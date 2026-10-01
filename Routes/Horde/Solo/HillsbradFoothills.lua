-- TuFFlevels / Routes/Horde/Solo/HillsbradFoothills.lua
--
-- Hillsbrad Foothills leg(s) of the solo Orc/Troll 1-60 route. Levels 28-38.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 23: Hillsbrad Fields
Leg(12, "Hillsbrad Foothills", {

    {
      type = "section", name = "Chapter 23: Hillsbrad Fields", levels = { 28, 30 },
      zone = "Hillsbrad Foothills",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 28, logCount = 7, x = 50.8, y = 13.9,
      note = "Zeppelin.",
    },
    {
      type = "travel", name = "Undercity to Tarren Mill", zone = "Undercity",
      location = "Trade Quarter", atLevel = 28, logCount = 7, x = 63.2, y = 48.6,
      note = "Take the flight path.",
    },
    {
      type = "accept", name = "Elixir of Agony (part 1)", questName = "Elixir of Agony",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 28,
      logCount = 8, x = 61.4, y = 19.2,
    },
    {
      type = "accept", name = "Elixir of Pain (part 1)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 28,
      logCount = 9, x = 61.4, y = 19.2,
    },
    {
      type = "accept", name = "Battle for Hillsbrad (part 1)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 10, x = 62.2, y = 20.2,
    },
    {
      type = "complete", name = "Elixir of Pain (part 1)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Hillsbrad Fields",
      atLevel = 28, logCount = 10, x = 45.0, y = 38.0, approx = true,
    },
    {
      type = "complete", name = "Elixir of Suffering (part 1)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 10, x = 45.0, y = 38.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Battle for Hillsbrad (part 1)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 10, x = 34.0, y = 39.0,
      approx = true,
    },
    {
      type = "turnin", name = "Elixir of Pain (part 1)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 28,
      logCount = 9, x = 61.4, y = 19.2,
    },
    {
      type = "accept", name = "Elixir of Pain (part 2)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 28,
      logCount = 10, x = 61.4, y = 19.2,
    },
    {
      type = "turnin", name = "Battle for Hillsbrad (part 1)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 9, x = 62.2, y = 20.2,
    },
    {
      type = "accept", name = "Battle for Hillsbrad (part 2)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 10, x = 62.2, y = 20.2,
    },
    {
      type = "accept", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 11, x = 62.0, y = 19.8,
    },
    {
      type = "accept", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 12, x = 62.2, y = 20.2,
    },
    {
      type = "complete", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 12, x = 45.0, y = 38.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Elixir of Suffering (part 1)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 12, x = 45.0, y = 38.0,
      approx = true,
    },
    {
      type = "turnin", name = "Elixir of Pain (part 2)", questName = "Elixir of Pain",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Hillsbrad Fields",
      atLevel = 28, logCount = 11, x = 32.6, y = 35.4,
    },
    {
      type = "complete", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 11, x = 35.0, y = 45.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Battle for Hillsbrad (part 2)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 11, x = 35.0, y = 45.0,
      approx = true,
    },
    {
      type = "turnin", name = "Elixir of Suffering (part 1)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 10, x = 61.4, y = 19.2,
    },
    {
      type = "accept", name = "Elixir of Suffering (part 2)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 11, x = 61.4, y = 19.2,
    },
    {
      type = "turnin", name = "Elixir of Suffering (part 2)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 10, x = 61.4, y = 19.2,
    },
    {
      type = "turnin", name = "Battle for Hillsbrad (part 2)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 9, x = 62.2, y = 20.2,
    },
    {
      type = "accept", name = "Battle for Hillsbrad (part 3)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 10, x = 62.2, y = 20.2,
    },
    {
      type = "complete", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 10, x = 32.0, y = 45.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Battle for Hillsbrad (part 3)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 10, x = 32.0, y = 45.0,
      approx = true,
    },
    {
      type = "turnin", name = "Battle for Hillsbrad (part 3)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 9, x = 62.2, y = 20.2,
    },
    {
      type = "accept", name = "Battle for Hillsbrad (part 4)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 10, x = 62.2, y = 20.2,
    },
    {
      type = "complete", name = "Battle for Hillsbrad (part 4)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 10, x = 30.0, y = 42.0,
      approx = true,
    },
    {
      type = "complete", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Hillsbrad Fields", atLevel = 28, logCount = 10, x = 29.7, y = 41.6,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "Battle for Hillsbrad (part 4)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 9, x = 62.2, y = 20.2,
    },
    {
      type = "accept", name = "Battle for Hillsbrad (part 5)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 28, logCount = 10, x = 62.2, y = 20.2,
    },
    {
      type = "complete", name = "Elixir of Agony (part 1)", questName = "Elixir of Agony",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Nethander Stead",
      atLevel = 28, logCount = 10, x = 63.0, y = 62.0, approx = true,
    },
    {
      type = "complete", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Azurelode Mine", atLevel = 29, logCount = 10, x = 27.0, y = 59.0,
      approx = true,
    },
    {
      type = "complete", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Azurelode Mine", atLevel = 29, logCount = 10, x = 27.0, y = 59.0,
      approx = true,
    },
    {
      type = "complete", name = "Battle for Hillsbrad (part 5)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Azurelode Mine", atLevel = 29, logCount = 10, x = 27.0, y = 59.0,
      approx = true,
    },
    {
      type = "manual", name = "Kill until 34850/44300 xp into Lvl 29",
      zone = "Hillsbrad Foothills", location = "Hillsbrad Fields", atLevel = 29, logCount = 10,
      x = 27.0, y = 59.0, approx = true,
    },
    {
      type = "turnin", questName = "Dangerous!", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 29, logCount = 9, x = 62.2, y = 20.2,
    },
    {
      type = "turnin", questName = "Souvenirs of Death", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 29, logCount = 8, x = 62.0, y = 19.8,
    },
    {
      type = "turnin", name = "Battle for Hillsbrad (part 5)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 29, logCount = 7, x = 62.2, y = 20.2,
    },
    {
      type = "accept", name = "Battle for Hillsbrad (part 6)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 29, logCount = 8, x = 62.2, y = 20.2,
    },
    {
      type = "accept", questName = "Humbert's Sword", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 29, logCount = 9, x = 62.6, y = 20.2,
    },
    {
      type = "turnin", name = "Elixir of Agony (part 1)", questName = "Elixir of Agony",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 30,
      logCount = 8, x = 61.4, y = 19.2,
    },
    {
      type = "accept", name = "Elixir of Agony (part 2)", questName = "Elixir of Agony",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 30,
      logCount = 9, x = 61.4, y = 19.2,
    },
    {
      type = "note", name = "Note",
      note = "Skip Elixir of Agony #2 if you cannot train in Undercity. (Druid/Shaman)",
      atLevel = 30,
    },
    {
      type = "note", optional = true, name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Soothing Turtle Bisque, Infiltration on a later pass.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 30, x = 62.2, y = 19.0,
    },
    {
      type = "accept", questName = "Regthar Deathgate", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 30, logCount = 10, x = 63.2, y = 20.6,
    },
    {
      type = "note", optional = true, name = "Skip for now: 4 quests here",
      note = "Do not pick up yet - the route comes back for The Hammer May Fall, Prison Break In, Stone Tokens, Helcular's Revenge on a later pass.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 30, x = 61.8, y = 19.6,
    },
    {
      type = "complete", name = "Battle for Hillsbrad (part 6)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Dun Garok", atLevel = 30, logCount = 10, x = 71.0, y = 78.0, approx = true,
    },
    {
      type = "complete", questName = "Humbert's Sword", zone = "Hillsbrad Foothills",
      location = "Dun Garok", atLevel = 30, logCount = 10, x = 71.0, y = 78.0, approx = true,
    },
    {
      type = "turnin", name = "Battle for Hillsbrad (part 6)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 30, logCount = 9, x = 62.2, y = 20.2,
    },
    {
      type = "turnin", questName = "Humbert's Sword", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 30, logCount = 8, x = 62.6, y = 20.2,
    },
    {
      type = "accept", name = "Battle for Hillsbrad (part 7)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 30, logCount = 9, x = 62.2, y = 20.2,
    },
    {
      type = "note", name = "Note",
      note = "Hearth here if you cannot train in Undercity. (Druid/Shaman)", atLevel = 30,
    },
    {
      type = "turnin", name = "Elixir of Agony (part 2)", questName = "Elixir of Agony",
      ambiguous = true, zone = "Undercity", location = "The Apothecarium", atLevel = 30,
      logCount = 8, x = 48.6, y = 69.4,
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips Elixir of Agony #3, Going, Going, Guano!. Low XP for the travel time.",
      zone = "Undercity", location = "The Apothecarium", atLevel = 30, x = 48.6, y = 69.4,
    },
    {
      type = "turnin", name = "Battle for Hillsbrad (part 7)",
      questName = "Battle for Hillsbrad", ambiguous = true, zone = "Undercity",
      location = "The Royal Quarter", atLevel = 30, logCount = 7, x = 56.2, y = 91.8,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Undercity", atLevel = 30, logCount = 7,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "hearth", name = "Hearth to Camp Taurajo", zone = "Undercity", atLevel = 30,
      logCount = 7,
      note = "Use your hearthstone. Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "Fly to Thunder Bluff to train Lvl 30 skills if you could not train in Undercity. Set hearth there. (Druid/Shaman)",
      atLevel = 30,
    },
})

-- Chapter 35: Alterac Mountains
Leg(20, "Hillsbrad Foothills", {

    {
      type = "section", name = "Chapter 35: Alterac Mountains", levels = { 37, 38 },
      zone = "Hillsbrad Foothills",
    },
    {
      type = "travel", name = "Booty Bay to Grom'gol Base Camp", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 37, logCount = 15, x = 26.9, y = 77.1,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "The Troll Witchdoctor", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 37, logCount = 14, x = 32.2, y = 27.8,
    },
    {
      type = "note", optional = true, name = "Skip for now: Marg Speaks",
      note = "Do not pick up yet - the route comes back for Marg Speaks on a later pass.",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp", atLevel = 37, x = 32.2,
      y = 27.7,
    },
    {
      type = "turnin", name = "The Defense of Grom'gol (part 2)",
      questName = "The Defense of Grom'gol", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 37, logCount = 13, x = 32.2, y = 28.8,
    },
    {
      type = "turnin", name = "Mok'thardin's Enchantment (part 1)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 37, logCount = 12, x = 32.0, y = 29.2,
    },
    {
      type = "accept", name = "Mok'thardin's Enchantment (part 2)",
      questName = "Mok'thardin's Enchantment", ambiguous = true, zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 37, logCount = 13, x = 32.0, y = 29.2,
    },
    {
      type = "travel", name = "Grom'gol Base Camp to Tirisfal Glades",
      zone = "Stranglethorn Vale", location = "Grom'gol Base Camp", atLevel = 37,
      logCount = 13, x = 31.5, y = 29.1, note = "Zeppelin.",
    },
    {
      type = "accept", questName = "To Steal From Thieves", zone = "Undercity",
      location = "Trade Quarter", atLevel = 37, logCount = 14, x = 64.0, y = 49.4,
    },
    {
      type = "note", optional = true, name = "Skip: Reclaimed Treasures",
      note = "The route deliberately skips Reclaimed Treasures. Low XP for the travel time.",
      zone = "Undercity", location = "Trade Quarter", atLevel = 37, x = 62.3, y = 48.6,
    },
    {
      type = "note", optional = true, name = "Skip: Bring the End",
      note = "The route deliberately skips Bring the End. Low XP for the travel time.",
      zone = "Undercity", location = "Magic Quarter", atLevel = 37, x = 74.0, y = 33.3,
    },
    {
      -- Optional group content (plans/quests/notable_horde_quests.md, "Dungeon quest
      -- bundles"): Bring the End (just skipped above) is part of the Razorfen Downs
      -- bundle. If a group is available, the full run (Bring the End, Extinguishing
      -- the Idol, An Unholy Alliance - level 37-42, no XP sum sourced yet) is worth
      -- doing instead of skipping. Added 2026-09-26 per plans/13; NOT YET IN-GAME
      -- VERIFIED.
      type = "note", optional = true, name = "If grouped: Razorfen Downs bundle",
      zone = "Undercity", location = "Magic Quarter", atLevel = 37,
      note = "3 quests (Bring the End, Extinguishing the Idol, An Unholy Alliance), level 37-42, no XP sum sourced yet, if you have a group.",
    },
    {
      type = "note", optional = true, name = "Skip: 2 quests here",
      note = "The route deliberately skips The Crown of Will #1, Into The Scarlet Monastery. Low XP for the travel time.",
      zone = "Undercity", location = "Royal Quarter", atLevel = 37, x = 57.7, y = 93.8,
    },
    {
      -- Optional group content (plans/quests/notable_horde_quests.md, "Dungeon quest
      -- bundles" and "Scarlet Monastery (Horde)"): Into The Scarlet Monastery (just
      -- skipped above) starts at Varimathras here in Undercity and needs Loksey
      -- (Library), Herod (Armory), and Mograine/Whitemane (Cathedral) - 5,150 XP on
      -- its own. Side quests Hearts of Zeal, Vorrel's Revenge, Compendium of the
      -- Fallen, Test of Lore add more. The Library run is also where the Mage's
      -- Wand chain's Rituals of Power is picked up (see the Mage-only note in
      -- TheBarrens.lua/ThousandNeedles.lua) - same group-content tie-in, not a
      -- separate step. Added 2026-09-26 per plans/13; NOT YET IN-GAME VERIFIED.
      type = "note", optional = true, name = "If grouped: Scarlet Monastery bundle",
      zone = "Undercity", location = "Royal Quarter", atLevel = 37,
      note = "Into The Scarlet Monastery (5,150 XP; needs Loksey/Library, Herod/Armory, Mograine+Whitemane/Cathedral) plus side quests Hearts of Zeal, Vorrel's Revenge, Compendium of the Fallen, Test of Lore, level 33-45, if you have a group. The Library run also covers the Mage chain's Rituals of Power.",
    },
    {
      type = "travel", name = "Undercity to Tarren Mill", zone = "Undercity",
      location = "Trade Quarter", atLevel = 37, logCount = 14, x = 63.2, y = 48.6,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Prison Break In", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 15, x = 61.6, y = 20.8,
    },
    {
      type = "accept", questName = "Stone Tokens", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 16, x = 61.6, y = 20.8,
    },
    {
      type = "accept", questName = "The Hammer May Fall", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 17, x = 61.8, y = 19.6,
    },
    {
      type = "manual", name = "Christoph Jeffcoat: Soothing Spices x1",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 37, logCount = 17,
      x = 62.3, y = 19.0, note = "Vendor stop.",
    },
    {
      type = "accept", questName = "Soothing Turtle Bisque", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 18, x = 62.3, y = 19.0,
    },
    {
      type = "turnin", questName = "Soothing Turtle Bisque", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 17, x = 62.3, y = 19.0,
    },
    {
      type = "note", optional = true, name = "Skip for now: WANTED: Baron Vardus",
      note = "Do not pick up yet - the route comes back for WANTED: Baron Vardus on a later pass.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 37, x = 62.6, y = 20.7,
    },
    {
      type = "accept", name = "The Crown of Will (part 1)", ambiguous = true,
      questName = "The Crown of Will",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 37, x = 62.6, y = 20.7,
    },
    {
      type = "turnin", name = "The Crown of Will (part 1)", questName = "The Crown of Will",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 37,
      logCount = 17, x = 62.6, y = 20.7,
    },
    {
      type = "note", optional = true, name = "Skip: The Crown of Will #2",
      note = "The route deliberately skips The Crown of Will #2. Low XP for the travel time.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 37, x = 62.6, y = 20.7,
    },
    {
      type = "accept", questName = "Infiltration", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 18, x = 63.2, y = 20.6,
    },
    {
      type = "accept", name = "Helcular's Revenge (part 1)", questName = "Helcular's Revenge",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 37,
      logCount = 19, x = 63.8, y = 19.6,
    },
    {
      type = "complete", name = "Helcular's Revenge (part 1)",
      questName = "Helcular's Revenge", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Darrow Hill", atLevel = 37, logCount = 19, x = 45.0, y = 31.0, approx = true,
    },
    {
      type = "complete", questName = "Prison Break In", zone = "Alterac Mountains",
      location = "Internment Camp", atLevel = 37, logCount = 19, x = 20.0, y = 85.0,
      approx = true,
    },
    {
      type = "complete", questName = "Stone Tokens", zone = "Alterac Mountains",
      location = "Internment Camp", atLevel = 37, logCount = 19, x = 20.0, y = 85.0,
      approx = true,
    },
    {
      type = "complete", questName = "Infiltration", zone = "Hillsbrad Foothills",
      location = "Corrahn's Dagger", atLevel = 37, logCount = 19, x = 47.0, y = 82.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Prison Break In", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 18, x = 61.6, y = 20.8,
    },
    {
      type = "accept", questName = "Dalaran Patrols", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 19, x = 61.6, y = 20.8,
    },
    {
      type = "turnin", questName = "Stone Tokens", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 18, x = 61.6, y = 20.8,
    },
    {
      type = "accept", questName = "Bracers of Binding", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 19, x = 61.6, y = 20.8,
    },
    {
      type = "turnin", questName = "Infiltration", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 18, x = 63.2, y = 20.6,
    },
    {
      type = "accept", questName = "Gol'dir", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 19, x = 63.2, y = 20.6,
    },
    {
      type = "accept", questName = "WANTED: Baron Vardus", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 37, logCount = 20, x = 62.6, y = 20.7,
    },
    {
      type = "turnin", name = "Helcular's Revenge (part 1)", questName = "Helcular's Revenge",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 37,
      logCount = 19, x = 63.8, y = 19.6,
    },
    {
      type = "accept", name = "Helcular's Revenge (part 2)", questName = "Helcular's Revenge",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 37,
      logCount = 20, x = 63.8, y = 19.6,
    },
    {
      type = "manual", name = "Mountain Lion: Fresh Carcass", zone = "Alterac Mountains",
      location = "Sofera's Naze", atLevel = 37, logCount = 20, x = 65.0, y = 50.0,
      approx = true, note = "Collect these here.",
    },
    {
      type = "complete", questName = "Gol'dir", zone = "Alterac Mountains",
      location = "Strahnbrad", atLevel = 37, logCount = 20,
      note = "Partial progress - work on this while you are here, then move on. Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Gol'dir", zone = "Alterac Mountains",
      location = "Strahnbrad", atLevel = 37, logCount = 20, x = 60.0, y = 43.7,
    },
    {
      type = "turnin", questName = "Gol'dir", zone = "Alterac Mountains",
      location = "Strahnbrad", atLevel = 37, logCount = 19, x = 60.0, y = 43.7,
    },
    {
      type = "accept", questName = "Blackmoore's Legacy", zone = "Alterac Mountains",
      location = "Strahnbrad", atLevel = 37, logCount = 20, x = 60.0, y = 43.7,
    },
    {
      type = "complete", name = "The Crown of Will (part 2)", questName = "The Crown of Will",
      ambiguous = true, zone = "Alterac Mountains", location = "Ruins of Alterac",
      atLevel = 37, logCount = 20, x = 44.0, y = 47.0, approx = true,
    },
    {
      type = "complete", name = "Helcular's Revenge (part 2)",
      questName = "Helcular's Revenge", ambiguous = true, zone = "Alterac Mountains",
      location = "Growless Cave", atLevel = 37, logCount = 20, x = 37.5, y = 66.3,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Frostmaw", zone = "Alterac Mountains",
      location = "Growless Cave", atLevel = 37, logCount = 20, x = 37.5, y = 66.3,
    },
    {
      -- Warrior class chain finale (plans/quests/notable_horde_quests.md, quest IDs
      -- 1791/1712/1713/1792, min 30/40): The Windwatcher continues from Klannoc
      -- Macleod (Fray Island, Barrens - see TheBarrens.lua Chapter 26) to Bath'rah the
      -- Windwatcher here in the Alterac Mountains. Cyclonian is a level 40 elite air
      -- elemental fight - sources disagree on whether the Whirlwind Weapon itself is
      -- worth it at this level (IV: yes at 30+; WT/WIC/WH: realistically 38-40 solo;
      -- ZK: skip it) - flagged optional for that reason, unlike the Berserker Stance
      -- half which was added unconditionally. Added 2026-09-26 per plans/13; NOT YET
      -- IN-GAME VERIFIED.
      type = "note", optional = true, name = "Detour: Whirlwind Weapon (Warrior)",
      zone = "Alterac Mountains", atLevel = 38, class = "WARRIOR",
      note = "If you did the Berserker Stance half in the Barrens: Bath'rah the Windwatcher is out here. Needs 8 Liferoot, 30 Bloodscalp Tusk (STV trolls), and 8 each Thundering/Burning/Cresting Charm (Arathi Highlands level 38-39 elites, or buy them) before the Cyclonian fight (level 40 elite). Sources disagree on whether it's worth the detour at this level.",
    },
    {
      type = "complete", questName = "Bracers of Binding", zone = "Alterac Mountains",
      location = "Dalaran", atLevel = 37, logCount = 20, x = 22.0, y = 64.0, approx = true,
    },
    {
      type = "complete", questName = "Dalaran Patrols", zone = "Alterac Mountains",
      location = "Dalaran", atLevel = 37, logCount = 20, x = 22.0, y = 64.0, approx = true,
    },
    {
      type = "complete", name = "Helcular's Revenge (part 2)",
      questName = "Helcular's Revenge", ambiguous = true, zone = "Alterac Mountains",
      location = "Darrow Hill", atLevel = 37, logCount = 20,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", name = "Helcular's Revenge (part 2)", questName = "Helcular's Revenge",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Southshore", atLevel = 38,
      logCount = 19, x = 52.7, y = 53.2,
    },
    {
      type = "turnin", questName = "Dalaran Patrols", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 38, logCount = 18, x = 61.6, y = 20.8,
    },
    {
      type = "turnin", questName = "Bracers of Binding", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 38, logCount = 17, x = 61.6, y = 20.8,
    },
    {
      type = "accept", name = "The Crown of Will (part 2)", ambiguous = true,
      questName = "The Crown of Will",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 38, x = 62.6, y = 20.7,
    },
    {
      type = "turnin", name = "The Crown of Will (part 2)", questName = "The Crown of Will",
      ambiguous = true, zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 38,
      logCount = 17, x = 62.6, y = 20.7,
    },
    {
      type = "note", optional = true, name = "Skip: The Crown of Will #3",
      note = "The route deliberately skips The Crown of Will #3. Low XP for the travel time.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 38, x = 62.6, y = 20.7,
    },
    {
      type = "turnin", questName = "Blackmoore's Legacy", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 38, logCount = 16, x = 63.2, y = 20.6,
    },
    {
      type = "accept", questName = "Lord Aliden Perenolde", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 38, logCount = 17, x = 63.2, y = 20.6,
    },
})

