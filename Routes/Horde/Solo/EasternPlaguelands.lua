-- TuFFlevels / Routes/Horde/Solo/EasternPlaguelands.lua
--
-- Eastern Plaguelands leg(s) of the solo Orc/Troll 1-60 route. Levels 57-58.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 66: Eastern Plaguelands #1 | Chapter 67: Eastern Plaguelands #2
Leg(47, "Eastern Plaguelands", {

    {
      type = "section", name = "Chapter 66: Eastern Plaguelands #1", levels = { 57, 57 },
      zone = "Eastern Plaguelands",
    },
    {
      type = "turnin", questName = "All Along the Watchtowers", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 57, logCount = 8, x = 83.1, y = 68.9,
    },
    {
      type = "accept", questName = "Scholomance", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 57, logCount = 9, x = 83.1, y = 68.9,
    },
    {
      type = "note", name = "Skip: A",
      note = "The route deliberately skips Alas, Andorhal. Low XP for the travel time.",
      zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 57, x = 83.1, y = 68.9,
    },
    {
      type = "turnin", questName = "Scholomance", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 57, logCount = 8, x = 83.3, y = 69.2,
    },
    {
      type = "accept", questName = "Skeletal Fragments", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 57, logCount = 9, x = 83.3, y = 69.2,
    },
    {
      type = "turnin", name = "Return to the Bulwark (part 3)",
      questName = "Return to the Bulwark", ambiguous = true, zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 57, logCount = 8, x = 83.0, y = 71.9,
    },
    {
      type = "accept", questName = "Target: Gahrron's Withering", zone = "Tirisfal Glades",
      location = "The Bulwark", atLevel = 57, logCount = 9, x = 83.0, y = 71.9,
    },
    {
      type = "accept", name = "A Plague Upon Thee (part 1)", questName = "A Plague Upon Thee",
      ambiguous = true, zone = "Tirisfal Glades", location = "The Bulwark", atLevel = 57,
      logCount = 10, x = 83.3, y = 72.3,
    },
    {
      type = "accept", questName = "Blood Tinged Skies", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 57, logCount = 11, x = 7.6, y = 43.7,
    },
    {
      type = "accept", questName = "Carrion Grubbage", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 57, logCount = 12, x = 7.6, y = 43.7,
    },
    {
      type = "accept", questName = "Demon Dogs", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 57, logCount = 13, x = 7.6, y = 43.7,
    },
    {
      type = "complete", questName = "Carrion Grubbage", zone = "Eastern Plaguelands",
      atLevel = 57, logCount = 13, x = 21.0, y = 68.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Demon Dogs", zone = "Eastern Plaguelands", atLevel = 57,
      logCount = 13, x = 21.0, y = 68.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Blood Tinged Skies", zone = "Eastern Plaguelands",
      atLevel = 57, logCount = 13, x = 21.0, y = 68.0, approx = true,
    },
    {
      type = "turnin", questName = "The Champion of the Banshee Queen",
      zone = "Eastern Plaguelands", location = "The Marris Stead", atLevel = 57, logCount = 12,
      x = 26.5, y = 74.7,
    },
    {
      type = "accept", questName = "To Kill With Purpose", zone = "Eastern Plaguelands",
      location = "The Marris Stead", atLevel = 57, logCount = 13, x = 26.5, y = 74.7,
    },
    {
      type = "accept", questName = "Un-Life's Little Annoyances", zone = "Eastern Plaguelands",
      location = "The Marris Stead", atLevel = 57, logCount = 14, x = 26.5, y = 74.7,
    },
    {
      type = "accept", questName = "The Ranger Lord's Behest", zone = "Eastern Plaguelands",
      location = "The Marris Stead", atLevel = 57, logCount = 15, x = 26.5, y = 74.7,
    },
    {
      type = "accept", questName = "Zaeldarr the Outcast", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 57, logCount = 16, x = 79.5, y = 63.9,
    },
    {
      type = "accept", name = "The Restless Souls (part 1)", questName = "The Restless Souls",
      ambiguous = true, zone = "Eastern Plaguelands", location = "Light's Hope Chapel",
      atLevel = 57, logCount = 17, x = 79.5, y = 63.9,
    },
    {
      type = "turnin", questName = "Duke Nicholas Zverenhoff", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 57, logCount = 16, x = 81.4, y = 59.8,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Archivist. Low XP for the travel time.",
      zone = "Eastern Plaguelands", location = "Light's Hope Chapel", atLevel = 57, x = 81.4,
      y = 59.8,
    },
    {
      type = "turnin", questName = "Uncle Carlin", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 57, logCount = 15, x = 81.5, y = 59.8,
    },
    {
      type = "accept", questName = "Defenders of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 57, logCount = 16, x = 81.5, y = 59.8,
    },
    {
      type = "turnin", questName = "Brother Carlin", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 57, logCount = 15, x = 81.5, y = 59.8,
    },
    {
      type = "accept", questName = "Heroes of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 57, logCount = 16, x = 81.5, y = 59.8,
    },
    {
      type = "accept", questName = "Villains of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 57, logCount = 17, x = 81.5, y = 59.8,
    },
    {
      type = "note", name = "Skip: 2 quests here",
      note = "The route deliberately skips Plagued Hatchlings, The Flesh does not Lie. Low XP for the travel time.",
      zone = "Eastern Plaguelands", location = "Light's Hope Chapel", atLevel = 57, x = 81.5,
      y = 59.7,
    },
    {
      type = "hearth", name = "Set Hearth to Light's Hope Chapel",
      zone = "Eastern Plaguelands", location = "Light's Hope Chapel", atLevel = 57,
      logCount = 17, x = 81.6, y = 58.1, note = "Bind your hearthstone here.",
    },
    {
      type = "note", name = "Skip: 3 quests here",
      note = "The route deliberately skips Houses of the Holy, The Great Fras Siabi, That's Asking A Lot. Low XP for the travel time.",
      zone = "Eastern Plaguelands", location = "Light's Hope Chapel", atLevel = 57, x = 81.7,
      y = 57.8,
    },
    {
      type = "travel", name = "Georgia <Bat Handler>", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 57, logCount = 17, x = 80.2, y = 57.0,
      note = "Talk to the flight master and learn this flight point.",
    },

    {
      type = "section", name = "Chapter 67: Eastern Plaguelands #2", levels = { 57, 58 },
      zone = "Eastern Plaguelands",
    },
    {
      type = "complete", questName = "Un-Life's Little Annoyances",
      zone = "Eastern Plaguelands", atLevel = 57, logCount = 17, x = 53.0, y = 47.0,
      approx = true,
    },
    {
      type = "complete", questName = "Carrion Grubbage", zone = "Eastern Plaguelands",
      atLevel = 57, logCount = 17, x = 53.0, y = 47.0, approx = true,
    },
    {
      type = "complete", questName = "Demon Dogs", zone = "Eastern Plaguelands", atLevel = 57,
      logCount = 17, x = 53.0, y = 47.0, approx = true,
    },
    {
      type = "complete", name = "A Plague Upon Thee (part 1)",
      questName = "A Plague Upon Thee", ambiguous = true, zone = "Eastern Plaguelands",
      location = "Plaguewood", atLevel = 57, logCount = 17, x = 40.0, y = 31.0, approx = true,
    },
    {
      type = "complete", questName = "Defenders of Darrowshire", zone = "Eastern Plaguelands",
      location = "Plaguewood", atLevel = 57, logCount = 17, x = 40.0, y = 31.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "The Restless Souls (part 1)", questName = "The Restless Souls",
      ambiguous = true, zone = "Eastern Plaguelands", location = "Terrordale", atLevel = 57,
      logCount = 16, x = 14.5, y = 33.7,
    },
    {
      type = "note", name = "Skip: T",
      note = "The route deliberately skips The Restless Souls #2. Low XP for the travel time.",
      zone = "Eastern Plaguelands", location = "Terrordale", atLevel = 57, x = 14.5, y = 33.7,
    },
    {
      type = "accept", questName = "Augustus' Receipt Book", zone = "Eastern Plaguelands",
      location = "Terrordale", atLevel = 57, logCount = 17, x = 14.4, y = 33.5,
    },
    {
      type = "complete", questName = "Augustus' Receipt Book", zone = "Eastern Plaguelands",
      location = "Terrordale", atLevel = 57, logCount = 17, x = 17.4, y = 31.1,
    },
    {
      type = "turnin", questName = "Augustus' Receipt Book", zone = "Eastern Plaguelands",
      location = "Terrordale", atLevel = 57, logCount = 16, x = 14.4, y = 33.5,
    },
    {
      type = "turnin", questName = "Blood Tinged Skies", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 57, logCount = 15, x = 7.6, y = 43.7,
    },
    {
      type = "turnin", questName = "Carrion Grubbage", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 14, x = 7.6, y = 43.7,
    },
    {
      type = "turnin", questName = "Demon Dogs", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 13, x = 7.6, y = 43.7,
    },
    {
      type = "accept", questName = "Redemption", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 14, x = 7.6, y = 43.7,
    },
    {
      type = "turnin", questName = "Redemption", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 13, x = 7.6, y = 43.7,
    },
    {
      type = "accept", questName = "Of Forgotten Memories", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 14, x = 7.6, y = 43.7,
    },
    {
      type = "complete", questName = "Zaeldarr the Outcast", zone = "Eastern Plaguelands",
      location = "The Undercroft", atLevel = 58, logCount = 14, x = 27.5, y = 84.9,
    },
    {
      type = "accept", questName = "Hameya's Plea", zone = "Eastern Plaguelands",
      location = "The Undercroft", atLevel = 58, logCount = 15, x = 27.3, y = 86.2,
    },
    {
      type = "complete", questName = "Of Forgotten Memories", zone = "Eastern Plaguelands",
      location = "The Undercroft", atLevel = 58, logCount = 15, x = 27.3, y = 86.2,
    },
    {
      type = "complete", questName = "To Kill With Purpose", zone = "Eastern Plaguelands",
      location = "Corin's Crossing", atLevel = 58, logCount = 15, x = 59.0, y = 69.0,
      approx = true,
    },
    {
      type = "complete", questName = "Defenders of Darrowshire", zone = "Eastern Plaguelands",
      location = "Corin's Crossing", atLevel = 58, logCount = 15, x = 59.0, y = 69.0,
      approx = true,
    },
    {
      type = "complete", questName = "Villains of Darrowshire", zone = "Eastern Plaguelands",
      location = "The Infectis Scar", atLevel = 58, logCount = 15, x = 53.9, y = 65.8,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", questName = "To Kill With Purpose", zone = "Eastern Plaguelands",
      location = "The Marris Stead", atLevel = 58, logCount = 14, x = 26.5, y = 74.7,
    },
    {
      type = "turnin", questName = "Un-Life's Little Annoyances", zone = "Eastern Plaguelands",
      location = "The Marris Stead", atLevel = 58, logCount = 13, x = 26.5, y = 74.7,
    },
    {
      type = "turnin", questName = "Of Forgotten Memories", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 12, x = 7.6, y = 43.7,
    },
    {
      type = "accept", questName = "Of Lost Honor", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 13, x = 7.6, y = 43.7,
    },
    {
      type = "hearth", name = "Hearth to Light's Hope Chapel", zone = "Eastern Plaguelands",
      location = "Thondroril River", atLevel = 58, logCount = 13, x = 7.6, y = 43.7,
      note = "Use your hearthstone.",
    },
    {
      type = "complete", questName = "Of Lost Honor", zone = "Eastern Plaguelands",
      location = "Northdale", atLevel = 58, logCount = 13, x = 71.3, y = 33.9,
    },
    {
      type = "complete", questName = "Hameya's Plea", zone = "Eastern Plaguelands",
      location = "Zul'mashar", atLevel = 58, logCount = 13, x = 70.0, y = 17.0, approx = true,
    },
    {
      type = "complete", questName = "The Ranger Lord's Behest", zone = "Eastern Plaguelands",
      location = "Quel'Lithien Lodge", atLevel = 58, logCount = 13, x = 52.1, y = 18.3,
    },
    {
      type = "complete", questName = "Villains of Darrowshire", zone = "Eastern Plaguelands",
      location = "Blackwood Lake", atLevel = 58, logCount = 13, x = 51.1, y = 49.9,
    },
    {
      type = "turnin", questName = "Defenders of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 58, logCount = 12, x = 81.5, y = 59.8,
    },
    {
      type = "turnin", questName = "Villains of Darrowshire", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 58, logCount = 11, x = 81.5, y = 59.8,
    },
    {
      type = "turnin", questName = "Zaeldarr the Outcast", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 58, logCount = 10, x = 79.5, y = 63.9,
    },
    {
      type = "travel", name = "Light's Hope Chapel to Undercity", zone = "Eastern Plaguelands",
      location = "Light's Hope Chapel", atLevel = 58, logCount = 10, x = 80.2, y = 57.0,
      note = "Take the flight path.",
    },
})

