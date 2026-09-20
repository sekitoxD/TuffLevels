# Rogue leveling priorities

Research aid for authoring `class = "ROGUE"` steps and rogue-specific
notes in `Routes/<Faction>/<Zone>.lua` files, and for `Rogue.lua`'s own
milestone/grind-advice content. See `research/README.md` for the
workflow and citation format this file follows.

Manually researched via Wowhead/WoWDB — no scraping, no automation. A
row only belongs here once someone has actually checked the quest's
Requires/Rewards panel, not as a placeholder guess.

## Weapon upgrade quests by bracket (1H sword/mace/axe rewards)

| Level | Quest | Zone | Weapon type | Notes | Wowhead |
|---|---|---|---|---|---|
| | | | | | |

## Best XP-per-hour zones/quests for this class

Grind zones/quest clusters where Rogue stealth/CC/positioning lets it
out-pace the base route's pacing — candidates for a `note` on a `grind`
step, or a `class = "ROGUE"` detour step, in the relevant route file.

<!-- <zone/quest> - <why Rogue does better here> - <Wowhead link> -->

## Community discussion notes (unverified - needs a Wowhead cross-check)

Lower-confidence findings from community threads, not yet checked against
Wowhead's Requires/Rewards panel the way the table above expects. Kept
separate rather than mixed into the verified table, so nothing here gets
mistaken for a checked citation.

- **Source:** [MMO-Champion "Classic WoW Rogue Thread"](https://www.mmo-champion.com/threads/2503293-Classic-WoW-Rogue-Thread)
  (community discussion thread, page 1 only - general talent/tactics
  chat, not a structured leveling guide; sparse on route-planning content).
  - **"Barman Shanker" dagger, obtainable ~level 50 in Blackrock Depths**
    ("you can get SOLO @50 Barman Shanker from BRD" — first-hand claim,
    user "Ange"). **Needs verification**: this reads like a boss/mob
    drop, not a quest reward — if so it doesn't belong in the weapon
    upgrade *quest* table above at all (that's for quest rewards
    specifically). Confirm on Wowhead whether it's a drop or a quest
    reward, and from what/whom, before using it for anything.
  - Dagger-focused Ambush/Subtlety build claimed effective for leveling
    ("Ambush>SS>EVIS>SS>EVIS", ~90% Ambush crit chance at level 50 with
    a fast off-hand) — general build/tactics advice, not route-specific;
    more relevant to `Rogue.lua`'s own milestone content than a route step.
  - No specific zones or XP-efficient quest clusters were named in this
    thread. No content was flagged as an XP trap or to avoid.

If more Rogue leveling sources get researched, add them as their own
`- **Source:** ...` entries here, and promote anything Wowhead-verified
up into the weapon-quest table or the XP-zone section above it.

## Community gear-priority spreadsheet (unverified — pending Wowhead cross-check)

**Source:** ["Horde Rogue - Quest Gear Guide"](https://docs.google.com/spreadsheets/d/13MuieeftxH00hJo7njbydnCgHgcMEtt_u3w1tZVU04s) —
a community-maintained Google Sheet, author/ownership unknown, organized
by zone and level range with a quest → gear-reward table per zone plus a
dungeon breakdown. The sheet color-codes each item's priority (good pick
/ be cautious / essential), but that color coding does not survive a CSV
export, so priority tiering below is lost — only the raw quest/level/gear
data made it through. None of this has been checked against Wowhead's
own Requires/Rewards panel yet, so per this file's own rule at the top,
none of it is promoted into the verified table above until someone does
that check. Treat every row below as a *candidate* to verify and promote,
not a citation in its own right.

### Weapon-reward quests (candidates for the verified table above)

Level column below is the source's "Required Lvl" (character minimum),
not "Quest Lvl" (which is also shown in parentheses where it differs and
is usually the level the quest itself is designed for/rewards XP as).

| Level | Quest | Zone | Weapon | Notes |
|---|---|---|---|---|
| 4 | Skull Rock | Durotar | Dagger | Chain quest (quest lvl 12); "excellent option for dagger upgrade" |
| 9 | Hidden Enemies | Ragefire Chasm (dungeon) | Dagger or mace | Quest lvl 16 |
| 5 | At War With The Scarlet Crusade | Tirisfal Glades | Dagger | Quest lvl 12 |
| 33 | Into the Scarlet Monastery | Scarlet Monastery (dungeon) | Sword | Quest lvl 42; 1.9 speed, +9 str +3 agi +4 stam |
| 12 | Wand to Bethor | Silverpine Forest | Dagger | Quest lvl 18; +1 stam +1 agi |
| 10 | Samophlange | The Barrens | Mace (main hand) | Quest lvl 16; needs 1H mace weapon skill trained |
| 12 | Serena Bloodfeather | The Barrens | Sword or dagger (choice) | Quest lvl 20; sword +3 stam, or dagger +3 agi |
| 10 | Leaders of the Fang | Wailing Caverns (dungeon) | Sword | Quest lvl 22; +5 agi +2 stam |
| 37 | Bring the End | Razorfen Downs (dungeon) | Sword | Quest lvl 42; +28 AP. Also drops a neck (+1 agi +7 stam +10 spirit) |
| 15 | Arachnophobia | Stonetalon Mountains | Sword | Quest lvl 21, elite; +3 stam |
| 20 | Torek's Assault | Ashenvale Forest | Sword | Quest lvl 24; +2 str +2 agi |
| 25 | Baron Aquanis | Blackfathom Depths (dungeon) | Sword | Quest lvl 30, elite; +15 AP, 2.7 speed |
| 30 | Call to Arms | Arathi Highlands | Dagger | Quest lvl 40, elite; 1.89 speed, +7 agi |
| 39 | Seed of Life | Maraudon (dungeon) | "Thrash Blade" (unique-named item) | Quest lvl 51 |
| 40 | A Hero's Welcome | Feralas | Dagger | Quest lvl 46; 1.8 speed, +6 agi +3 stam |
| 45 | Zapped Giants | Feralas | Sword | Quest lvl 48; +6 agi +5 stam |
| 38 | Challenge Overlord Mok'Morokk | Dustwallow Marsh | Dagger | Quest lvl 45, elite; +8 str |
| 35 | Threat From the Sea | Swamp of Sorrows | Dagger | Quest lvl 43; +6 agi +3 stam |
| 53 | Shy-Rotam | Winterspring | Sword or dagger (choice) | Quest lvl 60; both variants +33 AP vs beasts |

### Other notable gear by zone (non-weapon — armor, rings, trinkets, bags)

Kept for when a route step needs a `note` about a non-weapon upgrade.
Format: Quest (quest lvl, elite/dungeon flag / required lvl) — reward.

- **Durotar 1-10**: Carry Your Weight (7/4) — early bag. Securing the Lines (11/7) — vendor gear or upgrade if weapon-skill trained. Dark Storms (12/4) — precursor to Skull Rock, potential gear/vendor.
- **Silverpine Forest 10-20** *(zone note: detour to Undercity to train swords for 10 silver; grab the Hillsbrad flight paths on the way out)*: Pyrewood Ambush (15 elite/12) — pants +2 str +2 agi. A Husband's Revenge (20/10) — ring +4 stam.
- **The Barrens 10-25**: Centaur Bracers (14/9) — ranged weapon upgrade or vendor mallet. The Disruption Ends (15/9) — vendor gear. Stolen Silver (18/9) — boots +1 stam +3 agi (green). Raptor Horns (18/13) — cloak +3 stam (green). Hezrul Bloodmark (19/11) — ring +1 stam +3 agi. Cry of the Thunderhawk (20/10) — gloves +3 stam +3 agi. Betrayal from Within (25/17) — chest +8 stam +2 agi. Isha Awak (27/10) — belt +5 stam +5 agi. The Forgotten Pools (13/10) — breadcrumb, starts the Wailing Caverns sword chain.
- **Wailing Caverns (dungeon)**: Deviate Hides (17/13) — 10-slot bag.
- **Razorfen Kraul (dungeon)**: Willix the Importer (30/22) — ring +6 agi.
- **Razorfen Downs (dungeon)**: Extinguishing the Idol (37/32) — ring +10 stam +4 spirit.
- **Stonetalon Mountains 15-27**: Earthen Arise (20 elite/14) — wrist +2 agi +2 stam. Bloodfury Bloodline (26 elite/18) — cloak +4 agi +3 stam. Gerenzo Wrenchwhistle (27/16) — boots +5 str +5 stam. The Den (29 elite/20) — chest +2 str +9 agi.
- **Ashenvale Forest 18-30**: Vorsha the Lasher (23/20) — ring +3 stam +2 spirit. King of the Foulweald (26/21) — chest +7 agi +6 stam. Warsong Supplies (27/22) — boots +8 agi +6 stam. Je'neu of the Earthen Ring (27/23) — belt +4 agi +3 stam +12 AP. Raene's Cleansing (30/18) — good vendor gear. Answered Questions (30/25) — bow, possible ranged upgrade.
- **Blackfathom Depths (dungeon)**: Allegiance to the Old Gods (26/17) — ring +3 str +3 agi.
- **Thousand Needles 25-35**: Protect Kanati Greycloud (28/23) — wrist +5 agi. Arikara (28 elite/24) — vendor gear, good XP. Wanted - Arnak Grimtotem (29/25) — chest +4 agi +9 stam +3 spirit. Free at Last (29/25) — belt +5 stam +12 AP. Final Passage (36/25) — good XP, possible vendor gear. Safety First (41/29) — gloves +8 agi +9 stam.
- **Desolace 30-40**: Centaur Bounty (31/30) — gloves +7 agi +7 stam. Bodyguard for Hire (35/30) — ring +8 stam. Clam Bait (35/31) — belt +5 stam +16 AP. Khan Hratha (42 elite/30) — belt +8 agi +9 stam.
- **Maraudon (dungeon)**: Vyletongue Corruption (47/41) — head +15 agi +10 stam. The Pariah's Instructions (48/39) — belt +15 agi. Legends of Maraudon (49/41) — trinket (item unspecified in source).
- **Feralas 40-50**: A Grim Discovery (45/37) — cloak +8 stam +10 AP. Rescue OOX-22/FE! (45/40) — shoulders +10 str +10 agi. The Mark of Quality (46/40) — boots +11 agi +6 stam, or gloves +10 str +9 agi. Improved Quality (48/40) — chest +6 str +7 agi +15 stam. Wandering Shay (49/44) — belt +14 str +3 stam. Weapons of Spirit (50/40) — vendor gear.
- **Zul'Farrak (dungeon)**: Divino-matic Rod (47/40) — ring +13 agi +5 stam. Gahz'rilla (50/40) — riding trinket (source notes the precursor mallet quest is hard to get).
- **Un'Goro Crater 48-55**: The Bait for Lar'korwi (56/48) — chest +4 agi +23 stam.
- **Felwood 48-55**: Runecloth quest (req 40) — shoulders +18 agi.
- **Stranglethorn Vale 30-45**: Tiger Mastery (37/28) — gloves +7 str +8 agi. Excelsior (38 elite/31) — boots +7 str +9 agi. Panther Mastery (43 elite/28) — pants +10 agi +11 stam.
- **Badlands 35-45**: Forbidden Knowledge (40/30) — good PVP item. This Is Going to Be Hard (45/35) — run-speed trinket, 30 min cooldown. Broken Alliances (50 elite/40) — chest +3 str +23 agi +5 stam.
- **Searing Gorge 43-50**: (unnamed "Incendosaurs?" quest, 49/45) — PVP trinket that removes bleed. WANTED: Overseer Maltorius (50 elite/45) — chest +18 agi +8 stam. Rise, Obsidion! (52 elite/40) — head +16 agi +10 stam +3 spirit.
- **Western Plaguelands 51-58**: The Last Barov (60 elite/52) — "great" PVP trinket. Alas, Andorhal (60 elite/50) — decent trinket.
- **Eastern Plaguelands 53-60**: Duskwing, Oh How I Hate Thee (60/56) — shoulder +17 agi +6 stam. The Scarlet Oracle, Demetria (60 elite/56) — stat bow: +2 str +3 agi +9 stam.

### Zones/content the source suggests deprioritizing while leveling

Subjective community opinion, not a hard fact — record it, don't treat it
as settled:

- **Azshara 45-55**: its questline ("A Hero's Reward") ties into the
  Molten Core attunement chain — source says it's "pretty safely" skippable
  for pure leveling.
- **Uldaman (dungeon, 36-45)**: source author's own note: "Bunch of
  quests.... I typically avoid this dungeon."
- **Cortello's Riddle** (Stranglethorn Vale, quest lvl 51, req 35): long
  quest chain: "not worth to do it while leveling" despite the 14-slot
  bag reward.

### XP-zone note

- **Tanaris 40-50**: source explicitly flags it as having no standout
  gear, but says not to skip it — "great quests and xp/farming." Fits the
  "Best XP-per-hour zones" section above once corroborated.

## Lockpicking (1-300)

Rogue-exclusive secondary skill, not tracked in-addon (no skill-level
Compat wrapper exists — this is reference-only, same status as the
`research/professions/*.md` guides).

**Source:** the "LockPicking Guide" tab of the community
["Rogue Master Sheet - Horde"](https://docs.google.com/spreadsheets/d/13MuieeftxH00hJo7njbydnCgHgcMEtt_u3w1tZVU04s)
Google Sheet, which itself cites
[vanillaguides.com's 1-300 Lockpicking guide](https://vanillaguides.com/2018/07/30/1-300-lockpicking-guide-for-vanilla-world-of-warcraft-wow-classic/)
and a linked YouTube walkthrough (credited there to "BueBiz").

- **1-75 — The Barrens (Horde)**: pick locks in the zone as you level
  through it normally.
- **75-150 — The Barrens (Horde)**: continue in-zone.
- **150 (breakpoint) — "Mission: Possible But Not Probable"**: while on
  this quest, repeatedly pick the chest containing the quest item
  (deleting and re-looting it each time) — flagged by a Wowhead
  comment as the fastest way to level lockpicking at this bracket. If
  you've already completed the quest, fall back to the highest-skill
  footlocker you can pick: Waterlogged Footlocker (skill 70, Redridge
  Mountains lake) or Battered Footlocker (skill 70/110, Windshear Mine
  or Windshear Crag in Stonetalon, or Durnholde Keep in Hillsbrad).
- **150-175 — Footlockers**: Waterlogged Footlocker (skill 150,
  Desolace/Sar'theris Strand coastal water) or Battered Footlocker
  (skill 150, Angor Fortress upstairs, Badlands). The Workshop Door
  backdoor entrance to Gnomeregan also works at skill 150 but has a
  long respawn — footlockers are generally less annoying.
- **175-200 — Scarlet Monastery doors** (Tirisfal Glades dungeon):
  1. Pick the Armory door.
  2. Pick the Cathedral door.
  3. Enter the Cathedral, stealth to the big Cathedral door on the
     courtyard's northern side, and pick it.
  4. Leave and reset instances (right-click portrait → Reset All
     Instances), repeat.
- **200-250 — Searing Gorge (The Slag Pit)**: drop into the caves and
  stealth around for small black lockboxes near the Dark Iron miners
  and the upstairs elite area. Loop: check by the miners, head
  upstairs and check the hallway, jump down from the elite platform
  back to the miners, repeat.
- **250-300 — Blackrock Depths gates**: enter BRD and pick the gate on
  the immediate left, then (watching for a patrolling mob) the second
  gate on the right, then the next door on the left. Inside that room,
  pick the Shadowforge Lock mechanism — at level 60 it's possible to
  stand carefully between the two flanking mobs without pulling aggro
  by staying as far from the mechanism as possible and erring slightly
  right. Leave and reset instances, repeat.

## Training milestones already covered in-addon

`Rogue.lua`'s own `seeded` milestone table (level-up trainer visits,
key ability unlocks) is a separate, already-built feature — see that
file rather than duplicating its content here. This file is for
route-authoring research specifically (weapon rewards, grind zones),
not general class-leveling advice the addon already surfaces in-game.
