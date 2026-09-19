-- TuFFlevels / Routes/Horde/Dungeon/06-UldumanBlitz.lua
--
-- Part 6 of the 5-man Horde 1-60 dungeon route.
-- Sections: Ulduman Blitz (level 44-46) | Continued (level 44-46)
--
-- The source sheet for this route carries NO coordinates, so these steps
-- name a zone and a location and nothing more. The arrow stays blank; the
-- tracker still advances off quest events exactly as it does elsewhere.

local ADDON, ns = ...
local Part = ns.DungeonPart

Part(6, {

    { type = "section", name = "Ulduman Blitz (level 44-46)", levels = { 44, 46 } },
    { type = "note", name = "Note", note = "F off Desolace" },
    {
      type = "travel", name = "Orgrimmar to Desolace", zone = "Orgrimmar", logCount = 8,
      note = "Take the flight path.",
    },
    {
      type = "accept", questName = "Portals of the Legion", zone = "Desolace",
      location = "Shadowprey Village", logCount = 9,
    },
    {
      type = "complete", questName = "Portals of the Legion", zone = "Desolace",
      location = "Mannoroc Coven", logCount = 9,
    },
    {
      type = "accept", questName = "Ghost-o-plasm Round Up", zone = "Desolace",
      location = "Kodo Graveyard", logCount = 10,
    },
    {
      type = "accept", name = "The Corrupter (part 5)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 11,
    },
    {
      type = "complete", questName = "Ghost-o-plasm Round Up", zone = "Desolace",
      location = "Magram Village", logCount = 11,
    },
    {
      type = "complete", name = "The Corrupter (part 5)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Mannoroc Coven", logCount = 11,
    },
    {
      type = "turnin", name = "The Corrupter (part 5)", questName = "The Corrupter",
      ambiguous = true, zone = "Desolace", location = "Ghostwalker Post", logCount = 10,
    },
    {
      type = "turnin", questName = "Ghost-o-plasm Round Up", zone = "Desolace",
      location = "Kodo Graveyard", logCount = 9,
    },
    {
      type = "turnin", questName = "Portals of the Legion", zone = "Desolace",
      location = "Shadowprey Village", logCount = 8,
    },
    {
      type = "travel", name = "Shadowprey Village to Gadgetzan", zone = "Desolace",
      location = "Shadowprey Village", logCount = 8, note = "Take the flight path.",
    },
    { type = "note", name = "Note", note = "First Tanaris Pass" },
    {
      type = "travel", name = "Orgrimmar to Thousand Needles", zone = "The Barrens",
      location = "Freewind Post", logCount = 8, note = "Take the flight path.",
    },
    {
      type = "note", name = "Note", note = "Run to Tanaris", zone = "Thousand Needles",
      location = "Freewind Post",
    },
    {
      type = "accept", questName = "Gahz'rilla", zone = "Thousand Needles",
      location = "Shimmering Flats", logCount = 9,
    },
    { type = "turnin", questName = "Tran'rek", zone = "Tanaris", location = "Gadgetzan", logCount = 8 },
    {
      type = "note", name = "Skip: Scarab Shells",
      note = "Do not pick up Scarab Shells yet - the route comes back for it.",
      zone = "Tanaris", location = "Gadgetzan",
    },
    {
      type = "accept", questName = "WANTED: Andre Firebeard", zone = "Tanaris",
      location = "Gadgetzan", logCount = 9,
    },
    {
      type = "accept", questName = "WANTED: Caliph Scorpidsting", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10,
    },
    {
      type = "hearth", name = "Set Hearth to Gadgetzan", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10, note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "Wastewander Justice", zone = "Tanaris",
      location = "Gadgetzan", logCount = 11,
    },
    {
      type = "accept", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Gadgetzan", logCount = 12,
    },
    { type = "turnin", questName = "Into the Field", zone = "Tanaris", location = "Gadgetzan", logCount = 11 },
    { type = "accept", questName = "Slake That Thirst", zone = "Tanaris", location = "Gadgetzan", logCount = 12 },
    {
      type = "note", name = "Skip: The Divino-matic Rod",
      note = "Do not pick up The Divino-matic Rod yet - the route comes back for it.",
      zone = "Tanaris", location = "Gadgetzan",
    },
    {
      type = "note", name = "Skip: The Thirsty Goblin",
      note = "Do not pick up The Thirsty Goblin yet - the route comes back for it.",
      zone = "Tanaris", location = "Gadgetzan",
    },
    {
      type = "note", name = "Skip: Troll Temper",
      note = "Do not pick up Troll Temper yet - the route comes back for it.",
      zone = "Tanaris", location = "Gadgetzan",
    },
    {
      type = "complete", questName = "Wastewander Justice", zone = "Tanaris",
      location = "Noonshade Ruins", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Slake That Thirst", zone = "Tanaris",
      location = "Noonshade Ruins", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Noonshade Ruins", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", questName = "Pirate Hats Ahoy!", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 13,
    },
    {
      type = "accept", questName = "Screecher Spirits", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 14,
      note = "Note: Need to do this for ZF and ST",
    },
    {
      type = "accept", questName = "Southsea Shakedown", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 15,
    },
    {
      type = "turnin", questName = "Stoley's Debt", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 14,
    },
    {
      type = "accept", questName = "Stoley's Shipment", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 15,
    },
    {
      type = "complete", questName = "Wastewander Justice", zone = "Tanaris",
      location = "Winterspring Field", logCount = 15,
    },
    {
      type = "complete", questName = "Slake That Thirst", zone = "Tanaris",
      location = "Winterspring Field", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Winterspring Field", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "turnin", questName = "Wastewander Justice", zone = "Tanaris",
      location = "Gadgetzan", logCount = 14,
    },
    {
      type = "accept", questName = "More Wastewander Justice", zone = "Tanaris",
      location = "Gadgetzan", logCount = 15,
    },
    {
      type = "complete", questName = "Slake That Thirst", zone = "Tanaris",
      location = "Winterspring Field", logCount = 15,
    },
    {
      type = "complete", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Winterspring Field", logCount = 15,
    },
    {
      type = "complete", questName = "WANTED: Caliph Scorpidsting", zone = "Tanaris",
      location = "Winterspring Field", logCount = 15,
    },
    {
      type = "complete", questName = "More Wastewander Justice", zone = "Tanaris",
      location = "Winterspring Field", logCount = 15,
    },
    {
      type = "complete", questName = "Southsea Shakedown", zone = "Tanaris",
      location = "Lost Rigger Cove", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Pirate Hats Ahoy!", zone = "Tanaris",
      location = "Lost Rigger Cove", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "WANTED: Andre Firebeard", zone = "Tanaris",
      location = "Lost Rigger Cove", logCount = 15,
    },
    {
      type = "complete", questName = "Stoley's Shipment", zone = "Tanaris",
      location = "Lost Rigger Cove", logCount = 15,
    },
    {
      type = "accept", questName = "Ship Schedules", zone = "Tanaris",
      location = "Lost Rigger Cove", logCount = 16,
      note = "Note: Accept this quest ASAP so it doesnt keep dropping just for you.  LOW DROP, possible not everyone will get it",
    },
    {
      type = "complete", questName = "Southsea Shakedown", zone = "Tanaris",
      location = "Lost Rigger Cove", logCount = 16,
    },
    {
      type = "complete", questName = "Pirate Hats Ahoy!", zone = "Tanaris",
      location = "Lost Rigger Cove", logCount = 16,
      note = "Note: if this place is fucked with people, leave this quest behind",
    },
    {
      type = "turnin", questName = "Stoley's Shipment", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 15,
    },
    {
      type = "accept", questName = "Deliver to MacKinley", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 16,
    },
    {
      type = "turnin", questName = "WANTED: Andre Firebeard", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 15,
    },
    {
      type = "turnin", questName = "Ship Schedules", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 14,
    },
    {
      type = "turnin", questName = "Southsea Shakedown", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 13,
    },
    {
      type = "turnin", questName = "Pirate Hats Ahoy!", zone = "Tanaris",
      location = "Steamwheedle Port", logCount = 12,
    },
    {
      type = "hearth", name = "Hearth to Gadgetzan", zone = "Tanaris", location = "Gadgetzan",
      logCount = 12, note = "Use your hearthstone.",
    },
    { type = "turnin", questName = "Slake That Thirst", zone = "Tanaris", location = "Gadgetzan", logCount = 11 },
    {
      type = "accept", questName = "Tanaris Field Sampling", zone = "Tanaris",
      location = "Gadgetzan", logCount = 12,
    },
    {
      type = "turnin", questName = "Water Pouch Bounty", zone = "Tanaris",
      location = "Gadgetzan", logCount = 11,
    },
    {
      type = "turnin", questName = "WANTED: Caliph Scorpidsting", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10,
    },
    {
      type = "turnin", questName = "More Wastewander Justice", zone = "Tanaris",
      location = "Gadgetzan", logCount = 9,
    },
    {
      type = "accept", questName = "Gadgetzan Water Survey", zone = "Tanaris",
      location = "Gadgetzan", logCount = 10,
    },
    {
      type = "complete", questName = "Tanaris Field Sampling", zone = "Tanaris",
      location = "West of Gadgetzan", logCount = 10,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Gadgetzan Water Survey", zone = "Tanaris",
      location = "Sandsorrow Watch", logCount = 10,
    },
    {
      type = "complete", questName = "Tanaris Field Sampling", zone = "Tanaris",
      location = "West of Gadgetzan", logCount = 10,
    },
    {
      type = "turnin", questName = "Gadgetzan Water Survey", zone = "Tanaris",
      location = "Gadgetzan", logCount = 9,
    },
    {
      type = "note", name = "Skip: Noxious Lair Investigation",
      note = "Do not pick up Noxious Lair Investigation yet - the route comes back for it.",
      zone = "Tanaris", location = "Gadgetzan",
    },
    {
      type = "turnin", questName = "Tanaris Field Sampling", zone = "Tanaris",
      location = "Gadgetzan", logCount = 8,
    },
    {
      type = "accept", questName = "Return to Apothecary Zinge", zone = "Tanaris",
      location = "Gadgetzan", logCount = 9,
    },
    {
      type = "travel", name = "Gadgetzan to Freewind Post", zone = "Tanaris",
      location = "Gadgetzan", logCount = 9, note = "Take the flight path.",
    },
    {
      type = "note", name = "Note", note = "Run to Feralas", zone = "Thousand Needles",
      location = "Freewind Post",
    },
    { type = "note", name = "Note", note = "Feralas Pass" },
    {
      type = "hearth", name = "Set Hearth to Camp Mojache", zone = "Feralas",
      location = "Camp Mojache", logCount = 9, note = "Bind your hearthstone here.",
    },
    {
      type = "accept", questName = "A Strange Request", zone = "Feralas",
      location = "Camp Mojache", logCount = 10,
    },
    {
      type = "travel", name = "Camp Mojache To Ogrimmar", zone = "Feralas",
      location = "Camp Mojache", logCount = 10, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "A Strange Request", zone = "Orgrimmar",
      location = "The Cleft of Shadow", logCount = 9,
    },
    {
      type = "accept", questName = "Return to Witch Doctor Uzer'i", zone = "Orgrimmar",
      location = "The Cleft of Shadow", logCount = 10,
    },
    {
      type = "accept", questName = "A Threat in Feralas", zone = "Orgrimmar",
      location = "The Valley of Honor", logCount = 11,
    },
    {
      type = "hearth", name = "Hearth to Camp Mojache", zone = "Orgrimmar",
      location = "The Valley of Honor", logCount = 11, note = "Use your hearthstone.",
    },
    {
      type = "turnin", questName = "A Threat in Feralas", zone = "Feralas",
      location = "Camp Mojache", logCount = 10,
    },
    {
      type = "accept", name = "The Ogres of Feralas (part 1)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Camp Mojache", logCount = 11,
    },
    {
      type = "accept", questName = "Gordunni Cobalt", zone = "Feralas",
      location = "Camp Mojache", logCount = 12,
    },
    {
      type = "turnin", questName = "Return to Witch Doctor Uzer'i", zone = "Feralas",
      location = "Camp Mojache", logCount = 11,
    },
    {
      type = "accept", questName = "Testing the Vessel", zone = "Feralas",
      location = "Camp Mojache", logCount = 12,
    },
    {
      type = "accept", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Camp Mojache", logCount = 13,
    },
    {
      type = "accept", questName = "War on the Woodpaw", zone = "Feralas",
      location = "Camp Mojache", logCount = 14,
    },
    {
      type = "note", name = "Skip: The Mark of Quality",
      note = "Do not pick up The Mark of Quality yet - the route comes back for it.",
      zone = "Feralas", location = "Camp Mojache",
    },
    {
      type = "complete", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Grimtotem Compound", logCount = 14,
      note = "Partial progress - work on this while you are here, then move on. Clear Mobs, then move on to woodpaws, will be back. (its a drive by)",
    },
    {
      type = "complete", questName = "War on the Woodpaw", zone = "Feralas",
      location = "North of Mojache", logCount = 14,
    },
    {
      type = "complete", name = "The Ogres of Feralas (part 1)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Gordunni Outpost", logCount = 14,
    },
    {
      type = "complete", questName = "Gordunni Cobalt", zone = "Feralas",
      location = "Gordunni Outpost", logCount = 14,
    },
    {
      type = "accept", questName = "The Gordunni Scroll", zone = "Feralas",
      location = "Gordunni Outpost", logCount = 15,
    },
    {
      type = "complete", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Grimtotem Compound", logCount = 15,
      note = "Partial progress - work on this while you are here, then move on. Clear Mobs, then move on to Mojache (its a drive by)",
    },
    {
      type = "turnin", name = "The Ogres of Feralas (part 1)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Camp Mojache", logCount = 14,
    },
    {
      type = "accept", name = "The Ogres of Feralas (part 2)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Camp Mojache", logCount = 15,
    },
    {
      type = "turnin", questName = "The Gordunni Scroll", zone = "Feralas",
      location = "Camp Mojache", logCount = 14,
    },
    {
      type = "note", name = "Skip: Dark Ceremony",
      note = "Do not pick up Dark Ceremony yet - the route comes back for it.",
      zone = "Feralas", location = "Camp Mojache",
    },
    {
      type = "turnin", questName = "Gordunni Cobalt", zone = "Feralas",
      location = "Camp Mojache", logCount = 13,
    },
    {
      type = "turnin", questName = "War on the Woodpaw", zone = "Feralas",
      location = "Camp Mojache", logCount = 12,
    },
    { type = "accept", questName = "Alpha Strike", zone = "Feralas", location = "Camp Mojache", logCount = 13 },
    {
      type = "complete", questName = "Alpha Strike", zone = "Feralas",
      location = "Woodpaw Hills", logCount = 13,
    },
    { type = "turnin", questName = "Alpha Strike", zone = "Feralas", location = "Camp Mojache", logCount = 12 },
    {
      type = "complete", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Grimtotem Compound", logCount = 12,
      note = "Partial progress - work on this while you are here, then move on. Clear Mobs, then move on to Mojache (its a drive by) might be getting close to done by now",
    },
    {
      type = "accept", questName = "Woodpaw Investigation", zone = "Feralas",
      location = "Camp Mojache", logCount = 13,
    },
    {
      type = "turnin", questName = "Woodpaw Investigation", zone = "Feralas",
      location = "Woodpaw Hills", logCount = 12,
    },
    {
      type = "accept", questName = "The Battle Plans", zone = "Feralas",
      location = "Woodpaw Hills", logCount = 13,
    },
    {
      type = "turnin", questName = "The Battle Plans", zone = "Feralas",
      location = "Camp Mojache", logCount = 12,
    },
    {
      type = "accept", questName = "Zukk'ash Infestation", zone = "Feralas",
      location = "Camp Mojache", logCount = 13,
    },
    { type = "accept", questName = "Stinglasher", zone = "Feralas", location = "Camp Mojache", logCount = 14 },
    {
      type = "complete", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Grimtotem Compound", logCount = 14,
    },
    {
      type = "turnin", questName = "A New Cloak's Sheen", zone = "Feralas",
      location = "Camp Mojache", logCount = 13,
    },
    {
      type = "accept", name = "A Grim Discovery (part 1)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Camp Mojache", logCount = 14,
    },
    {
      type = "complete", name = "A Grim Discovery (part 1)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Grimtotem Compound", logCount = 14,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Screecher Spirits", zone = "Feralas",
      location = "Ruins of Isildien", logCount = 14,
    },
    {
      type = "complete", name = "The Ogres of Feralas (part 2)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Ruins of Isildien", logCount = 14,
    },
    {
      type = "complete", name = "A Grim Discovery (part 1)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Grimtotem Compound", logCount = 14,
    },
    {
      type = "complete", questName = "Zukk'ash Infestation", zone = "Feralas",
      location = "The Writhing Deep", logCount = 14,
    },
    {
      type = "complete", questName = "Stinglasher", zone = "Feralas",
      location = "The Writhing Deep", logCount = 14,
    },
    {
      type = "hearth", name = "Hearth to Camp Mojache", zone = "Feralas",
      location = "The Writhing Deep", logCount = 14, note = "Use your hearthstone.",
    },
    {
      type = "turnin", name = "A Grim Discovery (part 1)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Camp Mojache", logCount = 13,
      note = "If Hearth is up",
    },
    {
      type = "accept", name = "A Grim Discovery (part 2)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Feralas", location = "Camp Mojache", logCount = 14,
    },
    {
      type = "turnin", name = "The Ogres of Feralas (part 2)",
      questName = "The Ogres of Feralas", ambiguous = true, zone = "Feralas",
      location = "Camp Mojache", logCount = 13,
    },
    {
      type = "turnin", questName = "Zukk'ash Infestation", zone = "Feralas",
      location = "Camp Mojache", logCount = 12,
    },
    { type = "turnin", questName = "Stinglasher", zone = "Feralas", location = "Camp Mojache", logCount = 11 },
    {
      type = "accept", questName = "Zukk'ash Report", zone = "Feralas",
      location = "Camp Mojache", logCount = 12,
    },
    { type = "note", name = "Note", note = "Hinterlands Pass" },
    {
      type = "travel", name = "Camp Mojache to Orgrimmar", zone = "Feralas",
      location = "Camp Mojache", logCount = 12, note = "Take the flight path.",
    },
    { type = "turnin", questName = "Zukk'ash Report", zone = "Orgrimmar", location = "The Drag", logCount = 11 },
    {
      type = "accept", name = "Ripple Recovery (part 1)", questName = "Ripple Recovery",
      ambiguous = true, zone = "Orgrimmar", location = "The Drag", logCount = 12,
    },
    {
      type = "turnin", name = "Ripple Recovery (part 1)", questName = "Ripple Recovery",
      ambiguous = true, zone = "Orgrimmar", location = "The Drag", logCount = 11,
    },
    {
      type = "accept", name = "Ripple Recovery (part 2)", questName = "Ripple Recovery",
      ambiguous = true, zone = "Orgrimmar", location = "The Drag", logCount = 12,
    },
    {
      type = "turnin", name = "A Grim Discovery (part 2)", questName = "A Grim Discovery",
      ambiguous = true, zone = "Orgrimmar", location = "The Valley of Honor", logCount = 11,
    },
    {
      type = "travel", name = "Durotar to Tirisfal Glades", zone = "Durotar",
      location = "Jaggedswine Farm", logCount = 11, note = "Zeppelin.",
    },
    {
      type = "accept", questName = "Lines of Communication", zone = "Undercity",
      location = "The Magic Quarter", logCount = 12,
    },
    {
      type = "turnin", questName = "Return to Apothecary Zinge", zone = "Undercity",
      location = "The Apothecarium", logCount = 11,
    },
    {
      type = "travel", name = "Undercity to Hammerfall", zone = "Undercity", logCount = 11,
      note = "Take the flight path.",
    },
    { type = "complete", questName = "Summoning the Princess", zone = "Arathi Highlands", logCount = 11 },
    { type = "turnin", questName = "Summoning the Princess", zone = "Arathi Highlands", logCount = 10 },
    { type = "note", name = "Note", note = "Learn New bandages." },
    {
      type = "travel", name = "Hammerfall to Tarren Mill", zone = "Arathi Highlands",
      location = "Hammerfall", logCount = 10, note = "Take the flight path.",
    },
    {
      type = "hearth", name = "Set Hearth to Tarren Mill", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 10, note = "Use your hearthstone.",
    },
    {
      type = "turnin", name = "Ripple Recovery (part 2)", questName = "Ripple Recovery",
      ambiguous = true, zone = "The Hinterlands", location = "Shindigger's Camp", logCount = 9,
    },
    {
      type = "accept", questName = "A Sticky Situation", zone = "The Hinterlands",
      location = "Shindigger's Camp", logCount = 10,
    },
    {
      type = "complete", questName = "Grim Message", zone = "The Hinterlands",
      location = "Zun'watha", logCount = 10,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", questName = "Venom Bottles", zone = "The Hinterlands",
      location = "Zun'watha", logCount = 11,
    },
    {
      type = "complete", questName = "Grim Message", zone = "The Hinterlands",
      location = "Zun'watha", logCount = 11,
    },
    {
      type = "complete", questName = "Testing the Vessel", zone = "The Hinterlands",
      logCount = 11,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Whiskey Slim's Lost Grog", zone = "The Hinterlands",
      logCount = 11,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "accept", questName = "Vilebranch Hooligans", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 12,
    },
    {
      type = "accept", questName = "Cannibalistic Cousins", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 13,
    },
    {
      type = "accept", questName = "Message to the Wildhammer", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 14,
    },
    {
      type = "accept", questName = "Stalking the Stalkers", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 15,
    },
    {
      type = "accept", questName = "Hunt the Savages", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 16,
    },
    {
      type = "accept", questName = "Avenging the Fallen", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 17,
    },
    {
      type = "note", name = "Skip: Lard Lost His Lunch",
      note = "Do not pick up Lard Lost His Lunch yet - the route comes back for it.",
      zone = "The Hinterlands", location = "Revantusk Village",
    },
    {
      type = "note", name = "Skip: Snapjaws, Mon!",
      note = "Do not pick up Snapjaws, Mon! yet - the route comes back for it.",
      zone = "The Hinterlands", location = "Revantusk Village",
    },
    {
      type = "note", name = "Skip: Gammerita, Mon!",
      note = "Do not pick up Gammerita, Mon! yet - the route comes back for it.",
      zone = "The Hinterlands", location = "Revantusk Village",
    },
    {
      type = "hearth", name = "Hearth to Tarren Mill", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 17,
      note = "Use your hearthstone. If Hearth isnt up Fly toTM",
    },
    {
      type = "turnin", questName = "Venom Bottles", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 16,
    },
    {
      type = "accept", questName = "Undamaged Venom Sac", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 17,
    },
    {
      type = "travel", name = "Tarren Mill to Revantusk Village", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 17, note = "Take the flight path.",
    },
    {
      type = "complete", questName = "Whiskey Slim's Lost Grog", zone = "The Hinterlands",
      logCount = 17,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Stalking the Stalkers", zone = "The Hinterlands",
      logCount = 17,
      note = "Partial progress - work on this while you are here, then move on.",
    },
    {
      type = "complete", questName = "Cannibalistic Cousins", zone = "The Hinterlands",
      location = "Shaol'watha", logCount = 17,
    },
    {
      type = "complete", questName = "Vilebranch Hooligans", zone = "The Hinterlands",
      location = "Shaol'watha", logCount = 17,
    },
    {
      type = "complete", questName = "A Sticky Situation", zone = "The Hinterlands",
      location = "Skulk Rock", logCount = 17,
    },
    { type = "complete", questName = "Testing the Vessel", zone = "The Hinterlands", logCount = 17 },
    { type = "complete", questName = "Hunt the Savages", zone = "The Hinterlands", logCount = 17 },
    { type = "complete", questName = "Stalking the Stalkers", zone = "The Hinterlands", logCount = 17 },
    {
      type = "accept", questName = "Find OOX-09/HL!", zone = "The Hinterlands",
      location = "Agol'watha", logCount = 18,
      note = "Note: If you never get it.... you never get it, move on.",
    },
    {
      type = "turnin", questName = "Find OOX-09/HL!", zone = "The Hinterlands",
      location = "Agol'watha", logCount = 17,
    },
    {
      type = "note", name = "Skip: Rescue OOX-09/HL!",
      note = "The route deliberately skips Rescue OOX-09/HL!.", zone = "The Hinterlands",
      location = "Agol'watha",
    },

    { type = "section", name = "Continued (level 44-46)", levels = { 44, 46 }, zone = "The Hinterlands" },
    {
      type = "complete", questName = "Message to the Wildhammer", zone = "The Hinterlands",
      location = "Quel'Danil Lodge", logCount = 17,
    },
    {
      type = "complete", questName = "Lines of Communication", zone = "The Hinterlands",
      location = "Quel'Danil Lodge", logCount = 17,
    },
    {
      type = "accept", questName = "Rin'ji is Trapped!", zone = "The Hinterlands",
      location = "Quel'Danil Lodge", logCount = 18,
    },
    {
      type = "complete", questName = "Rin'ji is Trapped!", zone = "The Hinterlands",
      location = "Quel'Danil Lodge", logCount = 18,
    },
    {
      type = "turnin", questName = "A Sticky Situation", zone = "The Hinterlands",
      location = "Shindigger's Camp", logCount = 17,
    },
    {
      type = "accept", questName = "Ripple Delivery", zone = "The Hinterlands",
      location = "Shindigger's Camp", logCount = 18,
    },
    {
      type = "complete", questName = "Undamaged Venom Sac", zone = "The Hinterlands",
      location = "Shadra'alor", logCount = 18,
      note = "FYI: The item has a timer so dont fiddle fuck around",
    },
    { type = "complete", questName = "Whiskey Slim's Lost Grog", zone = "The Hinterlands", logCount = 18 },
    {
      type = "turnin", questName = "Vilebranch Hooligans", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 17,
    },
    {
      type = "turnin", questName = "Cannibalistic Cousins", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 16,
    },
    {
      type = "turnin", questName = "Message to the Wildhammer", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 15,
    },
    {
      type = "note", name = "Skip: Another Message to the Wildhammer",
      note = "The route deliberately skips Another Message to the Wildhammer.",
      zone = "The Hinterlands", location = "Revantusk Village",
    },
    {
      type = "turnin", questName = "Stalking the Stalkers", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 14,
    },
    {
      type = "turnin", questName = "Hunt the Savages", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 13,
    },
    {
      type = "turnin", questName = "Avenging the Fallen", zone = "The Hinterlands",
      location = "Revantusk Village", logCount = 12,
    },
    {
      type = "turnin", questName = "Rin'ji is Trapped!", zone = "The Hinterlands",
      location = "The Overlook Cliffs", logCount = 11,
    },
    {
      type = "accept", questName = "Rin'ji's Secret", zone = "The Hinterlands",
      location = "The Overlook Cliffs", logCount = 12,
    },
    {
      type = "travel", name = "Revantusk Village to Tarren Mill", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 12, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Undamaged Venom Sac", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 11,
    },
    {
      type = "accept", questName = "Consult Master Gadrin", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 12,
    },
    {
      type = "travel", name = "Tarren Mill to Undercity", zone = "Hillsbrad Foothills",
      location = "Tarren Mill", logCount = 12, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Lines of Communication", zone = "Undercity",
      location = "The Magic Quarter", logCount = 11,
    },
    {
      type = "turnin", questName = "Rin'ji's Secret", zone = "Undercity",
      location = "The Magic Quarter", logCount = 10,
    },
    {
      type = "accept", questName = "Oran's Gratitude", zone = "Undercity",
      location = "The Magic Quarter", logCount = 11,
    },
    {
      type = "turnin", questName = "Oran's Gratitude", zone = "Undercity",
      location = "The Magic Quarter", logCount = 10,
    },
    {
      type = "travel", name = "Tirisfal Glades to Grom'gol Base Camp",
      zone = "Tirisfal Glades", logCount = 10, note = "Zeppelin.",
    },
    {
      type = "turnin", questName = "Grim Message", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 9,
    },
    {
      type = "travel", name = "Grom'gol to Booty Bay", zone = "Stranglethorn Vale",
      location = "Grom'gol Base Camp", logCount = 9, note = "Take the flight path.",
    },
    {
      type = "turnin", questName = "Deliver to MacKinley", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 8,
    },
    {
      type = "turnin", questName = "Whiskey Slim's Lost Grog", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 7,
    },
    {
      type = "travel", name = "Booty Bay to Ratchet", zone = "Stranglethorn Vale",
      location = "Booty Bay", logCount = 7, note = "Boat.",
    },
    { type = "note", name = "Note", note = "JUMP OFF THE BOAT AT ECHO ISLES!" },
    {
      type = "turnin", questName = "Consult Master Gadrin", zone = "Durotar",
      location = "Sen'jin Village", logCount = 6,
    },
    {
      type = "accept", questName = "The Spider God", zone = "Durotar",
      location = "Sen'jin Village", logCount = 7,
    },
    { type = "note", name = "Note", note = "Ride To Orgrimmar" },
})
