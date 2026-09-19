# Plan 2: Features inspired by RestedXP, and how to improve on them

Branch: `initial_audit`
Depends on: `plans/01-bug-fixes.md` Phases 1.1-1.3 (arrow, Back, error handling) being done.

## What this plan is and is not

RestedXP (RXP) is a leveling addon with a free client and paid speedrun guides. Its
[CurseForge listing](https://www.curseforge.com/wow/addons/restedxp-guide) advertises:

- an optimized quest path
- auto quest accept and turn-in
- other automation options
- NPC targeting through a macro
- a customizable arrow
- a customizable UI
- a leveling time tracker
- custom guides

It lists Retail, Forever, MoP Classic, Classic and TBC.

**What we copy:** the feature ideas.

**What we do not copy:**
- RXP's guide content or route data.
- Its code.
- Its guide syntax verbatim.

Its guides are a commercial product. The DSL notes below are from my own knowledge, not
from fetched docs (the RXP docs returned 403), so treat them as a design reference and check
the RXPGuides repo license before reusing anything.

**Non-goals (from the README, still in force):**
- No algorithmic route generation. Routes stay hand-authored data.
- No bundled QuestieDB data.
- No secure snippets.
- The addon must keep working with no quest database.

## Forever constraints that shape everything here

- API is the Midnight 12.x set. Port from Retail, not Classic.
- Secret-value restrictions apply, mostly in combat and instances. Quest log, maps and
  waypoints are not restricted, but nameplate unit names can become secret in instances.
- No quest database exists for Forever. The Recorder plus crowdsourcing is the data story.
- Beta level cap: 20, rising to 30 after two weeks (beta ends Oct 21). Launch is Nov 4,
  2026. Route work above level 30 cannot be tested until launch.
- SavedVariables do not restore on the beta. Design for state that can be rebuilt from the
  quest log.

---

## Phase A: Quick wins (small, low risk)

### A1. Auto-detect the manual step types
Today `travel`, `hearth`, `trainer` and `death` are never auto-detected (`Core.lua:87-91`).
Detect them instead of making the user click Next.

| Step type | Detect completion by |
|---|---|
| `travel` | Player within N yards of the step's coordinates, or reached the target map (see B1 for yards) |
| `hearth` | Bind location or zone change after using the Hearthstone. Choose events in a spike; wrap them with `Compat:RegisterEvents` |
| `trainer` | `TRAINER_CLOSED` after `TRAINER_SHOW`. Optionally also a level or spell-learned check |
| `death` | `PLAYER_DEAD`, then `PLAYER_ALIVE` or `PLAYER_UNGHOST` |
| `flightpath` (new) | Taxi node known. Use the `C_TaxiMap` node state if present |

- Each new event goes through `Compat:RegisterEvents` and is listed in `/tuff client` if rejected.
- **Acceptance:** a route with these step types advances with zero clicks.

### A2. Capability table instead of flavor checks
Adopt the pattern used by other Forever ports: a `Compat.has` table.
- Keys such as `has.specs`, `has.questDB`, `has.secretValues`, `has.taxiMap`.
- Each key is true only if the API is present and not on a known-absent list.
- Feature code asks `Compat.has.x`, not `Compat.isForever`.
- **Acceptance:** no `isForever` checks outside `Compat.lua` (except the SavedVariables logic).

### A3. Fast-forward and progress recovery
Forever loses SavedVariables, so the step index resets on every launch. `Reconcile` heals
only if every step before the real position is auto-detectable.
- `Core:Resume()`: scan forward and jump to the last step whose quest flag is done. This
  also clears the pin from Plan 1 fix 1.2.
- Ask on login when index is 1 but quest flags say the player is further along: "You
  look further along. Jump to step N?"
- **Progress code:** a short code (route id, step index, checksum) shown in the tracker with
  a Copy button, plus `/tuff code <code>` to restore it.
- **Acceptance:** relog on Forever, accept the prompt, land within one step of the true position.

---

## Phase B: Arrow and navigation

### B1. Real distance
`Arrow.lua:53` uses `map fraction * 1000`, which is not yards.
- Use `C_Map.GetWorldPosFromMapPos` for the target and `UnitPosition("player")` for the
  player. Compute yards, not map fraction.
- Fall back to the current estimate with a `~` prefix when the real value is unavailable.
- **Acceptance:** a distance readout that matches an in-game measurement to within a few yards.

### B2. Multi-waypoint steps and cross-zone travel
- A step may carry `path = { {map, x, y}, ... }`. The arrow points at the next point.
- If the target is on another map, point at the nearest known transition (zone edge,
  boat, tram, flight master) instead of showing "--". Add `via = {...}` on travel steps
  and let authors supply it.
- **Acceptance:** an Orgrimmar to Durotar travel step points at the gate, then the target.

### B3. Arrow polish
- Colorblind-safe palette option, size and scale settings, and a minimal text-only mode.
- Optionally hand off to TomTom, or use the native super-tracked waypoint, if the user prefers
  (`Data:SetWaypoint` already does both).

---

## Phase C: Automation (the biggest gap versus RXP)

### C0. Spike first (1-2 hours, in the Forever beta)
Determine whether `AcceptQuest`, `CompleteQuest`, `GetQuestReward`, `SelectGossipOption`
and `SelectAvailableQuest`/`SelectActiveQuest` (or their Retail equivalents) work
from an event handler without a hardware event on Forever. Record the results in
Plan 1 Phase 0.5. **If they are blocked, drop this phase and update the README to say so.**
I believe they are allowed, but I have not confirmed it.

### C1. Step-aware auto accept and turn-in (opt-in)
Better than a blanket "accept everything":
- Only act when the open quest matches the **current step** (`step.quest`).
- Accept on `QUEST_DETAIL` for `accept` steps. Turn in on `QUEST_COMPLETE` for `turnin` steps.
- Reward choice: never guess. If the quest has a choice, show a highlight on the best
  choice by the user's rule (vendor value, or class-usable upgrade) and let the user click.
- Gossip: auto-select the single matching option only when the step names the NPC.
- Shift held bypasses automation. A visible on/off toggle sits in the tracker.
- **Acceptance:** with automation on, a run through the Valley of Trials needs no dialog
  clicks; with it off, behaviour is unchanged.

### C2. Optional targeting helper
RXP offers a targeting macro. The unsecure alternative here is to highlight the NPC
(nameplate marker, already built) and print the name. Do not create secure macros or
snippets (see `CLAUDE.md`).

---

## Phase D: Pace tracking (improve on RXP's time tracker)

The Recorder already stamps entries with `t` (`Recorder.lua:99`).
- Per-step and per-section timing shown in the Progress window.
- Personal best splits stored per route, and an optional "ghost" (a saved run to compare
  against, ahead/behind by N minutes).
- XP/hour and level ETA from the actual step data.
- Export a run as text so players can share it (SavedVariables can't be relied on on
  Forever, so the export must work in-session).
- **Acceptance:** finishing a section shows time taken and delta versus best.

---

## Phase E: Route format

The engine stays a step engine. These add expressiveness for authors.

### E1. New step fields
- `objective = n` on `complete` steps: done when objective n of the quest is finished.
- `xp = { level = 12, pct = 50 }` step type: done at level 12 and 50% XP.
- `optional = true`: shown dimmed, skipped by Resume.
- `skipIfLevel = n`: skipped when the player is at or above level n.
- `requires`/`after`: step ids that must be done first, so out-of-order play is fine.
- Update the schema header in `Routes/Durotar.lua` and `Data:ValidateRoute`.

### E2. Compact guide syntax that compiles to step tables
Lua tables are hard for a first-time author to write. Add an optional line format,
loaded at runtime or converted offline, for example:

```
section Valley of Trials 1-6
accept 4641 npc=Kaltunk at=1411,42.6,68.8 "Right in front of you at spawn."
turnin 4641 npc=Gornek
xp 5
travel 1411,55.4,74.4 "Southeast along the road."
```

- `GuideImport.lua` already converts Guidelime-format text, so reuse its parsing scaffolding.
- Keep it a convenience layer. The step table stays the source of truth.
- Original syntax, not RXP's. The line above is a sketch, not a spec.
- **Acceptance:** the Durotar sample route can be written in the compact form and compiles to identical steps.

---

## Phase F: Crowd-sourced Forever routes

Since no database exists for Forever, this is the biggest opportunity.
1. **Versioned export.** The Recorder's export gets a `format = N` header, client build,
   date and character class/race, so recordings can be compared.
2. `tools/merge_routes.py`: merge multiple recordings into one route. Group by quest ID,
   take the median coordinates, keep the most common order, flag conflicts.
3. `tools/lint_route.lua` (from Plan 1 Phase 4) run in CI on every route PR.
4. A `CONTRIBUTING.md` explaining: record, export, open a PR.
5. Human review keeps the "authored, not generated" rule: tools assist, the author decides.
- **Acceptance:** two recordings of the same zone merge into a single route with a conflict report.

---

## Phase G: Safety and UX

- **Instance safety:** when `C_Secrets`/`C_RestrictedActions` report restrictions, or the
  player is in an instance, pause the nameplate markers and never compare secret names.
  Add a test hook so this can be checked outside an instance.
- **Settings panel** using the Retail Settings API (present on Forever), not the removed
  `InterfaceOptions` frames.
- **Localisation of objective parsing.** `Marker.lua:52-60` strips English suffixes only.
  Prefer the objective `type` and `numFulfilled` fields to text parsing.
- **Onboarding for a first-time author:** trim `Rogue.lua` out of the default load or
  ship it as an optional module. It is class-specific scope for a first addon.

---

## Suggested schedule (against the Forever timeline)

| When | Work |
|---|---|
| Now to Oct 7 (beta cap 20) | Plan 1. Phase C0 spike. Phase A. Record levels 1-20 in the beta |
| Oct 7 to Oct 21 (beta cap 30) | Phase B, Phase C if the spike passed, Phase F tooling. Record 20-30 |
| Oct 21 to Nov 4 | Phase D, Phase E, Phase G. Merge and review beta recordings. Re-verify APIs on the release build |
| Launch, Nov 4 | Record 30-60. Ship a first verified route for 1-30 |

Dates assume the beta level-cap schedule stays as announced. Blizzard may change it.

## Risks

- **Beta churn.** The Forever API may change before launch. Keep every client-specific
  call behind `Compat`.
- **Automation may be blocked** on Forever (spike C0). The plan works without it.
- **Data quality.** Crowd-sourced routes need review. Merge tooling reports conflicts and
  doesn't hide them.
- **Scope.** This is a lot for a first addon. The order above deliberately front-loads
  the cheap, high-value items (A1, A3, B1).
- **Legal.** Do not reuse RestedXP guide content, code or verbatim syntax.

## Done when

- A new character can play levels 1-20 on Forever with the arrow, markers and automatic
  step advance, with no manual Next clicks for quest, travel, hearth or trainer steps.
- A lost session can be restored (progress code or fast-forward).
- At least one route for the Forever starting zones is recorded, merged and CI-clean.
