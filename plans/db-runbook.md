# Runbook: local cmangos Classic database (Phases 1 output, Phases 2-3 commands)

Produced by Phase 1 of `plans/request-for-db.md`. This is the deliverable the implementation agent executes
verbatim. **The import logic, read-only user, acceptance queries and helper scripts (sections 1, 6 steps 5-9, 7) were
dry-run on a throwaway local MariaDB 11.8 container on the desktop on 2026-09-19** and produced the outputs
shown; the server-side compose, paths and `ssh`/`scp` plumbing have not been exercised. The real server has not been touched beyond
read-only pre-checks (section 6, step 1).

Rules for the implementation agent: run steps in order, make no decisions, and **stop and report** the
moment any output differs from "Expect". Never print, log, or commit a password. Never write anything under
`/home/carl/Documents/Repos/TuffLevels/`.

SSH: use `command ssh carl@10.0.0.200 '...'` (bare `ssh` is aliased to Kitty's kitten and refuses non-TTY use).
Passwordless key auth works. `carl` is in the `docker` group; `sudo` needs a password, so do not use it.

## 1. Sources, pins, and why the install is manual

| Repo | Role | Pinned commit (fetched 2026-09-19) |
|---|---|---|
| `cmangos/classic-db` | Content (world data) + `Updates/` | `22b51464f1625f6ef6275771de1f5466c6f5d19e` (2026-09-01) |
| `cmangos/mangos-classic` | Schema (`sql/base/mangos.sql`), core updates, DBC data | `8ec338a1704e7dcb1c0213eb7ed58f9231ade40f` (2026-08-31) |

- Only the **world** database is needed. Character, realmd, and logs DBs are for running a game server and are
  not created.
- `classic-db`'s own `InstallFullDB.sh` is a menu-driven interactive script (single-keypress prompts, no batch
  mode). It is not used. The manual order below reproduces what its "install world DB" path does:
  1. `mangos-classic/sql/base/mangos.sql` (schema)
  2. `classic-db/Full_DB/ClassicDB_1_12_1_z2815.sql.gz` (content)
  3. `classic-db/Updates/[0-9]*.sql` (356 files, glob order)
  4. `classic-db/Updates/Instances/[0-9]*.sql` (30 files)
  5. `mangos-classic/sql/updates/mangos/z*_mangos_*.sql` **newer than the DB's current core revision** (exactly 1
     file at these pins: `z2837_01_mangos_gobject_near_link.sql`; the content updates in step 3 already advance
     the DB to `z2836`, so a hard-coded starting revision fails, and the script reads it from `db_version`)
  6. `mangos-classic/sql/base/dbc/original_data/*.sql` then `.../cmangos_fixes/*.sql`
- Skipped on purpose: `locales/` (non-English text), `ACID/` (creature AI), ScriptDev2, `utilities/`, dev
  updates. None affect the quest/item/NPC lookups this plan needs.
- Result: **194 tables**, ~27-40 s to import. `db_version` ends at `required_z2837_01_mangos_gobject_near_link`.
- Licensing: `classic-db` is GPL-3.0 and `mangos-classic` GPL-2.0. Everything above stays on the server (and its
  dump there). Nothing from it goes in this repo.

## 2. Tables that matter

All in database `classicmangos`. Row counts at the pins: `quest_template` 4245, `item_template` 17718,
`creature_template` 10384.

| Table | Key columns |
|---|---|
| `quest_template` | `entry` (quest ID), `Title`, `QuestLevel`, `MinLevel`, `RequiredRaces`, `RequiredClasses` (bitmasks, 0 = any), `PrevQuestId`, `NextQuestId`, `NextQuestInChain`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `ZoneOrSort` (numeric area/sort ID, no names in this DB), `SrcItemId`, `ReqItemId1-4`, `ReqCreatureOrGOId1-4` (negative = gameobject), `RewChoiceItemId1-6`, `RewItemId1-4`, `RewOrReqMoney`, `RequiredSkill`, `RequiredMinRepFaction/Value` |
| `creature_questrelation` | `id` (NPC entry), `quest`: NPC **starts** quest |
| `creature_involvedrelation` | `id`, `quest`: NPC **ends** (turn-in) quest |
| `gameobject_questrelation` / `gameobject_involvedrelation` | same, keyed on `gameobject_template.entry` |
| `areatrigger_involvedrelation` | quests completed by entering an area trigger |
| `creature_template` | `entry`, `Name`, `MinLevel`, `MaxLevel`, `NpcFlags` (bit 2 = quest giver), `Faction` |
| `creature` | spawns: `id` (creature_template entry), `map`, `position_x/y/z` (world coordinates, see section 5) |
| `gameobject_template` | `entry`, `name` |
| `item_template` | `entry`, `name`, `Quality`, `ItemLevel`, `RequiredLevel`, `class`/`subclass`/`InventoryType`, `AllowableClass`/`AllowableRace` (-1 = all), `stat_type1-10`/`stat_value1-10`, `dmg_min1/dmg_max1`, `delay` (ms), `armor`, `bonding`, `startquest` |

Sample queries (each verified to run):

```sql
-- quest with prerequisites and rewards
select entry,Title,QuestLevel,MinLevel,RequiredRaces,RequiredClasses,PrevQuestId,NextQuestInChain,ExclusiveGroup,RewChoiceItemId1 from quest_template where entry=1792;
-- who starts / ends a quest
select c.name from creature_questrelation r join creature_template c on c.entry=r.id where r.quest=1791;
select c.name from creature_involvedrelation r join creature_template c on c.entry=r.id where r.quest=1791;
-- gameobject-started quests
select g.id,t.name,g.quest from gameobject_questrelation g join gameobject_template t on t.entry=g.id limit 5;
-- where an NPC stands
select c.map,round(c.position_x,1) x,round(c.position_y,1) y from creature c where c.id=6176;
-- item stats
select entry,name,Quality,class,subclass,InventoryType,dmg_min1,dmg_max1,delay,stat_type1,stat_value1,AllowableClass from item_template where entry=6975;
-- quest by name
select entry,Title,MinLevel,RequiredClasses,RequiredRaces from quest_template where Title like 'Cyclonian%';
```

Column semantics (cmangos convention; **not verified in this trial**, confirm with a known quest before relying on
them in tooling): a negative `PrevQuestId` means the named quest must be *active*, not turned in; a non-zero
`ExclusiveGroup` links quests that gate each other (positive: taking/finishing one blocks the others; negative:
all must be finished before `NextQuestId` unlocks). `stat_type` 3 = Agility, 4 = Strength, 5 = Intellect,
6 = Spirit, 7 = Stamina.

## 3. Race and class bitmasks

Verified against the data: vanilla Alliance quests use `77` (1+4+8+64), Horde `178` (2+16+32+128); the
class column shows only the class bits below.

| Race | Bit | | Class | Bit |
|---|---|---|---|---|
| Human | 1 | | Warrior | 1 |
| Orc | 2 | | Paladin | 2 |
| Dwarf | 4 | | Hunter | 4 |
| Night Elf | 8 | | Rogue | 8 |
| Undead | 16 | | Priest | 16 |
| Tauren | 32 | | Shaman | 64 |
| Gnome | 64 | | Mage | 128 |
| Troll | 128 | | Warlock | 256 |
| (Blood Elf 512, Draenei 1024: TBC, unused here) | | | Druid | 1024 |

Bit 32 in the class column (Death Knight) does not occur. A mask like `384` is Mage+Warlock. The DB also
contains a few TBC-era masks (`690`, `1101`); treat them as noise.

## 4. Alternatives (recommendation: do not add a second source now)

| Source | Closeness to Era 1.15 | Quest data | Item data | Notes |
|---|---|---|---|---|
| **cmangos classic-db** (chosen) | Targets patch 1.12.1; Era 1.15.x has quest/item changes on top | Full: relations, chains, prereqs, rewards | Full: stats, class/race | Verified working (this runbook). |
| **vmangos** (`vmangos/core`, GPL-2.0) | Also 1.12.1-era, but a *progressive* DB: rows are tagged with the patch that added or changed them, so the final state can be selected | Full | Full | Larger, MySQL dump distributed via its releases; not imported or verified here. Would be a *different* view of the same 1.12 baseline, not closer to 1.15. |
| **Wago.tools DB2 exports** (Classic builds) | Real client data for the actual Classic Era build, so it is the only one that can reflect 1.15.x | Client-side only (no server relations: nothing says which NPC starts/ends a quest or the chain order) | Likely accurate stats, required level, item level | wago.tools is JS-rendered and I could not confirm table availability or CSV export from here: **unverified**. |

Recommendation: keep cmangos as the single source. If item accuracy vs Era matters later, add Wago item tables
as an items-only cross-check in Phase 4 item 3, after confirming the export exists. A concrete example of cmangos
data drift found in this trial: Whirlwind Axe (6975) has `RequiredLevel = 0` and `ItemLevel = 40` in the DB,
so the level-30 gate comes from the quest's `MinLevel`, not the item.

## 5. Coordinate conversion

Not available from this DB. `creature.position_x/y` are world coordinates on `map`; route steps need a uiMapID
plus 0-100 x/y. Converting needs per-zone world bounds: this DB has **no area/zone-name table** (`areatable`
does not exist; `quest_template.ZoneOrSort` is a bare number). Those bounds live in client data
(`UiMapAssignment`/`WorldMapArea`, obtainable from Wago DB2 exports, unverified as above) or could be queried
in-game with `C_Map.GetMapPosFromWorldPos` (an idea only, untested; the DB's axis order also differs from the
in-game one). **Answer: not worth it now. Keep using `/tuff capture` for step coordinates**; the DB's positions
only identify *which* NPC and roughly where (`map` + coordinates), as the plan says. Revisit only if Phase 4
item 4 is wanted.

## 6. Phase 2: infrastructure (run on 10.0.0.200 via `command ssh`)

Decisions already made:
- Port **3320** (verified free 2026-09-19; 3306, 3308, 3310 and 1433 are taken). Bound to **10.0.0.200 only**
  (not `0.0.0.0`) so it is not exposed on the server's WireGuard (`wg0`) or Docker interfaces.
- `MARIADB_ROOT_HOST: localhost`, so root cannot log in over the network. All import/admin goes through
  `docker exec`; remote access is only the read-only user.
- Stack dir: `/mnt/config/appdata/dockage/Stacks/classic-db/` (where Dockge keeps stacks; `carl` can write there).
  Data: `/mnt/config/appdata/classic-db/mysql`. Sources and scripts: `/mnt/config/appdata/classic-db/src`.

### Step 1: pre-checks (read-only)

```bash
command ssh carl@10.0.0.200 'ss -tln | grep -c ":3320 " ; ls -d /mnt/config/appdata/classic-db /mnt/config/appdata/dockage/Stacks/classic-db 2>&1'
```
Expect: `0`, then two `No such file or directory` lines. Anything else: stop.

### Step 2: create directories, secrets, compose file

```bash
command ssh carl@10.0.0.200 'set -e
mkdir -p /mnt/config/appdata/classic-db/mysql /mnt/config/appdata/classic-db/src /mnt/config/appdata/dockage/Stacks/classic-db
cd /mnt/config/appdata/dockage/Stacks/classic-db
umask 077
printf "CLASSIC_DB_ROOT_PASSWORD=%s\nCLASSIC_DB_RO_PASSWORD=%s\n" "$(openssl rand -hex 24)" "$(openssl rand -hex 24)" > .env
umask 022
cat > compose.yaml <<"EOF"
services:
  classic-db:
    image: mariadb:11
    container_name: classic-db
    restart: unless-stopped
    environment:
      MARIADB_ROOT_PASSWORD: ${CLASSIC_DB_ROOT_PASSWORD}
      MARIADB_ROOT_HOST: localhost
      MARIADB_DATABASE: classicmangos
    ports:
      - "10.0.0.200:3320:3306"
    volumes:
      - /mnt/config/appdata/classic-db/mysql:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 10
EOF
setfacl -b .env && chmod 600 .env
ls -la .env compose.yaml && docker compose config -q && echo compose-ok'
```
Expect: `.env` mode `-rw-------` (600) with no trailing `+`, `compose.yaml` present, then `compose-ok`. Do not `cat` `.env`.
(The `setfacl -b` is required: the TrueNAS dataset has default ACLs on parent directories that override `umask`
and left `.env` as `-rw-rw-r--+`, world-readable. Found on the first execution, 2026-09-19.)

### Step 3: start and wait for healthy

```bash
command ssh carl@10.0.0.200 'cd /mnt/config/appdata/dockage/Stacks/classic-db && docker compose up -d 2>&1 | tail -5; for i in $(seq 1 30); do s=$(docker inspect -f "{{.State.Health.Status}}" classic-db); [ "$s" = healthy ] && break; sleep 5; done; echo status=$s; ss -tln | grep ":3320 "'
```
Expect: `status=healthy` and a listener on `10.0.0.200:3320`. If not healthy after 150 s, run
`docker logs classic-db 2>&1 | tail -30` and report (a likely cause is data-dir ownership on the TrueNAS dataset).

### Step 4: fetch pinned sources

```bash
command ssh carl@10.0.0.200 'set -e; cd /mnt/config/appdata/classic-db/src
fetch() { mkdir -p "$1" && cd "$1" && git init -q && git remote add origin "$2" && git fetch -q --depth 1 origin "$3" && git checkout -q FETCH_HEAD && git rev-parse HEAD && cd ..; }
fetch classic-db https://github.com/cmangos/classic-db 22b51464f1625f6ef6275771de1f5466c6f5d19e
fetch mangos-classic https://github.com/cmangos/mangos-classic 8ec338a1704e7dcb1c0213eb7ed58f9231ade40f
ls classic-db/Full_DB'
```
Expect: the two exact hashes printed, then `ClassicDB_1_12_1_z2815.sql.gz`.

### Step 5: write the helper scripts

Write these four files on the **desktop** into a scratch directory (`mkdir -p /tmp/classic-db-scripts`; use
quoted heredocs so nothing is expanded), then copy them to the server. This avoids nested shell quoting.

`sqlroot.sh` (root client inside the container; the password comes from the container's own environment):
```bash
#!/bin/sh
exec docker exec -i classic-db sh -c 'MYSQL_PWD="$MARIADB_ROOT_PASSWORD" exec mariadb -uroot "$@"' sh "$@"
```

`import.sh`:
```bash
#!/bin/bash
# usage: import.sh <CORE_DIR> <CDB_DIR> ; mysql client via $MYSQL_CMD (must connect as a user that can create DBs)
set -u
CORE=$1; CDB=$2; DB=classicmangos
SQL() { $MYSQL_CMD "$@"; }
fail() { echo "FAILED: $*"; exit 1; }
apply() { local out; out=$(SQL $DB < "$1" 2>&1) || { echo "ERROR in $1:"; echo "$out" | tail -5; exit 1; }; }
SQL -e "DROP DATABASE IF EXISTS $DB; CREATE DATABASE $DB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci" || fail create
apply $CORE/sql/base/mangos.sql; echo "base schema ok"
gzip -dc $CDB/Full_DB/ClassicDB_1_12_1_z2815.sql.gz | SQL $DB || fail fulldb; echo "full db ok"
n=0; for f in $CDB/Updates/[0-9]*.sql; do apply $f; n=$((n+1)); done; echo "content updates: $n"
n=0; for f in $CDB/Updates/Instances/[0-9]*.sql; do apply $f; n=$((n+1)); done; echo "instance updates: $n"
CUR=$(SQL -N $DB -e "select column_name from information_schema.columns where table_schema='$DB' and table_name='db_version' and column_name like 'required_z%'")
CURREV=$(echo $CUR | sed -E 's/^required_z([0-9]+)_([0-9]+).*/\1\2/'); echo "db core rev before core updates: $CUR"
n=0; for f in $(ls $CORE/sql/updates/mangos/z*_*_mangos_*.sql | sort); do
  b=$(basename $f); rev=$(echo $b | sed -E 's/^z([0-9]+)_([0-9]+).*/\1\2/')
  if [ $((10#$rev)) -gt $((10#$CURREV)) ]; then apply $f; n=$((n+1)); fi
done; echo "core updates: $n"
for f in $CORE/sql/base/dbc/original_data/*.sql $CORE/sql/base/dbc/cmangos_fixes/*.sql; do apply $f; done; echo "dbc ok"
SQL $DB -e "select count(*) as tables from information_schema.tables where table_schema='$DB'"
```

`ro-user.sh` (reads the read-only password from the stack's `.env`, never prints it):
```bash
#!/bin/bash
set -e
cd /mnt/config/appdata/dockage/Stacks/classic-db
set -a; . ./.env; set +a
/mnt/config/appdata/classic-db/src/sqlroot.sh <<SQL
CREATE OR REPLACE USER 'tuff_ro'@'%' IDENTIFIED BY '${CLASSIC_DB_RO_PASSWORD}';
GRANT SELECT ON classicmangos.* TO 'tuff_ro'@'%';
FLUSH PRIVILEGES;
SQL
/mnt/config/appdata/classic-db/src/sqlroot.sh -N -e "SHOW GRANTS FOR 'tuff_ro'@'%'" | sed "s/IDENTIFIED BY PASSWORD.*/IDENTIFIED BY <hidden>/"
```

`dump.sh`:
```bash
#!/bin/bash
set -e
cd /mnt/config/appdata/classic-db
docker exec classic-db sh -c 'MYSQL_PWD="$MARIADB_ROOT_PASSWORD" exec mariadb-dump -uroot --single-transaction classicmangos' | gzip > "classicmangos-$(date +%F).sql.gz"
ls -la classicmangos-*.sql.gz
```

Copy and syntax-check:
```bash
scp /tmp/classic-db-scripts/{sqlroot.sh,import.sh,ro-user.sh,dump.sh} carl@10.0.0.200:/mnt/config/appdata/classic-db/src/
command ssh carl@10.0.0.200 'cd /mnt/config/appdata/classic-db/src && chmod +x *.sh && for f in *.sh; do bash -n $f && echo "$f ok"; done'
```
Expect four `ok` lines. (If `scp` is aliased to something odd, use `command scp`.)

### Step 6: import

```bash
command ssh carl@10.0.0.200 'cd /mnt/config/appdata/classic-db/src && MYSQL_CMD=$PWD/sqlroot.sh ./import.sh $PWD/mangos-classic $PWD/classic-db 2>&1 | tail -15'
```
Expect exactly:
```
base schema ok
full db ok
content updates: 356
instance updates: 30
db core rev before core updates: required_z2836_01_mangos_cls_rework
core updates: 1
dbc ok
tables
194
```
Any `ERROR in ...` or different counts: stop and report the full message.

### Step 7: read-only user

```bash
command ssh carl@10.0.0.200 '/mnt/config/appdata/classic-db/src/ro-user.sh'
```
Expect two grant lines: `GRANT USAGE ON *.* TO tuff_ro@% IDENTIFIED BY <hidden>` and
`GRANT SELECT ON classicmangos.* TO tuff_ro@%`.

### Step 8: desktop client credentials (outside the repo)

Run on the **desktop**:
```bash
mkdir -p ~/.config/tuff && chmod 700 ~/.config/tuff
pw=$(command ssh carl@10.0.0.200 'grep ^CLASSIC_DB_RO_PASSWORD= /mnt/config/appdata/dockage/Stacks/classic-db/.env | cut -d= -f2')
umask 077
printf 'QDB_HOST=10.0.0.200\nQDB_PORT=3320\nQDB_USER=tuff_ro\nQDB_PASSWORD=%s\nQDB_DB=classicmangos\n' "$pw" > ~/.config/tuff/qdb.env
unset pw
mariadb -h10.0.0.200 -P3320 -utuff_ro -p"$(grep ^QDB_PASSWORD= ~/.config/tuff/qdb.env | cut -d= -f2)" classicmangos -e "select count(*) from quest_template"
```
Expect `4245`. Also verify the user cannot write:
`mariadb ... -e "create table x(a int)"` → `ERROR 1142 ... CREATE command denied`; and root is unreachable remotely:
`mariadb -h10.0.0.200 -P3320 -uroot -pwhatever -e "select 1"` → `Access denied` (or a host-not-allowed error).
`~/.config/tuff/qdb.env` is mode 600 and is what Phase 4 `tools/qdb.py` reads (env vars `QDB_*`).

### Step 9: baseline dump

```bash
command ssh carl@10.0.0.200 '/mnt/config/appdata/classic-db/src/dump.sh'
```
Expect one `classicmangos-<date>.sql.gz` of tens of MB. (Contains GPL data: stays in that directory, never in the
repo.)

## 7. Phase 3: acceptance test

Source of the expectations: `plans/classes/notable_warrior_items.md`, `plans/quests/notable_horde_quests.md`.
Run from the **desktop** as the read-only user, so this also proves remote access.

Write `acc.sh` to the scratchpad directory (not the repo):

```bash
#!/bin/bash
# usage: acc.sh   (needs $MYSQL_CMD, a client connecting as the read-only user)
SQL() { $MYSQL_CMD -B classicmangos "$@"; }
echo "## Q1 whirlwind chain"
SQL -e "select entry,Title,MinLevel,RequiredClasses,RequiredRaces,PrevQuestId,NextQuestInChain from quest_template where entry in (1718,1719,1791,1712,1713,1792) order by entry"
echo "## Q2 whirlwind chain reward choices"
SQL -e "select RewChoiceItemId1,RewChoiceItemId2,RewChoiceItemId3 from quest_template where entry=1792"
echo "## Q3 chain start/end NPCs"
SQL -e "select 'start' k,r.quest,c.name from creature_questrelation r join creature_template c on c.entry=r.id where r.quest in (1719,1791,1712,1713,1792) union all select 'end',r.quest,c.name from creature_involvedrelation r join creature_template c on c.entry=r.id where r.quest in (1719,1791,1712,1713,1792) order by 1 desc,2"
echo "## Q4 whirlwind axe item"
SQL -e "select entry,name,Quality,class,subclass,InventoryType,dmg_min1,dmg_max1,delay,stat_type1,stat_value1,AllowableClass from item_template where entry=6975"
echo "## Q5 Path of Defense (Horde-only warrior quest)"
SQL -e "select entry,Title,QuestLevel,MinLevel,RequiredRaces,RequiredClasses,PrevQuestId,NextQuestInChain from quest_template where entry=1498"
echo "## Q6 NPC position (world coords)"
SQL -e "select c.id,t.name,c.map,round(c.position_x,1) x,round(c.position_y,1) y from creature c join creature_template t on t.entry=c.id where c.id in (6176,6236) order by c.id"
echo "## Q7 vanilla Horde (178) and Alliance (77) race masks are in use"
SQL -e "select RequiredRaces,count(*)>100 in_use from quest_template where RequiredRaces in (77,178) group by RequiredRaces"
echo "## Q8 db size sanity"
SQL -e "select (select count(*) from quest_template)>4000 quests_ok,(select count(*) from item_template)>17000 items_ok,(select count(*) from creature_template)>10000 creatures_ok"
```

Run and save output (tabs are literal tab characters in the expected file):
```bash
set -a; . ~/.config/tuff/qdb.env; set +a
MYSQL_CMD="mariadb -h$QDB_HOST -P$QDB_PORT -u$QDB_USER -p$QDB_PASSWORD" bash acc.sh > acc.actual
```

Expected output (`acc.expected`):

```
## Q1 whirlwind chain
entry	Title	MinLevel	RequiredClasses	RequiredRaces	PrevQuestId	NextQuestInChain
1712	Cyclonian	30	1	0	1791	1713
1713	The Summoning	30	1	0	1712	0
1718	The Islander	30	1	0	0	1719
1719	The Affray	30	1	0	1718	0
1791	The Windwatcher	30	1	0	1719	1712
1792	Whirlwind Weapon	30	1	0	1713	0
## Q2 whirlwind chain reward choices
RewChoiceItemId1	RewChoiceItemId2	RewChoiceItemId3
6975	6977	6976
## Q3 chain start/end NPCs
k	quest	name
start	1712	Bath'rah the Windwatcher
start	1713	Bath'rah the Windwatcher
start	1719	Klannoc Macleod
start	1791	Klannoc Macleod
start	1792	Bath'rah the Windwatcher
end	1712	Bath'rah the Windwatcher
end	1713	Bath'rah the Windwatcher
end	1719	Klannoc Macleod
end	1791	Bath'rah the Windwatcher
end	1792	Bath'rah the Windwatcher
## Q4 whirlwind axe item
entry	name	Quality	class	subclass	InventoryType	dmg_min1	dmg_max1	delay	stat_type1	stat_value1	AllowableClass
6975	Whirlwind Axe	3	2	1	17	102	154	3600	4	15	1
## Q5 Path of Defense (Horde-only warrior quest)
entry	Title	QuestLevel	MinLevel	RequiredRaces	RequiredClasses	PrevQuestId	NextQuestInChain
1498	Path of Defense	10	10	178	1	1505	1502
## Q6 NPC position (world coords)
id	name	map	x	y
6176	Bath'rah the Windwatcher	0	250.8	-1470.6
6236	Klannoc Macleod	1	-1709.1	-4330.1
## Q7 vanilla Horde (178) and Alliance (77) race masks are in use
RequiredRaces	in_use
77	1
178	1
## Q8 db size sanity
quests_ok	items_ok	creatures_ok
1	1	1
```

Pass/fail per query: `diff acc.expected acc.actual`. Report each `## Qn` block as PASS or FAIL with the
actual output for failures. Any FAIL stops the plan; do not "fix" data.

What these confirm and what they surface against the research notes (record in Phase 4 item 3, do not edit
notes now):
- The chain order **The Islander (1718) → The Affray (1719) → The Windwatcher (1791) → Cyclonian (1712) → The
  Summoning (1713) → Whirlwind Weapon (1792)** matches the warrior notes (Berserker Stance prerequisite first).
- **Conflict with the notes:** `notable_warrior_items.md` says the chain "starts with Bath'rah the Windwatcher in the
  Alterac Mountains". In this DB, *The Windwatcher* (1791) is **started by Klannoc Macleod** (map 1, i.e. Kalimdor)
  and turned in to Bath'rah (map 0, Alterac). Bath'rah starts Cyclonian onward.
- All six quests are Warrior-only (class mask 1) with `MinLevel` 30; there is no race restriction. The reward is a
  choice of Axe (6975), Warhammer (6976), Sword (6977).

## 8. Provenance log (the implementation agent reports these values; the main session fills them in, since the agent may not write to the repo)

| Item | Value |
|---|---|
| Import date | 2026-09-19 |
| classic-db commit | `22b51464f1625f6ef6275771de1f5466c6f5d19e` |
| mangos-classic commit | `8ec338a1704e7dcb1c0213eb7ed58f9231ade40f` |
| Server port | 3320 (bound to 10.0.0.200) |
| Baseline dump | `/mnt/config/appdata/classic-db/classicmangos-2026-09-19.sql.gz` (15,947,257 bytes, mode 600) |
| Acceptance result | Q1-Q8: all PASS (`diff` against `acc.expected` empty; re-run independently by the main session) |

Execution notes from 2026-09-19 (a Haiku subagent ran Phases 2-3; the main session verified and fixed two issues):
1. `.env` came out `-rw-rw-r--+` because the TrueNAS dataset has default ACLs on parent directories that override
   `umask`. Fixed in Step 2 (`setfacl -b` + `chmod 600`).
2. The container went `unhealthy` (the subagent called this a "false negative"; it was real). MariaDB ignores
   `/var/lib/mysql/.my-healthcheck.cnf` when it is world-writable, and the same ACL inheritance made it 666, so
   `healthcheck.sh` could not authenticate. `carl` cannot chmod it (owned by uid 999). Fix, run once after Step 3
   if `docker inspect` shows `unhealthy`: `docker exec classic-db chmod 600 /var/lib/mysql/.my-healthcheck.cnf`.
   Health returned to `healthy` within ~20 s and stays so, since the file is created only at first init.
3. The dump inherited mode 666; tightened to 600 with `setfacl -b` + `chmod 600`.
4. Remaining known exposure: the datadir `/mnt/config/appdata/classic-db/mysql` is mode 777 with ACLs (dataset
   default), so any local user on the NAS can read the DB files. The DB holds only public game data plus the
   `tuff_ro` hash; root is `localhost`-only. Left as is.
5. Verified from the desktop: `tuff_ro` reads (`quest_template` = 4245), `CREATE TABLE` is denied (ERROR 1142),
   remote root is denied (ERROR 1045), `~/.config/tuff/qdb.env` is mode 600.

## 9. Deviations from `request-for-db.md` (for the user to confirm)

1. Port bound to `10.0.0.200:3320` rather than all interfaces, and root is `localhost`-only. This satisfies plan
   Phase 2 step 3 without a firewall change.
2. `InstallFullDB.sh` is replaced by the manual order in section 1, since it cannot run non-interactively.
3. Schema is loaded from `mangos-classic`, not from the DB repo, as the plan already assumed.
4. Import runs on the server via `docker exec` (the server has no mysql/mariadb client).
