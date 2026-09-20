-- TuFFlevels / Pace.lua
--
-- Timing for the CURRENT run: per-section elapsed time (with a personal
-- best comparison), XP/hour, and a level-up ETA. Independent of Recorder -
-- this runs for anyone just following a route, not only while authoring
-- one. "Run" means "since this addon session started" (login or /reload),
-- since that's the only granularity that means anything given Forever
-- loses SavedVariables on every reload anyway.
--
-- Personal-best section splits are stored per route in TuFFlevelsDB and
-- compared against live as they complete. On a client where SavedVariables
-- actually restore (Classic Era/Retail) this persists and improves over
-- time; on Forever it's lost every reload like everything else the addon
-- saves - there's just no "best" to compare against until a session
-- survives cleanly. Same documented, unfixable-in-Lua limitation as the
-- rest of this addon's saved state.

local ADDON, ns = ...
local Compat = ns.Compat

local Pace = {}
ns.Pace = Pace

Pace.runStart = nil
Pace.sectionStart = nil
Pace.currentSectionName = nil
Pace.sectionSplits = {}   -- this run's { name, seconds } list, in order
Pace.xpGained = 0

--------------------------------------------------------------------------
-- Formatting
--------------------------------------------------------------------------

function Pace:FormatTime(seconds)
    seconds = math.floor((seconds or 0) + 0.5)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then return ("%dh %dm"):format(h, m) end
    if m > 0 then return ("%dm %ds"):format(m, s) end
    return ("%ds"):format(s)
end

--------------------------------------------------------------------------
-- Run / section tracking
--------------------------------------------------------------------------

function Pace:StartRun()
    self.runStart = time()
    self.sectionStart = self.runStart
    self.sectionSplits = {}
    self.xpGained = 0
    self._lastXP = Compat:Guard(UnitXP, "player")
    self._lastXPMax = Compat:Guard(UnitXPMax, "player")
    self._lastLevel = Compat:Guard(UnitLevel, "player")

    -- Picks up the section you're already in, rather than waiting for the
    -- next step-advance to discover it - matters for a returning player
    -- who's mid-route, not just a fresh start.
    local Core = ns.Core
    local section = Core and Core.active and Core:CurrentSection()
    self.currentSectionName = section and section.name or nil
end

-- A different route (or reloading the same one) starts a fresh run rather
-- than carrying over splits/section timing that no longer mean anything.
function Pace:OnRouteLoad()
    self:StartRun()
end

function Pace:RecordSplit(sectionName, elapsed)
    table.insert(self.sectionSplits, { name = sectionName, seconds = elapsed })

    local Core = ns.Core
    local routeName = Core.active and Core.active.name
    if not routeName then return end

    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.paceBest = db.paceBest or {}
    db.paceBest[routeName] = db.paceBest[routeName] or {}
    local best = db.paceBest[routeName][sectionName]

    if not best then
        db.paceBest[routeName][sectionName] = elapsed
        ns.Print(("|cffffd100%s|r done in %s - first time, that's your new best."):format(
            sectionName, self:FormatTime(elapsed)))
    elseif elapsed < best then
        db.paceBest[routeName][sectionName] = elapsed
        ns.Print(("|cffffd100%s|r done in %s - |cff00ff00%s faster|r than your best!"):format(
            sectionName, self:FormatTime(elapsed), self:FormatTime(best - elapsed)))
    else
        ns.Print(("|cffffd100%s|r done in %s - %s slower than your best (%s)."):format(
            sectionName, self:FormatTime(elapsed), self:FormatTime(elapsed - best), self:FormatTime(best)))
    end
end

-- Called whenever Reconcile actually moves the step index forward.
function Pace:OnStepAdvance()
    local Core = ns.Core
    if not Core.active then return end
    if not self.runStart then self:StartRun() end

    local section = Core:CurrentSection()
    local sectionName = section and section.name or nil

    if sectionName ~= self.currentSectionName then
        if self.currentSectionName and self.sectionStart then
            self:RecordSplit(self.currentSectionName, time() - self.sectionStart)
        end
        self.currentSectionName = sectionName
        self.sectionStart = time()
    end
end

-- Best time recorded for a section of the currently loaded route, or nil.
function Pace:BestFor(sectionName)
    local Core = ns.Core
    local routeName = Core.active and Core.active.name
    if not (routeName and sectionName) then return nil end

    local db = Compat:InitSavedVar("TuFFlevelsDB")
    return db.paceBest and db.paceBest[routeName] and db.paceBest[routeName][sectionName]
end

-- Elapsed time in the section you're currently in, live.
function Pace:CurrentSectionElapsed()
    if not self.sectionStart then return nil end
    return time() - self.sectionStart
end

--------------------------------------------------------------------------
-- XP/hour and level ETA
--------------------------------------------------------------------------

local XP_SAMPLE_INTERVAL = 30

function Pace:SampleXP()
    if not self.runStart then return end

    local xp = Compat:Guard(UnitXP, "player")
    local level = Compat:Guard(UnitLevel, "player")
    if not (xp and level) then return end

    if self._lastXP and self._lastLevel then
        local gained
        if level > self._lastLevel then
            -- Leveled up since the last sample: whatever was left of the
            -- old level, plus however far into the new one you are now.
            gained = (self._lastXPMax or 0) - self._lastXP + xp
        elseif xp >= self._lastXP then
            gained = xp - self._lastXP
        else
            gained = 0
        end
        self.xpGained = self.xpGained + gained
    end

    self._lastXP = xp
    self._lastLevel = level
    self._lastXPMax = Compat:Guard(UnitXPMax, "player")
end

-- nil if there's not enough of a sample yet, or the character has XP gain
-- disabled/is max level (UnitXPMax reports 0 in both cases).
function Pace:XPPerHour()
    if not (self.runStart and self.xpGained and self.xpGained > 0) then return nil end
    local elapsedHours = (time() - self.runStart) / 3600
    if elapsedHours <= 0 then return nil end
    return self.xpGained / elapsedHours
end

function Pace:LevelETASeconds()
    local rate = self:XPPerHour()
    if not rate then return nil end

    local xp = Compat:Guard(UnitXP, "player")
    local xpMax = Compat:Guard(UnitXPMax, "player")
    if not (xp and xpMax) or xpMax <= 0 then return nil end

    return (xpMax - xp) / (rate / 3600)
end

C_Timer.NewTicker(XP_SAMPLE_INTERVAL, function() Pace:SampleXP() end)

--------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------

local exportFrame

function Pace:ShowExport()
    local Core = ns.Core
    if #self.sectionSplits == 0 and not self.currentSectionName then
        ns.Print("No section splits yet this run.")
        return
    end

    if not exportFrame then
        -- No ScrollFrame here - UIPanelScrollFrameTemplate's scrollbar is
        -- built on UIPanelScrollBarTemplate, the same secure-snippet-based
        -- template that already crashed Progress.lua's window on Forever
        -- (see that file's hand-rolled slider). A plain multi-line EditBox
        -- has its own built-in keyboard scrolling (arrow keys, Page Up/
        -- Down) for content taller than the box, with nothing secure
        -- involved, so it sidesteps the broken template the same way.
        exportFrame = CreateFrame("Frame", "TuFFlevelsPaceExport", UIParent, "BackdropTemplate")
        exportFrame:SetSize(460, 400)
        exportFrame:SetPoint("CENTER")
        exportFrame:SetMovable(true)
        exportFrame:EnableMouse(true)
        exportFrame:RegisterForDrag("LeftButton")
        exportFrame:SetScript("OnDragStart", exportFrame.StartMoving)
        exportFrame:SetScript("OnDragStop", exportFrame.StopMovingOrSizing)
        exportFrame:SetFrameStrata("DIALOG")

        ns.Theme:Skin(exportFrame)

        local title = exportFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", 0, -14)
        title:SetText("Run splits")
        title:SetTextColor(unpack(ns.Theme.color.lilac))

        local help = exportFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        help:SetPoint("TOP", 0, -32)
        help:SetTextColor(unpack(ns.Theme.color.dim))
        help:SetText("Ctrl+C to copy. Arrow keys/Page Up-Down to scroll if it's long.")

        local edit = CreateFrame("EditBox", nil, exportFrame)
        edit:SetMultiLine(true)
        edit:SetFontObject("ChatFontNormal")
        edit:SetPoint("TOPLEFT", 16, -50)
        edit:SetPoint("BOTTOMRIGHT", -16, 42)
        edit:SetAutoFocus(false)
        edit:SetScript("OnEscapePressed", function() exportFrame:Hide() end)
        exportFrame.edit = edit

        local close = CreateFrame("Button", nil, exportFrame, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOM", 0, 14)
        close:SetText("Close")
        close:SetScript("OnClick", function() exportFrame:Hide() end)
    end

    local lines = { ("Route: %s"):format(Core.active and Core.active.name or "?") }
    for _, split in ipairs(self.sectionSplits) do
        local best = self:BestFor(split.name)
        local bestText = best and (" (best %s)"):format(self:FormatTime(best)) or ""
        table.insert(lines, ("%s: %s%s"):format(split.name, self:FormatTime(split.seconds), bestText))
    end
    if self.currentSectionName then
        table.insert(lines, ("%s: %s (in progress)"):format(
            self.currentSectionName, self:FormatTime(self:CurrentSectionElapsed())))
    end

    local rate = self:XPPerHour()
    if rate then
        table.insert(lines, ("XP/hour: %d"):format(rate))
    end
    if self.runStart then
        table.insert(lines, ("Total run time: %s"):format(self:FormatTime(time() - self.runStart)))
    end

    exportFrame.edit:SetText(table.concat(lines, "\n"))
    exportFrame:Show()
end
