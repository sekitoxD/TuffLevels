-- TuFFlevels / Routes/Horde/Solo/StonetalonMts.lua
--
-- Stonetalon Mts leg(s) of the solo Orc/Troll 1-60 route. Levels 20-27.
-- The route visits this zone 3 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 15: Out of Stonetalon Mountains
Leg(5, "Stonetalon Mts", {

    {
      type = "section", name = "Chapter 15: Out of Stonetalon Mountains", levels = { 20, 21 },
      zone = "Stonetalon Mts",
    },
    {
      type = "turnin", questName = "Ziz Fizziks", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 20, logCount = 13, x = 59.0, y = 62.4,
    },
    {
      type = "accept", questName = "Super Reaper 6000", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 20, logCount = 14, x = 59.0, y = 62.4,
    },
    {
      type = "complete", questName = "Goblin Invaders", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 20, logCount = 14, x = 65.0, y = 52.0,
      approx = true,
    },
    {
      type = "complete", questName = "Super Reaper 6000", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 20, logCount = 14, x = 63.0, y = 54.0,
      approx = true,
    },
    {
      type = "complete", questName = "Blood Feeders", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 20, logCount = 14, x = 62.0, y = 61.0,
      approx = true,
    },
    {
      type = "complete", questName = "Deepmoss Spider Eggs", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 20, logCount = 14, x = 62.0, y = 61.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Super Reaper 6000", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 21, logCount = 13, x = 59.0, y = 62.4,
    },
    {
      type = "accept", name = "Further Instructions (part 1)",
      questName = "Further Instructions", ambiguous = true, zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 21, logCount = 14, x = 59.0, y = 62.4,
    },
    {
      type = "complete", questName = "Boulderslide Ravine", zone = "Stonetalon Mts",
      location = "Boulderslide Ravine", atLevel = 21, logCount = 14, x = 60.0, y = 91.0,
      approx = true,
    },
    {
      type = "complete", questName = "Kill Grundig Darkcloud", zone = "Stonetalon Mts",
      location = "Camp Aparaje", atLevel = 21, logCount = 14, x = 73.6, y = 86.1,
    },
    {
      type = "accept", questName = "Protect Kaya", zone = "Stonetalon Mts",
      location = "Camp Aparaje", atLevel = 21, logCount = 15, x = 73.5, y = 85.6,
    },
    {
      type = "complete", questName = "Protect Kaya", zone = "Stonetalon Mts",
      location = "Camp Aparaje", atLevel = 21, logCount = 15, x = 76.0, y = 91.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Kill Grundig Darkcloud", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 21, logCount = 14, x = 35.2, y = 27.8,
    },
    {
      type = "turnin", questName = "Protect Kaya", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 21, logCount = 13, x = 35.2, y = 27.8,
    },
    {
      type = "accept", questName = "Kaya's Alive", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 21, logCount = 14, x = 35.2, y = 27.8,
    },
    {
      type = "turnin", questName = "Goblin Invaders", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 21, logCount = 13, x = 35.2, y = 27.8,
    },
    {
      type = "accept", questName = "Shredding Machines", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 21, logCount = 14, x = 35.2, y = 27.8,
    },
    {
      type = "accept", questName = "The Elder Crone", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 21, logCount = 15, x = 35.2, y = 27.8,
    },
    {
      type = "hearth", name = "Hearth to The Crossroads", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 21, logCount = 15, x = 35.2, y = 27.8,
      note = "Use your hearthstone.",
    },
})

-- Chapter 18: Stonetalon Peak
Leg(8, "Stonetalon Mts", {

    { type = "section", name = "Chapter 18: Stonetalon Peak", levels = { 23, 24 }, zone = "Stonetalon Mts" },
    {
      type = "accept", name = "Betrayal from Within (part 1)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 14, x = 44.6, y = 59.2,
    },
    {
      type = "turnin", questName = "Ishamuhale", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 13, x = 44.8, y = 59.0,
    },
    {
      type = "accept", name = "The Ashenvale Hunt (part 1)", questName = "The Ashenvale Hunt",
      ambiguous = true, zone = "The Barrens", location = "Camp Taurajo", atLevel = 23,
      logCount = 14, x = 44.8, y = 59.0,
    },
    {
      type = "accept", questName = "Enraged Thunder Lizards", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 15, x = 44.8, y = 59.0,
    },
    {
      type = "accept", questName = "Weapons of Choice", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 16, x = 45.0, y = 57.6,
    },
    {
      type = "accept", questName = "Owatanka", zone = "The Barrens", location = "Bramblescar",
      atLevel = 23, logCount = 17, x = 50.0, y = 60.0, approx = true,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", questName = "Enraged Thunder Lizards", zone = "The Barrens",
      location = "Bramblescar", atLevel = 23, logCount = 17, x = 50.0, y = 60.0, approx = true,
    },
    {
      type = "turnin", questName = "Enraged Thunder Lizards", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 16, x = 44.8, y = 59.0,
    },
    {
      type = "accept", questName = "Cry of the Thunderhawk", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 17, x = 44.8, y = 59.0,
    },
    {
      type = "complete", questName = "Cry of the Thunderhawk", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 17, x = 47.0, y = 61.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Cry of the Thunderhawk", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 16, x = 44.8, y = 59.0,
    },
    {
      type = "accept", questName = "Mahren Skyseer", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 17, x = 44.8, y = 59.0,
    },
    {
      type = "turnin", questName = "Owatanka", zone = "The Barrens", location = "Camp Taurajo",
      atLevel = 23, logCount = 16, x = 44.8, y = 59.0,
    },
    {
      type = "travel", name = "Camp Taurajo to Thunder Bluff", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 23, logCount = 16, x = 44.4, y = 59.2,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Return to Thunder Bluff", zone = "Thunder Bluff",
      location = "The Spirit Rise", atLevel = 23, logCount = 15, x = 61.4, y = 19.2,
    },
    {
      type = "accept", questName = "The Flying Machine Airport", zone = "Thunder Bluff",
      location = "The Spirit Rise", atLevel = 23, logCount = 16, x = 61.4, y = 19.2,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", atLevel = 23,
      logCount = 16, note = "Several spots around here - check the whole area.",
    },
    { type = "note", name = "Note", note = "Skip Class Trainer if you trained in Undercity.", atLevel = 23 },
    {
      type = "travel", name = "Thunder Bluff to Sunrock Retreat", zone = "Thunder Bluff",
      atLevel = 23, logCount = 16, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Cenarius' Legacy", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 23, logCount = 17, x = 46.0, y = 60.4,
    },
    {
      type = "turnin", questName = "Kaya's Alive", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 23, logCount = 16, x = 47.4, y = 58.4,
    },
    {
      type = "accept", questName = "Cycle of Rebirth", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 23, logCount = 17, x = 47.4, y = 58.4,
    },
    {
      type = "hearth", name = "Set Hearth to Sun Rock Retreat", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 23, logCount = 17, x = 47.5, y = 62.1,
      note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Trouble in the Deeps", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 23, logCount = 18, x = 47.2, y = 64.2,
    },
    {
      type = "turnin", questName = "Boulderslide Ravine", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 23, logCount = 17, x = 47.0, y = 64.0,
    },
    {
      type = "accept", questName = "Earthen Arise", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 23, logCount = 18, x = 47.0, y = 64.0,
    },
    {
      type = "complete", questName = "Cycle of Rebirth", zone = "Stonetalon Mts",
      location = "Mirkfallon Lake", atLevel = 23, logCount = 18, x = 50.0, y = 44.0,
      approx = true,
    },
    {
      type = "complete", questName = "Cenarius' Legacy", zone = "Stonetalon Mts",
      location = "Talon Peak", atLevel = 23, logCount = 18, x = 37.0, y = 13.0, approx = true,
    },
    {
      type = "complete", questName = "Jin'Zil's Forest Magic", zone = "Stonetalon Mts",
      location = "Talon Peak", atLevel = 23, logCount = 18, x = 37.0, y = 13.0, approx = true,
    },
    {
      type = "note", name = "Note",
      note = "If you have crowd control skills, do the Zoram Strand cliff jump and do Chapter 19.",
      atLevel = 23,
    },
    {
      type = "turnin", name = "Further Instructions (part 2)",
      questName = "Further Instructions", ambiguous = true, zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 23, logCount = 17, x = 59.0, y = 62.4,
    },
    {
      type = "accept", questName = "Gerenzo Wrenchwhistle", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 23, logCount = 18, x = 59.0, y = 62.4,
    },
    {
      type = "accept", name = "Gerenzo's Orders (part 1)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", atLevel = 24,
      logCount = 19, x = 71.8, y = 60.0,
    },
    {
      type = "complete", name = "Gerenzo's Orders (part 1)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", atLevel = 24,
      logCount = 19, x = 71.8, y = 60.0,
    },
    {
      type = "turnin", name = "Gerenzo's Orders (part 1)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", atLevel = 24,
      logCount = 18, x = 71.8, y = 60.0,
    },
    {
      type = "accept", name = "Gerenzo's Orders (part 2)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", atLevel = 24,
      logCount = 19, x = 71.8, y = 60.0,
    },
    {
      type = "complete", questName = "Gerenzo Wrenchwhistle", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 24, logCount = 19, x = 63.0, y = 40.6,
    },
    {
      type = "complete", questName = "The Flying Machine Airport", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 24, logCount = 19, x = 66.5, y = 45.5,
    },
    {
      type = "complete", questName = "Shredding Machines", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 24, logCount = 19, x = 65.0, y = 50.0,
      approx = true,
    },
    {
      type = "turnin", name = "Gerenzo's Orders (part 2)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", atLevel = 24,
      logCount = 18, x = 59.0, y = 62.4,
    },
    {
      type = "turnin", questName = "Gerenzo Wrenchwhistle", zone = "Stonetalon Mts",
      location = "Windshear Crag", atLevel = 24, logCount = 17, x = 59.0, y = 62.4,
    },
    {
      type = "complete", questName = "Earthen Arise", zone = "Stonetalon Mts",
      location = "Boulderslide Ravine", atLevel = 24, logCount = 17, x = 57.6, y = 89.4,
    },
    {
      type = "turnin", questName = "", zone = "Stonetalon Mts", location = "Malaka'Jin",
      atLevel = 24, logCount = 16, x = 71.2, y = 94.8,
    },
    {
      type = "turnin", questName = "Jin'Zil's Forest Magic", zone = "Stonetalon Mts",
      location = "Malaka'Jin", atLevel = 24, logCount = 15, x = 74.4, y = 97.8,
    },
    {
      type = "turnin", questName = "Shredding Machines", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 24, logCount = 14, x = 35.2, y = 27.8,
    },
    {
      type = "hearth", name = "Hearth to Sun Rock Retreat", zone = "The Barrens",
      location = "Honor's Stand", atLevel = 24, logCount = 14, x = 35.2, y = 27.8,
      note = "Use your hearthstone.",
    },
    {
      type = "note", name = "Skip for now: C",
      note = "Do not pick up yet - the route comes back for Calling in the Reserves on a later pass.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat", atLevel = 24, x = 47.2, y = 61.0,
    },
    {
      type = "turnin", questName = "Earthen Arise", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 24, logCount = 13, x = 47.0, y = 64.0,
    },
    {
      type = "turnin", questName = "Cycle of Rebirth", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 24, logCount = 12, x = 47.4, y = 58.4,
    },
    {
      type = "note", name = "Skip for now: N",
      note = "Do not pick up yet - the route comes back for New Life on a later pass.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat", atLevel = 24, x = 47.4, y = 58.4,
    },
    {
      type = "turnin", questName = "Cenarius' Legacy", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 24, logCount = 11, x = 46.0, y = 60.4,
    },
    {
      type = "accept", questName = "Ordanus", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 24, logCount = 12, x = 46.0, y = 60.4,
    },
})

-- Chapter 21: Charred Vale
Leg(10, "Stonetalon Mts", {

    { type = "section", name = "Chapter 21: Charred Vale", levels = { 26, 27 }, zone = "Stonetalon Mts" },
    {
      type = "accept", questName = "Calling in the Reserves", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 26, logCount = 11, x = 47.2, y = 61.0,
    },
    {
      type = "accept", questName = "Harpies Threaten", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 26, logCount = 12, x = 47.2, y = 61.0,
    },
    {
      type = "turnin", questName = "Ordanus", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 26, logCount = 11, x = 46.0, y = 60.4,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Den. Low XP for the travel time.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat", atLevel = 26, x = 46.0, y = 60.4,
    },
    {
      type = "accept", questName = "New Life", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 26, logCount = 12, x = 47.4, y = 58.4,
    },
    {
      type = "accept", questName = "Elemental War", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 26, logCount = 13, x = 47.2, y = 64.2,
    },
    {
      type = "complete", questName = "New Life", zone = "Stonetalon Mts",
      location = "The Charred Vale", atLevel = 26, logCount = 13, x = 33.0, y = 68.0,
      approx = true,
    },
    {
      type = "complete", questName = "Elemental War", zone = "Stonetalon Mts",
      location = "The Charred Vale", atLevel = 27, logCount = 13, x = 33.0, y = 68.0,
      approx = true,
    },
    {
      type = "complete", questName = "Harpies Threaten", zone = "Stonetalon Mts",
      location = "The Charred Vale", atLevel = 27, logCount = 13, x = 33.0, y = 68.0,
      approx = true,
    },
    {
      type = "turnin", questName = "New Life", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 27, logCount = 12, x = 47.4, y = 58.4,
    },
    {
      type = "turnin", questName = "Elemental War", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 27, logCount = 11, x = 47.2, y = 64.2,
    },
    {
      type = "turnin", questName = "Harpies Threaten", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 27, logCount = 10, x = 47.2, y = 61.0,
    },
    {
      type = "accept", questName = "Bloodfury Bloodline", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 27, logCount = 11, x = 47.2, y = 61.0,
    },
    {
      type = "complete", questName = "Bloodfury Bloodline", zone = "Stonetalon Mts",
      location = "The Charred Vale", atLevel = 27, logCount = 11, x = 30.0, y = 62.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Bloodfury Bloodline", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 27, logCount = 10, x = 47.2, y = 61.0,
    },
    {
      type = "travel", name = "Sun Rock Retreat to Thunder Bluff", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", atLevel = 27, logCount = 10, x = 45.1, y = 59.8,
      note = "Take the flight path.",
    },
    {
      type = "turnin", name = "The Sacred Flame (part 1)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thunder Bluff", atLevel = 27, logCount = 9, x = 54.6, y = 51.4,
    },
    {
      type = "accept", name = "The Sacred Flame (part 2)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thunder Bluff", atLevel = 27, logCount = 10, x = 54.6,
      y = 51.4,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", atLevel = 27,
      logCount = 10, note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "The Flying Machine Airport", zone = "Thunder Bluff",
      location = "The Spirit Rise", atLevel = 27, logCount = 9, x = 61.4, y = 19.2,
    },
    {
      type = "travel", name = "Thunder Bluff to Camp Taurajo", zone = "Thunder Bluff",
      atLevel = 27, logCount = 9, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Camp Taurajo", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 27, logCount = 9, x = 45.6, y = 59.0,
      note = "Bind your hearthstone here.",
    },
})

