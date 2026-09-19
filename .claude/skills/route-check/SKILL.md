---
name: route-check
description: Static review of hand-authored TuFFlevels route files (Routes/**/*.lua) before commit — checks step schema, RegisterRoute metadata, and .toc registration. Use when a route file was added or edited, before committing changes under Routes/, or when asked to "check", "verify", or "audit" a route.
---

# Route check

TuFFlevels routes are **hand-authored data, not generated content** (see
`CLAUDE.md` / `README.md` — algorithmic route generation is explicitly
rejected). This skill never invents or edits step content. It only checks
that route files edited in this session are structurally sound, the same
way a human reviewer would before shipping them, and tells the user what
it cannot check from outside the game client.

This is a **static, offline complement** to `/tuff verify`, not a
replacement for it — `/tuff verify` (via `Data:ValidateRoute` in
`Data.lua`) is the authoritative check because it can query QuestieDB for
real quest IDs; this skill has no Lua interpreter or live game state to
work with. Always tell the user to run `/tuff verify` in-game as the last
step, even when this skill finds nothing wrong.

## 1. Find the target files

Default to files under `Routes/` that are new or modified in the working
tree: `git status --short -- Routes/` plus `git diff --stat -- Routes/`
(staged and unstaged). If the user names specific files or a route name,
use those instead. If nothing under `Routes/` changed, say so and stop —
don't go looking for unrelated problems.

## 2. Per-file schema check

For each step table (`{ type = "...", ... }`) in the file's `steps = { }`
list, check against the authoritative schema (`Routes/Durotar.lua` header
comment + `Core.lua`'s `IsStepDone`/`StepApplies`, `Data.lua`'s
`ValidateRoute` — re-read these if unsure, don't rely on memory):

- **`type`** is one of: `accept`, `turnin`, `complete`, `grind`, `level`,
  `section`, `trainer`, `death`, `manual`, `travel`, `hearth`, `note`.
  Anything else is a typo, not a new feature — flag it.
- **`accept` / `turnin` / `complete`** steps carry a numeric `quest`, or a
  non-empty `questName` string (spreadsheet-imported steps resolve by name
  at runtime — that's fine, not an error). Missing both is a hard error.
- **`grind` / `level`** steps carry a numeric `targetLevel`.
- **`x` / `y`**, if present, are in `0–100`. If either is present, the step
  also needs a way to resolve a map: `map` (numeric uiMapID) or `zone`
  (name `Compat:MapID` can resolve) — a step with coords and neither is a
  silent dead waypoint.
- **`races`** (if present) is a list of valid race strings; **`class`** is
  a valid class-file token (e.g. `ROGUE`, all-caps); **`minLevel`** is a
  number. These are optional filters, not required on every step.
- **`section`** steps are headers only — don't flag them for missing
  `quest`/coords.

## 3. `RegisterRoute` metadata check

Confirm the file calls `ns.RegisterRoute("Name", { ... })` with:

- `faction`, `races`, `levels` (a `{min, max}` pair), `author` all set —
  flag leftover placeholders like `author = "you"`.
- If the route's quest IDs haven't been run through `/tuff verify` yet
  (ask the user, or infer from a "READ THIS" / unverified-IDs header
  comment like `Durotar.lua`'s), confirm `sample = true` is set so it's
  never auto-selected over a verified route, and that the file has a
  header comment warning the reader, matching `Durotar.lua`'s convention.

## 4. `.toc` registration check

For any **new** file under `Routes/` (untracked, or added this session):

- Check whether it's listed in `TuFFlevels.toc`, `TuFFlevels_Mainline.toc`,
  and `TuFFlevels_Vanilla.toc` (`grep -n "<relative path with backslashes>"
  *.toc` — entries use `\` not `/`). A route file that loads on some
  clients but not others is an easy miss.
- Check load order: it must come after `Core.lua`, and if it lives in a
  subfolder that uses the `Init.lua` / `Register.lua` pattern (see
  `Routes/Horde/Solo/` or `Routes/Horde/Dungeon/`), it must be listed
  after that folder's `Init.lua` and before its `Register.lua`.
- If a new file is missing from one or more `.toc`s, report it — don't
  silently edit the `.toc` files unless the user asks you to fix it.

## 5. Report

Give a short per-file checklist (pass/fail, one line per problem found,
file:line where possible). Then close with:

- What this skill could **not** check (quest ID existence, NPC/coordinate
  accuracy, in-game reachability) and a reminder to run `/tuff verify`
  (and `/tuff capture` if the route still needs real quest IDs) in-game
  before treating the route as done.
- If everything passes, say so plainly — don't pad a clean result with
  invented caveats.

Do not modify route files as part of this check unless the user explicitly
asks for the fix to be applied.
