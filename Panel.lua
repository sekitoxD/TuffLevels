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

local CHANGELOG_VERSION = "1.6.0"
local CHANGELOG = {
    "Alliance leveling routes added: Human, Dwarf/Gnome, and Night Elf, each a full 1-60 path (TuFFlevels had zero Alliance content before this). Converted from RXPGuides' Classic-flavored guides - see the Credits & License section at the bottom of each Routes/Alliance/*.lua file; unlike the rest of this addon (MIT), those three files are CC BY-NC-SA 4.0. Marked as sample routes (unverified IDs) until run through /tuff verify and played.",
    "Tauren leveling route added (Routes/Horde/Mulgore.lua, full 1-60) - Horde previously had no Mulgore-starting route at all. Same conversion/licensing approach as the Alliance routes above; self-contained, doesn't touch the existing Orc/Troll Solo/ route. About 24 steps reference a continent-level zone (Kalimdor/Eastern Kingdoms) this addon's zone table doesn't resolve yet - everything except those steps' arrows works.",
    "Added a Rogue-specific class-quest chain to the Horde Durotar route (Gornek -> Rwag, Encrypted Tablet/Parchment, Backstab training) - the existing generic 'Class Trainer - check the whole area' placeholder had nothing Rogue-specific.",
    "Added an RXPGuides (RestedXP) guide importer (/tuff rxp, or Menu > Content & Import) alongside the existing Guidelime importer - paste in a Classic-flavored guide you already have installed and get a TuFFlevels route back. Ships no RXPGuides content itself, same isolation as the QuestieDB/Guidelime integrations.",
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
    ns.Theme:SkinChildren(f)

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

    -- NPC markers attach to nameplates, which are off by default. Goes
    -- through Compat:SetCVarSafe (plans/01-bug-fixes.md V4), same as
    -- Marker:EnableFriendlyPlates and the Panel nameplates button below -
    -- a raw Guard(SetCVar, ...) here can't detect or work around
    -- "nameplateShowFriends" not existing as a cvar on Forever.
    Compat:SetCVarSafe("nameplateShowFriends", 1)
    Compat:SetCVarSafe("nameplateShowFriendlyNPCs", 1)

    -- Recording is opt-in, off by default (unlike Automation, which
    -- defaults on): it's a route-authoring tool (Recorder.lua), not
    -- something a player just following a route wants running from their
    -- very first session.

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
        "|cffffd100Just play.|r Level however you think is fastest. The tracker follows " ..
        "along and auto-advances as you go.\n\n" ..
        "A |cffffd100!|r or |cffffd100?|r will float over the head of any NPC your " ..
        "current step needs.\n\n" ..
        "Want to record your own route instead of following one? Click |cffffd100Menu|r " ..
        "on the tracker, then |cffffd100Content & Import|r, and hit Recording.")

    FitDialogToBody(w, body, 52, 60, 250)

    local ok = CreateFrame("Button", nil, w, "UIPanelButtonTemplate")
    ok:SetSize(120, 24)
    ok:SetPoint("BOTTOM", 0, 18)
    ok:SetText("Got it")
    ok:SetScript("OnClick", function() w:Hide() end)
    ns.Theme:SkinChildren(w)

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
    panel:SetSize(240, 438)
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

    -- Guides / routes
    panel.routeBtn = MakeButton(panel, "Available Guides", -40, function()
        Panel:ShowRoutePicker()
    end)

    MakeButton(panel, "Where to go next", -66, function()
        ns.Zones:Show()
    end)

    MakeButton(panel, "Progress / completed", -92, function()
        ns.Progress:Toggle()
    end)

    MakeButton(panel, "Catch up on quests", -118, function()
        Panel:ShowCatchUpDialog()
    end)

    panel.autoBtn = MakeButton(panel, "Auto accept/turn-in", -144, function()
        ns.Automation:Toggle() ; Panel:Refresh()
    end)

    panel.arrowBtn = MakeButton(panel, "Arrow", -170, function()
        ns.Arrow:Toggle() ; Panel:Refresh()
    end)

    panel.markerBtn = MakeButton(panel, "NPC markers", -196, function()
        ns.Marker:Toggle()
        Panel:Refresh()
    end)

    -- Recording extras - meaningless unless actively recording. Kept at a
    -- fixed slot rather than reflowing the rest of the menu when toggled;
    -- Panel:Refresh() drives whether they're shown. The Recording toggle
    -- itself lives in the Content & Import submenu now, alongside "Save
    -- this as a route" - these two stay here since they're only useful
    -- mid-recording, right next to the tracker, not buried a menu deeper.
    panel.noteBtn = MakeButton(panel, "Add a note here", -222, function()
        Panel:PromptNote()
    end)

    panel.markBtn = MakeButton(panel, "Mark this spot", -248, function()
        ns.Recorder:AddMark("Travel")
        Panel:Refresh()
    end)

    -- Content management and display settings both moved into their own
    -- submenus (see Panel:ShowContentMenu / Panel:ShowDisplayMenu below) -
    -- occasional-use buttons that don't need to sit in the main list.
    MakeButton(panel, "Content & Import", -274, function()
        Panel:ShowContentMenu()
    end)

    MakeButton(panel, "Display settings", -300, function()
        Panel:ShowDisplayMenu()
    end)

    -- Rogue.lua already refuses to do anything for any other class; this
    -- just keeps the button from cluttering the menu for the 8 classes
    -- that can never use it, closing the gap it would otherwise leave
    -- rather than just hiding it in place. Class never changes
    -- mid-session, so this is decided once here, not on every Refresh().
    local y = -326
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
    panel.noteBtn:SetShown(rec)
    panel.markBtn:SetShown(rec)

    panel.markerBtn:SetText(ns.Marker and ns.Marker.enabled
        and "NPC markers: on" or "NPC markers: off")
    panel.arrowBtn:SetText(ns.Arrow and ns.Arrow.enabled and "Arrow: on" or "Arrow: off")

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
-- Blizzard Settings panel (Game Menu > Options > AddOns)
--------------------------------------------------------------------------

-- A second UI surface for the SAME toggles the buttons above already drive
-- - no new SavedVariables, no new state. Gated on Compat.has.settingsAPI:
-- Classic Era has no `Settings` namespace at all, so nothing below ever
-- runs there.
--
-- Every Settings.* call is wrapped in Compat:Guard. The exact argument
-- shape of Settings.RegisterProxySetting/CreateCheckbox could not be
-- confirmed against a live client from this environment (no headless Lua
-- runner, no client access) - a wrong guess about that shape degrades to
-- "this one checkbox doesn't register", never a crash that takes the rest
-- of Panel.lua down with it.
--
-- Toggle()/ToggleMobs()/ToggleColorblind()/ToggleTextOnly() unconditionally
-- flip their boolean - they are not SetEnabled(bool) setters. The Settings
-- API calls the setter with the NEW value the user picked (and may call it
-- once during registration/restore), so the setter below only calls the
-- real Toggle() when the requested value actually differs from current
-- state, instead of flipping it unconditionally and desyncing the checkbox
-- from the real state on the first render.
local function MakeSettingsToggle(category, variable, name, tooltip, getValue, setValue)
    local varType = (Settings.VarType and Settings.VarType.Boolean) or "boolean"
    local setting = Compat:Guard(Settings.RegisterProxySetting,
        category, variable, varType, name, getValue() and true or false, getValue, setValue)
    if not setting then return end

    Compat:Guard(Settings.CreateCheckbox, category, setting, tooltip)
end

-- Called once at login (Core.lua's PLAYER_LOGIN handler, right after
-- Panel:Build()). self.settingsRegistered guards against double
-- registration if something ever calls this twice in one session.
function Panel:RegisterSettingsCategory()
    if not Compat.has.settingsAPI then return end
    if self.settingsRegistered then return end
    self.settingsRegistered = true

    local category = Compat:Guard(Settings.RegisterVerticalLayoutCategory, ADDON)
    if not category then return end

    Compat:Guard(Settings.RegisterAddOnCategory, category)

    MakeSettingsToggle(category, "TUFFLEVELS_AUTO_ACCEPT_TURNIN", "Auto accept/turn-in",
        "Automatically accepts and turns in quests matching your current step. Never guesses between multiple reward choices.",
        function() return ns.Automation and ns.Automation.enabled or false end,
        function(value)
            if not ns.Automation then return end
            if (ns.Automation.enabled or false) ~= value then
                ns.Automation:Toggle()
            end
            Panel:Refresh()
        end)

    MakeSettingsToggle(category, "TUFFLEVELS_NPC_MARKERS", "NPC markers",
        "Shows a floating icon over quest NPCs your current step needs.",
        function() return ns.Marker and ns.Marker.enabled or false end,
        function(value)
            if not ns.Marker then return end
            if (ns.Marker.enabled or false) ~= value then
                ns.Marker:Toggle()
            end
            Panel:Refresh()
        end)

    MakeSettingsToggle(category, "TUFFLEVELS_OBJECTIVE_MOBS", "Objective mob markers",
        "Also marks the mobs your current kill objective needs, not just quest NPCs.",
        function() return ns.Marker and ns.Marker.markMobs or false end,
        function(value)
            if not ns.Marker then return end
            if (ns.Marker.markMobs or false) ~= value then
                ns.Marker:ToggleMobs()
            end
        end)

    MakeSettingsToggle(category, "TUFFLEVELS_ARROW_COLORBLIND", "Arrow colorblind colors",
        "Uses a colorblind-friendly palette for the directional arrow.",
        function() return ns.Arrow and ns.Arrow.colorblind or false end,
        function(value)
            if not ns.Arrow then return end
            if (ns.Arrow.colorblind or false) ~= value then
                ns.Arrow:ToggleColorblind()
            end
        end)

    MakeSettingsToggle(category, "TUFFLEVELS_ARROW_TEXT_ONLY", "Arrow text-only mode",
        "Shows the arrow's distance/direction as text only, no icon.",
        function() return ns.Arrow and ns.Arrow.textOnly or false end,
        function(value)
            if not ns.Arrow then return end
            if (ns.Arrow.textOnly or false) ~= value then
                ns.Arrow:ToggleTextOnly()
            end
        end)
end

--------------------------------------------------------------------------
-- Content & Import submenu
--------------------------------------------------------------------------

-- Occasional-use route setup/backup actions, split out of the main list.
-- Rebuilt fresh on every open (same pattern as ShowRoutePicker/
-- ShowCatchUpDialog below) rather than persisted and live-refreshed - most
-- of these buttons have no on/off state to keep in sync while the panel
-- sits open, unlike the toggles on the main panel. Recording is the one
-- exception here, and its own click handler updates its own text directly
-- (see below) rather than needing this menu to be a persisted frame.
function Panel:ShowContentMenu()
    if self.contentMenu then self.contentMenu:Hide() end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(240, 332)
    f:SetPoint("TOPLEFT", panel, "TOPRIGHT", 8, 0)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Content & Import")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    MakeButton(f, "Import spreadsheet", -42, function()
        ns.SheetImport:Show()
    end)
    MakeButton(f, "Import a guide", -68, function()
        ns.GuideImport:Show()
    end)
    MakeButton(f, "Import RXPGuides guide", -94, function()
        ns.RXPImport:Show()
    end)
    MakeButton(f, "Write a route (text)", -120, function()
        ns.CompactGuide:Show()
    end)
    MakeButton(f, "Recover past quests", -146, function()
        ns.Import:Show()
    end)

    -- Recording moved here from the main panel (2026-09-20): a
    -- route-authoring tool that's off by default, sitting right next to
    -- "Save this as a route" now that both are occasional-use actions
    -- rather than something a player following a route needs on the main
    -- list. This menu is rebuilt fresh on every open, but Recording (unlike
    -- the other buttons here) has on/off state that can change while the
    -- menu is left open, so its own click handler updates its own text
    -- directly, the same pattern ShowDisplayMenu's mobBtn already uses.
    local recBtn, recStatus
    recBtn = MakeButton(f, ns.Recorder and ns.Recorder.active and "Stop recording" or "Start recording", -172, function()
        if ns.Recorder.active then ns.Recorder:Stop() else ns.Recorder:Start() end
        recBtn:SetText(ns.Recorder.active and "Stop recording" or "Start recording")
        recStatus:SetText(("%d steps recorded"):format(ns.Recorder and #ns.Recorder.log or 0))
        Panel:Refresh()
    end)

    recStatus = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    recStatus:SetPoint("TOP", 0, -192)
    recStatus:SetTextColor(unpack(ns.Theme.color.dim))
    recStatus:SetText(("%d steps recorded"):format(ns.Recorder and #ns.Recorder.log or 0))

    MakeButton(f, "Save this as a route", -218, function()
        ns.Recorder:ShowExport()
    end)
    MakeButton(f, "Progress code", -244, function()
        Panel:ShowProgressCode()
    end)

    local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOM", 0, 14)
    close:SetText("Close")
    close:SetScript("OnClick", function() f:Hide() end)

    ns.Theme:SkinChildren(f)
    self.contentMenu = f
    f:Show()
end

--------------------------------------------------------------------------
-- Display settings submenu
--------------------------------------------------------------------------

function Panel:ShowDisplayMenu()
    if self.displayMenu then self.displayMenu:Hide() end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(240, 320)
    f:SetPoint("TOPLEFT", panel, "TOPRIGHT", 8, 0)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Display settings")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local mobBtn
    mobBtn = MakeButton(f, ns.Marker and ns.Marker.markMobs
        and "Objective mobs: on" or "Objective mobs: off", -42, function()
        ns.Marker:ToggleMobs()
        mobBtn:SetText(ns.Marker.markMobs and "Objective mobs: on" or "Objective mobs: off")
    end)

    -- plans/01-bug-fixes.md V4: "nameplateShowFriends" isn't a registered
    -- cvar on Forever at all - read the same "nameplateShowFriendlyNPCs"
    -- cvar Marker:EnableFriendlyPlates/DisableFriendlyPlates confirm success
    -- against, via the same C_CVar-preferring Compat wrapper, or this
    -- button's label and on/off click logic silently invert on Forever.
    local platesBtn
    local plateCur = Compat:GetCVarSafe("nameplateShowFriendlyNPCs")
    platesBtn = MakeButton(f, plateCur == "1" and "Nameplates: on" or "Nameplates: off", -68, function()
        local cur = Compat:GetCVarSafe("nameplateShowFriendlyNPCs")
        if cur == "1" then ns.Marker:DisableFriendlyPlates()
        else ns.Marker:EnableFriendlyPlates() end
        local now = Compat:GetCVarSafe("nameplateShowFriendlyNPCs")
        platesBtn:SetText(now == "1" and "Nameplates: on" or "Nameplates: off")
    end)

    MakeButton(f, "Colors", -94, function()
        Panel:ShowColorPicker()
    end)

    MakeButton(f, "Reset arrow position", -120, function()
        ns.Arrow:ResetPosition()
    end)

    local cbBtn
    cbBtn = MakeButton(f, ns.Arrow and ns.Arrow.colorblind
        and "Arrow colorblind colors: on" or "Arrow colorblind colors: off", -146, function()
        ns.Arrow:ToggleColorblind()
        cbBtn:SetText(ns.Arrow.colorblind and "Arrow colorblind colors: on" or "Arrow colorblind colors: off")
    end)

    local textOnlyBtn
    textOnlyBtn = MakeButton(f, ns.Arrow and ns.Arrow.textOnly
        and "Arrow text-only mode: on" or "Arrow text-only mode: off", -172, function()
        ns.Arrow:ToggleTextOnly()
        textOnlyBtn:SetText(ns.Arrow.textOnly and "Arrow text-only mode: on" or "Arrow text-only mode: off")
    end)

    local tomtomBtn
    tomtomBtn = MakeButton(f, ns.Arrow and ns.Arrow.deferToTomTom
        and "Defer arrow to TomTom: on" or "Defer arrow to TomTom: off", -198, function()
        ns.Arrow:ToggleDeferToTomTom()
        tomtomBtn:SetText(ns.Arrow.deferToTomTom and "Defer arrow to TomTom: on" or "Defer arrow to TomTom: off")
    end)

    local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOM", 0, 14)
    close:SetText("Close")
    close:SetScript("OnClick", function() f:Hide() end)

    ns.Theme:SkinChildren(f)
    self.displayMenu = f
    f:Show()
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

    -- Height was fixed at the original 260 regardless of how many routes
    -- exist - with enough routes registered the last rows ran past the
    -- frame's own bottom edge and collided with the Close button anchored
    -- there, which is why Close looked "dead" (a route button was drawn on
    -- top of it and ate the click instead). Grow to fit instead.
    f:SetHeight(math.max(260, 42 + count * 26 + 60))

    local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOM", 0, 14)
    close:SetText("Close")
    close:SetScript("OnClick", function() f:Hide() end)

    -- Route buttons above were left on Blizzard's default UIPanelButtonTemplate
    -- look - every other dialog in this addon re-skins its buttons via
    -- SkinChildren right before showing; this one just never got it.
    ns.Theme:SkinChildren(f)

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
    ns.Theme:SkinChildren(f)

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
    ns.Theme:SkinChildren(f)

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
    ns.Theme:SkinChildren(f)

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
        "|cffffd100Auto accept/turn-in|r (off by default, on by default every " ..
        "login on Forever since it can't remember an explicit off there - " ..
        "toggle top-left on the tracker or in this menu) accepts and turns " ..
        "in quests for you, but only the ones matching your current step, " ..
        "and never guesses when a turn-in has more than one reward to " ..
        "choose from. Hold Shift to skip it for a single dialog without " ..
        "turning it off.\n\n" ..
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
    ns.Theme:SkinChildren(f)

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
    ns.Theme:SkinChildren(f)

    self.colorPicker = f
    f:Show()
end
