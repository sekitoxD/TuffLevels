# 04 — Leveling spec, respec and talent-order research

Question set: which spec to level as, when to respec, what order to spend talent points in, and
what to do when the best weapons available are for a different weapon type than the spec
specialises in. All answered by running the same engine (`02`), from the same data (`01`), and
never asserted from memory. Candidate builds below are **hypotheses for the tool to decide**.

## Method

### 1. Score every candidate build at every level

`run` (extended by `03`) gives DPS per build x level x tier with the best obtainable weapons
for that build at that level (acquisition tier from `search::Tier`: vendor, quest-solo, crafted,
quest-group, open-drop, quest-dungeon, dungeon-drop, world-drop). This already exists for rogue
weapons; it is extended with enemy-health tiers, two-hand and shield modes, and the warrior class.

### 2. `talents` subcommand: greedy marginal talent order

For each level from 10, with (level - 9) points available:

1. Enumerate talents that can take a point under tier gating (5 points in the tab per tier above
   the first) and prerequisites.
2. Score the marginal DPS of one more rank in the given scenario (mean over the tier mix and
   level-bracket weights defined in doc 03).
3. Take the best, record it, continue.

Output: a suggested order per build, plus a diff against the hand-authored `progression` in
`build.toml`. Limits, stated up front:

- Greedy is not optimal: a low-value talent can unlock a strong one. The tool therefore also
  scores "reach talent X" by the total DPS of the path to it, and lists the difference.
- It only sees DPS. Utility and survivability talents (lockpicking-related, escapes, threat,
  stun immunity) are **pinned** in `build.toml` at a chosen position and excluded from the greedy
  search, so a human decision is not overridden by a DPS number.

### 3. `progression` subcommand: spec and respec over levels

Dynamic programming over levels 10-60. State = (current build, stage). Transition at each level
= stay, or respec to another build at a cost. Value = DPS-weighted tier mix for that level with
the best weapons whose acquisition tier is allowed in that level's window (reusing `worth` and
`tier_of`).

- **Respec cost** comes from the manual-lookup queue (doc 01, item 3), not from memory.
  Until confirmed, `progression` treats it as a ruleset parameter with a flagged default.
- **Limits:** at most N respecs (default 2), configurable.
- **Objective:** DPS proxy. There is no quest XP in the DB, so kills per hour is approximated as
  `1 / (time to kill + fixed overhead per kill)`; the overhead is an assumption printed in the
  report header.
- **Regret table:** per level bracket, the DPS lost by forcing a single build or a single weapon
  type against the best available option. This is the direct answer to "the recommended best
  weapons are all for a different weapon type than the specialisation".

### 4. Human review

The tool's output is reviewed by the user before it goes into a route note. The tool advises;
the route content stays hand-authored.

## Candidate builds (hypotheses)

### Rogue

| Build | Weapon focus | Note |
|---|---|---|
| `combat_swords` | sword | Existing; standard solo build |
| `combat_maces` | mace | Existing; Mace Specialization stun is not modelled (known gap) |
| `combat_fist` | fist | Existing |
| `dagger_assassination` | dagger | Existing; positional (`position_fraction` 0.6) |
| `dagger_subtlety` | dagger | Existing |

The mismatch case: the Rogue weapon-upgrade notes (`plans/classes/notable_rogue_items.md`,
`Rogue.upgrades`) show best-in-window weapons of one type (for example maces at some levels)
while the popular solo spec specialises in swords. `progression` quantifies it: per bracket,
DPS for "swords spec with best sword" versus "swords spec with best mace (no spec bonus)"
versus "maces spec with best mace", and the respec cost between them.

### Warrior

| Candidate | Description | Question it answers |
|---|---|---|
| `arms` | Arms straight through, Mortal Strike at its trainer/talent level | Baseline single-spec plan |
| `fury_two_hand` | Fury talents with a two-hand weapon early, then respec | The user's example: start two-handed Fury, respec at Mortal Strike |
| `fury_dual_wield` | Fury with dual wield | Does dual wield beat two-hand before the Arms 31-point talent |

Warrior facts to confirm before modelling (manual queue, doc 01): Mortal Strike is the Arms
31-point talent and so becomes available at level 40; which talents each stage needs; whether the
Fury two-hand approach relies on talents that only work in a given stance. The tool's answer
(respec at level 40, or never, or earlier) is a result, not an input.

Warrior stage rotations (doc 03): `arms/pre_mortal_strike` and `arms/post_mortal_strike`, each
with low/medium/high/dungeon tiers. The pre-Mortal-Strike rotation is the "before" that the
respec decision is judged against.

## Talent trees

`rules/classes/<class>/talents.toml`, hand-authored from knowledge of the 1.12 trees and
verified two ways:

1. **Per-rank values** against `spell_template` (talent-rank spells such as "Improved ..." rows).
   A mismatch is recorded in the file as a comment with the spell id, and the DB value wins.
2. **Layout** (tab, tier, column, max rank, prerequisite) through the manual-lookup queue,
   flagged `verified = false` until checked. The tool warns when a run depends on an unverified
   talent.

The validator enforces: talents per tier need `5 x (tier - 1)` points already in the tab;
prerequisites are satisfied; total points equal `level - 9` at every level up to the build's last
level (the list is long enough, no silent under-spending); a respec wipes all points, the earlier
order is truncated at the respec level, and the respec's own `progression` is a full order that
is validated from zero (same wording as doc 03).

**Existing rogue builds fail these rules today.** Summing the ruleset's talent maxima against
each build's list gives 22 points (`combat_swords`, `combat_maces`, `combat_fist`), 28
(`dagger_assassination`) and 35 (`dagger_subtlety`), against 51 available at level 60. Because
`allocate_talents` (rules.rs:298-312) simply runs out of list, the current rogue numbers leave up
to 29 points unspent at high levels, and `combat_swords` lists `adrenaline_rush` and
`blade_flurry` with too few Combat points ahead of them for the tier gates. Extending all five
lists to a valid 51-point order is an explicit phase 3 deliverable (doc 07); expect DPS at high
levels to move **up** when it lands, which is a correction, not a regression.

## Outputs

- Per class: `plans/optimal/results/<class>.md` (hand-written summary of run results: chosen
  build path, respec level, talent order, per-tier rotation guidance). Per the GPL rule in the
  README, these are individual facts a human selected and re-typed (the recommended build, the
  respec level, a handful of named items with the number that justifies them), never pasted
  report tables or exported lists. The user decided (2026-09-20) that summaries of this size are
  small enough to commit (when a commit is requested).
- Feeds `plans/classes/notable_<class>_items.md` (item targets) and route notes (doc 05).

## Known unknowns

- Exact respec cost curve and whether the counter resets over time.
- Warrior rage constants (`Unit::RewardRage`) and next-swing ability behaviour.
- Talent values with no spell row (spec-level modifiers).
- Any exception to the 5-points-per-tier rule in 1.12.
- Whether the 20 s to time-to-kill change moves any existing rogue ranking (the golden set,
  doc 07 phase 0, will show it).
