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
-- ----- Luci4 Custom Theme for Awesome WM ------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------
-- battery_widget.lua

local batteryCmd = "acpi -bia"
local blinkTimeoutCriticalBattery = 2
local notificationTimeout = 0
local fallbackFont = "Monospace 10"
local batteryCharge = {
    full = 100,
    critical = 15
}

-- text formatting for the widget showing on the bar
local function tooltipText(font, color, batterySymbol, percent)
    local percentText = (percent < batteryCharge.full) and string.format("%d%%", percent) or ""
    return string.format("<span font='%s' foreground='%s'>%s %s</span>", font, color, batterySymbol, percentText)
end

-- Will show an Awesome notification when battery below critical levels.
local function showLowBatteryNotification(naughty, batteryWidget, percent, batteryStatus)
    if percent < batteryCharge.critical and batteryStatus == "Discharging" and not batteryWidget._notified then
        naughty.notify({
            preset = naughty.config.presets.normal, -- critical, normal, low
            title = "⚠️ Low Battery",
            -- text = string.format("Battery at %d%% — please plug in!", percent),
            timeout = notificationTimeout
        })
        batteryWidget._notified = true
    elseif percent >= batteryCharge.critical or batteryStatus ~= "Discharging" then
        batteryWidget._notified = false
    end
end

local function updateBatteryStatus(awful, beautiful, naughty, gears, batteryWidget, tooltip)
    awful.spawn.easy_async_with_shell(batteryCmd, function(stdout)
        tooltip.text = stdout:gsub("\n+$", "")

        local batteryLine = stdout:match("Battery %d+:.-%%")
        local batteryStatus, batteryPercentage = string.match(batteryLine or "", "Battery %d+: ([%a%s]+), (%d+)%%")

        if not batteryStatus or not batteryPercentage then
            batteryWidget.markup = tooltipText(beautiful.topBar_buttonTooltip_font, "#888888", "", 0)
            return
        end

        local percent = tonumber(batteryPercentage)
        local batterySymbol, color, blink = "", beautiful.topBar_fg or "#FFFFFF", false

        -- Determine battery symbol
        if batteryStatus == "Charging" then
            batterySymbol = ""
            color = beautiful.colour2.tint2
        elseif batteryStatus == "Full" then
            batterySymbol = ""
        elseif batteryStatus == "Discharging" then
            batterySymbol = (percent > 75 and "") or
                            (percent > 50 and "") or
                            (percent > 25 and "") or
                            (percent > batteryCharge.critical and "") or ""
            if percent > 50 then
                color = beautiful.topBar_fg or "#FFFFFF"
            elseif percent > 25 then
                color = beautiful.warningColour or "#FD971F"
            elseif percent > batteryCharge.critical then
                color = beautiful.errorColour or "#FF8800"
            else
                color = "#FF0000"
            end

            -- Blink only if battery < 15%
            blink = percent <= batteryCharge.critical
        end

        -- Show low battery notification, this is crashing the widged , investigate!
        showLowBatteryNotification(naughty, batteryWidget, percent, batteryStatus)

        if batteryWidget._visible == nil then
            batteryWidget._visible = true
        end

        -- Handle blinking
        if blink then
            if batteryWidget._blink_timer then
                batteryWidget._blink_timer:stop()
                batteryWidget._blink_timer = nil 
            end
            --if not batteryWidget._blink_timer then
            batteryWidget._blink_timer = gears.timer {
                timeout = blinkTimeoutCriticalBattery,
                autostart = false,
                callback = function()
                    batteryWidget._visible = not batteryWidget._visible
                    batteryWidget.markup = batteryWidget._visible and tooltipText(
                        beautiful.topBar_buttonTooltip_font or fallbackFont,
                        color,
                        batterySymbol,
                        percent
                    ) or tooltipText(
                        beautiful.topBar_buttonTooltip_font or fallbackFont,
                        beautiful.topBar_bg,
                        batterySymbol,
                        percent
                    )
                end
            }
            --end
            batteryWidget._blink_timer:start()
        else
            if batteryWidget._blink_timer then
                batteryWidget._blink_timer:stop()
                batteryWidget._blink_timer = nil  -- fully remove it
            end
            batteryWidget._visible = true
            batteryWidget.markup = tooltipText(
                beautiful.topBar_buttonTooltip_font or fallbackFont,
                color,
                batterySymbol,
                percent
            )
        end
    end)
end

local function getWidget(args)
    local awful = args.awful
    local wibox = args.wibox
    local gears = args.gears
    local naughty = args.naughty
    local beautiful = args.beautiful

    local batteryWidget = wibox.widget.textbox()

    -- Tooltip
    local tooltip = awful.tooltip({
        objects = { batteryWidget },
        align = "top",
        mode = "outside",
        preferred_positions = { "right", "left", "top", "bottom" },
        bg = beautiful.tooltip_bg_color,
        fg = beautiful.tooltip_fg_color,
        font = beautiful.tooltip_font
    })

    -- Initial update
    updateBatteryStatus(awful, beautiful, naughty, gears, batteryWidget, tooltip)

    -- Periodic update every 60 seconds
    gears.timer({
        timeout = 60,
        autostart = true,
        callback = function()
            updateBatteryStatus(awful, beautiful, naughty, gears, batteryWidget, tooltip)
        end
    })

    return wibox.container.margin(batteryWidget, 1, 1, 0, 0)
end

return getWidget

