-- TuFFlevels / Routes/Horde/Solo/ArathiHighlands.lua
--
-- Arathi Highlands leg(s) of the solo Orc/Troll 1-60 route. Levels 38-40.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 36: Arathi Highlands | Chapter 37: Faldir's Cove
Leg(21, "Arathi Highlands", {

    { type = "section", name = "Chapter 36: Arathi Highlands", levels = { 38, 38 }, zone = "Arathi Highlands" },
    {
      type = "complete", questName = "The Hammer May Fall", zone = "Arathi Highlands",
      location = "Boulderfist Outpost", atLevel = 38, logCount = 17, x = 35.0, y = 44.0,
      approx = true,
    },
    {
      type = "complete", questName = "To Steal From Thieves", zone = "Arathi Highlands",
      location = "Dabyrie's Farmstead", atLevel = 38, logCount = 17,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "accept", questName = "The Princess Trapped", zone = "Arathi Highlands",
      location = "Circle of East Binding", atLevel = 38, logCount = 18, x = 62.5, y = 33.8,
    },
    {
      type = "travel", name = "Urda <Wind Rider Master>", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 18, x = 73.1, y = 32.7,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "hearth", name = "Set Hearth to Hammerfall", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 18, x = 73.8, y = 32.4,
      note = "Bind your hearthstone here.",
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Real Threat. Low XP for the travel time.",
      zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38, x = 74.0, y = 33.2,
    },
    {
      type = "turnin", questName = "The Hammer May Fall", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 17, x = 74.2, y = 33.8,
    },
    {
      type = "accept", name = "Call to Arms (part 1)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 18, x = 74.2, y = 33.8,
    },
    {
      type = "turnin", questName = "Trollbane", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 17, x = 32.3, y = 27.7,
    },
    {
      type = "note", name = "Skip: S",
      note = "The route deliberately skips Sigil of Strom. Low XP for the travel time.",
      zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38, x = 73.8, y = 33.8,
    },
    {
      type = "accept", questName = "Hammerfall", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 18, x = 72.6, y = 34.0,
    },
    {
      type = "turnin", questName = "Hammerfall", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 17, x = 74.6, y = 36.4,
    },
    {
      type = "accept", name = "Raising Spirits (part 1)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 18, x = 74.6, y = 36.4,
    },
    {
      type = "accept", name = "Foul Magics (part 1)", questName = "Foul Magics",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 19, x = 74.6, y = 36.4,
    },
    {
      type = "complete", name = "Raising Spirits (part 1)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", atLevel = 38, logCount = 19, x = 67.0,
      y = 40.0, approx = true,
    },
    {
      type = "complete", name = "Call to Arms (part 1)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Witherbark Village",
      atLevel = 38, logCount = 19, x = 72.0, y = 64.0, approx = true,
    },
    {
      type = "turnin", name = "Raising Spirits (part 1)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 18, x = 74.6, y = 36.4,
    },
    {
      type = "accept", name = "Raising Spirits (part 2)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 19, x = 74.6, y = 36.4,
    },
    {
      type = "turnin", name = "Raising Spirits (part 2)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 18, x = 72.6, y = 34.0,
    },
    {
      type = "accept", name = "Raising Spirits (part 3)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 19, x = 72.6, y = 34.0,
    },
    {
      type = "turnin", name = "Call to Arms (part 1)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 18, x = 74.2, y = 33.8,
    },
    {
      type = "accept", name = "Call to Arms (part 2)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 19, x = 74.2, y = 33.8,
    },
    {
      type = "turnin", name = "Raising Spirits (part 3)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 18, x = 74.6, y = 36.4,
    },
    {
      type = "accept", name = "Guile of the Raptor (part 1)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 19, x = 74.6, y = 36.4,
    },
    {
      type = "complete", questName = "The Princess Trapped", zone = "Arathi Highlands",
      location = "Drywhisker Gorge", atLevel = 38, logCount = 19, x = 84.0, y = 35.0,
      approx = true,
    },
    {
      type = "turnin", questName = "The Princess Trapped", zone = "Arathi Highlands",
      location = "Drywhisker Gorge", atLevel = 38, logCount = 18, x = 84.3, y = 30.9,
    },
    {
      type = "accept", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Drywhisker Gorge", atLevel = 38, logCount = 19, x = 84.3, y = 30.9,
    },
    {
      type = "complete", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Circle of East Binding", atLevel = 38, logCount = 19, x = 66.7, y = 29.7,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Circle of Outer Binding", atLevel = 38, logCount = 19, x = 52.0, y = 50.7,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Foul Magics (part 1)", questName = "Foul Magics",
      ambiguous = true, zone = "Arathi Highlands", location = "Northfold Manor", atLevel = 38,
      logCount = 19, x = 33.0, y = 29.0, approx = true,
    },
    {
      type = "complete", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Circle of West Binding", atLevel = 38, logCount = 19, x = 25.5, y = 30.1,
    },
    {
      type = "turnin", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Circle of Inner Binding", atLevel = 38, logCount = 18, x = 36.1, y = 57.4,
    },
    {
      type = "note", name = "Skip: B",
      note = "The route deliberately skips Breaking the Keystone. Low XP for the travel time.",
      zone = "Arathi Highlands", location = "Circle of Inner Binding", atLevel = 38, x = 36.1,
      y = 57.4,
    },
    {
      type = "complete", questName = "Breaking the Keystone", zone = "Arathi Highlands",
      atLevel = 38, logCount = 18,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", name = "Breaking the Keystone", questName = "Breaking the Keystone",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Arathi Highlands", location = "Circle of Inner Binding", atLevel = 38, x = 36.2,
      y = 57.4,
    },
    {
      type = "turnin", questName = "Breaking the Keystone", zone = "Arathi Highlands",
      location = "Circle of Inner Binding", atLevel = 38, logCount = 18, x = 36.2, y = 57.4,
    },
    {
      type = "note", name = "Skip: M",
      note = "The route deliberately skips Myzrael's Allies. Low XP for the travel time.",
      zone = "Arathi Highlands", location = "Circle of Inner Binding", atLevel = 38, x = 36.2,
      y = 57.4,
    },
    {
      type = "complete", name = "Guile of the Raptor (part 1)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Boulderfist Hall", atLevel = 38, logCount = 18, x = 47.0, y = 77.0,
      approx = true,
    },
    {
      type = "complete", name = "Call to Arms (part 2)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Boulderfist Hall", atLevel = 38,
      logCount = 18, x = 53.0, y = 74.0, approx = true,
    },
    {
      type = "hearth", name = "Hearth to Hammerfall", zone = "Arathi Highlands",
      location = "Boulderfist Hall", atLevel = 38, logCount = 18, x = 53.0, y = 74.0,
      approx = true, note = "Use your hearthstone.",
    },
    {
      type = "accept", name = "Myzrael's Allies", questName = "Myzrael's Allies",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38, x = 74.4, y = 35.6,
    },
    {
      type = "turnin", questName = "Myzrael's Allies", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 18, x = 74.4, y = 35.6,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips Theldurin the Lost. Low XP for the travel time.",
      zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38, x = 74.4, y = 35.6,
    },
    {
      type = "turnin", name = "Call to Arms (part 2)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 17, x = 74.2, y = 33.8,
    },
    {
      type = "note", name = "Skip: C",
      note = "The route deliberately skips Call to Arms #3. Low XP for the travel time.",
      zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38, x = 74.2, y = 33.8,
    },
    {
      type = "turnin", name = "Foul Magics (part 1)", questName = "Foul Magics",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38,
      logCount = 16, x = 74.6, y = 36.4,
    },
    {
      type = "note", name = "Skip: F",
      note = "The route deliberately skips Foul Magics #2. Low XP for the travel time.",
      zone = "Arathi Highlands", location = "Hammerfall", atLevel = 38, x = 74.6, y = 36.4,
    },
    {
      type = "turnin", name = "Guile of the Raptor (part 1)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 15, x = 74.6, y = 36.4,
    },
    {
      type = "accept", name = "Guile of the Raptor (part 2)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 16, x = 74.6, y = 36.4,
    },
    {
      type = "turnin", name = "Guile of the Raptor (part 2)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 15, x = 72.6, y = 34.0,
    },
    {
      type = "accept", name = "Guile of the Raptor (part 3)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 16, x = 72.6, y = 34.0,
    },
    {
      type = "turnin", name = "Guile of the Raptor (part 3)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 15, x = 74.6, y = 36.4,
    },
    {
      type = "travel", name = "Hammerfall to Tarren Mill", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 38, logCount = 15, x = 73.1, y = 32.7,
      note = "Take the flight path.",
    },

    { type = "section", name = "Chapter 37: Faldir's Cove", levels = { 38, 40 }, zone = "Arathi Highlands" },
    {
      type = "hearth", name = "Set Hearth to Tarren Mill", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 38, logCount = 15, x = 62.8, y = 19.0,
      note = "Bind your hearthstone here.",
    },
    {
      type = "complete", name = "The Crown of Will (part 3)", questName = "The Crown of Will",
      ambiguous = true, zone = "Alterac Mountains", location = "Ruins of Alterac",
      atLevel = 38, logCount = 15, note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "WANTED: Baron Vardus", zone = "Alterac Mountains",
      location = "The Uplands", atLevel = 38, logCount = 15,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Lord Aliden Perenolde", zone = "Alterac Mountains",
      location = "Dandred's Fold", atLevel = 38, logCount = 15, x = 39.3, y = 14.6,
    },
    {
      type = "turnin", questName = "Lord Aliden Perenolde", zone = "Alterac Mountains",
      location = "Dandred's Fold", atLevel = 39, logCount = 14, x = 39.3, y = 14.3,
    },
    {
      type = "accept", questName = "Taretha's Gift", zone = "Alterac Mountains",
      location = "Dandred's Fold", atLevel = 39, logCount = 15, x = 39.3, y = 14.3,
    },
    {
      type = "grind", targetLevel = 40, name = "Kill until Level 40 and 90 gold",
      zone = "Alterac Mountains", location = "The Uplands", atLevel = 39, logCount = 15,
      x = 53.0, y = 21.0, approx = true,
    },
    {
      type = "turnin", questName = "To Steal From Thieves", zone = "Undercity",
      location = "Trade Quarter", atLevel = 40, logCount = 14, x = 64.0, y = 49.4,
    },
    {
      type = "accept", name = "Errand for Apothecary Zinge (part 1)",
      questName = "Errand for Apothecary Zinge", ambiguous = true, zone = "Undercity",
      location = "The Apothecarium", atLevel = 40, logCount = 15, x = 50.1, y = 68.0,
    },
    {
      type = "turnin", name = "Errand for Apothecary Zinge (part 1)",
      questName = "Errand for Apothecary Zinge", ambiguous = true, zone = "Undercity",
      location = "The Apothecarium", atLevel = 40, logCount = 14, x = 58.6, y = 54.7,
    },
    {
      type = "accept", name = "Errand for Apothecary Zinge (part 2)",
      questName = "Errand for Apothecary Zinge", ambiguous = true, zone = "Undercity",
      location = "The Apothecarium", atLevel = 40, logCount = 15, x = 58.6, y = 54.7,
    },
    {
      type = "turnin", name = "Errand for Apothecary Zinge (part 2)",
      questName = "Errand for Apothecary Zinge", ambiguous = true, zone = "Undercity",
      location = "The Apothecarium", atLevel = 40, logCount = 14, x = 50.1, y = 68.0,
    },
    {
      type = "accept", questName = "Into the Field", zone = "Undercity",
      location = "The Apothecarium", atLevel = 40, logCount = 15, x = 50.1, y = 68.0,
    },
    {
      type = "note", name = "Note",
      note = "Learn riding skill and purchase mount. Undead travel to Brill. Orc/Tauren/Troll use zeppelin to Durotar.",
      atLevel = 40,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Capital City", atLevel = 40,
      logCount = 15, note = "Several spots around here - check the whole area.",
    },
    {
      type = "hearth", name = "Hearth to Tarren Mill", zone = "Capital City", atLevel = 40,
      logCount = 15,
      note = "Use your hearthstone. Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "WANTED: Baron Vardus", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 40, logCount = 14, x = 62.3, y = 20.5,
    },
    {
      type = "accept", name = "The Crown of Will (part 3)", ambiguous = true,
      questName = "The Crown of Will",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 40, x = 62.6, y = 20.7,
    },
    {
      type = "turnin", name = "The Crown of Will (part 3)", questName = "The Crown of Will",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 40,
      logCount = 14, x = 62.6, y = 20.7,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Crown of Will #4. Low XP for the travel time.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 40, x = 62.6, y = 20.7,
    },
    {
      type = "turnin", questName = "Taretha's Gift", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 40, logCount = 13, x = 63.2, y = 20.6,
    },
    {
      type = "accept", questName = "Land Ho!", zone = "Arathi Highlands",
      location = "Faldir's Cove", atLevel = 40, logCount = 14, x = 31.6, y = 82.6,
    },
    {
      type = "turnin", questName = "Land Ho!", zone = "Arathi Highlands",
      location = "Faldir's Cove", atLevel = 40, logCount = 13, x = 32.2, y = 81.4,
    },
    {
      type = "accept", questName = "Deep Sea Salvage", zone = "Arathi Highlands",
      location = "Faldir's Cove", atLevel = 40, logCount = 14, x = 32.6, y = 81.4,
    },
    {
      type = "accept", questName = "Drowned Sorrows", zone = "Arathi Highlands",
      location = "Faldir's Cove", atLevel = 40, logCount = 15, x = 33.8, y = 80.8,
    },
    {
      type = "accept", name = "Sunken Treasure (part 1)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Faldir's Cove", atLevel = 40,
      logCount = 16, x = 33.8, y = 80.6,
    },
    {
      type = "complete", name = "Sunken Treasure (part 1)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Faldir's Cove", atLevel = 40,
      logCount = 16, x = 35.8, y = 79.5,
    },
    {
      type = "turnin", name = "Sunken Treasure (part 1)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Faldir's Cove", atLevel = 40,
      logCount = 15, x = 33.8, y = 80.4,
    },
    {
      type = "accept", name = "Sunken Treasure (part 2)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Faldir's Cove", atLevel = 40,
      logCount = 16, x = 33.8, y = 80.4,
    },
    {
      type = "complete", questName = "Deep Sea Salvage", zone = "Arathi Highlands",
      location = "Drowned Reef", atLevel = 40, logCount = 16,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Drowned Sorrows", zone = "Arathi Highlands",
      location = "Drowned Reef", atLevel = 40, logCount = 16, x = 24.0, y = 89.0,
      approx = true,
    },
    {
      type = "complete", name = "Sunken Treasure (part 2)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Drowned Reef", atLevel = 40,
      logCount = 16, x = 24.0, y = 89.0, approx = true,
    },
    {
      type = "turnin", questName = "Deep Sea Salvage", zone = "Arathi Highlands",
      location = "Faldir's Cove", atLevel = 40, logCount = 15, x = 32.6, y = 81.4,
    },
    {
      type = "turnin", questName = "Drowned Sorrows", zone = "Arathi Highlands",
      location = "Faldir's Cove", atLevel = 40, logCount = 14, x = 33.8, y = 80.8,
    },
    {
      type = "turnin", name = "Sunken Treasure (part 2)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Faldir's Cove", atLevel = 40,
      logCount = 13, x = 33.8, y = 80.4,
    },
    {
      type = "accept", name = "Sunken Treasure (part 3)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Faldir's Cove", atLevel = 40,
      logCount = 14, x = 33.8, y = 80.4,
    },
    {
      type = "turnin", name = "Sunken Treasure (part 3)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Faldir's Cove", atLevel = 40,
      logCount = 13, x = 32.2, y = 81.4,
    },
    {
      type = "accept", name = "Sunken Treasure (part 4)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Arathi Highlands", location = "Faldir's Cove", atLevel = 40,
      logCount = 14, x = 32.2, y = 81.4,
    },
})

