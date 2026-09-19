-- TuFFlevels / Routes/Horde1-60.lua
--
-- The structural half of a 1-60 Orc/Troll route: every section, its level
-- band, where to base, and where grinding beats questing.
--
-- WHAT THIS IS AND ISN'T
--
-- This contains NO quest IDs, because I don't have a quest database and
-- inventing them would produce an addon that looks finished and silently
-- lies to you. Everything here is factual: zone level bands, hub names,
-- where quest density drops off.
--
-- HOW TO FILL IT IN
--
-- Load this route, turn recording on, and play it. Every quest you accept
-- and turn in gets recorded with its real ID and real coordinates, in the
-- section you were in at the time. Then export and you have a complete
-- route - structure from here, data from your own client.
--
-- Read whatever guide you like alongside it. Reading a guide and playing
-- it is how every route in existence got made.

local ADDON, ns = ...

ns.RegisterRoute("Horde 1-60 (Orc/Troll)", {
    faction = "Horde",
    races   = { "Orc", "Troll" },
    levels  = { 1, 60 },
    skeleton = true,

    steps = {

        -- ================= 1-12 DUROTAR =================
        { type = "section", name = "Valley of Trials", levels = { 1, 6 } },
        { type = "note", name = "Clear it completely",
          note = "Densest questing in the game relative to travel. Nothing here is skippable." },
        { type = "note", name = "Jagged Dagger chain",
          note = "Starts with Report to Orgnil. Leads to Skull Rock. Needs about level 8 to solo - come back for it." },

        { type = "section", name = "Razor Hill", levels = { 6, 10 } },
        { type = "note", name = "Flight path",
          note = "Grab the Razor Hill flight point the moment you arrive. You will use it constantly." },
        { type = "note", name = "Rogue class quest at 10",
          note = "Blade of Cunning. Your first green weapon and a big agility jump. Do not skip it." },

        { type = "section", name = "Sen'jin Village", levels = { 8, 12 } },
        { type = "note", name = "Echo Isles",
          note = "Cluster of short quests offshore. Good density, easy to overlook." },

        -- ================= 10-20 BARRENS =================
        { type = "section", name = "The Barrens - Crossroads", levels = { 10, 16 } },
        { type = "note", name = "Crossroads flight path first",
          note = "Everything radiates from here. Take the flight point before any quest." },
        { type = "note", name = "Work outward, not in order",
          note = "Barrens quests spray across the whole zone. Group them by direction and clear a wedge at a time." },

        { type = "section", name = "The Barrens - Ratchet and south", levels = { 15, 20 } },
        { type = "note", name = "Ratchet",
          note = "Flight path, bank, auction house. Wharfmaster Dizzywig chain starts here." },
        { type = "note", name = "Wailing Caverns",
          note = "Horde-favoured dungeon. Tail Spike drops off Skum - a real weapon upgrade around 17." },

        -- ================= 20-30 =================
        { type = "section", name = "Stonetalon Mountains", levels = { 20, 25 } },
        { type = "note", name = "Sun Rock Retreat",
          note = "A lot of running for the payoff. Take it if the Barrens is crowded, skip if not." },

        { type = "section", name = "Ashenvale", levels = { 20, 27 } },
        { type = "note", name = "Splintertree Post",
          note = "Strong density. Contested with Alliance the whole way through - expect interruptions on a PvP realm." },

        { type = "section", name = "Thousand Needles", levels = { 25, 30 } },
        { type = "note", name = "Freewind Post",
          note = "Compact and fast. Shimmering Flats racetrack quests are quick." },

        { type = "section", name = "Hillsbrad Foothills", levels = { 22, 28 } },
        { type = "note", name = "Tarren Mill",
          note = "Excellent density, notorious PvP. On a busy PvP realm this can cost more time than it saves." },

        -- ================= 30-40 =================
        { type = "section", name = "Desolace", levels = { 30, 35 } },
        { type = "note", name = "Shadowprey Village",
          note = "Centaur reputation quests are repeatable and fast if you need to close a level." },
        { type = "note", name = "Kalimdor thins here",
          note = "This is where Horde Kalimdor starts running short. Grinding becomes a real option rather than a fallback." },

        { type = "section", name = "Stranglethorn Vale", levels = { 30, 38 } },
        { type = "note", name = "Grom'gol Base Camp",
          note = "Zeppelin straight from Durotar. Huge quest count, brutal PvP, enormous zone." },
        { type = "note", name = "Nesingwary chain",
          note = "Long, self-contained, good experience. Worth it if you're settling in." },

        { type = "section", name = "Dustwallow Marsh", levels = { 33, 38 } },
        { type = "note", name = "Brackenwall Village",
          note = "Sparse, but individual quests are short. Good for topping off a level." },

        { type = "section", name = "Badlands", levels = { 35, 40 } },
        { type = "note", name = "Kargath",
          note = "Tight cluster around one hub. Very little travel time. Strong if you don't mind repetition." },
        { type = "grind", targetLevel = 40,
          note = "Rogue note: humanoids pay twice here. Pickpocket every one - junkbox money adds up to your mount." },

        -- ================= 40-50 =================
        { type = "section", name = "MOUNT AT 40", levels = { 40, 40 } },
        { type = "note", name = "Buy it immediately",
          note = "Biggest single speed increase in the game. If you're short, stop and farm. Every hour before the mount is slower than every hour after." },

        { type = "section", name = "Tanaris", levels = { 40, 45 } },
        { type = "note", name = "Gadgetzan",
          note = "Major flight hub. Zul'Farrak runs stage from here and are worth doing for the experience alone." },

        { type = "section", name = "Feralas", levels = { 40, 47 } },
        { type = "note", name = "Camp Mojache",
          note = "Good density, far less traffic than Stranglethorn. Underrated." },

        { type = "section", name = "The Hinterlands", levels = { 42, 48 } },
        { type = "note", name = "Revantusk Village",
          note = "Far east coast and easy to miss entirely. Getting there is most of the cost." },

        { type = "section", name = "Un'Goro Crater", levels = { 45, 50 } },
        { type = "note", name = "Marshal's Refuge",
          note = "Dense, self-contained, low travel. One of the best zones in this band." },
        { type = "note", name = "Devilsaur leather",
          note = "If you have skinning, stealth past the devilsaurs and skin them. Best gold in the zone by a wide margin." },

        -- ================= 50-60 =================
        { type = "section", name = "Felwood", levels = { 48, 54 } },
        { type = "note", name = "Bloodvenom Post",
          note = "Timbermaw reputation starts here and carries into Winterspring. Worth starting early." },

        { type = "section", name = "Burning Steppes", levels = { 48, 55 } },
        { type = "note", name = "Flame Crest",
          note = "Get the flight path early - this is your staging ground for Blackrock later." },

        { type = "section", name = "Western Plaguelands", levels = { 50, 56 } },
        { type = "note", name = "The Bulwark",
          note = "Scholomance and Stratholme attunement work starts around here." },

        { type = "section", name = "Winterspring", levels = { 52, 58 } },
        { type = "note", name = "Everlook",
          note = "Northern hub. Black Lotus spawns in this zone - worth knowing as a rogue since stealth makes the circuit safe." },

        { type = "section", name = "Eastern Plaguelands", levels = { 54, 60 } },
        { type = "note", name = "Light's Hope Chapel",
          note = "Final stretch. Argent Dawn reputation matters later for raid consumables - bank the turn-ins." },

        { type = "section", name = "Silithus", levels = { 55, 60 } },
        { type = "note", name = "Cenarion Hold",
          note = "Thin questing. Mostly here for reputation and Black Lotus. Skip if you have EPL quests left." },

        { type = "grind", targetLevel = 60,
          note = "Wherever quests run out, grind humanoids. You're a rogue - pick the pulls, pickpocket everything, and the gold funds your 60 consumables." },

        { type = "section", name = "60", levels = { 60, 60 } },
        { type = "note", name = "Done",
          note = "Now record this route properly and it's worth something to someone else." },
    },
})
