-- TuFFlevels / RXPImport.lua
--
-- Reads guides written in RXPGuides' (RestedXP) own guide-text DSL and
-- converts them into TuFFlevels routes.
--
-- WHY THIS EXISTS, AND WHAT IT DELIBERATELY DOES NOT DO
--
-- RXPGuides ships some of the most tightly-optimized Classic leveling
-- routes around, and TuFFlevels currently has zero Alliance route data at
-- all - this exists to close that gap without copying anyone's work.
--
-- RXPGuides' guide text is Creative Commons BY-NC-SA 4.0. TuFFlevels is
-- MIT. Baking someone else's CC BY-NC-SA content into an MIT-licensed
-- repo would violate ShareAlike, so this module ships NONE of RXPGuides'
-- actual guide text - same arrangement as GuideImport.lua (Guidelime) and
-- Data.lua (QuestieDB): the data stays with whoever published it, this
-- addon only knows how to read the format. You paste in text from a copy
-- of RXPGuides you already have installed; nothing here reads its files
-- directly or ships any of its content.
--
-- If you publish a route built from an RXPGuides guide, credit RestedXP
-- and check their license terms first. Format compatibility is not
-- permission.
--
-- WHICH FILE TO PASTE FROM
--
-- RXPGuides ships separate guide files per expansion. Files under
-- Guides\RestedXP *.lua are TBC/WotLK-flavored (their header carries
-- `#tbc`/`#wotlk` with no `#classic`, which in RXPGuides' own loader means
-- the guide is skipped entirely on a Classic Era client). For Classic Era
-- routes, paste from the `Guides\Classic-*.lua` files instead (e.g.
-- `Classic-Alliance-1-13_Human.lua`) - those are the ones actually meant
-- for this client.
--
-- GRAMMAR THIS PARSER UNDERSTANDS (see RXPGuides' GuideLoader.lua /
-- functions.lua for the authoritative source)
--
-- `#name` / `#displayname` header directives name the guide. A `step`
-- line starts a new step; a trailing `<< Cond1 Cond2` is an AND of
-- conditions (class name, race name, faction, `!Cond` negation, or an
-- expansion flavor tag) that gates the whole step. A line inside a step
-- can carry its own trailing `<< Cond` the same way. `.goto Zone,x,y` sets
-- travel coordinates; multiple `.goto`s in one step become a waypoint
-- path, the last one is the final target. `.accept`/`.turnin`/`.complete`
-- (quest ID [,objective]) map directly to TuFFlevels' own step types.
-- `.trainer`/`.hs`/`.deathskip` map to trainer/hearth/death. `.target`,
-- `.vendor`, `.link`, and bare `>>`/`+` text lines carry no TuFFlevels
-- step type of their own and are folded into the step's `npc` field or
-- `note` text instead. `--comment` is stripped everywhere, exactly as
-- RXPGuides' own loader strips it before parsing anything else.
--
-- WHAT THIS PARSER DELIBERATELY SIMPLIFIES (bounded scope, not full
-- fidelity - see anything it can't confidently map, it keeps the step and
-- adds a warning rather than silently dropping content or guessing wrong)
--
-- - OR conditions (`Cond1/Cond2`) can't be expressed with TuFFlevels'
--   single `class`/`races` filters, so a step using one is kept
--   unfiltered and flagged for manual review instead of being dropped.
-- - Steps gated on a non-Classic expansion tag (tbc/wotlk/cata/...) are
--   dropped outright - out of scope for this addon's Classic Era/Forever
--   targets.
-- - `.goto`'s optional radius/"is this just a path point" flags aren't
--   modeled individually; every `.goto` in a step except the last always
--   becomes a `path` waypoint, and the last always becomes the step's own
--   target. This matches the common case in practice.
-- - `.vendor`/`.link`/`.target`/bare `>>`/`+` lines have no direct
--   TuFFlevels step-type equivalent, so they're folded into `note`/`npc`
--   text on the step they belong to rather than becoming their own step.

local ADDON, ns = ...

local RXPImport = {}
ns.RXPImport = RXPImport

--------------------------------------------------------------------------
-- Text cleanup
--------------------------------------------------------------------------

-- RXPGuides strips `--comment` to end of line before parsing anything
-- else runs - mirror that so stray `--` in guide text can't confuse the
-- rest of the parser.
local function StripComments(text)
    return (text .. "\n"):gsub("%-%-[^\r\n]*\r?\n", "\n")
end

-- RXPGuides' `|cRXP_CATEGORY_Label|r` tokens are its own authoring-time
-- color macros, not real WoW escape sequences - the human-readable text is
-- the "Label" part. Strip them down to plain text, and strip any real WoW
-- color codes the same way.
local function StripColorTokens(text)
    if not text then return text end
    text = text:gsub("|c%u[%u_]*_(.-)|r", "%1")
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    return text
end

--------------------------------------------------------------------------
-- Condition matching (`<< Cond1 Cond2`, `<< Cond1/Cond2`)
--------------------------------------------------------------------------

local CLASS_TOKENS = {
    WARRIOR = "WARRIOR", PALADIN = "PALADIN", HUNTER = "HUNTER",
    ROGUE = "ROGUE", PRIEST = "PRIEST", SHAMAN = "SHAMAN", MAGE = "MAGE",
    WARLOCK = "WARLOCK", DRUID = "DRUID",
}

local EXPANSION_TOKENS = {
    TBC = true, WOTLK = true, CATA = true, MOP = true, WOD = true,
    LEGION = true, BFA = true, SHADOWLANDS = true, DRAGONFLIGHT = true,
    TWW = true, RETAIL = true,
}

local RACE_TOKENS = {
    HUMAN = "Human", DWARF = "Dwarf", GNOME = "Gnome",
    NIGHTELF = "NightElf", DRAENEI = "Draenei", ORC = "Orc",
    TROLL = "Troll", TAUREN = "Tauren", UNDEAD = "Undead",
    SCOURGE = "Undead", BLOODELF = "BloodElf",
}

-- One AND-group of space-separated tokens (an OR group, already split out
-- by EvalCondition, is passed in one at a time). Returns class, races,
-- outOfScope (drop the step/line entirely), unhandled (kept a token it
-- didn't recognize).
local function ClassifyTokens(tokens)
    local class, races, outOfScope, unhandled
    for _, raw in ipairs(tokens) do
        local neg = raw:sub(1, 1) == "!"
        local tok = (neg and raw:sub(2) or raw):upper()
        if neg then
            -- Negated conditions ("!Human" wrong-guide warnings, "!Class")
            -- are RXPGuides UI navigation, not leveling content.
            outOfScope = true
        elseif CLASS_TOKENS[tok] then
            class = CLASS_TOKENS[tok]
        elseif EXPANSION_TOKENS[tok] then
            outOfScope = true
        elseif tok == "CLASSIC" or tok == "SOD" then
            -- explicit in-scope marker, nothing to record
        elseif RACE_TOKENS[tok] then
            races = races or {}
            table.insert(races, RACE_TOKENS[tok])
        elseif tok == "ALLIANCE" or tok == "HORDE" then
            -- faction - handled at the route level, not per step
        elseif tok == "MALE" or tok == "FEMALE" then
            -- not something TuFFlevels' step schema can filter on
            unhandled = true
        else
            unhandled = true
        end
    end
    return class, races, outOfScope, unhandled
end

-- "Warlock tbc" or "Human/Dwarf/Gnome" -> class, races, outOfScope,
-- unhandled. Multiple `/`-separated OR groups can't be expressed with
-- TuFFlevels' single class/races filter, so they're reported unhandled
-- and the step is kept unfiltered rather than dropped or guessed at.
local function EvalCondition(condText)
    if not condText or condText:match("^%s*$") then
        return nil, nil, false, false
    end
    local groups = {}
    for group in condText:gmatch("[^/]+") do table.insert(groups, group) end
    if #groups > 1 then
        return nil, nil, false, true
    end
    local tokens = {}
    for tok in groups[1]:gmatch("%S+") do table.insert(tokens, tok) end
    return ClassifyTokens(tokens)
end

--------------------------------------------------------------------------
-- Parser
--------------------------------------------------------------------------

function RXPImport:Parse(text)
    local route = {
        faction = nil,
        races = nil,
        levels = nil,
        steps = {},
        source = "Converted from an RXPGuides (RestedXP) guide you pasted in. " ..
            "RXPGuides content is CC BY-NC-SA 4.0 - credit RestedXP and check " ..
            "their license terms before republishing this route.",
    }

    if not text or text:match("^%s*$") then
        return route, "Imported RXP route", { "Nothing pasted." }
    end

    -- Accept either the whole file (with the Lua wrapper and
    -- RegisterGuide([[ ]]) call) or just the inner guide text.
    local inner = text:match("RegisterGuide%s*%(%s*%[%[(.-)%]%]%s*%)")
    if inner then text = inner end

    text = StripComments(text)

    local warnings = {}
    local guideName, displayName
    local sawStep = false
    local curStep

    local function FinishStep()
        if curStep and not curStep._skip then
            -- Fold accumulated notes into the step's note text before the
            -- scratch table is dropped, so it isn't lost before anything
            -- reads it.
            if curStep._notes and #curStep._notes > 0 then
                curStep.note = table.concat(curStep._notes, " - ")
            end
            curStep._notes = nil
            if curStep.type or curStep.zone or curStep.note then
                table.insert(route.steps, curStep)
            end
            -- else: nothing but a scratch table came out of this step
            -- (no type, no zone, no note text) - drop it rather than
            -- keeping a content-free placeholder.
        end
        curStep = nil
    end

    local function EnsureStep()
        if not curStep then
            curStep = { _notes = {} }
        end
        return curStep
    end

    for rawLine in (text .. "\n"):gmatch("(.-)\n") do
        local line = rawLine:match("^%s*(.-)%s*$")

        if line ~= "" then
            if not sawStep and line:sub(1, 1) == "#" then
                local tag, val = line:match("^#(%S+)%s*(.-)$")
                tag = tag and tag:lower()
                if tag == "name" and not guideName then
                    guideName = val
                elseif tag == "displayname" and not displayName then
                    displayName = val
                end

            elseif not sawStep and line:match("^<<") then
                local cond = line:match("^<<%s*(.-)%s*$")
                local fac = cond and cond:match("^(%a+)")
                fac = fac and fac:upper()
                if fac == "ALLIANCE" then route.faction = "Alliance"
                elseif fac == "HORDE" then route.faction = "Horde" end

            elseif line == "step" or line:match("^step%s*<<") then
                FinishStep()
                sawStep = true
                local cond = line:match("^step%s*<<%s*(.-)%s*$")
                local class, races, outOfScope, unhandled = EvalCondition(cond)
                if outOfScope then
                    curStep = { _skip = true }
                else
                    curStep = EnsureStep()
                    if class then curStep.class = class end
                    if races and #races == 1 then curStep.races = races end
                    if unhandled then
                        table.insert(warnings, ("Step condition '%s' is an OR/complex "
                            .. "condition TuFFlevels can't filter on - kept unfiltered, "
                            .. "please review."):format(cond))
                    end
                end

            elseif curStep and curStep._skip then
                -- inside an out-of-scope step (expansion-gated or a wrong-
                -- guide warning) - ignore its body lines entirely

            elseif line:sub(1, 1) == "#" then
                local tag, val = line:match("^#(%S+)%s*(.-)$")
                tag = tag and tag:lower()
                local step = EnsureStep()
                if tag == "sticky" or (tag == "completewith" and val == "next") then
                    step._infoOnly = true
                end

            else
                local body, lineCond = line:match("^(.-)%s*<<%s*(%S.-)%s*$")
                if not body then body = line end
                if lineCond then
                    local class, _, outOfScope = EvalCondition(lineCond)
                    if outOfScope then
                        body = nil
                    elseif class and curStep and curStep.class and curStep.class ~= class then
                        body = nil
                    end
                end

                if body and body ~= "" then
                    local step = EnsureStep()

                    if body:sub(1, 1) == "." then
                        local cmd, args = body:match("^%.(%S+)%s*(.-)$")
                        cmd = cmd and cmd:lower()
                        args = args or ""
                        local argText, annotation = args:match("^(.-)%s*>>%s*(.-)$")
                        argText = argText or args
                        annotation = annotation and StripColorTokens(annotation)

                        if cmd == "goto" then
                            local zone, x, y = argText:match("^(.-),%s*([%d%.]+)%s*,%s*([%d%.]+)")
                            if zone then
                                zone = zone:match("^%s*(.-)%s*$")
                                if step.zone then
                                    step.path = step.path or {}
                                    table.insert(step.path, { zone = step.zone, x = step.x, y = step.y })
                                end
                                step.zone, step.x, step.y = zone, tonumber(x), tonumber(y)
                                if annotation and annotation ~= "" then step.name = step.name or annotation end
                            end

                        elseif cmd == "accept" or cmd == "turnin" then
                            local id = tonumber(argText:match("^(%-?%d+)"))
                            if id then
                                step.type = cmd
                                step.quest = math.abs(id)
                                step.name = step.name or annotation
                            end

                        elseif cmd == "complete" then
                            local id, obj = argText:match("^(%-?%d+)%s*,%s*(%d+)")
                            if not id then id = argText:match("^(%-?%d+)") end
                            id = tonumber(id)
                            if id then
                                step.type = "complete"
                                step.quest = math.abs(id)
                                if obj then step.objective = tonumber(obj) end
                                if id < 0 then step.optional = true end
                                step.name = step.name or annotation
                            end

                        elseif cmd == "trainer" then
                            step.type = "trainer"
                            step.name = step.name or annotation or "Visit trainer"

                        elseif cmd == "hs" then
                            step.type = "hearth"
                            local label = StripColorTokens(argText)
                            step.name = step.name or (label ~= "" and label) or "Hearth"

                        elseif cmd == "deathskip" then
                            step.type = "death"
                            local label = StripColorTokens(argText)
                            step.name = step.name or (label ~= "" and label) or "Die and release"

                        elseif cmd == "target" then
                            local nm = argText:match("^%+?%s*(.-)$")
                            if nm and nm ~= "" then step.npc = step.npc or StripColorTokens(nm) end

                        elseif cmd == "vendor" then
                            table.insert(step._notes, "Vendor: "
                                .. ((annotation and annotation ~= "") and annotation or "sell junk / resupply"))

                        elseif cmd == "link" then
                            if annotation and annotation ~= "" then
                                table.insert(step._notes, annotation .. " (" .. argText .. ")")
                            end

                        else
                            -- Unrecognized dot-command (e.g. .repair, .mail,
                            -- .use, .click): keep it as a note rather than
                            -- silently losing whatever it was telling the
                            -- player to do.
                            table.insert(step._notes, StripColorTokens(body))
                        end

                    elseif body:sub(1, 2) == ">>" then
                        local t = StripColorTokens(body:sub(3):match("^%s*(.-)%s*$"))
                        if t ~= "" then
                            if not step.name then step.name = t else table.insert(step._notes, t) end
                        end

                    elseif body:sub(1, 1) == "+" then
                        local t = StripColorTokens(body:sub(2):match("^%s*(.-)%s*$"))
                        if t ~= "" then table.insert(step._notes, t) end
                    end
                end
            end
        end
    end
    FinishStep()

    for _, s in ipairs(route.steps) do
        -- (_notes -> note concatenation now happens in FinishStep, before
        -- _notes is nil'd, so there's nothing left to fold in here.)
        if not s.type then
            if s.zone then
                s.type = "travel"
                -- A travel step can legitimately carry no note text.
                if not s.name then s.name = s.note or "Guide note" end
            else
                -- FinishStep only lets a zoneless, typeless step through
                -- when it has note text, so s.note is always set here -
                -- no "Guide note" placeholder fallback needed.
                s.type = "note"
                if not s.name then s.name = s.note end
            end
        end
        if s._infoOnly then
            s.optional = true
            s._infoOnly = nil
        end
    end

    local name = displayName or guideName or "Imported RXP route"
    name = name:gsub("RestedXP%s*", ""):gsub("RXPGuides?", ""):gsub("^%s*[:%-]*%s*", "")
    name = "TuFFlvls " .. name

    if #route.steps == 0 then
        table.insert(warnings, "No steps found. Paste the text between "
            .. "RXPGuides.RegisterGuide([[ and ]]) - and make sure it's a "
            .. "Classic-flavored guide file, not a TBC/WotLK one (see this "
            .. "file's header comment).")
    end

    return route, name, warnings
end

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------

local win

function RXPImport:Show()
    if not win then
        win = CreateFrame("Frame", "TuFFlevelsRXPImport", UIParent, "BackdropTemplate")
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
        t:SetText("Import an RXPGuides guide")

        local help = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        help:SetPoint("TOP", 0, -32)
        help:SetWidth(580)
        help:SetTextColor(unpack(ns.Theme.color.dim))
        help:SetText("Paste the text from an already-installed RXPGuides Classic-flavored "
            .. "guide file (Guides\\Classic-*.lua, not the TBC/WotLK-flavored RestedXP *.lua "
            .. "ones) between RegisterGuide([[ and ]]), then Convert. Credit RestedXP and "
            .. "check their license (CC BY-NC-SA 4.0) before republishing what you build.")

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsRXPImportScroll", win,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 16, -64)
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
        convert:SetText("Convert")
        convert:SetScript("OnClick", function()
            RXPImport:DoConvert(win.edit:GetText())
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

function RXPImport:DoConvert(text)
    if not text or text:match("^%s*$") then
        win.status:SetText("|cffff5555Nothing pasted.|r")
        return
    end

    local route, name, warnings = self:Parse(text)

    if #route.steps == 0 then
        win.status:SetText("|cffff5555" .. (warnings[1] or "Parse failed.") .. "|r")
        return
    end

    ns.RegisterRoute(name, route)
    ns.Core:LoadRoute(name)

    local msg = ("|cff00ff00Imported '%s' - %d steps.|r"):format(name, #route.steps)
    msg = msg .. "\n|cff909090" .. route.source .. "|r"
    for _, w in ipairs(warnings) do
        msg = msg .. "\n|cffffff00" .. w .. "|r"
    end
    msg = msg .. "\n|cff909090This route lives in memory only. Use Save this as a route to keep it.|r"

    win.status:SetText(msg)
    if ns.UI then ns.UI:Refresh() end
    if ns.Panel then ns.Panel:Refresh() end
end
