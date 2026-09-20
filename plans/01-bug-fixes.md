# Plan 1: Bug fixes from the initial audit

Status: **Phases 1-4 done and committed on master.** Rewritten 2026-09-20 after an
audit against the actual codebase (see
`.claude/checkpoints/2026-09-20-plan-01-bug-fixes-audit.md` for the full evidence
trail). Original source: audit of the repo on 2026-09-18 (Forever beta day 2).

There is no headless Lua runner for WoW, so nothing here can be proven correct
outside the client — CI (`luacheck`, `busted spec/`, `validate_route.py --no-db`)
covers what's mechanically checkable and is green on the current `master`
(`gh run list`), but live behavior still needs a play session. That play session is
the only work this plan has left; see "Remaining: in-game verification" below.

Ground rules from `CLAUDE.md` still apply and were followed by everything below:
- Route all client detection through `Compat`.
- All event registration goes through `Compat:RegisterEvents`.
- `Data.lua` is the only file that touches QuestieDB.
- No secure snippets.

---

## Phase 1: Correctness bugs — done

| # | Fix | Where it lives | Evidence |
|---|---|---|---|
| 1.1 | `Compat.Atan2(y, x)` replaces the invalid two-arg `math.atan` call, branching on whether `math.atan2` exists rather than assuming either way | `Compat.lua:194`, called from `Arrow.lua:68` | Reads correctly regardless of what a live client's `math.atan2` turns out to be — the fix was written defensively, so Phase 0.1's original "which does the client have" question no longer blocks anything |
| 1.2 | `Core:SetIndex` is now the only place `self.index`/`Core.index` is assigned; `Core.pinned` blocks `Reconcile` from undoing Back/goto; cleared by Advance/LoadRoute/`Core:Resume()` | `Core.lua:22,228,245-426,851-852`; call sites fixed in `UI.lua:236,321,373`, `Progress.lua:244` | Matches the plan's chosen "pin until the user acts" behavior exactly |
| 1.3 | `Compat:Wrap(name, fn, onTrip)` wraps every `OnEvent`/slash handler with its own per-module error counter (ceiling well under Forever's 100-error cap) and an `onTrip` callback instead of going silent; `/tuff errors` reports counts | `Compat.lua:570,617,642,650`; wrapped at `Core.lua:636,697`, `Arrow.lua:158`, `Marker.lua:370`, `Recorder.lua:381`, `Rogue.lua:522` | Covered by `spec/compat_spec.lua`'s `Compat:Wrap` block (budget trip, `onTrip` fires once, one module tripping doesn't affect another) |
| 1.4 | `Core:AutoSelectRoute` collects candidates into a list and sorts deterministically (non-demo before `sample`/`skeleton`, then starting level, then name); logs the pick once; `Durotar.lua` marked `sample = true` | `Core.lua:443-470,487`; `Routes/Horde/Durotar.lua:89` | Covered by `spec/core_spec.lua`'s `AutoSelectRoute` block |
| 1.5 | `Data:ValidateRoute` treats a `questName`-only step as `unresolved` (info), not a problem; returns `problems, unknown, unresolved`; caller updated | `Data.lua:164-255` | Covered by `spec/data_spec.lua` |
| 1.6 | `Marker:EnableFriendlyPlates`/`DisableFriendlyPlates` call `pcall(SetCVar, ...)` directly and confirm via a `GetCVar` readback instead of trusting `Compat:Guard`'s always-nil return; check `InCombatLockdown()` first | `Marker.lua:309-336` | Reads correctly regardless of Phase 0.3's original question |
| 1.7 | `Data.lua`'s QuestieDB adapter prefers `QuestieLoader:ImportModule("QuestieDB")`, documents the fallback, stays fully optional | `Data.lua:21-95` | No database on Forever to test against; Classic Era confirmation is a live-client task, folded into "Remaining" below |
| 1.8 | `Compat:GetSpellBookName` uses `Enum.SpellBookSpellBank.Player` when it exists, else the legacy `"spell"` bank string; `Rogue.lua` calls the shim instead of a hardcoded `2` | `Compat.lua:326-338`; `Rogue.lua:556` | Reads correctly regardless of Phase 0.4's original question |

## Phase 2: Forever-specific data loss — done

### 2.1 Recording silently stops and is lost between launches

Status line while recording and `Compat:SavedVarsAreBroken()`, periodic nudge, login
warning, and `tools/extract_recording.py` for disk recovery are all in place.

- `Recorder.lua:91,153,156,394`
- `tools/extract_recording.py` (parses `WTF/Account/<ACCT>/SavedVariables/TuFFlevels.lua`)

## Phase 3: Content and documentation — done

- **3.1** README.md:126 states auto-accept/turn-in is implemented, opt-in, and
  confirmed live on Forever — stronger than the plan's requested "under
  investigation" wording; superseded rather than just satisfied.
- **3.2** `## Author: sekitoxD` in all three `.toc` files; `author = "sekitoxD"` in
  `Routes/Horde/Durotar.lua:88`; `/tuff routes` tags `skeleton` and `sample` routes
  (`Core.lua:753-754`); `Durotar.lua:89` carries `sample = true` so it's never
  auto-selected over a real route.
- **3.3** `Arrow.lua` routes every `TuFFlevelsDB` access through
  `Compat:InitSavedVar` (`Arrow.lua:107,117,145,269,275,281,288`).
- **3.4** `16001` listed first in `## Interface` for Forever in both
  `TuFFlevels.toc` and `TuFFlevels_Mainline.toc`. Which TOC Forever actually loads
  (Phase 0.2) is still worth a one-line `/tuff client` confirmation — folded into
  "Remaining" below since it's cheap to check alongside the rest.

## Phase 4: Tooling — done

All four items shipped, one under a different name than originally specified:

1. `.luacheckrc` with this addon's WoW globals — present, wired into CI.
2. `.github/workflows/lint.yml` — three jobs on push/PR: `luacheck`,
   `validate-routes` (`validate_route.py --no-db` + a `merge_routes.py` smoke test),
   `busted spec/`. Green on the current `master` HEAD (`gh run list`).
3. Structural route validation outside the game — shipped as
   `tools/validate_route.py --no-db` (Python) rather than the originally-proposed
   `tools/validate_routes.lua`. Same job, already in CI; the second contributor's
   existing Python tooling absorbed this instead of a new Lua script being written.
   Not a gap — recorded here so a future read of this plan doesn't go looking for a
   file that was never going to exist.
4. `spec/{compat,core,data}_spec.lua` cover exactly the functions named:
   `IsStepDone`, `StepApplies`, `Reconcile`, `SetIndex` + pinning, `AutoSelectRoute`,
   `Data:ValidateRoute`, `Compat:Guard`/`Wrap`. Stub `Data`/`Compat` via
   `spec/helpers/`.
5. `.pkgmeta` — present, configured for the BigWigs packager, ignores
   `Architecture`/`plans`/`tools`/`spec`/`.github`/dev-only files.

---

## Remaining: in-game verification

This is the only work left, and it's not code — it's a play session on the Forever
beta (and Classic Era / Retail if convenient) to confirm the defensively-written
fixes above actually behave as intended live, and to close out the plan's original
"Done when" checklist.

**Impact:** none — this is a read/observe pass, no files change unless a check
surfaces an actual bug, in which case that becomes its own small, separately-scoped
fix rather than reopening this plan.
**Performance:** none — no code runs differently because of this pass.
**Dev time:** ~20-30 minutes of played time (mostly the 10-minute error-spam
watch and one delivered-quest turn-in for the recording-recovery check).

| # | Check | Command | What it confirms |
|---|---|---|---|
| V1 | Arrow bearing | Walk toward a known coordinate | `Compat.Atan2` (1.1) points correctly regardless of which branch it took |
| V2 | Back sticks | Accept/complete/turn in a quest, hit Back, do a quest action | `Core.pinned` (1.2) actually blocks `Reconcile` from re-advancing |
| V3 | No error spam | 10 minutes of normal play | `Compat:Wrap` (1.3) per-module budgets hold under real event traffic |
| V4 | Nameplate CVar toggle | `/tuff plates`, in and out of combat | `Marker:EnableFriendlyPlates` (1.6) reports correctly and blocks in combat |
| V5 | Recording recovery | Record steps, exit the game, run `tools/extract_recording.py`, compare with the in-game export | End-to-end 2.1 data-loss recovery path |
| V6 | Which TOC loads | `/tuff client` | 3.4's `16001`-first ordering is actually what Forever picks up |
| V7 | QuestieDB adapter (Classic Era only, if available) | `/tuff verify` on the Durotar route with Questie installed | 1.7's `QuestieLoader:ImportModule` call form is correct |
| V8 | Rogue spellbook scan (rogue character) | Run the scan from the Rogue tab | `Compat:GetSpellBookName` (1.8) returns real names |

## Done when

- [x] `luacheck` passes with no warnings — CI green.
- [x] `busted` passes — CI green.
- [ ] V1-V8 above confirmed live and any resulting findings resolved.
