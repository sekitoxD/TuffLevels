# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

TuFFlevels is a WoW addon (plain Lua + WoW API, no build step). It is a **step-engine, not a route-generator**: `Data.lua` is a thin adapter over an optional quest database (QuestieDB), routes are hand-authored data files, and the addon's job is purely to track which step the player is on and auto-advance it. See `README.md` for the full rationale — don't try to make the engine "smarter" about picking quests; that's explicitly against the design.

There is no build/lint/test tooling — this is Lua that only runs inside the WoW client. "Testing" a change means loading it in-game (`/reload`) and exercising it, or reasoning carefully through the code, since there is no headless runner.

## Multi-client targets and the Compat layer

The addon ships **three TOC files** for three different WoW clients, all sharing the same Lua source:

| Client | TOC | Interface | Project | Notes |
|---|---|---|---|---|
| Classic Era | `TuFFlevels_Vanilla.toc` | 11507 | CLASSIC | QuestieDB available |
| Forever (`_classic_beta_`) | `TuFFlevels_Mainline.toc` | 16001 | MAINLINE | no quest DB exists |
| Retail/Midnight | `TuFFlevels_Mainline.toc` | 120100+ | MAINLINE | no quest DB needed |
| (default) | `TuFFlevels.toc` | all three | — | lists all interface versions |

**The critical trap**: Forever reports build number 16001 (looks Classic) but is actually the Retail/Mainline client (`WOW_PROJECT_ID == WOW_PROJECT_MAINLINE`). The near-universal `tocVersion >= 100000` check for "modern client" misreads Forever as Classic. `Compat.lua` detects flavor by `WOW_PROJECT_ID` first, build number second — always route new client-detection logic through `Compat.flavor` / `Compat.isForever` / `Compat.isMainline` rather than checking `GetBuildInfo()` directly. When porting API usage, copy from Retail code, not Classic code — Forever has dropped Classic-only globals like `GetItemInfo`, `GetSpellInfo`, `UnitAura`, `GetTalentInfo`, `CombatLogGetCurrentEventInfo`.

Three Forever-specific bugs `Compat.lua` works around (don't "fix" these by removing the workaround):
- **Unknown events abort the whole file.** `RegisterEvent` on an event the client doesn't recognize throws and kills every line after it in that file. All event registration must go through `Compat:RegisterEvents(frame, events)`, which `pcall`s each one individually and reports rejects via `/tuff client`.
- **SavedVariables never restore on login** (client writes on exit, doesn't read back) — this hits `/reload` too, not just a full relaunch, since `/reload` re-executes every addon's Lua from scratch just like a relaunch does. Can't be fixed in Lua; `Compat:InitSavedVar`'s in-session cache only dedupes repeated calls within one continuous Lua session, it does not survive `/reload`. `Compat:SavedVarsAreBroken()` drives a login warning that says so.
- **100-error cap per session** — after that the client stops delivering Lua errors to *any* addon. `Compat:Guard(fn, ...)` self-limits (currently 20 errors) so this addon can't mask other addons' real errors.

No secure snippets are used anywhere (`loadstring_untainted` is absent on Forever beta; `WrapScript`/`RunAttribute`/state drivers all throw there) — keep it that way.

## Load order (from the .toc files)

```
Compat.lua      -- client/flavor detection, safe event reg, SavedVariables bridge, API shims — loads first
Theme.lua       -- shared color palette for all frames
Data.lua        -- QuestieDB adapter (the ONE file to touch if QuestieDB's API changes)
Core.lua        -- the step engine: route registry, step advancement, slash commands
Automation.lua  -- opt-in, step-matched auto accept/turn-in (off by default)
Pace.lua        -- per-section timing, personal-best splits, XP/hour and level ETA
Recorder.lua    -- turns live play (accept/turn-in events) into route step data
Marker.lua      -- nameplate icons over quest NPCs / objective mobs; pauses under instance/secret-value restrictions (Compat:HasSecretRestrictions et al, /tuff debugrestrict to test)
UI.lua          -- the tracker window
Arrow.lua       -- pointer + distance readout to the current step
Panel.lua       -- button menu wrapping the slash commands, first-run setup
Progress.lua    -- checklist view of the whole route
Import.lua      -- rebuilds a route skeleton from already-completed quests (quest flags)
Zones.lua       -- "where to go next" leveling zone guide
GuideImport.lua -- converts community Guidelime-format guides into routes
CompactGuide.lua -- original line-based syntax that compiles to step tables
SheetImport.lua -- converts a CSV/TSV spreadsheet export into a route
Rogue.lua       -- rogue-only tab (training milestones, weapon upgrades, grind advice)
Routes\*.lua    -- data files, loaded last, call ns.RegisterRoute(...)
```

Every file shares one addon-private namespace via `local ADDON, ns = ...`, and each module attaches itself as `ns.<Name>` (e.g. `ns.Core`, `ns.Data`). Cross-module calls always guard with `if ns.X then ns.X:Method() end` since load order and optional modules matter.

## Core architecture

- **`Core.lua`** owns `Core.routes` (registry), `Core.active` (loaded route), `Core.index` (current step). `Core:Reconcile()` walks forward from the current index, auto-skipping any step that `IsStepDone()` says is satisfied or that `StepApplies()` says doesn't apply to this character (race/class/minLevel filters) — this is the auto-advance mechanism, driven off quest events (`QUEST_ACCEPTED`, `QUEST_TURNED_IN`, `QUEST_LOG_UPDATE`, etc.), throttled via `C_Timer.After(0.3, ...)` since `QUEST_LOG_UPDATE` fires very frequently.
- **`Data.lua`** is the *only* file that should reference QuestieDB's API directly (`Data:DetectProvider`, `providerHandle`). The addon must stay fully functional with **no database installed** — QuestieDB only enriches (names/coords/validation); route files always carry their own coordinates as the source of truth. If you need to touch QuestieDB integration, this is the file, and double-check accessor names against QuestieDB's own `docs/api.md` since the header comment flags them as unverified assumptions.
- **Step schema** (see the header comment in `Routes/Horde/Durotar.lua` for the authoritative reference): `type` is one of `accept | turnin | complete | grind | level | xp | section | trainer | death | manual | travel | hearth | flightpath | note`. Auto-detected types (`accept`, `turnin`, `complete`, `grind`, `level`, `xp`, `trainer`, `death`, `hearth`, `travel`, `flightpath`) are checked in `IsStepDone()` in `Core.lua`. `trainer`/`death`/`hearth` are event-driven (a small watcher in `Core.lua` tags the current step's own table with `step._eventDone` when it sees `TRAINER_CLOSED`/death-then-revive/hearth-cast-then-zone-change fire while that step is current); `travel` is checked by a 1-second ticker against real yards via `Data:RealDistanceToStep` (falling back to "right map" if the world-position APIs aren't available on that client); `flightpath` is directly queryable via `Data:IsFlightPathKnown`, no event or ticker needed; `xp` checks player level/XP percent directly. Everything else requires the user to click Next. Steps optionally filter by `races`, `class`, `minLevel`/`skipIfLevel` so one file can serve multiple race/class combos. `section` steps are headers only (`Core:CurrentSection`/`Core:Sections` scan for them) and always report done. A step's `path` (ordered waypoints, possibly cross-map) is what `Arrow.lua`'s `Data:EffectiveTarget` walks through before falling back to the step's own coordinates. `optional` steps never block `Reconcile`'s auto-advance walk regardless of done-state (they're dimmed in the Progress list instead — see `Progress.lua`'s row rendering); `requires` gates `IsStepDone()` on other step numbers (this route's array position) also being done, with a cycle guard against a circular chain — see `Routes/Horde/Durotar.lua`'s header for the full field list.
- **Quest name resolution**: spreadsheet-imported steps carry `questName` instead of a numeric `quest` ID (names aren't guaranteed unique game-wide, but are unique within a live quest log at any moment). `Core.ResolveQuest` / `Compat:GetQuestIDByName` resolve and permanently cache the mapping in `TuFFlevelsDB.questNames` the first time the quest is seen in the log.
- **Route authoring is the actual content of this addon.** `/tuff capture` dumps the live quest log as pasteable step lines (avoids hand-looking-up quest IDs), `/tuff verify` runs `Data:ValidateRoute` to catch bad IDs / missing coords / malformed grind steps before a route ships. Treat routes in `Routes/*.lua` as authored data, not something to auto-generate from an algorithm — see the README's "Why it's built this way" for why nearest-neighbor/algorithmic route generation is explicitly rejected.
- **Persistence**: `Core:Save`/`Core:Load` persist `{route, index}` into `TuFFlevelsCharDB` via `Compat:InitSavedVar`. On Forever this is best-effort only (see the SavedVariables bug above) — the addon warns rather than pretending it works.

## Conventions to follow when editing

- New WoW API calls that might not exist on all three targets go through a `Compat:` wrapper that `pcall`s the call and degrades gracefully — follow the pattern already used for quest-log accessors in `Compat.lua`.
- New slash-sub-commands get added to the `SlashCmdList["TUFFLEVELS"]` dispatcher in `Core.lua`, and mirrored as a button in `Panel.lua` if it's meant to be discoverable — the file header for `Panel.lua` describes it as "everything the slash commands do, as buttons."
- Registering a new route: call `ns.RegisterRoute(name, { faction, races, levels, author, steps = { ... } })` from a file under `Routes/`, and add that file's path to the bottom of the relevant `.toc` file(s) (order matters: it must load after `Core.lua`).
- Don't bundle or copy QuestieDB's data files into this repo — it's GPL-3.0 and read at runtime as an optional dependency only, which is why `Data.lua` isolates all contact with it. Copying its data in would require relicensing this addon GPL-3.0 (see README "Licensing").
