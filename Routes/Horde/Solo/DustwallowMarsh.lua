-- TuFFlevels / Routes/Horde/Solo/DustwallowMarsh.lua
--
-- Dustwallow Marsh leg(s) of the solo Orc/Troll 1-60 route. Levels 36-44.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 34: Dustwallow Marsh North
Leg(19, "Dustwallow Marsh", {

    {
      type = "section", name = "Chapter 34: Dustwallow Marsh North", levels = { 36, 37 },
      zone = "Dustwallow Marsh",
    },
    {
      type = "accept", questName = "The Lost Report", zone = "Dustwallow Marsh",
      location = "Swamplight Manor", atLevel = 36, logCount = 13, x = 55.4, y = 26.0,
    },
    {
      type = "accept", questName = "Soothing Spices", zone = "Dustwallow Marsh",
      location = "Swamplight Manor", atLevel = 36, logCount = 14, x = 55.4, y = 26.2,
    },
    {
      type = "turnin", questName = "Soothing Spices", zone = "Dustwallow Marsh",
      location = "Swamplight Manor", atLevel = 36, logCount = 13, x = 55.4, y = 26.2,
    },
    {
      type = "accept", questName = "Jarl Needs Eyes", zone = "Dustwallow Marsh",
      location = "Swamplight Manor", atLevel = 36, logCount = 14, x = 55.4, y = 26.2,
    },
    {
      type = "accept", questName = "Stinky's Escape", zone = "Dustwallow Marsh",
      location = "North Dustwallow Marsh", atLevel = 36, logCount = 15, x = 46.9, y = 17.5,
    },
    {
      type = "complete", questName = "Stinky's Escape", zone = "Dustwallow Marsh",
      location = "North Dustwallow Marsh", atLevel = 36, logCount = 15, x = 47.0, y = 20.0,
      approx = true,
    },
    {
      type = "accept", name = "The Black Shield (part 3)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      atLevel = 36, logCount = 16, x = 36.4, y = 30.8,
    },
    {
      type = "turnin", questName = "The Lost Report", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 36, logCount = 15, x = 35.2, y = 30.6,
    },
    {
      type = "accept", questName = "Theramore Spies", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 36, logCount = 16, x = 35.2, y = 30.6,
    },
    {
      type = "accept", questName = "Hungry!", zone = "Dustwallow Marsh",
      location = "South of Brackenwall", atLevel = 36, logCount = 17, x = 35.1, y = 38.3,
    },
    {
      type = "complete", questName = "Jarl Needs Eyes", zone = "Dustwallow Marsh",
      location = "Darkmist Cavern", atLevel = 36, logCount = 17, x = 34.0, y = 23.0,
      approx = true,
    },
    {
      type = "complete", questName = "Theramore Spies", zone = "Dustwallow Marsh",
      location = "North of Brackenwall", atLevel = 36, logCount = 17, x = 38.0, y = 23.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Theramore Spies", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 37, logCount = 16, x = 35.2, y = 30.6,
    },
    {
      type = "accept", questName = "The Theramore Docks", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 37, logCount = 17, x = 35.2, y = 30.6,
    },
    {
      type = "complete", name = "The Black Shield (part 3)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "North of Brackenwall",
      atLevel = 37, logCount = 17, x = 42.0, y = 26.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Hungry!", zone = "Dustwallow Marsh",
      location = "Dreadmurk Shore", atLevel = 37, logCount = 17, x = 57.0, y = 16.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Jarl Needs Eyes", zone = "Dustwallow Marsh",
      location = "Swamplight Manor", atLevel = 37, logCount = 16, x = 55.4, y = 26.2,
    },
    {
      type = "note", name = "Skip: J",
      note = "The route deliberately skips Jarl Needs a Blade. Low XP for the travel time.",
      zone = "Dustwallow Marsh", location = "Swamplight Manor", atLevel = 37, x = 55.4,
      y = 26.2,
    },
    {
      type = "accept", questName = "The Severed Head", zone = "Dustwallow Marsh",
      location = "Swamplight Manor", atLevel = 37, logCount = 17, x = 55.4, y = 26.0,
    },
    {
      type = "complete", questName = "The Theramore Docks", zone = "Dustwallow Marsh",
      location = "Theramore Isle", atLevel = 37, logCount = 17, x = 71.5, y = 51.2,
    },
    {
      type = "complete", name = "The Black Shield (part 3)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", atLevel = 37, logCount = 17, x = 42.0,
      y = 26.0, approx = true,
    },
    {
      type = "turnin", questName = "The Theramore Docks", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 37, logCount = 16, x = 35.2, y = 30.6,
    },
    {
      type = "turnin", questName = "The Severed Head", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 37, logCount = 15, x = 35.2, y = 30.6,
    },
    {
      type = "accept", questName = "The Troll Witchdoctor", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 37, logCount = 16, x = 35.2, y = 30.6,
    },
    {
      type = "turnin", questName = "Hungry!", zone = "Dustwallow Marsh",
      location = "South of Brackenwall", atLevel = 37, logCount = 15, x = 35.1, y = 38.3,
    },
    {
      type = "accept", questName = "Questioning Reethe", zone = "Dustwallow Marsh",
      location = "South of Brackenwall", atLevel = 37, logCount = 16, x = 40.8, y = 36.6,
    },
    {
      type = "complete", questName = "Questioning Reethe", zone = "Dustwallow Marsh",
      location = "South of Brackenwall", atLevel = 37, logCount = 16, x = 42.6, y = 38.1,
    },
    {
      type = "turnin", name = "The Black Shield (part 3)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      atLevel = 37, logCount = 15, x = 36.4, y = 30.8,
    },
    {
      type = "accept", name = "The Black Shield (part 4)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      atLevel = 37, logCount = 16, x = 36.4, y = 30.8,
    },
    {
      type = "turnin", name = "The Black Shield (part 4)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      atLevel = 37, logCount = 15, x = 36.4, y = 31.8,
    },
    {
      type = "turnin", questName = "Questioning Reethe", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 37, logCount = 14, x = 36.4, y = 31.8,
    },
    {
      type = "accept", name = "The Black Shield (part 5)", questName = "The Black Shield",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Brackenwall Village",
      atLevel = 37, logCount = 15, x = 36.4, y = 31.8,
    },
    {
      type = "hearth", name = "Hearth to Booty Bay", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 37, logCount = 15, x = 36.4, y = 31.8,
      note = "Use your hearthstone.",
    },
})

-- Chapter 43: Dustwallow Marsh South
Leg(26, "Dustwallow Marsh", {

    {
      type = "section", name = "Chapter 43: Dustwallow Marsh South", levels = { 43, 44 },
      zone = "Dustwallow Marsh",
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 5)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 43, logCount = 13, x = 27.2, y = 76.8,
    },
    {
      type = "turnin", questName = "Zanzil's Secret", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 43, logCount = 12, x = 27.1, y = 77.2,
    },
    {
      type = "note", name = "Skip for now: Z",
      note = "Do not pick up yet - the route comes back for Zanzil's Mixture and a Fool's Stout on a later pass.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 43, x = 27.1, y = 77.2,
    },
    {
      type = "turnin", questName = "Voodoo Dues", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 43, logCount = 11, x = 27.8, y = 77.1,
    },
    {
      type = "note", name = "Skip: C",
      note = "The route deliberately skips Cracking Maury's Foot. Low XP for the travel time.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 43, x = 27.8, y = 77.1,
    },
    {
      type = "turnin", questName = "The Captain's Chest", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 43, logCount = 11, x = 26.6, y = 73.6,
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 4)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Nek'mani Wellspring", atLevel = 43, logCount = 11, x = 28.9, y = 61.9,
    },
    {
      type = "complete", questName = "Akiris by the Bundle", zone = "Stranglethorn Vale",
      location = "Nek'mani Wellspring", atLevel = 43, logCount = 11, x = 26.0, y = 61.0,
      approx = true,
    },
    {
      type = "complete", questName = "The Mind's Eye", zone = "Stranglethorn Vale",
      location = "Mosh'Ogg Ogre Mound", atLevel = 43, logCount = 11, x = 52.9, y = 27.6,
    },
    {
      type = "complete", questName = "Cracking Maury's Foot", zone = "Stranglethorn Vale",
      location = "Mosh'Ogg Ogre Mound", atLevel = 43, logCount = 11, x = 50.0, y = 28.0,
      approx = true,
    },
    {
      type = "accept", name = "The Mind's Eye", questName = "The Mind's Eye",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp", atLevel = 43, x = 32.3,
      y = 27.7,
    },
    {
      type = "turnin", questName = "The Mind's Eye", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 43, logCount = 11, x = 32.3, y = 27.7,
    },
    {
      type = "note", name = "Skip: S",
      note = "The route deliberately skips Saving Yenniku. Low XP for the travel time.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp", atLevel = 43, x = 32.3,
      y = 27.7,
    },
    {
      type = "turnin", name = "Mok'thardin's Enchantment (part 4)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 43, logCount = 10, x = 32.0, y = 29.2,
    },
    {
      type = "travel", name = "Grom'Gol Base Camp to Booty Bay", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 43, logCount = 10, x = 32.5, y = 29.4,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Zanzil's Mixture and a Fool's Stout",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 43, logCount = 11,
      x = 27.1, y = 77.2,
    },
    {
      type = "note", name = "Skip: F",
      note = "The route deliberately skips Fool's Stout. Low XP for the travel time.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 43, x = 27.1, y = 77.2,
    },
    {
      type = "turnin", questName = "Akiris by the Bundle", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 43, logCount = 10, x = 27.4, y = 76.8,
    },
    {
      type = "accept", name = "Cracking Maury's Foot", questName = "Cracking Maury's Foot",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 43, x = 27.8, y = 77.1,
    },
    {
      type = "turnin", questName = "Cracking Maury's Foot", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 43, logCount = 10, x = 27.8, y = 77.1,
    },
    {
      type = "travel", name = "Booty Bay to Ratchet", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 43, logCount = 10, x = 25.9, y = 73.1, note = "Boat.",
    },
    {
      type = "travel", name = "Ratchet to Brackenwall Village", zone = "The Barrens",
      location = "Ratchet", atLevel = 43, logCount = 10, x = 63.1, y = 37.2,
      note = "Take the flight path.",
    },
    {
      type = "note", name = "Skip: O",
      note = "The route deliberately skips Overlord Mok'Morokk's Concern. Low XP for the travel time.",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 43, x = 36.3,
      y = 31.4,
    },
    {
      type = "manual", name = "Balai Lok'Wein: Manual: Mageweave Bandage",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 43, logCount = 10,
      x = 36.5, y = 30.4, note = "Vendor stop.",
    },
    {
      type = "accept", questName = "Identifying the Brood", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 43, logCount = 11, x = 37.0, y = 33.0,
    },
    {
      type = "note", name = "Skip: A",
      note = "The route deliberately skips Army of the Black Dragon. Low XP for the travel time.",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 43, x = 37.4,
      y = 31.4,
    },
    {
      type = "complete", questName = "Deadmire", zone = "Dustwallow Marsh",
      location = "The Quagmire", atLevel = 43, logCount = 11, x = 49.0, y = 56.5,
      approx = true,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips Tiara of the Deep. Low XP for the travel time.",
      zone = "Dustwallow Marsh", location = "The Quagmire", atLevel = 43, x = 46.1, y = 57.1,
    },
    {
      type = "complete", questName = "Razzeric's Tweaking", zone = "Dustwallow Marsh",
      location = "Beezil's Wreck", atLevel = 43, logCount = 11, x = 54.1, y = 56.5,
    },
    {
      type = "complete", questName = "Marg Speaks", zone = "Dustwallow Marsh",
      location = "Dustwallow Bay", atLevel = 43, logCount = 11, x = 52.0, y = 42.0,
      approx = true,
    },
    {
      type = "complete", questName = "Overlord Mok'Morokk's Concern",
      zone = "Dustwallow Marsh", location = "The Den of Flame", atLevel = 43, logCount = 11,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Army of the Black Dragon", zone = "Dustwallow Marsh",
      location = "The Den of Flame", atLevel = 43, logCount = 11, x = 40.0, y = 65.0,
      approx = true,
    },
    {
      type = "complete", questName = "Identifying the Brood", zone = "Dustwallow Marsh",
      location = "The Dragonmurk", atLevel = 43, logCount = 11, x = 47.0, y = 66.0,
      approx = true,
    },
    {
      type = "turnin", name = "Cortello's Riddle (part 2)", questName = "Cortello's Riddle",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Bloodfen Burrow", atLevel = 44,
      logCount = 10, x = 31.1, y = 66.2,
    },
    {
      type = "accept", name = "Cortello's Riddle (part 3)", questName = "Cortello's Riddle",
      ambiguous = true, zone = "Dustwallow Marsh", location = "Bloodfen Burrow", atLevel = 44,
      logCount = 11, x = 31.1, y = 66.2,
    },
    {
      type = "turnin", questName = "Marg Speaks", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 10, x = 35.2, y = 30.7,
    },
    {
      type = "accept", questName = "Report to Zor", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 11, x = 35.2, y = 30.7,
    },
    {
      type = "accept", name = "Overlord Mok'Morokk's Concern",
      questName = "Overlord Mok'Morokk's Concern",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 44, x = 36.3,
      y = 31.4,
    },
    {
      type = "turnin", questName = "Overlord Mok'Morokk's Concern", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 11, x = 36.3, y = 31.4,
    },
    {
      type = "accept", name = "Army of the Black Dragon",
      questName = "Army of the Black Dragon",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 44, x = 37.4,
      y = 31.4,
    },
    {
      type = "turnin", questName = "Army of the Black Dragon", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 11, x = 37.4, y = 31.4,
    },
    {
      type = "turnin", questName = "Identifying the Brood", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 10, x = 37.0, y = 33.0,
    },
    {
      type = "accept", name = "The Brood of Onyxia (part 1)",
      questName = "The Brood of Onyxia", ambiguous = true, zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 11, x = 37.0, y = 33.0,
    },
    {
      type = "turnin", name = "The Brood of Onyxia (part 1)",
      questName = "The Brood of Onyxia", ambiguous = true, zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 10, x = 36.3, y = 31.4,
    },
    {
      type = "accept", name = "The Brood of Onyxia (part 2)",
      questName = "The Brood of Onyxia", ambiguous = true, zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 11, x = 36.3, y = 31.4,
    },
    {
      type = "turnin", name = "The Brood of Onyxia (part 2)",
      questName = "The Brood of Onyxia", ambiguous = true, zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 10, x = 37.0, y = 33.0,
    },
    {
      type = "accept", name = "The Brood of Onyxia (part 3)",
      questName = "The Brood of Onyxia", ambiguous = true, zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 11, x = 37.0, y = 33.0,
    },
    {
      type = "complete", name = "The Brood of Onyxia (part 3)",
      questName = "The Brood of Onyxia", ambiguous = true, zone = "Dustwallow Marsh",
      location = "The Dragonmurk", atLevel = 44, logCount = 11,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", name = "The Brood of Onyxia (part 3)",
      questName = "The Brood of Onyxia", ambiguous = true, zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 10, x = 37.0, y = 33.0,
    },
    {
      type = "note", name = "Skip: C",
      note = "The route deliberately skips Challenge Overlord Mok'Morokk. Low XP for the travel time.",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 44, x = 36.3,
      y = 31.4,
    },
    {
      type = "complete", questName = "Challenge Overlord Mok'Morokk",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 44, logCount = 10,
      x = 36.3, y = 31.4,
    },
    {
      type = "accept", name = "Challenge Overlord Mok'Morokk",
      questName = "Challenge Overlord Mok'Morokk",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Dustwallow Marsh", location = "Brackenwall Village", atLevel = 44, x = 36.3,
      y = 31.4,
    },
    {
      type = "turnin", questName = "Challenge Overlord Mok'Morokk", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 10, x = 36.3, y = 31.4,
    },
    {
      type = "travel", name = "Brackenwall Village to Gadgetzan", zone = "Dustwallow Marsh",
      location = "Brackenwall Village", atLevel = 44, logCount = 10, x = 35.6, y = 31.9,
      note = "Take the flight path.",
    },
})

