-- TuFFlevels / Routes/Horde/Solo/Felwood.lua
--
-- Felwood leg(s) of the solo Orc/Troll 1-60 route. Levels 49-57.
-- The route visits this zone 3 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 52: Azshara and Felwood Start
Leg(34, "Felwood", {

    { type = "section", name = "Chapter 52: Azshara and Felwood Start", levels = { 49, 50 }, zone = "Felwood" },
    {
      type = "travel", name = "Orgrimmar to Splintertree Post", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 49, logCount = 10, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "A Land Filled with Hatred", zone = "Azshara",
      location = "Talrendis Point", atLevel = 49, logCount = 11, x = 11.4, y = 78.2,
    },
    {
      type = "accept", questName = "Spiritual Unrest", zone = "Azshara",
      location = "Talrendis Point", atLevel = 49, logCount = 12, x = 11.4, y = 78.2,
    },
    {
      type = "complete", questName = "Spiritual Unrest", zone = "Azshara",
      location = "Shadowsong Shrine", atLevel = 49, logCount = 12, x = 20.0, y = 61.0,
      approx = true,
    },
    {
      type = "complete", questName = "A Land Filled with Hatred", zone = "Azshara",
      location = "Haldarr Encampment", atLevel = 49, logCount = 12, x = 15.0, y = 73.0,
      approx = true,
    },
    {
      type = "turnin", questName = "A Land Filled with Hatred", zone = "Azshara",
      location = "Talrendis Point", atLevel = 49, logCount = 11, x = 11.4, y = 78.2,
    },
    {
      type = "turnin", questName = "Spiritual Unrest", zone = "Azshara",
      location = "Talrendis Point", atLevel = 49, logCount = 10, x = 11.4, y = 78.2,
    },
    {
      type = "turnin", name = "Betrayed (part 1)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Valormok", atLevel = 49, logCount = 9, x = 22.3, y = 51.5,
    },
    {
      type = "note", name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Betrayed #2, Stealing Knowledge on a later pass.",
      zone = "Azshara", location = "Valormok", atLevel = 49, x = 22.3, y = 51.5,
    },
    {
      type = "travel", name = "Kroum <Wind Rider Master>", zone = "Azshara",
      location = "Valormok", atLevel = 49, logCount = 9, x = 22.0, y = 49.6,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Valormok to Splintertree Post", zone = "Azshara",
      location = "Valormok", atLevel = 49, logCount = 9, x = 22.0, y = 49.6,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Timbermaw Ally", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 49, logCount = 10, x = 50.9, y = 85.0,
    },
    {
      type = "accept", questName = "Forces of Jaedenar", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 49, logCount = 11, x = 51.2, y = 82.1,
    },
    {
      type = "note", name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Verifying the Corruption, Cleansing Felwood on a later pass.",
      zone = "Felwood", location = "Emerald Sanctuary", atLevel = 49, x = 50.9, y = 81.6,
    },
    {
      type = "manual", name = "Cursed Ooze: 30x Felwood Slime Sample", zone = "Felwood",
      location = "Southern Felwood", atLevel = 50, logCount = 11, x = 41.0, y = 67.0,
      approx = true, note = "Collect these here.",
    },
    {
      type = "complete", questName = "Forces of Jaedenar", zone = "Felwood",
      location = "Jadenaar", atLevel = 50, logCount = 11, x = 39.0, y = 58.0, approx = true,
    },
    {
      type = "note", name = "Skip for now: W",
      note = "Do not pick up yet - the route comes back for Well of Corruption on a later pass.",
      zone = "Felwood", location = "Bloodvenom Post", atLevel = 50, x = 34.2, y = 52.3,
    },
    {
      type = "accept", questName = "A Husband's Last Battle", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 50, logCount = 12, x = 34.8, y = 52.7,
    },
    {
      type = "travel", name = "Brakkar <Wind Rider Master>", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 50, logCount = 12, x = 34.4, y = 54.0,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "complete", questName = "Timbermaw Ally", zone = "Felwood",
      location = "Deadwood Village", atLevel = 50, logCount = 12, x = 48.0, y = 89.0,
      approx = true,
    },
    {
      type = "complete", questName = "A Husband's Last Battle", zone = "Felwood",
      location = "Deadwood Village", atLevel = 50, logCount = 12, x = 48.2, y = 94.3,
    },
    {
      type = "turnin", questName = "Timbermaw Ally", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 50, logCount = 11, x = 50.9, y = 85.0,
    },
    {
      type = "accept", questName = "Speak to Nafien", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 50, logCount = 12, x = 50.9, y = 85.0,
    },
    {
      type = "turnin", questName = "Forces of Jaedenar", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 50, logCount = 11, x = 51.2, y = 82.1,
    },
    {
      type = "accept", questName = "Collection of the Corrupt Water", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 50, logCount = 12, x = 51.2, y = 82.1,
    },
    {
      type = "complete", questName = "Collection of the Corrupt Water", zone = "Felwood",
      location = "Jadenaar", atLevel = 50, logCount = 12, x = 35.2, y = 59.8,
    },
    {
      type = "turnin", questName = "A Husband's Last Battle", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 50, logCount = 11, x = 34.8, y = 52.7,
    },
    {
      type = "turnin", questName = "Collection of the Corrupt Water", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 50, logCount = 10, x = 51.2, y = 82.1,
    },
    {
      type = "accept", questName = "Seeking Spiritual Aid", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 50, logCount = 11, x = 51.2, y = 82.1,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 50, logCount = 11, x = 51.2, y = 82.1,
      note = "Use your hearthstone.",
    },
})

-- Chapter 63: Felwood #1
Leg(44, "Felwood", {

    { type = "section", name = "Chapter 63: Felwood #1", levels = { 56, 56 }, zone = "Felwood" },
    {
      type = "turnin", questName = "Cleansed Water Returns to Felwood", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 56, logCount = 14, x = 51.2, y = 82.1,
    },
    {
      type = "accept", questName = "Dousing the Flames of Protection", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 56, logCount = 15, x = 51.2, y = 82.1,
    },
    {
      type = "turnin", questName = "Linken's Memory", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 56, logCount = 14, x = 51.3, y = 81.5,
    },
    {
      type = "accept", questName = "Silver Heart", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 56, logCount = 15, x = 51.3, y = 81.5,
    },
    {
      type = "accept", questName = "Verifying the Corruption", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 56, logCount = 16, x = 50.9, y = 81.6,
    },
    {
      type = "accept", questName = "Cleansing Felwood", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 56, logCount = 17, x = 46.7, y = 83.1,
    },
    {
      type = "complete", questName = "Well of Corruption", zone = "Felwood",
      location = "Ruins of Constellas", atLevel = 56, logCount = 17, x = 32.3, y = 66.6,
    },
    {
      type = "accept", questName = "A Strange Red Key", zone = "Felwood",
      location = "Jadenaar", atLevel = 56, logCount = 18, x = 36.0, y = 56.0, approx = true,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "turnin", questName = "A Strange Red Key", zone = "Felwood",
      location = "Jadenaar", atLevel = 56, logCount = 17, x = 36.2, y = 55.5,
    },
    {
      type = "accept", questName = "Rescue From Jaedenar", zone = "Felwood",
      location = "Jadenaar", atLevel = 56, logCount = 18, x = 36.2, y = 55.5,
    },
    {
      type = "complete", questName = "Dousing the Flames of Protection", zone = "Felwood",
      location = "Jadenaar", atLevel = 56, logCount = 18,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Rescue From Jaedenar", zone = "Felwood",
      location = "Jadenaar", atLevel = 56, logCount = 18, x = 37.0, y = 55.0, approx = true,
    },
    {
      type = "turnin", questName = "Well of Corruption", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 56, logCount = 17, x = 34.2, y = 52.3,
    },
    {
      type = "accept", questName = "Corrupted Sabers", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 56, logCount = 18, x = 34.2, y = 52.3,
    },
    {
      type = "complete", questName = "Verifying the Corruption", zone = "Felwood",
      location = "Shatter Scar Vale", atLevel = 56, logCount = 18, x = 41.0, y = 41.0,
      approx = true,
    },
    {
      type = "complete", questName = "Toxic Horrors", zone = "Felwood",
      location = "Irontree Woods", atLevel = 56, logCount = 18, x = 50.0, y = 27.0,
      approx = true,
    },
    {
      type = "complete", questName = "Cleansing Felwood", zone = "Felwood",
      location = "Irontree Cavern", atLevel = 56, logCount = 18, x = 56.0, y = 18.0,
      approx = true,
    },
    {
      type = "complete", questName = "Silver Heart", zone = "Felwood",
      location = "Northern Felwood", atLevel = 56, logCount = 18, x = 57.0, y = 20.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Umber, Archivist", zone = "Moonglade", atLevel = 56,
      logCount = 17, x = 44.9, y = 35.6,
    },
    {
      type = "accept", questName = "Uncovering Past Secrets", zone = "Moonglade", atLevel = 56,
      logCount = 18, x = 44.9, y = 35.6,
    },
    {
      type = "turnin", questName = "Uncovering Past Secrets", zone = "Moonglade", atLevel = 56,
      logCount = 17, x = 51.7, y = 45.1,
    },
    {
      type = "accept", questName = "Under the Chitin Was...", zone = "Moonglade", atLevel = 56,
      logCount = 18, x = 44.9, y = 35.6,
    },
    {
      type = "turnin", questName = "Under the Chitin Was...", zone = "Moonglade", atLevel = 56,
      logCount = 17, x = 44.9, y = 35.6,
    },
})

-- Chapter 65: Felwood #2
Leg(46, "Felwood", {

    { type = "section", name = "Chapter 65: Felwood #2", levels = { 57, 57 }, zone = "Felwood" },
    {
      type = "travel", name = "Orgrimmar to Splintertree Post", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 57, logCount = 17, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Dousing the Flames of Protection", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 16, x = 51.2, y = 82.1,
    },
    {
      type = "accept", questName = "A Final Blow", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 17, x = 51.2, y = 82.1,
    },
    {
      type = "turnin", questName = "Rescue From Jaedenar", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 16, x = 51.3, y = 82.0,
    },
    {
      type = "accept", questName = "Retribution of the Light", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 17, x = 51.3, y = 82.0,
    },
    {
      type = "turnin", questName = "Words of the High Chief", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 16, x = 51.1, y = 81.8,
    },
    {
      type = "turnin", questName = "Silver Heart", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 15, x = 51.3, y = 81.5,
    },
    {
      type = "note", name = "Skip for now: A",
      note = "Do not pick up yet - the route comes back for Aquementas on a later pass.",
      zone = "Felwood", location = "Emerald Sanctuary", atLevel = 57, x = 51.3, y = 81.5,
    },
    {
      type = "turnin", questName = "Verifying the Corruption", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 14, x = 50.9, y = 81.6,
    },
    {
      type = "turnin", questName = "Cleansing Felwood", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 13, x = 46.7, y = 83.1,
    },
    {
      type = "complete", questName = "Corrupted Sabers", zone = "Felwood",
      location = "Ruins of Constellas", atLevel = 57, logCount = 13, x = 32.3, y = 66.6,
    },
    {
      type = "complete", questName = "Retribution of the Light", zone = "Felwood",
      location = "Jadenaar", atLevel = 57, logCount = 13, x = 38.3, y = 50.5,
    },
    {
      type = "turnin", questName = "Retribution of the Light", zone = "Felwood",
      location = "Jadenaar", atLevel = 57, logCount = 12, x = 38.5, y = 50.4,
    },
    {
      type = "accept", questName = "The Remains of Trey Lightforge", zone = "Felwood",
      location = "Jadenaar", atLevel = 57, logCount = 13, x = 38.5, y = 50.4,
    },
    {
      type = "complete", questName = "A Final Blow", zone = "Felwood", location = "Jadenaar",
      atLevel = 57, logCount = 13, x = 38.8, y = 46.8,
    },
    {
      type = "turnin", questName = "Corrupted Sabers", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 57, logCount = 12, x = 34.2, y = 52.3,
    },
    {
      type = "turnin", name = "Wild Guardians (part 3)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", atLevel = 57,
      logCount = 11, x = 34.7, y = 52.8,
    },
    {
      type = "turnin", questName = "A Final Blow", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 10, x = 51.2, y = 82.1,
    },
    {
      type = "turnin", questName = "The Remains of Trey Lightforge", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 9, x = 51.3, y = 82.0,
    },
    {
      type = "accept", name = "Salve via Hunting", questName = "Salve via Hunting",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Felwood", location = "Emerald Sanctuary", atLevel = 57, x = 46.7, y = 83.1,
    },
    {
      type = "turnin", questName = "Salve via Hunting", zone = "Felwood",
      location = "Emerald Sanctuary", atLevel = 57, logCount = 9, x = 46.7, y = 83.1,
    },
    {
      type = "travel", name = "Splintertree Post to Orgrimmar", zone = "Ashenvale",
      location = "Splintertree Outpost", atLevel = 57, logCount = 9, x = 73.2, y = 61.6,
      note = "Take the flight path.",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 57, logCount = 9, x = 50.8, y = 13.9,
      note = "Zeppelin.",
    },
})

