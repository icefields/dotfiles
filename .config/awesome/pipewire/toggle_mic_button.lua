local buttonTooltip = require("common.button_tooltip")

-- scripts
local HOME = os.getenv("HOME")
local toggleScript = HOME .. "/scripts/wm_common/volume.sh --toggle-mic"
local iconScript = HOME .. "/scripts/wm_common/volume.sh --get-mic-text-icon"

local function getButton(args)
    local button = buttonTooltip(args, {
        btnDefaultText = "",
        tooltipDefaultText = "Toggle microphone",
        buttonClickScript = toggleScript,
        buttonIconScript = iconScript,
    })
    return button
end

return getButton

