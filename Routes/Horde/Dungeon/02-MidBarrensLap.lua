-- TuFFlevels / Routes/Horde/Dungeon/02-MidBarrensLap.lua
--
-- Part 2 of the 5-man Horde 1-60 dungeon route.
-- Sections: Mid Barrens Lap (level 18-20) | Into Stonetalon (level 18-20) | Out of Stonetalon #1 (level 18-20) | Camp Taurajo to Thunder Bluff to WC (level 21-24) | Silverpine into Hillsbrad Lap with a Quick SFK (level 21-24) | Stonetalon Peak (level 24-28) | Windshear Crag to Zoram Strand (level 24-28)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(2, {

    { type = "section", name = "Mid Barrens Lap (level 18-20)", levels = { 18, 20 }, zone = "The Barrens" },
    { type = "accept", questName = "Egg Hunt", zone = "The Barrens", location = "The Crossroads", logCount = 17 },
    {
      type = "turnin", questName = "Harpy Lieutenants", zone = "The Barrens",
      location = "The Crossroads", logCount = 16,
    },
    {
      type = "accept", questName = "Serena Bloodfeather", zone = "The Barrens",
      location = "The Crossroads", logCount = 17,
    },
    {
      type = "turnin", questName = "Echeyakee", zone = "The Barrens",
      location = "The Crossroads", logCount = 16,
    },
    {
      type = "accept", questName = "The Angry Scytheclaws", zone = "The Barrens",
      location = "The Crossroads", logCount = 17,
    },
    {
      type = "turnin", questName = "The Stagnant Oasis", zone = "The Barrens",
      location = "The Crossroads", logCount = 16,
    },
    {
      type = "accept", questName = "Altered Beings", zone = "The Barrens",
      location = "The Crossroads", logCount = 17,
    },
    {
      type = "complete", questName = "Serena Bloodfeather", zone = "The Barrens",
      location = "The Dry Hills", logCount = 17,
    },
    {
      type = "turnin", questName = "The Spirits of Stonetalon", zone = "The Barrens",
      location = "Honor's Stand", logCount = 16,
    },
    {
      type = "accept", questName = "Avenge My Village", zone = "The Barrens",
      location = "Honor's Stand", logCount = 17,
    },
    {
      type = "complete", questName = "Avenge My Village", zone = "Stonetalon Mts",
      location = "Camp Aparaje", logCount = 17,
    },
    {
      type = "hearth", name = "Hearth to The Crossroads", zone = "The Barrens",
      location = "Ashenvale Border", logCount = 17, note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Serena Bloodfeather", zone = "The Barrens",
      location = "The Crossroads", logCount = 16,
    },
    {
      type = "accept", questName = "Letter to Jin'Zil", zone = "The Barrens",
      location = "The Crossroads", logCount = 17,
    },
    {
      type = "complete", questName = "Altered Beings", zone = "The Barrens",
      location = "The Stagnant Oasis", logCount = 17,
    },
    {
      type = "complete", questName = "Verog the Dervish", zone = "The Barrens",
      location = "The Stagnant Oasis", logCount = 17, note = "1",
    },
    {
      type = "complete", questName = "The Angry Scytheclaws", zone = "The Barrens",
      location = "Raptor Nests", logCount = 17,
    },
    {
      type = "complete", questName = "Lost in Battle", zone = "The Barrens",
      location = "Gold Road", logCount = 17,
    },
    { type = "accept", questName = "Lakota'mani", zone = "The Barrens", location = "Bramblescar", logCount = 18 },
    {
      type = "note", name = "Skip: Weapons of Choice",
      note = "Do not pick up Weapons of Choice yet - the route comes back for it.",
      zone = "The Barrens", location = "Camp Taurajo",
    },
    {
      type = "turnin", questName = "Lakota'mani", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 17,
    },
    {
      type = "accept", questName = "Tribes at War", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 18,
    },
    { type = "note", name = "Note", note = "Note: should be able to trigger overspawns with the quillboars" },
    {
      type = "complete", questName = "Tribes at War", zone = "The Barrens",
      location = "Agama'gor", logCount = 18,
    },
    {
      type = "complete", questName = "Consumed by Hatred", zone = "The Barrens",
      location = "Agama'gor", logCount = 18,
    },
    { type = "note", name = "Note", note = "Note:Save 11 blood sharts!" },
    {
      type = "complete", questName = "Stolen Silver", zone = "The Barrens",
      location = "Raptor Grounds", logCount = 18,
    },
    {
      type = "complete", questName = "The Guns of Northwatch", zone = "The Barrens",
      location = "Northwatch Hold", logCount = 18,
    },
    {
      type = "note", name = "Skip: Free From the Hold",
      note = "The route deliberately skips Free From the Hold. Super low xppm, dont do it you clown.",
      zone = "The Barrens", location = "Northwatch Hold",
    },
    {
      type = "turnin", questName = "The Guns of Northwatch", zone = "The Barrens",
      location = "Ratchet", logCount = 17,
    },
    {
      type = "turnin", name = "Chen's Empty Keg (part 2)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", logCount = 16,
    },
    {
      type = "note", name = "Skip: Chen's Empty Keg (part 3)",
      note = "The route deliberately skips Chen's Empty Keg (part 3).", zone = "The Barrens",
      location = "Ratchet",
    },
    {
      type = "note", name = "Note",
      note = "If you have Chens keg done by this time great do #3, if not dont worry its not the best xp",
    },
    { type = "turnin", questName = "Raptor Horns", zone = "The Barrens", location = "Ratchet", logCount = 15 },
    { type = "accept", questName = "Smart Drinks", zone = "The Barrens", location = "Ratchet", logCount = 16 },
    {
      type = "accept", questName = "Trouble at the Docks", zone = "The Barrens",
      location = "Ratchet", logCount = 17,
    },
    { type = "turnin", questName = "The Escape", zone = "The Barrens", location = "Ratchet", logCount = 16 },
    {
      type = "travel", name = "Ratchet to The Crossroads", zone = "The Barrens",
      location = "Ratchet", logCount = 16, note = "Take the flight path.",
    },
    {
      type = "note", name = "Skip: Report to Kadrak",
      note = "The route deliberately skips Report to Kadrak.", zone = "The Barrens",
      location = "The Crossroads",
    },
    {
      type = "turnin", questName = "Stolen Silver", zone = "The Barrens",
      location = "The Crossroads", logCount = 15,
    },
    {
      type = "turnin", questName = "The Angry Scytheclaws", zone = "The Barrens",
      location = "The Crossroads", logCount = 14,
    },
    {
      type = "accept", questName = "Jorn Skyseer", zone = "The Barrens",
      location = "The Crossroads", logCount = 15,
    },
    {
      type = "turnin", questName = "Consumed by Hatred", zone = "The Barrens",
      location = "The Crossroads", logCount = 14,
    },
    {
      type = "turnin", questName = "Lost in Battle", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "turnin", questName = "Altered Beings", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "accept", questName = "Hamuul Runetotem", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "accept", questName = "Mura Runetotem", zone = "The Barrens",
      location = "The Crossroads", logCount = 14,
    },

    { type = "section", name = "Into Stonetalon (level 18-20)", levels = { 18, 20 }, zone = "The Barrens" },
    {
      type = "hearth", name = "Set Hearth to The Crossroads", zone = "The Barrens",
      location = "The Crossroads", logCount = 14, note = "Bind your hearthstone here.",
    },
    {
      type = "turnin", questName = "Verog the Dervish", zone = "The Barrens",
      location = "West of Crossroads", logCount = 13,
    },
    {
      type = "accept", questName = "Hezrul Bloodmark", zone = "The Barrens",
      location = "West of Crossroads", logCount = 14,
    },
    {
      type = "complete", questName = "Hezrul Bloodmark", zone = "The Barrens",
      location = "Lushwater Oasis", logCount = 14,
    },
    {
      type = "turnin", questName = "Hezrul Bloodmark", zone = "The Barrens",
      location = "West of Crossroads", logCount = 13,
    },
    {
      type = "accept", questName = "Counterattack!", zone = "The Barrens",
      location = "West of Crossroads", logCount = 14,
    },
    {
      type = "complete", questName = "Counterattack!", zone = "The Barrens",
      location = "West of Crossroads", logCount = 14,
    },
    {
      type = "turnin", questName = "Counterattack!", zone = "The Barrens",
      location = "West of Crossroads", logCount = 13,
    },
    {
      type = "accept", questName = "Goblin Invaders", zone = "The Barrens",
      location = "Honor's Stand", logCount = 14,
    },
    {
      type = "turnin", questName = "Avenge My Village", zone = "The Barrens",
      location = "Honor's Stand", logCount = 13,
    },
    {
      type = "accept", questName = "Kill Grundig Darkcloud", zone = "The Barrens",
      location = "Honor's Stand", logCount = 14,
    },
    {
      type = "note", name = "Skip: Jin'Zil's Forest Magic",
      note = "The route deliberately skips Jin'Zil's Forest Magic.", zone = "Stonetalon Mts",
      location = "Malaka'Jin",
    },
    {
      type = "turnin", questName = "Letter to Jin'Zil", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "note", name = "Skip: Report to Kadrak",
      note = "The route deliberately skips Report to Kadrak.", zone = "Stonetalon Mts",
      location = "Malaka'Jin",
    },
    {
      type = "accept", questName = "Blood Feeders", zone = "Stonetalon Mts",
      location = "Malaka'Jin", logCount = 14,
    },
    {
      type = "accept", questName = "Arachnophobia", zone = "Stonetalon Mts",
      location = "Webwinder Path", logCount = 15,
    },
    {
      type = "complete", questName = "Blood Feeders", zone = "Stonetalon Mts",
      location = "Webwinder Path", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Arachnophobia", zone = "Stonetalon Mts",
      location = "Sishir Canyon", logCount = 15,
    },
    {
      type = "note", name = "Skip: Elemental War",
      note = "Do not pick up Elemental War yet - the route comes back for it.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat",
    },
    {
      type = "accept", questName = "Boulderslide Ravine", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 16,
    },
    {
      type = "turnin", questName = "Arachnophobia", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 15,
    },
    {
      type = "note", name = "Skip: Harpies Threaten",
      note = "Do not pick up Harpies Threaten yet - the route comes back for it.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat",
    },
    {
      type = "note", name = "Skip: Cycle of Rebirth",
      note = "Do not pick up Cycle of Rebirth yet - the route comes back for it.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat",
    },
    {
      type = "travel", name = "Tharm <Wind Rider Master>", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 15,
      note = "Talk to the flight master and learn this flight point.",
    },

    {
      type = "section", name = "Out of Stonetalon #1 (level 18-20)", levels = { 18, 20 },
      zone = "Stonetalon Mts",
    },
    {
      type = "turnin", questName = "Ziz Fizziks", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 14,
    },
    {
      type = "accept", questName = "Super Reaper 6000", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", questName = "Goblin Invaders", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", questName = "Super Reaper 6000", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", questName = "Blood Feeders", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 15,
    },
    {
      type = "turnin", questName = "Super Reaper 6000", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 14,
    },
    {
      type = "accept", name = "Further Instructions (part 1)",
      questName = "Further Instructions", ambiguous = true, zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", questName = "Boulderslide Ravine", zone = "Stonetalon Mts",
      location = "Boulderslide Ravine", logCount = 15,
    },
    {
      type = "complete", questName = "Kill Grundig Darkcloud", zone = "Stonetalon Mts",
      location = "Camp Aparaje", logCount = 15,
    },
    {
      type = "accept", questName = "Protect Kaya", zone = "Stonetalon Mts",
      location = "Camp Aparaje", logCount = 16,
    },
    {
      type = "complete", questName = "Protect Kaya", zone = "Stonetalon Mts",
      location = "Camp Aparaje", logCount = 16,
    },
    {
      type = "turnin", questName = "Kill Grundig Darkcloud", zone = "The Barrens",
      location = "Honor's Stand", logCount = 15,
    },
    {
      type = "turnin", questName = "Protect Kaya", zone = "The Barrens",
      location = "Honor's Stand", logCount = 14,
    },
    {
      type = "accept", questName = "Kaya's Alive", zone = "The Barrens",
      location = "Honor's Stand", logCount = 15,
    },
    {
      type = "turnin", questName = "Goblin Invaders", zone = "The Barrens",
      location = "Honor's Stand", logCount = 14,
    },
    {
      type = "accept", questName = "Shredding Machines", zone = "The Barrens",
      location = "Honor's Stand", logCount = 15,
    },
    {
      type = "accept", questName = "The Elder Crone", zone = "The Barrens",
      location = "Honor's Stand", logCount = 16,
    },
    {
      type = "hearth", name = "Hearth to The Crossroads", zone = "The Barrens",
      location = "Honor's Stand", logCount = 16, note = "Use your hearthstone.",
    },

    {
      type = "section", name = "Camp Taurajo to Thunder Bluff to WC (level 21-24)",
      levels = { 21, 24 }, zone = "The Barrens",
    },
    {
      type = "accept", questName = "Apothecary Zamah", zone = "The Barrens",
      location = "The Crossroads", logCount = 17,
    },
    {
      type = "travel", name = "The Crossroads to Camp Taurajo", zone = "The Barrens",
      location = "The Crossroads", logCount = 17, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Jorn Skyseer", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 16,
    },
    { type = "accept", questName = "Ishamuhale", zone = "The Barrens", location = "Camp Taurajo", logCount = 17 },
    {
      type = "accept", questName = "Melor Sends Word", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 18,
    },
    {
      type = "turnin", questName = "Tribes at War", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 17,
    },
    {
      type = "accept", questName = "Blood Shards of Agamaggan", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 18,
    },
    {
      type = "turnin", questName = "Blood Shards of Agamaggan", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 17,
    },
    {
      type = "note", name = "Skip: Betrayal from Within (part 1)",
      note = "Do not pick up Betrayal from Within (part 1) yet - the route comes back for it.",
      zone = "The Barrens", location = "Camp Taurajo",
    },
    {
      type = "accept", questName = "Spirit of the Wind",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Barrens", location = "Camp Taurajo",
    },
    {
      type = "turnin", questName = "Spirit of the Wind", zone = "The Barrens",
      location = "Camp Taurajo", logCount = 17,
    },
    {
      type = "accept", name = "The Ashenvale Hunt (part 1)", questName = "The Ashenvale Hunt",
      ambiguous = true, zone = "Thunder Bluff", logCount = 18,
      note = "Note: Main area when you first walk into TB",
    },
    {
      type = "turnin", questName = "Melor Sends Word", zone = "Thunder Bluff",
      location = "The Hunter Rise", logCount = 17,
    },
    {
      type = "note", name = "Skip: Steelsnap",
      note = "Do not pick up Steelsnap yet - the route comes back for it.",
      zone = "Thunder Bluff", location = "The Hunter Rise",
    },
    {
      type = "note", name = "Skip: The Sacred Flame (part 1)",
      note = "Do not pick up The Sacred Flame (part 1) yet - the route comes back for it.",
      zone = "Thunder Bluff",
    },
    {
      type = "turnin", questName = "Searching for the Lost Satchel", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 16,
      note = "Note:only if you were able to get it.",
    },
    {
      type = "turnin", questName = "Testing an Enemy's Strength", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 15,
      note = "Note:only if you were able to get it.",
    },
    {
      type = "turnin", questName = "The Elder Crone", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 14,
    },
    {
      type = "accept", questName = "Forsaken Aid", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 15,
    },
    {
      type = "turnin", questName = "Hamuul Runetotem", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 14,
    },
    {
      type = "accept", questName = "Nara Wildmane", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 15,
    },
    {
      type = "turnin", questName = "Nara Wildmane", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 14,
    },
    {
      type = "accept", questName = "Leaders of the Fang", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 15,
    },
    { type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", logCount = 15 },
    {
      type = "turnin", questName = "Apothecary Zamah", zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 14,
    },
    {
      type = "turnin", questName = "Forsaken Aid", zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 13,
    },
    {
      type = "accept", questName = "Serpentbloom", zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 14,
    },
    {
      type = "accept", questName = "Journey to Tarren Mill", zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 15,
    },
    {
      type = "accept", questName = "Until Death Do Us Part", zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 16,
    },
    {
      type = "travel", name = "Tal <Wind Rider Master>", zone = "Thunder Bluff", logCount = 16,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Thunder Bluff to Cross Roads", zone = "Thunder Bluff",
      logCount = 16, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Deviate Eradication", zone = "The Barrens",
      location = "Above Wailing Caverns", logCount = 17,
    },
    {
      type = "accept", questName = "Deviate Hides", zone = "The Barrens",
      location = "Above Wailing Caverns", logCount = 18,
    },
    {
      type = "note", name = "Note",
      note = "Single Quest run through WC, make sure everyone is looting for deviate hides!",
    },
    {
      type = "note", name = "Note",
      note = "Note: Finish questing for serpentbloom and deviate hides doing this loop (https://www.youtube.com/watch?v=40wgBk0GrNc)",
    },
    { type = "note", name = "Note", note = "The Glowing Shard", zone = "The Barrens", location = "WC" },
    {
      type = "hearth", name = "WC to Crossroads", zone = "The Barrens", location = "WC",
      logCount = 18, note = "Use your hearthstone.",
    },
    {
      type = "travel", name = "Crossroads to Ratchet", zone = "The Barrens",
      location = "Crossroads", logCount = 18, note = "Take the flight path.",
    },
    { type = "turnin", questName = "Smart Drinks", zone = "The Barrens", location = "Ratchet", logCount = 17 },
    { type = "complete", questName = "Ishamuhale", zone = "The Barrens", logCount = 17 },
    {
      type = "accept", questName = "The Glowing Shard", zone = "The Barrens", location = "WC",
      logCount = 18, note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "complete", questName = "The Glowing Shard", zone = "The Barrens",
      location = "Ratchet", logCount = 18,
    },
    {
      type = "turnin", questName = "Trouble at the Docks", zone = "The Barrens",
      location = "Ratchet", logCount = 17,
    },
    {
      type = "turnin", name = "Further Instructions (part 1)",
      questName = "Further Instructions", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", logCount = 16,
    },
    {
      type = "accept", name = "Further Instructions (part 2)",
      questName = "Further Instructions", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", logCount = 17,
    },
    { type = "accept", questName = "Blueleaf Tubers", zone = "The Barrens", location = "Ratchet", logCount = 18 },
    {
      type = "travel", name = "Ratchet to Crossroads", zone = "The Barrens",
      location = "Ratchet", logCount = 18, note = "Take the flight path.",
    },
    { type = "turnin", questName = "Deviate Hides", zone = "The Barrens", location = "Above WC", logCount = 17 },
    {
      type = "turnin", questName = "Deviate Eradication", zone = "The Barrens",
      location = "Above WC", logCount = 16,
    },
    {
      type = "turnin", questName = "The Glowing Shard", zone = "The Barrens",
      location = "Above WC", logCount = 15,
    },
    { type = "accept", questName = "In Nightmares", zone = "The Barrens", location = "Above WC", logCount = 16 },
    {
      type = "travel", name = "Crossroads to Thunderbluff", zone = "The Barrens",
      location = "Crossroads", logCount = 16, note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Thunderbluff", zone = "Thunder Bluff",
      logCount = 16, note = "Bind your hearthstone here.",
    },
    {
      type = "turnin", questName = "Leaders of the Fang", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 15,
    },
    {
      type = "turnin", questName = "In Nightmares", zone = "The Barrens",
      location = "The Elder Rise", logCount = 14,
    },
    {
      type = "turnin", questName = "Serpentbloom", zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 13,
    },
    {
      type = "travel", name = "Thunderbluff to Org", zone = "The Barrens",
      location = "Crossroads", logCount = 13, note = "Take the flight path.",
    },

    {
      type = "section", name = "Silverpine into Hillsbrad Lap with a Quick SFK (level 21-24)",
      levels = { 21, 24 }, zone = "Durotar",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", logCount = 13, note = "Zeppelin.",
    },
    {
      type = "accept", questName = "The Book of Ur", zone = "Undercity",
      location = "Apothecarium", logCount = 14,
    },
    {
      type = "turnin", questName = "The Power to Destroy...", zone = "Undercity",
      location = "The Royal Quarter", logCount = 13,
      note = "Note:only if you were able to get it.",
    },
    { type = "note", name = "Note", note = "Run to Sepulcher" },
    {
      type = "turnin", questName = "Until Death Do Us Part", zone = "Silverpine Forest",
      location = "The Sepulcher", logCount = 12,
    },
    {
      type = "turnin", questName = "Mura Runetotem", zone = "Silverpine Forest",
      location = "The Sepulcher", logCount = 11,
    },
    {
      type = "accept", questName = "Deathstalkers in Shadowfang", zone = "Silverpine Forest",
      location = "The Sepulcher", logCount = 12,
    },
    {
      type = "accept", questName = "Journey to Hillsbrad Foothills",
      zone = "Silverpine Forest", location = "The Sepulcher", logCount = 13,
    },
    {
      type = "accept", questName = "Beren's Peril", zone = "Silverpine Forest",
      location = "The Sepulcher", logCount = 14,
    },
    {
      type = "accept", questName = "Arugal Must Die", zone = "Silverpine Forest",
      location = "The Sepulcher", logCount = 15,
    },
    {
      type = "complete", questName = "Beren's Peril", zone = "Silverpine Forest",
      location = "Beren's Peril", logCount = 15,
    },
    {
      type = "accept", questName = "Time To Strike", zone = "Hillsbrad Foothills",
      location = "Southpoint Tower", logCount = 16,
    },
    {
      type = "travel", name = "Zarise <Bat Handler>", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 16,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "turnin", questName = "Journey to Hillsbrad Foothills",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", logCount = 15,
    },
    {
      type = "turnin", questName = "Journey to Tarren Mill", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 14,
    },
    {
      type = "accept", questName = "Blood of Innocents", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 15,
    },
    {
      type = "accept", name = "Elixir of Suffering (part 1)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 16,
    },
    {
      type = "note", name = "Skip: Elixir of Agony (part 1)",
      note = "The route deliberately skips Elixir of Agony (part 1).",
      zone = "Hillsbrad Foothills", location = "Tarren Mill",
    },
    {
      type = "accept", name = "Elixir of Pain (part 1)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", logCount = 17,
    },
    {
      type = "turnin", questName = "Time To Strike", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 16,
    },
    {
      type = "note", name = "Skip: Battle of Hillsbrad (part 1)",
      note = "Do not pick up Battle of Hillsbrad (part 1) yet - the route comes back for it.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill",
    },
    {
      type = "accept", questName = "WANTED: Syndicate Personnel", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 17,
    },
    {
      type = "accept", questName = "The Rescue", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 18,
    },
    {
      type = "complete", questName = "Elixir of Suffering", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 18,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Blood of Innocents", zone = "Hillsbrad Foothills",
      location = "Durnholde Keep", logCount = 18,
    },
    {
      type = "complete", questName = "WANTED: Syndicate Personnel",
      zone = "Hillsbrad Foothills", location = "Durnholde Keep", logCount = 18,
    },
    {
      type = "complete", questName = "The Rescue", zone = "Hillsbrad Foothills",
      location = "Durnholde Keep", logCount = 18,
    },
    {
      type = "complete", name = "Elixir of Suffering (part 1)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      logCount = 18,
    },
    {
      type = "complete", name = "Elixir of Pain (part 1)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", logCount = 18,
    },
    {
      type = "turnin", name = "Elixir of Suffering (part 1)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 17,
    },
    {
      type = "accept", name = "Elixir of Suffering (part 2)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 18,
    },
    {
      type = "turnin", name = "Elixir of Suffering (part 2)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 17,
    },
    {
      type = "turnin", name = "Elixir of Pain (part 1)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", logCount = 16,
    },
    {
      type = "note", name = "Skip: Elixir of Suffering (part 2)",
      note = "Do not pick up Elixir of Suffering (part 2) yet - the route comes back for it.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill",
    },
    {
      type = "note", name = "Skip: Elixir of Pain (part 2)",
      note = "Do not pick up Elixir of Pain (part 2) yet - the route comes back for it.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill",
    },
    {
      type = "turnin", questName = "WANTED: Syndicate Personnel", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 15,
    },
    {
      type = "turnin", questName = "The Rescue", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 14,
    },
    {
      type = "turnin", questName = "Blood of Innocents", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 13,
    },
    {
      type = "accept", name = "Return to Thunder Bluff (part 1)",
      questName = "Return to Thunder Bluff", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 14,
    },
    {
      type = "travel", name = "Tarren Mill to Sepulcher", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 14, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Beren's Peril", zone = "Silverpine Forest",
      location = "The Sepulcher", logCount = 13,
    },
    { type = "note", name = "Note", note = "One full SFK Clear" },
    {
      type = "turnin", questName = "Deathstalkers in Shadowfang", zone = "Silverpine Forest",
      location = "SFK", logCount = 12,
      note = "Note: He is inside the instance and you complete inside!",
    },
    {
      type = "turnin", questName = "Arugal Must Die", zone = "Silverpine Forest",
      location = "The Sepulcher", logCount = 11,
    },
    {
      type = "travel", name = "The Sepulcher to Undercity", zone = "Silverpine Forest",
      location = "The Sepulcher", logCount = 11, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "The Book of Ur", zone = "Undercity",
      location = "Apothocarium", logCount = 10,
    },
    {
      type = "hearth", name = "Hearth to Thunder Bluff", zone = "Undercity",
      location = "Magic Quarter", logCount = 10, note = "Use your hearthstone.",
    },

    { type = "section", name = "Stonetalon Peak (level 24-28)", levels = { 24, 28 }, zone = "Thunder Bluff" },
    {
      type = "accept", questName = "Steelsnap", zone = "Thunder Bluff",
      location = "The Hunter Rise", logCount = 11,
    },
    {
      type = "accept", name = "The Sacred Flame (part 1)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thunder Bluff", logCount = 12,
    },
    {
      type = "turnin", name = "Return to Thunder Bluff (part 1)",
      questName = "Return to Thunder Bluff", ambiguous = true, zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 11,
    },
    {
      type = "accept", questName = "The Flying Machine Airport", zone = "Thunder Bluff",
      location = "The Spirit Rise", logCount = 12,
    },
    { type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", logCount = 12 },
    {
      type = "travel", name = "Thunder Bluff to Sunrock Retreat", zone = "Thunder Bluff",
      logCount = 12, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Cenarius' Legacy", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 13,
    },
    {
      type = "turnin", questName = "Kaya's Alive", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 12,
    },
    {
      type = "accept", questName = "Cycle of Rebirth", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 13,
    },
    {
      type = "hearth", name = "Set Hearth to Sun Rock Retreat", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 13, note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Trouble in the Deeps", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 14,
    },
    {
      type = "turnin", questName = "Boulderslide Ravine", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 13,
    },
    {
      type = "accept", questName = "Earthen Arise", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 14,
    },
    {
      type = "complete", questName = "Cycle of Rebirth", zone = "Stonetalon Mts",
      location = "Mirkfallon Lake", logCount = 14,
    },
    {
      type = "complete", questName = "Cenarius' Legacy", zone = "Stonetalon Mts",
      location = "Talon Peak", logCount = 14,
    },
    {
      type = "turnin", name = "Further Instructions (part 2)",
      questName = "Further Instructions", ambiguous = true, zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 13,
    },
    {
      type = "accept", questName = "Gerenzo Wrenchwhistle", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 14,
    },
    {
      type = "accept", name = "Gerenzo's Orders (part 1)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", name = "Gerenzo's Orders (part 1)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", logCount = 15,
    },
    {
      type = "turnin", name = "Gerenzo's Orders (part 1)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", logCount = 14,
    },
    {
      type = "accept", name = "Gerenzo's Orders (part 2)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", name = "Gerenzo's Orders (part 2)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", questName = "Gerenzo Wrenchwhistle", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", questName = "The Flying Machine Airport", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 15,
    },
    {
      type = "complete", questName = "Shredding Machines", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 15,
    },
    {
      type = "turnin", name = "Gerenzo's Orders (part 2)", questName = "Gerenzo's Orders",
      ambiguous = true, zone = "Stonetalon Mts", location = "Windshear Crag", logCount = 14,
    },
    {
      type = "turnin", questName = "Gerenzo Wrenchwhistle", zone = "Stonetalon Mts",
      location = "Windshear Crag", logCount = 13,
    },
    {
      type = "complete", questName = "Earthen Arise", zone = "Stonetalon Mts",
      location = "Boulderslide Ravine", logCount = 13,
    },
    {
      type = "turnin", questName = "Blood Feeders", zone = "Stonetalon Mts",
      location = "Malaka'Jin", logCount = 12,
    },
    {
      type = "turnin", questName = "Shredding Machines", zone = "The Barrens",
      location = "Honor's Stand", logCount = 11,
    },
    {
      type = "hearth", name = "Hearth to Sun Rock Retreat", zone = "The Barrens",
      location = "Honor's Stand", logCount = 11, note = "Use your hearthstone.",
    },
    {
      type = "note", name = "Skip: Calling in the Reserves",
      note = "Do not pick up Calling in the Reserves yet - the route comes back for it.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat",
    },
    {
      type = "turnin", questName = "Earthen Arise", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 10,
    },
    {
      type = "turnin", questName = "Cycle of Rebirth", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 9,
    },
    {
      type = "note", name = "Skip: New Life",
      note = "Do not pick up New Life yet - the route comes back for it.",
      zone = "Stonetalon Mts", location = "Sun Rock Retreat",
    },
    {
      type = "turnin", questName = "Cenarius' Legacy", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 8,
    },
    {
      type = "accept", questName = "Ordanus", zone = "Stonetalon Mts",
      location = "Sun Rock Retreat", logCount = 9,
    },

    {
      type = "section", name = "Windshear Crag to Zoram Strand (level 24-28)",
      levels = { 24, 28 }, zone = "Ashenvale",
    },
    {
      type = "travel", name = "Andruk <Wind Rider Master>", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 9,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "accept", questName = "Vorsha the Lasher", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 10,
    },
    {
      type = "accept", questName = "Between a Rock and a Thistlefur", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 11,
    },
    {
      type = "accept", questName = "Naga at the Zoram Strand", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 12,
    },
    { type = "accept", questName = "Troll Charm", zone = "Ashenvale", location = "Zoram Strand", logCount = 13 },
    {
      type = "turnin", questName = "Trouble in the Deeps", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 12,
    },
    {
      type = "note", name = "Skip: Amongst the Ruins",
      note = "Do not pick up Amongst the Ruins yet - the route comes back for it.",
      zone = "Ashenvale", location = "Zoram Strand",
    },
    {
      type = "note", name = "Skip: The Essence of Aku'Mai",
      note = "Do not pick up The Essence of Aku'Mai yet - the route comes back for it.",
      zone = "Ashenvale", location = "Zoram Strand",
    },
    {
      type = "complete", questName = "Vorsha the Lasher", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 12,
    },
    {
      type = "complete", questName = "Naga at the Zoram Strand", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 12,
    },
    {
      type = "turnin", questName = "Vorsha the Lasher", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 11,
    },
    {
      type = "turnin", questName = "Naga at the Zoram Strand", zone = "Ashenvale",
      location = "Zoram Strand", logCount = 10,
    },
    {
      type = "complete", questName = "Troll Charm", zone = "Ashenvale",
      location = "Thistlefur Village", logCount = 10,
    },
    {
      type = "complete", questName = "Between a Rock and a Thistlefur", zone = "Ashenvale",
      location = "Thistlefur Village", logCount = 10,
    },
    {
      type = "accept", questName = "Freedom to Ruul", zone = "Ashenvale",
      location = "Thistlefur Village", logCount = 11,
    },
    {
      type = "complete", questName = "Freedom to Ruul", zone = "Ashenvale",
      location = "Thistlefur Village", logCount = 11,
    },
})
