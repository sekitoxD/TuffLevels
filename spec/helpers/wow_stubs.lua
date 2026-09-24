-- spec/helpers/wow_stubs.lua
--
-- Minimal WoW global stubs so the real addon files can be `loadfile`'d
-- outside the client. Only covers what's touched at FILE-LOAD time (top-
-- level code that runs the moment a file is chunk-called, not inside a
-- function a given spec never calls) - specs needing more should extend
-- the returned table's fields directly rather than growing this file
-- into a full client emulator.
--
-- Call Install() once per spec file, before loadfile-ing any addon
-- source. It's idempotent (safe to call from more than one spec).

local M = {}

local function MakeFrame()
    local frame = { events = {}, scripts = {}, shown = false }

    function frame:RegisterEvent(event) self.events[event] = true end
    function frame:UnregisterEvent(event) self.events[event] = nil end
    function frame:RegisterUnitEvent(event, unit) self.events[event] = unit or true end
    function frame:SetScript(handle, fn) self.scripts[handle] = fn end
    function frame:GetScript(handle) return self.scripts[handle] end
    function frame:Show() self.shown = true end
    function frame:Hide() self.shown = false end
    function frame:IsShown() return self.shown end
    function frame:SetSize() end
    function frame:SetPoint() end
    function frame:ClearAllPoints() end
    function frame:EnableMouse() end
    function frame:SetMovable() end
    function frame:RegisterForDrag() end
    function frame:SetFrameStrata() end
    function frame:CreateTexture() return MakeFrame() end
    function frame:CreateFontString() return MakeFrame() end
    function frame:SetText() end
    function frame:SetTextColor() end

    return frame
end

M.MakeFrame = MakeFrame

function M.Install()
    _G.CreateFrame = function(...) return MakeFrame() end
    _G.SlashCmdList = _G.SlashCmdList or {}

    _G.GetBuildInfo = _G.GetBuildInfo or function()
        return "1.0.0", "00000", "Jan 1 2020", "11507"
    end
    _G.WOW_PROJECT_CLASSIC = _G.WOW_PROJECT_CLASSIC or 1
    _G.WOW_PROJECT_MAINLINE = _G.WOW_PROJECT_MAINLINE or 2
    _G.WOW_PROJECT_ID = _G.WOW_PROJECT_ID or _G.WOW_PROJECT_CLASSIC

    _G.C_Timer = _G.C_Timer or {
        After = function(_, fn) end,
        NewTicker = function() return { Cancel = function() end } end,
    }

    _G.UnitClass = _G.UnitClass or function() return "Rogue", "ROGUE" end
    _G.UnitRace = _G.UnitRace or function() return "Orc", "Orc" end
    _G.UnitLevel = _G.UnitLevel or function() return 10 end
    _G.UnitFactionGroup = _G.UnitFactionGroup or function() return "Horde" end
    _G.UnitXP = _G.UnitXP or function() return 0 end
    _G.UnitXPMax = _G.UnitXPMax or function() return 0 end
    _G.UnitName = _G.UnitName or function() return nil end
    _G.UnitPosition = _G.UnitPosition or function() return nil end
    _G.GetPlayerFacing = _G.GetPlayerFacing or function() return 0 end
    _G.GetSpecialization = _G.GetSpecialization or nil
    _G.IsXPUserDisabled = _G.IsXPUserDisabled or function() return false end

    _G.DEFAULT_CHAT_FRAME = _G.DEFAULT_CHAT_FRAME or { AddMessage = function() end }
    _G.GetCVar = _G.GetCVar or function() return nil end
    _G.SetCVar = _G.SetCVar or function() end
    _G.InCombatLockdown = _G.InCombatLockdown or function() return false end
    _G.IsShiftKeyDown = _G.IsShiftKeyDown or function() return false end
    _G.GetZoneText = _G.GetZoneText or function() return "" end
    _G.time = _G.time or os.time
    -- os.clock() is monotonic and process-local, the same shape as WoW's
    -- own GetTime() (seconds since the client started, not wall-clock) -
    -- a spec that needs to control it directly (Compat's error-budget
    -- decay) overrides _G.GetTime itself rather than relying on this.
    _G.GetTime = _G.GetTime or os.clock
end

--- Loads one addon source file the way WoW's client does: the file's
--- `...` vararg is (addonName, ns), with `ns` shared across every file
--- loaded this way so later files see what earlier ones attached to it.
function M.LoadFile(path, ns, addonName)
    local chunk = assert(loadfile(path))
    return chunk(addonName or "TuFFlevels", ns)
end

return M
