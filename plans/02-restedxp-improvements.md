# Plan 2: Features inspired by RestedXP, and how to improve on them

Status: **rewritten 2026-09-20** after an audit found ~90% of the original plan already
shipped. See `.claude/checkpoints/2026-09-20-plan-02-restedxp-audit.md` for the audit
record (which scout confirmed what, with file:line references). This document now
describes only the work still remaining.

Depends on: `plans/01-bug-fixes.md` Phases 1.1-1.3 — confirmed done in code (`Compat.Atan2`,
`Core.pinned`/`Core:SetIndex`, and wrapped handlers via `Compat:Guard` all exist across
Core.lua/Arrow.lua/Compat.lua), even though that plan's own "Phase 0 results" section
was never filled in. No blocker here.

## What this plan is and is not

RestedXP (RXP) is a leveling addon with a free client and paid speedrun guides.
**What we copy:** the feature ideas. **What we do not copy:** its guide content or
route data, its code, or its guide syntax verbatim. See the original plan's intro
(preserved below in git history) for the full disclaimer — unchanged by this rewrite.

**Non-goals (from the README, still in force):** no algorithmic route generation, no
bundled QuestieDB data, no secure snippets, the addon must keep working with no quest
database.

## Already shipped (verified against source 2026-09-20, not re-planned here)

- **Phase A** — auto-detect for `travel`/`hearth`/`trainer`/`death`/`flightpath`
  (Core.lua), the `Compat.has` capability table (Compat.lua:55-60), `Core:Resume`/
  catch-up scan/progress codes (`/tuff code`, Core.lua:305-415).
- **Phase B** (mostly) — real-yard distance via `Data:RealDistanceToStep`
  (Data.lua:278-296), multi-waypoint `step.path` via `Data:EffectiveTarget`
  (Data.lua:306-330), colorblind palette / scale / text-only arrow modes, and
  `Data:SetWaypoint` TomTom+native handoff (Data.lua:346-383).
- **Phase C** (mostly) — step-matched auto accept/turn-in with Shift bypass and an
  on/off toggle (Automation.lua), gossip auto-select, and the nameplate targeting
  helper (Marker.lua).
- **Phase D** (mostly) — personal-best splits, XP/hour, level ETA, text export
  (Pace.lua).
- **Phase E** — `objective`, the `xp` step type, `optional`, `skipIfLevel`, `requires`
  with a cycle guard, and the CompactGuide.lua original line syntax. All documented in
  the Durotar.lua route header and enforced by `Data:ValidateRoute`.
- **Phase F** — `tools/merge_routes.py` (median-coordinate merge with conflict
  reporting), `tools/extract_recording.py`, `tools/validate_route.py`, and
  `CONTRIBUTING.md`'s record/export/PR workflow.
- **Phase G** (mostly) — `Compat:HasSecretRestrictions`, Marker.lua pausing under
  instance/secret restrictions, and the `/tuff debugrestrict` test hook.

Do not re-implement or "improve" any of the above as part of this plan without a new,
separately audited reason — it works and is covered by existing behavior.

---

## Remaining work

### R1. Locale-only objective-name parsing in Marker.lua

- **File:** `Marker.lua:52-56`
- **Problem:** `ObjectiveNames()` strips a kill-objective's trailing verb with
  hardcoded English patterns (`slain`, `killed`, `destroyed`). On any non-English
  client locale, the verb won't match, the leftover text won't equal the nameplate
  name, and the objective-mob marker silently never appears — it fails closed with no
  error, so it's easy to miss.
- **Fix:** Add a small `LOCALE_SUFFIXES` lookup keyed by `GetLocale()` (enUS/enGB,
  deDE, frFR, esES/esMX, ptBR, ruRU, itIT, koKR, zhCN, zhTW — the locales WoW ships),
  each holding the verb suffixes that locale's client appends to a kill objective.
  Fall back to the English list for any locale not in the table. This is a mitigation,
  not a perfect fix — Blizzard doesn't expose the raw target name via
  `C_QuestLog.GetQuestObjectives`, so text-parsing is unavoidable; the fix scopes the
  regex per locale instead of assuming English everywhere.
- **Impact:** Contained to one function in one file (`Marker.lua`). Nothing else calls
  `ObjectiveNames`. No schema change, no cross-module dependency.
- **Performance:** Zero measurable cost — same regex work as today, just locale-keyed.
  Runs only when the objective mob set is recomputed (on quest log update, already
  throttled elsewhere), not per-frame.
- **Dev time:** ~20-30 minutes, including sourcing correct per-locale suffixes.

### R2. `via` field for cross-zone travel steps

- **Files:** `Data.lua` (schema/validation, `EffectiveTarget`), `Arrow.lua` (display),
  `Routes/Horde/Durotar.lua` header (docs)
- **Problem:** `step.path` multi-waypoint routing works, but a travel step that
  crosses maps has no way to name *why* the intermediate point exists (zone gate,
  boat, tram, flight master). The arrow already shows "Via: " for in-path steps
  (Arrow.lua:255) but has no transition-type label to show alongside it.
- **Fix:** Add an optional `via = "gate" | "boat" | "tram" | "flightpath"` (free-form
  string is fine; no need for an enum) on a `path` waypoint entry. `Data:ValidateRoute`
  accepts it as an optional string, no new validation failure modes. `Arrow.lua`'s
  existing "Via: " line appends the label when present (e.g. "Via: Boat to
  Menethil").
- **Impact:** Additive, optional field — existing routes with no `via` field are
  unaffected (`nil` just means no label, same as today). Touches `Data.lua`'s
  validator and one display line in `Arrow.lua`. No behavior change to routing.
- **Performance:** None — read once when the arrow row is drawn, not per-frame.
- **Dev time:** ~30-45 minutes, including updating the Durotar.lua schema-header
  comment (the authoritative field reference).

### R3. Reward-choice call-out in Automation.lua — DONE (2026-09-20, scoped down)

- **File:** `Automation.lua`, new `Compat:GetItemSellPrice` wrapper in `Compat.lua`.
- **Shipped:** On `QUEST_COMPLETE` with more than one reward choice, each choice's
  item link (`GetQuestItemLink("choice", i)`) is scored by vendor sell price via the
  new `Compat:GetItemSellPrice` (tries `C_Item.GetItemInfo`, falls back to the global
  `GetItemInfo` for Classic Era), and the best one is named in a chat line. Nothing is
  auto-selected.
- **Scope change from the original idea:** the original wording said "highlight the
  best-scoring button with a glow/border." That was dropped in favor of a chat
  call-out during implementation, because the actual reward-choice frame's name and
  layout differ between Classic Era and Forever/Retail, this addon has no way to test
  either client's live frame without loading it in-game, and getting a UI-frame guess
  wrong risks visibly breaking Blizzard's own quest frame. The chat call-out delivers
  the same "point at the best choice without picking it" goal without that risk.
  Class-usability scoring (the other half of the original idea) was also dropped —
  sell price alone is enough signal for a first pass, and a class-usability table is
  new scope, not a quick addition.
- **Impact:** matches the original estimate — contained to `Automation.lua` +
  `Compat.lua`.
- **Performance:** as estimated — a few sell-price lookups only when a multi-choice
  turn-in is open, not per-frame.

### R4. Per-step Pace timing — DONE (2026-09-20)

- **Files:** `Pace.lua` (`Pace:RecordStepSplit`, `Pace:BestStepTime`,
  `Pace:StepDeltaVsBest`, called from `Pace:OnStepAdvance`).
- **Shipped:** cumulative time-since-run-start is recorded per step index into
  `db.paceBest[routeName].steps[stepIndex]` (keeps only the best, same model as the
  existing per-section `RecordSplit`), alongside the existing per-section data — no
  change to the section mechanism.
- **Impact/performance:** as estimated — additive table, one more record per step
  advance (event-driven, not per-frame).

### R5. Live ghost/timeline visual in Pace — DONE (2026-09-20)

- **Files:** `Pace.lua` (`Pace:StepDeltaVsBest`), `Progress.lua` (Refresh's existing
  pace block, plus a new `C_Timer.NewTicker(2, ...)` calling `Progress:Refresh()`).
- **Shipped:** the Progress window's existing pace line now also shows a live
  "+0:32 behind" / "0:14 ahead" delta at step granularity (color-coded green/red),
  computed against R4's best-step-time data. A 2-second ticker keeps it moving
  between quest events; `Progress:Refresh()` already no-ops while the window is
  hidden (existing guard, confirmed before relying on it), so the ticker costs
  nothing while Progress isn't open. This reuses the tracker/Progress window rather
  than building a new frame, per the impact note in the original plan.
- **Impact/performance:** as estimated — small UI hook, bounded 2s ticker cost only
  while the window is shown.

### R6. Settings panel using the Retail Settings API — DONE (2026-09-20)

- **Files:** `Compat.lua` (new `Compat.has.settingsAPI` entry), `Panel.lua` (new
  `Panel:RegisterSettingsCategory`/`MakeSettingsToggle`), `Core.lua` (calls it once
  from the `PLAYER_LOGIN` handler, right after `Panel:Build()`).
- **Shipped:** a vertical-layout Settings category (Game Menu → Options → AddOns)
  with 5 checkboxes wired to the same module state Panel.lua's existing buttons
  drive: automation on/off, NPC markers on/off, objective-mob markers on/off, arrow
  colorblind palette, arrow text-only mode. No new SavedVariables. Gated entirely
  behind `Compat.has.settingsAPI` (checks `Settings` plus the four specific
  functions used, not just namespace presence), so Classic Era — which has no
  `Settings` global — never executes any of this code.
- **Known verification gap:** the exact call signature of
  `Settings.RegisterProxySetting`/`Settings.CreateCheckbox` could not be confirmed
  against a live client from a non-interactive environment. Every call is wrapped in
  `Compat:Guard`, so a wrong guess degrades to "this checkbox doesn't register"
  rather than an error cascade — but **this needs a live in-game check on Forever or
  Retail** (open Game Menu → Options → AddOns → TuFFlevels, confirm all 5 checkboxes
  render and correctly reflect/change state) before calling R6 fully verified. Since
  `Toggle()`/`ToggleMobs()`/etc. are flip-only (not `SetEnabled(bool)`), each setter
  only calls the real toggle when the requested value differs from current state —
  double-check in-game that checkboxes don't desync from actual state on first open.
- **Impact/performance:** as estimated — additive UI, one-time registration cost at
  login, no effect on Classic Era.

---

## Suggested order

R1 and R2 are small and independent — do first. R3 needs a new Compat wrapper, so do
it before R4/R5 in case the wrapper pattern informs anything there (it shouldn't, but
sequencing avoids two people, or two sessions, touching Compat.lua at once). R4 before
R5 since R5 depends on R4's per-step data. R6 is independent of all the others and can
happen any time, including in parallel.

## Forever constraints that still apply

- Beta level cap 20 until Oct 7, 30 until Oct 21 (beta ends), launch Nov 4, 2026 —
  unchanged from the original plan and still the live schedule as of today (2026-09-20).
- All new API surface (Settings API, item-info wrapper) goes through `Compat`, checked
  by presence, not by `Compat.isForever`/build number.
- No secure snippets — none of R1-R6 need one.

## Done when

All six items (R1-R6) are implemented as of 2026-09-20 — see each section above for
what shipped. What's left is in-game verification, since none of this could be
playtested from this environment:

- [ ] R1: on a non-English client (or a locale override, if testable without a
  second client), the objective marker still appears on a kill step.
- [ ] R2: a route with a `via`-annotated multi-map travel step shows the label in the
  arrow's "Via:" line, and `/tuff verify` still passes.
- [ ] R3: completing a multi-choice quest with automation on prints the best-value
  reward call-out without auto-selecting anything.
- [ ] R4/R5: the Progress window shows a live ahead/behind delta at step granularity
  that updates every ~2 seconds while open.
- [ ] R6: Game Menu → Options → AddOns → TuFFlevels shows all 5 checkboxes,
  correctly reflecting and changing real state (see R6's verification-gap note).
