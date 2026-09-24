-- spec/compat_spec.lua
--
-- Exercises the REAL Compat.lua directly (no fakes needed - it has no
-- ns.* dependencies of its own, only raw WoW globals, which wow_stubs
-- covers). errorCount/moduleCounts/moduleTripped are all file-scope
-- locals inside Compat.lua, so a fresh `loadfile` per test gives each
-- test a clean budget with no reset bookkeeping needed here.

package.path = package.path .. ";./?.lua"

local stubs = require("spec.helpers.wow_stubs")

local function NewCompat()
    stubs.Install()
    local ns = {}
    stubs.LoadFile("Compat.lua", ns)
    return ns.Compat
end

describe("Compat:Guard", function()
    it("returns the wrapped function's results on success", function()
        local Compat = NewCompat()
        local result = Compat:Guard(function(a, b) return a + b end, 2, 3)
        assert.equals(5, result)
    end)

    it("returns nil and counts an error on failure, without throwing", function()
        local Compat = NewCompat()
        local result = Compat:Guard(function() error("boom") end)
        assert.is_nil(result)
        assert.equals(1, Compat:ErrorCount())
    end)

    it("stops calling the wrapped function once the shared budget is spent", function()
        local Compat = NewCompat()
        local calls = 0
        local function boom()
            calls = calls + 1
            error("boom")
        end
        for _ = 1, 25 do Compat:Guard(boom) end
        -- Budget is 20: only the first 20 attempts should have actually
        -- run the function - the rest short-circuit before even trying.
        assert.equals(20, calls)
        assert.equals(20, Compat:ErrorCount())
    end)

    -- P2.1: Guard was rewritten to forward pcall's results through a
    -- vararg tail call instead of packing them into a `{pcall(...)}`
    -- table, to cut the GC churn that pattern caused on a hot path. This
    -- must keep preserving every return value, not just the first few -
    -- Compat:GetItemSellPrice depends on a call far past the 3rd still
    -- coming through (it reads result[11]).
    it("preserves every return value, not just the first few", function()
        local Compat = NewCompat()
        local a, b, c, d, e = Compat:Guard(function()
            return 1, 2, 3, 4, 5
        end)
        assert.equals(1, a)
        assert.equals(2, b)
        assert.equals(3, c)
        assert.equals(4, d)
        assert.equals(5, e)
    end)

    it("preserves a return value far past the 3rd (GetItemSellPrice's shape)", function()
        local Compat = NewCompat()
        local result = { Compat:Guard(function()
            local out = {}
            for i = 1, 11 do out[i] = i * 10 end
            return unpack(out, 1, 11)
        end) }
        assert.equals(110, result[11])
    end)
end)

describe("Compat:Wrap", function()
    it("passes through results on success", function()
        local Compat = NewCompat()
        local wrapped = Compat:Wrap("Test", function(a, b) return a + b end)
        assert.equals(7, wrapped(3, 4))
    end)

    -- P2.1: same tail-call rewrite as Guard, with its own finishWrap
    -- helper - must keep forwarding every return value.
    it("preserves every return value, not just the first few", function()
        local Compat = NewCompat()
        local wrapped = Compat:Wrap("Test", function() return 1, 2, 3, 4, 5 end)
        local a, b, c, d, e = wrapped()
        assert.equals(1, a)
        assert.equals(2, b)
        assert.equals(3, c)
        assert.equals(4, d)
        assert.equals(5, e)
    end)

    it("swallows an error instead of letting it propagate", function()
        local Compat = NewCompat()
        local wrapped = Compat:Wrap("Test", function() error("boom") end)
        local ok = pcall(wrapped)
        assert.is_true(ok)
    end)

    it("trips after its module budget and calls onTrip exactly once", function()
        local Compat = NewCompat()
        local tripped = 0
        local wrapped = Compat:Wrap("Flaky", function() error("boom") end,
            function() tripped = tripped + 1 end)
        for _ = 1, 10 do wrapped() end
        assert.equals(1, tripped)
        assert.is_true(Compat:ModuleErrorCounts()["Flaky"].tripped)
    end)

    it("keeps one module tripping from affecting another module", function()
        local Compat = NewCompat()
        local flaky = Compat:Wrap("Flaky", function() error("boom") end)
        local fine = Compat:Wrap("Fine", function() return "ok" end)
        for _ = 1, 10 do flaky() end
        assert.equals("ok", fine())
    end)
end)

describe("Compat:Wrap decay (P2.2)", function()
    -- A tripped module never calls its own fn again, so nothing but the
    -- wrapper itself (checked on every call, before the trip
    -- short-circuit) can ever give it its budget back - these tests drive
    -- a fully controllable fake GetTime() to prove that actually happens
    -- after a quiet period, not just that the counters exist. Same
    -- leaked-stub concern as the SetCVar/GetCVar tests further down this
    -- file: wow_stubs' `_G.GetTime = _G.GetTime or os.clock` default only
    -- applies once per process, so snapshot and restore it around every
    -- test here.
    local savedGetTime

    before_each(function()
        savedGetTime = _G.GetTime
    end)

    after_each(function()
        _G.GetTime = savedGetTime
    end)

    it("gives a tripped module its budget back after a quiet period, and actually untrips it", function()
        local fakeNow = 1000
        _G.GetTime = function() return fakeNow end
        local Compat = NewCompat()

        local calls = 0
        local wrapped = Compat:Wrap("Flaky", function()
            calls = calls + 1
            error("boom")
        end)

        for _ = 1, 5 do wrapped() end
        assert.equals(5, calls)
        assert.is_true(Compat:ModuleErrorCounts()["Flaky"].tripped)

        -- Not quiet long enough yet - still tripped, fn still not called.
        fakeNow = fakeNow + 100
        wrapped()
        assert.equals(5, calls)

        -- Past the decay window: untripped, so fn actually runs again -
        -- proving this isn't just a count reset nothing would ever read.
        fakeNow = fakeNow + 301
        wrapped()
        assert.equals(6, calls)
        assert.is_false(Compat:ModuleErrorCounts()["Flaky"].tripped)

        -- The decaying budget count must have actually reset, not just
        -- the trip flag - one more failure right after shouldn't
        -- immediately re-trip, the way it would if moduleCounts had
        -- stayed at 5 (or climbed past it) straight through the decay.
        wrapped()
        assert.equals(7, calls)
        assert.is_false(Compat:ModuleErrorCounts()["Flaky"].tripped)

        -- Lifetime count (what /tuff errors shows) never resets, and
        -- keeps growing across the decay - it's the session-wide history,
        -- separate from the decaying budget that gates tripping.
        assert.equals(7, Compat:ModuleErrorCounts()["Flaky"].count)
    end)

    it("still runs onTrip on every re-trip, but only marks firstTrip once", function()
        -- onTrip is often a protective state change (Arrow re-hiding its
        -- frame), not just a message - it must keep running on every
        -- re-trip after a decay, even though Compat's own trip message
        -- only prints once. firstTrip tells onTrip which situation it's
        -- in, for callbacks that also want to print their own message
        -- only the first time.
        local fakeNow = 1000
        _G.GetTime = function() return fakeNow end
        local Compat = NewCompat()

        local trips = {}
        local wrapped = Compat:Wrap("Flaky", function() error("boom") end, function(firstTrip)
            table.insert(trips, firstTrip)
        end)

        for _ = 1, 5 do wrapped() end
        assert.equals(1, #trips)
        assert.is_true(trips[1])

        -- Past the decay window, failing its way back to tripped calls
        -- onTrip again - but this time firstTrip is false.
        fakeNow = fakeNow + 301
        for _ = 1, 5 do wrapped() end
        assert.equals(2, #trips)
        assert.is_false(trips[2])
    end)

    it("decays the shared lifetime total the same way", function()
        local fakeNow = 1000
        _G.GetTime = function() return fakeNow end
        local Compat = NewCompat()

        -- 30 distinct modules, one failure each - each stays well under
        -- its own per-module budget of 5, but the 30th pushes the SHARED
        -- lifetime total to its own cap.
        for i = 1, 30 do
            Compat:Wrap("Mod" .. i, function() error("boom") end)()
        end
        assert.is_true(Compat:ModuleErrorCounts()["Mod30"].tripped)

        -- A brand new module, never having failed before, trips on its
        -- very FIRST failure purely off the shared total - proves the
        -- total is actually shared across modules, not per-module.
        local fresh = Compat:Wrap("Fresh", function() error("boom") end)
        fresh()
        assert.is_true(Compat:ModuleErrorCounts()["Fresh"].tripped)

        -- Past the decay window, the shared total resets. A DIFFERENT
        -- brand new module's first-ever failure no longer trips it off a
        -- stale lifetime count - this specifically isolates the shared
        -- total's own decay from each module's independent per-module
        -- decay (which alone wouldn't need the total to reset at all).
        fakeNow = fakeNow + 301
        local anotherFresh = Compat:Wrap("AnotherFresh", function() error("boom") end)
        anotherFresh()
        assert.is_false(Compat:ModuleErrorCounts()["AnotherFresh"].tripped)
    end)
end)

describe("Compat:RegisterUnitEvents", function()
    -- P1.1: UNIT_SPELLCAST_SUCCEEDED/UNIT_QUEST_LOG_CHANGED must be
    -- registered player-only via RegisterUnitEvent, but fall back to a
    -- plain RegisterEvent if RegisterUnitEvent is missing or throws on
    -- this client - only reported as rejected if BOTH attempts fail.
    it("uses RegisterUnitEvent when available", function()
        local Compat = NewCompat()
        local frame = stubs.MakeFrame()
        local seen
        function frame:RegisterUnitEvent(event, unit) seen = { event, unit } end

        local registered, missing = Compat:RegisterUnitEvents(frame, { "UNIT_SPELLCAST_SUCCEEDED" }, "player")

        assert.same({ "UNIT_SPELLCAST_SUCCEEDED" }, registered)
        assert.same({}, missing)
        assert.same({ "UNIT_SPELLCAST_SUCCEEDED", "player" }, seen)
    end)

    it("falls back to plain RegisterEvent when RegisterUnitEvent throws", function()
        local Compat = NewCompat()
        local frame = stubs.MakeFrame()
        function frame:RegisterUnitEvent() error("unknown method") end

        local registered, missing = Compat:RegisterUnitEvents(frame, { "UNIT_SPELLCAST_SUCCEEDED" }, "player")

        assert.same({ "UNIT_SPELLCAST_SUCCEEDED" }, registered)
        assert.same({}, missing)
        assert.is_true(frame.events["UNIT_SPELLCAST_SUCCEEDED"])
    end)

    it("falls back to plain RegisterEvent when RegisterUnitEvent is absent", function()
        local Compat = NewCompat()
        local frame = stubs.MakeFrame()
        frame.RegisterUnitEvent = nil

        local registered, missing = Compat:RegisterUnitEvents(frame, { "UNIT_QUEST_LOG_CHANGED" }, "player")

        assert.same({ "UNIT_QUEST_LOG_CHANGED" }, registered)
        assert.same({}, missing)
        assert.is_true(frame.events["UNIT_QUEST_LOG_CHANGED"])
    end)

    it("only reports an event missing when both attempts fail", function()
        local Compat = NewCompat()
        local frame = stubs.MakeFrame()
        function frame:RegisterUnitEvent() error("nope") end
        function frame:RegisterEvent() error("nope either") end

        local registered, missing = Compat:RegisterUnitEvents(frame, { "SOME_UNKNOWN_EVENT" }, "player")

        assert.same({}, registered)
        assert.same({ "SOME_UNKNOWN_EVENT" }, missing)
    end)
end)

describe("Compat:SetCVarSafe / GetCVarSafe", function()
    -- plans/01-bug-fixes.md V4: prefer C_CVar.* when present, fall back to
    -- the legacy globals otherwise; success/failure must not depend on the
    -- setter's return value, since both forms return nothing on success.
    --
    -- Several tests below overwrite _G.SetCVar/_G.GetCVar directly (some
    -- with throwing stubs, to prove C_CVar.* took priority over them) -
    -- wow_stubs.Install()'s `_G.SetCVar = _G.SetCVar or function() end`
    -- default only applies once per process, so a leaked stub here would
    -- silently poison every spec file that runs afterward. Snapshot and
    -- restore both globals, not just C_CVar, around every test.
    local savedSetCVar, savedGetCVar

    before_each(function()
        savedSetCVar, savedGetCVar = _G.SetCVar, _G.GetCVar
    end)

    after_each(function()
        _G.C_CVar = nil
        _G.SetCVar, _G.GetCVar = savedSetCVar, savedGetCVar
    end)

    it("falls back to the legacy globals when C_CVar is absent", function()
        local Compat = NewCompat()
        local stored
        _G.SetCVar = function(name, value) stored = { name, value } end
        _G.GetCVar = function(name) return stored and stored[1] == name and tostring(stored[2]) end

        assert.is_true(Compat:SetCVarSafe("nameplateShowFriends", 1))
        assert.equals("1", Compat:GetCVarSafe("nameplateShowFriends"))
    end)

    it("prefers C_CVar.* when present", function()
        local Compat = NewCompat()
        local stored
        _G.C_CVar = {
            SetCVar = function(name, value) stored = { name, value } end,
            GetCVar = function(name) return stored and stored[1] == name and tostring(stored[2]) end,
        }
        -- Legacy globals would report the opposite of what actually happened
        -- if they were used by mistake - proves C_CVar.* took priority.
        _G.SetCVar = function() error("legacy SetCVar should not be called") end
        _G.GetCVar = function() return "0" end

        assert.is_true(Compat:SetCVarSafe("nameplateShowFriends", 1))
        assert.equals("1", Compat:GetCVarSafe("nameplateShowFriends"))
    end)

    it("reports failure when the setter throws, regardless of its return shape", function()
        local Compat = NewCompat()
        _G.C_CVar = {
            SetCVar = function() error("boom") end,
            GetCVar = function() return nil end,
        }

        assert.is_false(Compat:SetCVarSafe("nameplateShowFriends", 1))
        assert.equals(1, Compat:ErrorCount())
    end)

    it("reports failure, not false success, once the error budget is exhausted", function()
        local Compat = NewCompat()
        for _ = 1, 25 do Compat:Guard(function() error("boom") end) end
        assert.is_true(Compat:ErrorBudgetExhausted())

        -- Guard() short-circuits once the budget is spent, never calling the
        -- setter and never moving ErrorCount() - a naive before/after diff
        -- would misread that silence as success.
        _G.C_CVar = { SetCVar = function() error("should never run") end }

        assert.is_false(Compat:SetCVarSafe("nameplateShowFriends", 1))
    end)
end)

describe("Compat:GetQuestIDByName / SaveNameCache (P2.3)", function()
    -- InitSavedVar reuses whatever's already sitting in the real global
    -- (that's the whole point - it survives a /reload on a client where
    -- SavedVariables actually persist), so unlike Compat's own file-scope
    -- locals, TuFFlevelsDB does NOT reset just because NewCompat() loads a
    -- fresh Compat.lua chunk. Snapshot and restore it, same shape as the
    -- C_QuestLog/C_Map stubs in this file.
    local savedCQuestLog, savedDB

    before_each(function()
        savedCQuestLog = _G.C_QuestLog
        savedDB = _G.TuFFlevelsDB
        _G.TuFFlevelsDB = nil
    end)

    after_each(function()
        _G.C_QuestLog = savedCQuestLog
        _G.TuFFlevelsDB = savedDB
    end)

    it("resolves a name from the live quest log and caches it", function()
        _G.C_QuestLog = {
            GetNumQuestLogEntries = function() return 1 end,
            GetInfo = function(i)
                if i == 1 then
                    return { title = "Rite of Passage", questID = 111, isHeader = false }
                end
            end,
        }
        local Compat = NewCompat()
        assert.equals(111, Compat:GetQuestIDByName("Rite of Passage"))

        -- Cached: still resolves even after the quest is turned in and
        -- leaves the log entirely (LogIndex invalidated and rebuilt
        -- without it) - proves nameCache itself is answering the second
        -- call, not just LogIndex's own separate memoization.
        Compat:InvalidateLogIndex()
        _G.C_QuestLog.GetNumQuestLogEntries = function() return 0 end
        _G.C_QuestLog.GetInfo = function() return nil end
        assert.equals(111, Compat:GetQuestIDByName("Rite of Passage"))
    end)

    it("does not resolve a name that isn't in the log", function()
        _G.C_QuestLog = {
            GetNumQuestLogEntries = function() return 0 end,
            GetInfo = function() return nil end,
        }
        local Compat = NewCompat()
        assert.is_nil(Compat:GetQuestIDByName("Nonexistent Quest"))
    end)

    -- P2.3's regression risk: a step further down a route, for a quest
    -- already held, must still auto-advance later even if that quest gets
    -- turned in (and leaves the log) before its OWN step is ever directly
    -- evaluated by name - that only works if resolving ANY name merges
    -- the whole log index into nameCache, not just the one key that was
    -- actually asked for.
    it("opportunistically caches every quest currently in the log, not just the one asked about", function()
        _G.C_QuestLog = {
            GetNumQuestLogEntries = function() return 2 end,
            GetInfo = function(i)
                if i == 1 then return { title = "Quest A", questID = 1, isHeader = false } end
                if i == 2 then return { title = "Quest B", questID = 2, isHeader = false } end
            end,
        }
        local Compat = NewCompat()
        -- Only "Quest A" is asked about here - "Quest B" is never queried.
        assert.equals(1, Compat:GetQuestIDByName("Quest A"))

        -- "Quest B" is turned in and leaves the log before its own step is
        -- ever evaluated by name.
        Compat:InvalidateLogIndex()
        _G.C_QuestLog.GetNumQuestLogEntries = function() return 0 end
        _G.C_QuestLog.GetInfo = function() return nil end

        -- Still resolves: the earlier lookup for "Quest A" merged the
        -- WHOLE log index (including "Quest B") into nameCache.
        assert.equals(2, Compat:GetQuestIDByName("Quest B"))
    end)

    -- Round-2 review finding: the in-memory merge alone isn't enough - on
    -- a client where SavedVariables persist (Classic Era/Retail), "Quest
    -- B" from the scenario above would resolve fine for the rest of THIS
    -- session, but be lost again after a relog, since LoadNameCache only
    -- restores whatever actually got persisted. The merge must write to
    -- TuFFlevelsDB.questNames too, not just nameCache.
    it("also persists opportunistically-merged names to SavedVariables, not just memory", function()
        _G.C_QuestLog = {
            GetNumQuestLogEntries = function() return 2 end,
            GetInfo = function(i)
                if i == 1 then return { title = "Quest A", questID = 1, isHeader = false } end
                if i == 2 then return { title = "Quest B", questID = 2, isHeader = false } end
            end,
        }
        local Compat = NewCompat()
        -- Only "Quest A" is asked about - "Quest B" is never queried.
        assert.equals(1, Compat:GetQuestIDByName("Quest A"))

        -- Both should already be in SavedVariables, not just nameCache -
        -- resolving "Quest A" merged the whole log index into both.
        local db = Compat:InitSavedVar("TuFFlevelsDB")
        assert.equals(1, db.questNames["quest a"])
        assert.equals(2, db.questNames["quest b"])
    end)

    it("SaveNameCache writes only the one name/id pair it's given", function()
        local Compat = NewCompat()
        Compat:SaveNameCache("rite of passage", 111)
        Compat:SaveNameCache("a different quest", 222)

        local db = Compat:InitSavedVar("TuFFlevelsDB")
        assert.equals(111, db.questNames["rite of passage"])
        assert.equals(222, db.questNames["a different quest"])

        -- "Only" means only - nothing else should have appeared.
        local count = 0
        for _ in pairs(db.questNames) do count = count + 1 end
        assert.equals(2, count)
    end)

    it("SaveNameCache does nothing when nothing actually resolved", function()
        local Compat = NewCompat()
        Compat:SaveNameCache("some quest", nil)
        -- Checked directly against the real global, not through
        -- InitSavedVar - calling InitSavedVar itself would create the
        -- table as a side effect, making this assertion meaningless.
        assert.is_nil(_G.TuFFlevelsDB)
    end)
end)

describe("Compat:MapID (P2.5)", function()
    local savedCMap

    before_each(function()
        savedCMap = _G.C_Map
    end)

    after_each(function()
        _G.C_Map = savedCMap
    end)

    it("resolves a zone once ZoneIndex has built", function()
        -- A zone/ID deliberately absent from CLASSIC_MAP_IDS, so this can
        -- only resolve via a genuinely-built ZoneIndex, not the static
        -- fallback table.
        _G.C_Map = {
            GetMapChildrenInfo = function(root)
                if root == 946 then
                    return { { name = "Fakezone Test Area", mapID = 9999 } }
                end
                return {}
            end,
        }
        local Compat = NewCompat()
        assert.equals(9999, Compat:MapID("Fakezone Test Area"))
        assert.equals(9999, Compat:MapID("Fakezone Test Area"))
    end)

    -- The audit correction's specific concern: an empty ZoneIndex doesn't
    -- mean the zone doesn't exist, only that the map system isn't up yet -
    -- CLASSIC_MAP_IDS can still supply a plausible-looking fallback value
    -- in the meantime, and caching THAT would permanently shadow the real
    -- answer once ZoneIndex actually builds and disagrees with it.
    it("never caches a value obtained before ZoneIndex actually built, even a valid fallback one", function()
        -- Durotar resolves via the static CLASSIC_MAP_IDS fallback (1411)
        -- while C_Map reports nothing yet (ZoneIndex still empty).
        _G.C_Map = { GetMapChildrenInfo = function() return {} end }
        local Compat = NewCompat()
        assert.equals(1411, Compat:MapID("Durotar"))

        -- The map system "comes up" with a DIFFERENT answer for the same
        -- zone (plausible on Mainline, where uiMapIDs don't necessarily
        -- match Classic's). If the fallback value above got cached, this
        -- would still (wrongly) return 1411 instead of the new value.
        _G.C_Map.GetMapChildrenInfo = function(root)
            if root == 946 then return { { name = "Durotar", mapID = 555 } } end
            return {}
        end
        assert.equals(555, Compat:MapID("Durotar"))
    end)

    it("never caches a miss, so a zone can resolve later once the map system catches up", function()
        -- A zone deliberately absent from the static CLASSIC_MAP_IDS
        -- fallback table, so the only way to resolve it is via ZoneIndex.
        _G.C_Map = { GetMapChildrenInfo = function() return {} end }
        local Compat = NewCompat()
        assert.is_nil(Compat:MapID("Fakezone Test Area"))

        -- The map system "comes up" between calls - a real login scenario,
        -- where C_Map isn't ready yet the first few times it's asked. Must
        -- not have poisoned this zone with the earlier miss.
        _G.C_Map.GetMapChildrenInfo = function(root)
            if root == 946 then return { { name = "Fakezone Test Area", mapID = 9999 } } end
            return {}
        end
        assert.equals(9999, Compat:MapID("Fakezone Test Area"))
    end)
end)
