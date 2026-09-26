-- TuFFlevels / Routes/Horde/Dungeon/08-Felwood1.lua
--
-- Part 8 of the 5-man Horde 1-60 dungeon route.
-- Sections: Felwood #1 (level 51-52) | Un'goro Home Run! (level 51-52)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(8, {

    { type = "section", name = "Felwood #1 (level 51-52)", levels = { 51, 52 } },
    { type = "note", name = "Note", note = "Run to Felwood - Emerald Sanctuary" },
    {
      type = "accept", questName = "Timbermaw Ally", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 13,
    },
    {
      type = "accept", questName = "Forces of Jaedenar", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 14,
    },
    {
      type = "accept", questName = "Verifying the Corruption", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 15,
    },
    {
      type = "accept", questName = "Cleansing Felwood", zone = "Felwood",
      location = "West of Sanctuary", logCount = 16,
    },
    {
      type = "complete", questName = "Forces of Jaedenar", zone = "Felwood",
      location = "Jadenaar", logCount = 16,
    },
    {
      type = "accept", questName = "A Husband's Last Battle", zone = "Felwood",
      location = "Bloodvenom Post", logCount = 17,
    },
    {
      type = "complete", questName = "Timbermaw Ally", zone = "Felwood",
      location = "Deadwood Village", logCount = 17,
    },
    {
      type = "complete", questName = "A Husband's Last Battle", zone = "Felwood",
      location = "Deadwood Village", logCount = 17,
    },
    {
      type = "turnin", questName = "Timbermaw Ally", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 16,
    },
    {
      type = "accept", questName = "Speak to Nafien", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 17,
    },
    {
      type = "turnin", questName = "Forces of Jaedenar", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 16,
    },
    {
      type = "accept", questName = "Collection of the Corrupt Water", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 17,
    },
    {
      type = "complete", questName = "Collection of the Corrupt Water", zone = "Felwood",
      location = "Jadenaar", logCount = 17,
    },
    {
      type = "turnin", questName = "Collection of the Corrupt Water", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 16,
    },
    {
      type = "accept", questName = "Seeking Spiritual Aid", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 17,
    },
    {
      type = "complete", questName = "Verifying the Corruption", zone = "Felwood",
      location = "Shatter Scar Vale", logCount = 17,
    },
    {
      type = "complete", questName = "Strength of Corruption", zone = "Felwood",
      location = "Northeastern Felwood", logCount = 17,
    },
    {
      type = "complete", questName = "Cleansing Felwood", zone = "Felwood",
      location = "Irontree Cavern", logCount = 17,
    },
    {
      type = "turnin", questName = "Speak to Nafien", zone = "Felwood",
      location = "Felpaw Village", logCount = 16,
    },
    {
      type = "accept", questName = "Deadwood of the North", zone = "Felwood",
      location = "Felpaw Village", logCount = 17,
    },
    {
      type = "complete", questName = "Deadwood of the North", zone = "Felwood",
      location = "Felpaw Village", logCount = 17,
    },
    {
      type = "turnin", questName = "Deadwood of the North", zone = "Felwood",
      location = "Felpaw Village", logCount = 16,
    },
    {
      type = "note", optional = true, name = "Skip: Speak to Salfa",
      note = "The route deliberately skips Speak to Salfa.", zone = "Felwood",
      location = "Felpaw Village",
    },
    { type = "turnin", questName = "Seed of Life", zone = "Moonglade", logCount = 15 },
    {
      type = "travel", name = "Moonglade to Bloodvenom Post", zone = "Felwood",
      location = "Bloodvenom Post", logCount = 15, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "A Husband's Last Battle", zone = "Felwood",
      location = "Bloodvenom Post", logCount = 14,
    },
    {
      type = "travel", name = "Bloodvenom Post to Orgrimmar", zone = "Felwood",
      location = "Bloodvenom Post", logCount = 14, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Betrayed (part 4)", questName = "Betrayed", ambiguous = true,
      zone = "Orgrimmar", location = "Valley of Honor", logCount = 13,
    },
    {
      type = "turnin", questName = "Delivery to Jes'rimon", zone = "Orgrimmar",
      location = "The Drag", logCount = 12,
    },
    {
      type = "accept", questName = "Jes'rimon's Payment to Jediga", zone = "Orgrimmar",
      location = "The Drag", logCount = 13,
    },
    {
      type = "accept", questName = "Bone Bladed Weapons", zone = "Orgrimmar",
      location = "The Drag", logCount = 14,
    },
    {
      type = "accept", questName = "March of the Silithid", zone = "Orgrimmar",
      location = "The Drag (2nd level)", logCount = 15,
    },
    {
      type = "travel", name = "Orgrimmar to Undercrity", zone = "Orgrimmar",
      location = "Ogrimmar", logCount = 15, note = "Zeppelin.",
    },
    { type = "turnin", questName = "Delivery to Andron Gant", zone = "Undercity", logCount = 14 },
    { type = "accept", questName = "Andron's Payment to Jediga", zone = "Undercity", logCount = 15 },
    {
      type = "turnin", name = "Seeping Corruption (part 1)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "Apothocarium", logCount = 14,
    },
    {
      type = "accept", name = "Seeping Corruption (part 2)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "Apothocarium", logCount = 15,
    },
    {
      type = "turnin", name = "Seeping Corruption (part 2)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "Apothocarium", logCount = 14,
    },
    { type = "note", name = "Note", note = "Searing Detour" },
    {
      type = "note", name = "Note",
      note = "******* IMPORTANT---- get the 15 silk cloth out of your bank-----------IMPORTANT ********",
    },
    {
      type = "travel", name = "Undercity to Kargath", zone = "Undercity", logCount = 14,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Divine Retribution", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 15,
    },
    {
      type = "turnin", questName = "Divine Retribution", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 14,
    },
    {
      type = "accept", questName = "The Flawless Flame", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 15,
    },
    {
      type = "travel", name = "Grisha <Wind Rider Master>", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 15,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "note", optional = true, name = "Skip: WANTED: Overseer Maltorius",
      note = "Do not pick up WANTED: Overseer Maltorius yet - the route comes back for it.",
      zone = "Searing Gorge", location = "Thorium Point",
    },
    {
      type = "accept", questName = "JOB OPPORTUNITY: Culling the Competition",
      zone = "Searing Gorge", location = "Thorium Point", logCount = 16,
    },
    {
      type = "accept", questName = "STOLEN: Smithing Tuyere and Lookout's Spyglass",
      zone = "Searing Gorge", location = "Thorium Point", logCount = 17,
    },
    {
      type = "accept", questName = "Curse These Fat Fingers", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 18,
    },
    {
      type = "accept", questName = "Fiery Menace!", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 19,
    },
    {
      type = "note", optional = true, name = "Skip: Incendosaurs? Whateverosaur is More Like It",
      note = "Do not pick up Incendosaurs? Whateverosaur is More Like It yet - the route comes back for it.",
      zone = "Searing Gorge", location = "Thorium Point",
    },
    {
      type = "note", optional = true, name = "Skip: What the Flux?",
      note = "Do not pick up What the Flux? yet - the route comes back for it.",
      zone = "Searing Gorge", location = "Thorium Point",
    },
    {
      type = "complete", questName = "STOLEN: Smithing Tuyere and Lookout's Spyglass",
      zone = "Searing Gorge", logCount = 19,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Curse These Fat Fingers", zone = "Searing Gorge",
      logCount = 19,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    { type = "complete", questName = "Fiery Menace!", zone = "Searing Gorge", logCount = 19 },
    { type = "complete", questName = "The Flawless Flame", zone = "Searing Gorge", logCount = 19 },
    {
      type = "complete", questName = "STOLEN: Smithing Tuyere and Lookout's Spyglass",
      zone = "Searing Gorge", logCount = 19,
    },
    {
      type = "turnin", questName = "The Flawless Flame", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 18,
    },
    {
      type = "accept", questName = "Forging the Shaft", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 19,
    },
    {
      type = "turnin", questName = "Fiery Menace!", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 18,
    },
    {
      type = "turnin", questName = "STOLEN: Smithing Tuyere and Lookout's Spyglass",
      zone = "Searing Gorge", location = "Thorium Point", logCount = 17,
    },
    {
      type = "accept", questName = "Incendosaurs? Whateverosaur is More Like It",
      zone = "Searing Gorge", location = "Thorium Point", logCount = 18,
    },
    {
      type = "accept", questName = "What the Flux?", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 19,
    },
    {
      type = "accept", questName = "WANTED: Overseer Maltorius", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 20,
    },
    {
      type = "complete", questName = "What the Flux?", zone = "Searing Gorge",
      location = "The Cauldron", logCount = 20,
    },
    {
      type = "complete", questName = "WANTED: Overseer Maltorius", zone = "Searing Gorge",
      location = "The Cauldron", logCount = 20,
    },
    {
      type = "complete", questName = "Incendosaurs? Whateverosaur is More Like It",
      zone = "Searing Gorge", location = "The Cauldron", logCount = 20,
    },
    {
      type = "complete", questName = "JOB OPPORTUNITY: Culling the Competition",
      zone = "Searing Gorge", location = "The Cauldron", logCount = 20,
    },
    {
      type = "complete", questName = "Forging the Shaft", zone = "Searing Gorge",
      location = "The Cauldron", logCount = 20,
    },
    {
      type = "turnin", questName = "Forging the Shaft", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 19,
    },
    {
      type = "accept", questName = "The Flame's Casing", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 20,
    },
    {
      type = "turnin", questName = "Curse These Fat Fingers", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 19,
    },
    {
      type = "turnin", questName = "Incendosaurs? Whateverosaur is More Like It",
      zone = "Searing Gorge", location = "Thorium Point", logCount = 18,
    },
    {
      type = "turnin", questName = "What the Flux?", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 17,
    },
    {
      type = "turnin", questName = "WANTED: Overseer Maltorius", zone = "Searing Gorge",
      location = "Thorium Point", logCount = 16,
    },
    {
      type = "turnin", questName = "JOB OPPORTUNITY: Culling the Competition",
      zone = "Searing Gorge", location = "Thorium Point", logCount = 15,
    },
    {
      type = "complete", questName = "The Flame's Casing", zone = "Searing Gorge",
      location = "Firewatch Ridge", logCount = 15,
    },
    {
      type = "turnin", questName = "The Flame's Casing", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 14,
    },
    {
      type = "accept", name = "The Torch of Retribution (part 1)",
      questName = "The Torch of Retribution", ambiguous = true, zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 15,
    },
    {
      type = "turnin", name = "The Torch of Retribution (part 1)",
      questName = "The Torch of Retribution", ambiguous = true, zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 14,
    },
    {
      type = "accept", name = "The Torch of Retribution (part 2)",
      questName = "The Torch of Retribution", ambiguous = true, zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 15,
    },
    {
      type = "turnin", name = "The Torch of Retribution (part 2)",
      questName = "The Torch of Retribution", ambiguous = true, zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 14,
    },
    {
      type = "accept", questName = "Squire Maltrake", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 15,
    },
    {
      type = "turnin", questName = "Squire Maltrake", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 14,
    },
    {
      type = "accept", questName = "Set Them Ablaze!", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 15,
    },
    {
      type = "complete", questName = "Set Them Ablaze!", zone = "Searing Gorge",
      location = "The Cauldron", logCount = 15,
    },
    {
      type = "turnin", questName = "Set Them Ablaze!", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 14,
    },
    {
      type = "accept", questName = "Trinkets...", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 15,
    },
    {
      type = "turnin", questName = "Trinkets...", zone = "Searing Gorge",
      location = "Pyrox Flats", logCount = 14,
    },
    {
      type = "accept", questName = "The Key to Freedom", zone = "Searing Gorge", logCount = 15,
      note = "Starts from an item you loot, not from an NPC.",
    },
    {
      type = "accept", questName = "Caught!", zone = "Searing Gorge",
      location = "Grimesilt Digsite", logCount = 16,
    },
    {
      type = "complete", questName = "Caught!", zone = "Searing Gorge",
      location = "Grimesilt Digsite", logCount = 16,
      note = "Note: this is where you need the silk cloth",
    },
    {
      type = "turnin", questName = "Caught!", zone = "Searing Gorge",
      location = "Grimesilt Digsite", logCount = 15,
    },
    {
      type = "note", optional = true, name = "Skip: Ledger from Tanaris",
      note = "The route deliberately skips Ledger from Tanaris.", zone = "Searing Gorge",
      location = "Grimesilt Digsite",
    },
    {
      type = "turnin", questName = "The Key to Freedom", zone = "Searing Gorge",
      location = "Grimesilt Digsite", logCount = 14,
    },
    {
      type = "note", name = "Note",
      note = "Do the Searing Gorge -> Burning Steppes mountains skip to Flame Crest",
    },
    {
      type = "travel", name = "Vahgruk <Wind Rider Master>", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 14,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "turnin", questName = "Yuka Screwspigot", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 13,
    },
    {
      type = "note", optional = true, name = "Skip: Ribbly Screwspigot",
      note = "Do not pick up Ribbly Screwspigot yet - the route comes back for it.",
      zone = "Burning Steppes", location = "Flame Crest",
    },
    {
      type = "hearth", name = "Hearth to Camp Mojache", zone = "Burning Steppes",
      location = "Flame Crest", logCount = 13, note = "Use your hearthstone.",
    },
    { type = "note", name = "Note", note = "Back to Felwood" },
    {
      type = "travel", name = "Camp Mojache to Thunder Bluff", zone = "Feralas",
      location = "Camp Mojache", logCount = 13, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Delivery to Magatha", zone = "Thunder Bluff",
      location = "Elder Rise", logCount = 12,
    },
    {
      type = "accept", questName = "Magatha's Payment to Jediga", zone = "Thunder Bluff",
      location = "Elder Rise", logCount = 13,
    },
    {
      type = "travel", name = "Thunder Bluff to Ratchet", zone = "Thunder Bluff",
      logCount = 13, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Volcanic Activity", zone = "The Barrens",
      location = "Ratchet", logCount = 14,
    },
    {
      type = "complete", questName = "The Stone Circle", zone = "The Barrens",
      location = "Ratchet", logCount = 14,
      note = "Note: In a chest just outside of Liv Rizzlefix's workshop.",
    },
    {
      type = "turnin", questName = "Seeking Spiritual Aid", zone = "The Barrens",
      location = "Ratchet", logCount = 13, note = "Note: Island just north of ratchet",
    },
    {
      type = "accept", questName = "Cleansed Water Returns to Felwood", zone = "The Barrens",
      location = "Ratchet", logCount = 14,
    },
    {
      type = "travel", name = "Ratchet to Valormok", zone = "The Barrens",
      location = "Ratchet", logCount = 14, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Jes'rimon's Payment to Jediga", zone = "Azshara",
      location = "Valormok", logCount = 13,
    },
    {
      type = "turnin", questName = "Andron's Payment to Jediga", zone = "Azshara",
      location = "Valormok", logCount = 12,
    },
    {
      type = "turnin", questName = "Magatha's Payment to Jediga", zone = "Azshara",
      location = "Valormok", logCount = 11,
    },
    {
      type = "travel", name = "Valormok to Bloodvenom Post", zone = "Azshara",
      location = "Valormok", logCount = 11, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Cleansing Felwood", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 10,
    },
    {
      type = "note", optional = true, name = "Skip: Salve via Disenchanting",
      note = "The route deliberately skips Salve via Disenchanting.", zone = "Felwood",
      location = "Emerald Sanctuary",
    },
    {
      type = "accept", questName = "Salve via Hunting", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 11,
    },
    {
      type = "turnin", questName = "Cleansed Water Returns to Felwood", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 10,
    },
    {
      type = "accept", questName = "Dousing the Flames of Protection", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 11,
    },
    {
      type = "turnin", questName = "Verifying the Corruption", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 10,
    },
    {
      type = "complete", questName = "Dousing the Flames of Protection", zone = "Felwood",
      location = "Jadenaar", logCount = 10,
      note = "Note: It's the cave in the back of Jadenaar, not the front one.",
    },
    {
      type = "accept", questName = "A Strange Red Key", zone = "Felwood",
      location = "Jadenaar", logCount = 11, note = "Note: Item Drop",
    },
    { type = "turnin", questName = "A Strange Red Key", zone = "Felwood", location = "Jadenaar", logCount = 10 },
    {
      type = "accept", questName = "Rescue From Jaedenar", zone = "Felwood",
      location = "Jadenaar", logCount = 11, note = "Note: Escort",
    },
    {
      type = "complete", questName = "Rescue From Jaedenar", zone = "Felwood",
      location = "Jadenaar", logCount = 11,
    },
    {
      type = "turnin", questName = "Dousing the Flames of Protection", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 10,
    },
    {
      type = "accept", questName = "A Final Blow", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 11,
    },
    {
      type = "turnin", questName = "Rescue From Jaedenar", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 10,
    },
    {
      type = "accept", questName = "Retribution of the Light", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 11, note = "Note: Elite spawns.",
    },
    {
      type = "complete", questName = "Retribution of the Light", zone = "Felwood",
      location = "Jadenaar", logCount = 11,
    },
    { type = "complete", questName = "A Final Blow", zone = "Felwood", location = "Jadenaar", logCount = 11 },
    {
      type = "turnin", questName = "Retribution of the Light", zone = "Felwood",
      location = "Jadenaar", logCount = 10,
    },
    {
      type = "accept", questName = "The Remains of Trey Lightforge", zone = "Felwood",
      location = "Jadenaar", logCount = 11,
    },
    {
      type = "turnin", questName = "A Final Blow", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 10,
    },
    {
      type = "turnin", questName = "The Remains of Trey Lightforge", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 9, note = "w",
    },
    {
      type = "turnin", questName = "Salve via Hunting", zone = "Felwood",
      location = "Emerald Sanctuary", logCount = 8,
    },
    {
      type = "note", name = "Note", note = "Hearth to Camp Mojache", zone = "Felwood",
      location = "Emerald Sanctuary",
    },
    { type = "note", name = "Note", note = "If your hearth isnt up, if its short grind, if its long, fly." },
    {
      type = "turnin", questName = "Strength of Corruption", zone = "Feralas",
      location = "Camp Mojache", logCount = 7,
    },
    { type = "note", name = "Note", note = "Ungoro Grand \"Batter up!\"" },
    {
      type = "travel", name = "Camp Mojache to Gadgetzan", zone = "Feralas",
      location = "Camp Mojache", logCount = 7, note = "Take the flight path.",
    },
    { type = "accept", questName = "Super Sticky", zone = "Tanaris", location = "Gadgetzan", logCount = 8 },
    {
      type = "turnin", questName = "March of the Silithid", zone = "Tanaris",
      location = "Gadgetzan", logCount = 7,
    },
    {
      type = "accept", questName = "Bungle in the Jungle", zone = "Tanaris",
      location = "Gadgetzan", logCount = 8,
    },
    {
      type = "hearth", name = "Set Hearth to Gadgetzan", zone = "Tanaris",
      location = "Gadgetzan", logCount = 8, note = "Bind your hearthstone here.",
    },
    { type = "turnin", questName = "The Stone Circle", zone = "Tanaris", logCount = 7 },
    { type = "accept", questName = "Into the Depths", zone = "Tanaris", logCount = 8 },
    { type = "accept", questName = "Secret of the Circle", zone = "Tanaris", logCount = 9 },
    {
      type = "accept", questName = "The Fare of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 10,
    },
    {
      type = "accept", questName = "The Apes of Un'Goro", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 11,
    },
    {
      type = "manual", name = "\"Red, Blue Yellow, Green Crystal x7 each\"",
      zone = "Un'goro Crater", logCount = 11,
      note = "Collect these here. Note: they ARE tradeable to other group memebers, you will need alot so prio them",
    },
    {
      type = "manual", name = "One BLood Petal Sprout", zone = "Un'goro Crater", logCount = 11,
      note = "Collect these here. Note: Going to be in your bag for a very very very long time.",
    },
    {
      type = "complete", questName = "Bone-Bladed Weapons", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 11,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", name = "It's a Secret to Everybody (part 1)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 12,
    },
    {
      type = "turnin", name = "It's a Secret to Everybody (part 1)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 11,
    },
    {
      type = "accept", name = "It's a Secret to Everybody (part 2)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 12,
    },
    {
      type = "complete", questName = "The Fare of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 12,
    },
    {
      type = "turnin", questName = "The Fare of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 11,
    },
    {
      type = "accept", questName = "The Scent of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 12,
    },
    {
      type = "complete", questName = "The Scent of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 12,
    },
    {
      type = "complete", questName = "Bone-Bladed Weapons", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 12,
    },
    {
      type = "accept", questName = "Williden's Journal", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 13,
      note = "Note: It may not have dropped yet, just turn it in when it does.",
    },
    {
      type = "turnin", questName = "The Scent of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 12,
    },
    {
      type = "accept", questName = "The Bait for Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 13,
    },
    {
      type = "complete", questName = "\"Red, Blue Yellow, Green Crystal x7 each\"",
      zone = "Un'goro Crater", logCount = 13,
      note = "Note: FINISH them before going back to Marshals.",
    },
    {
      type = "complete", questName = "Super Sticky", zone = "Un'goro Crater",
      location = "Lakkari Tar Pits", logCount = 13,
      note = "Partial progress - work on this while you are here, then move on. Note: Low Drop rate, kill as many as you can while you wait for people @ Crystals.",
    },
    {
      type = "note", optional = true, name = "Skip: Chasing A-Me 01 (part 1)",
      note = "Do not pick up Chasing A-Me 01 (part 1) yet - the route comes back for it.",
      zone = "Un'goro Crater", location = "Marshal's Refuge",
    },
    {
      type = "turnin", questName = "Williden's Journal", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 12,
      note = "Note: It may not have dropped yet, just turn it in when it does.",
    },
    {
      type = "turnin", name = "It's a Secret to Everybody (part 2)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 11,
    },
    {
      type = "note", optional = true, name = "Skip: It's a Secret to Everybody (part 3)",
      note = "Do not pick up It's a Secret to Everybody (part 3) yet - the route comes back for it.",
      zone = "Un'goro Crater", location = "Marshal's Refuge",
    },
    {
      type = "note", optional = true, name = "Skip: Alien Ecology",
      note = "Do not pick up Alien Ecology yet - the route comes back for it.",
      zone = "Un'goro Crater", location = "Marshal's Refuge",
    },
    {
      type = "note", optional = true, name = "Skip: Lost!",
      note = "Do not pick up Lost! yet - the route comes back for it.",
      zone = "Un'goro Crater", location = "Marshal's Refuge",
    },
    {
      type = "accept", questName = "Expedition Salvation", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 12,
    },
    {
      type = "accept", questName = "Roll the Bones", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 13,
      note = "Note:Might be an issue, to get enough for everyone, play it by ear",
    },
    {
      type = "accept", questName = "Shizzle's Flyer", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 14,
    },
    {
      type = "accept", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 15,
    },
    {
      type = "accept", questName = "Larion and Muigin", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 16,
    },
    {
      type = "travel", name = "Gryfe <Flight Master>", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 16,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "accept", questName = "Crystals of Power", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 17,
    },
    {
      type = "turnin", questName = "Crystals of Power", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 16,
    },
    {
      type = "accept", questName = "The Eastern Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 17,
    },
    {
      type = "accept", questName = "Alien Ecology", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 18,
    },
    {
      type = "note", optional = true, name = "Skip: The Western Pylon",
      note = "Do not pick up The Western Pylon yet - the route comes back for it.",
      zone = "Un'goro Crater", location = "Marshal's Refuge",
    },
    {
      type = "manual", name = "Un'goro Soil x5", zone = "Un'goro Crater", logCount = 18,
      note = "Collect these here. Note: Just dont sell Soil till after ungoro",
    },
    {
      type = "complete", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "Fungal Rock", logCount = 18,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "The Northern Pylon", zone = "Un'goro Crater",
      location = "Fungal Rock", logCount = 18,
    },
    {
      type = "complete", questName = "The Apes of Un'Goro", zone = "Un'goro Crater",
      location = "Fungal Rock", logCount = 18,
    },
    {
      type = "complete", questName = "Super Sticky", zone = "Un'goro Crater",
      location = "Lakkari Tar Pits", logCount = 18, note = "Note:potential to be a grind",
    },
    {
      type = "complete", questName = "Larion and Muigin", zone = "Un'goro Crater",
      location = "Northeastern Un'goro", logCount = 18,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Expedition Salvation", zone = "Un'goro Crater",
      location = "Northeastern Un'goro", logCount = 18,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Roll the Bones", zone = "Un'goro Crater",
      location = "Northeastern Un'goro", logCount = 18,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Shizzle's Flyer", zone = "Un'goro Crater",
      location = "Northeastern Un'goro", logCount = 18,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "The Eastern Pylon", zone = "Un'goro Crater",
      location = "Ironstone Plateau", logCount = 18,
    },
    {
      type = "complete", questName = "The Bait for Lar'korwi", zone = "Un'goro Crater",
      location = "Ironstone Plateau", logCount = 18,
    },
    {
      type = "turnin", questName = "The Bait for Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 17,
    },
    {
      type = "turnin", questName = "The Apes of Un'Goro", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 16,
    },
    {
      type = "accept", questName = "The Mighty U'cha", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 17,
    },
    {
      type = "complete", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "The Slithering Scar", logCount = 17,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Bungle in the Jungle", zone = "Un'goro Crater",
      location = "The Slithering Scar", logCount = 17,
    },
    {
      type = "hearth", name = "Hearth to Gadgetzan", zone = "Un'goro Crater",
      location = "The Slithering Scar", logCount = 17, note = "Use your hearthstone.",
    },

    { type = "section", name = "Un'goro Home Run! (level 51-52)", levels = { 51, 52 }, zone = "Tanaris" },
    { type = "turnin", questName = "Super Sticky", zone = "Tanaris", location = "Gadgetzan", logCount = 16 },
    {
      type = "turnin", questName = "Bungle in the Jungle", zone = "Tanaris",
      location = "Gadgetzan", logCount = 15,
    },
    {
      type = "accept", questName = "Pawn Captures Queen", zone = "Tanaris",
      location = "Gadgetzan", logCount = 16,
    },
    {
      type = "travel", name = "Gadgetzan to Marshal's Refuge", zone = "Tanaris",
      location = "Gadgetzan", logCount = 16, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Alien Ecology", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 17,
    },
    {
      type = "accept", questName = "Lost!", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 18,
    },
    {
      type = "accept", questName = "The Northern Pylon",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Un'goro Crater", location = "Marshal's Refuge",
    },
    {
      type = "turnin", questName = "The Northern Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 17,
    },
    {
      type = "turnin", questName = "The Eastern Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 16,
    },
    {
      type = "accept", questName = "The Western Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 17,
    },
    {
      type = "accept", name = "Chasing A-Me 01 (part 1)", questName = "Chasing A-Me 01",
      ambiguous = true, zone = "Un'goro Crater", location = "Marshal's Refuge", logCount = 18,
    },
    {
      type = "manual", name = "One blood petal Sprout", zone = "Un'goro Crater",
      location = "Ungoro Crater", logCount = 18,
      note = "Collect these here. Note this is going to sit in your bag for a very long time!",
    },
    {
      type = "complete", questName = "The Mighty U'cha", zone = "Un'goro Crater",
      location = "Fungal Rock", logCount = 18,
    },
    {
      type = "turnin", name = "Chasing A-Me 01 (part 1)", questName = "Chasing A-Me 01",
      ambiguous = true, zone = "Un'goro Crater", location = "Fungal Rock", logCount = 17,
    },
    {
      type = "note", optional = true, name = "Skip: Chasing A-Me 01 (part 2)",
      note = "The route deliberately skips Chasing A-Me 01 (part 2).", zone = "Un'goro Crater",
      location = "Fungal Rock",
    },
    {
      type = "complete", questName = "Shizzle's Flyer", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", logCount = 17,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", logCount = 17,
    },
    {
      type = "complete", questName = "Larion and Muigin", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", logCount = 17,
    },
    {
      type = "complete", questName = "The Western Pylon", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", logCount = 17,
    },
    {
      type = "accept", questName = "Finding the Source", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", logCount = 18,
      note = "Note: Need to belevel 51, should be by now",
    },
    {
      type = "complete", questName = "Expedition Salvation", zone = "Un'goro Crater",
      location = "Terror Run", logCount = 18,
    },
    {
      type = "complete", questName = "Roll the Bones", zone = "Un'goro Crater",
      location = "Terror Run", logCount = 18,
    },
    {
      type = "complete", questName = "Alien Ecology", zone = "Un'goro Crater",
      location = "The Slithering Scar", logCount = 18,
    },
    {
      type = "complete", questName = "Pawn Captures Queen", zone = "Un'goro Crater",
      location = "The Slithering Scar", logCount = 18,
    },
    {
      type = "turnin", questName = "The Mighty U'cha", zone = "Un'goro Crater",
      location = "The Marshlands", logCount = 17,
    },
    {
      type = "complete", questName = "Shizzle's Flyer", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", logCount = 17,
    },
    {
      type = "complete", questName = "Volcanic Activity", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", logCount = 17,
    },
    {
      type = "complete", questName = "Finding the Source", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", logCount = 17,
    },
    {
      type = "turnin", questName = "Lost!", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", logCount = 16,
    },
    {
      type = "accept", questName = "A Little Help From My Friends", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", logCount = 17, note = "Note: Goblen side of mountain.",
    },
    {
      type = "complete", questName = "A Little Help From My Friends", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", logCount = 17,
    },
    {
      type = "turnin", questName = "A Little Help From My Friends", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 16,
    },
    {
      type = "turnin", questName = "Alien Ecology", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 15,
    },
    {
      type = "turnin", questName = "Roll the Bones", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 14,
    },
    {
      type = "turnin", questName = "Expedition Salvation", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 13,
    },
    {
      type = "turnin", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 12,
    },
    {
      type = "turnin", questName = "Larion and Muigin", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 11,
    },
    {
      type = "accept", questName = "Marvon's Workshop", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 12,
    },
    {
      type = "turnin", questName = "Shizzle's Flyer", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 11,
    },
    {
      type = "turnin", questName = "The Western Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 10,
    },
    {
      type = "accept", questName = "Making Sense of It", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 11,
    },
    {
      type = "turnin", questName = "Making Sense of It", zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 10,
    },
    {
      type = "accept", name = "It's a Secret to Everybody (part 3)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "Marshal's Refuge", logCount = 11,
    },
    {
      type = "turnin", questName = "Finding the Source", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", logCount = 10,
    },
    {
      type = "accept", questName = "The New Springs", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", logCount = 11,
    },
    {
      type = "hearth", name = "Hearth to Gadgetzan", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", logCount = 11, note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Pawn Captures Queen", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10,
    },
    {
      type = "accept", name = "Calm Before the Storm (part 1)",
      questName = "Calm Before the Storm", ambiguous = true, zone = "Tanaris",
      location = "Gadgetzan", logCount = 11,
    },
    {
      type = "travel", name = "Gadgetzan to Racthet", zone = "Tanaris", location = "Gadgetzan",
      logCount = 11, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Volcanic Activity", zone = "The Barrens",
      location = "Ratchet", logCount = 10,
    },
    {
      type = "turnin", questName = "Marvon's Workshop", zone = "The Barrens",
      location = "Ratchet", logCount = 9,
    },
    { type = "accept", questName = "Zapper Fuel", zone = "The Barrens", location = "Ratchet", logCount = 10 },
    {
      type = "travel", name = "Ratchet to Orgrimmar", zone = "The Barrens",
      location = "Ratchet", logCount = 10, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Bone-Bladed Weapons",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Orgrimmar", location = "The Drag",
    },
    {
      type = "turnin", questName = "Bone-Bladed Weapons", zone = "Orgrimmar",
      location = "The Drag", logCount = 9,
    },
    {
      type = "turnin", name = "Calm Before the Storm (part 1)",
      questName = "Calm Before the Storm", ambiguous = true, zone = "Orgrimmar",
      location = "The Drag", logCount = 8,
    },
    {
      type = "accept", name = "Calm Before the Storm (part 2)",
      questName = "Calm Before the Storm", ambiguous = true, zone = "Orgrimmar",
      location = "The Drag", logCount = 9,
    },
    {
      type = "turnin", name = "Calm Before the Storm (part 2)",
      questName = "Calm Before the Storm", ambiguous = true, zone = "Orgrimmar",
      location = "Valley of Strength", logCount = 8,
    },
})
