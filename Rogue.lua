-- TuFFlevels / Rogue.lua
--
-- Rogue-only extras: what you train and when, what to hold, when grinding
-- beats questing.
--
-- HOW THE TRAINING TABLE IS BUILT
--
-- I did not hand-write a table of every rogue ability rank and its level,
-- because getting that subtly wrong is worse than not having it. Instead
-- the addon watches what you actually learn and records the level you
-- learned it at. Same approach as the route recorder: the client already
-- knows, so let it tell us.
--
-- A handful of well-known unlocks are seeded so the tab isn't empty on a
-- fresh character. Everything seeded is marked, and anything the client
-- reports overwrites it.

local ADDON, ns = ...
local Compat = ns.Compat
local Theme = ns.Theme

local Rogue = {}
ns.Rogue = Rogue

function Rogue:IsRogue()
    local _, class = UnitClass("player")
    return class == "ROGUE"
end

--------------------------------------------------------------------------
-- Seeded unlocks
--------------------------------------------------------------------------

-- Milestones worth planning a trainer trip around. Kept deliberately
-- short - these are the ones that change how you play, not every rank.
Rogue.seeded = {
    { level = 10, what = "Dual Wield + Poisons",
      note = "The big one. Dual wield changes your damage completely, and poisons open up. Do not skip this trainer visit." },
    { level = 10, what = "Sap",
      note = "Lets you take single mobs out of a pack. Huge for solo pulls." },
    { level = 16, what = "Sprint",
      note = "Escapes and travel time. Pays for itself while levelling." },
    { level = 20, what = "Blade Flurry / spec power spike",
      note = "Talents start compounding here. Worth a respec look if yours is scattered." },
    { level = 22, what = "Vanish",
      note = "Turns deaths into escapes. Softcore or not, corpse runs cost more time than anything." },
    { level = 30, what = "Weapon specialization tier",
      note = "Classic Era only - pick your weapon type and commit. Gone in Forever, replaced by Hack and Slash." },
    { level = 40, what = "Mount",
      note = "Single biggest levelling speed increase in the game. Bank gold for it from the 30s." },
}

-- Community-sourced trainer spend/skip guidance (not independently
-- verified - source: the "RogueAbilities" tab of a community "Rogue
-- Master Sheet - Horde" Google Sheet, essential/situational/DO_NOT_TAKE
-- flags per ability rank). Deliberately condensed rather than
-- transcribed rank-by-rank, same reasoning as Rogue.seeded above: a
-- full every-rank table is more likely to be silently wrong somewhere
-- than a short summary is.
Rogue.trainingNote =
    "Community-sourced spend/skip list, not independently verified - " ..
    "cross-check before trusting it blindly.\n\n" ..
    "Worth training every rank as it becomes available: Sinister Strike, " ..
    "Eviscerate, Slice and Dice, Kidney Shot, Cheap Shot, Ambush rank 1, " ..
    "Vanish, Blind, Distract, Instant Poison and Crippling Poison.\n\n" ..
    "Skip entirely while levelling - pure gold sinks unless your build " ..
    "specifically calls for them: Garrote, Expose Armor, Mind-numbing " ..
    "Poison, Deadly Poison, Wound Poison, and any rank past 1 of Feint, " ..
    "Gouge, Kick, Sap or Rupture.\n\n" ..
    "Hemorrhage is talent-specific - only worth training if you've actually " ..
    "spent the Subtlety point for it."

--------------------------------------------------------------------------
-- Learned-ability tracking
--------------------------------------------------------------------------

function Rogue:Record(spellName, level)
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.rogueLearned = db.rogueLearned or {}

    if not db.rogueLearned[spellName] then
        db.rogueLearned[spellName] = level
    end
end

function Rogue:Learned()
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    return db.rogueLearned or {}
end

--------------------------------------------------------------------------
-- Weapons
--------------------------------------------------------------------------

-- What a Horde rogue should actually be holding, and why. The Classic and
-- Forever answers differ enough that guessing one would mislead.
Rogue.weapons = {
    {
        head = "What you can use",
        body = "Classic Era: daggers, one-hand swords, one-hand maces, fist weapons, " ..
               "plus bows, crossbows, guns and thrown. |cffb31f26No axes.|r\n\n" ..
               "Forever: |cff73cc8cone-hand axes work|r, alongside swords, maces, daggers " ..
               "and fist weapons. Confirmed in game, not just demo reports - a rogue can " ..
               "equip and swing a one-hand axe.",
    },
    {
        head = "Orc",
        body = "Classic Era: Axe Specialization does |cffb31f26nothing|r for you - " ..
               "rogues can't equip axes there. Your racial value is Blood Fury (attack " ..
               "power burst) and Hardiness (stun resist).\n\n" ..
               "Forever: axes work for rogues, so |cff73cc8cAxe Specialization is live|r. " ..
               "Reported to grant crit rather than weapon skill. That makes Orc rogue a " ..
               "real weapon-type choice instead of a wasted racial - hold an axe when the " ..
               "damage is comparable, because the racial is free crit on top.",
    },
    {
        head = "Troll",
        body = "Berserking is a haste cooldown and scales with how hurt you are - " ..
               "genuinely strong while levelling, where you're often low.\n\n" ..
               "Throwing Weapon Specialization helps your ranged slot. Minor, but " ..
               "thrown is what you'll pull with.",
    },
    {
        head = "While levelling",
        body = "Slow main hand, fast off hand. Sinister Strike and your poisons both " ..
               "care about the main hand's damage, and a fast off hand applies poison " ..
               "more often.\n\n" ..
               "Base damage beats speed if the number is genuinely higher. Don't hold " ..
               "a slow weapon that hits for less.\n\n" ..
               "Orc on Forever: when two one-handers are close, take the axe. The racial " ..
               "crit tips it.",
    },
    {
        head = "Talent note",
        body = "Classic Era: the weapon specialization talents reward committing to one " ..
               "weapon type. Pick before you spend.\n\n" ..
               "Forever: Sword, Mace, Dagger and Fist specializations are |cffb31f26gone|r. " ..
               "Combat's Hack and Slash replaces all of them with per-weapon bonuses, and " ..
               "Mutilate moves into Assassination. Any Classic talent guide you read will " ..
               "be wrong there.",
    },
}

--------------------------------------------------------------------------
-- Weapon upgrades worth routing around
--------------------------------------------------------------------------

-- Horde-obtainable only. Alliance-side rewards are left out rather than
-- listed and caveated.
--
-- verdict says how the item is acquired and whether that is worth the effort.
-- It is the same scale the offline DPS model (tools/tuffweights, Classic Era
-- rules) uses for every weapon, armor piece, ring and cloak: how much DPS the
-- item adds over the best gear you could plan on that is easier to get, and
-- how you get it (vendor, solo quest, group quest, dungeon, drop).
--   vendor        - buy it
--   solo          - a quest you can do alone
--   group_worth   - a group quest whose gain justifies the extra time
--   group_formed  - a group quest, only if a group is already formed
--   dungeon_very  - a dungeon run that clearly pays off
--   dungeon_kinda - a dungeon run that pays off modestly
--   dungeon_not   - a dungeon item too small or too unlikely to run for
--   crafted       - needs a profession you already have
--   open_drop     - open-world drop: use it if it drops, never farm it
--   world_drop    - random world drop: luck only
--   not_worth     - adds under 1%
Rogue.verdicts = {
    { key = "vendor",        title = "Vendor: pick it up" },
    { key = "solo",          title = "Solo quest: do it" },
    { key = "group_worth",   title = "Group quest: worth the extra time" },
    { key = "group_formed",  title = "Group quest: only if a group is already formed" },
    { key = "dungeon_very",  title = "Dungeon: very worth it" },
    { key = "dungeon_kinda", title = "Dungeon: kinda worth it" },
    { key = "dungeon_not",   title = "Dungeon: not worth it" },
    { key = "crafted",       title = "Crafted: if you already have the profession" },
    { key = "open_drop",     title = "Open-world drop: use it if it drops, never farm it" },
    { key = "world_drop",    title = "World drop: luck only, never plan around it" },
    { key = "not_worth",     title = "Not worth it" },
}

-- Verdicts that stay quiet on level-up and in the current-level highlight.
Rogue.quietVerdicts = { dungeon_not = true, not_worth = true }

-- Gains are the model's mean over the level window (peak in brackets) versus
-- the best easier gear, best across builds. The baseline is thin below level
-- 25, so early gains are overstated.
Rogue.upgrades = {
    -- solo
    { verdict = "solo", level = 4,  item = "Jagged Dagger",
      how = "Quest chain starting with Report to Orgnil, Durotar (Skull Rock)",
      note = "On the normal levelling path anyway. Needs roughly level 8 to actually solo, so take the chain early and finish it later. Below the model's level-10 floor, so its gain is not measured." },
    { verdict = "solo", level = 10, item = "Blade of Cunning",
      how = "Rogue class quest at 10",
      note = "You do the class quest regardless. Only about +1% at 10: level with the other quest weapons, not a big jump." },
    { verdict = "solo", level = 35, item = "Tok'kar's Murloc Shanker",
      how = "Threat From the Sea, Swamp of Sorrows",
      note = "About +3% for levels 35-43 (up to +4.5%) once the other vendor and quest weapons are counted. A 5-quest chain." },

    -- dungeon_very
    { verdict = "dungeon_very", level = 15, item = "Wingblade",
      how = "Leaders of the Fang, Wailing Caverns",
      note = "Largest jump on the list: about +14% for levels 11-28 (peak +23%). A sword, at the end of a 7-quest chain, and a group dungeon." },
    { verdict = "dungeon_very", level = 21, item = "Outlaw Sabre",
      how = "Baron Aquanis, Blackfathom Deeps (turn in in Ashenvale)",
      note = "About +22% for levels 21-29 (peak +27%). Elite kill, bring a group." },
    { verdict = "dungeon_very", level = 39, item = "Vanquisher's Sword",
      how = "Bring the Light / Bring the End, Razorfen Downs",
      note = "About +5% for levels 37-44, peaking near +10%. A sword, which matters - see the spec note." },

    -- dungeon_kinda
    { verdict = "dungeon_kinda", level = 33, item = "Sword of Omen",
      how = "Into The Scarlet Monastery",
      note = "About +4% for levels 33-44 (peak +8%). A sword, so it keeps Sword Specialization." },
    { verdict = "dungeon_kinda", level = 45, item = "Thrash Blade",
      how = "Corruption of Earth and Seed, Maraudon",
      note = "Extra-attack proc. About +3% for levels 45-59." },
    { verdict = "dungeon_kinda", level = 54, item = "Ebon Hilt of Marduk",
      how = "Marduk Blackpool, Scholomance (about 7% drop)",
      note = "About +7% for levels 54-59. Only if you are already in Scholomance." },
    { verdict = "dungeon_kinda", level = 58, item = "Dal'Rend's Sacred Charge",
      how = "Warchief Rend Blackhand, Upper Blackrock Spire (about 17% drop)",
      note = "About +8% at 58-59 and it carries into raiding, but only two levels of levelling use. Take it if you are in the Spire." },

    -- dungeon_not
    { verdict = "dungeon_not", level = 17, item = "Tail Spike",
      how = "Drops from Skum, Wailing Caverns (50%)",
      note = "Only about +2% for levels 17-19. Worth having if you are in there for Wingblade." },
    { verdict = "dungeon_not", level = 19, item = "Shadowfang",
      how = "Shadowfang Keep bosses (a rare drop)",
      note = "About +16% for levels 19-29 if you get one, but the database gives it roughly a 0.02% chance per boss. Equip it if it drops; do not run for it." },
    { verdict = "dungeon_not", level = 55, item = "Ironfoe",
      how = "Emperor Dagran Thaurissan, Blackrock Depths (1% drop)",
      note = "About +6.5% for levels 55-59, but a 1% drop. Only worth it if it drops during a run you were doing anyway." },

    -- open_drop
    { verdict = "open_drop", level = 21, item = "Blackvenom Blade",
      how = "Rohh the Silent, level 26 rare elite (about 25% drop)",
      note = "About +7% for levels 21-28. Take it if you are passing that way, do not hunt it." },
    { verdict = "open_drop", level = 51, item = "Krol Blade",
      how = "Level-63 Ahn'Qiraj-era Colossi or a rare world drop, Bind on Equip",
      note = "About +8% for 51-59, but the drop sources are effectively unreachable while levelling. Equip one if it turns up; never plan around it." },

    -- not_worth
    { verdict = "not_worth", level = 30, item = "Swinetusk Shank",
      how = "Drops in Razorfen Kraul",
      note = "Within noise of the other options at 30. Not worth a run." },
}

Rogue.specNote =
    "Sword or Mace Combat is the levelling spec. Sinister Strike doesn't care " ..
    "where you're standing, it handles multiple mobs, and it works the same " ..
    "solo or in a dungeon.\n\n" ..
    "Daggers fight you while levelling: Backstab needs to be behind a target " ..
    "that keeps turning to face you, and Sinister Strike with a dagger hits " ..
    "noticeably softer. Ambush is good for the opener at low level and that's " ..
    "about it.\n\n" ..
    "Practical upshot: get sword and mace training as early as you can afford " ..
    "it, and skill up every weapon type as you go so you're free to switch " ..
    "when something good drops.\n\n" ..
    "Forever changes this. The weapon specialization talents are gone and " ..
    "Combat's Hack and Slash replaces them, so a Classic talent guide will " ..
    "mislead you there."

--------------------------------------------------------------------------
-- Grinding
--------------------------------------------------------------------------

-- When killing things beats running quests. Rogue-flavoured: stealth means
-- you choose your pulls, which makes grinding less punishing than it is for
-- most classes.
Rogue.grinding = {
    { band = "1-10",  advice = "Never. Starting zone quests are dense and fast." },
    { band = "10-20", advice = "Rarely. The Barrens has more quests than you need." },
    { band = "20-30", advice = "Occasionally, to close a level when you're one bar short and the next quest hub is a long ride." },
    { band = "30-40", advice = "Real option. Quest density drops and travel time climbs. Stealth past what you don't want and kill only the good pulls." },
    { band = "40-50", advice = "Often worth it. Humanoids for cloth and junkbox drops - you're the only class that gets paid twice for the same kill." },
    { band = "50-60", advice = "Depends on the zone. Where quests thin out, grind. Pick humanoids so pickpocketing pays." },
}

Rogue.deathNote =
    "This is a softcore addon. Dying is sometimes correct - a corpse run is " ..
    "often cheaper than a long detour, and sometimes cheaper than fighting " ..
    "your way out. Don't play like a hardcore character. Do get Vanish at 22, " ..
    "because it turns a lot of deaths into a few seconds."

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------

local win, content
local current = "training"

local function SetText(text)
    content:SetText(text)
    content:SetWidth(430)
end

function Rogue:BuildTraining()
    local lines = {}
    local level = UnitLevel("player")
    local learned = self:Learned()

    table.insert(lines, Theme.hex.accent .. "Milestones|r")
    table.insert(lines, "")

    for _, m in ipairs(self.seeded) do
        local colour
        if level >= m.level then colour = Theme.hex.done
        elseif level >= m.level - 2 then colour = Theme.hex.warn
        else colour = Theme.hex.dim end

        table.insert(lines, ("%s[%d] %s|r"):format(colour, m.level, m.what))
        table.insert(lines, ("   %s%s|r"):format(Theme.hex.faint, m.note))
    end

    local count = 0
    for _ in pairs(learned) do count = count + 1 end

    table.insert(lines, "")
    table.insert(lines, Theme.hex.accent .. "What you've learned|r")
    table.insert(lines, "")

    if count == 0 then
        table.insert(lines, Theme.hex.faint ..
            "Nothing recorded yet. Train an ability and it appears here with the level you got it at." ..
            "|r")
    else
        -- sort by level
        local sorted = {}
        for name, lvl in pairs(learned) do
            table.insert(sorted, { name = name, level = lvl })
        end
        table.sort(sorted, function(a, b)
            if a.level == b.level then return a.name < b.name end
            return a.level < b.level
        end)
        for _, e in ipairs(sorted) do
            table.insert(lines, ("%s%2d|r  %s%s|r")
                :format(Theme.hex.dim, e.level, Theme.hex.text, e.name))
        end
    end

    table.insert(lines, "")
    table.insert(lines, Theme.hex.accent .. "What to spend gold on|r")
    table.insert(lines, Theme.hex.text .. self.trainingNote .. "|r")

    return table.concat(lines, "\n")
end

function Rogue:BuildWeapons()
    local lines = {}
    for _, s in ipairs(self.weapons) do
        table.insert(lines, Theme.hex.accent .. s.head .. "|r")
        table.insert(lines, Theme.hex.text .. s.body .. "|r")
        table.insert(lines, "")
    end
    return table.concat(lines, "\n")
end

function Rogue:VerdictTitle(key)
    for _, v in ipairs(self.verdicts) do
        if v.key == key then return v.title end
    end
    return key
end

function Rogue:BuildUpgrades()
    local lines = {}
    local level = UnitLevel("player")

    table.insert(lines, Theme.hex.accent .. "Weapons worth routing around|r")
    table.insert(lines, Theme.hex.faint .. "Horde-obtainable only.|r")
    table.insert(lines, "")

    for _, verdict in ipairs(self.verdicts) do
        local shown = false
        for _, u in ipairs(self.upgrades) do
            if u.verdict == verdict.key then
                if not shown then
                    table.insert(lines, Theme.hex.accent .. verdict.title .. "|r")
                    table.insert(lines, "")
                    shown = true
                end
                local colour
                if self.quietVerdicts[verdict.key] then colour = Theme.hex.faint
                elseif level >= u.level + 6 then colour = Theme.hex.faint
                elseif level >= u.level then colour = Theme.hex.done
                elseif level >= u.level - 4 then colour = Theme.hex.warn
                else colour = Theme.hex.dim end

                table.insert(lines, ("%s[%d] %s|r"):format(colour, u.level, u.item))
                table.insert(lines, ("   %s%s|r"):format(Theme.hex.text, u.how))
                table.insert(lines, ("   %s%s|r"):format(Theme.hex.faint, u.note))
                table.insert(lines, "")
            end
        end
    end

    table.insert(lines, Theme.hex.accent .. "Spec and weapon type|r")
    table.insert(lines, Theme.hex.text .. self.specNote .. "|r")

    return table.concat(lines, "\n")
end

function Rogue:BuildGrinding()
    local lines = {}
    local level = UnitLevel("player")

    table.insert(lines, Theme.hex.accent .. "When to grind instead of quest|r")
    table.insert(lines, "")

    for _, g in ipairs(self.grinding) do
        local lo = tonumber(g.band:match("^(%d+)"))
        local hi = tonumber(g.band:match("%-(%d+)$"))
        local here = (level >= lo and level <= hi)
        local colour = here and Theme.hex.bright or Theme.hex.dim

        table.insert(lines, ("%s%s%s|r"):format(colour, g.band .. "  ", g.advice))
    end

    table.insert(lines, "")
    table.insert(lines, Theme.hex.accent .. "On dying|r")
    table.insert(lines, Theme.hex.text .. self.deathNote .. "|r")

    return table.concat(lines, "\n")
end

function Rogue:Refresh()
    if not win then return end
    if current == "training" then SetText(self:BuildTraining())
    elseif current == "upgrades" then SetText(self:BuildUpgrades())
    elseif current == "weapons" then SetText(self:BuildWeapons())
    else SetText(self:BuildGrinding()) end
end

function Rogue:Show()
    if not self:IsRogue() then
        ns.Print("This tab is rogue-only, and you're not on a rogue.")
        return
    end

    if not win then
        win = CreateFrame("Frame", "TuFFlevelsRogue", UIParent)
        win:SetSize(500, 470)
        win:SetPoint("CENTER")
        win:SetFrameStrata("DIALOG")
        win:EnableMouse(true)
        win:SetMovable(true)
        win:RegisterForDrag("LeftButton")
        win:SetScript("OnDragStart", win.StartMoving)
        win:SetScript("OnDragStop", win.StopMovingOrSizing)
        Theme:Skin(win)

        local title = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", 0, -12)
        title:SetText(Theme:Accent("Rogue"))

        local function Tab(label, mode, x)
            local b = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
            b:SetSize(108, 22)
            b:SetPoint("TOPLEFT", x, -36)
            b:SetText(label)
            Theme:SkinButton(b)
            b:SetScript("OnClick", function() current = mode ; Rogue:Refresh() end)
            return b
        end
        -- Only the click handlers Tab() wires up matter here - nothing
        -- reads the buttons back by reference afterward.
        local _ = {
            Tab("Training", "training", 14),
            Tab("Upgrades", "upgrades", 128),
            Tab("Weapons", "weapons", 242),
            Tab("Grinding", "grinding", 356),
        }

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsRogueScroll", win,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 16, -66)
        scroll:SetPoint("BOTTOMRIGHT", -32, 46)

        local body = CreateFrame("Frame", nil, scroll)
        body:SetSize(430, 10)
        scroll:SetScrollChild(body)

        content = body:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        content:SetPoint("TOPLEFT")
        content:SetWidth(430)
        content:SetJustifyH("LEFT")
        content:SetSpacing(3)
        content:SetTextColor(unpack(Theme.color.text))

        local close = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOM", 0, 14)
        close:SetText("Close")
        Theme:SkinButton(close)
        close:SetScript("OnClick", function() win:Hide() end)

        win.body = body
    end

    win:Show()
    self:Refresh()
    win.body:SetHeight(math.max(10, content:GetStringHeight() + 20))
end

--------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------

local rf = CreateFrame("Frame")

local _, missingEvents = Compat:RegisterEvents(rf, {
    "LEARNED_SPELL_IN_TAB",
    "PLAYER_LEVEL_UP",
    "CHAT_MSG_SYSTEM",
})
if ns.Core and ns.Core.missingEvents then
    for _, e in ipairs(missingEvents) do table.insert(ns.Core.missingEvents, e) end
end

rf:SetScript("OnEvent", Compat:Wrap("Rogue", function(self, event, ...)
    if not Rogue:IsRogue() then return end

    if event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        -- flag the milestone trainer visits rather than letting them slide
        for _, m in ipairs(Rogue.seeded) do
            if m.level == newLevel then
                ns.Print(("%sLevel %d: %s|r"):format(Theme.hex.accent, m.level, m.what))
                ns.Print(Theme.hex.dim .. m.note .. "|r")
            end
        end
        for _, u in ipairs(Rogue.upgrades) do
            if u.level == newLevel and not Rogue.quietVerdicts[u.verdict] then
                ns.Print(("%s%s: %s|r - %s")
                    :format(Theme.hex.bright, Rogue:VerdictTitle(u.verdict), u.item, u.how))
            end
        end
        Rogue:Refresh()

    elseif event == "LEARNED_SPELL_IN_TAB" then
        -- The payload varies by client; record the level regardless and let
        -- the spellbook scan below attach names.
        Rogue:ScanSpellbook()
    end
end))

-- Walks the rogue spellbook and records anything not already known, stamped
-- with your current level.
function Rogue:ScanSpellbook()
    if not self:IsRogue() then return end
    local level = UnitLevel("player")

    for i = 1, 200 do
        local name = Compat:GetSpellBookName(i)
        if not name then break end
        self:Record(name, level)
    end
end
