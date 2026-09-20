# Plan 5: Rogue Master Sheet and ONSLAUGHT compared with the tuffweights tool

Sources (both exported as xlsx, all tabs, 2026-09-20):

- "Rogue Master Sheet - Horde" (`13MuieeftxH00hJo7njbydnCgHgcMEtt_u3w1tZVU04s`): Quest Gear Guide,
  RogueAbilities, LockPicking, Engineering, FirstAid, Cooking, Fishing (empty), World Map, Macros (NYI).
- ONSLAUGHT (`1ObO5Zf3SbFp9EPfiIoqFnmYtWLpFtvClMGRapiHxmLM`): Generic Solo Orc/Troll Route,
  5 Man Dungeon Route (final), Tirisfal Starting. Route-format audit is in `plan 04`; this plan only asks
  whether the routes and the tool agree about which quests are worth doing.

Compared against `tools/tuffweights/out/{worth,rewards}.md` as generated on 2026-09-20, with quest and item facts
checked in the local cmangos DB via `tools/qdb.py`. The join is by quest name, not ID (the sheet uses classicdb IDs,
the DB uses its own). Nothing DB-derived is copied here except quest and item names.

## Bottom line

1. **Nothing in either sheet changes a weight.** Neither carries numbers. The Quest Gear Guide is stat lines per quest;
   ONSLAUGHT is a route with no gear guidance at all. What they can do is check *which items and quests* the tool
   rates, and they mostly agree.
2. **The tool's stat values are consistent with how the sheet author picks.** In the rows I compared by hand, the item
   the sheet names is the highest Agi/Str/AP choice on that quest and matches the tool's best-scoring choice. Where the
   tool disagrees it is about whether the quest is worth doing at all, not which reward to take (see section 1).
3. **What the comparison found is three tool problems (plus one known modelling assumption) and four sheet problems**,
   listed below. Two of the tool problems change published verdicts; none needs a new weight.

## 1. Sheet gear picks against tool verdicts

78 sheet rows carry a gear note.

| tool says | rows | examples |
|---|---|---|
| worth doing (solo/group/dungeon verdict) | 26 | Wingblade, Outlaw Sabre, Sword of Omen, Silent Hunter, Deftkin Belt, Rambling Boots, Tiger Hunter Gloves |
| marginal: net < 0.5% over easier sources, or helps an empty slot only | 12 | Warsong Boots, Loamflake Bracers, Brawnhide Armor, Braced Handguards, Ringtail Girdle |
| no gain / nothing scorable | 8 | Windsong Cinch, Skull Rock, Cry of the Thunderhawk |
| listed, but "not worth it" | 4 | Willix the Importer, Allegiance to the Old Gods, Divino-matic Rod, Hidden Enemies |
| no verdict row (armor under 1% at every level, or unscored utility) | 25 | stamina rings, trinkets, bags, Panther Hunter Leggings, Duskwing Mantle |
| no rogue-usable Horde reward in the DB | 3 | Carry Your Weight, The Forgotten Pools, Legends of Maraudon |

The "marginal" group is a baseline effect, not a disagreement. Example checked by hand: Windsong Cinch (+12 AP) scores
-1.1% at L27 because Deftkin Belt (+4 Agi, +12 AP, solo quest, L23) is already in the baseline. The sheet lists both
belts; the tool says take the better one. Correct.

Several of the 25 unscored rows are Stamina-heavy (Ring +8/+10 Sta, Plainstalker Tunic +23 Sta). The tool never scores
Stamina (deliberate, see notes), so it cannot tell you when the sheet's "survivability" picks are worth a detour. That
is a known gap, not a new one.

## 2. Problems in the sheet (verified against the DB)

- **Maraudon notes are one row low.** The note sits on the row *below* the quest it describes:

  | sheet row says | DB says the reward is on |
  |---|---|
  | Vyletongue Corruption: head +15 agi +10 stam | **Twisted Evils** (Sprightring Helm; other choice Acumen Robes) |
  | The Pariah's Instructions: belt +15 agi | **Vyletongue Corruption** (Sagebrush Girdle; other choice Woodseed Hoop) |
  | Legends of Maraudon: trinket | **The Pariah's Instructions** (Mark of the Chosen); Legends of Maraudon has no gear reward |
  | Seed of Life: Thrash Blade | **Corruption of Earth and Seed** (Thrash Blade; other choice Verdant Keeper's Aim) |

  `research/classes/rogue.md` had copied the offset lines as written; corrected in the same change as this plan.
- **Five quests on a "Horde" sheet are Alliance-only in the DB:** Raene's Cleansing, Answered Questions (Ashenvale),
  A Hero's Welcome, Wandering Shay (Feralas), Rise, Obsidion! (Searing Gorge). Probably carried over from an Alliance
  copy. Annotated in the research file, not removed. Worth one manual check against a live client if any of them matters.
- **Runecloth (6031)**: sheet says required level 40, DB says 50.
- **Final Passage is undersold.** The sheet says "Good XP, possible vendor gear". It rewards Windstorm Hammer
  (mace, +4 Str +5 Sta), which the tool rates "Dungeon: very worth it" at +17% mean over L25-29 for mace builds.
  The chain is Test of Lore (6627) -> Test of Lore (1159) -> Test of Lore (1160) -> Test of Lore (6628) -> Final Passage
  (1394); 1160 needs a quest item that is a gameobject inside Scarlet Monastery (map 189), which matches the sheet
  listing Test of Lore under SM. This closes the "chain order not checked" caveat in `notable_rogue_items.md`.

## 3. Quests the tool rates that neither sheet flags

Only the ones with a real uplift. "solo route" / "5-man route" = whether ONSLAUGHT accepts the quest.

| quest | item | tool verdict | solo route | 5-man route |
|---|---|---|---|---|
| The Real Threat | Sword of Hammerfall | group, worth the extra time, +10.9% mean L30-34 | SKIP | accepts |
| Assault on Fenris Isle | Talonstrike | group, worth the extra time, +6.3% mean L10-19 | absent | absent |
| Deep Sea Salvage | Black Water Hammer | solo, +3.9% mean L35-38 | accepts | absent |
| Betrayed | Belgrom's Hammer | solo, +5.3% mean L44-48 | accepts | accepts |
| Bone-Bladed Weapons | White Bone Band / Shredder | solo, +1.6% L48-59 | accepts | accepts |
| Frostmaw | Spirit Hunter Headdress | solo, +2.4% L26-41 | accepts | SKIP |
| The God Hakkar | Lifeforce Dirk | dungeon, kinda, +3.0% L40-45 | absent | accepts |
| Kirtonos the Herald | Mirah's Song | dungeon, kinda, +2.6% L55-59 | absent | absent |
| The Shattered Hand / The Deathstalkers | Blade of Cunning | solo, +1.2% at L10 | absent | absent |

Sword of Hammerfall, Lifeforce Dirk, Mirah's Song, Windstorm Hammer, Outlaw Sabre are already in
`notable_rogue_items.md` ("Model-derived additions"). Talonstrike was left out on purpose earlier. Not yet in the notes:
Black Water Hammer, Belgrom's Hammer, Spirit Hunter Headdress, and the rogue class quest for Blade of Cunning (both
ONSLAUGHT routes are class-agnostic, so neither has it).

## 4. ONSLAUGHT routes against the tool

The route is XP-driven, so agreement is a good sign for the tool: nearly every quest the tool rates "Solo quest: do it"
is on the solo route. The exceptions are Rescue OOX-22/FE! (explicit SKIP), Rites of the Earthmother (the Mulgore start
chain, not on an Orc/Troll route), the rogue class quests, and the reputation-gated Epic Armaments quests (section 5.2).
The 5-man route covers nearly all of the group/dungeon picks (Wingblade, Outlaw Sabre, Sword of Omen, Thrash Blade,
Sword of Hammerfall, Silent Hunter, Skullbreaker, Lifeforce Dirk).

Where they differ, the differences are informative:

- **Windstorm Hammer** (tool: +17% mean, +22% peak for mace builds over L25-29; rank 1 on the shortlist at L25-28 in
  all five builds). The 5-man route has an explicit SKIP on Test of Lore and the solo route never touches it; the
  Quest Gear Guide calls Final Passage "possible vendor gear". It is the largest single item the two sources leave on the
  table, but the tool counts the chain as 10 quests including a Scarlet Monastery trip, so skipping it may be a
  deliberate cost call rather than an oversight. The tool cannot price that cost; the decision stays with the user.
- **Vanquisher's Sword** (Bring the End, RFD): SKIP on the solo route, not in the 5-man route. Tool: dungeon, very worth
  it, +5.2% mean L37-44.
- **Unholy Alliance / Skullbreaker** (RFK/RFD): only on the 5-man route.

## 5. Problems found in the tool

1. **`rewards.md` and `worth.md` disagree about the same items.** `rewards.rs` line 219 classifies with
   `POINT_WINDOW` (one level's uplift used as both mean and peak), so a dungeon item that peaks briefly reads "very
   worth it" there but "kinda" in `worth.md`, which uses the real window:

   | item | rewards.md | worth.md |
   |---|---|---|
   | Skullbreaker | +15.4%, very worth it | 28-29, mean +6.5%, kinda |
   | Sword of Omen | +8.3%, very worth it | 33-44, mean +3.8%, kinda |
   | Thrash Blade | +4.9%, very worth it | 45-59, mean +2.8%, kinda |

   The report text says "the same verdict `worth.md` uses"; it is not. **Recommended fix:** take each pick's verdict from
   the item's `worth` row (mean and window) when one exists, and keep the point classification only for items that have
   no window.
2. **Quest reputation gates are not exported.** 256 quests in the DB have `RequiredMinRepFaction`; the exporter ignores it
   (it fixed the same thing for vendors in session 3b). Visible effect: the four "Epic Armaments of Battle" quests
   (Argent Dawn Friend/Honored/Revered/Exalted, faction 529) show as plain "Solo quest: do it" for Medallion of the Dawn
   (+3.2%) and Bracers of Subterfuge (+2.2%) at L55-59. **Recommended fix:** export `requires` on quest sources and have
   `tier_of` treat a gated quest like a conditioned vendor (skip it). Only those two items are affected today.
3. **Utility rewards are invisible.** The sheet lists bags and utility trinkets the tool cannot score: Deviate Hide Pack
   (10-slot, from Deviate Hides, min 13) and Explorer's Knapsack (14-slot, Cortello's Riddle, min 35, long chain) are
   confirmed as bag rewards in the DB. Nifty Stopwatch (run speed), Luffa (bleed removal) and Carrot on a Stick (riding
   speed) are described only by the sheet; their effects were not checked. The DB also has bags the sheet misses:
   **Thawpelt Sack, 14 slots, from The Platinum Discs (min 40, Horde version)**, and Captain Sander's Booty Bag
   (8 slots). **Recommended:** not a model change. Add a short "Utility (not scored)" section to
   `notable_rogue_items.md`.
4. **Model assumption the sheet contradicts, already on the to-do list:** the tool assumes weapon skill is available
   for every type from L10. The sheet notes swords must be trained (10 silver, Undercity, on the way to Silverpine) and
   that a mace upgrade only counts "if you have 1 hand mace trained". The cost is small but the *visit* is not free.
   This is the "path DP with switching costs" item; no new work implied.

## 6. What was already absorbed

- RogueAbilities: condensed into `Rogue.lua` (commit b31d702). Instant Poison "essential", Deadly/Wound/Mind-numbing
  "DO_NOT_TAKE" while levelling; Backstab ranks "Situational". Consistent with the tool: it models no poisons yet
  (open item "poisons/consumables"), and the sheet's advice says Instant Poison is the one to add if that is built.
- LockPicking, Engineering, FirstAid, Cooking: in `research/`.
- Quest Gear Guide: in `research/classes/rogue.md` (unverified until now; the DB check is section 2).

## Decisions for the user (all three approved and done, 2026-09-20)

1. `rewards.md` verdicts now use the item's `worth` window when that window covers the level the reward was scored at
   (`rewards.rs::pick_verdict`); otherwise the one-level score. Skullbreaker, Sword of Omen, Thrash Blade now read "kinda worth it"
   in both reports; 10 other dungeon/group picks were downgraded the same way. Cost: `rewards` now runs the full search, ~60s instead of ~5s.
   Caveat found on the way: worth starts at L10, so a naive "always use the window" turned low-level picks (Brushwood Blade +51%,
   Hammer of Orgrimmar +10.6%) into "not worth it"; hence the "window must cover the scored level" rule.
2. The exporter now records a reputation `requires` on quest sources and choose-one quests (own gate or any earlier quest in the
   chain; Friendly or higher). `tier_of` skips gated quests and `rewards` leaves them out (15 quests). Medallion of the Dawn and Bracers
   of Subterfuge left the solo list; Runecloth (Timbermaw) and Apprentice's Duties (Ironforge, Honored) left `rewards.md`.
3. Black Water Hammer, Belgrom's Hammer, Spirit Hunter Headdress and a "Utility (not scored)" bag table are in
   `plans/classes/notable_rogue_items.md`, every fact checked with `tools/qdb.py`. Blade of Cunning was already there.
