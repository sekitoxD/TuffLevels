-- TuFFlevels / Routes/Horde/Solo/SilverpineForest.lua
--
-- Silverpine Forest leg(s) of the solo Orc/Troll 1-60 route. Levels 12-23.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 7: Silverpine Forest North Lap #1 | Chapter 8: Silverpine Forest North Lap #2 | Chapter 9: Silverpine Forest Mid Lap
Leg(3, "Silverpine Forest", {

    {
      type = "section", name = "Chapter 7: Silverpine Forest North Lap #1",
      levels = { 12, 13 }, zone = "Silverpine Forest",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 12, logCount = 11, x = 50.8, y = 13.9,
      note = "Zeppelin.",
    },
    {
      type = "death", name = "Nightmare Vale to Brill", zone = "Tirisfal Glades",
      location = "Nightmare Vale", atLevel = 12, logCount = 11, x = 46.0, y = 56.0,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "accept", questName = "Delivery to Silverpine Forest", zone = "Tirisfal Glades",
      location = "Brill", atLevel = 12, logCount = 12, x = 59.4, y = 52.4,
    },
    {
      type = "travel", name = "Michael Garrett <Bat Handler>", zone = "Undercity",
      location = "Trade Quarter", atLevel = 12, logCount = 12, x = 63.2, y = 48.6,
      note = "Talk to the flight master and learn this flight point.",
    },
    { type = "note", name = "Note", note = "If area is competitive, do Escorting Erland now.", atLevel = 12 },
    {
      type = "manual", name = "Worg: Discolored Worg Heart x6", zone = "Silverpine Forest",
      location = "Malden's Orchard", atLevel = 12, logCount = 12, x = 68.0, y = 7.0,
      note = "Start collecting this now - it drops over the whole leg, not in one spot.",
    },
    {
      type = "death", name = "Shining Strand to The Sepulcher", zone = "Silverpine Forest",
      location = "Shining Strand", atLevel = 12, logCount = 12, x = 68.0, y = 7.0,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "accept", questName = "Lost Deathstalkers", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 12, logCount = 13, x = 43.4, y = 40.9,
    },
    {
      type = "accept", questName = "The Dead Fields", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 12, logCount = 14, x = 43.4, y = 40.9,
    },
    {
      type = "turnin", questName = "Delivery to Silverpine Forest", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 12, logCount = 13, x = 42.8, y = 40.9,
    },
    {
      type = "accept", name = "A Recipe for Death (part 1)", questName = "A Recipe for Death",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 12,
      logCount = 14, x = 42.8, y = 40.9,
    },
    {
      type = "accept", questName = "Border Crossings", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 12, logCount = 15, x = 44.0, y = 40.9,
    },
    {
      type = "accept", questName = "Prove your Worth", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 12, logCount = 16, x = 44.2, y = 39.8,
    },
    {
      type = "complete", questName = "The Dead Fields", zone = "Silverpine Forest",
      location = "The Dead Field", atLevel = 12, logCount = 16, x = 45.4, y = 21.0,
    },
    {
      type = "complete", name = "A Recipe For Death (part 1)",
      questName = "A Recipe For Death", ambiguous = true, zone = "Silverpine Forest",
      location = "The Skittering Dark", atLevel = 13, logCount = 16, x = 37.0, y = 15.0,
      approx = true,
    },
    {
      type = "accept", questName = "Escorting Erland", zone = "Silverpine Forest",
      location = "Malden's Orchard", atLevel = 13, logCount = 17, x = 56.2, y = 9.2,
    },
    {
      type = "complete", questName = "Escorting Erland", zone = "Silverpine Forest",
      location = "Malden's Orchard", atLevel = 13, logCount = 17, x = 56.0, y = 12.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Escorting Erland", zone = "Silverpine Forest",
      location = "The Ivar Patch", atLevel = 13, logCount = 16, x = 53.5, y = 13.4,
    },
    {
      type = "accept", questName = "The Deathstalkers' Report", zone = "Silverpine Forest",
      location = "The Ivar Patch", atLevel = 13, logCount = 17, x = 53.5, y = 13.4,
    },
    {
      type = "turnin", questName = "Lost Deathstalkers", zone = "Silverpine Forest",
      location = "The Ivar Patch", atLevel = 13, logCount = 16, x = 53.5, y = 13.4,
    },
    {
      type = "accept", questName = "Wild Hearts", zone = "Silverpine Forest",
      location = "The Ivar Patch", atLevel = 13, logCount = 17, x = 53.5, y = 13.4,
    },
    {
      type = "complete", questName = "Prove your Worth", zone = "Silverpine Forest",
      location = "East of The Sepulcher", atLevel = 13, logCount = 17, x = 49.0, y = 35.0,
      approx = true,
    },

    {
      type = "section", name = "Chapter 8: Silverpine Forest North Lap #2",
      levels = { 13, 14 }, zone = "Silverpine Forest",
    },
    {
      type = "travel", name = "Karos Razok <Bat Handler>", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 17, x = 45.6, y = 42.6,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "turnin", questName = "The Deathstalkers' Report", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 16, x = 43.4, y = 40.9,
    },
    {
      type = "accept", questName = "Speak with Renferrel", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 17, x = 43.4, y = 40.9,
    },
    {
      type = "turnin", questName = "The Dead Fields", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 16, x = 43.4, y = 40.9,
    },
    {
      type = "accept", questName = "The Decrepit Ferry", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 17, x = 43.4, y = 40.9,
    },
    {
      type = "turnin", questName = "Wild Hearts", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 16, x = 42.8, y = 40.9,
    },
    {
      type = "accept", questName = "Return to Quinn", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 17, x = 42.8, y = 40.9,
    },
    {
      type = "turnin", questName = "Speak with Renferrel", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 16, x = 42.8, y = 40.9,
    },
    {
      type = "accept", questName = "Zinge's Delivery", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 17, x = 42.8, y = 40.9,
    },
    {
      type = "turnin", questName = "Prove your Worth", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 13, logCount = 16, x = 44.2, y = 39.8,
    },
    {
      type = "accept", name = "Arugal's Folly (part 1)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 13,
      logCount = 17, x = 44.2, y = 39.8,
    },
    {
      type = "turnin", questName = "Return to Quinn", zone = "Silverpine Forest",
      location = "The Ivar Patch", atLevel = 13, logCount = 16, x = 53.4, y = 12.6,
    },
    {
      type = "accept", questName = "Ivar the Foul", zone = "Silverpine Forest",
      location = "The Ivar Patch", atLevel = 13, logCount = 17, x = 53.5, y = 13.4,
    },
    {
      type = "complete", questName = "Ivar the Foul", zone = "Silverpine Forest",
      location = "The Ivar Patch", atLevel = 13, logCount = 17, x = 51.5, y = 13.9,
    },
    {
      type = "turnin", questName = "Ivar the Foul", zone = "Silverpine Forest",
      location = "The Ivar Patch", atLevel = 13, logCount = 16, x = 53.5, y = 13.4,
    },
    {
      type = "complete", name = "Arugal's Folly (part 1)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "Valgan's Field", atLevel = 13,
      logCount = 16, x = 52.8, y = 28.6,
    },
    {
      type = "turnin", questName = "The Decrepit Ferry", zone = "Silverpine Forest",
      location = "The Decrepit Ferry", atLevel = 13, logCount = 15, x = 58.4, y = 34.8,
    },
    {
      type = "accept", questName = "Rot Hide Clues", zone = "Silverpine Forest",
      location = "The Decrepit Ferry", atLevel = 13, logCount = 16, x = 58.4, y = 34.8,
    },
    {
      type = "turnin", questName = "Rot Hide Clues", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 15, x = 43.4, y = 40.9,
    },
    {
      type = "accept", questName = "The Engraved Ring", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 16, x = 43.4, y = 40.9,
    },
    {
      type = "note", name = "Skip for now: R",
      note = "Do not pick up yet - the route comes back for Rot Hide Ichor on a later pass.",
      zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14, x = 43.4, y = 40.9,
    },
    {
      type = "turnin", name = "Arugal's Folly (part 1)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14,
      logCount = 15, x = 44.2, y = 39.8,
    },
    {
      type = "accept", name = "Arugal's Folly (part 2)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14,
      logCount = 16, x = 44.2, y = 39.8,
    },
    {
      type = "complete", name = "Arugal's Folly (part 2)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "North Tide's Hollow",
      atLevel = 14, logCount = 16, x = 43.0, y = 31.0, approx = true,
    },
    {
      type = "turnin", name = "Arugal's Folly (part 2)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14,
      logCount = 15, x = 44.2, y = 39.8,
    },
    {
      type = "accept", name = "Arugal's Folly (part 3)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14,
      logCount = 16, x = 44.2, y = 39.8,
    },

    {
      type = "section", name = "Chapter 9: Silverpine Forest Mid Lap", levels = { 14, 15 },
      zone = "Silverpine Forest",
    },
    {
      type = "complete", name = "Arugal's Folly (part 3)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "Deep Elem Mine", atLevel = 14,
      logCount = 16, x = 58.6, y = 44.8,
    },
    {
      type = "turnin", questName = "Border Crossings", zone = "Silverpine Forest",
      location = "West of Ambermill", atLevel = 14, logCount = 15, x = 49.9, y = 60.3,
    },
    {
      type = "accept", questName = "Maps and Runes", zone = "Silverpine Forest",
      location = "West of Ambermill", atLevel = 14, logCount = 16, x = 49.9, y = 60.3,
    },
    {
      type = "turnin", questName = "Maps and Runes", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 15, x = 44.0, y = 41.0,
    },
    {
      type = "accept", questName = "Dalar's Analysis", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 16, x = 44.0, y = 41.0,
    },
    {
      type = "turnin", questName = "Dalar's Analysis", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 15, x = 44.2, y = 39.8,
    },
    {
      type = "turnin", name = "Arugal's Folly (part 3)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14,
      logCount = 14, x = 44.2, y = 39.8,
    },
    {
      type = "accept", name = "Arugal's Folly (part 4)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14,
      logCount = 15, x = 44.2, y = 39.8,
    },
    {
      type = "accept", questName = "Dalaran's Intentions", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 16, x = 44.2, y = 39.8,
    },
    {
      type = "turnin", questName = "Dalaran's Intentions", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 15, x = 44.0, y = 41.0,
    },
    {
      type = "accept", questName = "Ambermill Investigations", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 16, x = 44.0, y = 41.0,
    },
    {
      type = "complete", questName = "Ambermill Investigations", zone = "Silverpine Forest",
      location = "Ambermill", atLevel = 14, logCount = 16, x = 59.0, y = 64.0, approx = true,
    },
    {
      type = "complete", name = "Arugal's Folly (part 4)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "Pyrewood Village",
      atLevel = 14, logCount = 16, x = 48.0, y = 72.0, approx = true,
    },
    {
      type = "death", name = "Ambermill to The Sepulcher", zone = "Silverpine Forest",
      location = "Ambermill", atLevel = 14, logCount = 16, x = 59.0, y = 64.0, approx = true,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "turnin", questName = "Ambermill Investigations", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 15, x = 44.0, y = 41.0,
    },
    {
      type = "note", name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Weaver on a later pass.",
      zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14, x = 44.0, y = 41.0,
    },
    {
      type = "turnin", name = "Arugal's Folly (part 4)", questName = "Arugal's Folly",
      ambiguous = true, zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 14,
      logCount = 14, x = 44.2, y = 39.8,
    },
    {
      type = "travel", name = "The Sepulcher to Undercity", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 14, logCount = 14, x = 45.6, y = 42.6,
      note = "Take the flight path.",
    },
    {
      type = "turnin", name = "A Recipe For Death (part 1)", questName = "A Recipe For Death",
      ambiguous = true, zone = "Undercity", location = "The Apothecarium", atLevel = 15,
      logCount = 13, x = 48.6, y = 69.4,
    },
    {
      type = "note", name = "Skip: A",
      note = "The route deliberately skips A Recipe For Death #2. Low XP for the travel time.",
      zone = "Undercity", location = "The Apothecarium", atLevel = 15, x = 48.6, y = 69.4,
    },
    {
      type = "turnin", questName = "Zinge's Delivery", zone = "Undercity",
      location = "The Apothecarium", atLevel = 15, logCount = 12, x = 49.8, y = 68.4,
    },
    {
      type = "accept", questName = "Sample for Helbrim", zone = "Undercity",
      location = "The Apothecarium", atLevel = 15, logCount = 13, x = 49.8, y = 68.4,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Power to Destroy.... Low XP for the travel time.",
      zone = "Undercity", location = "The Royal Quarter", atLevel = 15, x = 56.2, y = 91.8,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Undercity", atLevel = 15,
      logCount = 13, note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "Class Trainer might be less travel time at Brill or Orgrimmar depending on class.",
      atLevel = 15,
    },
    {
      type = "turnin", questName = "The Engraved Ring", zone = "Tirisfal Glades",
      location = "Brill", atLevel = 15, logCount = 12, x = 61.2, y = 50.8,
    },
    {
      type = "accept", questName = "Raleigh and the Undercity", zone = "Tirisfal Glades",
      location = "Brill", atLevel = 15, logCount = 13, x = 61.2, y = 50.8,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "Tirisfal Glades",
      location = "Brill", atLevel = 15, logCount = 13, x = 61.2, y = 50.8,
      note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Ride to Orgrimmar", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 15, logCount = 12, x = 54.0, y = 68.6,
    },
    {
      type = "accept", questName = "Doras the Wind Rider Master", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 15, logCount = 13, x = 54.0, y = 68.6,
    },
    {
      type = "turnin", questName = "Doras the Wind Rider Master", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 15, logCount = 12, x = 45.2, y = 63.8,
    },
    {
      type = "accept", questName = "Return to the Crossroads", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 15, logCount = 13, x = 45.2, y = 63.8,
    },
    {
      type = "travel", name = "Orgrimmar to The Crossroads", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 15, logCount = 13, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },
})

-- Chapter 17: Silverpine #2 & Durnholde Keep
--
-- On WoW Forever only, this leg also runs Ruins of Lordaeron, one of
-- Forever's new dungeons (see plans/09-forever-dungeons-routing-research.md).
-- Steps marked `forever = true` are dropped on every other client by
-- ns.RegisterRoute (Core.lua). They also carry races = { "Orc", "Troll" }:
-- Undead run this dungeon at the end of Routes/Horde/TirisfalStart.lua
-- instead, and quest-name steps can't tell it's already done there (the
-- name cache doesn't survive a session on Forever). The dungeon is 15-20 and its
-- quests are level 21-22, so the natural place for it is here: the leg
-- already comes back to the Sepulcher and Undercity at level 23, where
-- all but one quest giver stands (Brill is a short extra detour).
--
-- Everything is picked up at the end of the leg, not on arrival. On arrival
-- the quest log climbs to 20 (full) at Tarren Mill, so nothing extra fits
-- until the Hillsbrad quests are handed in.
--
-- Quest data (names, givers, objectives) is from foreverchanges.pro's beta
-- page (data dated 2026-09-19) and is provisional until launch. It has no
-- coordinates, so only steps whose NPC position this file already knows
-- carry x/y. The logCount values on the unmarked steps after the Sepulcher
-- accept are one lower than the real count on Forever, because they're
-- shared with Classic Era.
Leg(7, "Silverpine Forest", {

    {
      type = "section", name = "Chapter 17: Silverpine #2 & Durnholde Keep",
      levels = { 21, 23 }, zone = "Silverpine Forest",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 21, logCount = 15, x = 50.8, y = 13.9,
      note = "Zeppelin.",
    },
    {
      type = "turnin", questName = "Raleigh and the Undercity", zone = "Undercity",
      location = "Trade Quarter", atLevel = 21, logCount = 14, x = 61.2, y = 50.8,
    },
    {
      type = "accept", questName = "A Husband's Revenge", zone = "Undercity",
      location = "Trade Quarter", atLevel = 21, logCount = 15, x = 61.2, y = 50.8,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Book of Ur. Low XP for the travel time.",
      zone = "Undercity", location = "The Apothecarium", atLevel = 21, x = 53.7, y = 54.5,
    },
    {
      type = "travel", name = "Undercity to The Sepulcher", zone = "Undercity",
      location = "Trade Quarter", atLevel = 21, logCount = 15, x = 63.2, y = 48.6,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Until Death Do Us Part", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 21, logCount = 14, x = 44.2, y = 42.6,
    },
    {
      type = "turnin", questName = "Mura Runetotem", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 21, logCount = 13, x = 43.0, y = 42.0,
    },
    {
      type = "accept", questName = "Rot Hide Ichor", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 21, logCount = 14, x = 43.4, y = 40.9,
    },
    {
      type = "note", name = "Skip: D",
      note = "The route deliberately skips Deathstalkers in Shadowfang. Low XP for the travel time.",
      zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 21, x = 43.4, y = 40.9,
    },
    {
      type = "accept", questName = "Journey to Hillsbrad Foothills",
      zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 21, logCount = 15,
      x = 42.8, y = 40.8,
    },
    {
      type = "accept", questName = "Beren's Peril", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 21, logCount = 16, x = 44.0, y = 41.0,
    },
    {
      type = "accept", questName = "The Weaver", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 21, logCount = 17, x = 44.0, y = 41.0,
    },
    {
      type = "note", name = "Skip: A",
      note = "The route deliberately skips Arugal Must Die. Low XP for the travel time.",
      zone = "Silverpine Forest", location = "The Sepulcher", atLevel = 21, x = 44.2, y = 39.8,
    },
    {
      type = "complete", questName = "Rot Hide Ichor", zone = "Silverpine Forest",
      location = "Fenris Isle", atLevel = 21, logCount = 17, x = 66.0, y = 30.0, approx = true,
    },
    {
      type = "note", name = "Note",
      note = "If a Talking Head does not drop or if the quest is too difficult for your class, skip the Resting in Pieces quest.",
      atLevel = 21,
    },
    {
      type = "accept", questName = "Resting in Pieces", zone = "Silverpine Forest",
      location = "Fenris Isle", atLevel = 21, logCount = 18, x = 66.0, y = 30.0, approx = true,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "turnin", questName = "Resting in Pieces", zone = "Silverpine Forest",
      location = "Fenris Isle", atLevel = 21, logCount = 17, x = 67.9, y = 24.8,
    },
    {
      type = "accept", questName = "The Hidden Niche", zone = "Silverpine Forest",
      location = "Fenris Isle", atLevel = 21, logCount = 18, x = 67.9, y = 24.8,
    },
    {
      type = "complete", questName = "The Hidden Niche", zone = "Silverpine Forest",
      location = "Fenris Isle", atLevel = 21, logCount = 18, x = 68.0, y = 25.0, approx = true,
    },
    {
      type = "turnin", questName = "The Hidden Niche", zone = "Silverpine Forest",
      location = "Fenris Isle", atLevel = 22, logCount = 17, x = 65.4, y = 24.8,
    },
    {
      type = "accept", questName = "Wand to Bethor", zone = "Silverpine Forest",
      location = "Fenris Isle", atLevel = 22, logCount = 18, x = 65.4, y = 24.8,
    },
    {
      type = "complete", questName = "The Weaver", zone = "Silverpine Forest",
      location = "Ambermill", atLevel = 22, logCount = 18, x = 63.4, y = 64.3,
    },
    {
      type = "complete", questName = "Beren's Peril", zone = "Silverpine Forest",
      location = "Beren's Peril", atLevel = 22, logCount = 18, x = 60.0, y = 72.0,
      approx = true,
    },
    {
      type = "complete", questName = "A Husband's Revenge", zone = "Silverpine Forest",
      location = "Greymane Wall", atLevel = 22, logCount = 18, x = 46.0, y = 84.0,
      approx = true,
    },
    {
      type = "accept", questName = "Time To Strike", zone = "Hillsbrad Foothills",
      location = "Southpoint Tower", atLevel = 22, logCount = 19, x = 20.8, y = 47.6,
    },
    {
      type = "travel", name = "Zarise <Bat Handler>", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 19, x = 60.2, y = 18.6,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "turnin", questName = "Journey to Hillsbrad Foothills",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 22, logCount = 18,
      x = 61.4, y = 19.2,
    },
    {
      type = "turnin", questName = "Journey to Tarren Mill", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 17, x = 61.4, y = 19.2,
    },
    {
      type = "accept", questName = "Blood of Innocents", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 18, x = 61.4, y = 19.2,
    },
    {
      type = "accept", name = "Elixir of Suffering (part 1)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 19, x = 61.4, y = 19.2,
    },
    {
      type = "note", name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Elixir of Agony #1, Elixir of Pain #1 on a later pass.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 22, x = 61.4, y = 19.2,
    },
    {
      type = "turnin", questName = "Time To Strike", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 18, x = 62.2, y = 20.2,
    },
    {
      type = "note", name = "Skip for now: B",
      note = "Do not pick up yet - the route comes back for Battle for Hillsbrad #1 on a later pass.",
      zone = "Hillsbrad Foothills", location = "Tarren Mill", atLevel = 22, x = 62.2, y = 20.2,
    },
    {
      type = "accept", questName = "WANTED: Syndicate Personnel", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 19, x = 62.2, y = 20.6,
    },
    {
      type = "accept", questName = "The Rescue", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 20, x = 62.2, y = 20.6,
    },
    {
      type = "complete", name = "Elixir of Suffering (part 1)",
      questName = "Elixir of Suffering", ambiguous = true, zone = "Hillsbrad Foothills",
      location = "Eastern Hillsbrad", atLevel = 22, logCount = 20, x = 71.0, y = 43.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Blood of Innocents", zone = "Hillsbrad Foothills",
      location = "Durnholde Keep", atLevel = 22, logCount = 20, x = 77.0, y = 44.0,
      approx = true,
    },
    {
      type = "complete", questName = "WANTED: Syndicate Personnel",
      zone = "Hillsbrad Foothills", location = "Durnholde Keep", atLevel = 22, logCount = 20,
      x = 77.0, y = 44.0, approx = true,
    },
    {
      type = "complete", questName = "The Rescue", zone = "Hillsbrad Foothills",
      location = "Durnholde Keep", atLevel = 22, logCount = 20, x = 77.0, y = 44.0,
      approx = true,
    },
    {
      type = "turnin", questName = "WANTED: Syndicate Personnel", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 19, x = 62.2, y = 20.2,
    },
    {
      type = "turnin", questName = "The Rescue", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 18, x = 62.2, y = 20.6,
    },
    {
      type = "turnin", questName = "Blood of Innocents", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 17, x = 61.4, y = 19.2,
    },
    {
      type = "accept", questName = "Return to Thunder Bluff", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 18, x = 61.4, y = 19.2,
    },
    {
      type = "travel", name = "Tarren Mill to Sepulcher", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 22, logCount = 18, x = 60.2, y = 18.6,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Rot Hide Ichor", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 22, logCount = 17, x = 43.4, y = 40.9,
    },
    {
      type = "accept", questName = "Rot Hide Origins", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 22, logCount = 18, x = 43.4, y = 40.9,
    },
    {
      type = "turnin", questName = "The Weaver", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 23, logCount = 17, x = 44.0, y = 41.0,
    },
    {
      type = "turnin", questName = "Beren's Peril", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 23, logCount = 16, x = 44.0, y = 41.0,
    },
    {
      type = "travel", name = "The Sepulcher to Undercity", zone = "Silverpine Forest",
      location = "The Sepulcher", atLevel = 23, logCount = 15, x = 45.6, y = 42.6,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "A Husband's Revenge", zone = "Undercity",
      location = "Trade Quarter", atLevel = 23, logCount = 14, x = 62.0, y = 43.0,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Undercity", atLevel = 23,
      logCount = 14, note = "Several spots around here - check the whole area.",
    },
    {
      type = "note", name = "Note",
      note = "Class Trainer might be less travel time at Thunder Bluff in Chapter 18 depending on class.",
      atLevel = 23,
    },
    {
      type = "turnin", questName = "Rot Hide Origins", zone = "Undercity",
      location = "Magic Quarter", atLevel = 23, logCount = 13, x = 84.0, y = 17.0,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips Thule Ravenclaw. Low XP for the travel time.",
      zone = "Undercity", location = "Magic Quarter", atLevel = 23, x = 84.0, y = 17.0,
    },
    {
      type = "turnin", questName = "Wand to Bethor", zone = "Undercity",
      location = "Magic Quarter", atLevel = 23, logCount = 12, x = 84.0, y = 17.0,
    },

    -- Ruins of Lordaeron (Forever only) ------------------------------------
    {
      type = "section", name = "Chapter 17b: Ruins of Lordaeron (Forever dungeon)",
      levels = { 23, 24 }, zone = "Tirisfal Glades", forever = true, races = { "Orc", "Troll" },
    },
    {
      type = "note", name = "Mandatory: group up for Ruins of Lordaeron", atLevel = 23,
      forever = true, races = { "Orc", "Troll" },
      note = "Don't skip this. A 5-man dungeon for levels 15-20 - at 23 it goes quickly, and a duo may be enough. Its six quests plus the first-clear bonus are XP the rest of the route is meant to count on, so find a group (LFG, Undercity or Brill) before going on.",
    },
    {
      type = "accept", questName = "Light's Justice", zone = "Undercity",
      npc = "Morbin Lightbane", atLevel = 23, logCount = 14, forever = true, races = { "Orc", "Troll" },
      x = 57.8, y = 89.8,
    },
    {
      type = "accept", questName = "The New Plague", zone = "Undercity",
      npc = "Theodore Griffs", atLevel = 23, logCount = 15, forever = true, races = { "Orc", "Troll" },
      x = 47.0, y = 72.6,
      note = "Not the same quest as A New Plague in Brill.",
    },
    {
      type = "accept", questName = "Crest of Lordaeron", ambiguous = true, zone = "Undercity",
      npc = "Oran Snakewrithe", atLevel = 23, logCount = 16, forever = true, races = { "Orc", "Troll" },
      note = "Wowhead's dungeon-quest guide lists this quest as picked up inside the dungeon rather than from an NPC beforehand, but its rows for this name look scrape-ambiguous (two entries, likely one per faction) against foreverchanges.pro's structured giver name used here. Kept as originally sourced pending in-game verification.",
    },
    {
      type = "accept", questName = "A Frightened Request", zone = "Undercity",
      npc = "Tabitha Heartweaver", atLevel = 23, logCount = 17, forever = true, races = { "Orc", "Troll" },
      x = 34.0, y = 21.0,
      note = "Location corrected from Wowhead's dungeon-quest guide (was guessed as Silverpine Forest; the guide gives Undercity with this coordinate). Unverified in-game.",
    },
    {
      type = "accept", questName = "The Wrath of Rath'mael", zone = "Tirisfal Glades",
      location = "Brill", npc = "Deathguard Kristof", atLevel = 23, logCount = 18,
      x = 59.4, y = 52.4, approx = true, forever = true, races = { "Orc", "Troll" },
      note = "The source only says Tirisfal Glades - Brill, north of the Undercity entrance, is the likely spot.",
    },
    {
      type = "note", name = "Enter Ruins of Lordaeron", zone = "Tirisfal Glades",
      location = "Ruins of Lordaeron", atLevel = 23, forever = true, races = { "Orc", "Troll" },
      note = "Among the ruins of Lordaeron's capital, above the Undercity. Bosses: The Baron, Witherfang, The Abandoned, Bjork, Rath'mael, Viktor the Vile.",
    },
    {
      type = "complete", questName = "Light's Justice", zone = "Ruins of Lordaeron",
      atLevel = 23, forever = true, races = { "Orc", "Troll" }, note = "25 Intact Limbs.",
    },
    {
      type = "complete", questName = "The New Plague", zone = "Ruins of Lordaeron",
      atLevel = 23, forever = true, races = { "Orc", "Troll" }, note = "Highly Toxic Strain, from Witherfang.",
    },
    {
      type = "complete", questName = "Crest of Lordaeron", ambiguous = true, zone = "Ruins of Lordaeron",
      atLevel = 23, forever = true, races = { "Orc", "Troll" },
    },
    {
      type = "complete", questName = "The Wrath of Rath'mael", zone = "Ruins of Lordaeron",
      atLevel = 23, forever = true, races = { "Orc", "Troll" }, note = "Kill Rath'mael.",
    },
    {
      type = "complete", questName = "A Frightened Request", zone = "Ruins of Lordaeron",
      atLevel = 23, forever = true, races = { "Orc", "Troll" }, note = "Find out what happened to Edward Heartweaver.",
    },
    {
      type = "accept", questName = "Unending Torment", zone = "Ruins of Lordaeron",
      atLevel = 23, logCount = 19, forever = true, races = { "Orc", "Troll" },
      note = "Starts from an item you loot in the dungeon (Abominable Head), not from an NPC. The source doesn't say which boss drops it - its rewards match the Alliance quest for the Head of the Baron, so most likely The Baron.",
    },
    {
      type = "turnin", questName = "Unending Torment", zone = "Undercity",
      location = "The Apothecarium", npc = "Master Apothecary Faranell", atLevel = 23,
      logCount = 18, x = 50.1, y = 68.0, forever = true, races = { "Orc", "Troll" },
      note = "The source calls this a multi-step chain inside the Undercity. Follow any follow-up quests it gives you before leaving.",
    },
    {
      type = "turnin", questName = "Light's Justice", zone = "Undercity",
      npc = "Morbin Lightbane", atLevel = 23, logCount = 17, forever = true, races = { "Orc", "Troll" },
    },
    {
      type = "turnin", questName = "The New Plague", zone = "Undercity",
      npc = "Theodore Griffs", atLevel = 23, logCount = 16, forever = true, races = { "Orc", "Troll" },
    },
    {
      type = "turnin", questName = "Crest of Lordaeron", ambiguous = true, zone = "Undercity",
      npc = "Oran Snakewrithe", atLevel = 23, logCount = 15, forever = true, races = { "Orc", "Troll" },
    },
    {
      type = "turnin", questName = "The Wrath of Rath'mael", zone = "Tirisfal Glades",
      location = "Brill", npc = "Deathguard Kristof", atLevel = 23, logCount = 14,
      x = 59.4, y = 52.4, approx = true, forever = true, races = { "Orc", "Troll" },
    },
    {
      type = "turnin", questName = "A Frightened Request", zone = "Undercity",
      npc = "Tabitha Heartweaver", atLevel = 23, logCount = 13, x = 34.0, y = 21.0,
      forever = true, races = { "Orc", "Troll" },
      note = "Same NPC as the accept, per Wowhead's dungeon-quest guide - no extra travel needed. Worth about 7,000 XP. Unverified in-game.",
    },
    {
      type = "hearth", name = "Hearth to Camp Taurajo", zone = "Undercity",
      location = "Magic Quarter", atLevel = 23, logCount = 13, note = "Use your hearthstone.",
    },
})

