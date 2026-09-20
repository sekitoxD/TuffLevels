-- TuFFlevels / .luacheckrc
--
-- WoW addon Lua (5.1). Route files (Routes/**/*.lua) are large,
-- hand-authored data tables with long single-line step entries - line
-- length isn't a useful signal there (or anywhere else in this addon),
-- so it's off project-wide rather than special-cased per directory.

std = "lua51"
max_line_length = false

-- .luarocks/ is CI's own locally-installed luacheck/busted dependency
-- tree (created by `luarocks install` right before this runs), not part
-- of this addon - exclude it so this only ever checks the project's own
-- code, regardless of what tree luarocks happens to install into.
exclude_files = { ".luarocks/**" }

-- Every file opens with `local ADDON, ns = ...` by convention, even in
-- files that only ever use `ns` - keeping both names documents the
-- vararg's shape consistently across the whole addon. Don't flag ADDON
-- as unused for that; everything else still gets normal unused-local
-- detection.
ignore = { "211/ADDON" }

-- WoW event/script callbacks have a fixed argument order set by the API
-- (e.g. OnEvent(self, event, ...)), so a handler that only needs `event`
-- still has to declare `self` first - can't drop a leading unused
-- parameter without losing the ones after it. Checking unused locals
-- (still on) catches real dead code; checking unused *arguments* here
-- would just flag this normal callback shape everywhere.
unused_args = false

-- Every widget-scoped callback naturally takes `self` (the widget it
-- fires on) as its own first argument, nested inside a method that
-- already has an outer `self` (the module) in scope - e.g. a button's
-- OnClick inside `function Panel:Build(...)`. That's shadowing by
-- luacheck's definition (431/432), but it's the correct, idiomatic name
-- in both scopes, not a mistake; the same goes for short, reused local
-- names like `b`/`db` across sibling closures. Real shadowing bugs are
-- rare in a codebase this size and would show up as a wrong-value test
-- failure, not silently through this check.
ignore = { "211/ADDON", "431", "432" }

-- Globals this addon itself creates. SLASH_TUFFLEVELS1-3 register the
-- slash command; SlashCmdList's own field (SlashCmdList["TUFFLEVELS"])
-- is likewise assigned, not just read, so it needs full global (not
-- read_globals) status too. TuFFlevelsFrame is the one WoW-implicit
-- frame-name global this addon references directly elsewhere (Panel.lua,
-- picking the tracker as an anchor) - every other named frame
-- CreateFrame() creates is only ever read back through its own local
-- variable, so luacheck never needs to know its global name; WoW makes
-- that name a global as an engine side effect invisible to static
-- analysis, not because the Lua source assigns it.
globals = {
    "SLASH_TUFFLEVELS1", "SLASH_TUFFLEVELS2", "SLASH_TUFFLEVELS3",
    "SlashCmdList",
}

-- The client API surface this addon calls. Read-only - nothing here
-- should ever be assigned by this addon's own code. Namespaced tables
-- (C_Map, C_QuestLog, ...) are declared once each; luacheck only checks
-- that the top-level name is known, not every function inside it.
read_globals = {
    "TuFFlevelsFrame",

    -- Frames / UI
    "CreateFrame", "UIParent", "GameTooltip", "DEFAULT_CHAT_FRAME",
    "UiMapPoint",

    -- Namespaced API tables
    "C_Timer", "C_Map", "C_QuestLog", "C_GossipInfo", "C_SpellBook",
    "C_TaxiMap", "C_SuperTrack", "C_NamePlate", "C_Secrets",
    "C_RestrictedActions",

    -- Client/project identification
    "GetBuildInfo", "WOW_PROJECT_ID", "WOW_PROJECT_MAINLINE",
    "WOW_PROJECT_CLASSIC",

    -- Unit info
    "UnitClass", "UnitRace", "UnitLevel", "UnitXP", "UnitXPMax",
    "UnitName", "UnitPosition", "UnitFactionGroup", "GetPlayerFacing",
    "IsXPUserDisabled", "GetSpecialization",

    -- Quest/gossip actions (Automation.lua)
    "AcceptQuest", "GetQuestReward", "GetNumQuestChoices", "GetQuestID",
    "SelectActiveQuest", "SelectAvailableQuest", "GetNumActiveQuests",
    "GetActiveTitle", "GetNumAvailableQuests", "GetAvailableTitle",
    "GetSpellBookItemName",

    -- Misc client state
    "InCombatLockdown", "IsShiftKeyDown", "GetCVar", "SetCVar",
    "CreateVector2D", "Enum", "GetZoneText", "time", "date", "CreateColor",
}

-- busted (spec/*.lua) injects its own globals - describe/it/assert/
-- before_each/etc - that are neither standard Lua nor WoW API. luacheck
-- ships a ready-made "busted" std covering exactly these; add it on top
-- of the base lua51 std for spec files only, so main addon code still
-- can't accidentally call a busted-only function by mistake.
files["spec/**/*.lua"] = {
    std = "lua51+busted",
}
