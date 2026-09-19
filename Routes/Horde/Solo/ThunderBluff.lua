-- TuFFlevels / Routes/Horde/Solo/ThunderBluff.lua
--
-- Thunder Bluff leg(s) of the solo Orc/Troll 1-60 route. Levels 21-21.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 16: Camp Taurajo to Thunder Bluff
Leg(6, "Thunder Bluff", {

    {
      type = "section", name = "Chapter 16: Camp Taurajo to Thunder Bluff",
      levels = { 21, 21 }, zone = "Thunder Bluff",
    },
    {
      type = "accept", questName = "Apothecary Zamah", zone = "The Barrens",
      location = "The Crossroads", atLevel = 21, logCount = 16, x = 51.4, y = 30.2,
    },
    {
      type = "travel", name = "The Crossroads to Camp Taurajo", zone = "The Barrens",
      location = "The Crossroads", atLevel = 21, logCount = 16, x = 51.5, y = 30.3,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Melor Sends Word", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 17, x = 44.8, y = 59.0,
    },
    {
      type = "turnin", questName = "Jorn Skyseer", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 16, x = 44.8, y = 59.0,
    },
    {
      type = "accept", questName = "Ishamuhale", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 17, x = 44.8, y = 59.0,
    },
    {
      type = "hearth", name = "Set Hearth to Camp Taurajo", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 17, x = 45.6, y = 59.0,
      note = "Bind your hearthstone here.",
    },
    {
      type = "turnin", questName = "Tribes at War", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 16, x = 44.6, y = 59.2,
    },
    {
      type = "accept", questName = "Blood Shards of Agamaggan", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 17, x = 44.6, y = 59.2,
    },
    {
      type = "turnin", questName = "Blood Shards of Agamaggan", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 16, x = 44.6, y = 59.2,
    },
    {
      type = "note", name = "Skip for now: B",
      note = "Do not pick up yet - the route comes back for Betrayal from Within #1 on a later pass.",
      zone = "The Barrens", location = "Camp Taurajo", atLevel = 21, x = 44.6, y = 59.2,
    },
    {
      type = "accept", name = "Spirit of the Wind", questName = "Spirit of the Wind",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Barrens", location = "Camp Taurajo", atLevel = 21, x = 44.6, y = 59.2,
    },
    {
      type = "turnin", questName = "Spirit of the Wind", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 16, x = 44.6, y = 59.2,
    },
    {
      type = "travel", name = "Camp Taurajo to Thunder Bluff", zone = "The Barrens",
      location = "Camp Taurajo", atLevel = 21, logCount = 16, note = "Take the flight path.",
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Ashenvale Hunt #1. Low XP for the travel time.",
      zone = "Thunder Bluff", location = "Thunder Bluff", atLevel = 21,
    },
    {
      type = "turnin", questName = "Melor Sends Word", zone = "Thunder Bluff",
      location = "The Hunter Rise", atLevel = 21, logCount = 15, x = 61.4, y = 80.6,
    },
    {
      type = "accept", questName = "Steelsnap", zone = "Thunder Bluff",
      location = "The Hunter Rise", atLevel = 21, logCount = 16, x = 61.4, y = 80.6,
    },
    {
      type = "accept", name = "The Sacred Flame (part 1)", questName = "The Sacred Flame",
      ambiguous = true, zone = "Thunder Bluff", atLevel = 21, logCount = 17, x = 54.6,
      y = 51.4,
    },
    {
      type = "turnin", questName = "The Elder Crone", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 21, logCount = 16, x = 70.2, y = 30.8,
    },
    {
      type = "accept", questName = "Forsaken Aid", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 21, logCount = 17, x = 70.2, y = 30.8,
    },
    {
      type = "turnin", questName = "Hamuul Runetotem", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 21, logCount = 16, x = 78.4, y = 28.4,
    },
    {
      type = "accept", questName = "Nara Wildmane", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 21, logCount = 17, x = 78.4, y = 28.4,
    },
    {
      type = "turnin", questName = "Nara Wildmane", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 21, logCount = 16, x = 75.6, y = 31.2,
    },
    {
      type = "note", name = "Skip: L",
      note = "The route deliberately skips Leaders of the Fang. Low XP for the travel time.",
      zone = "Thunder Bluff", location = "The Elder Rise", atLevel = 21, x = 75.6, y = 31.2,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Thunder Bluff", atLevel = 21,
      logCount = 16, note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "Apothecary Zamah", zone = "Thunder Bluff",
      location = "The Spirit Rise", atLevel = 21, logCount = 15, x = 23.0, y = 21.0,
    },
    {
      type = "turnin", questName = "Forsaken Aid", zone = "Thunder Bluff",
      location = "The Spirit Rise", atLevel = 21, logCount = 14, x = 23.0, y = 21.0,
    },
    {
      type = "note", name = "Skip: S",
      note = "The route deliberately skips Serpentbloom. Low XP for the travel time.",
      zone = "Thunder Bluff", location = "The Spirit Rise", atLevel = 21, x = 23.0, y = 21.0,
    },
    {
      type = "accept", questName = "Journey to Tarren Mill", zone = "Thunder Bluff",
      location = "The Spirit Rise", atLevel = 21, logCount = 15, x = 23.0, y = 21.0,
    },
    {
      type = "accept", questName = "Until Death Do Us Part", zone = "Thunder Bluff",
      location = "The Spirit Rise", atLevel = 21, logCount = 16, x = 27.4, y = 24.6,
    },
    {
      type = "travel", name = "Tal <Wind Rider Master>", zone = "Thunder Bluff", atLevel = 21,
      logCount = 16, x = 46.8, y = 50.0,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Thunder Bluff to Ratchet", zone = "Thunder Bluff", atLevel = 21,
      logCount = 16, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Further Instructions (part 1)",
      questName = "Further Instructions", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", atLevel = 21, logCount = 15, x = 63.0, y = 37.2,
    },
    {
      type = "accept", name = "Further Instructions (part 2)",
      questName = "Further Instructions", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", atLevel = 21, logCount = 16, x = 63.0, y = 37.2,
    },
    {
      type = "turnin", questName = "Deepmoss Spider Eggs", zone = "The Barrens",
      location = "Ratchet", atLevel = 21, logCount = 15, x = 62.4, y = 37.6,
    },
    {
      type = "note", name = "Skip: B",
      note = "The route deliberately skips Blueleaf Tubers. Low XP for the travel time.",
      zone = "The Barrens", location = "Ratchet", atLevel = 21, x = 62.4, y = 37.6,
    },
    {
      type = "complete", questName = "Ishamuhale", zone = "The Barrens",
      location = "North of Ratchet", atLevel = 21, logCount = 15, x = 60.0, y = 30.5,
      approx = true,
    },
    {
      type = "travel", name = "Ratchet to Orgrimmar", zone = "The Barrens",
      location = "Ratchet", atLevel = 21, logCount = 15, x = 63.1, y = 37.2,
      note = "Take the flight path.",
    },
})

