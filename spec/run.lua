-- spec/run.lua
--
-- Minimal busted-compatible shim (describe/it/before_each/assert) plus a
-- runner that loads every spec/*_spec.lua file and reports pass/fail
-- counts. Promoted from a scratch tool used to build RXPImport.lua's test
-- coverage (see plans/12-rxpguides-reimport-and-directive-upgrade.md) so
-- the whole spec suite can be run headlessly without a real `busted`
-- install (LuaRocks/busted wouldn't configure on this machine). Dev-only;
-- never loaded in-game, zero runtime impact on the addon.
--
-- Run with the Lua 5.1 interpreter that matches WoW's own Lua version
-- (see spec/rxp_harness.lua's header for the Windows winget package):
--   "/c/Program Files (x86)/Lua/5.1/lua.exe" spec/run.lua

package.path = package.path .. ";./?.lua"

local passed, failed = 0, 0
local failures = {}
local describeStack = {}
local beforeEachStack = {}
local afterEachStack = {}

local function fullName(name)
    local parts = {}
    for _, d in ipairs(describeStack) do table.insert(parts, d) end
    table.insert(parts, name)
    return table.concat(parts, " > ")
end

-- A `describe` body, or a before_each/after_each hook, can throw (a typo in
-- shared test setup, not just inside an `it`). Without a pcall here that
-- aborts the whole run and leaves describeStack/beforeEachStack/
-- afterEachStack unpopped, so later spec files misattribute their test
-- names to whatever describe blocks never got popped. Record it as a
-- failure and keep going instead.
function describe(name, fn)
    table.insert(describeStack, name)
    table.insert(beforeEachStack, {})
    table.insert(afterEachStack, {})
    local ok, err = pcall(fn)
    table.remove(afterEachStack)
    table.remove(beforeEachStack)
    table.remove(describeStack)
    if not ok then
        failed = failed + 1
        table.insert(failures, { name = fullName(name), err = err })
    end
end

function before_each(fn)
    table.insert(beforeEachStack[#beforeEachStack], fn)
end

function after_each(fn)
    table.insert(afterEachStack[#afterEachStack], fn)
end

function it(name, fn)
    local ok, err = true, nil
    for _, hooks in ipairs(beforeEachStack) do
        for _, hook in ipairs(hooks) do
            if ok then ok, err = pcall(hook) end
        end
    end
    if ok then ok, err = pcall(fn) end
    if ok then
        passed = passed + 1
    else
        failed = failed + 1
        table.insert(failures, { name = fullName(name), err = err })
    end
    for _, hooks in ipairs(afterEachStack) do
        for _, hook in ipairs(hooks) do pcall(hook) end
    end
end

local function deepEquals(a, b)
    if a == b then return true end
    if type(a) ~= "table" or type(b) ~= "table" then return false end
    for k, v in pairs(a) do
        if not deepEquals(v, b[k]) then return false end
    end
    for k in pairs(b) do
        if a[k] == nil then return false end
    end
    return true
end

local function fail(msg)
    error(msg, 3)
end

assert = setmetatable({
    equals = function(expected, actual, msg)
        if expected ~= actual then
            fail(("expected %s, got %s%s"):format(
                tostring(expected), tostring(actual), msg and (" (" .. msg .. ")") or ""))
        end
    end,
    same = function(expected, actual, msg)
        if not deepEquals(expected, actual) then
            fail(("tables not equal%s"):format(msg and (" (" .. msg .. ")") or ""))
        end
    end,
    is_true = function(v, msg)
        if v ~= true then fail(("expected true, got %s%s"):format(tostring(v), msg and (" (" .. msg .. ")") or "")) end
    end,
    is_false = function(v, msg)
        if v ~= false then fail(("expected false, got %s%s"):format(tostring(v), msg and (" (" .. msg .. ")") or "")) end
    end,
    is_nil = function(v, msg)
        if v ~= nil then fail(("expected nil, got %s%s"):format(tostring(v), msg and (" (" .. msg .. ")") or "")) end
    end,
}, { __call = function(_, v, msg, ...)
    if not v then fail(msg or "assertion failed") end
    return v, msg, ...
end })

-- io.popen's shell varies by how this interpreter was invoked (plain
-- cmd vs. Git Bash), so a `dir`/`ls` listing isn't reliable here - list
-- explicitly instead. Add new *_spec.lua files to this list.
local specFiles = {
    "spec/compat_spec.lua",
    "spec/core_spec.lua",
    "spec/data_spec.lua",
    "spec/rxpimport_spec.lua",
}
for _, path in ipairs(specFiles) do
    print("-- " .. path)
    local chunk = assert(loadfile(path))
    chunk()
end

print(("\n%d passed, %d failed"):format(passed, failed))
if failed > 0 then
    for _, f in ipairs(failures) do
        print(("  FAIL %s: %s"):format(f.name, tostring(f.err)))
    end
    os.exit(1)
end
