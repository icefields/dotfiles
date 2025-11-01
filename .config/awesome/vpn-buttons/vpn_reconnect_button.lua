local createVpnTooltip = require("vpn-buttons.vpn_tooltip")
local config = require("vpn-buttons.vpn_common")

local function getButton(args)
    local gears = args.gears
    local awful = args.awful
    local beautiful = args.beautiful
    local wibox = args.wibox

    local vpnReconnectButton = wibox.widget {
        {
            id = "icon",
            text = "󰝳", --"", --"", --"",
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            font = beautiful.topBar_button_font --"Symbols Nerd Font Mono 10"
        },
        widget = wibox.container.background,
        bg = "#00000000",
        fg = "#ffffff",
        shape = gears.shape.rounded_bar,
        forced_width = beautiful.topBar_buttonSize,
        forced_height = beautiful.topBar_buttonSize,
    }

    local wifiTooltip = createVpnTooltip(vpnReconnectButton, awful, beautiful)

    vpnReconnectButton:connect_signal("button::press", function()
        awful.spawn.easy_async_with_shell(config.reconnectScript, function()
            gears.timer.start_new(5, function()
                return false
            end)
        end)
    end)

    return  vpnReconnectButton
end

return getButton

