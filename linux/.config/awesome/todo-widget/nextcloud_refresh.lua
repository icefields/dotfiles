local spawn = require("awful.spawn")
local naughty = require("naughty")

local HOME_DIR = os.getenv("HOME")
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/todo-widget'

local function refreshNextcloud(onDone)
    local fetchScript = WIDGET_DIR .. "/fetchTasks.lua"
    spawn.easy_async_with_shell(
        string.format(
            "bash -c 'cd %s && exec lua5.1 %s'",
            WIDGET_DIR,
            fetchScript
        ),
        function(stdout, stderr, reason, exit_code)
            if exit_code ~= 0 then
                naughty.notify({
                    title = "Failed to fetch tasks",
                    text = stderr or "Unknown error",
                    preset = naughty.config.presets.critical,
                })
            else
                if onDone then
                    onDone()
                end

                naughty.notify({
                    title  = "Tasks Refreshed",
                    text   = "Nextcloud tasks have been refreshed",
                    preset = naughty.config.presets.normal,
                })
            end
        end
    )
end

return {
    refreshNextcloud = refreshNextcloud
}

