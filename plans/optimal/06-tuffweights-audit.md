# 06 — tuffweights audit

Audit of `tools/tuffweights` (about 4,700 lines including TOML) against the goals in this
folder: multi-class, multi-rotation, parameterised, modular, with reuse. Line references are to
the tree at commit e8c7b9c plus uncommitted work, checked 2026-09-20. Part A is the current
state; part B is the disposition of every module; part C is the checklist to re-run after the
refactor.

## A. Current state

### A1. Modules and layering

Layers, bottom to top: `data`, `rules` -> `model` -> `search`, `weights`, `mc` -> `report`,
`armor` -> `audit`, `worth`, `verdict` -> `rewards` -> `main`.

| Module | LOC | Role |
|---|---|---|
| `main.rs` | 272 | clap CLI and glue |
| `rules.rs` | 312 | Ruleset, Build, `enum Ability`, `enum Cond`, `allocate_talents` |
| `data.rs` | 354 | Exporter JSON schema (`Item`, `Weapon`, `Equip`, `Proc`, `World`, `QuestChoice`) |
| `model.rs` | 941 | Analytic DPS: formulas, class logic, rotation walk |
| `mc.rs` | 380 | Monte Carlo replay and crosscheck |
| `weights.rs` | 80 | Finite-difference stat weights |
| `search.rs` | 321 | Loadout search, `Tier`, class/race/faction masks |
| `report.rs` | 325 | Build x level grid, markdown and JSON reports |
| `armor.rs` | 138 | Non-weapon valuation |
| `worth.rs` | 355 | Uplift windows and verdicts (`worth.md`) |
| `rewards.rs` | 464 | Quest-reward advisor |
| `verdict.rs` | 175 | Shared verdict labels |
| `audit.rs` | 265 | Compare shortlist with hand-authored `Rogue.lua` and notes |

Oddities: `rewards` runs `report::compute_cells` and `worth::compute_rows` (rewards.rs:312-327),
so `rewards` re-runs the whole search grid (about 15 s). `audit` reads `Rogue.lua` and
`notable_rogue_items.md`, so it is rogue-specific by design.

### A2. Rogue-specific and hard-coded in Rust

| Item | Where |
|---|---|
| `enum Ability { SinisterStrike, Backstab, Hemorrhage, Eviscerate }` (Ambush is exported but not usable) | rules.rs:165; `ABILITIES`, `idx()`, `table_key()` model.rs:23-46 |
| Fixed-size ability arrays `casts: [f64;4]`, `ranks: [_;4]`, `RotStats` | model.rs:78, 227, 237-244 |
| Eviscerate as the only finisher; every other ability a one-CP builder | model.rs:498, 526-537; mc.rs:193; `eviscerate_damage` model.rs:100 |
| Combo point cap 5 (`evis_by_cp: [f64;6]`), energy-only resource, 80% miss refund | model.rs:513; mc.rs:213; model.rs:456-516; mc.rs:197, 209 |
| Per-ability talent multipliers (`builder_parts`), SS-only energy reduction | model.rs:423-439 |
| Backstab requires a dagger main hand | model.rs:540-542 |
| Weapon-type string literals `"sword"`, `"dagger"`, `"mace"`, `"fist"` | model.rs:203-204, 321, 410, 427, 609; mc.rs:77; armor.rs:42 |
| Talent effect fields as struct members (`ss_energy_reduction`, `evis_dmg_pct`, `bs_dmg_pct`, `sword_extra_attack_pct`, `mace_skill`, ...) | rules.rs:117-134; destructured in `TalentSums::new` model.rs:170-199; `spec_crit` model.rs:201-207 |
| Stats are Str and Agi only; AP formula coefficients per Str/Agi | model.rs:366-367, 377 |
| Weapon skill assumed to be `5 x level`; normalized speed 1.7 dagger / 2.4 other | model.rs:327-329, 426-428 |
| `ROGUE_CLASS_BIT = 1 << 3` used as the class filter | search.rs:14; used at search.rs:173, armor.rs:77, rewards.rs:114 and 342 |
| Search enumerates main-hand x off-hand only; dual wield gated by level | search.rs:182-183, 233; model.rs:228, 291 |
| Hard-coded four-ability cast printout | main.rs:231-236 |
| Rogue wording in report prose | rewards.rs:391-393, worth.rs:296 |
| Exporter filters: `AllowableClass`, cloth/leather only, rogue weapon skills, `SpellFamilyName = 8`, `player_levelstats class = 4`, rogue `why_unusable`, rogue `ABILITIES` tuple; `WEAPON_SKILL` has no two-hand subclasses and `WEAPON_SLOT` no `InventoryType 17` | export_items.py:34, 38, 204-213, 382, 662, 673, 702 |
| `dual_wield_level` is one global constant although it is class-specific | era-1.12.toml:18; model.rs:291; search.rs:225 |

### A3. What is already data-driven

Attack-table constants, `usable_weapon_types`, `dual_wield_level`, fight parameters, talent
numbers and ranks (not their meaning), racial skill, spell duration table, reference gear, player
stat coefficients, per-build weapon types, talent order, position fraction, rotation order.
Ability ranks, costs and damage coefficients come from the export; there is no `[abilities]`
section in the ruleset.

### A4. Gaps against the new goals

| Goal | Current state |
|---|---|
| Enemy-health tiers | **Not modelled.** Nothing reads mob HP. |
| Fight length as input | `fight.seconds = 20.0` scalar; not per build, not a flag. Used at model.rs:458, 598, 624 and mc.rs:170. |
| Mob level offset as input | `fight.mob_level_delta = 0`; `Prepared::new(mob_delta)` exists (model.rs:278) but every caller passes `None`. |
| Rotation per fight type | None. One static list per build; `best_by_level_md` (report.rs:205) chooses among builds only. |
| Rotation stages | None. |
| Cooldowns | None modelled. |
| Talent tier gating, prerequisites, respec | `allocate_talents` (rules.rs:298-312) spends `level - 9` points in list order, ignoring all three. Each talent takes all its ranks before the next. |
| Talent point budget | **The five rogue builds list only 22, 22, 22, 28 and 35 points against 51 at level 60** (sum of ruleset maxima per build, checked 2026-09-20). `allocate_talents` runs out of list, so up to 29 points stay unspent at high levels, and `combat_swords` puts `adrenaline_rush` and `blade_flurry` ahead of enough Combat points to satisfy their tier gates. Today's rogue numbers, and therefore the phase-0 golden set, encode an under-talented rogue. |
| Condition language | `Cond` has four forms, no combinators, `>=` only (rules.rs:176-207). |
| Class and weapon-mode variables | No `--class`; rogue only; no two-hand or shield mode. |
| CLI scenario flags | No fight-seconds, mob-delta, class, tier or stage flags. |

### A5. Duplication to remove

| Duplicated | Locations |
|---|---|
| Condition evaluation and priority pick | model.rs:482-493 and mc.rs:180-191 (verbatim match on `Cond`) |
| Finisher/builder cast resolution, energy refund, CP updates, pooling | model.rs:498-516 and mc.rs:193-217 |
| Slot and regen setup | model.rs:458-459 and mc.rs:157-158 |
| Class-mask check | search.rs:173, armor.rs:77, rewards.rs:114, 342 |
| Race-mask check | search.rs:167-174, armor.rs:78, rewards.rs:117-121 |
| Faction parse (`--faction` to mask) | main.rs:179-182 and 207-210; crosscheck omits it |
| Build lookup by name | main.rs:219-222 and 247 |
| `RunOptions` construction | main.rs:183 and rewards.rs:314-323 |
| Ability index/name tables | `idx()`, `table_key()`, `ABILITIES`, and `casts`/`ranks` arrays |

### A6. Tests and hygiene

About 32 tests: model.rs 14, search.rs 4, rewards.rs 3, verdict/audit/mc/armor 2 each,
weights/worth/report 1 each. `main.rs`, `rules.rs` and `data.rs` have **none**: no test for the
`Cond` parser or `allocate_talents`. Several tests need the real export; some silently pass when
it is absent (model.rs:929-931, mc.rs:364) while others fail (search.rs:311, weights.rs:66).
Dead-code residue: unused `Ctx.crit_base`, `hit`, `mhw` and `let _ = ...` statements
(model.rs:642-643), an `allow(dead_code)` in data.rs:6.

## B. Disposition by module

| Module | Disposition | Target |
|---|---|---|
| `main.rs` | Slim to clap plus `Scenario` construction | `main.rs`, `scenario.rs` |
| `rules.rs` | **Split**: game-wide rules stay; class data, build loading, talent allocation, `Cond` move out | `rules.rs` (global), `class/`, `engine/cond.rs`, `builds` loader |
| `data.rs` | Keep; add `mob_health`, per-class `abilities`, `base_stats` | `content/data.rs` |
| `model.rs` | **Split**: tables and mitigation to `engine/`, class logic to data, rotation walk to `solver/markov.rs`; `Prepared` becomes class-agnostic | `engine/*`, `solver/markov.rs` |
| `mc.rs` | Keep; consume the shared cast resolution and condition evaluator instead of its copy | `engine/solver/mc.rs` |
| `weights.rs` | Keep; perturbation list built from the class's stats, not fixed | `content/weights.rs` |
| `search.rs` | Generalise class/race/faction filtering (one function each); slot enumeration by `weapon_mode` | `content/search.rs` |
| `report.rs` | Add tier axis; keep API | `content/report.rs` |
| `armor.rs` | Widen usable armor types by class; remove literal `"fist"` map | `content/armor.rs` |
| `worth.rs`, `verdict.rs` | Keep; move rogue wording into class-supplied strings | `content/` |
| `rewards.rs` | Keep; stop rerunning the full grid by taking cached cells; use `Scenario` | `content/rewards.rs` |
| `audit.rs` | Keep rogue-specific; make the hand-authored file paths per-class, skip cleanly when absent | `content/audit.rs` |
| New | `engine/resource.rs`, `engine/cond.rs`, `solver/timeline.rs`, `class/*`, `plan/talents.rs`, `plan/progression.rs`, `scenario.rs` | |
| Delete | dead-code residue in A6; `Talent` struct; `enum Ability`; fixed arrays | |

## C. Post-refactor audit checklist

Run after each phase that touches the listed area, and in full after phase 6.

1. **Residual class literals.** `grep -n -E '\bEviscerate\b|\bSinister\b|"(sword|dagger|mace|fist)"|ROGUE_CLASS_BIT' src/` returns nothing outside tests. The generic word `rogue`/`energy` is *not* grepped: `engine/resource.rs` legitimately has `Resource::Energy`, `content/audit.rs` is rogue-specific by design (B), and `main.rs`/`scenario.rs` default `--class` to `rogue`. Any other hit in engine or content code is a finding.
2. **No enum of abilities in Rust.** `grep -n 'enum Ability'` is empty.
3. **Single implementations.** Exactly one condition evaluator, one cast-resolution function, one class filter, one race filter, one faction parser, one build lookup (`grep` for the old patterns from A5 returns zero duplicates).
4. **Golden set.** Rogue `out/results.json` from phase 0 matches (phase 1 exact; phase 2 within 0.01%; later phases only where a change is intended and explained).
5. **MC agreement.** `crosscheck` at levels 15, 25, 35, 45, 55 stays within the bounds recorded at phase 0 for both solvers.
6. **Tests.** New tests exist for: condition parser (each operator, precedence, error cases), `allocate_talents` and the tier-gate validator (valid, gated, prerequisite failure, respec), `extends` resolution and cycle rejection, TTK fixed-point convergence, stage selection at boundary levels. Tests that need the export **fail** with a clear message when it is absent; they never silently pass.
7. **Performance.** `cargo run --release -- run` within about 2x of the phase-0 timing; `rewards` no longer reruns the whole grid.
8. **Licensing.** `git status --porcelain` shows no JSON or generated markdown anywhere under `tools/` (the golden set lives in `tools/tuffweights/out/golden/`, inside the already-ignored tree; `.gitignore` covers `tools/.cache/`, `tools/out/`, `tools/tuffweights/out/`, `tools/tuffweights/target/` and nothing else); no DB tables or Wowhead text in tracked files, per the README's GPL rule.
9. **CLI.** Every subcommand builds a `Scenario`; `--class`, `--tier`, `--stage`, `--fight-seconds`, `--mob-delta` work on all subcommands where meaningful.
10. **Dead code.** No `let _ =` placeholders, no unused `Ctx` fields, no blanket `allow(dead_code)`.
11. **Docs.** `plans/optimal/` updated with any deviation from this plan (what changed and why).
