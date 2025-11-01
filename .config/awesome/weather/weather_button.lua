
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

local apiBase = "https://wttr.in/43.6426,-79.3871"
local cachedWeatherFile = os.getenv("HOME") .. "/.cache/current_weather"
local cachedWeatherScript = "cat " .. cachedWeatherFile
local fetchSaveWeatherScript = "curl -s '" .. apiBase .. "?Tm' -o tmpWtr && [ -s tmpWtr ] && mv tmpWtr ".. cachedWeatherFile .. " || rm -f tmpWtr"
-- "curl -s 'https://wttr.in/43.6426,-79.3871?Tm' > /home/lucifer/.cache/current_weather"
local fetchWeatherIconScript = "curl -s '" .. apiBase .. "?format=%c'"
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
        c.bg = beautiful.bg_focus
        -- If cached version available, show it first
        setWeatherText(awful, beautiful, gears, cachedWeatherScript, weatherTooltip, fallbackLoadingText, true, function(stdout)
            local fallback = stdout
            if not stdout or stdout:match("^%s*$") then fallback = fallbackErrorText end
            setWeatherText(awful, beautiful, gears, fetchSaveWeatherScript .. " && " .. cachedWeatherScript, weatherTooltip, fallback, true)
        end)
    end)

    -- Clear background on mouse leave.
    button:connect_signal("mouse::leave", function(c) c.bg = nil end)
    return weatherTooltip
end

local function getButton(args)
    local gears = args.gears
    local awful = args.awful
    local beautiful = args.beautiful
    local wibox = args.wibox
    local fallbackIcon = "w"

    -- Button with an icon (font-based or symbol).
    local button = wibox.widget {
        {
            id = "icon",
            text = fallbackIcon,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            font = beautiful.topBar_button_font
        },
        widget = wibox.container.background,
        bg = "#00000000",  -- Transparent background
        fg = beautiful.topBar_fg,  -- Icon color (white)
        shape = gears.shape.rounded_bar,
        forced_width = beautiful.topBar_buttonSize,
        forced_height = beautiful.topBar_buttonSize
    }

    local weatherTooltip = createWeatherTooltip(button, args)
    local iconWidget = button:get_children_by_id("icon")[1]

    setWeatherText(awful, beautiful, gears, fetchWeatherIconScript, iconWidget, fallbackIcon, false)

    -- Refresh on button press.
    button:connect_signal("button::press", function()
        setWeatherText(awful, beautiful, gears, fetchSaveWeatherScript .. " && " .. cachedWeatherScript, weatherTooltip, fallbackErrorText, true)
        setWeatherText(awful, beautiful, gears, fetchWeatherIconScript, iconWidget, fallbackIcon, false)
    end)

    return button
end

return getButton

