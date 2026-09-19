# Plan 3: Route folder layout for faction/class expansion, and an external research workflow

Depends on: nothing structurally. Safe to do independently of Plans 1 and 2.

## What this plan is and is not

The goal is a `Routes/` layout that scales cleanly along two axes the user named — **faction**
(Horde/Alliance) and **class** (Rogue, Mage, ...) — plus a repeatable, human-driven process for
using Wowhead/WoWDB to gather the facts a route author needs (faction/race/class restrictions,
weapon-type quest rewards, XP-efficient quests per zone) before those facts get typed into a
route file.

**This is not** a step toward scraping Wowhead, auto-generating routes, or making the engine
pick quests algorithmically. `README.md`'s "Why it's built this way" section is explicit that
nearest-neighbor/algorithmic generation is rejected, and that rejection extends to letting an
external database drive step selection. Wowhead/WoWDB stay a manual research aid; a human reads
them, a human decides, a human writes the step. This plan only organizes where that human work
lives on disk and gives it a consistent note-taking format.

## Current state (verified against the code)

- `Routes/` is flat: `Durotar.lua`, `Horde1-60.lua`. Both hardcode `faction = "Horde"`.
- Every route file must be listed by explicit path in all three `.toc` files
  (`TuFFlevels.toc`, `TuFFlevels_Mainline.toc`, `TuFFlevels_Vanilla.toc`) — WoW addons cannot
  scan a directory at runtime, so **adding any new route file always costs a one-line `.toc`
  edit no matter how the folders are organized.** No layout can remove that step; the goal here
  is just to make each edit obvious and predictable.
- `ns.RegisterRoute(name, route)` (`Core.lua:28`) stores routes in a flat table keyed by name —
  the table is populated by whichever files got loaded, so subfolders under `Routes/` are purely
  a filesystem/`.toc` concern and require zero Lua changes.
- `Core:AutoSelectRoute()` (`Core.lua:268-308`) already filters candidate routes by
  `route.faction == Data:PlayerFaction()` and, if present, `route.races`, then ranks
  deterministically. Faction is already the primary selector a route is built around.
- `StepApplies()` (`Core.lua:103-123`) already filters individual **steps** (not whole routes)
  by `step.races`, `step.class`, and `step.minLevel`. `Routes/Durotar.lua`'s header comment
  already documents this: "one file can serve Orc and Troll with occasional divergences rather
  than maintaining two." This is the existing mechanism for the kind of class deviation the user
  described (e.g. a Rogue-only detour step for a weapon-reward quest) — it needs no new code.
- There is **no** `step.faction` filter today, only route-level `faction`. Not needed yet: every
  existing route already commits to one faction, so every step in it is implicitly that faction.
  It would only matter for a route file meant to serve a contested zone visited by both factions.

## Proposed folder layout

```
Routes/
  Horde/
    Durotar.lua
    Horde1-60.lua
  Alliance/
    (created when the first Alliance route is authored)
  Contested/
    (created only if/when a shared-zone route is authored; see "Engine change" below)

research/
  quests/
    <zone-name>.md        -- raw Wowhead/WoWDB findings for that zone, see template below
  classes/
    rogue.md              -- weapon-quest priorities, preferred grind zones, per level bracket
    mage.md
    warrior.md
    ...                    -- one file per class, created as the user gets to researching it
  factions/
    horde-exclusive-quests.md
    alliance-exclusive-quests.md
```

Rationale:

- `Routes/<Faction>/` mirrors the field the engine already selects on (`route.faction`), so the
  folder a file lives in always matches what `AutoSelectRoute` will do with it. There's no
  parallel taxonomy to keep in sync.
- **No `Routes/<Class>/` tier, and no route-level `class` field.** A full alternate route per
  class would multiply combinatorially (2 factions x several races x 9 classes) against a design
  that already rejects generated combinatorics. It would also fight `AutoSelectRoute`, which
  picks exactly one route per character today — introducing class as a second selection axis
  would need new merge/precedence logic in `Core.lua`, which is exactly the kind of engine
  cleverness `CLAUDE.md` says not to add.
- Instead, class deviation stays at the **step level**, inside the shared faction/race route
  file, using the `class` filter that already exists: a Rogue-only bonus step for a
  weapon-reward quest sits right next to the steps everyone else takes, tagged
  `class = "ROGUE"`, and other classes silently skip it via `StepApplies`. This is the same
  pattern `races` already uses in `Durotar.lua`.
- `research/` holds the knowledge that justifies those tags. It is plain Markdown, never loaded
  by the addon (same status as `plans/` or `README.md`) — it's where "why this quest, why this
  class" lives before it becomes a step, and it's where it stays as a citation trail afterward.

## Research note template

One file per zone under `research/quests/`, one per class under `research/classes/`. Suggested
shape for a zone file:

```markdown
# Research: <Zone Name>

## <Quest Name> (id ####)
- Wowhead: https://www.wowhead.com/classic/quest=####/slug
- Zone / level: <zone>, level ##
- Restrictions: faction=<Horde|Alliance|both>, races=<list or "all">, class=<list or "all">
  - How verified: Wowhead's quest page shows a "Requires" line under the quest title for
    faction/race/class gating; WoWDB shows the same under "Details". Screenshot or quote it
    here if it's easy to misread (e.g. a quest that's *technically* startable by both factions
    but only turns in for one).
- XP reward: ####  (Wowhead quest page, "Rewards" panel)
- Item reward(s) relevant to a class build: <item name, weapon type, ilvl/stats if relevant>
- Chain / prerequisites: <notes>
- Verdict: <keep as base-route step | class-only detour for X | skip (XP trap) | needs a
  second look>
```

Example, using the quest the user flagged:

```markdown
## The Family Crypt (id 408)
- Wowhead: https://www.wowhead.com/classic/quest=408/the-family-crypt
- Zone / level: Tirisfal Glades
- Restrictions: faction=Horde (Undead starting-zone questline; Wowhead's "Requires" line
  confirms it, no Alliance equivalent exists)
- Verdict: base-route step in Routes/Horde/Tirisfal.lua once that file exists; no class/race
  filter needed beyond the route already being Horde-only.
```

A class file (`research/classes/rogue.md`) reads more like a priority list than a per-quest log:

```markdown
# Rogue leveling priorities

## Weapon upgrade quests by bracket (1H sword/mace/axe rewards)
| Level | Quest | Zone | Weapon type | Notes | Wowhead |
|---|---|---|---|---|---|
| ~10 | ... | ... | 1H Sword | ... | link |

## Best XP-per-hour zones/quests for this class
<grind zones where Rogue stealth/CC lets it out-pace the base route's pacing, etc.>
```

These tables are exactly what gets promoted into `class = "ROGUE"` steps (or a `note` pointing
at an alternate grind zone) inside the relevant `Routes/<Faction>/<Zone>.lua` file — the research
file is the durable "why", the route step is the terse "what to do."

## External research workflow

No scraping, no fetch automation — this repo has no build step and Wowhead/WoWDB scraping would
also risk their terms of service for no real benefit, since the volume of quests worth recording
is small and manual reading is the way to actually judge XP-trap/travel-time quality anyway
(the same judgment call `README.md` already says a database can't make). Process:

1. Browse the Wowhead (or WoWDB) classic quest list for the zone/level bracket being authored.
2. For each candidate quest, check its "Requires" line for faction/race/class gating, and check
   its Rewards panel for XP and item rewards.
3. Record findings in `research/quests/<zone>.md` using the template above, before writing any
   route step — this keeps the citation trail even for quests that get rejected as XP traps.
4. For class-specific priorities (weapon rewards, preferred grind zones), maintain the running
   table in `research/classes/<class>.md` rather than re-deriving it zone-by-zone.
5. Promote finalized decisions into `Routes/<Faction>/<Zone>.lua` steps. Carry the Wowhead URL
   forward into the step's `note` field (or a trailing `--` comment) so a future editor can
   re-check a claim without re-searching for it.
6. Run `/tuff verify` before shipping, same as any other route edit.

## Engine change (deferred, only when actually needed)

Add a `step.faction` check to `StepApplies()` in `Core.lua`, mirroring the existing
`step.races`/`step.class` blocks — a few lines, same shape. **Do not add this speculatively.**
It only matters the day a `Routes/Contested/<Zone>.lua` file is written to serve one route file
to both factions in a shared zone (e.g. a Hillsbrad/STV-style leveling route). Until that file
exists the field would be dead code, which the project's own conventions rule out. Track it here
so it isn't forgotten, but implement it in the same commit as the first Contested route.

## Migration steps for the two existing files

1. `git mv Routes/Durotar.lua Routes/Horde/Durotar.lua`
2. `git mv Routes/Horde1-60.lua Routes/Horde/Horde1-60.lua`
3. Update the `Routes\Durotar.lua` / `Routes\Horde1-60.lua` lines in all three `.toc` files to
   `Routes\Horde\Durotar.lua` / `Routes\Horde\Horde1-60.lua`.
4. No changes inside the Lua files themselves — `local ADDON, ns = ...` and `ns.RegisterRoute`
   are location-independent; only the `.toc` path matters to the client.
5. Don't create `Routes/Alliance/` or `Routes/Contested/` yet — git doesn't track empty
   directories, and creating them now would just invite an unlisted, unloaded file to rot in
   them. Create each the day its first route file is written.

## Phasing

| Phase | Trigger | Work |
|---|---|---|
| 1 | Now | Move the two Horde files under `Routes/Horde/`, fix the three `.toc` files, create `research/` with the templates above and empty `research/classes/rogue.md` scaffolding per the user's stated priority |
| 2 | First Alliance route is authored | Create `Routes/Alliance/`, add its `.toc` lines |
| 3 | First contested-zone route is authored | Add the `step.faction` filter to `Core.lua` in the same commit |
| 4 | Ongoing | Fill in `research/classes/*.md` and `research/quests/*.md` from Wowhead/WoWDB research; graduate entries into route steps; keep citations in step `note` fields |

## Non-goals (carried forward from `README.md` / `CLAUDE.md`)

- No scraping or fetch automation against Wowhead/WoWDB.
- No algorithmic or nearest-neighbor route generation.
- No route-level `class` field or per-class alternate route files — class deviation stays at
  the step level via the existing `class` filter.
- No bundling of QuestieDB (or any third-party) data files into this repo.
