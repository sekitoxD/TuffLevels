-- TuFFlevels / Routes/Horde/Solo/Badlands.lua
--
-- Badlands leg(s) of the solo Orc/Troll 1-60 route. Levels 40-40.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 38: Badlands
Leg(22, "Badlands", {

    { type = "section", name = "Chapter 38: Badlands", levels = { 40, 40 }, zone = "Badlands" },
    {
      type = "turnin", questName = "Martek the Exiled", zone = "Badlands",
      location = "Valley of Fangs", atLevel = 40, logCount = 13, x = 42.4, y = 52.6,
    },
    {
      type = "accept", questName = "Indurium", zone = "Badlands", location = "Valley of Fangs",
      atLevel = 40, logCount = 14, x = 42.4, y = 52.6,
    },
    {
      type = "accept", questName = "Barbecued Buzzard Wings", zone = "Badlands",
      location = "Valley of Fangs", atLevel = 40, logCount = 15, x = 42.4, y = 52.8,
    },
    {
      type = "turnin", questName = "Barbecued Buzzard Wings", zone = "Badlands",
      location = "Valley of Fangs", atLevel = 40, logCount = 14, x = 42.4, y = 52.8,
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips Pearl Diving, Power Stones. Low XP for the travel time.",
      zone = "Badlands", location = "Valley of Fangs", atLevel = 40, x = 42.4, y = 52.8,
    },
    {
      type = "accept", name = "Study of the Elements: Rock (part 1)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 15, x = 26.0, y = 44.8,
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips Coolant Heads Prevail, Gyro... What?. Low XP for the travel time.",
      zone = "Badlands", location = "The Dustbowl", atLevel = 40, x = 26.0, y = 44.8,
    },
    {
      type = "complete", name = "Study of the Elements: Rock (part 1)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 15, x = 20.0, y = 43.0,
      approx = true,
    },
    {
      type = "turnin", name = "Study of the Elements: Rock (part 1)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 14, x = 26.0, y = 44.8,
    },
    {
      type = "accept", name = "Study of the Elements: Rock (part 2)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 15, x = 26.0, y = 44.8,
    },
    {
      type = "complete", name = "Study of the Elements: Rock (part 2)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 15, x = 14.0, y = 33.0,
      approx = true,
    },
    {
      type = "turnin", name = "Study of the Elements: Rock (part 2)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 14, x = 26.0, y = 44.8,
    },
    {
      type = "accept", name = "Study of the Elements: Rock (part 3)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 15, x = 26.0, y = 44.8,
    },
    {
      type = "turnin", questName = "Neeka Bloodscar", zone = "Badlands", location = "Kargath",
      atLevel = 40, logCount = 14, x = 6.5, y = 47.2,
    },
    {
      type = "accept", questName = "Report to Helgrum", zone = "Badlands",
      location = "Kargath", atLevel = 40, logCount = 15, x = 6.5, y = 47.2,
    },
    {
      type = "accept", questName = "Coyote Thieves", zone = "Badlands", location = "Kargath",
      atLevel = 40, logCount = 16, x = 6.5, y = 47.2,
    },
    {
      type = "hearth", name = "Set Hearth to Kargath", zone = "Badlands", location = "Kargath",
      atLevel = 40, logCount = 16, x = 2.8, y = 45.9, note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Badlands Reagent Run", zone = "Badlands",
      location = "Kargath", atLevel = 40, logCount = 17, x = 2.4, y = 46.1,
    },
    {
      type = "accept", name = "Broken Alliances (part 1)", questName = "Broken Alliances",
      ambiguous = true, zone = "Badlands", location = "Kargath", atLevel = 40, logCount = 18,
      x = 2.9, y = 45.6,
    },
    {
      type = "complete", questName = "Coyote Thieves", zone = "Badlands",
      location = "Mirage Flats", atLevel = 40, logCount = 18, x = 13.0, y = 64.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Badlands Reagent Run", zone = "Badlands",
      location = "Mirage Flats", atLevel = 40, logCount = 18, x = 13.0, y = 64.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Study of the Elements: Rock (part 3)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "Dustbelch Grotto", atLevel = 40, logCount = 18, x = 3.0, y = 80.0,
      approx = true,
    },
    {
      type = "complete", name = "Broken Alliances (part 1)", questName = "Broken Alliances",
      ambiguous = true, zone = "Badlands", atLevel = 40, logCount = 18,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "note", name = "Note",
      note = "Turn in Study of the Elements: Rock #3 if you catch the Broken Alliances patrol on the western side of their route.",
      atLevel = 40,
    },
    {
      type = "complete", questName = "Indurium", zone = "Badlands", location = "Agmond's End",
      atLevel = 40, logCount = 18, x = 51.0, y = 69.0, approx = true,
    },
    {
      type = "accept", name = "Theldurin the Lost", questName = "Theldurin the Lost",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Badlands", location = "Agmond's End", atLevel = 40, x = 51.4, y = 76.8,
    },
    {
      type = "turnin", questName = "Theldurin the Lost", zone = "Badlands",
      location = "Agmond's End", atLevel = 40, logCount = 18, x = 51.4, y = 76.8,
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips The Lost Fragments, Solution to Doom. Low XP for the travel time.",
      zone = "Badlands", location = "Agmond's End", atLevel = 40, x = 51.4, y = 76.8,
    },
    {
      type = "complete", questName = "The Lost Fragments", zone = "Badlands",
      location = "Agmond's End", atLevel = 40, logCount = 18, x = 54.0, y = 82.0,
      approx = true,
    },
    {
      type = "accept", name = "The Lost Fragments", questName = "The Lost Fragments",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Badlands", location = "Agmond's End", atLevel = 40, x = 51.4, y = 76.8,
    },
    {
      type = "turnin", questName = "The Lost Fragments", zone = "Badlands",
      location = "Agmond's End", atLevel = 40, logCount = 18, x = 51.4, y = 76.8,
    },
    {
      type = "note", optional = true, name = "Skip: S",
      note = "The route deliberately skips Summoning the Princess. Low XP for the travel time.",
      zone = "Badlands", location = "Agmond's End", atLevel = 40, x = 51.4, y = 76.8,
    },
    {
      type = "turnin", questName = "Indurium", zone = "Badlands", location = "Valley of Fangs",
      atLevel = 40, logCount = 17, x = 42.4, y = 52.8,
    },
    {
      type = "accept", questName = "News for Fizzle", zone = "Badlands",
      location = "Valley of Fangs", atLevel = 40, logCount = 18, x = 42.4, y = 52.8,
    },
    {
      type = "complete", questName = "Coyote Thieves", zone = "Badlands",
      location = "Valley of Fangs", atLevel = 40, logCount = 18, x = 55.0, y = 56.0,
      approx = true,
    },
    {
      type = "complete", questName = "Badlands Reagent Run", zone = "Badlands",
      location = "Valley of Fangs", atLevel = 40, logCount = 18, x = 55.0, y = 56.0,
      approx = true,
    },
    {
      type = "turnin", name = "Study of the Elements: Rock (part 3)",
      questName = "Study of the Elements: Rock", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 17, x = 26.0, y = 44.8,
    },
    {
      type = "note", optional = true, name = "Skip: 3 quests here",
      note = "The route deliberately skips This Is Going to Be Hard #1, Stone Is Better than Cloth, Liquid Stone. Low XP for the travel time.",
      zone = "Badlands", location = "The Dustbowl", atLevel = 40, x = 26.0, y = 44.8,
    },
    {
      type = "accept", name = "This Is Going to Be Hard (part 1)", ambiguous = true,
      questName = "This Is Going to Be Hard",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Badlands", location = "The Dustbowl", atLevel = 40, x = 25.8, y = 44.4,
    },
    {
      type = "turnin", name = "This Is Going to Be Hard (part 1)",
      questName = "This Is Going to Be Hard", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 17, x = 25.8, y = 44.4,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips This Is Going to Be Hard #2. Low XP for the travel time.",
      zone = "Badlands", location = "The Dustbowl", atLevel = 40, x = 25.8, y = 44.4,
    },
    {
      type = "accept", name = "This Is Going to Be Hard (part 2)", ambiguous = true,
      questName = "This Is Going to Be Hard",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Badlands", location = "The Dustbowl", atLevel = 40, x = 26.0, y = 44.8,
    },
    {
      type = "turnin", name = "This Is Going to Be Hard (part 2)",
      questName = "This Is Going to Be Hard", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 17, x = 26.0, y = 44.8,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips This Is Going to Be Hard #3. Low XP for the travel time.",
      zone = "Badlands", location = "The Dustbowl", atLevel = 40, x = 26.0, y = 44.8,
    },
    {
      type = "complete", name = "This Is Going to Be Hard (part 3)",
      questName = "This Is Going to Be Hard", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 17, x = 26.0, y = 45.0,
      approx = true,
    },
    {
      type = "accept", name = "This Is Going to Be Hard (part 3)", ambiguous = true,
      questName = "This Is Going to Be Hard",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Badlands", location = "The Dustbowl", atLevel = 40, x = 26.0, y = 44.8,
    },
    {
      type = "turnin", name = "This Is Going to Be Hard (part 3)",
      questName = "This Is Going to Be Hard", ambiguous = true, zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 17, x = 26.0, y = 44.8,
    },
    {
      type = "hearth", name = "Hearth to Kargath", zone = "Badlands",
      location = "The Dustbowl", atLevel = 40, logCount = 17, x = 26.0, y = 44.8,
      note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Coyote Thieves", zone = "Badlands", location = "Kargath",
      atLevel = 40, logCount = 16, x = 6.5, y = 47.2,
    },
    {
      type = "turnin", questName = "Badlands Reagent Run", zone = "Badlands",
      location = "Kargath", atLevel = 40, logCount = 15, x = 2.4, y = 46.1,
    },
    {
      type = "note", optional = true, name = "Skip: U",
      note = "The route deliberately skips Uldaman Reagent Run. Low XP for the travel time.",
      zone = "Badlands", location = "Kargath", atLevel = 40, x = 2.4, y = 46.1,
    },
    {
      type = "turnin", name = "Broken Alliances (part 1)", questName = "Broken Alliances",
      ambiguous = true, zone = "Badlands", location = "Kargath", atLevel = 40, logCount = 14,
      x = 2.9, y = 45.6,
    },
    {
      type = "note", optional = true, name = "Skip: B",
      note = "The route deliberately skips Broken Alliances #2. Low XP for the travel time.",
      zone = "Badlands", location = "Kargath", atLevel = 40, x = 2.9, y = 45.6,
    },
    {
      type = "travel", name = "Gorrik <Wind Rider Master>", zone = "Badlands",
      location = "Kargath", atLevel = 40, logCount = 14, x = 4.0, y = 44.8,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "complete", questName = "Solution to Doom", zone = "Badlands",
      location = "The Sealed Hall", atLevel = 40, logCount = 14, x = 54.1, y = 58.2,
    },
    {
      type = "complete", questName = "Reclaimed Treasures", zone = "Badlands",
      location = "South Common Hall", atLevel = 40, logCount = 14, x = 53.8, y = 58.2,
    },
    {
      type = "complete", questName = "Uldaman Reagent Run", zone = "Badlands",
      location = "Dig One", atLevel = 40, logCount = 14, x = 54.0, y = 58.0, approx = true,
    },
    {
      type = "complete", questName = "Power Stones", zone = "Badlands",
      location = "The Maker's Terrace", atLevel = 40, logCount = 14, x = 46.0, y = 12.0,
      approx = true,
    },
    {
      type = "accept", name = "Power Stones", questName = "Power Stones",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Badlands", location = "Valley of Fangs", atLevel = 40, x = 42.4, y = 52.8,
    },
    {
      type = "turnin", questName = "Power Stones", zone = "Badlands",
      location = "Valley of Fangs", atLevel = 40, logCount = 14, x = 42.4, y = 52.8,
    },
    {
      type = "accept", name = "Solution to Doom", questName = "Solution to Doom",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Badlands", location = "Agmond's End", atLevel = 40, x = 51.4, y = 76.8,
    },
    {
      type = "turnin", questName = "Solution to Doom", zone = "Badlands",
      location = "Agmond's End", atLevel = 40, logCount = 14, x = 51.4, y = 76.8,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips To the Undercity for Yagyin's Digest. Low XP for the travel time.",
      zone = "Badlands", location = "Agmond's End", atLevel = 40, x = 51.4, y = 76.8,
    },
    {
      type = "accept", name = "Uldaman Reagent Run", questName = "Uldaman Reagent Run",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Badlands", location = "Kargath", atLevel = 40, x = 2.4, y = 46.1,
    },
    {
      type = "turnin", questName = "Uldaman Reagent Run", zone = "Badlands",
      location = "Kargath", atLevel = 40, logCount = 14, x = 2.4, y = 46.1,
    },
    {
      type = "travel", name = "Kargath to Booty Bay", zone = "Badlands", location = "Kargath",
      atLevel = 40, logCount = 14, x = 4.0, y = 44.8, note = "Take the flight path.",
    },
})

