-- TuFFlevels / Marker.lua
--
-- Puts an icon over the head of the NPC your current step needs.
--
-- Works by attaching a texture to that unit's nameplate. Nameplates only
-- exist for units the client is currently showing, so this lights up when
-- the NPC is on screen and in range - the waypoint handles getting you there.

local ADDON, ns = ...
local Compat = ns.Compat

local Marker = {}
ns.Marker = Marker

Marker.enabled = true
Marker.markMobs = true

local ICON = {
    accept   = "Interface\\GossipFrame\\AvailableQuestIcon",
    turnin   = "Interface\\GossipFrame\\ActiveQuestIcon",
    complete = "Interface\\GossipFrame\\ActiveQuestIcon",
    mob      = "Interface\\Minimap\\ObjectIcons",
    default  = "Interface\\GossipFrame\\AvailableQuestIcon",
}

-- Quest givers get the familiar yellow marks. Objective mobs get a purple
-- diamond so the two never read as the same thing.
local TINT = {
    mob = { 0.66, 0.42, 0.95 },
}

local active = {}     -- [nameplateFrame] = markerTexture

--------------------------------------------------------------------------
-- Objective mobs
--------------------------------------------------------------------------

-- Your quest log already names what you need to kill: "Mottled Boar slain:
-- 3/10". Parse the name out of that and we can mark those nameplates too,
-- with no quest database involved at all.
--
-- Blizzard doesn't expose the raw target name, only this locale-formatted
-- text, so the trailing verb has to be stripped per client locale rather
-- than assuming English everywhere (a non-English client would otherwise
-- leave the verb attached, never match a nameplate name, and the marker
-- would silently never appear). CJK locales aren't in this table: their
-- objective text isn't "Name <verb>: X/Y" shaped, so verb-stripping
-- wouldn't apply cleanly; the counter-stripped text is used as-is for them.
local LOCALE_SUFFIXES = {
    enUS = { "slain", "killed", "destroyed" },
    enGB = { "slain", "killed", "destroyed" },
    deDE = { "getötet", "erlegt", "erschlagen", "zerstört" },
    frFR = { "tués?", "tuées?", "détruite?s?" },
    esES = { "muertos?", "muertas?", "destruidos?", "destruidas?" },
    esMX = { "muertos?", "muertas?", "destruidos?", "destruidas?" },
    ptBR = { "mortos?", "mortas?", "destruídos?", "destruídas?" },
    ruRU = { "убит", "убита", "убито", "убиты", "уничтожен", "уничтожена", "уничтожено", "уничтожены" },
    itIT = { "ucciso", "uccisa", "uccisi", "uccise", "distrutto", "distrutta", "distrutti", "distrutte" },
}

local function SuffixesForLocale()
    local locale = GetLocale and GetLocale() or "enUS"
    return LOCALE_SUFFIXES[locale] or LOCALE_SUFFIXES.enUS
end

local function ObjectiveNames(questID)
    local names = {}
    if not (C_QuestLog and C_QuestLog.GetQuestObjectives) then return names end

    local objectives = Compat:Guard(C_QuestLog.GetQuestObjectives, questID)
    if type(objectives) ~= "table" then return names end

    local suffixes = SuffixesForLocale()

    for _, obj in ipairs(objectives) do
        local text = obj.text
        if type(text) == "string" and obj.finished ~= true then
            -- strip the trailing counter and any verb the locale appends
            local name = text:match("^(.-):%s*%d+%s*/%s*%d+%s*$") or text
            for _, suffix in ipairs(suffixes) do
                name = name:gsub("%s+" .. suffix .. "$", "")
            end
            name = name:match("^%s*(.-)%s*$")
            if name and #name > 2 then
                names[name:lower()] = true
            end
        end
    end
    return names
end

-- Every mob the current step wants dead, across quests in your log.
function Marker:WantedMobs()
    if not self.enabled or not self.markMobs then return nil end

    local step = ns.Core and ns.Core:CurrentStep()
    if not step then return nil end

    -- A "complete" step points at one quest. Otherwise mark objectives for
    -- everything in the log, which is what you actually want while grinding.
    if step.quest and step.type == "complete" then
        return ObjectiveNames(step.quest)
    end

    local all = {}
    for i = 1, Compat:NumQuestLogEntries() do
        local info = Compat:GetQuestLogInfo(i)
        if info and not info.isHeader and info.questID then
            for name in pairs(ObjectiveNames(info.questID)) do
                all[name] = true
            end
        end
    end
    return all
end

--------------------------------------------------------------------------
-- Which NPC does the current step want?
--------------------------------------------------------------------------

function Marker:WantedNPC()
    if not self.enabled then return nil end

    local step = ns.Core and ns.Core:CurrentStep()
    if not step or not step.npc then return nil end

    return step.npc, step.type
end

-- The nameplate icon only helps once the NPC is actually on screen. A
-- chat line covers players who've left friendly nameplates off, or just
-- want the name up front to scan for or /targetexact themselves - the
-- addon can't create a secure targeting macro/keybind (CLAUDE.md: no
-- secure snippets), so this is the unsecure equivalent RestedXP's
-- targeting macro would otherwise cover. Only announces once per new
-- wanted NPC, not on every nameplate-driven rescan.
local lastAnnounced = nil

function Marker:AnnounceWantedNPC()
    local wanted = self:WantedNPC()
    if wanted then
        if wanted ~= lastAnnounced then
            lastAnnounced = wanted
            if ns.Print then ns.Print("Look for: |cffffd100" .. wanted .. "|r") end
        end
    else
        lastAnnounced = nil
    end
end

--------------------------------------------------------------------------
-- Marker creation
--------------------------------------------------------------------------

local function CreateMarker(plate)
    local holder = CreateFrame("Frame", nil, plate)
    holder:SetSize(32, 32)
    holder:SetFrameStrata("HIGH")

    -- Anchor above the plate. UnitFrame is the standard child on modern
    -- clients; fall back to the plate itself if the layout differs.
    local anchor = plate.UnitFrame or plate
    holder:SetPoint("BOTTOM", anchor, "TOP", 0, 6)

    local tex = holder:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints()
    holder.icon = tex

    -- Gentle bob so it reads as "this one" without being obnoxious.
    local ag = holder:CreateAnimationGroup()
    ag:SetLooping("BOUNCE")
    local up = ag:CreateAnimation("Translation")
    up:SetOffset(0, 6)
    up:SetDuration(0.7)
    up:SetSmoothing("IN_OUT")
    holder.anim = ag

    return holder
end

local function ShowMarkerOn(plate, stepType)
    local marker = active[plate]
    if not marker then
        marker = CreateMarker(plate)
        active[plate] = marker
    end

    marker.icon:SetTexture(ICON[stepType] or ICON.default)

    if stepType == "mob" then
        marker.icon:SetTexCoord(0.5, 0.75, 0, 0.25)
        marker.icon:SetVertexColor(unpack(TINT.mob))
        marker:SetSize(22, 22)
    else
        marker.icon:SetTexCoord(0, 1, 0, 1)
        marker.icon:SetVertexColor(1, 1, 1)
        marker:SetSize(32, 32)
    end

    marker:Show()
    if marker.anim and not marker.anim:IsPlaying() then
        marker.anim:Play()
    end
end

local function HideMarkerOn(plate)
    local marker = active[plate]
    if marker then
        if marker.anim then marker.anim:Stop() end
        marker:Hide()
    end
end

--------------------------------------------------------------------------
-- Nameplate handling
--------------------------------------------------------------------------

-- Test hook for G1 (instance safety) - flip this via /tuff debugrestrict to
-- exercise the restricted-state code path without needing to actually be
-- in an instance or on a client with secret values active.
Marker.debugForceRestricted = false

local function IsRestricted()
    return Marker.debugForceRestricted or Compat:IsInInstance() or Compat:HasSecretRestrictions()
end
Marker.IsRestricted = IsRestricted

local function CheckUnit(unit)
    if not unit then return end
    if IsRestricted() or Compat:IsUnitIdentitySecret(unit) then return end

    local name = Compat:Guard(UnitName, unit)
    if not name or Compat:IsSecretValue(name) then return end

    local plate = Compat:Guard(C_NamePlate.GetNamePlateForUnit, unit)
    if not plate then return end

    -- 1. Is this the quest giver the step wants?
    local wanted, stepType = Marker:WantedNPC()
    if wanted then
        local lname, lwant = name:lower(), wanted:lower()
        if lname == lwant or lname:find(lwant, 1, true) then
            ShowMarkerOn(plate, stepType)
            return
        end
    end

    -- 2. Is it something an active objective needs dead? Objective text
    -- names the plural creature ("Mottled Boars slain: 3/10") while the
    -- nameplate shows the singular ("Mottled Boar"), so an exact-string
    -- hash lookup never fires for the common case - fall back to a
    -- substring match in both directions, same as the quest-giver check
    -- above already does for its own name-matching gap.
    local mobs = Marker:WantedMobs()
    if mobs then
        local lname = name:lower()
        if mobs[lname] then
            ShowMarkerOn(plate, "mob")
            return
        end
        for wantedMob in pairs(mobs) do
            if lname:find(wantedMob, 1, true) or wantedMob:find(lname, 1, true) then
                ShowMarkerOn(plate, "mob")
                return
            end
        end
    end

    HideMarkerOn(plate)
end

-- The wanted NPC changes whenever the step advances, so re-scan every
-- visible nameplate rather than waiting for one to spawn.
function Marker:RescanAll()
    self:AnnounceWantedNPC()

    for plate in pairs(active) do
        HideMarkerOn(plate)
    end

    -- Pause entirely rather than just refusing new matches: in an
    -- instance, or under Midnight-style secret-value restrictions,
    -- nameplate matching isn't worth the risk of touching a value the
    -- client won't let us read safely.
    if IsRestricted() then return end

    if not (C_NamePlate and C_NamePlate.GetNamePlates) then return end
    local plates = Compat:Guard(C_NamePlate.GetNamePlates)
    if not plates then return end

    for _, plate in ipairs(plates) do
        local unit = plate.namePlateUnitToken
        if unit then CheckUnit(unit) end
    end
end

--------------------------------------------------------------------------
-- Target fallback
--------------------------------------------------------------------------

-- If nameplates are off entirely, at least confirm on target change.
local function CheckTarget()
    local wanted = Marker:WantedNPC()
    if not wanted then return end
    if IsRestricted() or Compat:IsUnitIdentitySecret("target") then return end
    local name = Compat:Guard(UnitName, "target")
    if not name or Compat:IsSecretValue(name) then return end
    if name:lower() == wanted:lower() then
        ns.Print("|cff00ff00Correct NPC targeted:|r " .. name)
    end
end

--------------------------------------------------------------------------
-- Nameplate visibility
--------------------------------------------------------------------------

-- Friendly NPC nameplates are off by default for most people, which would
-- make the whole feature invisible. Offer it rather than forcing it.
-- SetCVar returns nothing on success, so Compat:Guard's "did the pcall
-- succeed" result was always non-nil and the old code printed failure
-- text on every success. Call it directly and confirm by reading the CVar
-- back instead. SetCVar is also blocked in combat.
function Marker:EnableFriendlyPlates()
    if InCombatLockdown() then
        ns.Print("Can't change nameplate settings in combat. Try again out of combat.")
        return
    end

    pcall(SetCVar, "nameplateShowFriends", 1)
    pcall(SetCVar, "nameplateShowFriendlyNPCs", 1)

    local ok, cur = pcall(GetCVar, "nameplateShowFriends")
    if ok and cur == "1" then
        ns.Print("Friendly nameplates on. NPC markers will show now.")
    else
        ns.Print("Could not change nameplate settings on this client.")
    end
    self:RescanAll()
end

function Marker:DisableFriendlyPlates()
    if InCombatLockdown() then
        ns.Print("Can't change nameplate settings in combat. Try again out of combat.")
        return
    end

    pcall(SetCVar, "nameplateShowFriends", 0)
    pcall(SetCVar, "nameplateShowFriendlyNPCs", 0)
    ns.Print("Friendly nameplates disabled.")
end

function Marker:ToggleMobs()
    self.markMobs = not self.markMobs
    self:RescanAll()
    ns.Print("Objective mob markers " .. (self.markMobs and "on" or "off"))
end

function Marker:Toggle()
    self.enabled = not self.enabled
    if not self.enabled then
        for plate in pairs(active) do HideMarkerOn(plate) end
    else
        self:RescanAll()
    end
    ns.Print("NPC markers " .. (self.enabled and "|cff00ff00on|r" or "|cffff5555off|r"))
end

--------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------

local mf = CreateFrame("Frame")

local _, missingEvents = Compat:RegisterEvents(mf, {
    "NAME_PLATE_UNIT_ADDED",
    "NAME_PLATE_UNIT_REMOVED",
    "PLAYER_TARGET_CHANGED",
    "PLAYER_ENTERING_WORLD",
})
if ns.Core and ns.Core.missingEvents then
    for _, e in ipairs(missingEvents) do table.insert(ns.Core.missingEvents, e) end
end

mf:SetScript("OnEvent", Compat:Wrap("Marker", function(self, event, unit)
    if event == "NAME_PLATE_UNIT_ADDED" then
        CheckUnit(unit)

    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local plate = unit and Compat:Guard(C_NamePlate.GetNamePlateForUnit, unit)
        if plate then
            HideMarkerOn(plate)
            active[plate] = nil
        end

    elseif event == "PLAYER_TARGET_CHANGED" then
        CheckTarget()

    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Fires on every zone/instance transition (including login) - the
        -- prompt trigger for pausing/resuming markers around instance
        -- boundaries, rather than waiting for the next unrelated
        -- step-change-driven RescanAll to notice. `self` here is the
        -- event frame (mf), not the Marker module - call it by name.
        Marker:RescanAll()
    end
end, function()
    Marker.enabled = false
    for plate in pairs(active) do HideMarkerOn(plate) end
end))
