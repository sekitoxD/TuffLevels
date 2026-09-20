# Contributing a route

TuFFlevels has no quest database for Forever — the only way route data exists
is players recording it as they play. This is how you turn a played-through
zone into something that can go back into the addon for everyone else.

## The short version

1. **Record.** Menu → Recording (on by default for a fresh install). Play the
   zone normally — accept, complete, turn in, travel — in whatever order you
   actually did it.
2. **Export.** Menu → Save this as a route. This gives you a ready-to-paste
   Lua route file, with a header noting the export `format`, your `client`
   (flavor + interface version), `class`, and the date you recorded it —
   see `Recorder.lua`'s `BuildRouteText` if you want the exact fields.
3. **Verify.** `/tuff verify` in-game, or `python tools/validate_route.py
   --no-db path/to/YourFile.lua` outside it. Fix anything it flags before
   opening a PR — a bad quest ID or malformed step is on you to catch, not
   the reviewer.
4. **Open a PR** with the exported file under `Routes/`, named for the zone
   or leg it covers. Mention your character's race/class/faction in the PR
   description if the export header doesn't already make it obvious.

## If you're merging more than one recording of the same content

Two people recording the same zone will disagree here and there — different
order, slightly different coordinates, a quest one of you skipped. Don't
hand-merge that from scratch:

```
python tools/merge_routes.py RecordingA.lua RecordingB.lua ... -o Merged.lua
```

This groups steps by quest ID, takes the median of each step's recorded
coordinates, keeps whichever step order was most common across the inputs,
and writes a conflict report for anything it can't resolve on its own (a
step present in some recordings and not others, wildly different
coordinates, disagreeing NPC names). Read that report. The tool proposes;
you decide — see "Why it's built this way" in `README.md` for why this
addon doesn't auto-generate routes even when it has real player data to
work from. A merged route still needs the same `/tuff verify` /
`validate_route.py` pass, and a human read-through, before it's a PR.

## What review is actually checking for

- **Structural correctness** — `/tuff verify` / `validate_route.py` already
  catch most of this: bad IDs, missing coordinates, malformed steps.
- **Does the route make sense as a route** — is the order actually good, are
  the notes useful, would you hand this to someone else and trust it. Tools
  can't judge this; a person has to actually read it.
- **No QuestieDB data copied in.** Route files carry their own coordinates
  precisely so nothing from QuestieDB (GPL-3.0) ends up committed here — see
  "Licensing" in `README.md`. If a PR's coordinates or names look like
  they were pulled from a database rather than played and recorded, that's
  a real problem, not a style nitpick.

## Multi-file routes

Some zones are big enough to record in legs and stitch together — see
`Routes/Horde/Solo/*.lua` and its `Register.lua` for the pattern (each zone
file contributes to `ns.SoloLegs`, one `Register.lua` sorts and concatenates
them into a single route at the end). Follow that structure if you're
recording a large route yourself rather than inventing a new one.
