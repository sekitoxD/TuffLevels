-- spec/helpers/fake_data.lua
--
-- A controllable stand-in for ns.Data, for specs exercising Core.lua's
-- step-detection logic without touching QuestieDB or any live WoW state.
-- Set the fields directly from a test (e.g. data.level = 12) rather than
-- going through setters - it's test scaffolding, not a real module.

local FakeData = {}
FakeData.__index = FakeData

function FakeData.new()
    local self = setmetatable({}, FakeData)
    self.level = 1
    self.race = "Orc"
    self.faction = "Horde"
    self.inLog = {}          -- [questID] = true
    self.complete = {}       -- [questID] = true
    self.readyToTurnIn = {}  -- [questID] = true
    self.objectivesDone = {} -- [questID] = { [n] = true }
    self.flightPathsKnown = {} -- [mapID.."|"..(node or name)] = true
    return self
end

function FakeData:PlayerLevel() return self.level end
function FakeData:PlayerRace() return self.race end
function FakeData:PlayerFaction() return self.faction end

function FakeData:IsQuestInLog(id) return self.inLog[id] == true end
function FakeData:IsQuestComplete(id) return self.complete[id] == true end
function FakeData:IsQuestReadyToTurnIn(id) return self.readyToTurnIn[id] == true end

function FakeData:IsQuestObjectiveDone(id, n)
    local q = self.objectivesDone[id]
    return q ~= nil and q[n] == true
end

function FakeData:IsFlightPathKnown(step)
    local key = tostring(step.mapID) .. "|" .. tostring(step.node or step.name)
    return self.flightPathsKnown[key] == true
end

function FakeData:StepMap(step)
    if not step then return nil end
    return step.map
end

function FakeData:SetWaypoint(step) return true end
function FakeData:RealDistanceToStep(mapID, point) return nil end

function FakeData:EffectiveTarget(step)
    return self:StepMap(step), step and step.x, step and step.y, true
end

return FakeData
