#!/usr/bin/env python3
"""Recover a TuFFlevels recording after a Forever relog.

Forever (the _classic_beta_ client) writes SavedVariables to disk on exit
but never reads them back on login, so a recording in progress looks like
it vanished. It didn't - it's still sitting in the account's SavedVariables
file. This script parses that file directly and prints the same route text
the in-game "Save this as a route" export window would have produced.

Usage:
    python tools/extract_recording.py "<path to>/WTF/Account/<ACCOUNT>/SavedVariables/TuFFlevels.lua"

The output goes to stdout. Redirect it into a file under Routes/ to use it:
    python tools/extract_recording.py TuFFlevels.lua > Routes/Recovered.lua

Faction, race and the level range aren't stored per recorded step, so they
come out as placeholders - fill them in before the route is used.
"""

import re
import sys


class LuaParseError(Exception):
    pass


_TOKEN_RE = re.compile(r"""
      (?P<WS>\s+)
    | (?P<COMMENT>--\[\[.*?\]\]|--[^\n]*)
    | (?P<STRING>"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*')
    | (?P<NUMBER>-?\d+\.?\d*(?:[eE][-+]?\d+)?)
    | (?P<LBRACE>\{)
    | (?P<RBRACE>\})
    | (?P<LBRACKET>\[)
    | (?P<RBRACKET>\])
    | (?P<EQUALS>=)
    | (?P<COMMA>,)
    | (?P<SEMI>;)
    | (?P<IDENT>[A-Za-z_][A-Za-z0-9_]*)
""", re.VERBOSE | re.DOTALL)


def _tokenize(text):
    tokens = []
    pos = 0
    while pos < len(text):
        m = _TOKEN_RE.match(text, pos)
        if not m:
            raise LuaParseError("Unrecognized text near: %r" % text[pos:pos + 40])
        pos = m.end()
        kind = m.lastgroup
        if kind in ("WS", "COMMENT"):
            continue
        tokens.append((kind, m.group()))
    return tokens


def _unquote(s):
    body = s[1:-1]
    return body.encode("utf-8").decode("unicode_escape")


class _Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.i = 0

    def peek(self):
        return self.tokens[self.i] if self.i < len(self.tokens) else (None, None)

    def next(self):
        tok = self.peek()
        self.i += 1
        return tok

    def expect(self, kind):
        k, v = self.next()
        if k != kind:
            raise LuaParseError("Expected %s, got %s (%r)" % (kind, k, v))
        return v

    def parse_value(self):
        kind, val = self.peek()
        if kind == "LBRACE":
            return self.parse_table()
        if kind == "STRING":
            self.next()
            return _unquote(val)
        if kind == "NUMBER":
            self.next()
            return float(val) if ("." in val or "e" in val or "E" in val) else int(val)
        if kind == "IDENT" and val in ("true", "false"):
            self.next()
            return val == "true"
        if kind == "IDENT" and val == "nil":
            self.next()
            return None
        raise LuaParseError("Unexpected token %s (%r) in value position" % (kind, val))

    def parse_table(self):
        self.expect("LBRACE")
        array = []
        fields = {}
        while True:
            kind, val = self.peek()
            if kind == "RBRACE":
                self.next()
                break
            if kind == "LBRACKET":
                self.next()
                key = self.parse_value()
                self.expect("RBRACKET")
                self.expect("EQUALS")
                value = self.parse_value()
                fields[key] = value
            elif kind == "IDENT" and self.tokens[self.i + 1][0] == "EQUALS":
                key = val
                self.next()
                self.next()
                value = self.parse_value()
                fields[key] = value
            else:
                array.append(self.parse_value())

            kind, _ = self.peek()
            if kind in ("COMMA", "SEMI"):
                self.next()
            elif kind == "RBRACE":
                continue
            else:
                raise LuaParseError("Expected , or } , got %s" % (kind,))

        if array and not fields:
            return array
        for idx, item in enumerate(array, start=1):
            fields[idx] = item
        return fields


def parse_lua_assignments(text):
    """Returns {global_name: value} for every top-level `Name = {...}` in the file."""
    tokens = _tokenize(text)
    out = {}
    i = 0
    while i < len(tokens):
        kind, val = tokens[i]
        if kind == "IDENT" and i + 1 < len(tokens) and tokens[i + 1][0] == "EQUALS":
            name = val
            p = _Parser(tokens[i + 2:])
            value = p.parse_value()
            out[name] = value
            i = i + 2 + p.i
            continue
        i += 1
    return out


KIND_TO_TYPE = {
    "section": "section",
    "accept": "accept",
    "turnin": "turnin",
    "level": "grind",
    "travel": "travel",
    "note": "note",
}


def _escape_lua(s):
    return str(s).replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ")


def build_route_text(record_log, route_name="Recovered Route"):
    out = []
    out.append("-- Recovered with tools/extract_recording.py from a SavedVariables file")
    out.append("-- Forever didn't restore this recording in-game; it was pulled from disk.")
    out.append("-- Faction/race/levels below are placeholders - the log doesn't carry them.")
    out.append("")
    out.append("local ADDON, ns = ...")
    out.append("")
    out.append('ns.RegisterRoute("%s", {' % _escape_lua(route_name))
    out.append('    faction = "Horde", -- FIXME: fill in')
    out.append('    races   = { "Orc" }, -- FIXME: fill in')

    levels = [e.get("level") for e in record_log if isinstance(e, dict) and e.get("level")]
    first_level = levels[0] if levels else 1
    last_level = levels[-1] if levels else 60
    out.append("    levels  = { %s, %s }," % (first_level, last_level))
    out.append("")
    out.append("    steps = {")

    last_level_seen = None
    for e in record_log:
        if not isinstance(e, dict):
            continue
        step_type = KIND_TO_TYPE.get(e.get("kind"))
        if not step_type:
            continue

        parts = ['type = "%s"' % step_type]

        if e.get("questID") is not None:
            parts.append("quest = %d" % int(e["questID"]))
        if e.get("title"):
            parts.append('name = "%s"' % _escape_lua(e["title"]))
        if e.get("npc"):
            parts.append('npc = "%s"' % _escape_lua(e["npc"]))
        if e.get("map") is not None:
            parts.append("map = %d" % int(e["map"]))
        if e.get("x") is not None and e.get("y") is not None:
            parts.append("x = %.1f, y = %.1f" % (float(e["x"]), float(e["y"])))
        if e.get("note"):
            parts.append('note = "%s"' % _escape_lua(e["note"]))

        if step_type == "section":
            band = e.get("level")
            parts.append("levels = { %s, %s }" % (band, band))

        if step_type != "section" and e.get("level") is not None and e["level"] != last_level_seen:
            parts.append("minLevel = %s" % e["level"])
            last_level_seen = e["level"]

        out.append("        { " + ", ".join(parts) + " },")

    out.append("    },")
    out.append("})")
    return "\n".join(out)


def main(argv):
    if len(argv) != 2:
        print(__doc__)
        return 1

    path = argv[1]
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        text = f.read()

    try:
        globals_ = parse_lua_assignments(text)
    except LuaParseError as e:
        sys.stderr.write("Could not parse %s: %s\n" % (path, e))
        return 1

    db = globals_.get("TuFFlevelsDB")
    if not isinstance(db, dict):
        sys.stderr.write("No TuFFlevelsDB table found in %s\n" % path)
        return 1

    record_log = db.get("recordLog")
    if isinstance(record_log, dict):
        # A table with only integer keys still round-trips through
        # _Parser.parse_table as a plain list; a dict here means the log
        # had gaps or non-sequential keys, so keep any that are ordered ints.
        entries = [record_log[k] for k in sorted(
            (k for k in record_log if isinstance(k, int)))]
    elif isinstance(record_log, list):
        entries = record_log
    else:
        entries = []

    if not entries:
        sys.stderr.write("TuFFlevelsDB has no recordLog entries.\n")
        return 1

    print(build_route_text(entries))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
