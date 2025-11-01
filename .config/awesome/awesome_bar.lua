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
-- awesome_bar.lua

local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

local function getTagListButtons(client, gears, awful)
    local taglist_buttons = gears.table.join(
        awful.button( { }, 1, function(t)
                t:view_only()
            end
        ),
        awful.button( { modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button( { }, 3,
            awful.tag.viewtoggle
        ),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button( { }, 4, function(t)
            awful.tag.viewnext(t.screen)
        end),
        awful.button( { }, 5, function(t)
                awful.tag.viewprev(t.screen)
        end)
    )
    return taglist_buttons
end

local function getTaskListButtons(client, gears, awful)
    local tasklist_buttons = gears.table.join(
        awful.button( { }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate","tasklist", { raise = true })
            end
        end),
        awful.button( { }, 3, function()
            awful.menu.client_list( { theme = { width = 500 } } )
        end),
        awful.button( { }, 4, function ()
            awful.client.focus.byidx(1)
        end),
        awful.button( { }, 5, function ()
            awful.client.focus.byidx(-1)
        end)
    )
    return tasklist_buttons
end

-- calendar widget
local function getCalendarWidget(beautiful)
    return calendar_widget( {
        theme = 'nord',
        placement = 'top_right',
        start_sunday = false,
        radius = beautiful.rect_radius,
        -- with customized next/previous (see table above)
        previous_month_button = 3,
        next_month_button = 1,
    })
end

-- Luci4 volume widget configuration
local function getVolumeWidget(beautiful)
    return volume_widget {
        widget_type = 'horizontal_bar',
        size = 36,
        width = 100,
        -- shape = 'powerline',
        with_icon = true,
        main_color = beautiful.border_focus,
        mute_color = beautiful.mute_volume,
        bg_color = beautiful.border_normal
    }
end

-- system tray
local function getSystemTray(wibox, beautiful, gears)
     local systray = wibox.widget.systray()
    -- systray.opacity = 0.95

    local luciSysTrayColour = wibox.container.background()
    luciSysTrayColour:set_fg(beautiful.fg_systray)
    luciSysTrayColour:set_bg(beautiful.bg_systray)
    luciSysTrayColour.shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height_, beautiful.rect_radius)
    end
    local trayMargin = beautiful.systray_margin
    luciSysTrayColour:set_widget(wibox.layout.margin(systray, trayMargin, trayMargin, trayMargin, trayMargin))
    return luciSysTrayColour
end

-- system clock
-- Create a textclock widget and change the format property using Pango markup
local function getClockWidget(wibox, beautiful)
    return wibox.widget.textclock("<span color='"..beautiful.clock_fg.."'> <b>%a</b> %b %d, %H:%M </span>")
end

-----------------------------------------
-- Main function to create the system bar.
local function createAwesomeBar(args, s, lockScreenCommand)
    local beautiful = args.beautiful
    local awful = args.awful
    local client = args.client
    local gears = args.gears
    local wibox = args.wibox

    -- VPN buttons
    local toggleVpnButton = require("vpn-buttons.vpn_toggle_button")(args)
    local vpnReconnectButton = require("vpn-buttons.vpn_reconnect_button")(args)

    local weatherButton = require("weather.weather_button")(args)

    -- Keyboard map indicator and switcher
    local mykeyboardlayout = awful.widget.keyboardlayout()
    mykeyboardlayout.widget:set_font(beautiful.font)

    -- clock and calendar
    local calendarWidget = getCalendarWidget(beautiful)
    local clockWidget = getClockWidget(wibox, beautiful)
    clockWidget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then calendarWidget.toggle() end
    end)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Luci4 Create a taglist widget
    local luciTagList = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = getTagListButtons(client, gears, awful),
        --style   = {
        --    shape = gears.shape.powerline
        -- }
        -- show all tags regardless of the window
        -- source = function() return root.tags() end
    }
    local luciTagListColour = wibox.widget.background()
    luciTagListColour:set_widget(luciTagList)
    --luciTagListColour:set_fg(beautiful.fg_systray)
    --luciTagListColour:set_bg(beautiful.bg_normal)
    s.mytaglist = luciTagListColour

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags, -- minimizedcurrenttags, --alltags,
        buttons = getTaskListButtons(client, gears, awful),
        style    = {
            spacing = 2,
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, beautiful.rect_radius)
            end, -- gears.shape.octogon, -- powerline, --rounded_rect,
            shape_border_width = beautiful.tasklist_border_width,
            shape_border_color = beautiful.tasklist_border_colour,
            font = beautiful.tasklist_font,
            tasklist_disable_icon = false
        }
    }

    -- Create the wibox
    -- Luci4 bar customization
    s.mywibox = awful.wibox({
        screen = s,
        fg = beautiful.fg_normal,
        height = beautiful.topBar_height,
        bg = beautiful.topBar_bg, -- bg_normal 
        position = beautiful.topBar_position,
        border_color = beautiful.border_focus,
        border_width = beautiful.topBar_border
    })
    -- ORIG s.mywibox = awful.wibar({ position = "top", screen = s })

     -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- menu on the left of the  bar
            -- mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            ram_widget(),
            cpu_widget(),
            -- or custom
            -- cpu_widget({
            -- width = 70,
            -- step_width = 2,
            -- step_spacing = 0,
            -- color = '#434c5e'
            -- })
            mykeyboardlayout,
            -- wibox.layout.margin(wibox.widget.systray(), 4,4,4,4),
            toggleVpnButton,
            vpnReconnectButton,
            getSystemTray(wibox, beautiful, gears),
            weatherButton,
            clockWidget,
            getVolumeWidget(beautiful),
            s.mylayoutbox,
            -- default logout widget
            -- logout_menu_widget(),
            -- custom version of logout widget
            logout_menu_widget {
            -- font = 'Play 14',
                onlock = function()
                    awful.spawn.with_shell(lockScreenCommand)
                end
            },
        },
    }
end

return {
    createAwesomeBar = createAwesomeBar
}

