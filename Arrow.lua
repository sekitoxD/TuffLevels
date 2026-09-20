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
Arrow.colorblind = false
Arrow.textOnly = false
Arrow.deferToTomTom = false

local frame, tex, distText, titleText
local TWO_PI = math.pi * 2

-- Blue/orange reads correctly for every common form of color blindness,
-- unlike the default purple/red pairing.
local CB_ON_TARGET  = { 0.25, 0.55, 1.00 }
local CB_OFF_TARGET = { 1.00, 0.55, 0.10 }

local COMPASS = {
    "Ahead", "Ahead-Right", "Right", "Behind-Right",
    "Behind", "Behind-Left", "Left", "Ahead-Left",
}
local function CompassLabel(angle)
    local sector = math.floor((angle / TWO_PI) * 8 + 0.5) % 8
    return COMPASS[sector + 1]
end

--------------------------------------------------------------------------
-- Geometry
--------------------------------------------------------------------------

-- Returns angle (radians, 0 = straight ahead), distance in yards, whether
-- the target is on a different map, whether the distance is only the old
-- map-fraction estimate (real-yards APIs unavailable), and whether the
-- target is the step's own final destination (false while still routing
-- through an authored `path`).
local function Bearing(step)
    if not step then return nil end

    local targetMap, tx, ty, isFinal = ns.Data:EffectiveTarget(step)
    if not (tx and ty) then return nil end

    local mapID = Compat:Guard(C_Map.GetBestMapForUnit, "player")
    if not mapID then return nil end

    -- Only meaningful if the target is on the map we're standing in.
    if targetMap and targetMap ~= mapID then return nil, nil, true end

    local pos = Compat:Guard(C_Map.GetPlayerMapPosition, mapID, "player")
    if not pos or not pos.GetXY then return nil end
    local px, py = pos:GetXY()
    if not px then return nil end

    local dx = (tx / 100) - px
    local dy = (ty / 100) - py

    -- Map coordinates run y-down; world angles run y-up.
    local angle = Compat.Atan2(dx, -dy)

    local facing = Compat:Guard(GetPlayerFacing)
    if facing then
        angle = angle + facing
    end

    -- Real yards via world position; falls back to the old map-fraction
    -- estimate (caller shows it with a ~ prefix) if unavailable.
    local dist = ns.Data:RealDistanceToStep(mapID, { x = tx, y = ty })
    local approx = false
    if not dist then
        dist = math.sqrt(dx * dx + dy * dy) * 1000
        approx = true
    end

    return angle % TWO_PI, dist, false, approx, isFinal
end

--------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------

-- Adjustable via mouse wheel over the arrow; clamped so it can't be
-- scrolled into being invisible or absurdly large.
local SCALE_MIN, SCALE_MAX, SCALE_STEP = 0.5, 2.5, 0.1

function Arrow:Build()
    if frame then return end

    frame = CreateFrame("Frame", "TuFFlevelsArrow", UIParent)
    frame:SetSize(84, 104)
    frame:SetPoint("TOP", UIParent, "TOP", 0, -80)
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

    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(self, delta)
        local scale = self:GetScale() + delta * SCALE_STEP
        scale = math.max(SCALE_MIN, math.min(SCALE_MAX, scale))
        self:SetScale(scale)
        local db = Compat:InitSavedVar("TuFFlevelsDB")
        db.arrowScale = scale
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
    if db.arrowScale then
        frame:SetScale(db.arrowScale)
    end
    Arrow.colorblind = db.arrowColorblind or false
    Arrow.textOnly = db.arrowTextOnly or false
    Arrow.deferToTomTom = db.arrowDeferToTomTom or false

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

    -- TomTom already draws its own crazy-arrow toward the same waypoint
    -- (Data:SetWaypoint hands it off there when installed) - showing both
    -- is redundant, so let TomTom own the arrow when asked to.
    if self.deferToTomTom and _G.TomTom then frame:Hide() return end

    local step = ns.Core and ns.Core:CurrentStep()
    if not step then frame:Hide() return end

    -- note/manual/trainer/death/hearth steps (and any accept/turnin step an
    -- author didn't give coords) legitimately have no x/y. Rather than just
    -- vanishing - indistinguishable from "disabled" - point at the next
    -- upcoming step in the route that does have coordinates.
    local usingNext = false
    if not (step.x and step.y) and ns.Core and ns.Core.active then
        local steps = ns.Core.active.steps
        for i = ns.Core.index + 1, #steps do
            if steps[i].x and steps[i].y then
                step = steps[i]
                usingNext = true
                break
            end
        end
    end

    local angle, dist, wrongMap, approx, isFinal = Bearing(step)

    if wrongMap then
        frame:Show()
        if self.textOnly then
            tex:Hide() ; frame.glow:Hide()
        else
            tex:Show() ; frame.glow:Show()
            tex:SetRotation(0)
            tex:SetVertexColor(unpack(Theme.color.faint))
        end
        distText:SetText("--")
        titleText:SetText(step.zone and ("Travel to " .. step.zone) or "Different zone")
        return
    end

    if not angle then frame:Hide() return end

    frame:Show()

    local onTarget = math.min(angle, TWO_PI - angle) < 0.3
    local onColor, offColor = Theme.color.lilac, Theme.color.ember
    local onGlow, offGlow = Theme.color.violet, Theme.color.blood
    if self.colorblind then
        onColor, offColor = CB_ON_TARGET, CB_OFF_TARGET
        onGlow, offGlow = CB_ON_TARGET, CB_OFF_TARGET
    end

    if self.textOnly then
        tex:Hide() ; frame.glow:Hide()
        distText:SetTextColor(unpack(onTarget and onColor or offColor))
        distText:SetText(("%s%s  %d"):format(approx and "~" or "",
            CompassLabel(angle), dist))
    else
        tex:Show() ; frame.glow:Show()
        tex:SetRotation(-angle)
        -- Arrow goes on-target color when pointed the right way, off
        -- otherwise (purple/red by default, blue/orange in colorblind mode).
        if onTarget then
            tex:SetVertexColor(unpack(onColor))
            frame.glow:SetVertexColor(onGlow[1], onGlow[2], onGlow[3], 0.55)
        else
            tex:SetVertexColor(unpack(offColor))
            frame.glow:SetVertexColor(offGlow[1], offGlow[2], offGlow[3], 0.35)
        end
        distText:SetTextColor(unpack(Theme.color.lilac))
        distText:SetText(("%s%d"):format(approx and "~" or "", dist))
    end

    local label = step.npc or step.name or ""
    if #label > 28 then label = label:sub(1, 26) .. "..." end
    local prefix = usingNext and "Next: " or (not isFinal and "Via: " or "")
    titleText:SetText(prefix .. label)
end

function Arrow:Toggle()
    self.enabled = not self.enabled
    if frame then
        if self.enabled then frame:Show() else frame:Hide() end
    end
    ns.Print("Arrow " .. (self.enabled and "on" or "off"))
end

function Arrow:ToggleColorblind()
    self.colorblind = not self.colorblind
    Compat:InitSavedVar("TuFFlevelsDB").arrowColorblind = self.colorblind
    ns.Print("Arrow colorblind colors " .. (self.colorblind and "on" or "off"))
end

function Arrow:ToggleTextOnly()
    self.textOnly = not self.textOnly
    Compat:InitSavedVar("TuFFlevelsDB").arrowTextOnly = self.textOnly
    ns.Print("Arrow text-only mode " .. (self.textOnly and "on" or "off"))
end

function Arrow:ToggleDeferToTomTom()
    self.deferToTomTom = not self.deferToTomTom
    Compat:InitSavedVar("TuFFlevelsDB").arrowDeferToTomTom = self.deferToTomTom
    ns.Print("Defer to TomTom's arrow " .. (self.deferToTomTom and "on" or "off"))
end

-- Undoes drag-reposition and mouse-wheel-resize, since those have no other
-- undo path once you've scrolled the arrow down to a size you didn't want.
function Arrow:ResetPosition()
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.arrowPos = nil
    db.arrowScale = nil
    if frame then
        frame:SetScale(1.0)
        frame:ClearAllPoints()
        frame:SetPoint("TOP", UIParent, "TOP", 0, -80)
    end
    ns.Print("Arrow reset to default position and size.")
end
