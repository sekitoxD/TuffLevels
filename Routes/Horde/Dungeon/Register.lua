-- TuFFlevels / Routes/Horde/Dungeon/Register.lua
--
-- Loads LAST of the Dungeon/ files. Stitches every part the numbered files
-- contributed into one route and registers it.

local ADDON, ns = ...

local parts = ns.DungeonParts or {}

table.sort(parts, function(a, b) return a.order < b.order end)

local steps = {}
for _, part in ipairs(parts) do
    for _, step in ipairs(part.steps) do
        steps[#steps + 1] = step
    end
end

ns.RegisterRoute("ONSLAUGHT 5-Man Horde 1-60 (Orc/Troll)", {
    faction = "Horde",
    races   = { "Orc", "Troll" },
    levels  = { 1, 60 },
    group   = true,
    author  = "Docc / ONSLAUGHT spreadsheet, converted for TuFFlevels",
    source  = "docs.google.com/spreadsheets/d/1ObO5Zf3SbFp9EPfiIoqFnmYtWLpFtvClMGRapiHxmLM",
    steps   = steps,
})
