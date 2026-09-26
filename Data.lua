-- TuFFlevels / Data.lua
-- Adapter over QuestieDB. Everything that touches an external database goes
-- through here, so when QuestieDB's API shifts you fix one file.
--
-- Design rule: the addon must stay functional with NO database installed.
-- QuestieDB is an enrichment layer (names, coords, prereq validation),
-- never a hard requirement. Route files carry their own coords.

local ADDON, ns = ...

local Compat = ns.Compat

local Data = {}
ns.Data = Data

--------------------------------------------------------------------------
-- Provider detection
--------------------------------------------------------------------------

local provider = nil       -- "questiedb" | "questie" | nil
local providerHandle = nil

function Data:DetectProvider()
    if provider then return provider end

    -- QuestieDB ships as a standalone addon with a global library table.
    -- NOTE: verify the exact global name + accessor signatures against
    -- QuestieDB's docs/api.md before shipping. This is the ONE place that
    -- needs updating if the API differs from what's assumed here.
    if _G.QuestieDB then
        providerHandle = _G.QuestieDB
        provider = "questiedb"
    elseif _G.QuestieLoader then
        local ok, db = pcall(function()
            return _G.QuestieLoader:ImportModule("QuestieDB")
        end)
        if ok and db then
            providerHandle = db
            provider = "questie"
        end
    end

    Compat.has.questDB = (provider ~= nil)
    return provider
end

function Data:HasProvider()
    return self:DetectProvider() ~= nil
end

function Data:ProviderName()
    return provider or "none"
end

--------------------------------------------------------------------------
-- Flight points
--------------------------------------------------------------------------

-- NOTE: TaxiNodeInfo field names (state, Enum.FlightPathState.Known) are
-- from memory, not verified against this session's client - same caveat
-- as the QuestieDB assumptions above. Confirm with /tuff verify or a live
-- flightpath step before shipping a route that relies on this.
--
-- A "flightpath" step is identified by step.mapID (the uiMapID the node
-- lives on) plus either step.node (a numeric nodeID) or step.name.

-- P2.4: GetAllTaxiNodes allocates a fresh table of every node on the map on
-- every call, and a full-route walk (Progress, /tuff verify) can call this
-- for every flightpath step in one pass. A short TTL (not an invalidation
-- event - nothing tells us when a flight point gets learned) keeps a rapid
-- walk from re-allocating the same map's node list over and over, while
-- staying fresh enough that learning a flight point mid-session shows up
-- within a second or two rather than needing a route reload. Objective
-- completion (IsQuestObjectiveDone below) is deliberately NOT memoized the
-- same way - that state changes far more often (every kill/loot) and a
-- stale read there would misreport step completion, not just redraw late.
local taxiNodeCache = {}   -- [mapID] = { nodes = {...}, at = GetTime() }
local TAXI_NODE_CACHE_TTL = 1.5

local function TaxiNodesFor(mapID)
    local entry = taxiNodeCache[mapID]
    local now = GetTime()
    if entry and (now - entry.at) < TAXI_NODE_CACHE_TTL then
        return entry.nodes
    end

    local nodes = Compat:Guard(C_TaxiMap.GetAllTaxiNodes, mapID)
    if nodes then
        taxiNodeCache[mapID] = { nodes = nodes, at = now }
    end
    return nodes
end

function Data:IsFlightPathKnown(step)
    if not (Compat.has.taxiMap and step.mapID and Enum.FlightPathState) then return false end

    local nodes = TaxiNodesFor(step.mapID)
    if not nodes then return false end

    for _, node in ipairs(nodes) do
        if (step.node and node.nodeID == step.node)
            or (step.name and node.name == step.name) then
            return node.state == Enum.FlightPathState.Known
        end
    end
    return false
end

--------------------------------------------------------------------------
-- Quest lookups
--------------------------------------------------------------------------

-- Returns quest name, or nil if unavailable.
-- Falls back to the name stored in the route file.
function Data:GetQuestName(questID, fallback)
    if not self:HasProvider() then return fallback end

    local ok, result = pcall(function()
        local h = providerHandle
        if h.GetQuest then
            local q = h:GetQuest(questID)
            return q and (q.name or q.Name)
        elseif h.QueryQuestSingle then
            return h.QueryQuestSingle(questID, "name")
        end
    end)

    if ok and result then return result end
    return fallback
end

-- Does this quest ID exist in the database at all?
-- Used by /tuff verify to catch typo'd IDs in route files.
function Data:QuestExists(questID)
    if not self:HasProvider() then return nil end  -- nil = unknown, not false
    return self:GetQuestName(questID) ~= nil
end

--------------------------------------------------------------------------
-- Live client state (always available, no provider needed)
--------------------------------------------------------------------------

function Data:IsQuestComplete(questID)
    return Compat:IsQuestComplete(questID)
end

function Data:IsQuestInLog(questID)
    return Compat:GetLogIndex(questID) ~= nil
end

-- Is the quest in the log AND ready to hand in?
function Data:IsQuestReadyToTurnIn(questID)
    if not Compat:GetLogIndex(questID) then return false end
    return Compat:IsQuestObjectivesComplete(questID)
end

-- Is objective n (1-based, in the order the quest log lists them) of this
-- quest finished? Lets a "complete" step gate on one specific objective
-- rather than the whole quest.
function Data:IsQuestObjectiveDone(questID, n)
    if not (C_QuestLog and C_QuestLog.GetQuestObjectives) then return false end
    local objectives = Compat:Guard(C_QuestLog.GetQuestObjectives, questID)
    if type(objectives) ~= "table" then return false end
    local obj = objectives[n]
    return obj ~= nil and obj.finished == true
end

function Data:PlayerLevel()
    return UnitLevel("player")
end

function Data:PlayerRace()
    local _, raceFile = UnitRace("player")
    return raceFile        -- "Orc", "Troll", "Scourge", etc.
end

function Data:PlayerFaction()
    local faction = UnitFactionGroup("player")
    return faction          -- "Horde" | "Alliance"
end

--------------------------------------------------------------------------
-- Route validation
--------------------------------------------------------------------------

-- Walks a route and reports problems. This is the tool that keeps
-- hand-authored route data honest: bad quest IDs, missing coords,
-- steps that reference quests the DB has never heard of.
function Data:ValidateRoute(route)
    local problems = {}
    local unknown = 0
    local unresolved = 0

    for i, step in ipairs(route.steps) do
        local label = ("step %d (%s)"):format(i, step.type or "?")

        if step.type == "accept" or step.type == "turnin" or step.type == "complete" then
            if type(step.quest) == "number" then
                local exists = self:QuestExists(step.quest)
                if exists == false then
                    table.insert(problems,
                        ("%s: quest %d not found in database"):format(label, step.quest))
                elseif exists == nil then
                    unknown = unknown + 1
                end
            elseif type(step.questName) == "string" and step.questName ~= "" then
                -- Spreadsheet-imported steps carry a name instead of an ID.
                -- Not resolvable until the quest is seen in a live log, so
                -- this is informational, not a validation failure.
                unresolved = unresolved + 1
            else
                table.insert(problems, label .. ": missing numeric quest ID or quest name")
            end
        end

        if (step.type == "grind" or step.type == "level") and type(step.targetLevel) ~= "number" then
            table.insert(problems, label .. ": " .. step.type .. " step needs targetLevel")
        end

        if step.type == "flightpath" and not (step.mapID and (step.node or step.name)) then
            table.insert(problems, label .. ": flightpath step needs mapID and node or name")
        end

        if step.type == "item" then
            if type(step.itemID) ~= "number" then
                table.insert(problems, label .. ": item step needs numeric itemID")
            end
            if step.count ~= nil and type(step.count) ~= "number" then
                table.insert(problems, label .. ": item step's count should be a number")
            end
        end

        if step.type == "spell" and type(step.spellID) ~= "number" then
            table.insert(problems, label .. ": spell step needs numeric spellID")
        end

        if step.type == "complete" and step.objective ~= nil and type(step.objective) ~= "number" then
            table.insert(problems, label .. ": objective should be a number")
        end

        if step.type == "xp" then
            local xp = step.xp
            if type(xp) ~= "table" or type(xp.level) ~= "number" then
                table.insert(problems, label .. ": xp step needs xp = { level = n, pct = n }")
            elseif xp.pct ~= nil and (type(xp.pct) ~= "number" or xp.pct < 0 or xp.pct > 100) then
                table.insert(problems, label .. ": xp.pct should be 0-100")
            end
        end

        if step.skipIfLevel ~= nil and type(step.skipIfLevel) ~= "number" then
            table.insert(problems, label .. ": skipIfLevel should be a number")
        end

        if step.requires then
            if type(step.requires) ~= "table" then
                table.insert(problems, label .. ": requires should be a list of step numbers")
            else
                for _, idx in ipairs(step.requires) do
                    if type(idx) ~= "number" or idx < 1 or idx > #route.steps then
                        table.insert(problems,
                            ("%s: requires references step %s, which isn't in this route"):format(
                                label, tostring(idx)))
                    elseif idx == i then
                        table.insert(problems, label .. ": requires references itself")
                    end
                end
            end
        end

        if step.x and (step.x < 0 or step.x > 100) then
            table.insert(problems, label .. ": x should be 0-100")
        end
        if step.y and (step.y < 0 or step.y > 100) then
            table.insert(problems, label .. ": y should be 0-100")
        end
        if (step.x or step.y) and not self:StepMap(step) then
            table.insert(problems,
                label .. ": has coords but no map - needs a zone name this client knows, or a uiMapID")
        end

        if step.path then
            for j, point in ipairs(step.path) do
                if not (point.x and point.y) then
                    table.insert(problems, ("%s: path point %d missing x/y"):format(label, j))
                elseif not self:StepMap(point) then
                    table.insert(problems,
                        ("%s: path point %d has coords but no map"):format(label, j))
                end
                if point.via and type(point.via) ~= "string" then
                    table.insert(problems, ("%s: path point %d via should be a string"):format(label, j))
                end
            end
        end
    end

    return problems, unknown, unresolved
end

--------------------------------------------------------------------------
-- Waypoints
--------------------------------------------------------------------------

-- The uiMapID for a step on THIS client. Route files carry a zone name
-- because the numbers differ per flavor; step.map stays supported for
-- hand-authored steps that pin a specific map.
function Data:StepMap(step)
    if not step then return nil end

    if step.zone then
        local id = Compat:MapID(step.zone)
        if id then return id end
    end
    return step.map
end

-- Real-world distance in yards from the player to a map/x/y point, using
-- world positions rather than the fractional map-position estimate Arrow
-- used before (that estimate scales with each zone's map size, not real
-- distance). Returns nil if the position APIs aren't available or the
-- player's world position can't be read - callers fall back to their own
-- coarser estimate in that case.
-- Phase 3: this runs from Arrow's 20 Hz update loop, so a client missing
-- C_Map entirely (not just this one method) can't be allowed to throw here
-- the way a bare `C_Map.GetWorldPosFromMapPos` would - same `C_Map and`
-- guard shape Data:SetWaypoint already uses below.
function Data:RealDistanceToStep(mapID, point)
    if not (mapID and point.x and point.y and C_Map
            and C_Map.GetWorldPosFromMapPos and CreateVector2D and UnitPosition) then
        return nil
    end

    local y1, x1 = Compat:Guard(UnitPosition, "player")
    if not (y1 and x1) then return nil end

    local vec = Compat:Guard(CreateVector2D, point.x / 100, point.y / 100)
    if not vec then return nil end

    local _, worldPos = Compat:Guard(C_Map.GetWorldPosFromMapPos, mapID, vec)
    if not (worldPos and worldPos.GetXY) then return nil end

    local wx, wy = worldPos:GetXY()
    local dx, dy = wx - x1, wy - y1
    return math.sqrt(dx * dx + dy * dy)
end

-- For steps with an authored `path` (ordered waypoints, possibly across
-- several maps, for a multi-hop or cross-zone travel step), returns the
-- next point still ahead instead of the step's own final destination -
-- advances through the list as each point is actually reached. Falls back
-- to the step's own map/x/y once the path is exhausted or absent.
-- Returns mapID, x, y, isFinal, via. `via` is the authored point's own
-- `via` field (e.g. "Boat to Menethil"), naming why the point exists, or
-- nil for the step's own final destination or an unannotated point.
local PATH_POINT_REACHED_YARDS = 20

function Data:EffectiveTarget(step)
    if not step.path or #step.path == 0 then
        return self:StepMap(step), step.x, step.y, true, nil
    end

    step._pathIndex = step._pathIndex or 1
    while step._pathIndex <= #step.path do
        local point = step.path[step._pathIndex]
        local mapID = self:StepMap(point)
        local currentMap = Compat:Guard(C_Map.GetBestMapForUnit, "player")

        if mapID and currentMap == mapID then
            local dist = self:RealDistanceToStep(mapID, point)
            if dist and dist <= PATH_POINT_REACHED_YARDS then
                step._pathIndex = step._pathIndex + 1
            else
                return mapID, point.x, point.y, false, point.via
            end
        else
            return mapID, point.x, point.y, false, point.via
        end
    end

    return self:StepMap(step), step.x, step.y, true, nil
end

-- Compat:Guard returns nil both when the wrapped call throws and when it
-- succeeds but simply returns nothing - both waypoint APIs below are void
-- on success, so a nil return can't tell "failed" from "worked". This
-- checks Compat's error count instead, which only moves on an actual
-- throw - except once the session error budget is exhausted, Guard stops
-- calling fn at all and the count can't move either way, so that case is
-- checked explicitly rather than read as a false success.
local function Attempt(fn, ...)
    if Compat:ErrorBudgetExhausted() then return false end
    local before = Compat:ErrorCount()
    local a, b, c = Compat:Guard(fn, ...)
    return Compat:ErrorCount() == before, a, b, c
end

-- P2.8 (reduced - see plan 08's audit correction; the EffectiveTarget half
-- of the original fix is deferred, it needs an Arrow->Data hook this batch
-- doesn't add): SetIndex/Reconcile call this on every step change even
-- when the step's own target didn't actually move (re-applying the same
-- index, or landing on a run of steps that share coordinates), stomping
-- the player's own map pin/TomTom waypoint every time. lastWaypoint
-- remembers the last target actually set, so a repeat call for the SAME
-- (mapID, x, y) is a no-op - UNLESS `force` is true, which the Map button
-- (UI.lua) passes so an explicit "take me there" click always works even
-- if the player closed their map or cleared the pin since it was set.
--
-- New: also removes the PREVIOUS TomTom waypoint before adding the next
-- one - without this, TomTom.AddWaypoint had nothing removing the old
-- pin, so they piled up in TomTom's own list for the rest of the session.
local lastWaypoint = nil   -- { mapID, x, y }
local lastTomTomUID = nil

function Data:SetWaypoint(step, force)
    local mapID = self:StepMap(step)
    if not mapID or not step.x or not step.y then return false end

    if not force and lastWaypoint and lastWaypoint.mapID == mapID
            and lastWaypoint.x == step.x and lastWaypoint.y == step.y then
        return true
    end

    -- Invalidate now, before actually trying anything: the TomTom branch
    -- below removes the PREVIOUS pin before it knows whether the new one
    -- will succeed. If it then fails (and the native fallback also fails
    -- or isn't available), leaving lastWaypoint pointing at the old
    -- target would falsely dedupe every later call for that same target
    -- as "already set" - even though nothing is actually on screen
    -- anymore - until the Map button's force=true call is used to recover.
    lastWaypoint = nil

    if _G.TomTom and _G.TomTom.AddWaypoint then
        -- Guard's own session error budget (not this function's target
        -- cache) can be exhausted here on a very unlucky session - in that
        -- narrow case Guard skips the removal without running it, and
        -- this still clears lastTomTomUID, leaving that one pin
        -- unreachable for later removal. Rare enough (20 unrelated errors
        -- addon-wide first) not to special-case further.
        if lastTomTomUID and _G.TomTom.RemoveWaypoint then
            Compat:Guard(_G.TomTom.RemoveWaypoint, _G.TomTom, lastTomTomUID)
            lastTomTomUID = nil
        end

        local ok, uid = Attempt(_G.TomTom.AddWaypoint, _G.TomTom, mapID, step.x / 100, step.y / 100, {
            title = step.note or step.name or "TuFFlevels",
            crazy = true,
            persistent = false,
        })
        if ok then
            lastTomTomUID = uid
            lastWaypoint = { mapID = mapID, x = step.x, y = step.y }
            return true
        end
        -- TomTom threw - fall through and try the native pin instead of
        -- just giving up, in case TomTom is present but broken.
    end

    -- No TomTom (or TomTom failed): drop a native map pin instead. Neither
    -- call is guaranteed to exist with the exact signature this addon
    -- expects on every client, so this goes through Compat:Guard like any
    -- other WoW API call this addon isn't certain of - an unguarded throw
    -- here previously aborted silently (WoW hides Lua errors by default)
    -- and skipped every call after Data:SetWaypoint in Core:SetIndex/
    -- Core:Reconcile, since this runs on every step change, not just the
    -- Map button click.
    if C_Map and C_Map.SetUserWaypoint and UiMapPoint then
        local pointOk, point = Attempt(UiMapPoint.CreateFromCoordinates, mapID, step.x / 100, step.y / 100)
        if pointOk and point then
            local setOk = Attempt(C_Map.SetUserWaypoint, point)
            if setOk then
                if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
                    Attempt(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
                end
                lastWaypoint = { mapID = mapID, x = step.x, y = step.y }
                return true
            end
        end
    end

    return false
end
