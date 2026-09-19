-- TuFFlevels / Progress.lua
--
-- A checklist of your route: what's done, where you are, what's left.
-- Click any line to jump to it.

local ADDON, ns = ...
local Compat = ns.Compat

local Progress = {}
ns.Progress = Progress

local ROWS = 16
local ROW_H = 18

local win, rows, slider
local offset = 0
local filter = "all"      -- all | done | todo

--------------------------------------------------------------------------
-- Completed quest totals
--------------------------------------------------------------------------

-- Every quest ID the character has ever completed. Not guaranteed present
-- on every client, so treat a nil return as "unknown" rather than zero.
function Progress:TotalCompletedQuests()
    if not (C_QuestLog and C_QuestLog.GetAllCompletedQuestIDs) then return nil end
    local list = Compat:Guard(C_QuestLog.GetAllCompletedQuestIDs)
    if type(list) ~= "table" then return nil end
    return #list
end

-- How much of the loaded route is finished.
function Progress:RouteStats()
    local route = ns.Core and ns.Core.active
    if not route then return 0, 0, 0, 0 end

    local done, total, questsDone, questsTotal = 0, 0, 0, 0

    for _, step in ipairs(route.steps) do
        total = total + 1
        if ns.Core.IsStepDone(step) then done = done + 1 end

        if step.quest and step.type == "turnin" then
            questsTotal = questsTotal + 1
            if Compat:IsQuestComplete(step.quest) then
                questsDone = questsDone + 1
            end
        end
    end

    return done, total, questsDone, questsTotal
end

-- Quests turned in during this recording session.
function Progress:SessionTurnIns()
    local out = {}
    if not ns.Recorder then return out end
    for _, e in ipairs(ns.Recorder.log) do
        if e.kind == "turnin" then table.insert(out, e) end
    end
    return out
end

--------------------------------------------------------------------------
-- Row data
--------------------------------------------------------------------------

local function BuildList()
    local route = ns.Core and ns.Core.active
    local list = {}
    if not route then return list end

    for i, step in ipairs(route.steps) do
        if ns.Core.StepApplies(step) then
            local isDone = (i < ns.Core.index) or ns.Core.IsStepDone(step)
            local isCurrent = (i == ns.Core.index)

            local include = (filter == "all")
                or (filter == "done" and isDone)
                or (filter == "todo" and not isDone)

            if step.type == "section" then
                table.insert(list, {
                    index = i, step = step, isSection = true,
                    done = (i < ns.Core.index), current = false,
                })
            elseif include then
                table.insert(list, {
                    index = i, step = step,
                    done = isDone, current = isCurrent,
                })
            end
        end
    end
    return list
end

local function RowLabel(entry)
    local s = entry.step
    local what

    if s.type == "grind" or s.type == "level" then
        what = "Reach level " .. (s.targetLevel or "?")
    else
        what = s.name or (s.quest and ("Quest " .. s.quest)) or s.type
    end

    local verb = ({
        accept = "Accept", turnin = "Turn in", complete = "Complete",
        grind = "", level = "", travel = "Go to", hearth = "Hearth",
        manual = "Do", note = "", })[s.type] or s.type

    local line = (verb ~= "" and (verb .. ": ") or "") .. what
    if s.npc then line = line .. " |cff808080(" .. s.npc .. ")|r" end
    return line
end

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------

function Progress:Build()
    if win then return end

    win = CreateFrame("Frame", "TuFFlevelsProgress", UIParent, "BackdropTemplate")
    win:SetSize(460, 400)
    win:SetPoint("CENTER")
    win:SetFrameStrata("DIALOG")
    win:EnableMouse(true)
    win:SetMovable(true)
    win:RegisterForDrag("LeftButton")
    win:SetScript("OnDragStart", win.StartMoving)
    win:SetScript("OnDragStop", win.StopMovingOrSizing)
    win:Hide()

    ns.Theme:Skin(win)

    local t = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Progress")

    win.summary = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    win.summary:SetPoint("TOPLEFT", 18, -34)
    win.summary:SetPoint("TOPRIGHT", -18, -34)
    win.summary:SetJustifyH("LEFT")

    -- filter buttons
    local function FilterButton(label, mode, x)
        local b = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        b:SetSize(70, 20)
        b:SetPoint("TOPLEFT", x, -66)
        b:SetText(label)
        b:SetScript("OnClick", function()
            filter = mode ; offset = 0 ; Progress:Refresh()
        end)
        return b
    end
    win.fAll  = FilterButton("All", "all", 18)
    win.fDone = FilterButton("Done", "done", 92)
    win.fTodo = FilterButton("To do", "todo", 166)

    -- rows
    rows = {}
    for i = 1, ROWS do
        local r = CreateFrame("Button", nil, win)
        r:SetSize(400, ROW_H)
        r:SetPoint("TOPLEFT", 18, -92 - (i - 1) * ROW_H)

        r.icon = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        r.icon:SetPoint("LEFT", 0, 0)
        r.icon:SetWidth(20)

        r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        r.text:SetPoint("LEFT", 22, 0)
        r.text:SetPoint("RIGHT", 0, 0)
        r.text:SetJustifyH("LEFT")

        r:SetScript("OnClick", function(self)
            if self.stepIndex then
                ns.Core.index = self.stepIndex
                ns.Core:Save()
                if ns.UI then ns.UI:Refresh() end
                if ns.Marker then ns.Marker:RescanAll() end
                Progress:Refresh()
            end
        end)

        local hl = r:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints()
        hl:SetColorTexture(1, 1, 1, 0.08)

        rows[i] = r
    end

    slider = CreateFrame("Slider", nil, win, "UIPanelScrollBarTemplate")
    slider:SetPoint("TOPRIGHT", -14, -100)
    slider:SetPoint("BOTTOMRIGHT", -14, 52)
    slider:SetMinMaxValues(0, 1)
    slider:SetValueStep(1)
    slider:SetObeyStepOnDrag(true)
    slider:SetValue(0)
    ns.Theme:SkinChildren(win)
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    slider:SetScript("OnValueChanged", function(self, value)
        offset = math.floor(value)
        Progress:RenderRows()
    end)

    win:EnableMouseWheel(true)
    win:SetScript("OnMouseWheel", function(self, delta)
        slider:SetValue(slider:GetValue() - delta * 3)
    end)

    local jump = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
    jump:SetSize(140, 22)
    jump:SetPoint("BOTTOMLEFT", 18, 16)
    jump:SetText("Jump to current")
    jump:SetScript("OnClick", function()
        local list = BuildList()
        for i, e in ipairs(list) do
            if e.current then slider:SetValue(math.max(0, i - 3)) break end
        end
    end)

    local close = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOMRIGHT", -18, 16)
    close:SetText("Close")
    close:SetScript("OnClick", function() win:Hide() end)
end

function Progress:RenderRows()
    local list = BuildList()

    for i = 1, ROWS do
        local r = rows[i]
        local e = list[i + offset]

        if e then
            local mark, color
            if e.current then
                mark, color = "|cffffd100>|r", "|cffffd100"
            elseif e.done then
                mark, color = "|cff00ff00v|r", "|cff808080"
            else
                mark, color = "|cff505050-|r", "|cffffffff"
            end

            r.icon:SetText(mark)
            r.text:SetText(color .. RowLabel(e) .. "|r")
            r.stepIndex = e.index
            r:Show()
        else
            r:Hide()
            r.stepIndex = nil
        end
    end

    local maxOffset = math.max(0, #list - ROWS)
    slider:SetMinMaxValues(0, maxOffset)
    if offset > maxOffset then offset = maxOffset end
end

function Progress:Refresh()
    if not win then return end

    local done, total, qDone, qTotal = self:RouteStats()
    local lifetime = self:TotalCompletedQuests()

    local pct = total > 0 and math.floor(done / total * 100) or 0

    local text = ("Route: |cffffd100%d of %d steps|r (%d%%)   Quests in route: |cff00ff00%d of %d|r")
        :format(done, total, pct, qDone, qTotal)

    if lifetime then
        text = text .. ("\nQuests completed on this character: |cff00ff00%d|r"):format(lifetime)
    end

    local session = #self:SessionTurnIns()
    if session > 0 then
        text = text .. ("   This session: |cff00ff00%d|r"):format(session)
    end

    win.summary:SetText(text)
    self:RenderRows()
end

function Progress:Toggle()
    self:Build()
    if win:IsShown() then
        win:Hide()
    else
        win:Show()
        offset = 0
        self:Refresh()
        -- open on the current step rather than the top
        local list = BuildList()
        for i, e in ipairs(list) do
            if e.current then slider:SetValue(math.max(0, i - 3)) break end
        end
    end
end
