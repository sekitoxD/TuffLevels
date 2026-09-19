-- TuFFlevels / Arrow.lua
--
-- The "just go" half. A big arrow that points at your current step and a
-- distance readout, so you never open the map.
--
-- Independent of TomTom. Uses the player's facing and map position, which
-- every target client exposes.

local ADDON, ns = ...
local Compat = ns.Compat
local Theme = ns.Theme

local Arrow = {}
ns.Arrow = Arrow

Arrow.enabled = true

local frame, tex, distText, titleText
local TWO_PI = math.pi * 2

--------------------------------------------------------------------------
-- Geometry
--------------------------------------------------------------------------

-- Returns angle (radians, 0 = straight ahead) and distance in yards-ish.
local function Bearing(step)
    if not step or not step.x or not step.y then return nil end

    local mapID = Compat:Guard(C_Map.GetBestMapForUnit, "player")
    if not mapID then return nil end

    -- Only meaningful if the step is on the map we're standing in.
    local stepMap = ns.Data and ns.Data:StepMap(step) or step.map
    if stepMap and stepMap ~= mapID then return nil, nil, true end

    local pos = Compat:Guard(C_Map.GetPlayerMapPosition, mapID, "player")
    if not pos or not pos.GetXY then return nil end
    local px, py = pos:GetXY()
    if not px then return nil end

    local dx = (step.x / 100) - px
    local dy = (step.y / 100) - py

    -- Map coordinates run y-down; world angles run y-up.
    local angle = Compat.Atan2(dx, -dy)

    local facing = Compat:Guard(GetPlayerFacing)
    if facing then
        angle = angle + facing
    end

    -- Rough distance. Map units aren't yards, but the scale is consistent
    -- enough within a zone to be useful as a "closer/further" readout.
    local dist = math.sqrt(dx * dx + dy * dy) * 1000

    return angle % TWO_PI, dist, false
end

--------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------

function Arrow:Build()
    if frame then return end

    frame = CreateFrame("Frame", "TuFFlevelsArrow", UIParent)
    frame:SetSize(84, 104)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local db = Compat:InitSavedVar("TuFFlevelsDB")
        local p, _, rp, x, y = self:GetPoint()
        db.arrowPos = { p, rp, x, y }
    end)

    tex = frame:CreateTexture(nil, "OVERLAY")
    tex:SetSize(64, 64)
    tex:SetPoint("TOP", 0, 0)
    tex:SetTexture("Interface\\Minimap\\ROTATING-MINIMAPGUIDEARROW")
    tex:SetVertexColor(unpack(Theme.color.orchid))

    -- glow behind the arrow, red so it reads against the purple
    local glow = frame:CreateTexture(nil, "ARTWORK")
    glow:SetSize(78, 78)
    glow:SetPoint("CENTER", tex, "CENTER")
    glow:SetTexture("Interface\\Cooldown\\star4")
    glow:SetBlendMode("ADD")
    glow:SetVertexColor(Theme.color.blood[1], Theme.color.blood[2], Theme.color.blood[3], 0.5)
    frame.glow = glow

    distText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    distText:SetPoint("TOP", tex, "BOTTOM", 0, -2)
    distText:SetTextColor(unpack(Theme.color.lilac))

    titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleText:SetPoint("TOP", distText, "BOTTOM", 0, -2)
    titleText:SetWidth(140)
    titleText:SetTextColor(unpack(Theme.color.dim))

    local db = Compat:InitSavedVar("TuFFlevelsDB")
    if db.arrowPos then
        local p, rp, x, y = unpack(db.arrowPos)
        frame:ClearAllPoints()
        frame:SetPoint(p, UIParent, rp, x, y)
    end

    local guardedUpdate = Compat:Wrap("Arrow", function() Arrow:Update() end, function()
        frame:Hide()
        ns.Print("|cffff5555Arrow disabled after repeated errors.|r /tuff errors for details.")
    end)

    frame:SetScript("OnUpdate", function(self, elapsed)
        self._t = (self._t or 0) + elapsed
        if self._t < 0.05 then return end
        self._t = 0
        guardedUpdate()
    end)
end

--------------------------------------------------------------------------
-- Update
--------------------------------------------------------------------------

function Arrow:Update()
    if not frame then return end

    if not self.enabled then frame:Hide() return end

    local step = ns.Core and ns.Core:CurrentStep()
    if not step then frame:Hide() return end

    local angle, dist, wrongMap = Bearing(step)

    if wrongMap then
        frame:Show()
        tex:SetRotation(0)
        tex:SetVertexColor(unpack(Theme.color.faint))
        distText:SetText("--")
        titleText:SetText(step.zone and ("Travel to " .. step.zone) or "Different zone")
        return
    end

    if not angle then frame:Hide() return end

    frame:Show()
    tex:SetRotation(-angle)

    -- Arrow goes purple when you're pointed the right way, red when not.
    local off = math.min(angle, TWO_PI - angle)
    if off < 0.3 then
        tex:SetVertexColor(unpack(Theme.color.lilac))
        frame.glow:SetVertexColor(Theme.color.violet[1], Theme.color.violet[2],
                                  Theme.color.violet[3], 0.55)
    else
        tex:SetVertexColor(unpack(Theme.color.ember))
        frame.glow:SetVertexColor(Theme.color.blood[1], Theme.color.blood[2],
                                  Theme.color.blood[3], 0.35)
    end

    distText:SetText(("%d"):format(dist))

    local label = step.npc or step.name or ""
    if #label > 28 then label = label:sub(1, 26) .. "..." end
    titleText:SetText(label)
end

function Arrow:Toggle()
    self.enabled = not self.enabled
    if frame then
        if self.enabled then frame:Show() else frame:Hide() end
    end
    ns.Print("Arrow " .. (self.enabled and "on" or "off"))
end
