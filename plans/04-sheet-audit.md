# Plan 4: Audit of the ONSLAUGHT route spreadsheet, and the routes converted from it

Source: `docs.google.com/spreadsheets/d/1ObO5Zf3SbFp9EPfiIoqFnmYtWLpFtvClMGRapiHxmLM`
Audited: 2026-09-19, against a CSV export of all three tabs.

The sheet is read-only from here, so nothing below was fixed *in the sheet*. Everything
marked "repaired" was repaired during conversion, in the generated route files. If the
sheet is ever re-exported, the same repairs have to be re-applied — they are listed
precisely enough to redo.

## What is in the document

| Tab | gid | Rows | Covers | Coordinates |
|---|---|---|---|---|
| Generic Solo OrcTroll Route | 1385640031 | 3,127 | Horde solo 1-60, 68 chapters, 30 zones | yes, ~95% |
| 5 Man Dungeon Route (final) | 1953536056 | 2,464 | Horde 5-man 1-60, 37 sections | **none** |
| Tirisfal Starting | 1467675920 | 210 | Undead opening 1-14 | **none** |

The solo tab is the substantial one and is in good shape: 730 accepts, 818 turn-ins,
492 completes, 2,411 typed rows, a quest-log count that reconciles to within 4 rows across
2,700 rows, and a level column that moves backwards exactly once. It is a real route, not
a sketch. The problems below are mostly edges, with two exceptions (F1 and F2) that would
have stopped the engine dead.

---

## Findings that block a step engine

### F1 — 50 turn-ins have no pickup row anywhere in the sheet *(repaired)*

Chain quests that the NPC hands you the instant you turn in the previous link are recorded
only as a `TURN IN`. A human reading the sheet infers the accept; `Core:Reconcile()` cannot,
and parks on a `turnin` step for a quest that is not in the log and never will be.

Examples: `The Torch of Retribution #1/#2`, `The Name of the Beast #1/#2/#3`,
`This Is Going to Be Hard #1/#2/#3`, the whole Searing Gorge block (rows 1903-1919), the
whole Revantusk block (rows 2097-2111).

Repaired by inserting a synthetic `accept` step immediately before each such turn-in,
noted as such in the step. This is safe in both directions: an `accept` step is satisfied
when the quest is in the log *or* already completed, so if the chain link really was picked
up elsewhere, the synthetic step auto-advances and costs nothing.

### F2 — 194 quest names carry a `#N` suffix that does not exist in game *(repaired)*

`Arugal's Folly #1` … `#4`, `Samophlange #1` … `#4`, `The Crown of Will #1` … `#3`, and 190
more. 478 rows are affected.

Two distinct failures come out of this:

1. The literal string never matches a live quest log, so `Core.ResolveQuest` never resolves
   and every one of those 478 steps is manual-advance-only.
2. Strip the suffix naively and it gets *worse*, not better. `Compat:GetQuestIDByName` is
   cache-first and the cache is keyed by name, so all four links of `Arugal's Folly` resolve
   to link 1's ID. Link 1 is flagged complete by the time you reach link 2, so links 2-4 all
   read as already done and `Reconcile()` walks straight through the entire chain without you
   playing any of it. A silent, unrecoverable 4-step skip.

Repaired in two halves. The generator emits `questName = "Arugal's Folly"` plus
`ambiguous = true`, and keeps the readable label in `name` (`"Arugal's Folly (part 2)"`).
`Core.ResolveQuest` routes ambiguous steps to the new `Compat:GetQuestIDByNameLive`, which
reads the live quest log only — never the cache, and never writes to it. The live log holds
exactly the link you are on, which is the only thing that can tell them apart.

### F3 — 11 rows labelled `SKIP` are actually accepts *(repaired)*

`SKIP` in the accept column normally means "there is a quest here, don't take it", and those
rows carry no quest-log delta. Eleven rows say `SKIP` but carry `+1`, and all eleven are
completed and turned in later in the sheet: `Counterattack!` (row 430), `Arachnophobia`,
`Earthen Arise`, `Humbert's Sword`, `Arikara`, `Hypercapacitor Gizmo`, and five more.

The `+1` is the reliable signal, and it disambiguates cleanly: of 167 `SKIP` rows, the 11
with a delta are all turned in later; of the 156 without, none are turned in *on that pass*.
The generator treats `SKIP` + `+1` as `ACCEPT`.

### F4 — the sheet's level column must not become `step.minLevel` *(repaired)*

`SheetImport.lua:271` currently sets `minLevel = level` from the `Lvl` column. `StepApplies()`
uses `minLevel` to **hide** a step. Tagging every step with the route's intended pacing means
an under-levelled character has steps silently removed and the route runs away from them —
precisely backwards from what the column is for.

The generated routes use a new display-only field, `atLevel`. `UI.lua` renders it, and warns
when you are behind the route's pace instead of hiding the step. `SheetImport.lua` still has
the original behaviour; fixing it there is a separate, small change.

### F5 — uiMapIDs cannot be baked into route data *(repaired)*

Steps need a map to place a waypoint on. `Routes/Durotar.lua` hardcodes Classic Era numbers
(`1411`, `1413`, `1454`). uiMapIDs are per-flavor data, and this addon ships to three clients;
a literal baked into 2,700 steps is an unverifiable guess about at least two of them.

The generated routes carry `zone = "Durotar"` instead. `Compat:MapID()` builds a
name → uiMapID index from the client's own map tree at runtime
(`C_Map.GetMapChildrenInfo(946, nil, true)`), with the Classic Era table kept only as a
fallback for a client where that walk comes back empty. `Data:StepMap(step)` resolves it, and
`Arrow.lua`, `Data:SetWaypoint` and `Data:ValidateRoute` all go through it. `step.map` still
works for hand-authored steps that want to pin a specific map.

---

## Data-quality findings in the solo tab

### F6 — the `Path Order` column is 102/104 `#REF!`

Column Z is almost entirely broken references. So is the map-legend block to its right
(columns AF-AZ, ~30 more `#REF!`). **No step-data column is affected** — `Quest`, `Type`,
`Zone`, `Location`, `Log`, `Lvl` and `Coord` are all clean.

The practical consequence: whatever within-chapter ordering hint `Path Order` used to carry
is gone, and row order is the only ordering information left in the sheet. The conversion
takes row order as authoritative, which is what a human reading the sheet does anyway.

### F7 — 124 steps have no usable coordinate

130 rows say so deliberately (`Multiple` ×67, `Patrol` ×43, `Zonewide` ×20) and the conversion
turns each into a note explaining why there is no arrow. The rest are genuine gaps, and they
cluster: `TRAINER` 28 of 29 rows blank, `NOTE` 37 of 44, `COMPLETE` 45 of 492.

The trainer gap is the one worth filling by hand — "go train" with no arrow is the step most
likely to send someone to the wrong city.

### F8 — 5 malformed coordinates *(repaired)*

`(33.0, 68.)` ×3 and `(35.0, 31.)` have a trailing decimal point; `47.8. 39.8` has a period
where the comma belongs, which the existing `SheetImport` coordinate parser rejects outright,
silently dropping the coordinate. The generator repairs all five.

### F9 — 4 quest-log count breaks

Rows 1608/1610 (`Threat From the Sea #3`, `Continued Threat`) and rows 1788/1789
(`Hearth to Camp Mojache`, `The Battle Plans`). Over 2,700 rows with a running ±1 delta, four
breaks is a very low error rate, but the counts are carried into the route as `logCount` and
shown in the tracker, so these four will read a quest out of step. Not auto-fixable — someone
has to decide which of the two numbers is right.

### F10 — one level regression

Row 2319, chapter 55 (`The Western Pylon`): the `Lvl` column goes 53 → 52.

### F11 — a case-variant duplicate

`A Recipe for Death #1` and `A Recipe For Death #1` both appear. Harmless after conversion
(name resolution is case-insensitive) but it means the sheet has two rows it thinks are
different quests.

### F12 — chapter 59 has no title

Row 2469 reads just `Chapter 59`. The generator names it after its dominant zone.

### F13 — two junk values in the `Zone` column

`Capital City` (2 rows, means Undercity) and `Chapter 3 End: Quest log audit` (1 row, a
chapter marker that landed in the wrong column). Both handled in conversion.

### F14 — 236 skip rows are guidance, not steps *(converted)*

156 `SKIP` and 80 `TEMP SKIP` rows tell you what *not* to pick up — genuinely useful when you
are standing in front of an NPC with an exclamation mark. Emitting one step each would add 236
manual clicks, so consecutive skips at the same location are merged: 236 rows became 195 note
steps.

---

## Findings in the 5-man dungeon tab

This tab is noticeably rougher than the solo tab. It is still a complete, usable route, but it
carries less data per step and more mess per column.

- **D1 — no coordinates at all.** 2,113 quest rows, zero coordinates. Steps in the converted
  route name a zone and a location and nothing else; the arrow stays blank. This is the single
  biggest gap in the document and the obvious thing to fill in by hand.
- **D2 — 15 misspelled or variant zone names**, plus non-zones in the zone column:
  `Ogrimmar`, `Thunderbluff`, `Trisfall`, `Trisfal`, `Tirisfal`, `Hinterlands`, `Tanris`,
  `Ungoro Crater`, `The Badlands`, `Eastern Plagueland`, `EasternPlaguelands`, and the
  literals `-`, `Clear:15-20min`, `Clear 20-30 Min`, `Shared to you outside of RFC Hopefully`.
  Dungeon shorthand (`BRD`, `BRM`, `SM`, `BFD`, `Gnomergon`, `RFC`) is also in that column.
  All normalised during conversion; the aliases live in `Compat.lua`'s `ZONE_ALIASES`.
- **D3 — prose leaked into the section-name column.** Section 34's name is the fragment
  `if only one skip it. "`. The generator rejects section names that read as prose and falls
  back to the segment label.
- **D4 — segment numbering is inconsistent.** Segment 1 and Segment 5 are absent, `Segment 11`
  appears twice with two different level bands (34-36 and 36-36), and there is a level gap
  between Segment 11 (…-36) and Segment 12 (42-…). Six levels of the route have no segment
  label at all.
- **D5 — three sections carry 215, 232 and 437 rows**, which means section headers are simply
  missing across whole legs. The conversion starts a new section on a segment change as well
  as a section change, which breaks those blocks into 48 usable sections.
- **D6 — XP/minute farm tables are interleaved with steps.** 22 rows have no action and put
  the clear time in the zone column and `Xppm: 640 - 426` in the location column. Good data in
  the wrong shape; converted into per-section "Farm rates" notes rather than dropped.
- **D7 — 9 turn-ins with no pickup row**, same class of problem as F1, same repair.
- **D8 — free text in the action column.** The `ACCEPT` column holds 133 distinct values where
  it should hold an enum; most are sentences. Converted to note steps.

---

## Findings in the Tirisfal Starting tab

- **T1 — no coordinates**, same as the dungeon tab.
- **T2 — three unfilled placeholders.** Rows 82, 130 and 191 read `You must be at least
  XXXX/5400 into Level 8`, `XXXX/8800 into Level 11`, `XXXX/11400 into level 13`. The XP
  thresholds these steps exist to state were never filled in. Carried through verbatim, since
  inventing numbers would be worse than showing the gap.
- **T3 — a quest-name mismatch.** Row 120 accepts `Delivery to Silverpine`; row 144 turns in
  `Delivery to Silverpine Forest`. One of the two is wrong.
- **T4 — chain links are distinguished only by a free-text note.** `A New Plague` appears four
  times, `At War with the Scarlet Crusade` four times, `Arugal's Folly` three, with the link
  identified in the notes column (`"Part 2, for killing murlocs"`). This is the same hazard as
  F2 but without the `#N` marker to detect it, so those steps are **not** flagged `ambiguous`
  and will mis-resolve the way F2 describes. Fixing it means tagging the links by hand in
  `Routes/Horde/TirisfalStart.lua`; the note text says which is which.

---

## What was generated

| Route | Files | Steps | Levels |
|---|---|---|---|
| `ONSLAUGHT Solo Horde 1-60 (Orc/Troll)` | `Routes/Horde/Solo/` — 28 zone files + Init + Register | 2,781 | 1-60 |
| `ONSLAUGHT 5-Man Horde 1-60 (Orc/Troll)` | `Routes/Horde/Dungeon/` — 10 part files + Init + Register | 2,270 | 1-60 |
| `Tirisfal Start (Undead) 1-14` | `Routes/Horde/TirisfalStart.lua` | 209 | 1-14 |

The solo route is stored one file per zone because it visits several zones two or three times
and a single 2,781-step file is not editable. Each file contributes its legs via
`ns.SoloLeg(order, zone, steps)`; `Register.lua` sorts by `order` and concatenates, so `.toc`
order does not affect route order. The dungeon route uses the same pattern with
`ns.DungeonPart(order, steps)`.

The dungeon route is registered with `group = true`, a new field `Core:AutoSelectRoute()`
now ranks below solo routes — it is a real route, but never the right guess for a character
the addon knows nothing about.

## Engine changes these routes required

| File | Change |
|---|---|
| `Compat.lua` | `Compat:MapID(zone)` — runtime zone-name → uiMapID index, Classic table as fallback, alias table for the sheets' spellings |
| `Compat.lua` | `Compat:GetQuestIDByNameLive(name)` — live-log-only resolution for ambiguous chain names (F2) |
| `Compat.lua` | quest-log name index, rebuilt at most once per quest event — a 2,800-step route asks for name resolution thousands of times per refresh |
| `Core.lua` | `ResolveQuest` honours `step.ambiguous` |
| `Core.lua` | `AutoSelectRoute` ranks `route.group` below solo routes |
| `Core.lua` | invalidates the quest-log index on quest events |
| `Data.lua` | `Data:StepMap(step)`; used by `SetWaypoint` and `ValidateRoute` |
| `Arrow.lua` | bearing uses `Data:StepMap` instead of `step.map` |
| `UI.lua` | renders `step.atLevel`, warning when you are behind the route's pace |
| `Progress.lua` | `Refresh()` bails when the window is hidden — it walks the whole route, and `Reconcile` calls it on every quest event |

## Still to do, by hand

1. **Run `/tuff verify`** on all three routes in game. Nothing here has been executed — there
   is no headless Lua runner in this repo, so the generated files have been checked
   structurally (quote balance, brace balance, field shape across all 41 files) and no further.
2. **Coordinates for the dungeon and Tirisfal routes** (D1, T1). Both are usable without them
   and much better with them.
3. **Trainer-step coordinates in the solo route** (F7) — 28 of 29 are blank.
4. **The four quest-log count breaks** (F9) and the one level regression (F10) need someone to
   decide which number is right.
5. **Tag the Tirisfal chain links `ambiguous`** (T4). Until that is done those steps can
   mis-resolve the way F2 describes.
6. ~~**`SheetImport.lua` still has the F4 bug**~~ **Fixed.** It now writes the sheet's level
   into `atLevel`, same as the generated routes, instead of `minLevel`.
7. **`Routes/Durotar.lua` is still `sample = true` with unverified quest IDs**, and now
   overlaps the real Durotar leg. It is never auto-selected, so it is harmless, but it is a
   candidate for deletion once the generated route has been played.
