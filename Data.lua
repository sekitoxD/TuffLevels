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
function Data:IsFlightPathKnown(step)
    if not (Compat.has.taxiMap and step.mapID and Enum.FlightPathState) then return false end

    local nodes = Compat:Guard(C_TaxiMap.GetAllTaxiNodes, step.mapID)
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

        if step.type == "grind" and type(step.targetLevel) ~= "number" then
            table.insert(problems, label .. ": grind step needs targetLevel")
        end

        if step.type == "flightpath" and not (step.mapID and (step.node or step.name)) then
            table.insert(problems, label .. ": flightpath step needs mapID and node or name")
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
function Data:RealDistanceToStep(mapID, point)
    if not (mapID and point.x and point.y
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
-- Returns mapID, x, y, isFinal.
local PATH_POINT_REACHED_YARDS = 20

function Data:EffectiveTarget(step)
    if not step.path or #step.path == 0 then
        return self:StepMap(step), step.x, step.y, true
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
                return mapID, point.x, point.y, false
            end
        else
            return mapID, point.x, point.y, false
        end
    end

    return self:StepMap(step), step.x, step.y, true
end

function Data:SetWaypoint(step)
    local mapID = self:StepMap(step)
    if not mapID or not step.x or not step.y then return false end

    if _G.TomTom and _G.TomTom.AddWaypoint then
        _G.TomTom:AddWaypoint(mapID, step.x / 100, step.y / 100, {
            title = step.note or step.name or "TuFFlevels",
            crazy = true,
            persistent = false,
        })
        return true
    end

    -- No TomTom: drop a native map pin instead.
    if C_Map and C_Map.SetUserWaypoint and UiMapPoint then
        local point = UiMapPoint.CreateFromCoordinates(mapID, step.x / 100, step.y / 100)
        C_Map.SetUserWaypoint(point)
        if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        end
        return true
    end

    return false
end
