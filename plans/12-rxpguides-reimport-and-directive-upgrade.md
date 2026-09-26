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

## Recommended sequencing

1. Land Phase 1 on Mulgore.lua first, chapter by chapter, checkpointing
   between chapters given the size.
2. Re-evaluate Phase 2 (fold into Phase 3, small slice) once Phase 1's
   workflow is proven.
3. Before starting Phase 3, re-read `plans/04-sheet-audit.md` in full and
   produce a written list of every tracked correction it documents, so
   the replace-vs-forward-port-gaps-only decision can be made with that
   list in hand rather than from memory.
