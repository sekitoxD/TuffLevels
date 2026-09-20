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
