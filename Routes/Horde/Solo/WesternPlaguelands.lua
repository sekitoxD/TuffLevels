-- TuFFlevels / Routes/Horde/Solo/WesternPlaguelands.lua
--
-- Western Plaguelands leg(s) of the solo Orc/Troll 1-60 route. Levels 54-59.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 60: Western Plaguelands
Leg(41, "Western Plaguelands", {

    {
      type = "section", name = "Chapter 60: Western Plaguelands", levels = { 54, 55 },
      zone = "Western Plaguelands",
    },
    {
      type = "turnin", questName = "The Everlook Report", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 54, logCount = 13, x = 83.2, y = 68.4,
    },
    {
      type = "accept", questName = "Argent Dawn Commission", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 54, logCount = 14, x = 83.2, y = 68.4,
    },
    {
      type = "turnin", questName = "Argent Dawn Commission", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 54, logCount = 13, x = 83.2, y = 68.4,
    },
    {
      type = "manual", name = "Box of Incendiaries: Flame in a Bottle x1",
      zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 54, logCount = 13,
      x = 83.2, y = 69.1, note = "Collect these here.",
    },
    {
      type = "turnin", questName = "A Call to Arms: The Plaguelands!",
      zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 54, logCount = 12,
      x = 83.1, y = 68.9,
    },
    {
      type = "accept", questName = "Scarlet Diversions", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 54, logCount = 13, x = 83.1, y = 68.9,
    },
    {
      type = "note", optional = true, name = "Skip: B",
      note = "The route deliberately skips Barov Family Fortune. Low XP for the travel time.",
      zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 54, x = 83.1, y = 71.6,
    },
    {
      type = "note", optional = true, name = "Skip for now: A",
      note = "Do not pick up yet - the route comes back for A Plague Upon Thee #1 on a later pass.",
      zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 54, x = 83.3, y = 72.3,
    },
    {
      type = "accept", questName = "Little Pamela", zone = "Western Plaguelands",
      location = "Sorrow Hill", atLevel = 54, logCount = 14, x = 49.2, y = 78.6,
    },
    {
      type = "turnin", questName = "Little Pamela", zone = "Eastern Plaguelands",
      location = "Darrowshire", atLevel = 54, logCount = 13, x = 36.5, y = 90.8,
    },
    {
      type = "accept", questName = "Pamela's Doll", zone = "Eastern Plaguelands",
      location = "Darrowshire", atLevel = 54, logCount = 14, x = 36.5, y = 90.8,
    },
    {
      type = "complete", questName = "Pamela's Doll", zone = "Eastern Plaguelands",
      location = "Darrowshire", atLevel = 54, logCount = 14, x = 39.0, y = 91.0, approx = true,
    },
    {
      type = "turnin", questName = "Pamela's Doll", zone = "Eastern Plaguelands",
      location = "Darrowshire", atLevel = 54, logCount = 13, x = 36.5, y = 90.8,
    },
    {
      type = "accept", questName = "Uncle Carlin", zone = "Eastern Plaguelands",
      location = "Darrowshire", atLevel = 54, logCount = 14, x = 36.5, y = 90.8,
    },
    {
      type = "accept", questName = "Auntie Marlene", zone = "Eastern Plaguelands",
      location = "Darrowshire", atLevel = 54, logCount = 15, x = 36.5, y = 90.8,
    },
    {
      type = "turnin", questName = "Auntie Marlene", zone = "Western Plaguelands",
      location = "Sorrow Hill", atLevel = 54, logCount = 14, x = 49.2, y = 78.6,
    },
    {
      type = "accept", questName = "A Strange Historian", zone = "Western Plaguelands",
      location = "Sorrow Hill", atLevel = 54, logCount = 15, x = 49.2, y = 78.6,
    },
    {
      type = "complete", questName = "A Strange Historian", zone = "Western Plaguelands",
      location = "Sorrow Hill", atLevel = 54, logCount = 15, x = 49.7, y = 76.8,
    },
    {
      type = "accept", name = "The Wildlife Suffers Too (part 1)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 54, logCount = 16, x = 53.7, y = 64.7,
    },
    {
      type = "complete", name = "The Wildlife Suffers Too (part 1)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      atLevel = 54, logCount = 16, x = 43.0, y = 56.0, approx = true,
    },
    {
      type = "complete", questName = "Scarlet Diversions", zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 54, logCount = 16, x = 40.7, y = 52.0,
    },
    {
      type = "turnin", questName = "Scarlet Diversions", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 54, logCount = 15, x = 83.1, y = 68.9,
    },
    {
      type = "accept", questName = "All Along the Watchtowers", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 54, logCount = 16, x = 83.1, y = 68.9,
    },
    {
      type = "accept", questName = "The Scourge Cauldrons", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 54, logCount = 17, x = 83.1, y = 68.9,
    },
    {
      type = "turnin", questName = "The Scourge Cauldrons", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 55, logCount = 16, x = 83.0, y = 71.9,
    },
    {
      type = "accept", questName = "Target: Felstone Field", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 55, logCount = 17, x = 83.0, y = 71.9,
    },
    {
      type = "complete", questName = "Target: Felstone Field", zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 55, logCount = 17, x = 37.2, y = 56.8,
    },
    {
      type = "turnin", questName = "Target: Felstone Field", zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 55, logCount = 16, x = 37.2, y = 56.8,
    },
    {
      type = "accept", name = "Return to the Bulwark (part 1)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 55, logCount = 17, x = 37.2, y = 56.8,
    },
    {
      type = "accept", name = "Better Late Than Never (part 1)",
      questName = "Better Late Than Never", ambiguous = true, zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 55, logCount = 18, x = 38.4, y = 54.1,
    },
    {
      type = "turnin", name = "Better Late Than Never (part 1)",
      questName = "Better Late Than Never", ambiguous = true, zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 55, logCount = 17, x = 38.7, y = 55.2,
    },
    {
      type = "accept", name = "Better Late Than Never (part 2)",
      questName = "Better Late Than Never", ambiguous = true, zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 55, logCount = 18, x = 38.7, y = 55.2,
    },
    {
      type = "turnin", name = "Return to the Bulwark (part 1)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 55, logCount = 17, x = 83.0, y = 71.9,
    },
    {
      type = "accept", questName = "Target: Dalson's Tears", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 55, logCount = 18, x = 83.0, y = 71.9,
    },
    {
      type = "complete", questName = "Target: Dalson's Tears", zone = "Western Plaguelands",
      location = "Dalson's Tears", atLevel = 55, logCount = 18, x = 46.2, y = 52.0,
    },
    {
      type = "turnin", questName = "Target: Dalson's Tears", zone = "Western Plaguelands",
      location = "Dalson's Tears", atLevel = 55, logCount = 17, x = 46.2, y = 51.9,
    },
    {
      type = "accept", name = "Return to the Bulwark (part 2)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Western Plaguelands",
      location = "Dalson's Tears", atLevel = 55, logCount = 18, x = 46.2, y = 51.9,
    },
    {
      type = "accept", questName = "Mrs. Dalson's Diary", zone = "Western Plaguelands",
      location = "Dalson's Tears", atLevel = 55, logCount = 19, x = 47.8, y = 50.7,
    },
    {
      type = "turnin", questName = "Mrs. Dalson's Diary", zone = "Western Plaguelands",
      location = "Dalson's Tears", atLevel = 55, logCount = 18, x = 47.8, y = 50.7,
    },
    {
      type = "manual", name = "Wandering Skeleton: Dalson Outhouse Key",
      zone = "Western Plaguelands", location = "Dalson's Tears", atLevel = 55, logCount = 18,
      x = 48.0, y = 50.0, approx = true, note = "Collect these here.",
    },
    {
      type = "accept", name = "Locked Away (part 1)", questName = "Locked Away",
      ambiguous = true, zone = "Western Plaguelands", location = "Dalson's Tears",
      atLevel = 55, logCount = 19, x = 48.1, y = 49.7,
    },
    {
      type = "turnin", name = "Locked Away (part 1)", questName = "Locked Away",
      ambiguous = true, zone = "Western Plaguelands", location = "Dalson's Tears",
      atLevel = 55, logCount = 18, x = 48.1, y = 49.7,
    },
    {
      type = "accept", name = "Locked Away (part 2)", questName = "Locked Away",
      ambiguous = true, zone = "Western Plaguelands", location = "Dalson's Tears",
      atLevel = 55, logCount = 19, x = 47.4, y = 49.6,
    },
    {
      type = "turnin", name = "Locked Away (part 2)", questName = "Locked Away",
      ambiguous = true, zone = "Western Plaguelands", location = "Dalson's Tears",
      atLevel = 55, logCount = 18, x = 47.4, y = 49.6,
    },
    {
      type = "turnin", name = "Return to the Bulwark (part 2)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 55, logCount = 17, x = 83.0, y = 71.9,
    },
    {
      type = "accept", questName = "Target: Writhing Haunt", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 55, logCount = 18, x = 83.0, y = 71.9,
    },
    {
      type = "turnin", questName = "A Strange Historian", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 17, x = 39.5, y = 66.8,
    },
    {
      type = "accept", questName = "The Annals of Darrowshire", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 18, x = 39.5, y = 66.8,
    },
    {
      type = "accept", questName = "A Matter of Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 19, x = 39.5, y = 66.8,
    },
    {
      type = "complete", questName = "All Along the Watchtowers", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 19,
      note = "Partial progress - work on this while you are here, then move on. Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "A Matter of Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 19, x = 48.0, y = 64.0,
      approx = true,
    },
    {
      type = "complete", questName = "All Along the Watchtowers", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 19,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "A Matter of Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 18, x = 39.5, y = 66.8,
    },
    {
      type = "accept", name = "Counting Out Time (part 1)", questName = "Counting Out Time",
      ambiguous = true, zone = "Western Plaguelands", location = "Ruins of Andorhal",
      atLevel = 55, logCount = 19, x = 39.5, y = 66.8,
    },
    {
      type = "complete", name = "Counting Out Time (part 1)", questName = "Counting Out Time",
      ambiguous = true, zone = "Western Plaguelands", location = "Ruins of Andorhal",
      atLevel = 55, logCount = 19, x = 41.0, y = 68.0, approx = true,
    },
    {
      type = "complete", questName = "The Annals of Darrowshire", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 19, x = 43.5, y = 70.0,
      approx = true,
    },
    {
      type = "turnin", name = "Counting Out Time (part 1)", questName = "Counting Out Time",
      ambiguous = true, zone = "Western Plaguelands", location = "Ruins of Andorhal",
      atLevel = 55, logCount = 18, x = 39.5, y = 66.8,
    },
    {
      type = "note", optional = true, name = "Skip: C",
      note = "The route deliberately skips Counting Out Time #2. Low XP for the travel time.",
      zone = "Western Plaguelands", location = "Ruins of Andorhal", atLevel = 55, x = 39.5,
      y = 66.8,
    },
    {
      type = "turnin", questName = "The Annals of Darrowshire", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 17, x = 39.5, y = 66.8,
    },
    {
      type = "accept", questName = "Brother Carlin", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", atLevel = 55, logCount = 18, x = 39.5, y = 66.8,
    },
    {
      type = "complete", questName = "Target: Writhing Haunt", zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 18, x = 53.0, y = 65.7,
    },
    {
      type = "turnin", questName = "Target: Writhing Haunt", zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 17, x = 53.0, y = 65.6,
    },
    {
      type = "accept", name = "Return to the Bulwark (part 3)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 18, x = 53.0, y = 65.6,
    },
    {
      type = "turnin", name = "The Wildlife Suffers Too (part 1)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 17, x = 53.7, y = 64.7,
    },
    {
      type = "accept", name = "The Wildlife Suffers Too (part 2)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 18, x = 53.7, y = 64.7,
    },
    {
      type = "complete", name = "The Wildlife Suffers Too (part 2)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 18, x = 58.0, y = 62.0,
      approx = true,
    },
    {
      type = "turnin", name = "The Wildlife Suffers Too (part 2)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 17, x = 53.7, y = 64.7,
    },
    {
      type = "accept", questName = "Glyphed Oaken Branch", zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 18, x = 53.7, y = 64.7,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "Western Plaguelands",
      location = "Writhing Haunt", atLevel = 55, logCount = 18, x = 53.7, y = 64.7,
      note = "Use your hearthstone.",
    },
})

-- Chapter 68: Plaguelands Finale
Leg(48, "Western Plaguelands", {

    {
      type = "section", name = "Chapter 68: Plaguelands Finale", levels = { 58, 59 },
      zone = "Western Plaguelands",
    },
    {
      type = "turnin", name = "Better Late Than Never (part 2)",
      questName = "Better Late Than Never", ambiguous = true, zone = "Undercity", atLevel = 58,
      logCount = 9, x = 69.8, y = 43.2,
    },
    {
      type = "accept", questName = "The Jeremiah Blues", zone = "Undercity", atLevel = 58,
      logCount = 10, x = 69.8, y = 43.2,
    },
    {
      type = "turnin", questName = "The Jeremiah Blues", zone = "Undercity", atLevel = 58,
      logCount = 9, x = 67.6, y = 44.2,
    },
    {
      type = "accept", questName = "Good Luck Charm", zone = "Undercity", atLevel = 58,
      logCount = 10, x = 67.6, y = 44.2,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Undercity", atLevel = 58,
      logCount = 10, note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "Melding of Influences", zone = "Undercity",
      location = "The Apothecarium", atLevel = 58, logCount = 9, x = 47.5, y = 73.3,
    },
    {
      type = "turnin", name = "A Plague Upon Thee (part 1)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 58,
      logCount = 8, x = 83.3, y = 72.3,
    },
    {
      type = "accept", name = "A Plague Upon Thee (part 2)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 58,
      logCount = 9, x = 83.3, y = 72.3,
    },
    {
      type = "complete", questName = "Alas, Andorhal", zone = "Western Plaguelands",
      location = "Ruins of Andorhol", atLevel = 58, logCount = 9, x = 45.3, y = 69.2,
    },
    {
      type = "complete", questName = "Skeletal Fragments", zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 58, logCount = 9, x = 37.0, y = 56.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Good Luck Charm", zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 58, logCount = 8, x = 38.4, y = 54.1,
    },
    {
      type = "accept", questName = "Two Halves Become One", zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 58, logCount = 9, x = 38.4, y = 54.1,
    },
    {
      type = "complete", questName = "Two Halves Become One", zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 58, logCount = 9, x = 36.8, y = 58.2,
    },
    {
      type = "turnin", questName = "Two Halves Become One", zone = "Western Plaguelands",
      location = "Felstone Field", atLevel = 58, logCount = 8, x = 38.4, y = 54.1,
    },
    {
      type = "complete", name = "A Plague Upon Thee (part 2)",
      questName = "A Plague Upon Thee", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", atLevel = 58, logCount = 8, x = 48.3, y = 32.0,
    },
    {
      type = "turnin", name = "A Plague Upon Thee (part 2)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Western Plaguelands", location = "Northridge Lumber Camp",
      atLevel = 58, logCount = 7, x = 48.3, y = 32.0,
    },
    {
      type = "accept", name = "A Plague Upon Thee (part 3)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Western Plaguelands", location = "Northridge Lumber Camp",
      atLevel = 58, logCount = 8, x = 48.3, y = 32.0,
    },
    {
      type = "accept", name = "Unfinished Business (part 1)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", atLevel = 58, logCount = 9, x = 51.9, y = 28.1,
    },
    {
      type = "complete", name = "Unfinished Business (part 1)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", atLevel = 58, logCount = 9, x = 51.0, y = 43.0,
      approx = true,
    },
    {
      type = "turnin", name = "Unfinished Business (part 1)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", atLevel = 58, logCount = 8, x = 51.9, y = 28.1,
    },
    {
      type = "accept", name = "Unfinished Business (part 2)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", atLevel = 58, logCount = 9, x = 51.9, y = 28.1,
    },
    {
      type = "complete", name = "Unfinished Business (part 2)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", atLevel = 58, logCount = 9,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", name = "Unfinished Business (part 2)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", atLevel = 58, logCount = 8, x = 51.9, y = 28.1,
    },
    {
      type = "note", optional = true, name = "Skip: U",
      note = "The route deliberately skips Unfinished Business #3. Low XP for the travel time.",
      zone = "Western Plaguelands", location = "Northridge Lumber Camp", atLevel = 58,
      x = 51.9, y = 28.1,
    },
    {
      type = "complete", questName = "Target: Gahrron's Withering",
      zone = "Western Plaguelands", location = "Gahrron's Withering", atLevel = 58,
      logCount = 8, x = 62.5, y = 58.5,
    },
    {
      type = "turnin", questName = "Target: Gahrron's Withering", zone = "Western Plaguelands",
      location = "Gahrron's Withering", atLevel = 58, logCount = 7, x = 62.5, y = 58.5,
    },
    {
      type = "accept", name = "Return to the Bulwark (part 4)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Western Plaguelands",
      location = "Gahrron's Withering", atLevel = 58, logCount = 8, x = 62.5, y = 58.5,
    },
    {
      type = "complete", questName = "Heroes of Darrowshire", zone = "Western Plaguelands",
      location = "Gahrron's Withering", atLevel = 58, logCount = 8, x = 63.8, y = 57.2,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", questName = "Of Lost Honor", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 7, x = 7.6, y = 43.7,
    },
    {
      type = "accept", name = "Of Love and Family (part 1)", questName = "Of Love and Family",
      ambiguous = true, zone = "Eastern Plaguelands", location = "Thondroril River",
      atLevel = 58, logCount = 8, x = 7.6, y = 43.7,
    },
    {
      type = "turnin", questName = "The Ranger Lord's Behest", zone = "Eastern Plaguelands",
      location = "The Marris Stead", atLevel = 58, logCount = 7, x = 26.5, y = 74.7,
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips Duskwing, Oh How I Hate Thee..., The Corpulent One. Low XP for the travel time.",
      zone = "Eastern Plaguelands", location = "The Marris Stead", atLevel = 58, x = 26.5,
      y = 74.7,
    },
    {
      type = "turnin", questName = "Hameya's Plea", zone = "Eastern Plaguelands",
      location = "The Undercroft", atLevel = 58, logCount = 6, x = 28.0, y = 86.2,
    },
    {
      type = "turnin", name = "Of Love and Family (part 1)", questName = "Of Love and Family",
      ambiguous = true, zone = "Western Plaguelands", location = "Caer Darrow", atLevel = 58,
      logCount = 5, x = 65.8, y = 75.4,
    },
    {
      type = "note", optional = true, name = "Skip: O",
      note = "The route deliberately skips Of Love and Family #2. Low XP for the travel time.",
      zone = "Western Plaguelands", location = "Caer Darrow", atLevel = 58, x = 65.8, y = 75.4,
    },
    {
      type = "turnin", name = "Return to the Bulwark (part 4)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 58, logCount = 4, x = 83.0, y = 71.9,
    },
    {
      type = "turnin", name = "A Plague Upon Thee (part 3)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 58,
      logCount = 3, x = 83.3, y = 72.3,
    },
    {
      type = "turnin", questName = "Skeletal Fragments", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 58, logCount = 2, x = 83.3, y = 69.2,
    },
    {
      type = "accept", questName = "Mold Rhymes With...", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 58, logCount = 3, x = 83.3, y = 69.2,
    },
    {
      type = "accept", name = "Alas, Andorhal", questName = "Alas, Andorhal",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 58, x = 83.1, y = 68.9,
    },
    {
      type = "turnin", questName = "Alas, Andorhal", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 58, logCount = 3, x = 83.1, y = 68.9,
    },
    {
      type = "accept", questName = "Mission Accomplished!", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 58, logCount = 4, x = 83.1, y = 68.9,
    },
    {
      type = "turnin", questName = "Mission Accomplished!", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 59, logCount = 3, x = 83.1, y = 68.9,
    },
})

