-- TuFFlevels / Routes/Horde/Dungeon/05-Arathithunderdome.lua
--
-- Part 5 of the 5-man Horde 1-60 dungeon route.
-- Sections: Arathi thunderdome (level 42-44) | Ulduman Blitz (level 42-44)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(5, {

    { type = "section", name = "Arathi thunderdome (level 42-44)", levels = { 42, 44 }, zone = "Undercity" },
    {
      type = "note", name = "Note", note = "Hearth to Undercity", zone = "Undercity",
      location = "Trade Quarter",
    },
    {
      type = "note", name = "Note",
      note = "******* IMPORTANT---- PUT 15 SILK CLOTH IN YOUR BANK-----------IMPORTANT ********",
    },
    { type = "trainer", name = "Class Trainer", zone = "Undercity", logCount = 11 },
    {
      type = "accept", name = "Errand for Apothecary Zinge (part 1)",
      questName = "Errand for Apothecary Zinge", ambiguous = true, zone = "Undercity",
      location = "Apothecarium", logCount = 12,
    },
    {
      type = "turnin", name = "Errand for Apothecary Zinge (part 1)",
      questName = "Errand for Apothecary Zinge", ambiguous = true, zone = "Undercity",
      location = "Apothecarium", logCount = 11,
    },
    {
      type = "accept", name = "Errand for Apothecary Zinge (part 2)",
      questName = "Errand for Apothecary Zinge", ambiguous = true, zone = "Undercity",
      location = "Apothecarium", logCount = 12,
    },
    {
      type = "turnin", name = "Errand for Apothecary Zinge (part 2)",
      questName = "Errand for Apothecary Zinge", ambiguous = true, zone = "Undercity",
      location = "Apothecarium", logCount = 11,
    },
    {
      type = "accept", questName = "Into the Field", zone = "Undercity",
      location = "Apothecarium", logCount = 12,
    },
    {
      type = "turnin", questName = "Into The Scarlet Monastery", zone = "Undercity",
      location = "Royal Quarter", logCount = 11,
    },
    {
      type = "accept", questName = "Reclaimed Treasures", zone = "Undercity",
      location = "Trade Quarter", logCount = 12,
    },
    {
      type = "travel", name = "Undercity to Hammerfall", zone = "Undercity",
      location = "Trade Quarter", logCount = 12, note = "Take the flight path.",
    },
    { type = "accept", questName = "Triage", zone = "Arathi Highlands", location = "Hammerfall", logCount = 13 },
    {
      type = "complete", questName = "Triage", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 13,
    },
    { type = "turnin", questName = "Triage", zone = "Arathi Highlands", location = "Hammerfall", logCount = 12 },
    {
      type = "note", name = "Note",
      note = "If you see Fozruk on the way to stormgarde kill him for the keystone quest.",
    },
    {
      type = "complete", name = "Call to Arms (part 3)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Stormgarde Keep", logCount = 12,
    },
    {
      type = "complete", questName = "The Real Threat", zone = "Arathi Highlands",
      location = "Stormgarde Keep", logCount = 12,
    },
    {
      type = "complete", questName = "Sigil of Strom", zone = "Arathi Highlands",
      location = "Stormgarde Keep", logCount = 12,
    },
    { type = "complete", questName = "Breaking the Keystone", zone = "Arathi Highlands", logCount = 12 },
    {
      type = "turnin", questName = "Breaking the Keystone", zone = "Arathi Highlands",
      location = "Circle of Inner Binding", logCount = 11,
    },
    {
      type = "accept", questName = "Myzrael's Allies", zone = "Arathi Highlands",
      location = "Circle of Inner Binding", logCount = 12,
    },
    {
      type = "turnin", questName = "Myzrael's Allies", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11,
    },
    {
      type = "accept", questName = "Theldurin the Lost", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 12,
    },
    {
      type = "turnin", questName = "The Real Threat", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 11,
    },
    {
      type = "turnin", name = "Call to Arms (part 3)", questName = "Call to Arms",
      ambiguous = true, zone = "Arathi Highlands", location = "Hammerfall", logCount = 10,
    },
    {
      type = "turnin", questName = "Sigil of Strom", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 9,
    },
    {
      type = "note", name = "Skip: The Broken Sigil",
      note = "The route deliberately skips The Broken Sigil.", zone = "Arathi Highlands",
      location = "Hammerfall",
    },
    {
      type = "travel", name = "Hammerfall to Undercity", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 10, note = "Take the flight path.",
    },
    { type = "note", name = "Note", note = "Mount into STV" },
    {
      type = "travel", name = "Undercity to Orgrimmar", zone = "Tirisfal Glades",
      location = "Brill", logCount = 10, note = "Zeppelin.",
    },
    { type = "note", name = "Note", note = "Note: Get your mount" },
    {
      type = "travel", name = "Orgrimmar to Grom'Gol", zone = "Orgrimmar",
      location = "Ogrimmar", logCount = 10, note = "Zeppelin.",
    },
    {
      type = "complete", name = "The Defense of Grom'gol (part 2)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Mizjah Ruins", logCount = 10,
    },
    {
      type = "complete", questName = "Hostile Takeover", zone = "Stranglethorn Vale",
      location = "Venture Co Base Camp", logCount = 10,
      note = "Partial progress - work on this while you are here, then move on. NOTE: Wipe the Venture Camp (tower too) Split up and FFA loot",
    },
    {
      type = "complete", name = "Panther Mastery (part 3)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Venture Co Base Camp",
      logCount = 10,
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 1)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Venture Co Base Camp", logCount = 10,
    },
    {
      type = "complete", questName = "Hostile Takeover", zone = "Stranglethorn Vale",
      location = "Venture Co Base Camp", logCount = 10,
    },
    {
      type = "turnin", name = "Panther Mastery (part 3)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 9,
    },
    {
      type = "accept", name = "Panther Mastery (part 4)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 10,
    },
    {
      type = "turnin", name = "The Defense of Grom'gol (part 2)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 9,
    },
    {
      type = "turnin", name = "Mok'thardin's Enchantment (part 1)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 8,
    },
    {
      type = "accept", name = "Mok'thardin's Enchantment (part 2)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 9,
    },
    {
      type = "travel", name = "Grom'Gol to Booty Bay", zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 9, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Hostile Takeover", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
    },
    {
      type = "note", name = "Skip: Zanzil's Secret",
      note = "The route deliberately skips Zanzil's Secret.", zone = "Stranglethorn Vale",
      location = "Booty Bay",
    },
    {
      type = "accept", questName = "Scaring Shaky", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 1)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Southern Savage Coast", logCount = 10,
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 1)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Southern Savage Coast", logCount = 9,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 2)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Southern Savage Coast", logCount = 10,
    },
    {
      type = "complete", questName = "Scaring Shaky", zone = "Stranglethorn Vale",
      location = "Southern Savage Coast", logCount = 10,
      note = "Partial progress - work on this while you are here, then move on. Note: Clear them all then leave",
    },
    {
      type = "complete", name = "Raptor Mastery (part 3)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Southern Savage Coast",
      logCount = 10,
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 2)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Southern Savage Coast", logCount = 10,
    },
    {
      type = "turnin", name = "Mok'thardin's Enchantment (part 2)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 9,
    },
    {
      type = "accept", name = "Mok'thardin's Enchantment (part 3)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 10,
    },
    {
      type = "accept", questName = "The Vile Reef", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 11,
    },
    {
      type = "accept", questName = "Grim Message", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 12,
    },
    {
      type = "complete", questName = "The Vile Reef", zone = "Stranglethorn Vale",
      location = "The Vile Reef", logCount = 12,
    },
    {
      type = "complete", name = "Tiger Mastery (part 4)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Tkashi Ruins", logCount = 12,
    },
    {
      type = "turnin", name = "Tiger Mastery (part 4)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "turnin", name = "Raptor Mastery (part 3)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 10,
    },
    {
      type = "accept", name = "Raptor Mastery (part 4)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 11,
    },
    {
      type = "complete", name = "Panther Mastery (part 4)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "East Stranglethorn",
      logCount = 11,
    },
    {
      type = "complete", name = "Raptor Mastery (part 4)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Southern Savage Coast",
      logCount = 11,
    },
    {
      type = "turnin", questName = "The Vile Reef", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 10,
    },
    {
      type = "turnin", name = "Raptor Mastery (part 4)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 9,
    },
    {
      type = "turnin", name = "Panther Mastery (part 4)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      logCount = 8,
    },
    {
      type = "accept", questName = "Big Game Hunter", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", logCount = 9,
    },
    {
      type = "travel", name = "Grom'Gol to Booty Bay", zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 9, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 2)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 3)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9,
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 3)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 4)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9,
    },
    {
      type = "accept", questName = "Up to Snuff", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 10,
    },
    {
      type = "accept", questName = "Stranglethorn Fever", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 11,
    },
    {
      type = "accept", questName = "Keep An Eye Out", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 12,
    },
    {
      type = "complete", questName = "Scaring Shaky", zone = "Stranglethorn Vale",
      location = "Mistvale Valley", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on. Note: Clear them all and then go to Blood Sail #4",
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 3)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Mistvale Valley", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on. Note: Clear them all and then go to Blood Sail #4",
    },
    {
      type = "complete", name = "The Bloodsail Buccaneers (part 4)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Wild Shore", logCount = 12,
    },
    {
      type = "complete", questName = "Up to Snuff", zone = "Stranglethorn Vale",
      location = "Wild Shore", logCount = 12,
    },
    {
      type = "complete", questName = "Keep An Eye Out", zone = "Stranglethorn Vale",
      location = "Wild Shore", logCount = 12,
    },
    {
      type = "complete", questName = "Scaring Shaky", zone = "Stranglethorn Vale",
      location = "Mistvale Valley", logCount = 12,
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 3)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Mistvale Valley", logCount = 12,
    },
    {
      type = "complete", questName = "Stranglethorn Fever", zone = "Stranglethorn Vale",
      location = "Mistvale Valley", logCount = 12,
    },
    {
      type = "turnin", questName = "Scaring Shaky", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 11,
    },
    {
      type = "turnin", questName = "Stranglethorn Fever", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 10,
    },
    {
      type = "accept", questName = "Return to MacKinley", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 11,
    },
    {
      type = "turnin", questName = "Return to MacKinley", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 10,
    },
    {
      type = "accept", questName = "Voodoo Dues", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 11,
    },
    {
      type = "turnin", questName = "Keep An Eye Out", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 10,
    },
    {
      type = "turnin", questName = "Up to Snuff", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9,
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 4)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 5)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9,
    },
    {
      type = "note", name = "Skip: Cortello's Riddle (part 1)",
      note = "The route deliberately skips Cortello's Riddle (part 1).",
      zone = "Stranglethorn Vale", location = "Wild Shore",
    },
    {
      type = "complete", name = "The Bloodsail Buccaneers (part 5)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Wild Shore", logCount = 9,
    },
    {
      type = "complete", questName = "Voodoo Dues", zone = "Stranglethorn Vale",
      location = "Ruins of Aboraz", logCount = 9,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Voodoo Dues", zone = "Stranglethorn Vale",
      location = "Ruins of Jubuwal", logCount = 9,
    },
    {
      type = "complete", questName = "Big Game Hunter", zone = "Stranglethorn Vale",
      location = "Cape of Stranglethorn", logCount = 9,
    },
    {
      type = "turnin", name = "Mok'thardin's Enchantment (part 3)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 8,
    },
    {
      type = "accept", name = "Mok'thardin's Enchantment (part 4)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 9,
    },
    {
      type = "turnin", questName = "Big Game Hunter", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", logCount = 8,
    },
    {
      type = "travel", name = "Grom'Gol to Booty Bay", zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", logCount = 8, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 5)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 7,
    },
    {
      type = "accept", questName = "Tran'rek", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
    },
    {
      type = "accept", questName = "Whiskey Slim's Lost Grog", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9,
    },
    {
      type = "turnin", questName = "Voodoo Dues", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
    },
    {
      type = "note", name = "Skip: Cracking Maury's Foot",
      note = "The route deliberately skips Cracking Maury's Foot.",
      zone = "Stranglethorn Vale", location = "Booty Bay",
    },
    {
      type = "accept", questName = "Stoley's Debt", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9,
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 4)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Nek'mani Wellspring", logCount = 9,
    },
    {
      type = "travel", name = "Booty Bay to Grom'gol Base Camp", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 9, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Mok'thardin's Enchantment (part 4)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 8,
    },
    {
      type = "travel", name = "Grom'gol Base Camp to Kargath", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
      note = "Take the flight path. Note: if you cant fly to Kargath from Grol, hearth to UC, Fly to arathi, and run.... gross.",
    },

    { type = "section", name = "Ulduman Blitz (level 42-44)", levels = { 42, 44 }, zone = "Badlands" },
    {
      type = "accept", questName = "Badlands Reagent Run", zone = "Badlands",
      location = "Kargath", logCount = 9,
      note = "Note: Need to do this quest chain for Resto Pots for MC.",
    },
    {
      type = "accept", name = "Broken Alliances (part 1)", questName = "Broken Alliances",
      ambiguous = true, zone = "Badlands", location = "Kargath", logCount = 10,
    },
    {
      type = "complete", questName = "Badlands Reagent Run", zone = "Badlands", logCount = 10,
      note = "Partial progress - work on this while you are here, then move on. Note: Go directly south of Kargath, wipe the buzzards then prio buzzards as you go.",
    },
    {
      type = "accept", questName = "Power Stones", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 11,
    },
    {
      type = "complete", questName = "Badlands Reagent Run", zone = "Badlands", logCount = 11,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", questName = "Theldurin the Lost", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 10,
    },
    {
      type = "accept", questName = "The Lost Fragments", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 11,
    },
    {
      type = "complete", questName = "The Lost Fragments", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 11,
    },
    {
      type = "turnin", questName = "The Lost Fragments", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 10,
    },
    {
      type = "accept", questName = "Summoning the Princess", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 11,
    },
    {
      type = "accept", questName = "Solution to Doom", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 12,
    },
    {
      type = "complete", name = "Broken Alliances (part 1)", questName = "Broken Alliances",
      ambiguous = true, zone = "Badlands", logCount = 12,
    },
    { type = "complete", questName = "Badlands Reagent Run", zone = "Badlands", logCount = 12 },
    {
      type = "turnin", name = "Broken Alliances (part 1)", questName = "Broken Alliances",
      ambiguous = true, zone = "Badlands", location = "Kargath", logCount = 11,
    },
    {
      type = "turnin", questName = "Badlands Reagent Run", zone = "Badlands",
      location = "Kargath", logCount = 10,
    },
    { type = "accept", questName = "Uldaman Reagent Run", zone = "Badlands", logCount = 11 },
    {
      type = "complete", questName = "Uldaman Reagent Run", zone = "Badlands",
      location = "Uldaman Outside", logCount = 11,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Reclaimed Treasures", zone = "Badlands",
      location = "Uldaman Outside", logCount = 11, note = "NOTE: Chest outside of Uldaman",
    },
    {
      type = "complete", questName = "Solution to Doom", zone = "Badlands",
      location = "Uldaman Outside", logCount = 11,
      note = "NOTE: Diffrent Chest outside of Uldaman",
    },
    {
      type = "note", name = "Note",
      note = "Into Uld- Prio Magenta Fungus Cap, then do Solutoin to Doom. You can finish Fungas Caps after clear and inside",
    },
    {
      type = "note", name = "Note",
      note = "****Uldaman is a \"Blitz\" run to Archadeus, dont get off track!****",
    },
    { type = "note", name = "Note", note = "Platinum Discs is after Archadeus, go through dialogue!!!!!!!!" },
    {
      type = "manual", name = "Necklace Recovery", zone = "Badlands", location = "Uldaman",
      logCount = 11,
      note = "Collect these here. Note : Random Drop inside, DO NOT DELETE! you can not accept quest!",
    },
    {
      type = "accept", name = "Platinum Discs (part 1)", questName = "Platinum Discs",
      ambiguous = true, zone = "Badlands", location = "Uldaman", logCount = 12,
      note = "AFTER Archadeus",
    },
    {
      type = "turnin", name = "Platinum Discs (part 1)", questName = "Platinum Discs",
      ambiguous = true, zone = "Badlands", location = "Uldaman", logCount = 11,
      note = "Listen to the dialogue",
    },
    {
      type = "accept", name = "Platinum Discs (part 2)", questName = "Platinum Discs",
      ambiguous = true, zone = "Badlands", location = "Uldaman", logCount = 12,
      note = "Follow up is 45, so we need to wait to go to TB",
    },
    {
      type = "complete", questName = "Uldaman Reagent Run", zone = "Badlands",
      location = "Uldaman Outside", logCount = 12,
    },
    {
      type = "turnin", questName = "Power Stones", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 11,
    },
    {
      type = "turnin", questName = "Solution to Doom", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 10,
    },
    {
      type = "accept", questName = "To the Undercity for Yagyin's Digest", zone = "Badlands",
      location = "Valley Of Fangs", logCount = 11,
    },
    {
      type = "turnin", questName = "Uldaman Reagent Run", zone = "Badlands",
      location = "Kargath", logCount = 10,
    },
    {
      type = "note", name = "Note", note = "Hearth to Undercity", zone = "Undercity",
      location = "Trade Quarter",
    },
    { type = "trainer", name = "Class Trainer", zone = "Undercity", logCount = 10 },
    {
      type = "turnin", questName = "Reclaimed Treasures", zone = "Undercity",
      location = "Trade Quarter", logCount = 9,
    },
    {
      type = "turnin", questName = "To the Undercity for Yagyin's Digest", zone = "Undercity",
      location = "Apothecarium (front)", logCount = 8,
    },
    {
      type = "note", name = "Skip: \"The Star, the Hand and the Heart\"",
      note = "The route deliberately skips \"The Star, the Hand and the Heart\".",
      zone = "Undercity", location = "Apothecarium",
    },
    {
      type = "travel", name = "Undercity to Orgrimmar", zone = "Tirisfal Glades",
      location = "Brill", logCount = 8, note = "Zeppelin.",
    },
    {
      type = "accept", questName = "Necklace Recovery", zone = "Orgrimmar",
      location = "The Drag", logCount = 9,
      note = "This is the Necklace Quest - Dran Doffers in the Drag in Org",
    },
    { type = "turnin", questName = "Necklace Recovery", zone = "Orgrimmar", location = "The Drag", logCount = 8 },
    {
      type = "note", name = "Skip: Necklace Recovery take 2",
      note = "The route deliberately skips Necklace Recovery take 2.", zone = "Orgrimmar",
      location = "The Drag",
    },
})
