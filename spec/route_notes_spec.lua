-- spec/route_notes_spec.lua
--
-- Guards against raw RXPGuides dot-directives (".mob X", ".isOnQuest 7",
-- ".zoneskip Y", ".money <1", ...) leaking into a shipped route's note/name
-- text, where the tracker would show them verbatim ("NOTE: .mob Yarrog
-- Baneshadow"). RXPImport used to do this; tools/clean_route_notes.lua
-- cleans an existing file. Reads route files as plain text - no WoW globals.

local ROUTES = {
    "Routes/Alliance/Human.lua",
    "Routes/Alliance/DwarfGnome.lua",
    "Routes/Alliance/NightElf.lua",
    "Routes/Horde/Mulgore.lua",
    "Routes/Horde/OrcTrollRXP.lua",
    "Routes/Horde/Durotar.lua",
    "Routes/Horde/TirisfalStart.lua",
}

-- Returns the first offending "file:line: segment", or nil.
local function FindResidue(path)
    local h = io.open(path, "rb")
    if not h then return nil, "cannot open " .. path end
    local lineNo = 0
    for line in h:lines() do
        lineNo = lineNo + 1
        -- skip comment lines; they legitimately quote directives
        if not line:match("^%s*%-%-") then
            for body in line:gmatch('[%s,{]n[ao][mt]e = "([^"]*)"') do
                for seg in (body .. " - "):gmatch("(.-) %- ") do
                    if seg:match("^%.%a") then
                        h:close()
                        return ("%s:%d: %s"):format(path, lineNo, seg:sub(1, 60))
                    end
                end
            end
        end
    end
    h:close()
    return nil
end

describe("shipped route notes", function()
    for _, path in ipairs(ROUTES) do
        it(path .. " has no raw RXP directive text in note/name", function()
            local bad, err = FindResidue(path)
            assert.is_nil(err)
            assert.is_nil(bad)
        end)
    end
end)
