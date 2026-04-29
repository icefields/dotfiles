local config = require("vpn-buttons.vpn_common")
local buttonTooltip = require("common.button_tooltip")

-- scripts
local toggleScript = config.toggleScript
local getScript = config.getScript
local statusScript = config.statusScript

local function updateWifiIcon(awful, wifiIcon)
    awful.spawn.easy_async_with_shell(getScript, function(stdout)
        local status = stdout:gsub("%s+", "")
        if status == "connected" then
            wifiIcon.text = "󰍁" --"--"󱎚" --""
            -- wifiButton.bg = "#2ecc71"
        else
            wifiIcon.text = "" --"🔴"
            -- wifiButton.bg = "#e74c3c"
        end
    end)
end

local function getButton(args)
    local awful = args.awful
    local gears = args.gears

    -- mouseLeaveCallback
    local updateIcon = function (wifiButton, wifiIcon)
        updateWifiIcon(awful, wifiIcon)
    end

    local button = buttonTooltip(args, {
        tooltipScript = statusScript,
        buttonIconCallback = updateIcon,
        mouseLeaveCallback = updateIcon,
        -- clickResponseUpdateIconDelay = 5,
        btnDefaultText = "",
        tooltipDefaultText = "VPN Status ...",
        buttonClickCallback = function(wifiButton, wifiIcon)
            wifiButton.bg = nil
            awful.spawn.easy_async_with_shell(toggleScript, function()
                gears.timer.start_new(5, function()
                    updateWifiIcon(awful, wifiIcon)
                    return false
                end)
            end)
        end
    })
    return button
end

return getButton

