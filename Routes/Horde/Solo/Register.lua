-- TuFFlevels / Routes/Horde/Solo/Register.lua
--
-- Loads LAST of the Solo/ files. Stitches every leg the zone files
-- contributed into one route and registers it.

local ADDON, ns = ...

local legs = ns.SoloLegs or {}

table.sort(legs, function(a, b) return a.order < b.order end)

local steps = {}
for _, leg in ipairs(legs) do
    for _, step in ipairs(leg.steps) do
        steps[#steps + 1] = step
    end
end

ns.RegisterRoute("ONSLAUGHT Solo Horde 1-60 (Orc/Troll)", {
    faction = "Horde",
    races   = { "Orc", "Troll" },
    levels  = { 1, 60 },
    author  = "Docc / ONSLAUGHT spreadsheet, converted for TuFFlevels",
    source  = "docs.google.com/spreadsheets/d/1ObO5Zf3SbFp9EPfiIoqFnmYtWLpFtvClMGRapiHxmLM",
    steps   = steps,
})
