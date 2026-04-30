local buttonTooltip = require("common.button_tooltip")
local notif = require("common.notification")

-- scripts
local HOME = os.getenv("HOME")
local toggleScript = HOME .. "/scripts/wm_common/update-sys.sh update"
local iconScript = HOME .. "/scripts/wm_common/update-sys.sh"
local notifIcon = HOME .. "/.config/awesome/themes/icons-global/system-software-update.svg"
local placeholderIcon = "󰚰" -- "" -- "󰋅"

local function getButton(args)
    local naughty = args.naughty
    local beautiful = args.beautiful
    local button = buttonTooltip(args, {
        -- tooltipScript = statusScript,
        btnDefaultText = placeholderIcon,
        tooltipDefaultText = "Update System",
        buttonClickScript = toggleScript,
        buttonIconScript = iconScript,
        buttonIconCallback = function (buttonWidget, iconWidget, text)
            if not text or text == "" then
                iconWidget.text = placeholderIcon
            end
        end,
        buttonClickCallback = function (buttonWidget, iconWidget, text)
            notif.send(naughty, beautiful, {
                title = "System Updated",
                icon = notifIcon,
                timeout = 5,
                position = notif.POSITION.TOP_LEFT,
                preset = notif.PRESET.NORMAL,
            })
        end
    })
    return button
end

return getButton

