# 05 — From tool output to routes and item targets

The tool produces **advice**. Routes are hand-authored data; the README's "Why it's built this
way" rejects algorithmic route generation, and `CLAUDE.md` repeats it. This document says how the
outputs are consumed without breaking that.

## What the tool hands over

| Output | Consumer |
|---|---|
| Item priority per class, level and acquisition tier (`shortlist`, `worth`, `rewards`) | `plans/classes/notable_<class>_items.md`; step notes that say "take X from this quest" |
| Spec and respec plan (doc 04) | `note` steps in the route at the respec level; the class tab module (`Rogue.lua` today) |
| Rotation guidance per health tier and stage (doc 03) | Notes and the class tab; not step logic |
| Talent order (doc 04) | Class tab / notes |

## Routes: what is authored, and how

1. **Item and level targets first, routes second.** For each class, the item-target note is
   completed before any route step is written, so steps can name the reward to pick and the level
   window it is worth having.
2. **Quest and NPC facts** come from the DB via `tools/qdb.py` (`quest`, `item`), and
   `tools/validate_route.py` checks IDs before commit. Coordinates come from hand capture
   (`/tuff capture`), not from the DB (which has none the addon uses).
3. **Guide information beyond the DB** (quest order tips, dungeon routing, comments) comes from
   manual Wowhead lookups (doc 01 rules): facts and numbers only, never copied text.
4. **Class deviation is per step**: `class = "WARRIOR"` (or `ROGUE`) on the step, per
   `plans/03-route-folder-layout-and-class-research.md`. No `Routes/<Class>/` directory and no
   route-level `class` field.
5. **Layout and naming.** New routes follow the `Routes/<Faction>/<Kind>/` convention used by
   `Routes/Horde/Solo/` (`Init.lua` first, PascalCase zone files, `Register.lua` last) and
   `Routes/Horde/Dungeon/` (numbered chapter files `NN-Name.lua`, `Init.lua`, `Register.lua`).
   Files at the faction root (`Horde1-60.lua`, `TirisfalStart.lua`) are legacy. Sample files such
   as `Routes/Horde/Durotar.lua` are deliberately **not** listed in the `.toc` files
   (commit c983af8). Every real route file is listed by explicit path in all three `.toc` files,
   after `Core.lua`, with `Register.lua` last in its folder. A `Routes/Alliance/` directory is
   created the day the first Alliance route is written.

## Order of work

| Order | Work | Depends on |
|---|---|---|
| 1 | Rogue item and level targets: the tool's tiered output is available after phase 5b (health tiers and tuned tier rotations); the note `plans/classes/notable_rogue_items.md` is edited once, in phase 7, with the tiered output and the `progression` output both in hand | phases 5b and 7 |
| 2 | Warrior item and level targets (edit `notable_warrior_items.md` where the tool disagrees), in phase 7 | phases 6-7 |
| 3 | Respec and rotation notes for rogue and warrior as `note` steps and class-tab text | phase 7 |
| 4 | First new hand-authored route for the class that gains the most from tool output (decided at review) | 1-3 |
| 5 | Remaining seven classes, same recipe | later |

## Open questions (for review, not decided here)

- **Which route first**: a Horde warrior solo route, or extending the existing Horde solo route
  with `class="WARRIOR"` steps. The second reuses the existing zone files but risks step-count
  bloat; the first duplicates content. Decide when the warrior targets are done.
- **Class tab modules**: `Rogue.lua` is a rogue-only tab (training milestones, upgrades, grind
  advice). Whether warrior gets a `Warrior.lua` in the same style or a shared generic module is a
  design question for the addon side; the tool side does not depend on it.
- **Alliance**: no Alliance route exists. Item targets are faction-aware (`--faction`), so the
  notes can cover both without an Alliance route.
- Data that the addon needs at runtime (for example the upgrade table in `Rogue.lua`) is typed by
  hand from tool results. It is not generated: a generated tracked file would be the wholesale
  extraction the README's GPL rule rules out.

## Guardrails

- Run the `route-check` skill and `tools/validate_route.py` on any file under `Routes/` before commit.
- Lua changes (routes, `note` steps, class-tab text) are only really tested in the WoW client:
  `/tuff verify` clean on every touched route, `/reload` on Vanilla and on Forever with the new
  step visible in the tracker and the Progress list.
- Any commit follows the standing preference: ask first, no AI attribution in the message.
- GPL rule (README wording): no bulk or wholesale extraction; nothing from `tools/.cache/` or
  `tools/tuffweights/out/` is copied into tracked files beyond individual facts a human selected
  and re-typed.
