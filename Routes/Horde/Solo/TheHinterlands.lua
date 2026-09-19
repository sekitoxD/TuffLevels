-- TuFFlevels / Routes/Horde/Solo/TheHinterlands.lua
--
-- The Hinterlands leg(s) of the solo Orc/Troll 1-60 route. Levels 45-49.
-- The route visits this zone 2 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 46: Hinterlands West
Leg(29, "The Hinterlands", {

    { type = "section", name = "Chapter 46: Hinterlands West", levels = { 45, 46 }, zone = "The Hinterlands" },
    {
      type = "accept", name = "Reclaimed Treasures", questName = "Reclaimed Treasures",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "Undercity", location = "Trade Quarter", atLevel = 45, x = 62.3, y = 48.6,
    },
    {
      type = "turnin", questName = "Reclaimed Treasures", zone = "Undercity",
      location = "Trade Quarter", atLevel = 45, logCount = 11, x = 62.3, y = 48.6,
    },
    {
      type = "accept", questName = "Lines of Communication", zone = "Undercity",
      location = "The Magic Quarter", atLevel = 45, logCount = 12, x = 73.1, y = 32.8,
    },
    {
      type = "travel", name = "Undercity to Tarren Mill", zone = "Undercity",
      location = "Trade Quarter", atLevel = 45, logCount = 12, x = 63.2, y = 48.6,
      note = "Take the flight path.",
    },
    {
      type = "manual", name = "Razorbeak: Long Elegant Feather x10", zone = "The Hinterlands",
      atLevel = 45, logCount = 12, x = 17.0, y = 53.0, approx = true,
      note = "Start collecting this now - it drops over the whole leg, not in one spot.",
    },
    {
      type = "turnin", name = "Ripple Recovery (part 2)", questName = "Ripple Recovery",
      ambiguous = true, zone = "The Hinterlands", location = "Shindigger's Camp", atLevel = 45,
      logCount = 11, x = 26.7, y = 48.6,
    },
    {
      type = "accept", questName = "A Sticky Situation", zone = "The Hinterlands",
      location = "Shindigger's Camp", atLevel = 45, logCount = 12, x = 26.7, y = 48.6,
    },
    {
      type = "accept", questName = "Venom Bottles", zone = "The Hinterlands",
      location = "Zun'watha", atLevel = 45, logCount = 13,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Grim Message", zone = "The Hinterlands",
      location = "Zun'watha", atLevel = 45, logCount = 13, x = 23.0, y = 58.0, approx = true,
    },
    {
      type = "complete", questName = "Testing the Vessel", zone = "The Hinterlands",
      atLevel = 45, logCount = 13, x = 38.0, y = 54.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Natural Materials", zone = "The Hinterlands",
      atLevel = 45, logCount = 13, x = 38.0, y = 54.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", questName = "Vilebranch Hooligans", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 45, logCount = 14, x = 77.5, y = 80.4,
    },
    {
      type = "accept", questName = "Cannibalistic Cousins", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 45, logCount = 15, x = 78.8, y = 78.2,
    },
    {
      type = "accept", questName = "Message to the Wildhammer", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 45, logCount = 16, x = 79.4, y = 79.1,
    },
    {
      type = "accept", questName = "Stalking the Stalkers", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 45, logCount = 17, x = 79.2, y = 79.5,
    },
    {
      type = "accept", questName = "Hunt the Savages", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 45, logCount = 18, x = 79.2, y = 79.5,
    },
    {
      type = "accept", questName = "Avenging the Fallen", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 45, logCount = 19, x = 79.2, y = 79.5,
    },
    {
      type = "note", name = "Skip for now: 3 quests here",
      note = "Do not pick up yet - the route comes back for Lard Lost His Lunch, Snapjaws, Mon!, Gammerita, Mon! on a later pass.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 45, x = 78.1,
      y = 81.4,
    },
    {
      type = "travel", name = "Gorkas <Wind Rider Master>", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 45, logCount = 19, x = 81.7, y = 81.8,
      note = "Talk to the flight master and learn this flight point.",
    },
    {
      type = "travel", name = "Revantusk Village to Tarren Mill", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 45, logCount = 19, x = 81.7, y = 81.8,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Venom Bottles", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 45, logCount = 18, x = 61.4, y = 19.1,
    },
    {
      type = "accept", questName = "Undamaged Venom Sac", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 45, logCount = 19, x = 61.4, y = 19.1,
    },
    {
      type = "travel", name = "Tarren Mill to Revantusk Village", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 45, logCount = 19, x = 60.2, y = 18.6,
      note = "Take the flight path.",
    },
    {
      type = "complete", questName = "Avenging the Fallen", zone = "The Hinterlands",
      atLevel = 45, logCount = 19,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "complete", questName = "Vilebranch Hooligans", zone = "The Hinterlands",
      location = "Agol'watha", atLevel = 45, logCount = 19,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Cannibalistic Cousins", zone = "The Hinterlands",
      location = "Shaol'watha", atLevel = 45, logCount = 19, x = 70.0, y = 48.0, approx = true,
    },
    {
      type = "complete", questName = "Stalking the Stalkers", zone = "The Hinterlands",
      atLevel = 45, logCount = 19, x = 61.0, y = 46.0, approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Testing the Vessel", zone = "The Hinterlands",
      atLevel = 45, logCount = 19, x = 61.0, y = 46.0, approx = true,
    },
    {
      type = "complete", questName = "Hunt the Savages", zone = "The Hinterlands",
      atLevel = 45, logCount = 19, x = 61.0, y = 46.0, approx = true,
    },
    {
      type = "complete", questName = "Stalking the Stalkers", zone = "The Hinterlands",
      atLevel = 45, logCount = 19, x = 40.0, y = 46.0, approx = true,
    },
    {
      type = "complete", questName = "A Sticky Situation", zone = "The Hinterlands",
      location = "Skulk Rock", atLevel = 45, logCount = 19, x = 58.0, y = 39.0, approx = true,
    },
    {
      type = "accept", questName = "Find OOX-09/HL!", zone = "The Hinterlands",
      location = "Agol'watha", atLevel = 45, logCount = 20,
      note = "Starts from an item you loot here, not from an NPC. Zone-wide objective. No single spot to run to.",
    },
    {
      type = "note", name = "Note",
      note = "If you have not found the OOX-09/HL Distress Beacon yet, you can do this quest on the way back to Revantusk.",
      atLevel = 45,
    },
    {
      type = "turnin", questName = "Find OOX-09/HL!", zone = "The Hinterlands",
      location = "Agol'watha", atLevel = 45, logCount = 19, x = 49.4, y = 37.7,
    },
    {
      type = "note", name = "Skip: R",
      note = "The route deliberately skips Rescue OOX-09/HL!. Low XP for the travel time.",
      zone = "The Hinterlands", location = "Agol'watha", atLevel = 45, x = 49.4, y = 37.7,
    },
    {
      type = "complete", questName = "Message to the Wildhammer", zone = "The Hinterlands",
      location = "Quel'Danil Lodge", atLevel = 45, logCount = 19, x = 31.0, y = 49.0,
      approx = true,
    },
    {
      type = "complete", questName = "Lines of Communication", zone = "The Hinterlands",
      location = "Quel'Danil Lodge", atLevel = 45, logCount = 19,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "accept", questName = "Rin'ji is Trapped!", zone = "The Hinterlands",
      location = "Quel'Danil Lodge", atLevel = 45, logCount = 20, x = 30.7, y = 46.9,
    },
    {
      type = "complete", questName = "Rin'ji is Trapped!", zone = "The Hinterlands",
      location = "Quel'Danil Lodge", atLevel = 45, logCount = 20, x = 31.0, y = 49.0,
      approx = true,
    },
    {
      type = "turnin", questName = "A Sticky Situation", zone = "The Hinterlands",
      location = "Shindigger's Camp", atLevel = 45, logCount = 19, x = 26.7, y = 48.6,
    },
    {
      type = "accept", questName = "Ripple Delivery", zone = "The Hinterlands",
      location = "Shindigger's Camp", atLevel = 45, logCount = 20, x = 26.7, y = 48.6,
    },
    {
      type = "turnin", questName = "The Atal'ai Exile", zone = "The Hinterlands",
      location = "Shadra'alor", atLevel = 45, logCount = 19, x = 33.8, y = 75.2,
    },
    {
      type = "accept", questName = "Return to Fel'Zerul", zone = "The Hinterlands",
      location = "Shadra'alor", atLevel = 45, logCount = 20, x = 33.8, y = 75.2,
    },
    {
      type = "note", name = "Skip: J",
      note = "The route deliberately skips Jammal'an the Prophet. Low XP for the travel time.",
      zone = "The Hinterlands", location = "Shadra'alor", atLevel = 45, x = 33.8, y = 75.2,
    },
    {
      type = "complete", questName = "Undamaged Venom Sac", zone = "The Hinterlands",
      location = "Shadra'alor", atLevel = 45, logCount = 20, x = 36.0, y = 65.0, approx = true,
    },
    {
      type = "turnin", questName = "Rin'ji is Trapped!", zone = "The Hinterlands",
      location = "The Overlook Cliffs", atLevel = 46, logCount = 19, x = 86.3, y = 59.0,
    },
    {
      type = "accept", questName = "Rin'ji's Secret", zone = "The Hinterlands",
      location = "The Overlook Cliffs", atLevel = 46, logCount = 20, x = 86.3, y = 59.0,
    },
    {
      type = "turnin", questName = "Vilebranch Hooligans", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 46, logCount = 19, x = 77.5, y = 80.4,
    },
    {
      type = "turnin", questName = "Cannibalistic Cousins", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 46, logCount = 18, x = 78.8, y = 78.2,
    },
    {
      type = "note", name = "Skip: 2 quests here",
      note = "The route deliberately skips Wanted: Vile Priestess Hexx and Her Minions, Job Opening: Guard Captain of Revantusk Village. Low XP for the travel time.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 46, x = 79.1,
      y = 79.0,
    },
    {
      type = "turnin", questName = "Message to the Wildhammer", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 46, logCount = 17, x = 79.4, y = 79.1,
    },
    {
      type = "accept", questName = "Another Message to the Wildhammer",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 46, logCount = 18,
      x = 79.4, y = 79.1,
    },
    {
      type = "turnin", questName = "Stalking the Stalkers", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 46, logCount = 17, x = 79.2, y = 79.5,
    },
    {
      type = "turnin", questName = "Hunt the Savages", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 46, logCount = 16, x = 79.2, y = 79.5,
    },
    {
      type = "turnin", questName = "Avenging the Fallen", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 46, logCount = 15, x = 79.2, y = 79.5,
    },
    {
      type = "note", name = "Skip: 3 quests here",
      note = "The route deliberately skips Separation Anxiety, Dark Vessels, Kidnapped Elder Torntusk!. Low XP for the travel time.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 46, x = 79.2,
      y = 79.5,
    },
    {
      type = "travel", name = "Revantusk Village to Hammerfall", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 46, logCount = 15, x = 81.7, y = 81.8,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Horde Trauma", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 46, logCount = 14, x = 73.4, y = 36.9,
    },
    {
      type = "accept", questName = "Triage", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 46, logCount = 15, x = 73.4, y = 36.9,
    },
    {
      type = "complete", questName = "Triage", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 46, logCount = 15, x = 73.0, y = 37.0, approx = true,
    },
    {
      type = "turnin", questName = "Triage", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 46, logCount = 14, x = 73.4, y = 36.9,
    },
    {
      type = "travel", name = "Hammerfall to Tarren Mill", zone = "Arathi Highlands",
      location = "Hammerfall", atLevel = 46, logCount = 14, x = 73.1, y = 32.7,
      note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Undamaged Venom Sac", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 46, logCount = 13, x = 61.4, y = 19.1,
    },
    {
      type = "accept", questName = "Consult Master Gadrin", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 46, logCount = 14, x = 61.4, y = 19.1,
    },
    {
      type = "travel", name = "Tarren Mill to Undercity", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", atLevel = 46, logCount = 14, x = 60.2, y = 18.6,
      note = "Take the flight path.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Undercity", atLevel = 46,
      logCount = 14, note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "Lines of Communication", zone = "Undercity",
      location = "The Magic Quarter", atLevel = 46, logCount = 13, x = 73.1, y = 32.8,
    },
    {
      type = "turnin", questName = "Rin'ji's Secret", zone = "Undercity",
      location = "The Magic Quarter", atLevel = 46, logCount = 12, x = 86.3, y = 59.0,
    },
    {
      type = "accept", questName = "Oran's Gratitude", zone = "Undercity",
      location = "The Magic Quarter", atLevel = 46, logCount = 13, x = 73.1, y = 32.8,
    },
    {
      type = "turnin", questName = "Oran's Gratitude", zone = "Undercity",
      location = "The Magic Quarter", atLevel = 46, logCount = 12, x = 73.1, y = 32.8,
    },
    {
      type = "travel", name = "Tirisfal Glades to Grom'gol Base Camp",
      zone = "Tirisfal Glades", location = "Brill", atLevel = 46, logCount = 12, x = 61.9,
      y = 59.1, note = "Zeppelin.",
    },
    {
      type = "turnin", questName = "Grim Message", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 46, logCount = 11, x = 32.2, y = 27.7,
    },
    {
      type = "travel", name = "Grom'gol Base Camp to Kargath", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", atLevel = 46, logCount = 11, x = 32.5, y = 29.4,
      note = "Take the flight path.",
    },
})

-- Chapter 51: Hinterlands East
Leg(33, "The Hinterlands", {

    { type = "section", name = "Chapter 51: Hinterlands East", levels = { 49, 49 }, zone = "The Hinterlands" },
    {
      type = "turnin", questName = "The Gordunni Orb", zone = "Orgrimmar",
      location = "The Valley of Spirits", atLevel = 49, logCount = 12, x = 39.2, y = 86.3,
    },
    {
      type = "turnin", questName = "Zukk'ash Report", zone = "Orgrimmar",
      location = "The Drag", atLevel = 49, logCount = 11, x = 56.3, y = 46.7,
    },
    {
      type = "turnin", questName = "Rise of the Silithid", zone = "Orgrimmar",
      location = "The Drag", atLevel = 49, logCount = 10, x = 56.3, y = 46.7,
    },
    {
      type = "turnin", questName = "Ripple Delivery", zone = "Orgrimmar",
      location = "The Drag", atLevel = 49, logCount = 9, x = 59.5, y = 36.6,
    },
    {
      type = "accept", questName = "Bone-Bladed Weapons", zone = "Orgrimmar",
      location = "The Drag", atLevel = 49, logCount = 10, x = 55.5, y = 34.1,
    },
    {
      type = "turnin", name = "A Grim Discovery (part 2)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Honor", atLevel = 49,
      logCount = 9, x = 75.2, y = 34.2,
    },
    {
      type = "accept", name = "Betrayed (part 1)", questName = "Betrayed", ambiguous = true,
      zone = "Orgrimmar", location = "The Valley of Honor", atLevel = 49, logCount = 10,
      x = 75.2, y = 34.2,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 49,
      logCount = 10, note = "Several spots around here - check the whole area.",
    },
    {
      type = "hearth", name = "Set Hearth to Orgrimmar", zone = "Orgrimmar", atLevel = 49,
      logCount = 10, x = 54.1, y = 68.4, note = "Bind your hearthstone here.",
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 49, logCount = 10, x = 50.8, y = 13.9,
      note = "Zeppelin.",
    },
    {
      type = "turnin", questName = "Return to Apothecary Zinge", zone = "Undercity",
      location = "The Apothecarium", atLevel = 49, logCount = 9, x = 50.2, y = 68.0,
    },
    {
      type = "accept", name = "Seeping Corruption (part 1)", questName = "Seeping Corruption",
      ambiguous = true, zone = "Undercity", location = "The Apothecarium", atLevel = 49,
      logCount = 10, x = 48.7, y = 71.4,
    },
    {
      type = "accept", questName = "A Sample of Slime...", zone = "Undercity",
      location = "The Apothecarium", atLevel = 49, logCount = 11, x = 47.5, y = 73.3,
    },
    {
      type = "accept", questName = "... and a Batch of Ooze", zone = "Undercity",
      location = "The Apothecarium", atLevel = 49, logCount = 12, x = 47.5, y = 73.3,
    },
    {
      type = "travel", name = "Undercity to Revantusk Village", zone = "Undercity",
      location = "The Trade Quarter", atLevel = 49, logCount = 12, x = 63.2, y = 48.6,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Snapjaws, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 13, x = 80.3, y = 81.5,
    },
    {
      type = "accept", questName = "Gammerita, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 14, x = 80.3, y = 81.5,
    },
    {
      type = "accept", questName = "Lard Lost His Lunch", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 15, x = 78.1, y = 81.4,
    },
    {
      type = "note", name = "Skip: 3 quests here",
      note = "The route deliberately skips Dark Vessels, Kidnapped Elder Torntusk!, Separation Anxiety. Low XP for the travel time.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, x = 78.2,
      y = 81.2,
    },
    {
      type = "turnin", questName = "Another Message to the Wildhammer",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, logCount = 14,
      x = 79.4, y = 79.1,
    },
    {
      type = "accept", questName = "The Final Message to the Wildhammer",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, logCount = 15,
      x = 79.4, y = 79.1,
    },
    {
      type = "note", name = "Skip: 2 quests here",
      note = "The route deliberately skips Wanted: Vile Priestess Hexx and Her Minions, Job Opening: Guard Captain of Revantusk Village. Low XP for the travel time.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, x = 79.1,
      y = 79.0,
    },
    {
      type = "complete", questName = "Whiskey Slim's Lost Grog", zone = "The Hinterlands",
      location = "The Overlook Cliffs", atLevel = 49, logCount = 15, x = 78.0, y = 60.0,
      approx = true,
    },
    {
      type = "complete", questName = "Snapjaws, Mon!", zone = "The Hinterlands",
      location = "The Overlook Cliffs", atLevel = 49, logCount = 15, x = 78.0, y = 60.0,
      approx = true,
    },
    {
      type = "complete", questName = "Gammerita, Mon!", zone = "The Hinterlands",
      location = "The Overlook Cliffs", atLevel = 49, logCount = 15, x = 78.0, y = 60.0,
      approx = true,
    },
    {
      type = "turnin", name = "Cortello's Riddle (part 3)", questName = "Cortello's Riddle",
      ambiguous = true, zone = "The Hinterlands", location = "The Overlook Cliffs",
      atLevel = 49, logCount = 14, x = 80.8, y = 46.8,
    },
    {
      type = "complete", questName = "Lard Lost His Lunch", zone = "The Hinterlands",
      location = "The Overlook Cliffs", atLevel = 49, logCount = 14, x = 84.5, y = 41.2,
    },
    {
      type = "complete", questName = "Dark Vessels", zone = "The Hinterlands",
      location = "Jintha'Alor", atLevel = 49, logCount = 14, x = 63.0, y = 73.0, approx = true,
    },
    {
      type = "complete", questName = "Separation Anxiety", zone = "The Hinterlands",
      location = "Jintha'Alor", atLevel = 49, logCount = 14,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "Job Opening: Guard Captain of Revantusk Village",
      zone = "The Hinterlands", location = "Jintha'Alor", atLevel = 49, logCount = 14,
      x = 63.0, y = 73.0, approx = true,
    },
    {
      type = "accept", name = "Kidnapped Elder Torntusk!",
      questName = "Kidnapped Elder Torntusk!",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Hinterlands", location = "Jintha'Alor", atLevel = 49, x = 59.7, y = 77.8,
    },
    {
      type = "turnin", questName = "Kidnapped Elder Torntusk!", zone = "The Hinterlands",
      location = "Jintha'Alor", atLevel = 49, logCount = 14, x = 59.7, y = 77.8,
    },
    {
      type = "note", name = "Skip: R",
      note = "The route deliberately skips Recover the Key!. Low XP for the travel time.",
      zone = "The Hinterlands", location = "Jintha'Alor", atLevel = 49, x = 59.7, y = 77.8,
    },
    {
      type = "complete", questName = "Wanted: Vile Priestess Hexx and Her Minions",
      zone = "The Hinterlands", location = "Jintha'Alor", atLevel = 49, logCount = 14,
      x = 59.0, y = 79.0, approx = true,
    },
    {
      type = "complete", questName = "Recover the Key!", zone = "The Hinterlands",
      location = "Jintha'Alor", atLevel = 49, logCount = 14, x = 57.5, y = 86.5, approx = true,
    },
    {
      type = "accept", name = "Recover the Key!", questName = "Recover the Key!",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Hinterlands", location = "Jintha'Alor", atLevel = 49, x = 59.7, y = 77.8,
    },
    {
      type = "turnin", questName = "Recover the Key!", zone = "The Hinterlands",
      location = "Jintha'Alor", atLevel = 49, logCount = 14, x = 59.7, y = 77.8,
    },
    {
      type = "note", name = "Skip: R",
      note = "The route deliberately skips Return to Primal Torntusk. Low XP for the travel time.",
      zone = "The Hinterlands", location = "Jintha'Alor", atLevel = 49, x = 59.7, y = 77.8,
    },
    {
      type = "complete", questName = "Sprinkle's Secret Ingredient", zone = "The Hinterlands",
      location = "Valorwind Lake", atLevel = 49, logCount = 14, x = 41.0, y = 60.0,
      approx = true,
    },
    {
      type = "complete", questName = "The Final Message to the Wildhammer",
      zone = "The Hinterlands", location = "Aerie Peak", atLevel = 49, logCount = 14, x = 14.0,
      y = 48.0, approx = true,
    },
    {
      type = "turnin", questName = "The Final Message to the Wildhammer",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, logCount = 13,
      x = 79.4, y = 79.1,
    },
    {
      type = "accept", name = "Separation Anxiety", questName = "Separation Anxiety",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, x = 79.2,
      y = 79.5,
    },
    {
      type = "turnin", questName = "Separation Anxiety", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 13, x = 79.2, y = 79.5,
    },
    {
      type = "turnin", questName = "Lard Lost His Lunch", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 12, x = 78.1, y = 81.4,
    },
    {
      type = "accept", name = "Return to Primal Torntusk",
      questName = "Return to Primal Torntusk",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, x = 78.2,
      y = 81.2,
    },
    {
      type = "turnin", questName = "Return to Primal Torntusk", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 12, x = 78.2, y = 81.2,
    },
    {
      type = "accept", name = "Wanted: Vile Priestess Hexx and Her Minions",
      questName = "Wanted: Vile Priestess Hexx and Her Minions",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, x = 78.2,
      y = 81.2,
    },
    {
      type = "turnin", questName = "Wanted: Vile Priestess Hexx and Her Minions",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, logCount = 12,
      x = 78.2, y = 81.2,
    },
    {
      type = "accept", name = "Job Opening: Guard Captain of Revantusk Village",
      questName = "Job Opening: Guard Captain of Revantusk Village",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, x = 78.2,
      y = 81.2,
    },
    {
      type = "turnin", questName = "Job Opening: Guard Captain of Revantusk Village",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, logCount = 12,
      x = 78.2, y = 81.2,
    },
    {
      type = "accept", name = "Dark Vessels", questName = "Dark Vessels",
      note = "Offered by the same NPC the moment you hand in the previous link of this chain. Not listed as a pickup in the source sheet.",
      zone = "The Hinterlands", location = "Revantusk Village", atLevel = 49, x = 78.2,
      y = 81.2,
    },
    {
      type = "turnin", questName = "Dark Vessels", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 12, x = 78.2, y = 81.2,
    },
    {
      type = "turnin", questName = "Snapjaws, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 11, x = 80.3, y = 81.5,
    },
    {
      type = "turnin", questName = "Gammerita, Mon!", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 10, x = 80.3, y = 81.5,
    },
    {
      type = "hearth", name = "Hearth to Orgrimmar", zone = "The Hinterlands",
      location = "Revantusk Village", atLevel = 49, logCount = 10, x = 80.3, y = 81.5,
      note = "Use your hearthstone.",
    },
})

