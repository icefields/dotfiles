local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local createVpnTooltip = require("vpn-buttons.vpn_tooltip")
local config = require("vpn-buttons.vpn_common")

local vpnReconnectButton = wibox.widget {
    {
        id = "icon",
        text = "", --"", --"",
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        font = config.font --"Symbols Nerd Font Mono 10"
    },
    widget = wibox.container.background,
    bg = "#00000000",
    fg = "#ffffff",
    shape = gears.shape.rounded_bar,
    forced_width = config.buttonSize,
    forced_height =config.buttonSize,
}

local wifiTooltip = createVpnTooltip(vpnReconnectButton)

vpnReconnectButton:connect_signal("button::press", function()
    awful.spawn.easy_async_with_shell(config.reconnectScript, function()
        gears.timer.start_new(5, function()
            return false
        end)
    end)
end)

return  vpnReconnectButton

