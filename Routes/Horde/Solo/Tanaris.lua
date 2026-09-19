-- TuFFlevels / Routes/Horde/Solo/Tanaris.lua
--
-- Tanaris leg(s) of the solo Orc/Troll 1-60 route. Levels 44-49.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 44: Tanaris North
Leg(27, "Tanaris", {

    { type = "section", name = "Chapter 44: Tanaris North", levels = { 44, 44 }, zone = "Tanaris" },
    {
      type = "turnin", questName = "Tran'rek", zone = "Tanaris", location = "Gadgetzan",
      atLevel = 44, logCount = 9, x = 51.6, y = 26.8,
    },
    {
      type = "note", name = "Skip: S",
      note = "The route deliberately skips Scarab Shells. Low XP for the travel time.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 51.6, y = 26.8,
    },
    {
      type = "note", name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for Thistleshrub Valley on a later pass.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 51.6, y = 26.8,
    },
    {
      type = "accept", questName = "WANTED: Caliph Scorpidsting", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 10, x = 51.8, y = 27.0,
    },
    {
      type = "accept", questName = "WANTED: Andre Firebeard", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 11, x = 51.8, y = 27.0,
    },
    {
      type = "note", name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Dunemaul Compound on a later pass.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 52.8, y = 27.4,
    },
    {
      type = "hearth", name = "Set Hearth to Gadgetzan", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 11, x = 52.6, y = 27.9,
      note = "Bind your hearthstone here.",
    },
    {
      type = "turnin", questName = "Zanzil's Mixture and a Fool's Stout",
      zone = "Thousand Needles", location = "Shimmering Flats", atLevel = 44, logCount = 10,
      x = 77.8, y = 77.2,
    },
    {
      type = "accept", questName = "Get the Gnomes Drunk", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 44, logCount = 11, x = 77.8, y = 77.2,
    },
    {
      type = "turnin", questName = "Get the Gnomes Drunk", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 44, logCount = 10, x = 77.4, y = 77.0,
    },
    {
      type = "accept", questName = "Report Back to Fizzlebub", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 44, logCount = 11, x = 77.8, y = 77.2,
    },
    {
      type = "turnin", questName = "Razzeric's Tweaking", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 44, logCount = 10, x = 80.2, y = 76.0,
    },
    {
      type = "accept", name = "Safety First (part 1)", questName = "Safety First",
      ambiguous = true, zone = "Thousand Needles", location = "Shimmering Flats", atLevel = 44,
      logCount = 11, x = 80.2, y = 76.0,
    },
    {
      type = "hearth", name = "Hearth to Gadgetzan", zone = "Thousand Needles",
      location = "Shimmering Flats", atLevel = 44, logCount = 11, x = 77.8, y = 77.2,
      note = "Use your hearthstone.",
    },
    {
      type = "accept", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 12, x = 52.5, y = 28.4,
    },
    {
      type = "turnin", questName = "Into the Field", zone = "Tanaris", location = "Gadgetzan",
      atLevel = 44, logCount = 11, x = 52.5, y = 28.5,
    },
    {
      type = "accept", questName = "Slake That Thirst", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 12, x = 52.5, y = 28.5,
    },
    {
      type = "accept", questName = "Wastewander Justice", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 13, x = 52.5, y = 28.5,
    },
    {
      type = "note", name = "Skip: D",
      note = "The route deliberately skips Divino-matic Rod. Low XP for the travel time.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 52.5, y = 28.5,
    },
    {
      type = "note", name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Thirsty Goblin on a later pass.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 51.8, y = 28.7,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips Troll Temper. Low XP for the travel time.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 51.4, y = 28.8,
    },
    {
      type = "complete", questName = "Wastewander Justice", zone = "Tanaris",
      location = "Noonshade Ruins", atLevel = 44, logCount = 13, x = 60.0, y = 23.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Slake That Thirst", zone = "Tanaris",
      location = "Noonshade Ruins", atLevel = 44, logCount = 13, x = 60.0, y = 23.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Noonshade Ruins", atLevel = 44, logCount = 13, x = 60.0, y = 23.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", questName = "Pirate Hats Ahoy!", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 14, x = 66.6, y = 22.3,
    },
    {
      type = "accept", questName = "Screecher Spirits", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 15, x = 67.0, y = 22.4,
    },
    {
      type = "accept", questName = "Southsea Shakedown", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 16, x = 67.1, y = 23.9,
    },
    {
      type = "turnin", questName = "Stoley's Debt", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 15, x = 67.1, y = 24.0,
    },
    {
      type = "accept", questName = "Stoley's Shipment", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 16, x = 67.1, y = 24.0,
    },
    {
      type = "complete", questName = "Wastewander Justice", zone = "Tanaris",
      location = "Winterspring Field", atLevel = 44, logCount = 16, x = 63.0, y = 30.0,
      approx = true,
    },
    {
      type = "complete", questName = "Slake That Thirst", zone = "Tanaris",
      location = "Winterspring Field", atLevel = 44, logCount = 16, x = 63.0, y = 30.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Winterspring Field", atLevel = 44, logCount = 16, x = 63.0, y = 30.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", questName = "Wastewander Justice", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 15, x = 52.5, y = 28.5,
    },
    {
      type = "accept", questName = "More Wastewander Justice", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 16, x = 52.5, y = 28.5,
    },
    {
      type = "complete", questName = "Slake That Thirst", zone = "Tanaris",
      location = "Winterspring Field", atLevel = 44, logCount = 16, x = 62.0, y = 37.0,
      approx = true,
    },
    {
      type = "complete", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Winterspring Field", atLevel = 44, logCount = 16, x = 62.0, y = 37.0,
      approx = true,
    },
    {
      type = "complete", questName = "WANTED: Caliph Scorpidsting", zone = "Tanaris",
      location = "Winterspring Field", atLevel = 44, logCount = 16, x = 62.0, y = 37.0,
      approx = true,
    },
    {
      type = "complete", questName = "More Wastewander Justice", zone = "Tanaris",
      location = "Winterspring Field", atLevel = 44, logCount = 16, x = 62.0, y = 37.0,
      approx = true,
    },
    {
      type = "note", name = "Note",
      note = "Make sure you have collected 10 total Wastewander Water Pouches.", atLevel = 44,
    },
    {
      type = "complete", questName = "WANTED: Andre Firebeard", zone = "Tanaris",
      location = "Lost Rigger Cove", atLevel = 44, logCount = 16, x = 73.4, y = 47.1,
    },
    {
      type = "complete", questName = "Stoley's Shipment", zone = "Tanaris",
      location = "Lost Rigger Cove", atLevel = 44, logCount = 16, x = 72.2, y = 46.8,
    },
    {
      type = "complete", questName = "Southsea Shakedown", zone = "Tanaris",
      location = "Lost Rigger Cove", atLevel = 44, logCount = 16, x = 74.0, y = 47.0,
      approx = true,
    },
    {
      type = "complete", questName = "Pirate Hats Ahoy!", zone = "Tanaris",
      location = "Lost Rigger Cove", atLevel = 44, logCount = 16, x = 74.0, y = 47.0,
      approx = true,
    },
    {
      type = "accept", questName = "Ship Schedules", zone = "Tanaris",
      location = "Lost Rigger Cove", atLevel = 44, logCount = 17, x = 74.0, y = 47.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "note", name = "Note",
      note = "If you didn't loot any Ship Schedules from a Pirate's Footlocker drop, then skip this turn in.",
      atLevel = 44,
    },
    {
      type = "turnin", questName = "WANTED: Andre Firebeard", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 16, x = 67.1, y = 23.9,
    },
    {
      type = "turnin", questName = "Ship Schedules", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 15, x = 67.1, y = 23.9,
    },
    {
      type = "turnin", questName = "Southsea Shakedown", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 14, x = 67.1, y = 23.9,
    },
    {
      type = "turnin", questName = "Stoley's Shipment", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 13, x = 67.1, y = 24.0,
    },
    {
      type = "accept", questName = "Deliver to MacKinley", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 14, x = 67.1, y = 24.0,
    },
    {
      type = "turnin", questName = "Pirate Hats Ahoy!", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 13, x = 66.6, y = 22.3,
    },
    {
      type = "hearth", name = "Hearth to Gadgetzan", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 44, logCount = 13, x = 66.6, y = 22.3,
      note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 12, x = 52.5, y = 28.4,
    },
    {
      type = "turnin", questName = "Slake That Thirst", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 11, x = 52.5, y = 28.5,
    },
    {
      type = "accept", questName = "Tanaris Field Sampling", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 12, x = 52.5, y = 28.5,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "turnin", questName = "WANTED: Caliph Scorpidsting", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 11, x = 52.5, y = 28.5,
    },
    {
      type = "turnin", questName = "More Wastewander Justice", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 10, x = 52.5, y = 28.5,
    },
    {
      type = "note", name = "Skip: A",
      note = "The route deliberately skips Another Power Source?. Low XP for the travel time.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 52.5, y = 28.5,
    },
    {
      type = "turnin", name = "Safety First (part 1)", questName = "Safety First",
      ambiguous = true, zone = "Tanaris", location = "Gadgetzan", atLevel = 44, logCount = 9,
      x = 51.0, y = 27.2,
    },
    {
      type = "note", name = "Skip: S",
      note = "The route deliberately skips Safety First #2. Low XP for the travel time.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 51.0, y = 27.2,
    },
    {
      type = "accept", questName = "Gadgetzan Water Survey", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 10, x = 50.2, y = 27.4,
    },
    {
      type = "complete", questName = "Gadgetzan Water Survey", zone = "Tanaris",
      location = "Sandsorrow Watch", atLevel = 44, logCount = 10, x = 38.9, y = 29.2,
    },
    {
      type = "complete", questName = "Tanaris Field Sampling", zone = "Tanaris",
      location = "West of Gadgetzan", atLevel = 44, logCount = 10, x = 46.0, y = 29.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Gadgetzan Water Survey", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 9, x = 50.2, y = 27.4,
    },
    {
      type = "note", name = "Skip for now: N",
      note = "Do not pick up yet - the route comes back for Noxious Lair Investigation on a later pass.",
      zone = "Tanaris", location = "Gadgetzan", atLevel = 44, x = 50.2, y = 27.4,
    },
    {
      type = "turnin", questName = "Tanaris Field Sampling", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 8, x = 52.5, y = 28.5,
    },
    {
      type = "accept", questName = "Return to Apothecary Zinge", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 9, x = 52.5, y = 28.5,
    },
    {
      type = "travel", name = "Gadgetzan to Freewind Post", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 44, logCount = 9, x = 51.6, y = 25.4,
      note = "Take the flight path.",
    },
})

-- Chapter 50: Tanaris South
Leg(32, "Tanaris", {

    { type = "section", name = "Chapter 50: Tanaris South", levels = { 48, 49 }, zone = "Tanaris" },
    {
      type = "accept", questName = "Thistleshrub Valley", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 48, logCount = 11, x = 51.6, y = 26.8,
    },
    {
      type = "accept", questName = "Super Sticky", zone = "Tanaris", location = "Gadgetzan",
      atLevel = 48, logCount = 12, x = 51.6, y = 26.8,
    },
    {
      type = "accept", questName = "The Super Egg-O-Matic", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 48, logCount = 13, x = 52.4, y = 27.0,
    },
    {
      type = "turnin", questName = "The Super Egg-O-Matic", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 48, logCount = 12, x = 52.4, y = 27.0,
    },
    {
      type = "accept", questName = "The Dunemaul Compound", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 48, logCount = 13, x = 52.8, y = 27.4,
    },
    {
      type = "hearth", name = "Set Hearth to Gadgetzan", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 48, logCount = 13, x = 52.6, y = 27.9,
      note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "The Thirsty Goblin", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 48, logCount = 14, x = 51.8, y = 28.7,
    },
    {
      type = "accept", questName = "Noxious Lair Investigation", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 48, logCount = 15, x = 50.2, y = 27.4,
    },
    {
      type = "turnin", questName = "The Sunken Temple", zone = "Tanaris",
      location = "Broken Pillar", atLevel = 48, logCount = 14, x = 52.7, y = 45.9,
    },
    {
      type = "accept", questName = "The Stone Circle", zone = "Tanaris",
      location = "Broken Pillar", atLevel = 48, logCount = 15, x = 52.7, y = 45.9,
    },
    {
      type = "accept", questName = "Gahz'ridian", zone = "Tanaris", location = "Broken Pillar",
      atLevel = 48, logCount = 16, x = 52.7, y = 45.9,
    },
    {
      type = "complete", questName = "The Dunemaul Compound", zone = "Tanaris",
      location = "Dunemaul Compound", atLevel = 48, logCount = 16, x = 41.0, y = 55.0,
      approx = true,
    },
    {
      type = "grind", targetLevel = 49,
      name = "Kill until Level 49 at Dunemmaul or Southmoon Ruins.", zone = "Tanaris",
      location = "Dunemaul Compound", atLevel = 49, logCount = 16, x = 41.0, y = 55.0,
      approx = true,
    },
    {
      type = "complete", questName = "Gahz'ridian", zone = "Tanaris",
      location = "Southmoon Ruins", atLevel = 49, logCount = 16, x = 40.0, y = 72.0,
      approx = true,
    },
    {
      type = "complete", questName = "Thistleshrub Valley", zone = "Tanaris",
      location = "Thistleshrub Valley", atLevel = 49, logCount = 16, x = 29.0, y = 67.0,
      approx = true,
    },
    {
      type = "complete", questName = "The Thirsty Goblin", zone = "Tanaris",
      location = "Thistleshrub Valley", atLevel = 49, logCount = 16, x = 29.0, y = 67.0,
      approx = true,
    },
    {
      type = "accept", questName = "Tooga's Quest", zone = "Tanaris",
      location = "Thistleshrub Valley", atLevel = 49, logCount = 17,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Noxious Lair Investigation", zone = "Tanaris",
      location = "Noxious Lair", atLevel = 49, logCount = 17, x = 34.0, y = 48.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Gahz'ridian", zone = "Tanaris", location = "Broken Pillar",
      atLevel = 49, logCount = 16, x = 52.7, y = 45.9,
    },
    {
      type = "turnin", questName = "Tooga's Quest", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 49, logCount = 15, x = 66.6, y = 25.7,
    },
    {
      type = "accept", questName = "Yuka Screwspigot", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 49, logCount = 16, x = 67.0, y = 24.0,
    },
    {
      type = "turnin", questName = "Screecher Spirits", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 49, logCount = 15, x = 67.0, y = 22.4,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Prophecy of Mosh'aru. Low XP for the travel time.",
      zone = "Tanaris", location = "Steamwheedle Port", atLevel = 49, x = 67.0, y = 22.4,
    },
    {
      type = "hearth", name = "Hearth to Gadgetzan", zone = "Tanaris",
      location = "Steamwheedle Port", atLevel = 49, logCount = 15, x = 67.0, y = 22.4,
      note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "The Thirsty Goblin", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 14, x = 51.8, y = 28.7,
    },
    {
      type = "accept", questName = "In Good Taste", zone = "Tanaris", location = "Gadgetzan",
      atLevel = 49, logCount = 15, x = 51.8, y = 28.7,
    },
    {
      type = "turnin", questName = "Noxious Lair Investigation", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 14, x = 50.2, y = 27.4,
    },
    {
      type = "turnin", questName = "In Good Taste", zone = "Tanaris", location = "Gadgetzan",
      atLevel = 49, logCount = 13, x = 51.8, y = 28.7,
    },
    {
      type = "accept", questName = "Sprinkle's Secret Ingredient", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 14, x = 51.6, y = 26.9,
    },
    {
      type = "accept", questName = "The Scrimshank Redemption", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 15, x = 50.2, y = 27.5,
    },
    {
      type = "turnin", questName = "Thistleshrub Valley", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 14, x = 51.6, y = 26.8,
    },
    {
      type = "turnin", questName = "The Dunemaul Compound", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 13, x = 52.8, y = 27.4,
    },
    {
      type = "accept", questName = "Find OOX-17/TN!", zone = "Tanaris",
      location = "Southbreak Shore", atLevel = 49, logCount = 14,
      note = "Starts from an item you loot here, not from an NPC. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "turnin", questName = "Find OOX-17/TN!", zone = "Tanaris",
      location = "Southbreak Shore", atLevel = 49, logCount = 13, x = 60.2, y = 64.7,
    },
    {
      type = "note", name = "Skip: R",
      note = "The route deliberately skips Rescue OOX-17/TN!. Low XP for the travel time.",
      zone = "Tanaris", location = "Southbreak Shore", atLevel = 49, x = 60.2, y = 64.7,
    },
    {
      type = "complete", questName = "The Scrimshank Redemption", zone = "Tanaris",
      location = "Gaping Chasm", atLevel = 49, logCount = 13, x = 56.0, y = 71.2,
    },
    {
      type = "death", name = "Gaping Chasm to Gadgetzan", zone = "Tanaris",
      location = "Gaping Chasm", atLevel = 49, logCount = 13, x = 56.0, y = 71.2,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "turnin", questName = "The Scrimshank Redemption", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 12, x = 50.2, y = 27.5,
    },
    {
      type = "accept", name = "Insect Part Analysis (part 1)",
      questName = "Insect Part Analysis", ambiguous = true, zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 13, x = 50.2, y = 27.5,
    },
    {
      type = "turnin", name = "Insect Part Analysis (part 1)",
      questName = "Insect Part Analysis", ambiguous = true, zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 12, x = 50.9, y = 27.0,
    },
    {
      type = "accept", name = "Insect Part Analysis (part 2)",
      questName = "Insect Part Analysis", ambiguous = true, zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 13, x = 50.9, y = 27.0,
    },
    {
      type = "turnin", name = "Insect Part Analysis (part 2)",
      questName = "Insect Part Analysis", ambiguous = true, zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 12, x = 50.2, y = 27.5,
    },
    {
      type = "accept", questName = "Rise of the Silithid", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 13, x = 50.2, y = 27.5,
    },
    {
      type = "travel", name = "Gadgetzan to Orgrimmar", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 49, logCount = 13, x = 51.6, y = 25.4,
      note = "Take the flight path.",
    },
})

