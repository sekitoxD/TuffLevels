# 02 — Target architecture for tuffweights

Goal: one engine that takes a **scenario** (class, build, stage, tier, level, race, faction,
optional fight length and mob level offset) and returns DPS, stat weights, and item rankings,
with all class knowledge in data files. The audit of what exists today is `06`.

## Crate layout

```
src/
  lib.rs            # re-exports; the crate becomes a library plus a thin binary
  main.rs           # clap only; builds a Scenario and calls the library
  engine/
    attack_table.rs   # miss/dodge/glance/crit tables (from model.rs)
    mitigation.rs     # armor DR, mob level offset, weapon skill (from model.rs)
    resource.rs       # Resource enum: Energy{+combo points}, Rage, later Mana
    cond.rs           # condition language: parser + evaluator (one implementation)
    solver/
      mod.rs          # trait RotationSolver
      markov.rs       # existing (cp, energy) walk, kept while it is faster
      timeline.rs     # deterministic expected-value timeline with cooldowns
      mc.rs           # Monte Carlo replay, validator for both
  class/
    mod.rs            # ClassDef loaded from rules/classes/<class>/
    abilities.rs      # AbilityDef, AbilityId
    talents.rs        # TalentTree, effects, tier-gate validator, allocation
  content/
    data.rs           # exporter JSON schema (from data.rs)
    search.rs         # loadout search (from search.rs), slot enumeration by weapon_mode
    armor.rs weights.rs worth.rs verdict.rs rewards.rs audit.rs report.rs
  plan/
    talents.rs        # greedy marginal talent ordering
    progression.rs    # spec/respec DP over levels
  scenario.rs         # Scenario struct + the single faction/race/class parsing
```

Rationale: today's `model.rs` (941 lines) mixes formulas, class logic and the rotation
walk, and `mc.rs` duplicates the rotation logic. The split lets both solvers, the search and
the planners call the same pieces.

## Class rules as data

`rules/era-1.12.toml` keeps game-wide constants (attack-table constants, crit suppression,
armor formula constants, racial skill, max level, the `[tiers]` table from doc 03). Everything
class-specific moves to `rules/classes/<class>/`, **including `dual_wield_level`** (rogue learns
it at 10; warrior later, value to be confirmed by manual lookup; it is read at model.rs:291 and
search.rs:225 and lives in `era-1.12.toml:18` today):

| File | Content |
|---|---|
| `class.toml` | Class id and bit, resource type, `dual_wield_level`, `[stats]` (AP and crit formulas: coefficients per level/Str/Agi), usable weapon types and armor types, `[export]` (spell family, ability spell names, base-stat class id) |
| `abilities.toml` | One table per ability: resource cost, cooldown, GCD use, damage kind (`weapon_pct`, `weapon_normalized`, `ap_coefficient`, `flat`), secondary resource generated or spent (combo points), requirements (weapon type, stance, positional), talent modifiers |
| `talents.toml` | One table per talent: tab, tier, column, `max`, prerequisite (talent + rank), effect list |

### Abilities become data

- `enum Ability` (rules.rs:165) and the fixed arrays (`casts: [f64;4]`, `ranks: [_;4]`,
  `RotStats`) are replaced by an `AbilityId` index into a `Vec<AbilityDef>` built at load.
- Rogue's special cases (Eviscerate as the only finisher, 5-CP cap, Backstab dagger
  requirement, Sinister Strike energy reduction, `builder_parts` per-ability multipliers)
  become fields on the ability records: `spends = "combo_points"`, `requires.weapon =
  "dagger"`, and modifier entries. No ability name appears in Rust.
- Ability rank numbers still come from the export (`abilities.<class>`), keyed by the ability
  name in `abilities.toml`. `main.rs`'s hard-coded four-ability cast printout is generated from
  the class definition.

### Talent effects become generic

Replace the fixed `Talent` struct (rules.rs:117-134: `hit_pct`, `crit_pct`, `ss_energy_reduction`,
`evis_dmg_pct`, ...) with:

```toml
[talents.aggression]
tab = "combat"  tier = 3  column = 2  max = 3
effects = [ { effect = "damage_pct", scope = { ability = ["sinister_strike","eviscerate"] }, per_rank = 2.0 } ]
```

- `effect` is drawn from a small closed vocabulary in Rust (`hit_pct`, `crit_pct`, `damage_pct`,
  `crit_damage_add`, `ap_pct`, `resource_cost_add`, `weapon_skill`, `extra_attack_pct`,
  `haste_pct`, `resource_gain_pct`).
- `scope` is data: `all`, or by ability names, or by weapon type.
- Per-rank arrays (as `ss_energy_reduction` uses) are allowed: `per_rank = [3.0, 5.0]` means
  totals at rank 1 and 2.
- One function evaluates all effects; `TalentSums::new` (model.rs:170-199) and `spec_crit`
  (model.rs:201-207) disappear.

## Resource models

A small Rust enum with behaviour driven by the ability data:

| Resource | Behaviour | First user |
|---|---|---|
| Energy + combo points | 20 energy per 2 s tick, cap, CP cap of 5, missed special refunds a fraction | rogue |
| Rage | Generated from damage dealt (per swing) and damage taken; spent by abilities; no passive regen | warrior |
| Mana | Regen with spirit, five-second rule | casters, later |

Rage generation constants are **not** assumed; they are confirmed against cmangos
`Unit::RewardRage` before the rage model is used (manual-lookup queue item 5, doc 01).

## Solvers

One trait, three implementations, sharing ability definitions, the condition evaluator, and the
attack-table and mitigation code.

| Solver | Approach | Use |
|---|---|---|
| `markov` | Expected value over `(cp, energy)` states, one decision per GCD | Fast; used by the search across thousands of loadouts. Rogue. |
| `timeline` | Deterministic expected-value walk along the fight timeline, tracking cooldowns, GCD, resource, buffs | Cooldown-driven classes (warrior). Also usable for rogue once cooldown abilities such as Adrenaline Rush are modelled. |
| `mc` | Random replay of the same rules | Validator. `crosscheck` compares it to the analytic solvers. |

Decision rule for retiring `markov`: it is removed only if `timeline` matches it within 0.5%
DPS on the rogue golden set (doc 07 phase 0) **and** the full `run` stays within about 2x of
today's time (about 15 s for the grid). Otherwise both stay.

Deduplicated in this change: condition evaluation and priority pick (model.rs:482-493 and
mc.rs:180-191), finisher/builder cast resolution (model.rs:498-516 and mc.rs:193-217), and the
slot and regen setup (model.rs:458-459 and mc.rs:157-158).

## Condition language

`Cond` today supports `positional`, `talent:<name>`, `cp >= N`, `energy >= N` with no
combinators. Replace with a parsed expression:

```
expr     := or
or       := and ("or" and)*
and      := not ("and" not)*
not      := "not" not | cmp
cmp      := value (("<"|"<="|">"|">="|"=="|"!=") value)?
value    := number | variable | "ready:" ability | "buff:" name | "talent:" name | "(" expr ")"
variables: cp energy rage positional            (state every solver has)
           enemy_hp_pct time_left               (timeline and mc only)
```

Semantics an implementer needs:

- A bare value (no comparison) is true iff it is non-zero. `talent:x` is the rank (so true when
  ranked), `positional` is 1 or 0, `ready:<ability>` is 1 when off cooldown, `buff:<name>` is 1
  while active.
- `ready:`, `buff:`, `enemy_hp_pct` and `time_left` need state that only the `timeline` and `mc`
  solvers have. The `markov` solver rejects a rotation that uses them, at load time, with the
  file and line. Phase 4 rotations therefore use only `cp`, `energy`, `positional`, `talent:`.
- There is no `dodge_proc` variable. The event it stood for (Overpower or Riposte becoming
  usable after a dodge) is modelled as a named buff (`buff:overpower_window`) with a duration
  from the ability data and a per-swing trigger chance drawn from the attack table, in
  `timeline` and `mc` only (phase 5/6).

One parser and one evaluator in `engine/cond.rs`, validated when a build loads (unknown
variable, ability, buff or talent names are load errors, as `Build::validate` does for talents
now), with unit tests for every operator, precedence and the error cases.

## Weapons and slots

Each build declares `weapon_mode = "dual_wield" | "two_hand" | "one_hand_shield"`. `search.rs`
enumerates slots from it (today it assumes main-hand x off-hand). Weapon type names come from
the class definition rather than string literals (`"sword"`, `"dagger"`, `"mace"`, `"fist"` at
model.rs:203, 321, 410, 427, 609, mc.rs:77, armor.rs:42). Armor valuation (`armor.rs`) is
widened to the class's usable armor types.

## Scenario

```
Scenario     { class, build, stage, tier, level, race, faction,
               fight_seconds: Option<f64>, mob_delta: Option<i32> }        // one point
ScenarioGrid { class, builds: Vec, levels: RangeInclusive, tiers: Vec,
               race, faction, fight_seconds, mob_delta }                   // expands to Scenarios
```

`Scenario` is the unit the engine evaluates; `ScenarioGrid` is what `run`, `rewards` and
`crosscheck` build (`report::compute_cells` iterates it). `explain` and `mc` build a grid of one.
Every subcommand gets its grid via a single `ScenarioGrid::from_args`, replacing the duplicated
faction parsing (main.rs:179-182 and 207-210), build lookup (main.rs:219-222, 247) and
`RunOptions` construction (main.rs:183 and rewards.rs:314-323). `Prepared::new` already takes
`mob_delta: Option<i32>`; it is finally wired to input.

## Fight length

Not a constant. `fight_seconds = enemy_hp / (dps x party_multiplier)`, where `enemy_hp` comes
from the tier and level (doc 03), `dps` from the solver, and `party_multiplier` is 1.0 except in
the `dungeon` tier (doc 03). The rotation depends on fight length (pooling, cooldown use), so
the value is found by fixed-point iteration: start from the tier's default length, solve,
recompute, stop when it changes by under 1% or after 8 iterations (report if it does not
converge). `--fight-seconds` overrides it for what-if runs.

**Cost control.** The search scores the full main-hand x off-hand cross product per build and
level (search.rs:182-183, 233), so iterating per loadout would multiply solver work by up to 8.
Instead the fixed point is solved **once per (build, level, tier)** with a representative loadout
(the previous level's best loadout, or the reference gear at the first level) and that fight
length is held fixed across the loadout search. The full fixed point runs only on the top-N
loadouts in a refine pass; if the refined length differs from the held one by more than 5%, the
search is repeated once with the refined length. Phase 4 accepts on a timing check (doc 07).
