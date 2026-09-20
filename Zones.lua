-- TuFFlevels / Zones.lua
--
-- Where to be, by level. Horde, vanilla progression.
--
-- This is authored knowledge, not database lookup - which is why it works
-- on every client including Forever, where no quest database exists yet.
-- It answers "I'm done here, where now" without needing to know a single
-- quest ID.
--
-- Forever adds new zones. When those settle, add them here.

local ADDON, ns = ...

local Zones = {}
ns.Zones = Zones

-- min/max are the practical band, not the absolute limits.
-- hub = where you base yourself. travel = how you get there.
Zones.horde = {
    { min = 1,  max = 6,  name = "Valley of Trials",     hub = "Valley of Trials",
      races = { "Orc", "Troll" },
      note = "Starting area. Clear it out before you leave, it's dense." },

    { min = 1,  max = 6,  name = "Deathknell",            hub = "Deathknell",
      races = { "Scourge" },
      note = "Undead start." },

    { min = 1,  max = 6,  name = "Red Cloud Mesa",        hub = "Camp Narache",
      races = { "Tauren" },
      note = "Tauren start." },

    { min = 6,  max = 12, name = "Durotar",               hub = "Razor Hill",
      races = { "Orc", "Troll" },
      note = "Razor Hill and Sen'jin Village. Grab the Razor Hill flight path." },

    { min = 6,  max = 12, name = "Tirisfal Glades",       hub = "Brill",
      races = { "Scourge" },
      note = "Brill, then the Undercity." },

    { min = 6,  max = 12, name = "Mulgore",               hub = "Bloodhoof Village",
      races = { "Tauren" },
      note = "Bloodhoof, then Thunder Bluff." },

    { min = 10, max = 20, name = "The Barrens",           hub = "The Crossroads",
      note = "The great Horde funnel. Everyone ends up here. Crossroads flight path first, then work outward. Ratchet in the east for the Wailing Caverns run." },

    { min = 10, max = 20, name = "Silverpine Forest",     hub = "The Sepulcher",
      note = "Alternative to the Barrens if it's overcrowded. Lighter quest density but far less competition." },

    { min = 18, max = 25, name = "Hillsbrad Foothills",   hub = "Tarren Mill",
      note = "Contested and PvP-heavy on a PvP realm. Good density if you can survive it." },

    { min = 20, max = 25, name = "Stonetalon Mountains",  hub = "Sun Rock Retreat",
      note = "Pairs with the Barrens. Lots of running, moderate payoff." },

    { min = 20, max = 27, name = "Ashenvale",             hub = "Splintertree Post",
      note = "Strong quest density. Contested with Alliance throughout." },

    { min = 25, max = 30, name = "Thousand Needles",      hub = "Freewind Post",
      note = "Compact, quick to clear. Shimmering Flats racetrack quests." },

    { min = 25, max = 30, name = "Arathi Highlands",      hub = "Hammerfall",
      note = "Eastern Kingdoms option. Reachable by zeppelin then a run." },

    { min = 30, max = 35, name = "Desolace",              hub = "Shadowprey Village",
      note = "Centaur reputation quests are repeatable and fast." },

    { min = 30, max = 38, name = "Stranglethorn Vale",    hub = "Grom'gol Base Camp",
      note = "Enormous zone, huge quest count, brutal PvP. Zeppelin from Durotar straight to Grom'gol." },

    { min = 33, max = 38, name = "Dustwallow Marsh",      hub = "Brackenwall Village",
      note = "Sparse but the quests are short." },

    { min = 35, max = 40, name = "Badlands",              hub = "Kargath",
      note = "Tight quest cluster around Kargath. Fast levels if you like grinding." },

    { min = 35, max = 42, name = "Swamp of Sorrows",      hub = "Stonard",
      note = "Thin zone. Usually a stopover rather than a stay." },

    { min = 40, max = 45, name = "Tanaris",               hub = "Gadgetzan",
      note = "Gadgetzan flight path is a major hub. Zul'Farrak runs start here." },

    { min = 40, max = 47, name = "Feralas",               hub = "Camp Mojache",
      note = "Good density, low traffic compared to STV." },

    { min = 42, max = 48, name = "The Hinterlands",       hub = "Revantusk Village",
      note = "Revantusk is easy to miss on the far east coast." },

    { min = 45, max = 50, name = "Un'Goro Crater",        hub = "Marshal's Refuge",
      note = "Dense and self-contained. Also the Devilsaur leather farm." },

    { min = 45, max = 52, name = "Azshara",               hub = "Valormok",
      note = "Beautiful, badly laid out, lots of travel." },

    { min = 48, max = 54, name = "Felwood",               hub = "Bloodvenom Post",
      note = "Timbermaw reputation starts here and carries into Winterspring." },

    { min = 48, max = 55, name = "Burning Steppes",       hub = "Flame Crest",
      note = "Gateway to Blackrock. Get the flight path early." },

    { min = 50, max = 56, name = "Western Plaguelands",   hub = "The Bulwark",
      note = "Scholomance and Stratholme attunement work begins around here." },

    { min = 52, max = 58, name = "Winterspring",          hub = "Everlook",
      note = "Everlook is the northern hub. Black Lotus spawns here." },

    { min = 54, max = 60, name = "Eastern Plaguelands",   hub = "Light's Hope Chapel",
      note = "Final stretch. Argent Dawn reputation matters for raid consumables later." },

    { min = 55, max = 60, name = "Silithus",              hub = "Cenarion Hold",
      note = "Thin questing, but the reputation and Black Lotus are worth knowing about." },

    { min = 55, max = 60, name = "Blasted Lands",         hub = "Nethergarde (hostile)",
      note = "Demon grinding more than questing. Good if you're short of quests." },
}

--------------------------------------------------------------------------
-- Lookups
--------------------------------------------------------------------------

function Zones:ForLevel(level, race)
    local out = {}
    for _, z in ipairs(self.horde) do
        if level >= z.min and level <= z.max then
            local ok = true
            if z.races then
                ok = false
                for _, r in ipairs(z.races) do
                    if r == race then ok = true break end
                end
            end
            if ok then table.insert(out, z) end
        end
    end
    return out
end

-- What comes after where you are now.
function Zones:NextFor(level, race)
    local best, bestMin = nil, math.huge
    for _, z in ipairs(self.horde) do
        if z.min > level and z.min < bestMin then
            if not z.races then
                best, bestMin = z, z.min
            else
                for _, r in ipairs(z.races) do
                    if r == race then best, bestMin = z, z.min break end
                end
            end
        end
    end
    return best
end

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------

local win

function Zones:Show()
    if not win then
        win = CreateFrame("Frame", "TuFFlevelsZones", UIParent, "BackdropTemplate")
        win:SetSize(460, 380)
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
        t:SetText("Where to go next")

        local scroll = CreateFrame("ScrollFrame", "TuFFlevelsZonesScroll", win,
                                   "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 18, -40)
        scroll:SetPoint("BOTTOMRIGHT", -34, 46)

        local body = CreateFrame("Frame", nil, scroll)
        body:SetSize(400, 10)
        scroll:SetScrollChild(body)

        win.text = body:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        win.text:SetPoint("TOPLEFT")
        win.text:SetWidth(390)
        win.text:SetJustifyH("LEFT")
        win.text:SetSpacing(3)
        win.text:SetTextColor(unpack(ns.Theme.color.text))
        win.body = body

        local close = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        close:SetSize(100, 22)
        close:SetPoint("BOTTOM", 0, 16)
        close:SetText("Close")
        close:SetScript("OnClick", function() win:Hide() end)
        ns.Theme:SkinChildren(win)
        t:SetTextColor(unpack(ns.Theme.color.lilac))
    end

    local level = UnitLevel("player")
    local _, race = UnitRace("player")

    local lines = {}
    table.insert(lines, ("|cffffd100You are level %d.|r"):format(level))
    table.insert(lines, "")

    local current = self:ForLevel(level, race)
    if #current > 0 then
        table.insert(lines, "|cff00ff00Right now you should be in:|r")
        for _, z in ipairs(current) do
            table.insert(lines, ("  |cffffd100%s|r  (%d-%d)  base at %s")
                :format(z.name, z.min, z.max, z.hub))
            table.insert(lines, ("     |cff909090%s|r"):format(z.note))
        end
    else
        table.insert(lines, "|cffff5555No zone matches your level in the table.|r")
    end

    local nxt = self:NextFor(level, race)
    if nxt then
        table.insert(lines, "")
        table.insert(lines, ("|cff80c0ffNext, at level %d:|r"):format(nxt.min))
        table.insert(lines, ("  |cffffd100%s|r  base at %s"):format(nxt.name, nxt.hub))
        table.insert(lines, ("     |cff909090%s|r"):format(nxt.note))
    end

    table.insert(lines, "")
    table.insert(lines, "|cff707070Where several zones overlap, pick by what's least")
    table.insert(lines, "crowded on your realm. Density beats theoretical best.|r")

    win.text:SetText(table.concat(lines, "\n"))
    win.body:SetHeight(math.max(10, win.text:GetStringHeight() + 20))
    win:Show()
end
