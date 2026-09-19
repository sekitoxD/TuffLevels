# Warlock — notable leveling items (1-60)

See [README.md](README.md) for the legend, abbreviations and confidence caveats.

Warlocks level on their pet, DoTs and **wand**. The wand ladder is shared with Mage and Priest — see
the full table in [notable_mage_items.md](notable_mage_items.md#wand-progression-mage-priest-and-warlock-share-this-list).
Stat priority from WIC: Intellect > Stamina > Spirit over spell power while leveling.

## Top priority: wand ladder steps unique to the Warlock guide (WT)

| Level | Item | DPS | Source | Obtain |
|---|---|---|---|---|
| 5 | Lesser Magic Wand | 11.3 | Craft | Enchanting |
| 13 | Greater Magic Wand | 17.5 | Craft | Enchanting |
| 12 | Spark of the People's Militia | 12.8 | Q | "The People's Militia" — Westfall |
| 18 | Excavation Rod | 24.2 | Q | "Ormer's Revenge" — Wetlands |
| 20 | Spellcrafter Wand | 20.3 | Q | "Retrieval for Mauren" — Stonetalon Mountains (**listed for Warlock only; probably Horde/Stonetalon-side — verify**) |
| 20 | Consecrated Wand | 24.2 | Q | "Worgen in the Woods" — Duskwood |
| 24 | Gravestone Scepter | 29.0 | Q-dungeon | "Blackfathom Villainy" — Blackfathom Deeps |
| 30 | Rod of Sorrow | 31.8 | Q | "Wanted Otto and Falconcrest" — Arathi Highlands |
| 35+ | Burning Sliver | 32.7 | Q | "Crushridge Warmongers" — Alterac Mountains |
| 35+ | Cairnstone Sliver | 41.4 | Q | "The Morrow Stone" — Feralas |
| 45+ | Smokey's Fireshooter | 53.2 | Q | "When Smokey Sings, I Get Violent" — Eastern Plaguelands |

Dungeon drops: Cookie's Stirring Rod (22.3, Deadmines 35%), Noxious Shooter (50.0, Noxxion —
Maraudon 20%), Rod of Corrosion (55.0, Shade of Eranikus — Sunken Temple 32%), Mana Channeling Wand
(60.9, Cho'Rush — Dire Maul 25%). Vendor: Smoldering Wand (13.4), Blackbone Wand (35.3).

## Class quests with item rewards

| Quest | Level | Reward | Notes |
|---|---|---|---|
| Summon Succubus questline | 20 | **Small Soul Pouch** (WT) | needed for the Succubus |
| Summon Felhunter questline | 30 | **Box of Souls** (WT) | needed for the Felhunter |
| **Knowledge of the Orb of Orahil** | 35+ | **Orb of Noh'Ordahil**, a shadow-damage off-hand (WT) | 1 src — verify the quest and item names |
| Felsteed mount quest | 40 | free mount (WT: "simple quest in Ratchet, The Barrens") | a mount at 40 is a big speed win, **1 src, verify the location and requirements** |
| Soul Harvester quest | 20 | Soul Harvester (wand) (NTB) | single source (NTB); not on the WT wand list — verify it exists before using |
| Harnessing Shadows | 60 | Dreadmist Mask / Leggings / Soul Harvester upgrade (NTB) | endgame; needs UBRS + Stratholme |

## Armor

- **Shadoweave set** (L37+; gloves, mask, pants, robe, shoulders) — crafted by Tailoring or bought
  on the AH; shadow damage + spell power (WT, WIC). Only realistic if the Warlock tailors.
- Blue BoE world drops with Int/Stam from the AH (WIC).

## Open items

- The three quest-reward rows marked "verify" above.
- Warlock-usable staves/daggers (melee stat stick) not covered.
- Which of the wand quests are Alliance- vs Horde-side was not documented consistently.

## DB verification (checked 2026-09-19)

Snapshot: cmangos `classic-db` `22b51464f1625f6ef6275771de1f5466c6f5d19e` + `mangos-classic`
`8ec338a1704e7dcb1c0213eb7ed58f9231ade40f`, imported 2026-09-19 (patch 1.12.1). Looked up with
`tools/qdb.py`. Limits: (1) the DB is 1.12.1, not Classic Era 1.15, so "close, not identical"; (2) no Forever
coverage; (3) DB positions are world coordinates, not the addon's coordinates; (4) quest XP is not in the DB.
Nothing above was edited; checks and disagreements are listed here.

**The wand ladder** is verified in [notable_mage_items.md](notable_mage_items.md#db-verification-checked-2026-09-19).
Two items specific to this note:
- **Spellcrafter Wand (6677, 20.3 dps)** is the reward of **Retrieval for Mauren (1078)**, an **Alliance** quest
  (race mask 77, min 17, zone 406). The note's guess "probably Horde/Stonetalon-side" is wrong: it is Alliance
  only, so a Horde Warlock cannot take it.
- Smoldering Wand (5208): required level 15, 13.4 dps.

**Class-quest rewards, row by row**

| Note row | DB result |
|---|---|
| Summon Succubus, level 20, Small Soul Pouch | **Confirmed.** The Binding (1474 Horde, 1513 Horde, 1739 Alliance, all min 20) grants the spell (712) and the **Small Soul Pouch (22243)**. Level 10 Voidwalker and Imp quests (The Binding 1471 / 1504 / 1689, min 10) grant spell 697. |
| Summon Felhunter, level 30, Box of Souls | **Confirmed.** The Binding (1795, both factions, min 30, Strahad Farsan) grants spell 691 and the **Box of Souls (22244)**; it follows Tome of the Cabal (1758-1805). |
| Knowledge of the Orb of Orahil, level 35+ | **Confirmed, names differ.** The item is spelled **Orb of Noh'Orahil (15107**, off-hand held item, rare), not "Noh'Ordahil". Chain: Knowledge of the Orb of Orahil (4965 / 4967 Alliance, 4968 / 4969 Horde, min 35) and Fragments of the Orb of Orahil (1799), then Cleansing of the Orb of Orahil (4961), Returning the Cleansed Orb (4976), then a choice of **The Completed Orb of Noh'Orahil (4975**, Orb of Noh'Orahil 15107 or Staff of Noh'Orahil 15105**)** or **The Completed Orb of Dar'Orahil (4964**, Orb of Dar'Orahil 15108 or Staff of Dar'Orahil 15106**)**. The staff options are not in the note. |
| Felsteed at level 40, "simple quest in Ratchet" | **Partly confirmed.** Summon Felsteed is a Warlock quest, min 40, in two parts: per-race starters (3631 Horde, 4487 / 4488 Alliance, 4489 Horde) turn in to **Strahad Farsan**, then **Summon Felsteed (4490**, both factions) grants the spell (5784). Strahad Farsan stands on map 1 (Kalimdor) at world -785.9, -3723.3; the DB has no zone names, so "Ratchet, Barrens" is plausible but not confirmed. |
| Soul Harvester, level 20, a wand (NTB) | **CONFLICT.** Soul Harvester (20536) is a **2H staff** (44.8 dps, rare) and the reward of **Trolls of a Feather (8422, min 50)**, after The Wrong Stuff (8421). It is not a level 20 wand. |
| Harnessing Shadows, level 60, Dreadmist Mask / Leggings / Soul Harvester upgrade | **CONFLICT.** Harnessing Shadows (7502) is Warlock-only, **min 54**, both factions, and rewards the **Royal Seal of Eldre'Thalas (18467**, Warlock-only trinket). Not the Dreadmist pieces. The Dreadsteed of Xoroth (7631) is a separate level 60 quest. |

Not checked: the Shadoweave set (crafting) and the "Blue BoE world drops" line.
