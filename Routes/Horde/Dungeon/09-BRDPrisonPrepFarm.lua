-- TuFFlevels / Routes/Horde/Dungeon/09-BRDPrisonPrepFarm.lua
--
-- Part 9 of the 5-man Horde 1-60 dungeon route.
-- Sections: BRD Prison Prep & Farm (level 53-54) | BRD Prison Prep & Farm (level 53-54) | BRD Prison Prep & Farm (level 54-55)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(9, {

    {
      type = "section", name = "BRD Prison Prep & Farm (level 53-54)", levels = { 53, 54 },
      zone = "Tirisfal Glades",
    },
    {
      type = "travel", name = "Orgrimmar to Tirisfal", zone = "Tirisfal Glades", logCount = 8,
      note = "Zeppelin.",
    },
    {
      type = "accept", questName = "Vivian Lagrave", zone = "Undercity",
      location = "Apothecarium", logCount = 9,
    },
    {
      type = "travel", name = "Undercity to Kargath", zone = "Undercity",
      location = "Trade Quarter", logCount = 9, note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Kargath", zone = "Badlands", location = "Kargath",
      logCount = 9, note = "Use your hearthstone.",
    },
    { type = "turnin", questName = "Vivian Lagrave", zone = "Badlands", location = "Kargath", logCount = 8 },
    {
      type = "note", name = "Skip: Lost Thunderbrew Recipe",
      note = "Do not pick up Lost Thunderbrew Recipe yet - the route comes back for it.",
      zone = "Badlands", location = "Kargath",
    },
    { type = "accept", questName = "Disharmony of Flame", zone = "Badlands", location = "Kargath", logCount = 9 },
    {
      type = "accept", questName = "KILL ON SIGHT: Dark Iron Dwarves", zone = "Badlands",
      location = "Kargath", logCount = 10, note = "Note: There is TWO Wanted Poster",
    },
    { type = "accept", questName = "Dreadmaul Rock", zone = "Badlands", location = "Kargath", logCount = 11 },
    {
      type = "travel", name = "Kargath to Flame Crest", zone = "Badlands",
      location = "Kargath", logCount = 11, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Tablet of the Seven", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 12,
    },
    {
      type = "complete", questName = "Tablet of the Seven", zone = "Burning Steppes",
      location = "Ruins of Thaurissan", logCount = 12,
    },
    {
      type = "complete", questName = "Dreadmaul Rock", zone = "Burning Steppes",
      location = "Dreadmaul Rock", logCount = 12,
    },
    {
      type = "turnin", questName = "Dreadmaul Rock", zone = "Burning Steppes",
      location = "Dreadmaul Rock", logCount = 11,
    },
    {
      type = "accept", questName = "Krom'Grul", zone = "Burning Steppes",
      location = "Dreadmaul Rock", logCount = 12,
    },
    {
      type = "complete", questName = "Krom'Grul", zone = "Burning Steppes",
      location = "Dreadmaul Rock", logCount = 12,
    },
    {
      type = "accept", name = "A Taste of Flame (part 1)", questName = "A Taste of Flame",
      ambiguous = true, zone = "Burning Steppes", location = "Slither Rock", logCount = 13,
    },
    {
      type = "turnin", name = "A Taste of Flame (part 1)", questName = "A Taste of Flame",
      ambiguous = true, zone = "Burning Steppes", location = "Slither Rock", logCount = 12,
    },
    {
      type = "accept", name = "A Taste of Flame (part 2)", questName = "A Taste of Flame",
      ambiguous = true, zone = "Burning Steppes", location = "Slither Rock", logCount = 13,
    },
    {
      type = "turnin", questName = "Tablet of the Seven", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 12,
    },
    {
      type = "travel", name = "Flame Crest to Kargath", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 12, note = "Take the flight path.",
    },
    { type = "turnin", questName = "Krom'Grul", zone = "Badlands", location = "Kargath", logCount = 11 },
    { type = "note", name = "Note", note = "Run into BRM" },
    {
      type = "complete", questName = "Disharmony of Flame", zone = "Blackrock Mountain",
      location = "outside of BRD", logCount = 11,
      note = "Note: He is the Flame guy outside of BRD patting.",
    },
    {
      type = "complete", questName = "KILL ON SIGHT: Dark Iron Dwarves", zone = "Badlands",
      location = "Kargath", logCount = 11,
    },
    { type = "accept", questName = "Commander Gor'shak", zone = "Badlands", location = "Kargath", logCount = 12 },
    {
      type = "note", name = "Note",
      note = "!!!MAKE SURE EVERYONE COMPLETES QUEST BEFORE ACCEPTING NEXT PART!!!!!",
    },
    {
      type = "turnin", questName = "Commander Gor'shak", zone = "Blackrock Depths",
      location = "BRD", logCount = 11,
    },
    {
      type = "accept", name = "What Is Going On? (part 1)", questName = "What Is Going On?",
      ambiguous = true, zone = "Blackrock Depths", location = "BRD", logCount = 12,
    },
    {
      type = "turnin", name = "What Is Going On? (part 1)", questName = "What Is Going On?",
      ambiguous = true, zone = "Blackrock Depths", location = "BRD", logCount = 11,
    },
    {
      type = "accept", name = "What Is Going On? (part 2)", questName = "What Is Going On?",
      ambiguous = true, zone = "Blackrock Depths", location = "BRD", logCount = 12,
      note = "Note: Kharan Mighthammer is the cell right across from Go'shak",
    },
    {
      type = "turnin", name = "What Is Going On? (part 2)", questName = "What Is Going On?",
      ambiguous = true, zone = "Blackrock Depths", location = "BRD", logCount = 11,
    },
    {
      type = "accept", questName = "The Eastern Kingdom", zone = "Blackrock Depths",
      location = "BRD", logCount = 12,
    },
    {
      type = "hearth", name = "Hearth to Kargath", zone = "Blackrock Depths", location = "BRD",
      logCount = 12, note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Disharmony of Flame", zone = "Badlands",
      location = "Kargath", logCount = 11,
      note = "Note: He is the Flame guy outside of BRD patting.",
    },
    { type = "accept", questName = "Disharmony of Fire", zone = "Badlands", location = "Kargath", logCount = 12 },
    { type = "accept", questName = "The Last Element", zone = "Badlands", location = "Kargath", logCount = 13 },
    {
      type = "turnin", questName = "KILL ON SIGHT: Dark Iron Dwarves", zone = "Badlands",
      location = "Kargath", logCount = 12,
    },
    {
      type = "accept", questName = "KILL ON SIGHT: High Ranking Dark Iron Officials",
      zone = "Badlands", location = "Kargath", logCount = 13,
      note = "Note: Back to the Wanted Poster",
    },
    {
      type = "complete", questName = "Disharmony of Fire", zone = "Blackrock Depths",
      location = "BRD", logCount = 13,
    },
    {
      type = "complete", questName = "KILL ON SIGHT: High Ranking Dark Iron Officials",
      zone = "Blackrock Depths", location = "BRD", logCount = 13,
    },
    {
      type = "complete", name = "A Taste of Flame (part 2)", questName = "A Taste of Flame",
      ambiguous = true, zone = "Blackrock Depths", location = "BRD", logCount = 13,
    },
    { type = "note", name = "Note", note = "If your hearth isnt up, grind till it is. it will be tight." },
    {
      type = "hearth", name = "Hearth to Kargath", zone = "Blackrock Depths", location = "BRD",
      logCount = 13, note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Disharmony of Fire", zone = "Badlands",
      location = "Kargath", logCount = 12,
      note = "Note: He is the Flame guy outside of BRD patting.",
    },
    {
      type = "turnin", questName = "KILL ON SIGHT: High Ranking Dark Iron Officials",
      zone = "Badlands", location = "Kargath", logCount = 11,
    },
    {
      type = "travel", name = "Kargath to Flame Crest", zone = "Badlands",
      location = "Kargath", logCount = 11, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "A Taste of Flame (part 2)", questName = "A Taste of Flame",
      ambiguous = true, zone = "Burning Steppes", location = "Slither Rock", logCount = 10,
    },

    { type = "section", name = "BRD Prison Prep & Farm (level 53-54)", levels = { 53, 54 } },
    { type = "note", name = "Note", note = "Putting Lipstick on a Pig called \"Sunken Temple\"" },
    {
      type = "travel", name = "Flame Crest to Grom'gol", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 10, note = "Take the flight path.",
    },
    { type = "note", name = "Note", note = "Run to Swamp" },
    {
      type = "accept", questName = "Fall from Grace", zone = "Swamp of Sorrows", logCount = 11,
      note = "The Fallen hero Quest, listen to the dialogue.",
    },
    { type = "turnin", questName = "Fall from Grace", zone = "Swamp of Sorrows", logCount = 10 },
    { type = "accept", questName = "The Disgraced One", zone = "Swamp of Sorrows", logCount = 11 },
    {
      type = "turnin", questName = "The Disgraced One", zone = "Swamp of Sorrows",
      location = "Stonard", logCount = 10,
    },
    {
      type = "accept", questName = "The Missing Orders", zone = "Swamp of Sorrows",
      location = "Stonard", logCount = 11,
    },
    {
      type = "turnin", questName = "The Missing Orders", zone = "Swamp of Sorrows",
      location = "Stonard", logCount = 10,
    },
    {
      type = "hearth", name = "Set Hearth to Stonard", zone = "Swamp of Sorrows",
      location = "Stonard", logCount = 10, note = "Use your hearthstone.",
    },
    { type = "note", name = "Note", note = "Get the Flight Path" },
    {
      type = "accept", questName = "The Swamp Talker", zone = "Swamp of Sorrows",
      location = "Stonard", logCount = 11,
    },
    {
      type = "complete", questName = "The Swamp Talker", zone = "Swamp of Sorrows",
      location = "Stagbolg cave", logCount = 11, note = "Note: Murlock in the cave SE Swamp.",
    },
    {
      type = "turnin", questName = "Into the Depths", zone = "Sunken Temple", logCount = 10,
      note = "Note:  You have to go down to the alter first, then back up....",
    },
    {
      type = "turnin", questName = "Secret of the Circle", zone = "Sunken Temple",
      logCount = 9, note = "Note: The order is S, N, SW, SE, NW, NE.",
    },
    { type = "complete", questName = "The God Hakkar", zone = "Sunken Temple", logCount = 9 },
    { type = "complete", questName = "Zapper Fuel", zone = "Sunken Temple", logCount = 9 },
    { type = "complete", questName = "Jammal'an the Prophet", zone = "Sunken Temple", logCount = 9 },
    {
      type = "accept", name = "The Essence of Eranikus (part 1)",
      questName = "The Essence of Eranikus", ambiguous = true, zone = "Sunken Temple",
      logCount = 10, note = "Note: Drops from Eranikus",
    },
    {
      type = "turnin", name = "The Essence of Eranikus (part 1)",
      questName = "The Essence of Eranikus", ambiguous = true, zone = "Sunken Temple",
      logCount = 9, note = "Note The turn in is the Brazier in the back of Eranikus's room.",
    },
    {
      type = "hearth", name = "Hearth to Stonard", zone = "Swamp of Sorrows",
      location = "Stonard", logCount = 9, note = "Use your hearthstone.",
    },
    {
      type = "manual", name = "Oathstone of Ysera's Dragonflight", zone = "Swamp of Sorrows",
      location = "Itharius's Cave", logCount = 9,
      note = "Collect these here. Note go through the dialogue from itharius , he is here---------------------------------->>>",
    },
    {
      type = "accept", name = "The Essence of Eranikus (part 2)",
      questName = "The Essence of Eranikus", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Itharius's Cave", logCount = 10,
      note = "Note: He put the stone in your bag, accept the quest from it.",
    },
    {
      type = "turnin", name = "The Essence of Eranikus (part 2)",
      questName = "The Essence of Eranikus", ambiguous = true, zone = "Swamp of Sorrows",
      location = "Itharius's Cave", logCount = 9,
    },
    {
      type = "note", name = "Skip: In Eranikus' Own Words",
      note = "The route deliberately skips In Eranikus' Own Words.", zone = "Swamp of Sorrows",
      location = "Itharius's Cave",
    },
    { type = "turnin", questName = "The Swamp Talker", zone = "Swamp of Sorrows", logCount = 8 },
    { type = "accept", questName = "A Tale of Sorrow", zone = "Swamp of Sorrows", logCount = 9 },
    { type = "turnin", questName = "A Tale of Sorrow", zone = "Swamp of Sorrows", logCount = 8 },
    { type = "accept", questName = "The Stones That Bind Us", zone = "Swamp of Sorrows", logCount = 9 },
    { type = "complete", questName = "The Stones That Bind Us", zone = "Blasted Lands", logCount = 9 },
    { type = "turnin", questName = "The Stones That Bind Us", zone = "Swamp of Sorrows", logCount = 8 },
    {
      type = "accept", name = "Heroes of Old (part 1)", questName = "Heroes of Old",
      ambiguous = true, zone = "Swamp of Sorrows", logCount = 9,
    },
    {
      type = "turnin", name = "Heroes of Old (part 1)", questName = "Heroes of Old",
      ambiguous = true, zone = "Swamp of Sorrows", logCount = 8,
    },
    {
      type = "accept", name = "Heroes of Old (part 2)", questName = "Heroes of Old",
      ambiguous = true, zone = "Swamp of Sorrows", logCount = 9,
    },
    {
      type = "accept", name = "Heroes of Old (part 3)", ambiguous = true,
      questName = "Heroes of Old",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Swamp of Sorrows",
    },
    {
      type = "turnin", name = "Heroes of Old (part 3)", questName = "Heroes of Old",
      ambiguous = true, zone = "Swamp of Sorrows", logCount = 8,
    },
    {
      type = "accept", questName = "Kirith", zone = "Swamp of Sorrows", logCount = 9,
      note = "Note: Kill the demon dog then he will spawn.",
    },
    {
      type = "turnin", questName = "Kirith", zone = "Swamp of Sorrows",
      location = "Serpents Coil", logCount = 8,
    },
    {
      type = "accept", questName = "The Cover of Darkness", zone = "Swamp of Sorrows",
      location = "Serpents Coil", logCount = 9,
    },
    { type = "turnin", questName = "The Cover of Darkness", zone = "Swamp of Sorrows", logCount = 8 },
    {
      type = "note", name = "Skip: The Demon Hunter",
      note = "The route deliberately skips The Demon Hunter.", zone = "Swamp of Sorrows",
    },
    {
      type = "travel", name = "Stonard to Hinterlands", zone = "Swamp of Sorrows",
      location = "Stonard", logCount = 8, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Jammal'an the Prophet", zone = "The Hinterlands",
      location = "Shadra'alor", logCount = 7,
    },
    {
      type = "complete", questName = "Summoning Shadra", zone = "The Hinterlands",
      location = "Shadra'alor", logCount = 7,
    },
    {
      type = "travel", name = "Hinterlands to Arathi Highlands", zone = "The Hinterlands",
      location = "Hinterlands", logCount = 7, note = "Take the flight path.",
    },
    { type = "note", name = "Note", note = "Learn Next Skill of First aid" },
    {
      type = "travel", name = "Arathi to Tarren Mill", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 7, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Summoning Shadra", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 6,
    },
    {
      type = "accept", questName = "Venom to the Undercity", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 7,
    },
    {
      type = "travel", name = "Tarren Mill to Undercity", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 7, note = "Take the flight path.",
    },

    { type = "section", name = "BRD Prison Prep & Farm (level 54-55)", levels = { 54, 55 } },
    { type = "note", name = "Note", note = "WPL First Pass" },
    { type = "trainer", name = "Class Trainer", zone = "Undercity", logCount = 7 },
    {
      type = "hearth", name = "Set Hearth ro Undercity", zone = "Blackrock Mountain",
      location = "BRD", logCount = 7, note = "Use your hearthstone.",
    },
    { type = "accept", questName = "A Call to Arms: The Plaguelands!", zone = "Undercity", logCount = 8 },
    {
      type = "turnin", questName = "Venom to the Undercity", zone = "Undercity",
      location = "Apothecarium", logCount = 7,
    },
    {
      type = "accept", questName = "The Champion of the Banshee Queen", zone = "Undercity",
      location = "The Royal Quarter", logCount = 8,
    },
    { type = "note", name = "Note", note = "Run to Bulwark" },
    {
      type = "turnin", questName = "A Call to Arms: The Plaguelands!",
      zone = "Tirisfal Glades", location = "The Bulwark", logCount = 7,
    },
    {
      type = "accept", questName = "Scarlet Diversions", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 8,
    },
    {
      type = "manual", name = "Flame in a Bottle", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 8, note = "Collect these here.",
    },
    {
      type = "accept", questName = "Argent Dawn Commission", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 9,
    },
    {
      type = "turnin", questName = "Argent Dawn Commission", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 8,
    },
    {
      type = "accept", name = "A Plague Upon Thee (part 1)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Tirisfal Glades", location = "The Bulwark", logCount = 9,
    },
    {
      type = "accept", questName = "Little Pamela", zone = "Western Plaguelands",
      location = "Sorrow Hill", logCount = 10,
    },
    {
      type = "turnin", questName = "Little Pamela", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 9,
    },
    {
      type = "accept", questName = "Pamela's Doll", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 10,
    },
    {
      type = "complete", questName = "Pamela's Doll", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 10,
      note = "Note:Random Spawns all the houses, need 3 peices.",
    },
    {
      type = "turnin", questName = "Pamela's Doll", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 9,
    },
    {
      type = "accept", questName = "Uncle Carlin", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 10,
    },
    {
      type = "accept", questName = "Auntie Marlene", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 11,
    },
    {
      type = "turnin", questName = "Auntie Marlene", zone = "Western Plaguelands",
      location = "Sorrow Hill", logCount = 10,
    },
    {
      type = "accept", questName = "A Strange Historian", zone = "Western Plaguelands",
      location = "Sorrow Hill", logCount = 11,
    },
    {
      type = "complete", questName = "Scarlet Diversions", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 11,
    },
    {
      type = "turnin", questName = "Scarlet Diversions", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 10,
    },
    {
      type = "accept", questName = "All Along the Watchtowers", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 11,
    },
    {
      type = "accept", questName = "The Scourge Cauldrons", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "turnin", questName = "The Scourge Cauldrons", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 11,
    },
    {
      type = "accept", questName = "Target: Felstone Field", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "complete", questName = "Target: Felstone Field", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 12,
    },
    {
      type = "turnin", questName = "Target: Felstone Field", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 11,
    },
    {
      type = "accept", name = "Return to the Bulwark (part 1)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 12,
    },
    {
      type = "accept", name = "Better Late Than Never (part 1)",
      questName = "Better Late Than Never", ambiguous = true, zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 13, note = "Note: In the House",
    },
    {
      type = "turnin", name = "Better Late Than Never (part 1)",
      questName = "Better Late Than Never", ambiguous = true, zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 12, note = "Note: In the Barn",
    },
    {
      type = "accept", name = "Better Late Than Never (part 2)",
      questName = "Better Late Than Never", ambiguous = true, zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 13,
    },
    {
      type = "turnin", name = "Return to the Bulwark (part 1)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "accept", questName = "Target: Dalson's Tears", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 13,
    },
    {
      type = "complete", questName = "Target: Dalson's Tears", zone = "Western Plaguelands",
      location = "Dalson's Tears", logCount = 13,
    },
    {
      type = "turnin", questName = "Target: Dalson's Tears", zone = "Western Plaguelands",
      location = "Dalson's Tears", logCount = 12,
    },
    {
      type = "accept", name = "Return to the Bulwark (part 2)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Western Plaguelands",
      location = "Dalson's Tears", logCount = 13,
    },
    {
      type = "accept", questName = "Mrs. Dalson's Diary", zone = "Western Plaguelands",
      location = "Dalson's Tears", logCount = 14, note = "Note: yup... its in the barn",
    },
    {
      type = "turnin", questName = "Mrs. Dalson's Diary", zone = "Western Plaguelands",
      location = "Dalson's Tears", logCount = 13,
    },
    {
      type = "manual", name = "Wandering Skeleton: Dalson Outhouse Key",
      zone = "Western Plaguelands", location = "Dalson's Tears", logCount = 13,
      note = "Collect these here. Note: Kill \"Wandering Skeleton\" out back by the outhouse.",
    },
    {
      type = "accept", name = "Locked Away (part 1)", questName = "Locked Away",
      ambiguous = true, zone = "Western Plaguelands", location = "Dalson's Tears",
      logCount = 14, note = "Note: Outhouse in the back behind the house and barn.",
    },
    {
      type = "turnin", name = "Locked Away (part 1)", questName = "Locked Away",
      ambiguous = true, zone = "Western Plaguelands", location = "Dalson's Tears",
      logCount = 13,
    },
    {
      type = "accept", name = "Locked Away (part 2)", questName = "Locked Away",
      ambiguous = true, zone = "Western Plaguelands", location = "Dalson's Tears",
      logCount = 14,
    },
    {
      type = "turnin", name = "Locked Away (part 2)", questName = "Locked Away",
      ambiguous = true, zone = "Western Plaguelands", location = "Dalson's Tears",
      logCount = 13,
    },
    {
      type = "turnin", name = "Return to the Bulwark (part 2)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "accept", questName = "Target: Writhing Haunt", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 13,
    },
    {
      type = "complete", questName = "All Along the Watchtowers", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 13,
      note = "Partial progress - work on this while you are here, then move on. Note: If some one in the party does it, everyone should get credit for it. (in theoery)",
    },
    {
      type = "turnin", questName = "A Strange Historian", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 12,
      note = "Note: Chromie is upstairs in the inn of Andorhal",
    },
    {
      type = "accept", questName = "The Annals of Darrowshire", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 13,
    },
    {
      type = "accept", questName = "A Matter of Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 14,
    },
    {
      type = "complete", questName = "A Matter of Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 14,
    },
    {
      type = "complete", questName = "All Along the Watchtowers", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 14,
    },
    {
      type = "turnin", questName = "A Matter of Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 13,
    },
    {
      type = "accept", questName = "Counting Out Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 14,
    },
    {
      type = "complete", questName = "Counting Out Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 14,
      note = "Note: Little boxes in the old houses on the ground that look like tool boxes.",
    },
    {
      type = "complete", questName = "The Annals of Darrowshire", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 14,
      note = "Note: small X on the spines is the real one, dont loot willy nilly its an easy wipe if you do.",
    },
    {
      type = "turnin", questName = "Counting Out Time", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 13,
    },
    {
      type = "turnin", questName = "The Annals of Darrowshire", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 12,
    },
    {
      type = "accept", questName = "Brother Carlin", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 13,
    },
    {
      type = "turnin", questName = "All Along the Watchtowers", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "note", name = "Skip: Scholomance",
      note = "Do not pick up Scholomance yet - the route comes back for it.",
      zone = "Tirisfal Glades", location = "The Bulwark",
    },
    {
      type = "note", name = "Skip: Alas, Andorhal",
      note = "Do not pick up Alas, Andorhal yet - the route comes back for it.",
      zone = "Tirisfal Glades", location = "The Bulwark",
    },
    {
      type = "complete", questName = "Target: Writhing Haunt", zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 12,
    },
    {
      type = "turnin", questName = "Target: Writhing Haunt", zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 11,
    },
    {
      type = "accept", name = "Return to the Bulwark (part 3)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 12,
    },
    {
      type = "accept", name = "The Wildlife Suffers Too (part 1)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 13, note = "Note :Tauren Dead in the house.",
    },
    { type = "note", name = "Note", note = "Big Dickin in EPL" },
    {
      type = "accept", questName = "Blood Tinged Skies", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 14,
    },
    {
      type = "accept", questName = "Carrion Grubbage", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 15,
      note = "Note: Prio Carrions whenever possible, its the bottle neck!",
    },
    {
      type = "accept", questName = "Demon Dogs", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 16,
    },
    { type = "complete", questName = "Blood Tinged Skies", zone = "Eastern Plaguelands", logCount = 16 },
    {
      type = "complete", questName = "Carrion Grubbage", zone = "Eastern Plaguelands",
      logCount = 16, note = "Note: Prio Carrions whenever possible, its the bottle neck!",
    },
    { type = "complete", questName = "Demon Dogs", zone = "Eastern Plaguelands", logCount = 16 },
    {
      type = "turnin", questName = "Blood Tinged Skies", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 15,
    },
    {
      type = "turnin", questName = "Carrion Grubbage", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 14,
    },
    {
      type = "turnin", questName = "Demon Dogs", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 13,
    },
    {
      type = "accept", questName = "Redemption", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 14,
      note = "Note: READ the quest dummy.... you have to actually /sit",
    },
    {
      type = "turnin", questName = "Redemption", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 13,
    },
    {
      type = "accept", questName = "Of Forgotten Memories", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 14,
    },
    {
      type = "turnin", questName = "The Champion of the Banshee Queen",
      zone = "Eastern Plaguelands", location = "The Marris Stead", logCount = 13,
    },
    {
      type = "accept", questName = "To Kill With Purpose", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 14,
    },
    {
      type = "accept", questName = "Un-Life's Little Annoyances", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 15,
    },
    {
      type = "accept", questName = "The Ranger Lord's Behest", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 16,
    },
    {
      type = "complete", questName = "To Kill With Purpose", zone = "Eastern Plaguelands",
      location = "Corin's Crossing", logCount = 16,
      note = "Note: Ten min timer on quest drop to convert them with mortar and pestal.",
    },
    {
      type = "turnin", questName = "Uncle Carlin", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 15,
    },
    {
      type = "accept", questName = "Defenders of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 16,
    },
    {
      type = "turnin", questName = "Brother Carlin", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 15,
    },
    {
      type = "note", name = "Skip: Heroes of Darrowshire",
      note = "Do not pick up Heroes of Darrowshire yet - the route comes back for it.",
      zone = "Eastern Plaguelands", location = "Light's Hope Chapel",
    },
    {
      type = "accept", questName = "Villains of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 16,
    },
    {
      type = "note", name = "Skip: Plagued Hatchlings",
      note = "The route deliberately skips Plagued Hatchlings.", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel",
    },
    {
      type = "note", name = "Skip: Bolstering Our Defenses",
      note = "The route deliberately skips Bolstering Our Defenses.",
      zone = "Eastern Plaguelands", location = "Light's Hope Chapel",
    },
    {
      type = "note", name = "Skip: Houses of the Holy",
      note = "The route deliberately skips Houses of the Holy.", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel",
    },
    {
      type = "note", name = "Skip: The Archivist",
      note = "The route deliberately skips The Archivist.", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel",
    },
    {
      type = "note", name = "Skip: That's Asking A Lot",
      note = "The route deliberately skips That's Asking A Lot.", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel",
    },
    {
      type = "accept", questName = "Zaeldarr the Outcast", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 17,
    },
    {
      type = "note", name = "Skip: The Restless Souls (part 1)",
      note = "Do not pick up The Restless Souls (part 1) yet - the route comes back for it.",
      zone = "Eastern Plaguelands", location = "Light's Hope Chapel",
    },
    {
      type = "complete", questName = "Villains of Darrowshire", zone = "Eastern Plaguelands",
      location = "Corin's Crossing", logCount = 17,
      note = "Partial progress - work on this while you are here, then move on. Note: Get Shattered Sword of Marduk->>",
    },
    {
      type = "turnin", questName = "To Kill With Purpose", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 16,
    },
    {
      type = "complete", questName = "Zaeldarr the Outcast", zone = "Eastern Plaguelands",
      location = "The Undercroft", logCount = 16, note = "Note: He is downstairs in the crypt",
    },
    {
      type = "accept", questName = "Hameya's Plea", zone = "Eastern Plaguelands",
      location = "The Undercroft", logCount = 17,
      note = "Note: The quest is on the floor of the basement level of the crypt.",
    },
    {
      type = "complete", questName = "Of Forgotten Memories", zone = "Eastern Plaguelands",
      location = "The Undercroft", logCount = 17,
      note = "Note: Loot Grave then \"robbers appear\", only one person loot the grave!",
    },
    {
      type = "turnin", questName = "Of Forgotten Memories", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 16,
    },
    {
      type = "accept", questName = "Of Lost Honor", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 17,
    },
    {
      type = "complete", questName = "Un-Life's Little Annoyances",
      zone = "Eastern Plaguelands", logCount = 17,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Of Lost Honor", zone = "Eastern Plaguelands",
      location = "Northdale", logCount = 17,
      note = "Note: A flag, located in the little waters south of Northdale. Dive down, pick it up",
    },
    {
      type = "complete", questName = "Hameya's Plea", zone = "Eastern Plaguelands",
      location = "Zul'mashar", logCount = 17,
      note = "Note: Hameya patrols around the graveyard  in Zul'Masher",
    },
    {
      type = "complete", questName = "The Ranger Lord's Behest", zone = "Eastern Plaguelands",
      location = "Quel'Lithien Lodge", logCount = 17,
      note = "Note: Quel'Thalas Registry is inside on a bench.",
    },
    {
      type = "complete", name = "A Plague Upon Thee (part 1)",
      questName = "A Plague Upon Thee", ambiguous = true, zone = "Eastern Plaguelands",
      location = "Plaguewood", logCount = 17,
    },
    {
      type = "complete", questName = "Defenders of Darrowshire", zone = "Eastern Plaguelands",
      location = "Plaguewood", logCount = 17,
    },
    {
      type = "complete", questName = "Villains of Darrowshire", zone = "Eastern Plaguelands",
      location = "Blackwood Lake", logCount = 17,
      note = "Note: Horgus Skull is @ bottom of lake ->",
    },
    { type = "complete", questName = "Un-Life's Little Annoyances", zone = "Eastern Plaguelands", logCount = 17 },
    {
      type = "turnin", questName = "Zaeldarr the Outcast", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 16,
    },
    {
      type = "turnin", questName = "Defenders of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 15,
    },
    {
      type = "turnin", questName = "Villains of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 14,
    },
    {
      type = "accept", questName = "Heroes of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 15,
    },
    {
      type = "hearth", name = "Hearth to Undercity", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", logCount = 15, note = "Use your hearthstone.",
    },
    { type = "note", name = "Note", note = "Cleanup pass of WPL & EPL" },
    {
      type = "turnin", name = "Better Late Than Never (part 2)",
      questName = "Better Late Than Never", ambiguous = true, zone = "Undercity",
      logCount = 14,
    },
    { type = "accept", questName = "The Jeremiah Blues", zone = "Undercity", logCount = 15 },
    { type = "turnin", questName = "The Jeremiah Blues", zone = "Undercity", logCount = 14 },
    { type = "accept", questName = "Good Luck Charm", zone = "Undercity", logCount = 15 },
    {
      type = "turnin", name = "Return to the Bulwark (part 3)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 14,
    },
    {
      type = "accept", questName = "Target: Gahrron's Withering", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 15,
    },
    {
      type = "turnin", name = "A Plague Upon Thee (part 1)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Tirisfal Glades", location = "The Bulwark", logCount = 14,
    },
    {
      type = "accept", name = "A Plague Upon Thee (part 2)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Tirisfal Glades", location = "The Bulwark", logCount = 15,
    },
    {
      type = "accept", questName = "Scholomance", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 16,
    },
    {
      type = "accept", questName = "Alas, Andorhal", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 16,
    },
    {
      type = "turnin", questName = "Scholomance", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 15,
    },
    {
      type = "note", name = "Note",
      note = "SHOULD BE LEVEL 55 @ THIS TIME, if not ruroh scooby doo, grind something if you're close.",
    },
    {
      type = "accept", questName = "Skeletal Fragments", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 16,
      note = "Note: Need to be need to be level 55 to Accept",
    },
    {
      type = "complete", questName = "Skeletal Fragments", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 16,
      note = "Partial progress - work on this while you are here, then move on. Note: Wipe the entire field, then turn in Good luck Charm",
    },
    {
      type = "turnin", questName = "Good Luck Charm", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 15,
    },
    {
      type = "accept", questName = "Two Halves Become One", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 16,
    },
    {
      type = "complete", questName = "Two Halves Become One", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 16,
      note = "Note: Drops off Jabbering Ghoul (has a pitchfork, and blueish in color, front of field)",
    },
    {
      type = "complete", questName = "Skeletal Fragments", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 16,
    },
    {
      type = "turnin", questName = "Two Halves Become One", zone = "Western Plaguelands",
      location = "Felstone Field", logCount = 15,
    },
    {
      type = "complete", name = "The Wildlife Suffers Too (part 1)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 15,
    },
    {
      type = "turnin", name = "A Plague Upon Thee (part 2)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Western Plaguelands", location = "Northridge Lumber Camp",
      logCount = 14, note = "Note: Place on a box its at the back of the mill",
    },
    {
      type = "accept", name = "A Plague Upon Thee (part 3)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Western Plaguelands", location = "Northridge Lumber Camp",
      logCount = 15,
      note = "Note: you haver to click on the barrel you just placed to get the next part of the quest.",
    },
    {
      type = "accept", name = "Unfinished Business (part 1)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 16,
      note = "Note Quest Giver is east in the back----->",
    },
    {
      type = "complete", name = "Unfinished Business (part 1)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 16,
    },
    {
      type = "turnin", name = "Unfinished Business (part 1)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 15,
    },
    {
      type = "accept", name = "Unfinished Business (part 2)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 16,
    },
    {
      type = "complete", name = "Unfinished Business (part 2)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 16,
      note = "Note: Named mobs in tower and nook",
    },
    {
      type = "turnin", name = "Unfinished Business (part 2)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 15,
    },
    {
      type = "accept", name = "Unfinished Business (part 3)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 16,
    },
    {
      type = "complete", name = "Unfinished Business (part 3)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Hearthglen", logCount = 16, note = "Note: Its the First tower",
    },
    {
      type = "complete", questName = "Heroes of Darrowshire", zone = "Western Plaguelands",
      location = "Hearthglen", logCount = 16,
      note = "Partial progress - work on this while you are here, then move on. Note: The libram is in the Inn, first floor",
    },
    {
      type = "turnin", name = "Unfinished Business (part 3)",
      questName = "Unfinished Business", ambiguous = true, zone = "Western Plaguelands",
      location = "Northridge Lumber Camp", logCount = 15,
    },
    {
      type = "turnin", name = "The Wildlife Suffers Too (part 1)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 15,
    },
    {
      type = "accept", name = "The Wildlife Suffers Too (part 2)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 16,
    },
    {
      type = "complete", name = "The Wildlife Suffers Too (part 2)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 16,
    },
    {
      type = "turnin", name = "The Wildlife Suffers Too (part 2)",
      questName = "The Wildlife Suffers Too", ambiguous = true, zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 15,
    },
    {
      type = "accept", questName = "Glyphed Oaken Branch", zone = "Western Plaguelands",
      location = "Writhing Haunt", logCount = 16,
    },
    {
      type = "complete", questName = "Target: Gahrron's Withering",
      zone = "Western Plaguelands", location = "Gahrron's Withering", logCount = 16,
    },
    {
      type = "turnin", questName = "Target: Gahrron's Withering", zone = "Western Plaguelands",
      location = "Dalson's Tears", logCount = 15,
    },
    {
      type = "accept", name = "Return to the Bulwark (part 4)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Western Plaguelands",
      location = "Dalson's Tears", logCount = 16,
    },
    {
      type = "complete", questName = "Heroes of Darrowshire", zone = "Western Plaguelands",
      location = "Dalson's Tears", logCount = 16,
      note = "Partial progress - work on this while you are here, then move on. Note:Shield right outside of the barn",
    },
    {
      type = "turnin", questName = "Hameya's Plea", zone = "Eastern Plaguelands",
      location = "The Undercroft", logCount = 15,
    },
    {
      type = "turnin", questName = "Un-Life's Little Annoyances", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 14,
    },
    {
      type = "turnin", questName = "The Ranger Lord's Behest", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 13,
    },
    {
      type = "accept", questName = "Duskwing, Oh How I Hate Thee...",
      zone = "Eastern Plaguelands", location = "The Marris Stead", logCount = 14,
      note = "Note: Need to be need to be level 55 to Accept",
    },
    {
      type = "accept", questName = "The Corpulent One", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 15,
    },
    {
      type = "complete", questName = "Duskwing, Oh How I Hate Thee...",
      zone = "Eastern Plaguelands", location = "The Marris Stead", logCount = 15,
    },
    {
      type = "complete", questName = "The Corpulent One", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 15,
    },
    {
      type = "turnin", questName = "Heroes of Darrowshire", zone = "Western Plaguelands",
      location = "Light's Hope Chapel", logCount = 14,
    },
    {
      type = "accept", questName = "Marauders of Darrowshire", zone = "Western Plaguelands",
      location = "Light's Hope Chapel", logCount = 16,
    },
    {
      type = "complete", questName = "Marauders of Darrowshire", zone = "Western Plaguelands",
      location = "Noxious Glade", logCount = 16,
      note = "Note: Go north of Lights hope to Scourge camp called  Noxious Glade",
    },
    {
      type = "turnin", questName = "Marauders of Darrowshire", zone = "Western Plaguelands",
      location = "Light's Hope Chapel", logCount = 15,
    },
    {
      type = "accept", questName = "Return to Chromie", zone = "Western Plaguelands",
      location = "Light's Hope Chapel", logCount = 16,
    },
    {
      type = "turnin", questName = "Duskwing, Oh How I Hate Thee...",
      zone = "Eastern Plaguelands", location = "The Marris Stead", logCount = 15,
    },
    {
      type = "turnin", questName = "The Corpulent One", zone = "Eastern Plaguelands",
      location = "The Marris Stead", logCount = 14,
    },
    {
      type = "turnin", questName = "Of Lost Honor", zone = "Eastern Plaguelands",
      location = "Thondroril River", logCount = 13,
    },
    {
      type = "accept", name = "Of Love and Family (part 1)", questName = "Of Love and Family",
      ambiguous = true, zone = "Eastern Plaguelands", location = "Thondroril River",
      logCount = 14,
    },
    {
      type = "turnin", name = "Of Love and Family (part 1)", questName = "Of Love and Family",
      ambiguous = true, zone = "Western Plaguelands", location = "Caer Darrow", logCount = 13,
      note = "Note: House on the west side of the island by the dock, low part of the island.",
    },
    {
      type = "accept", name = "Of Love and Family (part 2)", questName = "Of Love and Family",
      ambiguous = true, zone = "Western Plaguelands", location = "Caer Darrow", logCount = 14,
    },
    {
      type = "turnin", questName = "Return to Chromie", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 13,
    },
    {
      type = "accept", questName = "The Battle of Darrowshire", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 14,
    },
    {
      type = "turnin", name = "A Plague Upon Thee (part 3)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Tirisfal Glades", location = "The Bulwark", logCount = 13,
    },
    {
      type = "turnin", questName = "Skeletal Fragments", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "accept", questName = "Mold Rhymes With...", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 13,
    },
    {
      type = "turnin", name = "Return to the Bulwark (part 4)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "accept", questName = "Mission Accomplished!", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 13,
    },
    {
      type = "turnin", questName = "Mission Accomplished!", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "hearth", name = "Hearth to Undercity", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12, note = "Use your hearthstone.",
    },
})
