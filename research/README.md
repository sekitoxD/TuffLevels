# research/

Plain Markdown, never loaded by the addon (same status as `plans/` or
`README.md`). This is where the "why this quest, why this class" lives
*before* it becomes a route step, and where it stays afterward as a
citation trail — see `plans/03-route-folder-layout-and-class-research.md`
for the full rationale and workflow this scaffolding comes from.

**No scraping, no fetch automation.** Wowhead/WoWDB stay a manual
research aid: a human reads them, a human decides, a human writes the
step. This addon's whole design rejects letting an external database
drive step selection — see `README.md`'s "Why it's built this way".

## Layout

```
research/
  quests/
    <zone-name>.md   -- raw Wowhead/WoWDB findings for that zone
  classes/
    rogue.md          -- weapon-quest priorities, preferred grind zones
    <class>.md         -- created as you get to researching that class
  factions/
    horde-exclusive-quests.md
    alliance-exclusive-quests.md
  professions/
    cooking.md, firstaid.md, engineering.md, ... -- 1-300 leveling
    guides for secondary/trade skills. Reference-only: there is no
    in-addon profession tracking (no skill-level Compat wrapper, no
    craft-keyed step type), so these exist purely for a human to read
    while playing, same status as any other file in research/.
```

Create `quests/<zone>.md` and `factions/*.md` files as you actually do
that research — git doesn't track empty directories, and an empty
scaffold file just invites rot. `classes/rogue.md` already exists
(the addon's own `Rogue.lua` tab made it the first priority). Only
create a `professions/<skill>.md` file for a skill someone actually
researched — `Fishing` has none yet for exactly that reason.

## Workflow

1. Browse the Wowhead (or WoWDB) classic quest list for the zone/level
   bracket being authored.
2. For each candidate quest, check its "Requires" line for faction/race/
   class gating, and check its Rewards panel for XP and item rewards.
3. Record findings in `research/quests/<zone>.md` using the template
   below, before writing any route step — this keeps the citation trail
   even for quests that get rejected as XP traps.
4. For class-specific priorities (weapon rewards, preferred grind zones),
   maintain the running table in `research/classes/<class>.md` rather
   than re-deriving it zone-by-zone.
5. Promote finalized decisions into `Routes/<Faction>/<Zone>.lua` steps.
   Carry the Wowhead URL forward into the step's `note` field (or a
   trailing `--` comment) so a future editor can re-check a claim
   without re-searching for it.
6. Run `/tuff verify` (or `python tools/validate_route.py`) before
   shipping, same as any other route edit.

## Zone research template

One file per zone under `research/quests/`:

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

Example, using the quest the original plan flagged:

```markdown
## The Family Crypt (id 408)
- Wowhead: https://www.wowhead.com/classic/quest=408/the-family-crypt
- Zone / level: Tirisfal Glades
- Restrictions: faction=Horde (Undead starting-zone questline; Wowhead's "Requires" line
  confirms it, no Alliance equivalent exists)
- Verdict: base-route step in Routes/Horde/Tirisfal.lua once that file exists; no class/race
  filter needed beyond the route already being Horde-only.
```

## Class research template

A class file (`research/classes/rogue.md`) reads more like a priority
list than a per-quest log:

```markdown
# Rogue leveling priorities

## Weapon upgrade quests by bracket (1H sword/mace/axe rewards)
| Level | Quest | Zone | Weapon type | Notes | Wowhead |
|---|---|---|---|---|---|
| ~10 | ... | ... | 1H Sword | ... | link |

## Best XP-per-hour zones/quests for this class
<grind zones where Rogue stealth/CC lets it out-pace the base route's pacing, etc.>
```

These tables are exactly what gets promoted into `class = "ROGUE"` steps
(or a `note` pointing at an alternate grind zone) inside the relevant
`Routes/<Faction>/<Zone>.lua` file — the research file is the durable
"why", the route step is the terse "what to do."

## What NOT to add here yet

- `Routes/Alliance/` or `Routes/Contested/` folders — create each the
  day its first route file is actually written.
- A `step.faction` filter in `Core.lua` — only needed the day a
  `Routes/Contested/<Zone>.lua` file serves one route to both factions
  in a shared zone. Implement it in the same commit as that route, not
  before.
- A `Routes/<Class>/` tier, or a route-level `class` field — class
  deviation stays at the step level via the `class` filter `StepApplies`
  already has (see `Routes/Horde/Durotar.lua`'s header). A full
  alternate route per class would multiply combinatorially against a
  design that already rejects generated combinatorics.
