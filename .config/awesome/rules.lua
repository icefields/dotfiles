-----------------------------------------------------
-- ----------------------------------------------- --
--   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄   --
--  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌  --
--  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌  --
--   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀   --
-- ----------------------------------------------- --
-- -------- Luci4 config for Awesome WM  --------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------
-- rules.lua

-- local awesomeApps = require("awesome-applications")
-- local cmds = awesomeApps.commands

local function getPlacement(awful, windowPlacement)
    local placement = {
        centered     = awful.placement.centered,
        center       = awful.placement.centered,
        top_left     = awful.placement.top_left,
        top_right    = awful.placement.top_right,
        bottom_left  = awful.placement.bottom_left,
        bottom_right = awful.placement.bottom_right,
        top          = awful.placement.top,
        bottom       = awful.placement.bottom,
        left         = awful.placement.left,
        right        = awful.placement.right,
        under_mouse  = awful.placement.under_mouse,
        next_to_mouse = awful.placement.next_to_mouse,
    }

    return placement[windowPlacement] or
       (awful.placement.no_overlap + awful.placement.no_offscreen)
end

local function getProperty(awful, property)
    property.placement = getPlacement(awful, property.windowPlacement)
    return property
end

local function getRule(awful, app, screenPos)
    local properties =  getProperty(awful, app.properties)
    properties.screen = screenPos or  awful.screen.preferred
    local rule = {
        rule = { class = app.class },
        properties = properties
    }
    return rule
end

local function awesomeRules(args, awesomeApps, clientkeys, clientbuttons)
    local beautiful = args.beautiful
    local awful = args.awful
    local screen = args.screen

    local rules = {
        -- All clients will match this rule.
        {   rule = { },
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                keys = clientkeys,
                buttons = clientbuttons,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen
            }
        },
        getRule(awful, awesomeApps.vlc), -- vlc media player, floating
        getRule(awful, awesomeApps.archiveManager), -- Archive browser/extractor, floating
        getRule(awful, awesomeApps.fileBrowser, screen.count()),
        -- KeepassXc, floating
        {   rule = { class = "KeePassXC" },
            properties = {
                floating = true,
                maximized_vertical = false,
                maximized_horizontal = false,
                maximized = false,
                placement = awful.placement.centered
            }
        },
        -- Tutanota
        {   rule = { class = "tutanota-desktop" },
            properties = {
                -- tag = "2",
                -- screen = screen.count(), -- open on secondary screen if present
                -- minimized = true,
                floating = true,
                maximized_vertical = false,
                maximized_horizontal = false,
                maximized = false,
            }
        },
        -- Lxappearance, floating
        {   rule = { class = "Lxappearance" },
            properties = {
                floating = true,
                maximized = false,
                placement = awful.placement.centered
            }
        },
        -- Android Studio
        {   rule = { class = "jetbrains-studio" },
            properties = {
                tag = "4",
                size_hints_honor = false, -- no gaps on full screen
                titlebars_enabled = false,
                fullscreen = true,
                floating = false,
                border_width = 0,
                --border_color = 0,
                --maximized = true,
                --maximized_vertical = true,
                --maximized_horizontal = true
            }
        },
        -- Vivaldi browser
        {   rule = { class = "Vivaldi-stable" },
            properties = {
                -- tag = "2",
                opacity = 1,
                maximized = false,
                floating = false
            }
        },

        -- Messaging apps will go on tag 5
        -- Signal
        {   rule = { class = "Signal" },
            properties = {
                tag = "8"
            }
        },
        -- Telegram
        {   rule = { class = "TelegramDesktop" },
            properties = {
                tag = "8"
            }
        },
        -- Element
        {   rule = { class = "Element" },
            properties = {
                tag = "8",
                floating = true,
                width = 1200,
                height = 900,
                placement = awful.placement.centered
            }
        },
        -- Floating clients.
        {   rule_any = {
                instance = {
                    "DTA",  -- Firefox addon DownThemAll.
                    "copyq",  -- Includes session name in class.
                    "pinentry",
                },
                class = {
                    "Amp Locker", -- glitch and crash if not floating
                    "Arandr",
                    "Berry Amp - Charles Caswell",
                    "QjackCtl",
                    "Calfjackhost", -- calf subwindow
                    "calfjackhost", -- main calf
                    "mpv",
                    "Mumble",
                    "cinnamon-settings sound",
                    "Xviewer",
                    "Blueman-manager",
                    "Gpick",
                    "Kruler",
                    "video-downloader",
                    "MessageWin",  -- kalarm.
                    "Sxiv",
                    "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                    "Wpa_gui",
                    "veromix",
                    "xtightvncviewer",
                    "Gnome-screenshot"
                },

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name = {
                    "Event Tester",  -- xev.
                },
                role = {
                    "AlarmWindow",  -- Thunderbird's calendar.
                    "ConfigManager",  -- Thunderbird's about:config.
                    "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
            properties = {
                floating = true,
                placement = awful.placement.centered
            }
        },

        -- Add titlebars to normal clients and dialogs
        {   rule_any = {
                type = { "normal", "dialog" }
            },
            properties = {
                titlebars_enabled = false,
                -- Some maximized windows have gaps at the right and bottom
                size_hints_honor = false
            }
        },

        -- Set Firefox to always map on the tag named "2" on screen 1.
        -- { rule = { class = "Firefox" },
        --   properties = { screen = 1, tag = "2" } },
    }

    return rules
end

return {
    awesomeRules = awesomeRules
}

