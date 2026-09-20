-- TuFFlevels / CompactGuide.lua
--
-- An optional line-based syntax that compiles to the same step tables
-- Routes/*.lua files write by hand - for a first-time author, one line
-- per step reads a lot easier than a Lua table literal. The step table
-- stays the source of truth; this is a convenience layer on top of it,
-- not a new engine concept. Original syntax, built for this addon - not
-- Guidelime's (see GuideImport.lua) and not RestedXP's.
--
-- Structurally mirrors GuideImport.lua: Parse(text) -> route, name,
-- warnings, plus a paste-box Show()/DoConvert() dialog.
--
-- LINE FORMAT
--   # directive value          route-level metadata
--   -- comment                 ignored, like a Lua comment
--   type positional... key=value... ["quoted note"]
--
-- DIRECTIVES (route-level, one per line)
--   #name <text>       route display name
--   #faction <text>    "Horde" | "Alliance"
--   #races <list>      comma-separated, e.g. Orc,Troll
--   #levels <lo>-<hi>  route's level range
--   #author <text>
--
-- STEP LINES
--   accept/turnin/complete <questID>   quest steps
--   complete <questID> objective=n     gate on one objective, not the whole quest
--   grind/level <targetLevel>
--   xp <level> [pct=n]                 xp = { level = n, pct = n }
--   section <name...> [<lo>-<hi>]      trailing "N-N" becomes levels
--   travel <map,x,y | zone,x,y>        coords may also come via at=
--   flightpath <mapID,node>            node may be a numeric ID or a name
--   trainer/death/manual/note <text...>
--
--   Common keys, any type: npc= name= note= at=map-or-zone,x,y objective=
--   optional (bare flag, or optional=true) skipIfLevel= minLevel=
--   requires=1,2,3 (other step numbers in THIS file, 1-based) races=A,B
--   class=CLASSTOKEN
--
--   A value with spaces needs quotes: name="Your Place In The World".
--   A bare "quoted string" with no key= is shorthand for note=.
--
-- EXAMPLE
--   #name Valley of Trials
--   #faction Horde
--   #races Orc,Troll
--
--   section Valley of Trials 1-6
--   accept 4641 name="Your Place In The World" npc=Kaltunk at=1411,42.6,68.8 "Right in front of you at spawn."
--   turnin 4641 npc=Gornek at=1411,43.4,68.0
--   grind 5 at=1411,44.0,66.0

local ADDON, ns = ...

local CompactGuide = {}
ns.CompactGuide = CompactGuide

--------------------------------------------------------------------------
-- Tokenizer
--------------------------------------------------------------------------

-- Splits a line into tokens on whitespace, except a key="quoted value" or
-- a bare "quoted value" stays one token (quotes and all) so spaces inside
-- it survive. Quotes are stripped when each token is interpreted below.
local function Tokenize(line)
    local tokens = {}
    local i, n = 1, #line

    while i <= n do
        while i <= n and line:sub(i, i):match("%s") do i = i + 1 end
        if i > n then break end

        local start = i
        local spacePos = line:find("%s", i) or (n + 1)
        local plainEnd = spacePos - 1

        local eq = line:find("=", start, true)
        if eq and eq <= plainEnd and line:sub(eq + 1, eq + 1) == '"' then
            local close = line:find('"', eq + 2, true) or n
            table.insert(tokens, line:sub(start, close))
            i = close + 1
        elseif line:sub(start, start) == '"' then
            local close = line:find('"', start + 1, true) or n
            table.insert(tokens, line:sub(start, close))
            i = close + 1
        else
            table.insert(tokens, line:sub(start, plainEnd))
            i = spacePos
        end
    end

    return tokens
end

-- "1411,42.6,68.8" or "Durotar,42.6,68.8" -> a table with x/y and either
-- map (numeric first part) or zone (text first part), or nil if it
-- doesn't look like a coordinate triple at all.
local function ParseCoordTriple(value)
    local first, x, y = value:match("^([^,]+),([%d%.]+),([%d%.]+)$")
    if not first then return nil end

    local point = { x = tonumber(x), y = tonumber(y) }
    local mapID = tonumber(first)
    if mapID then point.map = mapID else point.zone = first end
    return point
end

local function ParseNumberList(value)
    local out = {}
    for part in value:gmatch("[^,]+") do
        table.insert(out, tonumber(part))
    end
    return out
end

local function ParseStringList(value)
    local out = {}
    for part in value:gmatch("[^,]+") do
        table.insert(out, part:match("^%s*(.-)%s*$"))
    end
    return out
end

--------------------------------------------------------------------------
-- Line -> step
--------------------------------------------------------------------------

-- Splits tokens into: the step type, ordered positional (non-key) tokens,
-- and a key/value map - quotes already stripped from both keys' values
-- and bare quoted tokens (which become kv.note).
local function ClassifyTokens(tokens)
    local stepType = tokens[1]
    local positional, kv = {}, {}

    for i = 2, #tokens do
        local token = tokens[i]

        local key, qval = token:match('^(%a[%w]*)="(.-)"$')
        if key then
            kv[key] = qval
        else
            local key2, val2 = token:match("^(%a[%w]*)=(.+)$")
            if key2 then
                kv[key2] = val2
            else
                local bare = token:match('^"(.-)"$')
                if bare then
                    kv.note = kv.note or bare
                elseif token == "optional" then
                    kv.optional = "true"
                else
                    table.insert(positional, token)
                end
            end
        end
    end

    return stepType, positional, kv
end

-- Keys that make sense on more than one step type, applied after the
-- type-specific fields below so an explicit key always wins over a
-- positional guess (e.g. explicit name= over a joined-positional name).
local function ApplyCommonKeys(step, kv)
    if kv.npc then step.npc = kv.npc end
    if kv.name then step.name = kv.name end
    if kv.note then step.note = kv.note end
    if kv.zone then step.zone = kv.zone end

    if kv.at then
        local point = ParseCoordTriple(kv.at)
        if point then
            step.map, step.zone = point.map, point.zone or step.zone
            step.x, step.y = point.x, point.y
        end
    end

    if kv.objective then step.objective = tonumber(kv.objective) end
    if kv.optional then step.optional = (kv.optional ~= "false") end
    if kv.skipIfLevel then step.skipIfLevel = tonumber(kv.skipIfLevel) end
    if kv.minLevel then step.minLevel = tonumber(kv.minLevel) end
    if kv.class then step.class = kv.class end
    if kv.requires then step.requires = ParseNumberList(kv.requires) end
    if kv.races then step.races = ParseStringList(kv.races) end
end

-- Builds one step table from a single non-empty, non-comment, non-
-- directive line. Returns nil plus a warning string if the line can't be
-- understood at all.
local function ParseStepLine(line, lineNo)
    local tokens = Tokenize(line)
    local stepType, positional, kv = ClassifyTokens(tokens)
    if not stepType then return nil, ("line %d: empty"):format(lineNo) end

    local step = { type = stepType }

    if stepType == "accept" or stepType == "turnin" or stepType == "complete" then
        local id = tonumber(positional[1])
        if id then step.quest = id
        elseif positional[1] then step.questName = table.concat(positional, " ") end

    elseif stepType == "grind" or stepType == "level" then
        step.targetLevel = tonumber(positional[1])

    elseif stepType == "xp" then
        step.xp = { level = tonumber(positional[1]), pct = tonumber(kv.pct) or 0 }

    elseif stepType == "section" then
        local lo, hi = nil, nil
        local nameParts = {}
        for _, tok in ipairs(positional) do
            local a, b = tok:match("^(%d+)%-(%d+)$")
            if a then lo, hi = tonumber(a), tonumber(b)
            else table.insert(nameParts, tok) end
        end
        step.name = table.concat(nameParts, " ")
        if lo then step.levels = { lo, hi } end

    elseif stepType == "travel" then
        if positional[1] then
            local point = ParseCoordTriple(positional[1])
            if point then
                step.map, step.zone, step.x, step.y = point.map, point.zone, point.x, point.y
                table.remove(positional, 1)
            end
        end
        if not step.name and #positional > 0 then step.name = table.concat(positional, " ") end

    elseif stepType == "flightpath" then
        if positional[1] then
            local mapID, rest = positional[1]:match("^(%d+),(.+)$")
            if mapID then
                step.mapID = tonumber(mapID)
                step.node = tonumber(rest) or nil
                if not step.node then step.name = rest end
            end
        end

    elseif stepType == "trainer" or stepType == "death" or stepType == "manual" or stepType == "note" then
        if #positional > 0 then step.name = table.concat(positional, " ") end

    elseif stepType == "hearth" then
        -- no positional fields of its own; at=/name= (common keys) cover it

    else
        return nil, ("line %d: unknown step type '%s'"):format(lineNo, stepType)
    end

    ApplyCommonKeys(step, kv)
    return step
end

--------------------------------------------------------------------------
-- Parse
--------------------------------------------------------------------------

function CompactGuide:Parse(text)
    local route = { steps = {} }
    local name
    local warnings = {}
    local lineNo = 0

    for line in (text .. "\n"):gmatch("(.-)\n") do
        lineNo = lineNo + 1
        line = line:match("^%s*(.-)%s*$")

        if line ~= "" and not line:match("^%-%-") then
            if line:sub(1, 1) == "#" then
                local key, value = line:match("^#(%a+)%s+(.*)$")
                key = key and key:lower()
                if key == "name" then
                    name = value
                elseif key == "faction" then
                    route.faction = value
                elseif key == "races" then
                    route.races = ParseStringList(value)
                elseif key == "author" then
                    route.author = value
                elseif key == "levels" then
                    local lo, hi = value:match("^(%d+)%-(%d+)$")
                    if lo then route.levels = { tonumber(lo), tonumber(hi) } end
                else
                    table.insert(warnings, ("line %d: unknown directive '%s'"):format(lineNo, line))
                end
            else
                local step, err = ParseStepLine(line, lineNo)
                if step then
                    table.insert(route.steps, step)
                elseif err then
                    table.insert(warnings, err)
                end
            end
        end
    end

    if #route.steps == 0 then
        table.insert(warnings, "No steps found.")
    end

    return route, name or "Compact route", warnings
end

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------

local win

function CompactGuide:Show()
    if not win then
        win = CreateFrame("Frame", "TuFFlevelsCompactGuide", UIParent, "BackdropTemplate")
        win:SetSize(640, 500)
        win:SetPoint("CENTER")
        win:SetFrameStrata("DIALOG")
        win:EnableMouse(true)
        win:SetMovable(true)
        win:RegisterForDrag("LeftButton")
        win:SetScript("OnDragStart", win.StartMoving)
        win:SetScript("OnDragStop", win.StopMovingOrSizing)

        ns.Theme:Skin(win)

        local t = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Write a route (compact text)")

        local help = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        help:SetPoint("TOP", 0, -32)
        help:SetWidth(580)
        help:SetTextColor(unpack(ns.Theme.color.dim))
        help:SetText("One line per step - see CompactGuide.lua's header for the format. " ..
                     "Example: accept 4641 npc=Kaltunk at=1411,42.6,68.8 \"Right in front of spawn.\"")

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsCompactGuideScroll", win,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 16, -56)
        scroll:SetPoint("BOTTOMRIGHT", -34, 76)

        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetMultiLine(true)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(580)
        edit:SetAutoFocus(false)
        edit:SetScript("OnEscapePressed", function() win:Hide() end)
        scroll:SetScrollChild(edit)
        win.edit = edit

        win.status = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        win.status:SetPoint("BOTTOMLEFT", 18, 46)
        win.status:SetPoint("BOTTOMRIGHT", -18, 46)
        win.status:SetJustifyH("LEFT")
        win.status:SetTextColor(unpack(ns.Theme.color.text))

        local convert = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        convert:SetSize(140, 22)
        convert:SetPoint("BOTTOMLEFT", 16, 16)
        convert:SetText("Compile")
        convert:SetScript("OnClick", function()
            CompactGuide:DoConvert(win.edit:GetText())
        end)

        local close = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOMRIGHT", -16, 16)
        close:SetText("Close")
        close:SetScript("OnClick", function() win:Hide() end)
        ns.Theme:SkinChildren(win)
        t:SetTextColor(unpack(ns.Theme.color.lilac))
    end

    win:Show()
    win.status:SetText("")
end

function CompactGuide:DoConvert(text)
    if not text or text:match("^%s*$") then
        win.status:SetText("|cffff5555Nothing written yet.|r")
        return
    end

    local route, name, warnings = self:Parse(text)

    if #route.steps == 0 then
        win.status:SetText("|cffff5555" .. (warnings[1] or "Compile failed.") .. "|r")
        return
    end

    ns.RegisterRoute(name, route)
    ns.Core:LoadRoute(name)

    local msg = ("|cff00ff00Compiled '%s' - %d steps.|r"):format(name, #route.steps)
    for _, w in ipairs(warnings) do
        msg = msg .. "\n|cffffff00" .. w .. "|r"
    end
    msg = msg .. "\n|cff909090This route lives in memory only. Use Save this as a route to keep it.|r"

    win.status:SetText(msg)
    if ns.UI then ns.UI:Refresh() end
    if ns.Panel then ns.Panel:Refresh() end
end
