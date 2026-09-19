-- TuFFlevels / Progress.lua
--
-- A checklist of your route: what's done, where you are, what's left.
-- Click any line to jump to it.

local ADDON, ns = ...
local Compat = ns.Compat

local Progress = {}
ns.Progress = Progress

local ROW_H = 18
local ROW_TOP = 92     -- offset from the top where the row list starts
local ROW_BOTTOM = 52  -- offset reserved at the bottom for the slider/buttons

local win, rows, slider, EnsureRow
local visibleRows = 16
local offset = 0
local filter = "all"      -- all | done | todo

-- Recomputes how many rows fit in the window's current height, growing the
-- row-button pool as needed (rows are never destroyed, only hidden) and
-- hiding any pooled rows beyond what currently fits.
local function RecomputeRows()
    if not win then return end
    local avail = win:GetHeight() - ROW_TOP - ROW_BOTTOM
    visibleRows = math.max(1, math.floor(avail / ROW_H))
    for i = 1, visibleRows do EnsureRow(i) end
    for i, r in pairs(rows) do
        if i > visibleRows then
            r:Hide()
            r.stepIndex = nil
        end
    end
end

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
                    done = (i < ns.Core.index), current = isCurrent,
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

-- Scrolls to the live current step regardless of the active filter. A
-- non-"all" filter can exclude the current step from the list entirely
-- (e.g. filter "done" while the current step isn't done yet), which would
-- otherwise leave "Jump to current" with nothing to find and silently do
-- nothing - fall back to "all" so the jump always succeeds.
local function ScrollToCurrent()
    local list = BuildList()
    for i, e in ipairs(list) do
        if e.current then
            slider:SetValue(math.max(0, i - 3))
            return
        end
    end

    if filter ~= "all" then
        filter = "all"
        Progress:Refresh()
        list = BuildList()
        for i, e in ipairs(list) do
            if e.current then
                slider:SetValue(math.max(0, i - 3))
                return
            end
        end
    end
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

    win:SetResizable(true)
    Compat:SetResizeBounds(win, 320, 220, 900, 900)

    local pdb = Compat:InitSavedVar("TuFFlevelsDB")
    if pdb.progressSize then
        win:SetSize(unpack(pdb.progressSize))
    end

    ns.Theme:Skin(win)

    local t = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Progress")

    win.summary = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    win.summary:SetPoint("TOPLEFT", 18, -34)
    win.summary:SetPoint("TOPRIGHT", -18, -34)
    win.summary:SetJustifyH("LEFT")
    win.summary:SetTextColor(unpack(ns.Theme.color.text))

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

    -- rows - pooled lazily by EnsureRow/RecomputeRows so the list can grow
    -- or shrink with the window's height instead of a fixed count of 16.
    rows = {}
    EnsureRow = function(i)
        if rows[i] then return rows[i] end

        local r = CreateFrame("Button", nil, win)
        r:SetHeight(ROW_H)
        r:SetPoint("TOPLEFT", 18, -ROW_TOP - (i - 1) * ROW_H)
        r:SetPoint("TOPRIGHT", -34, -ROW_TOP - (i - 1) * ROW_H)

        r.icon = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        r.icon:SetPoint("LEFT", 0, 0)
        r.icon:SetWidth(20)

        r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        r.text:SetPoint("LEFT", 22, 0)
        r.text:SetPoint("RIGHT", 0, 0)
        r.text:SetJustifyH("LEFT")

        r:SetScript("OnClick", function(self)
            if self.stepIndex then
                ns.Core:SetIndex(self.stepIndex, { pin = true })
                Progress:Refresh()
            end
        end)

        local hl = r:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints()
        hl:SetColorTexture(1, 1, 1, 0.08)

        rows[i] = r
        return r
    end
    RecomputeRows()

    -- A bare, template-free slider. UIPanelScrollBarTemplate resolves to
    -- Blizzard's secure-snippet-based scrollbar (SecureScrollTemplates.lua)
    -- on this client, and Compat.lua already documents that secure
    -- snippets/WrapScript throw on Forever - every SetValue() call,
    -- including the engine's own call when the user drags the thumb,
    -- errored. A hand-built Slider needs nothing beyond the base Slider
    -- API (SetOrientation/SetThumbTexture), unchanged across all three
    -- clients, so it sidesteps the broken template entirely.
    slider = CreateFrame("Slider", nil, win)
    slider:SetOrientation("VERTICAL")
    slider:SetPoint("TOPRIGHT", -14, -100)
    slider:SetPoint("BOTTOMRIGHT", -14, 52)
    slider:SetWidth(16)
    slider:EnableMouse(true)
    slider:SetMinMaxValues(0, 1)
    slider:SetValueStep(1)
    slider:SetObeyStepOnDrag(true)

    local sliderTrack = slider:CreateTexture(nil, "BACKGROUND")
    sliderTrack:SetPoint("TOP", 0, -2)
    sliderTrack:SetPoint("BOTTOM", 0, 2)
    sliderTrack:SetWidth(4)

    local sliderThumb = slider:CreateTexture(nil, "OVERLAY")
    sliderThumb:SetSize(16, 28)
    slider:SetThumbTexture(sliderThumb)

    local function paintSlider()
        sliderTrack:SetColorTexture(unpack(ns.Theme.color.faint))
        sliderThumb:SetColorTexture(unpack(ns.Theme.color.violet))
    end
    paintSlider()
    ns.Theme._skinned[slider] = paintSlider

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
    jump:SetScript("OnClick", ScrollToCurrent)

    local close = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOMRIGHT", -18, 16)
    close:SetText("Close")
    close:SetScript("OnClick", function() win:Hide() end)

    -- resize grip, hanging just outside the corner so it doesn't overlap
    -- the "Close" button sitting at the window's own bottom-right edge
    local grip = CreateFrame("Button", nil, win)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", 10, -10)
    local gripTex = grip:CreateTexture(nil, "OVERLAY")
    gripTex:SetAllPoints()
    gripTex:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetScript("OnMouseDown", function() win:StartSizing("BOTTOMRIGHT") end)
    grip:SetScript("OnMouseUp", function()
        win:StopMovingOrSizing()
        local db = Compat:InitSavedVar("TuFFlevelsDB")
        db.progressSize = { win:GetWidth(), win:GetHeight() }
        RecomputeRows()
        Progress:Refresh()
    end)
end

function Progress:RenderRows()
    local list = BuildList()

    for i = 1, visibleRows do
        local r = rows[i]
        local e = list[i + offset]

        if e then
            local Hex = ns.Theme.hex
            local mark, color
            if e.current then
                mark, color = Hex.warn .. ">|r", Hex.warn
            elseif e.done then
                mark, color = Hex.done .. "v|r", Hex.dim
            else
                mark, color = Hex.faint .. "-|r", Hex.text
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

    local maxOffset = math.max(0, #list - visibleRows)
    slider:SetMinMaxValues(0, maxOffset)
    if offset > maxOffset then offset = maxOffset end
end

function Progress:Refresh()
    -- RouteStats and BuildList both walk the whole route, which is thousands
    -- of steps now. Reconcile calls this on every quest event, so a closed
    -- window has to cost nothing - existing-but-hidden is not good enough.
    if not win or not win:IsShown() then return end

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
        ScrollToCurrent()
    end
end
