# Notable quests and quest chains by faction (1-60)

Research notes on the quests and chains that leveling guides repeatedly call "big ticket" for
power-leveling, plus the class-specific chains that change how fast a character levels (for example the
Warrior Whirlwind Axe chain). Purpose: give route authoring a shortlist of what is worth building a
route around and what is worth a detour. Nothing here is loaded by the addon, and nothing here is
implemented yet; this is research to build the quest ordering from.

Companion to `../classes/`, which covers weapon and gear rewards per class. Follows the workflow in
`../03-route-folder-layout-and-class-research.md`: a human reads these notes, decides, and writes the
step. Nothing here should be turned into automatic step selection.

| Faction | File |
|---|---|
| Horde | [notable_horde_quests.md](notable_horde_quests.md) |
| Alliance | [notable_alliance_quests.md](notable_alliance_quests.md) |

Each file has the same layout: a top-picks table, levels 1-30, levels 31-60, dungeon quest bundles,
class-specific chains, flight paths and unlocks, traps and skips, then conflicts and open items.

## How to read the entries

- **"N srcs"** is the number of independent sources that list the quest or chain. Entries with four or
  more are the strongest candidates. Several pages on one domain count once.
- **Group?** says whether the quest needs a dungeon or a group. Dungeon bundles are only worth adding
  when the route already passes the dungeon.
- **Priority tags** on class chains: **TOP** (changes leveling speed), **WORTH IT**, **OPTIONAL**.
- **Levels** are where the sources place the quest, not the quest's minimum level; they drift by 2-4
  levels between guides.
- **XP** figures are per-quest values from Warcraft Tavern, Zockify or IV dungeon pages. "Raw XP"
  zone totals come from WIC and were read from a machine-translated page. "Sum" is arithmetic over the
  listed values.
- Race-locked entries are marked. Classic Era has no Horde Paladin, no Alliance Shaman, and neither
  Blood Elves nor Draenei.

## Sources

Abbreviations used inside the files:

| Tag | Source |
|---|---|
| WT | warcrafttavern.com (Nightfall's Horde guide, Judgement's Alliance guide, dungeon quest pages) |
| IV | icy-veins.com (class quest pages, dungeon quest pages, leveling route) |
| WIC | wowisclassic.com (read as a French page; not readable for Alliance 31-60) |
| ZK | zockify.com (dungeon quest pages, class leveling guides) |
| NTB | noobtoboss.com |
| WH | wowhead.com (only readable guide pages and search-result summaries) |
| SG | sageguide.net (Alliance route) |
| LW | legacy-wow.com (Alliance route) |
| JW / WP | wow-pro.com "Jame's" guides (a 2007 guide) |
| WCL | wowclassicleveler.com |
| CDB | classicdb.ch (database pages, the only ones that were read directly) |
| WWG | warcraft.wiki.gg |
| others | GR gamerant, TG thegamer, MGW magicgameworld, TTH tentonhammer, TAGN, AL almarsguides, BF Blizzard forums |

## Limits worth knowing before anything gets copied into a route

1. **No quest ID, NPC coordinate or item ID was verified against a database.** Wowhead renders
   client-side and could not be read. Only four ClassicDB pages were read directly (Alliance side). Before
   promoting an entry to a step, look the quest up and record its ID and URL in the step `note`, per
   Plan 3.
2. **The sources disagree in places**, and the files keep those disagreements visible rather than
   resolving them. Each file ends with a list of unresolved conflicts.
3. **WT and the 2007 JW/WP guide share a route**, so their agreement is one voice, not two. Likewise IV
   defers to Sage's guide for Alliance zone routing.
4. **Overland quest XP is mostly unsourced.** Only dungeon-quest XP and a few zone aggregates exist.
5. **The Alliance class-quest pass was cut short by a rate limit** and is a single pass; treat it as
   lower confidence than the Horde class file.
6. Level 60 endgame chains (Rhok'delar, Charger, Dreadsteed, Onyxia attunement and the like) are
   mentioned at most as one-liners; they are outside "fastest way to 60".

## Corrections this research makes to `../classes/`

These are recorded in each faction file and have **not** been applied to the class notes:

- The Warrior Whirlwind chain starts with **The Islander** at the class trainer, then The Affray (Berserker
  Stance), then The Windwatcher. It does not start with Bath'rah. The reward is a choice of Axe, Sword or
  Warhammer.
- **Big Game Hunter is not Hunter-only.** It is open to every class, needs level 28 and a 12-quest Stranglethorn
  Safari chain, and the Master Hunter's Rifle option is confirmed.
- **The Mage wand and orb chains start with the class trainers** (Deino / Uthel'nay for Horde), not
  Tabetha, who is the middle of the chain. Wand materials are unsettled between reads.
- **Paladin Summon Warhorse is short and free.** "Long and expensive" describes the level 60 Charger.
- **Cat, Travel and Dire Bear Form look like trainer spells**, not quests.
- **Marshal Maxwell is in the Burning Steppes**, and there is no Maxwell step in the Sunken Temple attunement.
- **Venture Company Mining** was not confirmed at level 31 (Warcraft Tavern picks it up at 43), and **The Perfect
  Poison** was not found in any source.
- The Rogue poison chain step names, and the Warlock Small Soul Pouch and Box of Souls rewards, need
  rechecking.

## Cross-faction findings

- **The biggest quest-driven speed wins are the free level 40 mounts** (Paladin Summon Warhorse, Warlock
  Summon Felsteed) **and the level 10 unlocks** (Tame Beast, Voidwalker, Bear Form, Defensive Stance). The weapon
  chains (Whirlwind, Verigan's Fist) are the ones that cost real detour time.
- **Whirlwind Weapon is contested.** IV says start at 30; others say it is realistically a 38-40 solo job
  because of level 38-39 elite charm mobs and a level 40 elite boss; ZK and one IV warrior guide say skip it.
  The Berserker Stance half is worth doing either way. The chain needs Fray Island in the Barrens, which is a
  detour for Alliance.
- **Both factions have a "dungeon quest run" that guides rank above grinding**: Zul'Farrak at 44-50 for both,
  the Stockade for Alliance at 22-30, and Blackfathom Deeps / Wailing Caverns for Horde. Their value depends
  on already being in position.
- **Un'Goro, Felwood, Winterspring and the Plaguelands are the agreed 50-60 zones** for both factions.

## DB verification of the corrections above (checked 2026-09-19)

Snapshot: cmangos `classic-db` `22b51464f1625f6ef6275771de1f5466c6f5d19e` + `mangos-classic`
`8ec338a1704e7dcb1c0213eb7ed58f9231ade40f`, imported 2026-09-19 (patch 1.12.1). The DB is close to Classic Era but
not identical, has no Forever coverage, uses world coordinates rather than the addon's, and has no quest XP. Details
and per-quest IDs are in the "DB verification" section at the end of each faction file and each class note.

| Correction | DB result |
|---|---|
| Whirlwind chain starts at the class trainer (The Islander), not Bath'rah | **Confirmed.** 1718 is started by six class trainers and turned in to Klannoc Macleod; Bath'rah only starts Cyclonian onward. The class note still says Bath'rah (marked there). |
| Big Game Hunter is open to all classes, needs level 28, 12-quest chain, rifle option | **Confirmed**, all four points. All three mastery chains must be finished. |
| Mage wand and orb chains start with the class trainers | **Confirmed** (Deino, Jennea Cannon, Anastasia Hartwell, Bink, Uthel'nay). Wand materials were not checked. "Items of Power" is not in the wand chain in the DB. |
| Paladin Summon Warhorse is short and free | **Consistent.** One quest (The Tome of Nobility, 1661, min 40, no cost in the DB). |
| Cat, Travel and Dire Bear Form look like trainer spells | **Consistent.** No Druid quest exists between level 16 and 50. |
| Marshal Maxwell is in the Burning Steppes, no Maxwell step in the Sunken Temple attunement | **Confirmed.** He stands at Morgan's Vigil, and his quests are the Onyxia-line ones. |
| Venture Company Mining not confirmed at level 31 | **Partly.** `MinLevel` is 30 but it requires Singing Blue Shards (605). Level 43 is not a requirement. |
| The Perfect Poison was not found | **Found.** Quest 9023, min 60, both factions, Silithus, rewards Doomulus Prime. |
| Rogue poison chain step names need rechecking | **Partly.** The entry quests exist (2360 Alliance, 2478 Horde, both min 20); the middle steps were not checked. |
| Warlock Small Soul Pouch and Box of Souls rewards need rechecking | **Confirmed** (22243 at level 20, 22244 at level 30). |

New findings the DB adds that no earlier note had are listed in each class note: Limb Cleaver, Vanquisher's Sword
and Triprunner Dungarees turned out to be faction splits rather than source disagreements, and several tables list a
quest reward under the wrong faction (Jail Break!, Ormer's Revenge, Retrieval for Mauren, Defeat Nek'rosh).
