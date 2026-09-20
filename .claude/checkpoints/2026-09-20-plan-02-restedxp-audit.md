# Checkpoint: plan-02-restedxp-audit

Saved: 2026-09-20
Branch: master @ d9e3022

## Goal

Audit `plans/02-restedxp-improvements.md` against the current state of the codebase
(the plan was written in September and much of it has since shipped without the plan
document being updated), rewrite the plan to reflect what's actually left, then begin
implementation of the remaining work.

## State

Working tree is clean except two untracked files unrelated to this plan
(`tools/CLAUDE.md`, `tools/tuffweights/CLAUDE.md`, owned by the other contributor's
area). No plan-02 work has been committed yet. The plan's header says
`Branch: initial_audit`, but the repo is currently on `master` — that branch doesn't
exist / was already merged, so the rewritten plan drops the branch note.

## Decisions made

- **Audited via four parallel scout agents** (one per phase group: A, B, C+D, E+F+G)
  reading the actual source instead of trusting the plan doc, per the repo's standing
  rule to route mechanical/first-pass checks to Haiku-tier agents rather than doing
  them serially in the main thread.
- **Verified plan 01's dependency status directly** rather than trusting its own
  "Phase 0 results (fill in)" section (which is empty in the file): grepped for
  `Atan2`, `Core.pinned`, `SetIndex`, `Compat:Guard` and confirmed they exist across
  many files, and confirmed `spec/`, `.pkgmeta`, `.luacheckrc` all exist. Conclusion:
  plan 01 Phases 1.1-1.3 (and most of Phase 4 tooling) are done in code even though
  the plan document was never marked complete — the code moved ahead of its own
  planning doc. Plan 02's stated dependency ("Phases 1.1-1.3 done") is satisfied.

## Audit findings (this is the "why" a diff can't show)

Nearly everything in plans/02's Phases A, B, C, D, E, F is already implemented:

- **Phase A** (auto-detect travel/hearth/trainer/death/flightpath, `Compat.has`
  capability table, `Core:Resume`/catch-up scan, progress codes via `/tuff code`):
  fully implemented (Core.lua, Compat.lua).
- **Phase B** (real-yard distance via `Data:RealDistanceToStep`, multi-waypoint
  `step.path` via `Data:EffectiveTarget`, colorblind palette / scale / text-only mode,
  `Data:SetWaypoint` TomTom+native handoff): fully implemented (Arrow.lua, Data.lua).
  Only gap: no `via` field for annotating cross-zone transition type.
- **Phase C** (step-matched auto accept/turn-in, gossip auto-select, Shift bypass,
  on/off toggle, nameplate marker targeting helper): implemented (Automation.lua,
  Marker.lua). Only gap: no highlighting of the best reward choice by vendor value or
  class-usable upgrade — it correctly never guesses, but also never highlights.
- **Phase D** (personal-best splits, XP/hour, level ETA, text export): implemented
  (Pace.lua). Only gaps: timing is section-level only (no per-step granularity), and
  the "ghost" comparison is a text delta, not a live visual ahead/behind indicator.
- **Phase E** (`objective`, `xp` step type, `optional`, `skipIfLevel`, `requires` with
  cycle guard, and the CompactGuide.lua line syntax): fully implemented and documented
  in the Durotar.lua route header.
- **Phase F** (merge_routes.py median-coordinate merging with conflict reporting,
  extract_recording.py, validate_route.py, CONTRIBUTING.md workflow doc): fully
  implemented.
- **Phase G**: `Compat:HasSecretRestrictions` + Marker.lua pausing + `/tuff
  debugrestrict` test hook: implemented. Two gaps remain: no Settings-API panel
  exists yet, and `Marker.lua:53-55` still strips only English quest-objective
  suffixes (`slain`/`killed`/`destroyed`) via `gsub` instead of using the objective's
  `type`/`numFulfilled` fields — confirmed still present, not fixed.
- Rogue.lua is loaded by default in all three `.toc` files (the plan's suggestion to
  make it optional/separate was not taken — left as-is, not treated as a gap to fix
  since it's a scope suggestion, not a correctness bug).

Net effect: the plan as written describes ~90% already-shipped work. The rewrite
should describe only the ~10% remaining, not re-plan already-done phases.

## Dead ends

- None. All six implementation items (R1-R6) went in cleanly on the first attempt,
  each scoped down from the original plan wording where a live-client-only detail
  made the literal spec unverifiable (see R3 and R6 below).

## Open questions

- None blocking further work. What remains is **in-game verification**, not more
  implementation — see plans/02-restedxp-improvements.md's "Done when" checklist.
  Flagged for the user specifically: R6's exact `Settings.RegisterProxySetting`/
  `Settings.CreateCheckbox` call shape could not be confirmed from this environment
  (no headless Lua runner, no live client) and needs a check in the Game Menu →
  Options → AddOns panel on Forever or Retail.

## Implementation summary (all done 2026-09-20)

Rewrote `plans/02-restedxp-improvements.md` down to six remaining items (R1-R6, the
plan's "Remaining work" section), each with impact/performance/dev-time per the
`always-audit-plans` pinned rule, then implemented all six in this session:

- **R1** (Marker.lua): locale-keyed kill-objective suffix stripping
  (`LOCALE_SUFFIXES`/`SuffixesForLocale`), replacing the English-only `gsub` chain.
- **R2** (Data.lua, Arrow.lua, Routes/Horde/Durotar.lua): optional `via` field on
  `step.path` waypoints, threaded through `Data:EffectiveTarget` → `Arrow.lua`'s
  `Bearing()` → the arrow's "Via:" label; validated (as an optional string) in
  `Data:ValidateRoute`.
- **R3** (Automation.lua, new `Compat:GetItemSellPrice`): reward-choice call-out.
  Scoped down from "highlight the button with a glow" to a chat announcement of the
  best-vendor-value choice, because the actual reward-choice frame's name/layout
  differs between Classic Era and Forever/Retail and can't be verified without a
  live client — a wrong UI-frame guess risked visibly breaking Blizzard's own quest
  frame, a chat line carries no such risk.
- **R4** (Pace.lua): per-step cumulative-time tracking (`RecordStepSplit`/
  `BestStepTime`), parallel to the existing per-section split tracking.
- **R5** (Pace.lua, Progress.lua): live ahead/behind delta in the Progress window's
  existing pace line (`StepDeltaVsBest`), kept moving by a new 2-second
  `C_Timer.NewTicker` calling `Progress:Refresh()` (which already no-ops while its
  window is hidden, so this costs nothing when Progress isn't open).
- **R6** (Compat.lua, Panel.lua, Core.lua): Settings-API category with 5 checkboxes
  mirroring Panel.lua's existing toggle buttons, gated behind a new
  `Compat.has.settingsAPI` flag (false on Classic Era, which has no `Settings`
  global). Implemented by a delegated `implementer` subagent per this repo's
  model-tiering convention; reviewed the diff directly before accepting it. Every
  `Settings.*` call is wrapped in `Compat:Guard`, so an unverifiable API-shape guess
  degrades to "one checkbox missing," not a crash.

## Next steps

1. In-game verification pass (see the plan's "Done when" checklist) — nothing here
   can be checked without loading the addon live, per this repo's testing model.
2. If any R-item's live behavior doesn't match what's documented above, fix in
   place and update the corresponding section of `plans/02-restedxp-improvements.md`
   rather than leaving the doc claiming "DONE" for something that turned out wrong.

## Relevant files

- `plans/02-restedxp-improvements.md` — the plan being rewritten.
- `Core.lua`, `Compat.lua` — Phase A (already done; reference only).
- `Arrow.lua`, `Data.lua` — Phase B (mostly done; `via` field gap here).
- `Automation.lua` — Phase C reward-choice gap.
- `Marker.lua` — objective-suffix localisation gap (lines ~45-55).
- `Pace.lua` — Phase D per-step/ghost gaps.
- `Panel.lua` — where a Settings-API panel would likely hook in.
- `plans/01-bug-fixes.md` — dependency; confirmed satisfied in code despite its own
  empty "Phase 0 results" section.
