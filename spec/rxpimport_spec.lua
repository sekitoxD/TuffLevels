-- spec/rxpimport_spec.lua
--
-- Exercises RXPImport:Parse against the REAL file. Parse doesn't touch
-- ns.Compat/ns.Data at all, so no fakes are needed - just the stubbed
-- WoW globals wow_stubs installs for file-load time.

package.path = package.path .. ";./?.lua"

local stubs = require("spec.helpers.wow_stubs")

local function NewParser()
    stubs.Install()
    local ns = {}
    stubs.LoadFile("RXPImport.lua", ns)
    return ns.RXPImport
end

describe("RXPImport:Parse", function()
    local RXPImport

    before_each(function()
        RXPImport = NewParser()
    end)

    it("strips a single |cCATEGORY_...|r color token", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    >>|cRXP_FRIENDLY_Talk to Grull|r
]])
        assert.equals("Talk to Grull", route.steps[1].name)
    end)

    it("strips a |Ttexture:size|t icon token with no leftover path text", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    >>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to Grull
]])
        assert.equals("Talk to Grull", route.steps[1].name)
    end)

    it("fully resolves a color token nested inside another one", function()
        -- Real RXPGuides shape: an outer WARN wrapper around an inner
        -- ENEMY-highlighted phrase. A single non-recursive pass matches the
        -- outer opener against the INNER closer, stranding the inner
        -- opener unstripped - confirmed live in Routes/Horde/Mulgore.lua
        -- before this was fixed (2026-09-25).
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    +|cRXP_WARN_Kill |cRXP_ENEMY_Mottled Boars|r. Loot them|r
]])
        assert.equals("Kill Mottled Boars. Loot them", route.steps[1].note)
    end)

    it("parses .itemcount into an item step", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .itemcount 922,1
]])
        assert.equals("item", route.steps[1].type)
        assert.equals(922, route.steps[1].itemID)
        assert.equals(1, route.steps[1].count)
    end)

    it("parses .train into a spell step", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .train 416044
]])
        assert.equals("spell", route.steps[1].type)
        assert.equals(416044, route.steps[1].spellID)
    end)

    it("parses .maxlevel into skipIfLevel on the current step", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 747
    .maxlevel 27
]])
        assert.equals(27, route.steps[1].skipIfLevel)
    end)

    it("parses a bare '.xp N' into a real auto-detecting xp step", function()
        local route = RXPImport:Parse([[
step
    .xp 4 >> Grind to level 4
    .mob Mottled Boar
]])
        assert.equals("xp", route.steps[1].type)
        assert.equals(4, route.steps[1].xp.level)
        assert.equals(0, route.steps[1].xp.pct)
        assert.equals("Grind to level 4", route.steps[1].name)
        -- The sibling .mob line (an unrecognized dot-command) still folds
        -- into note text as before - only step.type/step.xp changed.
        assert.equals(".mob Mottled Boar", route.steps[1].note)
    end)

    it("leaves a modified '.xp N+M' form as plain note text, not an xp step", function()
        -- Converting an absolute-XP modifier into TuFFlevels' 0-100 xp.pct
        -- would need Classic's per-level XP table, which isn't hardcoded
        -- here - confirm this form is left alone rather than guessed at.
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .xp 3+325 >> Grind to 325+/1400xp
]])
        assert.equals("travel", route.steps[1].type)
        assert.is_nil(route.steps[1].xp)
    end)

    it("leaves a '.xp <N,1' gate form as plain note text, not an xp step", function()
        local route = RXPImport:Parse([[
step
    .xp <4,1
]])
        assert.equals("note", route.steps[1].type)
        assert.is_nil(route.steps[1].xp)
    end)

    it("keeps '<< !Hunter' as a classExclude filter instead of dropping the step", function()
        local route = RXPImport:Parse([[
step << !Hunter
    .goto Durotar,1,1
    .turnin 837
]])
        assert.equals(1, #route.steps)
        assert.equals("turnin", route.steps[1].type)
        assert.same({ "HUNTER" }, route.steps[1].classExclude)
        assert.is_nil(route.steps[1].class)
    end)

    it("keeps every class in a multi-class '<< !Warrior !Rogue' exclude, not just the last one", function()
        local route = RXPImport:Parse([[
step << !Warrior !Rogue
    .goto Durotar,1,1
    .turnin 837
]])
        assert.same({ "WARRIOR", "ROGUE" }, route.steps[1].classExclude)
    end)

    it("does not drop '<< !sod' - it's a no-op keep, the long-hand default branch", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 3119 << !sod
    .turnin 77574 << sod
]])
        assert.equals(1, #route.steps)
        assert.equals(3119, route.steps[1].quest)
    end)

    it("drops a step tagged with a standalone '#season 2' line (the real SoD syntax)", function()
        local route = RXPImport:Parse([[
step
    #season 2
    .goto Durotar,1,1
    .train 425447
step
    #season 0
    .goto Durotar,1,1
    .turnin 4
]])
        assert.equals(1, #route.steps)
        assert.equals(4, route.steps[1].quest)
    end)

    it("drops a step tagged with a standalone '#hardcore' line", function()
        local route = RXPImport:Parse([[
step
    #hardcore
    .goto Durotar,1,1
    .deathskip
step
    #softcore
    .goto Durotar,1,1
    .turnin 5
]])
        assert.equals(1, #route.steps)
        assert.equals(5, route.steps[1].quest)
    end)

    it("applies each line's own '<< Class' to its own split step (the Innkeeper Grosk shape)", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 2161
    .train 6760 << Rogue
    .train 139 << Priest
]])
        assert.equals(3, #route.steps)
        assert.is_nil(route.steps[1].class)
        assert.equals("ROGUE", route.steps[2].class)
        assert.equals(6760, route.steps[2].spellID)
        assert.equals("PRIEST", route.steps[3].class)
        assert.equals(139, route.steps[3].spellID)
        -- Every split step still has the shared location, not just the last.
        assert.equals("Durotar", route.steps[1].zone)
        assert.equals("Durotar", route.steps[2].zone)
        assert.equals("Durotar", route.steps[3].zone)
    end)

    it("splits a same-quest '<< Class' / '<< !Class' reward-choice pair into two reachable steps, not one impossible one", function()
        -- RXPGuides' common shape for a class-specific reward choice on
        -- the SAME turn-in: found live (2026-09-26) in
        -- Classic-Horde-01-12_Durotar.lua - `.turnin 788,2 << Shaman` then
        -- `.turnin 788 << !Shaman`. A first attempt at line-level class
        -- support merged both conditions onto ONE step
        -- (class="SHAMAN", classExclude={"SHAMAN"}), which Core.lua's
        -- StepApplies rejects for every class - losing the turn-in for
        -- everyone instead of giving each condition its own step.
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 788,2 << Shaman
    .turnin 788 << !Shaman
]])
        assert.equals(2, #route.steps)
        assert.equals("SHAMAN", route.steps[1].class)
        assert.is_nil(route.steps[1].classExclude)
        assert.is_nil(route.steps[2].class)
        assert.same({ "SHAMAN" }, route.steps[2].classExclude)
    end)

    it("does not leak a same-quest line's class filter onto the next unconditioned directive", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 788,2 << Shaman
    .turnin 788 << !Shaman
    .accept 789
]])
        assert.equals(3, #route.steps)
        assert.is_nil(route.steps[3].class)
        assert.is_nil(route.steps[3].classExclude)
        assert.equals(789, route.steps[3].quest)
    end)

    it("drops a line whose own class contradicts the block's class instead of overriding it", function()
        local route = RXPImport:Parse([[
step << Warrior
    .goto Durotar,1,1
    .accept 100
    .accept 200 << Mage
]])
        assert.equals(1, #route.steps)
        assert.equals(100, route.steps[1].quest)
        assert.equals("WARRIOR", route.steps[1].class)
    end)

    it("keeps distinct race filters on two same-class steps for two different races", function()
        -- Confirmed live: `.accept 2383 << Orc Warrior` / `.accept 3065
        -- << Troll Warrior` in the shared Orc/Troll Durotar guide - both
        -- becoming unfiltered-by-race Warrior steps would give an Orc the
        -- Troll-only quest and vice versa.
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 2383 << Orc Warrior
    .accept 3065 << Troll Warrior
]])
        assert.equals(2, #route.steps)
        assert.same({ "Orc" }, route.steps[1].races)
        assert.equals("WARRIOR", route.steps[1].class)
        assert.same({ "Troll" }, route.steps[2].races)
        assert.equals("WARRIOR", route.steps[2].class)
    end)

    it("keeps a step gated by '#season N << Class' unfiltered (can't apply per-class at parse time) and warns", function()
        local route, _, warnings = RXPImport:Parse([[
step << Warlock/Hunter/Rogue/Priest/Warrior
    #season 2 << Warrior
    .goto Durotar,1,1
    .turnin 4
]])
        assert.equals(1, #route.steps)
        assert.equals(4, route.steps[1].quest)
        local warned = false
        for _, w in ipairs(warnings) do
            if w:match("season") then warned = true end
        end
        assert.is_true(warned)
    end)

    it("gives a '.trainer' line after a real action its own step instead of overwriting the action", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 3119
    .trainer
]])
        assert.equals(2, #route.steps)
        assert.equals("turnin", route.steps[1].type)
        assert.equals(3119, route.steps[1].quest)
        assert.equals("trainer", route.steps[2].type)
    end)

    it("gives a '.deathskip' line after a real action its own step instead of overwriting the action", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 5
    .deathskip
]])
        assert.equals(2, #route.steps)
        assert.equals("accept", route.steps[1].type)
        assert.equals("death", route.steps[2].type)
    end)

    it("does not let a carried-forward npc block a later split's own '.target'", function()
        -- Confirmed live: "Talk to Gadrin, Vornal and Vel'rin" - three
        -- different turn-ins at three different NPCs standing near each
        -- other all came out as "Master Gadrin" because npc was carried
        -- across the split and `step.npc = step.npc or nm` never overwrites
        -- a non-nil carried value.
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 826
    .target Master Gadrin
    .goto Durotar,2,2
    .turnin 818
    .target Vornal
]])
        assert.equals(2, #route.steps)
        assert.equals("Master Gadrin", route.steps[1].npc)
        assert.equals("Vornal", route.steps[2].npc)
    end)

    it("treats a '.train id,flags' with the textOnly bit set as a note, not a blocking spell step", function()
        -- RXPGuides' own functions.lua (addon.functions.train) treats an
        -- odd flags value as bit 0x1 ("textOnly") set - a silent condition
        -- ("skip if already known"), not an instruction to go learn
        -- something. Confirmed live: Innkeeper Grosk's five class-gated
        -- `.train X,1 << Class` lines were all textOnly gates, not real
        -- training actions - treating them as blocking `spell` steps left
        -- a player stuck on a spell they likely already knew, with no way
        -- to complete the step early.
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 2161
    .train 6760,1 << Rogue
]])
        assert.equals(1, #route.steps)
        assert.equals("turnin", route.steps[1].type)
        assert.equals("Skip this step if you already know spell 6760", route.steps[1].note)
    end)

    it("reverses the '.train id,flags' textOnly note wording when the reverse bit is also set", function()
        -- flags=3 (bits 0 and 1 both set) - "skip if you DON'T know it",
        -- the opposite of flags=1 - per RXPGuides' own functions.lua
        -- (`element.reverse = bit.band(flags,0x2) == 0x2`, and completion
        -- is gated on `IsPlayerSpell(id) ~= reverse`).
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 2161
    .train 6760,3
]])
        assert.equals("Skip this step if you don't already know spell 6760", route.steps[1].note)
    end)

    it("still treats a '.train id,flags' with an even (non-textOnly) flags value as a real spell step", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .train 6760,2
]])
        assert.equals("spell", route.steps[1].type)
        assert.equals(6760, route.steps[1].spellID)
    end)

    it("drops a '<< skip' step (RXPGuides' own disabled-step marker)", function()
        local route = RXPImport:Parse([[
step << skip
    .goto Durotar,1,1
    .turnin 1
step
    .goto Durotar,1,1
    .turnin 2
]])
        assert.equals(1, #route.steps)
        assert.equals(2, route.steps[1].quest)
    end)

    it("resolves '<< !Undead' to the Horde faction's complement race list, using the real raceFile 'Scourge'", function()
        -- Core.lua's `races` filter is already an OR list (StepApplies
        -- loops over it), so "everyone except Undead" in a Horde guide
        -- can be modeled exactly as { Orc, Troll, Tauren } instead of
        -- either dropping the step or leaving it fully unfiltered. Uses
        -- "Scourge", not the human-readable "Undead" - Data:PlayerRace()
        -- returns UnitRace's raceFile ("Scourge" for Undead), and
        -- Core.lua's StepApplies does an exact string compare against it -
        -- confirmed live (2026-09-26, code review): every already-shipped
        -- route filtering on this race already uses "Scourge"
        -- (Routes/Horde/Mulgore.lua), so mapping to "Undead" here would
        -- have silently hidden every affected step from Undead players.
        local route = RXPImport:Parse([[
<< Horde
step << !Undead
    .goto Durotar,1,1
    .turnin 1
]])
        assert.equals(1, #route.steps)
        assert.equals(1, route.steps[1].quest)
        local races = {}
        for _, r in ipairs(route.steps[1].races) do races[r] = true end
        assert.equals(3, #route.steps[1].races)
        assert.is_true(races["Orc"])
        assert.is_true(races["Troll"])
        assert.is_true(races["Tauren"])
        assert.is_nil(races["Scourge"])
    end)

    it("resolves '<< !Orc !Troll' (RXPGuides' own wrong-guide warning) to just the other Horde races", function()
        local route = RXPImport:Parse([[
<< Horde
step << !Orc !Troll
    .goto Durotar,1,1
    .turnin 1
]])
        assert.equals(1, #route.steps)
        local races = {}
        for _, r in ipairs(route.steps[1].races) do races[r] = true end
        assert.equals(2, #route.steps[1].races)
        assert.is_true(races["Tauren"])
        assert.is_true(races["Scourge"])
    end)

    it("falls back to keep-unfiltered-and-warn for a negated race when the guide's faction is unknown", function()
        local route, _, warnings = RXPImport:Parse([[
step << !Undead
    .goto Durotar,1,1
    .turnin 1
]])
        assert.equals(1, #route.steps)
        assert.equals(1, route.steps[1].quest)
        assert.is_nil(route.steps[1].races)
        assert.equals(1, #warnings)
    end)

    it("marks a '#optional' step as optional so it never blocks Reconcile", function()
        local route = RXPImport:Parse([[
step
    #optional
    .goto Durotar,1,1
    .itemcount 3135,1
]])
        assert.is_true(route.steps[1].optional)
    end)

    it("propagates '#optional' to a split step created AFTER the tag, not just steps that already existed", function()
        -- Confirmed live: real guides almost always put `#optional` FIRST
        -- in the block - ApplyToBlock alone only reaches steps that exist
        -- at that moment, so a `.complete`+`.itemcount` block split into
        -- two steps left the SECOND (the item step) non-optional.
        local route = RXPImport:Parse([[
step
    #optional
    .goto Durotar,1,1
    .complete 375,2
    .itemcount 2876,5
]])
        assert.equals(2, #route.steps)
        assert.is_true(route.steps[1].optional)
        assert.is_true(route.steps[2].optional)
    end)

    it("propagates '.maxlevel' to a split step created AFTER the directive", function()
        local route = RXPImport:Parse([[
step
    .maxlevel 27
    .goto Durotar,1,1
    .accept 100
    .accept 200
]])
        assert.equals(2, #route.steps)
        assert.equals(27, route.steps[1].skipIfLevel)
        assert.equals(27, route.steps[2].skipIfLevel)
    end)

    it("fills npc onto every step in a block that named exactly one NPC, even via a trailing '.target'", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 100
    .accept 200
    .target Gornek
]])
        assert.equals(2, #route.steps)
        assert.equals("Gornek", route.steps[1].npc)
        assert.equals("Gornek", route.steps[2].npc)
    end)

    it("does not fill npc when a block names two or more distinct NPCs", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 100
    .target Gornek
    .accept 200
    .target Shikrik
]])
        assert.equals(2, #route.steps)
        assert.equals("Gornek", route.steps[1].npc)
        assert.equals("Shikrik", route.steps[2].npc)
    end)

    it("backfills a trailing '.goto' onto every earlier split step in the block", function()
        local route = RXPImport:Parse([[
step
    .accept 100
    .accept 200
    .goto Durotar,5,5
]])
        assert.equals(2, #route.steps)
        assert.equals("Durotar", route.steps[1].zone)
        assert.equals(5, route.steps[1].x)
        assert.equals("Durotar", route.steps[2].zone)
        assert.equals(5, route.steps[2].x)
    end)

    it("applies a trailing '#completewith next' (_infoOnly) to every split step in the block", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 100
    .accept 200
    #completewith next
]])
        assert.equals(2, #route.steps)
        assert.is_true(route.steps[1].optional)
        assert.is_true(route.steps[2].optional)
    end)

    it("splits two '.complete' directives for the same quest with different objectives", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .complete 100,1
    .complete 100,2
]])
        assert.equals(2, #route.steps)
        assert.equals(1, route.steps[1].objective)
        assert.equals(2, route.steps[2].objective)
    end)

    it("keeps '<< !Human' unfiltered rather than dropping it - same 'no raceExclude field' reasoning as '<< !Undead'", function()
        -- Superseded assumption (round 1 of this session): a negated race
        -- token was assumed to always be a "wrong guide, redirect here"
        -- warning and dropped outright. Round 3's real-guide check found a
        -- genuine content gate using the exact same shape (`<< !Undead`,
        -- "Get the Undercity flight path" in the shared Orc/Troll guide),
        -- which was being lost the same way - there's no syntactic way to
        -- tell the two apart, so "keep and flag" is the safer default.
        local route = RXPImport:Parse([[
step << !Human
    .goto Durotar,1,1
    .turnin 1
step
    .goto Durotar,1,1
    .turnin 2
]])
        assert.equals(2, #route.steps)
        assert.equals(1, route.steps[1].quest)
        assert.equals(2, route.steps[2].quest)
    end)

    it("drops a '<< SOD' step (Season of Discovery-only content)", function()
        local route = RXPImport:Parse([[
step << SOD
    .goto Durotar,1,1
    .train 1
step
    .goto Durotar,1,1
    .turnin 2
]])
        assert.equals(1, #route.steps)
        assert.equals(2, route.steps[1].quest)
    end)

    it("drops a '<< HARDCORE' step but keeps the '<< SOFTCORE' branch", function()
        local route = RXPImport:Parse([[
step << HARDCORE
    .goto Durotar,1,1
    .deathskip
step << SOFTCORE
    .goto Durotar,1,1
    .turnin 3
]])
        assert.equals(1, #route.steps)
        assert.equals("turnin", route.steps[1].type)
        assert.equals(3, route.steps[1].quest)
    end)

    it("splits a step naming two distinct quests into two steps, carrying zone/class forward", function()
        local route = RXPImport:Parse([[
step << Mage
    .goto Durotar,1,1
    .accept 100
    .accept 200
]])
        assert.equals(2, #route.steps)
        assert.equals(100, route.steps[1].quest)
        assert.equals(200, route.steps[2].quest)
        assert.equals("Durotar", route.steps[2].zone)
        assert.equals(1, route.steps[2].x)
        assert.equals("MAGE", route.steps[2].class)
    end)

    it("splits accept-then-turnin of the same quest id into two real steps instead of collapsing to just the turnin", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 747
    .turnin 747
]])
        assert.equals(2, #route.steps)
        assert.equals("accept", route.steps[1].type)
        assert.equals(747, route.steps[1].quest)
        assert.equals("turnin", route.steps[2].type)
        assert.equals(747, route.steps[2].quest)
    end)

    it("collapses two structurally-identical steps into one", function()
        -- RXPGuides' OR-condition branches (e.g. two alternate step blocks
        -- that each survive unfiltered per this parser's own "kept
        -- unfiltered, please review" doctrine for OR conditions) commonly
        -- converge on byte-identical directives for the same quest.
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .turnin 5
step
    .goto Durotar,1,1
    .turnin 5
]])
        assert.equals(1, #route.steps)
    end)

    it("does not let a trailing '.xp N' hint overwrite an already-typed step", function()
        -- Real guide shape: a turn-in (or accept/complete/etc.) directive
        -- followed by its own trailing ".xp N" grind hint on the next
        -- line. Directives are "last one wins" for step.type elsewhere in
        -- this parser, so without a guard the xp branch would silently
        -- turn a real turn-in into an inert xp-gate and lose the quest
        -- action entirely - caught in code review, 2026-09-26.
        local route = RXPImport:Parse([[
step
    .turnin 788
    .xp 5
]])
        assert.equals("turnin", route.steps[1].type)
        assert.equals(788, route.steps[1].quest)
    end)
end)
