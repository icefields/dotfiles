--local http = require("socket.http")
local https = require("ssl.https")
local json = require("dkjson")
local config = require("currency.api_config")
-- rename api_config_example to api_config and edit with your server info

local function fetchCurrencyRates()
    local url = config.baseUrl

    -- fetch the API response
--    local response, status = http.request(url)
    local response, status = https.request(config.baseUrl)
    if status ~= 200 then
        -- return nil, "Error fetching data, status code: " .. status
        return "Error fetching data, status code: " .. status
    end

    -- parse the JSON
    local data, pos, err = json.decode(response, 1, nil)
    if err then
        --return nil, "JSON parsing error: " .. err
        return "JSON parsing error: " .. err
    end

    -- local result_lines = {}
    local output = ""
    for pair, value in pairs(data.result) do
        if pair ~= "CAD/CAD" then
            output = output .. pair .. " " .. tostring(value) .. "\n"
            --table.insert(result_lines, pair .. " " .. tostring(value))
        end
    end

    return output:gsub("%s+$", "")
end

local function getWidget(args)
    local awful = args.awful
    local wibox = args.wibox
    local beautiful = args.beautiful
    local gears = args.gears

    local currencySymbols = config.symbols    
    local randomSymbol = currencySymbols[math.random(#currencySymbols)]

    local widget = wibox.widget {
        {
            id = "icon",
            text = randomSymbol,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            font = beautiful.topBar_button_font
        },
        widget = wibox.container.background,
        bg = "#00000000",  -- Transparent background
        fg = beautiful.topBar_fg,
        shape = gears.shape.rounded_bar,
        forced_height = beautiful.topBar_buttonSize
    }

    --local widget = wibox.widget {
    --    text = "$",
    --    align = "center",
    --    valign = "center",
    --    widget = wibox.widget.textbox
    --}

    local currencyTooltip = awful.tooltip {
        objects = { widget },
        mode = "outside",
        align = "top",
        margin_leftright = 8,
        margin_topbottom = 4,
        preferred_positions = { "top", "bottom" },
        text = "World Currencies Exchange",
        bg = beautiful.tooltip_bg_color,
        fg = beautiful.tooltip_fg_color
    }

    widget:connect_signal("mouse::enter", function(c)
        currencyTooltip.text = fetchCurrencyRates()
    end)

    -- show tooltip on right click
    --widget:connect_signal("button::press", function(_, _, _, button)
    --    if button == 3 then
    --        worldTimeTooltip.text = getWorldTimes()
    --    end
    --end)

    return widget
end

return {
    getWidget = getWidget
}

