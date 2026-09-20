#!/usr/bin/env python3
"""Merge multiple recordings of the same content into one route.

Two (or more) people recording the same zone will disagree here and
there: different play order, slightly different coordinates, a quest one
of them skipped. This groups their recorded steps by quest ID, takes the
median of each step's recorded coordinates, keeps whichever step order
was most common across the inputs, and writes a conflict report for
anything it can't resolve on its own.

This is a merging AID, not an authority - see CONTRIBUTING.md and
README.md's "Why it's built this way": the merged file still needs a
human read-through and /tuff verify or validate_route.py before it's a
route anyone should trust. This tool proposes; a person decides.

Usage:
    python tools/merge_routes.py RecordingA.lua RecordingB.lua -o Merged.lua
    python tools/merge_routes.py Routes/legA.lua Routes/legB.lua   # prints to stdout

The conflict report always goes to stderr, so it's visible either way.

Limitations (read before trusting the output):
  - Only quest-keyed steps (accept/turnin/complete with a numeric quest
    ID) are actually cross-referenced and deduplicated across inputs.
    Everything else (section, note, grind, travel, hearth, death,
    trainer, manual, flightpath, xp) is taken from the FIRST input file
    only, since those step types have no natural cross-recording join
    key - review the other recordings by hand for anything only they
    captured.
  - Step order is approximated by each step's average position (as a
    fraction of its own recording's length) across every recording it
    appears in. This is not a true sequence alignment/diff - a real
    reordering between recordings will not be perfectly reconstructed,
    just approximated. Read the merged order before trusting it.
"""

import os
import statistics
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import extract_recording as lua  # noqa: E402  (Lua table parser, string escaping)
from validate_route import parse_routes  # noqa: E402  (route-file reader)

QUEST_TYPES = ("accept", "turnin", "complete")


def load_inputs(paths):
    """[(path, route_name, route_dict, [step, ...])] - the first route
    found per file. route_dict is the full parsed route table (faction,
    races, levels, format, client, class, recordedAt, ...), not just its
    steps, so callers can check export metadata across inputs too."""
    out = []
    for path in paths:
        try:
            routes = parse_routes(path)
        except (lua.LuaParseError, OSError) as e:
            sys.stderr.write("%s: could not parse, skipping: %s\n" % (path, e))
            continue
        if not routes:
            sys.stderr.write("%s: no ns.RegisterRoute call found, skipping\n" % path)
            continue
        name, route, _, _ = routes[0]
        steps = route.get("steps") or []
        out.append((path, name, route, steps))
    return out


def check_export_format(inputs, conflicts):
    """Warns (via conflicts) if the inputs' Recorder.lua `format` numbers
    disagree - a newer/older export shape a mismatched addon version
    produced might not merge cleanly even if it parses without error."""
    seen = {}
    for path, _, route, _ in inputs:
        fmt = route.get("format")
        seen.setdefault(fmt, []).append(os.path.basename(path))
    if len(seen) > 1:
        conflicts.append(
            "export format mismatch across inputs - " + "; ".join(
                "format %s: %s" % (fmt, ", ".join(files))
                for fmt, files in sorted(seen.items(), key=lambda kv: (kv[0] is None, kv[0]))))


def _mode(values):
    """(most_common_value, {value: count}) for the non-empty values given,
    or None if there aren't any. Ties break by first-seen order."""
    values = [v for v in values if v]
    if not values:
        return None
    counts = {}
    order = []
    for v in values:
        if v not in counts:
            order.append(v)
        counts[v] = counts.get(v, 0) + 1
    order.sort(key=lambda v: -counts[v])
    return order[0], counts


def merge_quest_steps(inputs, conflicts):
    """{(quest, type): (avg_fractional_position, merged_step)}."""
    # Fields merged by explicit mode/median logic below, with conflict
    # detection - everything else on a step is carried through verbatim
    # (see the loop over `entries[0][1]` near the end) rather than only
    # ever emitting this fixed set, so nothing (races, class, minLevel,
    # skipIfLevel, optional, requires, path, objective, xp, mapID, node,
    # or any future field) is silently dropped from the merged output.
    HANDLED = {"type", "quest", "name", "npc", "map", "note", "x", "y"}

    groups = {}
    for path, _, _, steps in inputs:
        n = max(1, len(steps))
        for i, step in enumerate(steps):
            if not isinstance(step, dict) or step.get("type") not in QUEST_TYPES:
                continue
            qid = step.get("quest")
            if not isinstance(qid, int):
                continue
            # `complete` steps may legitimately repeat for the same quest
            # with a different `objective` (Phase E1) - keying on quest+
            # type alone would collapse two genuinely different steps
            # (different objectives, different locations) into one.
            key = (qid, step["type"], step.get("objective"))
            groups.setdefault(key, []).append((path, step, i / n))

    all_paths = {path for path, _, _, _ in inputs}
    merged = {}

    for key, entries in groups.items():
        qid, stype, objective = key
        who = "%s quest %d" % (stype, qid)
        if objective is not None:
            who += " objective %s" % objective
        present_in = {path for path, _, _ in entries}

        missing_from = all_paths - present_in
        if missing_from:
            conflicts.append(
                "%s: recorded in %d of %d inputs (missing from: %s)" % (
                    who, len(present_in), len(all_paths),
                    ", ".join(sorted(os.path.basename(p) for p in missing_from))))

        name_mode = _mode(s.get("name") for _, s, _ in entries)
        npc_mode = _mode(s.get("npc") for _, s, _ in entries)
        map_mode = _mode(s.get("map") for _, s, _ in entries)

        if npc_mode and len(npc_mode[1]) > 1:
            conflicts.append("%s: npc disagreement - %s" % (
                who, ", ".join("%r (%dx)" % (k, v) for k, v in npc_mode[1].items())))
        if map_mode and len(map_mode[1]) > 1:
            conflicts.append("%s: map disagreement - %s" % (
                who, ", ".join("%r (%dx)" % (k, v) for k, v in map_mode[1].items())))

        step = {"type": stype, "quest": qid}
        if name_mode:
            step["name"] = name_mode[0]
        if npc_mode:
            step["npc"] = npc_mode[0]
        if map_mode:
            step["map"] = map_mode[0]
        for _, s, _ in entries:
            if s.get("note"):
                step["note"] = s["note"]
                break

        xs = [s["x"] for _, s, _ in entries if isinstance(s.get("x"), (int, float))]
        ys = [s["y"] for _, s, _ in entries if isinstance(s.get("y"), (int, float))]
        if xs and ys and len(xs) == len(ys):
            step["x"] = round(statistics.median(xs), 1)
            step["y"] = round(statistics.median(ys), 1)
            if len(xs) > 1 and (max(xs) - min(xs) > 5 or max(ys) - min(ys) > 5):
                conflicts.append(
                    "%s: coordinates vary by more than 5 (x: %.1f-%.1f, y: %.1f-%.1f) - "
                    "median used, double check" % (who, min(xs), max(xs), min(ys), max(ys)))

        # Anything not explicitly merged above: first non-None value seen
        # wins. These fields (races, class, minLevel, requires, etc.) are
        # far more likely to be uniformly present/absent across an honest
        # recording than independently disagreed-upon per person, so
        # mode/conflict-detection isn't worth building out for them too.
        for _, s, _ in entries:
            for k, v in s.items():
                if k not in HANDLED and k not in step and v is not None:
                    step[k] = v

        position = statistics.mean(p for _, _, p in entries)
        merged[key] = (position, step)

    return merged


def merge_other_steps(inputs):
    """Non-quest-keyed steps, taken from the first input only (see the
    module docstring's Limitations section)."""
    if not inputs:
        return []
    _, _, _, steps = inputs[0]
    n = max(1, len(steps))
    return [(i / n, step) for i, step in enumerate(steps)
            if isinstance(step, dict) and step.get("type") not in QUEST_TYPES]


def _serialize_value(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        return ("%g" % value) if value == value else "0"  # NaN guard, shouldn't occur
    if isinstance(value, str):
        return '"%s"' % lua._escape_lua(value)
    if isinstance(value, list):
        return "{ " + ", ".join(_serialize_value(v) for v in value) + " }"
    if isinstance(value, dict):
        int_keys = [k for k in value if isinstance(k, int)]
        if int_keys and sorted(int_keys) == list(range(1, len(value) + 1)):
            return "{ " + ", ".join(_serialize_value(value[k]) for k in sorted(int_keys)) + " }"
        parts = []
        for k, v in value.items():
            if isinstance(k, str) and k.isidentifier():
                parts.append("%s = %s" % (k, _serialize_value(v)))
            else:
                parts.append("[%s] = %s" % (_serialize_value(k), _serialize_value(v)))
        return "{ " + ", ".join(parts) + " }"
    return "nil"


# Preferred key order for a readable diff; any field not listed here still
# gets emitted (see build_merged_route), just after these.
_STEP_KEY_ORDER = [
    "type", "quest", "questName", "name", "npc", "zone", "map", "x", "y",
    "note", "targetLevel", "xp", "objective", "levels", "path",
    "mapID", "node", "minLevel", "skipIfLevel", "optional", "requires",
    "races", "class",
]


def _serialize_step(step):
    parts = []
    seen = set()
    for key in _STEP_KEY_ORDER:
        if key in step and step[key] is not None:
            parts.append("%s = %s" % (key, _serialize_value(step[key])))
            seen.add(key)
    for key, value in step.items():
        if key not in seen and value is not None:
            parts.append("%s = %s" % (key, _serialize_value(value)))
    return "{ " + ", ".join(parts) + " }"


def build_merged_route(inputs, route_name):
    conflicts = []
    check_export_format(inputs, conflicts)
    quest_groups = merge_quest_steps(inputs, conflicts)
    other = merge_other_steps(inputs)

    combined = list(quest_groups.values()) + other
    combined.sort(key=lambda pair: pair[0])
    ordered_steps = [step for _, step in combined]

    lines = ["-- Merged with tools/merge_routes.py from:"]
    for path, name, _, steps in inputs:
        lines.append("--   %s (route %r, %d steps)" % (path, name, len(steps)))
    lines.append("-- Read the conflict report this tool printed (stderr) before trusting this.")
    lines.append("")
    lines.append("local ADDON, ns = ...")
    lines.append("")
    lines.append('ns.RegisterRoute("%s", {' % lua._escape_lua(route_name))
    lines.append('    faction = "Horde", -- FIXME: confirm')
    lines.append('    races   = { "Orc" }, -- FIXME: confirm')
    lines.append("    levels  = { 1, 60 }, -- FIXME: confirm")
    lines.append("")
    lines.append("    steps = {")

    for step in ordered_steps:
        if not isinstance(step, dict):
            continue
        lines.append("        " + _serialize_step(step) + ",")

    lines.append("    },")
    lines.append("})")
    return "\n".join(lines), conflicts


def main(argv):
    args = argv[1:]
    if not args or "-h" in args or "--help" in args:
        print(__doc__)
        return 0 if args else 1

    out_path = None
    if "-o" in args:
        idx = args.index("-o")
        if idx + 1 >= len(args):
            sys.stderr.write("-o needs a path.\n")
            return 1
        out_path = args[idx + 1]
        args = args[:idx] + args[idx + 2:]

    if len(args) < 2:
        sys.stderr.write("Need at least 2 route files to merge.\n")
        return 1

    inputs = load_inputs(args)
    if len(inputs) < 2:
        sys.stderr.write("Fewer than 2 files parsed successfully - nothing to merge.\n")
        return 1

    route_name = "Merged: " + " + ".join(name for _, name, _, _ in inputs)
    text, conflicts = build_merged_route(inputs, route_name)

    if out_path:
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(text + "\n")
        sys.stderr.write("Wrote %s\n" % out_path)
    else:
        print(text)

    sys.stderr.write("\n%d conflict(s):\n" % len(conflicts))
    for c in conflicts:
        sys.stderr.write("  - %s\n" % c)
    if not conflicts:
        sys.stderr.write("  (none)\n")

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
