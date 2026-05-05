-- ~/.config/awesome/themes/rofi_theme_generator.lua
--
-- Generates Rofi .rasi theme files from the AwesomeWM luci4 theme.
-- Call AFTER beautiful.init() in rc.lua:
--   require("themes.rofi_theme_generator").generate()

local beautiful = require("themes.luci4.theme")
local rofiTemplate = require("themes.rofi_template")
local rofiDmenuTemplate = require("themes.rofi_dmenu_template")

local M = {}

--- Configuration — override these before calling generate() if needed
M.config = {
    mainFontSize    = "22",
    mainFontWeight  = "Medium",
    promptFontSize  = "22",
    promptFontWeight = "Bold",
    promptPadding   = "4px",
    spacing         = 3,
    outputPath      = os.getenv("HOME") .. "/.config/rofi/themes/luci4.rasi",
    dmenuOutputPath = os.getenv("HOME") .. "/.config/rofi/themes/luci4-dmenu.rasi",
    dmenuHeight     = "40px",
}

--- Extract font family from a pango-style font string.
--- "Terminess Nerd Font SemiBold 12.5" → "Terminess Nerd Font"
--- "UbuntuSans Nerd Font 11"          → "UbuntuSans Nerd Font"
local function extractFontFamily(fontStr)
    if not fontStr then return "monospace" end
    local family = fontStr:gsub("%s+%d+%.?%d*%s*$", "")
    local weights = {
        "SemiBold", "Bold", "Medium", "Light", "Heavy",
        "Thin", "ExtraBold", "ExtraLight", "DemiBold",
        "Black", "Regular", "Italic", "Oblique",
    }
    for _, w in ipairs(weights) do
        family = family:gsub("%s+" .. w .. "%s*$", "")
    end
    return family
end

function M.generate()
    local t   = beautiful
    local cfg = M.config

    -- ============ COLOUR PALETTES ============
    local colour1 = t.colour1 or {}
    local colour2 = t.colour2 or {}

    -- ============ COLOUR MAPPING ============
    local backgroundColor            = t.bg_normal          or colour1.shade9 or "#191611"
    local borderColor                = t.border_normal      or colour1.main  or "#ffdead"
    local textColor                  = t.fg_normal         or colour1.tint5 or "#ffeed6"
    local promptBackground           = colour2.main        or "#4980ac"
    local promptForeground           = colour2.shade9      or "#070c11"
    local alternateNormalBackground  = colour2.shade8      or "#0e1922"
    local alternateNormalForeground  = textColor
    local selectedNormalBackground   = colour2.shade6      or "#91231c"
    local selectedNormalForeground   = "#ffffff"
    local listviewBorderColor        = alternateNormalBackground

    -- ============ FONT MAPPING ============
    local mainFontFamily = t.fontFamily_main or extractFontFamily(t.font)
    local sansFontFamily = t.fontFamily_sans  or extractFontFamily(t.tasklist_font)
    local rofiFont       = mainFontFamily .. " " .. cfg.mainFontWeight  .. " " .. cfg.mainFontSize
    local rofiPromptFont = sansFontFamily .. " " .. cfg.promptFontWeight .. " " .. cfg.promptFontSize

    -- ============ DIMENSIONS ============
    local borderWidth = t.border_width_dpi or t.border_width or 2
    local rectRadius  = t.rect_radius or 4

    -- ============ SHARED DATA TABLE ============
    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")

    local data = {
        date                       = timestamp,
        backgroundColor            = backgroundColor,
        borderColor                = borderColor,
        textColor                  = textColor,
        rofiFont                   = rofiFont,
        rofiPromptFont             = rofiPromptFont,
        promptBackground           = promptBackground,
        promptForeground           = promptForeground,
        promptPadding              = cfg.promptPadding,
        alternateNormalBackground  = alternateNormalBackground,
        alternateNormalForeground  = alternateNormalForeground,
        selectedNormalBackground   = selectedNormalBackground,
        selectedNormalForeground   = selectedNormalForeground,
        spacing                    = cfg.spacing,
        borderWidth                = borderWidth,
        rectRadius                 = rectRadius,
        listviewBorderColor        = listviewBorderColor,
        outputPath                 = cfg.outputPath,
        -- dmenu-specific
        dmenuHeight                = cfg.dmenuHeight,
        dmenuOutputPath            = cfg.dmenuOutputPath,
    }

    -- ============ GENERATE BOTH FILES ============
    local ok1 = rofiTemplate.generate(data)
    local ok2 = rofiDmenuTemplate.generate(data)

    return ok1 and ok2
end

return M

