#!/usr/bin/env python3
"""Check route files against the local cmangos quest database.

The offline counterpart to the in-game `/tuff verify`: it parses
Routes/**/*.lua, then reports problems. It only reports - it never edits a
route. Quest facts come from the same private-server database as
tools/qdb.py (patch 1.12.1, so "close to Classic Era, not identical"), which
means a finding is a prompt to check, not proof. Route files stay the source
of truth; nothing from the DB is copied into them.

Usage:
    python tools/validate_route.py                    # every file under Routes/
    python tools/validate_route.py Routes/Horde/Durotar.lua
    python tools/validate_route.py --no-db Routes/    # structure checks only
    python tools/validate_route.py --errors-only

Severities:
    ERROR  will misbehave in game (bad ID, class/race mismatch, out-of-order
           prerequisite, turn-in before accept, malformed step)
    WARN   probably wrong or fragile; worth a look
    INFO   only visible from inside this file (e.g. a prerequisite that is
           never in the route, fine if the route starts mid-chain)

Exit status is 1 if any ERROR was reported, else 0.

Checks (DB ones are skipped with --no-db):
    structure   route fields, step types, quest/questName, grind targetLevel,
                x/y range, coords without a map
    existence   quest ID exists; step `name` matches the quest title
    NPC         step `npc` is one of the quest's starters (accept) or
                enders (turnin)
    races       step/route races (raceFile names: Orc, Scourge, NightElf...)
                and route faction against the quest's race mask
    class       step `class` (classFile: ROGUE...) against the class mask, and
                class-locked quests with no class filter
    level       step minLevel below the quest's required level; quest above
                the route's level range
    order       turn-in/complete before accept, duplicate accept/turn-in,
                prerequisites (turned in vs still active), exclusive groups
"""

import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import extract_recording as lua  # noqa: E402  (Lua table parser)
import qdb                       # noqa: E402  (DB access + mask decoding)

STEP_TYPES = {"accept", "turnin", "complete", "grind", "level", "xp", "section",
              "trainer", "death", "manual", "travel", "hearth", "flightpath", "note"}
QUEST_TYPES = ("accept", "turnin", "complete")

# raceFile / classFile names (what Core.StepApplies compares) -> DB mask bit
RACE_BITS = {"Human": 1, "Orc": 2, "Dwarf": 4, "NightElf": 8, "Scourge": 16,
             "Tauren": 32, "Gnome": 64, "Troll": 128}
CLASS_BITS = {"WARRIOR": 1, "PALADIN": 2, "HUNTER": 4, "ROGUE": 8,
              "PRIEST": 16, "SHAMAN": 64, "MAGE": 128, "WARLOCK": 256,
              "DRUID": 1024}
FACTION_MASK = {"Horde": qdb.HORDE_MASK, "Alliance": qdb.ALLIANCE_MASK}
BIT_RACE = {v: k for k, v in RACE_BITS.items()}

SEV_ORDER = {"ERROR": 0, "WARN": 1, "INFO": 2}


# ---------------------------------------------------------------------------
# Reading route files
# ---------------------------------------------------------------------------

def _blank_comments(text):
    """Text with Lua comments replaced by spaces (newlines kept), string-aware."""
    out = []
    i, n = 0, len(text)
    while i < n:
        c = text[i]
        if c in "\"'":
            j = i + 1
            while j < n and text[j] != c:
                j += 2 if text[j] == "\\" else 1
            out.append(text[i:j + 1])
            i = j + 1
        elif text.startswith("--", i):
            m = re.match(r"--\[(=*)\[", text[i:])
            if m:
                end = text.find("]" + m.group(1) + "]", i)
                end = n if end < 0 else end + len(m.group(1)) + 2
            else:
                end = text.find("\n", i)
                end = n if end < 0 else end
            out.append(re.sub(r"[^\n]", " ", text[i:end]))
            i = end
        else:
            out.append(c)
            i += 1
    return "".join(out)


def _match_brace(text, start):
    """(end_index, offsets of depth-3 '{') for the table opening at `start`.

    Depth 1 is the route table, 2 its `steps` table, 3 each step, so the
    depth-3 offsets give the source line of every step."""
    depth, i, n = 0, start, len(text)
    step_offsets = []
    while i < n:
        c = text[i]
        if c in "\"'":
            i += 1
            while i < n and text[i] != c:
                i += 2 if text[i] == "\\" else 1
        elif c == "{":
            depth += 1
            if depth == 3:
                step_offsets.append(i)
        elif c == "}":
            depth -= 1
            if depth == 0:
                return i, step_offsets
        i += 1
    raise lua.LuaParseError("unbalanced braces in route table")


_REGISTER_RE = re.compile(r"""ns\.RegisterRoute\(\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*')\s*,\s*\{""")


def parse_routes(path):
    """[(route_name, route_dict, [step_line or None, ...], route_line)] for a file."""
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        text = _blank_comments(f.read())
    routes = []
    for m in _REGISTER_RE.finditer(text):
        name = lua._unquote(m.group(1))
        open_at = m.end() - 1
        end, offsets = _match_brace(text, open_at)
        table = lua._Parser(lua._tokenize(text[open_at:end + 1])).parse_table()
        if not isinstance(table, dict):
            table = {}
        steps = table.get("steps")
        if isinstance(steps, dict):
            steps = [steps[k] for k in sorted(k for k in steps if isinstance(k, int))]
        table["steps"] = steps if isinstance(steps, list) else []
        lines = [text.count("\n", 0, o) + 1 for o in offsets]
        if len(lines) != len(table["steps"]):
            lines = [None] * len(table["steps"])
        routes.append((name, table, lines, text.count("\n", 0, m.start()) + 1))
    return routes


def find_route_files(paths):
    files = []
    for p in paths:
        if os.path.isdir(p):
            for root, _, names in os.walk(p):
                files += [os.path.join(root, n) for n in sorted(names) if n.endswith(".lua")]
        else:
            files.append(p)
    return sorted(files)


# ---------------------------------------------------------------------------
# Quest facts (cached)
# ---------------------------------------------------------------------------

class QuestDB:
    def __init__(self, conn):
        self.conn = conn
        self._quests, self._npcs, self._preds = {}, {}, {}

    def quest(self, qid):
        if qid not in self._quests:
            rows = qdb.query(self.conn, "SELECT * FROM quest_template WHERE entry = %s", (qid,))
            self._quests[qid] = rows[0] if rows else None
        return self._quests[qid]

    def title(self, qid):
        q = self.quest(qid)
        return q["Title"] if q else "?? not in DB"

    def npcs(self, qid, table):
        """Creature names for creature_questrelation / creature_involvedrelation."""
        key = (qid, table)
        if key not in self._npcs:
            rows = qdb.query(
                self.conn,
                "SELECT DISTINCT c.Name FROM " + table + " r JOIN creature_template c ON c.entry = r.id "
                "WHERE r.quest = %s ORDER BY c.Name", (qid,))
            self._npcs[key] = [r["Name"] for r in rows]
        return self._npcs[key]

    def group_predecessors(self, qid):
        """Quests in a negative exclusive group whose NextQuestId is `qid`."""
        if qid not in self._preds:
            rows = qdb.query(
                self.conn,
                "SELECT entry FROM quest_template WHERE ExclusiveGroup < 0 AND NextQuestId = %s ORDER BY entry",
                (qid,))
            self._preds[qid] = [r["entry"] for r in rows]
        return self._preds[qid]

    def group_members(self, group):
        rows = qdb.query(self.conn, "SELECT entry FROM quest_template WHERE ExclusiveGroup = %s ORDER BY entry",
                         (group,))
        return [r["entry"] for r in rows]


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

class Report:
    def __init__(self):
        self.items = []   # (sev, line, step_no, text)

    def add(self, sev, line, step_no, text):
        self.items.append((sev, line, step_no, text))

    def count(self, sev):
        return sum(1 for i in self.items if i[0] == sev)


def _names(mask, bits):
    return ", ".join(n for n, b in sorted(bits.items(), key=lambda kv: kv[1]) if mask & b) or "none"


def _filter(step):
    races = step.get("races")
    return (tuple(sorted(races)) if isinstance(races, list) else None, step.get("class"))


def _compat(prior, cur):
    return prior == cur or prior == (None, None) or cur == (None, None)


def _race_mask(names, report, line, no):
    mask = 0
    for r in names:
        if r in RACE_BITS:
            mask |= RACE_BITS[r]
        else:
            report.add("WARN", line, no, "unknown race name %r (expected a raceFile such as Orc, Scourge, NightElf)" % r)
    return mask


def check_structure(route, lines, report):
    if route.get("faction") not in FACTION_MASK:
        report.add("WARN", None, None, "route `faction` should be \"Horde\" or \"Alliance\" (got %r)" % route.get("faction"))
    if not isinstance(route.get("races"), list) or not route.get("races"):
        report.add("WARN", None, None, "route has no `races` list")
    lv = route.get("levels")
    if not (isinstance(lv, list) and len(lv) == 2 and all(isinstance(x, (int, float)) for x in lv)):
        report.add("WARN", None, None, "route `levels` should be { min, max }")
    if not route["steps"]:
        report.add("ERROR", None, None, "route has no steps")

    for no, step in enumerate(route["steps"], 1):
        line = lines[no - 1]
        if not isinstance(step, dict):
            report.add("ERROR", line, no, "step is not a table")
            continue
        stype = step.get("type")
        if stype not in STEP_TYPES:
            report.add("ERROR", line, no, "unknown step type %r" % (stype,))
        if stype in QUEST_TYPES:
            if not isinstance(step.get("quest"), int):
                if not (isinstance(step.get("questName"), str) and step["questName"]):
                    report.add("ERROR", line, no, "%s step needs a numeric `quest` or a `questName`" % stype)
        if stype in ("grind", "level") and not isinstance(step.get("targetLevel"), (int, float)):
            report.add("ERROR", line, no, "%s step needs `targetLevel`" % stype)
        if stype == "section" and not step.get("name"):
            report.add("WARN", line, no, "section step has no `name`")
        if stype == "xp":
            xp = step.get("xp")
            if not (isinstance(xp, dict) and isinstance(xp.get("level"), (int, float))):
                report.add("ERROR", line, no, "xp step needs xp = { level = n, pct = n }")
            elif xp.get("pct") is not None and not (isinstance(xp["pct"], (int, float)) and 0 <= xp["pct"] <= 100):
                report.add("ERROR", line, no, "xp.pct should be 0-100")
        if stype == "flightpath" and not (step.get("mapID") and (step.get("node") or step.get("name"))):
            report.add("ERROR", line, no, "flightpath step needs mapID and node or name")
        if stype == "complete" and step.get("objective") is not None \
                and not isinstance(step["objective"], (int, float)):
            report.add("ERROR", line, no, "objective should be a number")
        if step.get("skipIfLevel") is not None and not isinstance(step["skipIfLevel"], (int, float)):
            report.add("ERROR", line, no, "skipIfLevel should be a number")
        if "requires" in step:
            req = step["requires"]
            if not isinstance(req, list):
                report.add("ERROR", line, no, "requires should be a list of step numbers")
            else:
                for idx in req:
                    if not (isinstance(idx, int) and 1 <= idx <= len(route["steps"])):
                        report.add("ERROR", line, no,
                                    "requires references step %r, which isn't in this route" % (idx,))
                    elif idx == no:
                        report.add("ERROR", line, no, "requires references itself")
        for axis in ("x", "y"):
            v = step.get(axis)
            if isinstance(v, (int, float)) and not 0 <= v <= 100:
                report.add("ERROR", line, no, "%s should be 0-100 (got %s)" % (axis, v))
        if (step.get("x") is not None or step.get("y") is not None) and not step.get("map"):
            report.add("ERROR", line, no, "has coordinates but no `map` (uiMapID)")
        for key in ("races",):
            if key in step and not isinstance(step[key], list):
                report.add("ERROR", line, no, "`%s` must be a list of names" % key)


def _quest_label(db, qid):
    return "%d %s" % (qid, db.title(qid))


def check_quests(route, lines, db, report):
    steps = route["steps"]
    route_races = route.get("races") if isinstance(route.get("races"), list) else []
    faction_mask = FACTION_MASK.get(route.get("faction"), 0)
    route_mask = 0
    scratch = Report()
    if route_races:
        route_mask = _race_mask(route_races, scratch, None, None)
    levels = route.get("levels") if isinstance(route.get("levels"), list) else None
    unresolved = 0

    # every quest step in order: (step_no, type, quest, filter)
    events = [(no, s.get("type"), s.get("quest"), _filter(s))
              for no, s in enumerate(steps, 1)
              if isinstance(s, dict) and s.get("type") in QUEST_TYPES and isinstance(s.get("quest"), int)]

    def prior(kind, qid, no, cur):
        return [e for e in events if e[0] < no and e[1] == kind and e[2] == qid and _compat(e[3], cur)]

    def later(kind, qid, no, cur):
        return [e for e in events if e[0] > no and e[1] == kind and e[2] == qid and _compat(e[3], cur)]

    reported_missing = set()
    for no, step in enumerate(steps, 1):
        if not isinstance(step, dict) or step.get("type") not in QUEST_TYPES:
            continue
        line = lines[no - 1]
        qid, stype = step.get("quest"), step["type"]
        if not isinstance(qid, int):
            unresolved += 1
            continue
        q = db.quest(qid)
        if q is None:
            if qid not in reported_missing:
                report.add("ERROR", line, no, "quest %d not found in the database (typo, or added after 1.12)" % qid)
                reported_missing.add(qid)
            continue
        cur = _filter(step)
        who = "%s %d %s" % (stype, qid, q["Title"])

        # name
        name = step.get("name")
        if isinstance(name, str) and name.strip().casefold() != q["Title"].strip().casefold():
            report.add("WARN", line, no, "%s: step name %r differs from DB title %r" % (who, name, q["Title"]))

        # NPC
        npc = step.get("npc")
        if isinstance(npc, str) and stype in ("accept", "turnin"):
            db_npcs = db.npcs(qid, "creature_questrelation" if stype == "accept" else "creature_involvedrelation")
            if db_npcs and npc.strip().casefold() not in (n.casefold() for n in db_npcs):
                report.add("WARN", line, no, "%s: npc %r is not a %s in the DB (%s)" % (
                    who, npc, "starter" if stype == "accept" else "ender", ", ".join(db_npcs)))

        # races
        allowed = q["RequiredRaces"]
        if allowed > 0:
            if isinstance(step.get("races"), list):
                mask = _race_mask(step["races"], scratch, None, None)
                origin = "step races"
            else:
                mask = route_mask or faction_mask
                origin = "route races" if route_mask else "route faction"
            if mask and not mask & allowed:
                report.add("ERROR", line, no, "%s: no %s can take it; quest is for %s" % (
                    who, origin, qdb.decode_races(allowed)))
            elif mask and mask & ~allowed:
                report.add("WARN", line, no, "%s: %s include %s, which the quest excludes%s" % (
                    who, origin, _names(mask & ~allowed, RACE_BITS),
                    "" if origin == "step races" else " (add a `races` filter to the step)"))
        # (step.races broader than the route's own races is not an error; the route may be shared)

        # class
        allowed_c = q["RequiredClasses"]
        cls = step.get("class")
        if cls is not None and cls not in CLASS_BITS:
            report.add("WARN", line, no, "unknown class %r (expected a classFile such as ROGUE)" % (cls,))
        elif allowed_c > 0:
            if cls is None:
                report.add("WARN", line, no,
                           "%s: quest is %s-only but the step has no `class` filter; every other class stalls here"
                           % (who, qdb.decode_classes(allowed_c)))
            elif not CLASS_BITS[cls] & allowed_c:
                report.add("ERROR", line, no, "%s: step class %s cannot take it; quest is %s-only" % (
                    who, cls, qdb.decode_classes(allowed_c)))

        # level
        ml = step.get("minLevel")
        if stype == "accept":
            if isinstance(ml, (int, float)) and ml < q["MinLevel"]:
                report.add("WARN", line, no, "%s: step minLevel %d is below the quest's required level %d" % (
                    who, ml, q["MinLevel"]))
            if levels and isinstance(levels[1], (int, float)) and q["MinLevel"] > levels[1]:
                report.add("WARN", line, no, "%s: quest needs level %d, above this route's range (%s-%s)" % (
                    who, q["MinLevel"], levels[0], levels[1]))

        # order
        if stype == "accept":
            dup = prior("accept", qid, no, cur)
            if dup:
                report.add("WARN", line, no, "%s: already accepted at step %d" % (who, dup[0][0]))
            done = prior("turnin", qid, no, cur)
            if done:
                report.add("WARN", line, no, "%s: accepted after it was turned in at step %d" % (who, done[0][0]))
            _check_prereq(db, q, qid, no, line, cur, who, report, prior, later)
        else:
            if stype == "turnin":
                dup = prior("turnin", qid, no, cur)
                if dup:
                    report.add("WARN", line, no, "%s: already turned in at step %d" % (who, dup[0][0]))
            if not prior("accept", qid, no, cur):
                late = later("accept", qid, no, cur)
                if late:
                    report.add("ERROR", line, no, "%s: %s comes before the accept at step %d" % (who, stype, late[0][0]))
                else:
                    report.add("INFO", line, no, "%s: never accepted in this route (fine if picked up before it, "
                               "or started by an item/object)" % who)
    if unresolved:
        report.add("INFO", None, None, "%d quest step(s) use `questName` and cannot be checked offline" % unresolved)


def _check_prereq(db, q, qid, no, line, cur, who, report, prior, later):
    prev = q["PrevQuestId"]
    if prev > 0:
        if not prior("turnin", prev, no, cur):
            late = later("turnin", prev, no, cur)
            if late:
                report.add("ERROR", line, no, "%s: prerequisite %s is turned in later (step %d)" % (
                    who, _quest_label(db, prev), late[0][0]))
            else:
                report.add("INFO", line, no, "%s: prerequisite %s is not turned in anywhere in this route" % (
                    who, _quest_label(db, prev)))
    elif prev < 0:
        p = -prev
        acc = prior("accept", p, no, cur)
        if acc:
            if prior("turnin", p, no, cur):
                report.add("WARN", line, no, "%s: needs %s still ACTIVE, but it was already turned in" % (
                    who, _quest_label(db, p)))
        else:
            late = later("accept", p, no, cur)
            if late:
                report.add("ERROR", line, no, "%s: needs %s active, which is only accepted later (step %d)" % (
                    who, _quest_label(db, p), late[0][0]))
            else:
                report.add("INFO", line, no, "%s: needs %s active; never accepted in this route" % (
                    who, _quest_label(db, p)))

    grp = q["ExclusiveGroup"]
    if grp > 0:
        for m in db.group_members(grp):
            if m != qid and prior("accept", m, no, cur):
                report.add("WARN", line, no, "%s: exclusive-group alternate %s was already accepted" % (
                    who, _quest_label(db, m)))
    for m in db.group_predecessors(qid):
        if not prior("turnin", m, no, cur):
            late = later("turnin", m, no, cur)
            if late:
                report.add("ERROR", line, no, "%s: group quest %s must be finished first (turned in at step %d)" % (
                    who, _quest_label(db, m), late[0][0]))
            elif prior("accept", m, no, cur) or later("accept", m, no, cur):
                report.add("WARN", line, no, "%s: group quest %s is accepted but never turned in" % (
                    who, _quest_label(db, m)))
            else:
                report.add("INFO", line, no, "%s: group quest %s is not in this route" % (who, _quest_label(db, m)))


# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------

def validate_file(path, db, errors_only):
    """Print findings for one file; returns (errors, warns, infos)."""
    totals = [0, 0, 0]
    try:
        routes = parse_routes(path)
    except OSError as e:
        print("%s: could not read: %s" % (path, e))
        return 1, 0, 0
    except lua.LuaParseError as e:
        # This parser only understands literal table data, not real Lua
        # (no variables, loops, function calls). A file like
        # Routes/Horde/Solo/Register.lua legitimately builds `steps` from
        # a loop over other files' contributions - WoW's actual Lua
        # interpreter runs that fine, only this offline tool's simplified
        # parser can't. Unbalanced braces mean the file is actually
        # broken (WoW's interpreter would fail too); anything else here
        # just means "not a literal table", which isn't necessarily wrong.
        if "unbalanced braces" in str(e):
            print("%s: could not parse: %s" % (path, e))
            return 1, 0, 0
        print("%s: not a literal step table (probably built with real Lua "
              "code - not checkable by this tool, not necessarily wrong): %s" % (path, e))
        return 0, 1, 0
    if not routes:
        print("%s: no ns.RegisterRoute call found" % path)
        return 0, 1, 0
    for name, route, lines, route_line in routes:
        report = Report()
        check_structure(route, lines, report)
        if db:
            check_quests(route, lines, db, report)
        shown = [i for i in report.items if not (errors_only and i[0] != "ERROR")]
        shown.sort(key=lambda i: (i[2] if i[2] is not None else 0, SEV_ORDER[i[0]]))
        errs, warns, infos = (report.count(s) for s in ("ERROR", "WARN", "INFO"))
        print("%s  route %r  (%d steps): %d error(s), %d warning(s), %d info" % (
            path, name, len(route["steps"]), errs, warns, infos))
        for sev, line, no, text in shown:
            where = ("line %d, step %d" % (line, no)) if line and no else ("step %d" % no if no else "route")
            print("  %-5s %s: %s" % (sev, where, text))
        totals[0] += errs
        totals[1] += warns
        totals[2] += infos
    return tuple(totals)


def main(argv):
    args = argv[1:]
    use_db = "--no-db" not in args
    errors_only = "--errors-only" in args
    if "-h" in args or "--help" in args:
        print(__doc__)
        return 0
    paths = [a for a in args if not a.startswith("--")]
    if not paths:
        paths = [os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "Routes")]
    files = find_route_files(paths)
    if not files:
        print("no .lua files found in: %s" % " ".join(paths))
        return 1

    db, conn = None, None
    if use_db:
        conn = qdb.connect()
        db = QuestDB(conn)
    try:
        total = [0, 0, 0]
        for f in files:
            for i, n in enumerate(validate_file(f, db, errors_only)):
                total[i] += n
    finally:
        if conn:
            conn.close()
    print("\n%d file(s): %d error(s), %d warning(s), %d info%s" % (
        len(files), total[0], total[1], total[2],
        "" if use_db else "  (--no-db: quest checks skipped)"))
    if use_db:
        print("DB is cmangos 1.12.1: a finding means 'check it', not 'wrong' (Era 1.15 differs).")
    return 1 if total[0] else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
