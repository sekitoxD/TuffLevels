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
end)
