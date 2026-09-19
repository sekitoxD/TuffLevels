# Plan 1: Bug fixes from the initial audit

Branch: `initial_audit`
Source: audit of the repo on 2026-09-18 (Forever beta day 2).

There is no headless Lua runner for WoW, so every task has a **Verify** line. It says
whether it can be checked in a plain Lua interpreter (P) or only in the game client (G).

Ground rules from `CLAUDE.md` still apply:
- Route all client detection through `Compat`.
- All event registration goes through `Compat:RegisterEvents`.
- `Data.lua` is the only file that touches QuestieDB.
- No secure snippets.

---

## Phase 0: Confirm the assumptions (30 min, in game)

Three of the fixes rest on things I could not check from outside the client. Do these
first on the Forever beta (and Classic Era or Retail if available) and write the results
at the bottom of this file.

| # | Check | Command | Why |
|---|---|---|---|
| 0.1 | Lua `atan` semantics | `/run print(math.atan(1,-1), math.atan2 and math.atan2(1,-1))` | Decides fix 1.1 |
| 0.2 | Which TOC the client loads | `/tuff client` | The `_Mainline` suffix is unverified on Forever |
| 0.3 | `SetCVar` return value | `/run print(SetCVar("nameplateShowFriends", 1))` | Decides fix 1.6 |
| 0.4 | Spellbook bank argument | `/run print(Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player)` | Decides fix 1.8 |
| 0.5 | Do accept/turn-in calls need a hardware event? | See Plan 2, Phase C spike | README claim (fix 1.9) |

---

## Phase 1: Correctness bugs

### 1.1 Arrow bearing uses a one-argument `math.atan`

- **File:** `Arrow.lua:44`
- **Problem:** `math.atan(dx, -dy)` passes two arguments. WoW runs Lua 5.1, where `math.atan`
  takes one argument, so the bearing is probably wrong. The arrow is the headline feature.
- **Fix:**
  - Add a local `Atan2(y, x)` in `Compat.lua` (`Compat.Atan2`).
  - It uses `math.atan2` if present.
  - Otherwise it uses `math.atan(y / x)` with quadrant correction, and handles `x == 0`.
  - Replace the call in `Arrow.lua`.
- **Also check:** the rotation sign in `tex:SetRotation(-angle)` once bearing is correct.
  Walk toward a known coordinate and confirm the arrow points at it.
- **Verify:** (P) table-test `Atan2` against the four quadrants and the axes.
  (G) walk toward a target and check the arrow.

### 1.2 `Back` and `goto` are undone by `Reconcile`

- **Files:** `Core.lua:170-187`, `211-217`, `486-491`, `514-518`; `UI.lua:236`; `Progress.lua:180`
- **Problem:** `Reconcile` advances past any step where `IsStepDone` is true. After Back
  lands on a completed quest step, the next quest event (within about 0.3 s) pushes it
  forward again. `goto` calls `Reconcile` immediately, so it does the same. `UI.lua` and
  `Progress.lua` assign `Core.index` directly and have the same problem.
- **Fix:**
  1. Add `Core:SetIndex(n, opts)` as the only place `self.index` is assigned. It clamps
     to `1..#steps+1`, saves, refreshes UI, marker, waypoint and panel, and does not call `Reconcile`.
  2. Add `Core.pinned`. Set it to `true` by any manual navigation (Back, `goto`, Progress
     jump, section jump).
  3. While `pinned`, `Reconcile` returns without advancing.
  4. Clear `pinned` in `Advance` (the Next button), `LoadRoute`, and a new
     `Core:Resume()` (fast-forward, see Plan 2 item A3).
  5. The tracker shows a small "Paused here. Next or Resume to continue" hint while pinned.
  6. Replace the direct assignments in `Core.lua:489`, `Core.lua:515`, `UI.lua:236` and
     `Progress.lua:180` with `SetIndex`.
- **Decision to confirm with the author:** pin until the user acts, versus auto-clear once
  the pinned step becomes newly done. This plan picks pin until the user acts, because it
  is predictable and needs no edge detection.
- **Verify:** (P) stub `Data` and `Compat`, mark steps done, call `Back`, fire `Reconcile`,
  assert the index does not move. (G) accept, complete and turn in a quest, hit Back, do a
  quest action, and confirm the tracker stays put.

### 1.3 Unwrapped handlers and one shared error budget

- **Files:** `Compat.lua:199-222`, `Arrow.lua:110-115`, `Core.lua:319-340`,
  `Marker.lua:281-295`, `Recorder.lua:349`, `Rogue.lua:402`
- **Problem:**
  - `Compat:Guard` only wraps individual API calls, not the handlers. An error in
    `Arrow:Update` at 20 Hz can hit Forever's 100-error cap in about 5 seconds and hide
    every other addon's errors.
  - The 10-error budget is global, so after it is spent every guarded call in every
    module silently returns nil. The addon looks half-dead with no explanation.
- **Fix:**
  1. Add `Compat:Wrap(name, fn)` that returns a function running `fn` under `pcall`.
  2. Give each `name` its own counter, with a total ceiling of about 30 (well under
     the client's 100).
  3. De-duplicate by message: an identical error reports once, then only counts.
  4. On a module hitting its limit, call an optional `onTrip` callback instead of going
     silent. For `Arrow`, that hides the frame and prints one message.
  5. Wrap every `OnUpdate`, `OnEvent` and slash handler.
  6. `/tuff errors` prints per-module counts and the last error for each.
- **Verify:** (P) test that a throwing function trips at the limit and calls `onTrip`, and
  that one module tripping doesn't affect another. (G) temporarily inject an error into
  `Arrow:Update` and confirm one message and a hidden arrow.

### 1.4 Non-deterministic route selection

- **File:** `Core.lua:236-251`
- **Problem:** `AutoSelectRoute` iterates with `pairs()`. Both shipped routes match Horde
  Orc/Troll, and on Forever the saved route is lost every launch, so the route picked can
  differ between launches.
- **Fix:**
  - Collect matching routes into a list and sort deterministically.
  - Prefer routes with `sample ~= true` and `skeleton ~= true`, then `levels[1]` ascending,
    then name.
  - Mark `Routes/Durotar.lua` with `sample = true`.
  - Log which route was auto-selected and why, once, in chat.
- **Verify:** (P) register three routes in shuffled order and assert the same choice each time.

### 1.5 `/tuff verify` rejects name-based steps

- **File:** `Data.lua:130-142`
- **Problem:** Spreadsheet-imported steps carry `questName` and no `quest`. `ValidateRoute`
  reports "missing numeric quest ID" for every one of them.
- **Fix:**
  - A quest step is valid if it has a numeric `quest` or a non-empty `questName`.
  - Count name-only steps under a separate `unresolved` total and report them as info
    ("N steps resolve by name at runtime"), not as problems.
  - Return `problems, unknown, unresolved`.
  - Update the caller in `Core.lua:409-423`.
- **Verify:** (P) validate a route that mixes numeric and name-only steps.

### 1.6 Misleading nameplate CVar message

- **File:** `Marker.lua:236-245`
- **Problem:** `Compat:Guard` returns the wrapped function's results, and `SetCVar` returns
  nothing, so `ok` is always nil and the code always prints "Could not change nameplate
  settings".
- **Fix:**
  - Call `pcall(SetCVar, ...)` directly.
  - Confirm success by reading `GetCVar` back.
  - Print success or failure based on that.
  - `SetCVar` is blocked in combat: detect `InCombatLockdown()` and say "try again out of combat".
- **Verify:** (G) toggle with `/tuff plates`, in and out of combat.

### 1.7 QuestieDB access likely wrong (Classic Era only)

- **File:** `Data.lua:23-75`
- **Problem:** `_G.QuestieDB` is probably not a real global, and `h:GetQuest(id)` passes
  `h` as the ID if `GetQuest` is a dot-function. These are from memory and unverified;
  the README already flags them as assumptions.
- **Fix (lowest priority, Forever has no database):**
  - Read Questie's source and `docs/api.md`.
  - Prefer `QuestieLoader:ImportModule("QuestieDB")`.
  - Use the correct call form.
  - Record the verified signatures in the file header.
  - Keep the "works with no provider" guarantee. Do not bundle any Questie data
    (GPL-3.0, see README "Licensing").
- **Verify:** (G, Classic Era) `/tuff verify` on the Durotar route with Questie installed.

### 1.8 Rogue spellbook scan passes a wrong bank argument

- **File:** `Rogue.lua:435-443`
- **Problem:** `Compat:Guard(getInfo, i, 2)` uses `2` as the "bank". The modern
  `C_SpellBook.GetSpellBookItemName` expects an `Enum.SpellBookSpellBank` value
  (`Player`), so the scan may return nothing or the wrong list.
- **Fix:**
  - Use `Enum.SpellBookSpellBank.Player` when it exists, else the legacy `"spell"` book
    type for the old global.
  - Move the call into a `Compat:GetSpellBookName(i)` shim.
  - Feature-gate it on the Phase 0.4 result. `GetSpecialization` is absent on Forever, so
    don't build on spec APIs.
- **Verify:** (G) log in as a rogue and run the scan.

---

## Phase 2: Forever-specific data loss

### 2.1 Recording silently stops and is lost between launches

- **Files:** `Recorder.lua:106-141`, `Compat.lua:79-102`, `Panel.lua`
- **Problem:** The recorder is the addon's main data source on Forever, since no quest
  database exists. It keeps the log and the `recording` flag in SavedVariables. Forever
  writes SavedVariables on exit but never restores them, so the flag is false and the log
  is empty on next launch. Recording just stops.
- **Fix:**
  1. When `Compat:SavedVarsAreBroken()`, show a persistent status line in the tracker while
     recording: "N steps recorded. Export before you log out."
  2. Auto-open the export window when the player logs out is not possible (no logout hook),
     so instead nudge every 25 recorded steps and on `PLAYER_LEAVING_WORLD`.
  3. On login with recording expected but not restored, print one clear warning that
     recording was reset, and ask the user to click Start again.
  4. Add `tools/extract_recording.py`. It parses
     `WTF/Account/<ACCT>/SavedVariables/TuFFlevels.lua` (still written on exit) and prints
     the route file, so a lost session can be recovered from disk.
  5. Document the recovery path in `HOW-TO-USE.md`.
- **Verify:** (P) run the extractor on a sample SavedVariables file.
  (G) record steps, exit the game, run the tool, and compare the output with the export window.

---

## Phase 3: Content and documentation

### 3.1 Correct the auto-accept claim (README:107)
The README says auto-accept and auto-turn-in are "blocked on every client, no workaround"
and "same limitation RestedXP has". RestedXP advertises those features and lists Forever.
Reword to: "Not implemented yet. Whether the required calls are allowed on Forever is under
investigation (Plan 2, Phase C)." Update the matching line in `CLAUDE.md` if present.

### 3.2 Placeholders and consistency
- Replace `## Author: you` in all three TOCs and `author = "you"` in `Routes/Durotar.lua`.
- Make chat messages use one canonical command, `/tuff`, with `/sl` documented as an alias.
  Touch `Compat.lua:211` and `Core.lua:520-524`.
- Mark `Routes/Horde1-60.lua` clearly as a skeleton in `/tuff routes` output (it already
  has `skeleton = true`; show it).
- Mark the Durotar IDs as unverified in `/tuff routes` and stop auto-selecting it (fix 1.4).
- Confirm the Forever quest IDs by recording them in the beta (levels 1-20 for now).
  Don't ship Classic Era IDs as Forever data.

### 3.3 Route through `InitSavedVar`
`Arrow.lua:74,103` touch `TuFFlevelsDB` directly. Use `Compat:InitSavedVar("TuFFlevelsDB")`
so the Forever in-session cache stays consistent.

### 3.4 TOC audit
- Confirm which TOC Forever loads (Phase 0.2). If the `_Mainline` suffix is not picked up,
  fall back to the un-suffixed `TuFFlevels.toc`, which already lists `16001`.
- Keep `16001` first in the `## Interface` line for Forever.

---

## Phase 4: Tooling so this stays fixed

1. `.luacheckrc` with the WoW globals used by this addon. Run `luacheck .` and fix the
   findings. This is the cheapest way to catch typos, unused variables and accidental
   globals.
2. `.github/workflows/lint.yml` running `luacheck` on push and PR.
3. `tools/validate_routes.lua`: loads every `Routes/*.lua` with a stub `ns.RegisterRoute`
   and runs the structural checks from `Data:ValidateRoute` outside the game.
4. `spec/` with `busted` tests for the pure logic: `IsStepDone`, `StepApplies`,
   `Reconcile`, `SetIndex` and pinning, `AutoSelectRoute`, `ValidateRoute`, `Compat:Wrap`.
   Stub `Data` and `Compat`.
5. `.pkgmeta` so the BigWigs packager can build release zips.

---

## Order of work

1. Phase 0 checks.
2. 1.1 (arrow), 1.2 (Back), 1.3 (error handling). These affect every user.
3. 1.4, 1.5, 1.6, 2.1.
4. 3.1-3.4 (docs and placeholders).
5. Phase 4 tooling. Doing this earlier is fine and makes 1.x safer, so pull step 1 of
   Phase 4 forward if possible.
6. 1.7, 1.8 last.

## Done when

- `luacheck` passes with no warnings.
- `busted` passes.
- On the Forever beta: the arrow points at a known target, Back sticks, no error spam
  after 10 minutes of play, and a recording can be recovered after a relog.

## Phase 0 results (fill in)

- 0.1:
- 0.2:
- 0.3:
- 0.4:
- 0.5:
