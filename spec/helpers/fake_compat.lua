-- spec/helpers/fake_compat.lua
--
-- A controllable stand-in for ns.Compat, covering every Compat: call
-- Core.lua actually makes (checked against the real file, not guessed).
-- Real event registration/pcall-guarding behavior isn't the point of the
-- Core specs - Compat's own behavior is covered separately by
-- spec/compat_spec.lua against the real Compat.lua.

local FakeCompat = {}
FakeCompat.__index = FakeCompat

function FakeCompat.new()
    local self = setmetatable({}, FakeCompat)
    self.db = {}
    self.isForever = false
    self.flavor = "classic"
    self.tocVersion = 11507
    self.isMainline = false
    self.restricted = false
    self.lastError = nil
    self.nameCache = {}
    return self
end

function FakeCompat:InitSavedVar(name)
    self.db[name] = self.db[name] or {}
    return self.db[name]
end

function FakeCompat:SavedVarsAreBroken() return false end

function FakeCompat:RegisterEvents(frame, events)
    local registered = {}
    for _, e in ipairs(events) do
        if frame and frame.RegisterEvent then frame:RegisterEvent(e) end
        table.insert(registered, e)
    end
    return registered, {}
end

function FakeCompat:Guard(fn, ...)
    if not fn then return nil end
    local ok, a, b, c = pcall(fn, ...)
    if ok then return a, b, c end
    return nil
end

function FakeCompat:Wrap(name, fn, onTrip)
    return function(...)
        local ok, err = pcall(fn, ...)
        if not ok then
            self.lastError = err
            if onTrip then onTrip(err) end
        end
    end
end

function FakeCompat:GetQuestIDByName(name) return self.nameCache[name] end
function FakeCompat:GetQuestIDByNameLive(name) return self.nameCache[name] end
function FakeCompat:SaveNameCache() end
function FakeCompat:LoadNameCache() end
function FakeCompat:InvalidateLogIndex() end
function FakeCompat:NumQuestLogEntries() return 0 end
function FakeCompat:GetQuestLogInfo(index) return nil end
function FakeCompat:ErrorCount() return 0 end
function FakeCompat:ModuleErrorCounts() return {} end

return FakeCompat
