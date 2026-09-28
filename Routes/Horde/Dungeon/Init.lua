-- TuFFlevels / Routes/Horde/Dungeon/Init.lua
--
-- Accumulator for the 5-man Orc/Troll 1-60 dungeon-grind route.
--
-- The route is one linear list of steps split into 10 numbered part files
-- (01-VALLEYOFTRIALS.lua .. 10-BRDPRISONPREPFARM.lua) because a single file
-- that size is unreviewable. Each part file contributes its steps with
-- ns.DungeonPart(n, steps), where n is that part's position in the FULL
-- route - not the order the .toc happens to load things in.
--
-- Register.lua loads last, sorts by n and concatenates. Leaving a part file
-- out of the .toc just yields a route with a hole in it; it never reorders
-- what remains.

local ADDON, ns = ...

local parts = {}
ns.DungeonParts = parts

function ns.DungeonPart(n, steps)
    parts[#parts + 1] = { order = n, steps = steps }
end
