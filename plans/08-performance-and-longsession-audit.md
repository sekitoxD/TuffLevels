# Plan 8: Performance and long-session audit fixes

**Status: in progress (audited 2026-09-22; see "Audit corrections" + batch table). PRIORITY — do this before starting any other new plan.**
When picking up work in this repo with no other in-flight plan specified, start
here first.

Source: a four-way parallel `code-reviewer` audit of every addon file outside
`tools/` (Compat.lua, Core.lua, Data.lua / Marker.lua, Arrow.lua, Pace.lua /
UI.lua, Panel.lua, Progress.lua, Zones.lua, Theme.lua / Automation.lua,
Recorder.lua, Import.lua, GuideImport.lua, RXPImport.lua, CompactGuide.lua,
SheetImport.lua, Rogue.lua), run 2026-09-22 specifically to find memory leaks,
per-frame/per-event performance cost, and correctness bugs that compound over a
multi-hour play session. `Routes/**/*.lua` (hand-authored data, not engine code)
was out of scope for this pass.

Ground rules from `CLAUDE.md` apply to every fix below:
- Route all client detection through `Compat`.
- All event registration goes through `Compat:RegisterEvents`.
- `Data.lua` is the only file that touches QuestieDB.
- No secure snippets.
- Cross-module calls guard with `if ns.X then ... end`.

Every item carries the impact/performance/dev-time audit the user's standing
rule requires. There is no headless Lua runner for WoW (per `CLAUDE.md`), so
each item below is marked **[code-confirmed]** (verifiable by reading the fix)
or **[G]** (needs a live client check, and on which target — Classic Era,
Forever, or Retail matters for several of these).

---

## Audit corrections (plan-auditor pass, 2026-09-22, after 1264d50) — READ FIRST

Every Phase 1 defect was confirmed real. Core.lua line refs below drifted ~+16
from line 40 on; other files unchanged unless noted. **Where this section
conflicts with an item's original "Fix:", this section wins.**

- **P1.1** — goes through `Compat:RegisterEvents` today (Core 552-565), not
  plain `RegisterEvent`. `Compat:RegisterUnitEvents` must fall back to plain
  `RegisterEvent` if `RegisterUnitEvent` is missing/throws, reporting missing
  only if both fail. Also register `UNIT_QUEST_LOG_CHANGED` player-only. When
  narrowing Core 695-702, keep reconcile for `TRAINER_CLOSED`,
  `PLAYER_ALIVE`/`PLAYER_UNGHOST`, `ZONE_CHANGED_NEW_AREA`, `PLAYER_LEVEL_UP`;
  only `UNIT_SPELLCAST_SUCCEEDED` (non-hearth) and `PLAYER_DEAD` skip it. Must
  add `RegisterUnitEvents` to `spec/helpers/fake_compat.lua` and
  `RegisterUnitEvent` to the stub frame in `spec/helpers/wow_stubs.lua` in the
  same commit or core_spec fails to load.
- **P1.2** — ticker at 0.05s (current rate), not 0.1s.
- **P1.3** — `RouteStats` (all steps, `IsStepDone`) and `BuildList`
  (applicable steps, `i < index or IsStepDone`) count differently; a single
  pass must keep both. Guard `RenderRows` against re-entry from
  `SetMinMaxValues`→`OnValueChanged`; key the cache on `Core.active` to reset
  `offset` on route change. Lines now 55-118, 296-304, 344-379, 424-451.
- **P1.4** — `ShowColorPicker` is static (build once, no pool);
  `ShowRoutePicker` needs a pool. CatchUp, ResumePrompt, ProgressCode,
  ContentMenu, DisplayMenu change content per open: build-once versions must
  refresh text/labels/buttons on every open, and closures must not capture the
  first call's arguments.
- **P1.5** — original fix breaks ambiguous *turn-in* steps (quest leaves the
  log, live lookup fails). Instead: still bind `step.quest`, but only when the
  step is the current step (or at/after `Core.index` in the Reconcile walk);
  never bind during full-route walks (Progress, `Sections()`).
- **P1.6** — original fix doesn't stop corruption (every later split in a
  mid-route session is still wrong; also `Core:Load` reconciles before
  `Pace:StartRun`, and lazy StartRun records `steps[index]=0`). Instead: record
  step bests / show `StepDeltaVsBest` only when the run began at step 1 (first
  non-section step), and mark the run invalid for step splits on any
  `SetIndex` that isn't a +1 advance. Section-split rule stays as written.
- **P1.7** — quest events must also trigger a throttled `RescanAll`, not just
  a dirty flag; invalidate the cache at the top of `RescanAll`; add events to
  the existing Marker 440 list.
- **P1.8** — each ticker self-stops after 8s; the real harm is a second scan
  resetting `titles`/`ids` under the first ticker's `onDone`. Cancel via
  `OnHide`.
- **P1.9** — replace with: at the top of `QUEST_GREETING`/`QUEST_DETAIL`/
  `QUEST_COMPLETE` handlers, `Compat:InvalidateLogIndex()` then
  `Core:Reconcile()`, then match. No re-run of the greeting match
  (double-select risk). Automation has no `GOSSIP_SHOW` handling — test on a
  `QUEST_GREETING` NPC; gossip support is out of scope.
- **P1.11** — ship with P2.11 (else the first learned spell stamps the whole
  spellbook). Store `rogueSeeded`/`rogueLearned` in `TuFFlevelsCharDB`; take
  the baseline on first `SPELLS_CHANGED`, not `PLAYER_LOGIN`. Rename was 11.0.
- **P1.12** — drop *both* `Compat:CacheQuestName` and `SaveNameCache` from the
  fallback; set only `step.quest` for the session.
- **P1.13** — don't clear `_eventDone` (would un-complete done steps after
  `/tuff reset`). Reset only `_pathIndex`, on the step that *becomes current*,
  in `SetIndex` and in Reconcile's `moved` branch. `LoadRoute`/`Load` bypass
  `SetIndex` (Core 443, 533); fix the Core 241 comment claiming otherwise.
- **P2.1** — use a vararg tail helper
  (`local function finish(ok, ...) ... return ... end; return finish(pcall(fn, ...))`)
  for both `Guard` and `Wrap`; keeps all returns and the error budget. No
  `GuardPack` needed.
- **P2.2** — the decay check runs at call entry (tripped modules never call
  `fn`) and clears `moduleTripped`; `totalWrapped` needs decay too. Use
  `time()` or add `GetTime` to `.luacheckrc` + wow_stubs.
- **P2.4** — 1-2s TTL on taxi nodes; skip memoizing objectives.
- **P2.5** — cache in Compat `mapIDCache[zone]`; never cache before
  `ZoneIndex()` is built, never cache nil.
- **P2.6** — add `OnShow`→`Refresh`.
- **P2.7** — key cache on `(Core.active, Core.index)`.
- **P2.8** — defer the EffectiveTarget half (needs an Arrow→Data hook). Add
  force flag for the Map button (UI 276). New: remove the previous TomTom
  waypoint uid on each step change (they pile up all session).
- **P2.9** — near-zero gain; optional.
- **P2.10** — at hard cap, stop recording and tell the player (don't drop).
- **P2.12** — guard with `if ns.Data then`.
- New [G] to check: `UIPanelScrollFrameTemplate` in Import.lua:179 and
  Rogue.lua:476 may throw on Forever like Progress's scrollbar did.
- **Out of scope, found while running CI:** the `validate-routes` CI job has
  failed on every commit since before plan 08: 15,721 errors across 49
  route files. Most are steps with coordinates but no numeric `map`, and the
  `Routes/Horde/Solo/*` files have "no ns.RegisterRoute call found". That's
  route data vs. validator rules, not engine code, so it needs its own plan.
  The luacheck job was fixed separately (commit b2e74d2); busted was green.

### Commit batches (in order; each code-reviewed before commit + push)

| # | Batch | Status |
|---|---|---|
| 1 | Core + Compat + spec helpers: P1.1 | done (reviewed); [G] pending: city/mob pack on all 3 clients, hearth step still completes |
| 2 | Core: P1.5 + P1.13 + Phase 3 `#steps+1` guard, with core_spec tests | done (reviewed, one round of fixes applied: SetIndex now only resets `_pathIndex` on an actual index change, comment corrected re: Reconcile also assigning `self.index` directly); [G] pending: two ambiguous-flagged steps for the same chain quest, open Progress mid-chain |
| 3 | Automation: P1.12, P1.9 | done (reviewed); [G] pending: QUEST_GREETING multi-quest NPC |
| 4 | Progress: P1.3 | done (reviewed); [G] pending: long route open during turn-in burst, scroll full list, route switch |
| 5 | Pace (+ Core hook): P1.6 | done (reviewed across 4 rounds; the original per-case patch approach was replaced with a single unified `Pace.horizon` signal - see the 2026-09-24 checkpoint for the full history). Known accepted trade-offs (documented in-code, not fixed): a Back-then-refast-forward within one section can still record a slightly understated best (narrower than the login/resume corruption this fix targets); `horizon`'s quest-log half is read once at login and won't catch a QUEST_LOG_UPDATE that arrives late; a route that shares already-done content across sections/routes can suppress a genuine recording (errs toward skipping, never toward corrupting); the live section timer display resets to 0 on Back/goto even within the same section (cosmetic only). [G] pending: `/reload` mid-route on Classic Era/Retail and confirm no `TuFFlevelsDB.paceBest` entry gets overwritten with a near-zero value; reselect an in-progress route from the Panel picker and confirm the same; a route with a leading non-optional note/manual step (Durotar/Human/TirisfalStart/Horde1-60) on Forever, confirm no corrupted bests after eventually clicking past it; log in fresh (not `/reload`) on Classic Era and check pace still behaves once quest log populates |
| 6 | Arrow: P1.2 + Phase 3 arrow items (Arrow.lua half; Data.lua half of the double map/distance compute moves to batch 16) | done (reviewed); [G] pending: fresh login no route, zone transition, TomTom defer on→off |
| 7 | Marker: P1.7 + Phase 3 unit-keyed `active` | done (reviewed, one round of fixes applied: throttled-rescan timer callback now wrapped in `Compat:Wrap`, mob cache also keyed on the step it was built for since LoadRoute can change step without a RescanAll, marker holder reparents if its unit's nameplate frame gets rebound, throttled rescan skips work while markers are disabled); [G] pending: populated zone with plates on, objective completes without a step change, switch routes mid-session |
| 8 | Panel + Theme comment: P1.4 + sorted route picker | done (reviewed, one round of fixes applied: stale/contradictory comment above ShowContentMenu removed, ShowResumePrompt now Shows before fitting height to body text since GetStringHeight on a hidden reused frame isn't reliable); [G] pending: open each dialog ~10 times, route picker with routes added/removed, catch-up with and without a jump available |
| 9 | Import: P1.8 | done (reviewed, no fixes needed); [G] pending: open the import window, click it again mid-scan, close it mid-scan |
| 10 | RXPImport: P1.10 | done (reviewed, no fixes needed); [G] pending: import a real RXP guide excerpt with vendor/hint lines |
| 11 | Rogue: P1.11 + P2.11 + drop `CHAT_MSG_SYSTEM` | done (reviewed, one round of fixes applied: `TakeBaseline` no longer latches `rogueSeeded` off an empty/not-yet-populated spellbook read, and now skips not-yet-learnable "future" spellbook entries via a new `Compat:IsSpellBookItemFuture` wrapper so they don't get permanently baselined as already-known; comment fixes). Known remaining gap, not fixed (low severity per review): old account-wide `TuFFlevelsDB.rogueLearned` data from before this batch is orphaned, not migrated or cleared. [G] pending: Forever and/or Retail rogue, train a new ability, confirm it appears; confirm a pre-existing (not-yet-trained) ability doesn't show a level until actually trained |
| 12 | Compat: P2.1 + compat_spec | done (reviewed, no fixes needed); [G] pending: confirm CI busted run is green (this batch's own specs have never actually been executed, only reasoned through) |
| 13 | Compat + stubs + .luacheckrc: P2.2 | done (reviewed across 3 rounds; a lifetime-vs-decaying-count split was added for /tuff errors, notification was capped to once per module while onTrip itself still fires on every re-trip via a firstTrip flag, and the Core "auto-advance is off" onTrip message added in this batch was corrected not to overstate what tripping actually disables). [G] pending: force a module to trip (e.g. temporarily break a wrapped handler) and confirm /tuff errors still shows it after several minutes, and that it silently recovers |
| 14 | Compat: P2.3 + P2.5 | done (reviewed across 3 rounds; a naive single-key P2.3 fix would have broken auto-advance for a quest turned in before its own step was ever asked about by name, in both memory and SavedVariables - fixed via a merge-once-per-LogIndex-rebuild design that keeps the O(1)-per-lookup goal while restoring both the in-memory and persisted opportunistic caching the original code had). [G] pending: a name-based route, hold two quests simultaneously, turn one in before its own step is reached, confirm it still auto-advances; on Classic Era/Retail, confirm the same holds after a `/reload` |
| 15 | Core: P2.7 | done (reviewed, no correctness fixes needed; strengthened the test suite per review - the original 3 tests never actually proved a repeat call hits the cache instead of re-walking, added 2 tests that mutate the route's steps in place between calls to prove it). [G] pending: a long section-less imported route, open Progress/UI repeatedly and confirm no per-refresh hitch |
| 16 | Data (+ Core): P2.4, P2.8 (reduced), Phase 3 `C_Map` guard | not started |
| 17 | UI: P2.6; Recorder: P2.9 + P2.10; Zones: P2.12 | not started |

---

## Phase 1 — correctness bugs and sustained-cost hot paths

These are the items that either actively corrupt state (chain-quest binding,
pace bests, imported-route notes) or run continuously for the length of a
session in ordinary play, not just in an edge case.

### P1.1 — `UNIT_SPELLCAST_SUCCEEDED` registered unfiltered drives a permanent reconcile storm

`Core.lua:547,636,679-686`. Registered via plain `RegisterEvent`, so it fires
for every nameplate/party/pet unit's spellcast, not just the player's. In any
populated area (cities, mob packs) this keeps `ThrottledReconcile` firing at a
sustained ~3.3 Hz indefinitely — full quest-log-index invalidation, a
`Core:Reconcile()` pass, and a `UI:Refresh()` each time, doing nothing useful
99% of the time.

**Fix:** add `Compat:RegisterUnitEvents(frame, events, unit)` (pcall-wraps
`frame:RegisterUnitEvent`, same Forever-safety shape as `RegisterEvents`) and
register this event `"player"`-only. Separately narrow Core.lua:679-686 so only
quest-affecting events actually call `InvalidateLogIndex`/`ThrottledReconcile`.

**Impact:** `Compat.lua` (new small method) + `Core.lua` (event registration
call site + handler branch). No other module depends on this registration.
**Performance:** removes the single largest steady-state CPU/GC cost found in
the audit — a permanent 3.3 Hz loop in every populated area, for the entire
session.
**Dev time:** ~30 min + [G] test standing near a mob pack/in a city on all
three targets, watching `/tuff errors` and a frame-time indicator.

### P1.2 — Arrow can permanently stop updating for the rest of the session

`Arrow.lua:163-220`. The update loop is `OnUpdate` on the same frame that
`Arrow:Update` hides on four paths (disabled, defer-to-TomTom, no current step,
no bearing angle). WoW does not call `OnUpdate` on a hidden frame, so once any
of those fire the arrow is dead until `/reload` or toggling it off/on twice.
Hits on a fresh login with no route yet selected, and after any zone-transition
frame where `C_Map.GetBestMapForUnit` briefly returns nil.

**Fix:** drive the loop from a `C_Timer.NewTicker(0.1, guardedUpdate)` created
once in `Build()`, independent of the visible frame's shown state; `Update`
still shows/hides the frame for display purposes only.

**Impact:** `Arrow.lua` only, self-contained.
**Performance:** neutral to positive (ticker-driven is no more expensive than
`OnUpdate`, and this phase also fixes finding P1.3 which was double-computing
inside the same loop).
**Dev time:** ~20 min + [G] test: fresh login with no route, `/reload` through a
zone transition, toggle defer-to-TomTom off after it was on.

### P1.3 — Progress window: full route walked twice per quest event, and again per scroll tick

`Progress.lua:55-118,296-299,424-451`. `Refresh()` calls `RouteStats()` and
`BuildList()` — two independent full walks of `route.steps` calling
`IsStepDone` on each — every time it's invoked while the window is open, which
is every quest event via `Core.lua:278` inside `Reconcile`. On a route with
thousands of steps this is thousands of guarded API calls and thousands of
table allocations per refresh, at up to ~3.3/sec (worse while P1.1 is
unfixed). Mouse-wheel scrolling triggers the same full rebuild per wheel
notch — the worst interactive stutter in the addon.

**Fix:** fold `RouteStats` and `BuildList` into one pass. Cache the built list
in a module-local, only rebuilt on `Refresh()`/filter/route change; make
`RenderRows` index into the cache instead of rebuilding it, so scrolling is
O(visible rows). Also fix P1.3b: `RenderRows` clamps `offset` *after* the
render loop (Progress.lua:376-378), causing a blank-then-repopulate flash and a
duplicate walk on route switch — move the clamp before the loop and reset
`offset = 0` on route change.

**Impact:** `Progress.lua` only.
**Performance:** removes the largest single per-event allocation/call spike in
the addon when the checklist window is left open during play — the realistic
case for a player tracking overall route progress.
**Dev time:** ~45 min + [G] test: open Progress on a long route, do a multi-quest
turn-in burst, scroll through the full list.

### P1.4 — Panel dialogs leak a frame (and its widgets) on every open

`Panel.lua` — 9 of 10 dialogs (`ShowChangelogDialog`, `ShowContentMenu`,
`ShowDisplayMenu`, `ShowRoutePicker`, `ShowCatchUpDialog`, `ShowResumePrompt`,
`ShowProgressCode`, `ShowHelpDialog`, `ShowColorPicker`) do
`if self.X then self.X:Hide() end` then unconditionally `CreateFrame(...)` and
reassign, instead of building once and reusing (the pattern `PromptNote`,
`Panel.lua:561-598`, already gets right). WoW frames parented to `UIParent`
are never garbage-collected, so every reopen leaks that dialog's buttons,
textures, and `Theme:SkinButton` closures permanently for the session. Compounds
with P1.4b: `Theme._skinned` (`Theme.lua:62`) is a weak-*key* table under the
assumption that closed frames get collected — they don't, so it can't self-trim
either, and `Theme:ReapplyAll()` gets slower on every dialog reopen as the
leaked set grows.

**Fix:** for the 7 fixed-content dialogs, build once behind `if not self.X then`
and just `Show()`/refresh labels on reopen (the `PromptNote` pattern). For
`ShowRoutePicker` and `ShowColorPicker` (variable button count), add a small
button pool: create on demand, hide surplus — same shape as `Progress.lua`'s
`EnsureRow`. Update the `Theme.lua:56-61` comment once frames stop leaking.

**Impact:** `Panel.lua` (9 functions) + `Theme.lua` (comment only, no logic
change needed once P1.4 lands). Self-contained; no other module calls into
these dialog builders.
**Performance:** removes an unbounded-over-session widget leak and the
`ReapplyAll` slowdown that comes with it — most visible to players who tweak
settings/colors repeatedly in one sitting.
**Dev time:** ~1-1.5 hr (9 call sites, 2 of which need real pooling logic) + [G]
test: open each dialog ~10 times in one session, then check `/framestack` or
just confirm `ReapplyAll` stays fast after repeated color-picker use.

### P1.5 — Chain-quest disambiguation is permanently defeated

`Core.lua:40-59`. `ResolveQuest` writes `step.quest = id` even for
`ambiguous`-flagged steps on first resolution — the "live log only" protection
that flag exists for only holds until the *first* time the step is evaluated
against the live log. Evaluating every step (e.g. opening Progress, which walks
the whole route) against a live log holding one link of a multi-link chain
quest permanently and silently binds the wrong quest ID to that step for the
rest of the session; auto-advance then falsely completes or skips it.

**Fix:** `ResolveQuest` returns the live-resolved ID for `ambiguous` steps
without ever writing `step.quest`; thread the resolved ID through
`StepOwnConditionDone` as a local instead of re-reading `step.quest`.

**Impact:** `Core.lua` only, one function plus its one caller.
**Performance:** none — this is a correctness fix, not a hot-path change.
**Dev time:** ~20 min + [G] test: a route with two `ambiguous`-flagged steps for
the same chain-quest name, open Progress while holding link 1, confirm link 2's
step doesn't get marked done.

### P1.6 — Personal-best pace data gets permanently corrupted on a mid-route session start

`Pace.lua:48-63,106,132-135`. `StartRun` records `time()` with no record of
which step the run began at. Any session that doesn't start at step 1 (login,
`/reload`, reselecting the route — all routine) feeds
`time() - runStart` into `RecordStepSplit` for the *next* step advance, and
since it keeps the minimum ever seen, a legitimate multi-hour best gets
silently overwritten with a near-zero garbage value, unrecoverable on clients
where SavedVariables persist (Classic Era, Retail).

**Fix:** record `self.runStartIndex = Core.index` in `StartRun`; have
`RecordStepSplit` skip when `stepIndex <= runStartIndex`, and `RecordSplit`
skip a section transition when `runStartIndex` is already past that section's
first step.

**Impact:** `Pace.lua` only.
**Performance:** none — correctness fix.
**Dev time:** ~20 min + [G] test: `/reload` mid-route, advance one step, confirm
no best gets overwritten; check `TuFFlevelsDB.paceBest` before/after on a
persisting client if available.

### P1.7 — `Marker:WantedMobs()` rescans the entire quest log per nameplate spawn

`Marker.lua:72-119,272`. Called once per unit from `NAME_PLATE_UNIT_ADDED`, and
once per visible plate from `RescanAll` (itself run on every step advance and
`PLAYER_ENTERING_WORLD`). Each call walks the full quest log, calling
`C_QuestLog.GetQuestObjectives` per quest and rebuilding gsub patterns by string
concatenation per objective per locale suffix. In a populated zone at 5-20
`NAME_PLATE_UNIT_ADDED` events/sec this is hundreds of quest-log API calls and
thousands of throwaway string allocations per second — worst exactly when the
quest log is fullest, i.e. during active questing.

**Fix:** compute the wanted-mob set once, cache on the module, invalidate via a
dirty flag on `QUEST_LOG_UPDATE`/`QUEST_ACCEPTED`/`QUEST_REMOVED` (registered
through `Compat:RegisterEvents`) and on step change (top of `RescanAll`).
Hoist the per-locale gsub patterns into `LOCALE_SUFFIXES` at load time instead
of rebuilding them per objective. This also fixes a latent correctness bug:
Marker currently registers no quest events, so a completed objective's marker
sticks on already-visible plates until the step index happens to move.

**Impact:** `Marker.lua` only.
**Performance:** removes the second-largest steady-state cost in the audit —
directly proportional to nameplate density, which is highest exactly where
players spend the most time (grinding/questing areas).
**Dev time:** ~40 min + [G] test: ride through a populated zone with plates on,
watch for stutter; complete an objective and confirm the marker clears without
a step change.

### P1.8 — Import window's polling ticker is never cancelled and stacks on reopen

`Import.lua:53,212-243`. `Show()` unconditionally re-scans and starts a new
`C_Timer.NewTicker(0.5, ...)` even if a scan is already in flight or the window
is already open; nothing cancels a previous ticker. Reopening/re-clicking
during an 8-second scan (realistic on a high-level character with hundreds of
completed quests) stacks concurrent tickers, each looping the full completed-ID
list every 0.5s — three clicks compounds into thousands of pcalls in one frame.
Closing the window doesn't cancel the ticker either.

**Fix:** store the ticker as `self.ticker`, cancel any existing one before
starting a new scan, skip the rescan in `Show()` if one's already running, and
cancel on window close.

**Impact:** `Import.lua` only.
**Performance:** eliminates a stacking-ticker pattern that gets worse the more
times the window is opened in a session.
**Dev time:** ~20 min + [G] test: open the import window, click it again
mid-scan, close it mid-scan.

### P1.9 — Automation only completes the first quest at a multi-quest NPC

`Automation.lua:132-163` against `Core.lua:601-609`. Automation reads
`Core:CurrentStep()` live, but `Core.index` doesn't advance until
`ThrottledReconcile`'s 0.3s timer fires. A multi-quest NPC's greeting panel
re-shows immediately (client-driven, faster than the 0.3s window), so quests
2+ are matched against the still-stale current step and silently skipped by
auto-accept/turn-in.

**Fix:** have Automation call `Core:Reconcile()` synchronously (it's bounded —
stops at the first not-done step) on `QUEST_ACCEPTED`/`QUEST_TURNED_IN` instead
of waiting on the debounce, then re-run the greeting match if a gossip/greeting
frame is still open.

**Impact:** `Automation.lua` only; calls an existing bounded `Core` method, no
new coupling.
**Performance:** negligible — this makes an already-cheap operation run
slightly more often, not a new hot path.
**Dev time:** ~30 min + [G] test: a real multi-quest NPC (e.g. an early Durotar
quest hub) with auto-accept/turn-in on, confirm all quests are handled in one
visit.

### P1.10 — RXP-imported guides lose all notes and gain content-free "Guide note" steps

`RXPImport.lua:203-210` vs `375-380`. `FinishStep()` nils `curStep._notes`
*before* the post-pass concatenates it into `step.note`, so `note` is never
populated for any imported step — every `.vendor`/`.link`/`+`-prefixed hint
from the source guide is silently discarded. A step whose only content was
notes still gets kept (passes the `#curStep._notes > 0` test before the nil-out)
and becomes a bare `{ type = "note", name = "Guide note" }` — the player has to
click through it for nothing, repeated dozens of times across a full guide
import.

**Fix:** move the `_notes` → `note` concatenation above the nil-out in
`FinishStep`; drop a step with no `type`/`zone` and no resulting note text
instead of keeping it as a placeholder.

**Impact:** `RXPImport.lua` only, isolated to the import path (no runtime
engine cost — this only affects the one-time import action).
**Performance:** none — correctness/content-quality fix, not a hot path.
**Dev time:** ~20 min + [G] test: import a real RXP guide excerpt with vendor/
hint lines, confirm notes appear on the resulting steps and no bare "Guide
note" steps are produced.

### P1.11 — Rogue tab's learned-ability tracking is likely dead on Forever/Retail

`Rogue.lua:513-517`. Registers only `LEARNED_SPELL_IN_TAB`, the Classic-era
event name — Mainline renamed it to `LEARNED_SPELL_IN_SKILL_LINE` at 10.0. This
is the exact "ported from Classic, not Retail" trap `CLAUDE.md` warns about:
`Compat:RegisterEvents` silently pcall-rejects the unknown name on Forever, so
`ScanSpellbook` is never called there and the "what you've learned" panel stays
empty forever on two of the three client targets.

**Fix:** register both `LEARNED_SPELL_IN_TAB` and `LEARNED_SPELL_IN_SKILL_LINE`,
handle either in the dispatcher.

**Impact:** `Rogue.lua` only.
**Performance:** none — correctness fix (feature currently silently
nonfunctional on 2 of 3 targets).
**Dev time:** ~15 min + [G] test on Forever and/or Retail with a rogue
character: train a new ability, confirm it appears in the tab; cross-check
`/tuff client`'s rejected-events list before/after.

### P1.12 — Automation's dialog-title fallback can permanently poison the persistent quest-name cache

`Automation.lua:69-81`. Falls back to resolving a quest name from whatever
dialog happens to be open (no uniqueness guarantee, unlike `Core.ResolveQuest`'s
live-log-only approach) and persists the match into `TuFFlevelsDB.questNames`
when `step.ambiguous` isn't set. An imported route (spreadsheet/RXP) that
missed hand-flagging a duplicate-named chain quest as `ambiguous` gets a wrong
ID permanently and persistently bound on that character.

**Fix:** don't call `Compat:SaveNameCache()` from this fallback path — bind
`step.quest` for the current session only, or require a confirming
`QUEST_ACCEPTED` read from the live log before persisting.

**Impact:** `Automation.lua` only.
**Performance:** none — correctness fix.
**Dev time:** ~20 min + [G] test: an imported route with an un-flagged duplicate
quest name, auto-accept it, confirm `TuFFlevelsDB.questNames` isn't polluted.

### P1.13 (corroborated by two independent audit passes) — `step._pathIndex` never resets on backtrack

`Data.lua:316-332`. `EffectiveTarget` advances `step._pathIndex` monotonically
on the shared route step table and nothing ever resets it — not `Core:Back`,
not `Core:SetIndex` moving backward, not `/tuff reset`, not a death/corpse-run.
After any backward movement through a multi-point `path` step, the arrow skips
straight to a later waypoint (or the final destination) instead of re-walking
the authored path, for the rest of the session on that step.

**Fix:** clear `_pathIndex` (and `_eventDone`) on any step between the old and
new index whenever `Core:SetIndex` moves backward.

**Impact:** `Core.lua` (`SetIndex`) + `Data.lua` (no change needed there beyond
what P1.13 already touches). Self-contained.
**Performance:** none — correctness fix.
**Dev time:** ~20 min + [G] test: walk partway through a multi-point path step,
die and release nearby (or `/tuff back`), confirm the arrow re-walks from the
first unvisited point rather than jumping ahead.

---

## Phase 2 — second-tier hot-path and hygiene fixes

Real cost, but either lower-frequency than Phase 1's items or masked by
WoW's incremental GC rather than actively breaking something.

| # | Item | Where | Fix | Dev time |
|---|---|---|---|---|
| P2.1 | `Compat:Guard`/`Wrap` allocate a `{pcall(...)}` results table on every call — the shared root cause of most GC churn found across the whole audit | `Compat.lua:618,627,673` | Fixed-arity fast path (`local ok,a,b,c,d = pcall(fn,...)`) for the common case; keep the table form as `Compat:GuardPack` for the one caller (`GetItemSellPrice`) that needs `result[11]` | ~30 min |
| P2.2 | `Compat:Wrap`'s per-module error budget never decays — a burst of 5 unrelated errors anywhere permanently disables that module (including the whole step engine or slash dispatcher) for the rest of a multi-hour session | `Compat.lua:659-700` | Reset `moduleCounts[name]` if the last error for that module was >~5 min ago; add an `onTrip` for `"Core"` that tells the player auto-advance is off | ~30 min |
| P2.3 | `GetQuestIDByName` bulk-copies the whole name cache into itself on every miss; `SaveNameCache` copies the entire cache into SavedVariables on every resolve | `Compat.lua:569-604` | Single-key lookup/write instead of a full-table copy | ~20 min |
| P2.4 | `Data:IsFlightPathKnown`/`IsQuestObjectiveDone` allocate a fresh taxi-node/objective table on every call, hit hard by full-route walks (Progress, `/tuff verify`) | `Data.lua:66-79,132-138` | Memoize `GetAllTaxiNodes` per mapID with a short TTL or explicit invalidation | ~25 min |
| P2.5 | `Compat:MapID` re-lowercases and does two lookups per call despite being on Arrow's 20 Hz path and every step of a route walk | `Compat.lua:517-525` | Memoize on the step (`step._mapID`) or a `mapIDCache[zone]` table | ~15 min |
| P2.6 | `UI:Refresh()` does full work while the tracker window is hidden | `UI.lua:329-330` | Add `if not frame:IsShown() then return end` after the existing nil-check | ~10 min |
| P2.7 | `Core:CurrentSection` is an O(index) backward walk on every UI refresh — worst on long section-less (imported) routes | `Core.lua:189-196` | Cache `{sectionStep, sectionIndex, forIndex}`, recompute only when `Core.index` changes | ~20 min |
| P2.8 | `Data:SetWaypoint` stomps the player's own map pin on every step advance, and uses the step's final coords rather than `EffectiveTarget`, disagreeing with the arrow on `path` steps | `Core.lua:237,283`; `Data.lua:351-388` | Only set the waypoint when the target actually changed; use `EffectiveTarget` for consistency with the arrow | ~20 min |
| P2.9 | `Recorder.lua`'s NPC-capture branch runs on every NPC interaction even when recording is off | `Recorder.lua:388-402` | Move the `if not Recorder.active then return end` guard above the capture branch | ~10 min |
| P2.10 | `Recorder.lua`'s log has no cap; unbounded growth over a long session on clients where SavedVariables persist (Classic Era/Retail) | `Recorder.lua:97-133` | Warn at ~2000 entries, hard cap around ~10000 | ~15 min |
| P2.11 | Rogue's first spellbook scan stamps every pre-existing ability with the player's *current* level, not when it was actually learned; repeats every session on Forever since SavedVariables don't persist there | `Rogue.lua:551-560` | Seed a baseline snapshot at `PLAYER_LOGIN` with a `db.rogueSeeded` marker; only stamp a level for spells learned after the baseline | ~25 min |
| P2.12 | `Zones.lua` gives Alliance characters Horde-only zone guidance with no faction gate | `Zones.lua:19,121-153` | Gate on `Data:PlayerFaction()`; show an "Alliance zones not authored yet" message until `Zones.alliance` exists | ~15 min |

**Impact (Phase 2, aggregate):** concentrated in `Compat.lua` and `Data.lua`,
which every other module depends on — treat as its own pass with full
regression testing across all three client targets rather than folding into
Phase 1.
**Performance (Phase 2, aggregate):** cuts steady per-call GC churn (millions
of throwaway tables over a session) rather than fixing an active correctness
bug — real, but lower urgency than Phase 1's active bugs and hot loops.
**Dev time (Phase 2, aggregate):** ~2-3 hours.

---

## Phase 3 — minor/cosmetic cleanup (optional)

Not urgent; batch these into the same commit as whichever Phase 1/2 item
touches the same file, rather than a dedicated pass.

- Arrow re-computes map/distance twice per tick (`Bearing` then
  `EffectiveTarget` each call `GetBestMapForUnit`/`RealDistanceToStep`
  independently) and re-`SetText`s unchanged strings every tick —
  `Arrow.lua:50-77,235,250`.
- `Pace:XPPerHour` counts AFK/alt-tab time against wall-clock — `Pace.lua:215`.
- Route-picker button order is nondeterministic (`pairs` iteration) —
  `Panel.lua:621`; sort like `Core:AutoSelectRoute` already does.
- `Core:Reconcile`'s paranoia guard is a hardcoded `5000` vs. documented
  ~3000-step routes — `Core.lua:257`; use `#self.active.steps + 1`.
- `Data:RealDistanceToStep` is missing the `C_Map and` guard that
  `Data:SetWaypoint` has, so it can throw on a client without `C_Map` from
  inside the 20 Hz arrow loop — `Data.lua:283`.
- `TuFFlevelsDB.questNames` has no eviction path, unbounded (but small — a few
  hundred KB even in the worst case) — `Compat.lua:600-604`.
- `Rogue.lua:522-547` registers `CHAT_MSG_SYSTEM` with no handler branch — dead
  registration, drop it or wire it up.
- `SheetImport.lua:302` — `levels = {1, 1}` written into exported routes when
  no source row carried a level.
- `CompactGuide.lua:138` — quoted-value parser can't represent an embedded `"`.
- Marker: stale marker possible if `GetNamePlateForUnit` returns nil during
  `NAME_PLATE_UNIT_REMOVED` — `Marker.lua:454-459`; self-corrects on next
  `NAME_PLATE_UNIT_ADDED` unless `IsRestricted()` short-circuits first. Key
  `active` by unit token as a belt-and-braces fix.

**Impact:** scattered one-line fixes, no cross-module risk.
**Performance:** negligible individually.
**Dev time:** ~1 hour if bundled in, otherwise skip without much lost.

---

## Done when

- [ ] Phase 1 (P1.1-P1.13) implemented and committed.
- [ ] `luacheck` and `busted spec/` green in CI on the branch/commit.
- [ ] [G] verification pass for each Phase 1 item per its own line above,
      covering at minimum: Forever (for P1.2, P1.11, P1.12's SavedVariables-
      adjacent behavior) and one non-Forever target (for anything that touches
      persisted SavedVariables state, e.g. P1.6, P1.10).
- [ ] Phase 2 (P2.1-P2.12) implemented and committed as a separate pass, with
      its own regression check since it touches the shared `Compat.lua`/
      `Data.lua` surface every module depends on.
- [ ] Phase 3 items folded into whichever Phase 1/2 commit touches the same
      file, or explicitly deferred with a one-line note why.
