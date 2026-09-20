# plans/optimal — best leveling spec, rotation, talents and item targets

Goal: make `tools/tuffweights` the primary source for **which spec to level, which
rotation to use against which enemy, and which talent order to take**, for more than
one class. Then use that output, the local cmangos 1.12 DB and a few manual Wowhead
lookups to hand-author new routes and item targets.

The rogue item-weight tool (commits 7e4ed38 .. 84cfd57) is the starting point. It scores
rogue weapons, armor and quest rewards, but it is rogue-only, models one fixed 20 s fight,
and has no notion of enemy health, rotation tiers or talent progression. These documents
plan the changes; nothing here changes code by itself.

## Decisions (made with the user, 2026-09-20)

| Topic | Decision |
|---|---|
| Wowhead | **Manual spot lookups only**, one page at a time, for facts the DB lacks. No fetcher script. Only bare numbers and IDs enter the repo, never page text. See `01-data-sources.md`. |
| Class scope | **Rogue + Warrior first.** Rogue is migrated onto the new engine, warrior is the second class. The other seven classes follow the same recipe afterwards. |
| Talent trees | **Hand-authored TOML per class**, per-rank values checked against `spell_template`. Anything uncertain is flagged for a manual check, not guessed. The layout and respec-cost lookups in the doc 01 queue are approved as individual Wowhead lookups. |
| Dungeon tier | **Kept** as the fourth tier (low, medium, high, dungeon), with the party multiplier as a stated assumption. |
| Results summaries | `plans/optimal/results/<class>.md` summaries are small enough to commit, when a commit is requested. |

## Constraints that apply to every document here

- **Routes stay hand-authored.** The tool advises (item priority, spec, rotation, talent
  order). It never generates routes. See the "Why it's built this way" section of the
  top-level `README.md` and `CLAUDE.md`.
- **GPL rule (one wording, used in every document here):** no bulk or wholesale extraction of
  DB data into tracked files: no table dumps, no generated files, nothing beyond the individual
  facts a human selected and re-typed (an item name and the number that justifies it, a few
  illustrative aggregates). `tools/.cache/` and everything under `tools/tuffweights/out/`
  (including `out/golden/`) are gitignored and never tracked. The cmangos DB is GPL-3.0.
- **Class deviation in routes stays at step level** (`class = "WARRIOR"` on a step), with no
  `Routes/<Class>/` tier and no route-level `class` field
  (`plans/03-route-folder-layout-and-class-research.md`; not this folder's `03-*.md`).
- **Commits:** ask first, no AI attribution in messages (standing user preference).

## Documents

| File | Content |
|---|---|
| `01-data-sources.md` | What the DB can and cannot answer, queries for enemy health, the Wowhead manual-lookup queue and recording rules, exporter changes |
| `02-tuffweights-architecture.md` | Target crate design: class data, data-driven abilities, resource models, solvers, condition language |
| `03-builds-rotations-tiers.md` | Folder layout, file schemas, the four enemy-health tiers, rotation stages, scenario variables and CLI |
| `04-spec-and-talent-progression.md` | How leveling specs, respecs and talent order are decided; rogue and warrior candidate builds |
| `05-routes-and-item-targets.md` | How tool output feeds hand-authored routes and item notes |
| `06-tuffweights-audit.md` | Audit of the current tool, disposition of every module, and the post-refactor audit checklist |
| `07-implementation-phases.md` | Ordered phases with an acceptance test each |

## Phase order (detail in `07`)

0. Baseline (golden `v0`) and missing tests. 1. Pure refactor. 2. Class layer, rogue ported,
exporter widened. 3. Condition language, talent trees, valid 51-point rogue orders (golden `v3`).
4. Scenario variables and health-tier plumbing. 5. Resource models and the timeline solver.
5b. Per-tier rogue rotations. 6. Warrior. 7. `talents` and `progression` subcommands and the
item notes. 8. Routes, class-tab text, then the remaining classes.

## Status

Planning only. Written 2026-09-20. Facts quoted from the DB were re-checked the same day
with `tools/qdb.py`; code references are to the tree at commit e8c7b9c plus uncommitted work.
