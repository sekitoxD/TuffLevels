# Plan 12: RXPGuides re-import and directive-driven step upgrades

## Background

Session work added two new auto-detected step types, `item` and `spell`
(Core.lua/Compat.lua, shipped v1.7.4), so guide instructions like "equip
this weapon" or "learn this rune" can auto-complete instead of always
falling back to a manual `note` click. The RXPGuides importer
(RXPImport.lua) was taught to parse `.itemcount`/`.train`/`.maxlevel` into
these (v1.7.4), and two real, previously-untestable parsing bugs were
found and fixed while building a headless test harness for it (v1.7.5):
a `|Ttexture:size|t` icon token was gluing a raw texture path onto step
names, and nested `|cCATEGORY_...|r` color tokens only half-stripped in
one pass (confirmed live in the shipped `Routes/Horde/Mulgore.lua` before
the fix).

**New capability this plan depends on**: a real Lua 5.1 interpreter
(`rjpcomputing.luaforwindows` via `winget`, matches WoW's Lua version
exactly) is now installed and can load `RXPImport.lua`/`Core.lua`/etc.
headlessly the same way `spec/*.lua` already assumes, via
`spec/helpers/wow_stubs.lua`. This makes it possible to run the actual
importer against real RXPGuides guide text and inspect its output
directly, instead of reasoning about the parser by eye or waiting for an
in-game test. A raw guide source library exists locally at
`E:\World of Warcraft\_anniversary_\Interface\AddOns\RXPGuides\Guides\`
(the user's Anniversary-realm RXPGuides install) - `Classic-*.lua` files
are the Classic-flavored ones this addon's importer targets (see
RXPImport.lua's header for why the non-`Classic-` `RestedXP *.lua` files
are TBC/WotLK-flavored and out of scope).

## Critical finding: two different, unrelated provenances

Not every Horde route can benefit from a "re-run through the fixed
importer" approach the same way:

| Route | File(s) | Built from | Directive residue in existing text? |
|---|---|---|---|
| Tauren 1-60 | `Routes/Horde/Mulgore.lua` | RXPGuides text, via RXPImport.lua (`sample = true`, "mechanically converted, not hand-verified") | Yes - confirmed `.itemcount`/`.train`/`.maxlevel`/`.collect`/`.isOnQuest`/`.zoneskip`/`.skill` all present verbatim in already-shipped note text (hundreds of occurrences) |
| Orc/Troll ONSLAUGHT | `Routes/Horde/Solo/*.lua` | A source **spreadsheet**, via SheetImport.lua (see each file's header, `plans/04-sheet-audit.md`) | **Zero** - confirmed via grep across the whole `Solo/` tree |
| Undead start | `Routes/Horde/TirisfalStart.lua` | Same source spreadsheet ("Tirisfal Starting" tab) | **Zero** - same as above |

This means:
- **Mulgore.lua** is the one route where "re-parse the real RXPGuides
  source and pull the improvements forward" is a direct, sensible
  operation - the content already came from that exact pipeline.
- **The Orc/Troll and Undead routes have no RXPGuides-derived text to
  upgrade in place.** The only way the new `item`/`spell` step types
  could reach them is a **wholesale re-derivation from a different
  source** than the one that built them today - not an upgrade, a
  replacement of the pipeline's output. That is a much bigger and
  riskier decision than it first sounded (see Phase 2 below) and
  deserves an explicit go/no-go separate from Phase 1.

## Also confirmed this session: re-parsing must be a MERGE, not a replace

`Mulgore.lua`'s git history shows a real hand-fix already layered on top
of the mechanical conversion (commit `1446770`, plan 07 A1): ~34 steps
that RXPGuides' own source labels with a continent-level zone
("Kalimdor"/"Eastern Kingdoms" - not resolvable to a uiMapID) were
re-researched against Wowhead/Warcraft Tavern and corrected by hand. A
fresh mechanical re-parse of the raw source would **reproduce that exact
same bug**, since the ambiguity exists in RXPGuides' own text, not in our
parser. Any re-import must diff against the current file and preserve
this class of fix, not blindly overwrite it.

## Tooling already built (scratch, not yet in-repo)

A working pipeline exists in this session's scratchpad:
1. `rxp_harness.lua` - loads the real `RXPImport.lua` headlessly, splits
   a raw guide file on its (possibly many) `RegisterGuide([[ ]])` blocks
   (`Classic-Horde-30-60.lua` alone has 36), and dumps each chapter's
   parsed `route.steps` as inspectable Lua.
2. `mini_busted.lua` - a minimal `describe`/`it`/`assert` shim (the
   bundled LuaRocks install couldn't get `busted` itself working -
   `LUAROCKS_PREFIX` config issue, not chased further) that successfully
   ran the ENTIRE existing `spec/*.lua` suite for the first time ever
   (92 assertions, 0 failures) plus the new `spec/rxpimport_spec.lua`.

Recommendation: promote a cleaned-up version of these two scripts into
the repo (e.g. `tools/spec_runner.lua`, though note `tools/` is the other
contributor's scope per CLAUDE.md - more likely a `spec/run.lua` or
similar addon-side location) so this "run the real test suite headlessly"
capability isn't lost/re-derived next session. Small (~30 min), zero
runtime impact (dev-only tooling, never loaded in-game).

## Phase 1: Mulgore.lua full re-parse + merge

**Impact**: touches only `Routes/Horde/Mulgore.lua` (one file, already
flagged `sample = true`/unverified, lowest-stakes route to iterate on).
No engine changes needed - Core.lua/RXPImport.lua already support
everything Phase 1 would produce. Must explicitly preserve: the ~34
hand-fixed zone corrections (commit `1446770`), and the "Skip: .../ Skip
for now: ..." `optional = true` tagging already applied this session
(commit `b025886`) if a straight regenerate-and-diff approach is used
rather than a true line-level merge.

**Performance**: none - same runtime step-checking cost either way,
this only changes which steps use `item`/`spell`/`skipIfLevel` vs. an
inert `note`.

**Dev time**: this is the big number. The source spans two files
(`Classic-Horde-1-12_Mulgore.lua`, 4 chapters, ~6k lines - piloted this
session; `Classic-Horde-30-60.lua`, 36 chapters, ~39k lines, shared with
the general Horde 22-60 path) and the existing route is 5281 lines with
branching `#next` chains (e.g. one chapter branches to two alternate
next chapters). Realistic estimate: **6-10 hours** of careful
chapter-by-chapter parse -> diff -> merge -> `/tuff verify` work, best
split across several `implementer` subagent runs (one or a few chapters
per run, per CLAUDE.md's ~100k-token soft budget per agent) with a
`code-reviewer` pass before each commit, checkpointed between chapters
given the size (see the `checkpoint` skill / this file's own status
section once work starts).

**Suggested approach per chapter**: parse with `rxp_harness.lua` -> diff
new step list against the corresponding existing section by quest
ID/coords (not raw text, since wording/formatting differs) -> carry
forward the new `item`/`spell`/`skipIfLevel` fields onto matching
existing steps -> re-apply any hand-fix from `1446770` that a fresh parse
would otherwise regress -> `/tuff verify` -> commit per chapter or small
chapter group, not the whole file at once.

## Phase 2: Undead route

**Finding**: no direct upgrade path exists (see provenance table above -
zero RXPGuides residue, sheet-derived). The only way to bring `item`/
`spell` auto-detection to `TirisfalStart.lua` is the same kind of
wholesale re-derivation as Phase 3 below, not a smaller upgrade. Given
its small size (900 lines, levels 1-14 only), if Phase 3 is approved,
this could reasonably be folded into it as a small first slice rather
than run separately. **Recommendation: hold until Phase 3's go/no-go is
decided** rather than treating it as its own independent phase.

## Phase 3: Orc/Troll ONSLAUGHT route replacement

**This is a materially different and larger decision than Phase 1**, not
a bigger version of the same task:

**Impact**: would replace content in `Routes/Horde/Solo/*.lua` (the
addon's flagship, most-played, most-audited route family - Undead
race-gating fixes, coordinate corrections, and other hand-verification
work is tracked across multiple recent commits and `plans/04-sheet-audit.md`).
A wholesale re-derivation from RXPGuides source risks silently regressing
all of that unless every one of those corrections is individually
cross-checked against the new output first - `plans/04-sheet-audit.md`
would need to be read in full and reconciled entry-by-entry, not just
spot-checked.

**Performance**: none (data-only change either way).

**Dev time**: substantially larger than Phase 1. The Orc/Troll path spans
the *same* `Classic-Horde-30-60.lua` 36-chapter file (Barrens onward is
shared Horde content, race-agnostic) plus the Orc/Troll-specific
`Classic-Horde-01-12_Durotar.lua` (10399 lines). Realistic estimate:
**15-25+ hours**, given the extra reconciliation-against-tracked-fixes
work Phase 1 doesn't have. Strongly recommend NOT starting this until
Phase 1 has proven the parse -> diff -> merge workflow end-to-end on the
lower-stakes Mulgore route, and until `plans/04-sheet-audit.md` has been
re-read specifically to enumerate every tracked correction that a
replacement would need to preserve.

**Alternative worth considering instead of a full replacement**: keep
the Orc/Troll route on its current sheet-derived pipeline (it works, and
carries real hand-verification history) and only forward-port the
*narrow* content gaps a diff against RXPGuides reveals (missing quests,
better coordinates) rather than swapping its entire provenance. This
would need its own smaller audit once Phase 1's tooling/workflow exists
to actually run that diff.

## Phase 3 (revised, 2026-09-25): parallel test route instead of in-place replacement

Decided against the in-place replacement framing Phase 3 above describes.
Reconciling every tracked correction in `plans/04-sheet-audit.md` against a
fresh RXPGuides parse *before* anything is testable is backwards - it means
15-25+ hours of reconciliation risk before a single step of the new content
has been played. Instead: build the RXPGuides-derived Orc/Troll route as a
**second, separately-registered route**, side by side with ONSLAUGHT, so it
can be manually played on a dedicated test character through the existing
route picker (`Panel:ShowRoutePicker`, `/tuff route <name>`) while
`Routes/Horde/Solo/*.lua` is not touched at all. Only after it's been played
and compared does a promote/merge/discard decision get made - the same
"prove the workflow on the lower-stakes route first" caution Phase 1 already
applies to Mulgore, just carried one step further: prove the *output* in
real play before deciding it should replace anything.

**Impact**: new files only - a new `Routes/Horde/OrcTrollRXP.lua` (single
file, same shape as `Mulgore.lua` rather than the `Solo/` leg-split
convention, since there's no existing multi-file structure to match yet),
registered under a distinct name (e.g. `"RXPGuides Orc/Troll 1-60 (TEST,
parse in progress)"`) and flagged `sample = true` so `Core:AutoSelectRoute`
ranks it below ONSLAUGHT for any character that hasn't explicitly picked it
- the same demotion mechanism Mulgore already relies on, no engine change
needed. Added to the load list in all three `.toc` files, after
`Mulgore.lua`. Zero lines of `Routes/Horde/Solo/*.lua` or
`TirisfalStart.lua` change.

**Performance**: none - one more registered route is the same cost model
as every other route file already loaded (a table in `Core.routes`, only
walked by `Reconcile`/`AutoSelectRoute` when active or during auto-select
ranking).

**Dev time**: building the full Orc/Troll leveling span this way is the
same underlying parse volume as the original Phase 3 estimate (**15-25+
hours**, same two source files: `Classic-Horde-01-12_Durotar.lua` and the
shared `Classic-Horde-30-60.lua`) - this doesn't shrink the total work, it
only removes the up-front reconciliation-before-testable-output blocker and
lets it ship incrementally, chapter by chapter, exactly like Phase 1's
Mulgore workflow (parse -> build steps -> `/tuff verify` -> commit per
chapter/small group), each increment independently testable on the dedicated
character without any risk to ONSLAUGHT. First slice (chapter 1, "1-6
Durotar") is a small, boundable first commit; the remaining chapters follow
the same per-chapter cadence as Phase 1.

**Once manually played through**: the forward-port-gaps-only alternative
Phase 3 above already floats becomes decidable with real evidence in hand -
diff the new route's content against ONSLAUGHT's tracked corrections
(`plans/04-sheet-audit.md`) to see whether the right outcome is "promote
this route to replace ONSLAUGHT," "forward-port specific gaps into
ONSLAUGHT and delete the test route," or "keep both indefinitely." That
decision is explicitly deferred, not made by this section.

### Progress checkpoint (update this as chapters land)

- [x] 2026-09-25: `spec/rxp_harness.lua` promoted from scratch into the
      repo (headless real-Lua parse-and-dump tool, per the "Tooling already
      built" section above).
- [x] 2026-09-25: `Routes/Horde/OrcTrollRXP.lua` created and registered,
      chapter 1 ("1-6 Durotar" from `Classic-Horde-01-12_Durotar.lua`)
      parsed and committed. Wired into all three `.toc` files.
- [x] 2026-09-26: First in-game playtest pass of chapter 1 (fresh Orc/Troll
      test character). Found and fixed four issues, three of them NOT
      specific to this route:
      - `Data.lua`'s `GetQuestName` called `QuestieDB.GetQuest` with a
        colon (`h:GetQuest(id)`), but the real function is a plain
        function (`QuestieDB.GetQuest(id)` everywhere in Questie's own
        source) - the colon call silently passed the wrong argument, so
        `/tuff verify` reported ~100% of quest IDs as "not found" **on
        every route**, not just this one. Fixed, with a regression spec
        (`spec/data_spec.lua`) that fakes a plain-function `GetQuest` so
        this can't silently regress back to a colon call.
      - `UI.lua`'s section header prepended the level range a second time
        when a section's own `name` already started with it (e.g. "1-6
        1-6 Durotar") - affects any route using the "N-M ZoneName"
        section-naming convention, confirmed also present (unnoticed
        until now) in all 35 of Mulgore.lua's section headers. Fixed.
      - `UI.lua` printed a step's `note` field a second time under its own
        "NOTE:" line even when it was identical to the step's `name`
        (RXPImport.lua's `s.name = s.note` fallback for steps with no
        distinct headline text does this) - fixed by skipping the second
        line when `note == name`.
      - `Routes/Horde/OrcTrollRXP.lua` itself had five exact-duplicate
        accept/turnin/complete steps (same quest+NPC) that read as
        already-done as soon as the first copy was handled, which is what
        looked like "auto turning in quests" at multi-turn-in NPCs.
        Deduped; see the file's header for the list.
- [x] 2026-09-26: Second in-game playtest pass (played to level 5, stopped
      early - enough issues to report before continuing). Found and fixed
      three more issues:
      - Two steps were missing a `class` filter that a sibling step for
        the same quest/item correctly had: quest 794's "complete" step
        (its own "accept" step was Warlock-only, but the complete step
        wasn't, so other classes got routed to a quest they could never
        have accepted - showed up as a party quest-share "prerequisite"
        failure) and the third "Buy Rough Arrows" tier at Duokna (its two
        lower tiers were correctly Hunter-only, this one wasn't - a Mage
        got told to buy Hunter ammo). Audited the rest of the chapter for
        the same quest-ID/item-purchase class-inconsistency pattern by
        script; no further instances found.
      - RXPImport.lua now converts a bare `.xp N` directive (no +/-/.
        modifier) into a real auto-detecting `xp` step instead of a dead
        `note` step - previously it always needed a manual Next click
        even when the player was already well past the target level,
        which is what "telling me to grind when I'm already on the xp"
        was. A modified form (`.xp N+M`, `.xp <N,1`) still can't convert
        safely without hardcoding Classic's per-level XP table, so those
        still fall through to a note as before.
      - Confirmed NOT a bug: the reported "quest tracker doesn't get
        following quest" was the player having picked up a real Durotar
        quest ("Wayward Weapons") that this chapter's parse never
        captured at all - the route correctly only tracks what's actually
        in it (per this addon's step-engine design, not a route
        generator), so a quest missing from the source guide's path (or
        dropped during parsing) just won't appear. A genuine content gap,
        not a code defect - no fix applied, noted for chapter review.
- [x] 2026-09-27: Independent code-review audit of the two playtest-fix
      commits (`code-reviewer` agent), requested before any further pushes.
      Found two real issues that hadn't shipped to a wider audience yet and
      one minor doc-accuracy issue; all three fixed same day, no gameplay
      content changed:
      - `UI.lua`'s `StepLabel` preferred a live QuestieDB quest title over
        a step's own `name`/`questName` whenever a provider was available -
        dead code until this round's `Data.lua` fix made `GetQuestName`
        actually return results for the first time, at which point it
        would have started replacing RXPGuides-derived steps' own
        instructions ("Kill Yarrog Baneshadow...") with generic quest
        titles on every client with Questie installed. Flipped to DB-title-
        as-fallback-only, matching CLAUDE.md's "QuestieDB enriches, route
        data is authoritative" design rule.
      - The new bare `.xp N` → `xp`-step conversion in `RXPImport.lua`
        unconditionally set `step.type`, so a real guide shape (an
        `.accept`/`.turnin`/`.complete` directive followed by its own
        trailing `.xp N` grind hint) would have silently lost its actual
        quest action the next time a chapter is parsed. Guarded with
        `and not step.type`; regression spec added.
      - This file's own header overstated the Nartok/77586 turnin dedup as
        "exact-duplicate" like the other four - it was actually two real
        money-threshold variants of the same turn-in. Corrected; no
        functional change (`spellID` is inert on a `turnin` step).
- [x] 2026-09-26: Chapter 2 ("6-10 Durotar") parsed via
      `spec/rxp_harness.lua` (confirmed chapter index 2 by listing all 6
      RegisterGuide blocks in the source file first, not assumed) and
      appended to `Routes/Horde/OrcTrollRXP.lua` (245 steps + 1 new section
      header; route's `levels` extended to `{ 1, 10 }`). Audited against the
      same bug shapes chapter 1's playtests found, before any in-game test
      of chapter 2 itself:
      - Duplicate steps: found and fixed 12 exact-duplicate lines across 6
        groups (quest 818/837/815/2983/5660 accept/complete/trainer step
        dupes, plus one whole duplicated "Fizzle Darkstorm -> die -> fight
        out" quest-806 block covering complete/death/travel together) - same
        OR-condition-branch root cause chapter 1's dupes had. Left the
        scattered vendor/spell/item-equip exact duplicates alone, matching
        chapter 1's own precedent (idempotent, non-blocking, not the bug
        shape this check targets).
      - Class-filter consistency: audited every accept/complete/turnin/
        trainer step's `class` against its same-quest siblings, and every
        tiered vendor-purchase chain for consistent `class`/`races` across
        tiers - found none of chapter 1's two bug shapes recurring. Flagged
        one unresolved oddity instead of guessing at a fix: quest 837 has
        two differently-classed turn-in steps at two different NPCs, which
        doesn't cleanly match this bug's "accept vs. complete/turnin"
        shape - could be the 77000s-style duplicate-ID mixup chapter 1
        already flagged, needs an in-game check.
      - Bare `.xp N` directives: none exist in chapter 2's source (only
        modified forms like `.xp 7+2070`/`.xp <10,1`, which correctly stay
        unconverted) - confirmed from the harness dump, not assumed.
      - No in-game testing done yet for chapter 2 - same as chapter 1's own
        first-parse state before its two playtest rounds.
- [x] 2026-09-27: Independent code-review audit of chapter 2 (`code-reviewer`
      agent), requested before any further pushes, same as chapter 1's round.
      Re-verified every claim above directly against the diff (re-ran the
      harness itself, re-audited class filters by hand) rather than trusting
      the report - all confirmed accurate. Found one real bug and resolved
      the quest-837 question the previous entry left open, plus surfaced a
      larger pre-existing parser gap:
      - Fixed: "Talk to Innkeeper Grosk" (quest 2161) had been parsed as a
        Warrior-only `spell` step because a trailing `.train 284,1 <<
        Warrior` directive on the same source line overwrote its own
        `.turnin 2161` - non-Warriors could never complete it. Reverted to a
        plain `turnin` step (Warrior spell training for 284 is still covered
        by the very next step, "Talk to Tarshaw").
      - Resolved (not a bug): quest 837's two differently-classed turn-in
        steps are both doing real work - one is a genuine Hunter-only early
        turn-in (`<< Hunter #xprate <1.5` in the source), the other an
        unfiltered fallback for everyone else that also happens to stand in
        for a `<< !Hunter` branch the parser drops entirely. Left as-is;
        changing either filter would strand a class without a turn-in.
      - New, larger finding not specific to chapter 2: RXPImport.lua keeps
        only the LAST quest ID when a source step names several quests at
        once (`step.quest` gets overwritten per directive instead of
        collecting all of them) - affects 29 of chapter 2's 63 distinct
        accept/turnin IDs (fewer in chapter 1, same root cause). Not fixed
        in this pass - it needs a RXPImport.lua parser change (multi-quest
        steps, or splitting at parse time), which is bigger than a
        single-chapter fix. Tracked as its own item below, to be resolved
        before parsing further chapters rather than repeating this gap at
        larger scale each time.
      - Also disclosed in the file's own KNOWN OPEN ISSUES rather than
        fixed: ~20 Season of Discovery rune-training steps survive
        unfiltered (can't complete on Era/Forever/Classic), both branches of
        `#xprate`/`#hardcore`/`#softcore` splits survive (duplicate
        non-optional "Die and release" steps), `<< !Hunter` steps are
        dropped instead of kept for their intended classes, two Warlock pet
        -spell steps may never auto-complete, a couple of `travel`-typed
        grind markers complete on arrival rather than after the actual
        grind, and a handful of near-duplicate (not byte-identical) steps
        from OR-condition branches remain unmerged (harmless - self-skips).
      - Confirmed which RXPGuides source copy was used
        (`_anniversary_` realm install) and noted in the file header that
        the `_classic_era_` copy of the same guide differs by 10 lines in
        this chapter, for reproducibility.
- [ ] **Before parsing chapter 3 or later**: fix RXPImport.lua's
      multi-quest-per-step data loss (see above) - it will only get worse at
      the shared `Classic-Horde-30-60.lua` file's scale. Also worth deciding
      then whether to teach the parser `#season`/`#xprate`/`#hardcore`-
      `#softcore`/`<< !X` tokens properly, rather than disclosing each as a
      per-chapter open issue indefinitely.
- [ ] Chapter 3 ("10-12 Durotar" / the "10-12 Tirisfal" branch it leads
      into for Undead - out of scope for this Orc/Troll route, skip it),
      then the shared `Classic-Horde-30-60.lua` 36 chapters (Barrens
      onward).
- [ ] In-game playtest pass of chapter 2 (none done yet).
- [ ] Continue the chapter-1 playtest past level 5 - two playtest rounds in
      a row have each found a handful of real issues, so a third full pass
      before declaring chapter 1 done is worth it. Recommend a class-
      filter consistency audit (like the two scripted checks used this
      round) as a standard step before/after each future chapter parse,
      not just a reactive one-off.
- [ ] Promote/forward-port/keep-both decision, once enough of the route is
      playable to compare meaningfully against ONSLAUGHT.

## Recommended sequencing

1. Land Phase 1 on Mulgore.lua first, chapter by chapter, checkpointing
   between chapters given the size.
2. Re-evaluate Phase 2 (fold into Phase 3, small slice) once Phase 1's
   workflow is proven.
3. Before starting Phase 3, re-read `plans/04-sheet-audit.md` in full and
   produce a written list of every tracked correction it documents, so
   the replace-vs-forward-port-gaps-only decision can be made with that
   list in hand rather than from memory.

## 2026-09-26 continuation: parser bug fixes landed, source layout re-confirmed against a newer RXPGuides copy

User request this session: audit and finish the four `sample = true` routes
(`Routes/Alliance/Human.lua`, `Routes/Alliance/DwarfGnome.lua`,
`Routes/Alliance/NightElf.lua`, `Routes/Horde/Mulgore.lua`) into shipped,
non-sample routes, extend Undead (`Routes/Horde/TirisfalStart.lua`, currently
1-14 only) to 1-60, and continue researching the RXPGuides folder for
anything else worth adding — all using RXPGuides itself as the trusted
source (no in-game verification required for route *content*; manual
testing reserved for actual bugs). Source this time is a different, newer
local copy than the one Phase 1's original session used:
`C:\Users\lilja\Downloads\RestedXP Guides v4.11.5\RXPGuides\` (vs. the
`_anniversary_` realm install referenced above) - **file layout differs
between the two copies**, recorded here so a future session doesn't have to
re-derive it:

- `Guides\Classic-Horde-01-14_Undead.lua` (9870 lines) is the direct
  equivalent of the old `Classic-Horde-01-14_Undead.lua` reference above and
  covers 1-14 (chapters: 1-6/6-11 Tirisfal, 12-14 Silverpine) - not needed
  for content (TirisfalStart.lua's own 1-14 is spreadsheet-sourced and
  already hand-verified) but useful as a cross-check.
- The old monolithic `Classic-Horde-30-60.lua` (36 chapters) **does not
  exist by that name in v4.11.5**. Its content is folded into
  `Guides\Era.lua`, a 157-`RegisterGuide` mega-file mixing every class/zone
  chapter RXPGuides ships (ADV AoE Mage routes, Season of Discovery
  alternate chapters, etc.) grouped by `#group RestedXP <Faction> <range>`
  tags. Confirmed present: `RestedXP Horde 22-30`, `30-40`, `40-50`, `50-60`
  and `RestedXP Alliance 20-30`, `30-40`, `40-50`, `50-60` - i.e. the full
  22-60 (Horde) / 20-60 (Alliance) shared continuation both Mulgore.lua and
  the three Alliance routes need exists, just in one huge file instead of
  one-file-per-range. Many chapters have an SoD-flavored sibling (e.g. `22-24
  Wetlands SoD` next to `22-24 Wetlands`) - same "a human picks the right
  chapter" step the harness workflow already requires, unrelated to this
  session's `<< SOD` step-level fix below (that fixes steps *inside* an
  otherwise-normal chapter, not chapter selection itself).
- Bridging 14-22 for Horde: `Guides\Classic-Horde-12-22_Barrens.lua` (13364
  lines, `Classic-`-prefixed, preferred per `RXPImport.lua`'s own header
  over the shorter non-`Classic-` `RestedXP Horde 13-23 Barrens.lua`
  alternate that also exists in this copy).
- Alliance sources for the sample routes' 1-1x starting zones are unchanged
  in shape: `Classic-Alliance-1-13_Human.lua` (6362 lines),
  `Classic-Alliance-1-14_DwarfGnome.lua` (8927 lines),
  `Classic-Alliance-1-10_NightElf.lua` (2007 lines, smallest - Night Elf
  should be the cheapest of the three to re-verify/finish). `Classic-
  Alliance-11-20.lua` (11427 lines) bridges into the shared 20-60 content in
  `Era.lua` the same way Barrens does for Horde.

### RXPImport.lua parser bug fixes (landed this session, all covered by
### automated specs - no in-game testing needed per this session's
### relaxed verification bar)

Fixed four of the "known open issues" flagged in §5b's chapter-2 code
review entry above, all of which affect every RXP-derived route (past and
future), not just OrcTrollRXP:

1. **Multi-quest-per-step data loss.** A step naming more than one distinct
   quest/item/spell via consecutive `.accept`/`.turnin`/`.complete`/
   `.itemcount`/`.train` directives used to overwrite the same step's
   fields each time, keeping only the last one. Now splits into a new step
   that carries the shared `class`/`races`/`classExclude`/`zone`/`x`/`y`/
   `npc` context forward (`StepForAction` helper in `RXPImport.lua`).
2. **`<< !ClassName` dropped instead of gating.** Added a `classExclude`
   step field (checked in `Core.lua`'s `StepApplies`, mirroring the
   existing `class` check) so "everyone except Hunter"-style steps survive
   for their intended classes instead of being discarded as if they were
   RXPGuides UI-navigation chrome. Other negated tokens (e.g. `!Human`) are
   left dropped as before - no confirmed bug there, not touched.
3. **`<< SOD` steps used to survive unconditionally** (treated as an
   "explicit in-scope marker" alongside `<< CLASSIC`) - this is why
   `Mulgore.lua` shipped ~20 unreachable Season-of-Discovery rune-training
   steps. Now `SOD`/`HARDCORE` mark the step out-of-scope (dropped);
   `SOFTCORE` is kept (explicit no-op, matching `CLASSIC`'s treatment).
4. **Exact-duplicate steps** (from OR-condition branches the parser can't
   fully model) now get collapsed automatically by a post-parse dedup pass
   keyed on `type|quest|itemID|spellID|class|classExclude|name|zone|x|y` -
   previously this needed a manual per-chapter pass (see §5/§5b above).

Also promoted `spec/run.lua`, a minimal busted-compatible shim + runner
(`describe`/`it`/`before_each`/`after_each`/`assert.equals`/`same`/
`is_true`/`is_false`/`is_nil`) so the whole `spec/*_spec.lua` suite can run
headlessly via `"/c/Program Files (x86)/Lua/5.1/lua.exe" spec/run.lua`
without a working `busted`/LuaRocks install (recommended but left as scratch
tooling in the original Phase 1 session - see "Tooling already built"
above). All 105 assertions pass, including new regression specs for the
four fixes above.

**Not attempted, left as documented limitations** (per this plan's own
precedent of disclosing rather than guessing): OR-group conditions
(`Cond1/Cond2`) still can't be expressed and stay unfiltered+flagged;
`.collect`/`.skill`/`.zone`/`.zoneskip`/`.isQuestComplete`/etc. still fall
through to a generic note; a `travel`-typed step that's really "grind here
until level X" still completes on arrival rather than after the grind
(RXPGuides has no explicit kill-count directive to detect this from -
authoring a heuristic risks false positives, not attempted).

### Audit (impact / performance / dev time, per the standing rule)

- **Impact:** `RXPImport.lua` (parser) and `Core.lua` (`StepApplies`, one
  new optional field check) - both are additive; no existing route's
  behavior changes since no shipped step currently sets `classExclude` and
  the dedup/split/SOD-drop logic only changes output for *future*
  re-parses, not any already-shipped `Routes/*.lua` file (those are static
  data, unaffected by an importer-code change). `spec/run.lua` is new,
  dev-only tooling with zero in-game footprint.
- **Performance:** none at runtime - `RXPImport.lua` only runs when a
  developer pastes guide text through its UI or the offline harness; it is
  never invoked during normal addon operation. `Core.lua`'s new
  `classExclude` check is one extra conditional `UnitClass` call per step,
  only for steps that set the field (none yet) - same cost model as the
  existing `class` check it sits beside.
- **Dev time:** ~2 hours (parser changes + Core.lua change + regression
  specs + promoting spec/run.lua + verifying all 105 assertions pass).

### Five rounds of independent code review found real bugs in the above - this is the corrected, final state

The "Impact"/"Dev time" audit above was written after the FIRST pass at these
fixes, before independent review. Per this session's own "always audit
plans" AND "always review before commits" standing rules, every fix below
went through a `code-reviewer` agent pass BEFORE being trusted, and each of
the first four passes found real, sometimes severe bugs - re-running
`spec/rxp_harness.lua` against the real RXPGuides source
(`Classic-Horde-01-12_Durotar.lua`, `Classic-Alliance-1-10_NightElf.lua`,
both from the `_anniversary_` realm install) is what caught every one of
these; the synthetic specs alone missed all of them on their own first
pass. This is the tracked history so a future session doesn't have to
re-derive why the code looks the way it does:

- **Round 1** found: the SOD/HARDCORE fix targeted the wrong syntax
  entirely (real guides use a standalone `#season N`/`#hardcore` line, not
  a `<< SOD` token); line-level class conditions were never actually
  applied to a split step (the "Innkeeper Grosk" bug - 5 `.train X <<
  Class` lines all losing their filter); the dedup pass was chapter-wide
  with a key missing `races`/`optional`/`objective`/`count`/`skipIfLevel`/
  `path`/`note`, causing real false-positive merges (an Orc-only and a
  Troll-only copy of the same step collapsing into one, losing the Troll
  copy); `classExclude` held only one class, silently dropping all but the
  last from a real `!Warrior !Rogue` condition; a stray `nul` file (Windows
  redirect artifact) was about to get committed.
- **Round 2** (after round 1's fixes) found a worse regression: RXPGuides'
  common same-quest reward-choice pair (`.turnin 788,2 << Shaman` /
  `.turnin 788 << !Shaman`) was landing BOTH conditions on one step
  (`class="SHAMAN", classExclude={"SHAMAN"}`), which `Core.lua`'s
  `StepApplies` rejects for every class - silently losing the Cutting
  Teeth/Sting of the Scorpid/Sarkoth turn-ins for everyone. Also: line-level
  RACE filters were dropped entirely; `npc` carried across a split and
  blocked a later `.target` from ever overwriting it (three different
  quest-givers all showing as "Master Gadrin"); `#season N << Cond` dropped
  the step for every class in the block instead of just the conditioned
  one; `.trainer`/`.hs`/`.deathskip` after a real action silently replaced
  it instead of getting their own step.
- **Round 3** (after a substantial redesign separating block-level from
  line-level conditions) confirmed all of round 2's regressions fixed, and
  found: 40-55% of accept/turnin steps had lost their `npc` entirely
  (correct fix for round 2's bug, but too conservative - the dominant real
  shape is a SINGLE trailing `.target` for a whole multi-action block);
  `.train id,flags` with the flags argument ignored, so a `textOnly` gate
  (RXPGuides' own "skip if already known" condition) shipped as a blocking,
  nameless `spell` step; `#optional` wasn't recognized, so "Equip X"-style
  item gates shipped non-optional and could block Reconcile forever;
  `<< skip` (RXPGuides' own disabled-step marker) fell through as
  "unhandled" instead of being dropped; negated race tokens (`<< !Undead`)
  were dropped entirely, losing real content for every OTHER race.
- **Round 4** confirmed those fixed, and found: `#optional`/`.maxlevel`
  only reached steps that already existed when the tag was read, not a
  split created later in the same block (since real guides put the tag
  FIRST); the fix for negated races kept them fully unfiltered-by-race
  instead of resolving to the complement race list within the guide's own
  already-parsed faction, so RXPGuides' own "wrong guide" warning
  (`<< !Orc !Troll` in the Orc/Troll guide) now shipped to exactly the
  races it's meant to exclude; the `.train` odd-flags note wording didn't
  account for RXPGuides' second "reverse" flag bit.
- **Round 5** confirmed those fixed, and found one more real, pre-existing
  bug that the negated-race fix made worse: `RACE_TOKENS` mapped
  Undead/Scourge to the human-readable `"Undead"`, but `Data:PlayerRace()`
  returns WoW's own raceFile (`"Scourge"`) and `Core.lua`'s `StepApplies`
  does an exact string compare - every already-shipped route filtering on
  this race already (correctly) uses `"Scourge"` (e.g.
  `Routes/Horde/Mulgore.lua`), so this would have silently hidden content
  from Undead players on the next import. Fixed by changing `RACE_TOKENS`
  and the new `FACTION_RACES` table to use `"Scourge"`.

**Final shape of the fix** (RXPImport.lua): `blockClass`/`blockClassExclude`/
`blockRaces`/`blockInfoOnly`/`blockSkipIfLevel` capture the "step << Cond"
block's own condition/flags once, kept separate from what any individual
line's own condition resolves a specific split step to (`ResolveLineFilter`
combines the two, dropping a line only on a genuine contradiction).
`StepForAction` splits on a resolved-filter mismatch as well as a
type/id/objective mismatch (catching same-quest reward-choice pairs), and
its `carry` table forwards the BLOCK's own filters/flags (not whatever the
current step happens to hold) to both existing and future splits.
`FACTION_RACES` + `route.faction` resolve a negated race to the faction's
complement race list. `npc` is intentionally NOT carried across a split or
backfilled per-line (that caused real misattribution); instead `FinishBlock`
fills it once, at block-end, only when the whole block named exactly one
distinct NPC. `#season`/`#hardcore`/`#optional` are read as real standalone
`#`-tag lines (the syntax real guides actually use), not `<<` tokens.
`.train id,flags` distinguishes a real training action from a silent
`textOnly` condition (RXPGuides' own `functions.lua` semantics, verified
directly against that source, not guessed). A post-parse dedup pass
collapses only ADJACENT exact-duplicate steps, never `hearth`/`death`/
`trainer` types.

**Not attempted, left as documented limitations** (per round 5's own
findings, explicitly triaged as low-severity/no real-guide occurrence found
rather than skipped by oversight): a positive race and a negated race in
the same AND-group combine as an OR instead of an AND (zero occurrences
found across the Classic guides); `.maxlevel N << Cond` is last-directive-
wins rather than taking the max across differently-conditioned lines
(low-impact ordering quirk, not content loss); the pre-existing "genuinely
required item, no accept/turnin action, still non-optional" pattern (rare
drop-item quests) can still block a player who never gets the drop.

### Audit (impact / performance / dev time, per the standing rule) - rounds 2-5

- **Impact:** still contained to `RXPImport.lua` (parser), `Core.lua`
  (`StepApplies`, `classExclude` now a list), `Routes/Horde/Durotar.lua`
  (schema-header doc comment), and dev-only `spec/`/`plans/` files. No
  shipped `Routes/*.lua` file was touched - these fixes only change output
  for *future* re-parses, exactly as scoped in round 1's audit.
- **Performance:** still none at runtime - same reasoning as round 1's
  audit; nothing here changes when or how often any WoW API is called
  in-game.
- **Dev time:** roughly 6-8 hours across five review rounds (each a
  `code-reviewer` agent pass that re-ran the real-guide harness itself,
  plus this session's own fix-and-reverify cycle after each). Far more than
  the original ~2 hour estimate, but each round found genuine bugs a
  synthetic-spec-only pass would have shipped - directly validates why this
  repo's standing rule is "always review before commits," not "review
  once."
