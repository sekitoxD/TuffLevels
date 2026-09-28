-- TuFFlevels / Routes/Horde/Solo/StranglethornVale.lua
--
-- Stranglethorn Vale leg(s) of the solo Orc/Troll 1-60 route. Levels 34-42.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 30: Start Stranglethorn Vale | Chapter 31: Stranglethorn Vale North | Chapter 32: Lake Nazferiti
Leg(17, "Stranglethorn Vale", {

    {
      type = "section", name = "Chapter 30: Start Stranglethorn Vale", levels = { 34, 34 },
      zone = "Stranglethorn Vale",
    },
    {
      type = "turnin", name = "Parts of the Swarm (part 1)", questName = "Parts of the Swarm",
      ambiguous = true, zone = "The Barrens", location = "The Crossroads", atLevel = 34,
      logCount = 8, x = 51.0, y = 29.6,
    },
    {
      type = "accept", name = "Parts of the Swarm (part 2)", questName = "Parts of the Swarm",
      ambiguous = true, zone = "The Barrens", location = "The Crossroads", atLevel = 34,
      logCount = 9, x = 51.0, y = 29.6,
    },
    {
      type = "hearth", name = "Set Hearth to The Crossroads", zone = "The Barrens",
      location = "The Crossroads", atLevel = 34, logCount = 9, x = 52.0, y = 29.9,
      note = "Bind your hearthstone here.",
    },
    {
      type = "travel", name = "The Crossroads to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", atLevel = 34, logCount = 9, x = 51.5, y = 30.3,
      note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Alliance Relations (part 4)", questName = "Alliance Relations",
      ambiguous = true, zone = "Orgrimmar", location = "Orgrimmar West Gate", atLevel = 34,
      logCount = 8, x = 22.4, y = 52.8,
    },
    {
      type = "note", name = "Note",
      note = "Train in Orgrimmar if you did not train in Thunder Bluff.", atLevel = 34,
    },
    {
      type = "turnin", name = "Parts of the Swarm (part 2)", questName = "Parts of the Swarm",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Honor", atLevel = 34,
      logCount = 7, x = 75.0, y = 34.0,
    },
    {
      -- x/y dropped: this exact coordinate pair (52.8, 49.0) also appears
      -- verbatim on the unrelated Feralas hearth step below in the route,
      -- so it reads as a placeholder the sheet reused rather than this
      -- spot's real position - not safe to trust or "correct" by guessing.
      -- hearth steps auto-complete on hearth-cast + zone change, not on
      -- coordinates, so this loses nothing functional.
      type = "hearth", name = "Hearth to The Crossroads", zone = "Ragefire Chasm",
      atLevel = 34, logCount = 7,
      note = "Bind your hearthstone here even if it costs you the old bind.",
    },
    {
      type = "travel", name = "The Crossroads to Ratchet", zone = "The Barrens",
      location = "Ratchet", atLevel = 34, logCount = 7, x = 51.5, y = 30.3,
      note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Goblin Sponsorship (part 1)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 34, logCount = 6,
      x = 62.6, y = 36.2,
    },
    {
      type = "accept", name = "Goblin Sponsorship (part 2)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", atLevel = 34, logCount = 7,
      x = 62.6, y = 36.2,
    },
    {
      type = "travel", name = "Ratchet to Booty Bay", zone = "The Barrens",
      location = "Ratchet", atLevel = 34, logCount = 7, x = 63.7, y = 38.7, note = "Boat.",
    },
    {
      type = "turnin", name = "Goblin Sponsorship (part 2)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 34,
      logCount = 6, x = 26.2, y = 73.4,
    },
    {
      type = "accept", name = "Goblin Sponsorship (part 3)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 34,
      logCount = 7, x = 26.2, y = 73.4,
    },
    {
      type = "accept", questName = "Supply and Demand", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 8, x = 28.2, y = 77.4,
    },
    {
      type = "note", optional = true, name = "Skip for now: S",
      note = "Do not pick up yet - the route comes back for Scaring Shaky on a later pass.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 34, x = 27.8, y = 77.0,
    },
    {
      type = "accept", questName = "Singing Blue Shards", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 9, x = 27.0, y = 77.2,
    },
    {
      type = "hearth", name = "Set Hearth to Booty Bay", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 9, x = 27.0, y = 77.2,
      note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Investigate the Camp", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 10, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", questName = "The Rumormonger", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 9, x = 27.0, y = 77.2,
    },
    {
      type = "accept", questName = "Dream Dust in the Swamp", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 10, x = 27.0, y = 77.2,
    },
    {
      type = "accept", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 11, x = 27.0, y = 77.2,
    },
    {
      type = "accept", questName = "Hostile Takeover", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 12, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", name = "Goblin Sponsorship (part 3)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 34,
      logCount = 11, x = 27.2, y = 76.8,
    },
    {
      type = "accept", name = "Goblin Sponsorship (part 4)", questName = "Goblin Sponsorship",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 34,
      logCount = 12, x = 27.2, y = 76.8,
    },
    {
      type = "travel", name = "Gringer <Wind Rider Master>", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 34, logCount = 12, x = 26.9, y = 77.1,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Thysta <Wind Rider Master>", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 34, logCount = 12, x = 32.5, y = 29.4,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "accept", name = "The Defense of Grom'gol (part 1)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 34, logCount = 13, x = 32.2, y = 28.8,
    },
    {
      type = "accept", name = "Mok'thardin's Enchantment (part 1)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 34, logCount = 14, x = 32.0, y = 29.2,
    },
    {
      type = "accept", questName = "Bloody Bone Necklaces", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 34, logCount = 15, x = 32.2, y = 27.8,
    },
    {
      type = "note", optional = true, name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Vile Reef on a later pass.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp", atLevel = 34, x = 32.2,
      y = 27.8,
    },
    {
      type = "accept", questName = "Hunt for Yenniku", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 34, logCount = 16, x = 32.2, y = 27.8,
    },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Trollbane, Grim Message on a later pass.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp", atLevel = 34, x = 32.2,
      y = 27.8,
    },
    {
      type = "manual", name = "Green Hills of Stranglethorn Pages",
      zone = "Stranglethorn Vale", atLevel = 34, logCount = 16,
      note = "Start collecting this now - it drops over the whole leg, not in one spot. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "complete", questName = "Investigate the Camp", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 34, logCount = 16, x = 27.0, y = 77.2,
    },
    {
      type = "accept", questName = "Welcome to the Jungle", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 34, logCount = 17, x = 35.6, y = 10.8,
    },
    {
      type = "turnin", questName = "Hemet Nesingwary", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 34, logCount = 16, x = 35.6, y = 10.8,
    },
    {
      type = "turnin", questName = "Hunting in Stranglethorn", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 34, logCount = 15, x = 35.6, y = 10.8,
    },
    {
      type = "turnin", questName = "Welcome to the Jungle", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 34, logCount = 14, x = 35.6, y = 10.8,
    },
    {
      type = "accept", name = "Raptor Mastery (part 1)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 34, logCount = 15, x = 35.6, y = 10.8,
    },
    {
      type = "accept", name = "Tiger Mastery (part 1)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 34, logCount = 16, x = 35.6, y = 10.6,
    },
    {
      type = "accept", name = "Panther Mastery (part 1)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 34, logCount = 17, x = 35.6, y = 10.6,
    },
    {
      type = "note", optional = true, name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Green Hills of Stranglethorn on a later pass.",
      zone = "Stranglethorn Vale", location = "Nesingwary's Expedition", atLevel = 34,
      x = 35.6, y = 10.6,
    },

    {
      type = "section", name = "Chapter 31: Stranglethorn Vale North", levels = { 34, 35 },
      zone = "Stranglethorn Vale",
    },
    {
      type = "complete", name = "Panther Mastery (part 1)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 34, logCount = 17, x = 41.0, y = 11.0, approx = true,
    },
    {
      type = "complete", questName = "Supply and Demand", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 34, logCount = 17, x = 41.0, y = 11.0,
      approx = true,
    },
    {
      type = "complete", questName = "Singing Blue Shards", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 34, logCount = 17, x = 35.0, y = 7.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Tiger Mastery (part 1)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 17, x = 33.0, y = 11.0, approx = true,
    },
    {
      type = "turnin", name = "Panther Mastery (part 1)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 16, x = 35.6, y = 10.8,
    },
    {
      type = "accept", name = "Panther Mastery (part 2)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 17, x = 35.6, y = 10.8,
    },
    {
      type = "turnin", name = "Tiger Mastery (part 1)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 16, x = 35.6, y = 10.6,
    },
    {
      type = "accept", name = "Tiger Mastery (part 2)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 17, x = 35.6, y = 10.6,
    },
    {
      type = "complete", questName = "Hunt for Yenniku", zone = "Stranglethorn Vale",
      location = "Tkashi Ruins", atLevel = 35, logCount = 17, x = 31.0, y = 13.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Tkashi Ruins", atLevel = 35, logCount = 17, x = 31.0, y = 13.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Bloody Bone Necklaces", zone = "Stranglethorn Vale",
      location = "Tkashi Ruins", atLevel = 35, logCount = 17, x = 31.0, y = 13.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Tiger Mastery (part 2)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Northwest Stranglethorn",
      atLevel = 35, logCount = 17, x = 31.0, y = 13.0, approx = true,
    },
    {
      type = "complete", name = "Panther Mastery (part 2)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Northwest Stranglethorn",
      atLevel = 35, logCount = 17, x = 31.0, y = 13.0, approx = true,
    },
    {
      type = "complete", name = "Raptor Mastery (part 1)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Northwest Stranglethorn",
      atLevel = 35, logCount = 17, x = 27.0, y = 17.0, approx = true,
    },
    {
      type = "complete", questName = "Singing Blue Shards", zone = "Stranglethorn Vale",
      location = "Bal'lal Ruins", atLevel = 35, logCount = 17, x = 25.0, y = 17.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Hunt for Yenniku", zone = "Stranglethorn Vale",
      location = "Bal'lal Ruins", atLevel = 35, logCount = 17, x = 30.0, y = 20.0,
      approx = true,
    },
    {
      type = "turnin", name = "Raptor Mastery (part 1)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 16, x = 35.6, y = 10.8,
    },
    {
      type = "accept", name = "Raptor Mastery (part 2)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 17, x = 35.6, y = 10.8,
    },
    {
      type = "turnin", name = "Tiger Mastery (part 2)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 16, x = 35.6, y = 10.6,
    },
    {
      type = "accept", name = "Tiger Mastery (part 3)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 17, x = 35.6, y = 10.6,
    },
    {
      type = "turnin", name = "Panther Mastery (part 2)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 16, x = 35.6, y = 10.8,
    },
    {
      type = "accept", name = "Panther Mastery (part 3)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 35, logCount = 17, x = 35.6, y = 10.8,
    },
    {
      type = "complete", questName = "Bloody Bone Necklaces", zone = "Stranglethorn Vale",
      location = "Tkashi Ruins", atLevel = 35, logCount = 17, x = 34.0, y = 16.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Tkashi Ruins", atLevel = 35, logCount = 17, x = 34.0, y = 16.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Tiger Mastery (part 3)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Tkashi Ruins", atLevel = 35,
      logCount = 17, x = 34.5, y = 19.5, approx = true,
    },
    {
      type = "complete", name = "Raptor Mastery (part 2)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Grom'Gol Base Camp",
      atLevel = 35, logCount = 17, x = 33.0, y = 24.0, approx = true,
    },
    {
      type = "complete", name = "The Defense of Grom'gol (part 1)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", atLevel = 35, logCount = 17, x = 33.0, y = 24.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Hunt for Yenniku", zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", atLevel = 35, logCount = 16, x = 32.2, y = 27.8,
    },
    {
      type = "accept", questName = "Headhunting", zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", atLevel = 35, logCount = 17, x = 32.2, y = 27.8,
    },
    {
      type = "turnin", name = "The Defense of Grom'gol (part 1)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", atLevel = 35, logCount = 16, x = 32.2, y = 28.8,
    },
    {
      type = "accept", name = "The Defense of Grom'gol (part 2)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'Gol Base Camp", atLevel = 35, logCount = 17, x = 32.2, y = 28.8,
    },
    {
      type = "complete", questName = "Singing Blue Shards", zone = "Stranglethorn Vale",
      location = "Bal'lal Ruins", atLevel = 35, logCount = 17, x = 25.0, y = 17.0,
      approx = true,
    },
    {
      type = "complete", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Kunda", atLevel = 35, logCount = 17, x = 23.0, y = 9.0,
      approx = true,
    },
    {
      type = "complete", questName = "Bloody Bone Necklaces", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Kunda", atLevel = 35, logCount = 17, x = 23.0, y = 9.0,
      approx = true,
    },
    {
      type = "complete", questName = "Headhunting", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Kunda", atLevel = 35, logCount = 17, x = 23.0, y = 9.0,
      approx = true,
    },
    {
      type = "hearth", name = "Hearth to Booty Bay", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Kunda", atLevel = 35, logCount = 17, x = 23.0, y = 9.0,
      approx = true, note = "Use your hearthstone.",
    },

    { type = "section", name = "Chapter 32: Lake Nazferiti", levels = { 35, 36 }, zone = "Stranglethorn Vale" },
    {
      type = "turnin", questName = "Singing Blue Shards", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 35, logCount = 16, x = 27.0, y = 77.2,
    },
    {
      type = "note", optional = true, name = "Skip for now: V",
      note = "Do not pick up yet - the route comes back for Venture Company Mining on a later pass.",
      zone = "Stranglethorn Vale", location = "Booty Bay", atLevel = 35, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", questName = "Investigate the Camp", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 35, logCount = 15, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", questName = "Bloodscalp Ears", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 35, logCount = 14, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", questName = "Supply and Demand", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 35, logCount = 13, x = 28.2, y = 77.4,
    },
    {
      type = "accept", questName = "Some Assembly Required", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 35, logCount = 14, x = 28.2, y = 77.4,
    },
    {
      type = "travel", name = "Booty Bay to Grom'gol Base Camp", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 35, logCount = 14, x = 26.9, y = 77.1,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Bloody Bone Necklaces", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 35, logCount = 13, x = 32.3, y = 27.7,
    },
    {
      type = "accept", questName = "Trollbane", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 35, logCount = 14, x = 32.3, y = 27.7,
    },
    {
      type = "turnin", questName = "Headhunting", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 35, logCount = 13, x = 32.2, y = 27.7,
    },
    {
      type = "note", optional = true, name = "Skip for now: B",
      note = "Do not pick up yet - the route comes back for Bloodscalp Clan Heads on a later pass.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp", atLevel = 35, x = 32.2,
      y = 27.7,
    },
    {
      type = "complete", name = "The Defense of Grom'gol (part 2)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Mizjah Ruins", atLevel = 35, logCount = 13, x = 37.0, y = 31.0,
      approx = true,
    },
    {
      type = "complete", name = "Panther Mastery (part 3)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Venture Co Base Camp",
      atLevel = 36, logCount = 13, x = 48.0, y = 22.0, approx = true,
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 1)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Venture Co Base Camp", atLevel = 36, logCount = 13, x = 48.0, y = 22.0,
      approx = true,
    },
    {
      type = "complete", name = "Goblin Sponsorship (part 4)",
      questName = "Goblin Sponsorship", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Venture Co Base Camp", atLevel = 36, logCount = 13, x = 42.6, y = 18.3,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Hostile Takeover", zone = "Stranglethorn Vale",
      location = "Lake Nazferiti", atLevel = 36, logCount = 13, x = 43.0, y = 19.0,
      approx = true,
    },
    {
      type = "complete", name = "Goblin Sponsorship (part 4)",
      questName = "Goblin Sponsorship", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Lake Nazferiti", atLevel = 36, logCount = 13, x = 43.3, y = 20.3,
    },
    {
      type = "complete", questName = "Some Assembly Required", zone = "Stranglethorn Vale",
      location = "Lake Nazferiti", atLevel = 36, logCount = 13, x = 41.0, y = 22.0,
      approx = true,
    },
    {
      type = "turnin", name = "Raptor Mastery (part 2)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 36, logCount = 12, x = 35.6, y = 10.8,
    },
    {
      type = "accept", name = "Raptor Mastery (part 3)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 36, logCount = 13, x = 35.6, y = 10.8,
    },
    {
      type = "turnin", name = "Tiger Mastery (part 3)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 36, logCount = 12, x = 35.6, y = 10.6,
    },
    {
      type = "accept", name = "Tiger Mastery (part 4)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 36, logCount = 13, x = 35.6, y = 10.6,
    },
    {
      type = "turnin", name = "Panther Mastery (part 3)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 36, logCount = 12, x = 35.6, y = 10.8,
    },
    {
      type = "accept", name = "Panther Mastery (part 4)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 36, logCount = 13, x = 35.6, y = 10.8,
    },
})

-- Chapter 40: Stranglethorn Vale Mid | Chapter 41: Stranglethorn Vale South
Leg(24, "Stranglethorn Vale", {

    {
      type = "section", name = "Chapter 40: Stranglethorn Vale Mid", levels = { 41, 42 },
      zone = "Stranglethorn Vale",
    },
    {
      type = "turnin", questName = "Back to Booty Bay", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 41, logCount = 14, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 1)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Southern Savage Coast", atLevel = 41, logCount = 13, x = 27.3, y = 69.5,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 2)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Southern Savage Coast", atLevel = 41, logCount = 14, x = 27.3, y = 69.5,
    },
    {
      type = "complete", name = "Raptor Mastery (part 3)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Southern Savage Coast",
      atLevel = 41, logCount = 14, x = 30.0, y = 44.0, approx = true,
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 2)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Southern Savage Coast", atLevel = 41, logCount = 14, x = 30.0, y = 44.0,
      approx = true,
    },
    {
      type = "turnin", name = "Mok'thardin's Enchantment (part 2)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 13, x = 32.0, y = 29.2,
    },
    {
      type = "accept", name = "Mok'thardin's Enchantment (part 3)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 14, x = 32.0, y = 29.2,
    },
    {
      type = "accept", questName = "Bloodscalp Clan Heads", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 15, x = 32.2, y = 27.7,
    },
    {
      type = "accept", questName = "The Vile Reef", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 16, x = 32.3, y = 27.7,
    },
    {
      type = "accept", questName = "Marg Speaks", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 17, x = 32.3, y = 27.7,
    },
    {
      type = "accept", questName = "Grim Message", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 18, x = 32.3, y = 27.7,
    },
    {
      type = "complete", name = "Tiger Mastery (part 4)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Tkashi Ruins", atLevel = 41,
      logCount = 18, x = 32.2, y = 17.4,
    },
    {
      type = "turnin", name = "Tiger Mastery (part 4)", questName = "Tiger Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 41, logCount = 17, x = 35.6, y = 10.6,
    },
    {
      type = "turnin", name = "Raptor Mastery (part 3)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 41, logCount = 16, x = 35.6, y = 10.8,
    },
    {
      type = "accept", name = "Raptor Mastery (part 4)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 41, logCount = 17, x = 35.6, y = 10.8,
    },
    {
      type = "complete", questName = "Bloodscalp Clan Heads", zone = "Stranglethorn Vale",
      location = "Northwest Stranglethorn", atLevel = 41, logCount = 17, x = 23.5, y = 9.0,
      approx = true,
    },
    {
      type = "complete", questName = "The Vile Reef", zone = "Stranglethorn Vale",
      location = "The Vile Reef", atLevel = 41, logCount = 17, x = 24.8, y = 23.0,
    },
    {
      type = "complete", questName = "Excelsior", zone = "Stranglethorn Vale",
      location = "The Savage Coast", atLevel = 41, logCount = 17, x = 29.0, y = 23.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Bloodscalp Clan Heads", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 16, x = 32.2, y = 27.6,
    },
    {
      type = "turnin", questName = "The Vile Reef", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 15, x = 32.3, y = 27.7,
    },
    {
      type = "accept", questName = "Split Bone Necklace", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 16, x = 32.3, y = 27.7,
    },
    {
      type = "accept", questName = "Speaking with Nezzliok", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 17, x = 32.2, y = 27.6,
    },
    {
      type = "accept", questName = "Speaking with Gan'zulah", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 41, logCount = 18, x = 32.2, y = 27.6,
    },
    {
      type = "complete", name = "Panther Mastery (part 4)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "East Stranglethorn",
      atLevel = 41, logCount = 18, x = 49.6, y = 24.0,
    },
    {
      type = "complete", questName = "Speaking with Nezzliok", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Mamwe", atLevel = 41, logCount = 18,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Speaking with Gan'zulah", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Mamwe", atLevel = 41, logCount = 18, x = 45.0, y = 42.0,
      approx = true,
    },
    {
      type = "complete", questName = "Skullsplitter Tusks", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Mamwe", atLevel = 41, logCount = 18, x = 45.0, y = 42.0,
      approx = true,
    },
    {
      type = "complete", questName = "Split Bone Necklace", zone = "Stranglethorn Vale",
      location = "Ruins of Zul'Mamwe", atLevel = 41, logCount = 18, x = 45.0, y = 42.0,
      approx = true,
    },
    {
      type = "complete", questName = "Venture Company Mining", zone = "Stranglethorn Vale",
      location = "Venture Co Mine", atLevel = 41, logCount = 18, x = 41.0, y = 44.0,
      approx = true,
    },
    {
      type = "complete", name = "Raptor Mastery (part 4)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Southern Savage Coast",
      atLevel = 41, logCount = 18, x = 28.7, y = 44.8,
    },
    {
      type = "turnin", questName = "Split Bone Necklace", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 17, x = 32.3, y = 27.7,
    },
    {
      type = "turnin", questName = "Speaking with Nezzliok", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 16, x = 32.2, y = 27.6,
    },
    {
      type = "turnin", questName = "Speaking with Gan'zulah", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 15, x = 32.2, y = 27.6,
    },
    {
      type = "accept", questName = "The Fate of Yenniku", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 16, x = 32.2, y = 27.6,
    },
    {
      type = "turnin", questName = "The Fate of Yenniku", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 15, x = 32.3, y = 27.7,
    },
    {
      type = "accept", questName = "The Singing Crystals", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 16, x = 32.3, y = 27.7,
    },
    {
      type = "turnin", name = "Raptor Mastery (part 4)", questName = "Raptor Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 42, logCount = 15, x = 35.6, y = 10.8,
    },
    {
      type = "turnin", name = "Panther Mastery (part 4)", questName = "Panther Mastery",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Nesingwary's Expedition",
      atLevel = 42, logCount = 14, x = 35.6, y = 10.8,
    },
    {
      type = "accept", questName = "Big Game Hunter", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 15, x = 35.7, y = 10.8,
    },
    {
      type = "hearth", name = "Hearth to Booty Bay", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 15, x = 35.7, y = 10.8,
      note = "Use your hearthstone.",
    },

    {
      type = "section", name = "Chapter 41: Stranglethorn Vale South", levels = { 42, 42 },
      zone = "Stranglethorn Vale",
    },
    {
      type = "turnin", questName = "Venture Company Mining", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 14, x = 27.0, y = 77.2,
    },
    {
      type = "turnin", questName = "Skullsplitter Tusks", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 13, x = 27.0, y = 77.1,
    },
    {
      type = "accept", questName = "Up to Snuff", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 14, x = 26.9, y = 77.4,
    },
    {
      type = "accept", questName = "Tran'rek", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 15, x = 27.1, y = 77.2,
    },
    {
      type = "accept", questName = "Akiris by the Bundle", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 16, x = 27.4, y = 76.8,
    },
    {
      type = "accept", questName = "Stoley's Debt", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 17, x = 27.8, y = 77.1,
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 2)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 16, x = 28.0, y = 76.2,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 3)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 17, x = 28.0, y = 76.2,
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 3)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 16, x = 27.2, y = 76.8,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 4)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 17, x = 27.2, y = 76.8,
    },
    {
      type = "turnin", questName = "Excelsior", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 16, x = 28.2, y = 77.4,
    },
    {
      type = "accept", questName = "Keep An Eye Out", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 17, x = 28.6, y = 75.8,
    },
    {
      type = "complete", name = "The Bloodsail Buccaneers (part 4)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Wild Shore", atLevel = 42, logCount = 17, x = 30.0, y = 81.0, approx = true,
    },
    {
      type = "complete", questName = "Up to Snuff", zone = "Stranglethorn Vale",
      location = "Wild Shore", atLevel = 42, logCount = 17, x = 27.0, y = 83.0, approx = true,
    },
    {
      type = "complete", questName = "Keep An Eye Out", zone = "Stranglethorn Vale",
      location = "Wild Shore", atLevel = 42, logCount = 17, x = 27.0, y = 83.0, approx = true,
    },
    {
      type = "manual", name = "Elder Mistvale Gorilla: Gorilla Fang  x10",
      zone = "Stranglethorn Vale", location = "Mistvale Valley", atLevel = 42, logCount = 17,
      x = 32.0, y = 67.0, approx = true, note = "Collect these here.",
    },
    {
      type = "complete", questName = "Scaring Shaky", zone = "Stranglethorn Vale",
      location = "Mistvale Valley", atLevel = 42, logCount = 17, x = 32.0, y = 67.0,
      approx = true,
    },
    {
      type = "complete", name = "Mok'thardin's Enchantment (part 3)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Mistvale Valley", atLevel = 42, logCount = 17, x = 32.0, y = 67.0,
      approx = true,
    },
    {
      type = "complete", questName = "Stranglethorn Fever", zone = "Stranglethorn Vale",
      location = "Mistvale Valley", atLevel = 42, logCount = 17, x = 35.3, y = 60.4,
    },
    {
      type = "turnin", questName = "Scaring Shaky", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 16, x = 27.0, y = 73.6,
    },
    {
      type = "accept", questName = "Return to MacKinley", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 17, x = 27.0, y = 73.6,
    },
    {
      type = "turnin", questName = "Return to MacKinley", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 16, x = 27.8, y = 77.0,
    },
    {
      type = "accept", questName = "Voodoo Dues", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 17, x = 27.8, y = 77.0,
    },
    {
      type = "turnin", questName = "Up to Snuff", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 16, x = 26.9, y = 77.4,
    },
    {
      type = "turnin", name = "The Bloodsail Buccaneers (part 4)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 15, x = 27.2, y = 76.8,
    },
    {
      type = "accept", name = "The Bloodsail Buccaneers (part 5)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 16, x = 27.2, y = 76.8,
    },
    {
      type = "turnin", questName = "Keep An Eye Out", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 42, logCount = 15, x = 28.6, y = 75.8,
    },
    {
      type = "accept", name = "Cortello's Riddle (part 1)", questName = "Cortello's Riddle",
      ambiguous = true, zone = "Stranglethorn Vale", location = "Wild Shore", atLevel = 42,
      logCount = 16, note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", name = "The Bloodsail Buccaneers (part 5)",
      questName = "The Bloodsail Buccaneers", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Wild Shore", atLevel = 42, logCount = 16,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "The Captain's Chest", zone = "Stranglethorn Vale",
      location = "Wild Shore", atLevel = 42, logCount = 16, x = 37.0, y = 70.0, approx = true,
    },
    {
      type = "complete", questName = "Voodoo Dues", zone = "Stranglethorn Vale",
      location = "Ruins of Aboraz", atLevel = 42, logCount = 16,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Zanzil's Secret", zone = "Stranglethorn Vale",
      location = "Ruins of Juhuwal", atLevel = 42, logCount = 16, x = 35.0, y = 52.0,
      approx = true,
    },
    {
      type = "complete", questName = "The Singing Crystals", zone = "Stranglethorn Vale",
      location = "Crystalvein Mine", atLevel = 42, logCount = 16, x = 43.0, y = 49.0,
      approx = true,
    },
    {
      type = "complete", questName = "Big Game Hunter", zone = "Stranglethorn Vale",
      location = "Cape of Stranglethorn", atLevel = 42, logCount = 16, x = 38.2, y = 35.5,
    },
    {
      type = "turnin", name = "Mok'thardin's Enchantment (part 3)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 15, x = 32.0, y = 29.2,
    },
    {
      type = "accept", name = "Mok'thardin's Enchantment (part 4)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 16, x = 32.0, y = 29.2,
    },
    {
      type = "turnin", questName = "The Singing Crystals", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 15, x = 32.3, y = 27.7,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Mind's Eye. Low XP for the travel time.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp", atLevel = 42, x = 32.3,
      y = 27.7,
    },
    {
      type = "manual", name = "The Green Hills of Stranglethorn Pages",
      zone = "Stranglethorn Vale", atLevel = 42, logCount = 15,
      note = "You should have the full stack by now. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "turnin", questName = "Big Game Hunter", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 14, x = 35.7, y = 10.8,
    },
    {
      type = "accept", questName = "The Green Hills of Stranglethorn",
      zone = "Stranglethorn Vale", location = "Nesingwary's Expedition", atLevel = 42,
      logCount = 15, x = 35.7, y = 10.5,
    },
    {
      type = "accept", questName = "Chapter I", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 16, x = 35.7, y = 10.5,
    },
    {
      type = "accept", questName = "Chapter II", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 17, x = 35.7, y = 10.5,
    },
    {
      type = "accept", questName = "Chapter III", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 18, x = 35.7, y = 10.5,
    },
    {
      type = "accept", questName = "Chapter IV", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 19, x = 35.7, y = 10.5,
    },
    {
      type = "turnin", questName = "Chapter I", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 18, x = 35.7, y = 10.5,
    },
    {
      type = "turnin", questName = "Chapter II", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 17, x = 35.7, y = 10.5,
    },
    {
      type = "turnin", questName = "Chapter III", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 16, x = 35.7, y = 10.5,
    },
    {
      type = "turnin", questName = "Chapter IV", zone = "Stranglethorn Vale",
      location = "Nesingwary's Expedition", atLevel = 42, logCount = 15, x = 35.7, y = 10.5,
    },
    {
      type = "note", name = "Note",
      note = "Abandon The Green Hills of Stranglethorn if you could not collect all 15 Green Hills of Stranglethorn pages.",
      atLevel = 42,
    },
    {
      type = "turnin", questName = "The Green Hills of Stranglethorn",
      zone = "Stranglethorn Vale", location = "Nesingwary's Expedition", atLevel = 42,
      logCount = 14, x = 35.7, y = 10.5,
    },
    {
      type = "travel", name = "Grom'Gol Base Camp to Stonard", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 42, logCount = 14, x = 32.5, y = 29.4,
      note = "Take the flight path.",
    },
})

