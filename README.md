# TuFFlevels

Step-by-step leveling route addon for WoW Classic Era. Horde 1–60.

Architecture: **QuestieDB is the data layer, routes are authored, the addon is a step engine.**

---

## Why it's built this way

An algorithm running over a quest database cannot produce a good leveling route. Questie knows where every quest giver stands and which quests chain into which. It does not know:

- which quests are XP traps (long travel, low reward)
- mob density and respawn rates
- where grinding beats questing
- hearthstone timing
- which breadcrumbs to take and which to ignore
- when to bank a turn-in for a level-up in the right zone

That's all human knowledge, and it's the entire difference between a fast route and a slow one. Nearest-neighbor over quest-giver coordinates produces something worse than a hand-written route from 2019.

So routes are data files a human writes. The addon executes them and the database validates them.

---

## Clients

| Client | Folder | Interface | Project | Quest database |
|---|---|---|---|---|
| Classic Era | `_classic_era_` | 11507 | CLASSIC | QuestieDB |
| Forever | `_classic_beta_` | 16001 | **MAINLINE** | none exists |
| Retail (Midnight) | `_retail_` | 120100+ | MAINLINE | none needed |

Ships with per-flavor TOCs. Drop the folder in and the client picks the right one.

Optional: **QuestieDB** (Classic Era only), **TomTom** (arrow waypoints, falls back to native map pins). Neither required — route files carry their own coordinates.

---

## Forever notes

Forever is **the Retail client with a Classic-looking build number**. This is the single biggest porting trap: `select(4, GetBuildInfo())` returns `16001`, so the near-universal `>= 100000` test for "modern client" reads Forever as Classic. `Compat.lua` detects by `WOW_PROJECT_ID` first and build number second.

The Classic globals are gone — `GetItemInfo`, `GetSpellInfo`, `UnitAura`, `GetTalentInfo`, `CombatLogGetCurrentEventInfo`. Port from Retail code, not Classic code.

**Midnight restrictions don't affect this addon.** They target threat meters and combat-decision addons: secret creature health and damage, restricted combat log, locked aura reads in combat. A reference/tracker addon touches none of it. We also use no secure snippets, which matters because `loadstring_untainted` is absent on the beta and every `WrapScript` / `RunAttribute` / state driver currently throws.

Three beta bugs the addon handles:

- **Unknown events abort the file.** `RegisterEvent` on an event the client doesn't know throws and kills everything after it. All registration goes through `Compat:RegisterEvents`, which pcalls each one and reports rejects via `/tuff client`.
- **SavedVariables are never restored.** The client writes on exit and doesn't read back, so progress resets on every launch AND every `/reload` (both re-execute all addon Lua from scratch). Can't be fixed in Lua — the addon warns on login, offers to jump back to where quest flags say you actually are, and `/tuff code`/`/tuff goto <n>` let you carry or restore a position manually.
- **100-error cap.** After 100 Lua errors the client stops delivering them to any handler, masking every other addon's real errors. `Compat:Guard` self-limits to 20.

`ReloadUI()` is protected — type `/reload`.

**There is no quest database for Forever.** Questie covers Classic content only, and Forever ships three new zones and 1,000+ new quests nobody has catalogued. `/tuff capture` is the whole data-acquisition story there: play it, capture, paste. That's a real advantage — you'd be building route data at the same time as everyone else rather than behind them.

---

## Commands

| Command | Does |
|---|---|
| `/tuff` | Toggle the window |
| `/tuff next` / `/tuff back` | Manual step control |
| `/tuff routes` | List loaded routes |
| `/tuff load <name>` | Switch route |
| `/tuff verify` | Validate the active route against the database |
| `/tuff capture` | Dump your quest log as pasteable route steps |
| `/tuff guide` | Import a community guide (Guidelime format) |
| `/tuff write` | Author a route in the compact line-based syntax |
| `/tuff where` | Print current step number |
| `/tuff goto <n>` | Jump to a step (progress recovery); pauses auto-advance |
| `/tuff resume` | Un-pause after Back/goto and let auto-advance continue |
| `/tuff catchup [confirm]` | Scan forward and jump to the furthest already-done step |
| `/tuff code [<code>]` | Print a portable progress code, or restore one |
| `/tuff pace` | Open the run-splits export (section times, XP/hour) |
| `/tuff help` | Open the in-addon Help / About dialog |
| `/tuff client` | Flavor, interface, rejected events, database status |
| `/tuff errors` | Suppressed error count |
| `/tuff reset` | Back to step 1 |

---

## Authoring routes

This is the actual work. The engine is done; the route is not.

**Workflow:**

1. Level a character through the section normally, in the order you want.
2. `/tuff capture` — prints every quest in your log as a formatted step line.
3. Paste into a route file, set the correct `type` on each, add notes and coords.
4. `/tuff verify` — catches typo'd IDs, missing coords, malformed steps.

`capture` exists because hand-looking-up 800 quest IDs is the thing that kills projects like this. Let the client tell you the IDs.

Two ways to skip hand-writing Lua tables: `/tuff write` opens an in-addon compact text editor (one line per step — `CompactGuide.lua`'s header has the format), or import an existing spreadsheet/community guide via the menu. Outside the game, `python tools/validate_route.py Routes/` runs the same structural checks as `/tuff verify` plus offline quest-DB checks (race/class/level/prerequisite order) against a local cmangos database — the CI workflow runs it in `--no-db` (structure-only) mode on every push.

**Crowd-sourcing a route from more than one recording.** Two people recording the same zone will disagree here and there. `python tools/merge_routes.py A.lua B.lua -o Merged.lua` groups their steps by quest ID, takes the median of the coordinates, keeps whichever order was most common, and prints a conflict report — it's a merging aid, not an authority; see `CONTRIBUTING.md` for the full workflow (record → export → merge if needed → verify → PR) and what still needs a human read-through afterward.

**Step types:**

| Type | Auto-advances when |
|---|---|
| `accept` | quest enters your log |
| `turnin` | quest flagged complete |
| `complete` | objectives done (or one specific `objective = n`), not yet handed in |
| `grind` / `level` | you reach `targetLevel` |
| `xp` | you reach `xp = { level = n, pct = n }` |
| `trainer` | closing the trainer window |
| `death` | dying then reviving |
| `hearth` | casting Hearthstone, then the zone changes |
| `travel` | within ~15 real yards of the step's coordinates (or just the right map, on a client without real-distance APIs) |
| `flightpath` | the node (`mapID` + `node` or `name`) is already known |
| `manual` / `note` | never — user clicks Next |

Steps filter by `races`, `class`, `minLevel`, and `skipIfLevel` (hides/skips once you're past that level — the inverse of `minLevel`), so one file can serve Orc and Troll with occasional divergences rather than maintaining two. `optional = true` marks a step as skippable — it's shown dimmed in the Progress list but never blocks auto-advance. `requires = { n, ... }` gates a step on other step numbers in the same route also being done, for dependencies that aren't just "the step right before it." A step's `path` (an ordered list of intermediate waypoints, possibly across zones) is what the arrow guides through before finally pointing at the step's own coordinates — see `Routes/Horde/Durotar.lua`'s header comment for the authoritative field-by-field reference, or write routes in the compact text syntax instead (`/tuff write`, see `CompactGuide.lua`'s header) rather than hand-writing Lua tables.

Auto accept/turn-in (opt-in, off by default on Classic Era/Retail, on by default every login on Forever — toggle on the tracker or in the menu) and per-section pace tracking with personal-best splits (always on, no toggle needed) both build on this same step data — see "Known constraints" below and `Pace.lua`'s header.

---

## Known constraints

**Auto-accept and auto-turn-in are implemented, opt-in.** Off by default on Classic Era/Retail, where SavedVariables persist correctly and an explicit off choice is remembered. On Forever it instead defaults to on at every login/reload, since that client's SavedVariables never restore (see "Known constraints" below) and a remembered off there is indistinguishable from "never set" — a manual `Toggle()` off only lasts for the current session. Confirmed live that `AcceptQuest`/`GetQuestReward` work from a plain event handler with no hardware event on the Forever beta. `Automation.lua` only ever acts on the quest matching your current step, never guesses a reward when there's a real choice, and Shift bypasses it for a single dialog. Toggle it on the tracker itself or in the menu — see `Automation.lua`'s header for the exact rules.

**Interface versions.** Mainline TOC lists `16001, 120100` — Forever first. Bump when either client patches.

**QuestieDB API.** `Data.lua` contains the only integration point. The accessor names there are assumed — check them against QuestieDB's `docs/api.md` before shipping. If they're wrong, the addon degrades to route-file coords rather than breaking, which is why it's isolated to one file.

**The seeded Durotar route has unverified quest IDs.** It's a format demonstration. Run `/tuff verify` before trusting any of it.

---

## Licensing

TuFFlevels itself is **MIT**-licensed (see `LICENSE`).

QuestieDB is **GPL-3.0**.

- Reading it at runtime as an optional dependency — you license TuFFlevels however you want.
- Bundling or copying its data into your addon — TuFFlevels must be GPL-3.0.

This addon does the former deliberately. Don't copy data files in.

---

Commands are `/tuff` or `/tufflevels`. `/sl` still works as a short alias.
