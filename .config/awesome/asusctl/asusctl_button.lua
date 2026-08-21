local buttonTooltip = require("common.button_tooltip")
--local notif = require("common.notification")

-- scripts
local getProfileScript = "asusctl profile get"
local nextProfileScript = "asusctl profile next && " .. getProfileScript
local iconScript = os.getenv("HOME") .. "/scripts/wm_common/asusctl/asusctl-profile-icon.sh"
--local notifIcon = os.getenv("HOME") .. "/.config/awesome/themes/icons-global/armorpaint.svg"

local function getButton(args)
    --local naughty = args.naughty
    --local beautiful = args.beautiful
    local button = buttonTooltip(args, {
        tooltipScript = getProfileScript,
        btnDefaultText = "",
        tooltipDefaultText = "Getting Profile ...",
        buttonClickScript = nextProfileScript,
        buttonIconScript = iconScript,
        --buttonClickCallback = function (button, icon, text)
        --    notif.send(naughty, beautiful, {
        --        title = "Profile Changed",
        --        text = text,
        --        icon = notifIcon,
        --        timeout = 5,
        --        position = notif.POSITION.TOP_RIGHT,
        --        preset = notif.PRESET.NORMAL,
        --    })
        --end
    })
    return button
end

return getButton

