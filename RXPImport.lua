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
-- expansion flavor tag) that gates the whole step (the block-level
-- condition). A line inside a step can carry its own trailing `<< Cond`
-- the same way - combined with the block-level condition (contradictions
-- drop the line; see ResolveLineFilter). `.goto Zone,x,y` sets travel
-- coordinates; multiple `.goto`s in one step become a waypoint path, the
-- last one is the final target. `.accept`/`.turnin`/`.complete` (quest ID
-- [,objective]) map directly to TuFFlevels' own step types.
-- `.trainer`/`.hs`/`.deathskip` map to trainer/hearth/death.
-- `.itemcount id,n` maps to an `item` step (done once you hold n+ of that
-- item), `.train spellID` maps to a `spell` step (done once known), and
-- `.maxlevel X` sets `skipIfLevel` on the current step rather than a type
-- of its own. `.target`, `.vendor`, `.link`, and bare `>>`/`+` text lines
-- carry no TuFFlevels step type of their own and are folded into the
-- step's `npc` field or `note` text instead. `--comment` is stripped
-- everywhere, exactly as RXPGuides' own loader strips it before parsing
-- anything else. A standalone `#season N` (N ~= 0) or `#hardcore` line
-- inside a step drops that whole step (Season of Discovery / hardcore-
-- permadeath content, out of scope for this addon's normal Classic Era/
-- Forever/Mainline targets); `#season 0`/`#softcore` are no-ops.
--
-- A step naming more than one distinct quest/item/spell (or a
-- `.trainer`/`.hs`/`.deathskip` after an already-typed action) splits into
-- multiple TuFFlevels steps instead of the later directive overwriting the
-- earlier one - see `StepForAction`. Each resulting step gets its own
-- resolved `class`/`classExclude`/`races` (a negated class condition like
-- `<< !Hunter` becomes `classExclude`, a list since one condition can name
-- several classes), and shares the block's own location, backfilling a
-- trailing `.goto` onto every step that split off before it. `npc` is
-- deliberately NOT carried across a split or backfilled - see the
-- `.target` handling's comment for why that turned out to misattribute a
-- later split's own NPC.
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
-- - `.collect` (item-count OR quest-accepted), `.fp`/`.fly` (flightpath),
--   `.skill` (profession/skill rank), `.zone`/`.zoneskip`, and the
--   `.isQuestComplete`/`.isQuestTurnedIn`/`.isOnQuest`/`.isQuestAvailable`
--   quest-state modifiers are NOT parsed yet - their exact attachment
--   rules (several are modifiers on the line above them, not standalone
--   steps) need a real guide sample to get right rather than guessed, so
--   they still fall through to the generic dot-command note below.

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
-- color/texture codes the same way. `|Tpath:size|t` is a decorative icon
-- (e.g. a chat-bubble glyph before "Talk to X") with no text content at
-- all - found live (2026-09-25) gluing a raw texture path onto every
-- accept step's name until this was added; drop it entirely rather than
-- leaving the path behind.
local function StripColorTokens(text)
    if not text then return text end
    text = text:gsub("|T[^|]*|t", "")
    -- RXPGuides commonly nests one colored phrase inside another (e.g.
    -- `|cRXP_WARN_Kill |cRXP_ENEMY_Mottled Boars|r. Loot them...|r`) - a
    -- single pass matches the OUTER opener against the FIRST |r it finds,
    -- which is the inner pair's closer, leaving the inner |c opener
    -- stranded and unstripped (confirmed live in Routes/Horde/Mulgore.lua's
    -- existing "Kill |cRXP_ENEMY_Plainstriders..." text, 2026-09-25).
    -- [^|]- can't cross into a nested |c, so each pass only ever resolves
    -- the innermost pair - repeat until a pass makes no more changes to
    -- peel outward one layer at a time.
    local changed = true
    while changed do
        local new = text:gsub("|c%u[%u_]*_([^|]-)|r", "%1")
        changed = (new ~= text)
        text = new
    end
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

-- `step.races` is compared against `Data:PlayerRace()`, which returns
-- WoW's own raceFile string (`UnitRace`'s 2nd return) - "Scourge" for
-- Undead, not the human-readable "Undead" this constant used to map to.
-- Confirmed live (2026-09-26, code review): every already-shipped route
-- that filters on this race already uses "Scourge" (e.g.
-- Routes/Horde/Mulgore.lua), so a fresh import mapping to "Undead" would
-- silently hide every such step from Undead players - StepApplies does an
-- exact string compare, "Undead" ~= "Scourge".
local RACE_TOKENS = {
    HUMAN = "Human", DWARF = "Dwarf", GNOME = "Gnome",
    NIGHTELF = "NightElf", DRAENEI = "Draenei", ORC = "Orc",
    TROLL = "Troll", TAUREN = "Tauren", UNDEAD = "Scourge",
    SCOURGE = "Scourge", BLOODELF = "BloodElf",
}

-- Every vanilla-Classic race for each faction, used to turn a negated race
-- condition into the complement race list rather than either dropping the
-- step or leaving it unfiltered - see the `neg`/RACE_TOKENS branch below.
-- Draenei/BloodElf are TBC+ and deliberately excluded (this parser targets
-- Classic-flavored guides; a Classic Era/Forever character is never one of
-- those races, so they'd never need to appear in a complement anyway).
local FACTION_RACES = {
    Horde = { "Orc", "Troll", "Tauren", "Scourge" },
    Alliance = { "Human", "Dwarf", "Gnome", "NightElf" },
}

-- One AND-group of space-separated tokens (an OR group, already split out
-- by EvalCondition, is passed in one at a time). `faction` (the guide's
-- own "<< Horde"/"<< Alliance" line, already parsed before any step is
-- reached) resolves a negated race into the complement race list within
-- that faction - see the `neg`/RACE_TOKENS branch below; pass nil if not
-- yet known. Returns class, races, outOfScope (drop the step/line
-- entirely), unhandled (kept a token it didn't recognize), classExclude (a
-- list of "everyone but these classes").
local function ClassifyTokens(tokens, faction)
    local class, races, outOfScope, unhandled, classExclude, negatedRaces
    for _, raw in ipairs(tokens) do
        local neg = raw:sub(1, 1) == "!"
        local tok = (neg and raw:sub(2) or raw):upper()
        if neg then
            if CLASS_TOKENS[tok] then
                -- "<< !Hunter" means "everyone except Hunter" - a real
                -- content gate (RXPGuides uses it for a fallback turn-in
                -- at a hub where one class already has its own earlier
                -- turn-in), not UI navigation. Model it with classExclude
                -- instead of dropping the whole step - confirmed live
                -- (2026-09-26): dropping it silently lost a real
                -- turn-in for every non-Hunter class in
                -- Routes/Horde/OrcTrollRXP.lua. A list, not a single class,
                -- because a real guide condition like "!Warrior !Rogue"
                -- excludes more than one class at once (confirmed live:
                -- 138 negated-class lines in one Durotar chapter alone) -
                -- a single-value field would keep only the last one and
                -- wrongly let the other excluded classes see the step.
                classExclude = classExclude or {}
                table.insert(classExclude, CLASS_TOKENS[tok])
            elseif tok == "SOD" or tok == "HARDCORE" then
                -- "!sod"/"!hardcore" is long-hand for "the normal branch"
                -- (double negative) - a no-op keep, same as SOFTCORE below,
                -- NOT out of scope. Confirmed live:
                -- Classic-Alliance-1-10_NightElf.lua pairs
                -- `.turnin 3119 << !sod` with `.turnin 77574 << sod` -
                -- treating the negation as out-of-scope too (this
                -- session's first pass at the SOD fix did exactly that)
                -- dropped BOTH branches, losing the real non-SoD turn-in
                -- entirely instead of just dropping the SoD one.
            elseif RACE_TOKENS[tok] then
                -- Resolved to the COMPLEMENT race list within the guide's
                -- own faction below (Core.lua's `races` filter is an OR
                -- list, not limited to one race), rather than dropped or
                -- left unfiltered. Confirmed live, two real, opposite-
                -- looking shapes that need the SAME fix:
                -- `step << !Undead` ("Get the Undercity flight path" in
                -- the shared Orc/Troll Durotar guide) was being dropped
                -- entirely instead of kept for Orc/Troll/Tauren; treating
                -- it as "unhandled" (kept unfiltered) instead - this
                -- session's first pass at this fix - shipped RXPGuides'
                -- own "you're reading the wrong guide" warning
                -- (`step << !Orc !Troll` / `step << !NightElf`) to exactly
                -- the races it's meant to exclude.
                negatedRaces = negatedRaces or {}
                table.insert(negatedRaces, RACE_TOKENS[tok])
            else
                -- Other negated conditions ("!Human" wrong-guide warnings)
                -- are RXPGuides UI navigation, not leveling content.
                outOfScope = true
            end
        elseif CLASS_TOKENS[tok] then
            class = CLASS_TOKENS[tok]
        elseif EXPANSION_TOKENS[tok] then
            outOfScope = true
        elseif tok == "CLASSIC" then
            -- explicit in-scope marker, nothing to record
        elseif tok == "SKIP" then
            -- RXPGuides' own "disabled step" marker (found live: 504 uses
            -- across the Classic guides) - not a class/race/expansion
            -- condition at all, so it used to fall through to "unhandled"
            -- and get imported unfiltered with a misleading "OR/complex
            -- condition" warning instead of being dropped like the
            -- author's own guide intends.
            outOfScope = true
        elseif tok == "SOD" or tok == "HARDCORE" then
            -- Season of Discovery runes / hardcore-permadeath-only content.
            -- This addon targets the normal Classic Era/Forever/Mainline
            -- rulesets, not SoD or hardcore, so a step gated on either is
            -- out of scope here - previously treated as an "explicit
            -- in-scope marker" alongside CLASSIC, which is how ~20
            -- unreachable SoD rune-training steps ended up surviving
            -- unfiltered in the shipped Routes/Horde/Mulgore.lua. NOTE:
            -- real guide files gate this with a standalone `#season N`/
            -- `#hardcore` line, not a `<<` token - see the `#`-directive
            -- handling below for the code path that actually fires in
            -- practice. This `<<`-token branch is kept for guides that do
            -- use it this way, but confirmed (2026-09-26) that it is NOT
            -- the common case.
            outOfScope = true
        elseif tok == "SOFTCORE" then
            -- The normal (non-permadeath) branch of a hardcore/softcore
            -- split - this addon's actual target, so keep it (no-op,
            -- same as CLASSIC).
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
    if negatedRaces then
        local factionRaces = faction and FACTION_RACES[faction]
        if factionRaces then
            local excluded = {}
            for _, r in ipairs(negatedRaces) do excluded[r] = true end
            local complement = {}
            for _, r in ipairs(factionRaces) do
                if not excluded[r] then table.insert(complement, r) end
            end
            if #complement > 0 then
                races = races or {}
                for _, r in ipairs(complement) do table.insert(races, r) end
            else
                -- Excludes every race in the faction - a contradiction
                -- (or a guide covering a faction FACTION_RACES doesn't
                -- know about), not something to guess at.
                unhandled = true
            end
        else
            -- Faction not yet known (the guide never declared "<< Horde"/
            -- "<< Alliance" before this condition) - can't compute a safe
            -- complement, so fall back to keep-and-flag rather than guess.
            unhandled = true
        end
    end
    return class, races, outOfScope, unhandled, classExclude
end

-- "Warlock tbc" or "Human/Dwarf/Gnome" -> class, races, outOfScope,
-- unhandled, classExclude. Multiple `/`-separated OR groups can't be
-- expressed with TuFFlevels' single class/races filter, so they're
-- reported unhandled and the step is kept unfiltered rather than dropped
-- or guessed at. `faction` is passed straight through to ClassifyTokens.
local function EvalCondition(condText, faction)
    if not condText or condText:match("^%s*$") then
        return nil, nil, false, false, nil
    end
    local groups = {}
    for group in condText:gmatch("[^/]+") do table.insert(groups, group) end
    if #groups > 1 then
        return nil, nil, false, true, nil
    end
    local tokens = {}
    for tok in groups[1]:gmatch("%S+") do table.insert(tokens, tok) end
    return ClassifyTokens(tokens, faction)
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

    -- Every step object produced from the CURRENT "step"/"step << Cond"
    -- block (including ones already split off and pushed into
    -- route.steps - see StepForAction below). Reset whenever a new "step"
    -- line starts. Lets a directive that appears late in the block (e.g. a
    -- trailing `.goto`/`.target`/`.maxlevel`, or `#sticky`/`#completewith
    -- next`) still reach every step the block produced, not just whichever
    -- one happens to be current when that line is read - confirmed live
    -- (2026-09-26): RXPGuides commonly lists all of a step's directives
    -- first and its location/level-gate/companion-flag last, so without
    -- this, splitting on the directives left every step but the final one
    -- with no coordinates at all.
    local curBlockSteps = {}

    -- The BLOCK's own condition, from "step << Cond" - captured once, kept
    -- separate from whatever a later LINE's own "<< Cond" resolves a given
    -- split step's class/classExclude/races to (see ResolveLineFilter and
    -- StepForAction below). Confirmed live (2026-09-26): using curStep's
    -- current (possibly line-narrowed) class as the contradiction-check/
    -- carry basis let one line's filter leak onto a later, differently- or
    -- un-conditioned directive in the same block.
    local blockClass, blockClassExclude, blockRaces

    -- `#sticky`/`#completewith next`/`#optional` and `.maxlevel` gate the
    -- WHOLE block (see the `#`/`.maxlevel` handling below, which still
    -- also calls `ApplyToBlock` for steps that already exist at that
    -- point). Tracked here too so `StepForAction`'s `carry` can pass them
    -- to a split that happens LATER, after the tag/directive was already
    -- read - confirmed live (2026-09-26): `ApplyToBlock` alone only ever
    -- reaches steps that exist AT THE MOMENT the tag/directive is
    -- processed, and real guides almost always put `#optional`/`.maxlevel`
    -- FIRST in the block, before the actions that go on to split - so an
    -- "Equip X"/"buy N of Y" item-gate split off from a `#optional`
    -- block's later `.itemcount` line was shipping as non-optional and
    -- could block Reconcile forever for a player who never satisfies it.
    local blockInfoOnly, blockSkipIfLevel

    -- Every distinct `.target` name seen in the current block, and how
    -- many distinct ones - used by FinishBlock below. `npc` is deliberately
    -- not carried across a split or backfilled AS EACH `.target` LINE IS
    -- READ (see the `.target` handling's own comment for why that
    -- misattributes NPCs when a block has more than one), but the dominant
    -- real shape is the OPPOSITE problem: a single `.target` at the very
    -- end of a multi-action block, meaning every split step but the last
    -- ends up with no `npc` at all - confirmed live: 40-55% of accept/
    -- turnin steps across the Durotar/NightElf guides. FinishBlock fills
    -- every npc-less step in the block with the single target name once
    -- the whole block is known to have had only one.
    local blockTargetSet, blockTargetCount, blockTargetName

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
            table.insert(curBlockSteps, curStep)
        end
        return curStep
    end

    -- Apply a shared-context field to every step this block has produced
    -- so far. `overwrite = false` only fills in steps that don't already
    -- have their own value for that field (used for zone/x/y, so an
    -- earlier split step that already got its own `.goto` isn't clobbered
    -- by a later one meant for a different split step); `overwrite = true`
    -- always sets it (used for skipIfLevel/_infoOnly, which gate the whole
    -- visit regardless of which directive line they appeared next to).
    -- NOT used for `npc` - see the `.target` handling below for why a
    -- block-wide fill-if-missing turned out to be unsafe for that field
    -- specifically.
    local function ApplyToBlock(field, value, overwrite)
        for _, s in ipairs(curBlockSteps) do
            if overwrite or s[field] == nil then
                s[field] = value
            end
        end
    end

    -- Called right before a block is abandoned (a new "step"/"step << Cond"
    -- line starts, or the guide text ends). If the whole block only ever
    -- named ONE distinct NPC via `.target`, fill it onto every step in the
    -- block that doesn't already have its own `npc` - see
    -- `blockTargetSet`'s header comment. A block with zero or several
    -- distinct targets is left alone (no safe single answer).
    local function FinishBlock()
        if blockTargetCount == 1 then
            for _, s in ipairs(curBlockSteps) do
                if not s.npc then s.npc = blockTargetName end
            end
        end
    end

    -- Merge two classExclude lists (dedup), for combining a block-level
    -- "<< !X !Y" with a line-level "<< !Z" on the same directive.
    local function MergeExclude(a, b)
        if not a then return b end
        if not b then return a end
        local seen, merged = {}, {}
        for _, c in ipairs(a) do
            if not seen[c] then seen[c] = true; table.insert(merged, c) end
        end
        for _, c in ipairs(b) do
            if not seen[c] then seen[c] = true; table.insert(merged, c) end
        end
        return merged
    end

    -- Order-independent comparison key for a classExclude list (or races,
    -- which is shaped the same way) - used to detect when a line's own
    -- resolved filter actually differs from what a step already has.
    local function ListKey(list)
        if not list then return "" end
        local sorted = {}
        for _, c in ipairs(list) do table.insert(sorted, c) end
        table.sort(sorted)
        return table.concat(sorted, ",")
    end

    -- Combine this LINE's own "<< Cond" (if any) with the BLOCK's "step <<
    -- Cond" into the effective class/classExclude/races for one specific
    -- directive. Returns (nil, nil, nil, true) on a genuine contradiction
    -- (e.g. block says Warrior, line says Mage; or block excludes Shaman
    -- and the line requires Shaman) - dropping the line rather than
    -- guessing which condition should win, matching this parser's existing
    -- "keep and flag, don't guess" doctrine for anything else it can't
    -- confidently resolve.
    local function ResolveLineFilter(lineClass, lineClassExclude, lineRaces)
        if lineClass and blockClass and lineClass ~= blockClass then
            return nil, nil, nil, true
        end
        local class = lineClass or blockClass
        local classExclude = MergeExclude(blockClassExclude, lineClassExclude)
        if class and classExclude then
            for _, c in ipairs(classExclude) do
                if c == class then return nil, nil, nil, true end
            end
        end
        -- Both lists can legitimately hold more than one race now (a
        -- negated-race condition resolves to the faction's complement -
        -- see ClassifyTokens/FACTION_RACES), so "different" means no
        -- overlap at all, and the effective races when both are set is
        -- their intersection (both conditions apply at once), not either
        -- one alone.
        local races
        if lineRaces and blockRaces then
            local blockSet = {}
            for _, r in ipairs(blockRaces) do blockSet[r] = true end
            local intersect = {}
            for _, r in ipairs(lineRaces) do
                if blockSet[r] then table.insert(intersect, r) end
            end
            if #intersect == 0 then
                return nil, nil, nil, true
            end
            races = intersect
        else
            races = lineRaces or blockRaces
        end
        return class, classExclude, races, false
    end

    -- A guide step that accepts/turns in/completes more than one distinct
    -- quest (or buys/trains more than one distinct item/spell, or visits a
    -- trainer/hearth/death-skip after an already-typed action) can't be
    -- represented by TuFFlevels' one-type-one-id-per-step schema. Split
    -- into a fresh step carrying the BLOCK's own class/race filters and
    -- the current location forward, instead of overwriting the previous
    -- directive - confirmed live (2026-09-26/27): a step naming two quest
    -- IDs kept only the last one, silently losing the first (Routes/Horde/
    -- OrcTrollRXP.lua chapter 2, ~29 of 63 distinct IDs), and a `.trainer`/
    -- `.hs`/`.deathskip` line landing after a real turn-in silently
    -- replaced it with type="trainer"/"hearth"/"death" instead of getting
    -- its own step.
    --
    -- `extra` is the `complete` step's objective number, if any - two
    -- `.complete` directives for the SAME quest but DIFFERENT objectives
    -- are two distinct real progress checkpoints, not a repeat, and must
    -- split too instead of the second overwriting the first's objective.
    --
    -- `effClass`/`effClassExclude`/`effRaces` are this SPECIFIC directive's
    -- already-resolved filter (from ResolveLineFilter) - even when the
    -- type+id (or trainer/hearth/death) match what's already on curStep,
    -- a DIFFERENT resolved filter still forces a split. Confirmed live
    -- (2026-09-26): RXPGuides' common "<< Shaman" / "<< !Shaman" reward-
    -- choice pair for the SAME quest ID was landing both conditions on one
    -- step (class=SHAMAN, classExclude={SHAMAN}), which `Core.lua`'s
    -- `StepApplies` rejects for every class - silently dropping the turn-in
    -- for everyone instead of giving each condition its own step.
    local ACTION_KEY = {
        accept = "quest", turnin = "quest", complete = "quest",
        item = "itemID", spell = "spellID",
        trainer = "_meta", hearth = "_meta", death = "_meta",
    }
    local function StepForAction(ty, id, extra, effClass, effClassExclude, effRaces)
        local key = ACTION_KEY[ty]
        local same = curStep and curStep.type == ty and curStep[key] == id
            and (ty ~= "complete" or curStep.objective == extra)
        if same and (effClass ~= curStep.class
            or ListKey(effClassExclude) ~= ListKey(curStep.classExclude)
            or ListKey(effRaces) ~= ListKey(curStep.races)) then
            same = false
        end
        if curStep and curStep.type and ACTION_KEY[curStep.type] and not same then
            local carry = {
                class = blockClass, races = blockRaces, classExclude = blockClassExclude,
                zone = curStep.zone, x = curStep.x, y = curStep.y,
                _infoOnly = blockInfoOnly, skipIfLevel = blockSkipIfLevel,
            }
            FinishStep()
            curStep = EnsureStep()
            for k, v in pairs(carry) do curStep[k] = v end
        end
        local step = EnsureStep()
        step.class = effClass
        step.classExclude = effClassExclude
        if effRaces then step.races = effRaces end
        return step
    end

    -- `#season N` (N ~= 0) / `#hardcore` on their own, standalone line
    -- always drop the step - see the `#`-tag handling below. When one
    -- carries its own trailing "<< Cond" instead (real example, Durotar ch6:
    -- `#season 2 << Warrior` inside a `step << Warlock/Hunter/Rogue/Priest/
    -- Warrior` block, meaning "SoD-only for Warriors, normal for the other
    -- four"), this parser has no per-class-at-PARSE-time way to skip it for
    -- only some of the classes a step already applies to - confirmed live
    -- (2026-09-26): unconditionally skipping dropped the step for all five
    -- classes, not just Warriors. Keeping it unfiltered by season (and
    -- warning) risks an unreachable SoD step surviving for one class
    -- instead of silently losing a real step for four - the safer default,
    -- matching this parser's "keep and flag, don't guess" doctrine.
    local function SeasonOrHardcoreCond(tag, val)
        if tag == "season" then
            local seasonPart, cond = val:match("^(%S+)%s*<<%s*(%S.-)%s*$")
            if not seasonPart then seasonPart = val end
            local season = tonumber(seasonPart:match("^(%d+)"))
            return (season and season ~= 0), cond
        elseif tag == "hardcore" then
            local cond = val:match("^<<%s*(%S.-)%s*$")
            return true, cond
        end
        return false, nil
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
                elseif tag == "season" or tag == "hardcore" then
                    -- A guide-WIDE season/hardcore tag (before the first
                    -- "step" line) means the whole guide is out of scope,
                    -- not just one step - can't be dropped automatically
                    -- (this function parses one guide's text at a time and
                    -- has already committed to returning a route), so warn
                    -- instead of silently importing SoD/hardcore-only
                    -- content.
                    local outOfScope = SeasonOrHardcoreCond(tag, val)
                    if outOfScope then
                        table.insert(warnings, ("This guide is tagged '#%s %s' for its "
                            .. "ENTIRE content, not just one step - this addon targets "
                            .. "normal Classic Era/Forever/Mainline, not Season of "
                            .. "Discovery/hardcore rulesets. Review before using."):format(tag, val))
                    end
                end

            elseif not sawStep and line:match("^<<") then
                local cond = line:match("^<<%s*(.-)%s*$")
                local fac = cond and cond:match("^(%a+)")
                fac = fac and fac:upper()
                if fac == "ALLIANCE" then route.faction = "Alliance"
                elseif fac == "HORDE" then route.faction = "Horde" end

            elseif line == "step" or line:match("^step%s*<<") then
                FinishStep()
                FinishBlock()
                curBlockSteps = {}
                blockTargetSet, blockTargetCount, blockTargetName = {}, 0, nil
                blockInfoOnly, blockSkipIfLevel = nil, nil
                sawStep = true
                local cond = line:match("^step%s*<<%s*(.-)%s*$")
                local class, races, outOfScope, unhandled, classExclude = EvalCondition(cond, route.faction)
                blockClass, blockClassExclude, blockRaces = nil, nil, nil
                if outOfScope then
                    curStep = { _skip = true }
                else
                    curStep = EnsureStep()
                    if class then curStep.class = class; blockClass = class end
                    if classExclude then curStep.classExclude = classExclude; blockClassExclude = classExclude end
                    if races then curStep.races = races; blockRaces = races end
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
                if tag == "sticky" or (tag == "completewith" and val == "next") or tag == "optional" then
                    -- Gates the whole visit (a "companion step" that never
                    -- blocks Reconcile), not just whichever split step
                    -- happens to be current - see StepForAction/
                    -- ApplyToBlock's header comment. `#optional` (found
                    -- live: an "Equip X"/"buy N of Y" item-gate the player
                    -- may never satisfy, e.g. a Rogue who never picks up a
                    -- specific throwing weapon) was previously unrecognized
                    -- and fell through to nothing, leaving the resulting
                    -- `item` step non-optional and able to block Reconcile
                    -- forever for a player who skips that gear choice.
                    ApplyToBlock("_infoOnly", true, true)
                    blockInfoOnly = true
                elseif tag == "season" or tag == "hardcore" then
                    -- Real guide files gate Season-of-Discovery-only/
                    -- hardcore-only steps with a standalone `#season N`/
                    -- `#hardcore` line (N=2 seen live), not the `<< SOD`/
                    -- `<< HARDCORE` token ClassifyTokens also handles -
                    -- confirmed (2026-09-26) via a real chapter parse: the
                    -- `<<`-token branch alone left every SoD rune step in
                    -- place. `#season 0`/no condition on `#hardcore` is the
                    -- unconditional drop case; see SeasonOrHardcoreCond's
                    -- header comment for the conditioned case.
                    local outOfScope, cond = SeasonOrHardcoreCond(tag, val)
                    if outOfScope then
                        if cond then
                            table.insert(warnings, ("'#%s %s' has a class/race condition "
                                .. "this parser can't apply per-class at parse time - kept "
                                .. "unfiltered by season/hardcore rather than risk dropping "
                                .. "it for every class the step applies to."):format(tag, val))
                        else
                            step._skip = true
                        end
                    end
                elseif tag == "softcore" then
                    -- The normal (non-permadeath) branch - keep, no-op.
                end

            else
                local body, lineCond = line:match("^(.-)%s*<<%s*(%S.-)%s*$")
                if not body then body = line end
                local effClass, effClassExclude, effRaces = blockClass, blockClassExclude, blockRaces
                if lineCond then
                    local lineClass, lineRaces, outOfScope, _, lineClassExclude = EvalCondition(lineCond, route.faction)
                    if outOfScope then
                        body = nil
                    else
                        local drop
                        effClass, effClassExclude, effRaces, drop = ResolveLineFilter(lineClass, lineClassExclude, lineRaces)
                        if drop then body = nil end
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
                                -- Backfill any earlier split step in this
                                -- block that has no location of its own yet
                                -- - see ApplyToBlock's header comment.
                                for _, s in ipairs(curBlockSteps) do
                                    if s ~= step and not s.zone then
                                        s.zone, s.x, s.y = step.zone, step.x, step.y
                                    end
                                end
                            end

                        elseif cmd == "accept" or cmd == "turnin" then
                            local id = tonumber(argText:match("^(%-?%d+)"))
                            if id then
                                id = math.abs(id)
                                step = StepForAction(cmd, id, nil, effClass, effClassExclude, effRaces)
                                step.type = cmd
                                step.quest = id
                                step.name = step.name or annotation
                            end

                        elseif cmd == "complete" then
                            local id, obj = argText:match("^(%-?%d+)%s*,%s*(%d+)")
                            if not id then id = argText:match("^(%-?%d+)") end
                            id = tonumber(id)
                            if id then
                                local absID = math.abs(id)
                                local objNum = obj and tonumber(obj) or nil
                                step = StepForAction("complete", absID, objNum, effClass, effClassExclude, effRaces)
                                step.type = "complete"
                                step.quest = absID
                                if objNum then step.objective = objNum end
                                if id < 0 then step.optional = true end
                                step.name = step.name or annotation
                            end

                        elseif cmd == "itemcount" then
                            local id, n = argText:match("^(%d+)%s*,%s*(%d+)")
                            id = tonumber(id)
                            if id then
                                step = StepForAction("item", id, nil, effClass, effClassExclude, effRaces)
                                step.type = "item"
                                step.itemID = id
                                step.count = tonumber(n) or 1
                                step.name = step.name or annotation
                            end

                        elseif cmd == "train" then
                            local id, flags = argText:match("^(%d+)%s*,%s*(%d+)")
                            if not id then id = argText:match("^(%d+)") end
                            id = tonumber(id)
                            flags = tonumber(flags)
                            if id and flags and flags % 2 == 1 then
                                -- RXPGuides' own flags bit 0 (an odd value)
                                -- is "textOnly" - this line is a CONDITION,
                                -- not a training action, per RXPGuides'
                                -- functions.lua (addon.functions.train).
                                -- Treated as a real `spell` step before
                                -- this fix, it became a blocking, nameless
                                -- step for a spell the player may have
                                -- learned long ago with no way to complete
                                -- it early - confirmed live: 15 such steps
                                -- across the Durotar/NightElf guides, e.g.
                                -- Innkeeper Grosk's Rogue/Priest/Warlock/
                                -- Shaman/Warrior ability gates. Keep as a
                                -- note instead. Bit 1 ("reverse") flips
                                -- which direction the check runs
                                -- (`IsPlayerSpell(id) ~= reverse` in
                                -- RXPGuides' own runtime, functions.lua's
                                -- `addon.functions.train`) - get the
                                -- wording right rather than risk saying the
                                -- exact opposite of what the guide means.
                                -- Verified directly against that source
                                -- (2026-09-26, two rounds of code review -
                                -- the first guessed this branch backwards
                                -- for real flags=1 data, e.g. "Tame a
                                -- Venomtail Scorpid" / `.train 16828,1`;
                                -- re-reading functions.lua settled it:
                                -- flags=1 has the reverse bit CLEAR, so it
                                -- skips once you already know the spell,
                                -- matching the non-reverse branch below).
                                if flags % 4 >= 2 then
                                    table.insert(step._notes,
                                        ("Skip this step if you don't already know spell %d"):format(id))
                                else
                                    table.insert(step._notes,
                                        ("Skip this step if you already know spell %d"):format(id))
                                end
                            elseif id then
                                step = StepForAction("spell", id, nil, effClass, effClassExclude, effRaces)
                                step.type = "spell"
                                step.spellID = id
                                step.name = step.name or annotation
                            end

                        elseif cmd == "maxlevel" then
                            local lvl = tonumber(argText:match("^(%d+)"))
                            if lvl then
                                ApplyToBlock("skipIfLevel", lvl, true)
                                blockSkipIfLevel = lvl
                            end

                        elseif cmd == "xp" and argText:match("^%d+$") and not step.type then
                            -- A bare ".xp N" (no operator, no +/-/. partial-XP
                            -- modifier, no comma-separated gate arg - just a
                            -- plain level number) means "grind to level N"
                            -- with no partial-XP target, which maps directly
                            -- onto TuFFlevels' xp step (pct = 0 is satisfied
                            -- the instant the player reaches that level - see
                            -- Core.lua's IsStepDone for type "xp"). A modified
                            -- form like ".xp 3+325" (325 raw XP into level 3)
                            -- or ".xp <4,1" (a gate on another step, not a
                            -- step of its own) would need Classic's per-level
                            -- XP table to convert an absolute XP amount into
                            -- TuFFlevels' 0-100 xp.pct - not attempted here,
                            -- so those still fall through to the plain-note
                            -- branch below exactly as before (confirmed live,
                            -- 2026-09-26: a bare ".xp N" step never auto-
                            -- advanced even after the player was already past
                            -- level N, since a plain `note` step has no
                            -- detectable condition and always needs a manual
                            -- Next click).
                            --
                            -- `not step.type` guards against a real guide
                            -- shape: a step already typed by an earlier
                            -- `.accept`/`.turnin`/`.complete`/etc. directive,
                            -- with a trailing `.xp N` grind hint on its own
                            -- line below. Without this guard the xp branch
                            -- would win (directives are "last one sets the
                            -- type" elsewhere in this parser) and silently
                            -- turn a real turn-in/accept step into an inert
                            -- xp-gate, losing the quest action entirely -
                            -- caught in code review, 2026-09-26, before any
                            -- shipped route was regenerated through this
                            -- path. `.xp` gating an existing typed step stays
                            -- a plain note the same as before this change.
                            local lvl = tonumber(argText)
                            step.type = "xp"
                            step.xp = { level = lvl, pct = 0 }
                            step.name = step.name or annotation or ("Grind to level " .. lvl)

                        elseif cmd == "trainer" then
                            -- Goes through StepForAction (finding this
                            -- session, 2026-09-26): previously this
                            -- unconditionally overwrote step.type, so a
                            -- `.trainer`/`.hs`/`.deathskip` line landing
                            -- after a real accept/turnin/complete/item/
                            -- spell action on the same step silently
                            -- replaced that action instead of getting its
                            -- own step - confirmed live in
                            -- Classic-Alliance-1-10_NightElf.lua's Shanda
                            -- block, where a `.trainer` line right after a
                            -- (correctly-kept) `.turnin << !sod` erased the
                            -- turn-in entirely.
                            step = StepForAction("trainer", true, nil, effClass, effClassExclude, effRaces)
                            step.type = "trainer"
                            step.name = step.name or annotation or "Visit trainer"

                        elseif cmd == "hs" then
                            step = StepForAction("hearth", true, nil, effClass, effClassExclude, effRaces)
                            step.type = "hearth"
                            local label = StripColorTokens(argText)
                            step.name = step.name or (label ~= "" and label) or "Hearth"

                        elseif cmd == "deathskip" then
                            step = StepForAction("death", true, nil, effClass, effClassExclude, effRaces)
                            step.type = "death"
                            local label = StripColorTokens(argText)
                            step.name = step.name or (label ~= "" and label) or "Die and release"

                        elseif cmd == "target" then
                            local nm = argText:match("^%+?%s*(.-)$")
                            if nm and nm ~= "" then
                                -- Deliberately NOT carried across a split
                                -- (StepForAction's `carry` table omits
                                -- `npc`) and NOT block-wide backfilled AS
                                -- EACH `.target` LINE IS READ - only ever
                                -- set on the step actually current when
                                -- this line is read. Confirmed live
                                -- (2026-09-26): carrying/backfilling npc
                                -- per-line caused two different real
                                -- misattributions - a later split's own
                                -- `.target` line could never override a
                                -- carried-forward earlier NPC (the `or`
                                -- below only fires when npc is still nil),
                                -- and a per-line backfill assigned a LATER
                                -- target's NPC to an EARLIER, already-
                                -- resolved split that belonged to a
                                -- different quest-giver entirely ("Talk to
                                -- Gadrin, Vornal and Vel'rin" turning into
                                -- three copies of "Master Gadrin"; a
                                -- Warrior's Battle Shout train step getting
                                -- the Shaman trainer's name).
                                --
                                -- FinishBlock (called once the whole block
                                -- is done) fills any STILL-npc-less step
                                -- with this name, but ONLY if the block
                                -- named exactly one distinct NPC overall -
                                -- covers the dominant real shape (a single
                                -- `.target` at the very end of a multi-
                                -- action block) without the per-line
                                -- backfill's misattribution risk. A block
                                -- with two or more distinct targets, or
                                -- none at all, leaves any step with no
                                -- `.target` of its own simply npc-less -
                                -- Marker.lua/Arrow.lua already fall back to
                                -- zone/x/y alone for those.
                                nm = StripColorTokens(nm)
                                step.npc = step.npc or nm
                                blockTargetSet = blockTargetSet or {}
                                if not blockTargetSet[nm] then
                                    blockTargetSet[nm] = true
                                    blockTargetCount = (blockTargetCount or 0) + 1
                                    blockTargetName = nm
                                end
                            end

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
    FinishBlock()

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

    -- Collapse exact-duplicate ADJACENT steps. RXPGuides' OR-condition
    -- branches (e.g. `<< Hunter/Warrior`, or a `#hardcore`/`#softcore`
    -- split this parser can't fully model) commonly produce two copies of
    -- the same directive right next to each other; every chapter of
    -- Routes/Horde/OrcTrollRXP.lua needed this done by hand (2026-09-26/27)
    -- before it was safe to ship - do it here automatically so future
    -- imports don't repeat that manual pass.
    --
    -- Deliberately NOT chapter-wide: a real chapter parse (2026-09-26)
    -- showed a whole-route dedup collapsing genuinely different steps that
    -- happened to share a key - a Troll-only and an Orc-only copy of the
    -- same "Talk to Trayexir" turn-in (fixed below by adding `races` to the
    -- key, but a far-apart false match on some other field is still
    -- possible with a global scan) and two different hearth-to-different-
    -- inn steps (whose default name/no-coords shape makes them look
    -- identical by every field this key can see) into one, silently
    -- dropping the second inn. Scoping to adjacent pairs only, and never
    -- deduping coordless hearth/death/trainer steps at all, keeps the
    -- common real case (an immediately-repeated OR-branch) covered without
    -- either failure mode.
    do
        local NEVER_DEDUP_TYPES = { hearth = true, death = true, trainer = true }
        local function StepKey(s)
            local exKey = s.classExclude and table.concat(s.classExclude, ",") or ""
            local racesKey = s.races and table.concat(s.races, ",") or ""
            local pathKey = ""
            if s.path then
                local parts = {}
                for _, wp in ipairs(s.path) do
                    table.insert(parts, ("%s,%s,%s"):format(tostring(wp.zone), tostring(wp.x), tostring(wp.y)))
                end
                pathKey = table.concat(parts, ";")
            end
            return table.concat({
                tostring(s.type), tostring(s.quest), tostring(s.itemID), tostring(s.spellID),
                tostring(s.class), exKey, racesKey, tostring(s.name), tostring(s.note),
                tostring(s.zone), tostring(s.x), tostring(s.y), tostring(s.npc),
                tostring(s.optional), tostring(s.objective), tostring(s.count),
                tostring(s.skipIfLevel), pathKey,
            }, "|")
        end
        local deduped = {}
        local prevKey
        for _, s in ipairs(route.steps) do
            local key = (not NEVER_DEDUP_TYPES[s.type]) and StepKey(s) or nil
            if not (key and key == prevKey) then
                table.insert(deduped, s)
            end
            prevKey = key
        end
        route.steps = deduped
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
