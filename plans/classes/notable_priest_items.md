# Priest — notable leveling items (1-60)

See [README.md](README.md) for the legend, abbreviations and confidence caveats.

Priests level on **wand damage plus Shadow/Holy spells**, so the leveling gear that matters is the
**wand progression** and Spirit/Intellect armor (WIC/WT: Spirit > Intellect > Stamina; "of the Owl"
greens are the standard pick). Weapon quest rewards for Priests are few — the class quests are
mostly skill unlocks.

## Top priority: the wand ladder

The wand list is shared with Mage and Warlock — see the full table (with sources and the naming
caveat) in [notable_mage_items.md](notable_mage_items.md#wand-progression-mage-priest-and-warlock-share-this-list).
The steps a Priest should not skip:

| Level | Item | DPS | Source | Obtain | Why it's worth it |
|---|---|---|---|---|---|
| 5 | Lesser Magic Wand | 11.3 | Craft | Enchanting (or AH) | first real wand |
| 13 | Greater Magic Wand | 17.5 | Craft | Enchanting (or AH) | 2nd craft step |
| ~15 | Spark of the People's Militia | 12.8 | Q | "The People's Militia" — Westfall (A) | free quest reward |
| ~20 | Excavation Rod | 24.2 | Q | "Ormer's Revenge" — Wetlands | +7 DPS over Greater Magic |
| ~20-25 | Consecrated Wand | 24.2 | Q | "Worgen in the Woods" — Duskwood | same tier, other zone |
| ~25 | Gravestone Scepter | 29.0 | Q-dungeon | "Blackfathom Villainy" — Blackfathom Deeps | |
| ~30 | Rod of Sorrow | 31.8 | Q | "Wanted Otto and Falconcrest" — Arathi Highlands | |
| ~35 | Cairnstone Sliver | 41.4 | Q | "The Morrow Stone" — Feralas | big jump (~+10 over Rod of Sorrow) |
| ~45 | Noxious Shooter | 50.0 | D (20%) | Noxxion — Maraudon | |
| ~50 | Smokey's Fireshooter | 53.2 | Q | "When Smokey Sings, I Get Violent" — Eastern Plaguelands | |
| ~52 | Rod of Corrosion | 55.0 | D (32%) | Shade of Eranikus — Sunken Temple | |
| ~58 | Mana Channeling Wand | 60.9 | D (25%) | Cho'Rush the Observer — Dire Maul | best in the bracket |

Source: WT Priest page. WIC gives a similar but not identical ladder and uses different item names
for the same quests (see the naming caveat in the Mage file) — verify names on Wowhead. Vendor
options: Smoldering Wand (13.4), Blackbone Wand (35.3, L41, capital-city wand vendor).

## Sunken Temple quest reward

- **Blood of Morphaz** (Sunken Temple): choice of **Woestave** (wand, ~53.2 DPS) or **Blessed Prayer
  Beads** (healing trinket) — NTB, WT. Level-appropriate for the 50s; needs a Sunken Temple run.

## Non-weapon and class-quest notes

- **Level-10 and level-20 racial priest quests** — ability unlocks; no items.
- **Benediction / Anathema** (L60 staff, "The Balance of Light and Shadow", Eris Havenfire, Western
  Plaguelands) — needs Molten Core; endgame, out of scope.
- No priest-specific weapon/armor quest reward beyond the above was found in the sources.

## Open items

- Priests can use maces/staves/daggers; the guides list *only wands*, so a melee/staff stat stick
  (e.g. the Illusionary Rod in the Mage file, or the Scarlet Monastery staves) is not covered.
- Horde equivalents for the low-20s quest wands not documented.

## DB verification (checked 2026-09-19)

Snapshot: cmangos `classic-db` `22b51464f1625f6ef6275771de1f5466c6f5d19e` + `mangos-classic`
`8ec338a1704e7dcb1c0213eb7ed58f9231ade40f`, imported 2026-09-19 (patch 1.12.1). Looked up with
`tools/qdb.py`. Limits: (1) the DB is 1.12.1, not Classic Era 1.15, so "close, not identical"; (2) no Forever
coverage; (3) DB positions are world coordinates, not the addon's coordinates; (4) quest XP is not in the DB.
Nothing above was edited; checks and disagreements are listed here.

**The wand ladder** is verified in [notable_mage_items.md](notable_mage_items.md#db-verification-checked-2026-09-19):
every DPS matches, the WT item names are the DB names, and the quest wands from The People's Militia through The
Morrow Stone are **Alliance-only** quests (Blackfathom Villainy has a Horde twin). That answers the open item
"Horde equivalents for the low-20s quest wands": there are none in this DB. Smoldering Wand (5208, 13.4 dps) exists
with required level 15.

**Blood of Morphaz (8257):** Priest-only, both factions, min 50, started by Ogtinc and turned in to Greta Mosshoof.
Reward is a choice of **three**, not two: **Woestave (20082, wand, 51.3 dps)**, **Blessed Prayer Beads (19990,
trinket)** and **Circle of Hope (20006, ring)**. **CONFLICT:** Woestave is 51.3 dps in the DB, not ~53.2.

**Class quests.** The level 10 and 20 racial Priest quests exist as spell unlocks with **no item rewards**
(min 10: Desperate Prayer, Touch of Weakness, Hex of Weakness, Stars of Elune / Returning Home; min 20: Devouring
Plague, Shadowguard, A Lack of Fear, Arcane Feedback, Elune's Grace), so "no items" is confirmed.

**Benediction (18608) / Anathema (18609):** both 2H staves, required level 60, 59.3 dps. The quest **The Balance of
Light and Shadow (7622)** is Priest-only, min 60, both factions, but its fixed reward is **Splinter of Nordrassil
(18659)**, not the staff; the staff is a separate item, so the note's "quest gives the staff" needs a second look.
