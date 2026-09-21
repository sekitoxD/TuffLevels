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
end)

describe("Compat:Wrap", function()
    it("passes through results on success", function()
        local Compat = NewCompat()
        local wrapped = Compat:Wrap("Test", function(a, b) return a + b end)
        assert.equals(7, wrapped(3, 4))
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
