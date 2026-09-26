# Plan 11: Wowhead "Every Dungeon Quest" cross-check for the Orc/Troll guide

Source: `https://www.wowhead.com/forever/guide/dungeons/every-dungeon-quest-location`
(by Serenal, updated 2026/09/23, patch 1.60.1), fetched live 2026-09-24 via
browser and read as page text. Research and audit only — nothing in `Routes/`
has been touched by this pass.

Continues `plans/09-forever-dungeons-routing-research.md` and
`plans/10-forever-dungeons-implementation.md`, which already did the first
round of this exact work (foreverchanges.pro as the source, Ruins of
Lordaeron implemented in `Routes/Horde/Solo/SilverpineForest.lua` Chapter
17b). This pass checks a second, independent source against what's already
there rather than starting from scratch.

---

## 1. What the guide is, and its limits

It's a single page covering **all** dungeon quests in WoW Forever — the ~17
Classic dungeons and the 9 Forever-exclusive ones — each quest listed with
level, faction side, effort/shareability, giver name + zone, and often a
`/way x y` coordinate. That coordinate data is new and useful: plan 09 found
that the previous source (foreverchanges.pro) had **no coordinates at all**,
only narrative location text. This page fixes that gap for some entries.

Two caveats, both important before trusting anything from it directly:

- **The site's own disclaimer:** "WoW: Forever is currently still in Beta...
  some of this guide may be incomplete or inaccurate. As dungeons become
  available to test, this guide is being checked. Currently unavailable
  dungeons have data taken from Classic WoW or the Wowhead Database." Treat
  it the same as any secondary source — useful for cross-referencing, not a
  replacement for this repo's own `/tuff capture` workflow.
- **Extraction quality:** the page was read as flattened text (table
  structure, icons and column alignment don't survive that). One concrete
  case found below (Earthseer Farsen / Afadra Dunwall sharing identical
  coordinates despite being in different zones) looks like a scrape
  misalignment, not real data. Column values like faction "Side" markers are
  similarly not fully trustworthy from this extraction.

## 2. Cross-reference against the default Orc/Troll route

"Default leveling guide for orc/troll" is `ONSLAUGHT Solo Horde 1-60`
(`Routes/Horde/Solo/*.lua`) — the quest-by-quest route, not the
`Routes/Horde/Horde1-60.lua` skeleton (which deliberately carries no quest
IDs yet, per its own header).

### 2a. Ragefire Chasm and Wailing Caverns — already covered, no changes needed

`Routes/Horde/Solo/Durotar.lua:486-621` already has the RFC "Hidden Enemies"
chain. Its captured coordinate for Thrall (Valley of Wisdom, `x=31.8,
y=37.8`) matches the guide's `/way 31 37` almost exactly — good
corroboration that the existing in-game-captured data is right. The route
also deliberately skips *Slaying the Beast* and *Hidden Enemies* part 3 as
low XP for the travel; nothing in the guide changes that trade-off.

Wailing Caverns' Barrens-side quests (Deviate Hides, Deviate Eradication,
etc.) are likewise already in `Solo/TheBarrens.lua`.

**Recommendation: no action.** This is the strongest evidence in this pass
that the existing captured data is trustworthy — an independent source
agrees with it down to the coordinate.

### 2b. Ruins of Lordaeron (Forever-only, `SilverpineForest.lua` Chapter 17b)

This is where the guide adds real value — three specific comparisons:

| Quest | Current file | Guide says | Verdict |
|---|---|---|---|
| **Light's Justice** | `npc = "Morbin Lightbane"`, no coords (line 677-679) | Undercity, `/way 57.8 89.8` | New data — safe to add, same giver name already assumed |
| **The New Plague** | `npc = "Theodore Griffs"`, no coords (line 681-684) | Undercity, `/way 47.0 72.6` | New data — safe to add, same giver name already assumed |
| **Unending Torment** | starts from a looted item inside the dungeon (line 721-723) | "Inside Dungeon" | Agrees — corroboration, no change |
| **A Frightened Request** | `zone = "Silverpine Forest"`, no coords, note admits it's a guess ("check the Sepulcher first") (line 630-633) | **Undercity**, Tabitha Heartweaver, `/way 34 21` | **Conflicts** — different zone entirely |
| **Crest of Lordaeron** | `type = "accept"` from `npc = "Oran Snakewrithe"` in Undercity, before entering (line 686-688) | "Inside Dungeon" (obtained inside, not from an NPC beforehand) | **Conflicts** — guide implies no pre-dungeon accept step exists at all |
| **The Wrath of Rath'mael** | Brill, `x=59.4, y=52.4`, `approx = true`, borrowed from an unrelated step (line 690-694) | Brill, Deathguard Kristof, **no coordinate given** | Guide can't confirm or deny this one — still unverified |

The last two rows are real conflicts, not just missing data, and they're
structural (which zone a step points at; whether a whole `accept` step
should exist) rather than a coordinate fill-in. Neither this guide nor the
one plan 09 used has been confirmed in-game — guessing between two
un-verified secondhand sources doesn't resolve anything.

### 2c. Hall of Thanes — no change

Nothing in this page's Hall of Thanes section contradicts plan 9/10's
finding that it has no confirmed Horde-side quest, or plan 10's decision to
implement it Alliance-only. The page's faction "Side" column didn't survive
text extraction cleanly enough to treat its absence there as new evidence
either way.

### 2d. The other 15 Classic dungeons — out of scope for this pass

Deadmines, SFK, BFD, Gnomeregan, RFK, Scarlet Monastery, RFD, Uldaman, ZF,
Maraudon, Sunken Temple, BRD, Dire Maul, Scholomance, Stratholme, UBRS are
all in the guide too, each with several quests. Whether the 1-60 Orc/Troll
route already threads through all of the relevant ones, with correct
coordinates, is a real question but a much bigger one — sized under R4.

## 3. Recommendations (audited per the standing plan-review rule)

### R1 — Add the two corroborating coordinate fills now

Add `x = 57.8, y = 89.8` to the Light's Justice accept step and
`x = 47.0, y = 72.6` to The New Plague accept step in
`Routes/Horde/Solo/SilverpineForest.lua`. Both keep the same NPC name the
file already has — the guide only adds a coordinate, it doesn't contradict
anything.

- **Impact:** `Routes/Horde/Solo/SilverpineForest.lua` only, 2 lines. Nothing
  else reads these fields except `Arrow.lua`'s waypoint display.
- **Performance:** none — static authored data, same cost as every other
  coordinate in the file.
- **Dev time:** ~5 minutes.

### R2 — Don't guess on the two conflicts; carry them into the next in-game capture pass

Do **not** move A Frightened Request to Undercity or restructure the Crest
of Lordaeron accept step based on this guide alone. Plan 10's Phase 1
already calls for a `/tuff capture` pass on this exact dungeon once someone
is in-game at the right level — add these two specific questions to that
pass instead of resolving them from a second unverified written source:
(1) is A Frightened Request really given in the Undercity, and where; (2) is
Crest of Lordaeron picked up from an NPC at all, or only inside the dungeon.

- **Impact:** none now — no file touched. Piggybacks entirely on
  Phase 1's already-planned capture session.
- **Performance:** n/a.
- **Dev time:** no additional time; it's two extra things to check during a
  play session that's already planned.

### R3 — Leave Hall of Thanes Alliance-only

No new evidence here to revisit plan 10's decision.

- **Impact / Performance / Dev time:** none — status quo.

### R4 — Treat the other 15 Classic dungeons as a separate, explicitly-scoped follow-up if wanted

Cross-checking full coverage and coordinate accuracy for Deadmines through
UBRS against the entire 1-60 route is realistically its own multi-hour pass,
not a side effect of this one. Spot-checking here (RFC, WC) took real,
useful comparison time per dungeon; the other 15 have several quests each.

- **Impact:** none now.
- **Performance:** n/a.
- **Dev time estimate if pursued:** roughly 10-15 min per dungeon to
  `grep` the route files, compare against the guide's list, and note gaps —
  about 2.5-4 hours for all 15 if full coverage confirmation is wanted.

### One data-quality flag, not a recommendation

The guide's Hall of Thanes rows list Earthseer Farsen (Dun Morogh, Gol'Golar
Quarry) and Afadra Dunwall (Ironforge, Old Ironforge) at the **identical**
coordinate (64.8, 58.4) despite being different zones — almost certainly a
table/scrape misalignment in how the page text flattened, not real data.
Don't reuse that pairing without checking the live page directly first.

## 4. Status

**R1 applied (2026-09-24):** `Routes/Horde/Solo/SilverpineForest.lua`'s
Light's Justice and The New Plague accept steps now carry
`x = 57.8, y = 89.8` and `x = 47.0, y = 72.6` respectively. Not yet run
in-game — same "untested" caveat as the rest of Chapter 17b per plan 10's
verification checklist.

**R2 resolved (2026-09-24), one of two conflicts fixed:**

- **A Frightened Request — fixed.** Moved from a guessed Silverpine Forest
  accept to Undercity, Tabitha Heartweaver, `x = 34.0, y = 21.0`, matching
  the guide's `/way 34 21`. The accept step moved from mid-Chapter-17 into
  the Chapter 17b Undercity block (between Crest of Lordaeron and The Wrath
  of Rath'mael, keeping all-Undercity accepts grouped before the Brill trip).
  The turn-in step, previously a placeholder that admitted the NPC was
  unknown, now points at the same NPC/coordinate — same-NPC accept/turn-in
  quests don't need a return trip. `logCount` hints between the old and new
  position were shifted by 1 to stay consistent (non-functional, display-only
  per `UI.lua:441`, but kept accurate). Judgment call: the guide's precise
  single coordinate outweighed the old guess, and this guide's coordinates
  already corroborated known-good data elsewhere in this file (section 2a).
  Still unverified in-game — flagged in the step notes.
- **Crest of Lordaeron — not changed.** The guide's evidence (two
  ambiguously-formatted "Inside Dungeon" rows for the same name at different
  levels, in a section mixing factions) is weaker than the original
  structured giver name (Oran Snakewrithe) from foreverchanges.pro, and
  reversing it would mean deleting a whole `accept` step rather than filling
  in a gap. Left as originally sourced, with a note on the step recording
  the conflict and the reasoning, for the next in-game capture pass to
  settle for real.

**R4 (2026-09-24): deferred by user decision, left for later work.** Not
sized or started this pass — still just the estimate in section 3 (~2.5-4
hours for all 15 remaining dungeons) if picked up later.
