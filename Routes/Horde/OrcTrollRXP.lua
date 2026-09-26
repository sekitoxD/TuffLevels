-- TuFFlevels / Routes/Horde/OrcTrollRXP.lua
--
-- ############################ READ THIS ############################
-- EXPERIMENTAL TEST ROUTE. Mechanically converted, not hand-verified, and
-- currently covers only levels 1-6 (chapter 1 of many). Not the default
-- route for any character - pick it explicitly from the route picker
-- (Panel's "Available Guides" button, or /tuff route) on a dedicated test
-- character to try it out.
--
-- Before trusting any of it, run:  /tuff verify
-- ###################################################################
--
-- WHY THIS FILE EXISTS ALONGSIDE Routes/Horde/Solo/*.lua
--
-- Routes/Horde/Solo/*.lua is the shipped ONSLAUGHT Orc/Troll 1-60 route
-- (spreadsheet-derived, hand-verified over many commits - see
-- plans/04-sheet-audit.md). This file is a SEPARATE, parallel attempt at
-- an Orc/Troll leveling route built the same way Routes/Horde/Mulgore.lua
-- was: parsed straight from RXPGuides (RestedXP) guide text via
-- RXPImport.lua, run headlessly through spec/rxp_harness.lua rather than
-- pasted through the in-game import UI one guide at a time.
--
-- This route carries ZERO risk to ONSLAUGHT - nothing under Solo/ was
-- touched to create this file, and `sample = true` below keeps
-- Core:AutoSelectRoute ranking this behind ONSLAUGHT for any Orc/Troll
-- character that hasn't explicitly picked it. The point of building it
-- this way, instead of editing ONSLAUGHT in place, is to get something
-- playable and comparable BEFORE deciding whether any of it should be
-- promoted into, merged with, or left separate from ONSLAUGHT - see
-- plans/12-rxpguides-reimport-and-directive-upgrade.md's "Phase 3
-- (revised)" section for the full reasoning and the chapter-by-chapter
-- progress checkpoint.
--
-- SOURCE AND SCOPE (chapter 1 of the planned coverage)
--
-- Parsed from Classic-Horde-01-12_Durotar.lua's first RegisterGuide block
-- ("1-6 Durotar"), via `lua spec/rxp_harness.lua <path-to-guide> 1`. Later
-- chapters (6-10, 10-12, then the shared Classic-Horde-30-60.lua content
-- from The Barrens onward) are tracked as follow-up work in plan 12, not
-- done yet - this file currently ends around level 6, at the edge of the
-- Valley of Trials.
--
-- KNOWN OPEN ISSUES (flagged for the in-game playtest pass, same spirit as
-- Mulgore.lua's own disclaimer - report anything confirmed wrong back into
-- this file per CONTRIBUTING.md rather than discarding it)
--
-- - A handful of steps carry a quest ID in the 77000s (e.g. 77586, 77585,
--   77584) immediately alongside another near-identical step using a
--   lower classic-era ID for what looks like the same NPC/quest (e.g.
--   3090, 3089, 3087). RXPImport.lua's condition parser has no token for
--   whatever the source guide used to pick between these (it's not one of
--   the class/race/expansion tokens it recognizes), so both variants
--   survived unfiltered instead of one being dropped. Needs an in-game
--   check on which ID (or both) actually exists for this client before
--   trusting the higher numbers.
-- - Several `type = "travel"`/`type = "note"` steps carry unparsed
--   directive residue in their name/note text (`.mob`, `.money`,
--   `.collect`, `.isOnQuest`, a modified `.xp N+M`/`.xp <N,1`, etc.) -
--   RXPImport.lua's header documents these as not parsed into their own
--   step types yet, so they fold into plain note text. Cosmetic only
--   (still clickable as a manual step), not a functional bug. A BARE
--   `.xp N` (no modifier) now converts to a real auto-detecting `xp` step
--   (fixed 2026-09-26, RXPImport.lua) - a modified form still can't,
--   since converting its absolute-XP amount into TuFFlevels' 0-100
--   xp.pct would need Classic's per-level XP table hardcoded, which
--   wasn't attempted.
-- - FIXED (2026-09-26, in-game playtest): two steps were missing a class
--   filter that a sibling step for the same quest/item correctly carried
--   - the quest 794 "complete" step lacked Warlock's quest 794 accept
--   step's `class = "WARLOCK"` (so other classes got routed to "kill
--   Yarrog Baneshadow" for a quest they were never able to accept,
--   reported as a party quest-share "prerequisite" failure), and the
--   third-tier "Buy Rough Arrows" step at Duokna lacked the `class =
--   "HUNTER"` its two lower-tier siblings had (reported as "arrows for a
--   class I'm not playing"). Audited the rest of the file for the same
--   quest-ID/item-purchase-grouped class-inconsistency pattern - no
--   further instances found in this chapter.
-- - FIXED (2026-09-26, in-game playtest; corrected 2026-09-27 code review
--   - the Nartok item below was mislabeled "exact-duplicate" here, it
--   wasn't): the raw parse contained several redundant accept/turnin/
--   complete steps for the same quest+NPC - four were byte-identical
--   exact duplicates (Galgar/4402, Foreman Thazz'ril/6394, a Vile
--   Familiars kill/792, a Shikrik accept/1516), almost certainly the
--   source guide's OR-condition branches (the "kept unfiltered" warnings
--   the harness prints) both surviving for a character that matched
--   both. The Nartok/77586 turnin was different: two real money-threshold
--   variants of the same turn-in (`spellID = 1454` vs `695`), not a byte-
--   identical copy - `spellID` is inert on a `turnin` step either way, so
--   merging to one was still correct, just for a different reason. Since
--   a quest can only be turned in once, the second copy of each silently
--   read as already-done and Reconcile
--   skipped it with no visible action - this is what looked like "auto
--   turning in quests" at an NPC with more than one turn-in. Deduped to
--   one copy per quest+NPC. If this resurfaces on a later chapter, it's
--   the same root cause, not a new bug.
-- - Every quest ID here is exactly what came out of the parser -
--   `/tuff verify` has not been run against this file yet.

local ADDON, ns = ...

ns.RegisterRoute("RXPGuides Orc/Troll 1-60 (TEST, parse in progress)", {
    faction = "Horde",
    races   = { "Orc", "Troll" },
    levels  = { 1, 6 },
    author  = "RXPImport (converted, via spec/rxp_harness.lua)",
    sample  = true,   -- mechanically converted, unverified IDs; run /tuff verify
    source  = "Converted from RXPGuides (RestedXP) Classic guide text (Classic-Horde-01-12_Durotar.lua, chapter 1: '1-6 Durotar'). RXPGuides content is CC BY-NC-SA 4.0 - see this file's Credits & License section below.",

    steps = {
        { type = "section", name = "1-6 Durotar", levels = { 1, 6 } },
        { type = "accept", name = "Talk to Kaltunk", zone = "Durotar", x = 43.29, y = 68.53, npc = "Kaltunk", quest = 4641 },
        { type = "travel", name = "Kill Mottled Boars. Loot them until you have 35 copper worth of vendor items (including your armor) - Kill Mottled Boars. Loot them until you have 10 copper worth of vendor items (including your armor) - .mob Mottled Boar - .money >0.01", note = "Kill Mottled Boars. Loot them until you have 35 copper worth of vendor items (including your armor) - Kill Mottled Boars. Loot them until you have 10 copper worth of vendor items (including your armor) - .mob Mottled Boar - .money >0.01", zone = "Durotar", x = 44.19, y = 65.34, path = { { zone = "Durotar", x = 43.85, y = 71.73 } }, optional = true },
        { type = "accept", name = "Talk to Ruzan", zone = "Durotar", x = 42.59, y = 69, npc = "Ruzan", quest = 1485, class = "WARLOCK" },
        { type = "travel", name = "Talk to Duokna", note = "Vendor: Vendor Trash - .money >0.01", zone = "Durotar", x = 42.59, y = 67.35, npc = "Duokna" },
        { type = "accept", name = "Talk to Gornek", zone = "Durotar", x = 42.06, y = 68.32, npc = "Gornek", quest = 788, path = { { zone = "Durotar", x = 42.29, y = 68.39 } } },
        { type = "spell", name = "Talk to Frang", note = "Talk to Shikrik", zone = "Durotar", x = 42.39, y = 69, npc = "Frang", spellID = 8017, path = { { zone = "Durotar", x = 42.28, y = 68.48 }, { zone = "Durotar", x = 42.89, y = 69.44 } } },
        { type = "travel", name = "Travel toward Nartok", note = ".money <0.01", zone = "Durotar", x = 40.65, y = 68.52, path = { { zone = "Durotar", x = 41.52, y = 68.36 }, { zone = "Durotar", x = 41.24, y = 68.16 }, { zone = "Durotar", x = 40.82, y = 68.03 } }, class = "WARLOCK" },
        { type = "travel", name = "Travel toward Hraug", note = ".money >0.01", zone = "Durotar", x = 40.56, y = 68.44, path = { { zone = "Durotar", x = 41.52, y = 68.36 }, { zone = "Durotar", x = 41.24, y = 68.16 }, { zone = "Durotar", x = 40.82, y = 68.03 } }, class = "WARLOCK", optional = true },
        { type = "travel", name = "Travel toward Hraug", zone = "Durotar", x = 40.56, y = 68.44, path = { { zone = "Durotar", x = 41.52, y = 68.36 }, { zone = "Durotar", x = 41.24, y = 68.16 }, { zone = "Durotar", x = 40.82, y = 68.03 } }, class = "WARLOCK", optional = true },
        { type = "travel", name = "Talk to Hraug", note = "Vendor: Vendor Trash - .money >0.01", zone = "Durotar", x = 40.56, y = 68.44, npc = "Hraug", class = "WARLOCK" },
        { type = "travel", name = "Talk to Hraug", note = "Vendor: Vendor Trash", zone = "Durotar", x = 40.56, y = 68.44, npc = "Hraug", class = "WARLOCK" },
        { type = "spell", name = "Talk to Nartok", zone = "Durotar", x = 40.65, y = 68.52, npc = "Nartok", quest = 77586, spellID = 348, class = "WARLOCK" },
        { type = "spell", name = "Talk to Nartok", zone = "Durotar", x = 40.65, y = 68.52, npc = "Nartok", spellID = 348, class = "WARLOCK" },
        { type = "travel", name = "Talk to Duokna", note = "Buy [Refreshing Spring Water] from her - .collect 159,5,6394,1 - .money <0.0025", zone = "Durotar", x = 42.59, y = 67.34, npc = "Duokna", class = "WARLOCK" },
        { type = "complete", name = "Kill Mottled Boars en route to the Burning Blade Coven", note = "Try to get to level 2 before getting there - .mob Mottled Boar", zone = "Durotar", x = 43.57, y = 67.28, quest = 788, class = "WARLOCK", optional = true, objective = 1 },
        { type = "travel", name = "Travel toward the Burning Blade Coven", note = ".isOnQuest 1485", zone = "Durotar", x = 45.3, y = 56.42, class = "WARLOCK" },
        { type = "complete", name = "Kill Vile Familiars. Loot them for Vile Familiar Heads", note = ".mob Vile Familiar", zone = "Durotar", x = 43.85, y = 55.52, quest = 1485, path = { { zone = "Durotar", x = 43.87, y = 58.42 }, { zone = "Durotar", x = 44.53, y = 58.62 }, { zone = "Durotar", x = 45.18, y = 58.42 }, { zone = "Durotar", x = 45.83, y = 58.59 }, { zone = "Durotar", x = 45.79, y = 57.43 }, { zone = "Durotar", x = 46.46, y = 57.57 }, { zone = "Durotar", x = 47.19, y = 57.12 }, { zone = "Durotar", x = 46.21, y = 56.69 }, { zone = "Durotar", x = 46.28, y = 56.11 }, { zone = "Durotar", x = 45.65, y = 56.9 }, { zone = "Durotar", x = 45.35, y = 56.32 }, { zone = "Durotar", x = 44.77, y = 56.87 }, { zone = "Durotar", x = 44.58, y = 56.1 }, { zone = "Durotar", x = 44.27, y = 56.59 } }, class = "WARLOCK", objective = 1 },
        { type = "complete", name = "Kill Mottled Boars", note = ".mob Mottled Boar", quest = 788, objective = 1 },
        { type = "accept", name = "Talk to Hana'zua", zone = "Durotar", x = 40.59, y = 62.59, npc = "Hana'zua", quest = 790 },
        { type = "complete", name = "Kill Sarkoth. Loot him for Sarkoth's Mangled Claw", note = ".mob Sarkoth", zone = "Durotar", x = 40.6, y = 66.8, quest = 790, objective = 1 },
        { type = "accept", name = "Talk to Hana'zua", zone = "Durotar", x = 40.59, y = 62.59, npc = "Hana'zua", quest = 804 },
        { type = "complete", name = "Kill Mottled Boars", note = ".mob Mottled Boar", zone = "Durotar", x = 41.99, y = 64.03, quest = 788, path = { { zone = "Durotar", x = 41.3, y = 65.03 }, { zone = "Durotar", x = 41.92, y = 64.74 }, { zone = "Durotar", x = 42.66, y = 64.92 }, { zone = "Durotar", x = 43.31, y = 65.02 }, { zone = "Durotar", x = 43.9, y = 65.96 }, { zone = "Durotar", x = 44.54, y = 65.96 }, { zone = "Durotar", x = 45.16, y = 65.77 }, { zone = "Durotar", x = 45.72, y = 65.93 }, { zone = "Durotar", x = 45.72, y = 65.04 }, { zone = "Durotar", x = 45.21, y = 63.95 }, { zone = "Durotar", x = 45.83, y = 63.01 }, { zone = "Durotar", x = 45.81, y = 62.17 }, { zone = "Durotar", x = 45.78, y = 61.14 }, { zone = "Durotar", x = 45.15, y = 60.2 }, { zone = "Durotar", x = 44.5, y = 59.45 }, { zone = "Durotar", x = 43.86, y = 60.43 }, { zone = "Durotar", x = 43.07, y = 60.24 }, { zone = "Durotar", x = 42.58, y = 60.09 }, { zone = "Durotar", x = 42.02, y = 61.19 }, { zone = "Durotar", x = 42.02, y = 62.15 }, { zone = "Durotar", x = 42, y = 62.92 } }, objective = 1 },
        { type = "note", name = "Grind Mottled Boars. Loot them until you have 1 silver worth of vendor items", note = ".mob Mottled Boar - .money >0.01", class = "WARLOCK" },
        { type = "note", name = "Grind Mottled Boars. Loot them until you have 2 silver worth of vendor items", note = "Grind Mottled Boars. Loot them until you have 1 silver 75 copper worth of vendor items - Grind Mottled Boars. Loot them until you have 1 silver 10 copper worth of vendor items - Grind Mottled Boars. Loot them until you have 1 silver worth of vendor items - .mob Mottled Boar - .money >0.02 - .money >0.0175 - .money >0.011 - .money >0.01" },
        { type = "travel", name = "Talk to Duokna", note = "Vendor: Vendor Trash", zone = "Durotar", x = 42.59, y = 67.34, npc = "Duokna", class = "ROGUE" },
        { type = "accept", name = "Talk to Ruzan", zone = "Durotar", x = 42.59, y = 69, npc = "Ruzan", quest = 1499, class = "WARLOCK" },
        { type = "note", name = ".cast 688 >>Cast [Summon Imp]", note = ".cast 688 >>Cast [Summon Imp]", class = "WARLOCK" },
        { type = "accept", name = "Talk to Zureetha", zone = "Durotar", x = 42.85, y = 69.15, npc = "Zureetha Fargaze", quest = 794, class = "WARLOCK" },
        { type = "turnin", name = "Talk to Gornek", zone = "Durotar", x = 42.06, y = 68.32, npc = "Gornek", quest = 804, path = { { zone = "Durotar", x = 42.28, y = 68.48 } } },
        { type = "travel", name = "Travel toward Rwag", zone = "Durotar", x = 41.27, y = 68, path = { { zone = "Durotar", x = 41.52, y = 68.36 } }, class = "ROGUE" },
        { type = "spell", name = "Talk to Rwag", note = ".money <0.04 - .xp <4,1", zone = "Durotar", x = 41.27, y = 68, npc = "Rwag", quest = 3088, spellID = 53, class = "ROGUE" },
        { type = "turnin", name = "Talk to Rwag", zone = "Durotar", x = 41.27, y = 68, npc = "Rwag", quest = 3088, class = "ROGUE" },
        { type = "note", name = ".xp 3+325 >> Grind to 325+/1400xp - .xp 3+925 >> Grind to 925+/1400xp - .mob Mottled Boar", note = ".xp 3+325 >> Grind to 325+/1400xp - .xp 3+925 >> Grind to 925+/1400xp - .mob Mottled Boar" },
        { type = "accept", name = "Talk to Galgar", zone = "Durotar", x = 42.73, y = 67.23, npc = "Galgar", quest = 4402, optional = true },
        { type = "travel", name = "Talk to Duokna", note = "Buy [Rough Arrows] from her - .collect 2512,400,6394,1 - Vendor: Vendor Trash - .money <0.002", zone = "Durotar", x = 42.59, y = 67.34, npc = "Duokna", class = "HUNTER" },
        { type = "travel", name = "Talk to Duokna", note = "Buy [Rough Arrows] from her - .collect 2512,200,6394,1 - Vendor: Vendor Trash - .money <0.001", zone = "Durotar", x = 42.59, y = 67.34, npc = "Duokna", class = "HUNTER" },
        { type = "accept", name = "Talk to Shikrik and Canaga", zone = "Durotar", x = 42.4, y = 69.17, npc = "Shikrik", quest = 1516, spellID = 8042, path = { { zone = "Durotar", x = 42.39, y = 69 } }, class = "SHAMAN" },
        { type = "accept", name = "Talk to Shikrik", zone = "Durotar", x = 42.39, y = 69, npc = "Shikrik", quest = 77585, class = "SHAMAN" },
        { type = "turnin", name = "Talk to Shikrik", zone = "Durotar", x = 42.39, y = 69, npc = "Shikrik", quest = 3089, class = "SHAMAN" },
        { type = "spell", name = "Talk to Mai'ah", zone = "Durotar", x = 42.51, y = 69.04, npc = "Mai'ah", quest = 77643, spellID = 1459, class = "MAGE" },
        { type = "spell", name = "Talk to Mai'ah", zone = "Durotar", x = 42.51, y = 69.04, npc = "Mai'ah", quest = 3086, spellID = 1459, class = "MAGE" },
        { type = "spell", name = "Talk to Jen'shan", note = ".money <0.01", zone = "Durotar", x = 42.84, y = 69.32, npc = "Jen'shan", quest = 77584, spellID = 1978, class = "HUNTER" },
        { type = "accept", name = "Talk to Jen'shan", zone = "Durotar", x = 42.84, y = 69.32, npc = "Jen'shan", quest = 77584, class = "HUNTER" },
        { type = "spell", name = "Talk to Jen'shan", note = ".money <0.01", zone = "Durotar", x = 42.84, y = 69.32, npc = "Jen'shan", quest = 3087, spellID = 1978, class = "HUNTER" },
        { type = "turnin", name = "Talk to Jen'shan", zone = "Durotar", x = 42.84, y = 69.32, npc = "Jen'shan", quest = 3087, class = "HUNTER" },
        { type = "spell", name = "Talk to Frang", note = ".money <0.01", zone = "Durotar", x = 42.89, y = 69.44, npc = "Frang", quest = 77582, spellID = 772, class = "WARRIOR" },
        { type = "accept", name = "Talk to Frang", zone = "Durotar", x = 42.89, y = 69.44, npc = "Frang", quest = 77582, class = "WARRIOR" },
        { type = "spell", name = "Talk to Frang", note = ".money <0.01", zone = "Durotar", x = 42.89, y = 69.44, npc = "Frang", quest = 3065, spellID = 772, class = "WARRIOR" },
        { type = "turnin", name = "Talk to Frang", zone = "Durotar", x = 42.89, y = 69.44, npc = "Frang", quest = 3065, class = "WARRIOR" },
        { type = "accept", name = "Talk to Ken'jai", zone = "Durotar", x = 42.36, y = 68.81, npc = "Ken'jai", quest = 77642, class = "PRIEST" },
        { type = "travel", name = "Talk to Kzan", note = ".collect 2132,1,5441,1 - .money <0.0102", zone = "Durotar", x = 40.47, y = 68, npc = "Kzan Thornslash", class = "SHAMAN" },
        { type = "accept", name = "Talk to Thazz'ril", zone = "Durotar", x = 44.63, y = 68.65, npc = "Foreman Thazz'ril", quest = 5441 },
        { type = "complete", name = "Travel to the Serpent Loa statue at Sen'Jin Village and type /kneel", note = ".use 205951 >>Talk to Serpent Loa as he appears, then use [Memory of a Troubled Acolyte] - .skipgossip", zone = "Durotar", x = 55.41, y = 72.84, npc = "Serpent Loa", quest = 77642, class = "PRIEST", objective = 1 },
        { type = "turnin", name = "Talk to Ken'jai", zone = "Durotar", x = 42.36, y = 68.81, npc = "Ken'jai", quest = 77642, class = "PRIEST" },
        { type = "complete", name = "Loot the Cactus Apples near the Cacti", quest = 4402, objective = 1 },
        { type = "complete", name = "Use the [Foreman's Blackjack] on sleeping Lazy Peons", note = ".use 16114", zone = "Durotar", x = 47.37, y = 65.67, npc = "Lazy Peon", quest = 5441, path = { { zone = "Durotar", x = 44.98, y = 69.13 }, { zone = "Durotar", x = 45.64, y = 65.7 } }, objective = 1 },
        { type = "complete", name = "Kill Vile Familiars", note = ".mob Vile Familiar", quest = 792, objective = 1 },
        { type = "spell", name = "Kill Scorpid Workers. Loot them for [Dyadic Icon]", note = ".collect 206381,1,77587,1 - .collect 206381,1,77585,1 - .mob Scorpid Worker", zone = "Durotar", x = 43.91, y = 59.33, spellID = 410094, class = "SHAMAN" },
        { type = "spell", note = ".equip 18,206381 >> Equip the [Dyadic Icon] - .use 206381 - .xp <3,1", spellID = 410094, itemID = 206381, count = 1, class = "SHAMAN" },
        { type = "spell", note = ".aura 408828 >>Continue to kill Scorpid Workers and obtain 10 stacks of [Building Inspiration] as they deal nature damage to you - .mob Scorpid Worker", zone = "Durotar", x = 43.91, y = 59.33, spellID = 410094, class = "SHAMAN" },
        { type = "complete", name = "Kill Scorpid Workers. Loot them for Scorpid Worker Tails", note = ".mob Scorpid Worker", zone = "Durotar", x = 43.91, y = 59.33, quest = 789, objective = 1 },
        { type = "complete", name = "Use the [Foreman's Blackjack] on sleeping Lazy Peons", note = ".use 16114", zone = "Durotar", x = 38.83, y = 61.84, npc = "Lazy Peon", quest = 5441, objective = 1 },
        { type = "xp", name = "Grind to level 4", xp = { level = 4, pct = 0 }, note = ".mob Mottled Boar - .mob Scorpid Worker - .mob Vile Familiar" },
        { type = "turnin", name = "Talk to Galgar", note = ".isQuestComplete 4402", zone = "Durotar", x = 42.73, y = 67.23, npc = "Galgar", quest = 4402 },
        { type = "travel", name = "Talk to Duokna", note = "Buy [Rough Arrows] from her - .collect 2512,1000,6394,1 - Vendor: Vendor Trash - .money >0.1", zone = "Durotar", x = 42.59, y = 67.34, npc = "Duokna", class = "HUNTER" },
        { type = "turnin", name = "Talk to Gornek", zone = "Durotar", x = 42.06, y = 68.32, npc = "Gornek", quest = 789, path = { { zone = "Durotar", x = 42.29, y = 68.39 } } },
        { type = "spell", name = "Talk to Mai'ah", zone = "Durotar", x = 42.51, y = 69.04, npc = "Mai'ah", spellID = 116, class = "MAGE" },
        { type = "spell", name = "Talk to Ken'jai", note = ".money <0.011", zone = "Durotar", x = 42.36, y = 68.81, npc = "Ken'jai", spellID = 589, class = "PRIEST" },
        { type = "turnin", name = "Talk to Ken'jai", note = ".money <0.021", zone = "Durotar", x = 42.36, y = 68.81, npc = "Ken'jai", quest = 3085, spellID = 589, class = "PRIEST" },
        { type = "turnin", name = "Talk to Jen'shan", note = ".xp <4,1 - .money <0.01", zone = "Durotar", x = 42.84, y = 69.32, npc = "Jen'shan", quest = 77584, spellID = 1978, class = "HUNTER" },
        { type = "spell", name = "Talk to Jen'shan", note = ".xp <4,1 - .money <0.01", zone = "Durotar", x = 42.84, y = 69.32, npc = "Jen'shan", spellID = 1978, class = "HUNTER" },
        { type = "spell", name = "Talk to Frang", note = ".money <0.02", zone = "Durotar", x = 42.89, y = 69.44, npc = "Frang", spellID = 772, class = "WARRIOR" },
        { type = "spell", name = "Talk to Frang", note = ".money <0.01", zone = "Durotar", x = 42.89, y = 69.44, npc = "Frang", spellID = 100, class = "WARRIOR" },
        { type = "accept", name = "Talk to Thazz'ril", zone = "Durotar", x = 44.63, y = 68.65, npc = "Foreman Thazz'ril", quest = 6394 },
        { type = "note", name = ".xp 4+1720 >> Grind to 1720+/2100xp - .mob Mottled Boar - .mob Scorpid Worker - .mob Vile Familiar - .isOnQuest 4402", note = ".xp 4+1720 >> Grind to 1720+/2100xp - .mob Mottled Boar - .mob Scorpid Worker - .mob Vile Familiar - .isOnQuest 4402", optional = true },
        { type = "complete", name = "Loot the Cactus Apples near the Cacti", zone = "Durotar", x = 44.67, y = 64.92, quest = 4402, path = { { zone = "Durotar", x = 43.45, y = 62.96 }, { zone = "Durotar", x = 43.82, y = 62.72 }, { zone = "Durotar", x = 44.85, y = 61.54 }, { zone = "Durotar", x = 44.88, y = 59.66 }, { zone = "Durotar", x = 44.61, y = 58.2 }, { zone = "Durotar", x = 45.46, y = 58.49 }, { zone = "Durotar", x = 45.93, y = 60.62 }, { zone = "Durotar", x = 46.87, y = 60.36 }, { zone = "Durotar", x = 47.28, y = 62.8 }, { zone = "Durotar", x = 46.08, y = 62.98 } }, objective = 1 },
        { type = "travel", name = "Enter the cave", note = ".isOnQuest 6394", zone = "Durotar", x = 45.35, y = 56.27 },
        { type = "travel", name = "Travel toward Thazz'ril's Pick", note = ".isOnQuest 6394", zone = "Durotar", x = 43.72, y = 53.79, path = { { zone = "Durotar", x = 45.37, y = 55.39 }, { zone = "Durotar", x = 44.43, y = 54.51 } } },
        { type = "complete", name = "Kill Felstalkers. Loot them for Felstalker Hooves", note = ".mob Felstalker", quest = 1516, class = "SHAMAN", objective = 1 },
        { type = "complete", name = "Loot Thazz'ril's Pick against the wall", zone = "Durotar", x = 43.72, y = 53.79, quest = 6394, objective = 1 },
        { type = "complete", name = "Kill Yarrog Baneshadow. Loot him for the Burning Blade Medallion", note = ".mob Yarrog Baneshadow", zone = "Durotar", x = 42.7, y = 52.99, quest = 794, class = "WARLOCK", objective = 1 },
        { type = "complete", name = "Kill Felstalkers. Loot them for Felstalker Hooves", note = ".mob Felstalker", zone = "Durotar", x = 43.27, y = 53.82, quest = 1516, class = "SHAMAN", objective = 1 },
        { type = "note", name = ".xp 5+690 >> Grind to 690+/2800xp - .isQuestTurnedIn 4402", note = ".xp 5+690 >> Grind to 690+/2800xp - .isQuestTurnedIn 4402" },
        { type = "travel", name = "Perform a Logout Skip by positioning your character on the edge of the rock until it looks like they're floating, then logging out and back in", note = "CLICK HERE for an example (https://www.youtube.com/watch?v=7vmnvdjbUnM)", zone = "Durotar", x = 53.55, y = 44.68, optional = true },
        { type = "death", name = "Die and release", note = ".subzoneskip 362", zone = "Durotar", x = 44.7, y = 52.47, npc = "Spirit Healer", optional = true },
        { type = "accept", name = "Talk to Gar'thok", note = "You can talk to him from outside or on top of the bunker", zone = "Durotar", x = 51.95, y = 43.5, npc = "Gar'thok", quest = 784 },
        { type = "travel", name = "Travel toward the tower", zone = "Durotar", x = 49.67, y = 40.42, path = { { zone = "Durotar", x = 50.22, y = 43.06 }, { zone = "Durotar", x = 50.09, y = 42.97 }, { zone = "Durotar", x = 50.2, y = 42.3 }, { zone = "Durotar", x = 49.96, y = 40.96 } }, optional = true },
        { type = "travel", name = "Travel up the tower toward Furl", zone = "Durotar", x = 49.6, y = 40.04, optional = true },
        { type = "accept", name = "Talk to Furl", zone = "Durotar", x = 49.89, y = 40.39, npc = "Furl Scornbrow", quest = 791 },
        { type = "spell", name = "Talk to Krunn", note = "This will allow you to find [Rough Stones] from nodes in order to craft [Sharpening Stones] (+2 Weapon Damage for 30 minutes)", zone = "Durotar", x = 51.81, y = 40.89, npc = "Krunn", spellID = 2575 },
        { type = "travel", name = "Talk to Wuark", note = "Buy a [Mining Pick] from him - .collect 2901,1,784,1", zone = "Durotar", x = 51.9, y = 41.14, npc = "Wuark" },
        { type = "spell", name = "Talk to Dwukk", note = ".skill blacksmithing,1,1", zone = "Durotar", x = 52.05, y = 40.73, npc = "Dwukk", spellID = 2018 },
        { type = "hearth", name = "Hearth", note = ".use 6948", optional = true },
        { type = "travel", name = "Talk to Duokna", note = "Vendor: Vendor Trash - .money >0.03", zone = "Durotar", x = 42.59, y = 67.34, npc = "Duokna" },
        { type = "accept", name = "Talk to Zureetha", zone = "Durotar", x = 42.85, y = 69.15, npc = "Zureetha Fargaze", quest = 805 },
        { type = "spell", name = "Talk to Ken'jai", zone = "Durotar", x = 42.36, y = 68.81, npc = "Ken'jai", quest = 5649, spellID = 17, class = "PRIEST" },
        { type = "turnin", name = "Talk to Mai'ah", note = ".isQuestComplete 77643", zone = "Durotar", x = 42.51, y = 69.04, npc = "Mai'ah", quest = 77643, spellID = 2136, class = "MAGE" },
        { type = "accept", name = "Talk to Shikrik and Canaga", note = ".xp <6,1", zone = "Durotar", x = 42.4, y = 69.17, npc = "Shikrik", quest = 1517, spellID = 332, path = { { zone = "Durotar", x = 42.39, y = 69 } }, class = "SHAMAN" },
        { type = "accept", name = "Talk to Canaga", zone = "Durotar", x = 42.4, y = 69.17, npc = "Canaga Earthcaller", quest = 1517, class = "SHAMAN" },
        { type = "spell", name = "Talk to Jen'shan", note = ".money <0.02", zone = "Durotar", x = 42.84, y = 69.32, npc = "Jen'shan", spellID = 3044, class = "HUNTER" },
        { type = "spell", name = "Talk to Frang", note = ".money <0.02", zone = "Durotar", x = 42.89, y = 69.44, npc = "Frang", spellID = 6343, class = "WARRIOR" },
        { type = "spell", name = "Talk to Frang", zone = "Durotar", x = 42.89, y = 69.44, npc = "Frang", spellID = 3127, class = "WARRIOR" },
        { type = "travel", name = "Travel toward Rwag", zone = "Durotar", x = 41.27, y = 68, path = { { zone = "Durotar", x = 42.13, y = 68.41 }, { zone = "Durotar", x = 41.52, y = 68.36 } }, class = "ROGUE" },
        { type = "spell", name = "Talk to Rwag", note = ".money <0.02 - .xp <6,1", zone = "Durotar", x = 41.27, y = 68, npc = "Rwag", spellID = 1776, class = "ROGUE" },
        { type = "spell", name = "Talk to Rwag", note = ".xp <6,1", zone = "Durotar", x = 41.27, y = 68, npc = "Rwag", spellID = 1757, class = "ROGUE" },
        { type = "travel", name = "Talk to Hraug", note = "Buy the [Grimoire of Blood Pact] from him - .collect 16321,1,817,1 - Vendor: Vendor Trash - .money <0.03", zone = "Durotar", x = 40.56, y = 68.44, npc = "Hraug", class = "WARLOCK" },
        { type = "turnin", name = "Talk to Nartok", note = ".money <0.02", zone = "Durotar", x = 40.65, y = 68.52, npc = "Nartok", quest = 77586, spellID = 1454, class = "WARLOCK" },
        { type = "item", name = "Use the [Grimoire of Blood Pact]", note = ".use 16321", spellID = 20397, itemID = 16321, count = 1, class = "WARLOCK" },
        { type = "travel", name = "Travel toward the Shaman Shrine", note = ".isOnQuest 1517", zone = "Durotar", x = 44.13, y = 76.36, path = { { zone = "Durotar", x = 43.36, y = 69.6 }, { zone = "Durotar", x = 43.18, y = 70.93 }, { zone = "Durotar", x = 41.31, y = 73.63 }, { zone = "Durotar", x = 40.82, y = 74.37 }, { zone = "Durotar", x = 42.71, y = 75.18 }, { zone = "Durotar", x = 43.57, y = 75.51 } }, class = "SHAMAN" },
        { type = "note", name = ".cast 8202 >>Use the [Earth Sapta] - .use 6635", note = ".cast 8202 >>Use the [Earth Sapta] - .use 6635", class = "SHAMAN", optional = true },
        { type = "accept", name = "Talk to the Manifestation", zone = "Durotar", x = 44.03, y = 76.21, npc = "Minor Manifestation of Earth", quest = 1518, class = "SHAMAN" },
        { type = "turnin", name = "Talk to Canaga", zone = "Durotar", x = 42.4, y = 69.17, npc = "Canaga Earthcaller", quest = 1518, class = "SHAMAN" },
        { type = "spell", name = "Talk to Shikrik", zone = "Durotar", x = 42.39, y = 69, npc = "Shikrik", spellID = 332, class = "SHAMAN" },
        { type = "turnin", name = "Talk to Thazz'ril", zone = "Durotar", x = 44.63, y = 68.65, npc = "Foreman Thazz'ril", quest = 6394 },
        { type = "travel", name = "Exit the Valley of Trials", note = ".isOnQuest 805", zone = "Durotar", x = 49.9, y = 68.43, path = { { zone = "Durotar", x = 47.09, y = 69.21 }, { zone = "Durotar", x = 49.02, y = 69.13 } } },
    },
})

--------------------------------------------------------------------------
-- Credits & License
--------------------------------------------------------------------------
--
-- This route's step data was mechanically converted from a Classic-flavored
-- RestedXP (RXPGuides) Orc/Troll leveling guide. Full credit to the
-- RestedXP team for the underlying route research and leveling-path
-- optimization - this file exists because of their work, not instead of
-- it. RXPGuides is itself a free, open addon; nothing about this
-- conversion or TuFFlevels involves any payment or monetization.
--
-- RXPGuides guide content is licensed Creative Commons
-- Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA
-- 4.0). Unlike the rest of TuFFlevels (MIT, see the repository's LICENSE
-- file), THIS FILE is a derivative work of that content and is licensed
-- under CC BY-NC-SA 4.0 too, not MIT - noncommercial use only, and any
-- redistributed adaptation of this specific file must credit RestedXP and
-- carry the same CC BY-NC-SA 4.0 license. TuFFlevels itself is free with
-- no monetization, which satisfies the NonCommercial term; this notice
-- exists so that stays true for anyone who builds on this file too.
