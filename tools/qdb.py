#!/usr/bin/env python3
"""Look up Classic quest and item facts in the local cmangos database.

This is a research aid for route authors, nothing more: it tells you what is
true about a quest or item, never which one to do next. The database is a
private-server (cmangos, patch 1.12.1) world DB, so treat it as "close to
Classic Era, not identical". It has no Forever coverage, its creature
positions are world coordinates (not the addon's uiMapID + 0-100 x/y), and
quest XP is not in it. Nothing from the DB may be copied into this repo
(GPL) - only facts a human types into notes and route files.

Usage:
    python tools/qdb.py quest 1792
    python tools/qdb.py quest "Whirlwind Weapon"
    python tools/qdb.py item 6975
    python tools/qdb.py item "Whirlwind Axe"

A name that matches more than one row prints a short candidate list; rerun
with the ID. Names match as a case-insensitive substring unless exactly one
title matches exactly.

Connection settings come from the environment (QDB_HOST, QDB_PORT, QDB_USER,
QDB_PASSWORD, QDB_DB). Any that are unset are read from
~/.config/tuff/qdb.env if that file exists. Needs the `pymysql` package.
"""

import os
import sys

RACES = [
    (1, "Human"), (2, "Orc"), (4, "Dwarf"), (8, "Night Elf"),
    (16, "Undead"), (32, "Tauren"), (64, "Gnome"), (128, "Troll"),
]
CLASSES = [
    (1, "Warrior"), (2, "Paladin"), (4, "Hunter"), (8, "Rogue"),
    (16, "Priest"), (64, "Shaman"), (128, "Mage"), (256, "Warlock"),
    (1024, "Druid"),
]
ALLIANCE_MASK = 77   # Human + Dwarf + Night Elf + Gnome
HORDE_MASK = 178     # Orc + Undead + Tauren + Troll

QUALITY = {0: "Poor", 1: "Common", 2: "Uncommon", 3: "Rare", 4: "Epic",
           5: "Legendary", 6: "Artifact"}
STATS = {0: "Mana", 1: "Health", 3: "Agility", 4: "Strength", 5: "Intellect",
         6: "Spirit", 7: "Stamina"}
BONDING = {0: "", 1: "BoP", 2: "BoE", 3: "BoU", 4: "Quest item"}
SLOTS = {
    1: "Head", 2: "Neck", 3: "Shoulder", 4: "Shirt", 5: "Chest", 6: "Waist",
    7: "Legs", 8: "Feet", 9: "Wrist", 10: "Hands", 11: "Finger",
    12: "Trinket", 13: "One-Hand", 14: "Shield", 15: "Ranged", 16: "Back",
    17: "Two-Hand", 18: "Bag", 19: "Tabard", 20: "Robe", 21: "Main Hand",
    22: "Off Hand", 23: "Held In Off-hand", 24: "Ammo", 25: "Thrown",
    26: "Ranged", 28: "Relic",
}
# item_template.class -> {subclass: name}; only the classes that matter here.
WEAPONS = {
    0: "Axe", 1: "Two-Hand Axe", 2: "Bow", 3: "Gun", 4: "Mace",
    5: "Two-Hand Mace", 6: "Polearm", 7: "Sword", 8: "Two-Hand Sword",
    10: "Staff", 13: "Fist Weapon", 14: "Misc", 15: "Dagger", 16: "Thrown",
    18: "Crossbow", 19: "Wand", 20: "Fishing Pole",
}
ARMOR = {0: "Misc", 1: "Cloth", 2: "Leather", 3: "Mail", 4: "Plate",
         6: "Shield", 7: "Libram", 8: "Idol", 9: "Totem"}

ENV_FILE = os.path.expanduser("~/.config/tuff/qdb.env")
ENV_KEYS = ("QDB_HOST", "QDB_PORT", "QDB_USER", "QDB_PASSWORD", "QDB_DB")


def decode_mask(mask, table):
    """Names for the set bits of a race/class mask; 'any' when the mask is 0."""
    if not mask or mask < 0:
        return "any"
    names = [name for bit, name in table if mask & bit]
    return ", ".join(names) if names else "unknown (mask %d)" % mask


def decode_races(mask):
    if mask == ALLIANCE_MASK:
        return "Alliance (Human, Dwarf, Night Elf, Gnome)"
    if mask == HORDE_MASK:
        return "Horde (Orc, Undead, Tauren, Troll)"
    return decode_mask(mask, RACES)


def decode_classes(mask):
    return decode_mask(mask, CLASSES)


def _load_env_file():
    try:
        with open(ENV_FILE, "r", encoding="utf-8") as f:
            lines = f.read().splitlines()
    except OSError:
        return {}
    out = {}
    for line in lines:
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        out[k.strip()] = v.strip()
    return out


def connect():
    """Open a read-only connection using the QDB_* settings."""
    try:
        import pymysql
    except ImportError:
        sys.exit("qdb: the pymysql package is required (pacman -S python-pymysql)")
    cfg = {k: os.environ[k] for k in ENV_KEYS if os.environ.get(k)}
    file_cfg = _load_env_file()
    for k in ENV_KEYS:
        cfg.setdefault(k, file_cfg.get(k, ""))
    missing = [k for k in ("QDB_HOST", "QDB_USER", "QDB_PASSWORD", "QDB_DB") if not cfg[k]]
    if missing:
        sys.exit("qdb: missing %s (set them, or create %s)" % (", ".join(missing), ENV_FILE))
    try:
        return pymysql.connect(
            host=cfg["QDB_HOST"], port=int(cfg["QDB_PORT"] or 3306),
            user=cfg["QDB_USER"], password=cfg["QDB_PASSWORD"],
            database=cfg["QDB_DB"], charset="utf8mb4",
            cursorclass=pymysql.cursors.DictCursor, connect_timeout=10,
        )
    except pymysql.MySQLError as e:
        sys.exit("qdb: could not connect to %s:%s: %s" % (cfg["QDB_HOST"], cfg["QDB_PORT"], e))


def query(conn, sql, args=()):
    with conn.cursor() as cur:
        cur.execute(sql, args)
        return list(cur.fetchall())


def _like(text):
    return "%" + text.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_") + "%"


def find_quests(conn, ident):
    """Quest rows matching an ID or a title (exact title wins over substring)."""
    if ident.isdigit():
        return query(conn, "SELECT * FROM quest_template WHERE entry = %s", (int(ident),))
    exact = query(conn, "SELECT * FROM quest_template WHERE Title = %s ORDER BY entry", (ident,))
    if len(exact) == 1:
        return exact
    return query(conn, "SELECT * FROM quest_template WHERE Title LIKE %s ORDER BY entry LIMIT 40",
                 (_like(ident),))


def find_items(conn, ident):
    if ident.isdigit():
        return query(conn, "SELECT * FROM item_template WHERE entry = %s", (int(ident),))
    exact = query(conn, "SELECT * FROM item_template WHERE name = %s ORDER BY entry", (ident,))
    if len(exact) == 1:
        return exact
    return query(conn, "SELECT * FROM item_template WHERE name LIKE %s ORDER BY entry LIMIT 40",
                 (_like(ident),))


def quest_title(conn, entry):
    rows = query(conn, "SELECT Title FROM quest_template WHERE entry = %s", (entry,))
    return rows[0]["Title"] if rows else "?? not in DB"


def quest_ref(conn, entry):
    return "%d %s" % (entry, quest_title(conn, entry))


def _where(conn, table, id_col, ids):
    """'Name (id) map M x,y' for the first spawn of each creature/object id."""
    lines = []
    for i in ids:
        if table == "creature":
            names = query(conn, "SELECT Name AS n FROM creature_template WHERE entry = %s", (i,))
        else:
            names = query(conn, "SELECT name AS n FROM gameobject_template WHERE entry = %s", (i,))
        name = names[0]["n"] if names else "?? not in DB"
        spawns = query(conn, "SELECT map, position_x x, position_y y FROM " + table +
                       " WHERE id = %s ORDER BY guid", (i,))
        if spawns:
            s = spawns[0]
            more = " (+%d more spawns)" % (len(spawns) - 1) if len(spawns) > 1 else ""
            where = "map %d, world %.1f, %.1f%s" % (s["map"], s["x"], s["y"], more)
        else:
            where = "no spawn rows"
        lines.append("%s [%s %d] - %s" % (name, "creature" if table == "creature" else "object", i, where))
    return lines


def quest_givers(conn, entry):
    """(starters, enders) as lists of display lines, all four ways a quest is given or ended."""
    def ids(table, col="id"):
        return [r[col] for r in query(conn, "SELECT id FROM " + table + " WHERE quest = %s ORDER BY id", (entry,))]

    starters = _where(conn, "creature", "id", ids("creature_questrelation"))
    starters += _where(conn, "gameobject", "id", ids("gameobject_questrelation"))
    for r in query(conn, "SELECT entry, name FROM item_template WHERE startquest = %s", (entry,)):
        starters.append("item %s [%d] (use to start)" % (r["name"], r["entry"]))
    enders = _where(conn, "creature", "id", ids("creature_involvedrelation"))
    enders += _where(conn, "gameobject", "id", ids("gameobject_involvedrelation"))
    for r in ids("areatrigger_involvedrelation"):
        enders.append("area trigger [%d] (completes on entering)" % r)
    return starters, enders


def item_line(conn, entry, count=1):
    rows = query(conn, "SELECT * FROM item_template WHERE entry = %s", (entry,))
    if not rows:
        return "%d ?? not in DB" % entry
    it = rows[0]
    head = "%s [%d] x%d" % (it["name"], entry, count) if count != 1 else "%s [%d]" % (it["name"], entry)
    return head + " - " + describe_item_short(it)


def describe_item_short(it):
    slot = SLOTS.get(it["InventoryType"], "")
    kind = ""
    if it["class"] == 2:
        kind = WEAPONS.get(it["subclass"], "Weapon")
    elif it["class"] == 4 and it["InventoryType"] not in (0, 2, 11, 12, 19):
        kind = ARMOR.get(it["subclass"], "")
    bits = [QUALITY.get(it["Quality"], str(it["Quality"]))]
    if kind:
        bits.append(kind)
    if slot and slot not in kind:
        bits.append(slot)
    return " ".join(bits)


def item_detail(it):
    """Multi-line stat block for one item_template row."""
    out = []
    bind = BONDING.get(it["bonding"], "")
    out.append("%s [%d]  %s%s" % (it["name"], it["entry"],
                                  QUALITY.get(it["Quality"], it["Quality"]),
                                  ", " + bind if bind else ""))
    out.append("  type: %s" % describe_item_short(it))
    out.append("  item level %d, required level %d%s" % (
        it["ItemLevel"], it["RequiredLevel"],
        "  (0 here: the level gate may come from the quest's MinLevel)" if it["RequiredLevel"] == 0 else ""))
    if it["class"] == 2 and it["delay"] and it["dmg_max1"]:
        dps = (it["dmg_min1"] + it["dmg_max1"]) / 2.0 / (it["delay"] / 1000.0)
        out.append("  damage %d-%d, speed %.2f (%.1f dps)" % (
            it["dmg_min1"], it["dmg_max1"], it["delay"] / 1000.0, dps))
    if it["armor"]:
        out.append("  armor %d" % it["armor"])
    if it["block"]:
        out.append("  block %d" % it["block"])
    stats = []
    for n in range(1, 11):
        if it["stat_value%d" % n]:
            stats.append("%+d %s" % (it["stat_value%d" % n],
                                     STATS.get(it["stat_type%d" % n], "stat%d" % it["stat_type%d" % n])))
    if stats:
        out.append("  stats: " + ", ".join(stats))
    out.append("  classes: %s   races: %s" % (
        decode_classes(it["AllowableClass"]) if it["AllowableClass"] > 0 else "any",
        decode_mask(it["AllowableRace"], RACES) if it["AllowableRace"] > 0 else "any"))
    if it["startquest"]:
        out.append("  starts quest %d" % it["startquest"])
    return out


def quest_detail(conn, q):
    entry = q["entry"]
    out = ["Quest %d: %s" % (entry, q["Title"]), ""]
    out.append("level %d, requires level %d, zone/sort %d" % (q["QuestLevel"], q["MinLevel"], q["ZoneOrSort"]))
    out.append("races:   %s" % decode_races(q["RequiredRaces"]))
    out.append("classes: %s" % decode_classes(q["RequiredClasses"]))
    if q["RequiredSkill"]:
        out.append("skill:   %d at %d" % (q["RequiredSkill"], q["RequiredSkillValue"]))
    if q["RequiredMinRepFaction"]:
        out.append("min rep: faction %d, value %d" % (q["RequiredMinRepFaction"], q["RequiredMinRepValue"]))

    starters, enders = quest_givers(conn, entry)
    out += ["", "started by:"] + ["  " + s for s in starters or ["(nobody in the DB)"]]
    out += ["", "turned in to:"] + ["  " + s for s in enders or ["(nobody in the DB)"]]

    out += ["", "chain:"]
    prev = q["PrevQuestId"]
    if prev > 0:
        out.append("  requires turned in: %s" % quest_ref(conn, prev))
    elif prev < 0:
        out.append("  requires ACTIVE (in log): %s" % quest_ref(conn, -prev))
    else:
        out.append("  no prerequisite quest")
    if q["BreadcrumbForQuestId"]:
        out.append("  breadcrumb for: %s" % quest_ref(conn, q["BreadcrumbForQuestId"]))
    if q["NextQuestInChain"]:
        out.append("  offers next in chain: %s" % quest_ref(conn, q["NextQuestInChain"]))
    if q["NextQuestId"]:
        out.append("  next quest id: %s" % quest_ref(conn, abs(q["NextQuestId"])))
    grp = q["ExclusiveGroup"]
    if grp:
        members = query(conn, "SELECT entry, Title FROM quest_template WHERE ExclusiveGroup = %s ORDER BY entry", (grp,))
        rule = ("ALTERNATES - taking or finishing one blocks the others" if grp > 0
                else "ALL must be finished to unlock the next quest")
        out.append("  exclusive group %d (%s):" % (grp, rule))
        out += ["    %d %s%s" % (m["entry"], m["Title"], "  <- this" if m["entry"] == entry else "") for m in members]
    for r in query(conn, "SELECT entry, Title, PrevQuestId FROM quest_template "
                         "WHERE ABS(PrevQuestId) = %s OR NextQuestInChain = %s ORDER BY entry", (entry, entry)):
        if r["entry"] != entry:
            how = ("needs this active" if r["PrevQuestId"] == -entry
                   else "needs this turned in" if r["PrevQuestId"] == entry else "chained from this")
            out.append("  leads to: %d %s (%s)" % (r["entry"], r["Title"], how))

    out += ["", "objectives:"]
    if q["SrcItemId"]:
        out.append("  given item at start: %s" % item_line(conn, q["SrcItemId"]))
    got = False
    for n in range(1, 5):
        item, cnt = q["ReqItemId%d" % n], q["ReqItemCount%d" % n]
        if item:
            out.append("  collect: %s" % item_line(conn, item, cnt))
            got = True
    for n in range(1, 5):
        tgt, cnt = q["ReqCreatureOrGOId%d" % n], q["ReqCreatureOrGOCount%d" % n]
        if tgt:
            table = "gameobject" if tgt < 0 else "creature"
            line = _where(conn, table, "id", [abs(tgt)])[0]
            out.append("  kill/use x%d: %s" % (cnt, line))
            got = True
    if not got:
        out.append("  (none recorded: talk/explore quest)")
    if q["Objectives"]:
        out.append("  text: " + " ".join(q["Objectives"].split()))

    out += ["", "rewards:"]
    money = q["RewOrReqMoney"]
    if money > 0:
        out.append("  money: %dg %ds %dc" % (money // 10000, money % 10000 // 100, money % 100))
    elif money < 0:
        out.append("  COSTS %dg %ds %dc to turn in" % (-money // 10000, -money % 10000 // 100, -money % 100))
    for n in range(1, 7):
        if q["RewChoiceItemId%d" % n]:
            out.append("  choose one: " + item_line(conn, q["RewChoiceItemId%d" % n], q["RewChoiceItemCount%d" % n]))
    for n in range(1, 5):
        if q["RewItemId%d" % n]:
            out.append("  always: " + item_line(conn, q["RewItemId%d" % n], q["RewItemCount%d" % n]))
    if q["RewSpell"] or q["RewSpellCast"]:
        out.append("  spell: %d" % (q["RewSpellCast"] or q["RewSpell"]))
    out.append("  (XP is not in the DB)")
    return out


def _print_candidates(rows, fmt):
    print("%d matches, rerun with an ID:" % len(rows))
    for r in rows:
        print("  " + fmt(r))


def cmd_quest(conn, ident):
    rows = find_quests(conn, ident)
    if not rows:
        print("no quest matching %r" % ident)
        return 1
    if len(rows) > 1:
        _print_candidates(rows, lambda r: "%d  %s (lvl %d, min %d, %s / %s)" % (
            r["entry"], r["Title"], r["QuestLevel"], r["MinLevel"],
            decode_races(r["RequiredRaces"]).split(" (")[0], decode_classes(r["RequiredClasses"])))
        return 0
    print("\n".join(quest_detail(conn, rows[0])))
    return 0


def cmd_item(conn, ident):
    rows = find_items(conn, ident)
    if not rows:
        print("no item matching %r" % ident)
        return 1
    if len(rows) > 1:
        _print_candidates(rows, lambda r: "%d  %s (%s)" % (r["entry"], r["name"], describe_item_short(r)))
        return 0
    print("\n".join(item_detail(rows[0])))
    users = query(conn, "SELECT entry, Title FROM quest_template WHERE %s IN (RewChoiceItemId1, RewChoiceItemId2, "
                        "RewChoiceItemId3, RewChoiceItemId4, RewChoiceItemId5, RewChoiceItemId6, RewItemId1, "
                        "RewItemId2, RewItemId3, RewItemId4) ORDER BY entry LIMIT 12", (rows[0]["entry"],))
    if users:
        print("  quest reward from: " + "; ".join("%d %s" % (u["entry"], u["Title"]) for u in users))
    return 0


def main(argv):
    if len(argv) != 3 or argv[1] not in ("quest", "item"):
        print(__doc__)
        return 1
    conn = connect()
    try:
        return cmd_quest(conn, argv[2]) if argv[1] == "quest" else cmd_item(conn, argv[2])
    finally:
        conn.close()


if __name__ == "__main__":
    sys.exit(main(sys.argv))
