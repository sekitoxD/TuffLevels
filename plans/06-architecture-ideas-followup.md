# Plan 6: Follow-up on the Architecture ideas list

Source: `Architecture/Ideas-for-architecture.md` (7 items, dictated by the user, session
cut off before it became a real plan — see `Architecture/last-update.md`).
Audited against the actual code on 2026-09-20 by an Explore pass that read every file
cited below directly (not just commit messages).

**Headline finding: 6 of the 7 items are already fixed on `master`.** Two commits already
on this branch predate this plan and resolve most of the list:

- `33c70fa` "Fix stale kill-objective display and reload-only palette, close event-report gap"
- `da6cfee` "Fix silently-broken Map/waypoint button and condense the menu (v1.5.0)"

So this plan is mostly a **verification checklist**, not new code. Only item 4 needs an
actual implementation decision. Every item still carries the impact/performance/dev-time
audit the user's standing rule requires, even the ones with no code change, so the size of
what's left is visible at a glance.

There is no headless Lua runner (per `CLAUDE.md`), so every verify line says whether it's
checkable by reading the code (already done, marked **[code-confirmed]**) or only in the
game client (marked **[G]**).

---

## Item 1 — Color palette not persisting across reload/relogin

**Status: fixed as far as Lua allows; no code change proposed.**

`Theme.presets` (`Theme.lua:71-127`) holds the built-in palettes; a user's choice is saved
to `TuFFlevelsDB.customTheme` (`Panel.lua:829-831`, `873-877`) and reloaded via
`Theme:LoadSaved()` on `PLAYER_LOGIN` (`Theme.lua:169-176`, `Core.lua:637-638`).
`TuFFlevelsDB` goes through `Compat:InitSavedVar` (`Compat.lua:143-160`) — the exact table
`CLAUDE.md` documents as subject to Forever's **un-fixable** "SavedVariables never restore
on login/reload" bug (`Compat:SavedVarsAreBroken`, `Compat.lua:162-164`). This is the same
root cause as every other persistence complaint on Forever, not a separate bug.

`33c70fa` already added `Theme:ReapplyAll()` (`Theme.lua:192-216`) so picking a palette
repaints every open frame immediately, in-session, without needing `/reload` at all — the
commit message explicitly notes `/reload` "may not even restore the saved palette" on
Forever, i.e. the author already knew this couldn't be fully fixed and worked around it by
removing the need to reload in the first place.

- **Impact:** none — no further code change proposed.
- **Performance:** n/a.
- **Dev time:** ~10 min, verification only.
- **Verify [G]:** on Forever, open the color picker, pick a preset, confirm every visible
  frame repaints without a `/reload`. Separately confirm the addon's existing
  `SavedVarsAreBroken()` login warning is what a player sees if they do `/reload` and the
  palette reverts — i.e. that the failure mode is "warned", not "silent".

## Item 2 — Kill/item objective counts not updating

**Status: fixed; no code change proposed.**

`UI.lua`'s `Objectives()` (`UI.lua:69-91`) reads live via `C_QuestLog.GetQuestObjectives`
— a modern API, not one of the Classic-only globals Forever dropped, so this was never a
Compat-shim gap. The actual bug: `Core:Reconcile()` (`Core.lua:248-288`) used to call
`ns.UI:Refresh()` only inside the `if moved then` branch, so a live "6/10 slain" count sat
frozen until the step itself advanced. `33c70fa` moved that refresh outside the `moved`
guard (`Core.lua:277-278`, comment at `272-276`), and `Reconcile` already runs on every
`QUEST_LOG_UPDATE` via the existing 0.3s throttle (`Core.lua:599-609`, `683-684`).

- **Impact:** none — no further code change proposed.
- **Performance:** none — the refresh this fix added rides the existing 0.3s-throttled
  reconcile pass; it does not add a new per-frame or per-event hook.
- **Dev time:** ~10 min, verification only.
- **Verify [G]:** accept a kill/collect quest, kill or loot one, watch the tracker update
  without doing anything else (no step change, no manual refresh). Also test the
  partial-completion-then-reload case named in the original idea: accept a quest,
  partially complete it, `/reload`, confirm the count picked back up from the live quest
  log rather than showing 0 or stale data (it should, since `Objectives()` re-reads by
  `questID` every call and caches nothing).

## Item 3 — No menu explanation of auto-progress/catchup mode

**Status: already implemented; no code change proposed.**

`Panel:ShowHelpDialog` (`Panel.lua:749-782`) has a dedicated "Auto progress & catch-up"
section: auto-advance behavior, `/tuff catchup` and `/tuff catchup confirm`
(`Core.lua:860-861`, `923`), the "Catch up on quests" button (`Panel.lua:214-216`, `561ff`,
backed by `Core:PreviewCatchUp`/`Core:CatchUp` at `Core.lua:318`, `338`), auto accept/turn-in,
and pace tracking. It's reachable from the "Help / About" button (`Panel.lua:268-270`), and
the CHANGELOG already claims this was added (`Panel.lua:33`).

- **Impact:** none — no code change proposed.
- **Performance:** n/a.
- **Dev time:** ~5 min, verification only.
- **Verify [G]:** open the menu fresh, without prior knowledge of where Help lives, and see
  whether "Help / About" is found before giving up. If it is not obviously discoverable,
  that's a follow-up UX nit (make the button more prominent), not a missing feature — flag
  it back rather than assuming this plan should silently expand to cover it.

## Item 4 — "Stop recording" / "Save as a route" still cluttering the menu

**Status: implemented (2026-09-20), pending in-game verification and a commit decision.**

Done: `Panel:FirstRunSetup()` no longer force-enables recording (`Panel.lua:94-113` — the
enable block was removed rather than flipped to `false`, since leaving `db.recording`/
`ns.Recorder.active` untouched is the actual "default off" state and matches how
Automation's opt-in works). The welcome popup's body text was also wrong after this change
("recording every quest and location as you go" was no longer true) and has been reworded
to describe auto-advance instead, with recording mentioned only as an opt-in you can turn on
from the menu (`Panel.lua:136-143`). Added a `CHANGELOG` entry and bumped
`CHANGELOG_VERSION`/all three `.toc` `## Version` fields to `1.5.4` (`Panel.lua:26-28`;
`TuFFlevels.toc`, `TuFFlevels_Vanilla.toc`, `TuFFlevels_Mainline.toc`).

**Checked for fallout before making this change:** `Recorder:Restore()` (`Recorder.lua:147-158`,
runs on `PLAYER_LOGIN` from Recorder.lua's own frame, which registers *after* Core.lua's
frame per `.toc` load order, so it always runs after `FirstRunSetup`) reads
`db.recording or false` into `self.active`. On a genuinely fresh install this now resolves
to `false` with no side effects on Vanilla/Retail. On **Forever specifically**, because
`Compat:SavedVarsAreBroken()` is true there, `Restore()`'s `elseif` branch will print "Recording
state was reset on login..." on a brand-new character's very first login, even though
nothing was ever recording — the message already hedges with "if you were recording", so
this is a minor pre-existing wording rough edge exposed by this change, not a functional
bug, and wasn't judged worth the extra state-tracking needed to fully suppress it for a
change this size. Left as one line in the "Verify" step below rather than a second code
change.

- **Impact (confirmed, not just estimated):** `Panel.lua` only — three edits (remove the
  auto-enable block, reword the welcome text, bump the changelog/version) plus the three
  `.toc` files' version strings. `Recorder.lua` untouched.
- **Performance:** none — no runtime path changed, only an initialization default.
- **Dev time:** ~15 minutes, as estimated.
- **Verify [G]:** delete `TuFFlevelsCharDB`/use a fresh character, confirm the panel opens
  with "Start recording" and "0 steps recorded". On Forever specifically, confirm the
  "Recording state was reset on login" message on that first login is at most a minor
  wording nit and not confusing enough to warrant a follow-up.
- **Not done: the submenu-move question is still open** (see below) — this pass only
  changed the default state, not where the button lives.

Both the "Recording" toggle and "Save this as a route" were already live and functional,
not dead code — `panel.recBtn` (`Panel.lua:192-195`) toggles `ns.Recorder:Start()`/`:Stop()`;
"Save this as a route" (moved into the "Content & Import" submenu by `da6cfee`) is at
`Panel.lua:345-347`, calling the fully-implemented `ns.Recorder:ShowExport()`
(`Recorder.lua:291`). No plan document anywhere in `plans/` called for removing this UI.
The root cause was `Panel:FirstRunSetup()` turning recording **on** for every fresh install
(Recorder.lua's own header describes it as a route-*authoring* tool, not something a player
following a route wants running) — fixed above.

**Still open, not part of this pass:** should the "Recording" toggle *also* move off the
main panel into the "Content & Import" submenu (where "Save as route" already lives), now
that it defaults off and is less likely to be the first thing a new player notices? Left for
the user to decide — it's a second, independent small edit to `Panel.lua`'s button layout if
wanted, not required by this fix.

## Item 5 — Map button does nothing

**Status: fixed; no code change proposed.**

`frame.mapBtn` (`UI.lua:274-281`) calls `ns.Data:SetWaypoint(step)`, which used to call
`TomTom.AddWaypoint`/`C_Map.SetUserWaypoint` unguarded (`Data.lua:346-383` before
`da6cfee`) — a throw was silently swallowed by WoW's default-hidden Lua errors, and since
`Reconcile` calls the same function on every step change (`Core.lua:283`), the failure was
invisible everywhere, not just on the button. `da6cfee` added an `Compat:ErrorCount()`-diff
guard (`Data.lua:339-343`, needed because both waypoint APIs can legitimately return nothing
on success, so a bare nil can't distinguish success from a swallowed throw) and made the
button print an explicit success/failure message (`UI.lua:277-279`).

- **Impact:** none — no further code change proposed.
- **Performance:** none — the diff-guard runs once per waypoint-set call (on click or on
  step change), not per-frame.
- **Dev time:** ~10 min verification, possibly a few more minutes only if Forever turns out
  to lack both waypoint APIs (see below).
- **Verify [G], specifically on Forever:** click the Map button and confirm a message
  appears either way. If it reports "no TomTom and no native map pin support on this
  client", confirm that's actually true for Forever (neither `TomTom` nor
  `C_Map.SetUserWaypoint` + `UiMapPoint` are present) rather than a Compat gap making a
  supported API look unsupported — `CLAUDE.md` doesn't currently document Forever's
  waypoint-API support one way or the other, so this is worth confirming and adding a note
  to `Compat.lua`'s header if it turns out to be a hard "no" on that client.

## Item 6 — Class icon instead of the red "?"

**Status: already implemented; no code change proposed.**

No red "?" indicator exists anywhere in `UI.lua`/`Progress.lua` — the only `"?"` fallbacks
found are unrelated text placeholders for a missing level number (`UI.lua:55`, `58`;
`Progress.lua:125`, `127`). `Compat:ClassIcon()` (`Compat.lua:338-345`) already does exactly
what was asked: looks up `UnitClass("player")` against `CLASS_ICON_TCOORDS` for the
class-circle atlas, falling back to `Interface\Icons\Ability_Rogue_Eviscerate` — the rogue
icon the idea list explicitly named as an acceptable default — and it's wired into a 20x20
texture in the tracker header next to `frame.sectionText` (`UI.lua:200-207`).

- **Impact:** none — no code change proposed.
- **Performance:** n/a — one texture set at header build time, not per-frame.
- **Dev time:** ~5 min, visual check only.
- **Verify [G]:** compare the in-game header against the reference picture the idea list
  points at (item 6 says "check picture" — that image wasn't available to this plan; only
  the user can do this comparison). Flag any mismatch in icon size/position/atlas coords as
  a follow-up, since the current code looks correct but hasn't been checked against that
  specific reference.

## Item 7 — Panel default position, centered intro, changelog notice

**Status: implemented; one minor residual, not recommended to fix.**

`UI:Build()` hardcodes `frame:SetPoint("LEFT", UIParent, "LEFT", 20, 0)` (`UI.lua:102`) as
the default, only overridden once a user has dragged the frame and `TuFFlevelsDB.pos`
exists (`UI.lua:118-123`, written on drag-stop at `107-112`) — so the *default* is
hardcoded every load, not SavedVariables-dependent, and is already left-aligned as asked.
`Panel:ShowWelcome()` stays centered (`Panel.lua:119`, `SetPoint("CENTER")`). The changelog
notice is a small dim "What's new" badge (`UI.lua:144-155`) shown only when
`Panel:HasUnseenChangelog()` is true (`Panel.lua:83-86`), wired through `UI:Refresh()`
(`UI.lua:333-335`) — minimal and non-intrusive, matching what was asked.

**Residual (informational, not recommended as a fix):** `db.lastSeenChangelogVersion` lives
in the same Forever-affected `TuFFlevelsDB`, so the "what's new" badge could reappear on
every `/reload` even after being dismissed. It fails safe — a returning player sees the
badge again rather than a real update silently being hidden — so this doesn't rise to a fix
worth scheduling; noted here only so it isn't rediscovered and treated as a new bug later.

- **Impact:** none — no code change proposed.
- **Performance:** n/a.
- **Dev time:** ~5 min, verification only (skip fixing the residual unless it actually
  annoys the user in practice).
- **Verify [G]:** confirm a fresh install opens left-aligned, the welcome popup is centered,
  and the "What's new" badge shows once and can be dismissed within a single session.

---

## Recommended order of work

1. ~~Item 4 decision + implementation~~ — **done** (2026-09-20): recording now defaults off,
   welcome text reworded, CHANGELOG/version bumped to 1.5.4. Commit is pending (ask first,
   per standing rule) until this is reviewed.
2. **One in-game verification pass**, still open, covering all 7 items above (~1 hour total
   on Forever, since that's the client the original complaints referenced) — items 1/2/3/5/6/7
   because this plan expects code already fixes them and wants to catch anything code-reading
   missed (e.g. Forever genuinely lacking waypoint APIs, per item 5), item 4 to confirm the
   new default and the reworded welcome text read correctly in-game.
3. Once verified, update `Architecture/Ideas-for-architecture.md` and
   `Architecture/last-update.md` to reflect that this list is resolved (or file the specific
   items that verification turns up as real bugs, if any do).
4. Separately, decide whether the "Recording" toggle should also move into the
   "Content & Import" submenu (see item 4's "still open" note) — independent of the above.

## Remaining work

~1 hour of in-game verification (all 7 items). No further code is expected unless
verification turns up something code-reading missed.
