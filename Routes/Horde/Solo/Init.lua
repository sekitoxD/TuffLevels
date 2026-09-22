-- TuFFlevels / Routes/Horde/Solo/Init.lua
--
-- Accumulator for the solo Orc/Troll 1-60 route.
--
-- The route is one linear list of steps, but it crosses 28 zones and comes
-- back to several of them two or three times, so it lives one file per zone
-- instead of one 2800-step file nobody can edit. Each zone file contributes
-- its legs with ns.SoloLeg(order, zone, steps), where order is that leg's
-- position in the FULL route - not its position in the file, and not the
-- order the .toc happens to load things in.
--
-- Register.lua loads last, sorts by that order and concatenates. Leaving a
-- zone file out of the .toc just yields a route with a hole in it; it never
-- reorders what remains.

local ADDON, ns = ...

local legs = {}
ns.SoloLegs = legs

function ns.SoloLeg(order, zone, steps)
    legs[#legs + 1] = { order = order, zone = zone, steps = steps }
end

-- Wrap a leg's step list in this to drop any step marked `forever = true`
-- on every client except WoW Forever. For content that only exists there
-- (its new dungeons, e.g. Ruins of Lordaeron): the same Solo files load on
-- Classic Era too, where those quests and NPCs don't exist. Filtered once at
-- load time, so it costs nothing at runtime, and Core never sees the field.
-- Compat.lua loads before any route file, so Compat.isForever is set by now.
function ns.SoloForeverOnly(steps)
    if ns.Compat and ns.Compat.isForever then return steps end
    local out = {}
    for _, step in ipairs(steps) do
        if not step.forever then out[#out + 1] = step end
    end
    return out
end
