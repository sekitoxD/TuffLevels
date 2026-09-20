# 07 — Implementation phases

Each phase ends with: `cargo test` green, the checks in `06` part C that apply, and a
`plan-auditor` pass on any plan document the phase changed. Work in `tools/tuffweights/` unless
stated. Nothing is committed without asking (no AI attribution in messages).

**Golden sets are versioned.** They live in `tools/tuffweights/out/golden/<version>/` (inside the
already-ignored `out/` tree; `.gitignore` covers only `tools/.cache/`, `tools/out/`,
`tools/tuffweights/out/` and `tools/tuffweights/target/`, so a sibling directory would be
tracked). Each acceptance line below names the version it compares against.

| Version | Created | Meaning |
|---|---|---|
| `v0` | phase 0 | The tool exactly as it is today (under-talented rogue, fixed 20 s fight) |
| `v3` | phase 3 | Same model with all five rogue builds extended to a valid 51-point talent order |

## Phase 0 — Baseline and missing tests

- Store `out/golden/v0/` (results.json and reports) with exact command lines, seeds and a hash of
  the rules and builds. Also store the sorted list of item ids in the current export.
- Record `run` and `rewards` wall time, and the `crosscheck` differences for levels 15, 25, 35, 45, 55.
- Note in the README of the golden directory that v0 encodes an under-talented rogue (`06` A4:
  22-35 of 51 points), so phase 3's re-baseline is expected to raise DPS at high levels.
- Add tests that do not exist: `Cond` parser (each form and error), `allocate_talents`,
  `load_builds` validation. Make export-dependent tests fail loudly when `tools/.cache/items.json`
  is missing (today some pass silently).
- **Accept:** `v0` stored; new tests pass; timings recorded in this file.

## Phase 1 — Pure refactor, no behaviour change

- Split into `lib.rs` + `main.rs`; move modules to the layout in `02`.
- Remove the duplication in `06` A5 (one condition evaluator, one cast resolver, one class/race/
  faction parser, one build lookup, one options constructor). The cast-resolver merge must keep
  the sequence of `Rng` draws inside a fight unchanged.
- Introduce `Scenario` and `ScenarioGrid` with today's flags only.
- **Accept:** vs `v0`, run with `--mc-fights 0` the reports are identical; with MC on, `mc_dps`
  is identical (draw order preserved) or, if a merge unavoidably reorders draws, within the MC
  standard error and the reason is recorded here.

## Phase 2 — Class layer, rogue ported, exporter widened

- Add `rules/classes/rogue/{class,abilities,talents}.toml`. Replace `enum Ability` and fixed
  arrays with `AbilityId`. Replace the `Talent` struct with generic effects. Move
  `dual_wield_level` into `class.toml` (rogue keeps 10).
- Remove rogue literals from engine and content code; keep `audit.rs` rogue-specific.
- Exporter reads `class.toml` `[export]`; items exported once; class filtering in Rust. **All
  exporter widening is done here**, not later: two-hand weapon subclasses and `InventoryType 17`,
  mail, plate and shield armor subclasses (concrete additions in doc 01 section 3).
- Keep the old rogue-filtered export as `items.v0.json` for this phase, for comparison.
- **Accept:** vs `v0`, top loadouts within 0.01% DPS **and** the sorted set of item ids that pass
  the Rust rogue filter is identical to `v0`'s item id set (diff the lists; DPS parity alone cannot
  detect a changed item pool); `06` C1 and C2 pass.

## Phase 3 — Condition language, talent trees, valid talent orders

- Implement the expression grammar in `engine/cond.rs` (semantics in `02`), migrate existing
  rotations without changing meaning.
- Author the rogue tree (`talents.toml`: tab, tier, column, prerequisites); manual-lookup queue
  item 1 supplies the layout. Add the tier-gate validator and respec handling.
- **Deliverable, not an exception:** extend all five rogue builds' `progression` to a valid
  51-point order (each currently lists 22-35 points and `combat_swords` violates tier gates).
  Record each choice and its reason.
- Create `out/golden/v3/` from the corrected builds, with a note explaining that DPS moved
  (up, at high levels) because the model now spends all its talent points.
- **Accept:** condition parser, allocation and validator tests pass; all five builds validate;
  the `v0` to `v3` difference is explained per build (only talent-driven, no unexplained movement
  at levels 10-31 where the old lists were long enough).

## Phase 4 — Scenario variables and enemy-health tiers (plumbing)

- Exporter writes `world.mob_health` per tier and level (definitions doc 03, query doc 01).
- TTK: fixed point solved once per (build, level, tier) with a representative loadout and held
  fixed across the search, full fixed point only on the top-N refine pass (doc 02).
- `--fight-seconds`, `--mob-delta`, `--tier`, `--stage`; `report.rs` cells and `results.json` gain
  a `tier` key; markdown reports gain the tier axis and the tier mix.
- Move builds to `builds/<class>/<build>/<stage>/<tier>.toml`; add `extends` and stage selection.
  Each tier file **copies the existing rotation verbatim** (only `cp`, `energy`, `positional`,
  `talent:` conditions, which the Markov solver accepts).
- **Accept:** with `--fight-seconds 20` and mob delta 0 the result reproduces `v3`; TTK converges
  for levels 10-59 in every tier, or the non-converging cells are listed; the tier degeneracy
  check (doc 03) is reported; `run` wall time within about 2x of the phase-0 timing;
  `crosscheck` within the phase-0 bounds.

## Phase 5 — Resource models and the timeline solver

- Implement `Resource` (energy and combo points, rage). Confirm rage constants against cmangos
  `Unit::RewardRage` first (manual queue item 5).
- Implement `solver/timeline.rs` with cooldowns, GCD and buffs, and the `ready:`, `buff:`,
  `enemy_hp_pct`, `time_left` conditions.
- **Accept:** on the `v3` rogue set, `timeline` is within 0.5% of `markov` and both agree with
  `mc`; decision on retiring `markov` (rule in doc 02) recorded here with the timings.

## Phase 5b — Per-tier rogue rotations

- Now that `time_left` and `enemy_hp_pct` exist, tune the four tier rotations of each rogue build
  (for example skipping finishers that cannot pay back before the fight ends).
- **Accept:** each tier's rotation beats the copied phase-4 rotation on its own tier, or is left
  identical with the reason noted; results are a new golden `v5b`; changes are explained per build.

## Phase 6 — Warrior

- Author `rules/classes/warrior/*` (abilities, tree, stats), builds `arms` (pre and post Mortal
  Strike stages), `fury_two_hand`, `fury_dual_wield`, each with four tier files.
- Handle `weapon_mode` (two-hand, dual wield, one-hand and shield) in search; armor valuation for
  mail and plate. (The exporter already carries this data from phase 2.)
- **Accept:** `mc` agrees with the analytic solver within tolerance for warrior loadouts at levels
  15, 25, 35, 45, 55; facts the model depends on that were not in the DB are listed as verified
  or flagged; `06` C1-C3 pass with warrior present.

## Phase 7 — `talents` and `progression`, and the item notes

- Implement both subcommands (doc 04) and run them for rogue and warrior.
- Write per-class summaries under `plans/optimal/results/`, and edit
  `plans/classes/notable_{rogue,warrior}_items.md` once, where the tool disagrees with the old
  notes (this is the only phase that edits them; doc 05).
- **Accept:** regret tables produced; respec cost confirmed via manual lookup or flagged in the
  report header; user reviews the recommendations.

## Phase 8 — Routes, class-tab text, other classes

- Hand-author routes and notes per `05`, validated with `tools/validate_route.py` and the
  `route-check` skill.
- **Addon-side acceptance (Lua is only truly tested in the client):** `/tuff verify` clean on
  every touched route; `/reload` on Vanilla and on Forever with the new step visible in the
  tracker and the Progress list; every new `Routes/` file listed in all three `.toc` files after
  `Core.lua`, with `Register.lua` last in its folder.
- Repeat phases 2-7 for the other seven classes, one at a time, reusing the engine unchanged
  (a class that needs a new resource model adds it under `engine/resource.rs`).
- **Accept (per class):** class definition, talent tree, builds, tier rotations and a summary
  exist **and** the class's results have been reviewed by the user against at least one in-game
  check (a respec or a rotation exercised on the relevant tier of enemy).

## Cross-phase risks

| Risk | Mitigation |
|---|---|
| Refactor silently changes rogue rankings | Versioned golden sets; exact match phase 1, item-id-set and 0.01% phase 2, explained differences only after that |
| Existing rogue numbers were computed with an under-talented model | Fixed deliberately in phase 3, recorded as `v0` to `v3` |
| Fixed-point TTK does not converge, or oscillates between rotations, or is too slow | Solved per (build, level, tier), cap of 8 iterations, non-convergence reported, `--fight-seconds` override, timing acceptance in phase 4 |
| Timeline solver too slow for the search | Keep `markov` for search; use `timeline` only where cooldowns matter, or search coarsely then refine the top loadouts |
| Rank-0 mobs nearly homogeneous, so low and medium tiers are close | Tier = population plus default level offset; degeneracy check reports it (doc 03) |
| Talent layout typed from memory is wrong | `verified = false` flag; manual lookup before a result is used; validator catches tier-gate impossibilities |
| Wowhead facts drift from 1.12 (SoD/Hardcore mixed in) | DB wins on any conflict; Wowhead only supplies things the DB lacks, each flagged |
| Scope creep to all nine classes | Rogue and warrior only until phase 7 accepts |
| Objective is DPS, not XP/hour | Stated in every report header; revisit if quest XP data is obtained |
