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
Pace.currentSectionFirstIndex = nil
Pace.currentSectionValid = false
Pace.sectionSplits = {}   -- this run's { name, seconds } list, in order
Pace.xpGained = 0
Pace.stepSplitsValid = false
Pace.horizon = 0   -- highest real step index known already passed (see StartRun)

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

-- The array index of a route's first non-section step - what "the run
-- began at step 1" (see below) actually means, since a route can lead with
-- a section-header step at index 1 without that being real played content.
local function FirstRealStepIndex(route)
    if not route or not route.steps then return 1 end
    for i, step in ipairs(route.steps) do
        if step.type ~= "section" then return i end
    end
    return 1
end

-- The array index of the first real (non-section) step belonging to the
-- section headered at `headerIndex` - i.e. that section's own content, not
-- the header itself. Every section is exactly one header step followed by
-- its content (Core:Sections()), so this is just the first non-section
-- step at or after headerIndex.
local function SectionFirstRealIndex(route, headerIndex)
    if not (route and route.steps and headerIndex) then return headerIndex end
    for i = headerIndex, #route.steps do
        if route.steps[i].type ~= "section" then return i end
    end
    return headerIndex
end

-- Highest real (non-section, applicable to this character, non-optional)
-- step index in the whole route that already reports done. A plain "was
-- this skipped by Reconcile's own walk" check isn't enough to find this:
-- Reconcile's walk halts at the first step it can't auto-complete (a
-- manual/note/trainer gate), so it can never even LOOK at real,
-- already-done content sitting past that gate. Same O(route length) cost
-- as Core:PreviewCatchUp's login scan; only run once per fresh start.
-- IsStepDone is pcall-guarded: this now runs on every LoadRoute (including
-- straight after a spreadsheet/RXP/CompactGuide import), not just once a
-- player's own forward progress reaches a given step, so a malformed
-- imported step (e.g. a grind/level step missing its targetLevel) can't
-- throw here and abort the route load before Reconcile/Save/UI:Refresh run.
local function ScanDoneHorizon(Core, route)
    local horizon = 0
    if not (Core and route and route.steps) then return horizon end
    for i, step in ipairs(route.steps) do
        if step.type ~= "section" and not step.optional and Core.StepApplies(step) then
            local ok, done = pcall(Core.IsStepDone, step)
            if ok and done then
                horizon = i
            end
        end
    end
    return horizon
end

-- `resumeFloor`, if given, is an extra known floor for `horizon` below -
-- used by Core:LoadRoute when RESELECTING the route already active (not
-- switching to a different one): that resets Core.index to 1 before this
-- runs, which would otherwise look exactly like a fresh start even though
-- the player was already partway through and is about to click straight
-- back to their spot, recording near-zero bests for everything skipped
-- past on the way back.
function Pace:StartRun(resumeFloor)
    self.runStart = time()
    self.sectionStart = self.runStart
    self.sectionSplits = {}
    self.xpGained = 0
    self._lastXP = Compat:Guard(UnitXP, "player")
    self._lastXPMax = Compat:Guard(UnitXPMax, "player")
    self._lastLevel = Compat:Guard(UnitLevel, "player")

    -- Picks up the section you're already in, rather than waiting for the
    -- next step-advance to discover it - matters for a returning player
    -- who's mid-route, not just a fresh start. `and` truncates a tail call
    -- to one value once an earlier operand forces it into a boolean-ish
    -- role, so this can't be written as a one-line `and` chain without
    -- silently losing sectionFirst - see Core:CurrentSection's two return
    -- values.
    local Core = ns.Core
    local section, sectionFirst
    if Core and Core.active then
        section, sectionFirst = Core:CurrentSection()
    end
    self.currentSectionName = section and section.name or nil
    self.currentSectionFirstIndex = sectionFirst
    self.currentSectionValid = true

    -- P1.6: "time since runStart" only reflects the actual time spent
    -- reaching a given step index - or a section's actual duration - when
    -- NOTHING was already passed or done before this run's clock started.
    -- `horizon` is the single, unified signal for "how far along is this
    -- run really starting", combining two things that can each be true
    -- independently: the tracker's own restored index (Core.index, which
    -- can be far ahead of anything ScanDoneHorizon can see if it's sitting
    -- behind a manual/note/trainer gate that can't re-report done after a
    -- reload), and whatever ScanDoneHorizon finds already done via live
    -- quest-log state (which can be far ahead of Core.index if the tracker
    -- itself is stuck behind that same kind of gate). Either one being
    -- ahead means real progress happened outside this run's timeline.
    -- Fixed once here for the whole run - stepSplitsValid is an
    -- all-or-nothing gate for the run, but `horizon` itself also feeds
    -- each individual section's own validity check as it completes (see
    -- OnStepAdvance) and Core:SetIndex's jump hook (see
    -- InvalidateStepSplits) can raise it further mid-run.
    local runStartIndex = (Core and Core.index) or 1
    local floor = math.max(runStartIndex - 1, resumeFloor and (resumeFloor - 1) or 0)
    self.horizon = math.max(floor, ScanDoneHorizon(Core, Core and Core.active))
    local firstReal = Core and Core.active and FirstRealStepIndex(Core.active) or 1
    self.stepSplitsValid = self.horizon < firstReal
end

-- Hooked from Core:SetIndex when the index changes in a way that isn't a
-- plain +1 advance (Back, goto, catch-up, a progress-code restore) - the
-- elapsed clock stops mapping to a straight walk through the route from
-- that point on. `oldIndex` (the index before this jump) raises `horizon`
-- when the jump moves backward: everything up to oldIndex-1 was already
-- reached once this run, so if the tracker re-crosses it later (a
-- catch-up after Back, say), that's not fresh progress either - without
-- this, a section re-entered and re-completed after a Back would still
-- look like a genuine first completion and record an understated best.
--
-- Both step splits (the whole run) and whatever section is currently in
-- progress stop being trustworthy pace data from this point on - see
-- OnStepAdvance's section-transition comment for why the section half
-- needs its own flag rather than reusing horizon alone. Called AFTER
-- Core.index is already updated, so Core:CurrentSection() reflects where
-- the jump landed - re-syncing currentSectionName/currentSectionFirstIndex
-- here (rather than leaving them pointing at whatever section the jump
-- left) matters whenever the jump crosses a section boundary: without
-- this, the OLD section's name/sectionStart would linger until the next
-- transition-detecting OnStepAdvance call, which would then compare
-- against the section the jump landed IN and wrongly conclude nothing
-- changed, letting that section's eventual completion get recorded as a
-- valid best.
function Pace:InvalidateStepSplits(oldIndex)
    self.stepSplitsValid = false
    if oldIndex and oldIndex - 1 > self.horizon then
        self.horizon = oldIndex - 1
    end

    local Core = ns.Core
    local section, sectionFirst
    if Core and Core.active then
        section, sectionFirst = Core:CurrentSection()
    end
    self.currentSectionName = section and section.name or nil
    self.currentSectionFirstIndex = sectionFirst
    self.currentSectionValid = false
    self.sectionStart = time()
end

-- A different route (or reselecting the same one) starts a fresh run
-- rather than carrying over splits/section timing that no longer mean
-- anything. See StartRun for `resumeFloor`.
function Pace:OnRouteLoad(resumeFloor)
    self:StartRun(resumeFloor)
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

-- Called whenever Reconcile actually moves the step index forward -
-- whether that's a single live step or a multi-step catch-up walk (the
-- synchronous one right after a fresh StartRun, or a later event-driven
-- one skipping several just-completed quests at once). Both cases are
-- handled uniformly: `horizon` (see StartRun/ScanDoneHorizon) already
-- accounts for anything that could make a recorded time misleading, so
-- there's no need to single out "the first call after StartRun" as special.
function Pace:OnStepAdvance()
    local Core = ns.Core
    if not Core.active then return end
    if not self.runStart then self:StartRun() end

    -- Cumulative time-to-reach-this-step, same idea as section splits but
    -- at step granularity - sections can be long enough that "behind pace"
    -- is only useful to know once you've already lost the whole section.
    -- Only trustworthy for a run that began at the route's true start (see
    -- StartRun) - otherwise skip it rather than recording/overwriting a
    -- best with a value that doesn't mean what it looks like it means.
    if self.stepSplitsValid then
        self:RecordStepSplit(Core.index, time() - self.runStart)
    end

    local section, sectionFirst = Core:CurrentSection()
    local sectionName = section and section.name or nil

    if sectionName ~= self.currentSectionName then
        if self.currentSectionName and self.sectionStart and self.currentSectionValid then
            -- Skip recording a best for the section this run either (a)
            -- started inside of already in progress, or (b) whose content
            -- `horizon` otherwise already covers (e.g. a manual gate held
            -- the tracker back while real, quest-flag-verifiable progress
            -- raced ahead of it - see ScanDoneHorizon) - either way,
            -- sectionStart doesn't correctly mark when the section's OWN
            -- first step was actually reached, so its elapsed time would
            -- understate how long the section actually takes. `horizon` is
            -- fixed for the run except for Core:SetIndex's jump hook
            -- (InvalidateStepSplits), which can only raise it, and section
            -- indices only increase, so this can only ever trip once per
            -- distinct section - every later one starts sectionStart fresh
            -- and is fully valid, UNLESS currentSectionValid was
            -- separately cleared by a mid-section jump landing back inside
            -- it - that's what the currentSectionValid check above is for.
            local sectionFirstReal = SectionFirstRealIndex(Core.active, self.currentSectionFirstIndex)
            local coveredByHorizon = sectionFirstReal and sectionFirstReal <= self.horizon
            if not coveredByHorizon then
                self:RecordSplit(self.currentSectionName, time() - self.sectionStart)
            end
        end
        self.currentSectionName = sectionName
        self.currentSectionFirstIndex = sectionFirst
        self.currentSectionValid = true
        self.sectionStart = time()
    end
end

-- Keeps only the best (lowest) cumulative time seen for reaching a given
-- step index in this route, same "best so far" model as RecordSplit.
function Pace:RecordStepSplit(stepIndex, elapsed)
    local Core = ns.Core
    local routeName = Core.active and Core.active.name
    if not routeName then return end

    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.paceBest = db.paceBest or {}
    db.paceBest[routeName] = db.paceBest[routeName] or {}
    db.paceBest[routeName].steps = db.paceBest[routeName].steps or {}

    local best = db.paceBest[routeName].steps[stepIndex]
    if not best or elapsed < best then
        db.paceBest[routeName].steps[stepIndex] = elapsed
    end
end

-- Best cumulative time (seconds since run start) previously recorded for
-- reaching this step index in the currently loaded route, or nil.
function Pace:BestStepTime(stepIndex)
    local Core = ns.Core
    local routeName = Core.active and Core.active.name
    if not (routeName and stepIndex) then return nil end

    local db = Compat:InitSavedVar("TuFFlevelsDB")
    return db.paceBest and db.paceBest[routeName] and db.paceBest[routeName].steps
        and db.paceBest[routeName].steps[stepIndex]
end

-- Live delta in seconds between this run and the best recorded run, at the
-- step you're on right now: positive means behind, negative means ahead.
-- nil until there's a best time to compare against (first time through a
-- step, SavedVariables lost the record, or this run's step-cumulative
-- timing isn't trustworthy - see StartRun/stepSplitsValid).
function Pace:StepDeltaVsBest()
    local Core = ns.Core
    if not (Core.active and self.runStart and self.stepSplitsValid) then return nil end
    local best = self:BestStepTime(Core.index)
    if not best then return nil end
    return (time() - self.runStart) - best
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
        ns.Theme:SkinChildren(exportFrame)
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
