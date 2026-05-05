-- ~/.config/awesome/themes/i3lock_theme_generator.lua
--
-- Generates an i3lock-color shell script from the AwesomeWM luci4 theme.
-- i3lock-color has no config file — it's driven entirely by CLI flags,
-- so we generate a shell script that invokes it with theme-matched colours.
--
-- Requires: i3lock-color (AUR)
-- Call: require("themes.i3lock_theme_generator").generate()
--
-- Flag names verified against i3lock-color(1) manpage.

local beautiful = require("themes.luci4.theme")

local M = {}

--- Configuration — override before calling generate() if needed
M.config = {
    outputPath    = os.getenv("HOME") .. "/scripts/wm_common/lockscreen.sh",
    useBlur       = false,
    blurAmount    = 9,
    showClock     = true,
    timeFormat    = "%H:%M", -- "%H:%M:%S",
    dateFormat    = "%A, %Y-%m-%d",
    showKeyLayout = false,
    screen        = 1,
    -- Font sizes for lock screen (larger than WM fonts)
    timeSize      = 66,
    dateSize      = 21,
    verifSize     = 21,
    wrongSize     = 21,
    layoutSize    = 44,
    -- Indicator geometry
    radius        = 190,
    ringWidth    = 16,
    -- Custom text
    verifText     = "Checking...",
    wrongText     = "Wrong pswd",
    noInputText   = "No Input",
    lockText      = "Locking...",
    lockFailedText = "Lock Failed",
    -- Key passthrough
    passMediaKeys  = true,
    passScreenKeys = true,
    passVolumeKeys = true,
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

--- Convert RGB hex + alpha to #RRGGBBAA format for i3lock-color.
--- i3lock-color uses RRGGBBAA: 6-char RGB + 2-char alpha at the END.
--- The # prefix is accepted (confirmed by working configs).
--- @param hex string RGB hex like "#4980ac" or "4980ac"
--- @param alpha string 2-char hex alpha: "FF"=opaque, "E6"=~90%, "00"=transparent
--- @return string 9-char #RRGGBBAA hex like "#4980ACE6"
local function rgba(hex, alpha)
    local rgb = hex:gsub("^#", "")
    return "#" .. string.upper(rgb .. alpha)
end

--- Ensure the parent directory of `path` exists.
local function ensureDir(path)
    local dir = path:match("^(.*/)")
    if dir and dir ~= "" then
        os.execute("mkdir -p '" .. dir .. "'")
    end
end

function M.generate()
    local t   = beautiful
    local cfg = M.config

    -- ============ COLOUR PALETTES ============
    local colour1 = t.colour1 or {}
    local colour2 = t.colour2 or {}
    local red     = t.errorColour or "#91231c"

    -- ============ ALPHA VALUES ============
    local OPAQUE  = "FF"  -- 100%
    local HIGH    = "E6"  -- ~90%
    local MID     = "CC"  -- ~80%
    local LOW     = "40"  -- ~25%
    local NONE    = "00"  -- fully transparent

    -- ============ COLOUR MAPPING ============
    local bgNormal      = t.bg_normal     or colour1.shade9 or "#191611"
    local fgNormal      = t.fg_normal     or colour1.tint5  or "#ffeed6"
    local borderNormal  = t.border_normal  or colour1.main   or "#ffdead"
    local ringIdle      = colour2.main    or "#4980ac"
    local ringVerify    = colour2.tint4   or "#91b2cd"
    local insideVerify  = colour2.shade9  or "#070c11"
    local separator     = colour2.shade4   or "#2b4c67"

    -- ============ FONT MAPPING ============
    local sansFontFamily = t.fontFamily_main or extractFontFamily(t.font)
    local mainFontFamily = t.fontFamily_sans  or extractFontFamily(t.tasklist_font)

    -- ============ BUILD i3lock ARGUMENTS ============
    local args = {}

    -- Background: solid colour or blur
    if cfg.useBlur then
        table.insert(args, string.format("--blur %d", cfg.blurAmount))
    else
        table.insert(args, string.format("--color=%s", rgba(bgNormal, OPAQUE)))
    end

    -- Ring and indicator colours
    table.insert(args, string.format("--inside-color=%s",      rgba(bgNormal, HIGH)))
    table.insert(args, string.format("--ring-color=%s",       rgba(ringIdle, HIGH)))
    table.insert(args, string.format("--insidever-color=%s",   rgba(insideVerify, HIGH)))
    table.insert(args, string.format("--ringver-color=%s",     rgba(ringVerify, HIGH)))
    table.insert(args, string.format("--insidewrong-color=%s", rgba(red, LOW)))
    table.insert(args, string.format("--ringwrong-color=%s",   rgba(red, HIGH)))
    table.insert(args, "--line-uses-ring")
    table.insert(args, string.format("--separator-color=%s",  rgba(separator, HIGH)))

    -- Text colours
    table.insert(args, string.format("--verif-color=%s",   rgba(fgNormal, OPAQUE)))
    table.insert(args, string.format("--wrong-color=%s",   rgba(fgNormal, OPAQUE)))
    table.insert(args, string.format("--modif-color=%s",   rgba(red, OPAQUE)))
    table.insert(args, string.format("--time-color=%s",   rgba(fgNormal, OPAQUE)))
    table.insert(args, string.format("--date-color=%s",   rgba(fgNormal, MID)))
    table.insert(args, string.format("--layout-color=%s", rgba(fgNormal, MID)))

    -- Key feedback
    table.insert(args, string.format("--keyhl-color=%s", rgba(borderNormal, HIGH)))
    table.insert(args, string.format("--bshl-color=%s",  rgba(red, HIGH)))

    -- Fonts — QUOTED because font names with spaces get split by the shell
    table.insert(args, string.format('--time-font="%s"',   mainFontFamily))
    table.insert(args, string.format("--time-size=%d",    cfg.timeSize))
    table.insert(args, string.format('--date-font="%s"',   sansFontFamily))
    table.insert(args, string.format("--date-size=%d",    cfg.dateSize))
    table.insert(args, string.format('--verif-font="%s"',  sansFontFamily))
    table.insert(args, string.format("--verif-size=%d",    cfg.verifSize))
    table.insert(args, string.format('--wrong-font="%s"',  sansFontFamily))
    table.insert(args, string.format("--wrong-size=%d",    cfg.wrongSize))
    table.insert(args, string.format('--layout-font="%s"', sansFontFamily))
    table.insert(args, string.format("--layout-size=%d",  cfg.layoutSize))

    -- Indicator geometry
    table.insert(args, "--indicator")
    table.insert(args, string.format("--radius=%d",       cfg.radius))
    table.insert(args, string.format("--ring-width=%d",   cfg.ringWidth))
    table.insert(args, string.format("--screen %d",       cfg.screen))

    -- Clock
    if cfg.showClock then
        table.insert(args, "--clock")
        table.insert(args, string.format('--time-str="%s"', cfg.timeFormat))
        table.insert(args, string.format('--date-str="%s"', cfg.dateFormat))
    end

    -- Custom text
    table.insert(args, string.format('--verif-text="%s"',    cfg.verifText))
    table.insert(args, string.format('--wrong-text="%s"',    cfg.wrongText))
    table.insert(args, string.format('--noinput="%s"',       cfg.noInputText))
    table.insert(args, string.format('--lock-text="%s"',     cfg.lockText))
    table.insert(args, string.format('--lockfailed="%s"',    cfg.lockFailedText))

    -- Key passthrough
    if cfg.passMediaKeys then
        table.insert(args, "--pass-media-keys")
    end
    if cfg.passScreenKeys then
        table.insert(args, "--pass-screen-keys")
    end
    if cfg.passVolumeKeys then
        table.insert(args, "--pass-volume-keys")
    end

    -- Keyboard layout
    if cfg.showKeyLayout then
        table.insert(args, "--keylayout 1")
    end

    -- ============ BUILD SHELL SCRIPT ============
    local header = string.format(
[[#!/bin/sh
# Auto-generated by i3lock_theme_generator.lua
# Generated: %s
# Themed for i3lock-color (AUR: i3lock-color)
# DO NOT EDIT — regenerate via: require("themes.i3lock_theme_generator").generate()
#
# If fonts don't render, verify the family name matches fontconfig:
#   fc-list | grep -i terminess
#   fc-list | grep -i ubuntusans

]], os.date("!%Y-%m-%dT%H:%M:%SZ"))

    local argLines = {}
    for i, arg in ipairs(args) do
        if i < #args then
            table.insert(argLines, "  " .. arg .. " \\")
        else
            table.insert(argLines, "  " .. arg)
        end
    end

    local script = header .. "i3lock \\\n" .. table.concat(argLines, "\n") .. "\n"

    -- ============ WRITE TO FILE ============
    ensureDir(cfg.outputPath)

    local f, err = io.open(cfg.outputPath, "w")
    if not f then
        io.stderr:write("i3lock_theme_generator: " .. tostring(err) .. "\n")
        return false
    end
    f:write(script)
    f:close()

    os.execute("chmod +x '" .. cfg.outputPath .. "'")

    return true
end

return M

