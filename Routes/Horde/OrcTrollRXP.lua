-- TuFFlevels / Routes/Horde/OrcTrollRXP.lua
--
-- ############################ READ THIS ############################
-- EXPERIMENTAL TEST ROUTE. Mechanically converted, not hand-verified, and
-- currently covers only levels 1-10 (chapters 1-2 of many). Not the default
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
-- SOURCE AND SCOPE (chapters 1-2 of the planned coverage)
--
-- Chapter 1 ("1-6 Durotar") parsed from Classic-Horde-01-12_Durotar.lua's
-- first RegisterGuide block via `lua spec/rxp_harness.lua <path-to-guide> 1`.
-- Chapter 2 ("6-10 Durotar") is that same source file's second RegisterGuide
-- block, parsed via `lua spec/rxp_harness.lua <path-to-guide> 2` and appended
-- 2026-09-26. Later chapters (10-12, then the shared Classic-Horde-30-60.lua
-- content from The Barrens onward) are tracked as follow-up work in plan 12,
-- not done yet - this file currently ends around level 10, having killed
-- Fizzle Darkstorm and fought out of Thunder Ridge, then hearthed back
-- toward Orgrimmar/Razor Hill. Quest 806 (Dark Storms) has no turn-in step
-- anywhere in this chapter - see the multi-quest-step open issue below.
--
-- Parsed from the RXPGuides `_anniversary_` realm install at
-- `E:\World of Warcraft\_anniversary_\Interface\AddOns\RXPGuides\Guides\`
-- (2026-09-26 code review confirmed this copy matches; the `_classic_era_`
-- copy of the same guide file differs by 10 step lines in chapter 2, so
-- future re-parses should record which install's copy they used).
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
-- - CHAPTER 2 ("6-10 Durotar", added 2026-09-26): parsed and audited for the
--   same bug shapes chapter 1's playtests found, before any in-game testing
--   of chapter 2 itself (none has happened yet - see plan 12's checkpoint):
--   - Duplicate steps: 12 exact-duplicate lines removed across 6 groups -
--     four copies of a "Kill Pygmy Surf Crawlers..." (quest 818) complete
--     step collapsed to one, a second "Run down the beach..." (818)
--     complete-step pair collapsed to one, a duplicated "Kill Razormane
--     Dustrunners..." (quest 837) complete step, a duplicated "Talk to
--     Orgnil, Gar'Thok and Torka" (quest 815) accept step, a duplicated
--     "Talk to Swart" (quest 2983) accept step, a duplicated "Talk to
--     Tai'jin" (quest 5660) trainer step, and one whole duplicated
--     "kill Fizzle Darkstorm -> die -> fight out of Thunder Ridge" (quest
--     806) block (2 complete steps + its death step + its travel step, all
--     4 byte-identical to an earlier occurrence) - same OR-condition-branch
--     root cause as chapter 1's dupes, extended here to the `trainer`/
--     `death`/`travel` step types since this block's dupes shared it.
--     Scattered vendor/spell/item-equip duplicates (weapon vendor visits,
--     [Grimoire of Firebolt Rank 2], etc.) were intentionally left alone,
--     same as chapter 1 - those are idempotent/non-blocking and clutter,
--     not the "silently reads as already done" bug this check targets.
--   - Class-filter consistency: audited every accept/complete/turnin/trainer
--     step's `class` against its sibling(s) for the same quest, and every
--     tiered vendor-purchase chain (weapons, arrows, reagents) for
--     consistent `class`/`races` across all tiers - no instance of chapter
--     1's two bugs (mismatched accept-vs-complete class, or an unmarked
--     tier in an otherwise class-gated purchase chain) found in chapter 2.
--   - RESOLVED (2026-09-27 code review): quest 837 has two different turn-in
--     steps ("Talk to Torka and Gar'Thok", class = HUNTER, and later "Talk to
--     Orgnil and Gar'Thok", no class) - checked against the source guide
--     text directly rather than guessed: the first comes from a Hunter-only
--     `<< Hunter #xprate <1.5` branch (an early turn-in after extra grind),
--     the second from a `<< Hunter/Shaman/Warrior #xprate >1.49` branch whose
--     OR condition RXPImport.lua's parser can't express, so it kept the step
--     unfiltered - which happens to be correct here, since it also stands in
--     for the `<< !Hunter` branch the parser drops entirely (see the
--     multi-branch open issue below). Left as-is: both class filters are
--     doing real work and changing either would strand a class without a
--     turn-in.
--   - Bare `.xp N` directives: none appear in chapter 2's source text (only
--     modified forms like `.xp 7+2070`/`.xp <10,1`/`.xp >11,1`, which
--     correctly stay unconverted per RXPImport.lua's existing guard) - the
--     bare-`.xp` conversion had nothing to do here, confirmed by inspecting
--     the harness dump rather than assumed.
-- - FIXED (2026-09-27 code review): "Talk to Innkeeper Grosk" (quest 2161)
--   had been parsed as a Warrior-only `spell` step (from a trailing
--   `.train 284,1 << Warrior` directive on the same source line), which
--   silently dropped its own `.turnin 2161` - non-Warriors could never
--   complete it, and Warriors got the wrong step type. Changed back to a
--   plain `turnin` step; Warrior spell training for 284 is still covered by
--   the separate "Talk to Tarshaw" step right after it.
-- - NOT FIXED, disclosed for the playtest (2026-09-27 code review): several
--   RXPGuides source-branch tags aren't understood by RXPImport.lua and are
--   handled inconsistently rather than by design:
--   - `#season 2` (Season of Discovery) rune-training steps survive
--     unfiltered - about 20 steps across Warrior/Priest/Mage/Rogue that
--     can never complete on Era/Forever/Classic and need a manual Next.
--     Same class of gap as `Mulgore.lua`'s existing SoD exclusion, just not
--     yet applied to the RXPGuides importer.
--   - Both branches of an `#xprate`/`#hardcore`/`#softcore` split both
--     survive (RXPImport.lua has no token for either), including duplicate
--     non-optional "Die and release" steps.
--   - `<< !Hunter` (negated class) steps are dropped entirely by
--     RXPImport.lua rather than kept for the classes they apply to, which
--     is why non-Hunters are missing a Torka/Orgnil/Gar'Thok turn-in and a
--     Margoz (828) accept - see the quest-837 note above for how this
--     happens to still work out for that one specific quest.
--   - The two Warlock "Use the [Grimoire of Firebolt Rank 2]" spell steps
--     may never auto-complete - it is a pet spell and
--     `Compat:IsSpellKnown` doesn't check the pet's spellbook.
-- - NOT FIXED, disclosed for the playtest (2026-09-27 code review): a
--   `type = "travel"` step used as a grind marker (e.g. "Grind to
--   4400+/6500xp", "Grind until your hearthstone cooldown is <5 minutes")
--   completes on arrival at its coordinate (Core.lua's travel ticker), not
--   after the grind actually happens - the player won't be held there.
-- - MAJOR OPEN ISSUE, not fixed (2026-09-27 code review): when the source
--   guide names several quests on one step (e.g. "Talk to Vel'rin, Vornal
--   and Gadrin" for quests 817/818/808/826), RXPImport.lua keeps only the
--   LAST quest ID (RXPImport.lua's accept/turnin parsing overwrites
--   `step.quest` per directive instead of collecting all of them). In
--   chapter 2 this affects 29 of 63 distinct accept/turnin IDs - a step
--   auto-advances on the one ID it kept, silently leaving the other named
--   quests unaccepted/untracked for the player to notice and handle by
--   hand. This is the same defect class chapter 1 also has, just at much
--   larger scale in chapter 2's source text. Not fixed here - it needs a
--   RXPImport.lua change (either step.quest becoming a list, or splitting
--   these into one step per quest at parse time), which is bigger than a
--   single-chapter data fix and should be its own plan-12 follow-up before
--   further chapters are added, not patched ad hoc per chapter.
-- - Some near-duplicate (not byte-identical) same-quest/same-NPC steps
--   remain from chapter 2's OR-condition branches (turnin 786, accept 2983,
--   accept 6083, complete 806 - each appears twice). Harmless (the second
--   copy just silently skips itself, per the same mechanism the Nartok/
--   77586 entry above already explains) but not merged, unlike chapter 1's
--   byte-identical dupes.
-- - Every quest ID here is exactly what came out of the parser -
--   `/tuff verify` has not been run against this file yet.

local ADDON, ns = ...

ns.RegisterRoute("RXPGuides Orc/Troll 1-60 (TEST, parse in progress)", {
    faction = "Horde",
    races   = { "Orc", "Troll" },
    levels  = { 1, 10 },
    author  = "RXPImport (converted, via spec/rxp_harness.lua)",
    sample  = true,   -- mechanically converted, unverified IDs; run /tuff verify
    source  = "Converted from RXPGuides (RestedXP) Classic guide text (Classic-Horde-01-12_Durotar.lua, chapters 1-2: '1-6 Durotar', '6-10 Durotar'). RXPGuides content is CC BY-NC-SA 4.0 - see this file's Credits & License section below.",

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
        { type = "section", name = "6-10 Durotar", levels = { 6, 10 } },
        { type = "accept", name = "Talk to Ukor", zone = "Durotar", x = 52.06, y = 68.3, npc = "Ukor", quest = 2161 },
        { type = "note", name = ".subzone 367 >>Travel to Sen'Jin Village", note = ".subzone 367 >>Travel to Sen'Jin Village", optional = true },
        { type = "accept", name = "Talk to Lar. He patrols a little", zone = "Durotar", x = 54.2, y = 73.36, npc = "Lar Prowltusk", quest = 786, path = { { zone = "Durotar", x = 54.2, y = 73.36 }, { zone = "Durotar", x = 54.09, y = 76.31 }, { zone = "Durotar", x = 54.52, y = 74.83 } } },
        { type = "accept", name = "Talk to Vel'rin, Vornal and Gadrin", zone = "Durotar", x = 55.94, y = 74.72, npc = "Vel'rin Fang", quest = 823, path = { { zone = "Durotar", x = 55.95, y = 73.93 }, { zone = "Durotar", x = 55.94, y = 74.4 } } },
        { type = "travel", name = "Enter the big hut", zone = "Durotar", x = 56.31, y = 73.8, path = { { zone = "Durotar", x = 56.16, y = 74.43 } }, optional = true },
        { type = "travel", name = "Talk to K'waii. Buy  [Weighted Throwing Axe] from her", note = ".collect 3131,200,786,1 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.9", zone = "Durotar", x = 56.29, y = 73.41, npc = "K'waii", class = "ROGUE" },
        { type = "travel", name = "Talk to K'waii", note = "Buy [Refreshing Spring Water] from her - .collect 159,20,786,1 - .money <0.010", zone = "Durotar", x = 56.29, y = 73.41, npc = "K'waii" },
        { type = "travel", name = "Talk to K'waii", note = "Buy [Refreshing Spring Water] from her - .collect 159,10,786,1 - .money <0.0050", zone = "Durotar", x = 56.29, y = 73.41, npc = "K'waii" },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Walking Stick] (5s 04c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "SHAMAN" },
        { type = "travel", name = "Talk to Trayexir. Buy a [Walking Stick] from him", note = ".collect 2495,1,786,1 - .money <0.0504 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 56.47, y = 73.12, class = "SHAMAN" },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Stiletto] (4s 01c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "ROGUE" },
        { type = "travel", name = "Talk to Trayexir. Buy a [Stiletto] from him", note = ".collect 2494,1,786,1 - .money <0.0401 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", zone = "Durotar", x = 56.47, y = 73.12, class = "ROGUE" },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Large Axe] (4s 84c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "WARRIOR", races = { "Orc" } },
        { type = "travel", name = "Talk to Trayexir. Buy a [large Axe] from him", note = ".collect 2491,1,786,1 - .money <0.0484 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 56.47, y = 73.12, class = "WARRIOR", races = { "Orc" } },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Tomahawk] (5s 40c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "WARRIOR", races = { "Troll" } },
        { type = "travel", name = "Talk to Trayexir. Buy a [Tomahawk] from him", note = ".collect 2490,1,786,1 - .money <0.0540 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", zone = "Durotar", x = 56.47, y = 73.12, class = "WARRIOR", races = { "Troll" } },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Hornwood Recurve Bow] (2s 83c). You'll come back later if you don't have enough yet - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "HUNTER" },
        { type = "travel", name = "Talk to Trayexir. Buy a [Hornwood Recurve Bow] from him", note = ".collect 2506,1,786,1 - .money <0.0283 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", zone = "Durotar", x = 56.47, y = 73.12, class = "HUNTER" },
        { type = "item", note = "Equip the [Weighted Throwing Axe] - .use 3131 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.9", itemID = 3131, count = 1, class = "ROGUE" },
        { type = "item", note = "Equip the [Walking Stick] - .use 2495 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", itemID = 2495, count = 1, class = "SHAMAN" },
        { type = "item", note = "Equip the [Stiletto] - .use 2494 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", itemID = 2494, count = 1, class = "ROGUE" },
        { type = "item", note = "Equip the [large Axe] - .use 2491 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", itemID = 2491, count = 1, class = "WARRIOR", races = { "Orc" } },
        { type = "item", note = "Equip the [Tomahawk] - .use 2490 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", itemID = 2490, count = 1, class = "WARRIOR", races = { "Troll" } },
        { type = "item", note = "Equip the [Hornwood Recurve Bow] - .use 2506 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", itemID = 2506, count = 1, class = "HUNTER" },
        { type = "spell", name = "Talk to Un'Thuwa", zone = "Durotar", x = 56.3, y = 75.11, npc = "Un'Thuwa", spellID = 2136, class = "MAGE" },
        { type = "spell", note = "Cast [Find Minerals] and mine any Copper Vein you find for [Rough Stones]. Make [Sharpening Stones] from them - .collect 2862,1,786,1 - .skill blacksmithing,<1,1", spellID = 2575 },
        { type = "complete", name = "Run down the beach. Kill Crawlers and Makruras. Loot them for their Mucus and Eyes. You do not have to finish this step here.", note = ".mob +Pygmy Surf Crawler - .mob +Surf Crawler - .mob +Makrura Shellhide - .mob +Makrura Clacker", zone = "Durotar", x = 52.2, y = 83, quest = 818, path = { { zone = "Durotar", x = 58.54, y = 75.89 }, { zone = "Durotar", x = 57.73, y = 77.91 }, { zone = "Durotar", x = 55.72, y = 79.62 }, { zone = "Durotar", x = 54.23, y = 82.26 } }, optional = true, objective = 1 },
        { type = "travel", name = "Reach the end of the beach", zone = "Durotar", x = 54.17, y = 82.6 },
        { type = "travel", name = "Reach the end of the beach", note = ".isOnQuest 818", zone = "Durotar", x = 52.2, y = 83 },
        { type = "complete", name = "Kill Kolkar Drudges and Kolkar Outrunners. Loot them for their Canvas Scraps", note = ".isOnQuest 791", quest = 791, objective = 1 },
        { type = "travel", name = "Enter the Kolkar base", note = ".isOnQuest 786", zone = "Durotar", x = 50.9, y = 79.2 },
        { type = "note", name = "Start collecting 3 stacks of [Linen Cloth] as you quest throughout Durotar. This will be used to make your wand later", note = "Skip this step if you've already bought a wand or can get one cheap from the AH. - .collect 2589,60", class = "PRIEST", optional = true },
        { type = "note", name = "Start collecting 3 stacks of [Linen Cloth] as you quest throughout Durotar. This will be used to make your wand later", note = ".collect 2589,60", class = "PRIEST", optional = true },
        { type = "note", name = "Be careful if Kolkanis is up, he is a level 9 rare. You may have to use a  [Minor Healing Potion] if you have it - .unitscan Warlord Kolkanis", note = "Be careful if Kolkanis is up, he is a level 9 rare. You may have to use a  [Minor Healing Potion] if you have it - .unitscan Warlord Kolkanis", optional = true },
        { type = "spell", name = "Kill Kolkar Drudges and Kolkar Outrunners. Loot them for a Severed Centaur Head", note = ".collect 207062,1 - .mob Kolkar Drudge - .mob Kolkar Outrunner", spellID = 403475, class = "WARRIOR" },
        { type = "complete", name = "Burn the Attack Plan inside the tent on the ground", zone = "Durotar", x = 49.81, y = 81.29, quest = 786, objective = 1 },
        { type = "complete", name = "Burn the Attack Plan on the ground", zone = "Durotar", x = 47.66, y = 77.34, quest = 786, objective = 2 },
        { type = "complete", name = "Burn the Attack Plan on the ground", zone = "Durotar", x = 46.23, y = 78.94, quest = 786, objective = 3 },
        { type = "spell", name = "Kill Kolkar Drudges and Kolkar Outrunners. Loot them for a Severed Centaur Head", note = ".collect 207062,1 - .mob Kolkar Drudge - .mob Kolkar Outrunner", zone = "Durotar", x = 46.54, y = 80.12, spellID = 403475, path = { { zone = "Durotar", x = 50.1, y = 79.24 }, { zone = "Durotar", x = 50.1, y = 79.24 }, { zone = "Durotar", x = 47.74, y = 80.35 } }, class = "WARRIOR" },
        { type = "death", name = "Die and release", note = ".isQuestComplete 786", zone = "Durotar", x = 57.5, y = 73.26, path = { { zone = "Durotar", x = 46.43, y = 79.25 } } },
        { type = "travel", name = "Leave the Kolkar base", note = ".isQuestComplete 786", zone = "Durotar", x = 50.95, y = 79.14, optional = true },
        { type = "turnin", name = "Talk to Lar. He patrols a little", note = ".isQuestComplete 786", zone = "Durotar", x = 54.2, y = 73.36, npc = "Lar Prowltusk", quest = 786, path = { { zone = "Durotar", x = 54.2, y = 73.36 }, { zone = "Durotar", x = 54.09, y = 76.31 }, { zone = "Durotar", x = 54.52, y = 74.83 } } },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Walking Stick] (5s 04c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "SHAMAN" },
        { type = "travel", name = "Talk to Trayexir. Buy a [Walking Stick] from him", note = ".collect 2495,1,823,1 - .money <0.0504 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 56.47, y = 73.12, class = "SHAMAN" },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Stiletto] (4s 01c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "ROGUE" },
        { type = "travel", name = "Talk to Trayexir. Buy a [Stiletto] from him", note = ".collect 2494,1,823,1 - .money <0.0401 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", zone = "Durotar", x = 56.47, y = 73.12, class = "ROGUE" },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Large Axe] (4s 84c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "WARRIOR", races = { "Orc" } },
        { type = "travel", name = "Talk to Trayexir. Buy a [large Axe] from him", note = ".collect 2491,1,823,1 - .money <0.0484 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 56.47, y = 73.12, class = "WARRIOR", races = { "Orc" } },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Tomahawk] (5s 40c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "WARRIOR", races = { "Troll" } },
        { type = "travel", name = "Talk to Trayexir. Buy a [Tomahawk] from him", note = ".collect 2490,1,823,1 - .money <0.0540 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", zone = "Durotar", x = 56.47, y = 73.12, class = "WARRIOR", races = { "Troll" } },
        { type = "travel", name = "Talk to Trayexir", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Hornwood Recurve Bow] (2s 83c). You'll come back later if you don't have enough yet - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", zone = "Durotar", x = 56.47, y = 73.12, npc = "Trayexir", class = "HUNTER" },
        { type = "travel", name = "Talk to Trayexir. Buy a [Hornwood Recurve Bow] from him", note = ".collect 2506,1,823,1 - .money <0.0283 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", zone = "Durotar", x = 56.47, y = 73.12, class = "HUNTER" },
        { type = "item", note = "Equip the [Weighted Throwing Axe] - .use 3131 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.9", itemID = 3131, count = 1, class = "ROGUE" },
        { type = "item", note = "Equip the [Walking Stick] - .use 2495 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", itemID = 2495, count = 1, class = "SHAMAN" },
        { type = "item", note = "Equip the [Stiletto] - .use 2494 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", itemID = 2494, count = 1, class = "ROGUE" },
        { type = "item", note = "Equip the [large Axe] - .use 2491 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", itemID = 2491, count = 1, class = "WARRIOR", races = { "Orc" } },
        { type = "item", note = "Equip the [Tomahawk] - .use 2490 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", itemID = 2490, count = 1, class = "WARRIOR", races = { "Troll" } },
        { type = "item", note = "Equip the [Hornwood Recurve Bow] - .use 2506 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", itemID = 2506, count = 1, class = "HUNTER" },
        { type = "turnin", name = "Talk to Vornal", note = ".isQuestComplete 818", zone = "Durotar", x = 55.95, y = 74.39, npc = "Master Vornal", quest = 818 },
        { type = "travel", name = "Talk to Hai'zan", note = "Buy [Haunch of Meat] from him - Vendor: Vendor trash - .collect 2287,10,823,1 - .money <0.025", zone = "Durotar", x = 55.62, y = 73.61, npc = "Hai'zan" },
        { type = "travel", name = "Talk to K'waii", note = "Buy [Refreshing Spring Water] from her - .collect 159,20,784,1 - .money <0.010", zone = "Durotar", x = 56.29, y = 73.41, npc = "K'waii" },
        { type = "travel", name = "Talk to K'waii", note = "Buy [Refreshing Spring Water] from her - .collect 159,10,784,1 - .money <0.0050", zone = "Durotar", x = 56.29, y = 73.41, npc = "K'waii" },
        { type = "turnin", name = "Talk to Lar. He patrols a little", zone = "Durotar", x = 54.2, y = 73.36, npc = "Lar Prowltusk", quest = 786, path = { { zone = "Durotar", x = 54.2, y = 73.36 }, { zone = "Durotar", x = 54.09, y = 76.31 }, { zone = "Durotar", x = 54.52, y = 74.83 } } },
        { type = "spell", name = "Talk to Ba'so to receive [Rune of Mutilation]", note = "He is stealthed! - .collect 203990,1 - .skipgossip", zone = "Durotar", x = 51.82, y = 58.67, npc = "Ba'so", spellID = 400094, itemID = 207098, count = 1, class = "ROGUE" },
        { type = "item", name = "Use the [Rune of Mutilation] to train [Mutilate]", note = ".use 203990", spellID = 400094, itemID = 203990, count = 1, class = "ROGUE" },
        { type = "note", name = ".subzone 362 >>Travel to Razor Hill", note = ".subzone 362 >>Travel to Razor Hill", optional = true },
        { type = "accept", name = "Talk to Orgnil, Gar'Thok and Torka", zone = "Durotar", x = 51.09, y = 42.49, npc = "Orgnil Soulscar", quest = 815, path = { { zone = "Durotar", x = 52.24, y = 43.15 }, { zone = "Durotar", x = 51.95, y = 43.5 } } },
        { type = "travel", name = "Travel toward the tower", zone = "Durotar", x = 49.67, y = 40.42, path = { { zone = "Durotar", x = 50.22, y = 43.06 }, { zone = "Durotar", x = 50.09, y = 42.97 }, { zone = "Durotar", x = 50.2, y = 42.3 }, { zone = "Durotar", x = 49.96, y = 40.96 } }, optional = true },
        { type = "travel", name = "Travel up the tower toward Furl", zone = "Durotar", x = 49.6, y = 40.04, path = { { zone = "Durotar", x = 49.75, y = 40.38 }, { zone = "Durotar", x = 49.77, y = 40.24 }, { zone = "Durotar", x = 49.69, y = 40.21 }, { zone = "Durotar", x = 49.68, y = 40.3 }, { zone = "Durotar", x = 49.78, y = 40.34 }, { zone = "Durotar", x = 49.79, y = 39.96 } }, optional = true },
        { type = "accept", name = "Talk to Furl", zone = "Durotar", x = 49.89, y = 40.39, npc = "Furl Scornbrow", quest = 791 },
        { type = "spell", name = "Talk to Krunn", note = "This will allow you to find [Rough Stones] from nodes in order to craft [Sharpening Stones] (+2 Weapon Damage for 30 minutes)", zone = "Durotar", x = 51.81, y = 40.89, npc = "Krunn", spellID = 2575 },
        { type = "travel", name = "Talk to Wuark", note = "Buy a [Mining Pick] from him - .collect 2901,1,784,1", zone = "Durotar", x = 51.9, y = 41.14, npc = "Wuark" },
        { type = "spell", name = "Talk to Dwukk", note = ".skill blacksmithing,1,1", zone = "Durotar", x = 52.05, y = 40.73, npc = "Dwukk", spellID = 2018 },
        { type = "spell", note = "Cast [Find Minerals] and mine any Copper Vein you find for [Rough Stones]. Make [Sharpening Stones] from them - .collect 2862,1,786,1 - .skill blacksmithing,<1,1", spellID = 2575 },
        { type = "travel", name = "Grind mobs on the way", note = ".subzone 372 >> Travel to Tiragarde Keep - .isOnQuest 784", zone = "Durotar", x = 54.42, y = 62.64 },
        { type = "travel", name = "Grind mobs on the way", note = ".subzone 372 >> Travel to Tiragarde Keep - .isOnQuest 784", zone = "Durotar", x = 57.26, y = 54.69 },
        { type = "note", name = "Be careful if Watch Commander Zalaphil is up, as he is a level 9 rare. You may have to use a [Minor Healing Potion] if you have one - .unitscan Watch Commander Zalaphil", note = "Be careful if Watch Commander Zalaphil is up, as he is a level 9 rare. You may have to use a [Minor Healing Potion] if you have one - .unitscan Watch Commander Zalaphil", optional = true },
        { type = "travel", name = "Move toward the second floor of the keep", zone = "Durotar", x = 59.29, y = 57.89, path = { { zone = "Durotar", x = 59.81, y = 58.22 }, { zone = "Durotar", x = 59.64, y = 58.44 }, { zone = "Durotar", x = 59.55, y = 57.89 } } },
        { type = "spell", name = "Kill Sailors and Marines. Loot them for the [Memory of a Dark Purpose]", note = ".collect 205940,1", spellID = 425216, class = "PRIEST" },
        { type = "complete", name = "Kill Kul Tiras Sailors and Kul Tiras Marines. Loot them for their Canvas Scraps", note = ".mob +Kul Tiras Sailor - .mob +Kul Tiras Marine - .mob +Kul Tiras Marine - .mob +Kul Tiras Sailor", quest = 791, objective = 1 },
        { type = "complete", name = "Kill Lieutenant Benedict. Loot him for his Key", note = ".collect 4882,1,830,1 - .mob Lieutenant Benedict", zone = "Durotar", x = 59.75, y = 58.27, quest = 784, objective = 3 },
        { type = "accept", name = "Go upstairs in the keep", note = "Open Benedict's Chest. Loot it for the [Aged Envelope] - Use the [Aged Envelope] to start the quest - .collect 4881,1,830 - .use 4881", zone = "Durotar", x = 59.27, y = 57.65, quest = 830, path = { { zone = "Durotar", x = 59.87, y = 57.87 }, { zone = "Durotar", x = 59.83, y = 57.58 }, { zone = "Durotar", x = 59.8, y = 57.82 }, { zone = "Durotar", x = 59.94, y = 57.82 }, { zone = "Durotar", x = 59.94, y = 57.61 } } },
        { type = "complete", name = "Kill Kul Tiras Sailors and Kul Tiras Marines. Loot them for their Canvas Scraps", note = ".mob +Kul Tiras Sailor - .mob +Kul Tiras Marine - .mob +Kul Tiras Marine - .mob +Kul Tiras Sailor", zone = "Durotar", x = 58.99, y = 58.3, quest = 791, path = { { zone = "Durotar", x = 58.99, y = 58.3 }, { zone = "Durotar", x = 57.65, y = 58.52 }, { zone = "Durotar", x = 57.36, y = 56.59 }, { zone = "Durotar", x = 58.1, y = 55.52 }, { zone = "Durotar", x = 58.54, y = 53.68 }, { zone = "Durotar", x = 56.54, y = 54.52 }, { zone = "Durotar", x = 56.37, y = 58.35 } }, objective = 1 },
        { type = "complete", name = "Kill Kul Tiras Sailors and Kul Tiras Marines", note = ".mob +Kul Tiras Sailor - .mob +Kul Tiras Marine", zone = "Durotar", x = 58.99, y = 58.3, quest = 784, path = { { zone = "Durotar", x = 58.99, y = 58.3 }, { zone = "Durotar", x = 57.65, y = 58.52 }, { zone = "Durotar", x = 57.36, y = 56.59 }, { zone = "Durotar", x = 58.1, y = 55.52 }, { zone = "Durotar", x = 58.54, y = 53.68 }, { zone = "Durotar", x = 56.54, y = 54.52 }, { zone = "Durotar", x = 56.37, y = 58.35 } }, objective = 2 },
        { type = "complete", name = "Kill Kul Tiras Sailors and Kul Tiras Marines. Loot them for their Canvas Scraps", note = ".mob Kul Tiras Sailor - .mob Kul Tiras Marine", zone = "Durotar", x = 58.99, y = 58.3, quest = 791, path = { { zone = "Durotar", x = 58.99, y = 58.3 }, { zone = "Durotar", x = 57.65, y = 58.52 }, { zone = "Durotar", x = 57.36, y = 56.59 }, { zone = "Durotar", x = 58.1, y = 55.52 }, { zone = "Durotar", x = 58.54, y = 53.68 }, { zone = "Durotar", x = 56.54, y = 54.52 }, { zone = "Durotar", x = 56.37, y = 58.35 } }, objective = 1 },
        { type = "spell", name = "Kill Sailors and Marines. Loot them for the [Memory of a Dark Purpose]", note = ".collect 205940,1 - .mob Kul Tiras Sailor - .mob Kul Tiras Marine", zone = "Durotar", x = 58.99, y = 58.3, spellID = 425216, path = { { zone = "Durotar", x = 58.99, y = 58.3 }, { zone = "Durotar", x = 57.65, y = 58.52 }, { zone = "Durotar", x = 57.36, y = 56.59 }, { zone = "Durotar", x = 58.1, y = 55.52 }, { zone = "Durotar", x = 58.54, y = 53.68 }, { zone = "Durotar", x = 56.54, y = 54.52 }, { zone = "Durotar", x = 56.37, y = 58.35 } }, class = "PRIEST" },
        { type = "spell", note = ".emote KNEEL,208309 - .aura 417316 >>Kneel before the Loa Altar and talk to the Serpent Loa to get the [Meditation on the Loa] buff - .skipgossip 208307,1", zone = "Durotar", x = 55.32, y = 72.66, npc = "Serpent Loa", spellID = 425216, class = "PRIEST", optional = true },
        { type = "spell", name = "Use the [Memory of Dark Purpose] to train [Void Plague]", note = ".use 205940", spellID = 425216, itemID = 205940, count = 1, class = "PRIEST" },
        { type = "travel", name = ".xp 7+2070 >> Grind to 2070+/4500xp - .isNotOnQuest 823", note = ".xp 7+2070 >> Grind to 2070+/4500xp - .isNotOnQuest 823", zone = "Durotar", x = 55.5, y = 48.97, path = { { zone = "Durotar", x = 59.02, y = 50.24 }, { zone = "Durotar", x = 57.93, y = 47.71 }, { zone = "Durotar", x = 59.2, y = 44.3 }, { zone = "Durotar", x = 57.96, y = 42.46 }, { zone = "Durotar", x = 56.47, y = 43.45 } }, class = "PRIEST" },
        { type = "travel", name = ".xp 7+1750 >> Grind to 1750+/4500xp - .isOnQuest 823", note = ".xp 7+1750 >> Grind to 1750+/4500xp - .isOnQuest 823", zone = "Durotar", x = 55.5, y = 48.97, path = { { zone = "Durotar", x = 59.02, y = 50.24 }, { zone = "Durotar", x = 57.93, y = 47.71 }, { zone = "Durotar", x = 59.2, y = 44.3 }, { zone = "Durotar", x = 57.96, y = 42.46 }, { zone = "Durotar", x = 56.47, y = 43.45 } }, class = "PRIEST" },
        { type = "travel", name = ".xp 7+855 >> Grind to 855+/4500xp - .isNotOnQuest 823", note = ".xp 7+855 >> Grind to 855+/4500xp - .isNotOnQuest 823", zone = "Durotar", x = 55.5, y = 48.97, path = { { zone = "Durotar", x = 59.02, y = 50.24 }, { zone = "Durotar", x = 57.93, y = 47.71 }, { zone = "Durotar", x = 59.2, y = 44.3 }, { zone = "Durotar", x = 57.96, y = 42.46 }, { zone = "Durotar", x = 56.47, y = 43.45 } }, class = "PRIEST" },
        { type = "travel", name = ".xp 7+375 >> Grind to 375+/4500xp - .isOnQuest 823", note = ".xp 7+375 >> Grind to 375+/4500xp - .isOnQuest 823", zone = "Durotar", x = 55.5, y = 48.97, path = { { zone = "Durotar", x = 59.02, y = 50.24 }, { zone = "Durotar", x = 57.93, y = 47.71 }, { zone = "Durotar", x = 59.2, y = 44.3 }, { zone = "Durotar", x = 57.96, y = 42.46 }, { zone = "Durotar", x = 56.47, y = 43.45 } }, class = "PRIEST" },
        { type = "death", name = "Die and release", zone = "Durotar", x = 57.3, y = 53.5 },
        { type = "note", name = ".subzone 362 >>Travel to Razor Hill", note = ".subzone 362 >>Travel to Razor Hill", optional = true },
        { type = "accept", name = "Talk to Gar'Thok", zone = "Durotar", x = 51.95, y = 43.5, npc = "Gar'Thok", quest = 831 },
        { type = "travel", name = "Travel toward the tower", zone = "Durotar", x = 49.67, y = 40.42, path = { { zone = "Durotar", x = 50.22, y = 43.06 }, { zone = "Durotar", x = 50.09, y = 42.97 }, { zone = "Durotar", x = 50.2, y = 42.3 }, { zone = "Durotar", x = 49.96, y = 40.96 } }, optional = true },
        { type = "travel", name = "Travel up the tower toward Furl", zone = "Durotar", x = 49.6, y = 40.04, path = { { zone = "Durotar", x = 49.75, y = 40.38 }, { zone = "Durotar", x = 49.77, y = 40.24 }, { zone = "Durotar", x = 49.69, y = 40.21 }, { zone = "Durotar", x = 49.68, y = 40.3 }, { zone = "Durotar", x = 49.78, y = 40.34 }, { zone = "Durotar", x = 49.79, y = 39.96 } }, optional = true },
        { type = "turnin", name = "Talk to Furl", zone = "Durotar", x = 49.89, y = 40.39, npc = "Furl Scornbrow", quest = 791 },
        { type = "spell", name = "Talk to Krunn", note = "This will allow you to find [Rough Stones] from nodes in order to craft [Sharpening Stones] (+2 Weapon Damage for 30 minutes)", zone = "Durotar", x = 51.81, y = 40.89, npc = "Krunn", spellID = 2575 },
        { type = "travel", name = "Talk to Wuark", note = "Buy a [Mining Pick] from Wuark - .collect 2901,1,825,1", zone = "Durotar", x = 51.9, y = 41.14, npc = "Wuark" },
        { type = "spell", name = "Talk to Dwukk", note = ".skill blacksmithing,1,1", zone = "Durotar", x = 52.05, y = 40.73, npc = "Dwukk", spellID = 2018 },
        { type = "travel", name = "Talk to Uhgar", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Walking Stick] (5s 04c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 52.02, y = 40.46, npc = "Uhgar", class = "SHAMAN" },
        { type = "travel", name = "Talk to Uhgar. Buy a [Walking Stick] from him", note = ".collect 2495,1,825,1 - .money <0.0504 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 52.02, y = 40.46, class = "SHAMAN" },
        { type = "travel", name = "Talk to Uhgar", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Stiletto] (4s 01c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", zone = "Durotar", x = 52.02, y = 40.46, npc = "Uhgar", class = "ROGUE" },
        { type = "travel", name = "Talk to Uhgar. Buy a [Stiletto] from him", note = ".collect 2494,1,825,1 - .money <0.0401 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", zone = "Durotar", x = 52.02, y = 40.46, class = "ROGUE" },
        { type = "travel", name = "Talk to Uhgar", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Large Axe] (4s 84c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 52.02, y = 40.46, npc = "Uhgar", class = "WARRIOR", races = { "Orc" } },
        { type = "travel", name = "Talk to Uhgar. Buy a [large Axe] from him", note = ".collect 2491,1,825,1 - .money <0.0484 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", zone = "Durotar", x = 52.02, y = 40.46, class = "WARRIOR", races = { "Orc" } },
        { type = "travel", name = "Talk to Uhgar", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Tomahawk] (5s 40c). You'll come back later if you don't have enough yet - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", zone = "Durotar", x = 52.02, y = 40.46, npc = "Uhgar", class = "WARRIOR", races = { "Troll" } },
        { type = "travel", name = "Talk to Uhgar. Buy a [Tomahawk] from him", note = ".collect 2490,1,825,1 - .money <0.0540 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", zone = "Durotar", x = 52.02, y = 40.46, class = "WARRIOR", races = { "Troll" } },
        { type = "item", note = "Equip the [Weighted Throwing Axe] - .use 3131 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.9", itemID = 3131, count = 1, class = "ROGUE" },
        { type = "item", note = "Equip the [Walking Stick] - .use 2495 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", itemID = 2495, count = 1, class = "SHAMAN" },
        { type = "item", note = "Equip the [Stiletto] - .use 2494 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.3", itemID = 2494, count = 1, class = "ROGUE" },
        { type = "item", note = "Equip the [large Axe] - .use 2491 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2", itemID = 2491, count = 1, class = "WARRIOR", races = { "Orc" } },
        { type = "item", note = "Equip the [Tomahawk] - .use 2490 - .itemStat 16,QUALITY,<7 - .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8", itemID = 2490, count = 1, class = "WARRIOR", races = { "Troll" } },
        { type = "travel", name = "Talk to Ghrawt", note = "Vendor: Vendor trash. Sell your weapon if it gives you enough money for a [Hornwood Recurve Bow] (2s 83c). You'll come back later if you don't have enough yet - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", zone = "Durotar", x = 52.97, y = 41.04, npc = "Ghrawt", class = "HUNTER" },
        { type = "travel", name = "Talk to Ghrawt. Buy a [Hornwood Recurve Bow] from him", note = ".collect 2506,1,818,1 - .money <0.0283 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", zone = "Durotar", x = 52.97, y = 41.04, class = "HUNTER" },
        { type = "item", note = "Equip the [Hornwood Recurve Bow] - .use 2506 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.3", itemID = 2506, count = 1, class = "HUNTER" },
        { type = "travel", name = "Talk to Ghrawt. Buy [Rough Arrows] from him", note = ".collect 2512,1000,825,1", zone = "Durotar", x = 52.97, y = 41.04, npc = "Ghrawt", class = "HUNTER" },
        { type = "turnin", name = "Talk to Innkeeper Grosk", note = "Buy [Ice Cold Milk] from him - Buy [Haunch of Meat] from him - Save 4 silver for your class spells! - Save 2 silver for your class spells! - Vendor: Vendor Trash - .home >> Set your Hearthstone to Razor Hill - .bindlocation 362", zone = "Durotar", x = 51.51, y = 41.64, npc = "Innkeeper Grosk", quest = 2161 },
        { type = "spell", name = "Talk to Tarshaw", zone = "Durotar", x = 54.18, y = 42.46, npc = "Tarshaw Jaggedscar", spellID = 284, class = "WARRIOR" },
        { type = "spell", name = "Talk to Swart", zone = "Durotar", x = 54.42, y = 42.59, npc = "Swart", spellID = 8044, class = "SHAMAN" },
        { type = "spell", name = "Talk to Dhugru", zone = "Durotar", x = 54.37, y = 41.2, npc = "Dhugru Gorelust", spellID = 1120, class = "WARLOCK" },
        { type = "travel", name = "Talk to Kitha and buy [Firebolt Rank 2]", note = ".collect 16302,1,825,1 - .money <0.01", zone = "Durotar", x = 54.7, y = 41.49, npc = "Kitha", class = "WARLOCK", optional = true },
        { type = "spell", name = "Use the [Grimoire of Firebolt Rank 2]", note = ".use 16302", spellID = 20270, class = "WARLOCK" },
        { type = "spell", name = "Go inside the bunker", note = "Talk to Thotar inside", zone = "Durotar", x = 51.85, y = 43.49, npc = "Thotar", spellID = 5116, class = "HUNTER" },
        { type = "spell", name = "Talk to Kaplak", zone = "Durotar", x = 51.98, y = 43.69, npc = "Kaplak", spellID = 6760, class = "ROGUE" },
        { type = "accept", name = "Talk to Tai'jin", zone = "Durotar", x = 54.26, y = 42.93, npc = "Tai'jin", quest = 5648, class = "PRIEST" },
        { type = "complete", name = "Cast [Lesser Heal] and [Power Word: Fortitude] on Kor'ja", zone = "Durotar", x = 53.1, y = 46.46, npc = "Grunt Kor'ja", quest = 5648, class = "PRIEST", objective = 1 },
        { type = "trainer", name = "Talk to Tai'jin", zone = "Durotar", x = 54.26, y = 42.93, npc = "Tai'jin", quest = 5648, class = "PRIEST" },
        { type = "spell", name = "Talk to Rawrk", note = ".money <0.01", zone = "Durotar", x = 54.17, y = 41.93, npc = "Rawrk", spellID = 3273 },
        { type = "travel", name = "Talk to Jark", note = "Buy a [Small Brown Pouch] from him - .collect 4496,1,825,1 - .money <0.05", zone = "Durotar", x = 54.39, y = 42.18, npc = "Jark" },
        { type = "complete", name = "Kill Pygmy Surf Crawlers and Surf Crawlers. Loot them for their Mucus", note = "Kill Makrura Spellhides and Makrura Clackers. Loot them for their Eyes - .mob +Pygmy Surf Crawler - .mob +Surf Crawler - .mob +Makrura Shellhide - .mob +Makrura Clacker", quest = 818, optional = true, objective = 1 },
        { type = "complete", name = "Loot the Gnomish Toolboxes inside and around the boats", zone = "Durotar", x = 62.25, y = 56.34, quest = 825, path = { { zone = "Durotar", x = 61.96, y = 55.46 }, { zone = "Durotar", x = 61.96, y = 55.46 }, { zone = "Durotar", x = 62.25, y = 56.34 }, { zone = "Durotar", x = 62.43, y = 59.84 }, { zone = "Durotar", x = 62.09, y = 60.68 }, { zone = "Durotar", x = 62.51, y = 60.56 }, { zone = "Durotar", x = 63.24, y = 58.1 } }, objective = 1 },
        { type = "travel", name = "Swim to the Island", zone = "Durotar", x = 67.1, y = 69.29 },
        { type = "complete", name = "Kill Durotar Tigers. Loot them for their Fur", note = ".mob Durotar Tiger", quest = 817, objective = 1 },
        { type = "complete", name = "Loot the Taillasher Eggs on the ground", note = "They're usually guarded by a Bloodtalon Taillasher - .mob Bloodtalon Taillasher", zone = "Durotar", x = 67.74, y = 69.86, quest = 815, path = { { zone = "Durotar", x = 67.04, y = 71.4 }, { zone = "Durotar", x = 70.23, y = 70.84 }, { zone = "Durotar", x = 67.04, y = 71.4 }, { zone = "Durotar", x = 67.66, y = 73.86 }, { zone = "Durotar", x = 68.67, y = 74.47 }, { zone = "Durotar", x = 69.76, y = 74.69 }, { zone = "Durotar", x = 70.29, y = 73.31 }, { zone = "Durotar", x = 70.23, y = 70.84 }, { zone = "Durotar", x = 69.69, y = 70.35 }, { zone = "Durotar", x = 69.21, y = 69.69 } }, objective = 1 },
        { type = "travel", name = "Swim to the main island", note = ".isOnQuest 826", zone = "Durotar", x = 66.94, y = 84.41 },
        { type = "complete", name = "Kill Hexed Trolls and Voodoo Trolls", note = ".mob +Hexed Troll - .mob +Voodoo Troll", quest = 826, objective = 2 },
        { type = "spell", name = "Kill the Voodoo Trolls. Loot them for [Prophecy of a Desecrated Citadel]", note = ".collect 205947,1 - .mob Voodoo Troll", spellID = 402852, class = "PRIEST" },
        { type = "spell", name = "Kill Zalazane. Loot him for the [Spell Notes: RING SEFF OSTROF]", note = ".collect 203753,1 - .mob Zalazane", spellID = 401765, class = "MAGE" },
        { type = "complete", name = "Kill Zalazane. Loot him for his Head", note = "Save your [Earth Shock] for when he casts [Healing Wave] - Save your [Gouge] for when he casts [Healing Wave] - .mob Zalazane", quest = 826, optional = true, objective = 3 },
        { type = "complete", name = "Loot one of the Skulls on the ground", zone = "Durotar", x = 67.4, y = 87.8, quest = 808, objective = 1 },
        { type = "complete", name = "Kill Zalazane. Loot him for his Head", note = "Save your [Earth Shock] for when he casts [Healing Wave] - Save your [Gouge] for when he casts [Healing Wave] - .mob Zalazane", zone = "Durotar", x = 67.4, y = 87.8, quest = 826, objective = 3 },
        { type = "spell", name = "Kill Zalazane. Loot him for the [Spell Notes: RING SEFF OSTROF]", note = ".collect 203753,1 - .mob Zalazane", zone = "Durotar", x = 67.4, y = 87.8, spellID = 401765, class = "MAGE" },
        { type = "spell", name = "Use the [Spell Notes: RING SEFF OSTROF] to learn [Fingers of Frost]", note = ".collect 211779,1 >>You need a [Comprehension Charm] from a Reagent Vendor to use the item - .use 203753", spellID = 401765, class = "MAGE" },
        { type = "complete", name = "Kill Durotar Tigers. Loot them for their Fur", note = ".mob Durotar Tiger", quest = 817, optional = true, objective = 1 },
        { type = "complete", name = "Kill Hexed Trolls and Voodoo Trolls", note = ".mob +Hexed Troll - .mob +Voodoo Troll", zone = "Durotar", x = 67.23, y = 88, quest = 826, path = { { zone = "Durotar", x = 67.23, y = 88.76 }, { zone = "Durotar", x = 67.23, y = 88.76 }, { zone = "Durotar", x = 66.52, y = 87.74 }, { zone = "Durotar", x = 65.94, y = 86.72 }, { zone = "Durotar", x = 65.9, y = 84.04 }, { zone = "Durotar", x = 65.88, y = 82.85 }, { zone = "Durotar", x = 67.38, y = 82.61 }, { zone = "Durotar", x = 68.42, y = 82.43 }, { zone = "Durotar", x = 68.5, y = 84.32 }, { zone = "Durotar", x = 68.47, y = 86.77 } }, objective = 2 },
        { type = "spell", name = "Kill the Voodoo Trolls. Loot them for [Prophecy of a Desecrated Citadel]", note = ".collect 205947,1 - .mob Voodoo Troll", zone = "Durotar", x = 67.23, y = 88, spellID = 402852, path = { { zone = "Durotar", x = 67.23, y = 88.76 }, { zone = "Durotar", x = 67.23, y = 88.76 }, { zone = "Durotar", x = 66.52, y = 87.74 }, { zone = "Durotar", x = 65.94, y = 86.72 }, { zone = "Durotar", x = 65.9, y = 84.04 }, { zone = "Durotar", x = 65.88, y = 82.85 }, { zone = "Durotar", x = 67.38, y = 82.61 }, { zone = "Durotar", x = 68.42, y = 82.43 }, { zone = "Durotar", x = 68.5, y = 84.32 }, { zone = "Durotar", x = 68.47, y = 86.77 } }, class = "PRIEST" },
        { type = "complete", name = "Kill Durotar Tigers. Loot them for their Fur", note = ".mob Durotar Tiger", zone = "Durotar", x = 59.79, y = 83.44, quest = 817, path = { { zone = "Durotar", x = 59.79, y = 83.44 }, { zone = "Durotar", x = 65.27, y = 87.86 }, { zone = "Durotar", x = 64.72, y = 88.53 }, { zone = "Durotar", x = 64.7, y = 84.89 }, { zone = "Durotar", x = 64.68, y = 80.8 }, { zone = "Durotar", x = 65.35, y = 80.11 }, { zone = "Durotar", x = 65.87, y = 81.23 }, { zone = "Durotar", x = 60.28, y = 80.04 }, { zone = "Durotar", x = 60.6, y = 82.26 }, { zone = "Durotar", x = 59.88, y = 83.51 }, { zone = "Durotar", x = 59.56, y = 84.86 }, { zone = "Durotar", x = 60.84, y = 88.79 }, { zone = "Durotar", x = 61.41, y = 89.69 }, { zone = "Durotar", x = 61.48, y = 91.37 }, { zone = "Durotar", x = 60.37, y = 91.36 }, { zone = "Durotar", x = 59.04, y = 90.51 } }, objective = 1 },
        { type = "complete", name = "Kill Pygmy Surf Crawlers and Surf Crawlers. Loot them for their Mucus", note = "Kill Makrura Spellhides and Makrura Clackers. Loot them for their Eyes - .mob +Pygmy Surf Crawler - .mob +Surf Crawler - .mob +Makrura Shellhide - .mob +Makrura Clacker", zone = "Durotar", x = 53.8, y = 83.14, quest = 818, path = { { zone = "Durotar", x = 59.64, y = 73.84 }, { zone = "Durotar", x = 59.64, y = 73.84 }, { zone = "Durotar", x = 58.11, y = 77.3 }, { zone = "Durotar", x = 57.27, y = 79.38 }, { zone = "Durotar", x = 55.66, y = 80.47 } }, objective = 1 },
        { type = "death", name = "Die and release", zone = "Durotar", x = 57.5, y = 73.26, optional = true },
        { type = "note", name = ".subzone 367 >>Travel to Sen'Jin Village", note = ".subzone 367 >>Travel to Sen'Jin Village" },
        { type = "travel", name = "Talk to Trayexir", note = "Jump into the hut - Vendor: Vendor trash and repair - .isOnQuest 808", zone = "Durotar", x = 56.48, y = 73.11, npc = "Trayexir" },
        { type = "spell", name = "Talk to Un'Thuwa", zone = "Durotar", x = 56.3, y = 75.1, npc = "Un'Thuwa", spellID = 118, class = "MAGE" },
        { type = "turnin", name = "Talk to Gadrin, Vornal and Vel'rin", zone = "Durotar", x = 55.95, y = 73.93, npc = "Master Gadrin", quest = 817, path = { { zone = "Durotar", x = 55.95, y = 74.73 }, { zone = "Durotar", x = 55.95, y = 74.39 } } },
        { type = "spell", note = ".emote KNEEL,208309 - .skipgossip 208307,1 - .aura 417316 >>Kneel before the Loa Altar and talk to the Serpent Loa to get the [Meditation on the Loa] buff", zone = "Durotar", x = 55.32, y = 72.66, spellID = 402852, class = "PRIEST" },
        { type = "item", name = "Use the [Prophecy of a Desecrated Citadel] to train [Homunculi]", note = ".aura 418459 >>Now you have to find an Undead Priest with a Loa buff. You have to kneel before him and he has to /pray for you. - .use 205947", spellID = 402852, itemID = 205947, count = 1, class = "PRIEST" },
        { type = "note", name = "Bind your [Faintly Glowing Skull] and [Really Sticky Glue]. Save them for emergency situations", note = "Bind your [Faintly Glowing Skull] and [Really Sticky Glue]. Save them for emergency situations" },
        { type = "spell", name = "Kill Razormane Quilboars and Razormane Scouts. Loot them for a Severed Quilboar Head", note = ".collect 206994,1 - .mob +Razormane Quilboar - .mob +Razormane Scout", zone = "Durotar", x = 49.22, y = 48.96, quest = 837, spellID = 403475, path = { { zone = "Durotar", x = 49.22, y = 48.96 }, { zone = "Durotar", x = 50.21, y = 50.78 }, { zone = "Durotar", x = 50.18, y = 49.23 }, { zone = "Durotar", x = 49.48, y = 49.14 }, { zone = "Durotar", x = 49.32, y = 48.18 }, { zone = "Durotar", x = 48.81, y = 49 }, { zone = "Durotar", x = 48.49, y = 49.29 }, { zone = "Durotar", x = 47.58, y = 49.62 }, { zone = "Durotar", x = 47.06, y = 49.53 }, { zone = "Durotar", x = 46.9, y = 48.11 } }, class = "WARRIOR", objective = 2 },
        { type = "complete", name = "Kill Razormane Quilboars and Razormane Scouts", note = ".mob +Razormane Quilboar - .mob +Razormane Scout", zone = "Durotar", x = 49.22, y = 48.96, quest = 837, path = { { zone = "Durotar", x = 49.22, y = 48.96 }, { zone = "Durotar", x = 50.21, y = 50.78 }, { zone = "Durotar", x = 50.18, y = 49.23 }, { zone = "Durotar", x = 49.48, y = 49.14 }, { zone = "Durotar", x = 49.32, y = 48.18 }, { zone = "Durotar", x = 48.81, y = 49 }, { zone = "Durotar", x = 48.49, y = 49.29 }, { zone = "Durotar", x = 47.58, y = 49.62 }, { zone = "Durotar", x = 47.06, y = 49.53 }, { zone = "Durotar", x = 46.9, y = 48.11 } }, objective = 2 },
        { type = "complete", name = "Kill Razormane Dustrunners and Razormane Battleguards", note = ".mob +Razormane Dustrunner - .mob +Razormane Battleguard", zone = "Durotar", x = 43.3, y = 40.4, quest = 837, path = { { zone = "Durotar", x = 44.45, y = 39.74 }, { zone = "Durotar", x = 44.45, y = 39.74 }, { zone = "Durotar", x = 44.49, y = 37.47 }, { zone = "Durotar", x = 43.3, y = 37.32 }, { zone = "Durotar", x = 41.7, y = 37.09 }, { zone = "Durotar", x = 41.64, y = 38.27 }, { zone = "Durotar", x = 41.94, y = 40.46 } }, objective = 4 },
        { type = "travel", name = ".xp 9+4470 >> Grind to 4470+/6500xp", note = ".xp 9+4470 >> Grind to 4470+/6500xp", zone = "Durotar", x = 47.17, y = 49.44, path = { { zone = "Durotar", x = 47.52, y = 48.67 }, { zone = "Durotar", x = 47.52, y = 48.67 }, { zone = "Durotar", x = 46.12, y = 45.47 }, { zone = "Durotar", x = 43.65, y = 43.91 }, { zone = "Durotar", x = 41.68, y = 44.69 }, { zone = "Durotar", x = 41, y = 46.13 }, { zone = "Durotar", x = 42.47, y = 48.5 }, { zone = "Durotar", x = 44.21, y = 49.68 } }, class = "HUNTER" },
        { type = "travel", name = ".xp 9+4400 >> Grind to 4400+/6500xp", note = ".xp 9+4400 >> Grind to 4400+/6500xp", zone = "Durotar", x = 47.43, y = 49.18, path = { { zone = "Durotar", x = 49.14, y = 48.89 }, { zone = "Durotar", x = 49.14, y = 48.89 } } },
        { type = "death", name = "Die and release" },
        { type = "travel", name = "Run to Razor Hill", zone = "Durotar", x = 51.95, y = 43.5 },
        { type = "accept", name = "Talk to Swart", note = ".isNotOnQuest 1522 - .xp <10,1", zone = "Durotar", x = 54.42, y = 42.59, npc = "Swart", quest = 2983, spellID = 8050, class = "SHAMAN" },
        { type = "turnin", name = "Talk to Torka and Gar'Thok", zone = "Durotar", x = 51.95, y = 43.5, npc = "Cook Torka", quest = 837, path = { { zone = "Durotar", x = 51.12, y = 42.46 } }, class = "HUNTER" },
        { type = "turnin", name = "Talk to Torka and Gar'Thok", zone = "Durotar", x = 51.95, y = 43.5, npc = "Cook Torka", quest = 825, path = { { zone = "Durotar", x = 51.12, y = 42.46 } } },
        { type = "accept", name = "Talk to Swart", note = ".isNotOnQuest 1522", zone = "Durotar", x = 54.42, y = 42.59, npc = "Swart", quest = 2983, spellID = 8050, class = "SHAMAN" },
        { type = "trainer", name = "Talk to Tarshaw", zone = "Durotar", x = 54.18, y = 42.46, npc = "Tarshaw Jaggedscar", quest = 1505, class = "WARRIOR" },
        { type = "spell", name = "Talk to Dhugru", zone = "Durotar", x = 54.37, y = 41.2, npc = "Dhugru Gorelust", spellID = 1120, class = "WARLOCK" },
        { type = "travel", name = "Talk to Kitha and buy [Firebolt Rank 2]", note = ".collect 16302,1,837,1 - .money <0.01", zone = "Durotar", x = 54.7, y = 41.49, npc = "Kitha", class = "WARLOCK", optional = true },
        { type = "spell", name = "Use the [Grimoire of Firebolt Rank 2]", note = ".use 16302", spellID = 20270, class = "WARLOCK" },
        { type = "trainer", name = "Talk to Tai'jin", zone = "Durotar", x = 54.26, y = 42.93, npc = "Tai'jin", quest = 5660, class = "PRIEST" },
        { type = "spell", name = "Talk to Kaplak", zone = "Durotar", x = 51.98, y = 43.69, npc = "Kaplak", spellID = 674, class = "ROGUE" },
        { type = "trainer", name = "Go inside the bunker", note = "Talk to Thotar inside", zone = "Durotar", x = 51.85, y = 43.49, npc = "Thotar", quest = 6062, class = "HUNTER" },
        { type = "travel", name = "Talk to Ghrawt. Buy [Sharp Arrows] and a [Medium Quiver] from him", note = ".collect 2515,1200,6082,1", zone = "Durotar", x = 52.97, y = 41.04, npc = "Ghrawt", class = "HUNTER" },
        { type = "travel", name = "Talk to Ghrawt. Buy [Sharp Arrows] from him", note = ".collect 2515,1200,6082,1", zone = "Durotar", x = 52.97, y = 41.04, npc = "Ghrawt", class = "HUNTER" },
        { type = "complete", note = ".use 15917 >> Use your [Taming Rod] on a Dire Mottled Boar at max range - .mob Dire Mottled Boar - .isOnQuest 6062", zone = "Durotar", x = 50.82, y = 53.65, quest = 6062, path = { { zone = "Durotar", x = 51.65, y = 56.51 }, { zone = "Durotar", x = 51.76, y = 48.41 }, { zone = "Durotar", x = 51.7, y = 50.23 }, { zone = "Durotar", x = 51.65, y = 51.34 }, { zone = "Durotar", x = 51.8, y = 53.18 } }, class = "HUNTER", objective = 1 },
        { type = "accept", name = "Go inside the bunker", note = "Talk to Thotar inside - .isQuestComplete 6062", zone = "Durotar", x = 51.85, y = 43.49, npc = "Thotar", quest = 6083, class = "HUNTER" },
        { type = "accept", name = "Go inside the bunker", note = "Talk to Thotar inside - .isQuestTurnedIn 6062", zone = "Durotar", x = 51.85, y = 43.49, npc = "Thotar", quest = 6083, class = "HUNTER" },
        { type = "note", name = "Dismiss your Dire Mottled Boar by right clicking its unit frame and clicking dismiss, otherwise you'll be unable to tame a Surf Crawler", note = "Dismiss your Dire Mottled Boar by right clicking its unit frame and clicking dismiss, otherwise you'll be unable to tame a Surf Crawler", class = "HUNTER", optional = true },
        { type = "complete", name = "Don't kill the Armored Scorpids you see. You'll need them later", note = ".use 15919 >> Use your [Taming Rod] on a Surf Crawler at max range - .mob Surf Crawler - .isQuestTurnedIn 6062", zone = "Durotar", x = 60.04, y = 24.79, quest = 6083, path = { { zone = "Durotar", x = 59.63, y = 23.38 }, { zone = "Durotar", x = 59.18, y = 28.35 }, { zone = "Durotar", x = 59.89, y = 26.42 } }, class = "HUNTER", objective = 1 },
        { type = "accept", name = "Go inside the bunker", note = "Talk to Thotar inside - .isQuestTurnedIn 6062", zone = "Durotar", x = 51.85, y = 43.49, npc = "Thotar", quest = 6082, class = "HUNTER" },
        { type = "note", name = "Dismiss your Surf Crawler by right clicking its unit frame and clicking dismiss, otherwise you'll be unable to tame an Armored Scorpid", note = "Dismiss your Surf Crawler by right clicking its unit frame and clicking dismiss, otherwise you'll be unable to tame an Armored Scorpid", class = "HUNTER", optional = true },
        { type = "complete", note = ".use 15920 >> Use your [Taming Rod] on an Armored Scorpid at max range - .mob Armored Scorpid - .isQuestTurnedIn 6062", zone = "Durotar", x = 57.15, y = 25.59, quest = 6082, path = { { zone = "Durotar", x = 54.84, y = 36.94 }, { zone = "Durotar", x = 54.84, y = 36.94 }, { zone = "Durotar", x = 54.01, y = 33.81 }, { zone = "Durotar", x = 54.22, y = 30.5 }, { zone = "Durotar", x = 55.71, y = 30.66 }, { zone = "Durotar", x = 56.19, y = 29.28 }, { zone = "Durotar", x = 56.95, y = 27.28 } }, class = "HUNTER", objective = 1 },
        { type = "accept", name = "Go inside the bunker", note = "Talk to Thotar inside - .isQuestTurnedIn 6062", zone = "Durotar", x = 51.85, y = 43.49, npc = "Thotar", quest = 6081, class = "HUNTER" },
        { type = "note", name = "Put [Tame Beast], [Dismiss Pet], and [Call Pet] onto your Action Bars", note = "Put [Tame Beast], [Dismiss Pet], and [Call Pet] onto your Action Bars", class = "HUNTER" },
        { type = "travel", name = "Talk to Grimtak", note = "Buy [Tough Jerky] from him. You will use this to feed your pet later - Vendor: Vendor Trash - .collect 117,5,828,1 - .isQuestTurnedIn 6062 - .isQuestAvailable 834", zone = "Durotar", x = 51.13, y = 42.63, npc = "Grimtak", class = "HUNTER" },
        { type = "accept", name = "Talk to Takrin", zone = "Durotar", x = 50.8, y = 43.6, npc = "Takrin Pathseeker", quest = 840 },
        { type = "travel", name = "Travel to Far Watch Post", note = ".zoneskip The Barrens", zone = "The Barrens", x = 62.26, y = 19.38 },
        { type = "accept", name = "Talk to Kargal", zone = "The Barrens", x = 62.27, y = 19.38, npc = "Kargal Battlescar", quest = 842 },
        { type = "accept", name = "Talk to Uzzek", zone = "The Barrens", x = 61.4, y = 21.1, npc = "Uzzek", quest = 1498, class = "WARRIOR" },
        { type = "accept", name = "Talk to Kranal", zone = "The Barrens", x = 55.86, y = 19.95, npc = "Kranal Fiss", quest = 1524, class = "SHAMAN" },
        { type = "travel", name = "Travel the path up the mountain toward Telf", note = "Be careful to not fall of the mountain, the path is very narrow. You could die if you fall", zone = "Durotar", x = 39.16, y = 58.56, path = { { zone = "Durotar", x = 36.74, y = 57.78 }, { zone = "Durotar", x = 36.63, y = 58.15 }, { zone = "Durotar", x = 36.63, y = 58.15 }, { zone = "Durotar", x = 36.77, y = 58.98 }, { zone = "Durotar", x = 36.85, y = 58.32 }, { zone = "Durotar", x = 37.24, y = 58.13 }, { zone = "Durotar", x = 37.86, y = 58.18 }, { zone = "Durotar", x = 38.05, y = 57.79 }, { zone = "Durotar", x = 38.93, y = 57.54 }, { zone = "Durotar", x = 39.19, y = 57.9 } }, class = "SHAMAN", optional = true },
        { type = "accept", name = "Talk to Telf", zone = "Durotar", x = 38.52, y = 58.93, npc = "Telf Joolam", quest = 1525, class = "SHAMAN" },
        { type = "accept", name = "Talk to Misha", zone = "Durotar", x = 43.11, y = 30.24, npc = "Misha Tor'kren", quest = 816 },
        { type = "complete", name = "Enter Thunder Ridge and kill Lightning Hides. Loot them for their Scales", note = ".mob Lightning Hide", zone = "Durotar", x = 43.19, y = 24.34, quest = 1498, path = { { zone = "Durotar", x = 43.19, y = 24.34 }, { zone = "Durotar", x = 39.16, y = 30.84 }, { zone = "Durotar", x = 39.23, y = 28.38 }, { zone = "Durotar", x = 39.43, y = 24.94 }, { zone = "Durotar", x = 41.39, y = 24.28 } }, class = "WARRIOR", objective = 1 },
        { type = "travel", name = "Jump into Thunder Ridge", zone = "Durotar", x = 41.66, y = 25.68, class = "SHAMAN", optional = true },
        { type = "complete", name = "Kill Fizzle Darkstorm and loot him for his Claw", note = "Be careful. Kill the patrolling Burning Blade Fanatic and the Lightning Hides in the back before you pull him - Pull him backwards towards the Lightning Hides you just killed. Otherwise you may bodypull additional Burning Blade mobs - Don't be afraid to die for the Claw as you will be respawning at the Spirit Healer after - Kill the imp first. Use [Gouge] when he casts [Soul Siphon] - Kill the imp first. Use [Earth Shock] when he casts [Soul Siphon] - You can cast [Polymorph] on Fizzle and kill the Imp first - Kill the imp first - Use a [Minor Healing Potion], [Minor Healthstone] if you have it and your [Faintly Glowing Skull] if needed - .mob Fizzle Darkstorm - .mob Imp Minion - .mob Burning Blade Fanatic - .mob Lightning Hide", zone = "Durotar", x = 42.13, y = 26.67, quest = 806, objective = 1 },
        { type = "complete", name = "Kill Fizzle Darkstorm and loot him for his Claw", note = "Be careful. Kill the patrolling Burning Blade Fanatic and the Lightning Hides in the back before you pull him - Pull him backwards towards the Lightning Hides you just killed. Otherwise you may bodypull additional Burning Blade mobs - Kill the imp first. Use [Gouge] when he casts [Soul Siphon] - Kill the imp first. Use [Earth Shock] when he casts [Soul Siphon] - You can cast [Polymorph] on Fizzle and kill the Imp first - Kill the imp first - Use a [Minor Healing Potion], [Minor Healthstone] if you have it and your [Faintly Glowing Skull] if needed - .mob Fizzle Darkstorm - .mob Imp Minion - .mob Burning Blade Fanatic - .mob Lightning Hide", zone = "Durotar", x = 42.13, y = 26.67, quest = 806, objective = 1 },
        { type = "death", name = "Die and release", note = ".isQuestComplete 806", zone = "Durotar", x = 47.04, y = 17.58 },
        { type = "travel", name = "Fight your way out of Thunder Ridge", note = ".isQuestComplete 806", zone = "Durotar", x = 39.2, y = 32.02 },
        { type = "travel", name = "Travel to Rezlak", zone = "Durotar", x = 46.37, y = 22.94, optional = true },
        { type = "accept", name = "Talk to Rezlak", zone = "Durotar", x = 46.37, y = 22.94, npc = "Rezlak", quest = 834 },
        { type = "spell", name = "Kill Dustwind Harpies. Loot them for a Severed Harpy Head", note = ".collect 206995,1 - .mob Dustwind Savage - .mob Dustwind Storm Witch - .mob Dustwind Pillager - .mob Dustwind Harpy", spellID = 403475, class = "WARRIOR", optional = true },
        { type = "complete", name = "Loot the Stolen Supply Sacks from the ground", zone = "Durotar", x = 47.19, y = 30.87, quest = 834, path = { { zone = "Durotar", x = 49.7, y = 21.9 }, { zone = "Durotar", x = 49.7, y = 21.9 }, { zone = "Durotar", x = 49.7, y = 24.33 }, { zone = "Durotar", x = 50.13, y = 25.7 }, { zone = "Durotar", x = 50.85, y = 25.96 }, { zone = "Durotar", x = 51.65, y = 27.67 }, { zone = "Durotar", x = 49.85, y = 27.07 }, { zone = "Durotar", x = 50.68, y = 31.55 }, { zone = "Durotar", x = 48.1, y = 34.36 }, { zone = "Durotar", x = 47.35, y = 33.4 }, { zone = "Durotar", x = 48.49, y = 32.01 } }, objective = 1 },
        { type = "spell", name = "Kill Dustwind Harpies. Loot them for a Severed Harpy Head", note = ".collect 206995,1 - .mob Dustwind Savage - .mob Dustwind Storm Witch - .mob Dustwind Pillager - .mob Dustwind Harpy", zone = "Durotar", x = 53.98, y = 23.7, spellID = 403475, path = { { zone = "Durotar", x = 53.98, y = 23.7 }, { zone = "Durotar", x = 54.02, y = 27.23 }, { zone = "Durotar", x = 52.82, y = 24.27 }, { zone = "Durotar", x = 51.85, y = 23.95 }, { zone = "Durotar", x = 54.01, y = 23.63 }, { zone = "Durotar", x = 52.13, y = 20.77 }, { zone = "Durotar", x = 51.26, y = 19.19 } }, class = "WARRIOR" },
        { type = "accept", name = "Talk to Rezlak", zone = "Durotar", x = 46.37, y = 22.94, npc = "Rezlak", quest = 835 },
        { type = "turnin", name = "Talk to Rezlak", zone = "Durotar", x = 46.37, y = 22.94, npc = "Rezlak", quest = 834 },
        { type = "travel", name = "Travel east around the hills to reach the cave. Follow the waypoint arrow", note = ".subzone 371 >>Travel toward Dustwind Cave", zone = "Durotar", x = 55.86, y = 28.31, path = { { zone = "Durotar", x = 49.42, y = 18.47 }, { zone = "Durotar", x = 51.35, y = 16.76 }, { zone = "Durotar", x = 54.65, y = 19.02 } }, class = "SHAMAN", optional = true },
        { type = "complete", name = "Kill Burning Blade Cultists. Loot them for a Reagent Pouch", note = ".mob Burning Blade Cultist", zone = "Durotar", x = 51.9, y = 25.7, quest = 1525, path = { { zone = "Durotar", x = 53.18, y = 29.15 }, { zone = "Durotar", x = 53.18, y = 29.15 }, { zone = "Durotar", x = 52.7, y = 27.97 }, { zone = "Durotar", x = 53.05, y = 27.87 }, { zone = "Durotar", x = 53.14, y = 27.24 }, { zone = "Durotar", x = 52.84, y = 26.8 }, { zone = "Durotar", x = 52.07, y = 26.85 } }, class = "SHAMAN", objective = 2 },
        { type = "travel", name = "Dismiss your [Imp] by right clicking its unit frame and clicking dismiss", note = ".cast 2641 Cast [Dismiss Pet] and then jump into Thunder Ridge", zone = "Durotar", x = 41.66, y = 25.68, path = { { zone = "Durotar", x = 44.72, y = 24.86 }, { zone = "Durotar", x = 42.28, y = 25.45 } }, optional = true },
        { type = "accept", name = "Talk to Rhinag", note = "This will start a 45 minute timer for the quest. Do NOT go AFK or log out for the next 5 minutes", zone = "Durotar", x = 41.54, y = 18.59, npc = "Rhinag", quest = 812 },
        { type = "travel", name = ".xp 9+2930 >>Grind to 2930+/6500 into level 9", note = ".xp 9+2930 >>Grind to 2930+/6500 into level 9", zone = "Durotar", x = 43.56, y = 15.08, path = { { zone = "Durotar", x = 43.56, y = 15.08 }, { zone = "Durotar", x = 44.16, y = 19.19 }, { zone = "Durotar", x = 44.13, y = 17.02 } } },
        { type = "travel", name = "Grind until your hearthstone cooldown is <5 minutes - .cooldown item,6948,<0", note = "Grind until your hearthstone cooldown is <5 minutes - .cooldown item,6948,<0", zone = "Durotar", x = 43.56, y = 15.08, path = { { zone = "Durotar", x = 43.56, y = 15.08 }, { zone = "Durotar", x = 44.16, y = 19.19 }, { zone = "Durotar", x = 44.13, y = 17.02 } } },
        { type = "travel", name = ".zone Orgrimmar >> Enter Orgrimmar - .zoneskip Orgrimmar", note = ".zone Orgrimmar >> Enter Orgrimmar - .zoneskip Orgrimmar", zone = "Orgrimmar", x = 48.97, y = 92.84, optional = true },
        { type = "turnin", name = "Talk to Nazgrel", zone = "Orgrimmar", x = 32.28, y = 35.8, npc = "Nazgrel", quest = 831 },
        { type = "accept", name = "Talk to Thrall", zone = "Orgrimmar", x = 31.74, y = 37.82, npc = "Thrall", quest = 5726 },
        { type = "travel", name = "Travel to the Valley of Honor", zone = "Orgrimmar", x = 68.02, y = 38.69, class = "HUNTER", optional = true },
        { type = "turnin", name = "Talk to Ormak", zone = "Orgrimmar", x = 66.05, y = 18.52, npc = "Ormak Grimshot", quest = 6081, class = "HUNTER" },
        { type = "spell", name = "Talk to Xao'tsu", zone = "Orgrimmar", x = 66.34, y = 14.83, npc = "Xao'tsu", spellID = 24547, class = "HUNTER" },
        { type = "note", name = "Remember to train your pet whenever they get Training Points for [Beast Training]", note = "Put [Beast Training](under the General tab), [Revive Pet], and [Feed Pet] onto your Action Bars", class = "HUNTER" },
        { type = "travel", name = "Talk to Zendo'jian. Buy a [Laminated Recurve Bow] from him", note = ".collect 2507,1,835,1 - .money <0.1751 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<5.7", zone = "Orgrimmar", x = 81.17, y = 18.69, npc = "Zendo'jian", class = "HUNTER" },
        { type = "item", note = "Equip the [Laminated Recurve Bow] when you are level 11 - .use 2507 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<5.7 - .xp <11,1", itemID = 2507, count = 1, class = "HUNTER" },
        { type = "item", note = "Equip the [Laminated Recurve Bow] - .use 2507 - .itemStat 18,QUALITY,<7 - .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<5.7 - .xp >11,1", itemID = 2507, count = 1, class = "HUNTER" },
        { type = "accept", name = "Talk to Kor'ghan in the Cleft of Shadow", note = ".isOnQuest 812", zone = "Orgrimmar", x = 47.24, y = 53.58, npc = "Kor'ghan", quest = 813 },
        { type = "note", name = "Abandon Need for a Cure. This will remove the timer on the quest but you will still be able to do it", note = ".abandon 812 >>Abandon Need for a Cure - .isOnQuest 812" },
        { type = "travel", name = "Talk to Zamja and Gru'ark", note = "Kill Gru'ark when he becomes hostile - .skipgossip", zone = "Orgrimmar", x = 58.05, y = 51.4, npc = "Zamja", path = { { zone = "Orgrimmar", x = 57.4, y = 53.93 } }, class = "WARRIOR", optional = true },
        { type = "spell", name = "Talk to Zamja", note = "Receive the [Rune of Frenzied Assault] from her - .collect 204716,1 - .skipgossip", zone = "Orgrimmar", x = 58.52, y = 52.73, npc = "Zamja", spellID = 425447, class = "WARRIOR" },
        { type = "item", name = "Use the [Rune of Frenzied Assault]", note = ".use 204716", spellID = 425447, itemID = 204716, count = 1, class = "WARRIOR" },
        { type = "hearth", name = "Hearth", note = ".isQuestComplete 806 - .use 6948 - .subzoneskip 362 - .bindlocation 362,1" },
        { type = "travel", name = "Talk to Innkeeper Grosk", note = "Vendor: Vendor Trash - Buy [Ice Cold Milk] from him - Buy [Haunch of Meat] from him - .collect 1179,15,818,1 - .collect 2287,15,818,1 - .money <0.0375", zone = "Durotar", x = 51.51, y = 41.64, npc = "Innkeeper Grosk" },
        { type = "spell", name = "Talk to Vahi", note = "Turn in the Heads you've collected in exchange for [Rune Fragments] - .collect 204688,1 - .collect 204689,1 - .collect 204690,1", zone = "Durotar", x = 53.14, y = 43.5, npc = "Vahi Bonesplitter", spellID = 403475, class = "WARRIOR" },
        { type = "spell", note = ".use 204688 >>Use the [Rune Fragments] to create [Rune of Devastate] - .collect 204703,1", spellID = 403475, class = "WARRIOR" },
        { type = "item", name = "Use the [Rune of Devastate]", note = ".use 204703", spellID = 403475, itemID = 204703, count = 1, class = "WARRIOR" },
        { type = "accept", name = "Talk to Orgnil", zone = "Durotar", x = 52.24, y = 43.15, npc = "Orgnil Soulscar", quest = 828, class = "HUNTER" },
        { type = "turnin", name = "Talk to Orgnil and Gar'Thok", zone = "Durotar", x = 51.95, y = 43.5, npc = "Orgnil Soulscar", quest = 837, path = { { zone = "Durotar", x = 52.24, y = 43.15 } } },
        { type = "accept", name = "Talk to Tarshaw", zone = "Durotar", x = 54.18, y = 42.46, npc = "Tarshaw Jaggedscar", quest = 1505, spellID = 6546, class = "WARRIOR" },
        { type = "spell", name = "Talk to Swart", zone = "Durotar", x = 54.42, y = 42.59, npc = "Swart", spellID = 8050, class = "SHAMAN" },
        { type = "spell", name = "Talk to Dhugru", zone = "Durotar", x = 54.37, y = 41.2, npc = "Dhugru Gorelust", spellID = 1120, class = "WARLOCK" },
        { type = "travel", name = "Talk to Kitha and buy [Firebolt Rank 2]", note = ".collect 16302,1,837,1 - .money <0.01", zone = "Durotar", x = 54.7, y = 41.49, npc = "Kitha", class = "WARLOCK", optional = true },
        { type = "spell", name = "Use the [Grimoire of Firebolt Rank 2]", note = ".use 16302", spellID = 20270, class = "WARLOCK" },
        { type = "spell", name = "Go inside the bunker", note = "Talk to Thotar inside", zone = "Durotar", x = 51.85, y = 43.49, npc = "Thotar", spellID = 13549, class = "HUNTER" },
        { type = "spell", name = "Talk to Kaplak", zone = "Durotar", x = 51.98, y = 43.69, npc = "Kaplak", spellID = 674, class = "ROGUE" },
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
