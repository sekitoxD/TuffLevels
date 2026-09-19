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
    text     = { 0.94, 0.88, 0.90 },
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
    text    = "|cfff0e0e6",
    dim     = "|cff8c7380",
    faint   = "|cff594753",
    done    = "|cff73cc8c",
    warn    = "|cfff2bf59",
}

local function unpackc(c, a)
    return c[1], c[2], c[3], a or 1
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
