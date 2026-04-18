local createVpnTooltip = require("vpn-buttons.vpn_tooltip")
local config = require("vpn-buttons.vpn_common")

local function getButton(args)
    local gears = args.gears
    local awful = args.awful
    local beautiful = args.beautiful
    local wibox = args.wibox
    local applyDpi = args.applyDpi

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
        fg = beautiful.topBar_fg,
        shape = gears.shape.rounded_bar,
        forced_width = applyDpi(beautiful.topBar_buttonSize),
        forced_height = applyDpi(beautiful.topBar_buttonSize),
    }

    local wifiTooltip = createVpnTooltip(vpnReconnectButton, awful, beautiful)

    vpnReconnectButton:connect_signal("button::press", function()
        vpnReconnectButton.bg = nil
        awful.spawn.easy_async_with_shell(config.reconnectScript, function()
            gears.timer.start_new(5, function()
                return false
            end)
        end)
    end)

    vpnReconnectButton:connect_signal("button::release", function(c) c.bg = beautiful.bg_focus end)

    return  vpnReconnectButton
end

return getButton

