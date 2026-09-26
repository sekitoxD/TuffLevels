# Plan 7: Future improvements for the addon

Source: (a) an in-session research pass on the WoW Forever ruleset (video
"EVERYTHING NEW & Changed in WoW Forever" / hammerdancegaming, cross-referenced
against Wowhead/lfcarry/dving/boostroom/zockify coverage of the same changes, since
the video's own transcript wasn't reachable this session); (b) a repo audit of
`CHANGELOG` entries in `Panel.lua`, route headers, and `Data.lua`/`Compat.lua`/
`Core.lua`/`Arrow.lua`/`Rogue.lua` done to find concrete, already-flagged gaps
rather than invent new ones.

**This is the revised version of this plan.** A `plan-auditor` pass on the first
draft found that several items rested on premises the codebase directly
contradicts, verified below by re-reading the cited code myself before rewriting.
The corrections are substantial enough that this isn't a line-number patch — two
items were dropped as invalid, one moved sections because it reaches the opposite
conclusion of what was originally claimed, and the single largest item was
re-scoped from a 20-minute engine fix to a real route-authoring task. What follows
already reflects the audit; nothing below is the pre-audit content.

Every item carries the impact/performance/dev-time audit the user's standing rule
requires (`Architecture/Ideas-for-architecture.md:1`).

---

## Section A — actionable now, not gated on anything

### A1. Route quality: unresolvable zone references and unverified IDs in the RXP-converted routes

**This supersedes the draft's separate "A1 continent-zone-resolution" and "A2
verify the Alliance/Tauren routes" items — they turned out to be the same
underlying problem, found by the same tool, fixed by the same kind of edit.**

The four RXP-converted routes (`Routes/Alliance/Human.lua`, `DwarfGnome.lua`,
`NightElf.lua`, `Routes/Horde/Mulgore.lua`) are explicitly flagged in the v1.6.0
changelog (`Panel.lua:28-29`) as "sample routes (unverified IDs) until run through
`/tuff verify` and played," and `Routes/Horde/Mulgore.lua:40-45`'s own header
flags "about 24 steps" using a continent-level zone name (`"Kalimdor"` /
`"Eastern Kingdoms"`) that `Compat:MapID` can't resolve.

**What the original draft got wrong, and why it matters:**

- The "~24 steps" figure undercounts by roughly 5x: counting `path = { ... }`
  waypoints (which `Data:ValidateRoute` checks separately at `Data.lua:240-252`),
  Mulgore alone has 120 occurrences (85 `"Kalimdor"`, 35 `"Eastern Kingdoms"`)
  across 34 step lines. `Routes/Horde/Mulgore.lua:40` and `Panel.lua:29` both
  understate this and should be corrected as part of the fix, not left standing.
- **Resolving the zone name in `Compat.lua` would not fix the symptom.** Even if
  `Compat:MapID("kalimdor")` returned a real uiMapID, `Arrow.lua:57`
  (`if targetMap and targetMap ~= mapID then return nil, nil, true end`) compares
  it against `C_Map.GetBestMapForUnit("player")`, which always returns a **zone**
  map, never a continent map — so a continent-level `targetMap` can never equal
  the player's current zone map, and `Arrow:Update` renders a dead
  "Travel to Kalimdor" arrow with no distance regardless. The `travel`-type
  auto-advance check (`Core.lua:623-625`) has the identical exact-map-equality
  requirement and would stay permanently un-completable the same way. A
  `Compat.lua`-only fix would make `/tuff verify` and
  `tools/validate_route.py --no-db` report clean while the in-game arrow and
  auto-advance for these steps stay broken — worse than the current state,
  because the diagnostic that currently flags the problem would go silent.
- **The actual fix is re-authoring each flagged step** with the zone the player
  is actually standing in when that step is current, and zone-local coordinates
  for it (e.g. `Routes/Horde/Mulgore.lua:592`'s
  `zone = "Kalimdor", x = 56.81, y = 45.47` for "Enter Orgrimmar through the
  western entrance" should be `zone = "Durotar"` with Durotar-local coordinates
  for that entrance). That's a data edit per occurrence, not a one-time engine
  change — sized like route authoring, not like a bugfix.
- The same class of "has coords but no map" failure shows up under dungeon/
  instance names across `Routes/` (Blackrock Depths, Sunken Temple, Maraudon,
  Gnomeregan, Blackrock Mountain, Scarlet Monastery, Ragefire Chasm, Blackfathom
  Deeps — dozens of occurrences total). Whether each of those is the same
  "continent-shaped" bug or something else (a genuinely missing zone entry, or a
  legitimately different case) isn't known yet — they should be triaged in the
  same pass rather than assumed identical to the Kalimdor/Eastern Kingdoms case.

**Recommended approach:**

1. Run `tools/validate_route.py --no-db` (no database needed, matches
   `CLAUDE.md`'s list of route-workflow tools that don't require it) against all
   four RXP-converted routes to get a complete, current list of every unresolved
   zone reference and structural problem. This step is mechanical and
   objective-answer — a good `verifier`-agent task, run via its `Bash` access,
   rather than `/tuff verify` (which needs `Core.active` set from inside a
   running client with a matching-race character loaded, per `Core.lua:777-778`
   and `Core:AutoSelectRoute`'s faction/race filter at `Core.lua:443-460` —
   not something a subagent can drive).
2. Triage each flagged line: continent names get re-authored to zone-local
   references per the pattern above; instance/dungeon names get checked
   individually since the right fix may differ per case.
3. In-game playtest each of the four routes end-to-end. This step needs one
   character per route's race (`Core:AutoSelectRoute` filters by faction+race),
   so it's a real, non-parallelizable time cost, not a quick pass — this is the
   only way to catch wrong-but-resolvable coordinates or wrong quest IDs that
   the validator can't see.

- **Impact:** `Routes/Alliance/*.lua` and `Routes/Horde/Mulgore.lua` data only.
  No engine change is being proposed for the zone-resolution part specifically
  *because* an engine-only fix was shown above to be a false fix — this is worth
  stating explicitly so a future session doesn't independently reach for the
  same "add a fallback map ID" shortcut that this audit ruled out. `Compat:MapID`
  has exactly one caller (`Data.lua:269`), but its output feeds four consumers
  (`Arrow.lua`'s bearing calc, `Core.lua`'s travel-completion check, every
  step-change waypoint set in `Data:SetWaypoint` at `Data.lua:351-387`, and
  `Data:ValidateRoute`) — so any future temptation to patch `Compat.lua` instead
  of the route data should account for all four before assuming it's safe.
- **Performance:** the validator pass and the playtest are both one-shot,
  off-session activities — no runtime cost either way. (Note for anyone still
  tempted by a hardcoded-fallback-table approach: `Compat.lua:434-435`
  documents `CLASSIC_MAP_IDS` as a Classic-Era-only fallback, and Kalimdor/
  Eastern Kingdoms are different IDs on Mainline/Forever — a Classic-only ID
  fed into `Data:SetWaypoint` on Forever would throw, and `Arrow.lua`'s bearing
  calc runs at roughly 20 Hz per `Arrow.lua:163-168`, so a throwing call on that
  path would exhaust `Compat:Guard`'s 20-error-per-session budget
  (`Compat.lua:616-628`) in about a second, silently killing waypoints and the
  arrow for the rest of that session. This is a reason the fallback-table
  approach was rejected, not a live risk in the recommended approach above.)
- **Dev time:** the validator pass is ~15 min total (mechanical, delegatable).
  Re-authoring the flagged zone/coordinate issues is the real cost and scales
  with how many distinct locations turn out to need it — budget at least a
  couple of hours across the four files, not the 20-30 minutes the original
  draft estimated for what looked like a one-line `Compat.lua` change. The
  in-game playtest is open-ended (however long it takes to level each route
  once) and should be treated as ongoing, same as any new route's shakeout
  period.

### A2. README's Forever quest-database description is stale in three places

`README.md:31` says Forever's quest database is "none exists." `CLAUDE.md`'s own
client table has the more recent, more accurate finding: "no built-in quest DB,
but a manually-installed Questie works (confirmed 2026-09-20)." Two more spots
carry the same staleness and need matching, not identical, edits:

- `README.md:36` — "Optional: **QuestieDB** (Classic Era only)" is now wrong outright.
- `README.md:56` — "**There is no quest database for Forever.** Questie covers
  Classic content only…" needs a *partial* correction: the first sentence is
  stale, but the second half is still true today (a manually-installed Questie's
  coverage of Forever-*exclusive* content, as opposed to the Classic content it
  shares with Forever, is unconfirmed — see C1 below). A blanket find-and-replace
  across all three spots would overcorrect the third one.

- **Impact:** `README.md` only, three spots, one requiring judgment rather than a
  mechanical replace.
- **Performance:** n/a — documentation.
- **Dev time:** ~15 min.

### A3. Rogue.lua's hardcoded tables and Forever's SavedVariables bug can silently corrupt training data

**This replaces the draft's "C5," which reached the opposite conclusion after
looking at only one part of the file.** `Rogue.lua:6-16`'s header is correct that
ability *ranks* aren't hardcoded — they're recorded from what the client reports
via `ScanSpellbook`. But the file also contains three hand-authored tables that
are exactly the kind of thing a talent rework can desync:

- `Rogue.seeded` (`Rogue.lua:36-51`) — a hardcoded level-to-milestone list,
  printed on every `PLAYER_LEVEL_UP` (`Rogue.lua:525-533`). It has already needed
  one Forever-specific patch in place (a comment marks one entry "Gone in
  Forever, replaced by Hack and Slash"), which is direct evidence this table
  needs re-verification against Forever specifically, not just at initial
  authoring time.
- `Rogue.upgrades` (`Rogue.lua:187...`) — level-keyed item advice, also printed
  on level-up (`Rogue.lua:534-539`).
- `Rogue.trainingNote` (`Rogue.lua:60-71`) — an explicit train/skip list,
  self-described in its own comment as "not independently verified."

Separately, and more concerning: the client-sourced half of the file doesn't
survive Forever's known SavedVariables bug either. `Rogue:Record` persists into
`TuFFlevelsDB` via `Compat:InitSavedVar` (`Rogue.lua:77-84`) — the same table
`CLAUDE.md` already documents as never restoring on Forever login/reload. Because
`ScanSpellbook` re-stamps *every already-known* ability with the player's
**current** level on each login (`Rogue.lua:551-559`), a Forever character's
"learned at level X" data gets silently overwritten with the wrong level on every
login/reload, not just lost — which is worse than the addon's other
Forever-SavedVariables cases, which at least fail by resetting to a known default
rather than writing a plausible-looking wrong value.

- **Impact:** `Rogue.lua` only. The seeded/upgrades/trainingNote tables need a
  content re-check against live Forever data (no code change). The
  re-stamping-on-login issue needs actual code: likely having `Rogue:Record`
  skip abilities that were already known before this session's scan (so only a
  level-up that happens *during* the current session updates the recorded
  level), rather than treating every login's spellbook scan as fresh data — but
  this needs to be verified against the actual `ScanSpellbook` logic before
  committing to that shape, not designed blind here.
- **Performance:** none — `ScanSpellbook` already runs at login/level-up
  frequency, not per-frame; a "skip already-known" guard is a cheap table check
  added to an existing one-shot call.
- **Dev time:** ~30 min to re-verify the three hardcoded tables against current
  Forever data; ~1 hour to investigate and fix the re-stamping issue once
  `ScanSpellbook`'s exact logic is read in full (not done as part of this
  planning pass — this item scopes the investigation, it doesn't presume the fix).

---

## Section B — route-authoring backlog (data, not engine work)

### B1. Hand-picked class-specific detours exist in exactly one place; a note on what was ruled out

The draft originally claimed the Durotar Rogue chain was "the first use of the
step-level `class` filter" and proposed extending the pattern to other classes as
a small, cheap backlog item. **That framing was wrong and is corrected here, not
just relocated:** the `class` filter is already used roughly 5,260 times across
the RXP-converted routes (890 on Rogue steps alone, down through 244 on Shaman) —
inherited automatically from RXPGuides' own class-conditional content during
conversion, not something deliberately hand-picked by this project.

The real, much narrower gap: **deliberately hand-authored** class-specific
content — the kind where someone researched a specific class-only quest chain and
wrote it in on purpose — exists in exactly one place:
`Routes/Horde/Solo/Durotar.lua:74-110` (not `Routes/Horde/Durotar.lua`, which the
draft and `Panel.lua:30`'s changelog text both cite incorrectly and which
contains no Rogue-specific content at all — that changelog line should be
corrected alongside README's, per A2's pattern, next time the changelog is
touched).

One hidden constraint worth recording before this is picked up again:
`StepApplies` (`Core.lua:155-181`) compares `step.class` as a single scalar
value, unlike `step.races` which is a list (`Core.lua:156-163`, roughly). A
detour meant to apply to two classes at once needs either duplicated steps or a
small engine change to accept a list — not assumed to be "free" the way the
draft implied.

- **Impact:** future hand-authored chains touch existing route files only,
  additive steps, no new files. The scalar-vs-list constraint above is the one
  thing that *would* need an engine change (`Core.lua`), and only if a
  shared-by-two-classes detour is ever wanted.
- **Performance:** none — `StepApplies` already runs on every reconcile pass at
  the current step count; a few more tagged steps is immeasurable.
- **Dev time:** small per chain (~30-60 min) once a class-specific quest is
  researched, same estimate as before — the correction here is entirely about
  what already exists, not about the cost of adding more.

**Dropped from the draft, recorded so it isn't proposed again:** the original
"B1" suggested giving Alliance/Tauren a per-zone `Solo/` folder structure like
Horde's. This was based on a misreading of what `Routes/Horde/Solo/` actually is:
`Register.lua:19-27` shows its 28 zone files are stitched into **one** route
(`"ONSLAUGHT Solo Horde 1-60 (Orc/Troll)"`), not 28 independent per-zone routes —
it's a file-splitting convention for maintainability on a single long route, and
Alliance/Tauren already have the equivalent (a full 1-60 path, just in one file
instead of split across many). There's no real content gap here to schedule.

---

## Section C — WoW Forever ruleset: research and measurement, testable now on beta

**The draft's framing that all of this was "gated until Nov 4, 2026 GA" was
wrong for most of it and is dropped.** The beta is live, this repo already
targets it (`_classic_beta_`), and `CLAUDE.md` records an in-game Forever
confirmation from 2026-09-20 — so anything measurable on the current beta build
should be measured now, not deferred to GA. The one genuinely date-sensitive part
is route *authoring* for Forever-exclusive zones, since their content could still
change before launch; the *research and measurement* items below don't have that
problem.

### C1. Confirm QuestieDB coverage of Forever-exclusive zones/quests

Actionable today, on the beta the user already runs. Spot-check a handful of
known Forever-exclusive quest IDs (Riverglades, Krol'dok Stronghold, Alcaz
Prison content) against the manually-installed Questie build `CLAUDE.md`
confirms works. If coverage is missing, Forever-exclusive route authoring falls
back to the manual-Wowhead-lookup workflow `plans/03-*.md` already documents —
not a blocker, just the expected path either way.

- **Impact:** research only, no code.
- **Performance:** n/a.
- **Dev time:** ~30-60 min.

### C2. Rested-XP-via-campfire: convention question, testable now if live on beta

Forever adds outdoor-campfire rested XP and a crafted-food XP bonus. First step
is confirming this is actually live on the current beta build (not assumed from
the video/search research). If it is, this likely needs only a `note`-step
convention (the same free-text mechanism already used for hearth timing), not a
new step type — unless testing shows a case for detecting an active campfire
buff programmatically, which would be new, separately-sized scope, not bundled
into the convention question.

- **Impact:** if kept as a `note` convention: route files only, zero engine
  change.
- **Performance:** `note` steps are free; not designing the speculative
  buff-tracker version here.
- **Dev time:** ~0 for the convention itself; confirming it's live on beta first
  is a quick in-game check.

### C3. Dungeon-first-clear XP reweighting: start measuring now, don't wait for GA

Forever raises first-run dungeon-quest XP and lowers dungeon mob-kill XP.
`Routes/Horde/Dungeon/` (`01-VALLEYOFTRIALS.lua` through `10-BRDPrisonPrepFarm.lua`)
is tuned against Classic's numbers, and that pacing assumption is worth
re-checking under Forever's curve — but since the beta is playable now, this can
be measured today using `Pace.lua`'s existing per-section timing / XP-per-hour
tracking (already built for exactly this comparison), rather than waiting for a
GA that might not even change these specific numbers.

- **Impact:** would touch `Routes/Horde/Dungeon/*.lua` pacing notes/ordering
  only, if anything — possibly no change needed until actually measured.
- **Performance:** n/a — pacing is authored data.
- **Dev time:** depends on how many dungeon laps get run for comparison data;
  start whenever someone is playing the beta rather than scheduling it.

### C4. Professions (Waylaid Supplies, campsite recipes) are new scope, not a gap — no date attached either way

TuFFlevels doesn't track professions at all today, so Forever's profession
rework has no existing feature to extend. This is a scope decision, not
something blocked on a date: if it's ever wanted, it needs its own plan
(new module, new persistence, new UI surface), not a line item here.

- **Impact/Performance/Dev time:** n/a — not being built; recorded only so it
  isn't mistaken for a small addition later.

---

## Recommended order of work

1. **A2** (README fix) — trivial, do first.
2. **A1** (route-quality pass on the four RXP-converted routes) — the largest
   real quality risk in the current route set; start the mechanical validator
   pass soon, treat the re-authoring and playtest as the bulk of the ongoing work.
3. **A3** (Rogue.lua Forever data-corruption investigation) — a live bug on the
   beta the user already runs, worth investigating before it's forgotten, not
   large once scoped.
4. **B1** (hand-authored class detours) — opportunistic backlog, no urgency.
5. **C1-C3** — can start any time on the current beta; not blocked on each other
   or on GA. **C4** is a standalone scope question with no timeline.

## Status

**A2 — done (2026-09-25).** All three README spots corrected.

**A1 — partially done (2026-09-25).** `tools/validate_route.py --no-db` still
couldn't be run (no Python on this machine, same gap plan 10 hit) so the
mechanical enumeration was done by grep instead, cross-checked against
Wowhead/Warcraft Tavern for the real zone + coordinate of each dungeon
entrance. `Routes/Horde/Mulgore.lua` is fixed: all but two of its ~34
continent-tagged steps (plus 100+ path waypoints) now carry a real zone
(Durotar, The Barrens, Ashenvale, Moonglade, Stranglethorn Vale, Westfall,
Tirisfal Glades, Badlands); several are `approx = true` pending an in-game
`/tuff capture` pass, and the Gnomeregan-transponder interior steps are left
an honest unconfirmed gap on purpose (the transponder teleports straight
inside; there's no outdoor entrance to capture a coordinate for). **Not yet
done:** `Routes/Alliance/Human.lua`, `DwarfGnome.lua`, and `NightElf.lua`
haven't been touched this pass — grep found no `"Kalimdor"`/`"Eastern
Kingdoms"` literal-zone hits in them (unlike Mulgore), so if they have the
same class of bug it's under different zone names not yet identified; that
triage and the in-game playtest of all four routes are still open. Treat
this as the mechanical/data half of A1 done for one of four files, not the
whole item closed.

**A3 — mostly resolved already, discovered during this pass (2026-09-25).**
The "more concerning" half of A3 — `Rogue:ScanSpellbook` re-stamping
already-known abilities with the wrong level on every Forever login — turns
out to already be fixed, in commit `ea62be9` ("Rogue: fix learned-ability
tracking on Forever/Retail, seed a level-free baseline", plan 08 batch 11),
which predates this plan. `Rogue:TakeBaseline` seeds every pre-existing
spellbook entry as `false` (known, level unrecorded) the first time
`SPELLS_CHANGED` fires each session, and `Rogue:Record`'s `== nil` check
means a later scan can never overwrite that baseline with a guessed
current-level value. This plan's premise for that half was stale by the
time it was written. **Still open:** re-verifying `Rogue.seeded`,
`Rogue.upgrades`, and `Rogue.trainingNote` against live Forever data —
nothing checked in this pass found a concrete error, so this stays
opportunistic rather than urgent.

Also fixed opportunistically while reviewing the backlog: plan 04's T3 (a
quest-name mismatch in `Routes/Horde/TirisfalStart.lua` between "Delivery
to Silverpine" and "Delivery to Silverpine Forest") — confirmed via Wowhead
(quest ID 445) that "Delivery to Silverpine Forest" is the real name, and
corrected the accept step to match.

Version bumped to 1.7.1 and a changelog entry added for this pass, per the
user's 2026-09-25 standing instruction to pair pushed work with a version/
changelog update and a beta pre-release.

Not yet started: **B1**, **C1-C4**.
