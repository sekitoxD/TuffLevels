-- TuFFlevels / Routes/Horde/Solo/Durotar.lua
--
-- Durotar leg(s) of the solo Orc/Troll 1-60 route. Levels 1-12.
-- The route visits this zone 1 time(s); each visit is one Leg() call below
-- and the leg number is its position in the full route, not in this file.
--
-- Generated from the source spreadsheet. Corrections applied during conversion
-- are listed in plans/04-sheet-audit.md - edit them HERE, not in the sheet.
--
-- The Rogue class-quest chain (Gornek -> Rwag, quest 3083/3088, Backstab
-- training) was hand-added afterward from RXPGuides' Classic-Horde
-- guide (facts only - quest IDs/coords/NPC names, not their wording) to
-- close a gap the source spreadsheet's class-agnostic "Class Trainer -
-- check the whole area" placeholder left for Rogues specifically. Unlike
-- Routes/Alliance/*.lua, this is a normal hand-authored addition, not a
-- bulk conversion, so it carries this file's regular MIT license.
--
-- Gated to Orc/Troll (see the Leg() opts below): Valley of Trials and its
-- follow-on quests are race-locked in-game and Undead/Tauren can never
-- accept them. Undead reach this route from Routes/Horde/TirisfalStart.lua
-- at ~level 15 via the Undercity zeppelin, never through Durotar, so this
-- whole leg would otherwise softlock their auto-advance on an
-- unacceptable quest.

local ADDON, ns = ...
local Leg = ns.SoloLeg

-- Chapter 1: Valley of Trials | Chapter 2: Sen'jin Village to Tiragarde Keep | Chapter 3: Scuttle Coast to Echo Isles | Chapter 4: Upper Durotar | Chapter 5: Skull Rock
Leg(1, "Durotar", {

    { type = "section", name = "Chapter 1: Valley of Trials", levels = { 1, 5 }, zone = "Durotar" },
    {
      type = "accept", questName = "Your Place In The World", zone = "Durotar",
      location = "The Den", atLevel = 1, logCount = 1, x = 43.3, y = 68.9,
    },
    {
      type = "turnin", questName = "Your Place In The World", zone = "Durotar",
      location = "The Den", atLevel = 1, logCount = 0, x = 43.3, y = 68.6,
    },
    {
      type = "accept", questName = "Cutting Teeth", zone = "Durotar", location = "The Den",
      atLevel = 1, logCount = 1, x = 42.1, y = 68.3,
    },
    {
      type = "accept", name = "Sarkoth (part 1)", questName = "Sarkoth", ambiguous = true,
      zone = "Durotar", location = "Valley of Trials", atLevel = 1, logCount = 2, x = 40.6,
      y = 62.6,
    },
    {
      type = "complete", name = "Sarkoth (part 1)", questName = "Sarkoth", ambiguous = true,
      zone = "Durotar", location = "Valley of Trials", atLevel = 1, logCount = 2, x = 40.5,
      y = 66.8,
    },
    {
      type = "turnin", name = "Sarkoth (part 1)", questName = "Sarkoth", ambiguous = true,
      zone = "Durotar", location = "Valley of Trials", atLevel = 2, logCount = 1, x = 40.6,
      y = 62.6,
    },
    {
      type = "accept", name = "Sarkoth (part 2)", questName = "Sarkoth", ambiguous = true,
      zone = "Durotar", location = "Valley of Trials", atLevel = 2, logCount = 2, x = 40.6,
      y = 62.6,
    },
    {
      type = "complete", questName = "Cutting Teeth", zone = "Durotar",
      location = "Valley of Trials", atLevel = 2, logCount = 2, x = 44.0, y = 65.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Cutting Teeth", zone = "Durotar", location = "The Den",
      atLevel = 2, logCount = 1, x = 42.1, y = 68.3,
    },
    {
      type = "turnin", name = "Sarkoth (part 2)", questName = "Sarkoth", ambiguous = true,
      zone = "Durotar", location = "The Den", atLevel = 3, logCount = 0, x = 42.1, y = 68.3,
    },
    {
      type = "accept", questName = "Sting of the Scorpid", zone = "Durotar",
      location = "The Den", atLevel = 3, logCount = 1, x = 42.1, y = 68.3,
    },
    {
      -- Rogue class-quest chain (RXPGuides Classic-Horde-01-12_Durotar.lua):
      -- Gornek hands out a race-specific tablet/parchment quest per class,
      -- turned in at Rwag to unlock class trainer access - added
      -- 2026-09-20, see plans/architecture-ideas notes for why.
      type = "accept", name = "Accept Encrypted Tablet", npc = "Gornek", quest = 3083,
      zone = "Durotar", x = 42.06, y = 68.32, atLevel = 3,
      races = { "Troll" }, class = "ROGUE",
    },
    {
      type = "accept", name = "Accept Encrypted Parchment", npc = "Gornek", quest = 3088,
      zone = "Durotar", x = 42.06, y = 68.32, atLevel = 3,
      races = { "Orc" }, class = "ROGUE",
    },
    {
      type = "note", name = "Note",
      note = "Skip Sting of the Scorpid and Sarkoth on a fresh crowded server.", atLevel = 3,
    },
    {
      type = "accept", questName = "Galgar's Cactus Apple Surprise", zone = "Durotar",
      location = "The Den", atLevel = 3, logCount = 2, x = 42.7, y = 67.2,
    },
    {
      type = "turnin", name = "Turn in Encrypted Tablet", npc = "Rwag", quest = 3083,
      zone = "Durotar", x = 41.27, y = 68.00, atLevel = 3,
      races = { "Troll" }, class = "ROGUE",
    },
    {
      type = "turnin", name = "Turn in Encrypted Parchment", npc = "Rwag", quest = 3088,
      zone = "Durotar", x = 41.27, y = 68.00, atLevel = 3,
      races = { "Orc" }, class = "ROGUE",
    },
    {
      type = "trainer", name = "Train Backstab", npc = "Rwag", zone = "Durotar",
      x = 41.27, y = 68.00, atLevel = 3, note = "Train Backstab from Rwag.",
      class = "ROGUE",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Durotar", location = "The Den",
      atLevel = 3, logCount = 2, note = "Several spots around here - check the whole area.",
    },
    {
      type = "accept", questName = "Vile Familiars", zone = "Durotar", location = "The Den",
      atLevel = 3, logCount = 3, x = 42.9, y = 69.2,
    },
    {
      type = "accept", questName = "Lazy Peons", zone = "Durotar",
      location = "Valley of Trials", atLevel = 3, logCount = 4, x = 44.6, y = 68.7,
    },
    {
      type = "complete", questName = "Vile Familiars", zone = "Durotar",
      location = "Valley of Trials", atLevel = 3, logCount = 4, x = 45.0, y = 57.0,
      approx = true,
    },
    {
      type = "complete", questName = "Lazy Peons", zone = "Durotar",
      location = "Valley of Trials", atLevel = 3, logCount = 4, x = 42.0, y = 59.0,
      approx = true,
    },
    {
      type = "complete", questName = "Sting of the Scorpid", zone = "Durotar",
      location = "Valley of Trials", atLevel = 4, logCount = 4, x = 42.0, y = 59.0,
      approx = true,
    },
    {
      type = "complete", questName = "Galgar's Cactus Apple Surprise", zone = "Durotar",
      location = "Valley of Trials", atLevel = 4, logCount = 4, x = 42.0, y = 59.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Galgar's Cactus Apple Surprise", zone = "Durotar",
      location = "The Den", atLevel = 4, logCount = 3, x = 42.7, y = 67.2,
    },
    {
      type = "turnin", questName = "Sting of the Scorpid", zone = "Durotar",
      location = "The Den", atLevel = 4, logCount = 2, x = 42.1, y = 68.3,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Durotar", location = "The Den",
      atLevel = 4, logCount = 2, note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "Vile Familiars", zone = "Durotar", location = "The Den",
      atLevel = 4, logCount = 1, x = 42.9, y = 69.2,
    },
    {
      type = "accept", questName = "Burning Blade Medallion", zone = "Durotar",
      location = "The Den", atLevel = 4, logCount = 2, x = 42.9, y = 69.2,
    },
    {
      type = "turnin", questName = "Lazy Peons", zone = "Durotar",
      location = "Valley of Trials", atLevel = 4, logCount = 1, x = 44.6, y = 68.7,
    },
    {
      type = "accept", questName = "Thazz'ril's Pick", zone = "Durotar",
      location = "Valley of Trials", atLevel = 4, logCount = 2, x = 44.6, y = 68.7,
    },
    {
      type = "complete", questName = "Thazz'ril's Pick", zone = "Durotar",
      location = "Burning Blade Coven", atLevel = 5, logCount = 2, x = 43.7, y = 53.8,
    },
    {
      type = "complete", questName = "Burning Blade Medallion", zone = "Durotar",
      location = "Burning Blade Coven", atLevel = 5, logCount = 2, x = 42.7, y = 53.0,
    },
    {
      type = "death", name = "Burning Blade Coven to The Den", zone = "Durotar",
      location = "Burning Blade Coven", atLevel = 5, logCount = 2, x = 43.0, y = 53.0,
      approx = true,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "turnin", questName = "Burning Blade Medallion", zone = "Durotar",
      location = "The Den", atLevel = 5, logCount = 1, x = 42.9, y = 69.2,
    },
    {
      type = "accept", questName = "Report to Sen'jin Village", zone = "Durotar",
      location = "The Den", atLevel = 5, logCount = 2, x = 42.9, y = 69.2,
    },
    {
      type = "turnin", questName = "Thazz'ril's Pick", zone = "Durotar",
      location = "Valley of Trials", atLevel = 5, logCount = 1, x = 44.6, y = 68.7,
    },

    {
      type = "section", name = "Chapter 2: Sen'jin Village to Tiragarde Keep",
      levels = { 5, 7 }, zone = "Durotar",
    },
    {
      type = "accept", questName = "Practical Prey", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 5, logCount = 2, x = 56.0, y = 73.9,
    },
    {
      type = "accept", questName = "A Solvent Spirit", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 5, logCount = 3, x = 55.9, y = 74.4,
    },
    {
      type = "turnin", questName = "Report to Sen'jin Village", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 5, logCount = 2, x = 55.9, y = 74.7,
    },
    {
      type = "accept", questName = "Report to Orgnil", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 5, logCount = 3, x = 55.9, y = 74.7,
    },
    {
      type = "accept", questName = "Minshina's Skull", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 5, logCount = 4, x = 55.9, y = 74.7,
    },
    {
      type = "accept", questName = "Zalazane", zone = "Durotar", location = "Sen'jin Village",
      atLevel = 5, logCount = 5, x = 55.9, y = 74.7,
    },
    {
      type = "accept", questName = "Thwarting Kolkar Aggression", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 5, logCount = 6,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "complete", questName = "Thwarting Kolkar Aggression", zone = "Durotar",
      location = "Kolkar Crag", atLevel = 6, logCount = 6,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", questName = "Thwarting Kolkar Aggression", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 6, logCount = 5,
      note = "This NPC patrols. Look along the road, not at one point.",
    },
    {
      type = "note", name = "Note",
      note = "If Thwarting Kolkar Aggression is too difficult at Lvl 6, do after Echo Isles quests.",
      atLevel = 6,
    },
    {
      type = "accept", questName = "A Peon's Burden", zone = "Durotar",
      location = "East of Valley of Trials", atLevel = 6, logCount = 6, x = 52.1, y = 68.3,
    },
    {
      type = "accept", questName = "Carry Your Weight", zone = "Durotar",
      location = "Razor Hill", atLevel = 6, logCount = 7, x = 49.9, y = 40.4,
    },
    {
      type = "accept", questName = "Break a Few Eggs", zone = "Durotar",
      location = "Razor Hill", atLevel = 6, logCount = 8, x = 51.1, y = 42.4,
    },
    {
      type = "turnin", questName = "A Peon's Burden", zone = "Durotar",
      location = "Razor Hill", atLevel = 6, logCount = 7, x = 51.5, y = 41.6,
    },
    {
      type = "hearth", name = "Set Hearth to Razor Hill", zone = "Durotar",
      location = "Razor Hill", atLevel = 6, logCount = 7, x = 51.5, y = 41.6,
      note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Vanquish the Betrayers", zone = "Durotar",
      location = "Razor Hill", atLevel = 6, logCount = 8, x = 52.0, y = 43.5,
    },
    {
      type = "accept", questName = "Encroachment", zone = "Durotar", location = "Razor Hill",
      atLevel = 6, logCount = 9, x = 52.0, y = 43.5,
    },
    {
      type = "turnin", questName = "Report to Orgnil", zone = "Durotar",
      location = "Razor Hill", atLevel = 6, logCount = 8, x = 52.2, y = 43.2,
    },
    {
      type = "accept", questName = "Dark Storms", zone = "Durotar", location = "Razor Hill",
      atLevel = 6, logCount = 9, x = 52.2, y = 43.2,
    },
    {
      type = "complete", questName = "Encroachment", zone = "Durotar",
      location = "Razormane Grounds", atLevel = 7, logCount = 9, x = 50.0, y = 50.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Vanquish the Betrayers", zone = "Durotar",
      location = "Tiragarde Keep", atLevel = 7, logCount = 9, x = 59.7, y = 58.3,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", name = "The Admiral's Orders (part 1)",
      questName = "The Admiral's Orders", ambiguous = true, zone = "Durotar",
      location = "Tiragarde Keep", atLevel = 7, logCount = 10, x = 59.3, y = 57.6,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", questName = "Carry Your Weight", zone = "Durotar",
      location = "Tiragarde Keep", atLevel = 7, logCount = 10, x = 59.0, y = 57.0,
      approx = true,
    },
    {
      type = "complete", questName = "Vanquish the Betrayers", zone = "Durotar",
      location = "Tiragarde Keep", atLevel = 7, logCount = 10, x = 59.0, y = 57.0,
      approx = true,
    },
    {
      type = "note", name = "Note",
      note = "Kill until 3250/4500 xp into Lvl 7 if you need Lvl 8 skills going into Echo Isles quests.",
      atLevel = 7,
    },
    {
      type = "death", name = "Tiragarde Keep to Razor Hill", zone = "Durotar",
      location = "Tiragarde Keep", atLevel = 7, logCount = 10, x = 59.0, y = 57.0,
      approx = true,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },

    { type = "section", name = "Chapter 3: Scuttle Coast to Echo Isles", levels = { 7, 8 }, zone = "Durotar" },
    {
      type = "turnin", name = "The Admiral's Orders (part 1)",
      questName = "The Admiral's Orders", ambiguous = true, zone = "Durotar",
      location = "Razor Hill", atLevel = 7, logCount = 9, x = 52.0, y = 43.5,
    },
    {
      type = "accept", name = "The Admiral's Orders (part 2)",
      questName = "The Admiral's Orders", ambiguous = true, zone = "Durotar",
      location = "Razor Hill", atLevel = 7, logCount = 10, x = 52.0, y = 43.5,
    },
    {
      type = "turnin", questName = "Vanquish the Betrayers", zone = "Durotar",
      location = "Razor Hill", atLevel = 7, logCount = 9, x = 52.0, y = 43.5,
    },
    {
      type = "accept", questName = "From The Wreckage...", zone = "Durotar",
      location = "Razor Hill", atLevel = 7, logCount = 10, x = 52.0, y = 43.5,
    },
    {
      type = "note", name = "Note",
      note = "Turn in Carry Your Weight if you did not get a bag drop.", atLevel = 7,
    },
    {
      type = "trainer", name = "First Aid Trainer", zone = "Durotar", location = "Razor Hill",
      atLevel = 7, logCount = 10, x = 54.2, y = 41.9,
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Durotar", location = "Razor Hill",
      atLevel = 7, logCount = 10, note = "Several spots around here - check the whole area.",
    },
    {
      type = "complete", questName = "From The Wreckage...", zone = "Durotar",
      location = "Scuttle Coast", atLevel = 7, logCount = 10, x = 63.0, y = 55.0,
      approx = true,
    },
    {
      type = "complete", questName = "A Solvent Spirit", zone = "Durotar",
      location = "Scuttle Coast", atLevel = 7, logCount = 10, x = 63.0, y = 55.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Practical Prey", zone = "Durotar",
      location = "Echo Isles", atLevel = 8, logCount = 10, x = 69.0, y = 72.0, approx = true,
    },
    {
      type = "complete", questName = "Break a Few Eggs", zone = "Durotar",
      location = "Echo Isles", atLevel = 8, logCount = 10, x = 69.0, y = 72.0, approx = true,
    },
    {
      type = "complete", questName = "Minshina's Skull", zone = "Durotar",
      location = "Echo Isles", atLevel = 8, logCount = 10, x = 67.4, y = 87.8,
    },
    {
      type = "complete", questName = "Zalazane", zone = "Durotar", location = "Echo Isles",
      atLevel = 8, logCount = 10, x = 67.0, y = 87.0, approx = true,
    },
    {
      type = "complete", questName = "A Solvent Spirit", zone = "Durotar",
      location = "Scuttle Coast", atLevel = 8, logCount = 10, x = 67.0, y = 78.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Minshina's Skull", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 8, logCount = 9, x = 55.9, y = 74.7,
    },
    {
      type = "turnin", questName = "Zalazane", zone = "Durotar", location = "Sen'jin Village",
      atLevel = 8, logCount = 8, x = 55.9, y = 74.7,
    },
    {
      type = "turnin", questName = "A Solvent Spirit", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 8, logCount = 7, x = 55.9, y = 74.4,
    },
    {
      type = "turnin", questName = "Practical Prey", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 8, logCount = 6, x = 56.0, y = 73.9,
    },
    {
      type = "hearth", name = "Hearth to Razor Hill", zone = "Durotar",
      location = "Sen'jin Village", atLevel = 8, logCount = 6, x = 55.6, y = 73.6,
      note = "Use your hearthstone.",
    },

    { type = "section", name = "Chapter 4: Upper Durotar", levels = { 9, 10 }, zone = "Durotar" },
    {
      type = "turnin", questName = "From The Wreckage...", zone = "Durotar",
      location = "Razor Hill", atLevel = 9, logCount = 5, x = 52.0, y = 43.5,
    },
    {
      type = "turnin", questName = "Break a Few Eggs", zone = "Durotar",
      location = "Razor Hill", atLevel = 9, logCount = 4, x = 51.1, y = 42.4,
    },
    {
      type = "turnin", questName = "Carry Your Weight", zone = "Durotar",
      location = "Razor Hill", atLevel = 9, logCount = 3, x = 49.9, y = 40.4,
    },
    {
      type = "accept", questName = "Lost But Not Forgotten", zone = "Durotar",
      location = "Tor'kren Farm", atLevel = 9, logCount = 4, x = 43.1, y = 30.2,
    },
    {
      type = "accept", questName = "Winds in the Desert", zone = "Durotar",
      location = "North Durotar", atLevel = 9, logCount = 5, x = 46.4, y = 23.0,
    },
    {
      type = "complete", questName = "Winds in the Desert", zone = "Durotar",
      location = "Razorwind Canyon", atLevel = 9, logCount = 5, x = 50.0, y = 25.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Winds in the Desert", zone = "Durotar",
      location = "North Durotar", atLevel = 9, logCount = 4, x = 46.4, y = 23.0,
    },
    {
      type = "accept", questName = "Securing the Lines", zone = "Durotar",
      location = "North Durotar", atLevel = 9, logCount = 5, x = 46.4, y = 23.0,
    },
    {
      type = "complete", questName = "Securing the Lines", zone = "Durotar",
      location = "Drygulch Ravine", atLevel = 9, logCount = 5, x = 54.0, y = 27.0,
      approx = true,
    },
    {
      type = "death", name = "Drygulch Ravine to Jaggedswine Farm", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 9, logCount = 5, x = 54.0, y = 27.0,
      approx = true,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "turnin", questName = "Securing the Lines", zone = "Durotar",
      location = "North Durotar", atLevel = 10, logCount = 4, x = 46.4, y = 23.0,
    },
    {
      type = "accept", questName = "Need for a Cure", zone = "Durotar",
      location = "Rocktusk Farm", atLevel = 10, logCount = 5, x = 41.5, y = 18.6,
    },
    {
      type = "complete", questName = "Dark Storms", zone = "Durotar",
      location = "Thunder Ridge", atLevel = 10, logCount = 5, x = 42.0, y = 26.5,
      approx = true,
    },
    {
      type = "death", name = "Thunder Ridge to Jaggedswine Farm", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 10, logCount = 5, x = 42.0, y = 26.5,
      approx = true,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "hearth", name = "Set Hearth to Orgrimmar", zone = "Orgrimmar",
      location = "The Valley of Strength", atLevel = 10, logCount = 5, x = 54.1, y = 68.4,
      note = "Bind your hearthstone here.",
    },
    {
      type = "trainer", name = "Class Trainer", zone = "Orgrimmar", atLevel = 10, logCount = 5,
      note = "Several spots around here - check the whole area.",
    },
    {
      type = "turnin", name = "The Admiral's Orders (part 2)",
      questName = "The Admiral's Orders", ambiguous = true, zone = "Orgrimmar",
      location = "The Valley of Wisdom", atLevel = 10, logCount = 4, x = 31.8, y = 37.8,
    },
    {
      type = "accept", name = "Hidden Enemies (part 1)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", atLevel = 10,
      logCount = 5, x = 31.8, y = 37.8,
    },
    {
      type = "accept", questName = "Finding the Antidote", zone = "Orgrimmar",
      location = "The Cleft of Shadow", atLevel = 10, logCount = 6, x = 47.2, y = 53.6,
    },
    {
      type = "note", optional = true, name = "Skip: S",
      note = "The route deliberately skips Slaying the Beast. Low XP for the travel time.",
      zone = "Orgrimmar", location = "The Cleft of Shadow", atLevel = 10, x = 49.5, y = 50.6,
    },
    {
      type = "death", name = "Ragefire Chasm to Jaggedswine Farm", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 10, logCount = 6, x = 52.8, y = 49.0,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "complete", questName = "Finding the Antidote", zone = "Durotar",
      location = "Eastern Durotar", atLevel = 10, logCount = 6, x = 40.0, y = 18.0,
      approx = true,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Lost But Not Forgotten", zone = "Durotar",
      location = "Southfury River", atLevel = 10, logCount = 6, x = 35.0, y = 28.0,
      approx = true,
    },
    {
      type = "complete", questName = "Encroachment", zone = "Durotar",
      location = "Razormane Grounds", atLevel = 10, logCount = 6, x = 43.0, y = 39.0,
      approx = true,
    },

    { type = "section", name = "Chapter 5: Skull Rock", levels = { 10, 12 }, zone = "Durotar" },
    {
      type = "accept", questName = "Conscript of the Horde", zone = "Durotar",
      location = "Razor Hill", atLevel = 10, logCount = 7, x = 50.8, y = 43.6,
    },
    {
      type = "turnin", questName = "Dark Storms", zone = "Durotar", location = "Razor Hill",
      atLevel = 10, logCount = 6, x = 52.2, y = 43.2,
    },
    {
      type = "accept", questName = "Margoz", zone = "Durotar", location = "Razor Hill",
      atLevel = 10, logCount = 7, x = 52.2, y = 43.2,
    },
    {
      type = "turnin", questName = "Encroachment", zone = "Durotar", location = "Razor Hill",
      atLevel = 10, logCount = 6, x = 52.0, y = 43.5,
    },
    {
      type = "turnin", questName = "Margoz", zone = "Durotar", location = "Eastern Durotar",
      atLevel = 10, logCount = 5, x = 56.4, y = 20.0,
    },
    {
      type = "accept", questName = "Skull Rock", zone = "Durotar",
      location = "Eastern Durotar", atLevel = 11, logCount = 6, x = 56.4, y = 20.0,
    },
    {
      type = "complete", name = "Hidden Enemies (part 1)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Durotar", location = "Skull Rock", atLevel = 11, logCount = 6,
      x = 52.0, y = 9.0, approx = true,
    },
    {
      type = "complete", questName = "Skull Rock", zone = "Durotar", location = "Skull Rock",
      atLevel = 11, logCount = 6, x = 52.0, y = 9.0, approx = true,
    },
    {
      type = "accept", questName = "Burning Shadows", zone = "Durotar",
      location = "Skull Rock", atLevel = 11, logCount = 7, x = 52.0, y = 9.0, approx = true,
      note = "Starts from an item you loot here, not from an NPC.",
    },
    {
      type = "complete", questName = "Finding the Antidote", zone = "Durotar",
      location = "Eastern Durotar", atLevel = 11, logCount = 7, x = 55.0, y = 14.0,
      approx = true,
    },
    {
      type = "turnin", questName = "Skull Rock", zone = "Durotar",
      location = "Eastern Durotar", atLevel = 11, logCount = 6, x = 56.4, y = 20.0,
    },
    {
      type = "accept", questName = "Neeru Fireblade", zone = "Durotar",
      location = "Eastern Durotar", atLevel = 11, logCount = 7, x = 56.4, y = 20.0,
    },
    {
      type = "death", name = "Eastern Durotar to Jaggedswine Farm", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 11, logCount = 7, x = 56.4, y = 20.0,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "turnin", name = "Hidden Enemies (part 1)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", atLevel = 11,
      logCount = 6, x = 31.8, y = 37.8,
    },
    {
      type = "accept", name = "Hidden Enemies (part 2)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", atLevel = 11,
      logCount = 7, x = 31.8, y = 37.8,
    },
    {
      type = "turnin", questName = "Finding the Antidote", zone = "Orgrimmar",
      location = "The Cleft of Shadow", atLevel = 11, logCount = 6, x = 47.2, y = 53.6,
    },
    {
      type = "turnin", questName = "Neeru Fireblade", zone = "Orgrimmar",
      location = "The Cleft of Shadow", atLevel = 11, logCount = 5, x = 49.5, y = 50.6,
    },
    {
      type = "accept", questName = "Ak'Zeloth", zone = "Orgrimmar",
      location = "The Cleft of Shadow", atLevel = 11, logCount = 6, x = 49.5, y = 50.6,
    },
    {
      type = "turnin", questName = "Burning Shadows", zone = "Orgrimmar",
      location = "The Cleft of Shadow", atLevel = 11, logCount = 5, x = 49.5, y = 50.6,
    },
    {
      type = "complete", name = "Hidden Enemies (part 2)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Cleft of Shadow", atLevel = 11,
      logCount = 5, x = 49.5, y = 50.6,
    },
    {
      type = "turnin", name = "Hidden Enemies (part 2)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", atLevel = 11,
      logCount = 4, x = 31.8, y = 37.8,
    },
    {
      type = "note", optional = true, name = "Skip: H",
      note = "The route deliberately skips Hidden Enemies #3. Low XP for the travel time.",
      zone = "Orgrimmar", location = "The Valley of Wisdom", atLevel = 11, x = 31.8, y = 37.8,
    },
    {
      type = "death", name = "Ragefire Chasm to Jaggedswine Farm", zone = "Durotar",
      location = "Jaggedswine Farm", atLevel = 11, logCount = 4, x = 52.8, y = 49.0,
      note = "Intentional death. Release and run back, or rez at the graveyard named here.",
    },
    {
      type = "turnin", questName = "Need for a Cure", zone = "Durotar",
      location = "Rocktusk Farm", atLevel = 11, logCount = 3, x = 41.5, y = 18.6,
    },
    {
      type = "turnin", questName = "Lost But Not Forgotten", zone = "Durotar",
      location = "Tor'kren Farm", atLevel = 11, logCount = 2, x = 43.1, y = 30.2,
    },
    {
      type = "turnin", questName = "Conscript of the Horde", zone = "The Barrens",
      location = "Far Watch Post", atLevel = 11, logCount = 1, x = 62.3, y = 19.4,
    },
    {
      type = "accept", questName = "Crossroads Conscription", zone = "The Barrens",
      location = "Far Watch Post", atLevel = 11, logCount = 2, x = 62.3, y = 19.4,
    },
    {
      type = "turnin", questName = "Ak'Zeloth", zone = "The Barrens",
      location = "Far Watch Post", atLevel = 12, logCount = 1, x = 62.3, y = 20.1,
    },
    {
      type = "accept", questName = "The Demon Seed", zone = "The Barrens",
      location = "Far Watch Post", atLevel = 12, logCount = 2, x = 62.3, y = 20.1,
    },
}, { races = { "Orc", "Troll" } })

