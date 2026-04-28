local config = require("vpn-buttons.vpn_common")
local buttonTooltip = require("common.button_tooltip")

-- scripts
local iconScript = config.wifiIconScript
local clickScript = config.wifiMenuScript
local statusScript = config.wifiStatusScript

local function getButton(args)
    local button = buttonTooltip(args, {
        tooltipScript = statusScript,
        btnDefaultText = "",
        tooltipDefaultText = "Getting WiFi info ...",
        buttonClickScript = clickScript,
        buttonIconScript = iconScript
    })
    return button
end

return getButton

