# Plan 10: Forever dungeons: mandatory runs, entry points, and later grind

Follows `plans/09-forever-dungeons-routing-research.md` (section 6 covers the
first Ruins of Lordaeron pass). Written 2026-09-22 after the user tested that
pass in-game ("tested works") and asked for four things:

1. Make the Forever dungeons mandatory. The first-clear bonus plus the quest
   XP should make later areas like Desolace less grindy. Review and audit the
   best way to implement this fully, Horde only.
2. Add a warning that the dungeon is Horde-first, but implement it for the
   Alliance as well.
3. Add an entry point. Undead finish TirisfalStart at level 14, right next to
   the dungeon.
4. Reuse the Forever-only mechanism for the other new dungeons that have data
   now (Hall of Thanes).

Items 2-4 and the "mandatory" half of item 1 are implemented in this pass
(phase 0). The rest of item 1 is phases 1-3. They're a plan only, because they
depend on numbers nobody has measured yet.

The plan was audited 2026-09-22 by the `plan-auditor` agent. Its findings are
folded in below: the XP math is corrected, the first draft's `notForever` cuts
are dropped, and the Horde coverage gaps plus a verification checklist are
added.

---

## Research moratorium (2026-09-26): no more secondary-source passes on these two dungeons

Three plans in a row (`plans/09-forever-dungeons-routing-research.md`,
this plan, `plans/11-wowhead-dungeon-quest-crosscheck.md`) have each
cross-checked Ruins of Lordaeron and Hall of Thanes against a different
beta-content website (foreverchanges.pro, then a Wowhead community guide).
Each pass found real value the first time (foreverchanges.pro gave the
quest list; the Wowhead guide added coordinates and caught two real
conflicts), but the return has been shrinking, and both sources carry the
same disclaimer: this is beta data, self-described as incomplete, and
neither one is a substitute for this repo's own `/tuff capture` workflow.
A fourth pass reading a third website would be spending research effort on
data that only becomes trustworthy once captured live anyway — see
`CLAUDE.md`/`README.md`'s existing rule that a route's own coordinates are
always the source of truth, external sources are enrichment only.

**Decision: no further web research on Ruins of Lordaeron or Hall of
Thanes.** The only way any of the open items below get resolved from here
is the in-game capture session Phase 1 already calls for. If a genuinely
new primary source shows up (e.g. official patch notes at GA, not another
fan-run guide site), that's a judgment call for whoever's holding this
plan then, not a standing invitation to keep cross-referencing fan wikis
in the meantime.

**Consolidated in-game checklist** — every open question from plans 09, 10,
and 11 that secondary sources could not resolve, gathered in one place so
a single play session (see Phase 1 below) closes all of them instead of
being spread across three documents:

| # | Quest / step | Open question | Source of the gap |
|---|---|---|---|
| 1 | Old Ironforge Incursion (Hall of Thanes) | Giver location (Earthseer Farsen, Dun Morogh) — currently a note only, on no route's path | Plan 09 §6, plan 10 R-d |
| 2 | Captain Truman | Location unknown | Plan 10 R-d |
| 3 | All 4 Hall of Thanes quests | Turn-in NPC/location unknown | Plan 10 R-d |
| 4 | Abominable Creatures (Ruins of Lordaeron) | Turn-in NPC/location unknown | Plan 10 R-d |
| 5 | Unending Torment | Follow-up chain length/content unknown | Plan 10 R-d |
| 6 | The Wrath of Rath'mael | XP value not listed anywhere; coordinate is `approx = true`, borrowed from an unrelated step | Plan 10 R-d |
| 7 | A Frightened Request | Moved to Undercity/Tabitha Heartweaver on a second-source guide's say-so (plan 11 R2) — never confirmed against the live client | Plan 11 R2 |
| 8 | Crest of Lordaeron | Unresolved conflict: is it a pre-dungeon NPC accept (current: Oran Snakewrithe, Undercity) or picked up inside the dungeon with no accept step at all? | Plan 11 R2 |
| 9 | Light's Justice, The New Plague | Coordinates added from the Wowhead guide (plan 11 R1), never confirmed the arrow actually lands there | Plan 11 R1 |
| 10 | All 10 Ruins of Lordaeron quests + 4 Hall of Thanes quests | No numeric `quest` ID yet — everything resolves by name only | Plan 10 Phase 1 item 3 |
| 11 | First-clear bonus, Forever's XP scale | Not documented on either source site; has to be measured live | Plan 10, "What we don't know" |

Phase 1 below already covers items 10-11 and the capture mechanics for
1-9; this table just makes sure none of the 9 quest-specific loose threads
gets silently dropped once the session actually happens.

- **Impact:** none — this section only redirects future effort, no code or
  route data changes.
- **Performance:** n/a.
- **Dev time:** ~0 to adopt; it saves time by preventing a fourth research
  pass (each of the first three ran 30-90+ min of source-reading) that
  would resolve nothing beyond what a live capture session settles anyway.

---

## What we don't know, and why it gates everything after phase 0

- **The first-clear bonus isn't documented anywhere.** foreverchanges.pro's
  `/dungeons` page and both populated dungeon pages were checked 2026-09-22.
  None mentions a first-clear reward or any dungeon XP mechanic. Its size
  has to be measured.
- **Forever's XP scale may not be Classic's.** The site lists 8,320 XP for a
  level-22 quest. A normal Classic level-22 quest gives about 1,500-2,000,
  so Forever either rescales quest XP (about 4-5x) or the site's figure means
  something else. Until that's calibrated in-game, every "levels of lead"
  figure below is only a Classic-table estimate.
- **Listed quest XP (Horde Ruins of Lordaeron):** Light's Justice 7,040, The New
  Plague 8,320, Crest of Lordaeron 8,320, A Frightened Request 7,040,
  Unending Torment 5,280. The Wrath of Rath'mael isn't listed. That's about
  36,000 XP plus Rath'mael plus the bonus. Mob XP adds little for Orc/Troll
  at 23: the grey cutoff is 16, the mobs are 15-20, and 5-man XP is split.
- **What that lead is worth, using Classic's table (if Forever doesn't rescale):**
  - at 16 (16,000 + 17,700 to the next two levels): about 2.1 levels;
  - at 23 (29,400 / 31,700): about 1.2 levels;
  - by Desolace at 33-34 (58,600 / 62,800): about 0.6 levels.
- **Being a level or two ahead does not reduce quest XP.** Classic pays full quest
  XP until you're more than 5 levels over the quest, then about 80/60/40/20% at
  +6 to +9, and 10% beyond that.
- **Measure time saved, not levels.** The useful figure is roughly lead XP ÷ XP
  per hour at that point in the route.

## What the engine already does for free, which is most of the user's goal

- **Grind steps auto-skip.** `grind`/`level` steps complete once
  `PlayerLevel() >= targetLevel` (`Core.lua`, `StepOwnConditionDone`). The
  Solo route's only explicit grind steps are Arathi → 40
  (`ArathiHighlands.lua:305`), Tanaris → 49 (`Tanaris.lua:383`) and Blasted
  Lands → 52 (`BlastedLands.lua:253`). A player who's ahead skips them with
  no change.
- **The "grind the gap" prompt disappears.** Desolace has no grind step. What
  makes it feel grindy is arriving under level, when the tracker shows "route
  expects level X, you're Y - grind the gap" (`UI.lua:434-441`). A dungeon
  lead removes that prompt by itself.
- **Desolace is not padded.** Its "Partial progress" notes (`Desolace.lua:109,
  183, 251, 288`) sit on `complete` steps of real quests that are turned in
  later (Kodo Roundup, Claim Rackmore's Treasure). The sheet has already
  pruned its low-value quests: there are 10 "Skip:" notes in that file.

So the default course is **no route cuts**. The lead pays off automatically.

---

## Phase 0: done in this pass

| Change | Impact | Performance | Dev time |
|---|---|---|---|
| `ns.RegisterRoute` drops `forever = true` steps on non-Forever clients (`Core.lua`). This replaces the Solo-only `ns.SoloForeverOnly` helper, which is removed. It's documented in the `Routes/Horde/Durotar.lua` schema header. | Every route goes through it, and route files stay plain literal tables. It would shift `requires` indices off Forever if a route mixed the two, and none does (grepped). | One pass over each route's steps at load, only off Forever. Zero per tick or per event. | ~20 min |
| Solo Chapter 17b made mandatory: "Mandatory: group up" replaces "skip if you can't get a group". | Wording only. The engine already blocks on these steps. | None | ~5 min |
| Solo 17b steps get `races = { "Orc", "Troll" }`. This is a **stopgap**; phase 1.3 removes it. | Name-only quest steps can't detect a completed quest after `/reload` (`Compat:GetQuestIDByName` learns names only from the live log), so an Undead who ran the dungeon in TirisfalStart would get stuck on 17b. Side effect: an Undead who clicked through the Tirisfal block never sees the dungeon, and neither does a Tauren who loads Solo by hand. | None | ~5 min |
| `ambiguous = true` on every Crest of Lordaeron step (the same name on both factions) | Makes it resolve from the live log only, so an account-wide cached ID from the other faction can't be used | None | ~5 min |
| **Undead entry point**: a Forever-only block at the end of `TirisfalStart.lua`. Order: level-16 gate → Brill and Undercity accepts → flight to the Sepulcher for A Frightened Request and back → dungeon → turn-ins → trainer → "To Kalimdor". The gate is **provisional**; see R-a. | `TirisfalStart.lua` only | Data only | ~45 min |
| **Alliance Ruins of Lordaeron** (4 quests given in Stormwind) in Human, Dwarf/Gnome and Night Elf. Accepted at the Stormwind visit that opens "27-29 Wetlands/Hillsbrad", run from Southshore (after the Hunter pet swap, before that section's hearth), turned in at the next Stormwind visit ("29-32 Duskwood"). Carries a "Horde territory (Horde-first dungeon)" warning. | The three RXP-converted files (CC BY-NC-SA). The new blocks are marked as original additions. | Data only | ~1.5 h (three parallel agents, plus review fixes) |
| **Hall of Thanes** (13-18, 4 quests) in the same three files. Human and Dwarf/Gnome run it at their Loch Modan Ironforge pass (~13; Human has a level-13 gate). Night Elf reaches Ironforge first at ~19. That's over the range, but the quests still pay full XP. Old Ironforge Incursion is a note only, because its Dun Morogh giver isn't on any of the three paths. Alliance only, by decision. | The three Alliance files | Data only | included above |

## Phase 1: measure, and capture numeric quest IDs (in-game, needs the user)

1. **Calibrate Forever's XP scale.** Run `/dump UnitXPMax("player")` at two or three
   levels, and write down the XP of one ordinary sheet quest. That settles whether
   the Classic numbers above apply.
2. **Measure each dungeon run.** Record level and XP before and after, and the
   first-clear bonus on its own if the client shows it. Do this for Orc/Troll
   at 23 (Solo 17b) and Undead at 16 (TirisfalStart).
3. **Capture numeric quest IDs** with `/tuff capture` (plan 09 R3) for all 10
   Ruins of Lordaeron quests and the 4 Hall of Thanes quests, and add them as
   `quest = <id>` next to `questName`.
   - `Data:IsQuestComplete(id)` then works across reloads.
   - **The 17b race filter can then go.** 17b becomes a fallback that
     auto-skips for anyone who already ran the dungeon, whatever their race.
   - Capture giver and turn-in coordinates in the same pass, and work through
     the "Consolidated in-game checklist" table in the moratorium section
     above — it's the complete list of what secondary sources couldn't
     settle, so this session is the one place all of it gets resolved.
4. **Record the level at each Solo chapter header** from 18 to 39. The tracker
   already prints it against `atLevel`. That baseline is the sheet's Classic
   pace, not a measured no-dungeon Forever run, so compare the two before
   drawing conclusions.

- **Impact:** measurement, plus a data edit for the IDs and coordinates (5 route
  files) and removing `races` from 20 Solo steps.
- **Performance:** none. Numeric IDs are cheaper than name resolution.
- **Dev time:** the play happens anyway. About 15 min of notes per run, and ~30-45
  min to paste the IDs and coordinates in and drop the filter.

## Phase 2: Horde coverage gaps ("fully implement for Horde")

**Rows 1-2 done in this pass (2026-09-26).** Both ports the same
already-decided Ruins of Lordaeron data from `TirisfalStart.lua`/Solo
Chapter 17b - no new quest names, NPCs, or coordinates were invented, and
anything still unknown at the source (Wowhead-vs-foreverchanges.pro
`Crest of Lordaeron` conflict, `A Frightened Request`'s unconfirmed
turn-in, missing NPC sub-locations) was carried over as the same
`note`/`ambiguous` flags rather than resolved. Row 3 is untouched - it's
still blocked on phase 1's in-game measurement, which hasn't happened.

| Change | Impact | Performance | Dev time |
|---|---|---|---|
| **Tauren (done)**: `TuFFlvls Tauren (1-60)` (`Routes/Horde/Mulgore.lua`) had no dungeon content. It reaches Tirisfal Glades/Undercity via the zeppelin at level 22-24, matching Solo Chapter 17b's level (not TirisfalStart's level-16 gate), so the block was copied from 17b's data rather than TirisfalStart's, inserted mid-"22-24 Hillsbrad" right after the existing Undercity steps and before the Silverpine turn-ins, in this file's own coordinate-bearing flat style. Marked as an original addition, not RXP-sourced. | `Mulgore.lua` only, one contiguous ~80-line insertion; no existing steps edited, no `requires` indices in this file to shift. | Data only; `forever = true` drops the whole block on every non-Forever client at `ns.RegisterRoute` time (`Core.lua`) - zero runtime cost added elsewhere. | ~50 min (read both source blocks, adapt field style, insert, `luac -p` syntax check) |
| **5-man route (done)**: `ONSLAUGHT 5-Man Horde 1-60` already has "Silverpine into Hillsbrad Lap with a Quick SFK (level 21-24)" (`Dungeon/02-MidBarrensLap.lua:590`), reaching Undercity at a matching level with the group already assembled. The same 17b data was inserted before the leg's closing hearth step, in this file's `location`-based (no-coordinate) style. Whole route is already Orc/Troll-only (`Register.lua`), so unlike Solo 17b's own copy, no per-step `races` workaround was needed here. | `Dungeon/02-MidBarrensLap.lua` only, one contiguous ~75-line insertion; no existing steps edited. | Data only, same `forever` gating as above. | ~35 min |
| Undead 16-vs-23 decision (R-a), from phase 1's numbers | `TirisfalStart.lua` (and 17b's filter) | None | ~15 min |

## Phase 3: optional, only if phase 1 shows both a lead and a specific time sink

Default: **no cuts.** Suppose the numbers show that one self-contained quest
(accepted and turned in at the same hub, not a chain link) costs more time
than it's worth for a player who's ahead. Gate that quest with a
**Forever-scoped `skipIfLevel`**: at registration on Forever,
`ns.RegisterRoute` copies a step's `foreverSkipIfLevel` into `skipIfLevel`.
Classic Era is untouched, and the cut applies only to players who really are
ahead, not to everyone on the client.

Guardrails:
- **Never on chain quests.** `skipIfLevel` is checked live in `StepApplies`, so
  cutting an accept leaves its name-only turn-in blocking, and dinging
  between accept and turn-in would skip the turn-in and strand the XP.
- Put the same threshold on the accept and the turn-in of a self-contained
  quest, set to at least `atLevel + 1`.
- Or add an engine rule that `skipIfLevel` doesn't apply while the quest is in
  the log (~15 lines in `StepApplies`, ~30 min), which removes the stranding
  hazard in general.

- **Impact:** ~5 lines in `ns.RegisterRoute`, plus `foreverSkipIfLevel` on
  individually justified steps.
- **Performance:** load-time copy. `skipIfLevel` is already evaluated today.
- **Dev time:** ~15 min for the copy, ~30 min for the optional engine rule, then
  per-quest decisions from data.

*Dropped from the first draft:*
- *A `notForever` flag that cut content by client. It would also cut content
  for Forever players who couldn't get a group, or who clicked through the
  dungeon, recreating the grind the user wants gone.*
- *A `/tuff pace` "lead" readout. It's mostly redundant, because the tracker
  already prints `atLevel` against the player's level on every step.*

## Verification checklist for phase 0

Nothing in this pass has been run in-game yet. The first Ruins of Lordaeron pass
was, and worked.

- [ ] Classic Era: `/reload`, load the Tirisfal and Solo routes, and check that the step
      counts match the previous release (no Forever blocks, Solo 17b absent).
- [ ] Forever, Scourge: TirisfalStart shows the Ruins of Lordaeron block, the
      level-16 step auto-completes at 16, and Solo 17b is hidden.
- [ ] Forever, Orc/Troll: 17b shows at the end of Leg 7.
- [ ] Forever, Alliance: Hall of Thanes and the Ruins of Lordaeron blocks show, and
      Hunters keep their pet through the dungeon.
- [ ] `tools/validate_route.py --no-db` on the changed files. It doesn't know
      `forever`, but it catches syntax and schema slips. It needs Python, which
      isn't on the machine this was written on.

---

## Risks and open questions

- **R-a: the level-16 gate at the end of TirisfalStart is expensive.**
  - **Cost:** going from 14 to 16 is about 27,300 XP of grinding on Classic's
    table, roughly 240 same-level kills, or about 75% of the listed quest XP it
    unlocks.
  - **Knock-on:** the Undead then leave at ~18 into Solo's 15-18 Barrens chapters,
    3 levels ahead, where the lowest quests start crossing the +6 reduction.
  - **In its favour:** running at 16 is worth ~2 levels against ~1.2 at 23, and
    groups are easier to find at the intended level.
  - **Decide from phase 1's numbers:** keep the gate, or send Undead to Solo 17b
    at 23 once the race filter is gone (phase 1.3).
- **R-b: quest log on the Solo side.** The dungeon was placed at the end of Leg 7
  because the log is full at Tarren Mill. The length of Unending Torment's
  follow-up chain is unknown, and the peak there is 19.
- **R-c: Alliance timing.** The Alliance routes reach Hillsbrad at 27-29. That's
  full XP for the level 21-22 quests up to 27 and reduced after. A better
  slot would need surgery on the RXP-converted files. Deferred, since the
  user asked for Horde-first.
- **R-d: the data is beta and provisional.**
  - Givers with no known location: Captain Truman, Tabitha Heartweaver,
    Earthseer Farsen.
  - Turn-in NPCs are unknown for Abominable Creatures and all four Hall of
    Thanes quests. (A Frightened Request's giver/turn-in location was
    corrected to Undercity, Tabitha Heartweaver, from a second source —
    see `plans/11-wowhead-dungeon-quest-crosscheck.md` — still unverified
    in-game.)
  - The Unending Torment chain is unknown.
  - Phase 1's capture replaces these notes with real data.
- **R-e: Pace personal bests.** New section headers change which steps each section
  covers on Forever. Moot there, since SavedVariables don't persist.
- **R-f: `TirisfalStart.lua` still says `levels = { 1, 14 }`.** On Forever it now ends
  around 18. That only affects the display and AutoSelect's tie-break.
