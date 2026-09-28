-- TuFFlevels / Routes/Horde/Dungeon/01-VALLEYOFTRIALS.lua
--
-- Part 1 of the 5-man Horde 1-60 dungeon route.
-- Sections: VALLEY OF TRIALS | Sen'jin Village to Tiragarde Keep | Scuttle Coast to Echo Isles | Razor Hill to Western Durotar to Orgrimmar | Skull Rock | Barrens Start | Ratchet to Merchant Coast | Northern Barrens Lap #1 | Northern Barrens Lap #2 | Northern Barrens Lap #2 (level 14-18) | Northern Barrens Lap #1 (level 18-20)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(1, {

    { type = "section", name = "VALLEY OF TRIALS", zone = "Durotar" },
    {
      type = "accept", questName = "Your Place In The World", zone = "Durotar",
      location = "The Den", logCount = 1,
    },
    {
      type = "turnin", questName = "Your Place In The World", zone = "Durotar",
      location = "The Den", logCount = 0,
    },
    { type = "accept", questName = "Cutting Teeth", zone = "Durotar", location = "The Den", logCount = 1 },
    {
      type = "note", optional = true, name = "Skip: Sarkoth (part 1)",
      note = "The route deliberately skips Sarkoth (part 1). Not worth trying to get the kill.",
      zone = "Durotar", location = "Valley of Trials",
    },
    {
      type = "complete", questName = "Cutting Teeth", zone = "Durotar",
      location = "Valley of Trials", logCount = 1,
    },
    { type = "turnin", questName = "Cutting Teeth", zone = "Durotar", location = "The Den", logCount = 0 },
    {
      type = "note", optional = true, name = "Skip: Sting of the Scorpid",
      note = "The route deliberately skips Sting of the Scorpid. Not worth, trying to compete for that many kills.",
      zone = "Durotar", location = "The Den",
    },
    {
      type = "accept", questName = "Galgar's Cactus Apple Surprise", zone = "Durotar",
      location = "The Den", logCount = 1,
    },
    { type = "trainer", name = "Class Trainer", zone = "Durotar", location = "The Den", logCount = 1 },
    { type = "accept", questName = "Vile Familiars", zone = "Durotar", location = "The Den", logCount = 2 },
    { type = "accept", questName = "Lazy Peons", zone = "Durotar", location = "Valley of Trials", logCount = 3 },
    {
      type = "complete", questName = "Vile Familiars", zone = "Durotar",
      location = "Valley of Trials", logCount = 3,
    },
    {
      type = "complete", questName = "Lazy Peons", zone = "Durotar",
      location = "Valley of Trials", logCount = 3,
    },
    {
      type = "complete", questName = "Galgar's Cactus Apple Surprise", zone = "Durotar",
      location = "Valley of Trials", logCount = 3,
    },
    {
      type = "turnin", questName = "Galgar's Cactus Apple Surprise", zone = "Durotar",
      location = "The Den", logCount = 2,
    },
    { type = "trainer", name = "Class Trainer", zone = "Durotar", location = "The Den", logCount = 2 },
    { type = "turnin", questName = "Vile Familiars", zone = "Durotar", location = "The Den", logCount = 1 },
    {
      type = "accept", questName = "Burning Blade Medallion", zone = "Durotar",
      location = "The Den", logCount = 2,
    },
    { type = "turnin", questName = "Lazy Peons", zone = "Durotar", location = "Valley of Trials", logCount = 1 },
    {
      type = "accept", questName = "Thazz'ril's Pick", zone = "Durotar",
      location = "Valley of Trials", logCount = 2,
    },
    {
      type = "complete", questName = "Thazz'ril's Pick", zone = "Durotar",
      location = "Burning Blade Coven", logCount = 2,
    },
    {
      type = "complete", questName = "Burning Blade Medallion", zone = "Durotar",
      location = "Burning Blade Coven", logCount = 2,
    },
    {
      type = "death", name = "Burning Blade Coven to The Den", zone = "Durotar",
      location = "Burning Blade Coven", logCount = 2,
      note = "Intentional death. Release and rez at the graveyard named here.",
    },
    {
      type = "turnin", questName = "Burning Blade Medallion", zone = "Durotar",
      location = "The Den", logCount = 1,
    },
    {
      type = "accept", questName = "Report to Sen'jin Village", zone = "Durotar",
      location = "The Den", logCount = 2,
    },
    { type = "trainer", name = "Class Trainer", zone = "Durotar", location = "The Den", logCount = 2 },
    {
      type = "turnin", questName = "Thazz'ril's Pick", zone = "Durotar",
      location = "Valley of Trials", logCount = 1,
    },

    { type = "section", name = "Sen'jin Village to Tiragarde Keep", zone = "Durotar" },
    {
      type = "accept", questName = "A Peon's Burden", zone = "Durotar",
      location = "Valley of Trials", logCount = 2,
    },
    { type = "note", name = "Note", note = "**Need to be LEVEL 5 When you hit Sen'jinVIllage***" },
    {
      type = "note", optional = true, name = "Skip: Practical Prey",
      note = "The route deliberately skips Practical Prey. Super shit for 5 man and to close to starting zone....",
      zone = "Durotar", location = "Sen'jin Village",
    },
    {
      type = "note", optional = true, name = "Skip: A Solvent Spirit",
      note = "The route deliberately skips A Solvent Spirit. Super shit for 5 man and to close to starting zone....",
      zone = "Durotar", location = "Sen'jin Village",
    },
    {
      type = "turnin", questName = "Report to Sen'jin Village", zone = "Durotar",
      location = "Sen'jin Village", logCount = 1,
    },
    {
      type = "accept", questName = "Report to Orgnil", zone = "Durotar",
      location = "Sen'jin Village", logCount = 2,
    },
    {
      type = "accept", questName = "Minshina's Skull", zone = "Durotar",
      location = "Sen'jin Village", logCount = 3,
    },
    { type = "accept", questName = "Zalazane", zone = "Durotar", location = "Sen'jin Village", logCount = 4 },
    {
      type = "trainer", name = "Herbalism Trainer", zone = "Durotar",
      location = "Sen'jin Village", logCount = 4,
    },
    {
      type = "accept", questName = "Thwarting Kolkar Aggression", zone = "Durotar",
      location = "Sen'jin Village", logCount = 5,
    },
    {
      type = "complete", questName = "Thwarting Kolkar Aggression", zone = "Durotar",
      location = "Kolkar Crag", logCount = 5,
    },
    {
      type = "turnin", questName = "Thwarting Kolkar Aggression", zone = "Durotar",
      location = "Sen'jin Village", logCount = 4,
    },
    {
      type = "note", name = "Note",
      note = "Note: Before you hit Razor Hill you need to be level 6, grind boars and whatever on the way.",
    },
    { type = "accept", questName = "Carry Your Weight", zone = "Durotar", location = "Razor Hill", logCount = 5 },
    {
      type = "note", optional = true, name = "Skip: Break a Few Eggs",
      note = "The route deliberately skips Break a Few Eggs. Super shit for 5 man and to close to starting zone....",
      zone = "Durotar", location = "Razor Hill",
    },
    { type = "turnin", questName = "A Peon's Burden", zone = "Durotar", location = "Razor Hill", logCount = 4 },
    {
      type = "hearth", name = "Set Hearth to Razor Hill", zone = "Durotar",
      location = "Razor Hill", logCount = 4, note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Vanquish the Betrayers", zone = "Durotar",
      location = "Razor Hill", logCount = 5,
    },
    { type = "accept", questName = "Encroachment", zone = "Durotar", location = "Razor Hill", logCount = 6 },
    { type = "turnin", questName = "Report to Orgnil", zone = "Durotar", location = "Razor Hill", logCount = 5 },
    { type = "accept", questName = "Dark Storms", zone = "Durotar", location = "Razor Hill", logCount = 6 },
    {
      type = "complete", questName = "Encroachment", zone = "Durotar",
      location = "Razormane Grounds", logCount = 6,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", name = "The Admiral's Orders (part 1)",
      questName = "The Admiral's Orders", ambiguous = true, zone = "Durotar",
      location = "Tiragarde Keep", logCount = 7,
    },
    {
      type = "complete", questName = "Carry Your Weight", zone = "Durotar",
      location = "Tiragarde Keep", logCount = 7,
    },
    {
      type = "complete", questName = "Vanquish the Betrayers", zone = "Durotar",
      location = "Tiragarde Keep", logCount = 7,
    },
    {
      type = "note", name = "Note",
      note = "Grind to level 8, if your way ahead of the pack then you can leave sooner.",
    },
    {
      type = "death", name = "Tiragarde Keep to Razor Hill", zone = "Durotar",
      location = "Tiragarde Keep", logCount = 7,
      note = "Intentional death. Release and rez at the graveyard named here.",
    },

    { type = "section", name = "Scuttle Coast to Echo Isles", zone = "Durotar" },
    {
      type = "turnin", name = "The Admiral's Orders (part 1)",
      questName = "The Admiral's Orders", ambiguous = true, zone = "Durotar",
      location = "Razor Hill", logCount = 6,
    },
    {
      type = "accept", name = "The Admiral's Orders (part 2)",
      questName = "The Admiral's Orders", ambiguous = true, zone = "Durotar",
      location = "Razor Hill", logCount = 7,
    },
    {
      type = "turnin", questName = "Vanquish the Betrayers", zone = "Durotar",
      location = "Razor Hill", logCount = 6,
    },
    {
      type = "accept", questName = "From The Wreckage....", zone = "Durotar",
      location = "Razor Hill", logCount = 7,
    },
    {
      type = "complete", questName = "From The Wreckage....", zone = "Durotar",
      location = "Scuttle Coast", logCount = 7,
    },
    {
      type = "complete", questName = "Minshina's Skull", zone = "Durotar",
      location = "Echo Isles", logCount = 7,
    },
    { type = "complete", questName = "Zalazane", zone = "Durotar", location = "Echo Isles", logCount = 7 },
    {
      type = "note", name = "Note",
      note = "If you can get the kill on Zalazane do it... if not move on and grind quillboars",
    },
    {
      type = "turnin", questName = "Minshina's Skull", zone = "Durotar",
      location = "Sen'jin Village", logCount = 6,
    },
    {
      type = "turnin", questName = "Zalazane", zone = "Durotar", location = "Sen'jin Village",
      logCount = 5, note = "Turn in if you have it; drop the quest if you do not.",
    },
    {
      type = "hearth", name = "Hearth to Razor Hill", zone = "Durotar",
      location = "Sen'jin Village", logCount = 5, note = "Use your hearthstone.",
    },

    { type = "section", name = "Razor Hill to Western Durotar to Orgrimmar", zone = "Durotar" },
    { type = "trainer", name = "Class Trainer", zone = "Durotar", location = "Razor Hill", logCount = 5 },
    {
      type = "turnin", questName = "From The Wreckage....", zone = "Durotar",
      location = "Razor Hill", logCount = 4,
    },
    { type = "turnin", questName = "Carry Your Weight", zone = "Durotar", location = "Razor Hill", logCount = 3 },
    {
      type = "accept", questName = "Lost But Not Forgotten", zone = "Durotar",
      location = "Razormane Grounds", logCount = 4,
    },
    {
      type = "accept", questName = "Winds in the Desert", zone = "Durotar",
      location = "North Durotar", logCount = 5,
    },
    {
      type = "complete", questName = "Winds in the Desert", zone = "Durotar",
      location = "Razorwind Canyon", logCount = 5,
    },
    {
      type = "death", name = "Drygulch Ravine to North Durotar", zone = "Durotar",
      location = "North Durotar", logCount = 5,
      note = "Intentional death. Release and rez at the graveyard named here.",
    },
    {
      type = "turnin", questName = "Winds in the Desert", zone = "Durotar",
      location = "North Durotar", logCount = 4,
    },
    {
      type = "accept", questName = "Securing the Lines", zone = "Durotar",
      location = "North Durotar", logCount = 5,
    },
    {
      type = "complete", questName = "Securing the Lines", zone = "Durotar",
      location = "Drygulch Ravine", logCount = 5,
    },
    {
      type = "turnin", questName = "Securing the Lines", zone = "Durotar",
      location = "North Durotar", logCount = 4,
    },
    {
      type = "accept", questName = "Need for a Cure", zone = "Durotar",
      location = "North Durotar", logCount = 5,
    },
    { type = "complete", questName = "Dark Storms", zone = "Durotar", location = "Thunder Ridge", logCount = 5 },
    {
      type = "death", name = "Thunder Ridge to North Durotar", zone = "Durotar",
      location = "North Durotar", logCount = 5,
      note = "Intentional death. Release and rez at the graveyard named here.",
    },
    {
      type = "hearth", name = "Set Hearth to Orgrimmar", zone = "Orgrimmar", logCount = 5,
      note = "Bind your hearthstone here.",
    },
    { type = "trainer", name = "Class Trainer", zone = "Orgrimmar", logCount = 5 },
    {
      type = "turnin", name = "The Admiral's Orders (part 2)",
      questName = "The Admiral's Orders", ambiguous = true, zone = "Orgrimmar",
      location = "The Valley of Wisdom", logCount = 4,
    },
    {
      type = "accept", name = "Hidden Enemies (part 1)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", logCount = 5,
    },
    {
      type = "accept", questName = "Finding the Antidote", zone = "Orgrimmar",
      location = "The Cleft of Shadow", logCount = 6,
    },
    {
      type = "death", name = "Ragefire Chasm to North Durotar", zone = "Durotar",
      location = "North Durotar", logCount = 6,
      note = "Intentional death. Release and rez at the graveyard named here.",
    },

    { type = "section", name = "Skull Rock", zone = "Durotar" },
    {
      type = "complete", questName = "Lost But Not Forgotten", zone = "Durotar",
      location = "Southfury River", logCount = 6,
    },
    {
      type = "complete", questName = "Encroachment", zone = "Durotar",
      location = "Razormane Grounds", logCount = 6,
    },
    {
      type = "note", name = "Note",
      note = "If not contested, grind till level 10 and force over spawns, will pay off later!",
    },
    {
      type = "accept", questName = "Conscript of the Horde", zone = "Durotar",
      location = "Razor Hill", logCount = 7,
    },
    { type = "turnin", questName = "Dark Storms", zone = "Durotar", location = "Razor Hill", logCount = 6 },
    { type = "accept", questName = "Margoz", zone = "Durotar", location = "Razor Hill", logCount = 7 },
    { type = "turnin", questName = "Encroachment", zone = "Durotar", location = "Razor Hill", logCount = 6 },
    { type = "complete", questName = "Margoz", zone = "Durotar", location = "Eastern Durotar", logCount = 6 },
    { type = "turnin", questName = "Margoz", zone = "Durotar", location = "Eastern Durotar", logCount = 5 },
    { type = "accept", questName = "Skull Rock", zone = "Durotar", location = "Eastern Durotar", logCount = 6 },
    {
      type = "complete", questName = "Finding the Antidote", zone = "Durotar",
      location = "Eastern Durotar", logCount = 6,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    { type = "note", name = "Note", note = "---------------------------------------->>>>>>>>" },
    {
      type = "complete", name = "Hidden Enemies (part 1)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Durotar", location = "Skull Rock", logCount = 6,
    },
    { type = "complete", questName = "Skull Rock", zone = "Durotar", location = "Skull Rock", logCount = 6 },
    { type = "accept", questName = "Burning Shadows", zone = "Durotar", location = "Skull Rock", logCount = 7 },
    {
      type = "complete", questName = "Finding the Antidote", zone = "Durotar",
      location = "Eastern Durotar", logCount = 7,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    { type = "turnin", questName = "Skull Rock", zone = "Durotar", location = "Eastern Durotar", logCount = 6 },
    {
      type = "accept", questName = "Neeru Fireblade", zone = "Durotar",
      location = "Eastern Durotar", logCount = 7,
    },
    {
      type = "complete", questName = "Finding the Antidote", zone = "Durotar",
      location = "Eastern Durotar", logCount = 7,
    },
    {
      type = "turnin", name = "Hidden Enemies (part 1)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", logCount = 6,
    },
    {
      type = "accept", name = "Hidden Enemies (part 2)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", logCount = 7,
    },
    {
      type = "turnin", questName = "Finding the Antidote", zone = "Orgrimmar",
      location = "The Cleft of Shadow", logCount = 6,
    },
    {
      type = "turnin", questName = "Neeru Fireblade", zone = "Orgrimmar",
      location = "The Cleft of Shadow", logCount = 5,
    },
    {
      type = "accept", questName = "Ak'Zeloth", zone = "Orgrimmar",
      location = "The Cleft of Shadow", logCount = 6,
    },
    {
      type = "turnin", questName = "Burning Shadows", zone = "Orgrimmar",
      location = "The Cleft of Shadow", logCount = 5,
    },
    {
      type = "complete", name = "Hidden Enemies (part 2)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Cleft of Shadow", logCount = 5,
    },
    {
      type = "turnin", name = "Hidden Enemies (part 2)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", logCount = 4,
    },
    {
      type = "accept", name = "Hidden Enemies (part 3)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", logCount = 5,
    },
    { type = "trainer", name = "Class Trainer", zone = "Orgrimmar", logCount = 5 },
    {
      type = "death", name = "Ragefire Chasm to North Durotar", zone = "Durotar",
      location = "North Durotar", logCount = 5,
      note = "Intentional death. Release and rez at the graveyard named here.",
    },
    {
      type = "turnin", questName = "Need for a Cure", zone = "Durotar",
      location = "North Durotar", logCount = 4,
    },
    {
      type = "turnin", questName = "Lost But Not Forgotten", zone = "Durotar",
      location = "Razormane Grounds", logCount = 3,
    },
    { type = "turnin", questName = "Ak'Zeloth", zone = "The Barrens", location = "Far Watch Post", logCount = 2 },
    {
      type = "accept", questName = "The Demon Seed", zone = "The Barrens",
      location = "Far Watch Post", logCount = 3,
    },
    {
      type = "turnin", questName = "Conscript of the Horde", zone = "The Barrens",
      location = "Far Watch Post", logCount = 2,
    },
    {
      type = "accept", questName = "Crossroads Conscription", zone = "The Barrens",
      location = "Far Watch Post", logCount = 3,
    },

    { type = "section", name = "Barrens Start", zone = "The Barrens" },
    {
      type = "complete", questName = "The Demon Seed", zone = "The Barrens",
      location = "Dreadmist peak", logCount = 3,
    },
    {
      type = "accept", questName = "Fungal Spores", zone = "The Barrens",
      location = "The Crossroads", logCount = 4,
    },
    {
      type = "accept", questName = "Wharfmaster Dizzywig", zone = "The Barrens",
      location = "The Crossroads", logCount = 5,
    },
    {
      type = "accept", questName = "Disrupt the Attacks", zone = "The Barrens",
      location = "The Crossroads", logCount = 6,
    },
    {
      type = "accept", questName = "Supplies for the Crossroads", zone = "The Barrens",
      location = "The Crossroads", logCount = 7,
    },
    {
      type = "accept", questName = "Harpy Raiders", zone = "The Barrens",
      location = "The Crossroads", logCount = 8,
    },
    {
      type = "accept", questName = "Raptor Thieves", zone = "The Barrens",
      location = "The Crossroads", logCount = 9,
    },
    {
      type = "hearth", name = "Set Hearth to The Crossroads", zone = "The Barrens",
      location = "The Crossroads", logCount = 9, note = "Bind your hearthstone here.",
    },
    {
      type = "turnin", questName = "Crossroads Conscription", zone = "The Barrens",
      location = "The Crossroads", logCount = 8,
    },
    {
      type = "accept", questName = "Plainstrider Menace", zone = "The Barrens",
      location = "The Crossroads", logCount = 9,
    },
    {
      type = "accept", questName = "The Forgotten Pools", zone = "The Barrens",
      location = "The Crossroads", logCount = 10,
    },
    {
      type = "manual", name = "Kalyimah Stormcloud: Bags", zone = "The Barrens",
      location = "The Crossroads", logCount = 10, note = "Vendor stop.",
    },
    {
      type = "complete", questName = "Plainstrider Menace", zone = "The Barrens",
      location = "Thorn Hill", logCount = 10,
      note = "------------------------------------>>>>>>>>>",
    },
    {
      type = "note", name = "Note",
      note = "Note: do a lap clockwise around crossroads if your having issues with spawns.",
    },
    {
      type = "complete", questName = "Disrupt the Attacks", zone = "The Barrens",
      location = "Thorn Hill", logCount = 10,
    },
    { type = "note", name = "Note", note = "w" },
    {
      type = "accept", name = "Chen's Empty Keg (part 1)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Thorn Hill", logCount = 11,
    },
    {
      type = "note", name = "Note",
      note = "Note: It may be difficult for everyone to get chens empty keg, if you have it great if not so be it.",
    },
    {
      type = "accept", questName = "Meats to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "turnin", questName = "Plainstrider Menace", zone = "The Barrens",
      location = "The Crossroads", logCount = 11,
    },
    {
      type = "accept", questName = "The Zhevra", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "turnin", questName = "Disrupt the Attacks", zone = "The Barrens",
      location = "The Crossroads", logCount = 11,
    },
    {
      type = "accept", questName = "The Disruption Ends", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "complete", questName = "The Zhevra", zone = "The Barrens",
      location = "Thorn Hill", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "note", name = "Note",
      note = "Note: probably best to do a lap around X-Roads starting south and going clockwise to thorn hill. (need the xp anyways)",
    },
    {
      type = "complete", questName = "The Disruption Ends", zone = "The Barrens",
      location = "Thorn Hill", logCount = 12,
    },
    {
      type = "complete", questName = "Supplies for the Crossroads", zone = "The Barrens",
      location = "Thorn Hill", logCount = 12,
    },
    {
      type = "complete", questName = "The Zhevra", zone = "The Barrens",
      location = "Thorn Hill", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on. ------------------------------------>>>>>>>>>",
    },
    {
      type = "turnin", questName = "The Demon Seed", zone = "The Barrens",
      location = "Far Watch Post", logCount = 11,
    },
    { type = "note", name = "Note", note = "**Need to be LEVEL 13 When you hit RATCHET***" },
    {
      type = "complete", questName = "The Zhevra", zone = "The Barrens",
      location = "Southfury River", logCount = 11,
    },

    { type = "section", name = "Ratchet to Merchant Coast", zone = "The Barrens" },
    {
      type = "accept", questName = "Southsea Freebooters", zone = "The Barrens",
      location = "Ratchet", logCount = 12,
    },
    {
      type = "accept", name = "Samophlange (part 1)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", logCount = 13,
    },
    {
      type = "accept", questName = "WANTED: Baron Longshore", zone = "The Barrens",
      location = "Ratchet", logCount = 14,
    },
    {
      type = "note", optional = true, name = "Skip: Root Samples",
      note = "The route deliberately skips Root Samples.", zone = "The Barrens",
      location = "Ratchet",
    },
    { type = "accept", questName = "Raptor Horns", zone = "The Barrens", location = "Ratchet", logCount = 15 },
    {
      type = "turnin", name = "Chen's Empty Keg (part 1)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", logCount = 14,
    },
    {
      type = "note", name = "Note",
      note = "Note: It may be difficult for everyone to get chens empty keg, if you have it great if not so be it.",
    },
    {
      type = "accept", name = "Chen's Empty Keg (part 2)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", logCount = 15,
    },
    {
      type = "accept", questName = "The Guns of Northwatch", zone = "The Barrens",
      location = "Ratchet", logCount = 16,
    },
    {
      type = "complete", questName = "Southsea Freebooters", zone = "The Barrens",
      location = "The Merchant Coast", logCount = 16,
    },
    {
      type = "complete", questName = "WANTED: Baron Longshore", zone = "The Barrens",
      location = "The Merchant Coast", logCount = 16,
    },
    {
      type = "turnin", questName = "Southsea Freebooters", zone = "The Barrens",
      location = "The Merchant Coast", logCount = 15,
    },
    {
      type = "turnin", questName = "WANTED: Baron Longshore", zone = "The Barrens",
      location = "Ratchet", logCount = 14,
    },
    {
      type = "accept", name = "The Missing Shipment (part 1)",
      questName = "The Missing Shipment", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", logCount = 15,
    },
    {
      type = "turnin", name = "The Missing Shipment (part 1)",
      questName = "The Missing Shipment", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", logCount = 14,
    },
    {
      type = "turnin", questName = "Wharfmaster Dizzywig", zone = "The Barrens",
      location = "Ratchet", logCount = 13,
    },
    {
      type = "accept", name = "The Missing Shipment (part 2)",
      questName = "The Missing Shipment", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", logCount = 14,
    },
    {
      type = "turnin", name = "The Missing Shipment (part 2)",
      questName = "The Missing Shipment", ambiguous = true, zone = "The Barrens",
      location = "Ratchet", logCount = 13,
    },
    { type = "accept", questName = "Stolen Booty", zone = "The Barrens", location = "Ratchet", logCount = 14 },
    {
      type = "complete", questName = "Stolen Booty", zone = "The Barrens",
      location = "The Merchant Coast", logCount = 14,
    },
    {
      type = "hearth", name = "Hearth to The Crossroads", zone = "The Barrens",
      location = "The Merchant Coast", logCount = 14, note = "Use your hearthstone.",
    },

    { type = "section", name = "Northern Barrens Lap #1", zone = "The Barrens" },
    {
      type = "turnin", questName = "The Zhevra", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "accept", questName = "Prowlers of the Barrens", zone = "The Barrens",
      location = "The Crossroads", logCount = 14,
    },
    {
      type = "turnin", questName = "The Disruption Ends", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "turnin", questName = "Supplies for the Crossroads", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "turnin", questName = "Meats to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", logCount = 11,
    },
    {
      type = "accept", questName = "Ride to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "accept", questName = "Kolkar Leaders", zone = "The Barrens",
      location = "West of Crossroads", logCount = 13,
    },
    {
      type = "accept", questName = "Centaur Bracers", zone = "The Barrens",
      location = "West of Crossroads", logCount = 14,
    },
    {
      type = "complete", questName = "The Forgotten Pools", zone = "The Barrens",
      location = "Forgotten Pools", logCount = 14,
    },
    {
      type = "complete", questName = "Fungal Spores", zone = "The Barrens",
      location = "Forgotten Pools", logCount = 14,
    },
    {
      type = "complete", questName = "Centaur Bracers", zone = "The Barrens",
      location = "Forgotten Pools", logCount = 14,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Kolkar Leaders", zone = "The Barrens",
      location = "Forgotten Pools", logCount = 14,
    },
    { type = "note", name = "Note", note = "Kill all the Raptors you see for raptor horns and heads!!!!!!" },
    { type = "complete", questName = "WW", zone = "The Barrens", location = "Western Barrens", logCount = 14 },
    {
      type = "complete", name = "Chen's Empty Keg (part 2)", questName = "Chen's Empty Keg",
      ambiguous = true, zone = "The Barrens", location = "Western Barrens", logCount = 14,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Raptor Thieves", zone = "The Barrens",
      location = "The Dry Hills", logCount = 14,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Harpy Raiders", zone = "The Barrens",
      location = "The Dry Hills", logCount = 14,
    },
    {
      type = "complete", questName = "Raptor Horns", zone = "The Barrens",
      location = "North Barrens", logCount = 14,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", name = "Samophlange (part 1)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", logCount = 13,
    },
    {
      type = "accept", name = "Samophlange (part 2)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", logCount = 14,
    },
    {
      type = "complete", name = "Samophlange (part 2)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", logCount = 14,
    },
    {
      type = "turnin", name = "Samophlange (part 2)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", logCount = 13,
    },
    {
      type = "accept", name = "Samophlange (part 3)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", logCount = 14,
    },
    {
      type = "complete", name = "Samophlange (part 3)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", logCount = 14,
    },
    {
      type = "turnin", name = "Samophlange (part 3)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", logCount = 13,
    },
    {
      type = "accept", name = "Samophlange (part 4)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Sludge Fen", logCount = 14,
    },
    {
      type = "complete", questName = "Raptor Thieves", zone = "The Barrens",
      location = "Sludge Fen", logCount = 14,
      note = "---------------------------------------------->>>",
    },

    { type = "section", name = "Northern Barrens Lap #2", zone = "The Barrens" },
    {
      type = "turnin", questName = "Raptor Thieves", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "accept", questName = "Stolen Silver", zone = "The Barrens",
      location = "The Crossroads", logCount = 14,
    },
    {
      type = "turnin", questName = "Fungal Spores", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "note", optional = true, name = "Skip: Apothecary Zamah",
      note = "Do not pick up Apothecary Zamah yet - the route comes back for it.",
      zone = "The Barrens", location = "The Crossroads",
    },
    {
      type = "turnin", questName = "Harpy Raiders", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "accept", questName = "Harpy Lieutenants", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "turnin", questName = "Prowlers of the Barrens", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "accept", questName = "Echeyakee", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "turnin", questName = "The Forgotten Pools", zone = "The Barrens",
      location = "The Crossroads", logCount = 12,
    },
    {
      type = "accept", questName = "The Stagnant Oasis", zone = "The Barrens",
      location = "The Crossroads", logCount = 13,
    },
    {
      type = "accept", questName = "Consumed by Hatred", zone = "The Barrens",
      location = "The Crossroads", logCount = 14,
    },
    {
      type = "accept", questName = "Lost in Battle", zone = "The Barrens",
      location = "The Crossroads", logCount = 15,
    },
    {
      type = "travel", name = "Crossroads to Orgrimmar", zone = "The Barrens",
      location = "The Crossroads", logCount = 15, note = "Take the flight path.",
    },
    { type = "turnin", questName = "Ride to Orgrimmar", zone = "Orgrimmar", logCount = 14 },
    { type = "accept", questName = "Doras the Wind Rider Master", zone = "Orgrimmar", logCount = 15 },
    { type = "turnin", questName = "Doras the Wind Rider Master", zone = "Orgrimmar", logCount = 14 },
    { type = "accept", questName = "Return to the Crossroads.", zone = "Orgrimmar", logCount = 15 },
    {
      type = "accept", questName = "Slaying the Beast", zone = "Orgrimmar",
      location = "Cleft of Shadow", logCount = 16,
    },
    { type = "note", name = "Note", note = "Hopefully some alt will be there to share UC and TB Quests for RFC" },
    {
      type = "accept", questName = "Searching for the Lost Satchel", logCount = 17,
      note = "Note:only if you're able to get it via sharing outside of the instance.",
    },
    {
      type = "accept", questName = "Testing an Enemy's Strength", logCount = 18,
      note = "Note:only if you're able to get it via sharing outside of the instance.",
    },
    {
      type = "accept", questName = "The Power to Destroy...", logCount = 19,
      note = "Note:only if you're able to get it via sharing outside of the instance.",
    },

    { type = "section", name = "Northern Barrens Lap #2 (level 14-18)", levels = { 14, 18 } },
    { type = "note", name = "Note", note = "Rage Fire Chasm QUEST" },
    {
      type = "note", name = "Note",
      note = "Note: After your first full clear, go turn in Slaying the Beast / Hidden Enemies for the upgraded weapons",
    },
    { type = "note", name = "Note", note = "Rage Fire Chasm Grind" },
    {
      type = "note", name = "Farm rates",
      note = "Farm throughput from the source sheet - Level 14 to 15: Tarag Loop (587 - 440 xp/min, clear 15-20min); Level 15 to 16: Tarag Loop (553 - 415 xp/min, clear 15-20min); Level 16 to 17: Full Clear (638 - 478 xp/min, clear 15-20min); Level 17 to 18: Full Clear (565 - 424 xp/min, clear 15-20min).",
    },

    { type = "section", name = "Northern Barrens Lap #1 (level 18-20)", levels = { 18, 20 }, zone = "Orgrimmar" },
    {
      type = "turnin", questName = "Slaying the Beast", zone = "Orgrimmar",
      location = "Cleft of Shadow", logCount = 18,
    },
    {
      type = "turnin", name = "Hidden Enemies (part 3)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", logCount = 17,
    },
    {
      type = "accept", name = "Hidden Enemies (part 4)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", logCount = 18,
    },
    {
      type = "turnin", name = "Hidden Enemies (part 4)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "Cleft of Shadow", logCount = 17,
    },
    {
      type = "accept", name = "Hidden Enemies (part 5)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "Cleft of Shadow", logCount = 18,
    },
    {
      type = "turnin", name = "Hidden Enemies (part 5)", questName = "Hidden Enemies",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Wisdom", logCount = 17,
    },
    {
      type = "accept", questName = "The Spirits of Stonetalon", zone = "Orgrimmar",
      location = "The Valley of Wisdom", logCount = 18,
    },
    {
      type = "travel", name = "Orgrimmar to The Crossroads", zone = "The Barrens",
      location = "The Crossroads", logCount = 18, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Return to the Crossroads.", zone = "The Barrens",
      location = "The Crossroads", logCount = 17,
    },
    {
      type = "complete", questName = "Centaur Bracers", zone = "The Barrens",
      location = "The Stagnant Oasis", logCount = 17,
    },
    {
      type = "complete", questName = "The Stagnant Oasis", zone = "The Barrens",
      location = "The Stagnant Oasis", logCount = 17,
    },
    { type = "turnin", questName = "Stolen Booty", zone = "The Barrens", location = "Ratchet", logCount = 16 },
    {
      type = "note", optional = true, name = "Skip: Trouble at the Docks",
      note = "Do not pick up Trouble at the Docks yet - the route comes back for it.",
      zone = "The Barrens", location = "Ratchet",
    },
    {
      type = "turnin", name = "Samophlange (part 4)", questName = "Samophlange",
      ambiguous = true, zone = "The Barrens", location = "Ratchet", logCount = 15,
    },
    {
      type = "accept", questName = "Wenikee Boltbucket", zone = "The Barrens",
      location = "Ratchet", logCount = 16,
    },
    { type = "accept", questName = "Ziz Fizziks", zone = "The Barrens", location = "Ratchet", logCount = 17 },
    {
      type = "travel", name = "Ratchet to The Crossroads", zone = "The Barrens",
      location = "Ratchet", logCount = 17, note = "Take the flight path.",
    },
    {
      type = "complete", questName = "Echeyakee", zone = "The Barrens",
      location = "North Barrens", logCount = 17,
    },
    {
      type = "turnin", questName = "Wenikee Boltbucket", zone = "The Barrens",
      location = "North Barrens", logCount = 16,
    },
    {
      type = "accept", questName = "Nugget Slugs", zone = "The Barrens",
      location = "North Barrens", logCount = 17,
    },
    {
      type = "complete", questName = "Nugget Slugs", zone = "The Barrens",
      location = "Sludge Fen", logCount = 17,
    },
    { type = "accept", questName = "Ignition", zone = "The Barrens", location = "Sludge Fen", logCount = 18 },
    { type = "complete", questName = "Ignition", zone = "The Barrens", location = "Sludge Fen", logCount = 18 },
    { type = "turnin", questName = "Ignition", zone = "The Barrens", location = "Sludge Fen", logCount = 17 },
    { type = "accept", questName = "The Escape", zone = "The Barrens", location = "Sludge Fen", logCount = 18 },
    { type = "complete", questName = "The Escape", zone = "The Barrens", location = "Sludge Fen", logCount = 18 },
    {
      type = "turnin", questName = "Nugget Slugs", zone = "The Barrens",
      location = "North Barrens", logCount = 17,
    },
    {
      type = "note", optional = true, name = "Skip: Rilli Greasygob",
      note = "The route deliberately skips Rilli Greasygob.", zone = "The Barrens",
      location = "North Barrens",
    },
    {
      type = "complete", questName = "Raptor Horns", zone = "The Barrens",
      location = "North Barrens", logCount = 17,
    },
    {
      type = "complete", questName = "Harpy Lieutenants", zone = "The Barrens",
      location = "The Dry Hills", logCount = 17,
    },
    {
      type = "turnin", questName = "Centaur Bracers", zone = "The Barrens",
      location = "West of Crossroads", logCount = 16,
    },
    {
      type = "turnin", questName = "Kolkar Leaders", zone = "The Barrens",
      location = "West of Crossroads", logCount = 15,
    },
    {
      type = "accept", questName = "Verog the Dervish", zone = "The Barrens",
      location = "West of Crossroads", logCount = 16,
    },
})
