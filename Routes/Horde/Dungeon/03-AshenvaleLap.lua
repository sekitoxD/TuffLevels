-- TuFFlevels / Routes/Horde/Dungeon/03-AshenvaleLap.lua
--
-- Part 3 of the 5-man Horde 1-60 dungeon route.
-- Sections: Ashenvale Lap (level 24-28) | Charred Vale (level 24-28) | Southern Barrens Lap (level 24-28) | Camp Turd to Thousand Needles (level 24-28) | Thousand Needles Lap (level 24-28) | Hillsbrad Lap #2 (level 28-29) | Hillsbrad round 2 (level 28-29) | Razor Fen Kraul Farm (level 29-31) | Razor Fen Kraul Farm (level 32-33)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(3, {

    { type = "section", name = "Ashenvale Lap (level 24-28)", levels = { 24, 28 }, zone = "Ashenvale" },
    {
      type = "accept", questName = "Ashenvale Outrunners", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 12,
    },
    {
      type = "note", name = "Skip: Warsong Supplies",
      note = "The route deliberately skips Warsong Supplies.", zone = "Ashenvale",
      location = "Splintertree Outpost",
    },
    {
      type = "turnin", name = "The Ashenvale Hunt (part 1)", questName = "The Ashenvale Hunt",
      ambiguous = true, zone = "Ashenvale", location = "Splintertree Outpost", logCount = 11,
    },
    {
      type = "accept", name = "The Ashenvale Hunt (part 2)", questName = "The Ashenvale Hunt",
      ambiguous = true, zone = "Ashenvale", location = "Splintertree Outpost", logCount = 12,
    },
    {
      type = "turnin", name = "The Ashenvale Hunt (part 2)", questName = "The Ashenvale Hunt",
      ambiguous = true, zone = "Ashenvale", location = "Splintertree Outpost", logCount = 11,
    },
    {
      type = "turnin", questName = "Freedom to Ruul", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 10,
    },
    {
      type = "accept", questName = "Stonetalon Standstill", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 11,
    },
    {
      type = "note", name = "Skip: Satyr Horns",
      note = "The route deliberately skips Satyr Horns. Note: Collection, quest low drop, not worth the time.",
      zone = "Ashenvale", location = "Splintertree Outpost",
    },
    {
      type = "travel", name = "Vhulgra <Wind Rider Master>", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 11,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "complete", name = "The Sacred Flame (part 1)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Ashenvale", location = "Raynewood Retreat", logCount = 11,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Ordanus", zone = "Ashenvale",
      location = "Raynewood Retreat", logCount = 11,
    },
    {
      type = "accept", questName = "Shadumbra's Head", zone = "Ashenvale",
      location = "Raynewood Retreat", logCount = 12,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "accept", questName = "Ursangous's Paw", zone = "Ashenvale",
      location = "Talondeep Path", logCount = 13,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "complete", questName = "Stonetalon Standstill", zone = "Ashenvale",
      location = "Mystral Lake", logCount = 13,
    },
    {
      type = "accept", questName = "The Befouled Element", zone = "Ashenvale",
      location = "Mystral Lake", logCount = 14,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "complete", name = "The Sacred Flame (part 1)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Ashenvale", location = "Moonwell", logCount = 14,
    },
    {
      type = "accept", questName = "Torek's Assault", zone = "Ashenvale",
      location = "Silverwing Outpost", logCount = 15,
    },
    {
      type = "complete", questName = "Torek's Assault", zone = "Ashenvale",
      location = "Silverwing Outpost", logCount = 15,
    },
    {
      type = "accept", questName = "Sharptalon's Claw", zone = "Ashenvale",
      location = "Nightsong Woods", logCount = 16,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "complete", questName = "Ashenvale Outrunners", zone = "Ashenvale",
      location = "Dor'Danil Barrow Den", logCount = 16,
    },
    {
      type = "note", name = "Skip: The Lost Pages",
      note = "The route deliberately skips The Lost Pages.", zone = "Ashenvale",
      location = "Splintertree Outpost",
    },
    {
      type = "turnin", questName = "Ashenvale Outrunners", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 15,
    },
    {
      type = "turnin", questName = "Torek's Assault", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 14,
    },
    {
      type = "turnin", questName = "Ursangous's Paw", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 13,
    },
    {
      type = "turnin", questName = "Sharptalon's Claw", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 12,
    },
    {
      type = "turnin", questName = "Shadumbra's Head", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 11,
    },
    {
      type = "accept", questName = "The Hunt Completed", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 12,
    },
    {
      type = "turnin", questName = "The Hunt Completed", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 11,
    },
    {
      type = "turnin", questName = "Stonetalon Standstill", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 10,
    },
    {
      type = "turnin", questName = "The Befouled Element", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 9,
    },
    {
      type = "accept", questName = "Je'neu of the Earthen Ring", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 10,
    },
    {
      type = "travel", name = "Splintertree to Zoram Strand", zone = "Ashenvale",
      location = "Splintertree Outpost", logCount = 10, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Between a Rock and a Thistlefur", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 9,
    },
    {
      type = "note", name = "Skip: King of the Foulweald",
      note = "The route deliberately skips King of the Foulweald.", zone = "Ashenvale",
      location = "Zoram Strand",
    },
    { type = "turnin", questName = "Troll Charm", zone = "Ashenvale", location = "Zoram Strand", logCount = 8 },
    {
      type = "turnin", questName = "Je'neu of the Earthen Ring", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 7,
    },
    {
      type = "accept", questName = "Amongst the Ruins", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 8,
    },
    {
      type = "accept", questName = "The Essence of Aku'Mai", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 9,
      note = "Note: Maybe... if you get enough, pick your lowest xp person to do this.",
    },
    {
      type = "accept", name = "Allegiance to the Old Gods (part 1)",
      questName = "Allegiance to the Old Gods", ambiguous = true, zone = "Ashenvale",
      location = "BFD", logCount = 10,
    },
    {
      type = "note", name = "Note",
      note = "Note: Drops off Tide Priests outside of instance, then go turn it back into Zoram before BFD, progress Aku'mai too",
    },
    {
      type = "turnin", name = "Allegiance to the Old Gods (part 1)",
      questName = "Allegiance to the Old Gods", ambiguous = true, zone = "Ashenvale",
      location = "Zoram Strand", logCount = 9,
    },
    {
      type = "accept", name = "Allegiance to the Old Gods (part 2)",
      questName = "Allegiance to the Old Gods", ambiguous = true, zone = "Ashenvale",
      location = "Zoram Strand", logCount = 10,
    },
    { type = "note", name = "Note", note = "One Full Quest run of BFD" },
    {
      type = "accept", questName = "Blackfathom Villainy", zone = "Blackfathom Deeps",
      location = "The Pool of Ask'ar", logCount = 11,
    },
    {
      type = "note", name = "Note",
      note = "Note: The quest giver for Blackfathom Villany is inside, in a side room by the turtle boss !!DONT MISS!!",
    },
    {
      type = "accept", questName = "Baron Aquanis", zone = "Ashenvale", location = "BFD",
      logCount = 12,
      note = "Starts from an item you loot, not from an NPC. Note: drops off of Baron Aquanis while getting fathomcore.",
    },
    {
      type = "turnin", questName = "Amongst the Ruins", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 11,
    },
    {
      type = "turnin", questName = "The Essence of Aku'Mai", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 10, note = "Note: Maybe... if you got enough",
    },
    {
      type = "turnin", name = "Allegiance to the Old Gods (part 2)",
      questName = "Allegiance to the Old Gods", ambiguous = true, zone = "Ashenvale",
      location = "Zoram Strand", logCount = 9,
    },
    { type = "turnin", questName = "Baron Aquanis", zone = "Ashenvale", location = "Zoram Strand", logCount = 8 },
    {
      type = "hearth", name = "Hearth to Sun Rock Retreat", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 8, note = "Use your hearthstone.",
    },

    { type = "section", name = "Charred Vale (level 24-28)", levels = { 24, 28 }, zone = "Stonetalon Mts" },
    {
      type = "accept", questName = "Calling in the Reserves", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 9,
    },
    {
      type = "accept", questName = "Harpies Threaten", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 10,
    },
    {
      type = "turnin", questName = "Ordanus", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 9,
    },
    {
      type = "accept", questName = "New Life", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 10,
    },
    {
      type = "note", name = "Skip: Elemental War",
      note = "The route deliberately skips Elemental War.", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat",
    },
    {
      type = "note", name = "Skip: The Den", note = "The route deliberately skips The Den.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat",
    },
    {
      type = "complete", questName = "New Life", zone = "Stonetalon Mts",
      location = "The Charred Vale", logCount = 10,
    },
    {
      type = "complete", questName = "Harpies Threaten", zone = "Stonetalon Mts",
      location = "The Charred Vale", logCount = 10,
    },
    {
      type = "turnin", questName = "New Life", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 9,
    },
    {
      type = "turnin", questName = "Harpies Threaten", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 8,
    },
    {
      type = "accept", questName = "Bloodfury Bloodline", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 9,
    },
    {
      type = "complete", questName = "Bloodfury Bloodline", zone = "Stonetalon Mts",
      location = "The Charred Vale", logCount = 9,
    },
    {
      type = "turnin", questName = "Bloodfury Bloodline", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 8,
    },
    {
      type = "travel", name = "Sun Rock Retreat to Thunder Bluff", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 8, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Blackfathom Villainy", zone = "Blackfathom Deeps",
      location = "The Pool of Ask'ar", logCount = 7,
    },
    {
      type = "turnin", name = "The Sacred Flame (part 1)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thunder Bluff", logCount = 6,
    },
    {
      type = "accept", name = "The Sacred Flame (part 2)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thunder Bluff", logCount = 7,
    },
    { type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", logCount = 7 },
    {
      type = "turnin", questName = "The Flying Machine Airport", zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 6,
    },
    {
      type = "travel", name = "Thunder Bluff to Camp Taurajo", zone = "Thunder Bluff",
      logCount = 6, note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Camp Taurajo", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 6, note = "Bind your hearthstone here.",
    },

    { type = "section", name = "Southern Barrens Lap (level 24-28)", levels = { 24, 28 }, zone = "The Barrens" },
    {
      type = "accept", name = "Betrayal from Within (part 1)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "Camp Taurajo", logCount = 7,
    },
    {
      type = "accept", questName = "Weapons of Choice", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 8,
    },
    { type = "turnin", questName = "Ishamuhale", zone = "The Barrens", location = "Camp Taurajo", logCount = 7 },
    {
      type = "accept", questName = "Enraged Thunder Lizards", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 8,
    },
    {
      type = "accept", questName = "Owatanka", zone = "The Barrens", location = "Bramblescar",
      logCount = 9, note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "turnin", questName = "Enraged Thunder Lizards", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 8,
    },
    {
      type = "accept", questName = "Cry of the Thunderhawk", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 9,
    },
    { type = "turnin", questName = "Owatanka", zone = "The Barrens", location = "Camp Taurajo", logCount = 8 },
    {
      type = "note", name = "Note",
      note = "Note: kill all the thunderhawks along the way to get quest item for 5 people.",
    },
    {
      type = "complete", questName = "Egg Hunt", zone = "The Barrens",
      location = "Field of Giants", logCount = 8,
    },
    {
      type = "accept", questName = "The Harvester", zone = "The Barrens",
      location = "Field of Giants", logCount = 9,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "accept", questName = "Gann's Reclamation", zone = "The Barrens",
      location = "South Gold Road", logCount = 10,
    },
    {
      type = "accept", questName = "Washte Pawne", zone = "The Barrens",
      location = "Blackthorn Ridge", logCount = 11,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "complete", questName = "Weapons of Choice", zone = "The Barrens",
      location = "Blackthorn Ridge", logCount = 11,
    },
    {
      type = "complete", name = "Betrayal from Within (part 1)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "Blackthorn Ridge", logCount = 11,
    },
    {
      type = "complete", questName = "Cry of the Thunderhawk", zone = "The Barrens",
      location = "South Gold Road", logCount = 11,
    },
    {
      type = "complete", questName = "Gann's Reclamation", zone = "The Barrens",
      location = "Bael Modan", logCount = 11,
    },
    {
      type = "turnin", questName = "Gann's Reclamation", zone = "The Barrens",
      location = "South Gold Road", logCount = 10,
    },
    {
      type = "accept", name = "Revenge of Gann (part 1)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "South Gold Road", logCount = 11,
    },
    {
      type = "accept", questName = "The Tear of the Moons", zone = "The Barrens",
      location = "Bael Modan", logCount = 12,
    },
    {
      type = "complete", name = "Revenge of Gann (part 1)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "Bael Modan", logCount = 12,
    },
    {
      type = "turnin", name = "Revenge of Gann (part 1)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "South Gold Road", logCount = 11,
    },
    {
      type = "accept", name = "Revenge of Gann (part 2)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "South Gold Road", logCount = 12,
    },
    {
      type = "complete", questName = "The Tear of the Moons", zone = "The Barrens",
      location = "Bael Modan", logCount = 12,
    },
    {
      type = "complete", name = "Revenge of Gann (part 2)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "Bael Modan", logCount = 12,
    },
    {
      type = "turnin", questName = "The Tear of the Moons", zone = "The Barrens",
      location = "Bael Modan", logCount = 11,
    },
    {
      type = "turnin", name = "Revenge of Gann (part 2)", questName = "Revenge of Gann",
      ambiguous = true, zone = "The Barrens", location = "South Gold Road", logCount = 10,
    },
    {
      type = "hearth", name = "Hearth to Camp Taurajo", zone = "The Barrens",
      location = "South Gold Road", logCount = 10, note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Weapons of Choice", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 9,
    },
    {
      type = "turnin", questName = "Cry of the Thunderhawk", zone = "The Barrens",
      location = "South Gold Road", logCount = 8,
    },
    {
      type = "accept", questName = "Mahren Skyseer", zone = "The Barrens",
      location = "South Gold Road", logCount = 9,
    },
    {
      type = "note", name = "Skip: A New Ore Sample",
      note = "The route deliberately skips A New Ore Sample.", zone = "The Barrens",
      location = "Camp Taurajo",
    },
    {
      type = "turnin", questName = "The Harvester", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 8,
    },
    {
      type = "turnin", questName = "Washte Pawne", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 7,
    },
    {
      type = "turnin", name = "Betrayal from Within (part 1)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "Camp Taurajo", logCount = 6,
    },
    {
      type = "accept", name = "Betrayal from Within (part 2)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "Camp Taurajo", logCount = 7,
    },
    {
      type = "travel", name = "Camp Taurajo to The Crossroads", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 7, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Betrayal from Within (part 2)",
      questName = "Betrayal from Within", ambiguous = true, zone = "The Barrens",
      location = "The Crossroads", logCount = 6,
    },
    { type = "turnin", questName = "Egg Hunt", zone = "The Barrens", location = "The Crossroads", logCount = 5 },
    {
      type = "travel", name = "Crossroads to Camp Turajo", zone = "The Barrens",
      location = "The Crossroads", logCount = 5, note = "Take the flight path.",
    },

    {
      type = "section", name = "Camp Turd to Thousand Needles (level 24-28)",
      levels = { 24, 28 }, zone = "The Barrens",
    },
    {
      type = "turnin", questName = "Calling in the Reserves", zone = "The Barrens",
      location = "The Great Lift", logCount = 4,
    },
    {
      type = "accept", questName = "Message to Freewind Post", zone = "The Barrens",
      location = "The Great Lift", logCount = 5,
    },
    {
      type = "travel", name = "Get Freewind Flight Path", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 5, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Wind Rider", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 6,
    },
    {
      type = "turnin", questName = "Message to Freewind Post", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 5,
    },
    {
      type = "accept", questName = "Pacify the Centaur", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 6,
    },
    {
      type = "turnin", name = "The Sacred Flame (part 2)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thousand Needles", location = "Freewind Post", logCount = 5,
    },
    {
      type = "accept", name = "The Sacred Flame (part 3)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thousand Needles", location = "Freewind Post", logCount = 6,
    },
    {
      type = "accept", questName = "Wanted - Arnak Grimtotem", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 7,
    },
    {
      type = "accept", questName = "Test of Faith", zone = "Thousand Needles",
      location = "The Weathered Nook", logCount = 8,
    },
    {
      type = "complete", questName = "Test of Faith", zone = "Thousand Needles",
      location = "The Weathered Nook", logCount = 8,
    },
    {
      type = "turnin", questName = "Test of Faith", zone = "Thousand Needles",
      location = "The Weathered Nook", logCount = 7,
    },
    {
      type = "accept", questName = "Test of Endurance", zone = "Thousand Needles",
      location = "The Weathered Nook", logCount = 8,
    },
    {
      type = "complete", questName = "Pacify the Centaur", zone = "Thousand Needles",
      location = "Splithoof Crag", logCount = 8,
    },
    {
      type = "complete", name = "The Sacred Flame (part 3)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thousand Needles", location = "Splithoof Crag", logCount = 8,
    },
    {
      type = "turnin", questName = "Pacify the Centaur", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 7,
    },
    {
      type = "accept", questName = "Grimtotem Spying", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 8,
    },
    {
      type = "turnin", name = "The Sacred Flame (part 3)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thousand Needles", location = "Freewind Post", logCount = 7,
    },

    {
      type = "section", name = "Thousand Needles Lap (level 24-28)", levels = { 24, 28 },
      zone = "Thousand Needles",
    },
    {
      type = "complete", questName = "Test of Endurance", zone = "Thousand Needles",
      location = "West Thousand Needles", logCount = 7,
      note = "Note: Back of Harpie Cave, open only ONE box at a time.",
    },
    {
      type = "complete", questName = "Wind Rider", zone = "Thousand Needles",
      location = "Highperch", logCount = 7,
      note = "Note: Prio the eggs so you get good respawns!",
    },
    {
      type = "accept", questName = "Homeward Bound", zone = "Thousand Needles",
      location = "Highperch", logCount = 8,
    },
    {
      type = "complete", questName = "Homeward Bound", zone = "Thousand Needles",
      location = "Highperch", logCount = 8,
    },
    {
      type = "complete", questName = "Steelsnap", zone = "Thousand Needles",
      location = "West Thousand Needles", logCount = 8,
      note = "Note: Steelsnap------------------>>>>>",
    },
    {
      type = "turnin", questName = "Homeward Bound", zone = "Thousand Needles",
      location = "Whitereach Post", logCount = 7,
    },
    {
      type = "accept", questName = "Hypercapacitor Gizmo", zone = "Thousand Needles",
      location = "Whitereach Post", logCount = 8,
    },
    {
      type = "complete", questName = "Hypercapacitor Gizmo", zone = "Thousand Needles",
      location = "Camp E'thok", logCount = 8,
    },
    {
      type = "turnin", questName = "Hypercapacitor Gizmo", zone = "Thousand Needles",
      location = "Whitereach Post", logCount = 7,
    },
    {
      type = "turnin", questName = "Test of Endurance", zone = "Thousand Needles",
      location = "The Weathered Nook", logCount = 6,
    },
    {
      type = "accept", questName = "Test of Strength", zone = "Thousand Needles",
      location = "The Weathered Nook", logCount = 7,
    },
    {
      type = "complete", questName = "Grimtotem Spying", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", logCount = 7,
    },
    {
      type = "complete", questName = "Wanted - Arnak Grimtotem", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", logCount = 7,
    },
    {
      type = "accept", questName = "Free at Last", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", logCount = 8, note = "Note: Escort",
    },
    {
      type = "complete", questName = "Free at Last", zone = "Thousand Needles",
      location = "Darkcloud Pinnacle", logCount = 8,
    },
    {
      type = "complete", questName = "Test of Strength", zone = "Thousand Needles",
      location = "West Thousand Needles", logCount = 8,
    },
    {
      type = "turnin", questName = "Test of Strength", zone = "Thousand Needles",
      location = "The Weathered Nook", logCount = 7,
      note = "Note: Rok'Alim the Pounder --------->>>>",
    },
    {
      type = "note", name = "Skip: Test of Lore",
      note = "The route deliberately skips Test of Lore.", zone = "Thousand Needles",
      location = "The Weathered Nook",
    },
    {
      type = "turnin", questName = "Grimtotem Spying", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 6,
    },
    {
      type = "turnin", questName = "Wanted - Arnak Grimtotem", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 5,
    },
    {
      type = "turnin", questName = "Free at Last", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 4,
    },
    {
      type = "turnin", questName = "Wind Rider", zone = "Thousand Needles",
      location = "Freewind Post", logCount = 3,
    },
    {
      type = "accept", questName = "Hemet Nesingwary", zone = "Thousand Needles",
      location = "Mirage Raceway", logCount = 4,
    },
    {
      type = "accept", name = "Wharfmaster Dizzywig (part 2)",
      questName = "Wharfmaster Dizzywig", ambiguous = true, zone = "Thousand Needles",
      location = "Mirage Raceway", logCount = 5,
    },
    {
      type = "accept", questName = "A Bump in the Road", zone = "Thousand Needles",
      location = "Mirage Raceway", logCount = 6,
    },
    {
      type = "complete", questName = "A Bump in the Road", zone = "Thousand Needles",
      location = "Mirage Raceway", logCount = 6,
    },
    {
      type = "turnin", questName = "A Bump in the Road", zone = "Thousand Needles",
      location = "Mirage Raceway", logCount = 5,
    },
    {
      type = "hearth", name = "Hearth to Camp Taurajo", zone = "Thousand Needles",
      location = "Mirage Raceway", logCount = 5, note = "Use your hearthstone.",
    },
    {
      type = "travel", name = "Camp Taurajo to Thunder Bluff", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 5, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Steelsnap", zone = "Thunder Bluff",
      location = "The Hunter Rise", logCount = 4,
    },
    {
      type = "note", name = "Skip: Frostmaw", note = "The route deliberately skips Frostmaw.",
      zone = "Thunder Bluff", location = "The Hunter Rise",
    },
    { type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", logCount = 4 },
    {
      type = "travel", name = "Thunder Bluff to Ratchet", zone = "Thunder Bluff", logCount = 4,
      note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Wharfmaster Dizzywig (part 2)",
      questName = "Wharfmaster Dizzywig", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", logCount = 3,
    },
    {
      type = "note", name = "Skip: Parts for Kravel",
      note = "The route deliberately skips Parts for Kravel.", zone = "The Barrens",
      location = "Ratchet",
    },
    {
      type = "turnin", questName = "Mahren Skyseer", zone = "The Barrens",
      location = "Ratchet", logCount = 2,
      note = "Note: off the island to the north of Ratchet",
    },
    { type = "accept", questName = "Isha Awak", zone = "The Barrens", logCount = 3 },
    { type = "complete", questName = "Isha Awak", zone = "The Barrens", logCount = 3 },
    { type = "turnin", questName = "Isha Awak", zone = "The Barrens", logCount = 2 },
    {
      type = "travel", name = "Ratchet to Orgrimmar", zone = "The Barrens",
      location = "Ratchet", logCount = 2, note = "Take the flight path.",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", logCount = 2, note = "Zeppelin.",
    },
    {
      type = "travel", name = "Undercity to Tarren Mill", zone = "Undercity", logCount = 2,
      note = "Take the flight path.",
    },

    {
      type = "section", name = "Hillsbrad Lap #2 (level 28-29)", levels = { 28, 29 },
      zone = "Hillsbrad Foothills",
    },
    {
      type = "note", name = "Note", note = "Set Hearth to Tarren Mill",
      zone = "Hillsbrad Foothills", location = "Tarren Mill",
    },
    {
      type = "note", name = "Skip: Elixir of Agony (part 1)",
      note = "The route deliberately skips Elixir of Agony (part 1).",
      zone = "Hillsbrad Foothills", location = "Tarren Mill",
    },
    {
      type = "accept", name = "Battle of Hillsbrad (part 1)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 3,
    },
    {
      type = "complete", name = "Battle of Hillsbrad (part 1)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 3,
    },
    {
      type = "accept", name = "Elixir of Pain (part 2)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", logCount = 4,
    },
    {
      type = "turnin", name = "Battle of Hillsbrad (part 1)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 3,
    },
    {
      type = "accept", name = "Battle of Hillsbrad (part 2)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 4,
    },
    {
      type = "accept", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 5,
    },
    {
      type = "accept", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 6,
    },
    {
      type = "complete", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 6,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 6,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "Elixir of Pain (part 2)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Hillsbrad Fields",
      logCount = 5,
    },
    {
      type = "complete", name = "Battle of Hillsbrad (part 2)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 5,
    },
    {
      type = "turnin", name = "Battle of Hillsbrad (part 2)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 4,
    },
    {
      type = "accept", name = "Battle of Hillsbrad (part 3)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 5,
    },
    {
      type = "complete", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 5,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 5,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Battle of Hillsbrad (part 3)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 5,
    },
    {
      type = "turnin", name = "Battle of Hillsbrad (part 3)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 4,
    },
    {
      type = "accept", name = "Battle of Hillsbrad (part 4)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 5,
    },
    {
      type = "complete", name = "Battle of Hillsbrad (part 4)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 5,
    },
    {
      type = "complete", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", logCount = 5,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "Battle of Hillsbrad (part 4)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 4,
    },
    {
      type = "accept", name = "Battle of Hillsbrad (part 5)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 5,
    },

    {
      type = "section", name = "Hillsbrad round 2 (level 28-29)", levels = { 28, 29 },
      zone = "Hillsbrad Foothills",
    },
    {
      type = "complete", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Azurelode Mine", logCount = 5,
    },
    {
      type = "complete", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Azurelode Mine", logCount = 5,
    },
    {
      type = "complete", name = "Battle of Hillsbrad (part 5)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Azurelode Mine", logCount = 5,
    },
    {
      type = "note", name = "Note", note = "Hearth to Tarren Mill",
      zone = "Hillsbrad Foothills", location = "Azurelode Mine",
    },
    {
      type = "turnin", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 4,
    },
    {
      type = "turnin", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 3,
    },
    {
      type = "turnin", name = "Battle of Hillsbrad (part 5)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 2,
    },
    {
      type = "accept", name = "Battle of Hillsbrad (part 6)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 3,
    },
    {
      type = "accept", questName = "Humbert's Sword", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 4,
    },
    {
      type = "note", name = "Skip: Infiltration",
      note = "The route deliberately skips Infiltration.", zone = "Hillsbrad Foothills",
      location = "Tarren Mill",
    },
    {
      type = "note", name = "Skip: The Hammer May Fall",
      note = "The route deliberately skips The Hammer May Fall.", zone = "Hillsbrad Foothills",
      location = "Tarren Mill",
    },
    {
      type = "note", name = "Skip: Prison Break In",
      note = "The route deliberately skips Prison Break In.", zone = "Hillsbrad Foothills",
      location = "Tarren Mill",
    },
    {
      type = "note", name = "Skip: Stone Tokens",
      note = "The route deliberately skips Stone Tokens.", zone = "Hillsbrad Foothills",
      location = "Tarren Mill",
    },
    {
      type = "note", name = "Skip: Hecular's Revenge",
      note = "The route deliberately skips Hecular's Revenge.", zone = "Hillsbrad Foothills",
      location = "Tarren Mill",
    },
    {
      type = "complete", name = "Battle of Hillsbrad (part 6)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Dun Garok", logCount = 4,
    },
    {
      type = "complete", questName = "Humbert's Sword", zone = "Hillsbrad Foothills",
      location = "Dun Garok", logCount = 4, note = "Note: Drops off a random mob",
    },
    {
      type = "turnin", name = "Battle of Hillsbrad (part 6)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 3,
    },
    {
      type = "turnin", questName = "Humbert's Sword", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 2,
    },
    {
      type = "accept", name = "Battle of Hillsbrad (part 7)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 3,
    },
    {
      type = "travel", name = "Tarren Mill to Undercity", zone = "Undercity",
      location = "Trade Quarter", logCount = 3, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "\"Going, Going, Guano!\"", zone = "Undercity",
      location = "Apothocarium", logCount = 4,
      note = "Note: Might not be able to accept till level 30 see below on RFK Farm",
    },
    {
      type = "note", name = "Note",
      note = "Note: Very high probability you will be shy of 30, when you hit 30 in RFK, hearth some one back, summon, then share.",
    },
    {
      type = "turnin", name = "Battle of Hillsbrad (part 7)",
      questName = "Battle of Hillsbrad", ambiguous = true, zone = "Undercity",
      location = "The Royal Quarter", logCount = 3,
    },
    {
      type = "note", name = "Note", note = "Set Hearth to Undercity", zone = "Undercity",
      location = "Trade Quarter",
    },
    {
      type = "travel", name = "Tirisfal Glades to Durator", zone = "Tirisfal Glades",
      location = "Brill", logCount = 3, note = "Zeppelin.",
    },
    { type = "trainer", name = "Class Trainer", zone = "Orgrimmar", logCount = 3 },
    { type = "accept", questName = "Rig Wars", zone = "Orgrimmar", logCount = 4 },
    { type = "accept", questName = "Chief Engineer Scooty", zone = "Orgrimmar", logCount = 5 },
    {
      type = "travel", name = "Orgrimmar To Camp Taurajo", zone = "Orgrimmar", logCount = 5,
      note = "Take the flight path.",
    },
    {
      type = "note", name = "Farm rates",
      note = "Farm throughput from the source sheet - Level 29-30: Ramtusk + Jargba (697 - 523 xp/min, clear 15-20min).",
    },

    { type = "section", name = "Razor Fen Kraul Farm (level 29-31)", levels = { 29, 31 } },
    {
      type = "note", name = "Note",
      note = "Do one clear of boars before Ramtusk, then once escort is done, just do ramtusk and jargba runs till 30",
    },
    {
      type = "note", name = "Note",
      note = "Note: Going, Going, Guano is potentialy a level 30 Quest, have a lock? hearth and get it, summon back. (conflicting reports)  Hearth is in UC so, maybe get another group to share",
    },
    {
      type = "note", name = "Farm rates",
      note = "Farm throughput from the source sheet - Level 30-32: Full Clear (624 - 520 xp/min, clear 25-30min).",
    },

    { type = "section", name = "Razor Fen Kraul Farm (level 32-33)", levels = { 32, 33 } },
    { type = "note", name = "Note", note = "Pushing into SM G yard" },
    {
      type = "accept", name = "An Unholy Alliance (part 1)", questName = "An Unholy Alliance",
      ambiguous = true, zone = "The Barrens", location = "RFK", logCount = 6,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "accept", questName = "Suspicious Hoofprints", zone = "Dustwallow Marsh",
      location = "Shady Rest Inn", logCount = 7,
    },
    {
      type = "accept", questName = "Lieutenant Paval Reethe", zone = "Dustwallow Marsh",
      location = "Shady Rest Inn", logCount = 8,
    },
    {
      type = "accept", name = "The Black Shield (part 1)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Shady Rest Inn", logCount = 9,
    },
    {
      type = "turnin", questName = "Suspicious Hoofprints", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", logCount = 8,
    },
    {
      type = "turnin", questName = "Lieutenant Paval Reethe", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", logCount = 7,
    },
    {
      type = "turnin", name = "The Black Shield (part 1)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      logCount = 6,
    },
    {
      type = "accept", name = "The Black Shield (part 2)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      logCount = 7,
    },
    {
      type = "turnin", name = "The Black Shield (part 2)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      logCount = 6,
    },
    {
      type = "note", name = "Skip: The Black Shield (part 3)",
      note = "The route deliberately skips The Black Shield (part 3).",
      zone = "Dustwallow Marsh", location = "Brackenwall Village",
    },
    {
      type = "travel", name = "Brackenwall Village  to Ratchet", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", logCount = 6, note = "Take the flight path.",
    },
    { type = "turnin", questName = "Blueleaf Tubers", zone = "The Barrens", location = "Ratchet", logCount = 5 },
    {
      type = "travel", name = "Ratchet to Booty Bay", zone = "The Barrens",
      location = "Ratchet", logCount = 5, note = "Boat.",
    },
    {
      type = "turnin", questName = "Chief Engineer Scooty", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 4,
    },
    {
      type = "accept", questName = "Gnomer-gooooone", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 5,
    },
    {
      type = "turnin", questName = "Gnomer-gooooone", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 4,
    },
    { type = "note", name = "Note", note = "Note quest item is behind boss in lockpicking style chest." },
    {
      type = "accept", questName = "Grime-Encrusted Object", zone = "Gnomeregan",
      location = "Gnomergon", logCount = 5,
      note = "Starts from an item you loot, not from an NPC. Note: Drops from any mob in gnomergon",
    },
    {
      type = "accept", questName = "Grime-Encrusted Ring", zone = "Gnomeregan",
      location = "Gnomergon", logCount = 6,
      note = "Starts from an item you loot, not from an NPC. Note: Only drops from Dark Iron Dwarfs.",
    },
    {
      type = "note", name = "Note",
      note = "Reset and zone out, go back in Gnomeregan and go far left to clean room, then escort",
    },
    {
      type = "turnin", questName = "Grime-Encrusted Object", zone = "Gnomeregan",
      location = "Gnomergon", logCount = 5, note = "Note: SParklemtatic in the clean room",
    },
    {
      type = "turnin", questName = "Grime-Encrusted Ring", zone = "Gnomeregan",
      location = "Gnomergon", logCount = 4, note = "Note: SParklemtatic in the clean room",
    },
    {
      type = "accept", questName = "Return of the Ring", zone = "Gnomeregan",
      location = "Gnomergon", logCount = 5,
    },
    {
      type = "accept", questName = "A Fine Mess", zone = "Gnomeregan", location = "Gnomergon",
      logCount = 6,
      note = "Note: escort is right outside east of the clean room in one of the cubbies on the wall",
    },
    {
      type = "complete", questName = "A Fine Mess", zone = "Gnomeregan",
      location = "Gnomergon", logCount = 6,
      note = "Note: Just run to the instance exit and it completes.",
    },
    {
      type = "turnin", questName = "A Fine Mess", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 5,
    },
    {
      type = "accept", questName = "Supply and Demand", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 6,
    },
    {
      type = "note", name = "Skip: Scaring Shaky",
      note = "Do not pick up Scaring Shaky yet - the route comes back for it.",
      zone = "Stranglethorn Vale", location = "Booty Bay",
    },
    {
      type = "note", name = "Skip: Singing Blue Shards",
      note = "The route deliberately skips Singing Blue Shards.", zone = "Stranglethorn Vale",
      location = "Booty Bay",
    },
    {
      type = "note", name = "Skip: Zanzil's Secret",
      note = "The route deliberately skips Zanzil's Secret.", zone = "Stranglethorn Vale",
      location = "Booty Bay",
    },
    {
      type = "accept", questName = "Investigate the Camp", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 7,
    },
    {
      type = "note", name = "Skip: Dream Dust in the Swamp",
      note = "The route deliberately skips Dream Dust in the Swamp.",
      zone = "Stranglethorn Vale", location = "Booty Bay",
    },
    {
      type = "accept", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
    },
    {
      type = "travel", name = "Booty Bay", zone = "Stranglethorn Vale", location = "Booty Bay",
      logCount = 8, note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Booty Bay to Ratchet", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8, note = "Boat.",
    },
    {
      type = "travel", name = "Ratchet to Orgrimmar", zone = "The Barrens",
      location = "Ratchet", logCount = 8, note = "Take the flight path.",
    },
})
