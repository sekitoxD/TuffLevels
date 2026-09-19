-- TuFFlevels / Routes/Horde/TirisfalStart.lua
--
-- Undead (Forsaken) opening, Tirisfal Glades through Silverpine to the
-- Orgrimmar zeppelin. Levels 1-14.
--
-- Converted from the "Tirisfal Starting" tab of the source spreadsheet.
-- That tab has NO coordinate column, so these steps name an NPC and a
-- location instead; the arrow stays blank and the tracker advances off
-- quest events. Coordinates are the obvious thing to add by hand here.
--
-- It ends where the main solo route reaches Orgrimmar. The sheet is
-- explicit that you then skip the route's first Silverpine leg, because
-- this start has already done those quests.

local ADDON, ns = ...

ns.RegisterRoute("Tirisfal Start (Undead) 1-14", {
    faction = "Horde",
    races   = { "Scourge" },
    levels  = { 1, 14 },
    author  = "Docc / ONSLAUGHT spreadsheet, converted for TuFFlevels",

    steps = {

        { type = "section", name = "Tirisfal Glades - Deathknell" },
        { type = "note", name = "Read this first", note = "Important! Tirisfal starting on live is noticeably worse than it is on private servers. Namely, the quest \"Proof of Demise\", which is a big chunk of XP from 9 to 10, can't be done until after killing Scarlet Warriors at the pumpkin farm. To make up for this, make sure you are killing monsters on your way between objectives, otherwise you are guaranteed not to hit 10 turning in quests after the pumpkin farm loop." },
        {
          type = "accept", questName = "Rude Awakening", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Undertaker Mordo",
        },
        {
          type = "turnin", questName = "Rude Awakening", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Shadow Priest Sarvis",
        },
        {
          type = "accept", questName = "The Mindless Ones", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Shadow Priest Sarvis",
        },
        {
          type = "complete", questName = "The Mindless Ones", zone = "Tirisfal Glades",
          location = "Deathknell",
          note = "Partial progress - work on this while you are here, then move on. Do this quest as spawns are available. Might be worth skipping on live or grouping for. Can turn in anytime you complete it. Worth 170 XP.",
        },
        {
          type = "accept", questName = "The Damned", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Novice Elreth",
        },
        { type = "complete", questName = "The Damned", zone = "Tirisfal Glades", location = "Deathknell" },
        { type = "turnin", questName = "The Damned", zone = "Tirisfal Glades", location = "Deathknell" },
        {
          type = "accept", questName = "Marla's Last Wish", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Novice Elreth",
        },
        {
          type = "accept", questName = "Night Web's Hollow", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Executor Arren",
        },
        {
          type = "accept", questName = "Scavenging Deathknell", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Deathguard Saltain",
        },
        {
          type = "complete", questName = "Marla's Last Wish", zone = "Tirisfal Glades",
          location = "Deathknell",
          note = "Partial progress - work on this while you are here, then move on. Kill Samuel Fipps. Might need to group for this part.",
        },
        {
          type = "complete", questName = "Night Web's Hollow", zone = "Tirisfal Glades",
          location = "Deathknell",
        },
        {
          type = "death", name = "Deathknell Graveyard", zone = "Tirisfal Glades",
          location = "Deathknell",
          note = "Intentional death. Release and rez at the graveyard named here. Die in the mine.",
        },
        {
          type = "complete", questName = "Marla's Last Wish", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Marla's Grave",
          note = "Grave near the entrance to the graveyard.",
        },
        {
          type = "turnin", questName = "Night Web's Hollow", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Executor Arren",
        },
        {
          type = "turnin", questName = "Marla's Last Wish", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Novice Elreth",
        },
        {
          type = "accept", questName = "The Scarlet Crusade", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Executor Arren",
        },
        {
          type = "complete", questName = "Scavenging Deathknell", zone = "Tirisfal Glades",
          location = "Deathknell",
          note = "Partial progress - work on this while you are here, then move on.",
        },
        {
          type = "complete", questName = "The Scarlet Crusade", zone = "Tirisfal Glades",
          location = "Deathknell",
        },
        {
          type = "death", name = "Deathknell Graveyard", zone = "Tirisfal Glades",
          location = "Deathknell",
          note = "Intentional death. Release and rez at the graveyard named here.",
        },
        {
          type = "turnin", questName = "The Scarlet Crusade", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Executor Arren",
        },
        {
          type = "accept", questName = "The Red Messenger", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Executor Arren",
        },
        {
          type = "complete", questName = "The Mindless Ones", zone = "Tirisfal Glades",
          location = "Deathknell",
        },
        {
          type = "complete", questName = "Scavenging Deathknell", zone = "Tirisfal Glades",
          location = "Deathknell",
        },
        {
          type = "complete", questName = "The Red Messenger", zone = "Tirisfal Glades",
          location = "Deathknell",
          note = "You can die and spirit rez in the camp if you have finished all the other quests, otherwise walk back to town and complete them.",
        },
        {
          type = "turnin", questName = "The Red Messenger", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Executor Arren",
        },
        {
          type = "turnin", questName = "Scavenging Deathknell", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Deathguard Saltain",
        },
        {
          type = "turnin", questName = "The Mindless Ones", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Shadow Priest Sarvis",
        },
        {
          type = "accept", questName = "Vital Intelligence", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Executor Arren",
        },
        {
          type = "accept", questName = "A Rogue's Deal", zone = "Tirisfal Glades",
          location = "Deathknell", npc = "Calvin Montague",
          note = "You must be at least 2350/2800 of Level 5 before turning these quests in to reach level 6 before the next leg.",
        },

        { type = "section", name = "Tirisfal Glades - Brill" },
        {
          type = "accept", questName = "Fields of Grief", zone = "Tirisfal Glades",
          location = "Deathknell Exit", npc = "Deathguard Simmer",
        },
        {
          type = "accept", questName = "Gordo's Task", zone = "Tirisfal Glades",
          location = "Road to Brill", npc = "Gordo",
          note = "Gordo patrols the road from Deathknell to Brill.",
        },
        {
          type = "complete", questName = "Gordo's Task", zone = "Tirisfal Glades",
          note = "Partial progress - work on this while you are here, then move on. You can find Gloom Weed along the road to Brill on the north side and around the farm for A Putrid Task. Turn in when complete and you're in Brill.",
        },
        { type = "accept", questName = "A Putrid Task", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "Vital Intelligence", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "accept", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Brill",
        },
        {
          type = "accept", questName = "Proof of Demise", zone = "Tirisfal Glades",
          location = "Brill",
          note = "Cannot be done on live until after the first part of At War with the Scarlet Crusade.",
        },
        { type = "accept", questName = "Wanted: Maggot Eye", zone = "Tirisfal Glades", location = "Brill" },
        { type = "accept", questName = "Graverobbers", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "A Rogue's Deal", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "hearth", name = "Gallow's End Tavern", zone = "Tirisfal Glades",
          location = "Brill",
          note = "Bind your hearthstone here. Train level 6 skills here. Buy level 5 food/drink. Skip First Aid for now (money).",
        },
        { type = "accept", questName = "A New Plague", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "complete", questName = "A New Plague", zone = "Tirisfal Glades",
          note = "Partial progress - work on this while you are here, then move on. Kill dogs outside the house, then near the Zeppelin, then large loop from zep tower to farmstead.",
        },
        {
          type = "complete", questName = "A Putrid Task", zone = "Tirisfal Glades",
          location = "Cold Hearth Manor",
          note = "Partial progress - work on this while you are here, then move on.",
        },
        {
          type = "complete", questName = "Gordo's Task", zone = "Tirisfal Glades",
          location = "Multiple Areas",
        },
        {
          type = "complete", questName = "A New Plague", zone = "Tirisfal Glades",
          location = "Cold Hearth Manor",
        },
        {
          type = "complete", questName = "A Putrid Task", zone = "Tirisfal Glades",
          location = "Cold Hearth Manor",
        },
        {
          type = "complete", questName = "Graverobbers", zone = "Tirisfal Glades",
          location = "Garren's Haunt",
          note = "Partial progress - work on this while you are here, then move on. Southwest near the mass grave is the best spot for these.",
        },
        {
          type = "complete", questName = "Wanted: Maggot Eye", zone = "Tirisfal Glades",
          location = "Garren's Haunt",
        },
        {
          type = "complete", questName = "Graverobbers", zone = "Tirisfal Glades",
          location = "Garren's Haunt",
          note = "May have to grind in the fields for Embalming Ichor.",
        },
        {
          type = "death", name = "Brill Graveyard", zone = "Tirisfal Glades",
          location = "Garren's Haunt",
          note = "Intentional death. Release and rez at the graveyard named here.",
        },
        { type = "turnin", questName = "Gordo's Task", zone = "Tirisfal Glades", location = "Brill" },
        { type = "accept", questName = "Deaths in the Family", zone = "Tirisfal Glades", location = "Brill" },
        { type = "accept", questName = "The Haunted Mills", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "accept", questName = "The Chill of Death", zone = "Tirisfal Glades",
          location = "Brill", note = "Buy more food and drink before leaving.",
        },
        { type = "turnin", questName = "Wanted: Maggot Eye", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "Graverobbers", zone = "Tirisfal Glades", location = "Brill" },
        { type = "accept", questName = "Forsaken Duties", zone = "Tirisfal Glades", location = "Brill" },
        { type = "accept", questName = "The Prodigal Lich", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "A New Plague", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "accept", questName = "A New Plague", zone = "Tirisfal Glades",
          location = "Brill", note = "Part 2, for killing murlocs.",
        },
        { type = "turnin", questName = "A Putrid Task", zone = "Tirisfal Glades", location = "Brill" },
        { type = "accept", questName = "The Mills Overrun", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "complete", questName = "The Chill of Death", zone = "Tirisfal Glades",
          location = "Multiple Areas",
          note = "Partial progress - work on this while you are here, then move on. Start south of Brill and work your way up to Agamand Mills.",
        },
        {
          type = "complete", questName = "Deaths in the Family", zone = "Tirisfal Glades",
          location = "Agamand Mills",
          note = "Partial progress - work on this while you are here, then move on.",
        },
        {
          type = "complete", questName = "The Mills Overrun", zone = "Tirisfal Glades",
          location = "Agamand Mills",
          note = "Partial progress - work on this while you are here, then move on.",
        },
        {
          type = "accept", questName = "A Letter Undelivered", zone = "Tirisfal Glades",
          location = "Agamand Mills",
          note = "Random drop from mobs in Agamand Mills. Not worth farming for. Worth 480 XP (See 89E).",
        },
        {
          type = "complete", questName = "Deaths in the Family", zone = "Tirisfal Glades",
          location = "Agamand Mills",
        },
        {
          type = "complete", questName = "The Haunted Mills", zone = "Tirisfal Glades",
          location = "Agamand Mills",
        },
        {
          type = "complete", questName = "The Mills Overrun", zone = "Tirisfal Glades",
          location = "Agamand Mills",
        },
        {
          type = "complete", questName = "The Chill of Death", zone = "Tirisfal Glades",
          location = "Agamand Mills",
          note = "Can carry this quest with you thoughout the zone. Worth 700 XP, adjust level 10 turn in calculations accordingly (See 89E).",
        },
        {
          type = "complete", questName = "A New Plague", zone = "Tirisfal Glades",
          location = "West Coast",
          note = "Partial progress - work on this while you are here, then move on.",
        },
        { type = "complete", questName = "A New Plague", zone = "Tirisfal Glades", location = "West Coast" },
        {
          type = "complete", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Solliden Farmstead",
          note = "Partial progress - work on this while you are here, then move on.",
        },
        {
          type = "complete", questName = "Proof of Demise", zone = "Tirisfal Glades",
          location = "Solliden Farmstead",
          note = "Partial progress - work on this while you are here, then move on. Can carry this quest with you thoughout the zone. Worth 625 XP, adjust level 10 turn in calculations accordingly (See 89E).",
        },
        {
          type = "complete", questName = "Fields of Grief", zone = "Tirisfal Glades",
          location = "Solliden Farmstead",
          note = "Partial progress - work on this while you are here, then move on.",
        },
        {
          type = "complete", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Solliden Farmstead",
        },
        {
          type = "complete", questName = "Proof of Demise", zone = "Tirisfal Glades",
          location = "Solliden Farmstead",
        },
        {
          type = "complete", questName = "Fields of Grief", zone = "Tirisfal Glades",
          location = "Solliden Farmstead",
          note = "You must be at least XXXX/5400 into Level 8 at this point to hit level 10 with all the turn ins (not including A Letter Undelivered).",
        },
        {
          type = "hearth", name = "to Gallows' End Tavern", zone = "Tirisfal Glades",
          location = "Solliden Farmstead", note = "Use your hearthstone.",
        },
        { type = "turnin", questName = "A Letter Undelivered", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "accept", questName = "The Haunted Mills", zone = "Tirisfal Glades",
          location = "Brill", note = "Part 2, for Captian Perrine.",
        },
        { type = "turnin", questName = "Deaths in the Family", zone = "Tirisfal Glades", location = "Brill" },
        { type = "accept", questName = "Speak with Sevren", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "turnin", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Brill",
        },
        {
          type = "accept", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Brill", note = "Part 2, for Captian Perrine.",
        },
        { type = "turnin", questName = "Proof of Demise", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "Speak with Sevren", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "The Mills Overrun", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "A New Plague", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "accept", questName = "A New Plague", zone = "Tirisfal Glades",
          location = "Brill", note = "Part 3, for killing spiders.",
        },
        { type = "turnin", questName = "Fields of Grief", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "accept", questName = "Fields of Grief", zone = "Tirisfal Glades",
          location = "Brill", note = "Part 2, give pumpkin to human in basement.",
        },
        { type = "turnin", questName = "Fields of Grief", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "The Chill of Death", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "turnin", questName = "Forsaken Duties", zone = "Tirisfal Glades",
          location = "Northeast of Undercity",
        },
        {
          type = "accept", questName = "Return to the Magistrate", zone = "Tirisfal Glades",
          location = "Northeast of Undercity",
        },
        {
          type = "accept", questName = "Rear Guard Patrol", zone = "Tirisfal Glades",
          location = "Northeast of Undercity",
        },
        {
          type = "complete", questName = "The Prodigal Lich", zone = "Undercity",
          location = "The Magic Quarter",
        },
        {
          type = "accept", questName = "The Lich's Identity", zone = "Undercity",
          location = "The Magic Quarter",
        },
        {
          type = "complete", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Nightmare Vale",
          note = "Exit the sewers from Undercity to get here.",
        },
        {
          type = "turnin", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Brill",
        },
        {
          type = "accept", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Brill",
          note = "Part 3, for killing Captain Vachon.",
        },
        {
          type = "complete", questName = "The Lich's Identity", zone = "Tirisfal Glades",
          location = "Gunther's Retreat",
        },
        {
          type = "complete", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Crusader Outpost",
          note = "Partial progress - work on this while you are here, then move on. Approach Crusader Outpost from the West, drop down into Balnir Farmstead",
        },
        {
          type = "complete", questName = "Rear Guard Patrol", zone = "Tirisfal Glades",
          location = "Balnir Farmstead",
          note = "Partial progress - work on this while you are here, then move on. Go from West to East through farmstead as you loop south of Crusader Outpost",
        },
        {
          type = "complete", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Crusader Outpost",
          note = "Approach tower from the Southeast and complete quest on the way to Venomweb Vale",
        },
        { type = "complete", questName = "A New Plague", zone = "Tirisfal Glades", location = "Venomweb Vale" },
        {
          type = "complete", questName = "Rear Guard Patrol", zone = "Tirisfal Glades",
          location = "Balnir Farmstead",
        },
        {
          type = "turnin", questName = "Rear Guard Patrol", zone = "Tirisfal Glades",
          location = "Northeast of Undercity",
        },
        {
          type = "turnin", questName = "The Lich's Identity", zone = "Undercity",
          location = "The Magic Quarter",
        },
        { type = "accept", questName = "Return the Book", zone = "Undercity", location = "The Magic Quarter" },
        {
          type = "turnin", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Brill",
        },
        {
          type = "accept", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Brill",
          note = "Part 4, for killing Captain Melrache",
        },
        {
          type = "turnin", questName = "Return to the Magistrate", zone = "Tirisfal Glades",
          location = "Brill",
        },
        { type = "turnin", questName = "A New Plague", zone = "Tirisfal Glades", location = "Brill" },
        { type = "accept", questName = "Delivery to Silverpine", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "accept", questName = "A New Plague", zone = "Tirisfal Glades",
          location = "Brill", note = "Part 4, give drink to dwarf in basement.",
        },
        { type = "trainer", name = "First Aid", zone = "Tirisfal Glades", location = "Brill" },
        { type = "turnin", questName = "A New Plague", zone = "Tirisfal Glades", location = "Brill" },
        {
          type = "complete", questName = "Return the Book", zone = "Tirisfal Glades",
          location = "Gunther's Retreat",
        },
        {
          type = "accept", questName = "Proving Allegiance", zone = "Tirisfal Glades",
          location = "Gunther's Retreat",
        },
        {
          type = "complete", questName = "Proving Allegiance", zone = "Tirisfal Glades",
          location = "Gunther's Retreat",
        },
        {
          type = "turnin", questName = "Proving Allegiance", zone = "Tirisfal Glades",
          location = "Gunther's Retreat",
        },
        {
          type = "accept", questName = "The Prodigal Lich Returns", zone = "Tirisfal Glades",
          location = "Gunther's Retreat",
        },
        {
          type = "complete", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Scarlet Watch Post",
          note = "Northeast of Gunther's Retreat, can approach directly instead of taking the road that loops around south of the tower.",
        },
        {
          type = "hearth", name = "to Gallows' End Tavern", zone = "Tirisfal Glades",
          location = "Scarlet Watch Post",
          note = "Use your hearthstone. You must be XXXX/8800 into Level 11 to hit 12 before Silverpine with all turn ins.",
        },
        {
          type = "turnin", questName = "At War with the Scarlet Crusade",
          zone = "Tirisfal Glades", location = "Brill",
        },
        {
          type = "hearth", name = "Undercity", zone = "Undercity",
          location = "The Trade Quarter",
          note = "Bind your hearthstone here. Learn flight path if you haven't already.",
        },
        {
          type = "turnin", questName = "The Prodigal Lich Returns", zone = "Undercity",
          location = "The Magic Quarter",
          note = "Train before leaving for Silverpine if you're level 12.",
        },

        { type = "section", name = "Silverpine Forest 1st Loop" },
        {
          type = "manual", name = "Discolored Worg Heart x6", zone = "Silverpine Forest",
          location = "Malden's Orchard",
          note = "Collect these as you go - they drop across the whole leg. Needed for Wild Hearts. Drops from Worgs and Discolored Worgs.",
        },
        {
          type = "accept", questName = "Escorting Erland", zone = "Silverpine Forest",
          location = "Malden's Orchard",
          note = "Due to competition it is worth checking for him and doing him on the way into the zone. If he's not there, death warp to the Sepulcher and do it later.",
        },
        {
          type = "complete", questName = "Escorting Erland", zone = "Silverpine Forest",
          location = "Malden's Orchard",
        },
        {
          type = "turnin", questName = "Escorting Erland", zone = "Silverpine Forest",
          location = "The Ivar Patch",
        },
        {
          type = "accept", questName = "The Deathstalkers' Report", zone = "Silverpine Forest",
          location = "The Ivar Patch",
        },
        {
          type = "death", name = "Sepulcher Graveyard", zone = "Silverpine Forest",
          location = "The Ivar Patch",
          note = "Intentional death. Release and rez at the graveyard named here. Die in the pumpkin field after accepting The Deathstalkers' Report.",
        },
        {
          type = "accept", questName = "Lost Deathstalkers", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "The Deathstalkers' Report", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "The Dead Fields", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Delivery to Silverpine Forest",
          zone = "Silverpine Forest", location = "The Sepulcher",
        },
        {
          type = "accept", questName = "A Recipe for Death", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Border Crossings", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Prove your Worth", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "travel", name = "Bat Handler", zone = "Silverpine Forest",
          location = "The Sepulcher",
          note = "Talk to the flight master and learn this flight point.",
        },
        {
          type = "complete", questName = "The Dead Fields", zone = "Silverpine Forest",
          location = "The Dead Field",
        },
        {
          type = "complete", questName = "A Recipe For Death", zone = "Silverpine Forest",
          location = "The Skittering Dark",
        },
        {
          type = "accept", questName = "The Deathstalkers' Report", zone = "Silverpine Forest",
          location = "The Ivar Patch",
          note = "If you weren't able to get Escorting Erland earlier, do it now.",
        },
        { type = "accept", questName = "Wild Hearts", zone = "Silverpine Forest", location = "The Ivar Patch" },
        {
          type = "complete", questName = "Wild Hearts", zone = "Silverpine Forest",
          location = "The Ivar Patch",
        },
        {
          type = "complete", questName = "Prove your Worth", zone = "Silverpine Forest",
          location = "East of The Sepulcher",
        },

        { type = "section", name = "Silverpine Forest 2nd Loop" },
        {
          type = "turnin", questName = "The Deathstalkers' Report", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Speak with Renferrel", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "The Dead Fields", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "The Decrepit Ferry", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        { type = "turnin", questName = "Wild Hearts", zone = "Silverpine Forest", location = "The Sepulcher" },
        {
          type = "accept", questName = "Return to Quinn", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Speak with Renferrel", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Zinge's Delivery", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Prove your Worth", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Return to Quinn", zone = "Silverpine Forest",
          location = "The Ivar Patch",
        },
        {
          type = "accept", questName = "Ivar the Foul", zone = "Silverpine Forest",
          location = "The Ivar Patch",
        },
        {
          type = "complete", questName = "Ivar the Foul", zone = "Silverpine Forest",
          location = "The Ivar Patch",
        },
        {
          type = "turnin", questName = "Ivar the Foul", zone = "Silverpine Forest",
          location = "The Ivar Patch",
        },
        {
          type = "complete", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "Valgan's Field",
        },
        {
          type = "turnin", questName = "The Decrepit Ferry", zone = "Silverpine Forest",
          location = "The Decrepit Ferry",
        },
        {
          type = "accept", questName = "Rot Hide Clues", zone = "Silverpine Forest",
          location = "The Decrepit Ferry",
        },
        {
          type = "turnin", questName = "Rot Hide Clues", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "The Engraved Ring", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "The Sepulcher",
          note = "Part 2, for collecting Glutton/Darksoul shackles.",
        },
        {
          type = "complete", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "North Tide's Hollow",
        },
        {
          type = "turnin", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "The Sepulcher",
          note = "Part 3, for killing Grimson the Pale in the Deep Elm Mine.",
        },

        { type = "section", name = "Silverpine Forest 3rd Loop" },
        {
          type = "complete", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "Deep Elem Mine",
        },
        {
          type = "turnin", questName = "Border Crossings", zone = "Silverpine Forest",
          location = "West of Ambermill",
        },
        {
          type = "accept", questName = "Maps and Runes", zone = "Silverpine Forest",
          location = "West of Ambermill",
          note = "You can spirit rez here if it makes sense for you to do so. If you're not sure, just walk.",
        },
        {
          type = "turnin", questName = "Maps and Runes", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Dalar's Analysis", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Dalar's Analysis", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Arugal's Folly", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Dalaran's Intentions", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Dalaran's Intentions", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Ambermill Investigations", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "complete", questName = "Ambermill Investigations",
          zone = "Silverpine Forest", location = "The Sepulcher",
          note = "You must be at least XXXX/11400 into level 13 to hit 14 before going to Durotar. Grind here until you reach that point, then spirit rez.",
        },
        {
          type = "death", name = "Sepulcher Graveyard", zone = "Silverpine Forest",
          location = "Ambermill",
          note = "Intentional death. Release and rez at the graveyard named here. Die anywhere in Ambermill.",
        },
        {
          type = "turnin", questName = "Ambermill Investigations", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Supplying the Sepulcher", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "turnin", questName = "Supplying the Sepulcher", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "accept", questName = "Ride to the Undercity", zone = "Silverpine Forest",
          location = "The Sepulcher",
        },
        {
          type = "hearth", name = "to The Undercity", zone = "Silverpine Forest",
          location = "The Sepulcher", note = "Use your hearthstone.",
        },
        {
          type = "turnin", questName = "Ride to the Undercity", zone = "Undercity",
          location = "The Trade Quarter",
        },
        { type = "accept", questName = "Michael Garrett", zone = "Undercity", location = "The Trade Quarter" },
        { type = "turnin", questName = "Michael Garrett", zone = "Undercity", location = "The Trade Quarter" },
        {
          type = "turnin", questName = "A Recipe For Death", zone = "Undercity",
          location = "The Apothecarium",
        },
        { type = "turnin", questName = "Zinge's Delivery", zone = "Undercity", location = "The Apothecarium" },
        {
          type = "accept", questName = "Sample for Helbrim", zone = "Undercity",
          location = "The Apothecarium",
        },
        {
          type = "accept", questName = "The Power to Destroy...", zone = "Undercity",
          location = "The Royal Quarter", npc = "Varimathras", note = "RFC Quest",
        },
        {
          type = "turnin", questName = "The Engraved Ring", zone = "Tirisfal Glades",
          location = "Brill",
          note = "You should be level 14 by now. Train in Brill before heading to Kalimdor.",
        },
        {
          type = "accept", questName = "Raleigh and the Undercity", zone = "Tirisfal Glades",
          location = "Brill",
        },
        {
          type = "travel", name = "Brill to Durotar", zone = "Tirisfal Glades",
          location = "Brill", note = "Zeppelin.",
        },
        {
          type = "travel", name = "Wind Rider Master", zone = "Orgrimmar",
          note = "Talk to the flight master and learn this flight point.",
        },

        { type = "section", name = "From here, continue with the regular route everyone else uses. Skip the part in the route where it has you go to Silverpine for the first time as you've done all those quests." },
    },
})
