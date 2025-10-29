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

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/luci4/theme.lua")

-- Luci4 custom
-- Collision
require("collision")()

local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local buildMenu = require("menu")

-- Widget and layout library
local wibox = require("wibox")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local awesomeCmds = require("awesome-applications").commands
local awesomeApplications = require("awesome-applications").applications

-- AwesomeWM-related args to pass to external widgets. 
local awesomeArgs = ({
    gears = gears,
    wibox = wibox,
    awful = awful,
    awesome = awesome,
    beautiful = beautiful,
    hotkeys_popup = hotkeys_popup,
    menubar = menubar,
    client = client,
    screen = screen
})

-- VPN buttons
local toggleVpnButton = require("vpn-buttons.vpn_toggle_button")(awesomeArgs)
local vpnReconnectButton = require("vpn-buttons.vpn_reconnect_button")(awesomeArgs)

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal = awesomeCmds.terminal.command
editor = os.getenv("EDITOR") or awesomeCmds.editor.command
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local luci4MainMenu = buildMenu(awesomeArgs, awesomeApplications, editor_cmd)

-- uncomment to use a lanucher, and add to the bar.
-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = luci4MainMenu })
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar

-- Luci4 volume widget configuration
local luciVolumeWidget = volume_widget {
    widget_type = 'horizontal_bar',
    size = 36,
    width = 100,
    shape = 'powerline',
    with_icon = true,
    main_color = beautiful.border_focus,
    mute_color = beautiful.mute_volume,
    bg_color = beautiful.border_normal
}

local systray = wibox.widget.systray()
-- systray.opacity = 0.95
local luciSysTrayColour = wibox.container.background()
luciSysTrayColour:set_fg(beautiful.fg_systray)
luciSysTrayColour:set_bg(beautiful.bg_systray)
luciSysTrayColour.shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.rect_radius)
end
local trayMargin = beautiful.systray_margin
luciSysTrayColour:set_widget(wibox.layout.margin(systray, trayMargin, trayMargin, trayMargin, trayMargin))


-- {{{ Wibar
-- Create a textclock widget and change the format property using Pango markup
local mytextclock = wibox.widget.textclock("<span color='"..beautiful.clock_fg.."'> <b>%a</b> %b %d, %H:%M </span>")

local cw = calendar_widget( {
    theme = 'nord',
    placement = 'top_right',
    start_sunday = false,
    radius = beautiful.rect_radius,
    -- with customized next/previous (see table above)
    previous_month_button = 1,
    next_month_button = 3,
})
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button( { }, 1,
        function(t)
            t:view_only()
        end
    ),
    awful.button( { modkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button( { }, 3,
        awful.tag.viewtoggle
    ),
    awful.button({ modkey }, 3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button( { }, 4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button( { }, 5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

local tasklist_buttons = gears.table.join(
    awful.button( { }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate",
                    "tasklist",
                    { raise = true }
                )
            end
        end
    ),
    awful.button( { }, 3,
        function()
            awful.menu.client_list( { theme = { width = 500 } } )
        end
    ),
    awful.button( { }, 4,
        function ()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button( { }, 5,
        function ()
            awful.client.focus.byidx(-1)
        end
    )
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

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
        buttons = taglist_buttons,
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
        buttons = tasklist_buttons,
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
        height = 24,
        bg = beautiful.topBar_bg, -- bg_normal 
        position = "top",
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
            luciSysTrayColour,
            mytextclock,
            luciVolumeWidget,
            s.mylayoutbox,
            -- default logout widget
            -- logout_menu_widget(),
            -- custom version of logout widget
            logout_menu_widget {
            -- font = 'Play 14',
                onlock = function()
                    awful.spawn.with_shell(awesomeCmds.lockScreen.command)
                end
            },
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () luci4MainMenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key binding
local showMainMenu = function() luci4MainMenu:show() end
local keyBindings = require("key-bindings")
local globalkeys = keyBindings.awesomeGlobalKeys(awesomeArgs, modkey, showMainMenu)
local clientkeys = keyBindings.awesomeClientKeys(awesomeArgs, modkey)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = require("rules").awesomeRules(awesomeArgs, clientkeys, clientbuttons)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

local autostartCmd = "$HOME/.config/awesome/autostart.sh"
awful.spawn.with_shell(autostartCmd)

-- restore wallpaper, must run nitrogen at least once to set a wallpaper before
-- awful.util.spawn_with_shell("lua ~/.config/awesome/nitrogen-random.lua")
for screenNumber = 0,1 do
    local wallpaperScript = "nitrogen --set-zoom-fill --random " .. beautiful.wallpapersPath .. " --head=" .. screenNumber -- .. " > /dev/null 2>&1"
    awful.spawn.with_shell(wallpaperScript)
end

--screen.connect_signal("request::desktop_decoration", function(s)
--    local wallpaperScript = "nitrogen --set-zoom-fill --random $HOME/.config/awesome/themes/luci4/wallpapers --head=" .. s.index -- .. " > /dev/null 2>&1"
--    awful.spawn.with_shell(wallpaperScript)
--
--    -- awful.spawn.with_shell("nitrogen --set-zoom-fill --random ~/.config/awesome/themes/wallpapers --head=" .. s.index)
--end)

