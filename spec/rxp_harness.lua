-- spec/rxp_harness.lua
--
-- Standalone (non-busted) dev tool: loads the real RXPImport.lua headlessly
-- via the same wow_stubs.lua the spec suite uses, splits a raw RXPGuides
-- guide file on its RegisterGuide([[ ]]) blocks, parses one chapter through
-- the real RXPImport:Parse, and dumps the resulting route.steps as
-- inspectable Lua so a route file can be hand-built/merged from it.
--
-- Run with a real Lua 5.1 interpreter (matches WoW's Lua version), e.g.
-- on Windows with rjpcomputing.luaforwindows installed via winget:
--   "/c/Program Files (x86)/Lua/5.1/lua.exe" spec/rxp_harness.lua <guidefile> [chapterNumber]
--
-- <guidefile> is a path to a raw RXPGuides Classic-*.lua guide file (not
-- shipped in this repo - point it at your own RXPGuides install). With no
-- chapterNumber, lists every #name found instead of parsing one.
--
-- This never runs in-game and ships no RXPGuides content - see
-- RXPImport.lua's header for the licensing rationale this tool inherits.

package.path = package.path .. ";./?.lua"

local stubs = require("spec.helpers.wow_stubs")

local function ReadFile(path)
    local f = assert(io.open(path, "r"))
    local text = f:read("*a")
    f:close()
    return text
end

local function SplitChapters(source)
    local chapters = {}
    local pos = 1
    while true do
        local openStart, openEnd = source:find("RegisterGuide%s*%(%s*%[%[", pos)
        if not openStart then break end
        local closeStart, closeEnd = source:find("%]%]%s*%)", openEnd + 1)
        if not closeStart then break end
        local inner = source:sub(openEnd + 1, closeStart - 1)
        local name = inner:match("#name%s+([^\n]+)") or "(unnamed)"
        table.insert(chapters, { name = name:gsub("%s+$", ""), text = inner })
        pos = closeEnd + 1
    end
    return chapters
end

-- Matches the flat, single-line-per-step style Routes/Horde/Mulgore.lua
-- already uses, so harness output can be pasted straight into a route file
-- rather than needing reformatting by hand. Field order is fixed (not
-- pairs()'s unspecified order) purely for readability/diffability.
local FIELD_ORDER = {
    "type", "name", "note", "zone", "map", "x", "y", "npc", "quest", "questName",
    "objective", "spellID", "itemID", "count", "path", "class", "classes",
    "classExclude", "races", "minLevel", "skipIfLevel", "optional",
    "requires", "approx", "xp",
}

local function DumpScalar(v)
    if type(v) == "string" then return string.format("%q", v) end
    return tostring(v)
end

local function DumpPath(path)
    local parts = {}
    for _, wp in ipairs(path) do
        -- A waypoint can carry a numeric `map` (uiMapID) instead of a
        -- `zone` name, same as a step's own location field - see
        -- RXPImport.lua's ".goto" handler for why (a purely numeric
        -- source token is a real uiMapID, not a zone name to resolve).
        -- `%q` on a nil `wp.zone` would be a hard Lua error, not just
        -- wrong output.
        if wp.zone then
            table.insert(parts, ("{ zone = %q, x = %s, y = %s }"):format(wp.zone, tostring(wp.x), tostring(wp.y)))
        else
            table.insert(parts, ("{ map = %s, x = %s, y = %s }"):format(tostring(wp.map), tostring(wp.x), tostring(wp.y)))
        end
    end
    return "{ " .. table.concat(parts, ", ") .. " }"
end

local function DumpStep(step)
    local parts = {}
    local seen = {}
    for _, key in ipairs(FIELD_ORDER) do
        local v = step[key]
        if v ~= nil then
            seen[key] = true
            if key == "path" then
                table.insert(parts, "path = " .. DumpPath(v))
            elseif key == "races" or key == "classExclude" or key == "classes" then
                -- All three are lists of quoted strings (races/classExclude,
                -- added 2026-09-26 for "<< !Class" gates, and classes,
                -- added 2026-09-27 for a real "<< ClassA/ClassB" OR) -
                -- without
                -- this branch the fallback loop below would dump a bare
                -- table's identity (e.g. "table: 00E74940") instead of Lua
                -- syntax, which would be a hard syntax error if pasted
                -- straight into a route file the way this harness's output
                -- is meant to be used.
                local names = {}
                for _, r in ipairs(v) do table.insert(names, string.format("%q", r)) end
                table.insert(parts, key .. " = { " .. table.concat(names, ", ") .. " }")
            elseif key == "xp" then
                -- An `xp` step's xp field is itself a table ({ level, pct },
                -- set by RXPImport.lua's bare `.xp N` conversion) - without
                -- this branch the fallback loop below would dump the table's
                -- bare identity (e.g. "table: 00E74940") instead of Lua
                -- syntax, a hard syntax error if pasted into a route file.
                table.insert(parts, key .. " = { level = " .. DumpScalar(v.level) .. ", pct = " .. DumpScalar(v.pct) .. " }")
            else
                table.insert(parts, key .. " = " .. DumpScalar(v))
            end
        end
    end
    -- Anything the fixed order missed (unexpected/new field) still gets
    -- printed rather than silently dropped.
    for k, v in pairs(step) do
        if not seen[k] and type(k) == "string" then
            table.insert(parts, k .. " = " .. DumpScalar(v))
        end
    end
    return "{ " .. table.concat(parts, ", ") .. " },"
end

local function DumpValue(v)
    local parts = { "{\n" }
    for _, step in ipairs(v) do
        table.insert(parts, "    " .. DumpStep(step) .. "\n")
    end
    table.insert(parts, "}")
    return table.concat(parts)
end

local guidePath = arg[1]
local chapterNum = arg[2] and tonumber(arg[2])

if not guidePath then
    io.stderr:write("usage: lua spec/rxp_harness.lua <guidefile> [chapterNumber]\n")
    os.exit(1)
end

stubs.Install()
local ns = {}
stubs.LoadFile("RXPImport.lua", ns)
local RXPImport = ns.RXPImport

local source = ReadFile(guidePath)
local chapters = SplitChapters(source)

if not chapterNum then
    print(("%d chapters found in %s:"):format(#chapters, guidePath))
    for i, ch in ipairs(chapters) do
        print(("  %d: %s"):format(i, ch.name))
    end
    os.exit(0)
end

local chapter = chapters[chapterNum]
if not chapter then
    io.stderr:write(("chapter %d not found (file has %d)\n"):format(chapterNum, #chapters))
    os.exit(1)
end

print(("-- Chapter %d: %s\n"):format(chapterNum, chapter.name))
local route, name, warnings = RXPImport:Parse(chapter.text)

print("-- Parsed name: " .. tostring(name))
if warnings and #warnings > 0 then
    print("-- Warnings:")
    for _, w in ipairs(warnings) do
        print("--   " .. w)
    end
    print()
end

print("local steps = " .. DumpValue(route.steps))
