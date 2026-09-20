# 03 — Builds, rotations, enemy-health tiers, scenario variables

## Folder layout

`tools/tuffweights/builds/` is split by class, then by build, then by rotation stage, with one
rotation file per enemy-health tier.

```
builds/
  rogue/
    combat_swords/
      build.toml
      default/
        low.toml  medium.toml  high.toml  dungeon.toml
    combat_maces/  combat_fist/  dagger_assassination/  dagger_subtlety/   (same shape)
  warrior/
    arms/
      build.toml
      pre_mortal_strike/   low.toml medium.toml high.toml dungeon.toml
      post_mortal_strike/  low.toml medium.toml high.toml dungeon.toml
    fury_dual_wield/
      build.toml
      default/ ...
    fury_two_hand/         (candidate, see doc 04)
```

- The five existing rogue builds (`combat_swords`, `combat_maces`, `combat_fist`,
  `dagger_assassination`, `dagger_subtlety`) move under `builds/rogue/`. Their single rotation
  becomes the starting point for all four tiers, then is tuned per tier.
- A build with one rotation uses a stage named `default`.
- `load_builds` walks `builds/<class>/<build>/` instead of reading flat `*.toml` files.

## `build.toml`

```toml
name = "arms"
class = "warrior"
description = "..."
weapon_mode = "two_hand"          # dual_wield | two_hand | one_hand_shield
weapon_types = ["two_hand_sword", "two_hand_mace", "polearm"]   # from the class definition
position_fraction = 1.0           # unchanged meaning: share of fights with positional access

# Talent progression: order in which points are spent. Validated against the tier gates and
# prerequisites in rules/classes/<class>/talents.toml. Level L has (L - 9) points to spend, and
# the list must be long enough to spend all of them up to the build's last level (51 at level 60).
progression = ["improved_heroic_strike", "deflection", "..."]

# Optional respec (as in the game, it wipes every point). At `at_level` the points spent so far
# are discarded, the earlier `progression` is truncated at that level, and `progression` below is a
# FULL order that spends (level - 9) points from scratch (cost from the ruleset).
[[respec]]
at_level = 40
progression = ["..."]

[[stage]]
name = "pre_mortal_strike"
# active until the next stage's entry condition is met
[[stage]]
name = "post_mortal_strike"
available_from = { ability = "mortal_strike" }   # or { level = 40 }
```

A stage becomes active when its `available_from` holds for the character at that level
(ability known via trainer level plus talent points, or a plain level). The last matching stage wins.

## Rotation files (`<stage>/<tier>.toml`)

```toml
extends = "low.toml"             # optional; entries below are appended/overridden by ability name

[[rotation]]
ability = "eviscerate"
when = "cp >= 5"                 # phase 4 rotations use only cp/energy/positional/talent: (see 02)

[[rotation]]
ability = "sinister_strike"
```

Priority list, same rule as today: first entry whose `when` holds and whose cost is affordable
is cast (pool if not affordable). Conditions use the grammar in `02`; `time_left`,
`enemy_hp_pct`, `ready:` and `buff:` become available with the timeline solver (phase 5).
`extends` avoids copying whole files between tiers. Two legal forms: `"<tier>.toml"` (same
stage) and `"../<stage>/<tier>.toml"` (another stage of the same build). The loader resolves it
and rejects cycles and paths outside the build's folder.

Each rotation file may also carry a short `notes` string for the player-facing explanation
(kept factual: "skip Rend below 10 s left").

## The four tiers

Defined from **enemy health**, so the tool never uses a long-fight rotation on a short fight.
Because ordinary (rank 0) mobs are nearly homogeneous in HP at a given level (doc 01), the
low/medium split cannot come from the HP spread alone. A tier is a population **plus a default
level offset**, both in the ruleset `[tiers]` table (assumptions, printed in every report header):

| Tier | Population (per level L, from the exporter query in doc 01) | Default `mob_delta` | Default `party_multiplier` |
|---|---|---|---|
| `low` | rank 0 mobs whose range contains L, HP at the 25th percentile | 0 | 1 |
| `medium` | rank 0 and rank 4 (rare) mobs whose range contains L+2, HP at the median: the yellow/orange pulls and rares | +2 | 1 |
| `high` | rank 1-2 mobs not on an instance map, whose range contains L+2, median HP | +2 | 1 |
| `dungeon` | rank 0-2 mobs on an instance map (`creature.map in instance_template`) whose range contains L, median HP | 0 | 4 (assumption: four other players add DPS) |

`fight_seconds = enemy_hp / (dps x party_multiplier)` (doc 02). The `dungeon` tier is the only
one where the rotation is judged on the player's own DPS but the fight length is set by the group,
so `dungeon` rotations are the long-sustained ones without a solo TTK of hundreds of seconds.
The user decided (2026-09-20) to keep `dungeon` as the fourth tier; the party multiplier stays
an assumption printed in every report header.

Reference health (2026-09-20, hand-typed from the illustrative query in doc 01): at level 20
normal mobs average about 488 HP and elites about 1733; at level 40, about 1829 and about 7857.
The tier medians themselves are computed at export time into `world.mob_health`, not typed.

**Degeneracy check.** At export time and again when a report is written, if two adjacent tiers
have medians (including the offset) that differ by less than 15% at a level, the report says so
and marks the lower tier's rotation as "not distinct at this level". The tier files stay separate
(the user asked for four), but results are not presented as if the rotations were tested on
different fights when they were not.

**Tier mix.** Where a single number per level is needed (the `progression` objective, the
greedy `talents` scorer) the four tiers are combined with default weights, in the ruleset,
stated as assumptions, adjustable per class:

| Level bracket | low | medium | high | dungeon |
|---|---|---|---|---|
| 10-29 | 0.60 | 0.30 | 0.05 | 0.05 |
| 30-49 | 0.50 | 0.30 | 0.10 | 0.10 |
| 50-59 | 0.40 | 0.30 | 0.10 | 0.20 |

Rationale: leveling is mostly ordinary pulls, with dungeon share rising at higher levels as
solo quests thin out. These weights are judgment calls, not data; the tool prints them.

## Rotation stages within a build

Each stage is its own set of four tier files. Example for the warrior request: arms **before**
Mortal Strike (`pre_mortal_strike/`) and arms **after** it (`post_mortal_strike/`) are separate
directories with separate rotations, because Mortal Strike changes which ability is the main
attack and how rage is spent. Rogue builds gain stages the same way when an ability that changes
the rotation appears (for example a cooldown gained from a talent).

## Scenario variables and CLI

`--class`, `--build`, `--stage`, `--tier`, `--level` (or `--min-level/--max-level` for grids),
`--fight-seconds`, `--mob-delta`, `--race`, `--faction` are global-style flags shared by every
subcommand through one `Scenario`. Defaults keep today's behaviour working: with only the rogue
class present, `--class` defaults to `rogue`.

Existing subcommands (`run`, `rewards`, `explain`, `mc`, `crosscheck`) keep their names. New
ones: `talents` and `progression` (doc 04). `run` gains a tier axis in `results.json` (a `tier`
key per cell) and the markdown reports (build x level x tier), scheduled in phase 4a (doc 07).
Results for `--tier` unset are reported for all four tiers and the tier mix above.

## Validation done at load

- Every ability, talent, variable and stage name in a build resolves, or the load fails with the
  file and line.
- Talent progression satisfies tier gates (5 points in a tab per tier above the first) and
  prerequisites; each respec's new order is validated on its own.
- A build has all four tier files for each stage, or the missing ones are named in a warning and
  the nearest lower tier is used (never silently).
