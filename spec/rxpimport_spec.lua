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

    it("resolves a block-level class-OR condition to a real 'classes' filter", function()
        -- Confirmed live (2026-09-27): "step << Hunter/Rogue" used to be
        -- reported unhandled and shipped completely unfiltered - previously
        -- the only way to keep the step reachable, but far too broad (every
        -- OTHER class saw it too).
        local route = RXPImport:Parse([[
step << Hunter/Rogue
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(1, #route.steps)
        assert.is_nil(route.steps[1].class)
        assert.same({ "HUNTER", "ROGUE" }, route.steps[1].classes)
    end)

    it("drops an out-of-scope (SoD) branch from a class-OR before resolving the rest", function()
        -- Confirmed live: "step << Hunter/Warrior/Priest/Sod Rogue" (the
        -- Night Elf "Train Staves" block) - the Rogue branch is SoD-gated
        -- and out of scope, so it must not survive into the classes list
        -- (Classic Rogues can never learn Staves, so a Rogue stuck with
        -- this filter could never complete the step).
        local route = RXPImport:Parse([[
step << Hunter/Warrior/Priest/Sod Rogue
    .goto Durotar,1,1
    .train 227
]])
        assert.equals(1, #route.steps)
        assert.is_nil(route.steps[1].class)
        assert.same({ "HUNTER", "WARRIOR", "PRIEST" }, route.steps[1].classes)
    end)

    it("collapses a class-OR down to exactly one class into the plain 'class' field, not a one-element 'classes'", function()
        -- Confirmed live (2026-09-27, round-2 code review): leaving this as
        -- classes = { "HUNTER" } instead of class = "HUNTER" let a LATER
        -- line's own plain "<< Hunter" condition resolve to `class` (not
        -- `classes`) for the exact same class - StepForAction's same-step
        -- check compares `class` and `classes` independently, so it read
        -- that as a DIFFERENT filter and split into a spurious duplicate
        -- step for what should have been one step.
        local route = RXPImport:Parse([[
step << Hunter/Sod Rogue
    .goto Durotar,1,1
    .complete 5,1
    .complete 5,1 << Hunter
]])
        assert.equals(1, #route.steps)
        assert.equals("HUNTER", route.steps[1].class)
        assert.is_nil(route.steps[1].classes)
    end)

    it("doesn't leave a stale block-level 'classes' sitting alongside a line-narrowed 'class' on the FIRST action of a block", function()
        -- Confirmed live (2026-09-27, round-3 code review): the block-start
        -- assignment (`step << Hunter/Warrior` sets curStep.classes =
        -- {H,W}) and the first action line's own narrower condition
        -- (`.accept 10 << Hunter`, resolving to class="HUNTER",
        -- classes=nil) both write to the SAME step object (no split has
        -- happened yet) - an `if effClasses then` guard on the classes
        -- assignment would leave the stale {H,W} in place instead of
        -- clearing it, which then made an identical later directive with
        -- the same line condition compare unequal (nil vs {H,W}) and split
        -- into a spurious duplicate step.
        local route = RXPImport:Parse([[
step << Hunter/Warrior
    .goto Durotar,1,1
    .accept 10 << Hunter
    .accept 11 << Warrior
]])
        assert.equals(2, #route.steps)
        assert.equals("HUNTER", route.steps[1].class)
        assert.is_nil(route.steps[1].classes)
        assert.equals("WARRIOR", route.steps[2].class)
        assert.is_nil(route.steps[2].classes)
    end)

    it("carries a block-level classes-OR onto a split step created AFTER the block condition was read", function()
        local route = RXPImport:Parse([[
step << Hunter/Warrior
    .goto Durotar,1,1
    .accept 1
    .accept 2 << Hunter
    .accept 3
]])
        assert.equals(3, #route.steps)
        assert.same({ "HUNTER", "WARRIOR" }, route.steps[1].classes)
        assert.equals("HUNTER", route.steps[2].class)
        assert.same({ "HUNTER", "WARRIOR" }, route.steps[3].classes)
    end)

    it("does not collapse adjacent OR-branch copies with DIFFERENT 'classes' into one, losing a class's copy", function()
        -- Same bug shape the dedup key already guards against for `races`
        -- (see StepKey's own comment) - `classes` needed the identical fix.
        local route = RXPImport:Parse([[
step << Hunter/Warrior
    .goto Durotar,1,1
    .accept 5 >> Accept Foo
step << Druid/Priest
    .goto Durotar,1,1
    .accept 5 >> Accept Foo
]])
        assert.equals(2, #route.steps)
        assert.same({ "HUNTER", "WARRIOR" }, route.steps[1].classes)
        assert.same({ "DRUID", "PRIEST" }, route.steps[2].classes)
    end)

    it("does not collapse adjacent steps that differ only in numeric 'map' into one", function()
        -- Same bug shape as the races/classes dedup-key fixes above, for
        -- the numeric `map` field added 2026-09-27 - two adjacent steps
        -- whose only difference is which map they're on both stringified
        -- their (nil) `zone` identically before this fix.
        local route = RXPImport:Parse([[
step
    .goto 1426,1,1
    .accept 5 >> Accept Foo
step
    .goto 1455,1,1
    .accept 5 >> Accept Foo
]])
        assert.equals(2, #route.steps)
        assert.equals(1426, route.steps[1].map)
        assert.equals(1455, route.steps[2].map)
    end)

    it("intersects a block-level class-OR with a narrower line-level class-OR", function()
        -- The exact real shape that stranded Night Elf Rogues: a block-level
        -- OR narrowed further by a line's own OR condition.
        local route = RXPImport:Parse([[
step << Hunter/Warrior/Priest/Sod Rogue
    .goto Durotar,1,1
    .train 227 << Hunter/Warrior/Priest
]])
        assert.equals(1, #route.steps)
        assert.same({ "HUNTER", "WARRIOR", "PRIEST" }, route.steps[1].classes)
    end)

    it("does not guess at a mixed race+class OR - still kept unfiltered, still warns", function()
        local route, _, warnings = RXPImport:Parse([[
step << Human/Warrior
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(1, #route.steps)
        assert.is_nil(route.steps[1].class)
        assert.is_nil(route.steps[1].classes)
        assert.is_nil(route.steps[1].races)
        local found = false
        for _, w in ipairs(warnings) do
            if w:find("OR/complex", 1, true) then found = true end
        end
        assert.is_true(found)
    end)

    it("warns on a LINE-level (not just block-level) OR/complex condition it can't filter on", function()
        -- Previously silently discarded (the return value was thrown away
        -- with `_`) - confirmed live: this is what let a First Aid training
        -- step ship forced onto every class instead of the intended subset.
        local route, _, warnings = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 100 << Human/Warrior
]])
        assert.equals(1, #route.steps)
        local found = false
        for _, w in ipairs(warnings) do
            if w:find("Line condition", 1, true) then found = true end
        end
        assert.is_true(found)
    end)

    it("keeps '<< era'/'<< Druid era' as a no-op in-scope marker, same as CLASSIC, not unhandled", function()
        local route, _, warnings = RXPImport:Parse([[
step << Druid era
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(1, #route.steps)
        assert.equals("DRUID", route.steps[1].class)
        assert.equals(0, #warnings)
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

    it("drops a step gated by an out-of-scope '#xprate' (a fast/slow-leveling-only branch)", function()
        -- Confirmed live (2026-09-27, code review): this addon targets a
        -- normal 1x Classic Era/Forever/Mainline pace. Unlike most xprate
        -- duplicates (near-identical content that harmlessly self-skips
        -- once the first copy is done), a fast-XP branch can be a
        -- genuinely DIFFERENT itinerary that never self-skips - a 1x
        -- player got both itineraries' worth of clicks back to back
        -- before this fix.
        local route = RXPImport:Parse([[
step
    #xprate >1.49
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(0, #route.steps)
    end)

    it("keeps a step gated by an in-scope '#xprate' (a threshold 1.0 satisfies)", function()
        local route = RXPImport:Parse([[
step
    #xprate <1.5
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(1, #route.steps)
        assert.equals(100, route.steps[1].quest)
    end)

    it("drops a step gated by an out-of-scope '#xprate A-B' range", function()
        local route = RXPImport:Parse([[
step
    #xprate 1.49-1.59
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(0, #route.steps)
    end)

    it("resolves a clean class-only '#xprate N << Class' condition into classExclude instead of warning", function()
        -- Unlike #season/#hardcore, whether the xp-rate threshold is
        -- satisfied doesn't depend on class - a trailing "<< Cond" only
        -- says WHICH classes this out-of-scope variant covers, so a clean
        -- class-only condition resolves directly (exclude those classes)
        -- rather than falling back to "can't apply per-class, keep
        -- unfiltered". Confirmed live (2026-09-27, round-4 code review):
        -- real guide text pairs "#xprate >1.49 << !Warrior !Paladin
        -- !Rogue" with "#xprate >1.59 << Warrior/Paladin/Rogue" on
        -- sibling steps - both out of scope at 1x, for complementary
        -- class sets.
        local route = RXPImport:Parse([[
step
    #xprate >1.49 << Warrior
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(1, #route.steps)
        assert.same({ "WARRIOR" }, route.steps[1].classExclude)
    end)

    it("resolves a negated class '#xprate N << !Class' condition to its complement in classExclude", function()
        -- "<< !Warrior !Paladin !Rogue" means "applies to everyone except
        -- these three" - since that whole variant is out of scope, it's
        -- the COMPLEMENT (everyone it actually covers) that needs
        -- excluding, not Warrior/Paladin/Rogue themselves.
        local route = RXPImport:Parse([[
step
    #xprate >1.49 << !Warrior !Paladin !Rogue
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(1, #route.steps)
        local excluded = {}
        for _, c in ipairs(route.steps[1].classExclude) do excluded[c] = true end
        assert.is_true(excluded.HUNTER and excluded.PRIEST and excluded.SHAMAN
            and excluded.MAGE and excluded.WARLOCK and excluded.DRUID)
        assert.is_true(not excluded.WARRIOR)
        assert.is_true(not excluded.PALADIN)
        assert.is_true(not excluded.ROGUE)
    end)

    it("keeps a step gated by '#xprate N << Race' unfiltered (a race condition can't be resolved) and warns", function()
        local route, _, warnings = RXPImport:Parse([[
<< Alliance
step
    #xprate >1.49 << Dwarf
    .goto Durotar,1,1
    .accept 100
]])
        assert.equals(1, #route.steps)
        local warned = false
        for _, w in ipairs(warnings) do
            if w:match("xp%-rate") then warned = true end
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

    it("folds a '.itemcount' trailing a '.turnin' into a note instead of splitting an unsatisfiable item step", function()
        local route = RXPImport:Parse([[
step
    .goto Teldrassil,60.4,56.4
    .target Zenn Foulhoof
    .turnin 489
    .itemcount 3418,3
]])
        assert.equals(1, #route.steps)
        assert.equals("turnin", route.steps[1].type)
        assert.equals(489, route.steps[1].quest)
        assert.is_true(route.steps[1].note ~= nil and route.steps[1].note:find("3418", 1, true) ~= nil)
    end)

    it("still splits a '.itemcount' trailing a '.complete' into its own item step (a real, satisfiable objective)", function()
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .complete 375,2
    .itemcount 2876,5
]])
        assert.equals(2, #route.steps)
        assert.equals("complete", route.steps[1].type)
        assert.equals("item", route.steps[2].type)
        assert.equals(2876, route.steps[2].itemID)
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

    it("drops (not misreads) a '.goto mapID/floor,x,y,flag' raw pixel-coordinate form", function()
        local route = RXPImport:Parse([[
step
    .goto 1438/1,854.400,9952.500,6
    .complete 489,1
    .isOnQuest 489
]])
        assert.equals(1, #route.steps)
        assert.is_nil(route.steps[1].zone)
        assert.is_nil(route.steps[1].x)
        assert.is_nil(route.steps[1].y)
    end)

    it("doesn't let a dropped mapID/floor annotation steal the step's name from its real task text", function()
        -- Confirmed live (2026-09-27): the annotation on a dropped
        -- mapID/floor line describes the waypoint that was just dropped
        -- (e.g. "Next to a small tree"), not the step's actual task - if it
        -- claims step.name first, the real ">>" task line that follows gets
        -- pushed into a note instead.
        local route = RXPImport:Parse([[
step
    .goto 1438/1,854.400,9952.500,6 >>Next to a small tree
    >>Loot the 3 Fel Cones from the locations marked on your map.
    .complete 489,1
]])
        assert.equals("Loot the 3 Fel Cones from the locations marked on your map.", route.steps[1].name)
    end)

    it("still parses a normal '.goto zone,x,y' after a mapID/floor line in the same block", function()
        local route = RXPImport:Parse([[
step
    .goto 1438/1,854.400,9952.500,6
    .goto Teldrassil,60.4,56.4
    .complete 489,1
]])
        assert.equals("Teldrassil", route.steps[1].zone)
        assert.equals(60.4, route.steps[1].x)
    end)

    it("converts a purely numeric '.goto mapID,x,y' token into the numeric 'map' field, not 'zone'", function()
        -- Confirmed live (2026-09-27, code review): a raw uiMapID like
        -- ".goto 1426,28.2,71.7" (Dun Morogh) is a real, resolvable map ID
        -- in RXPGuides' own grammar, in the SAME 0-100-percent coordinate
        -- space every other .goto uses (unlike the "mapID/floor" form
        -- above) - storing it as `zone = "1426"` (a string Compat:MapID
        -- tries to resolve by NAME and fails on) silently broke the
        -- travel-ticker auto-complete and the arrow for every affected
        -- step (150 steps / 491 path points in one real chapter alone).
        -- The OLD, pre-fix importer already got this right via `map =`.
        local route = RXPImport:Parse([[
step
    .goto 1426,28.239,71.707
    .accept 100
]])
        assert.is_nil(route.steps[1].zone)
        assert.equals(1426, route.steps[1].map)
        assert.equals(28.239, route.steps[1].x)
    end)

    it("pushes the right field (zone or map) onto path when switching goto forms mid-block", function()
        local route = RXPImport:Parse([[
step
    .goto Dun Morogh,10,10
    .goto 1426,20,20
    .accept 100
]])
        assert.equals(1426, route.steps[1].map)
        assert.is_nil(route.steps[1].zone)
        assert.equals(1, #route.steps[1].path)
        assert.equals("Dun Morogh", route.steps[1].path[1].zone)
        assert.equals(10, route.steps[1].path[1].x)
    end)

    it("backfills a numeric 'map' (not just 'zone') onto an earlier split step with no location yet", function()
        local route = RXPImport:Parse([[
step
    .accept 100
    .accept 200
    .goto 1426,5,5
]])
        assert.equals(2, #route.steps)
        assert.equals(1426, route.steps[1].map)
        assert.is_nil(route.steps[1].zone)
        assert.equals(1426, route.steps[2].map)
    end)

    it("keeps a step whose ONLY content is a numeric '.goto' - doesn't silently drop it", function()
        -- Confirmed live (2026-09-27, round-3 code review): FinishStep's
        -- keep-check only looked at `type`/`zone`/`note`, not `map` - a
        -- block like ".goto 1426,x,y >>Enter Anvilmar" with nothing else
        -- in it set `map` (no `zone`, no `note`, no `type` yet) and was
        -- silently discarded as if it were content-free, losing 23 real
        -- steps across one real chapter alone (e.g. "Enter Anvilmar",
        -- "Enter the Thunderbrew Distillery").
        local route = RXPImport:Parse([[
step
    .goto 1426,25.07,75.71 >>Enter Anvilmar
]])
        assert.equals(1, #route.steps)
        assert.equals("travel", route.steps[1].type)
        assert.equals(1426, route.steps[1].map)
        assert.equals("Enter Anvilmar", route.steps[1].name)
    end)

    it("types a typeless map-only step 'travel' (auto-completing), not 'note' (manual click)", function()
        -- Confirmed live: the travel/note fallback only checked `s.zone`,
        -- so a typeless step with only `map` set (no `zone`) was typed
        -- "note" instead of "travel" - it never auto-completed on arrival
        -- even though it has a perfectly good location to walk to. 47 real
        -- steps in one chapter had this shape, 20 of them mandatory.
        local route = RXPImport:Parse([[
step
    .goto 1426,25.07,75.71 >>Some waypoint
]])
        assert.equals("travel", route.steps[1].type)
    end)

    it("keeps a split step's numeric 'map' after the block's location came from a numeric '.goto'", function()
        -- Confirmed live (2026-09-27, round-3 code review): StepForAction's
        -- `carry` table only copied `zone` (plus x/y) to a new split step,
        -- not `map` - a block like ".goto 1426,x,y" / ".turnin 234" /
        -- ".accept 182" left the SPLIT step (.accept) with real x/y but no
        -- map AND no zone at all, worse than either a resolvable or even a
        -- consistently-dead location. 17 real steps had this shape, 10 of
        -- them mandatory (e.g. the Paladin "Tome of Divinity" chain).
        local route = RXPImport:Parse([[
step
    .goto 1426,25.07,75.71
    .turnin 234
    .accept 182
]])
        assert.equals(2, #route.steps)
        assert.equals(1426, route.steps[1].map)
        assert.equals(25.07, route.steps[1].x)
        assert.equals(1426, route.steps[2].map)
        assert.equals(25.07, route.steps[2].x)
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

    it("applies a labelled '#completewith <label>' (not just 'next') as optional too", function()
        -- RXPGuides' own GuideWindow.lua sets step.sticky = true whenever
        -- step.completewith is set and it isn't a "tip", for ANY label, not
        -- just the special "next" value - confirmed directly against that
        -- source. Previously only "#completewith next" was recognized, so a
        -- labelled form shipped as a blocking, non-optional step.
        local route = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .complete 100,1
    #completewith darn
]])
        assert.is_true(route.steps[1].optional)
    end)

    it("does NOT apply a lone '#completewith <label> << Cond' block-wide when Cond only covers PART of the block", function()
        -- A single conditioned tag with no complementing tag in the same
        -- block only covers the classes/races it names (Hunter here) - the
        -- rest of the block's own filter (unrestricted, i.e. every class)
        -- isn't covered, so this parser can't safely mark the whole block
        -- optional - warn and leave it mandatory rather than guess. Same
        -- "can't apply a per-class condition at parse time" situation
        -- '#season N << Cond' already handles.
        local route, _, warnings = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .complete 100,1
    #completewith darn << Hunter
]])
        assert.is_true(route.steps[1].optional == nil or route.steps[1].optional == false)
        local found = false
        for _, w in ipairs(warnings) do
            if w:find("can't apply per-class", 1, true) then found = true end
        end
        assert.is_true(found)
    end)

    it("applies a PAIR of '#completewith << Cond' tags whose conditions together cover every class", function()
        -- Confirmed live (2026-09-27, round-3 code review): the real,
        -- common form pairs two (or more) conditioned tags on one block
        -- whose conditions are each other's complement - e.g.
        -- Classic-Alliance-1-13_Human.lua's "Westfall Deed" rare-drop step:
        -- "#completewith Level9Grind << Warlock/Warrior/Rogue" +
        -- "#completewith PrincessC << !Warlock !Warrior !Rogue". Neither
        -- tag alone covers everyone, but together they cover every class,
        -- so the step should be optional for everyone with no warning -
        -- round 2's fix (warn on the first conditioned tag it saw,
        -- ignoring a later complementing one) got this wrong.
        local route, _, warnings = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 184
    #completewith Level9Grind << Warlock/Warrior/Rogue
    #completewith PrincessC << !Warlock !Warrior !Rogue
]])
        assert.is_true(route.steps[1].optional)
        assert.equals(0, #warnings)
    end)

    it("applies a conditioned '#completewith << Cond' when Cond only repeats the block's own class filter", function()
        -- e.g. "step << Hunter" + "#completewith prospector << Hunter" -
        -- the tag's condition covers 100% of the classes this BLOCK itself
        -- applies to (just Hunter), so there's no real gap to warn about.
        local route, _, warnings = RXPImport:Parse([[
step << Hunter
    .goto Durotar,1,1
    .accept 5
    #completewith prospector << Hunter
]])
        assert.is_true(route.steps[1].optional)
        assert.equals(0, #warnings)
    end)

    it("does not let an AND condition (positive class + classExclude in one group) wrongly cover an unrelated class", function()
        -- Confirmed live (2026-09-27, round-4 code review): "<< Warrior
        -- !Hunter" means "Warrior AND NOT Hunter" (one token group), not
        -- "Warrior OR (everyone but Hunter)" - accumulating both the
        -- positive class AND the classExclude's complement as coverage
        -- would wrongly mark a Rogue-only block optional, since the tag's
        -- real condition can never match a Rogue at all.
        local route, _, warnings = RXPImport:Parse([[
step << Rogue
    .goto Durotar,1,1
    .accept 1
    #completewith X << Warrior !Hunter
]])
        assert.is_true(route.steps[1].optional == nil or route.steps[1].optional == false)
        assert.equals(1, #warnings)
    end)

    it("does not let two DIFFERENT positive class tokens in one AND group resolve to just the last one", function()
        -- Confirmed live (2026-09-27, round-5 code review): "<< Warrior
        -- Rogue" means "Warrior AND Rogue" (one token group, AND
        -- semantics) - a condition no real character can ever satisfy, not
        -- "just Rogue" (the previous last-token-wins behavior). Silently
        -- reading it as "Rogue" would wrongly mark a Rogue-only block
        -- optional via a condition that can never actually match a Rogue.
        local route, _, warnings = RXPImport:Parse([[
step << Rogue
    .goto Durotar,1,1
    .accept 1
    #completewith X << Warrior Rogue
]])
        assert.is_true(route.steps[1].optional == nil or route.steps[1].optional == false)
        assert.equals(1, #warnings)
    end)

    it("applies when coverage completes despite an unrelated tag this parser can't resolve", function()
        -- Confirmed live (2026-09-27, round-4 code review): RXPGuides ORs
        -- every completewith/sticky tag on a step (matching ANY one is
        -- enough) - a tag this parser gives up on can only ADD potential
        -- optionality, never take away coverage two OTHER tags already
        -- established between them.
        local route, _, warnings = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .accept 1
    #completewith A << Warlock/Warrior/Rogue
    #completewith B << !Warlock !Warrior !Rogue
    #completewith C << NightElf
]])
        assert.is_true(route.steps[1].optional)
        assert.equals(0, #warnings)
    end)

    it("checks coverage against the block's own classExclude, not always all 9 classes", function()
        -- e.g. "step << !Hunter" + "#completewith X << !Hunter" - the tag's
        -- condition covers 100% of what the BLOCK itself applies to
        -- (everyone but Hunter), so there's no real gap to warn about.
        local route, _, warnings = RXPImport:Parse([[
step << !Hunter
    .goto Durotar,1,1
    .accept 1
    #completewith X << !Hunter
]])
        assert.is_true(route.steps[1].optional)
        assert.equals(0, #warnings)
    end)

    it("applies a PAIR of race-conditioned '#completewith << Cond' tags whose conditions together cover every race", function()
        -- Confirmed live (2026-09-27): Classic-Alliance-1-14_DwarfGnome.lua
        -- pairs "#completewith HonorStudents << Dwarf/Gnome" with
        -- "#completewith ThelsaHS << !Dwarf !Gnome" on one block - the race
        -- equivalent of the class-complement-pair case, tracked as an
        -- independent coverage dimension from class coverage.
        local route, _, warnings = RXPImport:Parse([[
<< Alliance
step
    .goto Durotar,1,1
    .accept 1
    #completewith HonorStudents << Dwarf/Gnome
    #completewith ThelsaHS << !Dwarf !Gnome
]])
        assert.is_true(route.steps[1].optional)
        assert.equals(0, #warnings)
    end)

    it("does not let a single, partial race condition alone mark a step optional", function()
        local route, _, warnings = RXPImport:Parse([[
<< Alliance
step
    .goto Durotar,1,1
    .accept 1
    #completewith X << Dwarf
]])
        assert.is_true(route.steps[1].optional == nil or route.steps[1].optional == false)
        assert.equals(1, #warnings)
    end)

    it("does not resolve a MIXED race+class OR ('<< Dwarf/Warrior') as either dimension", function()
        local route, _, warnings = RXPImport:Parse([[
<< Alliance
step
    .goto Durotar,1,1
    .accept 1
    #completewith X << Dwarf/Warrior
]])
        assert.is_true(route.steps[1].optional == nil or route.steps[1].optional == false)
        assert.equals(1, #warnings)
    end)

    it("does not let 'Human !Dwarf' (a positive race AND a negated one) over-cover Gnome/NightElf", function()
        -- Confirmed live (2026-09-27, round-6 code review): "Human !Dwarf"
        -- really means just "Human" (already excludes Dwarf), not "Human"
        -- unioned with the complement-of-Dwarf list ({Human, Gnome,
        -- NightElf}) - the latter would wrongly let a paired "<< Dwarf" tag
        -- complete coverage and mark the step optional for Gnome/NightElf
        -- too, when the real conditions only ever cover Human and Dwarf.
        local route, _, warnings = RXPImport:Parse([[
<< Alliance
step
    .goto Durotar,1,1
    .accept 1
    #completewith A << Human !Dwarf
    #completewith B << Dwarf
]])
        assert.is_true(route.steps[1].optional == nil or route.steps[1].optional == false)
        assert.equals(1, #warnings)
    end)

    it("does not let 'Human Dwarf' (two different positive races, impossible for any character) resolve at all", function()
        -- Same shape round 5 already guarded against for classes - a
        -- character can't be two races at once, so silently keeping both
        -- as an OR would wrongly satisfy this tag for a Human OR a Dwarf,
        -- when the real (impossible) condition can never match either.
        local route, _, warnings = RXPImport:Parse([[
<< Alliance
step
    .goto Durotar,1,1
    .accept 1
    #completewith A << Human Dwarf
    #completewith B << Gnome/NightElf
]])
        assert.is_true(route.steps[1].optional == nil or route.steps[1].optional == false)
        assert.equals(1, #warnings)
    end)

    it("does not misfire the positive-race guard on an exact repeat ('<< Human Human') or a class+race pair", function()
        -- The new "two different positive races" guard compares by value,
        -- not by token count - an exact repeat (a harmless no-op, possibly
        -- from a guide's own copy-paste) must still resolve cleanly, and a
        -- class token alongside a single clean race must be unaffected.
        local route1 = RXPImport:Parse([[
<< Alliance
step << Human Human
    .goto Durotar,1,1
    .accept 1
]])
        assert.same({ "Human" }, route1.steps[1].races)

        local route2 = RXPImport:Parse([[
<< Alliance
step << Warrior Human
    .goto Durotar,1,1
    .accept 1
]])
        assert.equals("WARRIOR", route2.steps[1].class)
        assert.same({ "Human" }, route2.steps[1].races)
    end)

    it("resolves a step-level '<< RaceA/RaceB' race-OR condition to a real 'races' filter (not just inside a #completewith tag)", function()
        -- The race-OR resolution added to EvalCondition applies everywhere
        -- EvalCondition is called, not just inside the #completewith
        -- coverage check - a block condition like "step << Dwarf/Gnome"
        -- (5 real occurrences found in Classic-Alliance-1-14_DwarfGnome.lua)
        -- now resolves to races={"Dwarf","Gnome"} instead of shipping
        -- completely unfiltered with a warning.
        local route, _, warnings = RXPImport:Parse([[
<< Alliance
step << Dwarf/Gnome
    .goto Durotar,1,1
    .accept 1
]])
        assert.same({ "Dwarf", "Gnome" }, route.steps[1].races)
        assert.equals(0, #warnings)
    end)

    it("applies '#completewith <label> << era' normally (a pure no-op scope marker, not a real restriction)", function()
        local route, _, warnings = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .complete 100,1
    #completewith darn << era
]])
        assert.is_true(route.steps[1].optional)
        assert.equals(0, #warnings)
    end)

    it("silently skips '#completewith <label> << sod' (out of scope for this addon's target ruleset), no warning", function()
        -- Confirmed live: real guide text pairs "#completewith darn << era"
        -- with "#completewith darnSoD << sod" on the SAME step - one
        -- companion label for each ruleset. The "sod" one is irrelevant to
        -- a non-SoD client, same as any other SoD-gated content, so it
        -- should neither apply nor warn - the "era" sibling (or an earlier
        -- unconditioned tag) is what actually determines optionality here.
        local route, _, warnings = RXPImport:Parse([[
step
    .goto Durotar,1,1
    .complete 100,1
    #completewith darnSoD << sod
]])
        assert.is_true(route.steps[1].optional == nil or route.steps[1].optional == false)
        assert.equals(0, #warnings)
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
