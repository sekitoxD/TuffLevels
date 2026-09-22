# Plan 9: WoW Forever dungeons — routing-readiness research and audit

**Status: research done. Ruins of Lordaeron (Horde side) is implemented in
the Solo route, untested in-game. See section 6.**

Source: `https://foreverchanges.pro/dungeons` and its 9 new-dungeon subpages,
plus `https://foreverchanges.pro/map`, browsed live 2026-09-22 (beta build
1.60.1.69913, page data dated 2026-09-19, ~43 days from the site's own launch
countdown). Cross-referenced against this repo's `Routes/**/*.lua`,
`plans/07-future-improvements.md` item C1, and `CLAUDE.md`'s route-authoring
rules.

---

## 1. What Forever adds: 9 new dungeons alongside the 26 Classic ones

| Dungeon | Levels | Location | Faction flavor (from site's "Story" text) | Quests known so far |
|---|---|---|---|---|
| Hall of Thanes | 13–18 | Beneath Ironforge, Dun Morogh | Alliance home turf; Horde "sneaks or fights in" | **4** (2 both-faction, 2 Alliance; no Horde quest seen yet) |
| Ruins of Lordaeron | 15–20 | Tirisfal Glades, above Undercity | Horde home turf (Forsaken); Alliance sneaks in | **10** (4 Alliance, 6 Horde) |
| Excavation Site: Wetlands | 24–29 | Wetlands, above Whelgar's Excavation | Explorers' League (Alliance-flavored); no split confirmed | 0 — not run enough in beta yet |
| City of Dalaran | 28–33 | Alterac Mountains | Neutral/story | 0 |
| The Drowned City | 35–40 | Off the coast of Stranglethorn Vale | Neutral | 0 |
| Krol'dok Stronghold | 40–45 | **Riverglades** (a brand-new zone) | Neutral | 0 |
| Alcaz Prison | 48–53 | Alcaz Island, Dustwallow Marsh | Neutral (Varian Wrynn backstory) | 0 |
| Blackmaw Hold | 55–60 | Behind the gate in Azshara | Neutral (leads toward the Barrow Deeps raid) | 0 |
| Shaper's Terrace | 58–60 | Un'Goro Crater | Neutral | 0 |

Only **2 of the 9** have any quest data yet — the site's own copy says the rest
"fill up as they get run" in the beta, i.e. this is a live, still-filling
dataset, not a finished reference.

## 2. What the site actually gives you, per dungeon that has data

For each dungeon page (e.g. `/dungeons/hall-of-thanes`,
`/dungeons/ruins-of-lordaeron`) the structured fields are: quest name, level
(and minimum level it can be picked up at), the **quest giver's name and zone**
(not coordinates — e.g. "Earthseer Farsen, Dun Morogh"), objectives (kill/
collect/bring-back targets), XP/money reward, and item choices. This is
good, beta-sourced, and reasonably complete for the two populated dungeons.

**What it does not give: no numeric coordinates anywhere.** "Location" text is
narrative only (e.g. "the way in is from the High Seat," "Alcaz Island,
Dustwallow Marsh," "Behind the gate in Azshara"). The `/map` page is an
interactive canvas/WebGL map with its own internal pixel-space (its URL
fragment encodes state like `x=5856&y=9984&z=1.25` for a Riverglades tooltip)
— that is the map widget's own pan/zoom coordinate system, not WoW's in-game
0–100 percentage coordinate system `Data.lua`/route files use, and it isn't
exposed as extractable text (it's a rendered map, not a data table). Trying to
back-convert those into route `x`/`y` would be guesswork, not a source of
truth — and it would also conflict with `CLAUDE.md`'s explicit principle that
"route files always carry their own coordinates as the source of truth,"
independent of any external enrichment source.

## 3. Cross-reference against this repo's existing routes

- **Excavation Site: Wetlands sits directly on top of content this addon
  already routes.** It's described as "above Whelgar's Excavation" in
  Wetlands — the three Alliance RXP-converted routes
  (`Routes/Alliance/{DwarfGnome,Human,NightElf}.lua`) already have a step at
  that exact site (`zone = "Wetlands", x = 36.62, y = 42.16`, quest 299,
  "Open the Ancient Relics and Loose Soil... in the Excavation Site"). That
  existing coordinate is a solid anchor point for wherever the new dungeon's
  entrance turns out to be, once someone finds it in-game.
- **Ruins of Lordaeron is the highest-overlap find.** It's inside Tirisfal
  Glades, directly above the Undercity — exactly the zone this addon's most
  mature content covers (`Routes/Horde/TirisfalStart.lua`,
  `Routes/Horde/Solo/SilverpineForest.lua`, the main Horde 1-60 route). It
  also already has the most quest data of any new dungeon (10 quests, 6 of
  them Horde-side) and real quest-giver names/zones (Deathguard Kristof in
  Brill, Morbin Lightbane and Theodore Griffs in Undercity).
- **Krol'dok Stronghold confirms a prior finding, doesn't add a new one.**
  `plans/07-future-improvements.md` item C1 already flagged Riverglades as a
  Forever-exclusive zone to spot-check against QuestieDB. This research
  confirms Riverglades is real and gives it a level range (40–45) and the
  dungeon built into it, but no route in this repo references it yet
  (confirmed by grep — zero hits for "Riverglades" anywhere in `Routes/`).
- **No existing route references the other 6 new dungeons at all**
  (Hall of Thanes, City of Dalaran, The Drowned City, Alcaz Prison, Blackmaw
  Hold, Shaper's Terrace) — grep across `Routes/` and the root `*.lua` files
  came back empty for all of them. This is expected; they're new content.

## 4. Recommendations

Every item below carries the impact/performance/dev-time audit per the user's
standing rule.

### R1 — Don't author routes for the 7 quest-empty dungeons yet

Seven of the nine have zero quest data on the source site because the beta
hasn't been run through them enough. Authoring route steps today would mean
inventing quest names/givers from nothing, which contradicts this repo's own
design principle (`CLAUDE.md`: "routes are hand-authored data files... don't
try to make the engine smarter"). Wait for the site (or direct in-game
play) to populate them.

- **Impact:** none — this is a "don't do X yet" recommendation, no files touched.
- **Performance:** n/a.
- **Dev time:** n/a now; re-check periodically (the site updates live) or
  once a Forever character can walk into Krol'dok Stronghold/Alcaz
  Prison/etc. directly.

### R2 — When ready to author, prioritize Ruins of Lordaeron first

It has the most complete quest data of any new dungeon, sits inside the
addon's most mature Horde leveling territory, and both factions have quest
data available (useful since Alliance routes are currently the
less-developed, "unverified" side of this repo per
`plans/07-future-improvements.md` A1). Still fully gated on R3.

- **Impact:** future work would touch `Routes/Horde/TirisfalStart.lua` /
  `Routes/Horde/Solo/SilverpineForest.lua` (Horde side) and one of the
  Alliance RXP routes (Alliance side) — additive steps, no engine change.
- **Performance:** none — authored data only, same as any other route content.
- **Dev time:** not sized here (blocked on R3); once coordinates exist,
  scope is comparable to any other 6-10 quest chain (~1-2 hours per faction
  side, in line with the estimate `plans/07`'s B1 gives for smaller
  class-specific chains).

### R3 — Get real coordinates through the addon's own capture tooling, not this site

Since the site has no numeric coordinates and its map isn't a reliable
source, the right path is the same one `CONTRIBUTING.md` already documents
for every other route: stand at each quest giver / objective in-game on the
Forever beta and use `/tuff capture` (dumps the live quest log as pasteable
step lines) or the `Recorder.lua` live-play capture, both of which pull real
`Data:` coordinates rather than approximated ones.

- **Impact:** none yet — this is a workflow choice, not a code change.
  `Recorder.lua` and `/tuff capture` already exist and need no modification
  to use for this.
- **Performance:** n/a — existing tooling, used as designed.
- **Dev time:** the capture itself is fast once someone is in-game at the
  right level (minutes per quest); the real cost is having a
  Forever character at the right level range to walk the dungeon, same
  open-ended "playtest" cost `plans/07` A1 already calls out for other routes.

### R4 — Re-run plan 07's C1 QuestieDB spot-check now that concrete quest names exist

`plans/07-future-improvements.md` C1 proposed spot-checking QuestieDB coverage
of Forever-exclusive content using Riverglades/Krol'dok/Alcaz Prison as
examples, but had no concrete quest IDs to test with. This research adds real
quest names to test against for at least Hall of Thanes and Ruins of
Lordaeron (e.g. "Old Ironforge Incursion," "The Wrath of Rath'mael") —
Krol'dok/Alcaz Prison still have no quests to test since the site hasn't
captured any yet.

- **Impact:** research only — confirms or denies whether `Data.lua`'s
  QuestieDB adapter can resolve these specific quest names/IDs once a
  manually-installed Questie is loaded on Forever. No code change unless the
  check reveals a real gap.
- **Performance:** n/a.
- **Dev time:** ~15-20 min in-game (open quest log/Questie for a character
  near these zones, or `/tuff capture` against a live quest, per R3).

### R5 — Treat all of this as provisional pre-launch data

The site itself states beta drops/rewards "may change before release," and
launch is still weeks out per its own countdown. Nothing here should be
treated as final even where quest data exists (Hall of Thanes, Ruins of
Lordaeron) — expect to re-verify quest text, XP values, and especially quest
*availability* closer to or after the 2026 launch date.

- **Impact:** none now; a reminder for whoever picks up R2/R3 later.
- **Performance:** n/a.
- **Dev time:** n/a.

### R6 — Decide where dungeon-quest content belongs before authoring anything

`Routes/Horde/Dungeon/` already exists, but it's a **5-man dungeon-farm
leveling route** (repeated dungeon clears for XP, per its own header
comments — "BRD Prison Prep & Farm," etc.), not a quest-chain-in-a-dungeon
route. The new Forever dungeons described above are solo-accessible,
quest-driven content reachable from the open world (a quest giver in Brill
sends you into Ruins of Lordaeron, for instance) — closer in shape to the
zone-based `Routes/Horde/Solo/*.lua` files than to the existing `Dungeon/`
folder. This is a real decision to make before any authoring starts, not
something to assume one way — file placement affects which existing route
these steps get spliced into.

- **Impact:** a naming/placement decision only; affects which existing file(s)
  R2's steps eventually get added to. No engine change either way — both
  options use the same step schema.
- **Performance:** none — placement doesn't affect runtime behavior.
- **Dev time:** ~0, it's a decision, not implementation work.

## 5. Status

Research and audit only, as instructed — nothing drafted into `Routes/`, no
`.lua` files touched. Ready for a decision on R6 and, once a character can
reach these zones in-game, on starting R3/R2 for Ruins of Lordaeron.

## 6. Implementation: Ruins of Lordaeron, Horde side (2026-09-22)

R2 has been started ahead of R3, using quest names instead of coordinates.
That is the same approach `Routes/Horde/TirisfalStart.lua` already uses, and
`Core.ResolveQuest` resolves names from the live quest log. Decisions made:

- **R6 resolved: the default Solo route, not `Dungeon/` and not
  `TirisfalStart.lua`.** The Horde quests go into `ONSLAUGHT Solo Horde 1-60`,
  Leg 7 (Chapter 17, `Routes/Horde/Solo/SilverpineForest.lua`), as a new
  "Chapter 17b" at the end of that leg. The leg already returns to the
  Sepulcher and Undercity at level 23, where five of the six givers stand.
  Brill (Deathguard Kristof, location assumed: the source only says
  "Tirisfal") is a new detour of about two short runs.
  The quests are level 21-22 (pick up at 15-16). `TirisfalStart.lua` ends at
  level 14, below that minimum.
- **Pickups go at the end of the leg, not on arrival.** The quest log reaches
  20 (full) at Tarren Mill, so nothing extra fits earlier.
- **Forever-only.** The Solo files also load on Classic Era, where this
  dungeon doesn't exist. Steps carry `forever = true`, and the new
  `ns.SoloForeverOnly` (in `Routes/Horde/Solo/Init.lua`) dropped them at load
  time on any client that isn't Forever. *(Superseded in plan 10: the filter
  now lives in `ns.RegisterRoute` for every route, and the helper is gone.)*
- **Alliance side was not done in this pass** (it is in plan 10). The 4 Alliance quests (Stormwind givers) were
  left for a later pass, by decision.

Known gaps, all flagged in the step notes: no coordinates for the new NPCs.
On Forever the hearth step now sits inside Chapter 17b, so it counts toward
that section in Progress and Pace.
Brill is approximate, borrowed from the leg 3 Brill step. Faranell's position
is reused from `ArathiHighlands.lua`. A Frightened Request's giver location
and turn-in NPC are unknown. The source doesn't say which boss drops the
Abominable Head. The Wrath of Rath'mael's XP isn't listed. Nothing has been
tested in-game yet: R3's `/tuff capture` pass is still what turns this into
verified data.

| Change | Impact | Performance | Dev time |
|---|---|---|---|
| `SoloForeverOnly` helper (removed in plan 10) | `Solo/Init.lua` only. It's opt-in per leg, and only Leg 7 uses it. | One filter pass per wrapped leg at load time. Zero per tick or per event. | ~15 min |
| Ruins of Lordaeron steps (20: 1 at the Sepulcher, 19 in Chapter 17b) | Leg 7 only. It adds a section to the Solo route on Forever, so Chapter 17's personal-best split gets shorter there (earlier PBs aren't comparable), and later step numbers shift, which matters to nothing because no Solo step uses `requires`. | Authored data only | ~1 h |
| In-game verification (R3) | None until done | n/a | ~30-45 min at level 23 with a group |

Continued in `plans/10-forever-dungeons-implementation.md`: the dungeon is now mandatory, the Undead entry point and the Alliance and Hall of Thanes blocks are added, and there is an audited plan for trimming later grind.
