-- TuFFlevels / Import.lua
--
-- Builds a route from quests you already finished.
--
-- The client remembers every quest ID your character has completed. It does
-- NOT remember the order you did them in, where you were standing, or who
-- you handed them to - that information was never stored.
--
-- So this recovers what it can (which quests, their names) and marks the
-- rest as needing a pass. It turns "I already levelled to 12" from wasted
-- effort into a usable skeleton.

local ADDON, ns = ...
local Compat = ns.Compat

local Import = {}
ns.Import = Import

Import.titles = {}       -- [questID] = title
Import.pending = {}
Import.ids = {}

--------------------------------------------------------------------------
-- Gathering
--------------------------------------------------------------------------

function Import:GetCompletedIDs()
    if not (C_QuestLog and C_QuestLog.GetAllCompletedQuestIDs) then return nil end
    local list = Compat:Guard(C_QuestLog.GetAllCompletedQuestIDs)
    if type(list) ~= "table" then return nil end
    return list
end

-- Quest titles aren't held in memory for completed quests. We ask the client
-- to load each one, then read the title once it arrives.
function Import:RequestTitles(ids, onProgress, onDone)
    self.titles = {}
    self.pending = {}
    self.ids = ids

    local total = #ids
    if total == 0 then if onDone then onDone(0, 0) end return end

    for _, id in ipairs(ids) do
        self.pending[id] = true
        Compat:Guard(C_QuestLog.RequestLoadQuestByID, id)
    end

    -- Poll rather than relying purely on the load event, since some IDs
    -- never resolve and would otherwise hang the whole import.
    local elapsed = 0
    local ticker
    ticker = C_Timer.NewTicker and C_Timer.NewTicker(0.5, function()
        elapsed = elapsed + 0.5
        local got = 0

        for _, id in ipairs(ids) do
            if not self.titles[id] then
                local title = Compat:Guard(C_QuestLog.GetTitleForQuestID, id)
                if title and title ~= "" then
                    self.titles[id] = title
                    self.pending[id] = nil
                end
            end
            if self.titles[id] then got = got + 1 end
        end

        if onProgress then onProgress(got, total) end

        if got >= total or elapsed >= 8 then
            if ticker then ticker:Cancel() end
            if onDone then onDone(got, total) end
        end
    end)

    -- No ticker API: read once and move on.
    if not ticker then
        local got = 0
        for _, id in ipairs(ids) do
            local title = Compat:Guard(C_QuestLog.GetTitleForQuestID, id)
            if title and title ~= "" then self.titles[id] = title ; got = got + 1 end
        end
        if onDone then onDone(got, #ids) end
    end
end

--------------------------------------------------------------------------
-- Route text
--------------------------------------------------------------------------

local function Escape(s)
    return tostring(s or ""):gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", " ")
end

function Import:BuildRouteText(routeName)
    routeName = routeName or "Recovered"

    local _, race = UnitRace("player")
    local faction = UnitFactionGroup("player")
    local level = UnitLevel("player")

    local out = {}
    local function add(l) table.insert(out, l) end

    add("-- Recovered from quests already completed on this character.")
    add("--")
    add("-- IMPORTANT: the client does not store the ORDER you did these in,")
    add("-- where the NPCs were, or who gave them to you. That information")
    add("-- never existed to recover.")
    add("--")
    add("-- What you have here is a correct list of quest IDs and names. To")
    add("-- finish it: reorder the lines the way you actually ran them, then")
    add("-- walk the zone once with recording on to pick up coordinates and")
    add("-- NPC names, or add npc= and x=/y= by hand.")
    add("")
    add("local ADDON, ns = ...")
    add("")
    add(('ns.RegisterRoute("%s", {'):format(Escape(routeName)))
    add(('    faction = "%s",'):format(faction or "Horde"))
    add(('    races   = { "%s" },'):format(race or "Orc"))
    add(('    levels  = { 1, %d },'):format(level))
    add("")
    add("    steps = {")

    -- Sort by quest ID. Not completion order, but vanilla IDs cluster by
    -- zone and content patch, so it lands closer than random.
    local sorted = {}
    for _, id in ipairs(self.ids) do table.insert(sorted, id) end
    table.sort(sorted)

    local named, unnamed = 0, 0
    for _, id in ipairs(sorted) do
        local title = self.titles[id]
        if title then
            named = named + 1
            add(('        { type = "turnin", quest = %d, name = "%s" },'):format(id, Escape(title)))
        else
            unnamed = unnamed + 1
            add(('        { type = "turnin", quest = %d },  -- name not recovered'):format(id))
        end
    end

    add("    },")
    add("})")
    add("")
    add(("-- %d quests recovered with names, %d without."):format(named, unnamed))

    return table.concat(out, "\n")
end

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------

local win

function Import:Show()
    if not win then
        win = CreateFrame("Frame", "TuFFlevelsImport", UIParent, "BackdropTemplate")
        win:SetSize(620, 470)
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
        t:SetText("Quests you've already completed")

        win.status = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        win.status:SetPoint("TOP", 0, -34)
        win.status:SetTextColor(unpack(ns.Theme.color.text))

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsImportScroll", win,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 16, -56)
        scroll:SetPoint("BOTTOMRIGHT", -34, 46)

        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetMultiLine(true)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(560)
        edit:SetAutoFocus(false)
        edit:SetScript("OnEscapePressed", function() win:Hide() end)
        scroll:SetScrollChild(edit)
        win.edit = edit

        local sel = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        sel:SetSize(100, 22)
        sel:SetPoint("BOTTOMLEFT", 16, 16)
        sel:SetText("Select All")
        sel:SetScript("OnClick", function()
            win.edit:SetFocus() ; win.edit:HighlightText()
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

    local ids = self:GetCompletedIDs()

    if not ids then
        win.status:SetText("|cffff5555This client won't list completed quests.|r")
        win.edit:SetText(
            "The addon asked the client for your completed quest list and it\n" ..
            "declined. Nothing can be recovered this way.\n\n" ..
            "Recording from here forward still works normally.")
        return
    end

    if #ids == 0 then
        win.status:SetText("No completed quests found.")
        win.edit:SetText("")
        return
    end

    win.status:SetText(("Found %d completed quests. Looking up names..."):format(#ids))
    win.edit:SetText("Loading quest names from the server, a few seconds...")

    self:RequestTitles(ids,
        function(got, total)
            win.status:SetText(("Found %d completed quests. Names: %d of %d")
                :format(total, got, total))
        end,
        function(got, total)
            win.status:SetText(("%d completed quests, %d names recovered. Ctrl+C to copy.")
                :format(total, got))
            win.edit:SetText(self:BuildRouteText("Recovered 1-" .. UnitLevel("player")))
            win.edit:SetFocus()
            win.edit:HighlightText()
        end)
end
