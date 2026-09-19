# Plan: Local Classic quest/item database for route research and validation

Depends on: nothing structurally. Complements Plan 3 (`03-route-folder-layout-and-class-research.md`)
and the research notes in `plans/quests/` and `plans/classes/`.

## Purpose and boundaries

Stand up a local MariaDB holding a private-server (cmangos Classic) world database, so route authors
can look up concrete facts (quest IDs, NPC positions, prerequisites, race/class restrictions, item IDs
and stats) instead of reading them off guide sites, and so route files can be checked against it.

**In scope:** a DB used as a *lookup and validation aid* by a human author.

**Out of scope, on purpose:**
- Generating routes or choosing/ordering steps from queries. `README.md` ("Why it's built this way")
  rejects this; the DB tells us what is true about a quest, never which quest to do next.
- Loading the DB from the addon at runtime. The addon stays QuestieDB-optional and route files keep
  their own coordinates as the source of truth (`Data.lua` rule).
- Copying DB contents into this repo. cmangos data is GPL-2.0 and this repo must not be relicensed
  (see `CLAUDE.md`, "Don't bundle or copy QuestieDB's data files"). The DB, dumps, and imported SQL
  live on the server or in gitignored paths. Only facts a human types into notes and route files
  enter the repo.

## Known limitations (record these in every research note that cites the DB)

1. **Version mismatch.** cmangos targets patch 1.12.1. Classic Era is 1.15.x, which has quest and item
   changes. Treat the DB as "close to Era, not identical". Confirm anything route-critical with
   `/tuff verify` or in game.
2. **No Forever coverage.** Forever's new zones and 1,000+ new quests are in no database. `/tuff capture`
   remains the data source there.
3. **Coordinates do not match the addon's.** MaNGOS stores creature positions as world coordinates
   (`map`, `position_x/y/z`). Route steps use a uiMapID plus `x, y` on a 0-100 scale. The conversion needs
   zone bounds that are not in this DB. Until a converter exists (see Phase 4), DB positions are used only
   to identify *which* NPC/area, and step `x, y` still come from `/tuff capture` or in-game checks.
4. **XP is not fully in the DB.** Quest XP depends on quest level and character level via core tables, not
   a single column. Do not assume the DB gives per-character XP values.

## Roles

| Agent | Model / effort | Deliverable |
|---|---|---|
| Research | Sonnet, normal effort | `plans/db-runbook.md` (see Phase 1). Makes every decision. |
| Implementation | Much lower-effort model (for example Haiku) | Executes the runbook verbatim. Makes no decisions; stops and reports if any expected result differs. |

Run research first. Start the implementation agent only after the runbook exists and the user has read it.
The implementation agent needs a way to reach 10.0.0.200 (SSH or an existing session there). Confirm this
before Phase 2; if access is not available, the runbook is handed to the user to run manually.

## Phase 1 - Research (Sonnet)

Produce `plans/db-runbook.md` containing:

1. **Source repos and exact commits.** Which repos supply the schema and the content. `cmangos/classic-db`
   (https://github.com/cmangos/classic-db) is content only; the schema comes from `cmangos/mangos-classic`.
   Record the commit hashes used and the documented import procedure (`InstallFullDB.sh` and its config,
   or a manual `mysql < file.sql` order). Note which of the databases (world, characters, realm) are
   actually needed; likely only the world DB.
2. **Which tables matter and their key columns**, at minimum: `quest_template` (level, required level,
   race/class masks, prev/next/exclusive-group columns, reward columns), `creature_questrelation` and
   `creature_involvedrelation` (and the gameobject equivalents), `creature_template`, `creature`,
   `item_template` (stats, weapon type, required level, class/race restrictions). Include a sample query
   for each.
3. **Race/class bitmask decoding** (which bit is which race/class) so tooling can print names.
4. **Comparison of alternatives** in one short table: vmangos, and Wago.tools DB2 exports for Classic
   builds. State which is closer to Era 1.15 for quests and for items, and recommend whether to add one
   as a second source. Do not import them in this plan; only recommend.
5. **Coordinate conversion options** for limitation 3: what data is needed, where it comes from, and
   whether it is realistic. A clear "not worth it, use `/tuff capture`" is an acceptable answer.
6. **Acceptance queries with expected answers**, drawn from `plans/classes/` and `plans/quests/` (for
   example the Warrior Whirlwind Axe chain: quest IDs, order, required level, race/class restriction).
   These become the Phase 3 pass/fail test.
7. **Exact commands** for Phase 2 and Phase 3, in order, with expected output or row counts after each.

The runbook must be complete enough that the implementation agent has no decisions left.

## Phase 2 - Infrastructure (implementation agent, on 10.0.0.200)

### Pre-checks (do these before writing anything)

- List ports in use: `ss -tlnp` and `docker ps --format '{{.Names}} {{.Ports}}'`. The plan assumes
  **3320** is free; if not, choose the next free port above 3320 and record it in the runbook.
- Confirm `/mnt/config/appdata/classic-db/` does not already exist, or is empty. Do not overwrite existing data.

### Compose file

Create as a new stack (Dockge) named `classic-db`. Secrets go in a `.env` beside the compose file, not in
the compose file, and the `.env` is never committed anywhere.

```yaml
services:
  classic-db:
    image: mariadb:11
    container_name: classic-db
    restart: unless-stopped
    environment:
      MARIADB_ROOT_PASSWORD: ${CLASSIC_DB_ROOT_PASSWORD}
      MARIADB_DATABASE: classicmangos
    ports:
      - "3320:3306"
    volumes:
      - /mnt/config/appdata/classic-db/mysql:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 10
```

Notes on what changed from the original request:
- The two extra `/var/lib/mysql/data` and `/logs` mounts are dropped; only the data directory is mounted, at
  `/mnt/config/appdata/classic-db/mysql` as requested.
- `version:` and `networks: {}` removed (obsolete/unneeded). Image is pinned to a major version.
- Database name `classicmangos` is the cmangos default; the runbook may change it if the import process expects another.

`.env` (generate a real password, do not use `password`):

```
CLASSIC_DB_ROOT_PASSWORD=<generated>
CLASSIC_DB_RO_PASSWORD=<generated>
```

### After the stack is healthy

1. Import the world DB following the runbook.
2. Create a **read-only** user for all querying, and stop using root for lookups:
   ```sql
   CREATE USER 'tuff_ro'@'%' IDENTIFIED BY '<CLASSIC_DB_RO_PASSWORD>';
   GRANT SELECT ON classicmangos.* TO 'tuff_ro'@'%';
   ```
3. Restrict who can reach port 3320 (bind to the LAN address, or firewall to the desktop) if the server's
   network is not already trusted.
4. Take a baseline dump for reproducibility:
   `mysqldump classicmangos > /mnt/config/appdata/classic-db/classicmangos-<date>.sql`. Record the source repo
   commit hashes and import date in the runbook.

## Phase 3 - Acceptance test (implementation agent)

Run each acceptance query from the runbook and compare against the expected answer. Report pass/fail per
query with actual output. Any failure stops the plan and goes back to the user; do not "fix" data.

## Phase 4 - Tooling (separate follow-up, after Phase 3 passes)

Only after the DB is verified. Each item is its own small task; none is required for the DB to be useful.

1. **`tools/qdb.py`, lookup helper.** Given a quest ID or name, print: start/end NPCs, quest level and
   required level, race/class restrictions decoded to names, prerequisite and next-in-chain quests,
   exclusive groups, and reward items with stats. Same style as `tools/extract_recording.py`. Read
   connection settings from environment variables; never hardcode credentials.
2. **`tools/validate_route.py`, offline route validator.** Parse `Routes/**/*.lua` and check quest IDs
   exist, step `races`/`class`/`minLevel` agree with the quest's requirements, no turn-in precedes its
   accept, and prerequisite chains are in order. This is the offline counterpart to `/tuff verify`.
   Report only; it never edits routes.
3. **Verify the research notes.** Add checked quest IDs and item IDs/stats to the entries in
   `plans/quests/` and `plans/classes/`. Where the DB disagrees with the guide-site sources, mark the
   conflict rather than silently picking one. Note in each file which DB snapshot (commit + date) the IDs
   came from.
4. **Coordinate converter**, only if Phase 1 item 5 found it realistic.

## Definition of done (Phases 1-3)

- [x] `plans/db-runbook.md` exists and lists source commits.
- [x] `classic-db` container is healthy on the chosen port (3320), data under `/mnt/config/appdata/classic-db/mysql`.
- [x] Read-only user works from the desktop; all acceptance queries pass (2026-09-19).
- [x] No DB content, dump, or credential is in this repo.
