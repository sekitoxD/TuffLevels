-- TuFFlevels / SheetImport.lua
--
-- Eats a CSV export of the ONSLAUGHT route spreadsheet and turns it into a
-- TuFFlevels route.
--
-- The sheet stores quest NAMES, not IDs. That's fine - the addon resolves a
-- name to an ID the moment the quest enters your log, and caches it. Steps
-- that haven't been resolved yet still display and still advance manually.
--
-- Expected columns (detected from the header row, not hardcoded):
--   ACCEPT / TURN IN        action columns
--   COMPLETE, NOTE, TRAINER, SPIRIT REZ, SET HEARTH, HEARTHSTONE,
--   PROGRESS, ITEM ACCEPT   action values in the middle column
--   Quest      quest name, or the text for NOTE rows
--   Zone       zone name
--   Location   sub-area, used as the section name
--   Log        how many quests should be in your log at this point
--   Lvl        expected level
--   Coord      "43.3, 68.9" or "(43.0, 53.0)" for approximate
--   Map        path order marker

local ADDON, ns = ...
local Theme = ns.Theme

local SheetImport = {}
ns.SheetImport = SheetImport

--------------------------------------------------------------------------
-- CSV
--------------------------------------------------------------------------

-- Handles quoted fields containing commas and doubled quotes.
local function ParseCSVLine(line)
    local fields, pos, len = {}, 1, #line

    while pos <= len do
        local field
        if line:sub(pos, pos) == '"' then
            local buf, p = {}, pos + 1
            while p <= len do
                local ch = line:sub(p, p)
                if ch == '"' then
                    if line:sub(p + 1, p + 1) == '"' then
                        table.insert(buf, '"') ; p = p + 2
                    else
                        p = p + 1 ; break
                    end
                else
                    table.insert(buf, ch) ; p = p + 1
                end
            end
            field = table.concat(buf)
            pos = p
            if line:sub(pos, pos) == "," then pos = pos + 1 end
        else
            local nextComma = line:find(",", pos, true)
            if nextComma then
                field = line:sub(pos, nextComma - 1)
                pos = nextComma + 1
            else
                field = line:sub(pos)
                pos = len + 1
            end
        end
        table.insert(fields, (field:gsub("^%s*(.-)%s*$", "%1")))
    end

    -- trailing empty field
    if line:sub(-1) == "," then table.insert(fields, "") end
    return fields
end

-- Tab-separated works too, which is what you get pasting straight out of
-- the browser rather than exporting.
local function ParseLine(line)
    if line:find("\t") then
        local fields = {}
        for f in (line .. "\t"):gmatch("(.-)\t") do
            table.insert(fields, (f:gsub("^%s*(.-)%s*$", "%1")))
        end
        return fields
    end
    return ParseCSVLine(line)
end

--------------------------------------------------------------------------
-- Column detection
--------------------------------------------------------------------------

local HEADERS = {
    quest = { "quest" },
    zone = { "zone" },
    location = { "location" },
    log = { "log" },
    level = { "lvl", "level" },
    coord = { "coord", "coords" },
    map = { "map" },
}

local function DetectColumns(rows)
    for rowIndex, fields in ipairs(rows) do
        local found, count = {}, 0

        for col, value in ipairs(fields) do
            local lower = value:lower()
            for key, names in pairs(HEADERS) do
                if not found[key] then
                    for _, n in ipairs(names) do
                        if lower == n then
                            found[key] = col ; count = count + 1 ; break
                        end
                    end
                end
            end
        end

        -- a real header row has at least quest + coord + level
        if found.quest and found.coord and found.level then
            return found, rowIndex
        end
    end
    return nil
end

--------------------------------------------------------------------------
-- Action detection
--------------------------------------------------------------------------

local ACTION_TO_TYPE = {
    ["ACCEPT"]       = "accept",
    ["ITEM ACCEPT"]  = "accept",
    ["TURN IN"]      = "turnin",
    ["TURNIN"]       = "turnin",
    ["COMPLETE"]     = "complete",
    ["PROGRESS"]     = "complete",
    ["NOTE"]         = "note",
    ["TRAINER"]      = "trainer",
    ["SET HEARTH"]   = "hearth",
    ["HEARTHSTONE"]  = "hearth",
    ["SPIRIT REZ"]   = "death",
    ["GRIND"]        = "grind",
    ["FLIGHT"]       = "travel",
}

-- Actions live in their own columns to the left of the quest name. Scan
-- everything before the quest column rather than assuming which one.
local function DetectAction(fields, questCol)
    for col = 1, math.min(questCol - 1, #fields) do
        local value = (fields[col] or ""):upper()
        if value ~= "" and ACTION_TO_TYPE[value] then
            return ACTION_TO_TYPE[value], value
        end
    end
    return nil
end

--------------------------------------------------------------------------
-- Coordinates
--------------------------------------------------------------------------

-- "43.3, 68.9" exact, "(43.0, 53.0)" approximate, "Multiple" / "Patrol" none.
local function ParseCoord(value)
    if not value or value == "" then return nil end

    local approx = value:find("%(") ~= nil
    local x, y = value:match("([%d%.]+)%s*,%s*([%d%.]+)")
    if not x then return nil end

    return tonumber(x), tonumber(y), approx
end

--------------------------------------------------------------------------
-- Parse
--------------------------------------------------------------------------

function SheetImport:Parse(text, routeName)
    local rows = {}
    for line in (text .. "\n"):gmatch("(.-)\r?\n") do
        if line:match("%S") then table.insert(rows, ParseLine(line)) end
    end

    if #rows == 0 then
        return nil, { "Nothing to parse." }
    end

    local cols, headerRow = DetectColumns(rows)
    if not cols then
        return nil, {
            "Couldn't find a header row.",
            "The sheet needs columns named Quest, Coord and Lvl.",
            "Export as CSV (File > Download > CSV) or copy the cells and paste.",
        }
    end

    local route = {
        faction = "Horde",
        races   = { "Orc", "Troll" },
        steps   = {},
        source  = "Imported from spreadsheet",
    }

    local warnings = {}
    local minLevel, maxLevel = 99, 1
    local skipped = 0

    -- Sections come from chapter boundaries, not location changes. Location
    -- flips back and forth constantly (Den, Valley, Den again) and would
    -- shred the route into fragments. Chapters are where the sheet itself
    -- says a block ends.
    local pendingSection = true
    local sectionStart = nil

    for i = headerRow + 1, #rows do
        local f = rows[i]
        local questText = f[cols.quest] or ""
        local stepType, rawAction = DetectAction(f, cols.quest)
        local level = tonumber(f[cols.level] or "")
        local location = cols.location and f[cols.location] or nil
        local zone = cols.zone and f[cols.zone] or nil
        local logCount = cols.log and tonumber(f[cols.log] or "") or nil

        -- chapter markers sit in their own column with no action
        local isChapter = questText:lower():find("chapter") and questText:lower():find("audit")
        if not isChapter then
            for _, cell in ipairs(f) do
                if cell:lower():find("chapter") and cell:lower():find("end") then
                    isChapter = true
                    questText = cell
                    break
                end
            end
        end

        if isChapter then
            table.insert(route.steps, {
                type = "note",
                name = questText,
                note = logCount and ("Quest log should be at " .. logCount ..
                       " here. If it isn't, something was missed or picked up early.") or nil,
                audit = logCount,
            })
            -- next real row opens a new section
            pendingSection = true
            sectionStart = nil

        elseif stepType then
            if pendingSection then
                pendingSection = false
                sectionStart = {
                    type = "section",
                    name = zone or location or "Section",
                    zone = zone,
                    levels = level and { level, level } or nil,
                }
                table.insert(route.steps, sectionStart)
            end

            -- widen the section's band as we go
            if sectionStart and level then
                sectionStart.levels = sectionStart.levels or { level, level }
                if level < sectionStart.levels[1] then sectionStart.levels[1] = level end
                if level > sectionStart.levels[2] then sectionStart.levels[2] = level end
            end

            local step = {
                type = stepType,
                questName = (stepType ~= "note") and questText or nil,
                name = questText,
                zone = zone,
                location = location,
                minLevel = level,
                logCount = logCount,
                action = rawAction,
            }

            local x, y, approx = ParseCoord(cols.coord and f[cols.coord])
            if x then
                step.x, step.y = x, y
                step.approx = approx
            end

            if stepType == "grind" and level then
                step.targetLevel = level
            end

            table.insert(route.steps, step)

            if level then
                if level < minLevel then minLevel = level end
                if level > maxLevel then maxLevel = level end
            end
        else
            skipped = skipped + 1
        end
    end

    route.levels = { minLevel <= maxLevel and minLevel or 1, maxLevel }
    route.name = routeName

    if #route.steps == 0 then
        table.insert(warnings, "Header found but no rows had a recognisable action.")
    end
    if skipped > 0 then
        table.insert(warnings, ("%d rows skipped (blank or no action column)."):format(skipped))
    end

    return route, warnings
end

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------

local win

function SheetImport:Show()
    if not win then
        win = CreateFrame("Frame", "TuFFlevelsSheetImport", UIParent)
        win:SetSize(660, 520)
        win:SetPoint("CENTER")
        win:SetFrameStrata("DIALOG")
        win:EnableMouse(true)
        win:SetMovable(true)
        win:RegisterForDrag("LeftButton")
        win:SetScript("OnDragStart", win.StartMoving)
        win:SetScript("OnDragStop", win.StopMovingOrSizing)
        Theme:Skin(win)

        local t = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -12)
        t:SetText(Theme:Accent("Import route spreadsheet"))

        local help = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        help:SetPoint("TOP", 0, -32)
        help:SetWidth(600)
        help:SetTextColor(unpack(Theme.color.dim))
        help:SetText("In Sheets: File > Download > Comma-separated values. Open the file, " ..
                     "copy everything, paste below. Or select the cells in the browser and paste directly.")

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsSheetScroll", win,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 16, -60)
        scroll:SetPoint("BOTTOMRIGHT", -34, 82)

        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetMultiLine(true)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(600)
        edit:SetAutoFocus(false)
        edit:SetScript("OnEscapePressed", function() win:Hide() end)
        scroll:SetScrollChild(edit)
        win.edit = edit

        local nameBox = CreateFrame("EditBox", nil, win, "InputBoxTemplate")
        nameBox:SetSize(260, 22)
        nameBox:SetPoint("BOTTOMLEFT", 22, 50)
        nameBox:SetAutoFocus(false)
        nameBox:SetText("ONSLAUGHT Durotar")
        win.nameBox = nameBox

        local nameLabel = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        nameLabel:SetPoint("BOTTOMLEFT", 22, 74)
        nameLabel:SetText("Route name")
        nameLabel:SetTextColor(unpack(Theme.color.dim))

        win.status = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        win.status:SetPoint("BOTTOMLEFT", 300, 46)
        win.status:SetPoint("BOTTOMRIGHT", -18, 46)
        win.status:SetJustifyH("LEFT")
        win.status:SetTextColor(unpack(Theme.color.text))

        local convert = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        convert:SetSize(140, 22)
        convert:SetPoint("BOTTOMLEFT", 16, 16)
        convert:SetText("Import")
        Theme:SkinButton(convert)
        convert:SetScript("OnClick", function()
            SheetImport:DoImport(win.edit:GetText(), win.nameBox:GetText())
        end)

        local export = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        export:SetSize(190, 22)
        export:SetPoint("BOTTOM", 0, 16)
        export:SetText("Import and save as file")
        Theme:SkinButton(export)
        export:SetScript("OnClick", function()
            SheetImport:DoImport(win.edit:GetText(), win.nameBox:GetText(), true)
        end)

        local close = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOMRIGHT", -16, 16)
        close:SetText("Close")
        Theme:SkinButton(close)
        close:SetScript("OnClick", function() win:Hide() end)
    end

    win:Show()
    win.status:SetText("")
    win.edit:SetFocus()
end

function SheetImport:DoImport(text, name, alsoExport)
    if not text or text:match("^%s*$") then
        win.status:SetText(Theme:Ember("Nothing pasted."))
        return
    end

    name = (name and name ~= "") and name or "Imported route"

    local route, warnings = self:Parse(text, name)

    if not route then
        local msg = {}
        for _, w in ipairs(warnings or {}) do table.insert(msg, Theme:Ember(w)) end
        win.status:SetText(table.concat(msg, "\n"))
        return
    end

    ns.RegisterRoute(name, route)
    ns.Core:LoadRoute(name)

    local sections, quests = 0, 0
    for _, s in ipairs(route.steps) do
        if s.type == "section" then sections = sections + 1 end
        if s.questName then quests = quests + 1 end
    end

    local msg = {
        Theme:Bright(("Imported %d steps, %d sections, %d quest steps.")
            :format(#route.steps, sections, quests)),
        Theme:Dim(("Levels %d-%d"):format(route.levels[1], route.levels[2])),
    }
    for _, w in ipairs(warnings) do table.insert(msg, Theme:Dim(w)) end

    if alsoExport then
        table.insert(msg, Theme:Dim("Opening export - paste that into Routes to keep it."))
        C_Timer.After(0.2, function()
            ns.SheetImport:ShowRouteFile(route, name)
        end)
    else
        table.insert(msg, Theme:Dim("Loaded for this session only."))
    end

    win.status:SetText(table.concat(msg, "\n"))
    if ns.UI then ns.UI:Refresh() end
    if ns.Panel then ns.Panel:Refresh() end
end

--------------------------------------------------------------------------
-- Write it back out as a route file
--------------------------------------------------------------------------

local function Esc(s)
    return tostring(s or ""):gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("[\r\n]", " ")
end

function SheetImport:BuildRouteFile(route, name)
    local out = {}
    local function add(l) table.insert(out, l) end

    add("-- " .. name)
    add("-- Imported from spreadsheet by TuFFlevels.")
    add("-- Quest names resolve to IDs automatically as you play.")
    add("")
    add("local ADDON, ns = ...")
    add("")
    add(('ns.RegisterRoute("%s", {'):format(Esc(name)))
    add('    faction = "Horde",')
    add('    races   = { "Orc", "Troll" },')
    add(("    levels  = { %d, %d },"):format(route.levels[1], route.levels[2]))
    add("")
    add("    steps = {")

    for _, s in ipairs(route.steps) do
        local parts = { ('type = "%s"'):format(s.type) }

        if s.type == "section" then
            table.insert(parts, ('name = "%s"'):format(Esc(s.name)))
            if s.levels then
                table.insert(parts, ("levels = { %d, %d }"):format(s.levels[1], s.levels[2]))
            end
            add("")
            add("        { " .. table.concat(parts, ", ") .. " },")
        else
            if s.questName then
                table.insert(parts, ('questName = "%s"'):format(Esc(s.questName)))
            end
            if s.name and s.name ~= s.questName then
                table.insert(parts, ('name = "%s"'):format(Esc(s.name)))
            end
            if s.x and s.y then
                table.insert(parts, ("x = %.1f, y = %.1f"):format(s.x, s.y))
            end
            if s.approx then table.insert(parts, "approx = true") end
            if s.minLevel then table.insert(parts, ("minLevel = %d"):format(s.minLevel)) end
            if s.logCount then table.insert(parts, ("logCount = %d"):format(s.logCount)) end
            if s.targetLevel then table.insert(parts, ("targetLevel = %d"):format(s.targetLevel)) end
            if s.note then table.insert(parts, ('note = "%s"'):format(Esc(s.note))) end
            add("        { " .. table.concat(parts, ", ") .. " },")
        end
    end

    add("    },")
    add("})")
    return table.concat(out, "\n")
end

local fileWin

function SheetImport:ShowRouteFile(route, name)
    if not fileWin then
        fileWin = CreateFrame("Frame", "TuFFlevelsSheetFile", UIParent)
        fileWin:SetSize(660, 500)
        fileWin:SetPoint("CENTER")
        fileWin:SetFrameStrata("FULLSCREEN_DIALOG")
        fileWin:EnableMouse(true)
        fileWin:SetMovable(true)
        fileWin:RegisterForDrag("LeftButton")
        fileWin:SetScript("OnDragStart", fileWin.StartMoving)
        fileWin:SetScript("OnDragStop", fileWin.StopMovingOrSizing)
        Theme:Skin(fileWin)

        local t = fileWin:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -12)
        t:SetText(Theme:Accent("Route file"))

        local help = fileWin:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        help:SetPoint("TOP", 0, -32)
        help:SetTextColor(unpack(Theme.color.dim))
        help:SetText("Ctrl+C, paste into Notepad, save in TuFFlevels/Routes as a .lua file")

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsSheetFileScroll", fileWin,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 16, -56)
        scroll:SetPoint("BOTTOMRIGHT", -34, 46)

        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetMultiLine(true)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(600)
        edit:SetAutoFocus(false)
        edit:SetScript("OnEscapePressed", function() fileWin:Hide() end)
        scroll:SetScrollChild(edit)
        fileWin.edit = edit

        local sel = CreateFrame("Button", nil, fileWin, "UIPanelButtonTemplate")
        sel:SetSize(100, 22)
        sel:SetPoint("BOTTOMLEFT", 16, 16)
        sel:SetText("Select All")
        Theme:SkinButton(sel)
        sel:SetScript("OnClick", function()
            fileWin.edit:SetFocus() ; fileWin.edit:HighlightText()
        end)

        local close = CreateFrame("Button", nil, fileWin, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOMRIGHT", -16, 16)
        close:SetText("Close")
        Theme:SkinButton(close)
        close:SetScript("OnClick", function() fileWin:Hide() end)
    end

    fileWin.edit:SetText(self:BuildRouteFile(route, name))
    fileWin:Show()
    fileWin.edit:SetFocus()
    fileWin.edit:HighlightText()
end
