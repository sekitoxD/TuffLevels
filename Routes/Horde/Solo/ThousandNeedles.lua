-- TuFFlevels / Routes/Horde/Solo/ThousandNeedles.lua
--
-- Thousand Needles leg(s) of the solo Orc/Troll 1-60 route. Levels 30-33.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 24: Splithoof Crag | Chapter 25: Thousand Needles Lap
Leg(13, "Thousand Needles", {

    { type = "section", name = "Chapter 24: Splithoof Crag", levels = { 30, 30 }, zone = "Thousand Needles" },
    {
      type = "accept", questName = "Suspicious Hoofprints", zone = "Dustwallow Marsh",
      location = "Shady Rest Inn", atLevel = 30, logCount = 8, x = 29.7, y = 47.6,
    },
    {
      type = "accept", questName = "Lieutenant Paval Reethe", zone = "Dustwallow Marsh",
      location = "Shady Rest Inn", atLevel = 30, logCount = 9, x = 29.8, y = 48.2,
    },
    {
      type = "accept", name = "The Black Shield (part 1)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Shady Rest Inn", atLevel = 30,
      logCount = 10, x = 29.6, y = 48.6,
    },
    {
      type = "travel", name = "Shardi <Wind Rider Master>", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 30, logCount = 10, x = 35.6, y = 31.9,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "turnin", questName = "Suspicious Hoofprints", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 30, logCount = 9, x = 36.4, y = 31.8,
    },
    {
      type = "turnin", questName = "Lieutenant Paval Reethe", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 30, logCount = 8, x = 36.4, y = 31.8,
    },
    {
      type = "turnin", name = "The Black Shield (part 1)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      atLevel = 30, logCount = 7, x = 36.4, y = 31.8,
    },
    {
      type = "accept", name = "The Black Shield (part 2)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      atLevel = 30, logCount = 8, x = 36.4, y = 31.8,
    },
    {
      type = "turnin", name = "The Black Shield (part 2)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      atLevel = 30, logCount = 7, x = 36.4, y = 30.8,
    },
    {
      type = "note", name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Black Shield #3 on a later pass.",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 30, x = 36.4,
      y = 30.8,
    },
    {
      type = "manual", name = "Balai Lok'Wein: Expert First Aid - Under Wraps",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 30, logCount = 7,
      x = 36.5, y = 30.4, note = "Vendor stop.",
    },
    {
      type = "manual", name = "Balai Lok'Wein: Manual: Heavy Silk Bandage",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 30, logCount = 7,
      x = 36.5, y = 30.4, note = "Vendor stop.",
    },
    {
      type = "turnin", questName = "Calling in the Reserves", zone = "The Barrens",
      location = "The Great Lift", atLevel = 30, logCount = 6, x = 31.9, y = 21.6,
    },
    {
      type = "accept", questName = "Message to Freewind Post", zone = "The Barrens",
      location = "The Great Lift", atLevel = 30, logCount = 7, x = 32.2, y = 22.2,
    },
    {
      type = "travel", name = "Nyse <Wind Rider Master>", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 7, x = 45.1, y = 49.1,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "accept", questName = "Wind Rider", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 8, x = 44.9, y = 48.9,
    },
    {
      type = "accept", questName = "Alien Egg", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 9, x = 44.6, y = 50.3,
    },
    {
      type = "turnin", questName = "Message to Freewind Post", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 8, x = 45.7, y = 50.8,
    },
    {
      type = "accept", questName = "Pacify the Centaur", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 9, x = 45.7, y = 50.8,
    },
    {
      type = "turnin", name = "The Sacred Flame (part 2)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thousand Needles", location = "Freewind Post", atLevel = 30,
      logCount = 8, x = 46.1, y = 51.7,
    },
    {
      type = "accept", name = "The Sacred Flame (part 3)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thousand Needles", location = "Freewind Post", atLevel = 30,
      logCount = 9, x = 46.1, y = 51.7,
    },
    {
      type = "accept", questName = "Wanted - Arnak Grimtotem", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 10, x = 46.0, y = 50.9,
    },
    {
      type = "complete", questName = "Alien Egg", zone = "Thousand Needles",
      location = "Windbreak Canyon", atLevel = 30, logCount = 10, x = 52.3, y = 55.2,
    },
    {
      type = "accept", questName = "Test of Faith", zone = "Thousand Needles",
      location = "The Weathered Nook", atLevel = 30, logCount = 11, x = 53.9, y = 41.5,
    },
    {
      type = "complete", questName = "Test of Faith", zone = "Thousand Needles",
      location = "The Weathered Nook", atLevel = 30, logCount = 11, x = 53.9, y = 41.5,
    },
    {
      type = "turnin", questName = "Test of Faith", zone = "Thousand Needles",
      location = "The Weathered Nook", atLevel = 30, logCount = 10, x = 53.9, y = 41.5,
    },
    {
      type = "accept", questName = "Test of Endurance", zone = "Thousand Needles",
      location = "The Weathered Nook", atLevel = 30, logCount = 11, x = 53.9, y = 41.5,
    },
    {
      type = "complete", questName = "Pacify the Centaur", zone = "Thousand Needles",
      location = "Splithoof Crag", atLevel = 30, logCount = 11, x = 44.0, y = 35.0,
      approx = true,
    },
    {
      type = "complete", name = "The Sacred Flame (part 3)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thousand Needles", location = "Splithoof Crag", atLevel = 30,
      logCount = 11, x = 42.0, y = 31.5,
    },
    {
      type = "accept", questName = "Assassination Plot", zone = "Thousand Needles",
      location = "Splithoof Crag", atLevel = 30, logCount = 12,
      note = "Starts from an item you loot here, not from an NPC. This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "Alien Egg", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 11, x = 44.6, y = 50.3,
    },
    {
      type = "accept", questName = "Serpent Wild", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 12, x = 44.6, y = 50.3,
    },
    {
      type = "turnin", questName = "Pacify the Centaur", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 11, x = 45.7, y = 50.8,
    },
    {
      type = "accept", questName = "Grimtotem Spying", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 30, logCount = 12, x = 46.1, y = 51.7,
    },
    {
      type = "turnin", name = "The Sacred Flame (part 3)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thousand Needles", location = "Freewind Post", atLevel = 30,
      logCount = 11, x = 46.1, y = 51.7,
    },

    {
      type = "section", name = "Chapter 25: Thousand Needles Lap", levels = { 30, 31 },
      zone = "Thousand Needles",
    },
    {
      type = "complete", questName = "Test of Endurance", zone = "Thousand Needles",
      location = "West Thousand Needles", atLevel = 30, logCount = 11, x = 25.9, y = 54.7,
    },
    {
      type = "complete", questName = "Wind Rider", zone = "Thousand Needles",
      location = "Highperch", atLevel = 30, logCount = 11, x = 11.0, y = 36.0, approx = true,
    },
    {
      type = "accept", questName = "Homeward Bound", zone = "Thousand Needles",
      location = "Highperch", atLevel = 30, logCount = 12, x = 17.9, y = 40.5,
    },
    {
      type = "complete", questName = "Homeward Bound", zone = "Thousand Needles",
      location = "Highperch", atLevel = 30, logCount = 12, x = 11.0, y = 36.0, approx = true,
    },
    {
      type = "complete", questName = "Steelsnap", zone = "Thousand Needles",
      location = "West Thousand Needles", atLevel = 30, logCount = 12, x = 15.0, y = 25.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Assassination Plot", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 11, x = 21.2, y = 31.6,
    },
    {
      type = "accept", questName = "Protect Kanati Greycloud", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 12, x = 21.2, y = 32.0,
    },
    {
      type = "complete", questName = "Protect Kanati Greycloud", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 12, x = 21.2, y = 32.0,
    },
    {
      type = "turnin", questName = "Protect Kanati Greycloud", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 11, x = 21.2, y = 32.0,
    },
    {
      type = "turnin", questName = "Serpent Wild", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 10, x = 21.6, y = 32.2,
    },
    {
      type = "turnin", questName = "Homeward Bound", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 9, x = 21.6, y = 32.2,
    },
    {
      type = "accept", questName = "Sacred Fire", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 10, x = 21.6, y = 32.2,
    },
    {
      type = "accept", questName = "Hypercapacitor Gizmo", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 11, x = 21.4, y = 32.6,
    },
    {
      type = "complete", questName = "Hypercapacitor Gizmo", zone = "Thousand Needles",
      location = "Camp E'thok", atLevel = 30, logCount = 11, x = 22.8, y = 24.5,
    },
    {
      type = "turnin", questName = "Hypercapacitor Gizmo", zone = "Thousand Needles",
      location = "Whitereach Post", atLevel = 30, logCount = 10, x = 21.4, y = 32.6,
    },
    {
      type = "complete", questName = "Sacred Fire", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", atLevel = 30, logCount = 10, x = 37.0, y = 38.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Test of Endurance", zone = "Thousand Needles",
      location = "The Weathered Nook", atLevel = 30, logCount = 9, x = 53.9, y = 41.5,
    },
    {
      type = "accept", questName = "Test of Strength", zone = "Thousand Needles",
      location = "The Weathered Nook", atLevel = 30, logCount = 10, x = 53.9, y = 41.5,
    },
    {
      type = "complete", questName = "A New Ore Sample", zone = "Thousand Needles",
      location = "East Thousand Needles", atLevel = 31, logCount = 10, x = 66.0, y = 50.0,
      approx = true,
    },
    {
      type = "accept", questName = "Hemet Nesingwary", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 31, logCount = 11, x = 77.8, y = 77.2,
    },
    {
      type = "accept", questName = "Rocket Car Parts", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 31, logCount = 12, x = 77.8, y = 77.2,
    },
    {
      type = "accept", questName = "Wharfmaster Dizzywig", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 31, logCount = 13, x = 77.8, y = 77.2,
    },
    {
      type = "accept", questName = "Salt Flat Venom", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 31, logCount = 14, x = 78.0, y = 77.0,
    },
    {
      type = "accept", questName = "Hardened Shells", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 31, logCount = 15, x = 78.0, y = 77.0,
    },
    {
      type = "accept", questName = "Load Lightening", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 31, logCount = 16, x = 80.0, y = 75.8,
    },
    {
      type = "accept", questName = "A Bump in the Road", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 31, logCount = 17, x = 81.6, y = 77.8,
    },
    {
      type = "hearth", name = "Hearth to Camp Taurajo", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 31, logCount = 17, x = 81.6, y = 77.8,
      note = "Use your hearthstone.",
    },
})

-- Chapter 27: Shimmering Flats
Leg(15, "Thousand Needles", {

    { type = "section", name = "Chapter 27: Shimmering Flats", levels = { 31, 33 }, zone = "Thousand Needles" },
    {
      type = "turnin", name = "The Swarm Grows (part 2)", questName = "The Swarm Grows",
      ambiguous = true, zone = "Thousand Needles", location = "Ironstone Camp", atLevel = 31,
      logCount = 13, x = 67.6, y = 64.0,
    },
    {
      type = "accept", name = "The Swarm Grows (part 3)", questName = "The Swarm Grows",
      ambiguous = true, zone = "Thousand Needles", location = "Ironstone Camp", atLevel = 31,
      logCount = 14, x = 67.6, y = 64.0,
    },
    {
      type = "manual", name = "Sparkleshell Tortoise: Turtle Meat x10",
      zone = "Thousand Needles", location = "Shimmering Flats", atLevel = 31, logCount = 14,
      x = 76.0, y = 57.0, approx = true,
      note = "Start collecting this now - it drops over the whole leg, not in one spot.",
    },
    {
      type = "complete", questName = "Rocket Car Parts", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 31, logCount = 14, x = 76.0, y = 57.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "A Bump in the Road", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 31, logCount = 14, x = 76.0, y = 57.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Load Lightening", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 31, logCount = 14, x = 86.0, y = 64.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Hardened Shells", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 32, logCount = 14, x = 82.0, y = 55.5,
      approx = true,
    },
    {
      type = "complete", questName = "Salt Flat Venom", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 32, logCount = 14, x = 76.0, y = 57.0,
      approx = true,
    },
    {
      type = "complete", name = "The Swarm Grows (part 3)", questName = "The Swarm Grows",
      ambiguous = true, zone = "Thousand Needles", location = "The Rustmaul Dig Site",
      atLevel = 32, logCount = 14, x = 70.0, y = 82.0, approx = true,
    },
    {
      type = "turnin", name = "The Swarm Grows (part 3)", questName = "The Swarm Grows",
      ambiguous = true, zone = "Thousand Needles", location = "Ironstone Camp", atLevel = 32,
      logCount = 13, x = 67.6, y = 64.0,
    },
    {
      type = "accept", name = "Parts of the Swarm (part 1)", questName = "Parts of the Swarm",
      ambiguous = true, zone = "Thousand Needles", location = "The Rustmaul Dig Site",
      atLevel = 32, logCount = 14, x = 70.0, y = 82.0, approx = true,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", name = "Parts of the Swarm (part 1)",
      questName = "Parts of the Swarm", ambiguous = true, zone = "Thousand Needles",
      location = "The Rustmaul Dig Site", atLevel = 32, logCount = 14, x = 70.0, y = 82.0,
      approx = true,
    },
    {
      type = "complete", questName = "Rocket Car Parts", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 32, logCount = 14, x = 79.0, y = 87.0,
      approx = true,
    },
    {
      type = "complete", questName = "A Bump in the Road", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 32, logCount = 14, x = 79.0, y = 87.0,
      approx = true,
    },
    {
      type = "complete", questName = "Load Lightening", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 32, logCount = 14, x = 86.0, y = 64.0,
      approx = true,
    },
    {
      type = "manual", name = "Sparkleshell Tortoise: Turtle Meat x10",
      zone = "Thousand Needles", location = "Shimmering Flats", atLevel = 32, logCount = 14,
      x = 86.0, y = 64.0, approx = true, note = "You should have the full stack by now.",
    },
    {
      type = "manual", name = "Kill until 34100/54500 xp into Lvl 32",
      zone = "Thousand Needles", location = "Shimmering Flats", atLevel = 32, logCount = 14,
      x = 86.0, y = 64.0, approx = true,
    },
    {
      type = "turnin", questName = "Rocket Car Parts", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 13, x = 77.8, y = 77.2,
    },
    {
      type = "turnin", questName = "Parts for Kravel", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 12, x = 77.8, y = 77.2,
    },
    {
      type = "accept", questName = "Delivery to the Gnomes", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 13, x = 77.8, y = 77.2,
    },
    {
      type = "turnin", questName = "Salt Flat Venom", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 12, x = 78.0, y = 77.0,
    },
    {
      type = "turnin", questName = "Delivery to the Gnomes", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 11, x = 78.0, y = 77.0,
    },
    {
      type = "accept", questName = "The Rumormonger", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 12, x = 77.8, y = 77.2,
    },
    {
      type = "turnin", questName = "Hardened Shells", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 11, x = 78.0, y = 77.0,
    },
    {
      type = "note", name = "Skip: E",
      note = "The route deliberately skips Encrusted Tail Fins. Low XP for the travel time.",
      zone = "Thousand Needles", location = "Mirage Raceway", atLevel = 32, x = 78.0, y = 77.0,
    },
    {
      type = "accept", questName = "Martek the Exiled", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 12, x = 78.0, y = 77.0,
    },
    {
      type = "turnin", questName = "Load Lightening", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 11, x = 80.0, y = 75.8,
    },
    {
      type = "accept", name = "Goblin Sponsorship (part 1)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "Thousand Needles", location = "Mirage Raceway", atLevel = 32,
      logCount = 12, x = 80.0, y = 75.8,
    },
    {
      type = "turnin", questName = "A Bump in the Road", zone = "Thousand Needles",
      location = "Mirage Raceway", atLevel = 32, logCount = 11, x = 81.6, y = 77.8,
    },
    {
      type = "travel", name = "Bulkrek Ragefist <Wind Rider Master>", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 32, logCount = 11, x = 51.6, y = 25.4,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Gadgetzan to Freewind Post", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 32, logCount = 11, x = 51.6, y = 25.4,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Grimtotem Spying", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 32, logCount = 10, x = 45.6, y = 50.6,
    },
    {
      type = "turnin", questName = "Wanted - Arnak Grimtotem", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 32, logCount = 9, x = 45.6, y = 50.6,
    },
    {
      type = "accept", questName = "Family Tree", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 32, logCount = 10, x = 45.6, y = 50.6,
    },
    {
      type = "turnin", questName = "Free at Last", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 33, logCount = 9, x = 46.0, y = 51.6,
    },
    {
      type = "hearth", name = "Hearth to Thunder Bluff", zone = "Thousand Needles",
      location = "Freewind Post", atLevel = 33, logCount = 9, x = 46.0, y = 51.6,
      note = "Use your hearthstone.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", atLevel = 33,
      logCount = 9, note = "Several spots around here - check the whole area.",
    },
})

