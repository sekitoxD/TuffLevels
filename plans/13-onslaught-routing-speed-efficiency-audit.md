# Plan 13: ONSLAUGHT Solo Horde 1-60 (Orc/Troll) — routing speed/efficiency research and audit

**Status: research and audit only, as requested. Nothing in `Routes/` has been touched.**

Scope: the user asked for research into improving the routing of `ONSLAUGHT Solo Horde
1-60 (Orc/Troll)` (`Routes/Horde/Solo/*.lua`, registered in `Register.lua`) for speed and
efficiency, using QuestieDB/Wowhead/MMO-Champion/etc. as research aids, factoring in
WoW Forever content, and asked for a reviewed audit of findings and recommendations
**before** any implementation starts. This file is that audit. Per `CLAUDE.md`'s route
design ("routes are hand-authored data... don't try to make the engine smarter") and
`plans/03`'s external-research workflow ("a human reads this, decides, and writes the
step"), nothing here should be turned into a route edit without an explicit go-ahead.

---

## 1. What ONSLAUGHT actually is (read from the code, not assumed)

- 48 `Leg()` calls across 28 zone files, concatenated by `Register.lua` in `order` sequence
  into one 1-60 route. Every leg's header comment states its level range, and most legs are
  further split into "Chapter N" sections with their own `levels = {a, b}` — the route
  carries **68 numbered chapters**, and the chapter numbers run in essentially monotonic
  level order even where a zone is revisited (e.g. "Chapter 39: Return to Desolace" is a
  deliberate later pass, not a numbering accident).
- Every zone file already contains explicit, individually-justified skip decisions:
  `{ type = "note", optional = true, name = "Skip: ...", note = "The route deliberately
  skips <quests>. Low XP for the travel time." }`. This pattern recurs in most of the 28
  files (confirmed by grep), not just one or two. **This route has already had an overland
  XP/travel-time optimization pass done on it** — it is not a naive quest-log dump.
- Source is a hand-maintained Google Sheet ("Docc / ONSLAUGHT spreadsheet"), not an
  algorithmic export. `plans/04-sheet-audit.md` is the record of the original
  spreadsheet→addon conversion.
- It is explicitly the **solo** route (`ONSLAUGHT Solo Horde 1-60`). That word is load-
  bearing for one of the findings below.

### Zone order, as actually registered (leg → zone)

1 Durotar · 2 Barrens · 3 Silverpine · 4 Barrens · 5 Stonetalon · 6 Thunder Bluff ·
7 Silverpine · 8 Stonetalon · 9 Ashenvale · 10 Stonetalon · 11 Barrens · 12 Hillsbrad ·
13 Thousand Needles · 14 Barrens · 15 Thousand Needles · 16 Desolace · 17 Stranglethorn ·
18 Swamp of Sorrows · 19 Dustwallow · 20 Hillsbrad · 21 Arathi · 22 Badlands ·
23 Desolace · 24 Stranglethorn · 25 Swamp of Sorrows · 26 Dustwallow · 27 Tanaris ·
28 Feralas · 29 Hinterlands · 30 Searing Gorge · 31 Feralas · 32 Tanaris · 33 Hinterlands ·
34 Felwood · 35 Blasted Lands · 36 Burning Steppes · 37 Un'Goro · 38 Azshara ·
39 Winterspring · 40 Undercity · 41 Western Plaguelands · 42 Winterspring · 43 Silithus ·
44 Felwood · 45 Winterspring · 46 Felwood · 47 Eastern Plaguelands · 48 Western Plaguelands

Cross-checked against the two routes catalogued in this repo's own prior research
(`plans/quests/notable_horde_quests.md` §"Zone order the guides use", sourced from
icy-veins/Sevenleaves and Warcraft Tavern/Nightfall) and against a fresh round of public
guides (Wowhead's Classic leveling guide, Gamerant, NoobToBoss, PewPewShop, WoWisClassic —
see Sources): **the macro shape matches the community consensus** (starter zone → Barrens
→ Stonetalon/Ashenvale → Hillsbrad/Thousand Needles → Desolace/Stranglethorn/Arathi/
Dustwallow → Tanaris/Feralas/Hinterlands/Badlands/Searing Gorge → Un'Goro/Felwood/
Winterspring/Plaguelands). No guide read, including the two already logged internally,
disagrees with ONSLAUGHT's ordering strongly enough to justify a reorder — every guide
also revisits zones 2-3 times for the same reason ONSLAUGHT does (a zone's quest levels
span outside one visit's bracket). **Finding: zone-order is not the lever.** Re-sequencing
would be high-risk (48 legs' worth of `requires`/hearth/flight-path assumptions to
re-verify) for a return the research doesn't support.

---

## 2. Where the real levers are

### 2A. Missing class-specific "TOP" chains — the single biggest gap found

This repo already has a rigorously sourced, partly DB-verified research file for exactly
this (`plans/quests/notable_horde_quests.md`, §"Class-specific chains" and §"Top picks at
a glance") that was written specifically so a human could "read this, decide, and write
the step" (`plans/03`, `plans/quests/README.md`). A grep for every quest name in that
file's Warrior/Rogue/Hunter/Warlock/Shaman/Mage chains against every file in
`Routes/Horde/Solo/` returned **zero matches** except one: **Big Game Hunter** (present in
`StranglethornVale.lua`, both the "Welcome to the Jungle" breadcrumb and the final
turn-in). Everything else — all of it flagged **TOP** or **WORTH IT** in the repo's own
research, all DB-verified — is absent:

| Chain | Class | Payoff | Verified quest IDs (from `plans/quests/notable_horde_quests.md`) |
|---|---|---|---|
| Tame Beast | Hunter | Pets; "the only Hunter class quest every guide says to do" | 6065-6067, 6061-6062, 6082, 6081, 6089 (min 10) |
| Voidwalker | Warlock | Tanking pet, essential for solo elites | 1478, 1506, 1471-1474/1504 family (min 10) |
| Succubus | Warlock | "By far the best companion for leveling" | 1472/1507, 1508, 1509-1510, 1515, 1512 (min 20) |
| Felsteed | Warlock | Free mount + Apprentice Riding at 40, biggest single class speed gain | 3631, 4489, 4490 (min 40) |
| Call of Earth/Fire/Air | Shaman | Totem schools, ~15-45 min each | 1516-1518 (min 4), 1522-1524 (min 10), 1531-1532 (min 30) |
| Whirlwind Weapon (through Berserker Stance) | Warrior | Berserker Stance/Intercept at 30 unconditionally; the weapon itself only pays off if soloed at 38-40 (sources split, ZK says skip the weapon) | 1718 (Islander), 1719 (Affray), 1791 (Windwatcher), 1712 (Cyclonian), 1713 (Summoning), 1792 (Whirlwind Weapon) |
| Mage's Wand / Celestial Orb | Mage | Wand/orb reward | 1952 (Wand), 1953-1958 (Orb, needs Uldaman) |
| Poison chain | Rogue | Poisons; needs 70-85 lockpicking | 2460 (Shattered Salute) |

None of this needs new external research — it's already sourced, already has quest IDs
and NPC names from a DB cross-check, and the mechanism to add it (`class = "WARRIOR"` /
etc. step filters, exactly as `Durotar.lua` already does for `races`) is existing, tested
engine behavior (`plans/03`, `StepApplies()` in `Core.lua`). This is a "promote research
into steps" job, not a "go research" job.

**Caveat carried over from the source file itself:** it explicitly says "no quest ID,
NPC coordinate was verified against a database" for overland quests beyond the DB spot-
checks already listed, and Wowhead couldn't be read client-side when that research was
done. A fresh check this session found the same — Wowhead's classic quest pages did not
return readable content via fetch, consistent with `plans/quests/README.md`'s note. Any
step written from this table still needs a coordinate captured in-game (`/tuff capture`)
before it ships, same as every other route step in this repo.

### 2B. Group dungeon quest bundles — a scope question, not a research gap

`plans/quests/notable_horde_quests.md` also lists large, well-sourced XP bundles for
Wailing Caverns (~12,900 XP), Blackfathom Deeps (~13,500 XP), Razorfen Kraul (~15,300 XP),
Zul'Farrak (several thousand XP per quest, "one of the best dungeons to do a quest run
of"), and others. These are absent from ONSLAUGHT too, but that's very likely **by
design**, not an oversight: the route is branded "Solo" in its own `RegisterRoute` name.
Adding group content would either contradict that branding or require a real decision
about whether ONSLAUGHT should grow an optional "if you have a group" layer (the
`optional = true` field the file already uses for skip-notes would fit naturally here).
**This is a decision for the user, not something to add unilaterally** — flagged as a
recommendation below rather than actioned.

### 2C. WoW Forever content — partially already done, one concrete new lead

- `plans/09`/`plans/10` already did the rigorous version of this research (browsing the
  beta's own companion site, `foreverchanges.pro`, plus in-game capture) and already
  landed Ruins of Lordaeron into `Routes/Horde/Solo/SilverpineForest.lua` as "Chapter 17b"
  (Forever-only, `forever = true`). `plans/10` closed further secondary-source research on
  that dungeon and Hall of Thanes specifically ("Research moratorium," 2026-09-26) — this
  session did not re-open that, per the existing convention.
- A fresh check of `foreverchanges.pro` (same primary source plan 9 used, re-checked this
  session, beta build `1.60.1.69876`) confirms **three** new zones total, not just the
  dungeons already catalogued: **Gilneas, Riverglades, and Mount Hyjal** ("New in Forever"
  on the site's own map page). Plan 9 only covered the 9 new dungeons; it did not cover
  these three standalone zones, so this is genuinely new ground, not a re-tread.
  - **Riverglades: level 36-44, Contested faction, reached by boat from Steamwheedle Port
    (Tanaris) to Powderfuse Port**, with separate Horde/Alliance flight paths (site's own
    text data, not the unreadable map canvas). This sits squarely inside ONSLAUGHT's
    already-crowded 33-44 stretch (Desolace, Stranglethorn, Swamp of Sorrows, Dustwallow,
    Hillsbrad, Arathi, Badlands all currently occupy this band). Badlands in particular is
    already a single-level (40-40) stop that the route's own skip-notes show is thin on
    worthwhile quests. **This is the one concrete, well-evidenced Forever lever**: if
    Riverglades' Horde-side quest density turns out to be good, it's a candidate to
    supplement or partly replace the weakest part of the existing 33-44 stretch. It needs
    the same treatment plan 9 already used for Ruins of Lordaeron: no coordinates exist
    anywhere yet, `/tuff capture` in-game is the only trustworthy source, and the boat's
    availability at the level ONSLAUGHT reaches Tanaris (44-49, i.e. *after* the 36-44
    band) vs. Riverglades' own 36-44 band is a real sequencing question that needs an
    in-game answer, not a guess.
  - **Gilneas**: site labels it "Battle for Gilneas," 16 tiles / 6 places, **no level range
    published yet**. Framed like a war-effort/contested zone rather than a standard 1-60
    leveling zone. Too little data to size or place; would need the same `/dungeons`-style
    wait-for-data treatment plan 9 gave the 7 quest-empty dungeons.
  - **Mount Hyjal**: confirmed to exist (reachable via Winterspring), but the site itself
    states it has **no level range yet** ("gives Hyjal no level range yet" per the site's
    own data). Multiple third-party sources (see caveat below) call it "endgame," which is
    consistent with a post-60 or late-50s zone, but nothing here is confirmed.
- **Caveat — third-party "Forever leveling guide" sites are unreliable and should not be
  used as a source.** A round of searches surfaced several commercial gold-selling/carry
  sites (expcarry, wowforeverbuilds.com, world-of-warcraft-forever.wiki, mythic-store,
  ssegold, boostroom, skillcarry) that each publish a "WoW Forever leveling route." Two of
  these were fetched directly and **actively contradict each other and the site's own
  primary data**: one claims Felwood is a "new Forever questline" at 42-50 (Felwood is a
  pre-existing Classic zone, and ONSLAUGHT already routes it 49-57); the other claims a
  fabricated-sounding "Zephras Isle" zone found nowhere else, and a 24-32 total-hour
  estimate for a 1-60 route with "1,000+ new quests," which is inconsistent with vanilla
  Classic's own 40-80+ hour norm. Both are typical AI-generated SEO filler from carry-
  service marketing sites, not primary sources. **Recommendation: don't cite or route from
  any of these; treat `foreverchanges.pro` and in-game capture as the only trustworthy
  Forever sources, exactly as plan 9 already established.**

### 2D. QuestieDB

`Data.lua` is the only file that should touch QuestieDB's API, and per `CLAUDE.md` it's an
optional enrichment layer (names/coords/validation), never the source of route content.
Nothing in this research found a QuestieDB-specific lever beyond what `plans/07`'s C1 /
`plans/09`'s R4 already scoped (spot-checking whether QuestieDB resolves Forever-exclusive
quest names once Questie is manually installed) — that item is already tracked, not
duplicated here.

---

## 3. Recommendations (impact / performance / dev-time audited per the standing rule)

### R1 — Do not reorder ONSLAUGHT's zone sequence

The research found no case for it (§1). Re-sequencing 48 legs would touch every zone
file's `Leg()` order argument and risk breaking flight-path/hearth assumptions the current
sequence already satisfies, for a return no source — internal or external — supports.

- **Impact:** none; this is a "don't do X" finding.
- **Performance:** n/a.
- **Dev time:** n/a.

### R2 — Promote class-specific TOP chains from `plans/quests/notable_horde_quests.md` into class-gated steps

Add Tame Beast (Hunter), Voidwalker/Succubus/Felsteed (Warlock), the three Shaman totem
calls, Berserker Stance (Warrior, the unconditional half of Whirlwind — leave the weapon
itself as a separately-flagged, sources-disagree detour), and Mage's Wand as `class = "X"`
steps inserted into the existing legs whose level range already covers each chain's
level (e.g. Voidwalker/Tame Beast/totems-at-4-and-10 fit inside the existing Durotar/
Barrens legs; Succubus/Felsteed fit the existing Barrens/Thousand Needles/Ratchet-adjacent
legs the route already passes through).

- **Impact:** touches roughly 6-8 existing `Routes/Horde/Solo/*.lua` files (Durotar,
  TheBarrens, StonetalonMts or wherever Ratchet/Crossroads-area legs sit, ThousandNeedles).
  Purely additive, class-gated steps — `StepApplies()` already silently skips them for
  other classes, so no existing step for any class is touched or reordered.
- **Performance:** none beyond what any other route step costs — these are authored data,
  evaluated the same way as every other step in `IsStepDone()`/`Reconcile()`.
- **Dev time:** each chain is a 3-6 step detour with an already-known quest ID list; call
  it 20-30 minutes of authoring per chain plus an in-game coordinate capture pass
  (`/tuff capture`) per chain the next time a character of that class plays the route —
  roughly 3-4 hours total across all classes, gated on having a character of each class
  to capture coordinates with (same constraint every route edit in this repo has).

### R3 — Ask before adding optional group-dungeon-bundle content

Wailing Caverns / Blackfathom Deeps / Razorfen Kraul / Zul'Farrak bundles are large XP
and already well-sourced, but conflict with the route's own "Solo" branding unless added
as clearly `optional = true` steps. **Needs a decision, not an assumption** — see the
question below.

- **Impact:** if approved, additive `optional` steps in the zone files the route already
  passes near each dungeon's entrance; no change to any non-optional step.
- **Performance:** none — optional steps are already a supported, zero-cost pattern
  (`Progress.lua` dims them; `Reconcile()` already skips blocking on them).
- **Dev time:** larger than R2 — each dungeon bundle is 5-9 quests with turn-ins split
  across multiple NPCs; ~1-1.5 hours of authoring per dungeon, plus the same in-game
  capture gate, plus needing an actual group to test with (this route currently has zero
  group-content testing infrastructure, unlike solo steps which one person can verify).

### R4 — When Riverglades' Horde-side quest data is capturable in-game, evaluate it against the existing 33-44 stretch

Not actionable yet — no coordinates exist anywhere (confirmed: `foreverchanges.pro`'s map
is a non-extractable canvas, same limitation plan 9 hit for the dungeons). The concrete,
falsifiable question to answer in-game once a Forever character reaches level 33-36:
is Riverglades' Horde-side quest density high enough to be worth the boat detour from
Tanaris, and if so, does it replace Badlands (already the thinnest stretch per the route's
own skip-notes) or supplement it. This follows the exact R2/R3 pattern `plans/09` already
used for Ruins of Lordaeron, applied to a new zone instead of a new dungeon.

- **Impact:** none now — research/decision only. If it proceeds, it would touch whichever
  existing 33-44 zone file the route decides to trim, plus one new zone file
  (`Routes/Horde/Solo/Riverglades.lua`) gated `forever = true` the same way Ruins of
  Lordaeron's steps are.
- **Performance:** none — authored data only, same cost model as any other zone file.
- **Dev time:** ~15-20 min to re-check `foreverchanges.pro`'s dungeons/map pages once the
  beta populates Riverglades quest data (same wait-and-recheck posture as plan 9's R1);
  then comparable to any other 8-10 quest zone leg once in-game capture is possible
  (~1-2 hours), per `plans/09`'s own R2 estimate for equivalent-sized new content.

### R5 — Do not pursue Gilneas or Mount Hyjal yet

Same reasoning as `plans/09`'s R1 for the 7 quest-empty dungeons: no level range, no quest
data, "Battle for Gilneas" reads as war-effort/endgame content rather than a 1-60 leveling
zone, and Hyjal's own source admits it has no level range yet. Authoring anything now would
mean inventing content.

- **Impact:** none — a "wait" recommendation.
- **Performance:** n/a.
- **Dev time:** n/a now; re-check alongside R4's periodic `foreverchanges.pro` re-check.

### R6 — Don't cite third-party "WoW Forever leveling guide" commercial sites

Documented here so a future session doesn't rediscover and trust them: expcarry,
wowforeverbuilds.com, world-of-warcraft-forever.wiki, mythic-store, ssegold, boostroom,
and skillcarry all publish Forever leveling routes that disagree with each other and, in
at least two checked cases, with `foreverchanges.pro`'s own primary data. Treat
`foreverchanges.pro` and in-game capture as the only trustworthy Forever sources (this
matches, and extends to non-dungeon zones, the sourcing rule `plans/09`/`plans/10` already
established for the 9 new dungeons).

- **Impact:** none — a sourcing-hygiene note.
- **Performance:** n/a.
- **Dev time:** n/a.

---

## 4. Decisions (2026-09-26)

1. **R2 (class chains): approved, all classes.**
2. **R3 (optional group dungeon bundles): approved, as `optional = true` steps.**
3. **R4 (Riverglades): approved as a queued follow-up** — no coordinates exist yet, so
   this stays research-only until a Forever character can `/tuff capture` at 33-36.

## 5. Implementation log (2026-09-26)

All R2 additions use `class = "X"` filters (`StepApplies()` already skips them for other
classes, no existing step touched or reordered) and are commented in-file with the exact
`plans/quests/notable_horde_quests.md` sourcing and a "NOT YET IN-GAME VERIFIED" flag,
matching the precedent `plans/09`/`plans/10` set for Ruins of Lordaeron. Steps whose exact
accept/turnin structure wasn't confirmed use `type = "note"` instead of `type = "accept"`
so nothing is mistracked; steps with a confirmed quest name/ID use `questName`/`quest` so
`Reconcile()` can auto-advance them once verified in-game.

| Chain | Class | File(s) | Mandatory or optional | Why |
|---|---|---|---|---|
| Call of Earth (lvl 4) | Shaman | `Durotar.lua` Ch.1 | Mandatory | Same hub as existing Valley of Trials content, zero detour |
| Call of Fire (lvl 10) | Shaman | `Durotar.lua` Ch.4, `TheBarrens.lua` Ch.6 (alt starter note) | Mandatory | Durotar-side starter fits the existing Orgrimmar stop; Barrens alt-starter cross-referenced |
| Call of Air (lvl 30) | Shaman | `ThousandNeedles.lua` Ch.24 | Mandatory | Giver is at Freewind Post, which the route already visits this chapter |
| Voidwalker (lvl 10) | Warlock | `Durotar.lua` Ch.5 (x3 steps) | Mandatory | Skull Rock and Neeru Fireblade are already existing route waypoints in this exact chapter |
| Succubus (lvl 20) | Warlock | `TheBarrens.lua` Ch.13 (Camp Taurajo) | Mandatory (Barrens leg); Stonetalon leg (Ken'zigla's Draught) flagged but not yet inserted | Chain spans two zones; only the Barrens half was placed with confidence |
| Summon Felsteed (lvl 40) | Warlock | `Badlands.lua` Ch.38 | **Optional** | Real dedicated trip back to Ratchet - route hasn't been in the Barrens since level 31 |
| Tame Beast (lvl 10) | Hunter | `Durotar.lua` Ch.4 | **Optional** | Backtrack to the Valley of Trials, which the route left after Chapter 1 |
| Berserker Stance (lvl 30) | Warrior | `TheBarrens.lua` Ch.26 (x2 steps) | Mandatory | The Islander/Affray, unconditionally worth it per every source; last Barrens visit |
| Whirlwind Weapon finale (lvl 38-40) | Warrior | `HillsbradFoothills.lua` Ch.35 | **Optional** | Sources split on the weapon itself; level-40 elite fight |
| Mage's Wand (lvl 30) | Mage | `TheBarrens.lua` Ch.26, `ThousandNeedles.lua` Ch.27 | Mandatory (start + Shimmering Flats leg); SM Library leg not inserted (group content) | Fits the existing Orgrimmar/Shimmering Flats stops |
| Poison chain (lvl 20) | Rogue | `TheBarrens.lua` Ch.13 (Orgrimmar) | **Optional** | Elite kill "likely needs group assistance"; disputed lockpicking requirement |

R3 additions (`optional = true`, no `class` filter - available to any grouped player),
placed next to an existing "the route deliberately skips X" note that's part of the same
dungeon's quest bundle:

| Dungeon bundle | File | Anchored to existing skip |
|---|---|---|
| Wailing Caverns (~12,900 XP, 7 quests) | `ThunderBluff.lua` | "Skip: Leaders of the Fang" |
| Razorfen Kraul (~15,300 XP, 5 quests) | `ThunderBluff.lua` | "Skip: Blueleaf Tubers" |
| Zul'Farrak (7 quests) | `Tanaris.lua` | "Skip: Scarab Shells" |

**Not done in this pass** (documented here so it isn't lost, not because it was rejected):
Blackfathom Deeps, Ragefire Chasm, Razorfen Downs, Scarlet Monastery, Maraudon, Sunken
Temple, and the level-52-60 dungeon bundles (BRD/LBRS/UBRS/Scholomance/Stratholme) from
§2B's source table are not yet added as optional steps. Same pattern as above would apply
- find the existing "deliberately skips" note tied to that dungeon's quest name (Durotar's
"Skip: Slaying the Beast" and "Skip: Hidden Enemies #3" are the Ragefire Chasm anchor
points, for example) and add an `optional = true` bundle note beside it. Also not done:
the Stonetalon leg of the Succubus chain (Ken'zigla's Draught at Malaka'jin) and the SM
Library leg of the Mage's Wand chain, both flagged in their respective notes above.

### Audit (impact / performance / dev time, per the standing rule)

- **Impact:** 7 files touched (`Durotar.lua`, `TheBarrens.lua`, `ThousandNeedles.lua`,
  `HillsbradFoothills.lua`, `Badlands.lua`, `ThunderBluff.lua`, `Tanaris.lua`), all under
  `Routes/Horde/Solo/`. Every change is additive - no existing step was edited, removed,
  or reordered. `StepApplies()`/`Reconcile()` need no engine change; the `class` and
  `optional` filters used here already exist and are already exercised elsewhere in these
  same files.
- **Performance:** none beyond the existing per-step cost model - these are authored data
  steps evaluated by `IsStepDone()`/`Reconcile()` exactly like every other step already in
  the file. No new per-tick or per-event work.
- **Dev time:** this session's authoring pass (~14 new step tables plus the cross-
  reference note), against the plan's own R2 estimate of "~3-4 hours across all classes"
  and R3's "~1-1.5 hours per dungeon" (3 dungeons done here). Remaining, not yet spent:
  the in-game coordinate capture pass this all still needs (flagged in every new step's
  `note`), and the "not done in this pass" items above.

### What still has to happen before this is trustworthy

Every new step in this pass is explicitly flagged `NOT YET IN-GAME VERIFIED` in its
`note`/comment. None of it has coordinates beyond what a handful of steps borrowed from
neighboring existing steps' zones. Per `CONTRIBUTING.md`'s standard workflow: the next
time a character of each class plays this route, use `/tuff capture` at each flagged step
to fill in real coordinates and confirm the accept/turnin sequence, then run `/tuff
verify`. Until that happens, treat this exactly like `plans/09`'s Ruins of Lordaeron
addition was treated - merged, additive, zero risk to the existing mandatory path (every
new step is either `class`-gated to a different class than whoever's testing, or
`optional`), but not yet confirmed correct.

---

## Sources

- Internal: `plans/quests/notable_horde_quests.md`, `plans/quests/README.md`,
  `plans/03-route-folder-layout-and-class-research.md`,
  `plans/09-forever-dungeons-routing-research.md`,
  `plans/10-forever-dungeons-implementation.md`, `plans/04-sheet-audit.md`,
  `Routes/Horde/Solo/*.lua` (read directly this session), `CLAUDE.md`.
- External (fetched/searched this session, 2026-09-26):
  - [Nightfall's WoW Classic Horde Leveling Guide — Warcraft Tavern](https://www.warcrafttavern.com/wow-classic/guides/horde-leveling-guide/)
  - [Leveling Guide 1-60 for WoW Classic — Wowhead](https://www.wowhead.com/classic/guide/classic-wow-leveling)
  - [Classic WoW Horde Leveling Guide and Recommended Zones — Wowhead](https://www.wowhead.com/classic/guide/horde-leveling-classic-wow)
  - [WoW Classic: Horde Leveling Guide (& Best Horde Leveling Route) — Gamerant](https://gamerant.com/wow-classic-horde-leveling-guide-best-horde-leveling-route/)
  - [WoW Classic Leveling Guide 1-60: Routes & Tips — NoobToBoss](https://noobtoboss.com/wow-classic-leveling-guide/)
  - [Horde Leveling Guide (1-60) for Classic WoW — WoWisClassic](https://www.wowisclassic.com/en/guide/leveling-1-60-horde/)
  - [WoW Classic Vanilla Guide ONSLAUGHT Route. How to make an Addon — OwnedCore](https://www.ownedcore.com/forums/wow-classic/wow-classic-general/801922-onslaught-route-how-make-addon.html) (confirms ONSLAUGHT's community origin as a spreadsheet route usable via the Guidelime addon; no new efficiency detail beyond what this repo already has)
  - [Speedrun Horde Leveling Guide 1-60 — RestedXP](https://shop.restedxp.com/product/speedrun-horde-leveling-guide-1-60-season-of-mastery-classic-era/) and [Forever Leveling Guide - Horde — RestedXP](https://shop.restedxp.com/product/forever-leveling-guide-horde/) (product pages only; both returned HTTP 403 to direct fetch, so their route content is not verified here — noted for awareness only, since this repo already has a separate, in-progress RXPGuides comparison project, `Routes/Horde/OrcTrollRXP.lua` / `plans/12`)
  - `https://foreverchanges.pro/` and `https://foreverchanges.pro/map` (primary Forever beta source, same one `plans/09` used; re-fetched this session, build `1.60.1.69876`)
  - Third-party Forever guide sites checked and flagged unreliable in §2C/R6: expcarry.com, wowforeverbuilds.com, world-of-warcraft-forever.wiki, mythic-store.com, ssegold.com, boostroom.com, skillcarry.net (`https://expcarry.com/wow-forever-leveling-guide-horde` and `https://shop.restedxp.com/product/forever-leveling-guide-horde/` returned HTTP 403/526 on direct fetch; the rest are search-snippet-only, not independently fetched)
