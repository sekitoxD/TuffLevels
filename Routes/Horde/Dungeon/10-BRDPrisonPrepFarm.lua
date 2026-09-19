-- TuFFlevels / Routes/Horde/Dungeon/10-BRDPrisonPrepFarm.lua
--
-- Part 10 of the 5-man Horde 1-60 dungeon route.
-- Sections: BRD Prison Prep & Farm (level 55-58) | BRD Prison Prep & Farm (level 58-60) | BRD Prison Prep & Farm (level 59-60)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(10, {

    { type = "section", name = "BRD Prison Prep & Farm (level 55-58)", levels = { 55, 58 } },
    { type = "note", name = "Note", note = "Killing Owlex Jones." },
    {
      type = "note", name = "Note", note = "Undercity to Orgrimmar", zone = "Tirisfal Glades",
      location = "Brill",
    },
    {
      type = "turnin", questName = "The Eastern Kingdom", zone = "Orgrimmar",
      location = "Thrall", logCount = 11,
    },
    { type = "accept", questName = "The Royal Rescue", zone = "Orgrimmar", location = "Thrall", logCount = 12 },
    {
      type = "note", name = "Note",
      note = "Dont attempt emp run till  level 59 or 60, aggro range in gauntlet is an epic disaster waiting to happen.",
    },
    {
      type = "hearth", name = "Set Hearth to Orgrimmar", zone = "Orgrimmar",
      location = "Ogrimmar", logCount = 12, note = "Use your hearthstone.",
    },
    {
      type = "travel", name = "Ogrimmar to Felwood", zone = "Azshara", location = "Valormok",
      logCount = 12, note = "Take the flight path.",
    },
    {
      type = "accept", name = "Wild Guardians (part 1)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", logCount = 13,
    },
    {
      type = "travel", name = "Bloodvenom Post to Moonglade", zone = "Felwood",
      location = "Bloodvenom Post", logCount = 13, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Winterfall Activity", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 14,
    },
    {
      type = "accept", questName = "It's a Secret to Everybody",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Winterspring", location = "Frostfire Hot Springs",
    },
    {
      type = "turnin", questName = "It's a Secret to Everybody", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 13,
    },
    {
      type = "note", name = "Skip: The Videre Elixir (part 1)",
      note = "The route deliberately skips The Videre Elixir (part 1).", zone = "Winterspring",
      location = "Frostfire Hot Springs",
    },
    {
      type = "turnin", questName = "The New Springs", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 12,
    },
    {
      type = "accept", questName = "Strange Sources", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 13,
    },
    {
      type = "accept", questName = "Threat of the Winterfall", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 14,
    },
    {
      type = "accept", questName = "Empty Firewater Flask", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 15,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "complete", questName = "Winterfall Activity", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "note", name = "Note",
      note = "Note: Den Watchers are easier at Winterfall Village.  Get Pathfinders and Totemics done.",
    },
    {
      type = "complete", name = "Wild Guardians (part 1)", questName = "Wild Guardians",
      ambiguous = true, zone = "Winterspring", location = "West of Everlook", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    { type = "accept", questName = "A Little Luck", zone = "Winterspring", location = "Everlook", logCount = 16 },
    { type = "turnin", questName = "A Little Luck", zone = "Winterspring", location = "Everlook", logCount = 15 },
    {
      type = "accept", questName = "Luck Be With You", zone = "Winterspring",
      location = "Everlook", logCount = 16,
    },
    {
      type = "accept", questName = "Ursius of the Shardtooth", zone = "Winterspring",
      location = "Everlook", logCount = 17,
    },
    {
      type = "complete", questName = "Ursius of the Shardtooth", zone = "Winterspring",
      location = "Winterfall Village", logCount = 17,
    },
    {
      type = "complete", questName = "Winterfall Activity", zone = "Winterspring",
      location = "Winterfall Village", logCount = 17,
    },
    {
      type = "complete", questName = "Threat of the Winterfall", zone = "Winterspring",
      location = "Winterfall Village", logCount = 17,
    },
    {
      type = "turnin", questName = "Ursius of the Shardtooth", zone = "Winterspring",
      location = "Everlook", logCount = 16,
    },
    {
      type = "accept", questName = "Brumeran of the Chillwind", zone = "Winterspring",
      location = "Everlook", logCount = 17,
    },
    {
      type = "complete", questName = "Brumeran of the Chillwind", zone = "Winterspring",
      location = "Southern Winterspring", logCount = 17,
    },
    {
      type = "complete", questName = "Luck Be With You", zone = "Winterspring",
      location = "Frostwhisper Gorge", logCount = 17,
    },
    {
      type = "complete", questName = "Strange Sources", zone = "Winterspring",
      location = "Darkwhisper Gorge", logCount = 17,
    },
    {
      type = "turnin", questName = "Luck Be With You", zone = "Winterspring",
      location = "Everlook", logCount = 16,
    },
    {
      type = "turnin", questName = "Brumeran of the Chillwind", zone = "Winterspring",
      location = "Everlook", logCount = 15,
    },
    { type = "accept", questName = "Shy-Rotam", zone = "Winterspring", location = "Everlook", logCount = 16 },
    {
      type = "complete", name = "Wild Guardians (part 1)", questName = "Wild Guardians",
      ambiguous = true, zone = "Winterspring", location = "West of Everlook", logCount = 16,
    },
    {
      type = "turnin", questName = "Strange Sources", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 15,
    },
    {
      type = "turnin", questName = "Empty Firewater Flask", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 14,
    },
    {
      type = "note", name = "Skip: Falling to Corruption",
      note = "The route deliberately skips Falling to Corruption.", zone = "Winterspring",
      location = "Frostfire Hot Springs",
    },
    {
      type = "turnin", questName = "Threat of the Winterfall", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 13,
    },
    {
      type = "turnin", questName = "Winterfall Activity", zone = "Winterspring",
      location = "Frostfire Hot Springs", logCount = 12,
    },
    {
      type = "travel", name = "Moonglade to Bloodvenom Post", zone = "Moonglade",
      logCount = 12, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Wild Guardians (part 1)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", logCount = 11,
    },
    {
      type = "accept", name = "Wild Guardians (part 2)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", logCount = 12,
    },
    {
      type = "travel", name = "Bloodvenom Post to Everlook", zone = "Felwood",
      location = "Bloodvenom Post", logCount = 12, note = "Take the flight path.",
    },
    {
      type = "complete", name = "Wild Guardians (part 2)", questName = "Wild Guardians",
      ambiguous = true, zone = "Winterspring", location = "The Hidden Grove", logCount = 12,
    },
    {
      type = "accept", name = "Guarding Secrets (part 1)", questName = "Guarding Secrets",
      ambiguous = true, zone = "Winterspring", location = "The Hidden Grove", logCount = 13,
      note = "Starts from an item you loot, not from an NPC.",
    },
    { type = "note", name = "Note", note = "Can farm some juju here.  Bears drop juju ember (fire resist)." },
    {
      type = "complete", questName = "Shy-Rotam", zone = "Winterspring",
      location = "Frostsaber Rock", logCount = 13,
    },
    { type = "turnin", questName = "Shy-Rotam", zone = "Winterspring", location = "Everlook", logCount = 12 },
    {
      type = "accept", questName = "Past Endeavors", zone = "Winterspring",
      location = "Everlook", logCount = 13,
    },
    {
      type = "travel", name = "Everlook to Bloodvenom Post", zone = "Winterspring",
      location = "Everlook", logCount = 13, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Wild Guardians (part 2)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", logCount = 12,
    },
    {
      type = "note", name = "Skip: Wild Guardians (part 3)",
      note = "The route deliberately skips Wild Guardians (part 3).", zone = "Felwood",
      location = "Bloodvenom Post",
    },
    {
      type = "turnin", name = "Guarding Secrets (part 1)", questName = "Guarding Secrets",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", logCount = 11,
    },
    {
      type = "accept", name = "Guarding Secrets (part 2)", questName = "Guarding Secrets",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", logCount = 12,
    },
    {
      type = "travel", name = "Bloodvenom to Thunderbluff", zone = "Felwood",
      location = "Bloodvenom Post", logCount = 12, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Glyphed Oaken Branch", zone = "Thunder Bluff",
      location = "The Elder Rise", logCount = 11,
    },
    {
      type = "turnin", name = "Guarding Secrets (part 2)", questName = "Guarding Secrets",
      ambiguous = true, zone = "Thunder Bluff", location = "The Elder Rise", logCount = 10,
    },
    {
      type = "turnin", questName = "Past Endeavors", zone = "Thunder Bluff",
      location = "The Hunter Rise", logCount = 9,
    },
    {
      type = "travel", name = "Thunderbluff to Tanaris", zone = "Thunder Bluff",
      location = "Thunderbluff", logCount = 10, note = "Take the flight path.",
    },
    { type = "turnin", questName = "Mold Rhymes With...", zone = "Tanaris", logCount = 9 },
    {
      type = "note", name = "Skip: Fire Plume Forged",
      note = "The route deliberately skips Fire Plume Forged. Note: Unless you can get two thorium bars per person.... then do it in Ungoro next.",
      zone = "Tanaris",
    },
    {
      type = "turnin", questName = "The God Hakkar", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 8,
    },
    {
      type = "note", name = "Skip: The Lost Tablets of Mosh'aru",
      note = "The route deliberately skips The Lost Tablets of Mosh'aru.", zone = "Tanaris",
      location = "Steamwheedle Port",
    },
    {
      type = "travel", name = "Tanaris to Ungoro", zone = "Tanaris", logCount = 8,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Zapper Fuel", zone = "Un'goro Crater",
      location = "Marshal Refuge", logCount = 7,
    },
    {
      type = "accept", questName = "Bloodpetal Zapper", zone = "Un'goro Crater",
      location = "Marshal Refuge", logCount = 8,
      note = "If you dont have the anymore, go get one you loser.",
    },
    {
      type = "turnin", questName = "Bloodpetal Zapper", zone = "Un'goro Crater",
      location = "Marshal Refuge", logCount = 7,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "Un'goro Crater",
      location = "Marshal Refuge", logCount = 7, note = "Use your hearthstone.",
    },
    { type = "note", name = "Note", note = "Orgrimmar to Undercity", zone = "The Barrens", location = "Ratchet" },
    {
      type = "travel", name = "Undercity to Kargath", zone = "Undercity", logCount = 7,
      note = "Take the flight path.",
    },
    { type = "note", name = "Note", note = "A BRD Pearl Necklace." },
    {
      type = "travel", name = "Undercity to Kargath", zone = "Undercity",
      location = "Trade Quarter", logCount = 7, note = "Take the flight path.",
    },
    {
      type = "note", name = "Note",
      note = "Note: If you have max runecloth bandages, swing by and get heavy runecloth at this point in time in Arathi",
    },
    { type = "note", name = "Note", note = "Set a hearth in Kargath here if no lock for summons." },
    {
      type = "accept", questName = "Lost Thunderbrew Recipe", zone = "Badlands",
      location = "Kargath", logCount = 8,
    },
    { type = "accept", questName = "Grark Lorkrub", zone = "Badlands", location = "Kargath", logCount = 9 },
    { type = "turnin", questName = "The Last Element", zone = "Badlands", location = "Kargath", logCount = 8 },
    { type = "note", name = "Note", note = "Run through BRM to Burning Steppes Flame Crest & get Flight Path" },
    {
      type = "accept", questName = "The Heart of the Mountain", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 9, note = "Note: Only one per run!",
    },
    {
      type = "accept", questName = "Ribbly Screwspigot", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 10,
    },
    {
      type = "turnin", questName = "Grark Lorkrub", zone = "Burning Steppes",
      location = "Blackrock Stronghold", logCount = 9,
      note = "Note: Inside of Blackrock Stronghold ---->",
    },
    {
      type = "note", name = "Note",
      note = "!!!MAKE SURE EVERYONE COMPLETES QUEST BEFORE ACCEPTING NEXT PART!!!!!",
    },
    {
      type = "accept", questName = "Precarious Predicament", zone = "Burning Steppes",
      location = "Blackrock Stronghold", logCount = 10, note = "Note: Escort through BRM",
    },
    {
      type = "turnin", questName = "Precarious Predicament", zone = "Badlands",
      location = "Kargath", logCount = 9,
    },
    {
      type = "accept", questName = "Operation: Death to Angerforge", zone = "Badlands",
      location = "Kargath", logCount = 10,
    },
    {
      type = "accept", questName = "Attunement to the Core", zone = "Blackrock Mountain",
      location = "BRM", logCount = 11, note = "Note: MC Portal elf.",
    },
    {
      type = "note", name = "Note",
      note = "Die in the lava right by the ramp where you accept the MC attunment, run back to the center of BRM (need to be a ghost)",
    },
    {
      type = "accept", name = "Dark Iron Legacy (part 1)", questName = "Dark Iron Legacy",
      ambiguous = true, zone = "Blackrock Mountain", location = "BRM", logCount = 12,
    },
    {
      type = "turnin", name = "Dark Iron Legacy (part 1)", questName = "Dark Iron Legacy",
      ambiguous = true, zone = "Blackrock Mountain", location = "BRM", logCount = 11,
    },
    {
      type = "accept", name = "Dark Iron Legacy (part 2)", questName = "Dark Iron Legacy",
      ambiguous = true, zone = "Blackrock Mountain", location = "BRM", logCount = 12,
    },
    { type = "note", name = "Note", note = "Rez at your body on the steps in front of the MC attunment Quest" },
    { type = "note", name = "Note", note = "Full on Quest run, just straight to ring of law.", location = "-" },
    {
      type = "turnin", name = "Dark Iron Legacy (part 2)", questName = "Dark Iron Legacy",
      ambiguous = true, zone = "Blackrock Mountain", location = "BRM", logCount = 11,
    },
    {
      type = "note", name = "Note",
      note = "Run / Hearth to Kargath, summon as you run for Org quests. Finish Summon In Kargath before moving on.",
    },
    {
      type = "accept", questName = "Warlord's Command", zone = "Badlands",
      location = "Kargath", logCount = 12,
      note = "Note: Reminder, do the dialoge, then the note comes in the mail.",
    },
    { type = "accept", questName = "Operative Bijou", zone = "Badlands", location = "Kargath", logCount = 13 },
    { type = "accept", questName = "The Pack Mistress", zone = "Badlands", location = "Kargath", logCount = 14 },
    {
      type = "turnin", questName = "Lost Thunderbrew Recipe", zone = "Badlands",
      location = "Kargath", logCount = 13,
    },
    {
      type = "turnin", questName = "Operation: Death to Angerforge", zone = "Badlands",
      location = "Kargath", logCount = 12,
    },
    {
      type = "travel", name = "Kargath to Flamecrest", zone = "Badlands", location = "Kargath",
      logCount = 12, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "En-Ay-Es-Tee-Why", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 13,
    },
    {
      type = "accept", questName = "Kibler's Exotic Pets", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 14,
    },
    {
      type = "accept", questName = "Mothers Milk", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 15,
      note = "Note dude fuck this quest.... maybe save it for a a questturn in run?!",
    },
    {
      type = "turnin", questName = "The Heart of the Mountain", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 14, note = "Note: Only one per run!",
    },
    {
      type = "turnin", questName = "Ribbly Screwspigot", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 13,
    },
    {
      type = "note", name = "Note",
      note = "The Gauntlet room before emp is very very difficult at 56 and 57 due to aggro range, not recomended.",
    },
    { type = "note", name = "Note", note = "Angerforge-> Argelmach -> Guzzler ->Phalanx" },
    { type = "note", name = "Note", note = "Angerforge-> Argelmach -> Guzzler ->Phalanx" },
    {
      type = "note", name = "Note",
      note = "If you have the lock for summon, train at 58 and summon back using hearth in Org.",
    },

    { type = "section", name = "BRD Prison Prep & Farm (level 58-60)", levels = { 58, 60 } },
    { type = "note", name = "Note", note = "LBRS 10 Yard Line (Red Zone)!" },
    { type = "note", name = "Note", note = "Quest  run including Bijou quests", location = "-" },
    { type = "note", name = "Note", note = "Run  or Hearth to Kargath if you have no lock" },
    { type = "turnin", questName = "Warlord's Command", zone = "Badlands", location = "Kargath", logCount = 13 },
    { type = "turnin", questName = "Operative Bijou", zone = "Badlands", location = "Kargath", logCount = 12 },
    { type = "turnin", questName = "The Pack Mistress", zone = "Badlands", location = "Kargath", logCount = 11 },
    {
      type = "travel", name = "Kargath to Flamecrest", zone = "Badlands", location = "Kargath",
      logCount = 11, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Mothers Milk", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 10,
      note = "Note dude fuck this quest.... maybe save it for a a questturn in run?!",
    },
    {
      type = "turnin", questName = "En-Ay-Es-Tee-Why", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 9,
    },
    {
      type = "turnin", questName = "Kibler's Exotic Pets", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 8,
    },
    { type = "note", name = "Note", note = "Farm Run", location = "-" },
    { type = "note", name = "Note", note = "Farm Run until 1 ubrs key or 59.5", location = "-" },

    { type = "section", name = "BRD Prison Prep & Farm (level 59-60)", levels = { 59, 60 } },
    { type = "note", name = "Note", note = "Strat Live finish line!" },
    {
      type = "travel", name = "Kargath to Undercity", zone = "Badlands", location = "Kargath",
      logCount = 8, note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Undercity", zone = "Undercity", logCount = 8,
      note = "Bind your hearthstone here.",
    },
    {
      type = "travel", name = "Undercity to Lights Hope", zone = "Undercity", logCount = 8,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "The Archivist", zone = "Eastern Plaguelands",
      location = "Lights Hope", logCount = 9,
    },
    { type = "note", name = "Note", note = "You have to get the painting BEFORE you burn it down in Strat Live" },
    {
      type = "accept", questName = "Houses of the Holy", zone = "Eastern Plaguelands",
      location = "Lights Hope", logCount = 10,
    },
    {
      type = "accept", questName = "The Great Fras Siabi", zone = "Eastern Plaguelands",
      location = "Lights Hope", logCount = 11,
    },
    {
      type = "accept", questName = "The Flesh Does Not Lie", zone = "Eastern Plaguelands",
      location = "Lights Hope", logCount = 12,
    },
    {
      type = "complete", questName = "The Battle of Darrowshire", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 12,
    },
    {
      type = "note", name = "Note",
      note = "Note: You can heal Davil and Captain Redpath, follow Redpath around, and prio killling Horgus the Ravager",
    },
    {
      type = "turnin", questName = "The Battle of Darrowshire", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 11,
    },
    {
      type = "accept", questName = "Hidden Treasures", zone = "Eastern Plaguelands",
      location = "Darrowshire", logCount = 12,
    },
    {
      type = "accept", questName = "The Call to Command", zone = "Eastern Plaguelands",
      location = "Marris Stead", logCount = 13,
    },
    {
      type = "complete", questName = "Alas, Andorhal", zone = "Western Plaguelands",
      location = "Ruins of Andorhal", logCount = 13,
    },
    {
      type = "turnin", questName = "Alas, Andorhal", zone = "Tirisfal Glades",
      location = "The Bulwark", logCount = 12,
    },
    {
      type = "note", name = "Note", note = "Hearth to Undercity", zone = "Tirisfal Glades",
      location = "The Bulwark",
    },
    { type = "turnin", questName = "The Call to Command", zone = "Undercity", logCount = 11 },
    { type = "accept", questName = "The Crimson Courier", zone = "Undercity", logCount = 12 },
    {
      type = "travel", name = "Undercity to Light's Hope Chapel", zone = "Undercity",
      logCount = 12, note = "Take the flight path.",
    },
    {
      type = "complete", questName = "The Crimson Courier", zone = "Eastern Plaguelands",
      location = "EasternPlaguelands", logCount = 12,
    },
    {
      type = "accept", questName = "The Restless Souls", zone = "Eastern Plaguelands",
      location = "Eastern Plagueland", logCount = 13,
      note = "Have to get the quest here ----------->>>",
    },
    { type = "note", name = "Note", note = "Quest run of Live.", location = "-" },
    {
      type = "turnin", questName = "The Restless Souls", zone = "Eastern Plaguelands",
      location = "Eastern Plagueland", logCount = 12,
    },
    { type = "note", name = "Note", note = "You have to get the painting BEFORE you burn it down!" },
    {
      type = "turnin", questName = "Houses of the Holy", zone = "Eastern Plaguelands",
      location = "Lights Hope", logCount = 11,
    },
    {
      type = "turnin", questName = "The Great Fras Siabi", zone = "Eastern Plaguelands",
      location = "Lights Hope", logCount = 10,
    },
    {
      type = "turnin", questName = "The Flesh Does Not Lie", zone = "Eastern Plaguelands",
      location = "Lights Hope", logCount = 9,
    },
    {
      type = "turnin", questName = "The Restless Souls", zone = "Eastern Plaguelands",
      location = "Eastern Plagueland", logCount = 8,
    },
    {
      type = "turnin", name = "Of Love and Family (part 2)", questName = "Of Love and Family",
      ambiguous = true, zone = "Eastern Plaguelands", location = "Eastern Plagueland",
      logCount = 7,
    },
    {
      type = "note", name = "Note",
      note = "Should be close to 60 by now and finish off the of love and family quest chain and Crimson Courier then Strat UD",
    },
})
