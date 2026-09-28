-- TuFFlevels / Routes/Horde/Dungeon/07-Continued.lua
--
-- Part 7 of the 5-man Horde 1-60 dungeon route.
-- Sections: Continued (level 46-49) | Continued (level 50-51)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(7, {

    { type = "section", name = "Continued (level 46-49)", levels = { 46, 49 } },
    { type = "note", name = "Note", note = "Uldaman and Tanaris Wrap up" },
    {
      type = "accept", questName = "Shadowshard Fragments", zone = "Orgrimmar",
      location = "Valley of Spirits", logCount = 8,
    },
    { type = "turnin", questName = "Ripple Delivery", zone = "Orgrimmar", location = "The Drag", logCount = 7 },
    { type = "trainer", name = "Class Trainer", zone = "Orgrimmar", location = "Ogrimmar", logCount = 7 },
    {
      type = "travel", name = "Ogrimmar to Thunderbluff", zone = "Orgrimmar",
      location = "Ogrimmar", logCount = 7, note = "Take the flight path.",
    },
    {
      type = "accept", name = "The Platinum Discs (part 2)", ambiguous = true,
      questName = "The Platinum Discs",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Thunder Bluff", location = "Thunderbluff",
    },
    {
      type = "turnin", name = "The Platinum Discs (part 2)", questName = "The Platinum Discs",
      ambiguous = true, zone = "Thunder Bluff", location = "Thunderbluff", logCount = 6,
    },
    {
      type = "accept", name = "The Platinum Discs (part 3)", questName = "The Platinum Discs",
      ambiguous = true, zone = "Thunder Bluff", location = "Thunderbluff", logCount = 7,
    },
    {
      type = "turnin", name = "The Platinum Discs (part 3)", questName = "The Platinum Discs",
      ambiguous = true, zone = "Thunder Bluff", location = "Thunderbluff", logCount = 6,
    },
    {
      type = "accept", questName = "Portents of Uldum", zone = "Thunder Bluff",
      location = "Thunderbluff", logCount = 7,
    },
    {
      type = "accept", name = "Portents of Uldum (part 1)", ambiguous = true,
      questName = "Portents of Uldum",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Thunder Bluff", location = "Elder Rise",
    },
    {
      type = "turnin", name = "Portents of Uldum (part 1)", questName = "Portents of Uldum",
      ambiguous = true, zone = "Thunder Bluff", location = "Elder Rise", logCount = 6,
    },
    {
      type = "accept", questName = "Seeing What Happens", zone = "Thunder Bluff",
      location = "Elder Rise", logCount = 7,
    },
    {
      type = "travel", name = "Thunderbluff to Camp Mojache", zone = "Thunder Bluff",
      location = "Thunderbluff", logCount = 7, note = "Take the flight path.",
    },
    { type = "note", name = "Note", note = "You need to be level 46  @ this point" },
    {
      type = "accept", questName = "The Sunken Temple", zone = "Feralas",
      location = "Camp Mojache", logCount = 8,
    },
    { type = "travel", name = "Camp Mojache to Gadgetzan", logCount = 8, note = "Take the flight path." },
    {
      type = "hearth", name = "Set Hearth to Gadgetzan", zone = "Tanaris",
      location = "Gadgetzan", logCount = 8, note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Thistleshrub Valley", zone = "Tanaris",
      location = "Gadgetzan", logCount = 9,
    },
    {
      type = "accept", questName = "The Dunemaul Compound", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10,
    },
    {
      type = "accept", questName = "The Thirsty Goblin", zone = "Tanaris",
      location = "Gadgetzan", logCount = 11,
    },
    {
      type = "accept", questName = "Noxious Lair Investigation", zone = "Tanaris",
      location = "Gadgetzan", logCount = 12,
    },
    {
      type = "complete", questName = "Noxious Lair Investigation", zone = "Tanaris",
      location = "Noxious Lair", logCount = 12,
    },
    {
      type = "complete", questName = "The Dunemaul Compound", zone = "Tanaris",
      location = "The Dunemaul Compound", logCount = 12,
    },
    {
      type = "complete", questName = "The Thirsty Goblin", zone = "Tanaris",
      location = "Thistleshrub Valley", logCount = 12,
    },
    {
      type = "complete", questName = "Thistleshrub Valley", zone = "Tanaris",
      location = "Thistleshrub Valley", logCount = 12,
    },
    {
      type = "turnin", questName = "Seeing What Happens", zone = "Tanaris",
      location = "Valley of the Watchers", logCount = 11,
      note = "Note: Pedestal behind the elites",
    },
    {
      type = "accept", questName = "The Stone Watcher", zone = "Tanaris",
      location = "Valley of the Watchers", logCount = 12,
    },
    {
      type = "turnin", questName = "The Stone Watcher", zone = "Tanaris",
      location = "Valley of the Watchers", logCount = 11,
    },
    {
      type = "accept", name = "Return to Thunder Bluff (part 2)",
      questName = "Return to Thunder Bluff", ambiguous = true, zone = "Tanaris",
      location = "Valley of the Watchers", logCount = 12,
    },
    {
      type = "accept", questName = "Tooga", zone = "Tanaris",
      location = "Thristleshrub Valley", logCount = 13,
      note = "If Tooga isnt there then hearth to Gadget and Skip it",
    },
    {
      type = "turnin", questName = "The Sunken Temple", zone = "Tanaris", logCount = 12,
      note = "Stop by and turn this in on the way by with Tooga -------------->>>",
    },
    { type = "accept", questName = "The Stone Circle", zone = "Tanaris", logCount = 13 },
    { type = "turnin", questName = "Tooga", zone = "Tanaris", location = "Port", logCount = 12 },
    { type = "turnin", questName = "Screecher Spirits", zone = "Tanaris", location = "Port", logCount = 11 },
    {
      type = "accept", questName = "The Prophecy of Mosh'aru", zone = "Tanaris",
      location = "Port", logCount = 12,
    },
    { type = "note", name = "Note", note = "Hearth to Gadgetzan", zone = "Tanaris", location = "Gadgetzan" },
    {
      type = "turnin", questName = "Noxious Lair Investigation", zone = "Tanaris",
      location = "Gadgetzan", logCount = 11,
    },
    {
      type = "turnin", questName = "Thistleshrub Valley", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10,
    },
    { type = "accept", questName = "Scarab Shells", zone = "Tanaris", location = "Gadgetzan", logCount = 11 },
    {
      type = "turnin", questName = "The Dunemaul Compound", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10,
    },
    { type = "accept", questName = "Divino-Matic Rod", zone = "Tanaris", location = "Gadgetzan", logCount = 11 },
    {
      type = "turnin", questName = "The Thirsty Goblin", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10,
    },
    { type = "accept", questName = "In Good Taste", zone = "Tanaris", location = "Gadgetzan", logCount = 11 },
    { type = "accept", questName = "Troll Temper", zone = "Tanaris", location = "Gadgetzan", logCount = 12 },
    { type = "turnin", questName = "In Good Taste", zone = "Tanaris", location = "Gadgetzan", logCount = 11 },
    {
      type = "accept", questName = "Sprinkle's Secret Ingredient", zone = "Tanaris",
      location = "Gadgetzan", logCount = 12,
      note = "Accept if Jinthalor quests are in and you going to Hinter again",
    },
    { type = "note", name = "Note", note = "ZF Farm" },
    { type = "note", name = "Note", note = "Full Clear without Gahz'rilla", location = "-" },
    { type = "note", name = "Note", note = "Jintha'alor" },
    { type = "note", name = "Note", note = "Hearth to Gadgetzan", zone = "Tanaris", location = "Gadgetzan" },
    {
      type = "turnin", questName = "The Prophecy of Mosh'aru", zone = "Tanaris",
      location = "Port", logCount = 11,
    },
    { type = "accept", questName = "The Ancient Egg", zone = "Tanaris", location = "Port", logCount = 12 },
    {
      type = "travel", name = "Tanaris to Ratchet", zone = "Orgrimmar", location = "Ogrimmar",
      logCount = 12, note = "Take the flight path.",
    },
    {
      type = "travel", name = "Ratchet to Sen'jin Village", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 12, note = "Boat.",
    },
    {
      type = "note", name = "Note",
      note = "If you just missed the boat you can ride all the way around (or waterwalk)",
    },
    {
      type = "turnin", questName = "The Spider God", zone = "Durotar",
      location = "Sen'jin Village", logCount = 11,
    },
    {
      type = "accept", questName = "Summoning Shadra", zone = "Durotar",
      location = "Sen'jin Village", logCount = 12,
    },
    { type = "note", name = "Note", note = "Ride to Orgrimmar" },
    { type = "trainer", name = "Class Trainer", zone = "Orgrimmar", location = "Ogrimmar", logCount = 12 },
    { type = "note", name = "Note", note = "Orgrimarr to Undercrity", zone = "Orgrimmar", location = "Ogrimmar" },
    {
      type = "accept", name = "Seeping Corruption (part 1)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Orgrimmar", location = "Ogrimmar", logCount = 13,
    },
    {
      type = "travel", name = "Undercity to Raventusk", zone = "Undercity", logCount = 13,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Dark Vessels", zone = "The Hinterlands",
      location = "Raventusk", logCount = 14,
    },
    {
      type = "accept", questName = "Lard Lost His Lunch", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 15,
    },
    {
      type = "accept", questName = "Snapjaws, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 16,
    },
    {
      type = "note", name = "Note",
      note = "Note: You might need to do snajaws first to get Gammerita, confliciting reports.",
    },
    {
      type = "accept", questName = "Gammerita, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 17,
    },
    {
      type = "complete", questName = "Lard Lost His Lunch", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 17,
    },
    {
      type = "complete", questName = "Snapjaws, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 17,
    },
    {
      type = "complete", questName = "Gammerita, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 17,
    },
    {
      type = "turnin", questName = "Lard Lost His Lunch", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 16,
    },
    {
      type = "turnin", questName = "Snapjaws, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 15,
    },
    {
      type = "turnin", questName = "Gammerita, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 14,
    },
    {
      type = "accept", questName = "Separation Anxiety", zone = "The Hinterlands",
      location = "Raventusk", logCount = 15,
    },
    {
      type = "accept", questName = "Wanted: Vile Priestess Hexx and Her Minions",
      zone = "The Hinterlands", location = "Raventusk", logCount = 16,
    },
    {
      type = "accept", questName = "Job Opening: Guard Captain of Revantusk Village",
      zone = "The Hinterlands", location = "Raventusk", logCount = 17,
    },
    {
      type = "accept", questName = "Kidnapped Elder Torntusk", zone = "The Hinterlands",
      location = "Raventusk", logCount = 18,
    },
    {
      type = "complete", questName = "Sprinkle's Secret Ingredient", zone = "The Hinterlands",
      location = "Valorwind Lake", logCount = 18,
    },
    {
      type = "accept", questName = "Jammal'an the Prophet", zone = "The Hinterlands",
      location = "Shadra'alor", logCount = 19, note = "Get the quest here---^^^^^^^",
    },
    { type = "note", name = "Note", note = "Location of Qiaga the Keeper---------->>>" },
    {
      type = "complete", questName = "Dark Vessels", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 19,
      note = "Partial progress - work on this while you are here, then move on. Note: Prio the cauldrons, gonna be a bottle neck most likely,",
    },
    {
      type = "complete", questName = "Job Opening: Guard Captain of Revantusk Village",
      zone = "The Hinterlands", location = "Jintha'Alor", logCount = 19,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Separation Anxiety", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 19,
      note = "Note: Very Top of Jintha, go right past the cave and its in a room with dogs and hay",
    },
    {
      type = "complete", questName = "Wanted: Vile Priestess Hexx and Her Minions",
      zone = "The Hinterlands", location = "Jintha'Alor", logCount = 19,
      note = "Partial progress - work on this while you are here, then move on. Note: Kill Preuestess",
    },
    {
      type = "turnin", questName = "Kidnapped Elder Torntusk", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 18,
    },
    {
      type = "accept", questName = "Recover the Key!", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 19,
    },
    {
      type = "complete", questName = "Wanted: Vile Priestess Hexx and Her Minions",
      zone = "The Hinterlands", location = "Jintha'Alor", logCount = 19,
    },
    {
      type = "complete", questName = "Recover the Key!", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 19,
    },
    {
      type = "complete", questName = "The Ancient Egg", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 19,
    },
    {
      type = "turnin", questName = "Recover the Key!", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 18,
    },
    {
      type = "accept", questName = "Return to Primal Torntusk", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 19,
    },
    { type = "note", name = "Note", note = "Make the ZF Mallet at the Alter  now" },
    {
      type = "complete", questName = "Job Opening: Guard Captain of Revantusk Village",
      zone = "The Hinterlands", location = "Jintha'Alor", logCount = 19,
    },
    {
      type = "complete", questName = "Dark Vessels", zone = "The Hinterlands",
      location = "Jintha'Alor", logCount = 19,
    },
    {
      type = "complete", questName = "Job Opening: Guard Captain of Revantusk Village",
      zone = "The Hinterlands", location = "Jintha'Alor", logCount = 19,
    },
    {
      type = "turnin", questName = "Dark Vessels", zone = "The Hinterlands",
      location = "Raventusk", logCount = 18,
    },
    {
      type = "turnin", questName = "Separation Anxiety", zone = "The Hinterlands",
      location = "Raventusk", logCount = 17,
    },
    {
      type = "turnin", questName = "Wanted: Vile Priestess Hexx and Her Minions",
      zone = "The Hinterlands", location = "Raventusk", logCount = 16,
    },
    {
      type = "turnin", questName = "Job Opening: Guard Captain of Revantusk Village",
      zone = "The Hinterlands", location = "Raventusk", logCount = 15,
    },
    {
      type = "turnin", questName = "Return to Primal Torntusk", zone = "The Hinterlands",
      location = "Raventusk", logCount = 14,
    },
    { type = "note", name = "Note", note = "Hearth to Gadgetzan", zone = "Tanaris", location = "Gadgetzan" },
    { type = "note", name = "Note", note = "Full Clear with Gahz'rilla", location = "-" },

    { type = "section", name = "Continued (level 50-51)", levels = { 50, 51 } },
    { type = "note", name = "Note", note = "Maraudon" },
    { type = "note", name = "Note", note = "Hearth to Gadgetzan", zone = "Tanaris", location = "Gadgetzan" },
    {
      type = "turnin", questName = "The Ancient Egg", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 13,
      note = "Note: you will not have Ancient Egg if you didnt go to Jintha'Alor, and skip ancient egg if turning in Mosh'aru",
    },
    {
      type = "accept", questName = "The God Hakkar", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 14,
      note = "Note: You wont have this quest if you didnt do Ancient Egg @ Jintha'alor",
    },
    {
      type = "accept", questName = "Yuka Screwspigot", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 15,
    },
    { type = "turnin", questName = "Divino-Matic Rod", zone = "Tanaris", location = "Gadgetzan", logCount = 14 },
    { type = "turnin", questName = "Scarab Shells", zone = "Tanaris", location = "Gadgetzan", logCount = 13 },
    { type = "turnin", questName = "Troll Temper", zone = "Tanaris", location = "Gadgetzan", logCount = 12 },
    {
      type = "turnin", questName = "Sprinkle's Secret Ingredient", zone = "Tanaris",
      location = "Gadgetzan", logCount = 11,
    },
    {
      type = "accept", questName = "Delivery for Marin", zone = "Tanaris",
      location = "Gadgetzan", logCount = 12,
    },
    {
      type = "turnin", questName = "Delivery for Marin", zone = "Tanaris",
      location = "Gadgetzan", logCount = 11,
    },
    {
      type = "accept", questName = "Noggenfogger Elixir", zone = "Tanaris",
      location = "Gadgetzan", logCount = 12,
    },
    {
      type = "turnin", questName = "Noggenfogger Elixir", zone = "Tanaris",
      location = "Gadgetzan", logCount = 11,
    },
    {
      type = "turnin", questName = "Gahz'rilla", zone = "Thousand Needles",
      location = "Shimmering Flats", logCount = 10,
      note = "Note: Abandon if you didnt do Jintha'alor",
    },
    {
      type = "travel", name = "Tanaris to Thunderbluff", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Return to Thunder Bluff (part 2)",
      questName = "Return to Thunder Bluff", ambiguous = true, zone = "Thunder Bluff",
      location = "Elder Rise", logCount = 9,
    },
    {
      type = "accept", questName = "A Future Task", zone = "Thunder Bluff",
      location = "Elder Rise", logCount = 10,
    },
    {
      type = "turnin", questName = "A Future Task", zone = "Thunder Bluff",
      location = "Thunderbluff", logCount = 9, note = "Note: End of Platinum Discs",
    },
    { type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", location = "Thunderbluff", logCount = 9 },
    {
      type = "travel", name = "Thunderbluff to Camp Mojache", zone = "Thunder Bluff",
      location = "Thunderbluff", logCount = 9, note = "Take the flight path.",
    },
    {
      type = "note", name = "Note", note = "Set Hearth to Camp Mojache", zone = "Tanaris",
      location = "Gadgetzan",
    },
    {
      type = "turnin", questName = "Testing the Vessel", zone = "Feralas",
      location = "Camp Mojache", logCount = 8,
    },
    {
      type = "accept", questName = "Vengeance on the Northspring", zone = "Feralas",
      location = "Camp Mojache", logCount = 9,
    },
    { type = "accept", questName = "Dark Heart", zone = "Feralas", location = "Camp Mojache", logCount = 10 },
    {
      type = "complete", questName = "Vengeance on the Northspring", zone = "Feralas",
      location = "Camp Mojache", logCount = 10,
    },
    { type = "complete", questName = "Dark Heart", zone = "Feralas", location = "Camp Mojache", logCount = 10 },
    { type = "note", name = "Note", note = "Run to Shadowprey" },
    {
      type = "travel", name = "Get the FP in Shadowprey", zone = "Desolace",
      location = "Shadowprey Village", logCount = 10, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Vyletongue Corruption", zone = "Desolace",
      location = "Shadowprey Village", logCount = 11,
    },
    {
      type = "accept", questName = "Corruption of Earth and Seed", zone = "Desolace",
      location = "Shadowprey Village", logCount = 12,
    },
    {
      type = "accept", questName = "The Pariah's Instructions", zone = "Desolace",
      location = "South of Mannoroc", logCount = 13,
      note = "Location of pariah here (he pats) ^^^^^^^",
    },
    {
      type = "accept", questName = "Twisted Evil", zone = "Desolace", location = "Kormeks Hut",
      logCount = 14, note = "Location of Willow (quest Giver)---->>",
    },
    {
      type = "note", name = "Note",
      note = "Head to the outide side of Purple Side (get shadow shadow shards, then go orange side)",
    },
    {
      type = "complete", questName = "The Pariah's Instructions", zone = "Desolace",
      location = "Center Area of Mara", logCount = 14,
      note = "Partial progress - work on this while you are here, then move on. Kill and loot The Nameless Prophet, go to the scepter portal and kill/loot Khan",
    },
    {
      type = "complete", questName = "Shadowshard Fragments", zone = "Desolace",
      location = "Purple Outside Mara", logCount = 14,
    },
    {
      type = "complete", questName = "The Pariah's Instructions", zone = "Desolace",
      location = "Purple Outside Mara", logCount = 14,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", questName = "Legends of Maraudon", zone = "Desolace",
      location = "Orange Outside Mara", logCount = 15,
    },
    {
      type = "complete", questName = "Vyletongue Corruption", zone = "Desolace",
      location = "Orange Outside Mara", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "The Pariah's Instructions", zone = "Desolace",
      location = "Orange Outside Mara", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on. Kill Khan outside orange side, left of portal",
    },
    {
      type = "complete", questName = "Vyletongue Corruption", zone = "Maraudon",
      location = "Orange Side", logCount = 15,
    },
    {
      type = "complete", questName = "The Pariah's Instructions", zone = "Maraudon",
      location = "Orange Side", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Legends of Maraudon", zone = "Maraudon",
      location = "Orange Side", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on. Kill / loot Noxious, make sure everyone looted it",
    },
    {
      type = "note", name = "Note",
      note = "Clear Orange and then back track into Purple side, to VyleTounge and possibly further for the Khan",
    },
    {
      type = "note", name = "Note",
      note = "Need to clear purple side till you reach the 4th Khan (he pats) and should be \"ghostly\", keep an eye out.",
    },
    {
      type = "complete", questName = "The Pariah's Instructions", zone = "Maraudon",
      location = "Purple Side", logCount = 15,
    },
    {
      type = "complete", questName = "Legends of Maraudon", zone = "Maraudon",
      location = "Purple Side", logCount = 15,
      note = "Kill / loot Vyletongue, make sure everyone looted it",
    },
    {
      type = "accept", questName = "The Scepter of Celebras", zone = "Maraudon",
      location = "Celebras", logCount = 15,
    },
    { type = "accept", questName = "Seed of Life", zone = "Maraudon", location = "Mara Princess", logCount = 15 },
    { type = "note", name = "Note", note = "Grind Mare Purple to Celebras and reset till 51", location = "-" },
    { type = "turnin", questName = "Twisted Evil", zone = "Desolace", location = "Kormeks Hut", logCount = 14 },
    {
      type = "turnin", questName = "The Pariah's Instructions", zone = "Desolace",
      location = "South of Mannoroc", logCount = 13,
    },
    {
      type = "turnin", questName = "Vyletongue Corruption", zone = "Desolace",
      location = "Shadowprey Village", logCount = 12,
    },
    {
      type = "turnin", questName = "Corruption of Earth and Seed", zone = "Desolace",
      location = "Shadowprey Village", logCount = 11,
    },
    {
      type = "note", name = "Note", note = "Hearth to Camp Mojache", zone = "Desolace",
      location = "Shadowprey Village",
    },
    {
      type = "turnin", questName = "Vengeance on the Northspring", zone = "Feralas",
      location = "Camp Mojache", logCount = 10,
    },
    { type = "turnin", questName = "Dark Heart", zone = "Feralas", location = "Camp Mojache", logCount = 9 },
    {
      type = "accept", questName = "Strength of Corruption", zone = "Feralas",
      location = "Camp Mojache", logCount = 10,
    },
    {
      type = "travel", name = "Shadowprey to Ogrimmar", zone = "Feralas",
      location = "Camp Mojache", logCount = 10, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Shadowshard Fragments", zone = "Orgrimmar",
      location = "Valley of Spirits", logCount = 9,
    },
    { type = "trainer", name = "Class Trainer", zone = "Orgrimmar", location = "Ogrimmar", logCount = 9 },
    {
      type = "travel", name = "Ogrimmar to Splintertree Post", zone = "Orgrimmar",
      location = "Ogrimmar", logCount = 9, note = "Take the flight path.",
    },
    { type = "note", name = "Note", note = "Azshara" },
    {
      type = "travel", name = "Orgrimmar to Splintertree Post", zone = "Orgrimmar",
      logCount = 9, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "A Land Filled with Hatred", zone = "Azshara",
      location = "Talrendis Point", logCount = 10,
    },
    {
      type = "accept", questName = "Spiritual Unrest", zone = "Azshara",
      location = "Talrendis Point", logCount = 11,
    },
    {
      type = "complete", questName = "Spiritual Unrest", zone = "Azshara",
      location = "Shadowsong Shrine", logCount = 11,
    },
    {
      type = "complete", questName = "A Land Filled with Hatred", zone = "Azshara",
      location = "Haldarr Encampment", logCount = 11,
    },
    {
      type = "turnin", questName = "A Land Filled with Hatred", zone = "Azshara",
      location = "Talrendis Point", logCount = 10,
    },
    {
      type = "turnin", questName = "Spiritual Unrest", zone = "Azshara",
      location = "Talrendis Point", logCount = 9,
    },
    {
      type = "accept", name = "Betrayed (part 1)", ambiguous = true, questName = "Betrayed",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Azshara", location = "Valormok",
    },
    {
      type = "turnin", name = "Betrayed (part 1)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Valormok", logCount = 8,
    },
    {
      type = "accept", name = "Betrayed (part 2)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Valormok", logCount = 9,
    },
    { type = "accept", questName = "Stealing Knowledge", zone = "Azshara", location = "Valormok", logCount = 10 },
    {
      type = "accept", questName = "Kim'jael Indeed!", zone = "Azshara",
      location = "Legash Encampment", logCount = 11,
    },
    {
      type = "complete", questName = "Kim'jael Indeed!", zone = "Azshara",
      location = "Thalassian Base Camp", logCount = 11,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Betrayed (part 2)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", logCount = 11,
    },
    {
      type = "turnin", name = "Betrayed (part 2)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", logCount = 10,
    },
    {
      type = "accept", name = "Betrayed (part 3)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", logCount = 11,
    },
    {
      type = "complete", name = "Betrayed (part 3)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", logCount = 11,
    },
    {
      type = "turnin", name = "Betrayed (part 3)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", logCount = 10,
    },
    {
      type = "accept", name = "Betrayed (part 4)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", logCount = 11,
    },
    {
      type = "complete", questName = "Kim'jael Indeed!", zone = "Azshara",
      location = "Thalassian Base Camp", logCount = 11,
    },
    {
      type = "turnin", questName = "Kim'jael Indeed!", zone = "Azshara",
      location = "Legash Encampment", logCount = 10,
    },
    {
      type = "accept", questName = "Kim'jael's \"Missing\" Equipment", zone = "Azshara",
      location = "Legash Encampment", logCount = 11,
    },
    {
      type = "complete", questName = "Stealing Knowledge", zone = "Azshara",
      location = "Ruins of Eldarath", logCount = 11,
    },
    {
      type = "complete", name = "Seeping Corruption (part 1)",
      questName = "Seeping Corruption", ambiguous = true, zone = "Azshara",
      location = "The Shattered Strand", logCount = 11,
    },
    {
      type = "complete", questName = "Kim'jael's \"Missing\" Equipment", zone = "Azshara",
      location = "The Shattered Strand", logCount = 11,
    },
    {
      type = "turnin", questName = "Kim'jael's \"Missing\" Equipment", zone = "Azshara",
      location = "Legash Encampment", logCount = 10,
    },
    { type = "turnin", questName = "Stealing Knowledge", zone = "Azshara", location = "Valormok", logCount = 9 },
    {
      type = "accept", questName = "Delivery to Andron Gant", zone = "Azshara",
      location = "Valormok", logCount = 10,
    },
    {
      type = "accept", questName = "Delivery to Archmage Xylem", zone = "Azshara",
      location = "Valormok", logCount = 11,
    },
    {
      type = "accept", questName = "Delivery to Jes'rimon", zone = "Azshara",
      location = "Valormok", logCount = 12,
    },
    {
      type = "accept", questName = "Delivery to Magatha", zone = "Azshara",
      location = "Valormok", logCount = 13,
    },
    {
      type = "turnin", questName = "Delivery to Archmage Xylem", zone = "Azshara",
      location = "Xylem's Tower", logCount = 12,
    },
    {
      type = "accept", questName = "Xylem's Payment to Jediga", zone = "Azshara",
      location = "Xylem's Tower", logCount = 13,
    },
    {
      type = "turnin", questName = "Xylem's Payment to Jediga", zone = "Azshara",
      location = "Valormok", logCount = 12,
    },
    {
      type = "travel", name = "Valomark to Spintertree", zone = "Azshara",
      location = "Valormok", logCount = 12, note = "Take the flight path.",
    },
})
