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

    return provider
end

function Data:HasProvider()
    return self:DetectProvider() ~= nil
end

function Data:ProviderName()
    return provider or "none"
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

        if step.x and (step.x < 0 or step.x > 100) then
            table.insert(problems, label .. ": x should be 0-100")
        end
        if step.y and (step.y < 0 or step.y > 100) then
            table.insert(problems, label .. ": y should be 0-100")
        end
        if (step.x or step.y) and not step.map then
            table.insert(problems, label .. ": has coords but no map (uiMapID)")
        end
    end

    return problems, unknown, unresolved
end

--------------------------------------------------------------------------
-- Waypoints
--------------------------------------------------------------------------

function Data:SetWaypoint(step)
    if not step.map or not step.x or not step.y then return false end

    if _G.TomTom and _G.TomTom.AddWaypoint then
        _G.TomTom:AddWaypoint(step.map, step.x / 100, step.y / 100, {
            title = step.note or step.name or "TuFFlevels",
            crazy = true,
            persistent = false,
        })
        return true
    end

    -- No TomTom: drop a native map pin instead.
    if C_Map and C_Map.SetUserWaypoint and UiMapPoint then
        local point = UiMapPoint.CreateFromCoordinates(step.map, step.x / 100, step.y / 100)
        C_Map.SetUserWaypoint(point)
        if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        end
        return true
    end

    return false
end
