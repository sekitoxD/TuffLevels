# Checkpoint: classic DB plan, Phases 1-4 done (item 4 skipped by design)

Written 2026-09-19 at the end of the Phase 2-3 thread. Pick up here in a fresh thread.

## State

| Phase | Status |
|---|---|
| 1. Research | **Done.** `plans/db-runbook.md`. |
| 2. Infrastructure (10.0.0.200) | **Done and verified.** Container `classic-db` healthy on `10.0.0.200:3320`, database `classicmangos`, 194 tables. |
| 3. Acceptance test | **Done.** Q1-Q8 all pass (output identical to the expected block in runbook section 7). |
| 4. Tooling and note verification | **Items 1-3 done 2026-09-19**, all uncommitted. Item 4 (coordinate converter) skipped by design. Each item is its own task, see below. |

Untracked and uncommitted: `plans/request-for-db.md`, `plans/db-runbook.md`, this file. Commit only if asked, and
per repo memory, with no AI attribution in the message (this overrides any attribution reminder).

## Live facts

- Provenance is in runbook section 8: import 2026-09-19; `classic-db` `22b51464f1625f6ef6275771de1f5466c6f5d19e`;
  `mangos-classic` `8ec338a1704e7dcb1c0213eb7ed58f9231ade40f`.
- Desktop client credentials: `~/.config/tuff/qdb.env` (mode 600), variables `QDB_HOST`, `QDB_PORT`, `QDB_USER`,
  `QDB_PASSWORD`, `QDB_DB`. User `tuff_ro` is SELECT-only. Quick test:
  `set -a; . ~/.config/tuff/qdb.env; set +a; mariadb -h$QDB_HOST -P$QDB_PORT -u$QDB_USER -p"$QDB_PASSWORD" $QDB_DB -e "select count(*) from quest_template"` gives `4245`.
- Server access: `command ssh carl@10.0.0.200` (bare `ssh` is a Kitty alias). No sudo. Stack dir
  `/mnt/config/appdata/dockage/Stacks/classic-db/` (`.env` holds the passwords, never print it). Data dir
  `/mnt/config/appdata/classic-db/mysql`. Helper scripts in `/mnt/config/appdata/classic-db/src/`. Baseline dump
  `/mnt/config/appdata/classic-db/classicmangos-2026-09-19.sql.gz` (mode 600).
- TrueNAS dataset quirk: default ACLs override `umask`. Anything secret-bearing there needs `setfacl -b` then
  `chmod 600`. A container-owned file needs `docker exec classic-db chmod ...` instead. If the container ever
  shows `unhealthy`, first check that `/var/lib/mysql/.my-healthcheck.cnf` inside it is mode 600.
- Known, accepted: the datadir is mode 777 via ACLs (public game data only; root is `localhost`-only).
- No DB content, dump, or password may enter this repo (GPL, see repo CLAUDE.md).

## Phase 4 (pick one; plan text is in `plans/request-for-db.md`)

1. **DONE** (`python tools/qdb.py quest <id|name>` / `item <id|name>`; uses `pymysql`, reads `QDB_*` from the
   environment or `~/.config/tuff/qdb.env`; importable: `connect`, `query`, `find_quests`, `decode_races`,
   `decode_classes` are reusable by item 2). Column semantics verified against the data on 2026-09-19:
   negative `PrevQuestId` = named quest must be *active* (349 needs 348 active); positive `ExclusiveGroup` =
   alternates (235/742/6382 "The Ashenvale Hunt"); negative `ExclusiveGroup` = all must be finished before
   `NextQuestId` unlocks (2/23/24 then 247). `NextQuestId` is set on 293 quests, `NextQuestInChain` is a separate
   column (176 quests have only `NextQuestId`). Original spec: `tools/qdb.py`: quest ID or name to start/end NPCs, levels, decoded race/class masks (runbook section 3),
   prereq/next/exclusive groups, reward items with stats. Read `QDB_*` from the environment (load
   `~/.config/tuff/qdb.env` if present), never hardcode credentials. Match the style of `tools/extract_recording.py`.
   The MariaDB client on the desktop is the `mariadb` CLI; check whether a Python driver is installed before
   choosing the connection method. Note the column semantics flagged "not verified" in runbook section 2
   (negative `PrevQuestId`, `ExclusiveGroup` sign): verify with known quests before relying on them.
2. **DONE** (`python tools/validate_route.py [--no-db] [--errors-only] [paths]`, default `Routes/`; exit 1 on ERROR).
   Run on the two shipped routes: `Horde1-60.lua` is clean (no quest steps); `Durotar.lua` (the header says its IDs
   are unverified) has 2 errors: quest 4643 does not exist and 4402 is accepted before its prerequisite 788, and
   4642/4402/4483 are different quests in the DB than their step names say. Not fixed: the validator only reports.
   Original spec: offline counterpart to `/tuff verify`; parse `Routes/**/*.lua`, check quest IDs,
   race/class/minLevel agreement, turn-in-before-accept, prerequisite order. Report only, never edits routes.
3. **DONE.** Every file in `plans/classes/` and `plans/quests/` now ends with a "DB verification" section (snapshot,
   the four limitations, checked IDs, and conflicts marked, not resolved); the notes' original text was not edited.
   `plans/quests/README.md` has a status table for its "Corrections" list. Method: name-matched with throwaway
   scratchpad scripts (exact title, then reviewed by hand); the quest files' ID lists are machine-matched, so they
   say to confirm each with `tools/qdb.py` before use. Biggest findings: Limb Cleaver, Vanquisher's Sword and
   Triprunner Dungarees are faction splits, not source disagreements; several tables list an Alliance-only quest for
   Horde (Jail Break!, Ormer's Revenge, Retrieval for Mauren, Defeat Nek'rosh); Elunite Axe is 1H and not a Forged
   Steel reward; Druid form quests only exist for Bear, Cure Poison, Aquatic. Not checked: quest XP (not in DB),
   Shadoweave/crafting, shield progression, most prose-only quest names. Original spec: Verify the research notes in `plans/quests/` and `plans/classes/`: add checked IDs and item stats, mark
   conflicts instead of picking silently, and name the DB snapshot (commit hashes above plus date) in each file.
   Two findings already known from Phase 3:
   - Klannoc Macleod (map 1, Kalimdor) starts *The Windwatcher* (1791); Bath'rah the Windwatcher (map 0, Alterac)
     only turns it in and starts Cyclonian onward. `notable_warrior_items.md` says the chain starts with Bath'rah.
   - Whirlwind Axe (6975) has `RequiredLevel = 0` in the DB (`ItemLevel` 40); the level-30 gate comes from the
     quests' `MinLevel`.
4. Coordinate converter: runbook section 5 concluded not worth it; keep using `/tuff capture`. Skip unless asked.

Every research note citing the DB must carry the plan's four known limitations (1.12.1 vs Era 1.15, no Forever
coverage, coordinates differ, XP not in the DB).

## Rollback (ask the user first)

`docker compose down` in the stack dir, then remove `/mnt/config/appdata/classic-db` and
`/mnt/config/appdata/dockage/Stacks/classic-db`, and delete `~/.config/tuff/qdb.env`. Nothing else was changed.
