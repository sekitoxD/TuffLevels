-- spec/core_spec.lua
--
-- Exercises Core.lua's pure step-engine logic (IsStepDone, StepApplies,
-- Reconcile, SetIndex/pinning, AutoSelectRoute) against the REAL file,
-- with ns.Data and ns.Compat replaced by controllable fakes so nothing
-- here touches QuestieDB or live WoW state. Run with `busted spec/` from
-- the repo root.

package.path = package.path .. ";./?.lua"

local stubs = require("spec.helpers.wow_stubs")
local FakeData = require("spec.helpers.fake_data")
local FakeCompat = require("spec.helpers.fake_compat")

-- Fresh ns + a freshly loaded Core for every test, so state from one
-- test (route registered, index moved, pinned...) can never leak into
-- the next.
local function NewCore()
    stubs.Install()
    local ns = {}
    ns.Data = FakeData.new()
    ns.Compat = FakeCompat.new()
    stubs.LoadFile("Core.lua", ns)
    return ns, ns.Core, ns.Data
end

-- A small route: two ordinary quest steps, then a grind gate.
local function SampleRoute()
    return {
        name = "Sample",
        faction = "Horde",
        races = { "Orc" },
        steps = {
            { type = "accept", quest = 100 },
            { type = "turnin", quest = 100 },
            { type = "grind", targetLevel = 5 },
        },
    }
end

describe("IsStepDone", function()
    local _, Core, Data

    before_each(function()
        _, Core, Data = NewCore()
    end)

    it("accept is done once the quest is in the log", function()
        local step = { type = "accept", quest = 1 }
        assert.is_false(Core.IsStepDone(step))
        Data.inLog[1] = true
        assert.is_true(Core.IsStepDone(step))
    end)

    it("accept is also done if the quest was already turned in", function()
        local step = { type = "accept", quest = 1 }
        Data.complete[1] = true
        assert.is_true(Core.IsStepDone(step))
    end)

    it("turnin is done only once flagged complete", function()
        local step = { type = "turnin", quest = 1 }
        assert.is_false(Core.IsStepDone(step))
        Data.complete[1] = true
        assert.is_true(Core.IsStepDone(step))
    end)

    it("complete without objective needs objectives finished or the quest complete", function()
        local step = { type = "complete", quest = 1 }
        assert.is_false(Core.IsStepDone(step))
        Data.readyToTurnIn[1] = true
        assert.is_true(Core.IsStepDone(step))
    end)

    it("complete with objective gates on that one objective, not all objectives", function()
        local step = { type = "complete", quest = 1, objective = 2 }
        assert.is_false(Core.IsStepDone(step))
        Data.objectivesDone[1] = { [2] = true }
        assert.is_true(Core.IsStepDone(step))
    end)

    it("grind/level are done at or above targetLevel", function()
        local step = { type = "grind", targetLevel = 10 }
        Data.level = 9
        assert.is_false(Core.IsStepDone(step))
        Data.level = 10
        assert.is_true(Core.IsStepDone(step))
    end)

    it("xp is done once past the level, or at it with enough percent", function()
        local step = { type = "xp", xp = { level = 10, pct = 50 } }
        Data.level = 9
        assert.is_false(Core.IsStepDone(step))
        Data.level = 10
        assert.is_false(Core.IsStepDone(step)) -- no XP stubbed yet -> 0%
        Data.level = 11
        assert.is_true(Core.IsStepDone(step)) -- already past the target level
    end)

    it("section always reports done", function()
        assert.is_true(Core.IsStepDone({ type = "section", name = "X" }))
    end)

    it("manual/note/travel never auto-detect", function()
        assert.is_false(Core.IsStepDone({ type = "manual" }))
        assert.is_false(Core.IsStepDone({ type = "note" }))
        assert.is_false(Core.IsStepDone({ type = "travel", map = 1, x = 1, y = 1 }))
    end)

    it("flightpath asks Data:IsFlightPathKnown", function()
        local step = { type = "flightpath", mapID = 1, node = 5 }
        assert.is_false(Core.IsStepDone(step))
        Data.flightPathsKnown["1|5"] = true
        assert.is_true(Core.IsStepDone(step))
    end)

    it("requires gates on other steps in the same route also being done", function()
        Core.active = SampleRoute()
        local gated = { type = "turnin", quest = 999, requires = { 1 } }
        -- gated's OWN condition is satisfied, but step 1 of SampleRoute
        -- (accept quest 100) isn't - requires must still block it.
        Data.complete[999] = true
        assert.is_false(Core.IsStepDone(gated))
        Data.inLog[100] = true
        assert.is_true(Core.IsStepDone(gated))
    end)

    it("requires fails closed on a circular chain instead of hanging", function()
        -- Both steps' own condition is satisfied; each requires the
        -- other, so neither can resolve - must return false, not hang.
        local a = { type = "turnin", quest = 1, requires = { 2 } }
        local b = { type = "turnin", quest = 2, requires = { 1 } }
        Core.active = { name = "Cyclic", steps = { a, b } }
        Data.complete[1] = true
        Data.complete[2] = true
        assert.is_false(Core.IsStepDone(a))
        assert.is_false(Core.IsStepDone(b))
    end)
end)

describe("ResolveQuest (ambiguous steps)", function()
    -- P1.5: evaluating an `ambiguous` step against whatever ONE link of a
    -- multi-link chain quest happens to be in the live log must never
    -- permanently bind that answer to step.quest UNLESS it's genuinely the
    -- current step - otherwise a full-route walk (Progress, /tuff verify)
    -- would mis-stamp every other link's step with the same id.
    it("never permanently binds step.quest for a same-name step that isn't current", function()
        local ns, Core, Data = NewCore()
        local step1 = { type = "turnin", questName = "Linked Quest", ambiguous = true }
        local step2 = { type = "turnin", questName = "Linked Quest", ambiguous = true }
        Core.active = { name = "Chain", steps = { step1, step2 } }
        Core.index = 1
        ns.Compat.nameCache["Linked Quest"] = 555
        Data.complete[555] = true

        -- step2 is NOT Core:CurrentStep() - it must still evaluate
        -- correctly against the live-resolved id, but never persist it.
        assert.is_true(Core.IsStepDone(step2))
        assert.is_nil(step2.quest)

        -- step1 IS Core:CurrentStep() - evaluating it binds normally.
        assert.is_true(Core.IsStepDone(step1))
        assert.equals(555, step1.quest)
    end)
end)

describe("StepApplies", function()
    local _, Core, Data

    before_each(function()
        _, Core, Data = NewCore()
    end)

    it("filters by race", function()
        local step = { races = { "Troll" } }
        Data.race = "Orc"
        assert.is_false(Core.StepApplies(step))
        Data.race = "Troll"
        assert.is_true(Core.StepApplies(step))
    end)

    it("filters by class", function()
        -- wow_stubs' UnitClass stub returns ROGUE
        assert.is_true(Core.StepApplies({ class = "ROGUE" }))
        assert.is_false(Core.StepApplies({ class = "MAGE" }))
    end)

    it("hides a step below minLevel", function()
        local step = { minLevel = 10 }
        Data.level = 5
        assert.is_false(Core.StepApplies(step))
        Data.level = 10
        assert.is_true(Core.StepApplies(step))
    end)

    it("hides a step at or above skipIfLevel", function()
        local step = { skipIfLevel = 10 }
        Data.level = 9
        assert.is_true(Core.StepApplies(step))
        Data.level = 10
        assert.is_false(Core.StepApplies(step))
    end)
end)

describe("SetIndex", function()
    it("clamps to 1..#steps+1", function()
        local _, Core = NewCore()
        Core.active = SampleRoute()
        Core:SetIndex(0)
        assert.equals(1, Core.index)
        Core:SetIndex(999)
        assert.equals(4, Core.index) -- #steps (3) + 1
    end)

    it("pins only when asked", function()
        local _, Core = NewCore()
        Core.active = SampleRoute()
        Core:SetIndex(2)
        assert.is_false(Core.pinned)
        Core:SetIndex(2, { pin = true })
        assert.is_true(Core.pinned)
    end)

    -- P1.13: _pathIndex tracks progress through a step's own multi-point
    -- path and must reset on the step that BECOMES current so the arrow
    -- re-walks from the start after a backtrack, instead of skipping ahead
    -- to wherever it was left. _eventDone must NOT be cleared here - that
    -- would un-complete an already-finished trainer/death/hearth/travel
    -- step the moment the tracker moves back onto it (e.g. via /tuff back).
    it("clears _pathIndex but not _eventDone on the step it moves onto", function()
        local _, Core = NewCore()
        Core.active = SampleRoute()
        local step2 = Core.active.steps[2]
        step2._pathIndex = 3
        step2._eventDone = true

        Core:SetIndex(2)

        assert.is_nil(step2._pathIndex)
        assert.is_true(step2._eventDone)
    end)

    it("does not touch _pathIndex on steps it doesn't move onto", function()
        local _, Core = NewCore()
        Core.active = SampleRoute()
        local step1 = Core.active.steps[1]
        step1._pathIndex = 7

        Core:SetIndex(2) -- moves onto step 2, not step 1

        assert.equals(7, step1._pathIndex)
    end)

    it("does not clear _pathIndex when re-applying the SAME index", function()
        -- Re-selecting the current step (e.g. clicking its own row in
        -- Progress, or /tuff goto <current>) must not throw away in-
        -- progress path position on a step the player never left.
        local _, Core = NewCore()
        Core.active = SampleRoute()
        Core:SetIndex(2)
        local step2 = Core.active.steps[2]
        step2._pathIndex = 3

        Core:SetIndex(2) -- same index as before

        assert.equals(3, step2._pathIndex)
    end)
end)

describe("Reconcile", function()
    it("walks forward past done and inapplicable steps and stops at the first real gap", function()
        local _, Core, Data = NewCore()
        Core.active = SampleRoute()
        Core.index = 1
        Data.inLog[100] = true    -- step 1 (accept 100) done
        Core:Reconcile()
        assert.equals(2, Core.index) -- stopped at step 2 (turnin 100), not yet done
    end)

    it("does nothing while pinned", function()
        local _, Core, Data = NewCore()
        Core.active = SampleRoute()
        Core.index = 1
        Core.pinned = true
        Data.inLog[100] = true
        Core:Reconcile()
        assert.equals(1, Core.index)
    end)

    it("optional steps never block advance, done or not", function()
        local _, Core = NewCore()
        Core.active = {
            name = "OptionalTest",
            steps = {
                { type = "manual", optional = true },
                { type = "manual" },
            },
        }
        Core.index = 1
        Core:Reconcile()
        -- optional step 1 is skipped even though "manual" never auto-detects,
        -- but step 2 (not optional, not done) blocks the walk
        assert.equals(2, Core.index)
    end)

    -- P1.13's SetIndex fix has a matching branch in Reconcile's own
    -- "moved" path, since Reconcile assigns self.index directly rather
    -- than calling SetIndex.
    it("clears _pathIndex on the step it advances onto", function()
        local _, Core, Data = NewCore()
        Core.active = SampleRoute()
        Core.index = 1
        Data.inLog[100] = true -- step 1 (accept 100) done
        local step2 = Core.active.steps[2]
        step2._pathIndex = 4

        Core:Reconcile()

        assert.equals(2, Core.index)
        assert.is_nil(step2._pathIndex)
    end)

    -- Phase 3: the paranoia guard used to be a hardcoded 5000 vs. the
    -- documented ~3000-step routes; it's now #steps+1, which must still be
    -- enough to walk a route where every step but the last is done.
    it("terminates a full walk on a longer all-but-last-done route", function()
        local _, Core, Data = NewCore()
        local steps = {}
        for i = 1, 10 do
            steps[i] = { type = "accept", quest = i }
            if i < 10 then Data.inLog[i] = true end
        end
        Core.active = { name = "Long", steps = steps }
        Core.index = 1
        Core:Reconcile()
        assert.equals(10, Core.index)
    end)

    -- The guard needs exactly #steps+1 iterations to walk a route where
    -- EVERY step (including the last) is done, landing one past the end -
    -- a guard of just #steps would break one short and strand the tracker
    -- on the last step instead of advancing past it.
    it("walks all the way past the end of a fully-done route", function()
        local _, Core, Data = NewCore()
        local steps = {}
        for i = 1, 10 do
            steps[i] = { type = "accept", quest = i }
            Data.inLog[i] = true
        end
        Core.active = { name = "AllDone", steps = steps }
        Core.index = 1
        Core:Reconcile()
        assert.equals(11, Core.index) -- #steps (10) + 1
    end)
end)

describe("Core:CurrentSection (P2.7 cache)", function()
    it("finds the nearest section header at or before the current index", function()
        local _, Core = NewCore()
        Core.active = {
            name = "Sectioned",
            steps = {
                { type = "section", name = "Alpha" },
                { type = "accept", quest = 1 },
                { type = "section", name = "Beta" },
                { type = "accept", quest = 2 },
            },
        }
        Core.index = 2
        local section, index = Core:CurrentSection()
        assert.equals("Alpha", section.name)
        assert.equals(1, index)

        Core.index = 4
        section, index = Core:CurrentSection()
        assert.equals("Beta", section.name)
        assert.equals(3, index)
    end)

    it("returns nil for a route with no sections at all", function()
        local _, Core = NewCore()
        Core.active = { name = "Flat", steps = { { type = "accept", quest = 1 } } }
        Core.index = 1
        -- Captured into a local (not passed directly as the assertion's
        -- argument): CurrentSection's "no section" case returns two nils
        -- (step, index), and a function call used directly as an
        -- argument expands ALL of its return values - `local x = f()`
        -- truncates cleanly to one, which is what every real caller does.
        local section = Core:CurrentSection()
        assert.is_nil(section)
        -- Repeat call with nothing changed: a cached "no section" result
        -- must answer this too, not just the first (uncached) call.
        section = Core:CurrentSection()
        assert.is_nil(section)
    end)

    -- Proves the cache is actually SERVED on a repeat call (not just that
    -- the answer happens to be correct either way): mutate the route's
    -- steps in place after the first call, with self.active/self.index
    -- both left unchanged - a genuinely cached call can't see that
    -- mutation, so it must still return the FIRST answer. Route steps are
    -- treated as immutable once a route is active (see CurrentSection's
    -- comment); this only exists to prove the cache is actually hit, not
    -- to bless in-place mutation of a live route.
    it("serves the cached answer on a repeat call, not a fresh walk", function()
        local _, Core = NewCore()
        local steps = {
            { type = "section", name = "Alpha" },
            { type = "accept", quest = 1 },
        }
        Core.active = { name = "Sectioned", steps = steps }
        Core.index = 2

        local section = Core:CurrentSection()
        assert.equals("Alpha", section.name)

        -- Same active route, same index - but the section header steps
        -- has been mutated in place. A real recompute would now find
        -- nothing (no more "section" step); the cache should still return
        -- the original "Alpha" answer.
        steps[1].type = "accept"
        section = Core:CurrentSection()
        assert.equals("Alpha", section.name)
    end)

    it("serves a cached nil on a repeat call, not a fresh walk", function()
        local _, Core = NewCore()
        local steps = { { type = "accept", quest = 1 } }
        Core.active = { name = "Flat", steps = steps }
        Core.index = 1
        local section = Core:CurrentSection()
        assert.is_nil(section)

        -- Same active route, same index - a section header is added in
        -- place after the first call. A real recompute would now find it;
        -- the cache should still return the original nil answer.
        steps[1] = { type = "section", name = "Snuck In" }
        section = Core:CurrentSection()
        assert.is_nil(section)
    end)

    -- P2.7's audit correction: the cache must key on (Core.active,
    -- Core.index) together, not index alone - a route switch can
    -- coincidentally leave Core.index at the same number the OLD route
    -- had, which must not serve a stale section from a route that isn't
    -- even loaded anymore.
    it("does not serve a stale section across a route switch at the same index", function()
        local _, Core = NewCore()
        local routeA = {
            name = "A",
            steps = {
                { type = "section", name = "A-Section" },
                { type = "accept", quest = 1 },
            },
        }
        local routeB = {
            name = "B",
            steps = {
                { type = "section", name = "B-Section" },
                { type = "accept", quest = 2 },
            },
        }

        Core.active = routeA
        Core.index = 2
        local section = Core:CurrentSection()
        assert.equals("A-Section", section.name)

        -- Switch routes WITHOUT changing self.index - the exact case a
        -- cache keyed on index alone would get wrong.
        Core.active = routeB
        section = Core:CurrentSection()
        assert.equals("B-Section", section.name)
    end)
end)

describe("AutoSelectRoute", function()
    it("is deterministic: prefers a non-demo route, then lower starting level, then name", function()
        local _, Core, Data = NewCore()
        Data.race, Data.faction = "Orc", "Horde"

        Core.routes = {
            ["Z Skeleton"] = { faction = "Horde", races = { "Orc" }, skeleton = true, levels = { 1, 60 } },
            ["B Real High"] = { faction = "Horde", races = { "Orc" }, levels = { 10, 20 } },
            ["A Real Low"] = { faction = "Horde", races = { "Orc" }, levels = { 1, 10 } },
        }

        assert.equals("A Real Low", Core:AutoSelectRoute())
    end)

    it("returns nil when nothing matches the character", function()
        local _, Core, Data = NewCore()
        Data.race, Data.faction = "Orc", "Horde"
        Core.routes = {
            ["Alliance only"] = { faction = "Alliance", races = { "Human" } },
        }
        assert.is_nil(Core:AutoSelectRoute())
    end)
end)
