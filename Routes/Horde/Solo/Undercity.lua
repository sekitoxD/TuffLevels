-- TuFFlevels / Routes/Horde/Solo/Undercity.lua
--
-- Undercity leg(s) of the solo Orc/Troll 1-60 route. Levels 54-54.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 59: Undercity
Leg(40, "Undercity", {

    { type = "section", name = "Chapter 59: Undercity", levels = { 54, 54 }, zone = "Undercity" },
    {
      type = "turnin", questName = "Strength of Corruption", zone = "Feralas",
      location = "Camp Mojache", atLevel = 54, logCount = 15, x = 76.2, y = 43.8,
    },
    {
      type = "manual", name = "Gregan Brewspewer: Bait", zone = "Feralas",
      location = "Twin Colossals", atLevel = 54, logCount = 15, x = 45.1, y = 25.6,
      note = "Vendor stop.",
    },
    {
      type = "complete", name = "The Videre Elixir (part 2)", questName = "The Videre Elixir",
      ambiguous = true, zone = "Feralas", location = "Ruins of Ravenwind", atLevel = 54,
      logCount = 15, x = 44.6, y = 10.5,
    },
    {
      type = "complete", name = "The Videre Elixir (part 1)", questName = "The Videre Elixir",
      ambiguous = true, zone = "Feralas", location = "Twin Colossals", atLevel = 54,
      logCount = 15, x = 45.1, y = 25.6,
    },
    {
      type = "travel", name = "Shadowprey Village to Thunder Bluff", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 54, logCount = 15, x = 21.6, y = 74.1,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "The New Frontier", zone = "Thunder Bluff", atLevel = 54,
      logCount = 16, note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", questName = "A Call to Arms: The Plaguelands!", zone = "Thunder Bluff",
      atLevel = 54, logCount = 17,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", atLevel = 54,
      logCount = 17, note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "Class Trainer might be less travel time at Orgrimmar or Undercity depending on class.",
      atLevel = 54,
    },
    {
      type = "turnin", questName = "Delivery to Magatha", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 54, logCount = 16, x = 69.9, y = 30.9,
    },
    {
      type = "accept", questName = "Magatha's Payment to Jediga", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 54, logCount = 17, x = 69.9, y = 30.9,
    },
    {
      type = "turnin", name = "Morrowgrain Research (part 2)",
      questName = "Morrowgrain Research", ambiguous = true, zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 54, logCount = 16, x = 71.1, y = 34.2,
    },
    {
      type = "turnin", questName = "The New Frontier", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 54, logCount = 15, x = 78.6, y = 28.6,
    },
    {
      type = "accept", questName = "Rabine Saturna", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 54, logCount = 16, x = 78.6, y = 28.6,
    },
    {
      type = "travel", name = "Thunder Bluff to Orgrimmar", zone = "Thunder Bluff",
      atLevel = 54, logCount = 16, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Delivery to Jes'rimon", zone = "Orgrimmar",
      location = "The Drag", atLevel = 54, logCount = 15, x = 55.5, y = 34.1,
    },
    {
      type = "accept", questName = "Jes'rimon's Payment to Jediga", zone = "Orgrimmar",
      location = "The Drag", atLevel = 54, logCount = 16, x = 55.5, y = 34.1,
    },
    {
      type = "turnin", name = "Betrayed (part 4)", questName = "Betrayed", ambiguous = true,
      zone = "Orgrimmar", location = "The Valley of Honor", atLevel = 54, logCount = 15,
      x = 75.2, y = 34.2,
    },
    {
      type = "hearth", name = "Set Hearth to Orgrimmar", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 54, logCount = 15, x = 54.1, y = 68.4,
      note = "Bind your hearthstone here.",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 54, logCount = 15, x = 50.8, y = 13.9,
      note = "Zeppelin.",
    },
    {
      type = "turnin", questName = "Delivery to Andron Gant", zone = "Undercity",
      location = "The Apothecarium", atLevel = 54, logCount = 14, x = 54.8, y = 76.3,
    },
    {
      type = "accept", questName = "Andron's Payment to Jediga", zone = "Undercity",
      location = "The Apothecarium", atLevel = 54, logCount = 15, x = 54.8, y = 76.3,
    },
    {
      type = "complete", questName = "A Sample of Slime...", zone = "Undercity",
      location = "The Apothecarium", atLevel = 54, logCount = 15, x = 47.9, y = 73.6,
    },
    {
      type = "complete", questName = "... and a Batch of Ooze", zone = "Undercity",
      location = "The Apothecarium", atLevel = 54, logCount = 15, x = 47.9, y = 73.6,
    },
    {
      type = "turnin", questName = "A Sample of Slime...", zone = "Undercity",
      location = "The Apothecarium", atLevel = 54, logCount = 14, x = 47.5, y = 73.3,
    },
    {
      type = "turnin", questName = "... and a Batch of Ooze", zone = "Undercity",
      location = "The Apothecarium", atLevel = 54, logCount = 13, x = 47.5, y = 73.3,
    },
    {
      type = "accept", questName = "Melding of Influences", zone = "Undercity",
      location = "The Apothecarium", atLevel = 54, logCount = 14, x = 47.5, y = 73.3,
    },
    {
      type = "turnin", name = "Seeping Corruption (part 1)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "The Apothecarium", atLevel = 54,
      logCount = 13, x = 48.7, y = 71.4,
    },
    {
      type = "accept", name = "Seeping Corruption (part 2)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "The Apothecarium", atLevel = 54,
      logCount = 14, x = 48.7, y = 71.4,
    },
    {
      type = "turnin", name = "Seeping Corruption (part 2)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "The Apothecarium", atLevel = 54,
      logCount = 13, x = 49.0, y = 70.8,
    },
    {
      type = "accept", name = "Seeping Corruption (part 3)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "The Apothecarium", atLevel = 54,
      logCount = 14, x = 48.7, y = 71.4,
    },
    {
      type = "turnin", name = "Seeping Corruption (part 3)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "The Apothecarium", atLevel = 54,
      logCount = 13, x = 48.7, y = 71.4,
    },
    {
      type = "note", optional = true, name = "Skip for now: V",
      note = "Do not pick up yet - the route comes back for Vivian Lagrave on a later pass.",
      zone = "Undercity", location = "The Apothecarium", atLevel = 54, x = 50.1, y = 68.0,
    },
    {
      type = "accept", questName = "The Champion of the Banshee Queen", zone = "Undercity",
      location = "The Royal Quarter", atLevel = 54, logCount = 14, x = 58.1, y = 91.8,
    },
})

