local buttonTooltip = require("common.button_tooltip")
-- local notif = require("common.notification")

local script = "lua " .. HomeEnv.HOME .. "/scripts/wm_common/Lucifer-WM-GTK-Window/main.lua"
local config = HomeEnv.HOME .. "/scripts/wm_common/Lucifer-WM-GTK-Window_configs/sports_config.lua"

local function getButton(args)
    -- local naughty = args.naughty
    -- local beautiful = args.beautiful
    local button = buttonTooltip(args, {
        btnDefaultText = '󰡒',
        tooltipDefaultText = "Sports",
        buttonIconScript = "echo '󰡒'",
        buttonClickScript = script .. " " .. config,
        buttonPaddingLeft = 0,
        buttonPaddingRight = -3
    })
    return button
end

return getButton

