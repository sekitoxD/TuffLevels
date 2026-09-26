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
end)
