-- TuFFlevels / Panel.lua
--
-- Everything the slash commands do, as buttons. Plus first-run setup so the
-- addon configures itself instead of asking you to type anything.

local ADDON, ns = ...
local Compat = ns.Compat

local Panel = {}
ns.Panel = Panel

local panel

--------------------------------------------------------------------------
-- First run
--------------------------------------------------------------------------

-- Runs once per install. Turns on the things the addon needs to work,
-- rather than leaving them as commands you have to discover.
function Panel:FirstRunSetup()
    local db = Compat:InitSavedVar("TuFFlevelsDB")

    if db.setupDone then return false end
    db.setupDone = true

    -- NPC markers attach to nameplates, which are off by default.
    Compat:Guard(SetCVar, "nameplateShowFriends", 1)
    Compat:Guard(SetCVar, "nameplateShowFriendlyNPCs", 1)

    -- Record from the start. If you're going to level anyway, there's no
    -- reason to make you remember to switch it on first.
    if ns.Recorder and not ns.Recorder.active then
        ns.Recorder.active = true
        db.recording = true
        db.recordLog = db.recordLog or {}
        ns.Recorder.log = db.recordLog
    end

    return true
end

function Panel:ShowWelcome()
    local w = CreateFrame("Frame", "TuFFlevelsWelcome", UIParent, "BackdropTemplate")
    w:SetSize(420, 250)
    w:SetPoint("CENTER")
    w:SetFrameStrata("DIALOG")
    w:EnableMouse(true)
    w:SetMovable(true)
    w:RegisterForDrag("LeftButton")
    w:SetScript("OnDragStart", w.StartMoving)
    w:SetScript("OnDragStop", w.StopMovingOrSizing)

    ns.Theme:Skin(w)

    local t = w:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    t:SetPoint("TOP", 0, -18)
    t:SetText("TuFFlevels is ready")

    local body = w:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", 24, -52)
    body:SetPoint("TOPRIGHT", -24, -52)
    body:SetJustifyH("LEFT")
    body:SetSpacing(4)
    body:SetText(
        "Everything is switched on already. You don't need to type anything.\n\n" ..
        "|cffffd100Just play.|r Level however you think is fastest. The addon is " ..
        "recording every quest and location as you go.\n\n" ..
        "A |cffffd100!|r or |cffffd100?|r will float over the head of any NPC your " ..
        "current step needs.\n\n" ..
        "When you want to save what you've played as a route, click |cffffd100Menu|r " ..
        "on the tracker and hit Export.")

    local ok = CreateFrame("Button", nil, w, "UIPanelButtonTemplate")
    ok:SetSize(120, 24)
    ok:SetPoint("BOTTOM", 0, 18)
    ok:SetText("Got it")
    ok:SetScript("OnClick", function() w:Hide() end)

    w:Show()
end

--------------------------------------------------------------------------
-- Button panel
--------------------------------------------------------------------------

local function MakeButton(parent, label, y, onClick)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(210, 22)
    b:SetPoint("TOP", 0, y)
    b:SetText(label)
    b:SetScript("OnClick", onClick)
    return b
end

function Panel:Build()
    if panel then return end

    panel = CreateFrame("Frame", "TuFFlevelsPanel", UIParent, "BackdropTemplate")
    panel:SetSize(240, 456)
    panel:SetFrameStrata("DIALOG")
    panel:EnableMouse(true)
    panel:SetMovable(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
    panel:Hide()

    ns.Theme:Skin(panel)

    local t = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("TuFFlevels")

    panel.recBtn = MakeButton(panel, "Recording", -40, function()
        if ns.Recorder.active then ns.Recorder:Stop() else ns.Recorder:Start() end
        Panel:Refresh()
    end)

    panel.status = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    panel.status:SetPoint("TOP", 0, -64)

    MakeButton(panel, "Progress / completed", -82, function()
        ns.Progress:Toggle()
    end)

    MakeButton(panel, "Rogue", -108, function()
        ns.Rogue:Show()
    end)

    MakeButton(panel, "Where to go next", -134, function()
        ns.Zones:Show()
    end)

    MakeButton(panel, "Import spreadsheet", -160, function()
        ns.SheetImport:Show()
    end)

    MakeButton(panel, "Import a guide", -186, function()
        ns.GuideImport:Show()
    end)

    MakeButton(panel, "Recover past quests", -212, function()
        ns.Import:Show()
    end)

    MakeButton(panel, "Save this as a route", -238, function()
        ns.Recorder:ShowExport()
    end)

    MakeButton(panel, "Add a note here", -264, function()
        Panel:PromptNote()
    end)

    MakeButton(panel, "Mark this spot", -290, function()
        ns.Recorder:AddMark("Travel")
        Panel:Refresh()
    end)

    panel.arrowBtn = MakeButton(panel, "Arrow", -272, function()
        ns.Arrow:Toggle() ; Panel:Refresh()
    end)

    panel.mobBtn = MakeButton(panel, "Objective mobs", -298, function()
        ns.Marker:ToggleMobs() ; Panel:Refresh()
    end)

    panel.markerBtn = MakeButton(panel, "NPC markers", -324, function()
        ns.Marker:Toggle()
        Panel:Refresh()
    end)

    panel.platesBtn = MakeButton(panel, "Friendly nameplates", -350, function()
        local cur = Compat:Guard(GetCVar, "nameplateShowFriends")
        if cur == "1" then ns.Marker:DisableFriendlyPlates()
        else ns.Marker:EnableFriendlyPlates() end
        Panel:Refresh()
    end)

    panel.routeBtn = MakeButton(panel, "Choose route", -376, function()
        Panel:ShowRoutePicker()
    end)

    MakeButton(panel, "Close", -410, function() panel:Hide() end)

    ns.Theme:SkinChildren(panel)
    t:SetTextColor(unpack(ns.Theme.color.lilac))
end

function Panel:Refresh()
    if not panel then return end

    local rec = ns.Recorder and ns.Recorder.active
    panel.recBtn:SetText(rec and "Stop recording" or "Start recording")
    panel.status:SetText(("%d steps recorded"):format(ns.Recorder and #ns.Recorder.log or 0))

    panel.markerBtn:SetText(ns.Marker and ns.Marker.enabled
        and "NPC markers: on" or "NPC markers: off")
    panel.arrowBtn:SetText(ns.Arrow and ns.Arrow.enabled and "Arrow: on" or "Arrow: off")
    panel.mobBtn:SetText(ns.Marker and ns.Marker.markMobs
        and "Objective mobs: on" or "Objective mobs: off")

    local cur = Compat:Guard(GetCVar, "nameplateShowFriends")
    panel.platesBtn:SetText(cur == "1" and "Nameplates: on" or "Nameplates: off")
end

function Panel:Toggle()
    self:Build()
    if panel:IsShown() then
        panel:Hide()
    else
        panel:ClearAllPoints()
        panel:SetPoint("TOPLEFT", TuFFlevelsFrame or UIParent, "TOPRIGHT", 8, 0)
        panel:Show()
        self:Refresh()
    end
end

--------------------------------------------------------------------------
-- Note prompt
--------------------------------------------------------------------------

function Panel:PromptNote()
    if not self.noteBox then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(380, 120)
        f:SetPoint("CENTER")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetPoint("TOP", 0, -16)
        lbl:SetText("Note for the last step:")

        local eb = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
        eb:SetSize(330, 24)
        eb:SetPoint("CENTER", 0, 0)
        eb:SetAutoFocus(true)
        eb:SetScript("OnEnterPressed", function(self)
            local txt = self:GetText()
            if txt and txt ~= "" then ns.Recorder:AddNote(txt) end
            self:SetText("")
            f:Hide()
        end)
        eb:SetScript("OnEscapePressed", function(self) self:SetText("") f:Hide() end)
        f.edit = eb

        local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        hint:SetPoint("BOTTOM", 0, 14)
        hint:SetText("Enter to save, Escape to cancel")

        self.noteBox = f
    end

    self.noteBox:Show()
    self.noteBox.edit:SetFocus()
end

--------------------------------------------------------------------------
-- Route picker
--------------------------------------------------------------------------

function Panel:ShowRoutePicker()
    if self.picker then self.picker:Hide() end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(300, 260)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Choose a route")

    local y = -42
    local count = 0
    for name, route in pairs(ns.Core.routes) do
        local label = ("%s  (%s-%s)"):format(name,
            route.levels and route.levels[1] or "?",
            route.levels and route.levels[2] or "?")
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(260, 22)
        b:SetPoint("TOP", 0, y)
        b:SetText(label)
        b:SetScript("OnClick", function()
            ns.Core:LoadRoute(name)
            f:Hide()
        end)
        y = y - 26
        count = count + 1
    end

    if count == 0 then
        local none = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        none:SetPoint("CENTER")
        none:SetText("No routes installed yet.\nPlay, then Save this as a route.")
    end

    local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOM", 0, 14)
    close:SetText("Close")
    close:SetScript("OnClick", function() f:Hide() end)

    self.picker = f
    f:Show()
end
