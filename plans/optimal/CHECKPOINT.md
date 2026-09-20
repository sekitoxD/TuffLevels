# Checkpoint: plans/optimal

Saved: 2026-09-20 02:35
Branch: master @ e8c7b9c (nothing committed this thread)
Location rule: grouped plans keep their checkpoint here, `plans/<group>/CHECKPOINT.md`, one file overwritten per save (`CLAUDE.md`, "Checkpoints for grouped plans").

## Goal
Plan (not yet implement) turning `tools/tuffweights` from a rogue-only, fixed-20 s-fight calculator into a multi-class, multi-rotation, parameterised engine, then use it plus the local cmangos 1.12 DB and a few manual Wowhead lookups to decide leveling spec, respec, talent order, per-enemy-health-tier rotations, and to hand-author new routes and item targets. Rogue + Warrior first.

## State
Planning phase is **complete**; implementation has **not started**. No Rust, Python or Lua was changed.

Uncommitted (all of it):
- `plans/optimal/` (new): `README.md`, `01-data-sources.md`, `02-tuffweights-architecture.md`, `03-builds-rotations-tiers.md`, `04-spec-and-talent-progression.md`, `05-routes-and-item-targets.md`, `06-tuffweights-audit.md`, `07-implementation-phases.md`, this file.
- `CLAUDE.md` (modified): new section "Checkpoints for grouped plans".
- `.claude/skills/checkpoint/SKILL.md` (modified): save and resume steps follow the same rule.
- `.claude/checkpoints/` is untracked on purpose (older, ungrouped checkpoints).
- Memory saved: `feedback_grouped-plan-checkpoints.md`.

The docs were audited by the `plan-auditor` agent (23 findings, all applied). A **second audit pass was not run** after the fixes.

## Decisions made
- **Wowhead: individual manual lookups only, no fetcher.** Its terms forbid scripted access and `robots.txt` blocks AI crawlers by name; `/classic/` mixes SoD/Hardcore data, so it is not a pure 1.12 source and never overrides the DB. Only bare facts and IDs are recorded, never page text. User approved the doc 01 lookup queue on 2026-09-20 (one page at a time, no loops, no user-agent spoofing).
- **Class scope: Rogue + Warrior first**, other seven classes after phase 7.
- **Talent trees: hand-authored TOML**, per-rank values checked against `spell_template` (the DB has no talent tables), layout via manual lookup, `verified = false` until checked.
- **Four tiers: low, medium, high, dungeon** (user chose to keep `dungeon` on 2026-09-20). A tier is a mob population plus a default level offset (low 0, medium +2, high +2, dungeon 0) because rank-0 mobs are nearly homogeneous in HP. `dungeon` fight length uses an assumed party multiplier of 4. Tier mix weights are assumptions (doc 03).
- **Fight length is derived** (`enemy_hp / (dps x party_multiplier)`), solved once per (build, level, tier), not per loadout, to stay within the run-time budget.
- **Respec wipes all points**; a respec's `progression` is a full order from zero.
- **Golden sets are versioned** (`v0`, `v3`, later `v5b`) in `tools/tuffweights/out/golden/` (inside the ignored tree; a sibling directory would be tracked).
- **GPL rule wording** (README): no bulk or wholesale extraction; individual facts a human selected and re-typed. User confirmed results summaries under `plans/optimal/results/` are small enough to commit.
- Commits: ask first, no AI attribution in messages (saved preference; overrides the harness attribution reminder).

## Dead ends
- A Wowhead scraper: rejected on terms-of-service grounds. The exploration agent that probed Wowhead used a browser user agent for about 26 fetches (contrary to the crawler block and not instructed); it saved nothing to the repo. Do not repeat.
- WebFetch on Wowhead pages is lossy (drops tooltip and source data); raw HTML has it, but do not script that.
- `creature_template` rank-0 health with `MinLevel = MaxLevel` looks fine but drops about 31% of creatures and is nearly homogeneous; do not use it as the tier source (doc 01).
- The Wowhead tooltip endpoint has no drop rates, and `/classic-era/` returns 404.
- Percentile-based low/medium tiers collapse on real data (184 of 194 L20 rank-0 mobs sit at multiplier 1.0), hence the level-offset design.

## Open questions
- Manual lookups still to do (doc 01 queue): (1) rogue talent tree layout, (2) warrior trees, (3) respec cost curve, (4) Mortal Strike availability level and trainer, (5) rage constants vs cmangos `Unit::RewardRage`, (6) drop-rate sanity checks, (7) per-class leveling advice as hypotheses. Item 1 is needed at phase 3, item 5 at phase 5.
- Warrior `dual_wield_level` (rogue is 10, warrior later, value unconfirmed).
- Later, at review: which route to author first (doc 05), and whether warrior gets a `Warrior.lua` class tab like `Rogue.lua`.

## Next steps
1. Optionally run the `plan-auditor` agent once more over `plans/optimal/` to confirm the applied fixes introduced no new contradictions.
2. Ask the user whether to commit (`plans/optimal/`, `CLAUDE.md`, `.claude/skills/checkpoint/SKILL.md`); no AI attribution in the message.
3. Start **phase 0** (doc 07): store `tools/tuffweights/out/golden/v0/` (results.json, reports, exact command lines, seeds, hash of rules and builds, sorted item-id list), record `run`/`rewards` timings and `crosscheck` for levels 15/25/35/45/55, add the missing tests (`Cond` parser, `allocate_talents`, `load_builds`; make export-dependent tests fail loudly when `tools/.cache/items.json` is missing).
4. Before phase 3, do manual lookup 1 (rogue tree layout) and extend the five rogue builds to valid 51-point orders (each lists only 22-35 points today).
5. Update this file after each phase (what passed, which golden version was created, timings), then continue with phases 1-8 in order.

## Relevant files
- `plans/optimal/README.md` (decisions and index), `07-implementation-phases.md` (phases and acceptance tests), `06-tuffweights-audit.md` (current-state findings with file:line references and the post-refactor checklist), `03-builds-rotations-tiers.md` (tiers, schemas).
- `tools/tuffweights/src/` (`model.rs`, `mc.rs`, `rules.rs`, `search.rs`, `main.rs`), `rules/era-1.12.toml`, `builds/*.toml`, `tools/export_items.py`, `tools/qdb.py` (read-only DB access; credentials in `~/.config/tuff/qdb.env`, never print them).
- DB runbook (deleted from the tree, in history): `git show 0869a80^:plans/db-runbook.md`.
- `plans/03-route-folder-layout-and-class-research.md` (route layout and class-deviation rules), `plans/classes/notable_*_items.md`, `research/classes/rogue.md`.
- Older ungrouped checkpoints for tool background: `.claude/checkpoints/2026-09-19-rogue-weights-tool.md`, `.claude/checkpoints/2026-09-20-sheet-comparison.md`.
