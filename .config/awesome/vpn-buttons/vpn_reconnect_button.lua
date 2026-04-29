local config = require("vpn-buttons.vpn_common")
local buttonTooltip = require("common.button_tooltip")
local notif = require("common.notification")

-- scripts
local reconnectScript = config.reconnectScript
local statusScript = config.statusScript
local notifIcon = os.getenv("HOME") .. "/.config/awesome/themes/icons-global/mullvad-vpn.svg"

local function getButton(args)
    local naughty = args.naughty
    local beautiful = args.beautiful
    local button = buttonTooltip(args, {
        tooltipScript = statusScript,
        btnDefaultText = "󰝳",
        tooltipDefaultText = "VPN Status ...",
        buttonClickScript = reconnectScript,
        buttonClickCallback = function (button, icon)
            notif.send(naughty, beautiful, {
                title = "VPN Reconnected",
                text = "VPN restarted and reconnected",
                icon = notifIcon,
                timeout = 5,
                position = notif.POSITION.TOP_MIDDLE,
                preset = notif.PRESET.NORMAL,
            })
        end
    })
    return button
end

return getButton

