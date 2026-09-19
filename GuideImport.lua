-- TuFFlevels / GuideImport.lua
--
-- Reads guides written in the Guidelime tag format and converts them into
-- TuFFlevels routes.
--
-- WHY THIS EXISTS, AND WHAT IT DELIBERATELY DOES NOT DO
--
-- There is a large body of free, community-made leveling guides in this
-- format. Those are other people's work. This addon ships none of them and
-- copies none of them.
--
-- What it does is read a guide YOU already have - one you installed from
-- CurseForge, or a file you wrote, or text you pasted in. Same arrangement
-- as the quest database: the data stays with whoever published it, we just
-- know how to read the format.
--
-- If you publish a route built from someone else's guide, credit them and
-- check their terms first. Format compatibility is not permission.
--
-- Tag reference: github.com/max-ri/Guidelime/wiki/WriteAGuide

local ADDON, ns = ...
local Compat = ns.Compat

local GuideImport = {}
ns.GuideImport = GuideImport

--------------------------------------------------------------------------
-- Parser
--------------------------------------------------------------------------

-- Pulls every [TAG value] out of a line, returns them in order plus the
-- leftover plain text.
local function ExtractTags(line)
    local tags = {}
    local text = line:gsub("%[(%u+)%s*([^%]]*)%]", function(code, value)
        table.insert(tags, { code = code, value = (value or ""):match("^%s*(.-)%s*$") })
        return ""
    end)
    return tags, text:match("^%s*(.-)%s*$")
end

-- "48,42 Elwynn Forest" -> 48, 42, "Elwynn Forest"
local function ParseCoords(value)
    local x, y, zone = value:match("^([%d%.]+)%s*,%s*([%d%.]+)%s*(.*)$")
    if not x then return nil end
    return tonumber(x), tonumber(y), (zone ~= "" and zone or nil)
end

-- Quest IDs may carry a chain part: "123,1"
local function ParseQuestID(value)
    local id = value:match("^(%d+)")
    return tonumber(id)
end

function GuideImport:Parse(text)
    local route = {
        faction = nil,
        races = nil,
        levels = nil,
        steps = {},
        source = nil,
    }

    local name
    local warnings = {}
    local lineNo = 0

    for line in (text .. "\n"):gmatch("(.-)\n") do
        lineNo = lineNo + 1
        line = line:match("^%s*(.-)%s*$")

        if line ~= "" and not line:match("^%-%-") then
            local tags, plain = ExtractTags(line)

            -- pending step built from this line's tags
            local pending = nil
            local coords = nil
            local npc = nil

            for _, tag in ipairs(tags) do
                local c, v = tag.code, tag.value

                if c == "N" then
                    -- [N 1-11 Elwynn Forest]
                    local lo, hi, zone = v:match("^(%d+)%s*%-%s*(%d+)%s*(.*)$")
                    if lo then
                        route.levels = { tonumber(lo), tonumber(hi) }
                        name = (zone ~= "" and zone or v)
                    else
                        name = v
                    end

                elseif c == "GA" then
                    route.faction = v

                elseif c == "D" then
                    route.source = v:gsub("\\\\", " ")

                elseif c == "G" then
                    local x, y, zone = ParseCoords(v)
                    if x then coords = { x = x, y = y, zone = zone } end

                elseif c == "TAR" then
                    npc = v

                elseif c == "QA" then
                    pending = pending or {}
                    table.insert(pending, { type = "accept", quest = ParseQuestID(v) })

                elseif c == "QT" then
                    pending = pending or {}
                    table.insert(pending, { type = "turnin", quest = ParseQuestID(v) })

                elseif c == "QC" then
                    pending = pending or {}
                    table.insert(pending, { type = "complete", quest = ParseQuestID(v) })

                elseif c == "QS" then
                    -- explicit skip: record as a note so the advice survives
                    pending = pending or {}
                    table.insert(pending, { type = "note",
                        name = "Skip quest " .. (ParseQuestID(v) or "?") })

                elseif c == "NX" then
                    pending = pending or {}
                    table.insert(pending, { type = "note", name = "Next guide: " .. v })

                elseif c == "O" or c == "OC" then
                    -- ongoing / optional markers: no direct equivalent,
                    -- carried through as a hint on the step text
                    plain = (plain ~= "" and plain or "")

                elseif c == "L" then
                    -- [L level] reach a level
                    local lvl = tonumber(v:match("^(%d+)"))
                    if lvl then
                        pending = pending or {}
                        table.insert(pending, { type = "grind", targetLevel = lvl })
                    end
                end
            end

            -- A line with coordinates but no quest tag is a travel step.
            if not pending and coords then
                pending = { { type = "travel" } }
            end

            if pending then
                for _, step in ipairs(pending) do
                    if plain ~= "" then step.name = step.name or plain end
                    if npc then step.npc = npc end
                    if coords then
                        step.x, step.y = coords.x, coords.y
                        step.zone = coords.zone
                    end
                    table.insert(route.steps, step)
                end
            elseif plain ~= "" and #tags == 0 then
                table.insert(route.steps, { type = "note", name = plain })
            end
        end
    end

    if #route.steps == 0 then
        table.insert(warnings, "No steps found. Is this Guidelime format?")
    end

    -- Coordinates in this format are zone-relative by name, not uiMapID.
    -- We can't resolve those without a zone table, so waypoints on imported
    -- steps will be limited until the route is walked once with recording on.
    local noMap = 0
    for _, s in ipairs(route.steps) do
        if s.x and not s.map then noMap = noMap + 1 end
    end
    if noMap > 0 then
        table.insert(warnings,
            ("%d steps have coordinates but no map ID. Zone names need resolving - "
             .. "walk the route once with recording on to fill them in."):format(noMap))
    end

    return route, name or "Imported guide", warnings
end

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------

local win

function GuideImport:Show()
    if not win then
        win = CreateFrame("Frame", "TuFFlevelsGuideImport", UIParent, "BackdropTemplate")
        win:SetSize(640, 500)
        win:SetPoint("CENTER")
        win:SetFrameStrata("DIALOG")
        win:EnableMouse(true)
        win:SetMovable(true)
        win:RegisterForDrag("LeftButton")
        win:SetScript("OnDragStart", win.StartMoving)
        win:SetScript("OnDragStop", win.StopMovingOrSizing)

        ns.Theme:Skin(win)

        local t = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Import a community guide")

        local help = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        help:SetPoint("TOP", 0, -32)
        help:SetWidth(580)
        help:SetText("Paste a guide in Guidelime format below, then Convert. " ..
                     "Use only guides you're allowed to use, and credit the author.")

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsGuideImportScroll", win,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 16, -56)
        scroll:SetPoint("BOTTOMRIGHT", -34, 76)

        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetMultiLine(true)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(580)
        edit:SetAutoFocus(false)
        edit:SetScript("OnEscapePressed", function() win:Hide() end)
        scroll:SetScrollChild(edit)
        win.edit = edit

        win.status = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        win.status:SetPoint("BOTTOMLEFT", 18, 46)
        win.status:SetPoint("BOTTOMRIGHT", -18, 46)
        win.status:SetJustifyH("LEFT")

        local convert = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        convert:SetSize(140, 22)
        convert:SetPoint("BOTTOMLEFT", 16, 16)
        convert:SetText("Convert")
        convert:SetScript("OnClick", function()
            GuideImport:DoConvert(win.edit:GetText())
        end)

        local close = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOMRIGHT", -16, 16)
        close:SetText("Close")
        close:SetScript("OnClick", function() win:Hide() end)
        ns.Theme:SkinChildren(win)
        t:SetTextColor(unpack(ns.Theme.color.lilac))
    end

    win:Show()
    win.status:SetText("")
end

function GuideImport:DoConvert(text)
    if not text or text:match("^%s*$") then
        win.status:SetText("|cffff5555Nothing pasted.|r")
        return
    end

    local route, name, warnings = self:Parse(text)

    if #route.steps == 0 then
        win.status:SetText("|cffff5555" .. (warnings[1] or "Parse failed.") .. "|r")
        return
    end

    ns.RegisterRoute(name, route)
    ns.Core:LoadRoute(name)

    local msg = ("|cff00ff00Imported '%s' - %d steps.|r"):format(name, #route.steps)
    if route.source then
        msg = msg .. "\n|cff909090Source: " .. route.source .. "|r"
    end
    for _, w in ipairs(warnings) do
        msg = msg .. "\n|cffffff00" .. w .. "|r"
    end
    msg = msg .. "\n|cff909090This route lives in memory only. Use Save this as a route to keep it.|r"

    win.status:SetText(msg)
    if ns.UI then ns.UI:Refresh() end
    if ns.Panel then ns.Panel:Refresh() end
end
