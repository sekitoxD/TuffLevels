# Checkpoint: plan-01-bug-fixes-audit

Saved: 2026-09-20
Branch: master (working tree has unrelated uncommitted plan-02 work; see below)

## Goal

Audit `plans/01-bug-fixes.md` against the current state of the codebase and rewrite it
to reflect what's actually left, per the user's request, before starting implementation.

## State

- Working tree has uncommitted changes in `Arrow.lua`, `Automation.lua`, `Compat.lua`,
  `Core.lua`, `Data.lua`, `Marker.lua`, `Pace.lua`, `Panel.lua`, `Progress.lua`,
  `Routes/Horde/Durotar.lua`, and `plans/02-restedxp-improvements.md`. All of it is
  R1-R6 from the plan-02 audit session earlier today (see
  `.claude/checkpoints/2026-09-20-plan-02-restedxp-audit.md`) — none of it touches
  anything plan-01 asked for. Left as-is; not this session's concern.
- `master` is at `d9e3022`. CI ("Lint" workflow: luacheck, `validate_route.py --no-db`,
  `merge_routes.py` smoke test, `busted spec/`) is green on the last 5 pushes
  (`gh run list`), including the current HEAD.

## Audit method

Grepped and read the actual source for every fix plan 01 names, rather than trusting
the plan doc's own (empty) "Phase 0 results" section:

- `Compat.Atan2` (Compat.lua:194), used by `Arrow.lua:68`.
- `Core.pinned` / `Core:SetIndex` / `Core:Resume` (Core.lua:22,228,292-426,851-852),
  and every direct `self.index =` / `Core.index =` assignment site the plan named
  (`UI.lua:236,321,373`, `Progress.lua:244`) now goes through `SetIndex`.
- `Compat:Wrap` (Compat.lua:617) wrapping every `OnEvent`/slash handler the plan named
  (Core.lua:636,697; Arrow.lua:158; Marker.lua:370; Recorder.lua:381; Rogue.lua:522),
  per-module budgets with `onTrip`, `/tuff errors` (Compat.lua:570,642,650).
- `Core:AutoSelectRoute` (Core.lua:443) collects candidates into a list and sorts
  deterministically (Core.lua:464-470: non-demo before sample/skeleton, then starting
  level, then name), logs the pick once (Core.lua:487), `Routes/Horde/Durotar.lua:89`
  carries `sample = true`.
- `Data:ValidateRoute` (Data.lua:164-255) treats a `questName`-only step as
  `unresolved`, not a problem, and returns `problems, unknown, unresolved`.
- `Marker:EnableFriendlyPlates`/`DisableFriendlyPlates` (Marker.lua:309-336) call
  `pcall(SetCVar, ...)` directly and confirm via `GetCVar` readback instead of
  trusting `Compat:Guard`'s return, and check `InCombatLockdown()` first.
- `Data.lua`'s QuestieDB adapter (still the only file touching it) prefers
  `QuestieLoader:ImportModule("QuestieDB")` with a documented fallback.
- `Compat:GetSpellBookName` (Compat.lua:331-338) uses
  `Enum.SpellBookSpellBank.Player` when present, else the legacy `"spell"` bank
  string; `Rogue.lua:556` calls it instead of a hardcoded `2`.
- Recorder SavedVariables-loss handling (Recorder.lua:91,153,156,394),
  `tools/extract_recording.py` exists.
- README.md:126 already states auto-accept/turn-in is implemented and confirmed
  live on Forever (stronger than the plan's requested "under investigation" wording
  — superseded, not just satisfied).
- TOC placeholders replaced (`## Author: sekitoxD` in all three .toc files,
  `author = "sekitoxD"` in `Routes/Horde/Durotar.lua:88`), `skeleton`/`sample` tags
  shown in `/tuff routes` (Core.lua:753-754), `16001` listed first for Forever in
  both `TuFFlevels.toc` and `TuFFlevels_Mainline.toc`.
- `Arrow.lua` routes all `TuFFlevelsDB` access through `Compat:InitSavedVar`
  (Arrow.lua:107,117,145,269,275,281,288).
- Phase 4 tooling all present: `.luacheckrc`, `.github/workflows/lint.yml` (3 jobs:
  luacheck, validate-routes, busted), `.pkgmeta`, `spec/{compat,core,data}_spec.lua`
  covering exactly the functions the plan named (`IsStepDone`, `StepApplies`,
  `SetIndex`+pinning, `Reconcile`, `AutoSelectRoute`, `Data:ValidateRoute`,
  `Compat:Guard`/`Wrap`).
- One naming difference, not a gap: the plan asked for a new
  `tools/validate_routes.lua` (Lua, no-DB structural checks). What shipped instead
  is `tools/validate_route.py --no-db` (Python, same job, already wired into
  `lint.yml`'s `validate-routes` job) — a second contributor's existing Python
  tooling absorbed this rather than a new Lua script being added. Functionally
  equivalent; the rewritten plan records it as done via the Python tool, not as an
  open gap.

## Audit findings

**Everything in Phases 1-4 of plan 01 is already implemented and committed on
`master`**, confirmed by reading the actual code rather than trusting the plan
document (which was never marked complete despite the code having moved past it —
the same pattern the plan-02 audit found this morning). CI is green on the current
HEAD, covering the "luacheck passes" / "busted passes" parts of the "Done when"
checklist mechanically.

The only thing that cannot be confirmed from this environment — no headless WoW
Lua runner, no live client — is **Phase 0's original purpose**: deciding which
variant of a fix to write based on live client behavior. That decision is now
moot: every Phase-0-gated fix was written defensively to handle either answer
(`Compat.Atan2` branches on whether `math.atan2` exists rather than assuming;
`EnableFriendlyPlates` confirms via `GetCVar` readback rather than trusting a
guessed return shape; `Compat:GetSpellBookName` branches on
`Enum.SpellBookSpellBank` existing). What's left of Phase 0 is a **confirmation
pass in the actual client**, not a decision that blocks further code.

## Dead ends

None — this was a read-only audit, no code was changed.

## Open questions

None blocking. Genuinely open item, flagged for the user: an in-game play session
is needed to fill in the "Phase 0 results" table and the "Done when" in-game bullets
(arrow points at a known target, Back sticks, no error spam after 10 minutes,
recording recoverable after relog) — this is authorship/live-client work no
subagent or static read can substitute for.

## Implementation summary

No implementation this session — the audit found nothing left to implement in
code. `plans/01-bug-fixes.md` was rewritten in place to state this plainly: Phases
1-4 marked done with file:line evidence, Phase 0 narrowed to the one real
remaining task (an in-game confirmation pass), and the "Order of work"/Phase 4
sections collapsed since they're now moot.

## Next steps

1. User runs the in-game confirmation pass described in the rewritten plan's
   "Remaining: in-game verification" section, on the Forever beta (and Classic Era
   / Retail if convenient), and fills in the results table.
2. If any check surfaces an actual behavioral bug (not just an unconfirmed
   assumption), open it as a new, small, separately-scoped fix — don't reopen
   Phase 1-4 wholesale for it.
3. No further code changes queued from this plan otherwise.

## Relevant files

- `plans/01-bug-fixes.md` — rewritten this session.
- `Compat.lua`, `Core.lua`, `Data.lua`, `Marker.lua`, `Rogue.lua`, `Recorder.lua` —
  where the fixes actually live (reference only, not touched this session).
- `.github/workflows/lint.yml`, `spec/*.lua`, `.luacheckrc`, `.pkgmeta` — Phase 4
  tooling (reference only).
- `.claude/checkpoints/2026-09-20-plan-02-restedxp-audit.md` — the sibling audit
  from earlier today; this one independently confirms its plan-01 dependency claim.
