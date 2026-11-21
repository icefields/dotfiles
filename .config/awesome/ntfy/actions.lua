-- maps ntfy message actions from the JSON stream to naughty.action buttons
local M = {}

-- POSIX-safe single-quote wrapper for values that travel through a shell
local function shellQuote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local runners = {}

runners.view = function(awful, spec)
    awful.spawn({ "xdg-open", spec.url })
end

runners.copy = function(awful, spec)
    awful.spawn({
        "sh", "-c",
        "printf '%s' " .. shellQuote(spec.value) .. " | xclip -selection clipboard",
    })
end

--runners.copy = function(awful, spec)
--    awful.spawn.with_shell(
--        "printf '%s' " .. shellQuote(spec.value) .. " | xclip -selection clipboard"
--    )
--end

runners.http = function(awful, spec)
    local method = spec.method
    if method == nil or method == "" then method = "POST" end
    local argv = { "curl", "-s", "-X", string.upper(method or "POST"), spec.url }
    for key, value in pairs(spec.headers or {}) do
        argv[#argv + 1] = "-H"
        argv[#argv + 1] = key .. ": " .. value
    end
    if spec.body then
        argv[#argv + 1] = "--data"
        argv[#argv + 1] = spec.body
    end
    awful.spawn(argv)
end

-- "broadcast" fires an Android intent, nothing to run on a desktop, skipped

--- build naughty.action buttons for a message
-- returns buttons, and resident (true if any action wants the notif kept alive)
function M.build(msg, deps)
    local awful, naughty = deps.awful, deps.naughty
    local buttons = {}
    local resident = false

    for _, spec in ipairs(msg.actions or {}) do
        local runner = runners[spec.action]

        if runner and spec.label and (spec.url or spec.value) then
            local clear = spec.clear == true
            resident = resident or not clear

            local button = naughty.action { name = spec.label }
            button:connect_signal("invoked", function(_, notif)
                runner(awful, spec)
                -- non-resident notifications are already destroyed by naughty;
                -- only destroy by hand when we told it to keep this one alive
                if clear and notif and resident then
                    notif:destroy()
                end
            end)

            buttons[#buttons + 1] = button
        end
    end

    return buttons, resident
end

return M

