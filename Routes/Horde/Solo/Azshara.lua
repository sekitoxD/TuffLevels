-- TuFFlevels / Routes/Horde/Solo/Azshara.lua
--
-- Azshara leg(s) of the solo Orc/Troll 1-60 route. Levels 53-53.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 57: Azshara
Leg(38, "Azshara", {

    { type = "section", name = "Chapter 57: Azshara", levels = { 53, 53 }, zone = "Azshara" },
    {
      type = "accept", name = "Betrayed (part 2)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Valormok", atLevel = 53, logCount = 11, x = 22.3, y = 51.5,
    },
    {
      type = "accept", questName = "Stealing Knowledge", zone = "Azshara",
      location = "Valormok", atLevel = 53, logCount = 12, x = 22.6, y = 51.4,
    },
    {
      type = "accept", questName = "Kim'jael Indeed!", zone = "Azshara",
      location = "Legash Encampment", atLevel = 53, logCount = 13, x = 53.5, y = 21.8,
    },
    {
      type = "complete", questName = "Kim'jael Indeed!", zone = "Azshara",
      location = "Thalassian Base Camp", atLevel = 53, logCount = 13, x = 56.0, y = 30.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", name = "Betrayed (part 2)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", atLevel = 53, logCount = 13,
      x = 56.0, y = 30.0, approx = true,
    },
    {
      type = "turnin", name = "Betrayed (part 2)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", atLevel = 53, logCount = 12,
      x = 59.5, y = 31.3,
    },
    {
      type = "accept", name = "Betrayed (part 3)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", atLevel = 53, logCount = 13,
      x = 59.5, y = 31.3,
    },
    {
      type = "complete", name = "Betrayed (part 3)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Thalassian Base Camp", atLevel = 53, logCount = 13,
      x = 59.5, y = 31.4,
    },
    {
      type = "complete", questName = "Kim'jael Indeed!", zone = "Azshara",
      location = "Thalassian Base Camp", atLevel = 53, logCount = 13, x = 56.0, y = 30.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Kim'jael Indeed!", zone = "Azshara",
      location = "Legash Encampment", atLevel = 53, logCount = 12, x = 53.5, y = 21.8,
    },
    {
      type = "accept", questName = "Kim'jael's \"Missing\" Equipment", zone = "Azshara",
      location = "Legash Encampment", atLevel = 53, logCount = 13, x = 53.5, y = 21.8,
    },
    {
      type = "complete", questName = "Stealing Knowledge", zone = "Azshara",
      location = "Ruins of Eldarath", atLevel = 53, logCount = 13, x = 37.0, y = 50.0,
      approx = true,
    },
    {
      type = "complete", name = "Seeping Corruption (part 1)",
      questName = "Seeping Corruption", ambiguous = true, zone = "Azshara",
      location = "The Shattered Strand", atLevel = 53, logCount = 13, x = 48.0, y = 49.0,
      approx = true,
    },
    {
      type = "complete", questName = "Kim'jael's \"Missing\" Equipment", zone = "Azshara",
      location = "The Shattered Strand", atLevel = 53, logCount = 13, x = 48.0, y = 49.0,
      approx = true,
    },
    {
      type = "accept", name = "The Demon Hunter", questName = "The Demon Hunter",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "turnin", questName = "The Demon Hunter", zone = "Azshara",
      location = "Bay of Storms", atLevel = 53, logCount = 13, x = 60.8, y = 66.4,
    },
    {
      type = "note", name = "Skip: L",
      note = "The route deliberately skips Loramus. Low XP for the travel time.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "accept", name = "Loramus", questName = "Loramus",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "turnin", questName = "Loramus", zone = "Azshara", location = "Bay of Storms",
      atLevel = 53, logCount = 13, x = 60.8, y = 66.4,
    },
    {
      type = "note", name = "Skip: B",
      note = "The route deliberately skips Breaking the Ward. Low XP for the travel time.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "accept", name = "Breaking the Ward", questName = "Breaking the Ward",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "turnin", questName = "Breaking the Ward", zone = "Azshara",
      location = "Bay of Storms", atLevel = 53, logCount = 13, x = 60.8, y = 66.4,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Name of the Beast #1. Low XP for the travel time.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "accept", name = "The Name of the Beast (part 1)", ambiguous = true,
      questName = "The Name of the Beast",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Azshara", location = "Temple of Arkkoran", atLevel = 53, x = 77.1, y = 42.8,
    },
    {
      type = "turnin", name = "The Name of the Beast (part 1)",
      questName = "The Name of the Beast", ambiguous = true, zone = "Azshara",
      location = "Temple of Arkkoran", atLevel = 53, logCount = 13, x = 77.1, y = 42.8,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Name of the Beast #2. Low XP for the travel time.",
      zone = "Azshara", location = "Temple of Arkkoran", atLevel = 53, x = 77.1, y = 42.8,
    },
    {
      type = "complete", name = "The Name of the Beast (part 2)",
      questName = "The Name of the Beast", ambiguous = true, zone = "Azshara",
      location = "Hetaera's Clutch", atLevel = 53, logCount = 13, x = 56.7, y = 44.8,
    },
    {
      type = "accept", name = "The Name of the Beast (part 2)", ambiguous = true,
      questName = "The Name of the Beast",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Azshara", location = "Temple of Arkkoran", atLevel = 53, x = 77.1, y = 42.8,
    },
    {
      type = "turnin", name = "The Name of the Beast (part 2)",
      questName = "The Name of the Beast", ambiguous = true, zone = "Azshara",
      location = "Temple of Arkkoran", atLevel = 53, logCount = 13, x = 77.1, y = 42.8,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Name of the Beast #3. Low XP for the travel time.",
      zone = "Azshara", location = "Temple of Arkkoran", atLevel = 53, x = 77.1, y = 42.8,
    },
    {
      type = "turnin", questName = "Kim'jael's \"Missing\" Equipment", zone = "Azshara",
      location = "Legash Encampment", atLevel = 53, logCount = 12, x = 53.5, y = 21.8,
    },
    {
      type = "accept", name = "The Name of the Beast (part 3)", ambiguous = true,
      questName = "The Name of the Beast",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "turnin", name = "The Name of the Beast (part 3)",
      questName = "The Name of the Beast", ambiguous = true, zone = "Azshara",
      location = "Bay of Storms", atLevel = 53, logCount = 12, x = 60.8, y = 66.4,
    },
    {
      type = "note", name = "Skip: A",
      note = "The route deliberately skips Azsharite. Low XP for the travel time.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "complete", questName = "Azsharite", zone = "Azshara",
      location = "Southern Azshara", atLevel = 53, logCount = 12, x = 51.0, y = 77.0,
      approx = true,
    },
    {
      type = "note", name = "Skip: A",
      note = "The route deliberately skips A Crew Under Fire. Low XP for the travel time.",
      zone = "Azshara", location = "The Ruined Reaches", atLevel = 53, x = 53.1, y = 87.8,
    },
    {
      type = "accept", name = "Azsharite", questName = "Azsharite",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "turnin", questName = "Azsharite", zone = "Azshara", location = "Bay of Storms",
      atLevel = 53, logCount = 12, x = 60.8, y = 66.4,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Formation of Felbane. Low XP for the travel time.",
      zone = "Azshara", location = "Bay of Storms", atLevel = 53, x = 60.8, y = 66.4,
    },
    {
      type = "turnin", questName = "Stealing Knowledge", zone = "Azshara",
      location = "Valormok", atLevel = 53, logCount = 11, x = 22.6, y = 51.4,
    },
    {
      type = "accept", questName = "Delivery to Andron Gant", zone = "Azshara",
      location = "Valormok", atLevel = 53, logCount = 12, x = 22.6, y = 51.4,
    },
    {
      type = "accept", questName = "Delivery to Archmage Xylem", zone = "Azshara",
      location = "Valormok", atLevel = 53, logCount = 13, x = 22.6, y = 51.4,
    },
    {
      type = "accept", questName = "Delivery to Jes'rimon", zone = "Azshara",
      location = "Valormok", atLevel = 53, logCount = 14, x = 22.6, y = 51.4,
    },
    {
      type = "accept", questName = "Delivery to Magatha", zone = "Azshara",
      location = "Valormok", atLevel = 53, logCount = 15, x = 22.6, y = 51.4,
    },
    {
      type = "turnin", name = "Betrayed (part 3)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Valormok", atLevel = 53, logCount = 14, x = 22.3, y = 51.5,
    },
    {
      type = "accept", name = "Betrayed (part 4)", questName = "Betrayed", ambiguous = true,
      zone = "Azshara", location = "Valormok", atLevel = 53, logCount = 15, x = 22.3, y = 51.5,
    },
    {
      type = "turnin", questName = "Delivery to Archmage Xylem", zone = "Azshara",
      location = "Xylem's Tower", atLevel = 53, logCount = 14, x = 29.3, y = 40.2,
    },
    {
      type = "accept", questName = "Xylem's Payment to Jediga", zone = "Azshara",
      location = "Xylem's Tower", atLevel = 53, logCount = 15, x = 29.3, y = 40.2,
    },
    {
      type = "turnin", questName = "Xylem's Payment to Jediga", zone = "Azshara",
      location = "Valormok", atLevel = 53, logCount = 14, x = 22.6, y = 51.4,
    },
    {
      type = "travel", name = "Valormok to Bloodvenom Post", zone = "Azshara",
      location = "Valormok", atLevel = 53, logCount = 14, x = 22.0, y = 49.6,
      note = "Take the flight path.",
    },
})

