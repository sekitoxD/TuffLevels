-- TuFFlevels / Routes/Horde/Solo/Ashenvale.lua
--
-- Ashenvale leg(s) of the solo Orc/Troll 1-60 route. Levels 24-26.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 19: Zoram Strand | Chapter 20: Ashenvale
Leg(9, "Ashenvale", {

    { type = "section", name = "Chapter 19: Zoram Strand", levels = { 24, 25 }, zone = "Ashenvale" },
    {
      type = "manual", name = "Shredder Operating Manual Pages", zone = "Ashenvale",
      atLevel = 24, logCount = 12,
      note = "Start collecting this now - it drops over the whole leg, not in one spot. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "travel", name = "Andruk <Wind Rider Master>", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 12, x = 12.2, y = 33.8,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "accept", questName = "Vorsha the Lasher", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 13, x = 12.0, y = 34.4,
    },
    {
      type = "accept", questName = "Between a Rock and a Thistlefur", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 14, x = 11.8, y = 34.6,
    },
    {
      type = "accept", questName = "Naga at the Zoram Strand", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 15, x = 11.6, y = 34.8,
    },
    {
      type = "accept", questName = "Troll Charm", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 16, x = 11.6, y = 34.8,
    },
    {
      type = "turnin", questName = "Trouble in the Deeps", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 15, x = 11.6, y = 34.2,
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips Amongst the Ruins, The Essence of Aku'Mai. Low XP for the travel time.",
      zone = "Ashenvale", location = "Zoram Strand", atLevel = 24, x = 11.6, y = 34.2,
    },
    {
      type = "complete", questName = "Vorsha the Lasher", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 15, x = 9.6, y = 27.6,
    },
    {
      type = "complete", questName = "Naga at the Zoram Strand", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 15, x = 12.0, y = 30.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Naga at the Zoram Strand", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 24, logCount = 14, x = 11.6, y = 34.8,
    },
    {
      type = "turnin", questName = "Vorsha the Lasher", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 25, logCount = 13, x = 12.2, y = 34.2,
    },
    {
      type = "complete", questName = "Troll Charm", zone = "Ashenvale",
      location = "Thistlefur Village", atLevel = 25, logCount = 13, x = 41.0, y = 33.0,
      approx = true,
    },
    {
      type = "accept", questName = "Freedom to Ruul", zone = "Ashenvale",
      location = "Thistlefur Village", atLevel = 25, logCount = 14, x = 41.5, y = 34.5,
    },
    {
      type = "complete", questName = "Between a Rock and a Thistlefur", zone = "Ashenvale",
      location = "Thistlefur Village", atLevel = 25, logCount = 14, x = 37.0, y = 34.0,
      approx = true,
    },
    {
      type = "complete", questName = "Freedom to Ruul", zone = "Ashenvale",
      location = "Thistlefur Village", atLevel = 25, logCount = 14, x = 38.0, y = 35.0,
      approx = true,
    },
    {
      type = "note", name = "Note",
      note = "If you did the Zoram Strand jump from Stonetalon Peak, hearth and finish Chapter 18's Windshear Crag.",
      atLevel = 25,
    },

    { type = "section", name = "Chapter 20: Ashenvale", levels = { 25, 26 }, zone = "Ashenvale" },
    {
      type = "accept", questName = "Ashenvale Outrunners", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 25, logCount = 15, x = 71.2, y = 68.0,
    },
    {
      type = "note", optional = true, name = "Skip: W",
      note = "The route deliberately skips Warsong Supplies. Low XP for the travel time.",
      zone = "Ashenvale", location = "Splintertree Outpost", atLevel = 25, x = 71.4, y = 67.6,
    },
    {
      type = "turnin", name = "The Ashenvale Hunt (part 1)", questName = "The Ashenvale Hunt",
      ambiguous = true, zone = "Ashenvale", location = "Splintertree Outpost", atLevel = 25,
      logCount = 14, x = 73.6, y = 61.4,
    },
    {
      type = "accept", name = "The Ashenvale Hunt (part 2)", questName = "The Ashenvale Hunt",
      ambiguous = true, zone = "Ashenvale", location = "Splintertree Outpost", atLevel = 25,
      logCount = 15, x = 73.6, y = 61.4,
    },
    {
      type = "turnin", name = "The Ashenvale Hunt (part 2)", questName = "The Ashenvale Hunt",
      ambiguous = true, zone = "Ashenvale", location = "Splintertree Outpost", atLevel = 25,
      logCount = 14, x = 73.6, y = 61.4,
    },
    {
      type = "turnin", questName = "Freedom to Ruul", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 25, logCount = 13, x = 74.0, y = 60.8,
    },
    {
      type = "accept", questName = "Stonetalon Standstill", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 25, logCount = 14, x = 73.6, y = 60.0,
    },
    {
      type = "accept", questName = "Satyr Horns", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 25, logCount = 15, x = 73.0, y = 61.4,
    },
    {
      type = "travel", name = "Vhulgra <Wind Rider Master>", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 25, logCount = 15, x = 73.2, y = 61.6,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "complete", questName = "Satyr Horns", zone = "Ashenvale", location = "Night Run",
      atLevel = 25, logCount = 15, x = 67.0, y = 56.0, approx = true,
    },
    {
      type = "complete", name = "The Sacred Flame (part 1)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Ashenvale", location = "Raynewood Retreat", atLevel = 25,
      logCount = 15, x = 61.0, y = 52.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Ordanus", zone = "Ashenvale",
      location = "Raynewood Retreat", atLevel = 25, logCount = 15, x = 62.0, y = 51.4,
    },
    {
      type = "accept", questName = "Shadumbra's Head", zone = "Ashenvale",
      location = "Raynewood Retreat", atLevel = 25, logCount = 16, x = 57.0, y = 56.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "accept", questName = "Ursangous's Paw", zone = "Ashenvale",
      location = "Talondeep Path", atLevel = 25, logCount = 17, x = 41.5, y = 66.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", questName = "Stonetalon Standstill", zone = "Ashenvale",
      location = "Mystral Lake", atLevel = 25, logCount = 17, x = 48.9, y = 69.5,
    },
    {
      type = "accept", questName = "The Befouled Element", zone = "Ashenvale",
      location = "Mystral Lake", atLevel = 25, logCount = 18, x = 49.0, y = 70.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", name = "The Sacred Flame (part 1)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Ashenvale", location = "Moonwell", atLevel = 25, logCount = 18,
      x = 60.2, y = 72.9,
    },
    {
      type = "accept", questName = "Torek's Assault", zone = "Ashenvale",
      location = "Silverwing Outpost", atLevel = 25, logCount = 19, x = 68.4, y = 75.2,
    },
    {
      type = "complete", questName = "Torek's Assault", zone = "Ashenvale",
      location = "Silverwing Outpost", atLevel = 25, logCount = 19, x = 64.8, y = 75.4,
    },
    {
      type = "complete", questName = "Ashenvale Outrunners", zone = "Ashenvale",
      location = "Dor'Danil Barrow Den", atLevel = 25, logCount = 19, x = 74.0, y = 71.0,
      approx = true,
    },
    {
      type = "accept", questName = "Sharptalon's Claw", zone = "Ashenvale",
      location = "Nightsong Woods", atLevel = 26, logCount = 20, x = 73.0, y = 70.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "manual", name = "Shredder Operating Manual Pages", zone = "Ashenvale",
      atLevel = 26, logCount = 20,
      note = "You should have the full stack by now. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "accept", questName = "The Lost Pages", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 21, x = 70.0, y = 71.0,
    },
    {
      type = "turnin", questName = "The Lost Pages", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 20, x = 70.0, y = 71.0,
    },
    {
      type = "note", name = "Note",
      note = "Abandon The Lost Pages if you could not collect all 12 Shredder Operating Manual Pages (1-12).",
      atLevel = 26,
    },
    {
      type = "turnin", questName = "Ashenvale Outrunners", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 19, x = 71.2, y = 68.0,
    },
    {
      type = "turnin", questName = "Torek's Assault", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 18, x = 73.0, y = 62.4,
    },
    {
      type = "turnin", questName = "Ursangous's Paw", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 17, x = 73.6, y = 61.4,
    },
    {
      type = "turnin", questName = "Sharptalon's Claw", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 16, x = 73.6, y = 61.4,
    },
    {
      type = "turnin", questName = "Shadumbra's Head", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 15, x = 73.6, y = 61.4,
    },
    {
      type = "accept", questName = "The Hunt Completed", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 16, x = 73.6, y = 61.4,
    },
    {
      type = "turnin", questName = "The Hunt Completed", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 15, x = 73.6, y = 61.4,
    },
    {
      type = "turnin", questName = "Stonetalon Standstill", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 14, x = 73.6, y = 60.0,
    },
    {
      type = "turnin", questName = "The Befouled Element", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 13, x = 73.6, y = 60.0,
    },
    {
      type = "accept", questName = "Je'neu of the Earthen Ring", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 14, x = 73.6, y = 60.0,
    },
    {
      type = "turnin", questName = "Satyr Horns", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 13, x = 73.0, y = 61.4,
    },
    {
      type = "travel", name = "Splintertree Post to Zoram Strand", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 26, logCount = 13, x = 73.2, y = 61.6,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Between a Rock and a Thistlefur", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 26, logCount = 12, x = 11.8, y = 34.6,
    },
    {
      type = "note", optional = true, name = "Skip: K",
      note = "The route deliberately skips King of the Foulweald. Low XP for the travel time.",
      zone = "Ashenvale", location = "Zoram Strand", atLevel = 26, x = 11.8, y = 34.6,
    },
    {
      type = "turnin", questName = "Troll Charm", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 26, logCount = 11, x = 11.6, y = 34.8,
    },
    {
      type = "turnin", questName = "Je'neu of the Earthen Ring", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 26, logCount = 10, x = 11.6, y = 34.2,
    },
    {
      type = "hearth", name = "Hearth to Sun Rock Retreat", zone = "Ashenvale",
      location = "Zoram Strand", atLevel = 26, logCount = 10, x = 11.6, y = 34.2,
      note = "Use your hearthstone.",
    },
})

