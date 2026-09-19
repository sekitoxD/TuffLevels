-- TuFFlevels / Routes/Horde/Dungeon/04-DesolaceSnoozeFest1.lua
--
-- Part 4 of the 5-man Horde 1-60 dungeon route.
-- Sections: Desolace Snooze Fest #1 (level 32-34) | Desolace Snooze Fest #2 (level 32-34) | SM Graveyard Farm (level 32-34) | SM Graveyard Farm (level 34-36) | Arathi Highlands #1 (level 36-36) | SM Armory Farm (level 36-36) | SM Cathedral Farm (level 36-36)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(4, {

    { type = "section", name = "Desolace Snooze Fest #1 (level 32-34)", levels = { 32, 34 }, zone = "Orgrimmar" },
    {
      type = "accept", name = "Alliance Relations (part 1)", questName = "Alliance Relations",
      ambiguous = true, zone = "Orgrimmar", location = "The Cleft of Shadow", logCount = 9,
      note = "Note: In theDrag",
    },
    {
      type = "turnin", name = "Alliance Relations (part 1)", questName = "Alliance Relations",
      ambiguous = true, zone = "Orgrimmar", location = "Orgrimmar West Gate", logCount = 8,
    },
    {
      type = "accept", name = "Alliance Relations (part 2)", questName = "Alliance Relations",
      ambiguous = true, zone = "Orgrimmar", location = "Orgrimmar West Gate", logCount = 9,
    },
    { type = "turnin", questName = "Rig Wars", zone = "Orgrimmar", logCount = 8 },
    { type = "turnin", questName = "Return of the Ring", zone = "Orgrimmar", logCount = 7 },
    { type = "trainer", name = "Class Trainer", zone = "Orgrimmar", logCount = 7 },
    {
      type = "travel", name = "Orgrimmar to Sun Rock Retreat", zone = "The Barrens",
      location = "The Crossroads", logCount = 7, note = "Take the flight path.",
    },
    {
      type = "note", name = "Skip: Bone Collector",
      note = "The route deliberately skips Bone Collector.", zone = "Desolace",
      location = "Kormek's Hut",
    },
    {
      type = "note", name = "Skip: Bodyguard for Hire",
      note = "The route deliberately skips Bodyguard for Hire.", zone = "Desolace",
      location = "Kormek's Hut",
    },
    {
      type = "note", name = "Skip: Catch of the Day",
      note = "The route deliberately skips Catch of the Day.", zone = "Desolace",
      location = "Ghostwalker Post",
    },
    {
      type = "turnin", name = "Alliance Relations (part 2)", questName = "Alliance Relations",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 6,
    },
    {
      type = "accept", name = "Alliance Relations (part 3)", questName = "Alliance Relations",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 7,
    },
    {
      type = "accept", questName = "Befouled by Satyr", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 8,
    },
    {
      type = "turnin", name = "Alliance Relations (part 3)", questName = "Alliance Relations",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 7,
    },
    {
      type = "accept", questName = "The Burning of Spirits", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 8,
    },
    {
      type = "accept", questName = "The Kolkar of Desolace",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Desolace", location = "Ghostwalker Post",
    },
    {
      type = "turnin", questName = "The Kolkar of Desolace", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 7,
    },
    {
      type = "accept", questName = "Khan Dez'hepah", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 8,
    },
    {
      type = "accept", questName = "Gelkis Alliance", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 9,
    },
    {
      type = "accept", questName = "Kodo Roundup", zone = "Desolace",
      location = "Scrabblescrew's Camp", logCount = 10,
    },
    {
      type = "complete", questName = "Khan Dez'hepah", zone = "Desolace",
      location = "Kolkar Village", logCount = 10,
    },
    {
      type = "turnin", questName = "Khan Dez'hepah", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 9,
    },
    {
      type = "accept", questName = "Centaur Bounty", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 10,
    },
    {
      type = "complete", questName = "Kodo Roundup", zone = "Desolace",
      location = "Kodo Graveyard", logCount = 10,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Centaur Bounty", zone = "Desolace",
      location = "Magram Village", logCount = 10,
    },
    {
      type = "complete", questName = "Gelkis Alliance", zone = "Desolace",
      location = "Magram Village", logCount = 10,
    },
    {
      type = "turnin", questName = "Gelkis Alliance", zone = "Desolace",
      location = "Gelkis Village", logCount = 9,
    },
    {
      type = "accept", questName = "Stealing Supplies", zone = "Desolace",
      location = "Gelkis Village", logCount = 10,
    },
    {
      type = "accept", questName = "Hunting in Stranglethorn", zone = "Desolace",
      location = "Shadowprey Village", logCount = 11,
    },
    {
      type = "accept", questName = "Hand of Iruxos", zone = "Desolace",
      location = "Shadowprey Village", logCount = 12,
    },
    {
      type = "note", name = "Skip: Clam Bait",
      note = "The route deliberately skips Clam Bait.", zone = "Desolace",
      location = "Shadowprey Village",
    },
    {
      type = "accept", questName = "Other Fish to Fry", zone = "Desolace",
      location = "Shadowprey Village", logCount = 13,
    },

    { type = "section", name = "Desolace Snooze Fest #2 (level 32-34)", levels = { 32, 34 }, zone = "Desolace" },
    {
      type = "accept", questName = "Sceptre of Light", zone = "Desolace",
      location = "Ethel Rethor", logCount = 14,
    },
    {
      type = "complete", questName = "Sceptre of Light", zone = "Desolace",
      location = "Thunder Axe Fortress", logCount = 14,
    },
    {
      type = "complete", questName = "Hand of Iruxos", zone = "Desolace",
      location = "Thunder Axe Fortress", logCount = 14,
    },
    {
      type = "complete", questName = "The Burning of Spirits", zone = "Desolace",
      location = "Thunder Axe Fortress", logCount = 14,
    },
    {
      type = "accept", name = "The Corrupter (part 1)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Thunder Axe Fortress", logCount = 15,
    },
    {
      type = "turnin", name = "The Corrupter (part 1)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 14,
    },
    {
      type = "accept", name = "The Corrupter (part 2)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 15,
    },
    {
      type = "turnin", questName = "The Burning of Spirits", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 14,
    },
    {
      type = "accept", name = "Alliance Relations (part 4)", questName = "Alliance Relations",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 15,
    },
    {
      type = "turnin", questName = "Centaur Bounty", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 14,
    },
    {
      type = "complete", name = "The Corrupter (part 2)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Sargeron", logCount = 14,
    },
    {
      type = "complete", questName = "Befouled by Satyr", zone = "Desolace",
      location = "Sargeron", logCount = 14,
    },
    {
      type = "turnin", questName = "Befouled by Satyr", zone = "Desolace",
      location = "Ghostwalker Post", logCount = 13,
    },
    {
      type = "turnin", name = "The Corrupter (part 2)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 12,
    },
    {
      type = "accept", name = "The Corrupter (part 3)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 13,
    },
    {
      type = "turnin", questName = "Sceptre of Light", zone = "Desolace",
      location = "Ethel Rethor", logCount = 12,
    },
    {
      type = "accept", questName = "Book of the Ancients", zone = "Desolace",
      location = "Ethel Rethor", logCount = 13,
    },
    {
      type = "accept", questName = "Claim Rackmore's Treasure!", zone = "Desolace",
      location = "The Veiled Sea", logCount = 14,
    },
    {
      type = "complete", questName = "Other Fish to Fry", zone = "Desolace",
      location = "The Veiled Sea", logCount = 14,
    },
    {
      type = "complete", questName = "Book of the Ancients", zone = "Desolace",
      location = "The Veiled Sea", logCount = 14,
    },
    {
      type = "complete", questName = "Claim Rackmore's Treasure!", zone = "Desolace",
      location = "The Veiled Sea", logCount = 14,
    },
    {
      type = "complete", name = "The Corrupter (part 3)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "The Veiled Sea", logCount = 14,
    },
    {
      type = "turnin", questName = "Claim Rackmore's Treasure!", zone = "Desolace",
      location = "The Veiled Sea", logCount = 13,
    },
    {
      type = "note", name = "Note",
      note = "Note: Save the wand for Visc in AQ 40 if you're a caster!!!!!!!!!!!!!!!!!!!!!!!",
    },
    {
      type = "turnin", questName = "Book of the Ancients", zone = "Desolace",
      location = "Ethel Rethor", logCount = 12,
    },
    {
      type = "turnin", name = "The Corrupter (part 3)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 11,
    },
    {
      type = "accept", name = "The Corrupter (part 4)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 12,
    },
    {
      type = "turnin", name = "The Corrupter (part 4)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 11,
    },
    {
      type = "note", name = "Skip: The Corrupter (part 5)",
      note = "Do not pick up The Corrupter (part 5) yet - the route comes back for it.",
      zone = "Desolace", location = "Ghostwalker Post",
    },
    {
      type = "note", name = "Skip: Ghost-o-plasm Round Up",
      note = "Do not pick up Ghost-o-plasm Round Up yet - the route comes back for it.",
      zone = "Desolace", location = "Kodo Graveyard",
    },
    {
      type = "complete", questName = "Kodo Roundup", zone = "Desolace",
      location = "Kodo Graveyard", logCount = 11,
    },
    {
      type = "turnin", questName = "Kodo Roundup", zone = "Desolace",
      location = "Scrabblescrew's Camp", logCount = 10,
    },
    {
      type = "complete", questName = "Stealing Supplies", zone = "Desolace",
      location = "Magram Village", logCount = 10,
    },
    {
      type = "turnin", questName = "Stealing Supplies", zone = "Desolace",
      location = "Gelkis Village", logCount = 9,
    },
    {
      type = "note", name = "Skip: Ongeku", note = "The route deliberately skips Ongeku.",
      zone = "Desolace", location = "Gelkis Village",
    },
    {
      type = "turnin", questName = "Hand of Iruxos", zone = "Desolace",
      location = "Shadowprey Village", logCount = 8,
    },
    {
      type = "note", name = "Skip: Portals of the Legion",
      note = "Do not pick up Portals of the Legion yet - the route comes back for it.",
      zone = "Desolace", location = "Shadowprey Village",
    },
    {
      type = "turnin", questName = "Other Fish to Fry", zone = "Desolace",
      location = "Shadowprey Village", logCount = 7,
    },
    { type = "note", name = "Note", note = "\"You know where you are?!?!?!\"" },
    {
      type = "note", name = "Note", note = "Hearth to Undercity", zone = "Undercity",
      location = "Trade Quarter",
    },
    { type = "trainer", name = "Class Trainer", zone = "Undercity", logCount = 7 },
    {
      type = "travel", name = "Tirisfal Glades to Grom'Gol", zone = "Tirisfal Glades",
      location = "Brill", logCount = 7, note = "Zeppelin.",
    },
    {
      type = "accept", name = "The Defense of Grom'gol (part 1)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 8,
    },
    {
      type = "accept", name = "Mok'thardin's Enchantment (part 1)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 9,
    },
    {
      type = "note", name = "Skip: Bloody Bone Necklaces",
      note = "The route deliberately skips Bloody Bone Necklaces.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp",
    },
    {
      type = "note", name = "Skip: The Vile Reef",
      note = "Do not pick up The Vile Reef yet - the route comes back for it.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp",
    },
    {
      type = "accept", questName = "Hunt for Yenniku", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 10,
    },
    {
      type = "accept", questName = "Trollbane", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 11,
    },
    {
      type = "note", name = "Skip: Grim Message",
      note = "Do not pick up Grim Message yet - the route comes back for it.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp",
    },
    {
      type = "complete", questName = "Supply and Demand", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", logCount = 11,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Investigate the Camp", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", logCount = 11,
    },
    {
      type = "turnin", questName = "Hunting in Stranglethorn", zone = "Desolace",
      location = "Shadowprey Village", logCount = 10,
    },
    {
      type = "turnin", questName = "Hemet Nesingwary", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", logCount = 9,
    },
    {
      type = "accept", questName = "Welcome to the Jungle", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", logCount = 10,
    },
    {
      type = "turnin", questName = "Welcome to the Jungle", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", logCount = 9,
    },
    {
      type = "accept", name = "Raptor Mastery (part 1)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 10,
    },
    {
      type = "accept", name = "Tiger Mastery (part 1)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "accept", name = "Panther Mastery (part 1)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
    },
    {
      type = "note", name = "Skip: The Green Hills of Stranglethorn",
      note = "The route deliberately skips The Green Hills of Stranglethorn.",
      zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
    },
    {
      type = "complete", name = "Panther Mastery (part 1)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
    },
    {
      type = "complete", questName = "Supply and Demand", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Tiger Mastery (part 1)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
    },
    {
      type = "turnin", name = "Panther Mastery (part 1)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "accept", name = "Panther Mastery (part 2)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
    },
    {
      type = "turnin", name = "Tiger Mastery (part 1)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "accept", name = "Tiger Mastery (part 2)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
    },
    {
      type = "complete", name = "Tiger Mastery (part 2)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Hunt for Yenniku", zone = "Stranglethorn Vale",
      location = "Tkashi Ruins", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Welcome to the Jungle", zone = "Stranglethorn Vale",
      location = "Tkashi Ruins", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Tiger Mastery (part 2)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Northwest Stranglethorn",
      logCount = 12,
    },
    {
      type = "complete", name = "Panther Mastery (part 2)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Northwest Stranglethorn",
      logCount = 12,
    },
    {
      type = "complete", name = "Raptor Mastery (part 1)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Northwest Stranglethorn",
      logCount = 12,
    },
    {
      type = "complete", questName = "Hunt for Yenniku", zone = "Stranglethorn Vale",
      location = "Bal'lal Ruins", logCount = 12,
    },
    {
      type = "complete", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Bal'lal Ruins", logCount = 12,
    },
    {
      type = "turnin", name = "Raptor Mastery (part 1)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "accept", name = "Raptor Mastery (part 2)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
    },
    {
      type = "turnin", name = "Tiger Mastery (part 2)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "accept", name = "Tiger Mastery (part 3)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
    },
    {
      type = "turnin", name = "Panther Mastery (part 2)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "accept", name = "Panther Mastery (part 3)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 12,
    },
    {
      type = "complete", name = "Tiger Mastery (part 3)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Tkashi Ruins", logCount = 12,
    },
    {
      type = "complete", name = "The Defense of Grom'gol (part 1)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 12,
    },
    {
      type = "complete", name = "Raptor Mastery (part 2)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Grom'Gol Base Camp",
      logCount = 12,
    },
    {
      type = "turnin", questName = "Hunt for Yenniku", zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 11,
    },
    {
      type = "turnin", name = "The Defense of Grom'gol (part 1)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 10,
    },
    {
      type = "accept", name = "The Defense of Grom'gol (part 2)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 11,
    },
    {
      type = "complete", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Kunda", logCount = 11,
    },
    {
      type = "turnin", name = "Tiger Mastery (part 3)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 10,
    },
    {
      type = "accept", name = "Tiger Mastery (part 4)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "turnin", name = "Raptor Mastery (part 2)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Grom'Gol Base Camp",
      logCount = 10,
    },
    {
      type = "accept", name = "Raptor Mastery (part 3)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Grom'Gol Base Camp",
      logCount = 11,
    },
    {
      type = "travel", name = "Grom'Gol to Booty Bay", zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 11, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Supply and Demand", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 10,
    },
    {
      type = "accept", questName = "Hostile Takeover", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 11,
    },
    {
      type = "turnin", questName = "Investigate the Camp", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 10,
    },
    {
      type = "turnin", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9,
    },
    {
      type = "note", name = "Note", note = "Hearth to Undercity", zone = "Undercity",
      location = "Trade Quarter",
    },
    { type = "trainer", name = "Class Trainer", zone = "Undercity", logCount = 9 },
    {
      type = "turnin", name = "An Unholy Alliance (part 1)", questName = "An Unholy Alliance",
      ambiguous = true, zone = "Undercity", location = "Royal Quarter", logCount = 8,
    },
    {
      type = "turnin", questName = "\"Going, Going, Guano!\"", zone = "Undercity",
      location = "Apothocarium", logCount = 7,
    },
    {
      type = "accept", questName = "Hearts of Zeal", zone = "Undercity",
      location = "Apothocarium", logCount = 8,
    },
    {
      type = "note", name = "Farm rates",
      note = "Farm throughput from the source sheet - Level 33-34: Full Clear (586 - 439 xp/min, clear 15-20min).",
    },

    { type = "section", name = "SM Graveyard Farm (level 32-34)", levels = { 32, 34 } },
    {
      type = "note", name = "Note",
      note = "Note: it is imparative to have got a summon to Kargath to get FP , needed @ level 42, hearth back to UC after",
    },
    {
      type = "hearth", name = "Hearth to Undercity", zone = "Undercity",
      location = "Trade Quarter", logCount = 8, note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Hearts of Zeal", zone = "Undercity",
      location = "Apothocarium", logCount = 7,
    },
    {
      type = "accept", questName = "Into The Scarlet Monastery", zone = "Undercity",
      location = "Royal Quarter", logCount = 8,
    },

    { type = "section", name = "SM Graveyard Farm (level 34-36)", levels = { 34, 36 } },
    { type = "note", name = "Note", note = "SM Library Farm" },
    {
      type = "note", name = "Note",
      note = "Note: Might be worth it sending warriors to hearth to UC for Whirlwind and training at 36",
    },
    {
      type = "note", name = "Note",
      note = "Note: it is imparative to have got a summon to Kargath to get FP , needed @ level 42, hearth back to UC after",
    },
    {
      type = "note", name = "Farm rates",
      note = "Farm throughput from the source sheet - Level 34-35: Full Clear (640 - 426 xp/min, clear 20-30 Min); Level 35-36: Full Clear (608 - 405 xp/min, clear 20-30 Min); Level 36-37: Full Clear (567 - 378 xp/min, clear 20-30 Min).",
    },

    {
      type = "section", name = "Arathi Highlands #1 (level 36-36)", levels = { 36, 36 },
      zone = "Scarlet Monastery",
    },
    {
      type = "hearth", name = "Hearth to Undercity", zone = "Scarlet Monastery",
      location = "SM", logCount = 8, note = "Use your hearthstone.",
    },
    {
      type = "travel", name = "Undercity to Tarren Mill", zone = "Undercity", logCount = 8,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "The Hammer May Fall", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 9,
    },
    {
      type = "complete", questName = "The Hammer May Fall", zone = "Arathi Highlands",
      location = "Boulderfist Outpost", logCount = 9,
    },
    {
      type = "accept", questName = "The Princess Trapped", zone = "Arathi Highlands",
      location = "Circle of East Binding", logCount = 10,
    },
    {
      type = "travel", name = "Urda <Wind Rider Master>", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 10,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "hearth", name = "Set Hearth to Hammerfall", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 10, note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "The Real Threat", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11,
    },
    {
      type = "turnin", questName = "The Hammer May Fall", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 10,
    },
    {
      type = "accept", name = "Call to Arms (part 1)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 11,
    },
    {
      type = "turnin", questName = "Trollbane", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 10,
    },
    {
      type = "accept", questName = "Sigil of Strom", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", questName = "Hammerfall", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 12,
    },
    {
      type = "turnin", questName = "Hammerfall", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", name = "Raising Spirits (part 1)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 12,
    },
    {
      type = "complete", name = "Raising Spirits (part 1)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", logCount = 12,
    },
    {
      type = "complete", name = "Call to Arms (part 1)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Witherbark Village",
      logCount = 12,
    },
    {
      type = "turnin", name = "Raising Spirits (part 1)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", name = "Raising Spirits (part 2)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 12,
    },
    {
      type = "turnin", name = "Raising Spirits (part 2)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", name = "Raising Spirits (part 3)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 12,
    },
    {
      type = "turnin", name = "Call to Arms (part 1)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", name = "Call to Arms (part 2)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 12,
    },
    {
      type = "turnin", name = "Raising Spirits (part 3)", questName = "Raising Spirits",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", name = "Guile of the Raptor (part 1)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 12,
    },
    {
      type = "complete", questName = "The Princess Trapped", zone = "Arathi Highlands",
      location = "Drywhisker Gorge", logCount = 12,
    },
    {
      type = "turnin", questName = "The Princess Trapped", zone = "Arathi Highlands",
      location = "Drywhisker Gorge", logCount = 11,
    },
    {
      type = "accept", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Drywhisker Gorge", logCount = 12,
    },
    {
      type = "complete", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Circle of East Binding", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Circle of Outer Binding", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Circle of West Binding", logCount = 12,
    },
    {
      type = "turnin", questName = "Stones of Binding", zone = "Arathi Highlands",
      location = "Circle of Inner Binding", logCount = 11,
    },
    {
      type = "accept", questName = "Breaking the Keystone", zone = "Arathi Highlands",
      location = "Circle of Inner Binding", logCount = 12,
    },
    {
      type = "complete", name = "Guile of the Raptor (part 1)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Boulderfist Hall", logCount = 12,
    },
    {
      type = "complete", name = "Call to Arms (part 2)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Boulderfist Hall",
      logCount = 12,
    },
    {
      type = "hearth", name = "Hearth to Hammerfall", zone = "Arathi Highlands",
      location = "Boulderfist Hall", logCount = 12, note = "Use your hearthstone.",
    },
    {
      type = "turnin", name = "Call to Arms (part 2)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", name = "Call to Arms (part 3)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 12,
    },
    {
      type = "turnin", name = "Guile of the Raptor (part 1)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", name = "Guile of the Raptor (part 2)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 12,
    },
    {
      type = "turnin", name = "Guile of the Raptor (part 2)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", name = "Guile of the Raptor (part 3)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 12,
    },
    {
      type = "turnin", name = "Guile of the Raptor (part 3)",
      questName = "Guile of the Raptor", ambiguous = true, zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11,
    },
    {
      type = "travel", name = "Hammerfall to Undercity", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11, note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Undercity", zone = "Undercity", logCount = 11,
      note = "Use your hearthstone.",
    },
    {
      type = "note", name = "Farm rates",
      note = "Farm throughput from the source sheet - Level 37-38: Full Clear (562 - 375 xp/min, clear 20-30 Min); Level 38-39: Full Clear (516 - 344 xp/min, clear 20-30 Min).",
    },

    { type = "section", name = "SM Armory Farm (level 36-36)", levels = { 36, 36 } },
    {
      type = "note", name = "Note",
      note = "Note: it is imparative to have got a summon to Kargath to get FP , needed by level 42, hearth back to UC after",
    },
    {
      type = "note", name = "Farm rates",
      note = "Farm throughput from the source sheet - Level 39-40: Full Clear (805 - 537 xp/min, clear 20-30 Min); Level 40-41: Full Clear (772 - 515 xp/min, clear 20-30 Min); Level 41-42: Full Clear (714 - 476 xp/min, clear 20-30 Min).",
    },

    { type = "section", name = "SM Cathedral Farm (level 36-36)", levels = { 36, 36 } },
    { type = "note", name = "Note", note = "Note: Probably worth it to Hearth to UC at 40 to train" },
    {
      type = "note", name = "Note",
      note = "Note: it is imparative to have got a summon to Kargath to get FP , needed @ level 42, hearth back to UC after",
    },
})
