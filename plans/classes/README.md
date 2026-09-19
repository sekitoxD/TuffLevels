# Notable leveling items by class (1-60)

Research notes on the weapons and gear that leveling guides commonly cite as worth going out of
your way for, with **how each one is obtained**. Purpose: decide which items deserve a
`class = "<CLASS>"` detour step (or a `note`) when authoring routes. Nothing here is loaded by the
addon — same status as the rest of `plans/`.

Follows the workflow in `../03-route-folder-layout-and-class-research.md`: a human reads these
notes, decides, and writes the step. Nothing here should be turned into automatic step selection.

| Class | File |
|---|---|
| Warrior | [notable_warrior_items.md](notable_warrior_items.md) |
| Paladin | [notable_paladin_items.md](notable_paladin_items.md) |
| Hunter | [notable_hunter_items.md](notable_hunter_items.md) |
| Rogue | [notable_rogue_items.md](notable_rogue_items.md) |
| Priest | [notable_priest_items.md](notable_priest_items.md) |
| Shaman | [notable_shaman_items.md](notable_shaman_items.md) |
| Mage | [notable_mage_items.md](notable_mage_items.md) |
| Warlock | [notable_warlock_items.md](notable_warlock_items.md) |
| Druid | [notable_druid_items.md](notable_druid_items.md) |

## How to read the tables

**Source type** — what it costs the player:

| Tag | Meaning | Route-worthiness |
|---|---|---|
| **Q** | Guaranteed quest reward (or a choice between rewards) | Best: deterministic, can be a real step |
| **Q-chain** | Multi-part quest with gathering/crafting/travel cost | Worth it only if the payoff is large (Whirlwind Axe, Verigan's Fist) |
| **Q-dungeon** | Quest that needs a dungeon run / a group | Only if the dungeon is already on the route |
| **D (nn%)** | Boss drop at the stated rate, per kill | RNG: mention in a `note`, don't build a step around it |
| **V** | Vendor purchase | Trivial; a `note` at most |
| **Craft** | Profession-crafted | Depends on the character having the profession |

**Faction** — A = Alliance, H = Horde, both = either. In Classic Era, Paladin is Alliance-only and
Shaman is Horde-only, so the Paladin and Shaman files cover one faction each. Horde Paladins and
Alliance Shamans (TBC and later) are not researched.

**Confidence** — every row carries the sources it came from; "1 src" means only one site listed it.
Quest names and levels were pulled from leveling-guide websites, not from a database record.

## Items that show up across several classes

These are worth a single shared step with per-class reward notes rather than nine separate ones.

| Quest | Where / level | What it gives | Notes |
|---|---|---|---|
| **In the Name of the Light** | Scarlet Monastery, req. L34 (A only) | Choice: Sword of Serenity (1H sword), Bonebiter (2H axe), Black Menace (dagger), Orb of Lorica | Needs Whitemane, Mograine, Herod and Loksey killed → a full SM run, so group. Rogue/Warrior/Paladin/Shaman all benefit. Turn in to Raleigh the Devout in Southshore. Confirmed by 3 sources |
| **Into the Scarlet Monastery** | Scarlet Monastery (H) | Sword of Omen (1H sword, Rogue list) | Horde counterpart; only 1 src for the reward, verify |
| **Corruption of Earth and Seed** | Maraudon, L45 | Choice incl. Resurgence Rod (2H), Thrash Blade (1H sword), Verdant Keeper's Aim (bow) | The reward that matters differs per class; appears in Warrior, Rogue, Paladin/Shaman and Hunter lists |
| **Azsharite Weaponry** | Stranglethorn Vale, L55 | Enchanted Azsharite Felbane Sword/Dagger (35.7-35.8 DPS) | Rogue-relevant at 55, 2 srcs |
| **Venture Company Mining** | Stranglethorn Vale, L31 | Silver Spade (31.1 DPS 2H) | Warrior/Paladin/Shaman lists |
| **The Mighty U'cha** | Un'goro Crater, L50 | Beastslayer (42.6 DPS 2H) / Beastsmasher (1H mace) | Warrior/Paladin/Shaman |
| **The Perfect Poison** | Silithus, L58 | Doomulus Prime (55.7 DPS 2H) | Best 2H quest weapon at the top of the range |
| **Defeat Nek'rosh** | Wetlands, L26 | Ancient War Sword (2H, 21.7 DPS) / Barreling Reaper (1H axe) | Cheap mid-20s upgrade |
| **Big Game Hunter** | Stranglethorn Vale, L25 | Master Hunter's Bow (19.4 DPS); a Master Hunter's Rifle also exists and is probably the gun option | Hunter only; the rifle link is unconfirmed, see hunter file |
| **Blackfathom Villainy / Ormer's Revenge / Worgen in the Woods / The People's Militia** | Various | Caster wands (Gravestone Scepter, Excavation Rod, Consecrated Wand, Spark of the People's Militia) | Shared by Mage, Priest, Warlock. Alliance-leaning list; Horde equivalents flagged in each file |

## Sourcing and confidence

Sources (abbreviations used inside the files):

- **WIC** — wowisclassic.com class guides (per-level weapon tables)
- **WT** — warcrafttavern.com class guides
- **IV** — icy-veins.com class-quests and leveling guides
- **NTB** — noobtoboss.com class-quest guides
- **ZK** — zockify.com leveling guides
- **WH/search** — Wowhead/ClassicDB/Ten Ton Hammer facts surfaced through search-result summaries

Limits worth knowing before anything gets copied into a route:

1. **Wowhead could not be read directly** (it renders client-side). No item ID or quest ID in these
   notes was checked against a database record. Before promoting an entry to a step, look the
   quest up on Wowhead/ClassicDB and record its ID + URL in the step `note`, per Plan 3.
2. The tables are gathered from guide sites and **disagree in places** (the same wand quest is
   given three different item names across the Mage/Priest/Warlock pages). Conflicts are flagged
   where they matter; unmarked rows agree across sources or came from a single consistent table.
3. **Levels are "when you can realistically use it"**, not the item's `requiredLevel`; they
   drift by a few levels between sources.
4. **DPS figures are copied from the guides**, useful only for comparing neighbours in one table.
5. Quest-giver names, chain steps and material lists are recorded only where a source stated them.
   Where a chain's locations weren't sourced they are left out rather than guessed.
6. Level-60 endgame rewards (Rhok'delar, Benediction/Anathema, Dreadmist etc.) are noted at most
   as one-liners: they are outside "fastest way to 60".

## DB verification

Each class note ends with a "DB verification" section (checked 2026-09-19 against a local cmangos Classic snapshot,
patch 1.12.1) that records checked item and quest IDs, and marks where the DB disagrees with the tables above. The
notes themselves were not edited. Quest-side results are in `../quests/README.md`.
