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
    """[(path, route_name, [step, ...])] - the first route found per file."""
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
        out.append((path, name, steps))
    return out


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
    groups = {}
    for path, _, steps in inputs:
        n = max(1, len(steps))
        for i, step in enumerate(steps):
            if not isinstance(step, dict) or step.get("type") not in QUEST_TYPES:
                continue
            qid = step.get("quest")
            if not isinstance(qid, int):
                continue
            groups.setdefault((qid, step["type"]), []).append((path, step, i / n))

    all_paths = {path for path, _, _ in inputs}
    merged = {}

    for key, entries in groups.items():
        qid, stype = key
        who = "%s quest %d" % (stype, qid)
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

        position = statistics.mean(p for _, _, p in entries)
        merged[key] = (position, step)

    return merged


def merge_other_steps(inputs):
    """Non-quest-keyed steps, taken from the first input only (see the
    module docstring's Limitations section)."""
    if not inputs:
        return []
    _, _, steps = inputs[0]
    n = max(1, len(steps))
    return [(i / n, step) for i, step in enumerate(steps)
            if isinstance(step, dict) and step.get("type") not in QUEST_TYPES]


def build_merged_route(inputs, route_name):
    conflicts = []
    quest_groups = merge_quest_steps(inputs, conflicts)
    other = merge_other_steps(inputs)

    combined = list(quest_groups.values()) + other
    combined.sort(key=lambda pair: pair[0])
    ordered_steps = [step for _, step in combined]

    lines = ["-- Merged with tools/merge_routes.py from:"]
    for path, name, steps in inputs:
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
        parts = ['type = "%s"' % step.get("type", "note")]
        if step.get("quest") is not None:
            parts.append("quest = %d" % step["quest"])
        if step.get("name"):
            parts.append('name = "%s"' % lua._escape_lua(step["name"]))
        if step.get("npc"):
            parts.append('npc = "%s"' % lua._escape_lua(step["npc"]))
        if step.get("map") is not None:
            parts.append("map = %s" % step["map"])
        if step.get("x") is not None and step.get("y") is not None:
            parts.append("x = %s, y = %s" % (step["x"], step["y"]))
        if step.get("note"):
            parts.append('note = "%s"' % lua._escape_lua(step["note"]))
        if step.get("targetLevel") is not None:
            parts.append("targetLevel = %s" % step["targetLevel"])
        if step.get("levels"):
            lv = step["levels"]
            parts.append("levels = { %s, %s }" % (lv[0], lv[1]))
        lines.append("        { " + ", ".join(parts) + " },")

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

    route_name = "Merged: " + " + ".join(name for _, name, _ in inputs)
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
