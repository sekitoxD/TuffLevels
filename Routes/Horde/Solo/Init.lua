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
