-- TuFFlevels / Routes/Horde/Solo/BlastedLands.lua
--
-- Blasted Lands leg(s) of the solo Orc/Troll 1-60 route. Levels 50-52.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 53: Blasted Lands
Leg(35, "Blasted Lands", {

    { type = "section", name = "Chapter 53: Blasted Lands", levels = { 50, 52 }, zone = "Blasted Lands" },
    {
      type = "accept", questName = "March of the Silithid", zone = "Orgrimmar",
      location = "The Drag", atLevel = 50, logCount = 12, x = 56.3, y = 46.7,
    },
    {
      type = "travel", name = "Orgrimmar to The Crossroads", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 50, logCount = 12, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to The Crossroads", zone = "The Barrens",
      location = "The Crossroads", atLevel = 50, logCount = 12, x = 52.0, y = 29.9,
      note = "Bind your hearthstone here.",
    },
    {
      type = "travel", name = "The Crossroads to Ratchet", zone = "The Barrens",
      location = "The Crossroads", atLevel = 50, logCount = 12, x = 51.5, y = 30.3,
      note = "Take the flight path.",
    },
    {
      type = "complete", questName = "The Stone Circle", zone = "The Barrens",
      location = "Ratchet", atLevel = 50, logCount = 12, x = 62.5, y = 38.5,
    },
    {
      type = "accept", questName = "Volcanic Activity", zone = "The Barrens",
      location = "Ratchet", atLevel = 50, logCount = 13, x = 62.4, y = 38.7,
    },
    {
      type = "turnin", questName = "Seeking Spiritual Aid", zone = "The Barrens",
      location = "The Merchant Coast", atLevel = 50, logCount = 12, x = 65.8, y = 43.8,
    },
    {
      type = "accept", questName = "Cleansed Water Returns to Felwood", zone = "The Barrens",
      location = "The Merchant Coast", atLevel = 50, logCount = 13, x = 65.8, y = 43.8,
    },
    {
      type = "travel", name = "Ratchet to Booty Bay", zone = "The Barrens",
      location = "Ratchet", atLevel = 50, logCount = 13, x = 63.7, y = 38.7, note = "Boat.",
    },
    {
      type = "accept", questName = "The Monogrammed Sash", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 50, logCount = 14, x = 23.3, y = 72.1,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "accept", questName = "The Captain's Chest", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 50, logCount = 15, x = 26.6, y = 73.6,
    },
    {
      type = "turnin", questName = "The Monogrammed Sash", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 50, logCount = 14, x = 26.6, y = 73.6,
    },
    {
      type = "accept", questName = "The Captain's Cutlass", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 50, logCount = 15, x = 26.6, y = 73.6,
    },
    {
      type = "turnin", questName = "The Captain's Cutlass", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 50, logCount = 14, x = 26.7, y = 73.6,
    },
    {
      type = "note", name = "Skip: F",
      note = "The route deliberately skips Facing Negolash. Low XP for the travel time.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 50, x = 26.7, y = 73.6,
    },
    {
      type = "complete", questName = "The Captain's Chest", zone = "Stranglethorn Vale",
      location = "The Crystal Shore", atLevel = 50, logCount = 14, x = 37.0, y = 69.7,
    },
    {
      type = "accept", name = "Message in a Bottle (part 1)",
      questName = "Message in a Bottle", ambiguous = true, zone = "Stranglethorn Vale",
      location = "The Crystal Shore", atLevel = 50, logCount = 15,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", name = "Message in a Bottle (part 1)",
      questName = "Message in a Bottle", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Jaguero Isle", atLevel = 50, logCount = 14, x = 38.5, y = 80.6,
    },
    {
      type = "accept", name = "Message in a Bottle (part 2)",
      questName = "Message in a Bottle", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Jaguero Isle", atLevel = 50, logCount = 15, x = 38.5, y = 80.6,
    },
    {
      type = "complete", name = "Message in a Bottle (part 2)",
      questName = "Message in a Bottle", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Jaguero Isle", atLevel = 50, logCount = 15, x = 41.0, y = 83.9,
    },
    {
      type = "turnin", name = "Message in a Bottle (part 2)",
      questName = "Message in a Bottle", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Jaguero Isle", atLevel = 50, logCount = 14, x = 38.5, y = 80.6,
    },
    {
      type = "turnin", questName = "The Captain's Chest", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 50, logCount = 13, x = 26.6, y = 73.6,
    },
    {
      type = "turnin", questName = "Whiskey Slim's Lost Grog", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 50, logCount = 12, x = 27.1, y = 77.5,
    },
    {
      type = "travel", name = "Booty Bay to Stonard", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 50, logCount = 12, x = 26.9, y = 77.1,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Fall From Grace", zone = "Swamp of Sorrows",
      location = "Blasted Lands Border", atLevel = 50, logCount = 13, x = 34.3, y = 66.1,
    },
    {
      type = "turnin", questName = "Fall From Grace", zone = "Swamp of Sorrows",
      location = "Blasted Lands Border", atLevel = 50, logCount = 12, x = 34.3, y = 66.1,
    },
    {
      type = "accept", questName = "The Disgraced One", zone = "Swamp of Sorrows",
      location = "Blasted Lands Border", atLevel = 50, logCount = 13, x = 34.3, y = 66.1,
    },
    {
      type = "turnin", questName = "The Disgraced One", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 50, logCount = 12, x = 47.8, y = 54.9,
    },
    {
      type = "accept", questName = "The Missing Orders", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 50, logCount = 13, x = 47.8, y = 54.9,
    },
    {
      type = "turnin", questName = "The Missing Orders", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 50, logCount = 12, x = 45.0, y = 57.4,
    },
    {
      type = "accept", questName = "The Swamp Talker", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 50, logCount = 13, x = 45.0, y = 57.4,
    },
    {
      type = "complete", questName = "The Swamp Talker", zone = "Swamp of Sorrows",
      location = "Stagalbog Cave", atLevel = 50, logCount = 13, x = 62.6, y = 88.1,
    },
    {
      type = "turnin", questName = "The Swamp Talker", zone = "Swamp of Sorrows",
      location = "Blasted Lands Border", atLevel = 50, logCount = 12, x = 34.3, y = 66.1,
    },
    {
      type = "accept", questName = "A Tale of Sorrow", zone = "Swamp of Sorrows",
      location = "Blasted Lands Border", atLevel = 50, logCount = 13, x = 34.3, y = 66.1,
    },
    {
      type = "turnin", questName = "A Tale of Sorrow", zone = "Swamp of Sorrows",
      location = "Blasted Lands Border", atLevel = 50, logCount = 12, x = 34.3, y = 66.1,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Stones That Bind Us. Low XP for the travel time.",
      zone = "Swamp of Sorrows", location = "Blasted Lands Border", atLevel = 50, x = 34.3,
      y = 66.1,
    },
    {
      type = "accept", questName = "A Boar's Vitality", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 13, x = 50.6, y = 14.2,
    },
    {
      type = "accept", questName = "Snickerfang Jowls", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 14, x = 50.6, y = 14.2,
    },
    {
      type = "accept", questName = "The Decisive Striker", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 15, x = 50.6, y = 14.2,
    },
    {
      type = "accept", questName = "The Basilisk's Bite", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 16, x = 50.6, y = 14.3,
    },
    {
      type = "accept", questName = "Vulture's Vigor", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 17, x = 50.6, y = 14.3,
    },
    {
      type = "complete", questName = "A Boar's Vitality", zone = "Blasted Lands", atLevel = 50,
      logCount = 17, note = "Zone-wide objective. No single spot to run to.",
    },
    {
      type = "complete", questName = "Snickerfang Jowls", zone = "Blasted Lands", atLevel = 50,
      logCount = 17, note = "Zone-wide objective. No single spot to run to.",
    },
    {
      type = "complete", questName = "The Basilisk's Bite", zone = "Blasted Lands",
      atLevel = 50, logCount = 17, note = "Zone-wide objective. No single spot to run to.",
    },
    {
      type = "complete", questName = "The Decisive Striker", zone = "Blasted Lands",
      atLevel = 50, logCount = 17, note = "Zone-wide objective. No single spot to run to.",
    },
    {
      type = "complete", questName = "Vulture's Vigor", zone = "Blasted Lands", atLevel = 50,
      logCount = 17, note = "Zone-wide objective. No single spot to run to.",
    },
    {
      type = "note", name = "Note",
      note = "Need 11 Brains, 14 Gizzards, 5 Jowls, 6 Lungs and 6 Pincers total for all 5 kill collection quests.",
      atLevel = 50,
    },
    {
      type = "complete", questName = "The Stones That Bind Us", zone = "Blasted Lands",
      atLevel = 50, logCount = 17, note = "Several spots around here - check the whole area.",
    },
    {
      type = "accept", questName = "Everything Counts In Large Amounts",
      zone = "Blasted Lands", atLevel = 50, logCount = 18, x = 52.0, y = 35.6,
    },
    {
      type = "turnin", questName = "Everything Counts In Large Amounts",
      zone = "Blasted Lands", atLevel = 50, logCount = 17, x = 52.0, y = 35.6,
    },
    {
      type = "turnin", questName = "A Boar's Vitality", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 16, x = 50.6, y = 14.2,
    },
    {
      type = "turnin", questName = "Snickerfang Jowls", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 15, x = 50.6, y = 14.2,
    },
    {
      type = "turnin", questName = "The Decisive Striker", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 14, x = 50.6, y = 14.2,
    },
    {
      type = "turnin", questName = "The Basilisk's Bite", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 50, logCount = 13, x = 50.6, y = 14.3,
    },
    {
      type = "turnin", questName = "Vulture's Vigor", zone = "Blasted Lands",
      location = "North Blasted Lands", atLevel = 51, logCount = 12, x = 50.6, y = 14.3,
    },
    {
      type = "grind", targetLevel = 52, name = "Kill until Level 52", zone = "Blasted Lands",
      location = "Garrison Armory", atLevel = 52, logCount = 12, x = 57.0, y = 11.0,
      approx = true,
    },
    {
      type = "accept", name = "The Stones That Bind Us", questName = "The Stones That Bind Us",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Swamp of Sorrows", location = "Blasted Lands Border", atLevel = 52, x = 34.3,
      y = 66.1,
    },
    {
      type = "turnin", questName = "The Stones That Bind Us", zone = "Swamp of Sorrows",
      location = "Blasted Lands Border", atLevel = 52, logCount = 12, x = 34.3, y = 66.1,
    },
    {
      type = "note", name = "Skip: K",
      note = "The route deliberately skips Kirith. Low XP for the travel time.",
      zone = "Swamp of Sorrows", location = "Blasted Lands Border", atLevel = 52, x = 34.3,
      y = 66.1,
    },
    {
      type = "complete", questName = "Kirith", zone = "Blasted Lands",
      location = "Serpent's Coil", atLevel = 52, logCount = 12, x = 69.2, y = 30.8,
    },
    {
      type = "accept", name = "Kirith", questName = "Kirith",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Blasted Lands", location = "Serpent's Coil", atLevel = 52, x = 69.2, y = 30.8,
    },
    {
      type = "turnin", questName = "Kirith", zone = "Blasted Lands",
      location = "Serpent's Coil", atLevel = 52, logCount = 12, x = 69.2, y = 30.8,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Cover of Darkness. Low XP for the travel time.",
      zone = "Swamp of Sorrows", location = "Blasted Lands Border", atLevel = 52, x = 69.2,
      y = 30.8,
    },
    {
      type = "accept", name = "The Cover of Darkness", questName = "The Cover of Darkness",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Swamp of Sorrows", location = "Blasted Lands Border", atLevel = 52, x = 34.3,
      y = 66.1,
    },
    {
      type = "turnin", questName = "The Cover of Darkness", zone = "Swamp of Sorrows",
      location = "Blasted Lands Border", atLevel = 52, logCount = 12, x = 34.3, y = 66.1,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Demon Hunter. Low XP for the travel time.",
      zone = "Swamp of Sorrows", location = "Blasted Lands Border", atLevel = 52, x = 34.3,
      y = 66.1,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 52, logCount = 12,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "travel", name = "Stonard to Kargath", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 52, logCount = 12, x = 46.1, y = 54.8,
      note = "Take the flight path.",
    },
})

