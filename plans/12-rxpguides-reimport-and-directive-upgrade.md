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
- [ ] Chapter 2 ("6-10 Durotar"), chapter 3 ("10-12 Durotar" / the
      "10-12 Tirisfal" branch it leads into for Undead - out of scope for
      this Orc/Troll route, skip it), then the shared
      `Classic-Horde-30-60.lua` 36 chapters (Barrens onward).
- [ ] Continue the chapter-1 playtest past level ~6 to shake out any
      further duplicate-step or directive-residue issues before starting
      chapter 2 - the OR-condition-branch duplication root cause found
      this round is very likely to recur in later chapters too.
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
