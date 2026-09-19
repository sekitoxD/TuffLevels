-- TuFFlevels / Routes/Horde/Solo/UngoroCrater.lua
--
-- Un'goro Crater leg(s) of the solo Orc/Troll 1-60 route. Levels 52-53.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 55: Un'Goro Crater East | Chapter 56: Un'Goro Crater West
Leg(37, "Un'goro Crater", {

    { type = "section", name = "Chapter 55: Un'Goro Crater East", levels = { 52, 52 }, zone = "Un'goro Crater" },
    {
      type = "travel", name = "The Crossroads to Gadgetzan", zone = "The Barrens",
      location = "The Crossroads", atLevel = 52, logCount = 12, x = 51.5, y = 30.3,
      note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Gadgetzan", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 12, x = 52.6, y = 27.9,
      note = "Bind your hearthstone here.",
    },
    {
      type = "turnin", questName = "Sprinkle's Secret Ingredient", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 11, x = 51.1, y = 26.9,
    },
    {
      type = "accept", questName = "Delivery for Marin", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 12, x = 51.1, y = 26.9,
    },
    {
      type = "turnin", questName = "March of the Silithid", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 11, x = 50.9, y = 27.0,
    },
    {
      type = "accept", questName = "Bungle in the Jungle", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 12, x = 50.9, y = 27.0,
    },
    {
      type = "turnin", questName = "Delivery for Marin", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 11, x = 51.8, y = 28.7,
    },
    {
      type = "turnin", questName = "The Stone Circle", zone = "Tanaris",
      location = "Broken Pillar", atLevel = 52, logCount = 10, x = 52.7, y = 45.9,
    },
    {
      type = "note", name = "Skip: I",
      note = "The route deliberately skips Into the Depths. Low XP for the travel time.",
      zone = "Tanaris", location = "Broken Pillar", atLevel = 52, x = 52.7, y = 45.9,
    },
    {
      type = "accept", questName = "The Fare of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 11, x = 71.6, y = 76.0,
    },
    {
      type = "accept", questName = "The Apes of Un'Goro", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 12, x = 71.6, y = 76.0,
    },
    {
      type = "manual", name = "Red, Blue Yellow, Green Crystal x7 each",
      zone = "Un'goro Crater", atLevel = 52, logCount = 12,
      note = "Start collecting this now - it drops over the whole leg, not in one spot. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "manual", name = "Un'goro Soil x40", zone = "Un'goro Crater", atLevel = 52,
      logCount = 12,
      note = "Start collecting this now - it drops over the whole leg, not in one spot. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "accept", name = "It's a Secret to Everybody (part 1)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 13, x = 63.0, y = 68.6,
    },
    {
      type = "turnin", name = "It's a Secret to Everybody (part 1)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 12, x = 63.1, y = 69.1,
    },
    {
      type = "accept", name = "It's a Secret to Everybody (part 2)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 13, x = 63.1, y = 69.1,
    },
    {
      type = "complete", questName = "The Fare of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 13, x = 68.7, y = 56.7,
    },
    {
      type = "turnin", questName = "The Fare of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 12, x = 71.6, y = 76.0,
    },
    {
      type = "accept", questName = "The Scent of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 13, x = 71.6, y = 76.0,
    },
    {
      type = "complete", questName = "The Scent of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 13, x = 67.3, y = 60.7,
    },
    {
      type = "complete", questName = "Bone-Bladed Weapons", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 13, x = 67.0, y = 61.0,
      approx = true,
    },
    {
      type = "accept", questName = "Williden's Journal", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 14,
      note = "Starts from an item you loot here, not from an NPC. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "turnin", questName = "The Scent of Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 13, x = 71.6, y = 76.0,
    },
    {
      type = "accept", questName = "The Bait for Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 14, x = 71.6, y = 76.0,
    },
    {
      type = "manual", name = "Un'goro Ooze: 30x Un'goro Slime Sample",
      zone = "Un'goro Crater", atLevel = 52, logCount = 14,
      note = "Start collecting this now - it drops over the whole leg, not in one spot. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "manual", name = "Red, Blue Yellow, Green Crystal x7 each",
      zone = "Un'goro Crater", atLevel = 52, logCount = 14,
      note = "You should have the full stack by now. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "accept", name = "Chasing A-Me 01 (part 1)", questName = "Chasing A-Me 01",
      ambiguous = true, zone = "Un'goro Crater", location = "Marshal's Refuge", atLevel = 52,
      logCount = 15, x = 46.4, y = 13.4,
    },
    {
      type = "accept", questName = "Shizzle's Flyer", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 16, x = 44.2, y = 11.6,
    },
    {
      type = "note", name = "Skip for now: L",
      note = "Do not pick up yet - the route comes back for Lost! on a later pass.",
      zone = "Un'goro Crater", location = "Marshal's Refuge", atLevel = 52, x = 43.6, y = 8.5,
    },
    {
      type = "accept", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 17, x = 43.5, y = 8.4,
    },
    {
      type = "accept", questName = "Roll the Bones", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 18, x = 43.5, y = 7.4,
    },
    {
      type = "note", name = "Skip for now: A",
      note = "Do not pick up yet - the route comes back for Alien Ecology on a later pass.",
      zone = "Un'goro Crater", location = "Marshal's Refuge", atLevel = 52, x = 43.9, y = 7.2,
    },
    {
      type = "turnin", questName = "Williden's Journal", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 17, x = 43.9, y = 7.1,
    },
    {
      type = "accept", questName = "Expedition Salvation", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 18, x = 43.9, y = 7.1,
    },
    {
      type = "accept", questName = "Crystals of Power", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 19, x = 41.9, y = 2.7,
    },
    {
      type = "turnin", questName = "Crystals of Power", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 18, x = 41.9, y = 2.7,
    },
    {
      type = "accept", questName = "The Eastern Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 19, x = 41.9, y = 2.7,
    },
    {
      type = "accept", questName = "The Northern Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 20, x = 41.9, y = 2.7,
    },
    {
      type = "note", name = "Skip for now: T",
      note = "Do not pick up yet - the route comes back for The Western Pylon on a later pass.",
      zone = "Un'goro Crater", location = "Marshal's Refuge", atLevel = 52, x = 41.9, y = 2.7,
    },
    {
      type = "travel", name = "Gryfe <Flight Master>", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 20, x = 45.2, y = 5.8,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "turnin", name = "It's a Secret to Everybody (part 2)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 19, x = 44.7, y = 8.1,
    },
    {
      type = "note", name = "Skip for now: I",
      note = "Do not pick up yet - the route comes back for It's a Secret to Everybody #3 on a later pass.",
      zone = "Un'goro Crater", location = "Marshal's Refuge", atLevel = 52, x = 44.7, y = 8.1,
    },
    {
      type = "accept", questName = "Larion and Muigin", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 20, x = 45.5, y = 8.7,
    },
    {
      type = "complete", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "Fungal Rock", atLevel = 52, logCount = 20, x = 56.0, y = 11.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "The Northern Pylon", zone = "Un'goro Crater",
      location = "Fungal Rock", atLevel = 52, logCount = 20, x = 56.5, y = 12.4,
    },
    {
      type = "complete", questName = "The Apes of Un'Goro", zone = "Un'goro Crater",
      location = "Fungal Rock", atLevel = 52, logCount = 20, x = 64.0, y = 16.0, approx = true,
    },
    {
      type = "complete", questName = "Super Sticky", zone = "Un'goro Crater",
      location = "Lakkari Tar Pits", atLevel = 52, logCount = 20, x = 60.0, y = 23.0,
      approx = true,
    },
    {
      type = "complete", questName = "Larion and Muigin", zone = "Un'goro Crater",
      location = "Northeastern Un'goro", atLevel = 52, logCount = 20, x = 67.0, y = 31.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Expedition Salvation", zone = "Un'goro Crater",
      location = "Northeastern Un'goro", atLevel = 52, logCount = 20, x = 68.6, y = 36.6,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "The Eastern Pylon", zone = "Un'goro Crater",
      location = "Ironstone Plateau", atLevel = 52, logCount = 20, x = 77.2, y = 50.0,
    },
    {
      type = "complete", questName = "The Bait for Lar'korwi", zone = "Un'goro Crater",
      location = "Ironstone Plateau", atLevel = 52, logCount = 20, x = 79.9, y = 49.8,
    },
    {
      type = "turnin", questName = "The Bait for Lar'korwi", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 19, x = 71.6, y = 76.0,
    },
    {
      type = "turnin", questName = "The Apes of Un'Goro", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 18, x = 71.6, y = 76.0,
    },
    {
      type = "accept", questName = "The Mighty U'cha", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 52, logCount = 19, x = 71.6, y = 76.0,
    },
    {
      type = "complete", questName = "Bungle in the Jungle", zone = "Un'goro Crater",
      location = "The Slithering Scar", atLevel = 52, logCount = 19, x = 50.0, y = 77.0,
      approx = true,
    },
    {
      type = "complete", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "The Slithering Scar", atLevel = 52, logCount = 19, x = 44.0, y = 89.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "hearth", name = "Hearth to Gadgetzan", zone = "Un'goro Crater",
      location = "The Slithering Scar", atLevel = 52, logCount = 19, x = 44.0, y = 89.0,
      approx = true, note = "Use your hearthstone.",
    },

    { type = "section", name = "Chapter 56: Un'Goro Crater West", levels = { 52, 53 }, zone = "Un'goro Crater" },
    {
      type = "turnin", questName = "Super Sticky", zone = "Tanaris", location = "Gadgetzan",
      atLevel = 52, logCount = 18, x = 51.6, y = 26.8,
    },
    {
      type = "turnin", questName = "Bungle in the Jungle", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 17, x = 50.9, y = 27.0,
    },
    {
      type = "accept", questName = "Pawn Captures Queen", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 18, x = 50.9, y = 27.0,
    },
    {
      type = "travel", name = "Gadgetzan to Marshal's Refuge", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 52, logCount = 18, x = 51.6, y = 25.4,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Alien Ecology", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 19, x = 43.9, y = 7.2,
    },
    {
      type = "accept", questName = "Lost!", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 20, x = 43.6, y = 8.5,
    },
    {
      type = "turnin", questName = "The Northern Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 19, x = 41.9, y = 2.7,
    },
    {
      type = "turnin", questName = "The Eastern Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 18, x = 41.9, y = 2.7,
    },
    {
      type = "accept", questName = "The Western Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 52, logCount = 19, x = 41.9, y = 2.7,
    },
    {
      type = "complete", questName = "The Mighty U'cha", zone = "Un'goro Crater",
      location = "Fungal Rock", atLevel = 52, logCount = 19, x = 68.2, y = 12.6,
    },
    {
      type = "turnin", name = "Chasing A-Me 01 (part 1)", questName = "Chasing A-Me 01",
      ambiguous = true, zone = "Un'goro Crater", location = "Fungal Rock", atLevel = 52,
      logCount = 18, x = 46.4, y = 13.4,
    },
    {
      type = "note", name = "Skip: C",
      note = "The route deliberately skips Chasing A-Me 01 #2. Low XP for the travel time.",
      zone = "Un'goro Crater", location = "Fungal Rock", atLevel = 52, x = 67.7, y = 16.8,
    },
    {
      type = "complete", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", atLevel = 52, logCount = 18, x = 35.0, y = 38.0,
      approx = true,
    },
    {
      type = "complete", questName = "Larion and Muigin", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", atLevel = 52, logCount = 18, x = 35.0, y = 38.0,
      approx = true,
    },
    {
      type = "accept", questName = "Finding the Source", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", atLevel = 52, logCount = 19, x = 30.9, y = 50.4,
    },
    {
      type = "complete", questName = "The Western Pylon", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", atLevel = 52, logCount = 19, x = 23.9, y = 59.1,
    },
    {
      type = "complete", questName = "Expedition Salvation", zone = "Un'goro Crater",
      location = "Terror Run", atLevel = 52, logCount = 19, x = 38.5, y = 66.1,
    },
    {
      type = "complete", questName = "Roll the Bones", zone = "Un'goro Crater",
      location = "Terror Run", atLevel = 52, logCount = 19, x = 45.0, y = 65.0, approx = true,
    },
    {
      type = "complete", questName = "Shizzle's Flyer", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", atLevel = 53, logCount = 19, x = 53.0, y = 64.0,
      approx = true,
    },
    {
      type = "complete", questName = "Alien Ecology", zone = "Un'goro Crater",
      location = "The Slithering Scar", atLevel = 53, logCount = 19, x = 48.7, y = 85.2,
    },
    {
      type = "complete", questName = "Pawn Captures Queen", zone = "Un'goro Crater",
      location = "The Slithering Scar", atLevel = 53, logCount = 19, x = 43.5, y = 81.1,
    },
    {
      type = "turnin", questName = "The Mighty U'cha", zone = "Un'goro Crater",
      location = "The Marshlands", atLevel = 53, logCount = 18, x = 71.6, y = 76.0,
    },
    {
      type = "turnin", questName = "Lost!", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", atLevel = 53, logCount = 17, x = 43.6, y = 8.5,
    },
    {
      type = "accept", questName = "A Little Help From My Friends", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", atLevel = 53, logCount = 18, x = 51.9, y = 49.8,
    },
    {
      type = "complete", questName = "A Little Help From My Friends", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", atLevel = 53, logCount = 18, x = 51.0, y = 46.0,
      approx = true,
    },
    {
      type = "complete", questName = "Volcanic Activity", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", atLevel = 53, logCount = 18, x = 51.0, y = 46.0,
      approx = true,
    },
    {
      type = "complete", questName = "Finding the Source", zone = "Un'goro Crater",
      location = "Fire Plume Ridge", atLevel = 53, logCount = 18, x = 49.6, y = 45.7,
    },
    {
      type = "manual", name = "Un'goro Ooze: 30x Un'goro Slime Sample",
      zone = "Un'goro Crater", atLevel = 53, logCount = 18,
      note = "You should have the full stack by now. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "manual", name = "Un'goro Soil x40", zone = "Un'goro Crater", atLevel = 53,
      logCount = 18,
      note = "You should have the full stack by now. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "note", name = "Note",
      note = "Do not vendor any Ungoro Soil you have collected, even if you have more than required.",
      atLevel = 53,
    },
    {
      type = "turnin", questName = "Shizzle's Flyer", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 17, x = 44.2, y = 11.6,
    },
    {
      type = "accept", name = "It's a Secret to Everybody (part 3)",
      questName = "It's a Secret to Everybody", ambiguous = true, zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 18, x = 44.7, y = 8.1,
    },
    {
      type = "turnin", questName = "Larion and Muigin", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 17, x = 45.5, y = 8.7,
    },
    {
      type = "accept", questName = "Marvon's Workshop", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 18, x = 45.5, y = 8.7,
    },
    {
      type = "turnin", questName = "A Little Help From My Friends", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 17, x = 43.6, y = 8.5,
    },
    {
      type = "turnin", questName = "Beware of Pterrordax", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 16, x = 43.6, y = 8.5,
    },
    {
      type = "turnin", questName = "Alien Ecology", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 15, x = 43.9, y = 7.2,
    },
    {
      type = "turnin", questName = "Expedition Salvation", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 14, x = 43.9, y = 7.1,
    },
    {
      type = "turnin", questName = "Roll the Bones", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 13, x = 43.5, y = 7.4,
    },
    {
      type = "turnin", questName = "The Western Pylon", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 12, x = 41.9, y = 2.7,
    },
    {
      type = "accept", questName = "Making Sense of It", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 13, x = 41.9, y = 2.7,
    },
    {
      type = "turnin", questName = "Making Sense of It", zone = "Un'goro Crater",
      location = "Marshal's Refuge", atLevel = 53, logCount = 12, x = 41.9, y = 2.7,
    },
    {
      type = "turnin", questName = "Finding the Source", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", atLevel = 53, logCount = 11, x = 71.6, y = 76.0,
    },
    {
      type = "accept", questName = "The New Springs", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", atLevel = 53, logCount = 12, x = 71.6, y = 76.0,
    },
    {
      type = "hearth", name = "Hearth to Gadgetzan", zone = "Un'goro Crater",
      location = "Golakka Hot Springs", atLevel = 53, logCount = 12, x = 71.6, y = 76.0,
      note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "Pawn Captures Queen", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 53, logCount = 11, x = 50.9, y = 27.0,
    },
    {
      type = "accept", name = "Calm Before the Storm (part 1)",
      questName = "Calm Before the Storm", ambiguous = true, zone = "Tanaris",
      location = "Gadgetzan", atLevel = 53, logCount = 12, x = 50.9, y = 27.0,
    },
    {
      type = "travel", name = "Gadgetzan to Camp Mojache", zone = "Tanaris",
      location = "Gadgetzan", atLevel = 53, logCount = 12, x = 51.6, y = 25.4,
      note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Camp Mojache", zone = "Feralas",
      location = "Camp Mojache", atLevel = 53, logCount = 12, x = 74.8, y = 45.2,
      note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Strength of Corruption", zone = "Feralas",
      location = "Camp Mojache", atLevel = 53, logCount = 13, x = 76.2, y = 43.8,
    },
    {
      type = "travel", name = "Camp Mojache to Thunder Bluff", zone = "Feralas",
      location = "Camp Mojache", atLevel = 53, logCount = 13, x = 75.4, y = 44.4,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Assisting Arch Druid Runetotem", zone = "Thunder Bluff",
      atLevel = 53, logCount = 14, x = 45.8, y = 64.7,
    },
    {
      type = "note", name = "Skip for now: A",
      note = "Do not pick up yet - the route comes back for A Call to Arms: The Plaguelands! on a later pass.",
      zone = "Thunder Bluff", location = "Thunder Bluff", atLevel = 53,
    },
    {
      type = "turnin", questName = "Assisting Arch Druid Runetotem", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 53, logCount = 13, x = 78.6, y = 28.6,
    },
    {
      type = "accept", questName = "Un'Goro Soil", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 53, logCount = 14, x = 78.6, y = 28.6,
    },
    {
      type = "turnin", questName = "Un'Goro Soil", zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 53, logCount = 13, x = 77.5, y = 22.0,
    },
    {
      type = "accept", name = "Morrowgrain Research (part 1)",
      questName = "Morrowgrain Research", ambiguous = true, zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 53, logCount = 14, x = 78.6, y = 28.6,
    },
    {
      type = "turnin", name = "Morrowgrain Research (part 1)",
      questName = "Morrowgrain Research", ambiguous = true, zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 53, logCount = 13, x = 71.1, y = 34.2,
    },
    {
      type = "accept", name = "Morrowgrain Research (part 2)",
      questName = "Morrowgrain Research", ambiguous = true, zone = "Thunder Bluff",
      location = "The Elder Rise", atLevel = 53, logCount = 14, x = 71.1, y = 34.2,
    },
    {
      type = "note", name = "Note",
      note = "Begin activating the Evergreen Pouch on its 10 minute cooldown everytime it is ready.",
      atLevel = 53,
    },
    {
      type = "travel", name = "Thunder Bluff to Ratchet", zone = "Thunder Bluff", atLevel = 53,
      logCount = 14, x = 46.8, y = 50.0, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Volcanic Activity", zone = "The Barrens",
      location = "Ratchet", atLevel = 53, logCount = 13, x = 62.4, y = 38.7,
    },
    {
      type = "turnin", questName = "Marvon's Workshop", zone = "The Barrens",
      location = "Ratchet", atLevel = 53, logCount = 12, x = 62.4, y = 38.7,
    },
    {
      type = "note", name = "Skip: Z",
      note = "The route deliberately skips Zapper Fuel. Low XP for the travel time.",
      zone = "The Barrens", location = "Ratchet", atLevel = 53, x = 62.4, y = 38.7,
    },
    {
      type = "travel", name = "Ratchet to Orgrimmar", zone = "The Barrens",
      location = "Ratchet", atLevel = 53, logCount = 12, x = 63.1, y = 37.2,
      note = "Take the flight path.",
    },
    {
      type = "turnin", name = "Calm Before the Storm (part 1)",
      questName = "Calm Before the Storm", ambiguous = true, zone = "Orgrimmar",
      location = "The Drag", atLevel = 53, logCount = 11, x = 56.3, y = 46.7,
    },
    {
      type = "accept", name = "Calm Before the Storm (part 2)",
      questName = "Calm Before the Storm", ambiguous = true, zone = "Orgrimmar",
      location = "The Drag", atLevel = 53, logCount = 12, x = 56.3, y = 46.7,
    },
    {
      type = "turnin", questName = "Bone-Bladed Weapons", zone = "Orgrimmar",
      location = "The Drag", atLevel = 53, logCount = 11, x = 55.5, y = 34.1,
    },
    {
      type = "note", name = "Skip for now: A",
      note = "Do not pick up yet - the route comes back for A Call to Arms: The Plaguelands! on a later pass.",
      zone = "Orgrimmar", location = "Orgrimmar", atLevel = 53,
    },
    {
      type = "turnin", name = "Calm Before the Storm (part 2)",
      questName = "Calm Before the Storm", ambiguous = true, zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 53, logCount = 10, x = 49.6, y = 69.1,
    },
    {
      type = "travel", name = "Orgrimmar to Valormok", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 53, logCount = 10, x = 45.2, y = 63.8,
      note = "Take the flight path.",
    },
})

