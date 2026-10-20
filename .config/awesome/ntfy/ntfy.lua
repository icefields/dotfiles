local json = require("json-library.json")
local config = require("ntfy.config")

local function priorityPreset(naughty, priority)
    if priority == 4 or priority == 5 then return naughty.config.presets.critical end
    if priority == 1 or priority == 2 then return naughty.config.presets.low end
    return naughty.config.presets.normal
end

local function subscribe(args)
    local awful, naughty, gears = args.awful, args.naughty, args.gears

    local function connect()
        awful.spawn.with_line_callback({ "curl", "-sN", config.url }, {
            stdout = function(line)
                local ok, msg = pcall(json.decode, line)
                if ok and msg and msg.event == "message" then
                    naughty.notify({
                        title   = msg.title or config.fallbackTitle,
                        message = msg.message,
                        preset  = priorityPreset(naughty, msg.priority),
                        icon = config.icon,
                        timeout = config.timeout
                    })
                end
            end,
            exit = function()
                gears.timer.start_new(config.connectionRetry, connect)
            end,
        })
    end

    connect()
end

-- this works when the url ends with /raw instead of /json
local function subscribeRaw(args)
    local awful = args.awful
    local naughty = args.naughty
    local gears = args.gears
    local url = config.url

    awful.spawn.with_line_callback({ "curl", "-sN", url }, {
        stdout = function(line)
            if line ~= "" then naughty.notify({ title = config.fallbackTitle, message = line }) end
        end,
        exit = function()
            gears.timer.start_new(config.connectionRetry, subscribe)
        end,
    })
end

return {
    subscribe = subscribe
}

