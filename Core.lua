-- TuFFlevels / Core.lua
-- The step engine. Holds routes, tracks which step you're on, and advances
-- automatically when the client tells us a step's condition is satisfied.

local ADDON, ns = ...
local Data = ns.Data
local Compat = ns.Compat

local Core = {}
ns.Core = Core

-- Defined up here because Core:Load uses it. A local declared further down
-- is not visible to closures created above it.
local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffa96bf2TuFFlevels|r: " .. tostring(msg))
end
ns.Print = Print

Core.routes = {}          -- [name] = routeTable
Core.active = nil         -- currently loaded route
Core.index  = 1           -- current step index
Core.pinned = false       -- true after manual navigation; blocks auto-advance

--------------------------------------------------------------------------
-- Route registration (called from Routes/*.lua)
--------------------------------------------------------------------------

function ns.RegisterRoute(name, route)
    route.name = name
    route.steps = route.steps or {}
    Core.routes[name] = route
end

--------------------------------------------------------------------------
-- Step condition evaluation
--------------------------------------------------------------------------

-- Steps imported from a spreadsheet carry a quest name instead of an ID.
-- Resolve it the first time we can and cache it on the step.
local function ResolveQuest(step)
    if step.quest then return step.quest end
    if not step.questName then return nil end

    -- step.ambiguous means several quests in the route share this name
    -- (chain links). Only the live quest log can say which one you hold, so
    -- don't let the name cache answer and don't teach it a wrong answer.
    if step.ambiguous then
        local id = Compat:GetQuestIDByNameLive(step.questName)
        if id then step.quest = id end
        return id
    end

    local id = Compat:GetQuestIDByName(step.questName)
    if id then
        step.quest = id
        Compat:SaveNameCache()
    end
    return id
end

Core.ResolveQuest = ResolveQuest

-- Returns true if this step is already satisfied.
local function IsStepDone(step)
    local t = step.type

    -- name-based steps need an ID before anything can be checked
    if not step.quest and step.questName then
        ResolveQuest(step)
        if not step.quest then
            -- unresolved: can't auto-detect, user advances manually
            return false
        end
    end

    if t == "accept" then
        -- Satisfied once it's in the log OR already turned in.
        return Data:IsQuestInLog(step.quest) or Data:IsQuestComplete(step.quest)

    elseif t == "turnin" then
        return Data:IsQuestComplete(step.quest)

    elseif t == "complete" then
        -- Objectives done but not handed in yet.
        return Data:IsQuestReadyToTurnIn(step.quest) or Data:IsQuestComplete(step.quest)

    elseif t == "grind" then
        return Data:PlayerLevel() >= step.targetLevel

    elseif t == "level" then
        return Data:PlayerLevel() >= step.targetLevel

    elseif t == "section" then
        -- a header, not a task
        return true

    elseif t == "trainer" or t == "death" then
        -- no detectable condition; user advances
        return false

    elseif t == "manual" or t == "travel" or t == "hearth" or t == "note" then
        -- No detectable condition. User clicks to advance.
        return false
    end

    return false
end

Core.IsStepDone = IsStepDone

-- Should this step be shown at all for this character?
local function StepApplies(step)
    if step.races then
        local race = Data:PlayerRace()
        local match = false
        for _, r in ipairs(step.races) do
            if r == race then match = true break end
        end
        if not match then return false end
    end

    if step.class then
        local _, classFile = UnitClass("player")
        if step.class ~= classFile then return false end
    end

    if step.minLevel and Data:PlayerLevel() < step.minLevel then
        return false
    end

    return true
end

Core.StepApplies = StepApplies

--------------------------------------------------------------------------
-- Advancing
--------------------------------------------------------------------------

-- Walks backwards from the current step to find which section you're in.
-- Section steps are markers, not work - they auto-advance past.
function Core:CurrentSection()
    if not self.active then return nil end
    for i = math.min(self.index, #self.active.steps), 1, -1 do
        local step = self.active.steps[i]
        if step and step.type == "section" then return step, i end
    end
    return nil
end

-- Every section in the route, with how far through each you are.
function Core:Sections()
    local out = {}
    if not self.active then return out end

    local currentSec = nil
    for i, step in ipairs(self.active.steps) do
        if step.type == "section" then
            currentSec = { name = step.name, levels = step.levels,
                           first = i, done = 0, total = 0 }
            table.insert(out, currentSec)
        elseif currentSec then
            currentSec.total = currentSec.total + 1
            if i < self.index or self.IsStepDone(step) then
                currentSec.done = currentSec.done + 1
            end
            currentSec.last = i
        end
    end
    return out
end

function Core:CurrentStep()
    if not self.active then return nil end
    return self.active.steps[self.index]
end

-- The only place self.index is assigned. Clamps to the valid range, saves,
-- and refreshes every dependent module. Never advances further on its own -
-- call Reconcile separately if auto-advance past done steps is wanted.
function Core:SetIndex(n, opts)
    opts = opts or {}
    local total = self.active and #self.active.steps or 0
    self.index = math.max(1, math.min(n, total + 1))
    if opts.pin then self.pinned = true end

    self:Save()
    if ns.UI then ns.UI:Refresh() end
    local step = self:CurrentStep()
    if step then Data:SetWaypoint(step) end
    if ns.Marker then ns.Marker:RescanAll() end
    if ns.Panel then ns.Panel:Refresh() end
    if ns.Progress then ns.Progress:Refresh() end
end

-- Walk forward past every step that's already satisfied or doesn't apply.
-- Called on login and after every relevant event. Does nothing while
-- pinned - otherwise a quest event within ~0.3s of Back or a manual goto
-- would immediately undo it by skipping straight past the step the player
-- just navigated to.
function Core:Reconcile()
    if not self.active or self.pinned then return end

    local moved = false
    local guard = 0

    while self.index <= #self.active.steps do
        guard = guard + 1
        if guard > 5000 then break end   -- paranoia

        local step = self.active.steps[self.index]
        if not StepApplies(step) or IsStepDone(step) then
            self.index = self.index + 1
            moved = true
        else
            break
        end
    end

    if moved then
        self:Save()
        if ns.UI then ns.UI:Refresh() end
        local step = self:CurrentStep()
        if step then Data:SetWaypoint(step) end
        if ns.Marker then ns.Marker:RescanAll() end
        if ns.Panel then ns.Panel:Refresh() end
        if ns.Progress then ns.Progress:Refresh() end
    end
end

function Core:Advance()
    if not self.active then return end
    self.pinned = false
    self:SetIndex(self.index + 1)
    self:Reconcile()
end

function Core:Back()
    if not self.active then return end
    self:SetIndex(self.index - 1, { pin = true })
end

-- Un-pins and lets Reconcile skip forward past whatever's already done.
-- Also the seam for Plan 2's fast-forward (scan from step 1 for the
-- furthest step whose quest flags say it's done) once that's built.
function Core:Resume()
    if not self.active then return end
    self.pinned = false
    self:Reconcile()
end

--------------------------------------------------------------------------
-- Route selection
--------------------------------------------------------------------------

function Core:LoadRoute(name)
    local route = self.routes[name]
    if not route then return false end

    self.active = route
    self.pinned = false
    self.index = 1
    self:Reconcile()
    self:Save()
    if ns.UI then ns.UI:Refresh() end
    return true
end

-- Pick the best route for this character automatically.
--
-- pairs() iteration order over Core.routes is unspecified, so with more
-- than one matching route the pick could differ between launches or even
-- between /reloads on the same character - and on Forever, where the
-- saved route choice never survives a relaunch, that's every login.
-- Collect every match and rank it deterministically instead of returning
-- whichever pairs() happens to hand back first.
function Core:AutoSelectRoute()
    local race = Data:PlayerRace()
    local faction = Data:PlayerFaction()

    local candidates = {}
    for name, route in pairs(self.routes) do
        if route.faction == faction then
            local matches = not route.races
            if not matches then
                for _, r in ipairs(route.races) do
                    if r == race then matches = true break end
                end
            end
            if matches then
                table.insert(candidates, { name = name, route = route })
            end
        end
    end

    if #candidates == 0 then return nil end

    -- Prefer a real route over a demo/skeleton, then a solo route over one
    -- that needs a standing 5-man, then the lowest starting level, then
    -- name, so the result is the same every time regardless of
    -- registration order.
    table.sort(candidates, function(a, b)
        local aDemo = a.route.sample or a.route.skeleton
        local bDemo = b.route.sample or b.route.skeleton
        if aDemo ~= bDemo then return not aDemo end

        -- route.group means "assumes a premade group". Playable, but never
        -- the right guess for a character we know nothing about.
        local aGroup = a.route.group or false
        local bGroup = b.route.group or false
        if aGroup ~= bGroup then return not aGroup end

        local aLevel = a.route.levels and a.route.levels[1] or math.huge
        local bLevel = b.route.levels and b.route.levels[1] or math.huge
        if aLevel ~= bLevel then return aLevel < bLevel end

        return a.name < b.name
    end)

    local pick = candidates[1]
    Print(("Auto-selected route: %s (best match for %s %s)"):format(
        pick.name, tostring(race), tostring(faction)))
    return pick.name
end

--------------------------------------------------------------------------
-- Persistence
--------------------------------------------------------------------------

function Core:Save()
    local db = Compat:InitSavedVar("TuFFlevelsCharDB")
    db.route = self.active and self.active.name or nil
    db.index = self.index
end

function Core:Load()
    local db = Compat:InitSavedVar("TuFFlevelsCharDB")

    -- Forever beta writes SavedVariables on exit but never reads them back,
    -- so progress silently resets. Warn instead of quietly losing it.
    if Compat:SavedVarsAreBroken() then
        C_Timer.After(5, function()
            Print("|cffffff00Progress saving is not working on this client.|r")
            Print("Your step number is shown on the tracker - note it before logging out.")
        end)
    end

    local name = db.route
    if name and self.routes[name] then
        self.active = self.routes[name]
        self.index = db.index or 1
    else
        local auto = self:AutoSelectRoute()
        if auto then
            self.active = self.routes[auto]
            self.index = 1
        end
    end
    self:Reconcile()
end

--------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------

local f = CreateFrame("Frame")

-- On Forever, RegisterEvent with an unknown event throws and aborts the
-- rest of this file. Every registration goes through the guarded helper.
local _, missingEvents = Compat:RegisterEvents(f, {
    "PLAYER_LOGIN",
    "QUEST_ACCEPTED",
    "QUEST_TURNED_IN",
    "QUEST_LOG_UPDATE",
    "UNIT_QUEST_LOG_CHANGED",
    "PLAYER_LEVEL_UP",
})
Core.missingEvents = missingEvents

-- QUEST_LOG_UPDATE fires constantly. Throttle reconciliation so we're not
-- walking the route table dozens of times a second during heavy questing.
local pending = false
local function ThrottledReconcile()
    if pending then return end
    pending = true
    C_Timer.After(0.3, function()
        pending = false
        Core:Reconcile()
    end)
end

f:SetScript("OnEvent", Compat:Wrap("Core", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        Data:DetectProvider()
        Compat:LoadNameCache()
        Core:Load()

        if ns.UI then ns.UI:Build() ; ns.UI:Refresh() end

        -- Configure itself rather than making the user type commands.
        if ns.Panel then
            local firstRun = ns.Panel:FirstRunSetup()
            ns.Panel:Build()
            if firstRun then
                C_Timer.After(2, function() ns.Panel:ShowWelcome() end)
            end
        end
        if ns.Arrow then ns.Arrow:Build() end
        if ns.Marker then C_Timer.After(1, function() ns.Marker:RescanAll() end) end
    else
        -- Anything that isn't login is a quest event, so the cached view of
        -- the quest log is stale from here on.
        Compat:InvalidateLogIndex()
        ThrottledReconcile()
    end
end))

--------------------------------------------------------------------------
-- Slash commands
--------------------------------------------------------------------------

SLASH_TUFFLEVELS1 = "/tuff"
SLASH_TUFFLEVELS2 = "/tufflevels"
SLASH_TUFFLEVELS3 = "/sl"

SlashCmdList["TUFFLEVELS"] = Compat:Wrap("Slash", function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = (cmd or ""):lower()

    if cmd == "" or cmd == "show" then
        if ns.UI then ns.UI:Toggle() end

    elseif cmd == "menu" then
        ns.Panel:Toggle()

    elseif cmd == "progress" or cmd == "done" then
        ns.Progress:Toggle()

    elseif cmd == "recover" or cmd == "import" then
        ns.Import:Show()

    elseif cmd == "next" and arg == "zone" then
        ns.Zones:Show()

    elseif cmd == "zone" or cmd == "zones" then
        ns.Zones:Show()

    elseif cmd == "guide" then
        ns.GuideImport:Show()

    elseif cmd == "rogue" then
        ns.Rogue:Show()

    elseif cmd == "sheet" then
        ns.SheetImport:Show()

    elseif cmd == "arrow" then
        ns.Arrow:Toggle()

    elseif cmd == "mobs" then
        ns.Marker:ToggleMobs()

    elseif cmd == "next" then
        Core:Advance()

    elseif cmd == "back" then
        Core:Back()

    elseif cmd == "routes" then
        Print("Available routes:")
        for name, route in pairs(Core.routes) do
            local tag = ""
            if route.skeleton then tag = "  |cffffff00[skeleton - no quest IDs]|r"
            elseif route.sample then tag = "  |cffffff00[sample - unverified IDs, run /tuff verify]|r" end
            Print(("  %s  (%s, levels %s-%s)%s"):format(
                name, route.faction or "?",
                route.levels and route.levels[1] or "?",
                route.levels and route.levels[2] or "?", tag))
        end

    elseif cmd == "load" then
        if Core:LoadRoute(arg) then
            Print("Loaded route: " .. arg)
        else
            Print("No such route: " .. tostring(arg))
        end

    elseif cmd == "verify" then
        if not Core.active then Print("No route loaded.") return end
        Print(("Validating '%s' (%d steps, provider: %s)"):format(
            Core.active.name, #Core.active.steps, Data:ProviderName()))
        local problems, unknown, unresolved = Data:ValidateRoute(Core.active)
        if #problems == 0 then
            Print("|cff00ff00No structural problems found.|r")
        else
            for _, p in ipairs(problems) do
                Print("|cffff5555" .. p .. "|r")
            end
        end
        if unknown > 0 then
            Print(("|cffffff00%d quest IDs could not be checked (no database installed).|r"):format(unknown))
        end
        if unresolved > 0 then
            Print(("%d steps resolve by name at runtime (not a problem)."):format(unresolved))
        end

    elseif cmd == "capture" then
        -- Dumps your current quest log as ready-to-paste route steps.
        -- This is how you author a route without hand-looking-up IDs.
        Print("--- paste into your route file ---")
        for i = 1, Compat:NumQuestLogEntries() do
            local info = Compat:GetQuestLogInfo(i)
            if info and not info.isHeader then
                Print(('{ type="turnin", quest=%d, name="%s" },'):format(
                    info.questID, info.title))
            end
        end

    elseif cmd == "rec" or cmd == "record" then
        local sub = arg:match("^(%S*)")
        sub = (sub or ""):lower()
        local rest = arg:match("^%S*%s+(.*)$")
        if sub == "start" then
            ns.Recorder:Start()
        elseif sub == "stop" then
            ns.Recorder:Stop()
        elseif sub == "export" then
            ns.Recorder:ShowExport(rest)
        elseif sub == "clear" then
            ns.Recorder:Clear()
        elseif sub == "status" then
            Print(("Recording: %s  |  %d steps captured"):format(
                ns.Recorder.active and "|cff00ff00ON|r" or "|cffff5555OFF|r",
                #ns.Recorder.log))
        else
            Print("Usage: /tuff rec start | stop | status | export [name] | clear")
        end

    elseif cmd == "marker" then
        ns.Marker:Toggle()

    elseif cmd == "plates" then
        if arg:lower() == "off" then
            ns.Marker:DisableFriendlyPlates()
        else
            ns.Marker:EnableFriendlyPlates()
        end

    elseif cmd == "npc" then
        local step = Core:CurrentStep()
        if step and step.npc then
            Print("Current step NPC: |cffffd100" .. step.npc .. "|r")
        else
            Print("This step has no NPC recorded.")
        end

    elseif cmd == "note" then
        if arg == "" then Print("Usage: /tuff note <text>") else ns.Recorder:AddNote(arg) end

    elseif cmd == "mark" then
        ns.Recorder:AddMark(arg ~= "" and arg or nil)

    elseif cmd == "where" then
        Print(("Route: %s  |  Step %d of %d"):format(
            Core.active and Core.active.name or "none",
            Core.index, Core.active and #Core.active.steps or 0))

    elseif cmd == "goto" then
        local n = tonumber(arg)
        if n then
            Core:SetIndex(n, { pin = true })
            Print("Jumped to step " .. Core.index .. " (pinned - /tuff resume to continue auto-advance)")
        else
            Print("Usage: /tuff goto <step number>")
        end

    elseif cmd == "resume" then
        Core:Resume()
        Print("Resumed. Step " .. Core.index)

    elseif cmd == "client" then
        Print(("Flavor: %s  |  Interface: %d  |  Mainline: %s"):format(
            Compat.flavor, Compat.tocVersion, tostring(Compat.isMainline)))
        Print(("Restricted API: %s  |  Database: %s"):format(
            tostring(Compat.restricted), Data:ProviderName()))
        if #(Core.missingEvents or {}) > 0 then
            Print("|cffffff00Events this client rejected: " ..
                table.concat(Core.missingEvents, ", ") .. "|r")
        end
        if Compat:SavedVarsAreBroken() then
            Print("|cffffff00SavedVariables are not being restored on this client.|r")
        end

    elseif cmd == "errors" then
        Print(("Guard-wrapped API calls suppressed: %d"):format(Compat:ErrorCount()))
        local counts = Compat:ModuleErrorCounts()
        local any = false
        for name, info in pairs(counts) do
            any = true
            Print(("  %s: %d error(s)%s"):format(
                name, info.count, info.tripped and " |cffff5555(suppressed)|r" or ""))
        end
        if not any then Print("  No handler errors this session.") end
        if Compat.lastError then Print("Last: " .. tostring(Compat.lastError)) end

    elseif cmd == "reset" then
        Core.pinned = false
        Core:SetIndex(1)
        Core:Reconcile()
        Print("Reset to step 1.")

    else
        Print("Commands: show | next | back | resume | where | goto <n> | routes | load <name>")
        Print("          verify | capture | client | errors | reset")
        Print("Recording: /tuff rec start | stop | status | export | clear")
        Print("          /tuff note <text> | /tuff mark <text>")
        Print("Markers: /tuff marker | /tuff plates [off] | /tuff npc")
        Print("(/tuff, /tufflevels and /sl all work the same)")
    end
end)
