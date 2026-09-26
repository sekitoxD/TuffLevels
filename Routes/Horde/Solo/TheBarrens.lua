-- TuFFlevels / Routes/Horde/Solo/TheBarrens.lua
--
-- The Barrens leg(s) of the solo Orc/Troll 1-60 route. Levels 12-31.
-- The route visits this zone 4 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 6: Barrens Start
Leg(2, "The Barrens", {

    { type = "section", name = "Chapter 6: Barrens Start", levels = { 12, 12 }, zone = "The Barrens" },
    {
      type = "accept", name = "Chen's Empty Keg (part 1)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Thorn Hill", atLevel = 12,
      logCount = 3, x = 55.8, y = 20.0,
    },
    {
      type = "complete", questName = "The Demon Seed", zone = "The Barrens",
      location = "Dreadmist peak", atLevel = 12, logCount = 3, x = 48.0, y = 19.1,
    },
    {
      type = "death", name = "Dreadmist Peak to The Crossroads", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 3, x = 48.0, y = 19.1,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "accept", questName = "The Forgotten Pools", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 4, x = 52.3, y = 31.9,
    },
    {
      type = "manual", name = "Kalyimah Stormcloud: Bags", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 4, x = 52.3, y = 32.0,
      note = "Vendor stop.",
    },
    {
      type = "turnin", questName = "Crossroads Conscription", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 3, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "Plainstrider Menace", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 4, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "Disrupt the Attacks", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 5, x = 51.5, y = 30.9,
    },
    {
      type = "accept", questName = "Supplies for the Crossroads", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 6, x = 51.5, y = 30.9,
    },
    {
      type = "accept", questName = "Harpy Raiders", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 7, x = 51.6, y = 30.9,
    },
    {
      type = "accept", questName = "Meats to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 8, x = 52.6, y = 29.8,
    },
    {
      type = "note", name = "Note",
      note = "You may set a Crossroads hearth instead of Orgrimmar if you don't need to train 16/18/20.",
      atLevel = 12,
    },
    {
      type = "accept", questName = "Raptor Thieves", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 9, x = 51.9, y = 30.3,
    },
    {
      type = "travel", name = "Devrak <Wind Rider Master>", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 9, x = 51.5, y = 30.3,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "turnin", questName = "Meats to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 8, x = 51.5, y = 30.3,
    },
    {
      type = "accept", questName = "Ride to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 9, x = 51.5, y = 30.3,
    },
    {
      type = "accept", questName = "Fungal Spores", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 10, x = 51.4, y = 30.2,
    },
    {
      type = "accept", questName = "Wharfmaster Dizzywig", zone = "The Barrens",
      location = "The Crossroads", atLevel = 12, logCount = 11, x = 51.4, y = 30.2,
    },
    {
      type = "complete", questName = "Plainstrider Menace", zone = "The Barrens",
      location = "Thorn Hill", atLevel = 12, logCount = 11, x = 54.0, y = 28.0, approx = true,
    },
    {
      type = "complete", questName = "Disrupt the Attacks", zone = "The Barrens",
      location = "Thorn Hill", atLevel = 12, logCount = 11, x = 55.5, y = 27.0, approx = true,
    },
    {
      type = "hearth", name = "Hearth or Fly to Orgrimmar", zone = "The Barrens",
      location = "Thorn Hill", atLevel = 12, logCount = 11, x = 55.5, y = 27.0, approx = true,
      note = "Use your hearthstone.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 12,
      logCount = 11, note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "Class Trainer might be less travel time at Brill or Undercity depending on class.",
      atLevel = 12,
    },
})

-- Chapter 10: Eastern Barrens | Chapter 11: Northern Barrens Lap #1 | Chapter 12: Northern Barrens Lap #2 | Chapter 13: Mid Barrens Lap | Chapter 14: Into Stonetalon Mountains
Leg(4, "The Barrens", {

    { type = "section", name = "Chapter 10: Eastern Barrens", levels = { 15, 15 }, zone = "The Barrens" },
    {
      type = "turnin", questName = "Return to the Crossroads", zone = "The Barrens",
      location = "The Crossroads", atLevel = 15, logCount = 12, x = 52.6, y = 29.8,
    },
    {
      type = "turnin", questName = "Plainstrider Menace", zone = "The Barrens",
      location = "The Crossroads", atLevel = 15, logCount = 11, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "The Zhevra", zone = "The Barrens",
      location = "The Crossroads", atLevel = 15, logCount = 12, x = 52.2, y = 31.0,
    },
    {
      type = "turnin", questName = "Sample for Helbrim", zone = "The Barrens",
      location = "The Crossroads", atLevel = 15, logCount = 11, x = 51.4, y = 30.2,
    },
    {
      type = "turnin", questName = "Disrupt the Attacks", zone = "The Barrens",
      location = "The Crossroads", atLevel = 15, logCount = 10, x = 51.5, y = 30.9,
    },
    {
      type = "accept", questName = "The Disruption Ends", zone = "The Barrens",
      location = "The Crossroads", atLevel = 15, logCount = 11, x = 51.4, y = 30.8,
    },
    {
      type = "complete", questName = "The Zhevra", zone = "The Barrens",
      location = "East of The Crossroads", atLevel = 15, logCount = 11, x = 56.0, y = 35.0,
      approx = true,
    },
    {
      type = "complete", questName = "Raptor Thieves", zone = "The Barrens",
      location = "East of The Crossroads", atLevel = 15, logCount = 11, x = 56.0, y = 35.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", questName = "Raptor Horns", zone = "The Barrens", location = "Ratchet",
      atLevel = 15, logCount = 12, x = 62.4, y = 37.6,
    },
    {
      type = "accept", questName = "Deepmoss Spider Eggs", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 13, x = 62.4, y = 37.6,
    },
    {
      type = "accept", questName = "WANTED: Baron Longshore", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 14, x = 62.6, y = 37.5,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips Trouble at the Docks. Low XP for the travel time.",
      zone = "The Barrens", location = "Ratchet", atLevel = 15, x = 63.0, y = 37.6,
    },
    {
      type = "accept", name = "Samophlange (part 1)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 15,
      logCount = 15, x = 63.0, y = 37.2,
    },
    {
      type = "travel", name = "Bragok <Flight Master>", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 15, x = 63.1, y = 37.2,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "accept", questName = "Southsea Freebooters", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 16, x = 62.6, y = 36.2,
    },
    {
      type = "turnin", name = "Chen's Empty Keg (part 1)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 15,
      logCount = 15, x = 62.2, y = 38.4,
    },
    {
      type = "accept", name = "Chen's Empty Keg (part 2)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 15,
      logCount = 16, x = 62.2, y = 38.4,
    },
    {
      type = "accept", questName = "The Guns of Northwatch", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 17, x = 62.2, y = 39.0,
    },
    {
      type = "complete", questName = "Southsea Freebooters", zone = "The Barrens",
      location = "The Merchant Coast", atLevel = 15, logCount = 17, x = 64.0, y = 46.0,
      approx = true,
    },
    {
      type = "complete", questName = "WANTED: Baron Longshore", zone = "The Barrens",
      location = "The Merchant Coast", atLevel = 15, logCount = 17,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "If Baron Longshore is not in the northern camps, you can do this during Chapter 13 with Stolen Booty.",
      atLevel = 15,
    },
    {
      type = "turnin", questName = "Southsea Freebooters", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 16, x = 62.6, y = 36.2,
    },
    {
      type = "turnin", questName = "WANTED: Baron Longshore", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 15, x = 62.6, y = 36.2,
    },
    {
      type = "accept", name = "The Missing Shipment (part 1)",
      questName = "The Missing Shipment", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 16, x = 62.6, y = 36.2,
    },
    {
      type = "accept", questName = "Ziz Fizziks", zone = "The Barrens", location = "Ratchet",
      atLevel = 15, logCount = 17, x = 63.0, y = 37.2,
    },
    {
      type = "turnin", name = "The Missing Shipment (part 1)",
      questName = "The Missing Shipment", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 16, x = 63.2, y = 38.4,
    },
    {
      type = "turnin", questName = "Wharfmaster Dizzywig", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 15, x = 63.2, y = 38.4,
    },
    {
      type = "accept", questName = "Miner's Fortune", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 16, x = 63.2, y = 38.4,
    },
    {
      type = "accept", name = "The Missing Shipment (part 2)",
      questName = "The Missing Shipment", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 17, x = 63.2, y = 38.4,
    },
    {
      type = "turnin", name = "The Missing Shipment (part 2)",
      questName = "The Missing Shipment", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 16, x = 62.6, y = 36.2,
    },
    {
      type = "accept", questName = "Stolen Booty", zone = "The Barrens", location = "Ratchet",
      atLevel = 15, logCount = 17, x = 62.6, y = 36.2,
    },
    {
      type = "travel", name = "Ratchet to The Crossroads", zone = "The Barrens",
      location = "Ratchet", atLevel = 15, logCount = 17, x = 63.1, y = 37.2,
      note = "Take the flight path.",
    },
    {
      type = "note", name = "Note",
      note = "Run to The Crossroads if you have not completed The Zhevra", atLevel = 15,
    },

    { type = "section", name = "Chapter 11: Northern Barrens Lap #1", levels = { 15, 16 }, zone = "The Barrens" },
    {
      type = "turnin", questName = "The Zhevra", zone = "The Barrens",
      location = "The Crossroads", atLevel = 15, logCount = 16, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "Prowlers of the Barrens", zone = "The Barrens",
      location = "The Crossroads", atLevel = 15, logCount = 17, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "Kolkar Leaders", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 15, logCount = 18, x = 45.4, y = 28.4,
    },
    {
      type = "accept", questName = "Centaur Bracers", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 15, logCount = 19, x = 45.4, y = 28.4,
    },
    {
      type = "complete", questName = "The Forgotten Pools", zone = "The Barrens",
      location = "Forgotten Pools", atLevel = 16, logCount = 19, x = 45.1, y = 22.5,
    },
    {
      type = "complete", questName = "Fungal Spores", zone = "The Barrens",
      location = "Forgotten Pools", atLevel = 16, logCount = 19, x = 45.0, y = 23.0,
      approx = true,
    },
    {
      type = "complete", questName = "Centaur Bracers", zone = "The Barrens",
      location = "Forgotten Pools", atLevel = 16, logCount = 19, x = 45.0, y = 23.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Kolkar Leaders", zone = "The Barrens",
      location = "Forgotten Pools", atLevel = 16, logCount = 19,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "complete", questName = "Prowlers of the Barrens", zone = "The Barrens",
      location = "Western Barrens", atLevel = 16, logCount = 19, x = 41.0, y = 23.0,
      approx = true,
    },
    {
      type = "complete", name = "Chen's Empty Keg (part 2)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Western Barrens", atLevel = 16,
      logCount = 19, x = 41.0, y = 23.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Raptor Thieves", zone = "The Barrens",
      location = "The Dry Hills", atLevel = 16, logCount = 19, x = 41.0, y = 23.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Harpy Raiders", zone = "The Barrens",
      location = "The Dry Hills", atLevel = 16, logCount = 19, x = 41.0, y = 19.0,
      approx = true,
    },
    {
      type = "complete", questName = "Raptor Horns", zone = "The Barrens",
      location = "North Barrens", atLevel = 16, logCount = 19, x = 44.0, y = 15.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "Samophlange (part 1)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", atLevel = 16,
      logCount = 18, x = 52.4, y = 11.6,
    },
    {
      type = "accept", name = "Samophlange (part 2)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", atLevel = 16,
      logCount = 19, x = 52.4, y = 11.6,
    },
    {
      type = "complete", name = "Samophlange (part 2)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", atLevel = 16,
      logCount = 19, note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", name = "Samophlange (part 2)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", atLevel = 16,
      logCount = 18, x = 52.4, y = 11.6,
    },
    {
      type = "accept", name = "Samophlange (part 3)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", atLevel = 16,
      logCount = 19, x = 52.4, y = 11.6,
    },
    {
      type = "complete", name = "Samophlange (part 3)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", atLevel = 16,
      logCount = 19, x = 52.8, y = 10.4,
    },
    {
      type = "turnin", name = "Samophlange (part 3)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", atLevel = 16,
      logCount = 18, x = 52.4, y = 11.6,
    },
    {
      type = "accept", name = "Samophlange (part 4)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", atLevel = 16,
      logCount = 19, x = 52.4, y = 11.6,
    },
    {
      type = "complete", questName = "Miner's Fortune", zone = "The Barrens",
      location = "Boulderlode Mine", atLevel = 16, logCount = 19, x = 61.0, y = 4.0,
      approx = true,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "The Barrens",
      location = "Boulderlode Mine", atLevel = 16, logCount = 19, x = 61.0, y = 4.0,
      approx = true, note = "Use your hearthstone.",
    },
    {
      type = "accept", questName = "The Spirits of Stonetalon", zone = "Orgrimmar",
      location = "The Valley of Wisdom", atLevel = 16, logCount = 20, x = 39.0, y = 38.0,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 16,
      logCount = 20, note = "Several spots around here - check the whole area.",
    },
    {
      type = "travel", name = "Orgrimmar to The Crossroads", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 16, logCount = 20, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },

    { type = "section", name = "Chapter 12: Northern Barrens Lap #2", levels = { 16, 18 }, zone = "The Barrens" },
    {
      type = "turnin", questName = "Fungal Spores", zone = "The Barrens",
      location = "The Crossroads", atLevel = 16, logCount = 19, x = 51.4, y = 30.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: A",
      note = "Do not pick up yet - the route comes back for Apothecary Zamah on a later pass.",
      zone = "The Barrens", location = "The Crossroads", atLevel = 16, x = 51.4, y = 30.2,
    },
    {
      type = "turnin", questName = "Harpy Raiders", zone = "The Barrens",
      location = "The Crossroads", atLevel = 16, logCount = 18, x = 51.6, y = 30.9,
    },
    {
      type = "accept", questName = "Harpy Lieutenants", zone = "The Barrens",
      location = "The Crossroads", atLevel = 16, logCount = 19, x = 51.6, y = 30.9,
    },
    {
      type = "turnin", questName = "Prowlers of the Barrens", zone = "The Barrens",
      location = "The Crossroads", atLevel = 16, logCount = 18, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "Echeyakee", zone = "The Barrens",
      location = "The Crossroads", atLevel = 16, logCount = 19, x = 52.2, y = 31.0,
    },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Consumed by Hatred, Lost in Battle on a later pass.",
      zone = "The Barrens", location = "The Crossroads", atLevel = 16, x = 52.0, y = 31.6,
    },
    {
      type = "turnin", questName = "The Forgotten Pools", zone = "The Barrens",
      location = "The Crossroads", atLevel = 16, logCount = 18, x = 52.3, y = 31.9,
    },
    {
      type = "accept", questName = "The Stagnant Oasis", zone = "The Barrens",
      location = "The Crossroads", atLevel = 16, logCount = 19, x = 52.3, y = 31.9,
    },
    {
      type = "complete", questName = "Centaur Bracers", zone = "The Barrens",
      location = "The Stagnant Oasis", atLevel = 16, logCount = 19, x = 55.0, y = 43.0,
      approx = true,
    },
    {
      type = "complete", questName = "The Stagnant Oasis", zone = "The Barrens",
      location = "The Stagnant Oasis", atLevel = 17, logCount = 19, x = 55.6, y = 42.7,
    },
    {
      type = "turnin", questName = "Miner's Fortune", zone = "The Barrens",
      location = "Ratchet", atLevel = 17, logCount = 18, x = 63.2, y = 38.4,
    },
    {
      type = "turnin", name = "Samophlange (part 4)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 17,
      logCount = 17, x = 63.0, y = 37.2,
    },
    {
      type = "accept", questName = "Wenikee Boltbucket", zone = "The Barrens",
      location = "Ratchet", atLevel = 17, logCount = 18, x = 63.0, y = 37.2,
    },
    {
      type = "complete", questName = "The Disruption Ends", zone = "The Barrens",
      location = "Thorn Hill", atLevel = 17, logCount = 18, x = 59.0, y = 27.0, approx = true,
    },
    {
      type = "complete", questName = "Supplies for the Crossroads", zone = "The Barrens",
      location = "Thorn Hill", atLevel = 17, logCount = 18, x = 59.0, y = 27.0, approx = true,
    },
    {
      type = "turnin", questName = "The Demon Seed", zone = "The Barrens",
      location = "Far Watch Post", atLevel = 17, logCount = 17, x = 62.4, y = 20.0,
    },
    {
      type = "complete", questName = "Echeyakee", zone = "The Barrens",
      location = "Northeastern Barrens", atLevel = 17, logCount = 17, x = 55.8, y = 17.0,
    },
    {
      type = "turnin", questName = "Wenikee Boltbucket", zone = "The Barrens",
      location = "North Barrens", atLevel = 17, logCount = 16, x = 49.0, y = 11.2,
    },
    {
      type = "accept", questName = "Nugget Slugs", zone = "The Barrens",
      location = "North Barrens", atLevel = 17, logCount = 17, x = 49.0, y = 11.2,
    },
    {
      type = "complete", questName = "Nugget Slugs", zone = "The Barrens",
      location = "Sludge Fen", atLevel = 17, logCount = 17, x = 56.0, y = 8.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", questName = "Ignition", zone = "The Barrens", location = "Sludge Fen",
      atLevel = 17, logCount = 18, x = 56.4, y = 7.4,
    },
    {
      type = "complete", questName = "Ignition", zone = "The Barrens", location = "Sludge Fen",
      atLevel = 17, logCount = 18,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "Ignition", zone = "The Barrens", location = "Sludge Fen",
      atLevel = 17, logCount = 17, x = 56.4, y = 7.4,
    },
    {
      type = "accept", questName = "The Escape", zone = "The Barrens", location = "Sludge Fen",
      atLevel = 17, logCount = 18, x = 56.4, y = 7.4,
    },
    {
      type = "complete", questName = "The Escape", zone = "The Barrens",
      location = "Sludge Fen", atLevel = 17, logCount = 18, x = 56.0, y = 7.5, approx = true,
    },
    {
      type = "complete", questName = "Nugget Slugs", zone = "The Barrens",
      location = "Sludge Fen", atLevel = 17, logCount = 18, x = 56.0, y = 9.0, approx = true,
    },
    {
      type = "turnin", questName = "Nugget Slugs", zone = "The Barrens",
      location = "North Barrens", atLevel = 17, logCount = 17, x = 49.0, y = 11.2,
    },
    {
      type = "note", optional = true, name = "Skip: R",
      note = "The route deliberately skips Rilli Greasygob. Low XP for the travel time.",
      zone = "The Barrens", location = "North Barrens", atLevel = 17, x = 49.0, y = 11.2,
    },
    {
      type = "complete", questName = "Raptor Horns", zone = "The Barrens",
      location = "North Barrens", atLevel = 17, logCount = 17, x = 45.0, y = 15.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Harpy Lieutenants", zone = "The Barrens",
      location = "The Dry Hills", atLevel = 18, logCount = 17, x = 39.0, y = 14.5,
      approx = true,
    },
    {
      type = "complete", questName = "Raptor Thieves", zone = "The Barrens", atLevel = 18,
      logCount = 17, x = 41.0, y = 23.0, approx = true,
    },
    {
      type = "turnin", questName = "Kolkar Leaders", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 18, logCount = 16, x = 45.4, y = 28.4,
    },
    {
      type = "turnin", questName = "Centaur Bracers", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 18, logCount = 15, x = 45.4, y = 28.4,
    },
    {
      type = "accept", questName = "Verog the Dervish", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 18, logCount = 16, x = 45.4, y = 28.4,
    },
    {
      type = "accept", questName = "Egg Hunt", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 17, x = 51.0, y = 29.6,
    },
    {
      type = "note", optional = true, name = "Skip: R",
      note = "The route deliberately skips Report to Kadrak. Low XP for the travel time.",
      zone = "The Barrens", location = "The Crossroads", atLevel = 18, x = 51.4, y = 30.8,
    },
    {
      type = "turnin", questName = "The Disruption Ends", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 16, x = 51.4, y = 30.8,
    },
    {
      type = "turnin", questName = "Supplies for the Crossroads", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 15, x = 51.5, y = 30.9,
    },
    {
      type = "turnin", questName = "Harpy Lieutenants", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 14, x = 51.6, y = 30.9,
    },
    {
      type = "accept", questName = "Serena Bloodfeather", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 15, x = 51.6, y = 30.9,
    },
    {
      type = "complete", questName = "Serena Bloodfeather", zone = "The Barrens",
      location = "The Dry Hills", atLevel = 18, logCount = 15,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "The Spirits of Stonetalon", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 18, logCount = 14, x = 35.2, y = 27.8,
    },
    {
      type = "accept", questName = "Goblin Invaders", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 18, logCount = 15, x = 35.2, y = 27.8,
    },
    {
      type = "accept", questName = "Avenge My Village", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 18, logCount = 16, x = 35.2, y = 27.8,
    },
    {
      type = "complete", questName = "Avenge My Village", zone = "Stonetalon Mts",
      location = "Camp Aparaje", atLevel = 18, logCount = 16, x = 82.0, y = 89.0,
      approx = true,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "Stonetalon Mts",
      location = "Camp Aparaje", atLevel = 18, logCount = 16, x = 82.0, y = 89.0,
      approx = true, note = "Use your hearthstone.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 18,
      logCount = 16, note = "Several spots around here - check the whole area.",
    },
    {
      type = "travel", name = "Orgrimmar to The Crossroads", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 18, logCount = 16, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },

    { type = "section", name = "Chapter 13: Mid Barrens Lap", levels = { 18, 20 }, zone = "The Barrens" },
    {
      type = "turnin", questName = "Raptor Thieves", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 15, x = 51.9, y = 30.3,
    },
    {
      type = "accept", questName = "Stolen Silver", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 16, x = 51.9, y = 30.3,
    },
    {
      type = "turnin", questName = "Serena Bloodfeather", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 15, x = 51.6, y = 30.9,
    },
    {
      type = "accept", questName = "Letter to Jin'Zil", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 16, x = 51.6, y = 30.9,
    },
    {
      type = "turnin", questName = "Echeyakee", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 15, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "The Angry Scytheclaws", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 16, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "Consumed by Hatred", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 17, x = 52.0, y = 31.6,
    },
    {
      type = "accept", questName = "Lost in Battle", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 18, x = 52.0, y = 31.6,
    },
    {
      type = "turnin", questName = "The Stagnant Oasis", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 17, x = 52.3, y = 31.9,
    },
    {
      type = "accept", questName = "Altered Beings", zone = "The Barrens",
      location = "The Crossroads", atLevel = 18, logCount = 18, x = 52.3, y = 31.9,
    },
    {
      type = "complete", questName = "Altered Beings", zone = "The Barrens",
      location = "The Stagnant Oasis", atLevel = 18, logCount = 18, x = 55.0, y = 43.0,
      approx = true,
    },
    {
      type = "note", name = "Note",
      note = "Kill Kolkars near the Command Tent until Verog the Dervish spawns.",
      atLevel = 18,
    },
    {
      type = "complete", questName = "Verog the Dervish", zone = "The Barrens",
      location = "The Stagnant Oasis", atLevel = 18, logCount = 18, x = 53.0, y = 41.6,
    },
    {
      type = "complete", questName = "The Angry Scytheclaws", zone = "The Barrens",
      location = "Raptor Nests", atLevel = 18, logCount = 18,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Raptor Horns", zone = "The Barrens",
      location = "Raptor Nests", atLevel = 18, logCount = 18, x = 52.0, y = 46.0,
      approx = true,
    },
    {
      type = "complete", questName = "Lost in Battle", zone = "The Barrens",
      location = "Gold Road", atLevel = 18, logCount = 18, x = 49.3, y = 50.3,
    },
    {
      type = "complete", name = "Chen's Empty Keg (part 2)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Gold Road", atLevel = 19,
      logCount = 18, x = 49.0, y = 51.0, approx = true,
    },
    {
      type = "accept", questName = "Lakota'mani", zone = "The Barrens", location = "Agama'gor",
      atLevel = 19, logCount = 19,
      note = "Starts from an item you loot here, not from an NPC. This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "note", name = "Note",
      note = "If Lakota'mani is not in the northern section of Agama'gor, just do it during Tribes at War/Consumed by Hatred.",
      atLevel = 19,
    },
    {
      type = "note", optional = true, name = "Skip for now: W",
      note = "Do not pick up yet - the route comes back for Weapons of Choice on a later pass.",
      zone = "The Barrens", location = "Camp Taurajo", atLevel = 19, x = 45.0, y = 57.6,
    },
    {
      type = "turnin", questName = "Lakota'mani", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 19, logCount = 18, x = 44.8, y = 59.0,
    },
    {
      type = "accept", questName = "Tribes at War", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 19, logCount = 19, x = 44.6, y = 59.2,
    },
    {
      type = "travel", name = "Omusa Thunderhorn <Wind Rider Master>", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 19, logCount = 19, x = 44.4, y = 59.2,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "manual", name = "Bristleback Quilboar: Blood Shard x11", zone = "The Barrens",
      location = "Agama'gor", atLevel = 19, logCount = 19, x = 52.0, y = 54.0, approx = true,
      note = "Collect these here.",
    },
    {
      type = "complete", questName = "Tribes at War", zone = "The Barrens",
      location = "Agama'gor", atLevel = 19, logCount = 19, x = 52.0, y = 54.0, approx = true,
    },
    {
      type = "complete", questName = "Consumed by Hatred", zone = "The Barrens",
      location = "Agama'gor", atLevel = 19, logCount = 19, x = 52.0, y = 54.0, approx = true,
    },
    {
      type = "complete", questName = "Stolen Silver", zone = "The Barrens",
      location = "Raptor Grounds", atLevel = 19, logCount = 19, x = 58.0, y = 53.9,
    },
    {
      type = "complete", questName = "The Guns of Northwatch", zone = "The Barrens",
      location = "Northwatch Hold", atLevel = 19, logCount = 19,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "Make sure you are at least 14500/21300 into level 19.", atLevel = 19,
    },
    {
      type = "note", optional = true, name = "Skip: F",
      note = "The route deliberately skips Free From the Hold. Low XP for the travel time.",
      zone = "The Barrens", location = "Northwatch Hold", atLevel = 19, x = 62.0, y = 55.0,
    },
    {
      type = "complete", questName = "Stolen Booty", zone = "The Barrens",
      location = "The Merchant Coast", atLevel = 19, logCount = 19,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "The Guns of Northwatch", zone = "The Barrens",
      location = "Ratchet", atLevel = 19, logCount = 18, x = 62.2, y = 39.0,
    },
    {
      type = "turnin", name = "Chen's Empty Keg (part 2)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 19,
      logCount = 17, x = 62.2, y = 38.4,
    },
    {
      type = "accept", name = "Chen's Empty Keg (part 3)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 19,
      logCount = 18, x = 62.2, y = 38.4,
    },
    {
      type = "turnin", questName = "Raptor Horns", zone = "The Barrens", location = "Ratchet",
      atLevel = 19, logCount = 17, x = 62.4, y = 37.6,
    },
    {
      type = "note", optional = true, name = "Skip: S",
      note = "The route deliberately skips Smart Drinks. Low XP for the travel time.",
      zone = "The Barrens", location = "Ratchet", atLevel = 19, x = 62.4, y = 37.6,
    },
    {
      type = "turnin", questName = "The Escape", zone = "The Barrens", location = "Ratchet",
      atLevel = 19, logCount = 16, x = 63.0, y = 37.2,
    },
    {
      type = "turnin", questName = "Stolen Booty", zone = "The Barrens", location = "Ratchet",
      atLevel = 20, logCount = 15, x = 62.6, y = 36.2,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "The Barrens",
      location = "Ratchet", atLevel = 20, logCount = 15, x = 62.6, y = 36.2,
      note = "Use your hearthstone.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 20,
      logCount = 15, note = "Several spots around here - check the whole area.",
    },
    {
      type = "travel", name = "Orgrimmar to The Crossroads", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 20, logCount = 15, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },

    {
      type = "section", name = "Chapter 14: Into Stonetalon Mountains", levels = { 20, 20 },
      zone = "The Barrens",
    },
    {
      type = "hearth", name = "Set Hearth to The Crossroads", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 15, x = 52.0, y = 29.9,
      note = "Bind your hearthstone here.",
    },
    {
      type = "turnin", questName = "Stolen Silver", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 14, x = 51.9, y = 30.3,
    },
    {
      type = "turnin", questName = "The Angry Scytheclaws", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 13, x = 52.2, y = 31.0,
    },
    {
      type = "accept", questName = "Jorn Skyseer", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 14, x = 52.2, y = 31.0,
    },
    {
      type = "turnin", questName = "Consumed by Hatred", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 13, x = 52.0, y = 31.6,
    },
    {
      type = "turnin", questName = "Lost in Battle", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 12, x = 52.0, y = 31.6,
    },
    {
      type = "turnin", questName = "Altered Beings", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 11, x = 52.3, y = 31.9,
    },
    {
      type = "accept", questName = "Hamuul Runetotem", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 12, x = 52.3, y = 31.9,
    },
    {
      type = "accept", questName = "Mura Runetotem", zone = "The Barrens",
      location = "The Crossroads", atLevel = 20, logCount = 13, x = 52.3, y = 31.9,
    },
    {
      type = "turnin", questName = "Verog the Dervish", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 20, logCount = 12, x = 45.4, y = 28.4,
    },
    {
      type = "accept", questName = "Hezrul Bloodmark", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 20, logCount = 13, x = 45.4, y = 28.4,
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips Deviate Eradication, Deviate Hides. Low XP for the travel time.",
      zone = "The Barrens", location = "Above Wailing Caverns", atLevel = 20, x = 51.9,
      y = 55.4,
    },
    {
      type = "complete", questName = "Hezrul Bloodmark", zone = "The Barrens",
      location = "Lushwater Oasis", atLevel = 20, logCount = 13,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "Hezrul Bloodmark", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 20, logCount = 12, x = 45.4, y = 28.4,
    },
    {
      type = "accept", questName = "Counterattack!", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 20, logCount = 13, x = 45.4, y = 28.4,
    },
    {
      type = "complete", questName = "Counterattack!", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 20, logCount = 13, x = 44.8, y = 28.2,
    },
    {
      type = "turnin", questName = "Counterattack!", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 20, logCount = 12, x = 45.4, y = 28.4,
    },
    {
      type = "turnin", questName = "Avenge My Village", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 20, logCount = 11, x = 35.2, y = 27.8,
    },
    {
      type = "accept", questName = "Kill Grundig Darkcloud", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 20, logCount = 12, x = 35.2, y = 27.8,
    },
    {
      type = "turnin", questName = "Letter to Jin'Zil", zone = "Stonetalon Mts",
      location = "Malaka'Jin", atLevel = 20, logCount = 11, x = 74.4, y = 97.8,
    },
    {
      type = "accept", questName = "Jin'Zil's Forest Magic", zone = "Stonetalon Mts",
      location = "Malaka'Jin", atLevel = 20, logCount = 12, x = 74.4, y = 97.8,
    },
    {
      type = "note", optional = true, name = "Skip: R",
      note = "The route deliberately skips Report to Kadrak. Low XP for the travel time.",
      zone = "Stonetalon Mts", location = "Malaka'Jin", atLevel = 20, x = 73.2, y = 94.8,
    },
    {
      type = "accept", questName = "Blood Feeders", zone = "Stonetalon Mts",
      location = "Malaka'Jin", atLevel = 20, logCount = 13, x = 71.2, y = 94.8,
    },
    {
      type = "accept", questName = "Arachnophobia", zone = "Stonetalon Mts",
      location = "Webwinder Path", atLevel = 20, logCount = 14, x = 59.1, y = 75.8,
    },
    {
      type = "complete", questName = "Blood Feeders", zone = "Stonetalon Mts",
      location = "Webwinder Path", atLevel = 20, logCount = 14, x = 60.0, y = 76.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Arachnophobia", zone = "Stonetalon Mts",
      location = "Sishir Canyon", atLevel = 20, logCount = 14,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Trouble in the Deeps, Elemental War on a later pass.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat", atLevel = 20, x = 47.2, y = 64.2,
    },
    {
      type = "accept", questName = "Boulderslide Ravine", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 20, logCount = 15, x = 47.0, y = 64.0,
    },
    {
      type = "turnin", questName = "Arachnophobia", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 20, logCount = 14, x = 47.2, y = 61.0,
    },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Harpies Threaten, Cycle of Rebirth on a later pass.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat", atLevel = 20, x = 47.2, y = 61.0,
    },
    {
      type = "travel", name = "Tharm <Wind Rider Master>", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 20, logCount = 14, x = 45.1, y = 59.8,
      note = "Talk to the flight master and learn this flight point.",
    },
})

-- Chapter 22: Southern Barrens
Leg(11, "The Barrens", {

    { type = "section", name = "Chapter 22: Southern Barrens", levels = { 27, 28 }, zone = "The Barrens" },
    {
      type = "complete", questName = "Egg Hunt", zone = "The Barrens",
      location = "Field of Giants", atLevel = 27, logCount = 9, x = 43.0, y = 70.0,
      approx = true,
    },
    {
      type = "accept", questName = "The Harvester", zone = "The Barrens",
      location = "Field of Giants", atLevel = 27, logCount = 10, x = 43.0, y = 70.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", name = "Chen's Empty Keg (part 3)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Field of Giants", atLevel = 27,
      logCount = 10, x = 45.0, y = 75.0, approx = true,
    },
    {
      type = "accept", questName = "Gann's Reclamation", zone = "The Barrens",
      location = "South Gold Road", atLevel = 27, logCount = 11,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", questName = "Washte Pawne", zone = "The Barrens",
      location = "Blackthorn Ridge", atLevel = 27, logCount = 12, x = 43.0, y = 81.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", questName = "Weapons of Choice", zone = "The Barrens",
      location = "Blackthorn Ridge", atLevel = 27, logCount = 12, x = 42.0, y = 81.0,
      approx = true,
    },
    {
      type = "complete", name = "Betrayal from Within (part 1)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "Blackthorn Ridge", atLevel = 27, logCount = 12,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Gann's Reclamation", zone = "The Barrens",
      location = "Bael Modan", atLevel = 27, logCount = 12, x = 47.0, y = 85.0, approx = true,
    },
    {
      type = "turnin", questName = "Gann's Reclamation", zone = "The Barrens",
      location = "South Gold Road", atLevel = 27, logCount = 11,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", name = "Revenge of Gann (part 1)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "South Gold Road", atLevel = 27,
      logCount = 12, note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", questName = "The Tear of the Moons", zone = "The Barrens",
      location = "Bael Modan", atLevel = 27, logCount = 13, x = 48.8, y = 86.2,
    },
    {
      type = "complete", questName = "The Tear of the Moons", zone = "The Barrens",
      location = "Bael Modan", atLevel = 27, logCount = 13, x = 49.1, y = 84.3,
    },
    {
      type = "complete", name = "Revenge of Gann (part 1)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "Bael Modan", atLevel = 27,
      logCount = 13, x = 49.0, y = 84.0, approx = true,
    },
    {
      type = "turnin", questName = "The Tear of the Moons", zone = "The Barrens",
      location = "Bael Modan", atLevel = 27, logCount = 12, x = 48.8, y = 86.2,
    },
    {
      type = "turnin", name = "Revenge of Gann (part 1)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "South Gold Road", atLevel = 27,
      logCount = 11, note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", name = "Revenge of Gann (part 2)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "South Gold Road", atLevel = 27,
      logCount = 12, note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "complete", name = "Revenge of Gann (part 2)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "Bael Modan", atLevel = 27,
      logCount = 12, x = 47.0, y = 85.6,
    },
    {
      type = "turnin", name = "Revenge of Gann (part 2)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "South Gold Road", atLevel = 27,
      logCount = 11, note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "hearth", name = "Hearth to Camp Taurajo", zone = "The Barrens",
      location = "South Gold Road", atLevel = 27, logCount = 11,
      note = "Use your hearthstone. This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "Weapons of Choice", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 27, logCount = 10, x = 45.0, y = 57.6,
    },
    {
      type = "accept", questName = "A New Ore Sample", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 27, logCount = 11, x = 45.0, y = 57.6,
    },
    {
      type = "turnin", questName = "The Harvester", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 27, logCount = 10, x = 44.8, y = 59.0,
    },
    {
      type = "turnin", questName = "Washte Pawne", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 28, logCount = 9, x = 44.8, y = 59.0,
    },
    {
      type = "turnin", name = "Betrayal from Within (part 1)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 28, logCount = 8, x = 44.6, y = 59.2,
    },
    {
      type = "accept", name = "Betrayal from Within (part 2)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 28, logCount = 9, x = 44.6, y = 59.2,
    },
    {
      type = "travel", name = "Camp Taurajo to The Crossroads", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 28, logCount = 9, x = 44.4, y = 59.2,
      note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Betrayal from Within (part 2)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "The Crossroads", atLevel = 28, logCount = 8, x = 51.4, y = 30.8,
    },
    {
      type = "turnin", questName = "Egg Hunt", zone = "The Barrens",
      location = "The Crossroads", atLevel = 28, logCount = 7, x = 51.0, y = 29.6,
    },
    {
      type = "travel", name = "The Crossroads to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", atLevel = 28, logCount = 7, x = 51.5, y = 30.3,
      note = "Take the flight path.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 28, logCount = 7,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "Class Trainer might be less travel time at Brill or Undercity depending on class.",
      atLevel = 28,
    },
})

-- Chapter 26: Darkcloud Pinnacle
Leg(14, "The Barrens", {

    { type = "section", name = "Chapter 26: Darkcloud Pinnacle", levels = { 31, 31 }, zone = "The Barrens" },
    {
      type = "turnin", questName = "A New Ore Sample", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 31, logCount = 16, x = 45.0, y = 57.6,
    },
    {
      type = "travel", name = "Camp Taurajo to Thunder Bluff", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 31, logCount = 16, x = 44.4, y = 59.2,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Sacred Fire", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 31, logCount = 15, x = 70.2, y = 30.8,
    },
    {
      type = "accept", questName = "Arikara", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 31, logCount = 16, x = 70.2, y = 30.8,
    },
    {
      type = "turnin", questName = "Steelsnap", zone = "Thunder Bluff",
      location = "The Hunter Rise", atLevel = 31, logCount = 15, x = 61.4, y = 80.6,
    },
    {
      type = "accept", questName = "Frostmaw", zone = "Thunder Bluff",
      location = "The Hunter Rise", atLevel = 31, logCount = 16, x = 61.4, y = 80.6,
    },
    {
      type = "note", optional = true, name = "Skip: A",
      note = "The route deliberately skips A Vengeful Fate. Low XP for the travel time.",
      zone = "Thunder Bluff", location = "Thunder Bluff", atLevel = 31, x = 36.1, y = 59.9,
    },
    {
      type = "hearth", name = "Set Hearth to Thunder Bluff", zone = "Thunder Bluff",
      atLevel = 31, logCount = 16, x = 45.8, y = 64.7, note = "Bind your hearthstone here.",
    },
    {
      type = "travel", name = "Thunder Bluff to The Crossroads", zone = "Thunder Bluff",
      atLevel = 31, logCount = 16, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
    {
      type = "note", name = "Note",
      note = "If you had a TB hearth previously, fly to Camp Taurajo to turn in A New Ore Sample before flying to Crossroads.",
      atLevel = 31,
    },
    {
      type = "accept", name = "The Swarm Grows (part 1)", questName = "The Swarm Grows",
      ambiguous = true, zone = "The Barrens", location = "The Crossroads", atLevel = 31,
      logCount = 17, x = 51.0, y = 29.6,
    },
    {
      type = "turnin", questName = "Regthar Deathgate", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 31, logCount = 16, x = 45.4, y = 28.4,
    },
    {
      type = "accept", questName = "The Kolkar of Desolace", zone = "The Barrens",
      location = "West of Crossroads", atLevel = 31, logCount = 17, x = 45.4, y = 28.4,
    },
    {
      type = "travel", name = "The Crossroads to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", atLevel = 31, logCount = 17, x = 51.5, y = 30.3,
      note = "Take the flight path.",
    },
    {
      type = "note", name = "Note",
      note = "Set hearth to Orgrimmar if your class cannot train at Thunder Bluff. (Rogue/Warlock)",
      atLevel = 31,
    },
    {
      type = "turnin", name = "The Swarm Grows (part 1)", questName = "The Swarm Grows",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Honor", atLevel = 31,
      logCount = 16, x = 75.0, y = 34.0,
    },
    {
      type = "accept", name = "The Swarm Grows (part 2)", questName = "The Swarm Grows",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Honor", atLevel = 31,
      logCount = 17, x = 75.0, y = 34.0,
    },
    {
      type = "note", optional = true, name = "Skip: R",
      note = "The route deliberately skips Rig Wars. Low XP for the travel time.",
      zone = "Orgrimmar", location = "The Valley of Honor", atLevel = 31, x = 76.0, y = 25.4,
    },
    {
      type = "accept", name = "Alliance Relations (part 1)", questName = "Alliance Relations",
      ambiguous = true, zone = "Orgrimmar", location = "The Cleft of Shadow", atLevel = 31,
      logCount = 18, x = 49.0, y = 49.0, approx = true,
    },
    {
      type = "turnin", name = "Alliance Relations (part 1)", questName = "Alliance Relations",
      ambiguous = true, zone = "Orgrimmar", location = "Orgrimmar West Gate", atLevel = 31,
      logCount = 17, x = 22.4, y = 52.8,
    },
    {
      type = "accept", name = "Alliance Relations (part 2)", questName = "Alliance Relations",
      ambiguous = true, zone = "Orgrimmar", location = "Orgrimmar West Gate", atLevel = 31,
      logCount = 18, x = 22.4, y = 52.8,
    },
    {
      type = "travel", name = "Orgrimmar to Ratchet", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 31, logCount = 18, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Wharfmaster Dizzywig", zone = "The Barrens",
      location = "Ratchet", atLevel = 31, logCount = 17, x = 63.2, y = 38.4,
    },
    {
      type = "accept", questName = "Parts for Kravel", zone = "The Barrens",
      location = "Ratchet", atLevel = 31, logCount = 18, x = 63.2, y = 38.4,
    },
    {
      type = "turnin", name = "Chen's Empty Keg (part 3)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 31,
      logCount = 17, x = 62.2, y = 38.4,
    },
    {
      type = "note", optional = true, name = "Skip: C",
      note = "The route deliberately skips Chen's Empty Keg #4. Low XP for the travel time.",
      zone = "The Barrens", location = "Ratchet", atLevel = 31, x = 62.2, y = 38.4,
    },
    {
      type = "turnin", questName = "Mahren Skyseer", zone = "The Barrens",
      location = "The Tidus Stair", atLevel = 31, logCount = 16, x = 65.8, y = 43.8,
    },
    {
      type = "accept", questName = "Isha Awak", zone = "The Barrens",
      location = "The Tidus Stair", atLevel = 31, logCount = 17, x = 65.8, y = 43.8,
    },
    {
      type = "complete", questName = "Isha Awak", zone = "The Barrens",
      location = "Merchant Coast", atLevel = 31, logCount = 17,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "Isha Awak", zone = "The Barrens",
      location = "The Tidus Stair", atLevel = 31, logCount = 16, x = 65.8, y = 43.8,
    },
    {
      type = "travel", name = "Ratchet to Freewind Post", zone = "The Barrens",
      location = "Ratchet", atLevel = 31, logCount = 16, x = 63.1, y = 37.2,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Wind Rider", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 31, logCount = 15, x = 44.9, y = 48.9,
    },
    {
      type = "complete", questName = "Grimtotem Spying", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", atLevel = 31, logCount = 15,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Arikara", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", atLevel = 31, logCount = 15, x = 38.0, y = 35.4,
    },
    {
      type = "complete", questName = "Wanted - Arnak Grimtotem", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", atLevel = 31, logCount = 15, x = 38.1, y = 26.8,
    },
    {
      type = "accept", questName = "Free at Last", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", atLevel = 31, logCount = 16, x = 37.9, y = 26.5,
    },
    {
      type = "complete", questName = "Free at Last", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", atLevel = 31, logCount = 16, x = 35.0, y = 31.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Arikara", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 31, logCount = 15, x = 21.6, y = 32.2,
    },
    {
      type = "complete", questName = "Test of Strength", zone = "Thousand Needles",
      location = "West Thousand Needles", atLevel = 31, logCount = 15, x = 17.0, y = 37.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Test of Strength", zone = "Thousand Needles",
      location = "The Weathered Nook", atLevel = 31, logCount = 14, x = 53.9, y = 41.5,
    },
})

