-- TuFFlevels / Recorder.lua
--
-- Turns playing the game into route authoring.
--
-- Turn recording on, level normally, and this watches every quest you
-- accept and turn in, where you were standing, and what level you were.
-- When you're done it writes a finished route file for you.
--
-- You never look up a quest ID or a coordinate. The client already knows
-- them; we just write them down.

local ADDON, ns = ...
local Compat = ns.Compat

local Recorder = {}
ns.Recorder = Recorder

Recorder.active = false
Recorder.log = {}

-- The NPC you are currently talking to. QUEST_ACCEPTED can fire after the
-- dialog closes, so we grab the name while the frame is still open and
-- use it when the quest event lands.
Recorder.lastNPC = nil

-- Used to split a recording into sections automatically when you change zone.
Recorder.lastZone = nil

--------------------------------------------------------------------------
-- Position
--------------------------------------------------------------------------

-- Returns mapID, x, y (0-100) or nil if the client won't say
-- (instances, loading screens, some scripted sequences).
local function GetPlayerPos()
    if not (C_Map and C_Map.GetBestMapForUnit) then return nil end

    local mapID = Compat:Guard(C_Map.GetBestMapForUnit, "player")
    if not mapID then return nil end

    local pos = Compat:Guard(C_Map.GetPlayerMapPosition, mapID, "player")
    if not pos or not pos.GetXY then return mapID, nil, nil end

    local x, y = pos:GetXY()
    if not x or not y then return mapID, nil, nil end

    return mapID, x * 100, y * 100
end

Recorder.GetPlayerPos = GetPlayerPos

--------------------------------------------------------------------------
-- Recording
--------------------------------------------------------------------------

local function CaptureNPC()
    local name = Compat:Guard(UnitName, "npc")
    if not name then name = Compat:Guard(UnitName, "questnpc") end
    if not name then name = Compat:Guard(UnitName, "target") end
    if name and name ~= "" then Recorder.lastNPC = name end
end

Recorder.CaptureNPC = CaptureNPC

-- Starts a new section whenever you enter a different zone, so a recorded
-- route comes out chunked by area instead of as one 800-line wall.
local function CheckZoneChange()
    if not Recorder.active then return end
    local zone = Compat:Guard(GetZoneText)
    if not zone or zone == "" then return end

    if zone ~= Recorder.lastZone then
        Recorder.lastZone = zone
        local mapID = Compat:Guard(C_Map.GetBestMapForUnit, "player")
        table.insert(Recorder.log, {
            kind = "section", title = zone, map = mapID,
            level = UnitLevel("player"), t = time(),
        })
        Recorder:Persist()
    end
end

Recorder.CheckZoneChange = CheckZoneChange

-- SavedVariables never make it back on Forever, so the only way to keep a
-- recording is to export it while the session is still alive. Nudge every
-- 25 steps instead of waiting for the player to remember on their own.
local NUDGE_EVERY = 25

local function MaybeNudgeExport()
    if not Compat:SavedVarsAreBroken() then return end
    if #Recorder.log == 0 or #Recorder.log % NUDGE_EVERY ~= 0 then return end
    ns.Print(("|cffffff00%d steps recorded.|r Export before you log out - " ..
        "this client won't restore them next login. Menu > Save this as a route."):format(#Recorder.log))
end

local function Record(entry)
    if not Recorder.active then return end
    CheckZoneChange()

    local mapID, x, y = GetPlayerPos()
    entry.map = mapID
    entry.x = x and math.floor(x * 10 + 0.5) / 10 or nil
    entry.y = y and math.floor(y * 10 + 0.5) / 10 or nil
    entry.level = UnitLevel("player")
    -- Only quest steps belong to an NPC. A travel waypoint or a level-up
    -- must not inherit whoever you last spoke to.
    if entry.kind == "accept" or entry.kind == "turnin" then
        entry.npc = entry.npc or Recorder.lastNPC
    end
    entry.t = time()

    table.insert(Recorder.log, entry)
    Recorder:Persist()
    if ns.Panel then ns.Panel:Refresh() end
    MaybeNudgeExport()
end

function Recorder:Start()
    self.active = true
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.recording = true
    db.recordLog = db.recordLog or {}
    self.log = db.recordLog
    ns.Print("|cff00ff00Recording.|r Just play - everything is being written down.")
end

function Recorder:Stop()
    self.active = false
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.recording = false
    ns.Print(("Recording stopped. %d steps captured. Menu > Save this as a route."):format(#self.log))
end

function Recorder:Clear()
    self.log = {}
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.recordLog = {}
    ns.Print("Recording cleared.")
end

function Recorder:Persist()
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.recordLog = self.log
end

function Recorder:Restore()
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    self.log = db.recordLog or {}
    self.active = db.recording or false
    if self.active then
        ns.Print(("|cff00ff00Recording resumed.|r %d steps so far."):format(#self.log))
    elseif Compat:SavedVarsAreBroken() then
        ns.Print("|cffffff00Recording state was reset on login - this client doesn't restore " ..
            "SavedVariables.|r If you were recording, click Start recording again (Menu > Recording). " ..
            "A recording lost this way can still be pulled from disk with tools/extract_recording.py.")
    end
end

--------------------------------------------------------------------------
-- Note taking
--------------------------------------------------------------------------

-- /tuff note <text> — attach a note to the last recorded step, or drop a
-- standalone note at your current position. This is where the human
-- knowledge goes: "pull him away from the adds", "skip if under level 8".
function Recorder:AddNote(text)
    if #self.log > 0 then
        self.log[#self.log].note = text
        self:Persist()
        ns.Print("Note added to last step.")
    else
        Record({ kind = "note", title = text })
        ns.Print("Standalone note recorded.")
    end
end

-- /tuff mark <text> — record a travel/manual step at your exact position.
-- Use it for flight paths, hearth points, "run through this cave", etc.
function Recorder:AddMark(text)
    Record({ kind = "travel", title = text or "Travel" })
    ns.Print("Waypoint recorded here.")
end

--------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------

local KIND_TO_TYPE = {
    section = "section",
    accept = "accept",
    turnin = "turnin",
    level  = "grind",
    travel = "travel",
    note   = "note",
}

local function EscapeLua(s)
    if not s then return "" end
    return tostring(s):gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", " ")
end

function Recorder:BuildRouteText(routeName)
    routeName = routeName or "My Route"

    local out = {}
    local function add(line) table.insert(out, line) end

    local _, race = UnitRace("player")
    local _, class = UnitClass("player")
    local faction = UnitFactionGroup("player")
    local firstLevel = self.log[1] and self.log[1].level or 1
    local lastLevel  = self.log[#self.log] and self.log[#self.log].level or 60
    local recordedAt = date("%Y-%m-%d")

    add("-- Recorded with TuFFlevels on " .. recordedAt)
    add("-- Every quest ID and coordinate below came from the game client.")
    add("")
    add("local ADDON, ns = ...")
    add("")
    add(('ns.RegisterRoute("%s", {'):format(EscapeLua(routeName)))
    -- format: bumped only if this export shape changes in a way
    -- tools/merge_routes.py needs to know about - lets it warn on an
    -- export from a mismatched addon version rather than misreading it.
    add("    format  = 1,")
    add(('    client  = "%s %d",'):format(Compat.flavor, Compat.tocVersion))
    add(('    recordedAt = "%s",'):format(recordedAt))
    add(('    class   = "%s",'):format(class or "?"))
    add(('    faction = "%s",'):format(faction or "Horde"))
    add(('    races   = { "%s" },'):format(race or "Orc"))
    add(('    levels  = { %d, %d },'):format(firstLevel, lastLevel))
    add("")
    add("    steps = {")

    local lastLevelSeen = nil

    for _, e in ipairs(self.log) do
        local stepType = KIND_TO_TYPE[e.kind]
        if stepType then
            local parts = {}

            table.insert(parts, ('type = "%s"'):format(stepType))

            if e.questID then
                table.insert(parts, ("quest = %d"):format(e.questID))
            end
            if e.title and e.title ~= "" then
                table.insert(parts, ('name = "%s"'):format(EscapeLua(e.title)))
            end
            if e.npc then
                table.insert(parts, ('npc = "%s"'):format(EscapeLua(e.npc)))
            end
            if e.map then
                table.insert(parts, ("map = %d"):format(e.map))
            end
            if e.x and e.y then
                table.insert(parts, ("x = %.1f, y = %.1f"):format(e.x, e.y))
            end
            if e.note then
                table.insert(parts, ('note = "%s"'):format(EscapeLua(e.note)))
            end

            -- Mark where you levelled, so the route shows expected pacing.
            if stepType == "section" then
                -- level band: from this marker to the next one
                local band = e.level
                table.insert(parts, ("levels = { %d, %d }"):format(band, band))
            end

            if stepType ~= "section" and e.level and e.level ~= lastLevelSeen then
                table.insert(parts, ("minLevel = %d"):format(e.level))
                lastLevelSeen = e.level
            end

            add("        { " .. table.concat(parts, ", ") .. " },")
        end
    end

    add("    },")
    add("})")

    return table.concat(out, "\n")
end

--------------------------------------------------------------------------
-- Export window (copy-paste, because SavedVariables can't be trusted)
--------------------------------------------------------------------------

local exportFrame

function Recorder:ShowExport(routeName)
    if #self.log == 0 then
        ns.Print("Nothing recorded yet. Menu > Start recording.")
        return
    end

    if not exportFrame then
        exportFrame = CreateFrame("Frame", "TuFFlevelsExport", UIParent, "BackdropTemplate")
        exportFrame:SetSize(600, 450)
        exportFrame:SetPoint("CENTER")
        exportFrame:SetMovable(true)
        exportFrame:EnableMouse(true)
        exportFrame:RegisterForDrag("LeftButton")
        exportFrame:SetScript("OnDragStart", exportFrame.StartMoving)
        exportFrame:SetScript("OnDragStop", exportFrame.StopMovingOrSizing)
        exportFrame:SetFrameStrata("DIALOG")

        ns.Theme:Skin(exportFrame)

        local title = exportFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", 0, -14)
        title:SetText("Route Export")
        title:SetTextColor(unpack(ns.Theme.color.lilac))

        local help = exportFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        help:SetPoint("TOP", 0, -32)
        help:SetTextColor(unpack(ns.Theme.color.dim))
        help:SetText("Press Ctrl+C, then paste into Notepad and save in your Routes folder")

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsExportScroll", exportFrame,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 16, -50)
        scroll:SetPoint("BOTTOMRIGHT", -34, 42)

        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetMultiLine(true)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(540)
        edit:SetAutoFocus(false)
        edit:SetScript("OnEscapePressed", function() exportFrame:Hide() end)
        scroll:SetScrollChild(edit)
        exportFrame.edit = edit

        local close = CreateFrame("Button", nil, exportFrame, "UIPanelButtonTemplate")
        close:SetSize(80, 22)
        close:SetPoint("BOTTOMRIGHT", -16, 14)
        close:SetText("Close")
        close:SetScript("OnClick", function() exportFrame:Hide() end)

        local selectAll = CreateFrame("Button", nil, exportFrame, "UIPanelButtonTemplate")
        selectAll:SetSize(100, 22)
        selectAll:SetPoint("BOTTOMLEFT", 16, 14)
        selectAll:SetText("Select All")
        selectAll:SetScript("OnClick", function()
            exportFrame.edit:SetFocus()
            exportFrame.edit:HighlightText()
        end)
        ns.Theme:SkinChildren(exportFrame)
    end

    local text = self:BuildRouteText(routeName)
    exportFrame.edit:SetText(text)
    exportFrame:Show()
    exportFrame.edit:SetFocus()
    exportFrame.edit:HighlightText()
end

--------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------

local rf = CreateFrame("Frame")

local _, missingEvents = Compat:RegisterEvents(rf, {
    "PLAYER_LOGIN",
    "QUEST_ACCEPTED",
    "QUEST_TURNED_IN",
    "PLAYER_LEVEL_UP",
    -- These fire while the NPC dialog is still open, which is the only
    -- moment the client will tell us who we are talking to.
    "QUEST_DETAIL",
    "QUEST_PROGRESS",
    "QUEST_COMPLETE",
    "GOSSIP_SHOW",
    "ZONE_CHANGED_NEW_AREA",
    "PLAYER_LEAVING_WORLD",
})
if ns.Core and ns.Core.missingEvents then
    for _, e in ipairs(missingEvents) do table.insert(ns.Core.missingEvents, e) end
end

rf:SetScript("OnEvent", Compat:Wrap("Recorder", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        Recorder:Restore()
        return
    end

    if event == "QUEST_DETAIL" or event == "QUEST_PROGRESS"
       or event == "QUEST_COMPLETE" or event == "GOSSIP_SHOW" then
        CaptureNPC()
        return
    end

    if event == "PLAYER_LEAVING_WORLD" then
        if Recorder.active and Compat:SavedVarsAreBroken() and #Recorder.log > 0 then
            ns.Print(("|cffffff00%d steps recorded, not yet exported.|r Export now if you're logging out - " ..
                "this client won't restore them next login."):format(#Recorder.log))
        end
        return
    end

    if not Recorder.active then return end

    if event == "ZONE_CHANGED_NEW_AREA" then
        CheckZoneChange()
        return
    end

    if event == "QUEST_ACCEPTED" then
        -- Payload differs between clients; find the numeric quest ID.
        local a, b = ...
        local questID = (type(b) == "number" and b) or (type(a) == "number" and a)
        if questID then
            local title
            local idx = Compat:GetLogIndex(questID)
            if idx then
                local info = Compat:GetQuestLogInfo(idx)
                title = info and info.title
            end
            Record({ kind = "accept", questID = questID, title = title })
        end

    elseif event == "QUEST_TURNED_IN" then
        local questID = ...
        if type(questID) == "number" then
            Record({ kind = "turnin", questID = questID })
        end

    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        if type(newLevel) == "number" then
            Record({ kind = "level", title = "Reached level " .. newLevel,
                     targetLevel = newLevel })
        end
    end
end))
