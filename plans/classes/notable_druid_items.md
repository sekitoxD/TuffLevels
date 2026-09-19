# Druid — notable leveling items (1-60)

See [README.md](README.md) for the legend, abbreviations and confidence caveats.

Druids level either **Feral (bear/cat)** or as a balance/caster hybrid. Feral druids get their
melee damage from a **staff/2H mace's attack power**, not its DPS, and the guides therefore point
at *staves and stat gear* rather than DPS ladders. Stat priority (WIC): Agility > Strength >
Stamina > Intellect > Spirit.

## Top priority

### Dungeon-quest staves — level 14, Q-dungeon, both factions
- **Staff of Westfall** (Alliance) — "The Defias Brotherhood", Deadmines. **Crescent Staff**
  (Horde) — "Leaders of the Fang", Wailing Caverns. IV: guaranteed on your first full dungeon run,
  and "can last you for a very long time".
- Alliance also gets **Tunic of Westfall** (chest) from the same Deadmines quest (WIC, WT).

### Manual Crowd Pummeler — level ~30, D, both factions
- 2H mace from **Crowd Pummeler 9-60 (Gnomeregan)**. IV calls it best-in-slot for Feral for the
  whole of Classic (WH/search), and a "Druid BiS weapon" worth solo-farming at L30. **Drop rate was
  not found; one anecdotal report says it's low** — treat as an RNG bonus, not a route step.

## Weapon options

| Level | Item | Type | Source | Obtain |
|---|---|---|---|---|
| 14 | Staff of Westfall (A) / Crescent Staff (H) | 2H staff | Q-dungeon | Deadmines / Wailing Caverns, see above |
| 30 | Manual Crowd Pummeler | 2H mace | D | Crowd Pummeler 9-60 — Gnomeregan |
| 31 | Loksey's Training Stick | staff | D (10%) | Houndmaster Loksey — Scarlet Monastery |
| 37 | Ironshod Bludgeon | staff | D (20%) | Ironaya — Uldaman |
| 43 | Warden Staff | staff (epic) | world drop | BoE, ~0.025% — luck only |

Source: WIC + IV. Warcraft Tavern's Warrior/Shaman tables list the shared 2H staff ladder (Living
Root, Rod of the Sleepwalker, Silver Spade... see [notable_shaman_items.md](notable_shaman_items.md)) that
Druids can also equip; not repeated here.

## Armor and accessories

| Level | Item | Slot | Source | Obtain |
|---|---|---|---|---|
| 14 | Tunic of Westfall | chest | Q-dungeon (A) | "The Defias Brotherhood" — Deadmines |
| 25 | Triprunner Dungarees | pants | Q-dungeon | "The Grand Betrayal" — Gnomeregan |
| 40 | Mason's Fraternity Ring | ring | Q-dungeon | "Divino-matic Rod" — Zul'Farrak |
| 40 | Wolfshead Helm | head | Craft | Leatherworking — "great for powershifting" |
| 53 | Devilsaur Gauntlets | hands | Craft | Leatherworking (BoE rare pattern) |
| 55 | Devilsaur Leggings | legs | Craft | Leatherworking (BoE rare pattern) |

## Class quests (all ability unlocks, no gear)

| Level | Quest | Unlocks |
|---|---|---|
| 10 | Bear Form | Bear Form (Maul, Growl, Demoralizing Roar) |
| 14 | Cure Poison | spell |
| 16 | Aquatic Form | swimming speed/breath |
| ~20 | Cat Form | Cat Form |
| 30 | Travel Form | movement speed (a huge speed-leveling win) |
| 40 | Dire Bear Form | tanking/leveling survivability |

Sources: NTB/WT (forms are quests; levels for Cat/Travel/Dire Bear from NTB's "form quests" page
were summarised without exact levels, so those three are from general knowledge — verify). **No
gear rewards exist on any of the Druid class quests.**

## Open items

- Exact drop rate for Manual Crowd Pummeler.
- Verify levels for Cat/Travel/Dire Bear form quests.
- No 40-60 non-crafted weapon upgrades beyond drops were captured.

## DB verification (checked 2026-09-19)

Snapshot: cmangos `classic-db` `22b51464f1625f6ef6275771de1f5466c6f5d19e` + `mangos-classic`
`8ec338a1704e7dcb1c0213eb7ed58f9231ade40f`, imported 2026-09-19 (patch 1.12.1). Looked up with
`tools/qdb.py`. Limits: (1) the DB is 1.12.1, not Classic Era 1.15, so "close, not identical"; (2) no Forever
coverage; (3) DB positions are world coordinates, not the addon's coordinates; (4) quest XP is not in the DB.
Nothing above was edited; checks and disagreements are listed here.

**Class quests.** The DB holds Druid-only quests (class mask 1024) for exactly three of the six rows in the table:
- **Bear Form:** a level 10 chain, one copy per race (Night Elf mask 8, Tauren mask 32): Moonglade, Heeding the
  Call, Great Bear Spirit, Body and Heart, then Back to Darnassus / Back to Thunder Bluff.
- **Cure Poison:** a level 14 chain (Lessons Anew, The Principal Source, Gathering the Cure, Curing the Sick,
  Power over Poison, which grants the spell). Night Elf and Tauren copies.
- **Aquatic Form:** level 16 (A Lesson to Learn, Trial of the Lake, Trial of the Sea Lion, Aquatic Form). Night
  Elf and Tauren copies.
- **Cat Form, Travel Form and Dire Bear Form have no quest in the DB.** The Druid-only quests jump from level 16
  to level 50, so all three are trainer spells here. This settles the "verify levels" open item for 1.12.1 (the
  quests named in the table do not exist) and agrees with the README's guess. Confirm in game on Era.
- **CONFLICT with "No gear rewards exist on any of the Druid class quests":** Aquatic Form (31 Tauren, 5061 Night
  Elf) rewards the **Aquarius Belt (16608, leather waist)** and Curing the Sick (6124 / 6129) rewards the
  **Veildust Medicine Bag (15866, off-hand held item)**, both uncommon. Minor gear, but not "no gear".

**Conflicts with the notes**
- **Triprunner Dungarees (9624)** come from two quests, one per faction: **Rig Wars (2841, Horde)** and **The
  Grand Betrayal (2929, Alliance)**, both min 25, each offering items 9623 / 9624 / 9625. The table lists only
  The Grand Betrayal.
- The ring is spelled **Masons Fraternity Ring** (9533, no apostrophe) and is confirmed as a reward of
  Divino-matic Rod (2768, both factions, min 40).
- Wolfshead Helm (8345): Druid-only, required level 40, no quest reward, consistent with "Craft".

**Confirmed:** Staff of Westfall (2042) and Tunic of Westfall (2041) both come from The Defias Brotherhood (166,
Alliance, min 14); Crescent Staff (6505) from Leaders of the Fang (914, Horde, min 11). Manual Crowd Pummeler
(9449, required 29, 29.0 dps), Loksey's Training Stick (7710, required 31), Ironshod Bludgeon (9408, required
37) and Warden Staff (943, epic, required 43) have no quest reward. Devilsaur Gauntlets (15063, required 53) and
Leggings (15062, required 55) have no quest reward.
