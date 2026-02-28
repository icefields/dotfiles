--local http = require("socket.http")
local https = require("ssl.https")
local json = require("dkjson")
local config = require("currency.api_config")
-- rename api_config_example to api_config and edit with your server info
local DB = require("sqlite_helper")

--local db = DB.new("currency.db")
local db = DB.new(config.dbPath, false)

db:execute([[
    CREATE TABLE IF NOT EXISTS currency (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date INTEGER NOT NULL,
        value REAL NOT NULL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    );
]])

local function saveData(name, value, date)
    db:insert(
        "INSERT INTO currency (name, value, date) VALUES (?, ?, ?)",
        {name, value, date}
    )
end

local function readDbData()
    exclude = config.exclude or {}

    local whereExclude = ""
    if #exclude > 0 then
        local excludeList = {}
        for _, name in ipairs(exclude) do
            table.insert(excludeList, string.format("'%s'", name))
        end
        whereExclude = " AND name NOT IN (" .. table.concat(excludeList, ", ") .. ")"
    end

    local sql = string.format([[
        SELECT *
        FROM currency
        WHERE date = (SELECT MAX(date) FROM currency)
        %s
        ORDER BY name ASC
    ]], whereExclude)

    local rows = db:query(sql)
    return rows
end


local function readDbData2()
    local rows = db:query([[
        SELECT *
        FROM currency
        WHERE date = (SELECT MAX(date) FROM currency)
        ORDER BY name ASC
    ]])
    return rows
end

-- TODO: this function is not working correctly. Returning always true until fixed.
local function isLatestDateOlderThan1Hour()
    -- Get the latest timestamp from the DB
    local rows = db:query([[
        SELECT MAX(date) as latest
        FROM currency
    ]])

    local latest = rows[1].latest
    if not latest then
        return true -- No data in table, treat as "older than 1 hour"
    end

    local now = os.time() * 1000 -- Current time in milliseconds (UTC)
    local diff = now - latest
    -- TODO: always returning true now, there is an issue with this fucntion.
    return true --diff > 3600000
end

local function getWidgetText()
    local data = readDbData()
    local lines = {}
    for _, row in ipairs(data) do
        local decimals = config.decimalsMap[row.name] or config.defaultDecimals
        table.insert(lines, string.format("%s %." .. decimals .."f", row.name, row.value))
    end
    return table.concat(lines, "\n")
end

local function fetchCurrencyRates()
    -- Fetch new data only if the latest entry is older than 1h
    if isLatestDateOlderThan1Hour() then
        local url = config.baseUrl

        -- fetch the API response
        local response, status = https.request(config.baseUrl)
        if status ~= 200 then
            -- return nil, "Error fetching data, status code: " .. status
            return "Error fetching data, status code: " .. status .. "\n" .. getWidgetText()
        end

        -- parse the JSON
        local data, pos, err = json.decode(response, 1, nil)
        if err then
            --return nil, "JSON parsing error: " .. err
            return "JSON parsing error: " .. err .. "\n" .. getWidgetText()
        end
        
        local date = data.date

        --local output = ""
        for pair, value in pairs(data.result) do
            if pair ~= "CAD/CAD" then
                --output = output .. pair .. " " .. tostring(value) .. "\n"
                saveData(pair, value, date)
            end
        end
    end

    -- the db is the source of thruth
    return getWidgetText()
    --return output:gsub("%s+$", "")
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

