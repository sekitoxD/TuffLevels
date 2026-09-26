-- TuFFlevels / Routes/Horde/Solo/Feralas.lua
--
-- Feralas leg(s) of the solo Orc/Troll 1-60 route. Levels 44-48.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 45: Feralas East
Leg(28, "Feralas", {

    { type = "section", name = "Chapter 45: Feralas East", levels = { 44, 45 }, zone = "Feralas" },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for The Ogres of Feralas #1, A New Cloak's Sheen on a later pass.",
      zone = "Feralas", location = "Camp Mojache", atLevel = 44, x = 75.8, y = 43.6,
    },
    {
      type = "accept", questName = "War on the Woodpaw", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 10, x = 74.9, y = 42.5,
    },
    {
      type = "note", optional = true, name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Mark of Quality on a later pass.",
      zone = "Feralas", location = "Camp Mojache", atLevel = 44, x = 74.4, y = 42.9,
    },
    {
      type = "accept", questName = "A Strange Request", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 11, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "Gordunni Cobalt", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 12, x = 75.7, y = 44.3,
    },
    {
      type = "hearth", name = "Set Hearth to Camp Mojache", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 12, x = 74.8, y = 45.2,
      note = "Bind your hearthstone here.",
    },
    {
      type = "travel", name = "Shyn <Wind Rider Master>", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 12, x = 75.4, y = 44.4,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Camp Mojache to Thunder Bluff", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 12, x = 75.4, y = 44.4,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Deadmire", zone = "Thunder Bluff",
      location = "The Hunter Rise", atLevel = 44, logCount = 11, x = 61.4, y = 80.6,
    },
    {
      type = "travel", name = "Thunder Bluff to Orgrimmar", zone = "Thunder Bluff",
      atLevel = 44, logCount = 11, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 44,
      logCount = 11, note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", optional = true, name = "Skip: S",
      note = "The route deliberately skips Shadowshard Fragments. Low XP for the travel time.",
      zone = "Orgrimmar", location = "The Valley of Spirits", atLevel = 44, x = 39.2, y = 86.3,
    },
    {
      type = "accept", questName = "Horde Trauma", zone = "Orgrimmar",
      location = "The Valley of Spirits", atLevel = 44, logCount = 12, x = 34.2, y = 84.6,
    },
    {
      type = "accept", questName = "A Threat in Feralas", zone = "Orgrimmar",
      location = "The Valley of Honor", atLevel = 44, logCount = 13, x = 75.2, y = 34.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: B",
      note = "Do not pick up yet - the route comes back for Betrayed #1 on a later pass.",
      zone = "Orgrimmar", location = "The Valley of Honor", atLevel = 44, x = 75.2, y = 34.2,
    },
    {
      type = "turnin", questName = "Report to Zor", zone = "Orgrimmar",
      location = "The Valley of Wisdom", atLevel = 44, logCount = 12, x = 35.2, y = 30.7,
    },
    {
      type = "accept", questName = "Service to the Horde", zone = "Orgrimmar",
      location = "The Valley of Wisdom", atLevel = 44, logCount = 13, x = 39.0, y = 38.0,
    },
    {
      type = "turnin", questName = "Service to the Horde", zone = "Orgrimmar",
      location = "The Valley of Wisdom", atLevel = 44, logCount = 12, x = 39.0, y = 38.0,
    },
    {
      type = "turnin", questName = "A Strange Request", zone = "Orgrimmar",
      location = "The Cleft of Shadow", atLevel = 44, logCount = 11, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "Return to Witch Doctor Uzer'i", zone = "Orgrimmar",
      location = "The Cleft of Shadow", atLevel = 44, logCount = 12, x = 49.5, y = 50.6,
    },
    {
      type = "accept", name = "Ripple Recovery (part 1)", questName = "Ripple Recovery",
      ambiguous = true, zone = "Orgrimmar", location = "The Drag", atLevel = 44, logCount = 13,
      x = 59.5, y = 36.6,
    },
    {
      type = "turnin", name = "Ripple Recovery (part 1)", questName = "Ripple Recovery",
      ambiguous = true, zone = "Orgrimmar", location = "The Drag", atLevel = 44, logCount = 12,
      x = 59.6, y = 36.9,
    },
    {
      type = "accept", name = "Ripple Recovery (part 2)", questName = "Ripple Recovery",
      ambiguous = true, zone = "Orgrimmar", location = "The Drag", atLevel = 44, logCount = 13,
      x = 59.6, y = 36.9,
    },
    {
      type = "note", optional = true, name = "Skip: N",
      note = "The route deliberately skips Necklace Recovery. Low XP for the travel time.",
      zone = "Orgrimmar", location = "The Drag", atLevel = 44, x = 59.5, y = 36.6,
    },
    {
      -- x/y dropped: same reasoning as the Stranglethorn Vale hearth step -
      -- this exact coordinate pair is reused verbatim there too, so it's a
      -- placeholder the sheet reused rather than this spot's real position.
      type = "hearth", name = "Hearth to Camp Mojache", zone = "Ragefire Chasm", atLevel = 44,
      logCount = 13,
      note = "Bind your hearthstone here even if it costs you the old bind.",
    },
    {
      type = "turnin", questName = "A Threat in Feralas", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 12,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", name = "The Ogres of Feralas (part 1)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 13,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "Return to Witch Doctor Uzer'i", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 12, x = 49.5, y = 50.6,
    },
    {
      type = "accept", questName = "Testing the Vessel", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 13, x = 49.5, y = 50.6,
    },
    {
      type = "accept", questName = "Natural Materials", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 14, x = 74.4, y = 43.4,
    },
    {
      type = "manual", name = "Woodpaw Gnolls: Silk Cloth x15", zone = "Feralas",
      location = "Camp Mojache", atLevel = 44, logCount = 14, x = 73.0, y = 38.0,
      approx = true,
      note = "Start collecting this now - it drops over the whole leg, not in one spot.",
    },
    {
      type = "complete", questName = "War on the Woodpaw", zone = "Feralas",
      location = "North of Mojache", atLevel = 45, logCount = 14, x = 73.0, y = 38.0,
      approx = true,
    },
    {
      type = "accept", questName = "The Gordunni Scroll", zone = "Feralas",
      location = "Gordunni Outpost", atLevel = 45, logCount = 15,
      note = "Starts from an item you loot here, not from an NPC. Several spots around here - check the whole area.",
    },
    {
      type = "complete", name = "The Ogres of Feralas (part 1)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Gordunni Outpost", atLevel = 45, logCount = 15, x = 76.0, y = 34.0,
      approx = true,
    },
    {
      type = "complete", questName = "Gordunni Cobalt", zone = "Feralas",
      location = "Gordunni Outpost", atLevel = 45, logCount = 15, x = 76.0, y = 34.0,
      approx = true,
    },
    {
      type = "turnin", name = "The Ogres of Feralas (part 1)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Camp Mojache", atLevel = 45, logCount = 14,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "note", optional = true, name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Ogres of Feralas #2 on a later pass.",
      zone = "Feralas", location = "Camp Mojache", atLevel = 45,
    },
    {
      type = "turnin", questName = "The Gordunni Scroll", zone = "Feralas",
      location = "Camp Mojache", atLevel = 45, logCount = 13,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "note", optional = true, name = "Skip for now: D",
      note = "Do not pick up yet - the route comes back for Dark Ceremony on a later pass.",
      zone = "Feralas", location = "Camp Mojache", atLevel = 45,
    },
    {
      type = "turnin", questName = "Gordunni Cobalt", zone = "Feralas",
      location = "Camp Mojache", atLevel = 45, logCount = 12, x = 75.7, y = 44.3,
    },
    {
      type = "turnin", questName = "War on the Woodpaw", zone = "Feralas",
      location = "Camp Mojache", atLevel = 45, logCount = 11, x = 74.9, y = 42.5,
    },
    {
      type = "accept", questName = "Alpha Strike", zone = "Feralas", location = "Camp Mojache",
      atLevel = 45, logCount = 12, x = 74.9, y = 42.5,
    },
    {
      type = "complete", questName = "Alpha Strike", zone = "Feralas",
      location = "Woodpaw Hills", atLevel = 45, logCount = 12, x = 73.0, y = 56.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Alpha Strike", zone = "Feralas", location = "Camp Mojache",
      atLevel = 45, logCount = 11, x = 74.9, y = 42.5,
    },
    {
      type = "accept", questName = "Woodpaw Investigation", zone = "Feralas",
      location = "Camp Mojache", atLevel = 45, logCount = 12, x = 74.9, y = 42.5,
    },
    {
      type = "turnin", questName = "Woodpaw Investigation", zone = "Feralas",
      location = "Woodpaw Hills", atLevel = 45, logCount = 11, x = 71.6, y = 55.9,
    },
    {
      type = "accept", questName = "The Battle Plans", zone = "Feralas",
      location = "Woodpaw Hills", atLevel = 45, logCount = 12, x = 71.6, y = 55.9,
    },
    {
      type = "manual", name = "Woodpaw Gnolls: Silk Cloth x15", zone = "Feralas",
      location = "Woodpaw Hills", atLevel = 45, logCount = 12, x = 71.0, y = 56.0,
      approx = true, note = "You should have the full stack by now.",
    },
    {
      type = "hearth", name = "Hearth to Camp Mojache", zone = "Feralas",
      location = "Woodpaw Hills", atLevel = 45, logCount = 11, x = 71.0, y = 56.0,
      approx = true, note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "The Battle Plans", zone = "Feralas",
      location = "Camp Mojache", atLevel = 45, logCount = 11, x = 71.6, y = 55.9,
    },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Zukk'ash Infestation, Stinglasher on a later pass.",
      zone = "Feralas", location = "Camp Mojache", atLevel = 45, x = 74.9, y = 42.5,
    },
    {
      type = "travel", name = "Camp Mojache to Orgrimmar", zone = "Feralas",
      location = "Camp Mojache", atLevel = 45, logCount = 11, x = 75.4, y = 44.4,
      note = "Take the flight path.",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 45, logCount = 11, x = 50.8, y = 13.9,
      note = "Zeppelin.",
    },
})

-- Chapter 48: Feralas Mid | Chapter 49: Feralas West
Leg(31, "Feralas", {

    { type = "section", name = "Chapter 48: Feralas Mid", levels = { 47, 47 }, zone = "Feralas" },
    {
      type = "turnin", questName = "Testing the Vessel", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 7, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "Hippogryph Muisek", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 8, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "The Sunken Temple", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 9, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "The Mark of Quality", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 10, x = 74.4, y = 42.9,
    },
    {
      type = "accept", questName = "Zukk'ash Infestation", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 11, x = 74.9, y = 42.5,
    },
    {
      type = "accept", questName = "Stinglasher", zone = "Feralas", location = "Camp Mojache",
      atLevel = 47, logCount = 12, x = 74.9, y = 42.5,
    },
    {
      type = "accept", questName = "Vengeance on the Northspring", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 13, x = 76.2, y = 43.8,
    },
    {
      type = "accept", questName = "Dark Heart", zone = "Feralas", location = "Camp Mojache",
      atLevel = 47, logCount = 14, x = 76.2, y = 43.8,
    },
    {
      type = "note", optional = true, name = "Skip for now: S",
      note = "Do not pick up yet - the route comes back for Strength of Corruption on a later pass.",
      zone = "Feralas", location = "Camp Mojache", atLevel = 47, x = 76.2, y = 43.8,
    },
    {
      type = "accept", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 15, x = 75.9, y = 42.7,
    },
    {
      type = "accept", name = "The Ogres of Feralas (part 2)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 16,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", questName = "Dark Ceremony", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 17,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "complete", name = "The Ogres of Feralas (part 2)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Ruins of Isildien", atLevel = 47, logCount = 17, x = 61.0, y = 57.0,
      approx = true,
    },
    {
      type = "complete", questName = "Dark Ceremony", zone = "Feralas",
      location = "Ruins of Isildien", atLevel = 47, logCount = 17, x = 60.0, y = 66.0,
      approx = true,
    },
    {
      type = "manual", name = "Hippogryph Egg x1", zone = "Feralas",
      location = "The High Wilderness", atLevel = 47, logCount = 17, x = 58.0, y = 76.0,
      approx = true, note = "Collect these here.",
    },
    {
      type = "complete", questName = "Natural Materials", zone = "Feralas",
      location = "The High Wilderness", atLevel = 47, logCount = 17, x = 55.0, y = 71.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Hippogryph Muisek", zone = "Feralas",
      location = "The High Wilderness", atLevel = 47, logCount = 17, x = 55.0, y = 71.0,
      approx = true,
    },
    {
      type = "manual", name = "Hippogryphs: Long Elegant Feather x10", zone = "Feralas",
      location = "The High Wilderness", atLevel = 47, logCount = 17, x = 55.0, y = 71.0,
      approx = true, note = "You should have the full stack by now.",
    },
    {
      type = "complete", questName = "The Mark of Quality", zone = "Feralas",
      location = "Feral Scar Vale", atLevel = 47, logCount = 17, x = 55.0, y = 56.0,
      approx = true,
    },
    {
      type = "accept", questName = "Find OOX-22/FE!", zone = "Feralas",
      location = "Feral Scar Vale", atLevel = 47, logCount = 18,
      note = "Starts from an item you loot here, not from an NPC. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "turnin", questName = "Find OOX-22/FE!", zone = "Feralas",
      location = "Feral Scar Vale", atLevel = 47, logCount = 17, x = 53.4, y = 55.7,
    },
    {
      type = "note", optional = true, name = "Skip: R",
      note = "The route deliberately skips Rescue OOX-22/FE!. Low XP for the travel time.",
      zone = "Feralas", location = "Feral Scar Vale", atLevel = 47, x = 53.4, y = 55.7,
    },
    {
      type = "turnin", questName = "Hippogryph Muisek", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 16, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "Faerie Dragon Muisek", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 17, x = 74.4, y = 43.4,
    },
    {
      type = "turnin", questName = "The Mark of Quality", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 16, x = 74.4, y = 42.9,
    },
    {
      type = "accept", questName = "Improved Quality", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 17, x = 74.4, y = 42.9,
    },
    {
      type = "turnin", name = "The Ogres of Feralas (part 2)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 16,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "Dark Ceremony", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 15,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "accept", questName = "The Gordunni Orb", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 16,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "complete", questName = "Faerie Dragon Muisek", zone = "Feralas",
      location = "Grimtotem Compound", atLevel = 47, logCount = 16, x = 68.0, y = 48.0,
      approx = true,
    },
    {
      type = "complete", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Grimtotem Compound", atLevel = 47, logCount = 16, x = 68.0, y = 48.0,
      approx = true,
    },
    {
      type = "turnin", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 15, x = 75.9, y = 42.7,
    },
    {
      type = "accept", name = "A Grim Discovery (part 1)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Camp Mojache", atLevel = 47,
      logCount = 16, x = 75.9, y = 42.7,
    },
    {
      type = "turnin", questName = "Faerie Dragon Muisek", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 15, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "Treant Muisek", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 16, x = 74.4, y = 43.4,
    },
    {
      type = "complete", questName = "Treant Muisek", zone = "Feralas",
      location = "Woodpaw Hills", atLevel = 47, logCount = 16, x = 74.0, y = 54.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Stinglasher", zone = "Feralas",
      location = "The Writhing Deep", atLevel = 47, logCount = 16, x = 77.0, y = 61.6,
    },
    {
      type = "complete", questName = "Zukk'ash Infestation", zone = "Feralas",
      location = "The Writhing Deep", atLevel = 47, logCount = 16, x = 73.0, y = 62.0,
      approx = true,
    },
    {
      type = "complete", questName = "Treant Muisek", zone = "Feralas",
      location = "North of Mojache", atLevel = 47, logCount = 16, x = 74.0, y = 40.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "note", name = "Note",
      note = "There is 1 Wandering Forest Walker north and 1 south of Camp Mojache. Estimated respawn is 10 minutes each.",
      atLevel = 47,
    },
    {
      type = "complete", questName = "Treant Muisek", zone = "Feralas",
      location = "Woodpaw Hills", atLevel = 47, logCount = 16, x = 74.0, y = 54.0,
      approx = true,
    },
    {
      type = "complete", questName = "Natural Materials", zone = "Feralas",
      location = "Woodpaw Hills", atLevel = 47, logCount = 16, x = 74.0, y = 54.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Treant Muisek", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 15, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "Mountain Giant Muisek", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 16, x = 74.4, y = 43.4,
    },
    {
      type = "turnin", questName = "Natural Materials", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 15, x = 74.4, y = 43.4,
    },
    {
      type = "turnin", questName = "Zukk'ash Infestation", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 14, x = 74.9, y = 42.5,
    },
    {
      type = "turnin", questName = "Stinglasher", zone = "Feralas", location = "Camp Mojache",
      atLevel = 47, logCount = 13, x = 74.9, y = 42.5,
    },
    {
      type = "accept", questName = "Zukk'ash Report", zone = "Feralas",
      location = "Camp Mojache", atLevel = 47, logCount = 14, x = 74.9, y = 42.5,
    },

    { type = "section", name = "Chapter 49: Feralas West", levels = { 47, 48 }, zone = "Feralas" },
    {
      type = "complete", name = "A Grim Discovery (part 1)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Grimtotem Compound", atLevel = 47,
      logCount = 14, x = 67.0, y = 46.0, approx = true,
    },
    {
      type = "accept", questName = "Zapped Giants", zone = "Feralas",
      location = "The Forgotten Coast", atLevel = 47, logCount = 15, x = 44.8, y = 43.4,
    },
    {
      type = "accept", questName = "Fuel for the Zapping", zone = "Feralas",
      location = "The Forgotten Coast", atLevel = 47, logCount = 16, x = 44.8, y = 43.4,
    },
    {
      type = "complete", questName = "Fuel for the Zapping", zone = "Feralas",
      location = "The Forgotten Coast", atLevel = 47, logCount = 16, x = 47.0, y = 50.0,
      approx = true,
    },
    {
      type = "complete", questName = "Screecher Spirits", zone = "Feralas",
      location = "The Forgotten Coast", atLevel = 47, logCount = 16, x = 47.0, y = 50.0,
      approx = true,
    },
    {
      type = "complete", questName = "Improved Quality", zone = "Feralas",
      location = "Rage Scar Hold", atLevel = 47, logCount = 16, x = 53.0, y = 32.0,
      approx = true,
    },
    {
      type = "accept", questName = "Perfect Yeti Hide", zone = "Feralas",
      location = "Rage Scar Hold", atLevel = 47, logCount = 17, x = 53.0, y = 32.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", questName = "Zapped Giants", zone = "Feralas",
      location = "Twin Colossals", atLevel = 47, logCount = 17, x = 40.0, y = 24.0,
      approx = true,
    },
    {
      type = "complete", questName = "Mountain Giant Muisek", zone = "Feralas",
      location = "Twin Colossals", atLevel = 47, logCount = 17, x = 40.0, y = 24.0,
      approx = true,
    },
    {
      type = "complete", questName = "Vengeance on the Northspring", zone = "Feralas",
      location = "Ruins of Ravenwind", atLevel = 48, logCount = 17, x = 40.0, y = 10.0,
      approx = true,
    },
    {
      type = "complete", questName = "Dark Heart", zone = "Feralas",
      location = "Ruins of Ravenwind", atLevel = 48, logCount = 17, x = 40.0, y = 10.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Zapped Giants", zone = "Feralas",
      location = "The Forgotten Coast", atLevel = 48, logCount = 16, x = 44.8, y = 43.4,
    },
    {
      type = "turnin", questName = "Fuel for the Zapping", zone = "Feralas",
      location = "The Forgotten Coast", atLevel = 48, logCount = 15, x = 44.8, y = 43.4,
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips Again With the Zapped Giants, Refuel for the Zapping. Low XP for the travel time.",
      zone = "Feralas", location = "The Forgotten Coast", atLevel = 48, x = 44.8, y = 43.4,
    },
    {
      type = "hearth", name = "Hearth to Camp Mojache", zone = "Feralas",
      location = "Twin Colossals", atLevel = 48, logCount = 15, x = 44.8, y = 43.4,
      note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Mountain Giant Muisek", zone = "Feralas",
      location = "Camp Mojache", atLevel = 48, logCount = 14, x = 74.4, y = 43.4,
    },
    {
      type = "accept", questName = "Weapons of Spirit", zone = "Feralas",
      location = "Camp Mojache", atLevel = 48, logCount = 15, x = 74.4, y = 43.4,
    },
    {
      type = "turnin", questName = "Improved Quality", zone = "Feralas",
      location = "Camp Mojache", atLevel = 48, logCount = 14, x = 74.4, y = 42.9,
    },
    {
      type = "turnin", questName = "Perfect Yeti Hide", zone = "Feralas",
      location = "Camp Mojache", atLevel = 48, logCount = 13, x = 74.4, y = 42.9,
    },
    {
      type = "turnin", questName = "Vengeance on the Northspring", zone = "Feralas",
      location = "Camp Mojache", atLevel = 48, logCount = 12, x = 76.2, y = 43.8,
    },
    {
      type = "turnin", questName = "Dark Heart", zone = "Feralas", location = "Camp Mojache",
      atLevel = 48, logCount = 11, x = 76.2, y = 43.8,
    },
    {
      type = "turnin", name = "A Grim Discovery (part 1)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Camp Mojache", atLevel = 48,
      logCount = 10, x = 75.9, y = 42.7,
    },
    {
      type = "accept", name = "A Grim Discovery (part 2)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Camp Mojache", atLevel = 48,
      logCount = 11, x = 75.9, y = 42.7,
    },
    {
      type = "turnin", questName = "Weapons of Spirit", zone = "Feralas",
      location = "Camp Mojache", atLevel = 48, logCount = 10, x = 74.4, y = 43.4,
    },
    {
      type = "travel", name = "Camp Mojache to Gadgetzan", zone = "Feralas",
      location = "Camp Mojache", atLevel = 48, logCount = 10, x = 75.4, y = 44.4,
      note = "Take the flight path.",
    },
})

