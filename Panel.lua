-- TuFFlevels / Panel.lua
--
-- Everything the slash commands do, as buttons. Plus first-run setup so the
-- addon configures itself instead of asking you to type anything.

local ADDON, ns = ...
local Compat = ns.Compat

local Panel = {}
ns.Panel = Panel

local panel

-- Grows a dialog to fit its body text instead of letting the Close/Confirm
-- row overlap it - body has no bottom anchor, so GetStringHeight reflects
-- the wrapped text height after SetText. Frame stays centered since
-- SetPoint("CENTER") re-centers around the new size automatically.
local function FitDialogToBody(f, body, topOffset, bottomReserve, minHeight)
    f:SetHeight(math.max(minHeight, topOffset + body:GetStringHeight() + bottomReserve))
end

--------------------------------------------------------------------------
-- Changelog
--------------------------------------------------------------------------

local CHANGELOG_VERSION = "1.4.0"
local CHANGELOG = {
    "Added a Help / About section explaining auto progress and catch-up mode.",
    "Map button now greys out (with feedback) instead of silently doing nothing on steps with no coordinates.",
    "The SavedVariables-loss warning now mentions saved settings/theme, not just step progress.",
    "Tracker now defaults to the left side of the screen on a fresh install.",
}

function Panel:ShowChangelogDialog()
    if self.changelogBox then self.changelogBox:Hide() end

    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.lastSeenChangelogVersion = CHANGELOG_VERSION
    if ns.UI and ns.UI.Refresh then ns.UI:Refresh() end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(400, 240)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("What's new - " .. CHANGELOG_VERSION)
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", 20, -46)
    body:SetPoint("TOPRIGHT", -20, -46)
    body:SetJustifyH("LEFT")
    body:SetSpacing(6)
    body:SetTextColor(unpack(ns.Theme.color.text))

    local lines = {}
    for _, entry in ipairs(CHANGELOG) do
        table.insert(lines, "- " .. entry)
    end
    body:SetText(table.concat(lines, "\n"))

    FitDialogToBody(f, body, 46, 60, 160)

    local ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    ok:SetSize(100, 22)
    ok:SetPoint("BOTTOM", 0, 16)
    ok:SetText("Close")
    ok:SetScript("OnClick", function() f:Hide() end)

    self.changelogBox = f
    f:Show()
end

function Panel:HasUnseenChangelog()
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    return db.lastSeenChangelogVersion ~= CHANGELOG_VERSION
end

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

    FitDialogToBody(w, body, 52, 60, 250)

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
    panel:SetSize(240, 758)
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

    -- Guides / routes
    panel.routeBtn = MakeButton(panel, "Available Guides", -82, function()
        Panel:ShowRoutePicker()
    end)

    MakeButton(panel, "Where to go next", -108, function()
        ns.Zones:Show()
    end)

    MakeButton(panel, "Import spreadsheet", -134, function()
        ns.SheetImport:Show()
    end)

    MakeButton(panel, "Import a guide", -160, function()
        ns.GuideImport:Show()
    end)

    MakeButton(panel, "Write a route (text)", -186, function()
        ns.CompactGuide:Show()
    end)

    MakeButton(panel, "Recover past quests", -212, function()
        ns.Import:Show()
    end)

    MakeButton(panel, "Save this as a route", -238, function()
        ns.Recorder:ShowExport()
    end)

    MakeButton(panel, "Progress / completed", -264, function()
        ns.Progress:Toggle()
    end)

    MakeButton(panel, "Catch up on quests", -290, function()
        Panel:ShowCatchUpDialog()
    end)

    MakeButton(panel, "Progress code", -316, function()
        Panel:ShowProgressCode()
    end)

    panel.autoBtn = MakeButton(panel, "Auto accept/turn-in", -342, function()
        ns.Automation:Toggle() ; Panel:Refresh()
    end)

    -- Recording extras
    MakeButton(panel, "Add a note here", -368, function()
        Panel:PromptNote()
    end)

    MakeButton(panel, "Mark this spot", -394, function()
        ns.Recorder:AddMark("Travel")
        Panel:Refresh()
    end)

    -- Display / options
    panel.arrowBtn = MakeButton(panel, "Arrow", -420, function()
        ns.Arrow:Toggle() ; Panel:Refresh()
    end)

    panel.mobBtn = MakeButton(panel, "Objective mobs", -446, function()
        ns.Marker:ToggleMobs() ; Panel:Refresh()
    end)

    panel.markerBtn = MakeButton(panel, "NPC markers", -472, function()
        ns.Marker:Toggle()
        Panel:Refresh()
    end)

    panel.platesBtn = MakeButton(panel, "Friendly nameplates", -498, function()
        local cur = Compat:Guard(GetCVar, "nameplateShowFriends")
        if cur == "1" then ns.Marker:DisableFriendlyPlates()
        else ns.Marker:EnableFriendlyPlates() end
        Panel:Refresh()
    end)

    MakeButton(panel, "Colors", -524, function()
        Panel:ShowColorPicker()
    end)

    MakeButton(panel, "Reset arrow position", -550, function()
        ns.Arrow:ResetPosition()
    end)

    panel.cbBtn = MakeButton(panel, "Arrow colorblind colors", -576, function()
        ns.Arrow:ToggleColorblind() ; Panel:Refresh()
    end)

    panel.textOnlyBtn = MakeButton(panel, "Arrow text-only mode", -602, function()
        ns.Arrow:ToggleTextOnly() ; Panel:Refresh()
    end)

    panel.tomtomBtn = MakeButton(panel, "Defer arrow to TomTom", -628, function()
        ns.Arrow:ToggleDeferToTomTom() ; Panel:Refresh()
    end)

    -- Rogue.lua already refuses to do anything for any other class; this
    -- just keeps the button from cluttering the menu for the 8 classes
    -- that can never use it, closing the gap it would otherwise leave
    -- rather than just hiding it in place. Class never changes
    -- mid-session, so this is decided once here, not on every Refresh().
    local y = -654
    local _, playerClass = UnitClass("player")
    if playerClass == "ROGUE" then
        MakeButton(panel, "Rogue", y, function()
            ns.Rogue:Show()
        end)
        y = y - 26
    end

    MakeButton(panel, "Help / About", y, function()
        Panel:ShowHelpDialog()
    end)
    y = y - 32

    MakeButton(panel, "Close", y, function() panel:Hide() end)

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

    panel.cbBtn:SetText(ns.Arrow and ns.Arrow.colorblind
        and "Arrow colorblind colors: on" or "Arrow colorblind colors: off")
    panel.textOnlyBtn:SetText(ns.Arrow and ns.Arrow.textOnly
        and "Arrow text-only mode: on" or "Arrow text-only mode: off")
    panel.tomtomBtn:SetText(ns.Arrow and ns.Arrow.deferToTomTom
        and "Defer arrow to TomTom: on" or "Defer arrow to TomTom: off")

    panel.autoBtn:SetText(ns.Automation and ns.Automation.enabled
        and "Auto accept/turn-in: on" or "Auto accept/turn-in: off")
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
-- Resume prompt (shown automatically at login, not from a button)
--------------------------------------------------------------------------

-- Same scan/jump as the Catch-up dialog above, but triggered unprompted
-- when login finds the tracker sitting at step 1 while quest flags say
-- otherwise (SavedVariables loss, or quests done outside the addon).
function Panel:ShowResumePrompt(furthest)
    if self.resumeBox then self.resumeBox:Hide() end

    local Core = ns.Core
    if not Core.active then return end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(360, 150)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Welcome back")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", 20, -46)
    body:SetPoint("TOPRIGHT", -20, -46)
    body:SetJustifyH("LEFT")
    body:SetSpacing(4)
    body:SetTextColor(unpack(ns.Theme.color.text))
    body:SetText(("You're at step 1, but quests up to step %d of %d already look done.\nJump the tracker to step %d?"):format(
        furthest, #Core.active.steps, furthest))

    FitDialogToBody(f, body, 46, 60, 150)

    local confirm = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    confirm:SetSize(100, 22)
    confirm:SetPoint("BOTTOM", -55, 16)
    confirm:SetText("Jump")
    confirm:SetScript("OnClick", function()
        Core:CatchUp(true)
        f:Hide()
        Panel:Refresh()
    end)

    local cancel = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    cancel:SetSize(100, 22)
    cancel:SetPoint("BOTTOM", 55, 16)
    cancel:SetText("Not now")
    cancel:SetScript("OnClick", function() f:Hide() end)

    self.resumeBox = f
    f:Show()
end

--------------------------------------------------------------------------
-- Progress code
--------------------------------------------------------------------------

-- A short, copy-pasteable stand-in for SavedVariables when those can't be
-- relied on: encodes route + step with a typo-catching checksum.
function Panel:ShowProgressCode()
    local Core = ns.Core
    local code = Core:GetProgressCode()
    if not code then
        ns.Print("No route loaded.")
        return
    end

    if self.codeBox then self.codeBox:Hide() end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(360, 150)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Progress code")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local help = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    help:SetPoint("TOP", 0, -42)
    help:SetTextColor(unpack(ns.Theme.color.dim))
    help:SetText("Ctrl+C to copy. Restore later with /tuff code <code>")

    local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    edit:SetSize(300, 24)
    edit:SetPoint("TOP", 0, -68)
    edit:SetAutoFocus(true)
    edit:SetText(code)
    edit:HighlightText()
    edit:SetScript("OnEscapePressed", function() f:Hide() end)
    edit:SetScript("OnEnterPressed", function(self) self:HighlightText() end)

    local ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    ok:SetSize(100, 22)
    ok:SetPoint("BOTTOM", 0, 16)
    ok:SetText("Close")
    ok:SetScript("OnClick", function() f:Hide() end)

    self.codeBox = f
    f:Show()
end

--------------------------------------------------------------------------
-- Help
--------------------------------------------------------------------------

function Panel:ShowHelpDialog()
    if self.helpBox then self.helpBox:Hide() end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(420, 280)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Auto progress & catch-up")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", 20, -46)
    body:SetPoint("TOPRIGHT", -20, -46)
    body:SetJustifyH("LEFT")
    body:SetSpacing(4)
    body:SetTextColor(unpack(ns.Theme.color.text))
    body:SetText(
        "The tracker auto-advances on its own. Accepting, completing and " ..
        "turning in a quest all move the current step forward without you " ..
        "doing anything - that's why there's no manual \"done\" button.\n\n" ..
        "|cffffd100Catch-up mode|r is for when you're ahead of the tracker - you " ..
        "already did some of the quests it hasn't caught up to yet (e.g. you " ..
        "loaded a route mid-level, or skipped steps).\n\n" ..
        "|cffffd100/tuff catchup|r previews how far forward it can scan based on " ..
        "quests you've already completed, without moving anything.\n" ..
        "|cffffd100/tuff catchup confirm|r jumps to that step for real.\n\n" ..
        "The |cffffd100Catch up on quests|r button on this menu does the same " ..
        "thing with a confirm dialog instead of typing commands.\n\n" ..
        "|cffffd100Auto accept/turn-in|r (off by default, toggle top-left on the " ..
        "tracker or in this menu) accepts and turns in quests for you, but only " ..
        "the ones matching your current step, and never guesses when a turn-in " ..
        "has more than one reward to choose from. Hold Shift to skip it for a " ..
        "single dialog without turning it off.\n\n" ..
        "|cffffd100Pace tracking|r runs automatically - the Progress window shows " ..
        "how long your current section is taking versus your best time for it, " ..
        "plus XP/hour and a level ETA. |cffffd100Export splits|r there (or " ..
        "/tuff pace) gives you a copyable summary of the run.\n\n" ..
        "|cffffd100Write a route (text)|r (or /tuff write) is a quicker way to " ..
        "author a route than a Lua table - one line per step, e.g. " ..
        "|cffa0a0a0accept 4641 npc=Kaltunk at=1411,42.6,68.8|r. See " ..
        "CompactGuide.lua's header for the full format.")

    FitDialogToBody(f, body, 46, 60, 160)

    local ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    ok:SetSize(100, 22)
    ok:SetPoint("BOTTOM", 0, 16)
    ok:SetText("Close")
    ok:SetScript("OnClick", function() f:Hide() end)

    self.helpBox = f
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
