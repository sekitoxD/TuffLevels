-- TuFFlevels / Routes/Horde/Solo/SwampofSorrows.lua
--
-- Swamp of Sorrows leg(s) of the solo Orc/Troll 1-60 route. Levels 36-43.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 33: Swamp of Sorrows West
Leg(18, "Swamp of Sorrows", {

    {
      type = "section", name = "Chapter 33: Swamp of Sorrows West", levels = { 36, 36 },
      zone = "Swamp of Sorrows",
    },
    {
      type = "complete", questName = "Dream Dust in the Swamp", zone = "Swamp of Sorrows",
      location = "Itharius's Cave", atLevel = 36, logCount = 13, x = 14.0, y = 61.0,
      approx = true,
    },
    {
      type = "accept", questName = "Draenethyst Crystals", zone = "Swamp of Sorrows",
      location = "The Harborage", atLevel = 36, logCount = 14, x = 26.0, y = 31.4,
    },
    {
      type = "accept", questName = "Noboru the Cudgel", zone = "Swamp of Sorrows",
      location = "Fallow Sanctuary", atLevel = 36, logCount = 15,
      note = "Starts from an item you loot here, not from an NPC. This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", questName = "Galen's Escape", zone = "Swamp of Sorrows",
      location = "Fallow Sanctuary", atLevel = 36, logCount = 16, x = 65.4, y = 18.2,
    },
    {
      type = "complete", questName = "Draenethyst Crystals", zone = "Swamp of Sorrows",
      location = "Fallow Sanctuary", atLevel = 36, logCount = 16, x = 60.0, y = 24.0,
      approx = true,
    },
    {
      type = "complete", questName = "Ongeku", zone = "Swamp of Sorrows",
      location = "Fallow Sanctuary", atLevel = 36, logCount = 16, x = 65.1, y = 22.0,
    },
    {
      type = "complete", questName = "Galen's Escape", zone = "Swamp of Sorrows",
      location = "Fallow Sanctuary", atLevel = 36, logCount = 16, x = 60.0, y = 24.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Galen's Escape", zone = "Swamp of Sorrows", atLevel = 36,
      logCount = 15, x = 47.8, y = 39.8,
    },
    {
      type = "accept", questName = "Neeka Bloodscar", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 36, logCount = 16, x = 47.7, y = 55.2,
    },
    {
      type = "travel", name = "Breyk <Wind Rider Master>", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 36, logCount = 16, x = 46.1, y = 54.8,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 36, logCount = 16,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "manual", name = "Banalash: Soothing Spices x3", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 36, logCount = 16, x = 44.8, y = 56.6,
      note = "Vendor stop.",
    },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Fresh Meat, Lack of Surplus #1 on a later pass.",
      zone = "Swamp of Sorrows", location = "Stonard", atLevel = 36, x = 44.7, y = 57.2,
    },
    {
      type = "turnin", questName = "Draenethyst Crystals", zone = "Swamp of Sorrows",
      location = "The Harborage", atLevel = 36, logCount = 15, x = 26.0, y = 31.4,
    },
    {
      type = "turnin", questName = "Noboru the Cudgel", zone = "Swamp of Sorrows",
      location = "The Harborage", atLevel = 36, logCount = 14, x = 26.0, y = 31.4,
    },
    {
      type = "hearth", name = "Hearth to Booty Bay", zone = "Swamp of Sorrows",
      location = "The Harborage", atLevel = 36, logCount = 14, x = 26.0, y = 31.4,
      note = "Use your hearthstone.",
    },
    {
      type = "note", optional = true, name = "Skip for now: Z",
      note = "Do not pick up yet - the route comes back for Zanzil's Secret on a later pass.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 36, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", questName = "Dream Dust in the Swamp", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 36, logCount = 13, x = 27.0, y = 77.2,
    },
    {
      type = "accept", questName = "Rumors for Kravel", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 36, logCount = 14, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", questName = "Hostile Takeover", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 36, logCount = 13, x = 27.0, y = 77.2,
    },
    {
      type = "note", name = "Note",
      note = "Rogues can class train at Ian Strom inside The Salty Sailor Tarven.",
      atLevel = 36,
    },
    {
      type = "turnin", name = "Goblin Sponsorship (part 4)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 36,
      logCount = 12, x = 27.2, y = 76.8,
    },
    {
      type = "accept", name = "Goblin Sponsorship (part 5)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 36,
      logCount = 13, x = 27.2, y = 76.8,
    },
    {
      type = "turnin", questName = "Some Assembly Required", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 36, logCount = 12, x = 28.2, y = 77.4,
    },
    {
      type = "note", optional = true, name = "Skip for now: E",
      note = "Do not pick up yet - the route comes back for Excelsior on a later pass.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 36, x = 28.2, y = 77.4,
    },
    {
      type = "travel", name = "Booty Bay to Ratchet", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 36, logCount = 12, x = 25.9, y = 73.1, note = "Boat.",
    },
})

-- Chapter 42: Swamp of Sorrows East
Leg(25, "Swamp of Sorrows", {

    {
      type = "section", name = "Chapter 42: Swamp of Sorrows East", levels = { 42, 43 },
      zone = "Swamp of Sorrows",
    },
    {
      type = "turnin", questName = "Report to Helgrum", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 42, logCount = 13, x = 48.0, y = 55.2,
    },
    {
      type = "accept", questName = "Pool of Tears", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 42, logCount = 14, x = 47.9, y = 54.8,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 42, logCount = 14,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "accept", questName = "Fresh Meat", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 42, logCount = 15, x = 44.7, y = 57.2,
    },
    {
      type = "accept", name = "Lack of Surplus (part 1)", questName = "Lack of Surplus",
      ambiguous = true, zone = "Swamp of Sorrows", location = "Stonard", atLevel = 42,
      logCount = 16, x = 44.7, y = 57.2,
    },
    {
      type = "turnin", name = "Cortello's Riddle (part 1)", questName = "Cortello's Riddle",
      ambiguous = true, zone = "Swamp of Sorrows", atLevel = 43, logCount = 15, x = 22.9,
      y = 48.2,
    },
    {
      type = "accept", name = "Cortello's Riddle (part 2)", questName = "Cortello's Riddle",
      ambiguous = true, zone = "Swamp of Sorrows", atLevel = 43, logCount = 16, x = 22.9,
      y = 48.2,
    },
    {
      type = "complete", name = "Lack of Surplus (part 1)", questName = "Lack of Surplus",
      ambiguous = true, zone = "Swamp of Sorrows", atLevel = 43, logCount = 16, x = 53.0,
      y = 42.0, approx = true,
    },
    {
      type = "complete", questName = "Pool of Tears", zone = "Swamp of Sorrows",
      location = "Pool of Tears", atLevel = 43, logCount = 16, x = 65.0, y = 55.0,
      approx = true,
    },
    {
      type = "turnin", name = "Lack of Surplus (part 1)", questName = "Lack of Surplus",
      ambiguous = true, zone = "Swamp of Sorrows", location = "Misty Reed Strand",
      atLevel = 43, logCount = 15, x = 81.3, y = 81.0,
    },
    {
      type = "accept", name = "Lack of Surplus (part 2)", questName = "Lack of Surplus",
      ambiguous = true, zone = "Swamp of Sorrows", location = "Misty Reed Strand",
      atLevel = 43, logCount = 16, x = 81.3, y = 81.0,
    },
    {
      type = "complete", name = "Lack of Surplus (part 2)", questName = "Lack of Surplus",
      ambiguous = true, zone = "Swamp of Sorrows", location = "Misty Reed Strand",
      atLevel = 43, logCount = 16, x = 85.0, y = 32.0, approx = true,
    },
    {
      type = "complete", questName = "Fresh Meat", zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 16, x = 93.0, y = 29.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "Lack of Surplus (part 2)", questName = "Lack of Surplus",
      ambiguous = true, zone = "Swamp of Sorrows", location = "Misty Reed Strand",
      atLevel = 43, logCount = 15, x = 81.3, y = 81.0,
    },
    {
      type = "accept", name = "Threat From the Sea (part 1)",
      questName = "Threat From the Sea", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 16, x = 81.3, y = 81.0,
    },
    {
      type = "turnin", name = "Threat From the Sea (part 1)",
      questName = "Threat From the Sea", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 15, x = 83.8, y = 80.4,
    },
    {
      type = "accept", name = "Threat From the Sea (part 2)",
      questName = "Threat From the Sea", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 16, x = 83.8, y = 80.4,
    },
    {
      type = "complete", name = "Threat From the Sea (part 2)",
      questName = "Threat From the Sea", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 16,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Fresh Meat", zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 16, x = 93.0, y = 29.0,
      approx = true,
    },
    {
      type = "turnin", name = "Threat From the Sea (part 2)",
      questName = "Threat From the Sea", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 15, x = 83.8, y = 80.4,
    },
    {
      type = "accept", name = "Threat From the Sea (part 3)",
      questName = "Threat From the Sea", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 16, x = 83.8, y = 80.4,
    },
    {
      type = "turnin", name = "Threat From the Sea (part 3)",
      questName = "Threat From the Sea", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 16, x = 81.3, y = 81.0,
    },
    {
      type = "accept", questName = "Continued Threat", zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 17, x = 83.8, y = 80.4,
    },
    {
      type = "complete", questName = "Continued Threat", zone = "Swamp of Sorrows",
      location = "Stagalbog Cave", atLevel = 43, logCount = 16,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "Continued Threat", zone = "Swamp of Sorrows",
      location = "Misty Reed Strand", atLevel = 43, logCount = 15, x = 83.8, y = 80.4,
    },
    {
      type = "turnin", questName = "Pool of Tears", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 43, logCount = 14, x = 47.9, y = 54.8,
    },
    {
      type = "accept", questName = "The Atal'ai Exile", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 43, logCount = 15, x = 47.9, y = 54.8,
    },
    {
      type = "turnin", questName = "Fresh Meat", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 43, logCount = 14, x = 44.7, y = 57.2,
    },
    {
      type = "hearth", name = "Hearth to Booty Bay", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 43, logCount = 14, x = 44.7, y = 57.2,
      note = "Use your hearthstone.",
    },
})

