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
