-- TuFFlevels / Routes/Horde/Solo/SearingGorge.lua
--
-- Searing Gorge leg(s) of the solo Orc/Troll 1-60 route. Levels 46-47.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 47: Searing Gorge
Leg(30, "Searing Gorge", {

    { type = "section", name = "Chapter 47: Searing Gorge", levels = { 46, 47 }, zone = "Searing Gorge" },
    {
      type = "accept", questName = "Divine Retribution", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 46, logCount = 12, x = 39.1, y = 39.0,
    },
    {
      type = "turnin", questName = "Divine Retribution", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 46, logCount = 11, x = 39.1, y = 39.0,
    },
    {
      type = "accept", questName = "The Flawless Flame", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 46, logCount = 12, x = 39.1, y = 39.0,
    },
    {
      type = "travel", name = "Grisha <Wind Rider Master>", zone = "Searing Gorge",
      location = "Thorium Point", atLevel = 46, logCount = 12, x = 34.8, y = 30.9,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "note", optional = true, name = "Skip: W",
      note = "The route deliberately skips WANTED: Overseer Maltorius. Low XP for the travel time.",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, x = 37.6, y = 26.5,
    },
    {
      type = "accept", questName = "JOB OPPORTUNITY: Culling the Competition",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, logCount = 13,
      x = 37.6, y = 26.5,
    },
    {
      type = "accept", questName = "STOLEN: Smithing Tuyere and Lookout's Spyglass",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, logCount = 14,
      x = 37.6, y = 26.5,
    },
    {
      type = "accept", questName = "Curse These Fat Fingers", zone = "Searing Gorge",
      location = "Thorium Point", atLevel = 46, logCount = 15, x = 38.6, y = 27.8,
    },
    {
      type = "accept", questName = "Fiery Menace!", zone = "Searing Gorge",
      location = "Thorium Point", atLevel = 46, logCount = 16, x = 38.6, y = 27.8,
    },
    {
      type = "accept", questName = "Incendosaurs? Whateverosaur is More Like It",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, logCount = 17,
      x = 38.6, y = 27.8,
    },
    {
      type = "note", optional = true, name = "Skip: W",
      note = "The route deliberately skips What the Flux?. Low XP for the travel time.",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, x = 38.8, y = 28.5,
    },
    {
      type = "complete", questName = "STOLEN: Smithing Tuyere and Lookout's Spyglass",
      zone = "Searing Gorge", atLevel = 46, logCount = 17, x = 42.0, y = 50.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Curse These Fat Fingers", zone = "Searing Gorge",
      atLevel = 46, logCount = 17, x = 42.0, y = 50.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Fiery Menace!", zone = "Searing Gorge", atLevel = 46,
      logCount = 17, x = 32.0, y = 44.0, approx = true,
    },
    {
      type = "complete", questName = "The Flawless Flame", zone = "Searing Gorge",
      atLevel = 46, logCount = 17, x = 36.0, y = 45.0, approx = true,
    },
    {
      type = "complete", questName = "STOLEN: Smithing Tuyere and Lookout's Spyglass",
      zone = "Searing Gorge", atLevel = 46, logCount = 17, x = 53.0, y = 60.0, approx = true,
    },
    {
      type = "turnin", questName = "The Flawless Flame", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 46, logCount = 16, x = 39.1, y = 39.0,
    },
    {
      type = "accept", questName = "Forging the Shaft", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 46, logCount = 17, x = 39.1, y = 39.0,
    },
    {
      type = "complete", questName = "What the Flux?", zone = "Searing Gorge",
      location = "The Cauldron", atLevel = 46, logCount = 17, x = 40.4, y = 35.7,
    },
    {
      type = "complete", questName = "WANTED: Overseer Maltorius", zone = "Searing Gorge",
      location = "The Cauldron", atLevel = 46, logCount = 17, x = 40.8, y = 35.9,
    },
    {
      type = "complete", questName = "Incendosaurs? Whateverosaur is More Like It",
      zone = "Searing Gorge", location = "The Cauldron", atLevel = 46, logCount = 17, x = 51.0,
      y = 32.0, approx = true,
    },
    {
      type = "complete", questName = "JOB OPPORTUNITY: Culling the Competition",
      zone = "Searing Gorge", location = "The Cauldron", atLevel = 46, logCount = 17, x = 42.0,
      y = 56.0, approx = true,
    },
    {
      type = "complete", questName = "Forging the Shaft", zone = "Searing Gorge",
      location = "The Cauldron", atLevel = 46, logCount = 17, x = 42.0, y = 56.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Forging the Shaft", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 46, logCount = 16, x = 39.1, y = 39.0,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Flame's Casing. Low XP for the travel time.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 46, x = 39.1, y = 39.0,
    },
    {
      type = "turnin", questName = "Curse These Fat Fingers", zone = "Searing Gorge",
      location = "Thorium Point", atLevel = 46, logCount = 15, x = 38.6, y = 27.8,
    },
    {
      type = "turnin", questName = "Fiery Menace!", zone = "Searing Gorge",
      location = "Thorium Point", atLevel = 46, logCount = 14, x = 38.6, y = 27.8,
    },
    {
      type = "turnin", questName = "Incendosaurs? Whateverosaur is More Like It",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, logCount = 13,
      x = 38.6, y = 27.8,
    },
    {
      type = "accept", name = "What the Flux?", questName = "What the Flux?",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, x = 38.8, y = 28.5,
    },
    {
      type = "turnin", questName = "What the Flux?", zone = "Searing Gorge",
      location = "Thorium Point", atLevel = 46, logCount = 13, x = 38.8, y = 28.5,
    },
    {
      type = "accept", name = "WANTED: Overseer Maltorius",
      questName = "WANTED: Overseer Maltorius",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, x = 37.7, y = 26.6,
    },
    {
      type = "turnin", questName = "WANTED: Overseer Maltorius", zone = "Searing Gorge",
      location = "Thorium Point", atLevel = 46, logCount = 13, x = 37.7, y = 26.6,
    },
    {
      type = "turnin", questName = "JOB OPPORTUNITY: Culling the Competition",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 46, logCount = 12,
      x = 39.0, y = 27.5,
    },
    {
      type = "turnin", questName = "STOLEN: Smithing Tuyere and Lookout's Spyglass",
      zone = "Searing Gorge", location = "Thorium Point", atLevel = 47, logCount = 11,
      x = 39.0, y = 27.5,
    },
    {
      type = "complete", questName = "The Flame's Casing", zone = "Searing Gorge",
      location = "Firewatch Ridge", atLevel = 47, logCount = 11, x = 23.0, y = 38.0,
      approx = true,
    },
    {
      type = "accept", name = "The Flame's Casing", questName = "The Flame's Casing",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.1, y = 39.0,
    },
    {
      type = "turnin", questName = "The Flame's Casing", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 47, logCount = 11, x = 39.1, y = 39.0,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Torch of Retribution #1. Low XP for the travel time.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.1, y = 39.0,
    },
    {
      type = "accept", name = "The Torch of Retribution (part 1)", ambiguous = true,
      questName = "The Torch of Retribution",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.1, y = 39.0,
    },
    {
      type = "turnin", name = "The Torch of Retribution (part 1)",
      questName = "The Torch of Retribution", ambiguous = true, zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 47, logCount = 11, x = 39.1, y = 39.0,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Torch of Retribution #2. Low XP for the travel time.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.1, y = 39.2,
    },
    {
      type = "accept", name = "The Torch of Retribution (part 2)", ambiguous = true,
      questName = "The Torch of Retribution",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.1, y = 39.2,
    },
    {
      type = "turnin", name = "The Torch of Retribution (part 2)",
      questName = "The Torch of Retribution", ambiguous = true, zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 47, logCount = 11, x = 39.1, y = 39.2,
    },
    {
      type = "note", optional = true, name = "Skip: S",
      note = "The route deliberately skips Squire Maltrake. Low XP for the travel time.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.2, y = 39.0,
    },
    {
      type = "accept", name = "Squire Maltrake", questName = "Squire Maltrake",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.2, y = 39.0,
    },
    {
      type = "turnin", questName = "Squire Maltrake", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 47, logCount = 11, x = 39.2, y = 39.0,
    },
    {
      type = "note", optional = true, name = "Skip: S",
      note = "The route deliberately skips Set Them Ablaze!. Low XP for the travel time.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.2, y = 39.0,
    },
    {
      type = "complete", questName = "Set Them Ablaze!", zone = "Searing Gorge",
      location = "The Cauldron", atLevel = 47, logCount = 11,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "accept", name = "Set Them Ablaze!", questName = "Set Them Ablaze!",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 39.2, y = 39.0,
    },
    {
      type = "turnin", questName = "Set Them Ablaze!", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 47, logCount = 11, x = 39.2, y = 39.0,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips Trinkets.... Low XP for the travel time.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 38.8, y = 39.0,
    },
    {
      type = "accept", name = "Trinkets...", questName = "Trinkets...",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Searing Gorge", location = "Pyrox Flats", atLevel = 47, x = 38.8, y = 39.0,
    },
    {
      type = "turnin", questName = "Trinkets...", zone = "Searing Gorge",
      location = "Pyrox Flats", atLevel = 47, logCount = 11, x = 38.8, y = 39.0,
    },
    {
      type = "accept", questName = "The Key to Freedom", zone = "Searing Gorge", atLevel = 47,
      logCount = 12,
      note = "Starts from an item you loot here, not from an NPC. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "accept", questName = "Caught!", zone = "Searing Gorge",
      location = "Grimesilt Digsite", atLevel = 47, logCount = 13, x = 65.6, y = 62.2,
    },
    {
      type = "complete", questName = "Caught!", zone = "Searing Gorge",
      location = "Grimesilt Digsite", atLevel = 47, logCount = 13, x = 63.0, y = 61.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Caught!", zone = "Searing Gorge",
      location = "Grimesilt Digsite", atLevel = 47, logCount = 12, x = 65.6, y = 62.2,
    },
    {
      type = "note", optional = true, name = "Skip: L",
      note = "The route deliberately skips Ledger from Tanaris. Low XP for the travel time.",
      zone = "Searing Gorge", location = "Grimesilt Digsite", atLevel = 47, x = 65.6, y = 62.2,
    },
    {
      type = "turnin", questName = "The Key to Freedom", zone = "Searing Gorge",
      location = "Grimesilt Digsite", atLevel = 47, logCount = 11, x = 65.6, y = 62.2,
    },
    {
      type = "travel", name = "Kargath to Stonard", zone = "Badlands", location = "Kargath",
      atLevel = 47, logCount = 11, x = 4.0, y = 44.8, note = "Take the flight path.",
    },
    {
      type = "note", name = "Note",
      note = "Train here if you could not in Undercity. (Hunter/Shaman)", atLevel = 47,
    },
    {
      type = "turnin", questName = "Return to Fel'Zerul", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 47, logCount = 10, x = 47.9, y = 54.8,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Temple of Atal'Hakkar. Low XP for the travel time.",
      zone = "Swamp of Sorrows", location = "Stonard", atLevel = 47, x = 47.9, y = 54.8,
    },
    {
      type = "travel", name = "Stonard to Booty Bay", zone = "Swamp of Sorrows",
      location = "Stonard", atLevel = 47, logCount = 10, x = 46.1, y = 54.8,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Report Back to Fizzlebub", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 47, logCount = 9, x = 27.1, y = 77.2,
    },
    {
      type = "accept", questName = "Whiskey Slim's Lost Grog", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 47, logCount = 10, x = 27.1, y = 77.4,
    },
    {
      type = "turnin", questName = "Deliver to MacKinley", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 47, logCount = 9, x = 27.8, y = 77.1,
    },
    {
      type = "travel", name = "Booty Bay to Ratchet", zone = "Stranglethorn Vale",
      location = "Booty Bay", atLevel = 47, logCount = 9, x = 25.9, y = 73.1, note = "Boat.",
    },
    {
      type = "turnin", questName = "Consult Master Gadrin", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 47, logCount = 8, x = 55.9, y = 74.7,
    },
    {
      type = "note", optional = true, name = "Skip: T",
      note = "The route deliberately skips The Spider God. Low XP for the travel time.",
      zone = "Durotar", location = "Sen'jin Village", atLevel = 47, x = 55.9, y = 74.7,
    },
    {
      type = "hearth", name = "Hearth to Camp Mojache", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 47, logCount = 8, x = 55.9, y = 74.7,
      note = "Use your hearthstone.",
    },
})

