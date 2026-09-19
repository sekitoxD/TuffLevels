-- TuFFlevels / Routes/Horde/Solo/Winterspring.lua
--
-- Winterspring leg(s) of the solo Orc/Troll 1-60 route. Levels 53-57.
-- The route visits this zone 3 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 58: Frostfire Springs
Leg(39, "Winterspring", {

    { type = "section", name = "Chapter 58: Frostfire Springs", levels = { 53, 54 }, zone = "Winterspring" },
    {
      type = "accept", name = "Wild Guardians (part 1)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", atLevel = 53,
      logCount = 15, x = 34.7, y = 52.8,
    },
    {
      type = "complete", questName = "Strength of Corruption", zone = "Felwood",
      location = "Northeastern Felwood", atLevel = 54, logCount = 15, x = 54.0, y = 27.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Speak to Nafien", zone = "Felwood",
      location = "Felpaw Village", atLevel = 54, logCount = 14, x = 50.9, y = 85.0,
    },
    {
      type = "accept", questName = "Deadwood of the North", zone = "Felwood",
      location = "Felpaw Village", atLevel = 54, logCount = 15, x = 64.8, y = 8.1,
    },
    {
      type = "note", name = "Skip for now: W",
      note = "Do not pick up yet - the route comes back for Winterfall Activity on a later pass.",
      zone = "Winterspring", location = "Frostfire Hot Springs", atLevel = 54, x = 27.7,
      y = 34.5,
    },
    {
      type = "turnin", questName = "The New Springs", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 14, x = 31.3, y = 45.2,
    },
    {
      type = "accept", questName = "Strange Sources", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 15, x = 31.3, y = 45.2,
    },
    {
      type = "note", name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for Threat of the Winterfall on a later pass.",
      zone = "Winterspring", location = "Frostfire Hot Springs", atLevel = 54, x = 31.3,
      y = 45.2,
    },
    {
      type = "turnin", name = "It's a Secret to Everybody (part 3)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 14, x = 31.3, y = 45.2,
    },
    {
      type = "accept", name = "The Videre Elixir (part 1)", questName = "The Videre Elixir",
      ambiguous = true, zone = "Winterspring", location = "Frostfire Hot Springs",
      atLevel = 54, logCount = 15, x = 31.3, y = 45.2,
    },
    {
      type = "complete", name = "Wild Guardians (part 1)", questName = "Wild Guardians",
      ambiguous = true, zone = "Winterspring", location = "West of Everlook", atLevel = 54,
      logCount = 15, x = 47.0, y = 38.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "travel", name = "Yugrek <Wind Rider Master>", zone = "Winterspring",
      location = "Everlook", atLevel = 54, logCount = 15, x = 60.5, y = 36.3,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "note", name = "Skip for now: A",
      note = "Do not pick up yet - the route comes back for Are We There, Yeti? #1 on a later pass.",
      zone = "Winterspring", location = "Everlook", atLevel = 54, x = 60.9, y = 37.6,
    },
    {
      type = "accept", questName = "A Strange One", zone = "Winterspring",
      location = "Everlook", atLevel = 54, logCount = 16, x = 61.1, y = 38.4,
    },
    {
      type = "accept", questName = "Trouble in Winterspring!", zone = "Winterspring",
      location = "Everlook", atLevel = 54, logCount = 17, x = 60.7, y = 38.2,
    },
    {
      type = "note", name = "Skip for now: U",
      note = "Do not pick up yet - the route comes back for Ursius of the Shardtooth on a later pass.",
      zone = "Winterspring", location = "Everlook", atLevel = 54, x = 61.9, y = 38.4,
    },
    {
      type = "turnin", questName = "Felnok Steelspring", zone = "Winterspring",
      location = "Everlook", atLevel = 54, logCount = 16, x = 61.6, y = 38.6,
    },
    {
      type = "note", name = "Skip for now: 2 quests here",
      note = "Do not pick up yet - the route comes back for Chillwind Horns, Duke Nicholas Zverenhoff on a later pass.",
      zone = "Winterspring", location = "Everlook", atLevel = 54, x = 61.6, y = 38.6,
    },
    {
      type = "accept", questName = "The Everlook Report", zone = "Winterspring",
      location = "Everlook", atLevel = 54, logCount = 17, x = 61.3, y = 39.0,
    },
    {
      type = "note", name = "Skip: S",
      note = "The route deliberately skips Sister Pamela. Low XP for the travel time.",
      zone = "Winterspring", location = "Everlook", atLevel = 54, x = 61.3, y = 39.0,
    },
    {
      type = "complete", name = "Wild Guardians (part 1)", questName = "Wild Guardians",
      ambiguous = true, zone = "Winterspring", location = "West of Everlook", atLevel = 54,
      logCount = 17, x = 56.0, y = 30.0, approx = true,
    },
    {
      type = "turnin", questName = "Trouble in Winterspring!", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 16, x = 31.3, y = 45.2,
    },
    {
      type = "accept", questName = "Threat of the Winterfall", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "complete", questName = "Threat of the Winterfall", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 17, x = 31.0, y = 37.0,
      approx = true,
    },
    {
      type = "accept", questName = "Winterfall Firewater", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 18, x = 31.0, y = 37.0,
      approx = true, note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "turnin", questName = "Threat of the Winterfall", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "turnin", questName = "Winterfall Firewater", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 16, x = 31.3, y = 45.2,
    },
    {
      type = "accept", questName = "Falling to Corruption", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 54, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "turnin", questName = "Falling to Corruption", zone = "Felwood",
      location = "Felpaw Village", atLevel = 54, logCount = 16, x = 60.2, y = 5.8,
    },
    {
      type = "accept", questName = "Mystery Goo", zone = "Felwood",
      location = "Felpaw Village", atLevel = 54, logCount = 17, x = 60.2, y = 5.8,
    },
    {
      type = "complete", questName = "Deadwood of the North", zone = "Felwood",
      location = "Felpaw Village", atLevel = 54, logCount = 17, x = 62.0, y = 7.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Deadwood of the North", zone = "Felwood",
      location = "Felpaw Village", atLevel = 54, logCount = 16, x = 64.8, y = 8.1,
    },
    {
      type = "accept", questName = "Speak to Salfa", zone = "Felwood",
      location = "Felpaw Village", atLevel = 54, logCount = 17, x = 64.8, y = 8.1,
    },
    {
      type = "travel", name = "Faustron <Flight Master>", zone = "Moonglade", atLevel = 54,
      logCount = 17, x = 32.1, y = 66.6,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Moonglade to Bloodvenom Post", zone = "Moonglade", atLevel = 54,
      logCount = 17, x = 32.1, y = 66.6, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "A Strange One", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 54, logCount = 16, x = 34.2, y = 52.3,
    },
    {
      type = "turnin", name = "Wild Guardians (part 1)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", atLevel = 54,
      logCount = 15, x = 34.7, y = 52.8,
    },
    {
      type = "accept", name = "Wild Guardians (part 2)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", atLevel = 54,
      logCount = 16, x = 34.7, y = 52.8,
    },
    {
      type = "hearth", name = "Hearth to Camp Mojache", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 54, logCount = 16, x = 34.7, y = 52.8,
      note = "Use your hearthstone.",
    },
})

-- Chapter 61: Winterspring South
Leg(42, "Winterspring", {

    { type = "section", name = "Chapter 61: Winterspring South", levels = { 55, 56 }, zone = "Winterspring" },
    {
      type = "travel", name = "Orgrimmar to Valormok", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 55, logCount = 18, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Andron's Payment to Jediga", zone = "Azshara",
      location = "Valormok", atLevel = 55, logCount = 17, x = 22.6, y = 51.4,
    },
    {
      type = "turnin", questName = "Jes'rimon's Payment to Jediga", zone = "Azshara",
      location = "Valormok", atLevel = 55, logCount = 16, x = 22.6, y = 51.4,
    },
    {
      type = "turnin", questName = "Magatha's Payment to Jediga", zone = "Azshara",
      location = "Valormok", atLevel = 55, logCount = 15, x = 22.6, y = 51.4,
    },
    {
      type = "travel", name = "Valormok to Everlook", zone = "Azshara", location = "Valormok",
      atLevel = 55, logCount = 15, x = 22.0, y = 49.6, note = "Take the flight path.",
    },
    {
      type = "accept", name = "Are We There, Yeti? (part 1)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 16, x = 60.9, y = 37.6,
    },
    {
      type = "accept", questName = "Chillwind Horns", zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 17, x = 61.6, y = 38.6,
    },
    {
      type = "accept", questName = "A Little Luck", zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 18, x = 61.1, y = 38.4,
    },
    {
      type = "turnin", questName = "A Little Luck", zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 17, x = 61.9, y = 38.3,
    },
    {
      type = "accept", questName = "Luck Be With You", zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 18, x = 61.9, y = 38.3,
    },
    {
      type = "accept", questName = "Ursius of the Shardtooth", zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 19, x = 61.9, y = 38.4,
    },
    {
      type = "complete", questName = "Ursius of the Shardtooth", zone = "Winterspring",
      location = "Winterfall Village", atLevel = 55, logCount = 19,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "complete", name = "Are We There, Yeti? (part 1)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Ice Thistle Hills", atLevel = 55, logCount = 19, x = 67.0, y = 42.0,
      approx = true,
    },
    {
      type = "turnin", name = "Are We There, Yeti? (part 1)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 18, x = 60.9, y = 37.6,
    },
    {
      type = "accept", name = "Are We There, Yeti? (part 2)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 19, x = 60.9, y = 37.6,
    },
    {
      type = "turnin", questName = "Ursius of the Shardtooth", zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 18, x = 61.9, y = 38.4,
    },
    {
      type = "accept", questName = "Brumeran of the Chillwind", zone = "Winterspring",
      location = "Everlook", atLevel = 55, logCount = 19, x = 61.9, y = 38.4,
    },
    {
      type = "complete", name = "Are We There, Yeti? (part 2)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Ice Thistle Hills", atLevel = 55, logCount = 19, x = 67.0, y = 42.0,
      approx = true,
    },
    {
      type = "complete", name = "Wild Guardians (part 2)", questName = "Wild Guardians",
      ambiguous = true, zone = "Winterspring", location = "Owl Wing Thicket", atLevel = 55,
      logCount = 19, x = 65.0, y = 61.0, approx = true,
    },
    {
      type = "accept", name = "Guarding Secrets (part 1)", questName = "Guarding Secrets",
      ambiguous = true, zone = "Winterspring", location = "Owl Wing Thicket", atLevel = 55,
      logCount = 20, x = 65.0, y = 61.0, approx = true,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", questName = "Brumeran of the Chillwind", zone = "Winterspring",
      location = "Southern Winterspring", atLevel = 55, logCount = 20,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "complete", questName = "Luck Be With You", zone = "Winterspring",
      location = "Frostwhisper Gorge", atLevel = 55, logCount = 20, x = 62.0, y = 69.0,
      approx = true,
    },
    {
      type = "complete", questName = "Strange Sources", zone = "Winterspring",
      location = "Darkwhisper Gorge", atLevel = 55, logCount = 20, x = 60.0, y = 74.0,
    },
    {
      type = "turnin", name = "Are We There, Yeti? (part 2)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Everlook", atLevel = 56, logCount = 19, x = 60.9, y = 37.6,
    },
    {
      type = "accept", name = "Are We There, Yeti? (part 3)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Everlook", atLevel = 56, logCount = 20, x = 60.9, y = 37.6,
    },
    {
      type = "complete", name = "Are We There, Yeti? (part 3)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Everlook", atLevel = 56, logCount = 20, x = 61.5, y = 38.6,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", questName = "Luck Be With You", zone = "Winterspring",
      location = "Everlook", atLevel = 56, logCount = 19, x = 61.9, y = 38.3,
    },
    {
      type = "turnin", questName = "Brumeran of the Chillwind", zone = "Winterspring",
      location = "Everlook", atLevel = 56, logCount = 18, x = 61.9, y = 38.4,
    },
    {
      type = "note", name = "Skip: S",
      note = "The route deliberately skips Shy-Rotam. Low XP for the travel time.",
      zone = "Winterspring", location = "Everlook", atLevel = 56, x = 61.9, y = 38.4,
    },
    {
      type = "turnin", name = "The Videre Elixir (part 1)", questName = "The Videre Elixir",
      ambiguous = true, zone = "Winterspring", location = "Frostfire Hot Springs",
      atLevel = 56, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "accept", questName = "Meet at the Grave", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 18, x = 31.3, y = 45.2,
    },
    {
      type = "turnin", questName = "Strange Sources", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "turnin", questName = "Mystery Goo", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 16, x = 31.3, y = 45.2,
    },
    {
      type = "accept", questName = "Toxic Horrors", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "turnin", questName = "Speak to Salfa", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 16, x = 27.7, y = 34.5,
    },
    {
      type = "turnin", questName = "Rabine Saturna", zone = "Moonglade", atLevel = 56,
      logCount = 15, x = 51.7, y = 45.1,
    },
    {
      type = "accept", questName = "Wasteland", zone = "Moonglade", atLevel = 56,
      logCount = 16, x = 51.7, y = 45.1,
    },
    {
      type = "travel", name = "Moonglade to Bloodvenom Post", zone = "Moonglade", atLevel = 56,
      logCount = 16, x = 32.1, y = 66.6, note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Well of Corruption", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 56, logCount = 17, x = 34.2, y = 52.3,
    },
    {
      type = "turnin", name = "Wild Guardians (part 2)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", atLevel = 56,
      logCount = 16, x = 34.7, y = 52.8,
    },
    {
      type = "accept", name = "Wild Guardians (part 3)", questName = "Wild Guardians",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", atLevel = 56,
      logCount = 17, x = 34.7, y = 52.8,
    },
    {
      type = "turnin", name = "Guarding Secrets (part 1)", questName = "Guarding Secrets",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", atLevel = 56,
      logCount = 16, x = 34.7, y = 52.8,
    },
    {
      type = "accept", name = "Guarding Secrets (part 2)", questName = "Guarding Secrets",
      ambiguous = true, zone = "Felwood", location = "Bloodvenom Post", atLevel = 56,
      logCount = 17, x = 34.7, y = 52.8,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "Felwood",
      location = "Bloodvenom Post", atLevel = 56, logCount = 17, x = 7.6, y = 43.7,
      note = "Use your hearthstone.",
    },
})

-- Chapter 64: Winterspring North
Leg(45, "Winterspring", {

    { type = "section", name = "Chapter 64: Winterspring North", levels = { 56, 57 }, zone = "Winterspring" },
    {
      type = "accept", questName = "Winterfall Activity", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 18, x = 27.7, y = 34.5,
    },
    {
      type = "turnin", questName = "Toxic Horrors", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "accept", questName = "Winterfall Runners", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 18, x = 31.3, y = 45.2,
    },
    {
      type = "complete", questName = "Winterfall Runners", zone = "Winterspring",
      location = "Winterfall Village", atLevel = 56, logCount = 18,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "turnin", questName = "Winterfall Runners", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "accept", questName = "High Chief Winterfall", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 56, logCount = 18, x = 31.3, y = 45.2,
    },
    {
      type = "complete", questName = "Winterfall Activity", zone = "Winterspring",
      location = "Winterfall Village", atLevel = 56, logCount = 18, x = 67.0, y = 36.0,
      approx = true,
    },
    {
      type = "complete", questName = "High Chief Winterfall", zone = "Winterspring",
      location = "Winterfall Village", atLevel = 56, logCount = 18, x = 69.5, y = 38.4,
    },
    {
      type = "accept", questName = "The Final Piece", zone = "Winterspring",
      location = "Winterfall Village", atLevel = 56, logCount = 19, x = 69.5, y = 38.4,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", name = "Wild Guardians (part 3)", questName = "Wild Guardians",
      ambiguous = true, zone = "Winterspring", location = "The Hidden Grove", atLevel = 56,
      logCount = 19, x = 65.0, y = 22.0, approx = true,
    },
    {
      type = "complete", questName = "Chillwind Horns", zone = "Winterspring",
      location = "North of Everlook", atLevel = 56, logCount = 19, x = 59.0, y = 15.0,
      approx = true,
    },
    {
      type = "complete", questName = "Shy-Rotam", zone = "Winterspring",
      location = "Frostsaber Rock", atLevel = 56, logCount = 19, x = 49.7, y = 9.7,
    },
    {
      type = "turnin", name = "Are We There, Yeti? (part 3)",
      questName = "Are We There, Yeti?", ambiguous = true, zone = "Winterspring",
      location = "Everlook", atLevel = 56, logCount = 18, x = 60.9, y = 37.6,
    },
    {
      type = "accept", questName = "Duke Nicholas Zverenhoff", zone = "Winterspring",
      location = "Everlook", atLevel = 56, logCount = 19, x = 61.3, y = 39.0,
    },
    {
      type = "turnin", questName = "Chillwind Horns", zone = "Winterspring",
      location = "Everlook", atLevel = 57, logCount = 18, x = 61.6, y = 38.6,
    },
    {
      type = "accept", questName = "Return to Tinkee", zone = "Winterspring",
      location = "Everlook", atLevel = 57, logCount = 19, x = 61.6, y = 38.6,
    },
    {
      type = "accept", name = "Shy-Rotam", questName = "Shy-Rotam",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Winterspring", location = "Everlook", atLevel = 57, x = 61.9, y = 38.4,
    },
    {
      type = "turnin", questName = "Shy-Rotam", zone = "Winterspring", location = "Everlook",
      atLevel = 57, logCount = 19, x = 61.9, y = 38.4,
    },
    {
      type = "turnin", questName = "High Chief Winterfall", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 57, logCount = 18, x = 31.3, y = 45.2,
    },
    {
      type = "turnin", questName = "The Final Piece", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 57, logCount = 17, x = 31.3, y = 45.2,
    },
    {
      type = "accept", questName = "Words of the High Chief", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 57, logCount = 18, x = 31.3, y = 45.2,
    },
    {
      type = "turnin", questName = "Winterfall Activity", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 57, logCount = 17, x = 27.7, y = 34.5,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "Winterspring",
      location = "Frostfire Hot Springs", atLevel = 57, logCount = 17, x = 27.7, y = 34.5,
      note = "Use your hearthstone.",
    },
})

