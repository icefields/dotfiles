-- komai.lua -- AwesomeWM v4.3 module: summon Komai to the current tag
-- Install: drop this file into ~/.config/awesome/ (or any dir on package.path).
-- Wire up in rc.lua:
--   local komai = require("komai")
--   -- optional overrides, all fields optional:
--   komai.setup({ cycle  = true,
--                 match  = "komai",
--                 script = os.getenv("HOME") .. "/bin/komai-summon" })
--   globalkeys = gears.table.join(globalkeys,
--       awful.key({ modkey }, "k", komai.summon,
--                 { description = "summon Komai", group = "launcher" }))
--
-- Behaviour (one keypress, three states):
--   window open on any tag -> close to tray (WM_DELETE_WINDOW, app lives)
--                             -> socket poke -> reopens on the CURRENT tag
--   window hidden in tray  -> socket poke -> w.show() -> current tag
--   app not running        -> launch the AppImage (cold start)

local awful  = require("awful")
local gears  = require("gears")
local naughty = require("naughty")
local client = client -- awesome C global, not a require-able library

local M = {}

M.config = {
    -- absolute path to the summon helper (python: socket poke + cold start)
    script = os.getenv("HOME") .. "/scripts/wm_common/komai-summon",
    -- true  = close+reopen cycle: window open anywhere -> lands on current tag
    -- false = instant yank: move the existing client here, no flicker
    cycle = false,
    -- lowercased substring matched against WM_CLASS class and instance
    match = "komai",
}

function M.setup(opts)
    for k, v in pairs(opts or {}) do
        M.config[k] = v
    end
    return M
end

local function komaiClient()
    local match = M.config.match:lower()
    for _, c in ipairs(client.get()) do
        local cls  = c.class    and c.class:lower()    or ""
        local inst = c.instance and c.instance:lower() or ""
        if cls:match(match) or inst:match(match) then
            return c
        end
    end
end

local function yankKomai()
    local c = komaiClient()
    if not c then return end
    local s = awful.screen.focused()
    if c.screen ~= s then
        c:move_to_screen(s)
    end
    c:move_to_tag(s.selected_tag)
    c.minimized = false
    client.focus = c
    c:raise()
end

local function reopenKomai()
    -- easy_async: pid on success, error STRING when the script cannot even be
    -- spawned (missing, not executable); the callback catches script-level
    -- failures (nonzero exit / stderr). Nothing fails silently anymore.
    local pidOrErr = awful.spawn.easy_async(M.config.script,
        function(_, stderr, exitreason, exitcode)
            if exitcode ~= 0 or (stderr and stderr ~= "") then
                naughty.notify({
                    title   = "komai-summon",
                    text    = string.format("%s failed (%s %d):\n%s",
                              M.config.script, exitreason or "?", exitcode or -1,
                              (stderr or ""):gsub("%s+$", "")),
                    urgency = "critical",
                })
            end
        end)
    if type(pidOrErr) == "string" then
        naughty.notify({
            title   = "komai-summon",
            text    = "cannot spawn " .. M.config.script .. ":\n" .. pidOrErr,
            urgency = "critical",
        })
        return
    end
    gears.timer.start_new(0.5, function()
        -- after remap the window lands on the current tag of the screen it was
        -- hidden on (client.c screen_getbycoord); this yank fixes the screen.
        yankKomai()
        return false -- one-shot
    end)
end

function M.summon()
    local c = komaiClient()
    if M.config.cycle and c then
        -- window is open somewhere: close it. c:kill() is graceful -
        -- WM_DELETE_WINDOW (awesome objects/client.c client_kill), exactly
        -- what a titlebar close button does. Komai hides to tray
        -- (MainWindow.cpp closeEvent, desktopSystemTrayEnabled) - no kill,
        -- no unmount. REQUIRES the tray setting ON, else the app really quits.
        c:kill()
        gears.timer.start_new(0.15, function() -- let hide() land first
            reopenKomai()
            return false -- one-shot
        end)
    elseif c then
        yankKomai()
    else
        -- tray-hidden (withdrawn = invisible to the WM) or not running.
        -- If the app died since, the script's dead-socket path cold-starts it.
        reopenKomai()
    end
end

return M

