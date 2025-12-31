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
    local properties = getProperty(awful, app.properties)
    properties.screen = screenPos or awful.screen.preferred
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

    local rules = { }
    local allClientRules = {
        rule = { },
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
    }
    local defaultFloatingRule = {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                --"Berry Amp - Charles Caswell",
                --"QjackCtl",
                --"Amp Locker", -- glitch and crash if not floating
                --"mpv",
                --"Mumble",
                --"video-downloader",
                --"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Arandr",
                "Calfjackhost", -- calf subwindow
                "calfjackhost", -- main calf
                "cinnamon-settings sound",
                "Xviewer",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
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
    }

    local titleBarsRule = { 
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = {
            titlebars_enabled = false,
            -- Some maximized windows have gaps at the right and bottom
            size_hints_honor = false
        }
    }

    table.insert(rules, allClientRules)
   
    -- Insert rules from applications object
    for _, appl in pairs(awesomeApps) do
        -- Rules cannot be applied without a class
        if type(appl) == "table" and appl.properties ~= nil and appl.class ~= nil and appl.class ~= "" then
            table.insert(rules, getRule(awful, appl))
        end
    end
    -- Insert file browser rule, will appear on last screen for multiscreen setup.
    table.insert(rules, getRule(awful, awesomeApps.fileBrowser, screen.count()))
 
    table.insert(rules, defaultFloatingRule)
    table.insert(rules, titleBarsRule)
    return rules
end

return {
    awesomeRules = awesomeRules
}

