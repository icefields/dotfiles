--local awful = require("awful")
--local gears = require("gears")
--local wibox = require("wibox")
local config = require("vpn-buttons.vpn_common")
local createVpnTooltip = require("vpn-buttons.vpn_tooltip")

-- scripts
local toggleScript = config.toggleScript
local getScript = config.getScript
local statusScript = config.statusScript

local function updateWifiIcon(awful, wifiButton)
    awful.spawn.easy_async_with_shell(getScript, function(stdout)
        local status = stdout:gsub("%s+", "")
        if status == "connected" then
            wifiButton:get_children_by_id("icon")[1].text = "󰍁" --"--"󱎚" --""
            -- wifiButton.bg = "#2ecc71"
        else
            wifiButton:get_children_by_id("icon")[1].text = "🔴"
            -- wifiButton.bg = "#e74c3c"
        end
    end)
end

local function getButton(args)
    local gears = args.gears
    local wibox = args.wibox
    local awful = args.awful
    local beautiful = args.beautiful

    local wifiButton = wibox.widget {
        {
            id = "icon",
            text = "",
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            font = config.font
        },
        widget = wibox.container.background,
        bg = "#00000000",
        fg = "#ffffff",
        shape = gears.shape.rounded_bar,
        forced_width = config.buttonSize,
        forced_height = config.buttonSize,
    }

    local wifiTooltip = createVpnTooltip(wifiButton, awful, beautiful)

    wifiButton:connect_signal("button::press", function()
        awful.spawn.easy_async_with_shell(toggleScript, function()
            gears.timer.start_new(5, function()
                updateWifiIcon(awful, wifiButton)
                return false
            end)
        end)
    end)

    wifiButton:connect_signal("mouse::leave", function(c)
        -- c.bg = "#00000000"
        updateWifiIcon(awful, wifiButton)
    end)

    updateWifiIcon(awful, wifiButton)

    return wifiButton
end

return getButton

