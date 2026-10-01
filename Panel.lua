-- TuFFlevels / Panel.lua
--
-- Everything the slash commands do, as buttons. Plus first-run setup so the
-- addon configures itself instead of asking you to type anything.

local ADDON, ns = ...
local Compat = ns.Compat

local Panel = {}
ns.Panel = Panel

local panel

-- Grows a dialog to fit its body text instead of letting the Close/Confirm
-- row overlap it - body has no bottom anchor, so GetStringHeight reflects
-- the wrapped text height after SetText. Frame stays centered since
-- SetPoint("CENTER") re-centers around the new size automatically.
local function FitDialogToBody(f, body, topOffset, bottomReserve, minHeight)
    f:SetHeight(math.max(minHeight, topOffset + body:GetStringHeight() + bottomReserve))
end

--------------------------------------------------------------------------
-- Changelog
--------------------------------------------------------------------------

local CHANGELOG_VERSION = "1.7.33"
-- Only the newest entries are shown in the dialog; older ones stay below
-- as history.
local CHANGELOG_SHOWN = 6
local CHANGELOG = {
    "Tracker readability pass for the ONSLAUGHT Orc/Troll route. About 180 skip-notes whose headline was cut to one letter (\"Skip: T\") now name the real quest (\"Skip: The Real Threat\"), and internal plan references no longer show in quest notes. Generic notes show their text instead of \"NOTE: Note\", pace and quest-log count share one dim line, the verb for kill/collect steps reads \"Complete\", long labels no longer cut through a multi-byte character, and long note rows in the Progress window truncate instead of overlapping. Not yet verified in-game.",
    "RXPGuides route notes cleaned up. Raw guide directives such as \".mob Yarrog Baneshadow\", \".zoneskip\", \".money <1\" and \".itemStat ...\" no longer appear in the note line of the tracker for the Human, Dwarf/Gnome, Night Elf, Tauren and Orc/Troll RXPGuides routes (about 12,000 notes). Real instruction text is kept, and bare Abandon and grind-to-XP checkpoints are now worded in plain English. About 26 empty note steps were removed from the Night Elf and Tauren routes, so if you are mid-route on either, or hold a progress code for them, check that your step still matches after updating (Back/Next fixes it). The RXPGuides importer no longer produces the raw text, and a new spec fails if it comes back. Not yet verified in-game.",
    "The arrow no longer presents a rough guess as a precise target. Steps the route author flagged approximate now show a ~ distance, and nameless ones (mob kills, objectives) read \"Near: <area>\" instead of an exact-looking pointer; steps with a named NPC keep the NPC's name. Not yet verified in-game.",
    "Arrow fixes. When a step has no coordinates and no later step does either, or the map or your position cannot be read, the arrow now stays up as a dim \"No target\" placeholder instead of vanishing. Compat's shared error budget now recovers after about 5 quiet minutes instead of blinding every API call (including the arrow's map lookup) for the rest of the session, the real-distance calculation no longer throws on restricted (secret) position values, and the new /tuff debugarrow prints exactly why the arrow is hidden or showing No target. Tested in-game for the No target state; the other fixes are not yet verified in-game.",
    "Menu cleanup. Removed the Import spreadsheet and Import a guide (Guidelime) buttons and their /tuff sheet and /tuff guide commands (RXPGuides import replaces them), the Reset arrow position button (/tuff arrow reset still works), and the unused Horde 1-60 skeleton route. The ONSLAUGHT Solo and 5-Man routes stay, and ONSLAUGHT Solo is the default route for Orc and Troll characters; the RXPGuides Orc/Troll route remains an optional test route in Available Guides. Not yet verified in-game.",
    "Menu windows are now one-at-a-time: opening any window from the main menu (Available Guides, Where to go next, Progress, Catch up, Help, Rogue, the import windows, Save this as a route, Progress code) closes the other menu windows and the Content & Import / Display settings submenus, so the menu stays clean. Buttons that have nothing to show yet (no route loaded, nothing recorded) no longer close your open windows. Windows opened by slash commands or automatically are unchanged. Not yet verified in-game.",
    "Fixed the menu's windows drawing on top of each other: opening Content & Import now closes Display settings (and the Colors window), and the other way around, so only one is visible at a time. Closing the main menu closes any submenu left open, closing Display settings closes Colors, and /tuff colors closes Content & Import. Hiding the whole UI with Alt+Z still keeps your open windows. An independent review found no blockers; other centered windows (Available Guides, Help, Progress and the import windows) can still stack and are a known follow-up.",
    "Fixed the red buttons that ignored your selected color theme: every button in the tracker, menu and windows now uses the theme's own colors instead of the stock red art (the Progress window's Jump / Export / Close buttons were never themed at all). Button text is now always legible - the light presets used to show near-unreadable text when you hovered a button - and error, dimmed and completed-step text is automatically brightened or darkened on any preset or custom palette where it was too faint to read.",
    "Fixed the What's new window: it now shows only the newest entries in a fixed-size scrolling window with a Close button that always stays on screen (it used to grow past the screen with no way to close it), and Escape closes it. Removed the custom color palette text box from the Colors window (the presets are the way to change colors now) - the preset buttons stay, and the Close button no longer overlaps leftover content.",
    "Re-parsed the Night Elf route's \"21-23 Stonetalon/Ashenvale\", \"23-24 Wetlands\" and \"24-27 Duskwood/Redridge\" chapters through the RXPGuides importer, with the Hunter and non-Hunter guide chapters split into class-filtered sections. Group-dungeon content (Wailing Caverns, Shadowfang Keep, Stormwind Stockades) and Bronze Tube quests are now optional so solo players are not forced to click through them. Fixed an RXPGuides importer bug where a maximum-level skip took effect one level too early (which made a Redridge/Duskwood quest chain skip its accept and then stall), made a negative turn-in directive optional, and stopped raw map-ID coordinates from becoming a bogus zone name. Two review rounds found and fixed real stalls before this shipped.",
    "Merged the Night Elf Hunter-only Ashenvale chapter (\"19-21 Darkshore/Ashenvale\") into the route as its own Hunter-filtered section: Night Elf Hunters now follow the guide's Hunter itinerary instead of the generic Redridge path, and finally get a turn-in for the Absent Minded Prospector quest. Other classes' steps are unchanged. A review round added a Return-to-Auberdine step for Hunters and kept the bear-kill step required.",
    "Follow-up fixes to the Night Elf Darkshore/Redridge re-parse after a second review round: the Redridge Goulash turn-in no longer blocks the route before you have collected the ingredients, and the Grizzled Thistle Bear kill step for the Buzzbox quest is a required step again so the route tells you to kill them before the hand-in.",
    "Re-parsed the Night Elf route's \"16-19 Darkshore\" and \"19-20 Redridge\" chapters through the RXPGuides importer, keeping the hand-fixed Deadmines coordinates and the Forever-only Hall of Thanes block. An independent code review caught steps that would have stalled the route (a quest turn-in with no way to accept it, an item step waiting on the wrong item, a Hunter-only Stormwind detour, and several conditional turn-ins) - all fixed before release. The Hunter-only alternate Ashenvale chapter is still not merged.",
    "Re-parsed the Night Elf route's \"14-16 Darkshore\" and \"20-21 Darkshore/Ashenvale\" chapters through the RXPGuides importer, and re-parsed its already-shipped Shadowglen/Teldrassil starting-zone chapters again to pick up last release's new xp-rate-threshold handling (which they'd shipped without). Two rounds of independent code review found real gameplay bugs the mechanical conversion had introduced: a Mining/Blacksmithing pair of trainer steps (split from one guide line into two separate steps) needed a Warrior/Rogue class filter that only one half of the pair got in the first review pass; and Priest/Rogue had no mandatory path at all to a quest pair every other class reaches through a class-filtered alternate, which in turn left a following step (using an item at the Auberdine moonwell) wrongly marked optional for everyone once Priest/Rogue's path was fixed. A third, narrower review pass confirmed all four fixes are correct and complete. No other previously-shipped route content was affected; Night Elf stays flagged 'sample = true' since the rest of the route (from \"16-19 Darkshore\" onward) hasn't been through this pass yet.",
    "Finished re-parsing the Dwarf/Gnome route's starting zone through Loch Modan (Elwynn Forest and Loch Modan, plus their own Hunter-only alternate paths, added alongside last release's Coldridge Valley/Dun Morogh) through the RXPGuides importer. This turned up a bigger version of a bug already being fixed last release: entire xp-rate-gated alternate itineraries (Season-of-Discovery-style fast leveling) were shipping side by side with the normal 1x path, since the importer had no concept of xp-rate thresholds at all - it now recognizes them the same way it already does Season of Discovery/hardcore-only content, dropping what doesn't apply at a normal pace and correctly excluding by class when a guide pairs two rate-gated variants for different classes. This also affects the Coldridge Valley/Dun Morogh content from last release, which has been regenerated with the fix. Five rounds of independent code review were needed to land this completely, including catching a subtle bug in the fix itself (an earlier attempt at the class-exclusion logic was silently overwritten by an unrelated part of the importer before it could take effect). No previously-shipped route content outside Dwarf/Gnome was affected; Night Elf's own starting-zone chapters have the same underlying gap and are noted as a known follow-up in that file's own header. Dwarf/Gnome stays flagged 'sample = true' since its Elwynn Forest/Voidwalker Quest chapters weren't fully explored and the rest of the route hasn't been through this pass yet.",
    "Re-parsed the Dwarf/Gnome route's starting zone (Coldridge Valley and Dun Morogh, including the Hunter class's separate alternate path through the same zones - both now ship side by side, class-filtered) through the RXPGuides importer. This turned up a real, previously-shipping bug in the importer itself: a raw numeric map ID or a capital city's client-specific zone name (e.g. RXPGuides' own \"StormwindClassic\" token) wasn't recognized, silently breaking the travel arrow and auto-complete for well over a hundred steps across this route alone - fixed by teaching the importer to store a numeric ID in the right field instead of guessing it's a zone name, and teaching the addon's zone-name lookup RXPGuides' own city-name convention. Four rounds of independent code review were needed to land this fix completely - each round caught a spot the previous one had missed (a step keeping only the old, broken location; steps being silently dropped or mistyped as a manual note instead of auto-completing; a split step losing its location entirely). No previously-shipped route content was affected; Dwarf/Gnome stays flagged 'sample = true' since only its starting zone has been through this pass so far.",
    "Extended the RXPGuides importer's '#completewith'/'#sticky'/'#optional' handling (added last release) to also work out race coverage, not just class coverage - needed before the Dwarf/Gnome route can be re-parsed, since its guide text pairs conditions like '#completewith X << Dwarf/Gnome' with '#completewith Y << !Dwarf !Gnome' on the same step. Three more rounds of independent code review caught a real bug each pass: a guide condition naming two different races at once, or a race together with its own exclusion, could resolve to the wrong (over-broad) filter instead of being flagged unresolvable - the same class of bug already fixed for classes last release, now closed for races too. No previously-shipped route content is affected.",
    "Re-parsed the Night Elf route's starting zone (Shadowglen/Teldrassil, the first two of many chapters) through the RXPGuides importer, and fixed a chain of real importer bugs this turned up across five more rounds of independent code review: a '.itemcount' directive right after a '.turnin' was splitting off its own item-collection step even though the turn-in had already consumed the items, making it permanently unsatisfiable; a class-OR guide condition (e.g. 'Hunter/Warrior/Priest') was still shipping completely unfiltered instead of resolving to a real per-class filter, which is what let a Rogue get permanently stuck at a Staves-training step no Rogue can ever complete, and forced First Aid training onto every class instead of just Warrior/Rogue; a rare RXPGuides coordinate format ('.goto mapID/floor,...') was being misread as a real zone name instead of dropped, and its own annotation text was stealing a step's name from its actual task; '#completewith <label>' only recognized the literal word 'next', so a labelled companion step (and one gated on a class/race condition) could ship as a blocking, non-optional step when it should have been skippable - a full redesign now works out whether a block's tags, taken together, actually cover everyone before deciding; and a guide condition naming the same class twice, or a class together with its own exclusion, could resolve to the wrong thing entirely instead of being flagged for review. No previously-shipped route content was affected - these are importer fixes plus the two re-parsed chapters only, still flagged 'sample = true' since the rest of the Night Elf route hasn't been through this pass yet.",
    "Fixed several real bugs in the RXPGuides importer found while starting work on finishing the sample Alliance/Tauren routes: a step naming two quests kept only the last one; a '<< !ClassName' condition dropped the whole step instead of showing it to every other class (and, when several classes were excluded at once, silently kept only the last one); Season of Discovery and hardcore-only content (the real '#season'/'#hardcore' tag, not the '<<' form) could survive unfiltered; a same-quest reward-choice pair (e.g. one turn-in for Shaman, another for everyone else) could end up impossible for every class at once; a negated race condition ('<< !Undead') was either dropped entirely or, in an earlier pass, left completely unfiltered-by-race instead of applying to every other race in the guide's own faction; '.train' gate conditions and '#optional'/'.maxlevel' tags weren't being honored consistently, which could leave a step stuck forever for a player who never satisfies an optional condition; and the NPC name shown on a split step could get misattributed to the wrong quest-giver. Also fixed the race name this importer writes for Undead (was the human-readable 'Undead', which never matched an actual Undead character - the addon compares against WoW's own internal race identifier, 'Scourge', same as the already-shipped Tauren route already uses). Five rounds of independent code review were needed to find and fix all of the above - each round caught something the previous one missed by testing against real RXPGuides source text rather than trusting hand-written test cases alone. No existing shipped route was changed; this only affects routes generated from this importer in the future.",
    "Cleaned up finished plan docs and phased three ready-to-implement plan items into the addon. Added the Forever-only Ruins of Lordaeron dungeon quests to the Tauren route and the 5-man Horde route (plan 10 Phase 2), added chapter 2 (\"6-10 Durotar\") to the experimental Orc/Troll RXPGuides test route (plan 12), and fixed dead travel arrows in the three Alliance RXP-converted routes (Human, Dwarf/Gnome, Night Elf) where Gnomeregan/Deadmines/Wailing Caverns/Scarlet Monastery/Uldaman/Maraudon steps carried a continent-level map ID instead of a real zone (plan 07 A1 follow-up). The Alliance fix took three code-review rounds: a first attempt relabeled the zone without converting the coordinate (would have turned a dead arrow into a confidently wrong one, discarded), a second attempt fixed the coordinates but accidentally let 5 in-place-task steps auto-complete early (reverted), and a third confirmed the fix. All of this is additive and flagged not yet in-game verified.",
    "Follow-up pass on the ONSLAUGHT dungeon-bundle work from plans/13: added 6 more optional group-content notes (Blackfathom Deeps, Ragefire Chasm, Razorfen Downs, Scarlet Monastery, Maraudon, Sunken Temple) plus the level 52-60 group (Blackrock Depths, LBRS/UBRS, the Key to Scholomance + Scholomance) and the missing Stonetalon leg of the Warlock Succubus chain (Ken'zigla's Draught), each anchored beside an existing 'skip - low XP for travel time' note for one of that dungeon's own quests. Stratholme was left out - no existing step anywhere in the route names any of its quests, so there was nothing honest to anchor it to. Code review caught two issues before this shipped: the new Ken'zigla's Draught step wasn't marked optional, so a Warlock could have hit it with its own prerequisite quests missing and stalled auto-advance; and the Scholomance bundle note overstated which key-chain quests the route already has (only 3 of 8, not all of them). Both fixed. Same caveat as the first pass - none of this is in-game verified yet.",
    "Researched and audited ONSLAUGHT (the Solo Horde 1-60 Orc/Troll route) for speed/efficiency gaps against this repo's own quest research plus Wowhead/Warcraft Tavern/community guides and WoW Forever's beta site - full writeup in plans/13. Zone order held up fine against every source checked, but every major class-specific power chain (Hunter Tame Beast, Warlock Voidwalker/Succubus/Felsteed, Shaman totems, Warrior Berserker Stance, Mage's Wand) was missing entirely; added them as class-gated steps across 7 zone files, plus three optional group-dungeon-bundle notes (Wailing Caverns, Razorfen Kraul, Zul'Farrak) next to the route's own existing 'skip - low XP for travel time' notes for those same quests. All additive, none of it blocks the existing mandatory path, and every new step is flagged not yet in-game verified - it still needs a /tuff capture pass per class before the coordinates and quest structure can be trusted.",
    "Audited every plan doc in plans/ against the actual code and git history: confirmed Plans 1, 3, and 6 are fully done (added a status note to Plan 3, which had none), and closed out two long-deferred parser gaps this pass turned up fixable - CompactGuide guide syntax can now escape a literal quote inside a quoted value (name=\"say \\\"hi\\\" first\"), and SheetImport no longer fabricates 'Levels 1-1' for a spreadsheet import with no level column at all (now reports 'Levels unknown' instead).",
    "Fixed the custom color palette (Menu > Display settings > Colors) silently claiming 'Custom colors applied' when you typed a key it didn't recognize - it now rejects an unknown key the same way it already rejected a bad hex value, instead of quietly doing nothing. Also added six new class-matched presets (Azure/Verdant/Amber/Umber/Rose/Silver) that a Mage, Hunter, Druid, Warrior, Paladin, or Priest gets automatically the first time they log in, unless you've already picked your own palette - Rogues and any other class keep the addon's own default red/purple look.",
    "Code review caught two issues in yesterday's fixes before they could ship further: the /tuff verify quest-lookup fix would have started replacing route-authored step instructions with generic QuestieDB quest titles on the tracker (now only used when a step has no text of its own); and a bare '.xp N' grind step could have silently overwritten a real accept/turnin/complete step's type if a guide listed both on the same step (now guarded).",
    "Fixed two steps in the Orc/Troll test route missing a class filter that a sibling step for the same quest/item correctly had - one routed non-Warlocks to a quest they could never accept (reported as a party quest-share 'prerequisite' failure), the other told non-Hunters to buy Hunter-only ammo.",
    "RXPGuides import now converts a bare '.xp N' grind directive (no partial-XP modifier) into a real auto-detecting step instead of a dead note that always needed a manual Next click, even once you were already past the target level.",
    "Fixed /tuff verify reporting every quest ID as 'not found in database' even for well-known quests - Data.lua was calling QuestieDB's GetQuest with a colon (method-call syntax) when the real function takes only the quest ID, so every lookup silently received the wrong argument and failed. This affected every route, not just the new test one.",
    "Fixed the tracker showing the same NOTE text twice in a row for certain imported steps, and a route section header sometimes doubling its own level range (e.g. '1-6 1-6 Durotar').",
    "Deduped several exact-duplicate accept/turnin/complete steps in the new Orc/Troll test route that were silently auto-skipping (read as already done) instead of prompting - the likely cause of quests appearing to 'auto turn in' at NPCs with more than one turn-in.",
    "Added an experimental Orc/Troll test route (Routes/Horde/OrcTrollRXP.lua, pick it manually from Available Guides) parsed fresh from RXPGuides source - a separate, parallel route alongside the existing ONSLAUGHT route, which is untouched. Currently covers levels 1-6 only; more chapters land incrementally.",
    "Fixed two RXPGuides import bugs found while testing the new item/spell step types: a decorative |T texture-icon token was gluing a raw path onto step names, and nested |c color tokens (a common RXPGuides pattern) only half-stripped, leaving raw color codes in some step text (already visible in Routes/Horde/Mulgore.lua).",
}

-- Fixed content (the changelog text is a load-time constant) - build once
-- and reuse on reopen instead of creating a fresh frame/widget set every
-- time (plan 08 batch 8 / P1.4). The seen-version bookkeeping still runs on
-- every open since it's cheap state, not part of the leaked frame problem.
function Panel:ShowChangelogDialog()
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    db.lastSeenChangelogVersion = CHANGELOG_VERSION
    if ns.UI and ns.UI.Refresh then ns.UI:Refresh() end

    if not self.changelogBox then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(440, 420)
        f:SetPoint("CENTER")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("What's new - " .. CHANGELOG_VERSION)
        t:SetTextColor(unpack(ns.Theme.color.lilac))

        -- The text is long, so it scrolls inside a fixed-size dialog: the
        -- Close button stays reachable however much text there is (the old
        -- auto-grown dialog ran off the top and bottom of the screen).
        -- Plain ScrollFrame plus a hand-built slider: UIPanelScrollFrame's
        -- scrollbar is the secure-template one that throws on Forever (see
        -- Progress.lua's slider comment).
        local scroll = CreateFrame("ScrollFrame", nil, f)
        scroll:SetPoint("TOPLEFT", 18, -40)
        scroll:SetPoint("BOTTOMRIGHT", -36, 52)

        local content = CreateFrame("Frame", nil, scroll)
        content:SetSize(380, 10)
        scroll:SetScrollChild(content)

        local body = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        body:SetPoint("TOPLEFT", 0, 0)
        body:SetWidth(380)
        body:SetJustifyH("LEFT")
        body:SetSpacing(4)
        body:SetTextColor(unpack(ns.Theme.color.text))

        local lines = {}
        for i = 1, math.min(#CHANGELOG, CHANGELOG_SHOWN) do
            table.insert(lines, "- " .. CHANGELOG[i])
        end
        body:SetText(table.concat(lines, "\n\n"))
        content:SetHeight(body:GetStringHeight() + 8)

        local slider = CreateFrame("Slider", nil, f)
        slider:SetOrientation("VERTICAL")
        slider:SetPoint("TOPRIGHT", -14, -40)
        slider:SetPoint("BOTTOMRIGHT", -14, 52)
        slider:SetWidth(16)
        slider:EnableMouse(true)
        local track = slider:CreateTexture(nil, "BACKGROUND")
        track:SetPoint("TOP", 0, -2)
        track:SetPoint("BOTTOM", 0, 2)
        track:SetWidth(4)
        local thumb = slider:CreateTexture(nil, "OVERLAY")
        thumb:SetSize(16, 28)
        slider:SetThumbTexture(thumb)
        local function paintSlider()
            track:SetColorTexture(unpack(ns.Theme.color.faint))
            thumb:SetColorTexture(unpack(ns.Theme.color.violet))
        end
        paintSlider()
        ns.Theme._skinned[slider] = paintSlider

        local function maxScroll()
            -- viewport = dialog height minus the fixed top (40) and bottom (52) insets;
            -- constant so it never depends on a layout pass having run
            return math.max(0, content:GetHeight() - (f:GetHeight() - 92))
        end
        slider:SetMinMaxValues(0, maxScroll())
        slider:SetValue(0)
        slider:SetScript("OnValueChanged", function(_, value)
            scroll:SetVerticalScroll(value)
        end)
        f:EnableMouseWheel(true)
        f:SetScript("OnMouseWheel", function(_, delta)
            slider:SetValue(math.min(maxScroll(), math.max(0, slider:GetValue() - delta * 40)))
        end)
        f:SetScript("OnShow", function()
            slider:SetMinMaxValues(0, maxScroll())
            slider:SetValue(0)
        end)

        local ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        ok:SetSize(100, 22)
        ok:SetPoint("BOTTOM", 0, 16)
        ok:SetText("Close")
        ok:SetScript("OnClick", function() f:Hide() end)
        ns.Theme:SkinChildren(f)

        -- Escape closes it too (registered by global frame name).
        local name = "TuFFlevelsChangelogFrame"
        _G[name] = f
        table.insert(UISpecialFrames, name)

        self.changelogBox = f
    end

    self.changelogBox:Show()
end

function Panel:HasUnseenChangelog()
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    return db.lastSeenChangelogVersion ~= CHANGELOG_VERSION
end

--------------------------------------------------------------------------
-- First run
--------------------------------------------------------------------------

-- Runs once per install. Turns on the things the addon needs to work,
-- rather than leaving them as commands you have to discover.
function Panel:FirstRunSetup()
    local db = Compat:InitSavedVar("TuFFlevelsDB")

    if db.setupDone then return false end
    db.setupDone = true

    -- NPC markers attach to nameplates, which are off by default. Goes
    -- through Compat:SetCVarSafe, same as Marker:EnableFriendlyPlates and
    -- the Panel nameplates button below - a raw Guard(SetCVar, ...) here
    -- can't detect or work around "nameplateShowFriends" not existing as a
    -- cvar on Forever.
    Compat:SetCVarSafe("nameplateShowFriends", 1)
    Compat:SetCVarSafe("nameplateShowFriendlyNPCs", 1)

    -- Recording is opt-in, off by default (unlike Automation, which
    -- defaults on): it's a route-authoring tool (Recorder.lua), not
    -- something a player just following a route wants running from their
    -- very first session.

    return true
end

function Panel:ShowWelcome()
    local w = CreateFrame("Frame", "TuFFlevelsWelcome", UIParent, "BackdropTemplate")
    w:SetSize(420, 250)
    w:SetPoint("CENTER")
    w:SetFrameStrata("DIALOG")
    w:EnableMouse(true)
    w:SetMovable(true)
    w:RegisterForDrag("LeftButton")
    w:SetScript("OnDragStart", w.StartMoving)
    w:SetScript("OnDragStop", w.StopMovingOrSizing)

    ns.Theme:Skin(w)

    local t = w:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    t:SetPoint("TOP", 0, -18)
    t:SetText("TuFFlevels is ready")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local body = w:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", 24, -52)
    body:SetPoint("TOPRIGHT", -24, -52)
    body:SetJustifyH("LEFT")
    body:SetSpacing(4)
    body:SetTextColor(unpack(ns.Theme.color.text))
    body:SetText(
        "Everything is switched on already. You don't need to type anything.\n\n" ..
        "|cffffd100Just play.|r Level however you think is fastest. The tracker follows " ..
        "along and auto-advances as you go.\n\n" ..
        "A |cffffd100!|r or |cffffd100?|r will float over the head of any NPC your " ..
        "current step needs.\n\n" ..
        "Want to record your own route instead of following one? Click |cffffd100Menu|r " ..
        "on the tracker, then |cffffd100Content & Import|r, and hit Recording.")

    FitDialogToBody(w, body, 52, 60, 250)

    local ok = CreateFrame("Button", nil, w, "UIPanelButtonTemplate")
    ok:SetSize(120, 24)
    ok:SetPoint("BOTTOM", 0, 18)
    ok:SetText("Got it")
    ok:SetScript("OnClick", function() w:Hide() end)
    ns.Theme:SkinChildren(w)

    w:Show()
end

--------------------------------------------------------------------------
-- Button panel
--------------------------------------------------------------------------

local function MakeButton(parent, label, y, onClick)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(210, 22)
    b:SetPoint("TOP", 0, y)
    b:SetText(label)
    b:SetScript("OnClick", onClick)
    return b
end

-- Content & Import and Display settings share one anchor beside the main
-- panel, and Colors (a centered window opened from Display settings) lands on
-- the same column, so any two open at once draw on top of each other.
-- Opening one closes the others.
-- Frames not built yet are skipped, so this is safe to call at any time.
function Panel:CloseSubmenus(except)
    for _, key in ipairs({ "contentMenu", "displayMenu", "colorPicker" }) do
        local f = self[key]
        if f and f ~= except then f:Hide() end
    end
end

-- Windows a menu button can open. Only these are managed: opening one from
-- the menu closes the others (and the submenus) so the menu stays clean.
-- Windows opened by slash commands or automatically (welcome, changelog,
-- resume prompt, recording note prompt) are deliberately left alone.
local MENU_WINDOW_GLOBALS = {
    "TuFFlevelsZones", "TuFFlevelsProgress", "TuFFlevelsRogue",
    "TuFFlevelsRXPImport", "TuFFlevelsCompactGuide", "TuFFlevelsImport",
    "TuFFlevelsExport",
}
local MENU_WINDOW_FIELDS = { "picker", "catchUpBox", "codeBox", "helpBox" }

-- keep: the global name or Panel field name of the window about to open, so
-- a Toggle-style opener still closes its own window on a second click.
-- canOpen (optional): openers that can bail out early with only a chat
-- message ("No route loaded") must not close the user's windows for nothing;
-- when it returns false, open() still runs to print that message but
-- nothing is closed.
function Panel:OpenMenuWindow(keep, open, canOpen)
    if canOpen and not canOpen() then
        open()
        return
    end
    for _, name in ipairs(MENU_WINDOW_GLOBALS) do
        local f = _G[name]
        if f and name ~= keep then f:Hide() end
    end
    for _, key in ipairs(MENU_WINDOW_FIELDS) do
        local f = self[key]
        if f and key ~= keep then f:Hide() end
    end
    self:CloseSubmenus()
    open()
end

function Panel:Build()
    if panel then return end

    panel = CreateFrame("Frame", "TuFFlevelsPanel", UIParent, "BackdropTemplate")
    panel:SetSize(240, 438)
    panel:SetFrameStrata("DIALOG")
    panel:EnableMouse(true)
    panel:SetMovable(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
    panel:Hide()
    -- Submenus are parented to UIParent, not the panel, so they would
    -- otherwise be left floating when the main menu closes.
    -- OnHide also fires when UIParent hides (Alt+Z); IsShown stays true
    -- then, so only an explicit Hide cascades and Alt+Z keeps the submenus.
    panel:HookScript("OnHide", function()
        if not panel:IsShown() then Panel:CloseSubmenus() end
    end)

    ns.Theme:Skin(panel)

    local t = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("TuFFlevels")

    -- Guides / routes
    panel.routeBtn = MakeButton(panel, "Available Guides", -40, function()
        Panel:OpenMenuWindow("picker", function() Panel:ShowRoutePicker() end)
    end)

    MakeButton(panel, "Where to go next", -66, function()
        Panel:OpenMenuWindow("TuFFlevelsZones", function() ns.Zones:Show() end)
    end)

    MakeButton(panel, "Progress / completed", -92, function()
        Panel:OpenMenuWindow("TuFFlevelsProgress", function() ns.Progress:Toggle() end)
    end)

    MakeButton(panel, "Catch up on quests", -118, function()
        Panel:OpenMenuWindow("catchUpBox", function() Panel:ShowCatchUpDialog() end,
            function() return ns.Core.active end)
    end)

    panel.autoBtn = MakeButton(panel, "Auto accept/turn-in", -144, function()
        ns.Automation:Toggle() ; Panel:Refresh()
    end)

    panel.arrowBtn = MakeButton(panel, "Arrow", -170, function()
        ns.Arrow:Toggle() ; Panel:Refresh()
    end)

    panel.markerBtn = MakeButton(panel, "NPC markers", -196, function()
        ns.Marker:Toggle()
        Panel:Refresh()
    end)

    -- Recording extras - meaningless unless actively recording. Kept at a
    -- fixed slot rather than reflowing the rest of the menu when toggled;
    -- Panel:Refresh() drives whether they're shown. The Recording toggle
    -- itself lives in the Content & Import submenu now, alongside "Save
    -- this as a route" - these two stay here since they're only useful
    -- mid-recording, right next to the tracker, not buried a menu deeper.
    panel.noteBtn = MakeButton(panel, "Add a note here", -222, function()
        Panel:PromptNote()
    end)

    panel.markBtn = MakeButton(panel, "Mark this spot", -248, function()
        ns.Recorder:AddMark("Travel")
        Panel:Refresh()
    end)

    -- Content management and display settings both moved into their own
    -- submenus (see Panel:ShowContentMenu / Panel:ShowDisplayMenu below) -
    -- occasional-use buttons that don't need to sit in the main list.
    MakeButton(panel, "Content & Import", -274, function()
        Panel:ShowContentMenu()
    end)

    MakeButton(panel, "Display settings", -300, function()
        Panel:ShowDisplayMenu()
    end)

    -- Rogue.lua already refuses to do anything for any other class; this
    -- just keeps the button from cluttering the menu for the 8 classes
    -- that can never use it, closing the gap it would otherwise leave
    -- rather than just hiding it in place. Class never changes
    -- mid-session, so this is decided once here, not on every Refresh().
    local y = -326
    local _, playerClass = UnitClass("player")
    if playerClass == "ROGUE" then
        MakeButton(panel, "Rogue", y, function()
            Panel:OpenMenuWindow("TuFFlevelsRogue", function() ns.Rogue:Show() end)
        end)
        y = y - 26
    end

    MakeButton(panel, "Help / About", y, function()
        Panel:OpenMenuWindow("helpBox", function() Panel:ShowHelpDialog() end)
    end)
    y = y - 32

    MakeButton(panel, "Close", y, function() panel:Hide() end)

    ns.Theme:SkinChildren(panel)
    t:SetTextColor(unpack(ns.Theme.color.lilac))
end

function Panel:Refresh()
    if not panel then return end

    local rec = ns.Recorder and ns.Recorder.active
    panel.noteBtn:SetShown(rec)
    panel.markBtn:SetShown(rec)

    panel.markerBtn:SetText(ns.Marker and ns.Marker.enabled
        and "NPC markers: on" or "NPC markers: off")
    panel.arrowBtn:SetText(ns.Arrow and ns.Arrow.enabled and "Arrow: on" or "Arrow: off")

    panel.autoBtn:SetText(ns.Automation and ns.Automation.enabled
        and "Auto accept/turn-in: on" or "Auto accept/turn-in: off")
end

function Panel:Toggle()
    self:Build()
    if panel:IsShown() then
        panel:Hide()
    else
        panel:ClearAllPoints()
        panel:SetPoint("TOPLEFT", TuFFlevelsFrame or UIParent, "TOPRIGHT", 8, 0)
        panel:Show()
        self:Refresh()
    end
end

--------------------------------------------------------------------------
-- Blizzard Settings panel (Game Menu > Options > AddOns)
--------------------------------------------------------------------------

-- A second UI surface for the SAME toggles the buttons above already drive
-- - no new SavedVariables, no new state. Gated on Compat.has.settingsAPI:
-- Classic Era has no `Settings` namespace at all, so nothing below ever
-- runs there.
--
-- Every Settings.* call is wrapped in Compat:Guard. The exact argument
-- shape of Settings.RegisterProxySetting/CreateCheckbox could not be
-- confirmed against a live client from this environment (no headless Lua
-- runner, no client access) - a wrong guess about that shape degrades to
-- "this one checkbox doesn't register", never a crash that takes the rest
-- of Panel.lua down with it.
--
-- Toggle()/ToggleMobs()/ToggleColorblind()/ToggleTextOnly() unconditionally
-- flip their boolean - they are not SetEnabled(bool) setters. The Settings
-- API calls the setter with the NEW value the user picked (and may call it
-- once during registration/restore), so the setter below only calls the
-- real Toggle() when the requested value actually differs from current
-- state, instead of flipping it unconditionally and desyncing the checkbox
-- from the real state on the first render.
local function MakeSettingsToggle(category, variable, name, tooltip, getValue, setValue)
    local varType = (Settings.VarType and Settings.VarType.Boolean) or "boolean"
    local setting = Compat:Guard(Settings.RegisterProxySetting,
        category, variable, varType, name, getValue() and true or false, getValue, setValue)
    if not setting then return end

    Compat:Guard(Settings.CreateCheckbox, category, setting, tooltip)
end

-- Called once at login (Core.lua's PLAYER_LOGIN handler, right after
-- Panel:Build()). self.settingsRegistered guards against double
-- registration if something ever calls this twice in one session.
function Panel:RegisterSettingsCategory()
    if not Compat.has.settingsAPI then return end
    if self.settingsRegistered then return end
    self.settingsRegistered = true

    local category = Compat:Guard(Settings.RegisterVerticalLayoutCategory, ADDON)
    if not category then return end

    Compat:Guard(Settings.RegisterAddOnCategory, category)

    MakeSettingsToggle(category, "TUFFLEVELS_AUTO_ACCEPT_TURNIN", "Auto accept/turn-in",
        "Automatically accepts and turns in quests matching your current step. Never guesses between multiple reward choices.",
        function() return ns.Automation and ns.Automation.enabled or false end,
        function(value)
            if not ns.Automation then return end
            if (ns.Automation.enabled or false) ~= value then
                ns.Automation:Toggle()
            end
            Panel:Refresh()
        end)

    MakeSettingsToggle(category, "TUFFLEVELS_NPC_MARKERS", "NPC markers",
        "Shows a floating icon over quest NPCs your current step needs.",
        function() return ns.Marker and ns.Marker.enabled or false end,
        function(value)
            if not ns.Marker then return end
            if (ns.Marker.enabled or false) ~= value then
                ns.Marker:Toggle()
            end
            Panel:Refresh()
        end)

    MakeSettingsToggle(category, "TUFFLEVELS_OBJECTIVE_MOBS", "Objective mob markers",
        "Also marks the mobs your current kill objective needs, not just quest NPCs.",
        function() return ns.Marker and ns.Marker.markMobs or false end,
        function(value)
            if not ns.Marker then return end
            if (ns.Marker.markMobs or false) ~= value then
                ns.Marker:ToggleMobs()
            end
        end)

    MakeSettingsToggle(category, "TUFFLEVELS_ARROW_COLORBLIND", "Arrow colorblind colors",
        "Uses a colorblind-friendly palette for the directional arrow.",
        function() return ns.Arrow and ns.Arrow.colorblind or false end,
        function(value)
            if not ns.Arrow then return end
            if (ns.Arrow.colorblind or false) ~= value then
                ns.Arrow:ToggleColorblind()
            end
        end)

    MakeSettingsToggle(category, "TUFFLEVELS_ARROW_TEXT_ONLY", "Arrow text-only mode",
        "Shows the arrow's distance/direction as text only, no icon.",
        function() return ns.Arrow and ns.Arrow.textOnly or false end,
        function(value)
            if not ns.Arrow then return end
            if (ns.Arrow.textOnly or false) ~= value then
                ns.Arrow:ToggleTextOnly()
            end
        end)
end

--------------------------------------------------------------------------
-- Content & Import submenu
--------------------------------------------------------------------------

-- Occasional-use route setup/backup actions, split out of the main list.
-- Button set is fixed; only the Recording button's label and the steps-
-- recorded count change while the menu is open (or between opens, if
-- recording was toggled elsewhere) - build once and refresh those two
-- widgets on every open instead of rebuilding the whole menu (plan 08
-- batch 8 / P1.4).
function Panel:ShowContentMenu()
    if not self.contentMenu then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(240, 280)
        f:SetPoint("TOPLEFT", panel, "TOPRIGHT", 8, 0)
        f:SetFrameStrata("DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Content & Import")
        t:SetTextColor(unpack(ns.Theme.color.lilac))

        -- Spreadsheet and Guidelime importers were removed
        MakeButton(f, "Import RXPGuides guide", -42, function()
            Panel:OpenMenuWindow("TuFFlevelsRXPImport", function() ns.RXPImport:Show() end)
        end)
        MakeButton(f, "Write a route (text)", -68, function()
            Panel:OpenMenuWindow("TuFFlevelsCompactGuide", function() ns.CompactGuide:Show() end)
        end)
        MakeButton(f, "Recover past quests", -94, function()
            Panel:OpenMenuWindow("TuFFlevelsImport", function() ns.Import:Show() end)
        end)

        -- Recording moved here from the main panel (2026-09-20): a
        -- route-authoring tool that's off by default, sitting right next to
        -- "Save this as a route" now that both are occasional-use actions
        -- rather than something a player following a route needs on the
        -- main list. Recording has on/off state that can change while the
        -- menu is left open, so its own click handler updates its own text
        -- directly, the same pattern ShowDisplayMenu's mobBtn already uses;
        -- both are also refreshed on every reopen below.
        local recBtn
        recBtn = MakeButton(f, "Start recording", -120, function()
            if ns.Recorder.active then ns.Recorder:Stop() else ns.Recorder:Start() end
            recBtn:SetText(ns.Recorder.active and "Stop recording" or "Start recording")
            f.recStatus:SetText(("%d steps recorded"):format(ns.Recorder and #ns.Recorder.log or 0))
            Panel:Refresh()
        end)
        f.recBtn = recBtn

        local recStatus = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        recStatus:SetPoint("TOP", 0, -140)
        recStatus:SetTextColor(unpack(ns.Theme.color.dim))
        f.recStatus = recStatus

        MakeButton(f, "Save this as a route", -166, function()
            Panel:OpenMenuWindow("TuFFlevelsExport", function() ns.Recorder:ShowExport() end,
                function() return #ns.Recorder.log > 0 end)
        end)
        MakeButton(f, "Progress code", -192, function()
            Panel:OpenMenuWindow("codeBox", function() Panel:ShowProgressCode() end,
                function() return ns.Core:GetProgressCode() end)
        end)

        local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOM", 0, 14)
        close:SetText("Close")
        close:SetScript("OnClick", function() f:Hide() end)

        ns.Theme:SkinChildren(f)
        self.contentMenu = f
    end

    local f = self.contentMenu
    f.recBtn:SetText(ns.Recorder and ns.Recorder.active and "Stop recording" or "Start recording")
    f.recStatus:SetText(("%d steps recorded"):format(ns.Recorder and #ns.Recorder.log or 0))

    self:CloseSubmenus(f)
    f:Show()
end

--------------------------------------------------------------------------
-- Display settings submenu
--------------------------------------------------------------------------

-- Button set is fixed; every button's label reflects live on/off state that
-- can change between opens (or while the menu sits open, via its own click
-- handler) - build once and refresh all five labels on every open instead
-- of rebuilding the whole menu (plan 08 batch 8 / P1.4).
function Panel:ShowDisplayMenu()
    if not self.displayMenu then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(240, 268)
        f:SetPoint("TOPLEFT", panel, "TOPRIGHT", 8, 0)
        f:SetFrameStrata("DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Display settings")
        t:SetTextColor(unpack(ns.Theme.color.lilac))

        f.mobBtn = MakeButton(f, "Objective mobs", -42, function()
            ns.Marker:ToggleMobs()
            f.mobBtn:SetText(ns.Marker.markMobs and "Objective mobs: on" or "Objective mobs: off")
        end)

        -- "nameplateShowFriends" isn't a registered cvar on Forever at all -
        -- read the same "nameplateShowFriendlyNPCs" cvar
        -- Marker:EnableFriendlyPlates/DisableFriendlyPlates confirm success
        -- against, via the same C_CVar-preferring Compat wrapper, or this
        -- button's label and on/off click logic silently invert on Forever.
        f.platesBtn = MakeButton(f, "Nameplates", -68, function()
            local cur = Compat:GetCVarSafe("nameplateShowFriendlyNPCs")
            if cur == "1" then ns.Marker:DisableFriendlyPlates()
            else ns.Marker:EnableFriendlyPlates() end
            local now = Compat:GetCVarSafe("nameplateShowFriendlyNPCs")
            f.platesBtn:SetText(now == "1" and "Nameplates: on" or "Nameplates: off")
        end)

        MakeButton(f, "Colors", -94, function()
            Panel:ShowColorPicker()
        end)

        -- No reset-position button: /tuff arrow reset does the same.
        f.cbBtn = MakeButton(f, "Arrow colorblind colors", -120, function()
            ns.Arrow:ToggleColorblind()
            f.cbBtn:SetText(ns.Arrow.colorblind and "Arrow colorblind colors: on" or "Arrow colorblind colors: off")
        end)

        f.textOnlyBtn = MakeButton(f, "Arrow text-only mode", -146, function()
            ns.Arrow:ToggleTextOnly()
            f.textOnlyBtn:SetText(ns.Arrow.textOnly and "Arrow text-only mode: on" or "Arrow text-only mode: off")
        end)

        f.tomtomBtn = MakeButton(f, "Defer arrow to TomTom", -172, function()
            ns.Arrow:ToggleDeferToTomTom()
            f.tomtomBtn:SetText(ns.Arrow.deferToTomTom and "Defer arrow to TomTom: on" or "Defer arrow to TomTom: off")
        end)

        local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOM", 0, 14)
        close:SetText("Close")
        close:SetScript("OnClick", function() f:Hide() end)

        ns.Theme:SkinChildren(f)
        -- Colors belongs to this menu; don't leave it orphaned when this
        -- one closes (its own Close button, or another submenu opening).
        f:SetScript("OnHide", function()
            if not f:IsShown() and Panel.colorPicker then Panel.colorPicker:Hide() end
        end)
        self.displayMenu = f
    end

    local f = self.displayMenu
    f.mobBtn:SetText(ns.Marker and ns.Marker.markMobs and "Objective mobs: on" or "Objective mobs: off")
    local plateCur = Compat:GetCVarSafe("nameplateShowFriendlyNPCs")
    f.platesBtn:SetText(plateCur == "1" and "Nameplates: on" or "Nameplates: off")
    f.cbBtn:SetText(ns.Arrow and ns.Arrow.colorblind and "Arrow colorblind colors: on" or "Arrow colorblind colors: off")
    f.textOnlyBtn:SetText(ns.Arrow and ns.Arrow.textOnly and "Arrow text-only mode: on" or "Arrow text-only mode: off")
    f.tomtomBtn:SetText(ns.Arrow and ns.Arrow.deferToTomTom and "Defer arrow to TomTom: on" or "Defer arrow to TomTom: off")

    self:CloseSubmenus(f)
    f:Show()
end

--------------------------------------------------------------------------
-- Note prompt
--------------------------------------------------------------------------

function Panel:PromptNote()
    if not self.noteBox then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(380, 120)
        f:SetPoint("CENTER")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetPoint("TOP", 0, -16)
        lbl:SetText("Note for the last step:")
        lbl:SetTextColor(unpack(ns.Theme.color.text))

        local eb = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
        eb:SetSize(330, 24)
        eb:SetPoint("CENTER", 0, 0)
        eb:SetAutoFocus(true)
        eb:SetScript("OnEnterPressed", function(self)
            local txt = self:GetText()
            if txt and txt ~= "" then ns.Recorder:AddNote(txt) end
            self:SetText("")
            f:Hide()
        end)
        eb:SetScript("OnEscapePressed", function(self) self:SetText("") f:Hide() end)
        f.edit = eb

        local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        hint:SetPoint("BOTTOM", 0, 14)
        hint:SetText("Enter to save, Escape to cancel")
        hint:SetTextColor(unpack(ns.Theme.color.dim))

        self.noteBox = f
    end

    self.noteBox:Show()
    self.noteBox.edit:SetFocus()
end

--------------------------------------------------------------------------
-- Route picker
--------------------------------------------------------------------------

-- The route list changes size (routes installed/removed between opens) and
-- content (which routes exist), so this can't be pure build-once like the
-- fixed-content dialogs - it pools route buttons instead: reuse existing
-- ones, create more as needed, hide any surplus left over from a previous
-- open that had more routes (same shape as Progress.lua's EnsureRow).
local function EnsureRouteButton(f, i)
    local b = f.rowPool[i]
    if not b then
        b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(280, 22)
        b:SetPoint("TOP", 0, -42 - (i - 1) * 26)
        local fs = b:GetFontString()
        if fs then
            local fontFile, _, fontFlags = fs:GetFont()
            fs:SetFont(fontFile, 11, fontFlags)
        end
        ns.Theme:SkinButton(b)
        f.rowPool[i] = b
    end
    return b
end

function Panel:ShowRoutePicker()
    if not self.picker then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(320, 260)
        f:SetPoint("CENTER")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Choose a route")
        t:SetTextColor(unpack(ns.Theme.color.lilac))

        local none = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        none:SetPoint("CENTER")
        none:SetText("No routes installed yet.\nPlay, then Save this as a route.")
        none:SetTextColor(unpack(ns.Theme.color.dim))
        f.none = none

        local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOM", 0, 14)
        close:SetText("Close")
        close:SetScript("OnClick", function() f:Hide() end)
        ns.Theme:SkinButton(close)

        f.rowPool = {}
        self.picker = f
    end

    local f = self.picker

    -- Deterministic order (Phase 3): `pairs` iteration order isn't stable,
    -- so the button order used to reshuffle on every open.
    local names = {}
    for name in pairs(ns.Core.routes) do table.insert(names, name) end
    table.sort(names)

    local count = #names
    for i, name in ipairs(names) do
        local route = ns.Core.routes[name]
        local suffix = ("  (%s-%s)"):format(
            route.levels and route.levels[1] or "?",
            route.levels and route.levels[2] or "?")
        local b = EnsureRouteButton(f, i)

        b:SetText(name .. suffix)

        -- Last resort if it still overflows at the smaller size: trim the
        -- route name (never the level range) with an ellipsis.
        local fs = b:GetFontString()
        if fs then
            local avail = b:GetWidth() - 20
            local trimmed = name
            while fs:GetStringWidth() > avail and #trimmed > 4 do
                trimmed = trimmed:sub(1, #trimmed - 1)
                b:SetText(trimmed .. "..." .. suffix)
            end
        end

        b:SetScript("OnClick", function()
            ns.Core:LoadRoute(name)
            f:Hide()
        end)
        b:Show()
    end

    for i = count + 1, #f.rowPool do
        f.rowPool[i]:Hide()
    end

    f.none:SetShown(count == 0)

    -- Height was fixed at the original 260 regardless of how many routes
    -- exist - with enough routes registered the last rows ran past the
    -- frame's own bottom edge and collided with the Close button anchored
    -- there, which is why Close looked "dead" (a route button was drawn on
    -- top of it and ate the click instead). Grow to fit instead.
    f:SetHeight(math.max(260, 42 + count * 26 + 60))

    f:Show()
end

--------------------------------------------------------------------------
-- Catch-up dialog
--------------------------------------------------------------------------

-- Confirms before jumping, since a route can run to ~3000 steps and
-- Core:CatchUp(true) would otherwise silently teleport the tracked step.
-- Whether a jump is even possible (canJump) changes every open, so both
-- Confirm/Cancel and Close are built once and just shown/hidden per case,
-- rather than rebuilding the button row from scratch each time.
function Panel:ShowCatchUpDialog()
    local Core = ns.Core
    if not Core.active then
        ns.Print("No route loaded.")
        return
    end

    if not self.catchUpBox then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(360, 150)
        f:SetPoint("CENTER")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Catch up on quests")
        t:SetTextColor(unpack(ns.Theme.color.lilac))

        local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        body:SetPoint("TOPLEFT", 20, -46)
        body:SetPoint("TOPRIGHT", -20, -46)
        body:SetJustifyH("LEFT")
        body:SetSpacing(4)
        body:SetTextColor(unpack(ns.Theme.color.text))
        f.body = body

        local confirm = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        confirm:SetSize(100, 22)
        confirm:SetPoint("BOTTOM", -55, 16)
        confirm:SetText("Confirm")
        confirm:SetScript("OnClick", function()
            Core:CatchUp(true)
            f:Hide()
            Panel:Refresh()
        end)
        f.confirm = confirm

        local cancel = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        cancel:SetSize(100, 22)
        cancel:SetPoint("BOTTOM", 55, 16)
        cancel:SetText("Cancel")
        cancel:SetScript("OnClick", function() f:Hide() end)
        f.cancel = cancel

        local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOM", 0, 16)
        close:SetText("Close")
        close:SetScript("OnClick", function() f:Hide() end)
        f.close = close

        ns.Theme:SkinChildren(f)
        self.catchUpBox = f
    end

    local f = self.catchUpBox
    local furthest = Core:PreviewCatchUp()
    local canJump = furthest and furthest > Core.index
    if canJump then
        f.body:SetText(("Jump from step %d to step %d of %d?\nScans forward for quests already done."):format(
            Core.index, furthest, #Core.active.steps))
    else
        f.body:SetText("Already caught up - nothing ahead looks done.")
    end
    f.confirm:SetShown(canJump)
    f.cancel:SetShown(canJump)
    f.close:SetShown(not canJump)

    f:Show()
end

--------------------------------------------------------------------------
-- Resume prompt (shown automatically at login, not from a button)
--------------------------------------------------------------------------

-- Same scan/jump as the Catch-up dialog above, but triggered unprompted
-- when login finds the tracker sitting at step 1 while quest flags say
-- otherwise (SavedVariables loss, or quests done outside the addon).
-- `furthest` is the one thing that changes per open - build once and
-- refresh the body text instead of rebuilding the whole frame.
function Panel:ShowResumePrompt(furthest)
    local Core = ns.Core
    if not Core.active then return end

    if not self.resumeBox then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(360, 150)
        f:SetPoint("CENTER")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Welcome back")
        t:SetTextColor(unpack(ns.Theme.color.lilac))

        local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        body:SetPoint("TOPLEFT", 20, -46)
        body:SetPoint("TOPRIGHT", -20, -46)
        body:SetJustifyH("LEFT")
        body:SetSpacing(4)
        body:SetTextColor(unpack(ns.Theme.color.text))
        f.body = body

        local confirm = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        confirm:SetSize(100, 22)
        confirm:SetPoint("BOTTOM", -55, 16)
        confirm:SetText("Jump")
        confirm:SetScript("OnClick", function()
            Core:CatchUp(true)
            f:Hide()
            Panel:Refresh()
        end)

        local cancel = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        cancel:SetSize(100, 22)
        cancel:SetPoint("BOTTOM", 55, 16)
        cancel:SetText("Not now")
        cancel:SetScript("OnClick", function() f:Hide() end)
        ns.Theme:SkinChildren(f)

        self.resumeBox = f
    end

    local f = self.resumeBox
    f.body:SetText(("You're at step 1, but quests up to step %d of %d already look done.\nJump the tracker to step %d?"):format(
        furthest, #Core.active.steps, furthest))
    -- Show() before fitting height to the body text: on a reopen the frame
    -- starts hidden (Jump/Not now hid it last time), and GetStringHeight()
    -- on a hidden FontString isn't guaranteed to reflect the wrapped text.
    f:Show()
    FitDialogToBody(f, f.body, 46, 60, 150)
end

--------------------------------------------------------------------------
-- Progress code
--------------------------------------------------------------------------

-- A short, copy-pasteable stand-in for SavedVariables when those can't be
-- relied on: encodes route + step with a typo-catching checksum. The code
-- itself changes every open (route/step can move between opens) - build
-- once and refresh the edit box text instead of rebuilding the frame.
function Panel:ShowProgressCode()
    local Core = ns.Core
    local code = Core:GetProgressCode()
    if not code then
        ns.Print("No route loaded.")
        return
    end

    if not self.codeBox then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(360, 150)
        f:SetPoint("CENTER")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Progress code")
        t:SetTextColor(unpack(ns.Theme.color.lilac))

        local help = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        help:SetPoint("TOP", 0, -42)
        help:SetTextColor(unpack(ns.Theme.color.dim))
        help:SetText("Ctrl+C to copy. Restore later with /tuff code <code>")

        local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
        edit:SetSize(300, 24)
        edit:SetPoint("TOP", 0, -68)
        edit:SetAutoFocus(true)
        edit:SetScript("OnEscapePressed", function() f:Hide() end)
        edit:SetScript("OnEnterPressed", function(box) box:HighlightText() end)
        f.edit = edit

        local ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        ok:SetSize(100, 22)
        ok:SetPoint("BOTTOM", 0, 16)
        ok:SetText("Close")
        ok:SetScript("OnClick", function() f:Hide() end)
        ns.Theme:SkinChildren(f)

        self.codeBox = f
    end

    local f = self.codeBox
    f.edit:SetText(code)
    f.edit:HighlightText()

    f:Show()
end

--------------------------------------------------------------------------
-- Help
--------------------------------------------------------------------------

-- Fixed content - build once and reuse on reopen (plan 08 batch 8 / P1.4).
function Panel:ShowHelpDialog()
    if not self.helpBox then
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(420, 280)
        f:SetPoint("CENTER")
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:EnableMouse(true)
        ns.Theme:Skin(f)

        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -14)
        t:SetText("Auto progress & catch-up")
        t:SetTextColor(unpack(ns.Theme.color.lilac))

        local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        body:SetPoint("TOPLEFT", 20, -46)
        body:SetPoint("TOPRIGHT", -20, -46)
        body:SetJustifyH("LEFT")
        body:SetSpacing(4)
        body:SetTextColor(unpack(ns.Theme.color.text))
        body:SetText(
            "The tracker auto-advances on its own. Accepting, completing and " ..
            "turning in a quest all move the current step forward without you " ..
            "doing anything - that's why there's no manual \"done\" button.\n\n" ..
            "|cffffd100Catch-up mode|r is for when you're ahead of the tracker - you " ..
            "already did some of the quests it hasn't caught up to yet (e.g. you " ..
            "loaded a route mid-level, or skipped steps).\n\n" ..
            "|cffffd100/tuff catchup|r previews how far forward it can scan based on " ..
            "quests you've already completed, without moving anything.\n" ..
            "|cffffd100/tuff catchup confirm|r jumps to that step for real.\n\n" ..
            "The |cffffd100Catch up on quests|r button on this menu does the same " ..
            "thing with a confirm dialog instead of typing commands.\n\n" ..
            "|cffffd100Auto accept/turn-in|r (off by default, on by default every " ..
            "login on Forever since it can't remember an explicit off there - " ..
            "toggle top-left on the tracker or in this menu) accepts and turns " ..
            "in quests for you, but only the ones matching your current step, " ..
            "and never guesses when a turn-in has more than one reward to " ..
            "choose from. Hold Shift to skip it for a single dialog without " ..
            "turning it off.\n\n" ..
            "|cffffd100Pace tracking|r runs automatically - the Progress window shows " ..
            "how long your current section is taking versus your best time for it, " ..
            "plus XP/hour and a level ETA. |cffffd100Export splits|r there (or " ..
            "/tuff pace) gives you a copyable summary of the run.\n\n" ..
            "|cffffd100Write a route (text)|r (or /tuff write) is a quicker way to " ..
            "author a route than a Lua table - one line per step, e.g. " ..
            "|cffa0a0a0accept 4641 npc=Kaltunk at=1411,42.6,68.8|r. See " ..
            "CompactGuide.lua's header for the full format.")

        FitDialogToBody(f, body, 46, 60, 160)

        local ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        ok:SetSize(100, 22)
        ok:SetPoint("BOTTOM", 0, 16)
        ok:SetText("Close")
        ok:SetScript("OnClick", function() f:Hide() end)
        ns.Theme:SkinChildren(f)

        self.helpBox = f
    end

    self.helpBox:Show()
end

--------------------------------------------------------------------------
-- Color picker
--------------------------------------------------------------------------

-- Palette changes apply immediately: Theme:ApplyPalette() updates the live
-- color tables and Theme:ReapplyAll() repaints every already-built frame
-- Skin()/SkinButton() touched, instead of waiting for the next /reload.
-- Content is fixed (ns.Theme.presets doesn't change at runtime) - build
-- once and reuse on reopen, same as the other fixed-content dialogs (plan
-- 08 batch 8 / P1.4; the audit correction over the original finding is
-- that this one does NOT need a button pool, unlike ShowRoutePicker).
function Panel:ShowColorPicker()
    -- Also reachable via /tuff colors with a submenu open; Display settings
    -- stays (this is opened from it), Content & Import must not.
    if self.contentMenu then self.contentMenu:Hide() end
    if self.colorPicker then
        self.colorPicker:Show()
        return
    end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    local presetNames = {}
    for name in pairs(ns.Theme.presets) do table.insert(presetNames, name) end
    table.sort(presetNames)

    -- Height follows the preset count so the Close button always sits below
    -- the last preset instead of clipping into leftover content.
    f:SetSize(280, 42 + 26 * #presetNames + 50)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(true)
    ns.Theme:Skin(f)

    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -14)
    t:SetText("Colors")
    t:SetTextColor(unpack(ns.Theme.color.lilac))

    local y = -42
    for _, name in ipairs(presetNames) do
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(200, 22)
        b:SetPoint("TOP", 0, y)
        b:SetText(name)
        b:SetScript("OnClick", function()
            local db = Compat:InitSavedVar("TuFFlevelsDB")
            db.customTheme = ns.Theme.presets[name]
            ns.Theme:ApplyPalette(db.customTheme)
            ns.Theme:ReapplyAll()
            ns.Print(("Palette set to %s."):format(name))
        end)
        y = y - 26
    end

    local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    close:SetSize(100, 22)
    close:SetPoint("BOTTOM", 0, 14)
    close:SetText("Close")
    close:SetScript("OnClick", function() f:Hide() end)
    ns.Theme:SkinChildren(f)

    self.colorPicker = f
    f:Show()
end
