-- TuFFlevels / Theme.lua
--
-- Red, black, purple. Applied to every frame the addon makes so it reads as
-- one thing rather than stock Blizzard dialogs.

local ADDON, ns = ...

local Theme = {}
ns.Theme = Theme

--------------------------------------------------------------------------
-- Palette
--------------------------------------------------------------------------

Theme.color = {
    -- backgrounds, darkest to lightest
    void     = { 0.04, 0.01, 0.01 },
    bg       = { 0.08, 0.02, 0.02 },
    panel    = { 0.12, 0.03, 0.04 },
    raised   = { 0.17, 0.05, 0.06 },

    -- reds
    blood    = { 0.45, 0.06, 0.09 },
    ember    = { 0.70, 0.12, 0.15 },

    -- purples, the accent
    violet   = { 0.48, 0.24, 0.78 },
    orchid   = { 0.66, 0.42, 0.95 },
    lilac    = { 0.80, 0.65, 1.00 },

    -- text
    text     = { 1.00, 0.97, 0.98 },
    dim      = { 0.55, 0.45, 0.50 },
    faint    = { 0.35, 0.28, 0.32 },

    done     = { 0.45, 0.80, 0.55 },
    warn     = { 0.95, 0.75, 0.35 },
}

-- Hex strings for inline text coloring
Theme.hex = {
    accent  = "|cffa96bf2",
    bright  = "|cffcca6ff",
    ember   = "|cffb31f26",
    text    = "|cfffff7fa",
    dim     = "|cff8c7380",
    faint   = "|cff594753",
    done    = "|cff73cc8c",
    warn    = "|cfff2bf59",
}

local function unpackc(c, a)
    return c[1], c[2], c[3], a or 1
end

--------------------------------------------------------------------------
-- Presets and custom import
--------------------------------------------------------------------------

-- Each preset is a flat {key = "RRGGBB"} table covering every key in both
-- Theme.color and Theme.hex. "Default" is the palette above, spelled out
-- as hex so all presets share one format.
Theme.presets = {
    Default = {
        void = "0a0303", bg = "140505", panel = "1f080a", raised = "2b0d0f",
        blood = "731017", ember = "b31f26",
        violet = "7a3dc7", orchid = "a96bf2", lilac = "ccaaff",
        text = "fff7fa", dim = "8c7380", faint = "594753",
        done = "73cc8c", warn = "f2bf59",
    },
    Azure = {
        void = "03060a", bg = "050a14", panel = "081120", raised = "0d182b",
        blood = "17406b", ember = "1f66a3",
        violet = "3d7ac7", orchid = "6ba9f2", lilac = "aaccff",
        text = "f7fbff", dim = "7380a0", faint = "475159",
        done = "73cc8c", warn = "f2bf59",
    },
    Verdant = {
        void = "030a04", bg = "05140a", panel = "08200f", raised = "0d2b16",
        blood = "17732b", ember = "1fa33f",
        violet = "3dc768", orchid = "6bf29a", lilac = "aaffcc",
        text = "f7fff9", dim = "76a082", faint = "475950",
        done = "73cc8c", warn = "f2bf59",
    },
    Amber = {
        void = "0a0703", bg = "140d05", panel = "201608", raised = "2b1e0d",
        blood = "734a17", ember = "a3711f",
        violet = "c78e3d", orchid = "f2b06b", lilac = "ffd9aa",
        text = "fffaf7", dim = "a08f73", faint = "594e47",
        done = "73cc8c", warn = "f2bf59",
    },
}

local function hexToRGB(hex)
    hex = hex:gsub("^|cff", ""):gsub("^#", "")
    if not hex:match("^%x%x%x%x%x%x$") then return nil end
    return tonumber(hex:sub(1, 2), 16) / 255,
           tonumber(hex:sub(3, 4), 16) / 255,
           tonumber(hex:sub(5, 6), 16) / 255
end

-- Overwrites the existing color/hex tables' keys IN PLACE (never replaces
-- the table objects) so any code holding a reference to one of the inner
-- {r,g,b} triplets still sees the update.
function Theme:ApplyPalette(flat)
    for key, hex in pairs(flat) do
        local r, g, b = hexToRGB(hex)
        if r then
            local c = self.color[key]
            if c then
                c[1], c[2], c[3] = r, g, b
            end
            if self.hex[key] then
                self.hex[key] = ("|cff%s"):format(hex:gsub("^|cff", ""):gsub("^#", ""))
            end
        end
    end

    -- Theme.hex.accent/bright have no matching Theme.color key of the same
    -- name - they're the inline-text hex forms of the orchid/lilac accent
    -- colors. Derive them from a preset's orchid/lilac unless the caller
    -- set accent/bright directly (handled by the loop above already).
    if flat.orchid and not flat.accent then
        self.hex.accent = ("|cff%s"):format(flat.orchid:gsub("^|cff", ""):gsub("^#", ""))
    end
    if flat.lilac and not flat.bright then
        self.hex.bright = ("|cff%s"):format(flat.lilac:gsub("^|cff", ""):gsub("^#", ""))
    end
end

-- Reads TuFFlevelsDB.customTheme (saved by Panel's color picker) and
-- applies it. Runs on PLAYER_LOGIN, before any frame's first Build() this
-- session, so a saved palette is in effect by the time anything draws.
function Theme:LoadSaved()
    local Compat = ns.Compat
    if not Compat then return end
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    if db.customTheme then
        self:ApplyPalette(db.customTheme)
    end
end

--------------------------------------------------------------------------
-- Frame skinning
--------------------------------------------------------------------------

-- Replaces the stock dialog look with a flat dark panel and a thin
-- red edge lit with purple at the top.
function Theme:Skin(frame, opts)
    opts = opts or {}
    if not frame then return frame end

    if frame.SetBackdrop then
        frame:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 1,
            insets   = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        frame:SetBackdropColor(unpackc(opts.bg or self.color.bg, opts.alpha or 0.96))
        frame:SetBackdropBorderColor(unpackc(self.color.blood, 1))
    else
        -- Older frames without backdrop support: fake it with textures.
        if not frame._bgTex then
            local t = frame:CreateTexture(nil, "BACKGROUND")
            t:SetAllPoints()
            frame._bgTex = t
        end
        frame._bgTex:SetColorTexture(unpackc(opts.bg or self.color.bg, opts.alpha or 0.96))
    end

    -- a purple hairline along the top edge
    if not frame._accentLine then
        local a = frame:CreateTexture(nil, "BORDER")
        a:SetPoint("TOPLEFT", 1, -1)
        a:SetPoint("TOPRIGHT", -1, -1)
        a:SetHeight(2)
        a:SetColorTexture(unpackc(self.color.violet, 0.9))
        frame._accentLine = a
    end

    -- subtle vertical fade, dark at the bottom
    if not frame._fade then
        local f = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
        f:SetPoint("TOPLEFT", 1, -3)
        f:SetPoint("BOTTOMRIGHT", -1, 1)
        f:SetColorTexture(1, 1, 1, 1)
        f:SetGradient("VERTICAL",
            CreateColor and CreateColor(0, 0, 0, 0.55) or nil,
            CreateColor and CreateColor(self.color.blood[1] * 0.5,
                                        self.color.blood[2] * 0.5,
                                        self.color.blood[3] * 0.5, 0.18) or nil)
        frame._fade = f
    end

    return frame
end

--------------------------------------------------------------------------
-- Buttons
--------------------------------------------------------------------------

function Theme:SkinButton(button)
    if not button or button._themed then return button end
    button._themed = true

    -- strip the stock art
    for _, region in ipairs({ button:GetRegions() }) do
        if region:GetObjectType() == "Texture" then
            local tex = region:GetTexture()
            if tex and type(tex) == "string" and tex:find("UI%-Panel%-Button") then
                region:SetTexture(nil)
            end
        end
    end

    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(unpackc(self.color.raised, 0.95))
    button._bg = bg

    local edge = button:CreateTexture(nil, "BORDER")
    edge:SetPoint("BOTTOMLEFT")
    edge:SetPoint("BOTTOMRIGHT")
    edge:SetHeight(1)
    edge:SetColorTexture(unpackc(self.color.violet, 0.7))

    local fs = button:GetFontString()
    if fs then fs:SetTextColor(unpackc(self.color.text)) end

    button:HookScript("OnEnter", function(self)
        if self._bg then self._bg:SetColorTexture(unpackc(Theme.color.blood, 0.95)) end
        local t = self:GetFontString()
        if t then t:SetTextColor(unpackc(Theme.color.lilac)) end
    end)
    button:HookScript("OnLeave", function(self)
        if self._bg then self._bg:SetColorTexture(unpackc(Theme.color.raised, 0.95)) end
        local t = self:GetFontString()
        if t then t:SetTextColor(unpackc(Theme.color.text)) end
    end)

    return button
end

-- Skin every UIPanelButtonTemplate child of a frame in one call.
function Theme:SkinChildren(frame)
    if not frame then return end
    for _, child in ipairs({ frame:GetChildren() }) do
        if child.GetFontString and child:GetObjectType() == "Button" then
            self:SkinButton(child)
        end
    end
end

--------------------------------------------------------------------------
-- Text helpers
--------------------------------------------------------------------------

function Theme:Accent(s)  return self.hex.accent .. tostring(s) .. "|r" end
function Theme:Bright(s)  return self.hex.bright .. tostring(s) .. "|r" end
function Theme:Dim(s)     return self.hex.dim    .. tostring(s) .. "|r" end
function Theme:Ember(s)   return self.hex.ember  .. tostring(s) .. "|r" end
