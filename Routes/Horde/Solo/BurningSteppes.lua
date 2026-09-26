-- TuFFlevels / Routes/Horde/Solo/BurningSteppes.lua
--
-- Burning Steppes leg(s) of the solo Orc/Troll 1-60 route. Levels 52-52.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 54: Burning Steppes
Leg(36, "Burning Steppes", {

    { type = "section", name = "Chapter 54: Burning Steppes", levels = { 52, 52 }, zone = "Burning Steppes" },
    {
      type = "note", optional = true, name = "Skip: 4 quests here",
      note = "The route deliberately skips Grark Lorkrub, KILL ON SIGHT: Dark Iron Dwarves, Dishamony of Flame, Lost Thunderbrew Recipe. Low XP for the travel time.",
      zone = "Badlands", location = "Kargath", atLevel = 52, x = 5.0, y = 47.6,
    },
    {
      type = "accept", questName = "Dreadmaul Rock", zone = "Badlands", location = "Kargath",
      atLevel = 52, logCount = 13,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", name = "The Rise of the Machines (part 1)",
      questName = "The Rise of the Machines", ambiguous = true, zone = "Badlands",
      location = "Kargath", atLevel = 52, logCount = 14, x = 3.0, y = 47.8,
    },
    {
      type = "travel", name = "Vahgruk <Wind Rider Master>", zone = "Burning Steppes",
      location = "Flame Crest", atLevel = 52, logCount = 14, x = 65.7, y = 24.2,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "accept", questName = "Broodling Essence", zone = "Burning Steppes",
      location = "Flame Crest", atLevel = 52, logCount = 15, x = 65.2, y = 24.0,
    },
    {
      type = "accept", questName = "Tablet of the Seven", zone = "Burning Steppes",
      location = "Flame Crest", atLevel = 52, logCount = 16, x = 65.2, y = 23.9,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Heart of the Mountain. Low XP for the travel time.",
      zone = "Burning Steppes", location = "Flame Crest", atLevel = 52, x = 65.2, y = 23.9,
    },
    {
      type = "turnin", questName = "Yuka Screwspigot", zone = "Burning Steppes",
      location = "Flame Crest", atLevel = 52, logCount = 15, x = 66.1, y = 22.0,
    },
    {
      type = "note", optional = true, name = "Skip: R",
      note = "The route deliberately skips Ribbly Screwspigot. Low XP for the travel time.",
      zone = "Burning Steppes", location = "Flame Crest", atLevel = 52, x = 66.1, y = 22.0,
    },
    {
      type = "complete", questName = "Tablet of the Seven", zone = "Burning Steppes",
      location = "Ruins of Thaurissan", atLevel = 52, logCount = 15, x = 54.1, y = 40.8,
    },
    {
      type = "complete", name = "The Rise of the Machines (part 1)",
      questName = "The Rise of the Machines", ambiguous = true, zone = "Burning Steppes",
      location = "Ruins of Thaurissan", atLevel = 52, logCount = 15, x = 64.0, y = 37.0,
      approx = true,
    },
    {
      type = "complete", questName = "Broodling Essence", zone = "Burning Steppes",
      atLevel = 52, logCount = 15, x = 81.0, y = 29.0, approx = true,
    },
    {
      type = "note", optional = true, name = "Skip: A",
      note = "The route deliberately skips A Taste of Flame #1. Low XP for the travel time.",
      zone = "Burning Steppes", location = "Slither Rock", atLevel = 52, x = 95.1, y = 31.6,
    },
    {
      type = "accept", name = "A Taste of Flame (part 1)", ambiguous = true,
      questName = "A Taste of Flame",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Burning Steppes", location = "Slither Rock", atLevel = 52, x = 95.1, y = 31.6,
    },
    {
      type = "turnin", name = "A Taste of Flame (part 1)", questName = "A Taste of Flame",
      ambiguous = true, zone = "Burning Steppes", location = "Slither Rock", atLevel = 52,
      logCount = 15, x = 95.1, y = 31.6,
    },
    {
      type = "note", optional = true, name = "Skip: A",
      note = "The route deliberately skips A Taste of Flame #2. Low XP for the travel time.",
      zone = "Burning Steppes", location = "Slither Rock", atLevel = 52, x = 95.1, y = 31.6,
    },
    {
      type = "complete", questName = "Dreadmaul Rock", zone = "Burning Steppes",
      location = "Dreadmaul Rock", atLevel = 52, logCount = 15, x = 79.8, y = 45.5,
    },
    {
      type = "turnin", questName = "Dreadmaul Rock", zone = "Burning Steppes",
      location = "Dreadmaul Rock", atLevel = 52, logCount = 14, x = 79.8, y = 45.5,
    },
    {
      type = "accept", questName = "Krom'Grul", zone = "Burning Steppes",
      location = "Dreadmaul Rock", atLevel = 52, logCount = 15, x = 79.8, y = 45.5,
    },
    {
      type = "complete", questName = "Krom'Grul", zone = "Burning Steppes",
      location = "Dreadmaul Rock", atLevel = 52, logCount = 15, x = 79.7, y = 47.5,
    },
    {
      type = "turnin", questName = "Broodling Essence", zone = "Burning Steppes",
      location = "Flame Crest", atLevel = 52, logCount = 14, x = 65.2, y = 24.0,
    },
    {
      type = "accept", questName = "Felnok Steelspring", zone = "Burning Steppes",
      location = "Flame Crest", atLevel = 52, logCount = 15, x = 65.2, y = 24.0,
    },
    {
      type = "turnin", questName = "Tablet of the Seven", zone = "Burning Steppes",
      location = "Flame Crest", atLevel = 52, logCount = 14, x = 65.2, y = 23.9,
    },
    {
      type = "travel", name = "Flame Crest to Kargath", zone = "Burning Steppes",
      location = "Flame Crest", atLevel = 52, logCount = 14, x = 65.7, y = 24.2,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Krom'Grul", zone = "Badlands", location = "Kargath",
      atLevel = 52, logCount = 13,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", name = "The Rise of the Machines (part 1)",
      questName = "The Rise of the Machines", ambiguous = true, zone = "Badlands",
      location = "Kargath", atLevel = 52, logCount = 12, x = 3.0, y = 47.8,
    },
    {
      type = "accept", name = "The Rise of the Machines (part 2)",
      questName = "The Rise of the Machines", ambiguous = true, zone = "Badlands",
      location = "Kargath", atLevel = 52, logCount = 13, x = 3.0, y = 47.8,
    },
    {
      type = "turnin", name = "The Rise of the Machines (part 2)",
      questName = "The Rise of the Machines", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 52, logCount = 12, x = 25.9, y = 44.9,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Rise of the Machines #3. Low XP for the travel time.",
      zone = "Badlands", location = "The Dustbowl", atLevel = 52, x = 25.9, y = 44.9,
    },
    {
      type = "hearth", name = "Hearth to The Crossroads", zone = "Badlands",
      location = "The Dustbowl", atLevel = 52, logCount = 12, x = 25.9, y = 44.9,
      note = "Use your hearthstone.",
    },
})

