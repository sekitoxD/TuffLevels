-- spec/data_spec.lua
--
-- Exercises the REAL Data:ValidateRoute against the REAL Data.lua and
-- Compat.lua (no fakes - Data.lua's structural checks don't need a live
-- QuestieDB; Data:QuestExists returns nil/"unknown" with no provider
-- registered, which ValidateRoute already treats as informational, not
-- a problem). Steps use numeric `map` IDs rather than `zone` names so
-- these tests don't depend on Compat's built-in zone-name table.

package.path = package.path .. ";./?.lua"

local stubs = require("spec.helpers.wow_stubs")

local function NewData()
    stubs.Install()
    local ns = {}
    stubs.LoadFile("Compat.lua", ns)
    stubs.LoadFile("Data.lua", ns)
    return ns.Data
end

describe("Data:ValidateRoute", function()
    it("reports no problems for a well-formed route", function()
        local Data = NewData()
        local route = {
            steps = {
                { type = "section", name = "Start" },
                { type = "accept", quest = 1, map = 1411, x = 50, y = 50 },
                { type = "turnin", quest = 1, map = 1411, x = 50, y = 50 },
                { type = "grind", targetLevel = 5 },
            },
        }
        local problems = Data:ValidateRoute(route)
        assert.equals(0, #problems)
    end)

    it("flags a quest step with neither a numeric quest nor a questName", function()
        local Data = NewData()
        local problems = Data:ValidateRoute({ steps = { { type = "accept" } } })
        assert.equals(1, #problems)
    end)

    it("treats a questName-only step as unresolved, not a problem", function()
        local Data = NewData()
        local route = { steps = { { type = "accept", questName = "Some Quest" } } }
        local problems, _, unresolved = Data:ValidateRoute(route)
        assert.equals(0, #problems)
        assert.equals(1, unresolved)
    end)

    it("flags coordinates out of 0-100 range", function()
        local Data = NewData()
        local route = { steps = { { type = "travel", map = 1411, x = 150, y = 50 } } }
        local problems = Data:ValidateRoute(route)
        assert.equals(1, #problems)
    end)

    it("flags coordinates with no map", function()
        local Data = NewData()
        local route = { steps = { { type = "travel", x = 50, y = 50 } } }
        local problems = Data:ValidateRoute(route)
        assert.equals(1, #problems)
    end)

    it("flags a grind/level step missing targetLevel", function()
        local Data = NewData()
        local route = { steps = { { type = "grind" }, { type = "level" } } }
        local problems = Data:ValidateRoute(route)
        assert.equals(2, #problems)
    end)

    it("flags a malformed xp step", function()
        local Data = NewData()
        local route = {
            steps = {
                { type = "xp" },
                { type = "xp", xp = { level = 10, pct = 150 } },
            },
        }
        local problems = Data:ValidateRoute(route)
        assert.equals(2, #problems)
    end)

    it("flags a flightpath step missing mapID and node/name", function()
        local Data = NewData()
        local problems = Data:ValidateRoute({ steps = { { type = "flightpath" } } })
        assert.equals(1, #problems)
    end)

    it("flags requires pointing outside the route", function()
        local Data = NewData()
        local route = { steps = { { type = "manual", requires = { 5 } } } }
        local problems = Data:ValidateRoute(route)
        assert.equals(1, #problems)
    end)

    it("flags requires referencing itself", function()
        local Data = NewData()
        local route = { steps = { { type = "manual", requires = { 1 } } } }
        local problems = Data:ValidateRoute(route)
        assert.equals(1, #problems)
    end)

    it("flags a path point missing x/y", function()
        local Data = NewData()
        local route = {
            steps = {
                { type = "travel", map = 1411, x = 1, y = 1, path = { { map = 1411 } } },
            },
        }
        local problems = Data:ValidateRoute(route)
        assert.equals(1, #problems)
    end)
end)

describe("Data:IsFlightPathKnown (P2.4)", function()
    -- Compat.has.taxiMap is computed at Compat.lua LOAD time (`C_TaxiMap ~=
    -- nil`), so C_TaxiMap/Enum must be set up BEFORE the Compat.lua load,
    -- not after - NewData() above loads Compat.lua itself, so this needs
    -- its own setup rather than reusing it.
    local savedCTaxiMap, savedEnum, savedGetTime

    before_each(function()
        savedCTaxiMap = _G.C_TaxiMap
        savedEnum = _G.Enum
        savedGetTime = _G.GetTime
        _G.Enum = _G.Enum or {}
        _G.Enum.FlightPathState = { Known = 1, Unknown = 0 }
    end)

    after_each(function()
        _G.C_TaxiMap = savedCTaxiMap
        _G.Enum = savedEnum
        _G.GetTime = savedGetTime
    end)

    local function NewDataWithTaxi(nodes)
        _G.C_TaxiMap = {
            GetAllTaxiNodes = function() return nodes end,
        }
        stubs.Install()
        local ns = {}
        stubs.LoadFile("Compat.lua", ns)
        stubs.LoadFile("Data.lua", ns)
        return ns.Data
    end

    it("reports a known flight point by node ID", function()
        local Data = NewDataWithTaxi({
            { nodeID = 5, name = "Some Flight Point", state = 1 },
        })
        assert.is_true(Data:IsFlightPathKnown({ mapID = 1411, node = 5 }))
    end)

    it("reports an unknown flight point as not known", function()
        local Data = NewDataWithTaxi({
            { nodeID = 5, name = "Some Flight Point", state = 0 },
        })
        assert.is_false(Data:IsFlightPathKnown({ mapID = 1411, node = 5 }))
    end)

    it("caches the node list for a short TTL instead of re-fetching every call", function()
        local fakeNow = 1000
        _G.GetTime = function() return fakeNow end
        local calls = 0
        _G.C_TaxiMap = {
            GetAllTaxiNodes = function()
                calls = calls + 1
                return { { nodeID = 5, name = "Some Flight Point", state = 1 } }
            end,
        }
        stubs.Install()
        local ns = {}
        stubs.LoadFile("Compat.lua", ns)
        stubs.LoadFile("Data.lua", ns)
        local Data = ns.Data

        Data:IsFlightPathKnown({ mapID = 1411, node = 5 })
        Data:IsFlightPathKnown({ mapID = 1411, node = 5 })
        assert.equals(1, calls)

        -- Past the short TTL: fetches again, so learning a flight point
        -- mid-session shows up without needing a route reload.
        fakeNow = fakeNow + 2
        Data:IsFlightPathKnown({ mapID = 1411, node = 5 })
        assert.equals(2, calls)
    end)
end)

describe("Data:SetWaypoint (P2.8, reduced)", function()
    local savedTomTom, savedCMap

    before_each(function()
        savedTomTom = _G.TomTom
        savedCMap = _G.C_Map
    end)

    after_each(function()
        _G.TomTom = savedTomTom
        _G.C_Map = savedCMap
    end)

    it("does not re-add a waypoint for the same target twice in a row", function()
        local Data = NewData()
        local addCalls, removeCalls = 0, 0
        _G.TomTom = {
            AddWaypoint = function()
                addCalls = addCalls + 1
                return "uid-" .. addCalls
            end,
            RemoveWaypoint = function() removeCalls = removeCalls + 1 end,
        }

        local step = { map = 1411, x = 50, y = 50 }
        assert.is_true(Data:SetWaypoint(step))
        assert.is_true(Data:SetWaypoint(step))
        assert.equals(1, addCalls)
        assert.equals(0, removeCalls)
    end)

    it("removes the previous TomTom waypoint before adding a new one for a different target", function()
        local Data = NewData()
        local addCalls, removedUIDs = 0, {}
        _G.TomTom = {
            AddWaypoint = function()
                addCalls = addCalls + 1
                return "uid-" .. addCalls
            end,
            RemoveWaypoint = function(_, uid) table.insert(removedUIDs, uid) end,
        }

        assert.is_true(Data:SetWaypoint({ map = 1411, x = 50, y = 50 }))
        assert.is_true(Data:SetWaypoint({ map = 1411, x = 60, y = 60 }))
        assert.equals(2, addCalls)
        assert.same({ "uid-1" }, removedUIDs)
    end)

    it("force=true re-sets the waypoint even for an unchanged target, removing the old pin first", function()
        local Data = NewData()
        local addCalls, removedUIDs = 0, {}
        _G.TomTom = {
            AddWaypoint = function()
                addCalls = addCalls + 1
                return "uid-" .. addCalls
            end,
            RemoveWaypoint = function(_, uid) table.insert(removedUIDs, uid) end,
        }

        local step = { map = 1411, x = 50, y = 50 }
        Data:SetWaypoint(step)
        Data:SetWaypoint(step, true)
        assert.equals(2, addCalls)
        -- No duplicate pin at the same spot - the first one was removed
        -- before the second was added.
        assert.same({ "uid-1" }, removedUIDs)
    end)

    it("does not dedupe two different maps that happen to share x/y coordinates", function()
        local Data = NewData()
        local addCalls = 0
        _G.TomTom = {
            AddWaypoint = function()
                addCalls = addCalls + 1
                return "uid-" .. addCalls
            end,
            RemoveWaypoint = function() end,
        }

        assert.is_true(Data:SetWaypoint({ map = 1411, x = 50, y = 50 }))
        assert.is_true(Data:SetWaypoint({ map = 1412, x = 50, y = 50 }))
        assert.equals(2, addCalls)
    end)

    -- Round-1 review finding: the TomTom branch removes the PREVIOUS pin
    -- before it knows whether the new AddWaypoint call will succeed. If
    -- that add then fails (and there's no native-pin fallback available
    -- either), the function must not still treat the OLD target as
    -- "already set" - nothing is actually on screen for it anymore, so a
    -- later call for that same target must try again, not silently no-op.
    it("does not leave a stale dedup entry when a waypoint change fails outright", function()
        local Data = NewData()
        local addCalls = 0
        _G.TomTom = {
            AddWaypoint = function()
                addCalls = addCalls + 1
                if addCalls == 1 then return "uid-1" end
                error("TomTom broke")
            end,
            RemoveWaypoint = function() end,
        }
        -- No native-pin fallback available on this "client".
        _G.C_Map = nil

        local stepA = { map = 1411, x = 50, y = 50 }
        local stepB = { map = 1411, x = 60, y = 60 }
        assert.is_true(Data:SetWaypoint(stepA))

        -- Moving to B removes A's pin, then fails to add B's (and there's
        -- no fallback) - SetWaypoint must report failure, not silently
        -- succeed with nothing on screen.
        assert.is_false(Data:SetWaypoint(stepB))

        -- Going back to A must actually try again - nothing is currently
        -- set, so a dedup hit here would be wrong.
        addCalls = 0
        assert.is_true(Data:SetWaypoint(stepA))
        assert.equals(1, addCalls)
    end)
end)
