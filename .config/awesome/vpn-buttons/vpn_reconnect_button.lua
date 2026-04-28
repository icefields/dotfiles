local config = require("vpn-buttons.vpn_common")
local buttonTooltip = require("common.button_tooltip")

-- scripts
local reconnectScript = config.reconnectScript
local statusScript = config.statusScript

local function getButton(args)
    local button = buttonTooltip(args, {
        tooltipScript = statusScript,
        btnDefaultText = "󰝳",
        tooltipDefaultText = "VPN Status ...",
        buttonClickScript = reconnectScript,
    })
    return button
end

return getButton

