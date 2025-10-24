local awful = require("awful")
local config = require("vpn-buttons.vpn_common")

local statusScript = config.statusScript 

local function createWifiTooltip(button)
    local wifiTooltip = awful.tooltip {
        objects = { button },
        mode    = "outside",
        align   = "top",
        margin_leftright = 8,
        margin_topbottom = 4,
        preferred_positions = { "top", "bottom" },
        text = "VPN status...",
    }

    button:connect_signal("mouse::enter", function(c)
        c.bg = "#5a5a5a"
        awful.spawn.easy_async_with_shell(statusScript, function(stdout)
            wifiTooltip.text = stdout:gsub("%s+$", "")
        end)
    end)

    button:connect_signal("mouse::leave", function(c)
        c.bg = nil
    end)

    return wifiTooltip
end

return createWifiTooltip

