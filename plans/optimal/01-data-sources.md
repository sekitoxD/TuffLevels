# 01 — Data sources

Two sources, in this order of authority: (1) the local cmangos 1.12 DB, (2) manual
Wowhead lookups for what the DB lacks. Nothing else is trusted for numbers.

## 1. The local cmangos DB

MariaDB 11 in Docker on `10.0.0.200:3320`, database `classicmangos`, read-only user.
cmangos classic-db plus mangos-classic DBC data, patch 1.12.1: close to Classic Era, not
identical. Credentials are in `~/.config/tuff/qdb.env` (variables `QDB_HOST`, `QDB_PORT`,
`QDB_USER`, `QDB_PASSWORD`, `QDB_DB`); never print them.

Access: `tools/qdb.py` (`qdb.connect()`, `qdb.query(conn, sql, args)`, `pymysql`), used by
`tools/export_items.py` and `tools/validate_route.py`. A one-off query:

```
cd tools && python3 - <<'EOF'
import qdb; c = qdb.connect()
print(qdb.query(c, "select count(*) n from quest_template"))
EOF
```

Escape a literal `%` as `%%` when passing args.

The original runbook was deleted in commit 0869a80 ("removing completed plans"). It is in
history: `git show 0869a80^:plans/db-runbook.md` (also `request-for-db.md`, `db-checkpoint.md`).

### What it can answer

| Need | Where |
|---|---|
| Items, weapons, armor, stats, procs | `item_template`, joined to `spell_template` for item spells |
| Item sources | `creature_loot_template`, `reference_loot_template`, gameobject loot, `npc_vendor`, quest rewards |
| Quests, chains, reward choices, reputation gates | `quest_template` (`PrevQuestId`, `NextQuestInChain`, `RewChoiceItemId1-6`, `RequiredMinRepFaction`), `creature_questrelation`, `creature_involvedrelation` |
| Enemy health and armor by level and rank | `creature_template` (`Rank`, `HealthMultiplier`, `ArmorMultiplier`) x `creature_template_classlevelstats` (`BaseHealthExp0`, `BaseArmor`) |
| Player base stats and HP | `player_levelstats`, `player_classlevelstats` |
| Class ability numbers per rank | `spell_template` (`Effect1-3`, `EffectBasePoints`, `ManaCost`, `PowerType`, `SpellFamilyName`), `spell_chain` |
| Talent effect values per rank | `spell_template` rows named `Improved ...` etc. |
| Trainer level and cost | `npc_trainer`, `npc_trainer_template` (`reqlevel`, `spellcost`) |
| Dungeon level ranges, spawns | `instance_template`, `areatrigger_teleport`, `creature.map`, `instance_dungeon_encounters` |

### What it cannot answer (verified absent 2026-09-20)

| Gap | Consequence |
|---|---|
| **No talent tree tables** (`talent`, `talent_tab`) | Tree layout (tab, tier, column, prerequisites, max rank) must be hand-authored. Per-rank values can be checked against `spell_template`. |
| No `skill_line_ability` | Skill-to-spell mapping is partial (`playercreateinfo_skills`, trainer `reqskill`). |
| No `areatable` / `map` | No zone or map names; `ZoneOrSort` is a bare number. |
| No quest XP | Objectives are DPS-based, not XP/hour. |
| Cast time, duration, range as index columns only | The existing `[spell_duration_s]` table in the ruleset was calibrated from few spells; treat as uncertain. |
| A trainer's `spell` is the learn-spell, not the ability spell; `spell_learn_spell` has only 9 rows | Ability-to-trainer-level mapping needs `spell_chain` plus a manual check. |

### Enemy health (new requirement)

Health per mob = `HealthMultiplier x BaseHealthExp0` where the base comes from
`creature_template_classlevelstats` for the mob's `UnitClass` and level. Rank values:
0 normal, 1 elite, 2 rare elite, 3 world boss, 4 rare.

Query to reproduce the reference table (`%s` = level, three times):

```sql
select Rank, count(*) n, round(avg(HealthMultiplier),2) avg_hm,
       round(avg(HealthMultiplier*cls.BaseHealthExp0)) avg_hp
from creature_template ct
join creature_template_classlevelstats cls on cls.Level=%s and cls.Class=ct.UnitClass
where ct.MinLevel=%s and ct.MaxLevel=%s
group by Rank order by Rank
```

Reference values (checked 2026-09-20, mobs whose min and max level both equal the level):

| Level | Rank 0 avg HP | Rank 1 avg HP | Rank 2 avg HP | Rank 4 avg HP |
|---|---|---|---|---|
| 20 | ~488 | ~1733 | ~1401 | ~484 |
| 40 | ~1829 | ~7857 | ~5334 | ~1581 |

Caveats: the sample is thin at some levels (3 rank-2 mobs at 20, 1 at 40); elite multipliers
vary a lot (0.001 to 8 at L20, 3 to 10 at L40); `creature_template_armor` is a stale duplicate
and is ignored. **This reference query is illustrative only:** requiring `MinLevel = MaxLevel`
drops about 31% of level 1-60 creatures (those spanning a level range), and rank-0 mobs are
nearly homogeneous (at L20, 184 of 194 have `HealthMultiplier` exactly 1.0; at L40, 241 of 267
sit at 1.15), so their HP differs mostly by `UnitClass` base health.

**Exporter query (the one tiers are built from).** For each level L, take every creature whose
`[MinLevel, MaxLevel]` contains L, and compute its health at L as
`HealthMultiplier x BaseHealthExp0(L, UnitClass)`. The stored `MinLevelHealth`/`MaxLevelHealth`
columns are cross-checked against this (they agreed in the survey, except a few rank-1 rows
where `MinLevelHealth = 0`, which are skipped). Group by tier (definitions in doc 03) and write
median HP per tier and level to `world.mob_health`, plus the sample size `n`; a tier with fewer
than 10 samples at a level is flagged, and borrows from the neighbouring level.

Dungeon HP comes from joining `creature.id` to `creature_template.Entry` filtered by
`creature.map in (select map from instance_template)`; dungeon bosses are rank 1-2 with
multipliers of roughly 4.5 to 13.

## 2. Wowhead (manual only)

Findings from the 2026-09-20 probe:

- The site's terms (Fanbyte EULA, linked from `wowhead.com/tos`) forbid access by
  "spiders, robots, crawlers, data mining tools or the like" and copying or redistribution.
  `robots.txt` allows item, quest, spell and guide paths for generic agents but disallows named
  AI crawlers entirely. So **no fetcher script is built**, and a browser user agent must not be
  used to route around that.
- `/classic/` is the only Classic site. It mixes Classic Era, Season of Discovery and Hardcore
  data ("1.13.0" patch tags are Era-client numbering; the talent calculator is SoD-branded). It
  is **not a pure 1.12 source**, so it never overrides the cmangos DB.
- Its extra value over the DB: crowd-sourced drop percentages, comment-thread quirks, rendered
  tooltips and class guides. All are advice or sanity checks, not 1.12 fact.

### Recording rules

| May be recorded | Must not be recorded |
|---|---|
| Item, quest, spell IDs and names (individual facts a human selected, per the GPL rule in the README) | Tooltip HTML, page text, guide prose, comment text |
| A number the tool needs (talent max rank, prerequisite, respec cost step, drop %) | Raw page dumps or downloaded files |
| A source note in a comment: `# wowhead, checked 2026-09-20` | Anything from user comments (licensed to the site owner) |

A lookup is done by a person or one page at a time by the assistant on request, at low rate,
with no loops and no browser user-agent spoofing (approved by the user 2026-09-20 for the queue below).
If a number affects a ranking, it is confirmed a second way (DB row or in-game) or flagged.

### Manual-lookup queue

| # | Fact needed | Why | Needed by phase |
|---|---|---|---|
| 1 | Rogue talent tree layout (three tabs: tier, column, max rank, prerequisites) | `talents.toml` and the tier-gate validator | 3 |
| 2 | Warrior talent tree layout (Arms, Fury, Protection) | same | 6 |
| 3 | Respec cost curve (first cost, step, cap) and whether it resets | `progression` respec cost | 7 |
| 4 | Level at which Mortal Strike (Arms 31-point talent) becomes available, and the trainer that teaches it | warrior stage entry | 6 |
| 5 | Warrior rage generation and Heroic Strike / Cleave next-swing behaviour, confirmed against cmangos `Unit::RewardRage` | rage resource model | 5 |
| 6 | Drop-rate sanity check for the handful of items a build's top loadout depends on | tier classification | 7-8 |
| 7 | Per-class leveling advice, only as *hypotheses* to test in the tool | doc 04 candidate builds | 6 |

Talent effect values that are not in `spell_template` (for example spec-level modifiers with
no spell row) are recorded as "manual check" in the talent file, not guessed.

## 3. Exporter changes

`tools/export_items.py` (799 lines) currently filters for rogue in SQL: `AllowableClass`
(:204-213), cloth and leather only (:211), rogue weapon skills (:34), `SpellFamilyName = 8` (:673),
`player_levelstats` for class 4 (:702).
Target behaviour:

- Read `rules/classes/<class>/class.toml` (`[export]`: class id, class bit, spell family,
  ability spell names) instead of hard-coded tuples such as `ABILITIES`.
- Export items **once**, without the class filter beyond dropping items nobody can use. Class
  filtering moves to Rust, driven by the class definition (usable weapon skills, armor types).
  All exporter widening happens in phase 2 (doc 07), with these concrete additions:
  `WEAPON_SKILL` (export_items.py:34) gains two-hand axe (1), two-hand mace (5), polearm (6),
  two-hand sword (8) and staff (10); `WEAPON_SLOT` (:38) gains `InventoryType 17`
  (`two_hand`); the armor subclass filter (:211) widens from 0/1/2 to include mail (3) and
  plate (4), and shields (6) for `one_hand_shield`.
- Export `abilities.<class>`, per-class and per-race `base_stats`, `mob_armor` (already there)
  and new `mob_health` by tier and level (tiers defined in doc 03).
- Output stays in gitignored `tools/.cache/`.
