local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local toggleScript = "$HOME/scripts/toggle-wifi-profile.sh toggle"
local getScript = "$HOME/scripts/toggle-wifi-profile.sh get"
local statusScript = os.getenv("HOME") .. "/scripts/toggle-wifi-profile.sh status"

local wifiButton = wibox.widget {
    {
        id = "icon",
        text = "⏳",
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
    },
    widget = wibox.container.background,
    bg = "#00000000",
    fg = "#ffffff",
    shape = gears.shape.rounded_bar,
    forced_width = 30,
    forced_height = 30,
}

local wifiTooltip = awful.tooltip {
    objects = { wifiButton },
    mode    = "outside",
    align   = "top",
    margin_leftright = 8,
    margin_topbottom = 4,
    preferred_positions = { "top", "bottom" },
    text = "VPN status...",
}

local function update_wifi_icon()
    awful.spawn.easy_async_with_shell(getScript, function(stdout)
        local status = stdout:gsub("%s+", "")
        if status == "connected" then
            wifiButton:get_children_by_id("icon")[1].text = "" --🔐"
            -- wifiButton.bg = "#2ecc71"
        else
            wifiButton:get_children_by_id("icon")[1].text = "🔴"
            -- wifiButton.bg = "#e74c3c"
        end
    end)
end

wifiButton:connect_signal("button::press", function()
    awful.spawn.easy_async_with_shell(toggleScript, function()
        gears.timer.start_new(5, function()
            update_wifi_icon()
            return false
        end)
    end)
end)

wifiButton:connect_signal("mouse::enter", function(c)
    c.bg = "#5a5a5a"
    awful.spawn.easy_async_with_shell(statusScript, function(stdout)
        wifiTooltip.text = stdout:gsub("%s+$", "")
    end)
end)

wifiButton:connect_signal("mouse::leave", function(c)
    c.bg = "#00000000"
    update_wifi_icon()
end)

update_wifi_icon()

return wifiButton

