-- TuFFlevels / Routes/Horde/Solo/Desolace.lua
--
-- Desolace leg(s) of the solo Orc/Troll 1-60 route. Levels 33-41.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 28: Desolace East | Chapter 29: Desolace North
Leg(16, "Desolace", {

    { type = "section", name = "Chapter 28: Desolace East", levels = { 33, 33 }, zone = "Desolace" },
    {
      type = "travel", name = "Thunder Bluff to Sunrock Retreat", zone = "Thunder Bluff",
      atLevel = 33, logCount = 9, x = 51.5, y = 30.3, note = "Take the flight path.",
    },
    {
      type = "manual", name = "Dread Swoop: Buzzard Wing x4", zone = "Desolace", atLevel = 33,
      logCount = 9, x = 60.0, y = 25.5, approx = true,
      note = "Start collecting this now - it drops over the whole leg, not in one spot.",
    },
    {
      type = "accept", questName = "Bone Collector", zone = "Desolace",
      location = "Kormek's Hut", atLevel = 33, logCount = 10, x = 62.2, y = 38.8,
    },
    {
      type = "note", optional = true, name = "Skip: B",
      note = "The route deliberately skips Bodyguard for Hire. Low XP for the travel time.",
      zone = "Desolace", location = "Kormek's Hut", atLevel = 33, x = 60.4, y = 38.0,
    },
    {
      type = "turnin", questName = "Family Tree", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 9, x = 55.4, y = 55.8,
    },
    {
      type = "note", optional = true, name = "Skip: C",
      note = "The route deliberately skips Catch of the Day. Low XP for the travel time.",
      zone = "Desolace", location = "Ghostwalker Post", atLevel = 33, x = 55.4, y = 55.8,
    },
    {
      type = "turnin", name = "Alliance Relations (part 2)", questName = "Alliance Relations",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 33,
      logCount = 8, x = 52.6, y = 54.2,
    },
    {
      type = "accept", name = "Alliance Relations (part 3)", questName = "Alliance Relations",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 33,
      logCount = 9, x = 52.6, y = 54.2,
    },
    {
      type = "accept", questName = "Befouled by Satyr", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 10, x = 52.6, y = 54.2,
    },
    {
      type = "turnin", name = "Alliance Relations (part 3)", questName = "Alliance Relations",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 33,
      logCount = 9, x = 52.2, y = 53.6,
    },
    {
      type = "accept", questName = "The Burning of Spirits", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 10, x = 52.2, y = 53.6,
    },
    {
      type = "turnin", questName = "The Kolkar of Desolace", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 9, x = 56.2, y = 59.4,
    },
    {
      type = "accept", questName = "Khan Dez'hepah", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 10, x = 56.2, y = 59.4,
    },
    {
      type = "accept", questName = "Gelkis Alliance", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 11, x = 56.2, y = 59.6,
    },
    {
      type = "note", optional = true, name = "Skip: M",
      note = "The route deliberately skips Magram Alliance. Low XP for the travel time.",
      zone = "Desolace", location = "Ghostwalker Post", atLevel = 33, x = 56.2, y = 59.6,
    },
    {
      type = "accept", questName = "Kodo Roundup", zone = "Desolace",
      location = "Scrabblescrew's Camp", atLevel = 33, logCount = 12, x = 60.8, y = 61.8,
    },
    {
      type = "complete", questName = "Khan Dez'hepah", zone = "Desolace",
      location = "Kolkar Village", atLevel = 33, logCount = 12, x = 73.4, y = 41.6,
    },
    {
      type = "turnin", questName = "Khan Dez'hepah", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 11, x = 56.2, y = 59.4,
    },
    {
      type = "accept", questName = "Centaur Bounty", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 12, x = 56.2, y = 59.4,
    },
    {
      type = "complete", questName = "Bone Collector", zone = "Desolace",
      location = "Kodo Graveyard", atLevel = 33, logCount = 12, x = 52.0, y = 59.0,
      approx = true,
    },
    {
      type = "complete", questName = "Kodo Roundup", zone = "Desolace",
      location = "Kodo Graveyard", atLevel = 33, logCount = 12, x = 52.0, y = 59.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Centaur Bounty", zone = "Desolace",
      location = "Magram Village", atLevel = 33, logCount = 12, x = 71.0, y = 73.0,
      approx = true,
    },
    {
      type = "complete", questName = "Gelkis Alliance", zone = "Desolace",
      location = "Magram Village", atLevel = 33, logCount = 12, x = 71.0, y = 73.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Gelkis Alliance", zone = "Desolace",
      location = "Gelkis Village", atLevel = 33, logCount = 11, x = 36.2, y = 79.2,
    },
    {
      type = "accept", questName = "Stealing Supplies", zone = "Desolace",
      location = "Gelkis Village", atLevel = 33, logCount = 12, x = 36.2, y = 79.2,
    },
    {
      type = "accept", questName = "Hunting in Stranglethorn", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 33, logCount = 13, x = 25.0, y = 72.2,
    },
    {
      type = "accept", questName = "Hand of Iruxos", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 33, logCount = 14, x = 25.8, y = 68.2,
    },
    {
      type = "accept", questName = "Clam Bait", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 33, logCount = 15, x = 22.6, y = 72.0,
    },
    {
      type = "note", name = "Note",
      note = "Consider skipping Clam Bait if you are not Undead or a Shaman/Warlock.",
      atLevel = 33,
    },
    {
      type = "accept", questName = "Other Fish to Fry", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 33, logCount = 16, x = 23.2, y = 72.8,
    },
    {
      type = "travel", name = "Thalon <Wind Rider Master>", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 33, logCount = 16, x = 21.6, y = 74.1,
      note = "Talk to the flight master and learn this flight point.",
    },

    { type = "section", name = "Chapter 29: Desolace North", levels = { 33, 34 }, zone = "Desolace" },
    {
      type = "accept", questName = "Sceptre of Light", zone = "Desolace",
      location = "Ethel Rethor", atLevel = 33, logCount = 17, x = 38.8, y = 27.2,
    },
    {
      type = "complete", questName = "Sceptre of Light", zone = "Desolace",
      location = "Thunder Axe Fortress", atLevel = 33, logCount = 17, x = 55.2, y = 30.2,
    },
    {
      type = "complete", questName = "Hand of Iruxos", zone = "Desolace",
      location = "Thunder Axe Fortress", atLevel = 33, logCount = 17, x = 55.0, y = 26.7,
    },
    {
      type = "complete", questName = "The Burning of Spirits", zone = "Desolace",
      location = "Thunder Axe Fortress", atLevel = 33, logCount = 17, x = 55.0, y = 29.0,
      approx = true,
    },
    {
      type = "accept", name = "The Corrupter (part 1)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Thunder Axe Fortress", atLevel = 33,
      logCount = 18, x = 55.0, y = 29.0, approx = true,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", questName = "Kodo Roundup", zone = "Desolace", atLevel = 33,
      logCount = 18, x = 59.0, y = 35.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "The Corrupter (part 1)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 33,
      logCount = 17, x = 52.2, y = 53.6,
    },
    {
      type = "accept", name = "The Corrupter (part 2)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 33,
      logCount = 18, x = 52.2, y = 53.6,
    },
    {
      type = "turnin", questName = "The Burning of Spirits", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 17, x = 52.2, y = 53.6,
    },
    {
      type = "turnin", questName = "Centaur Bounty", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 33, logCount = 16, x = 56.2, y = 59.4,
    },
    {
      type = "complete", name = "The Corrupter (part 2)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Sargeron", atLevel = 33, logCount = 16,
      x = 76.0, y = 21.0, approx = true,
    },
    {
      type = "complete", questName = "Befouled by Satyr", zone = "Desolace",
      location = "Sargeron", atLevel = 33, logCount = 16, x = 76.0, y = 21.0, approx = true,
    },
    {
      type = "turnin", questName = "Bone Collector", zone = "Desolace",
      location = "Kormek's Hut", atLevel = 33, logCount = 15, x = 62.2, y = 38.8,
    },
    {
      type = "turnin", questName = "Befouled by Satyr", zone = "Desolace",
      location = "Ghostwalker Post", atLevel = 34, logCount = 14, x = 52.6, y = 54.2,
    },
    {
      type = "accept", name = "Alliance Relations (part 4)", questName = "Alliance Relations",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 34,
      logCount = 15, x = 52.2, y = 53.6,
    },
    {
      type = "turnin", name = "The Corrupter (part 2)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 34,
      logCount = 14, x = 52.2, y = 53.6,
    },
    {
      type = "accept", name = "The Corrupter (part 3)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 34,
      logCount = 15, x = 52.2, y = 53.6,
    },
    {
      type = "turnin", questName = "Sceptre of Light", zone = "Desolace",
      location = "Ethel Rethor", atLevel = 34, logCount = 14, x = 38.8, y = 27.2,
    },
    {
      type = "accept", questName = "Book of the Ancients", zone = "Desolace",
      location = "Ethel Rethor", atLevel = 34, logCount = 15, x = 38.8, y = 27.2,
    },
    {
      type = "accept", questName = "Claim Rackmore's Treasure!", zone = "Desolace",
      location = "The Veiled Sea", atLevel = 34, logCount = 16, x = 36.1, y = 30.5,
    },
    {
      type = "complete", questName = "Claim Rackmore's Treasure!", zone = "Desolace",
      location = "The Veiled Sea", atLevel = 34, logCount = 16, x = 34.0, y = 33.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Clam Bait", zone = "Desolace",
      location = "The Veiled Sea", atLevel = 34, logCount = 16, x = 34.0, y = 33.0,
      approx = true,
    },
    {
      type = "complete", questName = "Other Fish to Fry", zone = "Desolace",
      location = "The Veiled Sea", atLevel = 34, logCount = 16, x = 34.0, y = 22.0,
      approx = true,
    },
    {
      type = "complete", questName = "Book of the Ancients", zone = "Desolace",
      location = "The Veiled Sea", atLevel = 34, logCount = 16, x = 28.2, y = 6.7,
    },
    {
      type = "complete", questName = "Claim Rackmore's Treasure!", zone = "Desolace",
      location = "The Veiled Sea", atLevel = 34, logCount = 16, x = 28.0, y = 7.0,
      approx = true,
    },
    {
      type = "complete", name = "The Corrupter (part 3)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "The Veiled Sea", atLevel = 34,
      logCount = 16, x = 28.0, y = 7.0, approx = true,
    },
    {
      type = "turnin", questName = "Claim Rackmore's Treasure!", zone = "Desolace",
      location = "The Veiled Sea", atLevel = 34, logCount = 15, x = 30.0, y = 8.7,
    },
    {
      type = "turnin", questName = "Book of the Ancients", zone = "Desolace",
      location = "Ethel Rethor", atLevel = 34, logCount = 14, x = 38.8, y = 27.2,
    },
    {
      type = "complete", questName = "Kodo Roundup", zone = "Desolace", atLevel = 34,
      logCount = 14, x = 59.0, y = 35.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "The Corrupter (part 3)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 34,
      logCount = 13, x = 52.2, y = 53.6,
    },
    {
      type = "accept", name = "The Corrupter (part 4)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 34,
      logCount = 14, x = 52.2, y = 53.6,
    },
    {
      type = "turnin", name = "The Corrupter (part 4)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 34,
      logCount = 13, x = 52.6, y = 54.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Corrupter #5 on a later pass.",
      zone = "Desolace", location = "Ghostwalker Post", atLevel = 34, x = 52.6, y = 54.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: G",
      note = "Do not pick up yet - the route comes back for Ghost-o-plasm Round Up on a later pass.",
      zone = "Desolace", location = "Kodo Graveyard", atLevel = 34, x = 47.8, y = 61.8,
    },
    {
      type = "complete", questName = "Kodo Roundup", zone = "Desolace",
      location = "Kodo Graveyard", atLevel = 34, logCount = 13, x = 52.0, y = 59.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Kodo Roundup", zone = "Desolace",
      location = "Scrabblescrew's Camp", atLevel = 34, logCount = 12, x = 60.8, y = 61.8,
    },
    {
      type = "complete", questName = "Stealing Supplies", zone = "Desolace",
      location = "Magram Village", atLevel = 34, logCount = 12, x = 71.0, y = 73.0,
      approx = true,
    },
    {
      type = "manual", name = "Dread Swoop: Buzzard Wing x4", zone = "Desolace", atLevel = 34,
      logCount = 12, x = 66.0, y = 68.0, approx = true,
      note = "You should have the full stack by now.",
    },
    {
      type = "turnin", questName = "Stealing Supplies", zone = "Desolace",
      location = "Gelkis Village", atLevel = 34, logCount = 11, x = 36.2, y = 79.2,
    },
    {
      type = "accept", questName = "Ongeku", zone = "Desolace", location = "Gelkis Village",
      atLevel = 34, logCount = 12, x = 36.2, y = 79.2,
    },
    {
      type = "turnin", questName = "Hand of Iruxos", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 34, logCount = 11, x = 25.8, y = 68.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: P",
      note = "Do not pick up yet - the route comes back for Portals of the Legion on a later pass.",
      zone = "Desolace", location = "Shadowprey Village", atLevel = 34, x = 25.8, y = 68.2,
    },
    {
      type = "turnin", questName = "Clam Bait", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 34, logCount = 10, x = 22.6, y = 72.0,
    },
    {
      type = "turnin", questName = "Other Fish to Fry", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 34, logCount = 9, x = 23.2, y = 72.8,
    },
    {
      type = "hearth", name = "Hearth to Thunder Bluff", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 34, logCount = 9, x = 23.2, y = 72.8,
      note = "Use your hearthstone.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", atLevel = 34,
      logCount = 9, note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "Class Trainer might be less travel time at Orgrimmar depending on class.",
      atLevel = 34,
    },
    {
      type = "travel", name = "Thunder Bluff to The Crossroads", zone = "Thunder Bluff",
      atLevel = 34, logCount = 9, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
})

-- Chapter 39: Return to Desolace
Leg(23, "Desolace", {

    { type = "section", name = "Chapter 39: Return to Desolace", levels = { 40, 41 }, zone = "Desolace" },
    {
      type = "turnin", name = "Sunken Treasure (part 4)", questName = "Sunken Treasure",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 40,
      logCount = 13, x = 27.2, y = 76.8,
    },
    {
      type = "note", optional = true, name = "Skip: S",
      note = "The route deliberately skips Sunken Treasure #5. Low XP for the travel time.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 40, x = 27.2, y = 76.8,
    },
    {
      type = "accept", questName = "Skullsplitter Tusks", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 40, logCount = 14, x = 27.0, y = 77.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for Tran'rek on a later pass.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 40, x = 27.0, y = 77.2,
    },
    {
      type = "hearth", name = "Set Hearth to Booty Bay", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 40, logCount = 14, x = 27.0, y = 77.2,
      note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Venture Company Mining", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 40, logCount = 15, x = 27.0, y = 77.2,
    },
    {
      type = "accept", questName = "Zanzil's Secret", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 40, logCount = 16, x = 27.0, y = 77.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Whiskey Slim's Lost Grog, Akiris by the Bundle on a later pass.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 40, x = 27.1, y = 77.5,
    },
    {
      type = "accept", questName = "Scaring Shaky", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 40, logCount = 17, x = 27.0, y = 77.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: S",
      note = "Do not pick up yet - the route comes back for Stoley's Debt on a later pass.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 40, x = 27.8, y = 77.0,
    },
    {
      type = "note", optional = true, name = "Skip: S",
      note = "The route deliberately skips Stranglethorn Fever. Low XP for the travel time.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 40, x = 27.6, y = 76.7,
    },
    {
      type = "accept", questName = "Excelsior", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 40, logCount = 18, x = 28.2, y = 77.4,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 1)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 40, logCount = 19, x = 28.0, y = 76.2,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Captain's Chest. Low XP for the travel time.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 40, x = 26.6, y = 73.6,
    },
    {
      type = "travel", name = "Booty Bay to Ratchet", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 40, logCount = 19, x = 25.9, y = 73.1, note = "Boat.",
    },
    {
      type = "turnin", questName = "Stinky's Escape", zone = "The Barrens",
      location = "Ratchet", atLevel = 41, logCount = 18, x = 62.4, y = 37.6,
    },
    {
      type = "travel", name = "Ratchet to Thunder Bluff", zone = "The Barrens",
      location = "Ratchet", atLevel = 41, logCount = 18, x = 63.1, y = 37.2,
      note = "Take the flight path.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", atLevel = 41,
      logCount = 18, note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", name = "The Black Shield (part 5)", questName = "The Black Shield",
      ambiguous = true, zone = "Thunder Bluff", location = "The Hunter Rise", atLevel = 41,
      logCount = 17, x = 54.2, y = 80.6,
    },
    {
      type = "turnin", questName = "Frostmaw", zone = "Thunder Bluff",
      location = "The Hunter Rise", atLevel = 41, logCount = 16, x = 61.4, y = 80.6,
    },
    {
      type = "accept", questName = "Deadmire", zone = "Thunder Bluff",
      location = "The Hunter Rise", atLevel = 41, logCount = 17, x = 61.4, y = 80.6,
    },
    {
      type = "travel", name = "Thunder Bluff to Shadowprey Village", zone = "Thunder Bluff",
      atLevel = 41, logCount = 17, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Portals of the Legion", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 41, logCount = 18, x = 25.8, y = 68.2,
    },
    {
      type = "turnin", questName = "Ongeku", zone = "Desolace", location = "Gelkis Village",
      atLevel = 41, logCount = 17, x = 36.2, y = 79.2,
    },
    {
      type = "accept", questName = "Khan Jehn", zone = "Desolace", location = "Gelkis Village",
      atLevel = 41, logCount = 18, x = 36.2, y = 79.2,
    },
    { type = "note", name = "Note", note = "Do Gizelton Caravan if the NPC is ready.", atLevel = 41 },
    {
      type = "complete", questName = "Portals of the Legion", zone = "Desolace",
      location = "Mannoroc Coven", atLevel = 41, logCount = 18, x = 50.0, y = 75.0,
      approx = true,
    },
    {
      type = "accept", questName = "Ghost-o-plasm Round Up", zone = "Desolace",
      location = "Kodo Graveyard", atLevel = 41, logCount = 19, x = 47.8, y = 61.8,
    },
    {
      type = "accept", name = "The Corrupter (part 5)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 41,
      logCount = 20, x = 52.6, y = 54.2,
    },
    {
      type = "complete", questName = "Khan Jehn", zone = "Desolace",
      location = "Magram Village", atLevel = 41, logCount = 20, x = 66.4, y = 80.1,
    },
    {
      type = "complete", questName = "Ghost-o-plasm Round Up", zone = "Desolace",
      location = "Magram Village", atLevel = 41, logCount = 20, x = 64.0, y = 92.0,
      approx = true,
    },
    {
      type = "complete", name = "The Corrupter (part 5)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Mannoroc Coven", atLevel = 41,
      logCount = 20, x = 57.0, y = 78.0, approx = true,
    },
    {
      type = "turnin", name = "The Corrupter (part 5)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", atLevel = 41,
      logCount = 19, x = 52.6, y = 54.2,
    },
    {
      type = "turnin", questName = "Ghost-o-plasm Round Up", zone = "Desolace",
      location = "Kodo Graveyard", atLevel = 41, logCount = 18, x = 47.8, y = 61.8,
    },
    {
      type = "note", name = "Note",
      note = "Do not turn in Corrupter and Ghost-o-plasm yet if you are able to do Khan Hratha. Turn them in after killing Hratha.",
      atLevel = 41,
    },
    {
      type = "turnin", questName = "Khan Jehn", zone = "Desolace", location = "Gelkis Village",
      atLevel = 41, logCount = 17, x = 36.2, y = 79.2,
    },
    {
      type = "note", optional = true, name = "Skip: K",
      note = "The route deliberately skips Khan Hratha. Low XP for the travel time.",
      zone = "Desolace", location = "Gelkis Village", atLevel = 41, x = 36.2, y = 79.2,
    },
    {
      type = "complete", questName = "Khan Hratha", zone = "Desolace",
      location = "Valley of Spears", atLevel = 41, logCount = 17, x = 29.8, y = 53.4,
    },
    {
      type = "accept", questName = "Get Me Out of Here!", zone = "Desolace",
      location = "Valley of Spears", atLevel = 41, logCount = 18, x = 33.8, y = 53.6,
    },
    {
      type = "note", name = "Note",
      note = "Skip this entire area and escort quest if you are not doing Khan Hratha.",
      atLevel = 41,
    },
    {
      type = "complete", questName = "Get Me Out of Here!", zone = "Desolace",
      location = "Valley of Spears", atLevel = 41, logCount = 18, x = 34.0, y = 56.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Get Me Out of Here!", zone = "Desolace",
      location = "Valley of Spears", atLevel = 41, logCount = 17, x = 47.8, y = 61.8,
    },
    {
      type = "accept", name = "Khan Hratha", questName = "Khan Hratha",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Desolace", location = "Gelkis Village", atLevel = 41, x = 36.2, y = 79.2,
    },
    {
      type = "turnin", questName = "Khan Hratha", zone = "Desolace",
      location = "Gelkis Village", atLevel = 41, logCount = 17, x = 36.2, y = 79.2,
    },
    {
      type = "turnin", questName = "Portals of the Legion", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 41, logCount = 16, x = 25.8, y = 68.2,
    },
    {
      type = "travel", name = "Shadowprey Village to Gadgetzan", zone = "Desolace",
      location = "Shadowprey Village", atLevel = 41, logCount = 16, x = 21.6, y = 74.1,
      note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Goblin Sponsorship (part 5)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "Thousand Needles", location = "Shimmering Flats", atLevel = 41,
      logCount = 15, x = 80.0, y = 75.8,
    },
    {
      type = "accept", questName = "The Eighteenth Pilot", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 16, x = 80.0, y = 75.8,
    },
    {
      type = "turnin", questName = "The Eighteenth Pilot", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 15, x = 80.2, y = 76.0,
    },
    {
      type = "accept", questName = "Razzeric's Tweaking", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 16, x = 80.2, y = 76.0,
    },
    {
      type = "note", optional = true, name = "Skip: G",
      note = "The route deliberately skips Gahz'rilla. Low XP for the travel time.",
      zone = "Thousand Needles", location = "Shimmering Flats", atLevel = 41, x = 78.1,
      y = 77.1,
    },
    {
      type = "turnin", questName = "Rumors for Kravel", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 15, x = 77.8, y = 77.2,
    },
    {
      type = "accept", questName = "Back to Booty Bay", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 16, x = 77.8, y = 77.2,
    },
    {
      type = "turnin", questName = "News for Fizzle", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 15, x = 78.0, y = 77.0,
    },
    {
      type = "accept", questName = "Keeping Pace", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 16, x = 80.0, y = 75.8,
    },
    {
      type = "turnin", questName = "Keeping Pace", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 15, x = 77.2, y = 77.4,
    },
    {
      type = "accept", questName = "Rizzle's Schematics", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 16, x = 77.2, y = 77.4,
    },
    {
      type = "turnin", questName = "Rizzle's Schematics", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 15, x = 80.2, y = 76.0,
    },
    {
      type = "note", optional = true, name = "Skip: I",
      note = "The route deliberately skips Indurium Ore. Low XP for the travel time.",
      zone = "Thousand Needles", location = "Shimmering Flats", atLevel = 41, x = 80.2,
      y = 76.0,
    },
    {
      type = "hearth", name = "Hearth to Booty Bay", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 41, logCount = 15, x = 80.2, y = 76.0,
      note = "Use your hearthstone.",
    },
})

