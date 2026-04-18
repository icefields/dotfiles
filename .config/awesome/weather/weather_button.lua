
-----------------------------------------------------
-- ----------------------------------------------- --
--   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄   --
--  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌  --
--  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌  --
--   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀   --
-- ----------------------------------------------- --
-- -------- Luci4 config for Awesome WM  --------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------

local config = require("config")
local apiBase = "https://wttr.in/" .. config.env.LOCATION_COORDINATES
local cachedWeatherFile = os.getenv("HOME") .. "/.cache/current_weather"
local cachedWeatherScript = "cat " .. cachedWeatherFile
local fetchSaveWeatherScript = "curl -s '" .. apiBase .. "?Tm' -o tmpWtr && [ -s tmpWtr ] && mv tmpWtr ".. cachedWeatherFile .. " || rm -f tmpWtr"
local fetchWeatherIconScript = "curl -s '" .. apiBase .. "?m&format=%c+%t+%h'" -- "?format=%c'"
local fallbackLoadingText = "Loading weather ..."
local fallbackErrorText = "Error fetching weather"

local function setWeatherText(awful, beautiful, gears, script, textField, fallbackText, isMarkup, callback)
    awful.spawn.easy_async_with_shell(script, function(stdout)
        if not stdout or stdout:match("^%s*$") then -- if response is blank
            --textField.text = fallbackText
            textField.markup = "<span font='" .. beautiful.topBar_buttonTooltip_font .. "'>" .. gears.string.xml_escape(fallbackText:gsub("%s+$", "")) .. "</span>"
        else
            if isMarkup then
                textField.markup = "<span font='" .. 
                    beautiful.topBar_buttonTooltip_font .. "'>" .. gears.string.xml_escape(
                    os.date("%a %b %d, %H:%M") .. "\n" .. stdout:gsub("%s+$", "")
                    ) .. "</span>"
            else
                textField.text = stdout:gsub("%s+$", "")
            end
        end
        if callback then callback(stdout) end
    end)
end

local function createWeatherTooltip(button, args)
    local awful = args.awful
    local beautiful = args.beautiful
    local gears = args.gears

    local weatherTooltip = awful.tooltip {
        objects = { button },
        mode = "outside",
        align = "top",
        margin_leftright = 8,
        margin_topbottom = 4,
        preferred_positions = { "top", "bottom" },
        text = fallbackLoadingText,
        bg = beautiful.tooltip_bg_color,
        fg = beautiful.tooltip_fg_color,
        font = beautiful.topBar_button_font
    }

    button:connect_signal("mouse::enter", function(c)
        -- If cached version available, show it first
        setWeatherText(awful, beautiful, gears, cachedWeatherScript, weatherTooltip, fallbackLoadingText, true, function(stdout)
            local fallback = stdout
            if not stdout or stdout:match("^%s*$") then fallback = fallbackErrorText end
            setWeatherText(awful, beautiful, gears, fetchSaveWeatherScript .. " && " .. cachedWeatherScript, weatherTooltip, fallback, true)
        end)
    end)

    return weatherTooltip
end

local function getButton(args)
    local gears = args.gears
    local awful = args.awful
    local beautiful = args.beautiful
    local wibox = args.wibox
    local fallbackIcon = "⸸"
    local applyDpi = args.applyDpi

    local iconWidget = {
        id = "icon",
        text = fallbackIcon,
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        font = beautiful.topBar_button_font
    }

    -- Button with an icon (font-based or symbol).
    local bgWidget = wibox.widget {
        iconWidget,
        widget = wibox.container.background,
        bg = "#00000000",
        fg = beautiful.topBar_fg,
        shape = gears.shape.rounded_bar,
        forced_height = applyDpi(beautiful.topBar_buttonSize)
    }
    local button = wibox.widget {
        bgWidget,
        widget = wibox.container.constraint,
        max_width = 200,
        strategy = "max"
    }

    -- background highlight on mouse enter, clear on mouse leave.
    button:connect_signal("mouse::enter", function(c) bgWidget.bg = beautiful.bg_focus end)
    button:connect_signal("mouse::leave", function(c) bgWidget.bg = nil end)

    local weatherTooltip = createWeatherTooltip(button, args)
    --local iconWidget = button:get_children_by_id("icon")[1]

    if iconWidget == nil then
        local naughty = args.naughty
        naughty.notify({
            preset = naughty.config.presets.normal, -- critical, normal, low
            title = "⚠️ iconWidget NIL", 
            timeout = notificationTimeout
        })
    end
    setWeatherText(awful, beautiful, gears, fetchWeatherIconScript, iconWidget, fallbackIcon, false)
    
    -- Refresh on button press.
    button:connect_signal("button::press", function(c)
        bgWidget.bg = nil
        setWeatherText(awful, beautiful, gears, fetchSaveWeatherScript .. " && " .. cachedWeatherScript, weatherTooltip, fallbackErrorText, true)
        setWeatherText(awful, beautiful, gears, fetchWeatherIconScript, iconWidget, fallbackIcon, false)
    end)
    -- Clear background on button release.
    button:connect_signal("button::release", function(c) bgWidget.bg = beautiful.bg_focus end)

    return wibox.container.margin(button, 1, 1, 0, 0) -- with added padding
end

return getButton

