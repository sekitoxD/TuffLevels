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
- **SavedVariables are never restored.** The client writes on exit and doesn't read back, so progress resets each launch. Can't be fixed in Lua — the addon warns on login and `/tuff where` + `/tuff goto <n>` let you restore manually.
- **100-error cap.** After 100 Lua errors the client stops delivering them to any handler, masking every other addon's real errors. `Compat:Guard` self-limits to 10.

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
| `/tuff where` | Print current step number |
| `/tuff goto <n>` | Jump to a step (progress recovery); pauses auto-advance |
| `/tuff resume` | Un-pause after Back/goto and let auto-advance continue |
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

**Step types:**

| Type | Auto-advances when |
|---|---|
| `accept` | quest enters your log |
| `turnin` | quest flagged complete |
| `complete` | objectives done, not yet handed in |
| `grind` / `level` | you reach `targetLevel` |
| `travel` / `hearth` / `manual` / `note` | never — user clicks Next |

Steps filter by `races`, `class`, and `minLevel`, so one file can serve Orc and Troll with occasional divergences rather than maintaining two.

---

## Known constraints

**No auto-accept or auto-turn-in yet.** Not implemented. Whether the required calls (`AcceptQuest`, `CompleteQuest`, `GetQuestReward`, gossip selection) work from an event handler without a hardware event on Forever is under investigation — RestedXP advertises these features on Forever, so "blocked on every client" was an unverified guess, not a confirmed limitation. Display and tracking work today regardless of the outcome.

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
