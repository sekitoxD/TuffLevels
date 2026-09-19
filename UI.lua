-- TuFFlevels / UI.lua
--
-- The tracker. Laid out as a stack: section header with level band and
-- navigation, the step you just finished dimmed above, then the current
-- step expanded with its objectives, then what's coming.

local ADDON, ns = ...
local Theme = ns.Theme

local UI = {}
ns.UI = UI

local frame
local ROW_LIMIT = 4

--------------------------------------------------------------------------
-- Step presentation
--------------------------------------------------------------------------

local VERB = {
    accept   = "Start",
    turnin   = "Turn in",
    complete = "Do",
    grind    = "Grind",
    level    = "Reach",
    travel   = "Go to",
    hearth   = "Hearth",
    trainer  = "Train",
    death    = "Die",
    manual   = "Do",
    note     = "NOTE",
    section  = "",
}

local VERB_COLOR = {
    accept   = Theme.hex.done,
    turnin   = Theme.hex.bright,
    complete = Theme.hex.accent,
    grind    = Theme.hex.ember,
    travel   = Theme.hex.dim,
    hearth   = Theme.hex.accent,
    trainer  = Theme.hex.warn,
    death    = Theme.hex.ember,
    note     = Theme.hex.warn,
}

-- The quest or task name, preferring the database where we have one.
local function StepLabel(step)
    if step.type == "grind" or step.type == "level" then
        return "level " .. (step.targetLevel or "?")
    end

    local name = step.questName or step.name
    if step.quest and ns.Data and ns.Data:HasProvider() then
        name = ns.Data:GetQuestName(step.quest, name)
    end
    return name or step.type
end

-- "0/1 Burning Blade Medallion" lines, read live from the quest log.
local function Objectives(step)
    local out = {}
    local questID = step.quest
    if not questID and step.questName and ns.Core.ResolveQuest then
        questID = ns.Core.ResolveQuest(step)
    end
    if not questID then return out end

    if not (C_QuestLog and C_QuestLog.GetQuestObjectives) then return out end
    local objectives = ns.Compat:Guard(C_QuestLog.GetQuestObjectives, questID)
    if type(objectives) ~= "table" then return out end

    for _, o in ipairs(objectives) do
        if o and o.text then
            local done = o.finished
            local mark = done and (Theme.hex.done .. "v|r") or (Theme.hex.faint .. "-|r")
            local body = done and (Theme.hex.faint .. o.text .. "|r")
                              or (Theme.hex.text .. o.text .. "|r")
            table.insert(out, "   " .. mark .. " " .. body)
        end
    end
    return out
end

--------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------

function UI:Build()
    if frame then return end

    frame = CreateFrame("Frame", "TuFFlevelsFrame", UIParent)
    frame:SetSize(330, 250)
    frame:SetPoint("CENTER", UIParent, "CENTER", 340, 80)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local db = ns.Compat:InitSavedVar("TuFFlevelsDB")
        local p, _, rp, x, y = self:GetPoint()
        db.pos = { p, rp, x, y }
    end)
    Theme:Skin(frame)

    local db = ns.Compat:InitSavedVar("TuFFlevelsDB")
    if db.pos then
        local p, rp, x, y = unpack(db.pos)
        frame:ClearAllPoints()
        frame:SetPoint(p, UIParent, rp, x, y)
    end

    -- "Step: 01-16" strip along the top
    frame.stepCount = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    frame.stepCount:SetPoint("TOP", 0, -6)
    frame.stepCount:EnableMouse(false)

    local countBtn = CreateFrame("Button", nil, frame)
    countBtn:SetSize(120, 12)
    countBtn:SetPoint("TOP", 0, -5)
    countBtn:SetScript("OnClick", function() ns.Progress:Toggle() end)
    countBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Open the full progress list")
        GameTooltip:Show()
    end)
    countBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- section header bar
    local header = CreateFrame("Frame", nil, frame)
    header:SetPoint("TOPLEFT", 6, -20)
    header:SetPoint("TOPRIGHT", -6, -20)
    header:SetHeight(26)
    local hbg = header:CreateTexture(nil, "BACKGROUND")
    hbg:SetAllPoints()
    hbg:SetColorTexture(0.17, 0.05, 0.06, 0.9)
    local hline = header:CreateTexture(nil, "BORDER")
    hline:SetPoint("BOTTOMLEFT") ; hline:SetPoint("BOTTOMRIGHT")
    hline:SetHeight(1)
    hline:SetColorTexture(0.48, 0.24, 0.78, 0.8)

    frame.sectionText = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.sectionText:SetPoint("LEFT", 30, 0)
    frame.sectionText:SetPoint("RIGHT", -44, 0)
    frame.sectionText:SetJustifyH("LEFT")

    -- class portrait slot
    local portrait = header:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(20, 20)
    portrait:SetPoint("LEFT", 5, 0)
    portrait:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    frame.portrait = portrait

    local prev = CreateFrame("Button", nil, header)
    prev:SetSize(16, 16)
    prev:SetPoint("RIGHT", -24, 0)
    prev.text = prev:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    prev.text:SetAllPoints()
    prev.text:SetText(Theme:Accent("<"))
    prev:SetScript("OnClick", function() UI:JumpSection(-1) end)

    local nextB = CreateFrame("Button", nil, header)
    nextB:SetSize(16, 16)
    nextB:SetPoint("RIGHT", -6, 0)
    nextB.text = nextB:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nextB.text:SetAllPoints()
    nextB.text:SetText(Theme:Accent(">"))
    nextB:SetScript("OnClick", function() UI:JumpSection(1) end)

    -- the step just completed, dimmed - doubles as the "paused" hint and
    -- Resume click target while Core.pinned is set (see Refresh)
    frame.previous = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    frame.previous:SetPoint("TOPLEFT", 12, -52)
    frame.previous:SetPoint("TOPRIGHT", -12, -52)
    frame.previous:SetJustifyH("LEFT")
    frame.previous:SetHeight(14)

    local resumeBtn = CreateFrame("Button", nil, frame)
    resumeBtn:SetAllPoints(frame.previous)
    resumeBtn:SetScript("OnClick", function()
        if ns.Core.pinned then ns.Core:Resume() end
    end)

    -- current step body
    frame.current = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.current:SetPoint("TOPLEFT", 12, -70)
    frame.current:SetPoint("TOPRIGHT", -12, -70)
    frame.current:SetJustifyH("LEFT")
    frame.current:SetJustifyV("TOP")
    frame.current:SetSpacing(2)

    -- what's next
    frame.upcoming = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    frame.upcoming:SetPoint("BOTTOMLEFT", 12, 34)
    frame.upcoming:SetPoint("BOTTOMRIGHT", -12, 34)
    frame.upcoming:SetJustifyH("LEFT")
    frame.upcoming:SetSpacing(2)

    local function Btn(label, width, point, x, onClick)
        local b = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        b:SetSize(width, 20)
        b:SetPoint(point, x, 8)
        b:SetText(label)
        Theme:SkinButton(b)
        b:SetScript("OnClick", onClick)
        return b
    end

    Btn("Back", 56, "BOTTOMLEFT", 8, function() ns.Core:Back() end)
    Btn("Arrow", 56, "BOTTOM", -60, function()
        if ns.Arrow and ns.Arrow.Toggle then ns.Arrow:Toggle() end
    end)
    Btn("Menu", 56, "BOTTOM", 0, function() ns.Panel:Toggle() end)
    Btn("Map", 56, "BOTTOM", 60, function()
        local step = ns.Core:CurrentStep()
        if step then ns.Data:SetWaypoint(step) end
    end)
    Btn("Next", 56, "BOTTOMRIGHT", -8, function() ns.Core:Advance() end)
end

--------------------------------------------------------------------------
-- Section navigation
--------------------------------------------------------------------------

function UI:JumpSection(direction)
    local Core = ns.Core
    if not Core.active then return end

    local marks = {}
    for i, step in ipairs(Core.active.steps) do
        if step.type == "section" then table.insert(marks, i) end
    end
    if #marks == 0 then return end

    local currentMark = 1
    for i, idx in ipairs(marks) do
        if idx <= Core.index then currentMark = i end
    end

    local target = marks[math.max(1, math.min(#marks, currentMark + direction))]
    if target then
        Core:SetIndex(target, { pin = true })
    end
end

--------------------------------------------------------------------------
-- Refresh
--------------------------------------------------------------------------

function UI:Refresh()
    if not frame then return end
    local Core = ns.Core

    if not Core.active then
        frame.sectionText:SetText(Theme:Ember("No route loaded"))
        frame.current:SetText(Theme:Dim("Menu > Choose route"))
        frame.previous:SetText("")
        frame.upcoming:SetText("")
        frame.stepCount:SetText("")
        return
    end

    local total = #Core.active.steps
    frame.stepCount:SetText(Theme:Dim(("Step: %02d-%02d"):format(
        math.min(Core.index, total), total)))

    -- section header
    local section = Core:CurrentSection()
    if section then
        local band = section.levels
            and ("%d-%d "):format(section.levels[1], section.levels[2]) or ""
        frame.sectionText:SetText(Theme.hex.text .. band ..
            (section.name or "") .. "|r")
    else
        frame.sectionText:SetText(Theme:Dim(Core.active.name or ""))
    end

    -- the step behind you, dimmed and truncated
    local prevStep
    for i = Core.index - 1, 1, -1 do
        local s = Core.active.steps[i]
        if s and s.type ~= "section" then prevStep = s break end
    end
    if Core.pinned then
        frame.previous:SetText(Theme.hex.warn .. "Paused here. Next or click here to Resume.|r")
    elseif ns.Recorder and ns.Recorder.active and ns.Compat:SavedVarsAreBroken() then
        frame.previous:SetText(Theme.hex.warn ..
            ("%d steps recorded. Export before you log out.|r"):format(#ns.Recorder.log))
    elseif prevStep then
        local label = StepLabel(prevStep)
        if #label > 42 then label = label:sub(1, 40) .. "..." end
        frame.previous:SetText(Theme.hex.faint ..
            (VERB[prevStep.type] or "") .. " " .. label .. "|r")
    else
        frame.previous:SetText("")
    end

    local step = Core:CurrentStep()
    if not step then
        frame.current:SetText(Theme:Bright("Route complete."))
        frame.upcoming:SetText("")
        return
    end

    -- current step
    local lines = {}

    if step.type == "note" then
        table.insert(lines, Theme.hex.warn .. "NOTE:|r " ..
            Theme.hex.text .. (step.name or "") .. "|r")
    else
        local verb = VERB[step.type] or step.type
        local colour = VERB_COLOR[step.type] or Theme.hex.text
        table.insert(lines, ("%s%s:|r %s%s|r")
            :format(colour, verb, Theme.hex.bright, StepLabel(step)))
    end

    if step.npc then
        table.insert(lines, Theme.hex.accent .. "   " .. step.npc .. "|r")
    end

    if step.location and step.location ~= (section and section.name) then
        table.insert(lines, Theme.hex.dim .. "   " .. step.location .. "|r")
    end

    for _, line in ipairs(Objectives(step)) do
        table.insert(lines, line)
    end

    if step.logCount then
        table.insert(lines, Theme.hex.faint ..
            ("   quest log should be at %d|r"):format(step.logCount))
    end

    -- The level the route expects you to be at here. Deliberately NOT
    -- minLevel: minLevel hides a step, so tagging every step with the route's
    -- pacing would make an under-levelled character silently skip the route.
    if step.atLevel and ns.Data then
        local level = ns.Data:PlayerLevel()
        if level < step.atLevel then
            table.insert(lines, Theme.hex.warn ..
                ("   route expects level %d, you're %d - grind the gap|r"):format(step.atLevel, level))
        else
            table.insert(lines, Theme.hex.faint ..
                ("   route pace: level %d|r"):format(step.atLevel))
        end
    end

    if step.note then
        table.insert(lines, "")
        table.insert(lines, Theme.hex.warn .. "NOTE: |r" ..
            Theme.hex.dim .. step.note .. "|r")
    end

    frame.current:SetText(table.concat(lines, "\n"))

    -- upcoming
    local nextLines = {}
    local shown, i = 0, Core.index + 1
    while shown < 2 and i <= total do
        local s = Core.active.steps[i]
        if s and Core.StepApplies(s) then
            if s.type == "section" then
                table.insert(nextLines, Theme.hex.accent .. "> " .. (s.name or "") .. "|r")
            else
                local label = StepLabel(s)
                if #label > 36 then label = label:sub(1, 34) .. "..." end
                table.insert(nextLines, Theme.hex.faint ..
                    (VERB[s.type] or "") .. " " .. label .. "|r")
            end
            shown = shown + 1
        end
        i = i + 1
    end
    frame.upcoming:SetText(table.concat(nextLines, "\n"))
end

function UI:Toggle()
    if not frame then self:Build() end
    if frame:IsShown() then frame:Hide() else frame:Show() ; self:Refresh() end
end
