-- TuFFlevels / Compat.lua
-- Loads first. Normalizes the three clients this addon targets:
--
--   Classic Era   interface 11507, WOW_PROJECT_CLASSIC
--   Forever       interface 16001, WOW_PROJECT_MAINLINE, folder _classic_beta_
--   Midnight      interface 120100+, WOW_PROJECT_MAINLINE
--
-- Forever is the Retail client wearing a Classic-looking build number. That
-- combination breaks the usual detection idiom, so never gate on the
-- interface number alone.

local ADDON, ns = ...

local Compat = {}
ns.Compat = Compat

--------------------------------------------------------------------------
-- Flavor detection
--------------------------------------------------------------------------

local _, _, _, tocVersion = GetBuildInfo()
tocVersion = tonumber(tocVersion) or 0

local isMainline = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

-- THE TRAP: Forever reports 16001 while being the Retail client. Almost
-- every Retail addon tests `tocVersion >= 100000` to mean "modern", so
-- Forever makes them load Classic paths or refuse to start. Detect by
-- project ID first, build number second.
local flavor
if isMainline and tocVersion < 100000 then
    flavor = "forever"
elseif isMainline then
    flavor = "retail"
else
    flavor = "classic"
end

Compat.flavor      = flavor
Compat.tocVersion  = tocVersion
Compat.isMainline  = isMainline
Compat.isForever   = (flavor == "forever")
Compat.isClassic   = (flavor == "classic")

-- Are we on a client with Midnight-era restrictions?
Compat.restricted  = isMainline and (C_Secrets ~= nil or C_RestrictedActions ~= nil)

--------------------------------------------------------------------------
-- Safe event registration
--------------------------------------------------------------------------

-- On Forever, RegisterEvent with an event the client doesn't know throws
-- and ABORTS THE REST OF THE FILE. One bad event name kills the addon.
-- Always go through this.
function Compat:RegisterEvents(frame, events)
    local registered, missing = {}, {}
    for _, event in ipairs(events) do
        local ok = pcall(frame.RegisterEvent, frame, event)
        if ok then
            table.insert(registered, event)
        else
            table.insert(missing, event)
        end
    end
    return registered, missing
end

--------------------------------------------------------------------------
-- SavedVariables bridge
--------------------------------------------------------------------------

-- Forever beta bug: the client WRITES SavedVariables on exit but never
-- reads them back. Every addon starts from defaults each launch.
--
-- We can't fix that from inside Lua. What we can do is fail loudly instead
-- of silently losing someone's route progress 40 levels in, and keep an
-- in-session copy so a /reload inside one session doesn't lose anything.

local sessionCache = {}

function Compat:InitSavedVar(globalName, default)
    local existing = _G[globalName]

    if type(existing) ~= "table" then
        -- Either first run, or the Forever SV bug ate it.
        if sessionCache[globalName] then
            _G[globalName] = sessionCache[globalName]
        else
            _G[globalName] = default or {}
        end
        if self.isForever and not sessionCache[globalName] then
            self.svSuspect = true
        end
    end

    sessionCache[globalName] = _G[globalName]
    return _G[globalName]
end

function Compat:SavedVarsAreBroken()
    return self.isForever and self.svSuspect
end

--------------------------------------------------------------------------
-- Reload
--------------------------------------------------------------------------

-- ReloadUI() is protected on Forever. Addon reload buttons are blocked.
function Compat:CanReload()
    return not self.isForever
end

--------------------------------------------------------------------------
-- API shims
--------------------------------------------------------------------------

-- Quest log. C_QuestLog exists on every target, but a few accessors moved.
-- Wrap the ones we depend on so a single missing function degrades to
-- "unknown" rather than erroring.

function Compat:IsQuestComplete(questID)
    if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then return false end
    local ok, result = pcall(C_QuestLog.IsQuestFlaggedCompleted, questID)
    return ok and result or false
end

function Compat:GetLogIndex(questID)
    if not (C_QuestLog and C_QuestLog.GetLogIndexForQuestID) then return nil end
    local ok, result = pcall(C_QuestLog.GetLogIndexForQuestID, questID)
    return ok and result or nil
end

function Compat:IsQuestObjectivesComplete(questID)
    if not (C_QuestLog and C_QuestLog.IsComplete) then return false end
    local ok, result = pcall(C_QuestLog.IsComplete, questID)
    return ok and result or false
end

function Compat:NumQuestLogEntries()
    if not (C_QuestLog and C_QuestLog.GetNumQuestLogEntries) then return 0 end
    local ok, result = pcall(C_QuestLog.GetNumQuestLogEntries)
    return ok and result or 0
end

function Compat:GetQuestLogInfo(index)
    if not (C_QuestLog and C_QuestLog.GetInfo) then return nil end
    local ok, result = pcall(C_QuestLog.GetInfo, index)
    return ok and result or nil
end

--------------------------------------------------------------------------
-- Quest name resolution
--------------------------------------------------------------------------

-- The route spreadsheet stores quest names, not IDs. Names aren't unique
-- across the game, but they are unique within your quest log at any moment,
-- which is the only time we need to match.
--
-- Resolved IDs are cached permanently - once you've had a quest in your log
-- we know its ID forever, including after it's turned in.

local nameCache = {}

function Compat:CacheQuestName(name, questID)
    if name and questID then nameCache[name:lower()] = questID end
end

function Compat:GetQuestIDByName(name)
    if not name then return nil end
    local key = name:lower()
    if nameCache[key] then return nameCache[key] end

    for i = 1, self:NumQuestLogEntries() do
        local info = self:GetQuestLogInfo(i)
        if info and not info.isHeader and info.title then
            nameCache[info.title:lower()] = info.questID
            if info.title:lower() == key then return info.questID end
        end
    end
    return nil
end

function Compat:LoadNameCache()
    local db = self:InitSavedVar("TuFFlevelsDB")
    db.questNames = db.questNames or {}
    for name, id in pairs(db.questNames) do nameCache[name] = id end
end

function Compat:SaveNameCache()
    local db = self:InitSavedVar("TuFFlevelsDB")
    db.questNames = db.questNames or {}
    for name, id in pairs(nameCache) do db.questNames[name] = id end
end

--------------------------------------------------------------------------
-- Error budget
--------------------------------------------------------------------------

-- Forever stops delivering Lua errors after 100 in a session. If this addon
-- is spewing, it will mask every other addon's real errors. Self-limit.

local errorCount = 0
local ERROR_BUDGET = 10

function Compat:Guard(fn, ...)
    if errorCount >= ERROR_BUDGET then return end
    local results = { pcall(fn, ...) }
    if not results[1] then
        errorCount = errorCount + 1
        if errorCount == ERROR_BUDGET then
            print("|cffff5555TuFFlevels|r: error budget reached, suppressing further errors. /sl errors")
        end
        Compat.lastError = results[2]
        return nil
    end
    return unpack(results, 2)
end

function Compat:ErrorCount()
    return errorCount
end
