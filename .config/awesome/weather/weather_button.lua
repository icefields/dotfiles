local buttonTooltip = require("common.button_tooltip")
-- local notif = require("common.notification")
local config = require("config")
local apiBase = "https://wttr.in/" .. config.env.LOCATION_COORDINATES
local fetchWeatherScript = "curl -s '" .. apiBase .. "?Tm'"
local fetchWeatherIconScript = "curl -s '" .. apiBase .. "?m&format=%c+%t+%h'" -- "?format=%c'"
local fallbackLoadingText = "Loading weather ..."
-- local fallbackErrorText = "Error fetching weather"

local function getButton(args)
    -- local naughty = args.naughty
    -- local beautiful = args.beautiful
    local button = buttonTooltip(args, {
        tooltipScript = fetchWeatherScript,
        btnDefaultText =  "⸸",
        tooltipDefaultText = fallbackLoadingText,
        buttonIconScript = fetchWeatherIconScript,
        buttonClickScript = fetchWeatherIconScript,
        buttonWidth = 88
    })
    return button
end

return getButton

