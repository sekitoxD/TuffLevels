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
-- map-fraction estimate (real-yards APIs unavailable), whether the target
-- is the step's own final destination (false while still routing through
-- an authored `path`), and that path point's `via` label if it has one.
--
-- `mapID` (the player's current map) is computed once per tick by the
-- caller and threaded through here instead of this function re-querying
-- `C_Map.GetBestMapForUnit` itself.
local function Bearing(step, mapID)
    if not step then return nil end

    local targetMap, tx, ty, isFinal, via = ns.Data:EffectiveTarget(step)
    if not (tx and ty) then return nil end

    if not mapID then return nil end

    -- Only meaningful if the target is on the map we're standing in.
    if targetMap and targetMap ~= mapID then return nil, nil, true end

    local pos = Compat:Guard(C_Map.GetPlayerMapPosition, mapID, "player")
    if not pos or not pos.GetXY then return nil end
    local px, py = pos:GetXY()
    if not px or Compat:IsSecretValue(px) or Compat:IsSecretValue(py) then return nil end

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

    return angle % TWO_PI, dist, false, approx, isFinal, via
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

    -- P2.2: onTrip now runs on every re-trip after a decay (a genuinely
    -- broken Update() will fail its way back to tripped every ~5 minutes
    -- for the rest of the session, not just once) - frame:Hide() has to
    -- happen every single time or the arrow would stay stuck showing
    -- stale state once Compat:Wrap's own repeat-trip message goes silent,
    -- but the player-facing print is still only useful once.
    local guardedUpdate = Compat:Wrap("Arrow", function() Arrow:Update() end, function(firstTrip)
        frame:Hide()
        if firstTrip then
            ns.Print("|cffff5555Arrow disabled after repeated errors.|r /tuff errors for details.")
        end
    end)

    -- Driven by a standalone ticker instead of this frame's own OnUpdate:
    -- WoW never calls OnUpdate on a hidden frame, and Update() hides this
    -- frame on several ordinary paths (arrow disabled, deferring to
    -- TomTom, no current step, no bearing angle) - any of those would
    -- otherwise stop the loop until the arrow is toggled off and on
    -- again. Created once
    -- here since Build() early-returns above if already built, so this
    -- never stacks across repeated Build()/Toggle() calls. Same 0.05s
    -- (20 Hz) rate the old OnUpdate throttle used.
    frame.ticker = C_Timer.NewTicker(0.05, guardedUpdate)
end

--------------------------------------------------------------------------
-- Update
--------------------------------------------------------------------------

-- Skips SetText when the string is unchanged - this frame's text updates
-- run at 20 Hz but the underlying values (compass label, rounded distance,
-- title) usually don't change between ticks.
local function SetTextCached(fs, text)
    if fs._lastText ~= text then
        fs:SetText(text)
        fs._lastText = text
    end
end

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

    -- Computed once per tick and threaded through Bearing instead of it
    -- re-querying the player's current map itself.
    local mapID = Compat:Guard(C_Map.GetBestMapForUnit, "player")

    local angle, dist, wrongMap, approx, isFinal, via = Bearing(step, mapID)

    -- An author-flagged `approx` step (a rough or zone-centre guess, not a
    -- real spot) gets the same "~" distance as the map-fraction fallback
    -- and names its area instead of implying a precise target. Only the
    -- step's own final destination counts: `path` waypoints are real.
    local guess = step.approx and isFinal

    if wrongMap then
        frame:Show()
        if self.textOnly then
            tex:Hide() ; frame.glow:Hide()
        else
            tex:Show() ; frame.glow:Show()
            tex:SetRotation(0)
            tex:SetVertexColor(unpack(Theme.color.faint))
        end
        SetTextCached(distText, "--")
        SetTextCached(titleText, step.zone and ("Travel to " .. step.zone) or "Different zone")
        return
    end

    -- No bearing (no step from here on has coordinates, the map is unknown,
    -- or the player's position can't be read right now). Show a dim
    -- placeholder rather than hiding, so this reads as "nothing to point
    -- at" instead of looking identical to a broken or disabled arrow.
    if not angle then
        -- Instances never expose the player's map position, so there is
        -- nothing to say there; stay hidden like the markers do.
        if Compat:IsInInstance() then frame:Hide() return end
        frame:Show()
        if self.textOnly then
            tex:Hide() ; frame.glow:Hide()
        else
            tex:Show() ; frame.glow:Hide()
            tex:SetRotation(0)
            tex:SetVertexColor(unpack(Theme.color.faint))
        end
        distText:SetTextColor(unpack(Theme.color.dim))
        SetTextCached(distText, "--")
        SetTextCached(titleText, "No target")
        return
    end

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
        SetTextCached(distText, ("%s%s  %d"):format((approx or guess) and "~" or "",
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
        SetTextCached(distText, ("%s%d"):format((approx or guess) and "~" or "", dist))
    end

    local label = (not isFinal and via) or step.npc or step.name or ""
    if #label > 28 then label = label:sub(1, 26) .. "..." end
    local prefix = usingNext and "Next: " or (not isFinal and "Via: " or "")
    -- A named NPC is what the player needs once they arrive, so it stays as
    -- the title; only nameless steps (mob kills, objectives) swap to the area.
    local area = step.location ~= "" and step.location or step.zone
    if guess and not step.npc and area then
        label = area
        if #label > 28 then label = label:sub(1, 26) .. "..." end
        prefix = usingNext and "Next, near: " or "Near: "
    end
    SetTextCached(titleText, prefix .. label)
end

-- /tuff debugarrow: prints why the arrow is (or isn't) showing, so a hidden
-- or "No target" arrow can be diagnosed without reading the code.
function Arrow:DebugDump()
    local function P(...) ns.Print(("|cffaaaaaa[arrow]|r " .. select(1, ...)):format(select(2, ...))) end
    P("built=%s shown=%s enabled=%s textOnly=%s deferToTomTom=%s tomtom=%s",
        tostring(frame ~= nil), tostring(frame and frame:IsShown()), tostring(self.enabled),
        tostring(self.textOnly), tostring(self.deferToTomTom), tostring(_G.TomTom ~= nil))
    local used, cap = Compat:GuardBudgetInfo()
    P("guard budget %d/%d, lifetime Guard errors %d, last: %s",
        used, cap, Compat:ErrorCount(), tostring(Compat.lastError))

    local step = ns.Core and ns.Core:CurrentStep()
    if not step then P("no current step") return end
    P("step %s: type=%s zone=%s x=%s y=%s map=%s path=%s",
        tostring(ns.Core.index), tostring(step.type), tostring(step.zone),
        tostring(step.x), tostring(step.y), tostring(step.map),
        tostring(step.path and #step.path or 0))

    local target, usingNext = step, false
    if not (step.x and step.y) then
        for i = ns.Core.index + 1, #ns.Core.active.steps do
            local s = ns.Core.active.steps[i]
            if s.x and s.y then target, usingNext = s, true
                P("falling back to step %d (%s, %s)", i, tostring(s.zone), tostring(s.name or s.questName))
                break
            end
        end
        if not usingNext then P("no later step has coordinates") return end
    end

    local mapID = Compat:Guard(C_Map.GetBestMapForUnit, "player")
    local tMap, tx, ty, isFinal = ns.Data:EffectiveTarget(target)
    P("player map=%s target map=%s (%s) x=%s y=%s final=%s",
        tostring(mapID), tostring(tMap), tostring(target.zone), tostring(tx), tostring(ty), tostring(isFinal))
    if target.zone and not Compat:MapID(target.zone) then
        P("zone name '%s' does not resolve to a map ID", target.zone)
    end
    local pos = mapID and Compat:Guard(C_Map.GetPlayerMapPosition, mapID, "player")
    local px = pos and pos.GetXY and pos:GetXY()
    P("player map position: %s", px and not Compat:IsSecretValue(px) and "ok" or "nil/secret (instance/restricted?)")
    P("in instance: %s", tostring(Compat:IsInInstance()))
    local sameMap = tMap == nil or tMap == mapID
    local d = sameMap and mapID and tx and ns.Data:RealDistanceToStep(mapID, { x = tx, y = ty })
    if not sameMap then P("target is on a different map - arrow shows Travel to <zone>") return end
    P("real distance: %s", d and ("%d yd"):format(d) or "nil (falls back to ~estimate)")
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
