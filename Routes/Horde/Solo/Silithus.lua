-- TuFFlevels / Routes/Horde/Solo/Silithus.lua
--
-- Silithus leg(s) of the solo Orc/Troll 1-60 route. Levels 56-56.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 62: Silithus
Leg(43, "Silithus", {

    { type = "section", name = "Chapter 62: Silithus", levels = { 56, 56 }, zone = "Silithus" },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 56,
      logCount = 17, note = "Several spots around here - check the whole area.",
    },
    {
      type = "travel", name = "Orgrimmar to Gadgetzan", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 56, logCount = 17, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },
    {
      type = "complete", name = "Are We There, Yeti? (part 3)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Tanaris",
      location = "Gadgetzan", atLevel = 56, logCount = 17, x = 51.1, y = 26.9,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", questName = "Meet at the Grave", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 56, logCount = 16, x = 53.9, y = 23.3,
    },
    {
      type = "accept", questName = "A Grave Situation", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 56, logCount = 17, x = 53.9, y = 23.3,
    },
    {
      type = "turnin", questName = "A Grave Situation", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 56, logCount = 16, x = 53.8, y = 29.1,
    },
    {
      type = "accept", questName = "Linken's Sword", zone = "Tanaris", location = "Gadgetzan",
      atLevel = 56, logCount = 17, x = 53.8, y = 29.1,
    },
    {
      type = "travel", name = "Gadgetzan to Marshal's Refuge", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 56, logCount = 17, x = 51.6, y = 25.4,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Linken's Sword", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 56, logCount = 16, x = 44.7, y = 8.1,
    },
    {
      type = "accept", questName = "A Gnome's Assistance", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 56, logCount = 17, x = 44.7, y = 8.1,
    },
    {
      type = "turnin", questName = "A Gnome's Assistance", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 56, logCount = 16, x = 41.9, y = 2.7,
    },
    {
      type = "accept", questName = "Linken's Memory", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 56, logCount = 17, x = 41.9, y = 2.7,
    },
    {
      type = "complete", name = "Are We There, Yeti? (part 3)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 56, logCount = 17, x = 43.7, y = 9.4,
    },
    {
      type = "complete", questName = "Melding of Influences", zone = "Un'goro Crater",
      location = "Lakkari Tar Pits", atLevel = 56, logCount = 17, x = 47.0, y = 26.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Wasteland", zone = "Silithus", location = "Valor's Rest",
      atLevel = 56, logCount = 16, x = 81.9, y = 18.9,
    },
    {
      type = "accept", questName = "The Spirits of Southwind", zone = "Silithus",
      location = "Valor's Rest", atLevel = 56, logCount = 17, x = 81.9, y = 18.9,
    },
    {
      type = "complete", questName = "The Spirits of Southwind", zone = "Silithus",
      location = "Southwind Village", atLevel = 56, logCount = 17, x = 63.0, y = 51.0,
      approx = true,
    },
    {
      type = "turnin", questName = "The Spirits of Southwind", zone = "Silithus",
      location = "Valor's Rest", atLevel = 56, logCount = 16, x = 81.9, y = 18.9,
    },
    {
      type = "accept", questName = "Hive in the Tower", zone = "Silithus",
      location = "Valor's Rest", atLevel = 56, logCount = 17, x = 81.9, y = 18.9,
    },
    {
      type = "complete", questName = "Hive in the Tower", zone = "Silithus",
      location = "Southwind Village", atLevel = 56, logCount = 17, x = 60.2, y = 52.6,
    },
    {
      type = "turnin", questName = "Hive in the Tower", zone = "Silithus",
      location = "Valor's Rest", atLevel = 56, logCount = 16, x = 81.9, y = 18.9,
    },
    {
      type = "accept", questName = "Umber, Archivist", zone = "Silithus",
      location = "Valor's Rest", atLevel = 56, logCount = 17, x = 81.9, y = 18.9,
    },
    {
      type = "travel", name = "Runk Windtamer <Wind Rider Master>", zone = "Silithus",
      location = "Cenarion Hold", atLevel = 56, logCount = 17, x = 48.7, y = 36.7,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Cenarion Hold to Thunder Bluff", zone = "Silithus",
      location = "Cenarion Hold", atLevel = 56, logCount = 17, x = 48.7, y = 36.7,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Glyphed Oaken Branch", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 56, logCount = 16, x = 75.6, y = 31.6,
    },
    {
      type = "turnin", name = "Guarding Secrets (part 2)", questName = "Guarding Secrets",
      ambiguous = true, zone = "Thunder Bluff", location = "The Elder Rise", atLevel = 56,
      logCount = 15, x = 75.6, y = 31.6,
    },
    {
      type = "travel", name = "Thunder Bluff to Splintertree Post", zone = "Thunder Bluff",
      atLevel = 56, logCount = 15, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
})

