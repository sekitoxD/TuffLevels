-- TuFFlevels / Routes/Horde/Durotar.lua
--
-- ############################ READ THIS ############################
-- The quest IDs below are UNVERIFIED. They are structurally correct
-- examples of the step format, not a validated route.
--
-- Before trusting any of them, run:  /tuff verify
-- That checks every ID in this file against QuestieDB and reports
-- anything it can't find.
--
-- To author real steps without looking IDs up by hand:
--   1. Accept the quests in game, in the order you want them
--   2. /tuff capture
--   3. Paste the output here and edit types/notes/coords
-- ###################################################################
--
-- STEP FORMAT
--   type      "accept" | "turnin" | "complete" | "grind" | "level" | "xp"
--             | "section" | "trainer" | "death" | "manual" | "travel"
--             | "hearth" | "flightpath" | "note"
--   quest     numeric quest ID (accept/turnin/complete)
--   name      fallback display name if no database is installed
--   npc       NPC to talk to - puts a marker over their head
--
--   Auto-detected without clicking Next: accept/turnin/complete/grind/level/xp
--   (quest log, player level, or XP), trainer (closing the trainer window),
--   death (dying then reviving), hearth (casting Hearthstone then the zone
--   changing), travel (within ~15 real yards of the step's coordinates, or
--   just the right map on a client where real-distance APIs aren't
--   available), flightpath (mapID + node/name already known on this
--   character). flightpath needs mapID (uiMapID) plus node (numeric
--   nodeID) or name.
--
--   objective  on a "complete" step: 1-based index into the quest's own
--              objective list - done when that one objective finishes,
--              not the whole quest. Omit to require every objective.
--   xp         on an "xp" step: { level = n, pct = n }. Done once the
--              player reaches that level, or is already past it - pct is
--              how far into that level's XP bar (0-100), default 0.
--   optional   true: shown dimmed in the Progress list, never blocks
--              auto-advance whether it's done or not - a take-it-or-leave
--              -it extra, not a gate.
--   skipIfLevel  hides and auto-skips this step once the player reaches
--              this level (opposite of minLevel, which hides it below one).
--   requires   list of OTHER step numbers (this route's array position,
--              1-based) that must also be done before this step counts as
--              done - lets a step depend on something earlier that isn't
--              immediately before it (e.g. an optional step it actually
--              needs). Re-numbering or reordering steps in this file
--              changes what these numbers point at, so update them
--              together with any edit that shifts step positions.
--
-- SECTIONS
--   { type = "section", name = "Zone or area", levels = { 6, 12 } }
--   Splits the route into chunks. Shown above the current step and as
--   headers in the progress list. Recording adds these on zone change.
--   map       uiMapID for the waypoint
--   x, y      0-100 coordinates
--   note      one line of guidance shown under the step
--   races     optional filter, e.g. { "Orc", "Troll" }
--   class     optional filter, e.g. "ROGUE"
--   minLevel  don't show this step below this level
--   targetLevel  for grind/level steps
--   path      optional ordered list of intermediate waypoints for a
--             multi-hop or cross-zone travel step, e.g.
--             { { zone = "Durotar", x = 50, y = 50 },
--               { zone = "The Barrens", x = 10, y = 20 } }
--             The arrow guides through each point in turn (advancing once
--             you're within ~20 yards and on that point's map) before
--             finally pointing at the step's own map/x/y. Without a path,
--             a step whose target is on a different map than the player
--             just shows "Different zone" instead of a bearing.
--
-- uiMapIDs (Classic Era):
--   Durotar 1411 | Orgrimmar 1454 | The Barrens 1413
--   Northern Barrens is not split in Classic - 1413 covers the whole zone

local ADDON, ns = ...

ns.RegisterRoute("Durotar (Orc/Troll)", {
    faction = "Horde",
    races   = { "Orc", "Troll" },
    levels  = { 1, 12 },
    author  = "sekitoxD",
    sample  = true,   -- unverified IDs; never auto-selected over a real route

    steps = {
        { type = "section", name = "Valley of Trials", levels = { 1, 6 } },

        { type = "note",
          name = "Valley of Trials",
          note = "Orc and Troll share this route start to finish. Same quests, same order." },

        -- ---- Valley of Trials ----
        { type = "accept", quest = 4641, name = "Your Place In The World",
          npc = "Kaltunk", map = 1411, x = 42.6, y = 68.8,
          note = "Kaltunk, right in front of you at spawn." },

        { type = "turnin", quest = 4641, name = "Your Place In The World",
          npc = "Gornek", map = 1411, x = 43.4, y = 68.0,
          note = "Gornek, inside the big hut." },

        { type = "accept", quest = 4642, name = "Cutting Teeth",
          npc = "Gornek", map = 1411, x = 43.4, y = 68.0,
          note = "Same NPC. Kill 10 Mottled Boars just outside." },

        { type = "turnin", quest = 4642, name = "Cutting Teeth",
          npc = "Gornek", map = 1411, x = 43.4, y = 68.0 },

        { type = "accept", quest = 4643, name = "Sarkoth",
          npc = "Gornek", map = 1411, x = 43.4, y = 68.0,
          note = "Cave to the southwest. Pull Sarkoth away from the scorpid adds." },

        { type = "turnin", quest = 4643, name = "Sarkoth",
          npc = "Gornek", map = 1411, x = 43.4, y = 68.0 },

        { type = "grind", targetLevel = 5,
          map = 1411, x = 44.0, y = 66.0,
          note = "Only if you're short. Boars and scorpids around the valley." },

        -- ---- Leaving the valley ----
        { type = "section", name = "Leaving the Valley", levels = { 5, 8 } },

        { type = "accept", quest = 4402, name = "Vanquish the Betrayers",
          map = 1411, x = 43.4, y = 68.0 },

        { type = "accept", quest = 788, name = "Vile Familiars",
          map = 1411, x = 43.2, y = 67.5,
          note = "Pick up alongside Betrayers - same area, kill them together." },

        { type = "turnin", quest = 788, name = "Vile Familiars",
          map = 1411, x = 43.2, y = 67.5 },

        { type = "turnin", quest = 4402, name = "Vanquish the Betrayers",
          map = 1411, x = 43.4, y = 68.0 },

        { type = "accept", quest = 4483, name = "Report to Sen'jin Village",
          map = 1411, x = 43.4, y = 68.0,
          note = "Breadcrumb out of the valley. Take it before you leave." },

        { type = "section", name = "Sen'jin and Razor Hill", levels = { 8, 12 } },

        { type = "travel",
          name = "Run to Sen'jin Village",
          map = 1411, x = 55.4, y = 74.4,
          note = "Southeast along the road. Grab the Razor Hill flight path on the way if you pass it." },

        { type = "turnin", quest = 4483, name = "Report to Sen'jin Village",
          map = 1411, x = 55.4, y = 74.4 },

        { type = "grind", targetLevel = 10,
          map = 1411, x = 55.0, y = 74.0,
          note = "Sen'jin and Razor Hill quest cluster. Fill in with whatever's up." },

        { type = "note",
          name = "End of seeded route",
          note = "Route continues into Razor Hill and the Barrens. Extend this file or add Routes/Barrens.lua." },
    },
})
