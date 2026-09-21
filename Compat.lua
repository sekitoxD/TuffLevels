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

-- Capability flags, not client-flavor guesses. Feature code should ask
-- Compat.has.x rather than Compat.isForever/isMainline/etc, so a feature
-- degrades correctly if a future client build adds or drops an API,
-- instead of silently breaking because it only checked the flavor name.
-- has.questDB is set later by Data:DetectProvider(), once it knows whether
-- a provider actually attached (Data.lua is the only file allowed to touch
-- QuestieDB directly, so this file can't determine that value itself).
Compat.has = {
    specs       = GetSpecialization ~= nil,
    secretValues = Compat.restricted,
    taxiMap     = C_TaxiMap ~= nil,
    questDB     = false,
    -- The modern Settings API (Blizzard Game Menu > Options > AddOns) is
    -- Retail/Forever only (both WOW_PROJECT_MAINLINE) - Classic Era still
    -- uses the legacy InterfaceOptionsFrame and has no `Settings` global at
    -- all. Gated on the exact functions Panel.lua's settings category
    -- needs, not just `Settings ~= nil`, since a future client could add
    -- the namespace without every function this addon calls - short-circuit
    -- `and` keeps this safe even when `Settings` itself is nil.
    settingsAPI = Settings ~= nil
        and Settings.RegisterVerticalLayoutCategory ~= nil
        and Settings.RegisterAddOnCategory ~= nil
        and Settings.RegisterProxySetting ~= nil
        and Settings.CreateCheckbox ~= nil,
}

--------------------------------------------------------------------------
-- Secret values / instance restrictions
--------------------------------------------------------------------------

-- NOTE: C_Secrets.HasSecretRestrictions/ShouldUnitIdentityBeSecret and the
-- issecretvalue() global are from Midnight's patch 12.0.0 API notes, not
-- verified against this session's actual client - same caveat as the
-- QuestieDB/flightpath assumptions elsewhere in this addon. Every call
-- here already degrades to "not restricted" if the API isn't present, so
-- a wrong guess just means the (already-optional) safety check no-ops,
-- not that anything breaks.

-- Broadly: is the client currently restricting addon access to some Lua
-- values at all, regardless of which unit is involved?
--
-- Confirmed unreliable as a blanket gate: in-game testing on Forever found
-- this returning true while standing in an ordinary outdoor leveling zone
-- (Durotar, no instance, nothing secret about a normal kill quest), which
-- made Marker.lua pause nameplate matching everywhere, all the time.
-- Marker.lua no longer OR's this into its restricted-check; it relies on
-- IsInInstance() plus the narrower per-unit/per-value checks below
-- instead. Kept here in case a future, more targeted use for it turns up,
-- but don't wire it back into a feature-wide pause without re-verifying
-- against a live client first.
function Compat:HasSecretRestrictions()
    if C_Secrets and C_Secrets.HasSecretRestrictions then
        if self:Guard(C_Secrets.HasSecretRestrictions) then return true end
    end
    if C_RestrictedActions and C_RestrictedActions.IsAddOnRestrictionActive then
        if self:Guard(C_RestrictedActions.IsAddOnRestrictionActive) then return true end
    end
    return false
end

-- Narrowly: would THIS unit's identity (name) specifically come back as
-- an opaque secret value right now?
function Compat:IsUnitIdentitySecret(unit)
    if not (C_Secrets and C_Secrets.ShouldUnitIdentityBeSecret) then return false end
    return self:Guard(C_Secrets.ShouldUnitIdentityBeSecret, unit) == true
end

-- Belt-and-suspenders: is this specific already-read value itself secret
-- (opaque, not safely comparable/stringable), independent of whether we
-- expected it to be.
function Compat:IsSecretValue(value)
    if not _G.issecretvalue then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return ok and result == true
end

function Compat:IsInInstance()
    return self:Guard(IsInInstance) == true
end

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
-- reads them back. This happens on /reload too, not just a full client
-- relaunch - /reload tears down and re-executes every addon's Lua from
-- scratch, so nothing addon-side survives it either way.
--
-- We can't fix that from inside Lua. What we can do is fail loudly instead
-- of silently losing someone's route progress 40 levels in. sessionCache
-- below only dedupes repeated InitSavedVar calls within one continuous
-- Lua session (e.g. multiple files reading TuFFlevelsDB before anything
-- else has touched it) - it does NOT persist across /reload or relaunch.

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
-- Math
--------------------------------------------------------------------------

-- WoW's Lua 5.1 runtime takes one argument in math.atan; math.atan2, if it
-- exists at all, is the two-argument, four-quadrant form arrow bearings
-- need. Use it when present, otherwise reconstruct the same result by hand.
function Compat.Atan2(y, x)
    if math.atan2 then
        return math.atan2(y, x)
    end
    if x > 0 then
        return math.atan(y / x)
    elseif x < 0 then
        if y >= 0 then
            return math.atan(y / x) + math.pi
        else
            return math.atan(y / x) - math.pi
        end
    else
        if y > 0 then return math.pi / 2
        elseif y < 0 then return -math.pi / 2
        else return 0 end
    end
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

-- GetItemInfo is dropped on Forever (see the header note); C_Item.GetItemInfo
-- is the Retail/Forever replacement and takes the same arguments (itemID,
-- itemString, item link or item name), so try it first. Returns nil, not an
-- error, for an item the client hasn't cached data for yet - callers that
-- need this can't block on a retry, so treat nil as "skip this item".
function Compat:GetItemSellPrice(item)
    if not item then return nil end
    local getInfo = (C_Item and C_Item.GetItemInfo) or _G.GetItemInfo
    if not getInfo then return nil end
    local result = { self:Guard(getInfo, item) }
    local sellPrice = result[11]
    return type(sellPrice) == "number" and sellPrice or nil
end

--------------------------------------------------------------------------
-- Gossip quest lists
--------------------------------------------------------------------------

-- NOTE: C_GossipInfo.GetActiveQuests/GetAvailableQuests's returned table
-- shape (title/questID/... fields) is from memory, not verified against
-- this session's client - same caveat as the QuestieDB/flightpath
-- assumptions elsewhere in this addon. Confirm live before relying on it
-- for anything higher-stakes than the automation opt-in it backs today.
--
-- Both paths return a list of { title = string, questID = number|nil,
-- index = number|nil } - questID is set on the modern path (exact match),
-- index on the legacy Classic Era path (title-text match only).
function Compat:GossipActiveQuests()
    local out = {}
    if C_GossipInfo and C_GossipInfo.GetActiveQuests then
        local list = self:Guard(C_GossipInfo.GetActiveQuests) or {}
        for _, entry in ipairs(list) do
            table.insert(out, { title = entry.title, questID = entry.questID })
        end
        return out
    end
    local n = self:Guard(_G.GetNumActiveQuests) or 0
    for i = 1, n do
        table.insert(out, { title = self:Guard(_G.GetActiveTitle, i), index = i })
    end
    return out
end

function Compat:GossipAvailableQuests()
    local out = {}
    if C_GossipInfo and C_GossipInfo.GetAvailableQuests then
        local list = self:Guard(C_GossipInfo.GetAvailableQuests) or {}
        for _, entry in ipairs(list) do
            table.insert(out, { title = entry.title, questID = entry.questID })
        end
        return out
    end
    local n = self:Guard(_G.GetNumAvailableQuests) or 0
    for i = 1, n do
        table.insert(out, { title = self:Guard(_G.GetAvailableTitle, i), index = i })
    end
    return out
end

function Compat:SelectGossipActiveQuest(entry)
    if C_GossipInfo and C_GossipInfo.SelectActiveQuest and entry.questID then
        self:Guard(C_GossipInfo.SelectActiveQuest, entry.questID)
    elseif entry.index then
        self:Guard(_G.SelectActiveQuest, entry.index)
    end
end

function Compat:SelectGossipAvailableQuest(entry)
    if C_GossipInfo and C_GossipInfo.SelectAvailableQuest and entry.questID then
        self:Guard(C_GossipInfo.SelectAvailableQuest, entry.questID)
    elseif entry.index then
        self:Guard(_G.SelectAvailableQuest, entry.index)
    end
end

-- The modern C_SpellBook API takes an Enum.SpellBookSpellBank value
-- ("Player"), not the old numeric BOOKTYPE_SPELL bank argument. Passing a
-- bare 2 where that enum is expected returns nothing or the wrong list.
-- GetSpecialization and other spec APIs are absent on Forever, so this
-- stays a pure bank-argument shim rather than anything spec-aware.
function Compat:GetSpellBookName(index)
    if C_SpellBook and C_SpellBook.GetSpellBookItemName then
        local bank = Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
        local ok, name = pcall(C_SpellBook.GetSpellBookItemName, index, bank)
        return ok and name or nil
    end
    if _G.GetSpellBookItemName then
        local ok, name = pcall(_G.GetSpellBookItemName, index, "spell")
        return ok and name or nil
    end
    return nil
end

-- SetResizeBounds is the modern min/max-size call; older clients only have
-- the SetMinResize/SetMaxResize pair it replaced. Try the new one first.
function Compat:SetResizeBounds(frame, minW, minH, maxW, maxH)
    if frame.SetResizeBounds then
        local ok = pcall(frame.SetResizeBounds, frame, minW, minH, maxW, maxH)
        if ok then return end
    end
    if frame.SetMinResize then pcall(frame.SetMinResize, frame, minW, minH) end
    if frame.SetMaxResize then pcall(frame.SetMaxResize, frame, maxW, maxH) end
end

--------------------------------------------------------------------------
-- Class icon, for the tracker portrait
--------------------------------------------------------------------------

-- Fallback icon if the class-circle atlas/table isn't available on this
-- client - a known-present Classic icon, not a class portrait, but never a
-- broken texture.
local FALLBACK_ICON = "Interface\\Icons\\Ability_Rogue_Eviscerate"

function Compat:ClassIcon()
    local ok, _, token = pcall(UnitClass, "player")
    if ok and token and _G.CLASS_ICON_TCOORDS and _G.CLASS_ICON_TCOORDS[token] then
        local c = _G.CLASS_ICON_TCOORDS[token]
        return "Interface\\TargetingFrame\\UI-Classes-Circles", c[1], c[2], c[3], c[4]
    end
    return FALLBACK_ICON, 0, 1, 0, 1
end

--------------------------------------------------------------------------
-- Zone name -> uiMapID
--------------------------------------------------------------------------

-- Route steps carry a zone NAME, not a uiMapID. uiMapIDs are per-flavor
-- data, not API, so a number baked into a route file is a guess about a
-- client we can't inspect from here. Instead, ask this client what it calls
-- its own zones and build the index once.
--
-- The table below is Classic Era's numbering and exists only as a fallback
-- for a client where the map-tree walk returns nothing.

local CLASSIC_MAP_IDS = {
    ["durotar"] = 1411,               ["mulgore"] = 1412,
    ["the barrens"] = 1413,           ["alterac mountains"] = 1416,
    ["arathi highlands"] = 1417,      ["badlands"] = 1418,
    ["blasted lands"] = 1419,         ["tirisfal glades"] = 1420,
    ["silverpine forest"] = 1421,     ["western plaguelands"] = 1422,
    ["eastern plaguelands"] = 1423,   ["hillsbrad foothills"] = 1424,
    ["the hinterlands"] = 1425,       ["dun morogh"] = 1426,
    ["searing gorge"] = 1427,         ["burning steppes"] = 1428,
    ["elwynn forest"] = 1429,         ["deadwind pass"] = 1430,
    ["duskwood"] = 1431,              ["loch modan"] = 1432,
    ["redridge mountains"] = 1433,    ["stranglethorn vale"] = 1434,
    ["swamp of sorrows"] = 1435,      ["westfall"] = 1436,
    ["wetlands"] = 1437,              ["teldrassil"] = 1438,
    ["darkshore"] = 1439,             ["ashenvale"] = 1440,
    ["thousand needles"] = 1441,      ["stonetalon mountains"] = 1442,
    ["desolace"] = 1443,              ["feralas"] = 1444,
    ["dustwallow marsh"] = 1445,      ["tanaris"] = 1446,
    ["azshara"] = 1447,               ["felwood"] = 1448,
    ["un'goro crater"] = 1449,        ["moonglade"] = 1450,
    ["silithus"] = 1451,              ["winterspring"] = 1452,
    ["stormwind city"] = 1453,        ["orgrimmar"] = 1454,
    ["ironforge"] = 1455,             ["thunder bluff"] = 1456,
    ["darnassus"] = 1457,             ["undercity"] = 1458,
}

-- The route spreadsheets spell several zones their own way, and a couple of
-- entries are outright typos that still have to resolve to something.
local ZONE_ALIASES = {
    ["stonetalon mts"]        = "stonetalon mountains",
    ["stonetalon mountains"]  = "stonetalon mountains",
    ["ungoro crater"]         = "un'goro crater",
    ["un'goro crater"]        = "un'goro crater",
    ["the undercity"]         = "undercity",
    ["capital city"]          = "undercity",
    ["trisfall"]              = "tirisfal glades",
    ["trisfal"]               = "tirisfal glades",
    ["trisfal glades"]        = "tirisfal glades",
    ["tirisfal"]              = "tirisfal glades",
    ["hinterlands"]           = "the hinterlands",
    ["ogrimmar"]              = "orgrimmar",
    ["thunderbluff"]          = "thunder bluff",
    ["tanris"]                = "tanaris",
    ["the badlands"]          = "badlands",
    ["eastern plagueland"]    = "eastern plaguelands",
    ["easternplaguelands"]    = "eastern plaguelands",
    ["barrens"]               = "the barrens",
    ["northern barrens"]      = "the barrens",
}

local zoneIndex

local function ZoneIndex()
    if zoneIndex then return zoneIndex end

    local built = {}
    if C_Map and C_Map.GetMapChildrenInfo then
        -- 946 is the Cosmic map; asking for all descendants gets every zone
        -- in one call instead of recursing the tree by hand.
        for _, root in ipairs({ 946, 947 }) do
            local all = Compat:Guard(C_Map.GetMapChildrenInfo, root, nil, true)
            if all then
                for _, info in ipairs(all) do
                    if info.name and info.mapID then
                        local key = info.name:lower()
                        if not built[key] then built[key] = info.mapID end
                    end
                end
            end
        end
    end

    -- Only memoize a walk that actually found something. Called too early
    -- (before the map system is up) it comes back empty, and caching that
    -- would poison every lookup for the rest of the session.
    if next(built) then zoneIndex = built end
    return built
end

-- Returns the uiMapID this client uses for a zone name, or nil.
function Compat:MapID(zone)
    if type(zone) ~= "string" or zone == "" then return nil end

    local key = zone:lower()
    key = ZONE_ALIASES[key] or key

    local index = ZoneIndex()
    return index[key] or CLASSIC_MAP_IDS[key]
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

-- A name -> ID map of the CURRENT quest log, rebuilt at most once per quest
-- event. A 2800-step route asks "what is this name's ID?" thousands of times
-- per refresh; walking all 25 log slots for each of those is the difference
-- between an instant refresh and a visible hitch on QUEST_LOG_UPDATE.
local logIndex

function Compat:InvalidateLogIndex()
    logIndex = nil
end

local function LogIndex()
    if logIndex then return logIndex end

    local map = {}
    for i = 1, Compat:NumQuestLogEntries() do
        local info = Compat:GetQuestLogInfo(i)
        if info and not info.isHeader and info.title then
            map[info.title:lower()] = info.questID
        end
    end

    logIndex = map
    return map
end

function Compat:GetQuestIDByName(name)
    if not name then return nil end
    local key = name:lower()
    if nameCache[key] then return nameCache[key] end

    for title, questID in pairs(LogIndex()) do
        nameCache[title] = questID
    end
    return nameCache[key]
end

-- Chain quests reuse one name for every link: the route sheet has four
-- separate quests all called "Arugal's Folly". The cache above is keyed by
-- name, so link 1's ID would answer for links 2-4 forever - and since link 1
-- IS flagged complete by then, every later link would read as already done
-- and the engine would blow through the whole chain without you playing it.
--
-- Steps that carry an ambiguous name resolve through here instead: live log
-- only, no cache read, no cache write. The log holds exactly the link you
-- are on right now, which is the one thing that can disambiguate them.
function Compat:GetQuestIDByNameLive(name)
    if not name then return nil end
    return LogIndex()[name:lower()]
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
local ERROR_BUDGET = 20

function Compat:Guard(fn, ...)
    if errorCount >= ERROR_BUDGET then return end
    local results = { pcall(fn, ...) }
    if not results[1] then
        errorCount = errorCount + 1
        if errorCount == ERROR_BUDGET then
            print("|cffff5555TuFFlevels|r: error budget reached, suppressing further errors. /tuff errors")
        end
        Compat.lastError = results[2]
        return nil
    end
    return unpack(results, 2)
end

function Compat:ErrorCount()
    return errorCount
end

-- Once true, Guard(fn, ...) stops calling fn at all and just returns nil -
-- callers that infer success/failure from whether Guard's error count moved
-- (rather than its return value, since some wrapped APIs are void on
-- success) need this to tell "skipped" apart from "ran and succeeded".
function Compat:ErrorBudgetExhausted()
    return errorCount >= ERROR_BUDGET
end

--------------------------------------------------------------------------
-- Per-module handler wrapping
--------------------------------------------------------------------------

-- Compat:Guard above wraps individual API calls. It does not help an
-- OnUpdate or OnEvent handler that throws from its own logic (not from a
-- WoW API call) - on Forever that can hit the 100-error session cap in
-- seconds, at 20Hz, and it would silently mask every other addon's errors
-- too since the single shared budget above would blow through instantly.
--
-- Compat:Wrap gives every named handler its own small budget. One module
-- tripping (e.g. Arrow's OnUpdate) does not affect any other module, and
-- each distinct error message is only printed once - after that it just
-- counts, so a spammy handler doesn't spam chat.

local moduleCounts  = {}   -- [name] = count
local moduleTripped = {}   -- [name] = true once that module goes silent
local seenMessages  = {}   -- [name] = { [message] = true }
local totalWrapped  = 0

local MODULE_BUDGET = 5
local TOTAL_WRAP_BUDGET = 30   -- well under the client's 100-error cap

-- Wraps fn so it never throws past this call. name groups it for
-- accounting and for /tuff errors. onTrip, if given, runs once the first
-- time this module's budget is spent (e.g. hide a frame, disable a
-- feature) instead of going silent with no explanation.
function Compat:Wrap(name, fn, onTrip)
    return function(...)
        if moduleTripped[name] then return end

        local results = { pcall(fn, ...) }
        if results[1] then
            return unpack(results, 2)
        end

        local msg = tostring(results[2])
        seenMessages[name] = seenMessages[name] or {}
        local isNewMessage = not seenMessages[name][msg]
        seenMessages[name][msg] = true

        moduleCounts[name] = (moduleCounts[name] or 0) + 1
        totalWrapped = totalWrapped + 1
        Compat.lastError = msg

        if isNewMessage then
            print(("|cffff5555TuFFlevels|r [%s]: %s"):format(name, msg))
        end

        if not moduleTripped[name]
           and (moduleCounts[name] >= MODULE_BUDGET or totalWrapped >= TOTAL_WRAP_BUDGET) then
            moduleTripped[name] = true
            print(("|cffff5555TuFFlevels|r: %s hit its error limit and is now suppressed. /tuff errors"):format(name))
            if onTrip then pcall(onTrip) end
        end

        return nil
    end
end

-- [name] = { count = n, lastError = "..." }, for /tuff errors.
function Compat:ModuleErrorCounts()
    local out = {}
    for name, count in pairs(moduleCounts) do
        out[name] = { count = count, tripped = moduleTripped[name] or false }
    end
    return out
end
