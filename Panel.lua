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
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local body = w:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", 24, -52)
    body:SetPoint("TOPRIGHT", -24, -52)
    body:SetJustifyH("LEFT")
    body:SetSpacing(4)
    body:SetTextColor(unpack(ns.Theme.color.text))
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
    panel:SetSize(240, 576)
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
    panel.status:SetTextColor(unpack(ns.Theme.color.dim))

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

    panel.arrowBtn = MakeButton(panel, "Arrow", -316, function()
        ns.Arrow:Toggle() ; Panel:Refresh()
    end)

    panel.mobBtn = MakeButton(panel, "Objective mobs", -342, function()
        ns.Marker:ToggleMobs() ; Panel:Refresh()
    end)

    panel.markerBtn = MakeButton(panel, "NPC markers", -368, function()
        ns.Marker:Toggle()
        Panel:Refresh()
    end)

    panel.platesBtn = MakeButton(panel, "Friendly nameplates", -394, function()
        local cur = Compat:Guard(GetCVar, "nameplateShowFriends")
        if cur == "1" then ns.Marker:DisableFriendlyPlates()
        else ns.Marker:EnableFriendlyPlates() end
        Panel:Refresh()
    end)

    panel.routeBtn = MakeButton(panel, "Choose route", -420, function()
        Panel:ShowRoutePicker()
    end)

    MakeButton(panel, "Colors", -446, function()
        Panel:ShowColorPicker()
    end)

    MakeButton(panel, "Reset arrow position", -472, function()
        ns.Arrow:ResetPosition()
    end)

    MakeButton(panel, "Catch up on quests", -498, function()
        Panel:ShowCatchUpDialog()
    end)

    MakeButton(panel, "Close", -530, function() panel:Hide() end)

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
        lbl:SetTextColor(unpack(ns.Theme.color.text))

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
        hint:SetTextColor(unpack(ns.Theme.color.dim))

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
    f:SetSize(320, 260)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Choose a route")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local y = -42
    local count = 0
    for name, route in pairs(ns.Core.routes) do
        local suffix = ("  (%s-%s)"):format(
            route.levels and route.levels[1] or "?",
            route.levels and route.levels[2] or "?")
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(280, 22)
        b:SetPoint("TOP", 0, y)

        local fs = b:GetFontString()
        if fs then
            local fontFile, _, fontFlags = fs:GetFont()
            fs:SetFont(fontFile, 11, fontFlags)
        end

        b:SetText(name .. suffix)

        -- Last resort if it still overflows at the smaller size: trim the
        -- route name (never the level range) with an ellipsis.
        if fs then
            local avail = b:GetWidth() - 20
            local trimmed = name
            while fs:GetStringWidth() > avail and #trimmed > 4 do
                trimmed = trimmed:sub(1, #trimmed - 1)
                b:SetText(trimmed .. "..." .. suffix)
            end
        end

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
        none:SetTextColor(unpack(ns.Theme.color.dim))
    end

    local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOM", 0, 14)
    close:SetText("Close")
    close:SetScript("OnClick", function() f:Hide() end)

    self.picker = f
    f:Show()
end

--------------------------------------------------------------------------
-- Catch-up dialog
--------------------------------------------------------------------------

-- Confirms before jumping, since a route can run to ~3000 steps and
-- Core:CatchUp(true) would otherwise silently teleport the tracked step.
function Panel:ShowCatchUpDialog()
    if self.catchUpBox then self.catchUpBox:Hide() end

    local Core = ns.Core
    if not Core.active then
        ns.Print("No route loaded.")
        return
    end

    local furthest = Core:PreviewCatchUp()
    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(360, 150)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Catch up on quests")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", 20, -46)
    body:SetPoint("TOPRIGHT", -20, -46)
    body:SetJustifyH("LEFT")
    body:SetSpacing(4)
    body:SetTextColor(unpack(ns.Theme.color.text))

    local canJump = furthest and furthest > Core.index
    if canJump then
        body:SetText(("Jump from step %d to step %d of %d?\nScans forward for quests already done."):format(
            Core.index, furthest, #Core.active.steps))
    else
        body:SetText("Already caught up - nothing ahead looks done.")
    end

    local confirm = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    confirm:SetSize(100, 22)

    if canJump then
        confirm:SetPoint("BOTTOM", -55, 16)
        confirm:SetText("Confirm")
        confirm:SetScript("OnClick", function()
            Core:CatchUp(true)
            f:Hide()
            Panel:Refresh()
        end)

        local cancel = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        cancel:SetSize(100, 22)
        cancel:SetPoint("BOTTOM", 55, 16)
        cancel:SetText("Cancel")
        cancel:SetScript("OnClick", function() f:Hide() end)
    else
        confirm:SetPoint("BOTTOM", 0, 16)
        confirm:SetText("Close")
        confirm:SetScript("OnClick", function() f:Hide() end)
    end

    self.catchUpBox = f
    f:Show()
end

--------------------------------------------------------------------------
-- Color picker
--------------------------------------------------------------------------

-- Palette changes apply immediately: Theme:ApplyPalette() updates the live
-- color tables and Theme:ReapplyAll() repaints every already-built frame
-- Skin()/SkinButton() touched, instead of waiting for the next /reload.
function Panel:ShowColorPicker()
    if self.colorPicker then self.colorPicker:Hide() end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(340, 440)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Colors")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local presetNames = {}
    for name in pairs(ns.Theme.presets) do table.insert(presetNames, name) end
    table.sort(presetNames)

    local y = -42
    for _, name in ipairs(presetNames) do
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(200, 22)
        b:SetPoint("TOP", 0, y)
        b:SetText(name)
        b:SetScript("OnClick", function()
            local db = Compat:InitSavedVar("TuFFlevelsDB")
            db.customTheme = ns.Theme.presets[name]
            ns.Theme:ApplyPalette(db.customTheme)
            ns.Theme:ReapplyAll()
            ns.Print(("Palette set to %s."):format(name))
        end)
        y = y - 26
    end

    local hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hint:SetPoint("TOPLEFT", 18, y - 10)
    hint:SetPoint("TOPRIGHT", -18, y - 10)
    hint:SetJustifyH("LEFT")
    hint:SetTextColor(unpack(ns.Theme.color.dim))
    hint:SetText("You can create your own custom color palette: paste comma-separated\n" ..
        "key=RRGGBB pairs below (e.g. orchid=3399ff,text=ffffff).\n" ..
        "Keys: void, bg, panel, raised, blood, ember, violet, orchid, lilac,\n" ..
        "text, dim, faint, done, warn")

    local eb = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    eb:SetSize(280, 24)
    eb:SetPoint("TOP", hint, "BOTTOM", 0, -28)
    eb:SetAutoFocus(false)
    eb:SetScript("OnEnterPressed", function(self)
        local text = self:GetText()
        self:ClearFocus()
        if text == "" then return end

        local updates, bad = {}, {}
        for pair in text:gmatch("[^,]+") do
            local key, hex = pair:match("^%s*(%a+)%s*=%s*(%x%x%x%x%x%x)%s*$")
            if key then
                updates[key:lower()] = hex:lower()
            else
                table.insert(bad, pair)
            end
        end

        if #bad > 0 then
            ns.Print("|cffff5555Rejected, malformed entr" ..
                (#bad == 1 and "y: " or "ies: ") .. table.concat(bad, ", ") .. "|r")
            return
        end

        local db = Compat:InitSavedVar("TuFFlevelsDB")
        db.customTheme = db.customTheme or {}
        for key, hex in pairs(updates) do
            db.customTheme[key] = hex
        end
        ns.Theme:ApplyPalette(updates)
        ns.Theme:ReapplyAll()
        self:SetText("")
        ns.Print("Custom colors applied.")
    end)

    local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOM", 0, 14)
    close:SetText("Close")
    close:SetScript("OnClick", function() f:Hide() end)

    self.colorPicker = f
    f:Show()
end
