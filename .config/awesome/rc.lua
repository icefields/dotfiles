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

-- Luci4 custom
-- Collision
require("collision")()

local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

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
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/luci4/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
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
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

-- Luci4 scan all the apps in the folder $HOME/apps and add to menu
local appsMenu = { }
for appExecutableName in io.popen([[ls -pa $HOME/apps/ | grep -v /]]):lines() do
    -- Luci4 making app names readable in the menu
    local appName = appExecutableName:gsub(" Standalone", "")
                                     :gsub("x86_64", "")
                                     :gsub("AppImage", "")
                                     :gsub("appimage", "")
                                     :gsub("-", " ")
                                     :gsub("x86-64","")
                                     :gsub("linux","")
                                     :gsub("%."," ")

    table.insert(appsMenu, { appName,
        function ()
             awful.spawn.with_shell("\"$HOME/apps/"..appExecutableName.."\" &")
        end
    })
end

-- Luci4 custom menu with favourite applications
flaggedmenu = {
    {   "Kitty Arch",
        function()
            awful.spawn.with_shell("~/.config/awesome/open_kitty_arch.sh")
        end,
        beautiful.arch_icon
    },
    {   "Kitty Isolated",
        function()
            awful.spawn.with_shell("~/.config/awesome/open_kitty_arch-isolated.sh")
        end,
        beautiful.arcolinux_icon
    },
    {   "Vivaldi",
        function()
            awful.spawn.with_shell("vivaldi")
        end,
        beautiful.vivaldi_icon
    }, 
    {   "Freetube",
        function()
            awful.spawn.with_shell("$HOME/apps/Freetube")
        end,
        beautiful.freetube_icon
    },
    {   "notepadqq",
        function()
            awful.spawn.with_shell("$HOME/apps/Notepadqq")
        end,
        beautiful.notepadqq_icon
    },
    {   "Calibre",
        function()
            awful.spawn.with_shell("$HOME/apps/Calibre")
        end,
        beautiful.calibre_icon
    },
    {   "UpScayl",
        function()
            awful.spawn.with_shell("$HOME/apps/Upscayl")
        end,
        beautiful.supertux_icon
    },
    {   "Gimp",
        function()
            awful.spawn("gimp")
        end,
        beautiful.gimp_icon
    },
    {   "Reaper",
        function()
            awful.spawn.with_shell("$HOME/apps/reaper_linux_x86_64/REAPER/reaper")
        end,
        beautiful.reaper_icon
    },
    {   "QjackCtl",
        function()
            awful.spawn("qjackctl")
        end,
        beautiful.jack_icon
    },
    {   "Tor Browser",
        function()
            awful.spawn.with_shell("$HOME/apps/tor-browser/Tor Browser")
        end,
        beautiful.tor_icon
    },
    {   "Steam",
        function()
            awful.spawn("steam")
        end,
        beautiful.steam_icon
    },
    {   "Telegram",
        function()
            awful.spawn.with_shell("$HOME/apps/Telegram/Telegram")
        end,
        beautiful.telegram_icon
    }
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_flagged = { "Favourites", flaggedmenu, beautiful.favourite_icon }
local menu_apps = { "Apps", appsMenu, beautiful.powerampache2speaker_icon }
local menu_terminal = { "open terminal", terminal, beautiful.kitty_icon }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_flagged, menu_apps },
        after =  { menu_awesome, menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_flagged,
            menu_apps,
            { "Debian", debian.menu.Debian_menu.Debian },
            menu_awesome,
            menu_terminal
        }
    })
end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

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
    -- mute_color = beautiful.,
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
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

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
    luciTagListColour:set_fg(beautiful.fg_systray)
    luciTagListColour:set_bg(beautiful.bg_normal)

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
                    awful.spawn.with_shell('~/.config/awesome/lockscreen.sh')
                end
            },
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
     awful.key({ "Mod1" }, "Tab", 
        function () 
            awful.menu.client_list( { theme = { width = 500 } } )
        end, {
            description = "show task list",
            group = "luci4"
        }
    ),
    -- Luci4 print area of screen
    awful.key({ "Control" }, "Print",
        function ()
            awful.util.spawn("gnome-screenshot -a")
        end, {
            description = "print area of the  screen",
            group = "luci4"
        }
    ),
    -- Print full screen
    awful.key({ }, "Print",
        function ()
            awful.util.spawn("gnome-screenshot")
        end, {
            description = "Print full screen",
            group = "luci4"
        }
    ),
    awful.key({ modkey, }, "s",
        hotkeys_popup.show_help, { 
            description="show help", 
            group="awesome" 
        }
    ),

    -- Luci4 changed arrows because of conflict with Collision
    -- awful.key({ modkey,           }, "[",
    --     awful.tag.viewprev,
    --     { description = "view previous", group = "tag"}
    -- ),
    -- awful.key({ modkey,           }, "]",
    --     awful.tag.viewnext,
    --     { description = "view next", group = "tag"}
    -- ),

    awful.key({ modkey, }, "Escape",
        awful.tag.history.restore, { 
            description = "go back", 
            group = "tag"
        }
    ),
    awful.key({ modkey, }, "j",
        function ()
            awful.client.focus.byidx(1)
        end, { 
            description = "focus next by index", 
            group = "client"
        }
    ),
    awful.key({ modkey, }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end, { 
            description = "focus previous by index", 
            group = "client"
        }
    ),
    awful.key({ modkey, }, "w", 
        function () 
            mymainmenu:show() 
        end, {
            description = "show main menu", 
            group = "awesome"
        }
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end, {
            description = "restore minimized", 
            group = "client"
        }
    ),
    -- Luci4 Audio key bindings
    awful.key( { }, "XF86AudioRaiseVolume",
        function ()
           awful.util.spawn("amixer -D pulse sset Master 2%+", false)
        end
    ),
    awful.key( { }, "XF86AudioLowerVolume",
        function ()
           awful.util.spawn("amixer -D pulse sset Master 2%-", false)
        end
    ),
    awful.key( { }, "XF86AudioMute",
        function ()
           awful.util.spawn("amixer -D pulse sset Master toggle", false)
        end
    ),
    -- Lock screen shortcut
    awful.key( { modkey, "Mod1" }, "l",
        function()
            awful.spawn.with_shell('~/.config/awesome/lockscreen.sh')
        end, {
            description = "Lock screen",
            group = "luci4"
        }
    ),
    -- LibreWolf
    awful.key( { modkey }, "b",
        function ()
            awful.util.spawn("librewolf")
        end, {
            description = "LibreWolf (open)",
            group = "luci4"
        }
    ),
    -- Nemo
    awful.key( { modkey }, "e",
        function ()
            awful.util.spawn("nemo")
        end, {
            description = "Nemo (open)",
            group = "luci4"
        }
    ),
    -- Kitty on Arch Distrobox (c as in console)
    awful.key( { modkey, }, "c",
        function()
            awful.spawn.with_shell("~/.config/awesome/open_kitty_arch.sh")
        end, {
            description = "Open Kitty Terminal on Arch container",
            group = "luci4"
        }
    ),
    -- Android Studio
    awful.key( { modkey }, "a",
        function ()
            awful.util.spawn("/opt/android-studio/bin/studio")
        end, {
            description = "Android Studio (open)",
            group = "luci4"
        }
    ),
    -- Prompt (Dmenu)
    awful.key( { modkey }, "space",
        function ()
            awful.util.spawn("dmenu_run")
        end, {
            description = "run prompt",
            group = "luci4"
        }
    ),
    -- Dmenu Share
    awful.key( { modkey, "Mod1" }, "space",
        function ()
            awful.spawn.with_shell("$HOME/scripts/share.sh &")
        end, {
            description = "get a share link and copy",
            group = "luci4"
        }
    ),

    -- encrypted Share
    awful.key( { modkey, "Mod1" }, "s",
        function ()
            awful.spawn.with_shell("kitty $HOME/scripts/sharesec.sh")
        end, {
            description = "zip, encrypt, get a share link and copy",
            group = "luci4"
        }
    ),


    -- Prompt (default)
    awful.key({ modkey },            "r",
        function ()
            awful.screen.focused().mypromptbox:run()
        end, {
            description = "run prompt",
            group = "launcher"
        }
    ),

    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end, {
            description = "lua execute prompt", 
            group = "awesome"
        }
    ),
    -- Menubar
    awful.key({ modkey }, "p", 
        function() menubar.show() end, {
            description = "show the menubar", 
            group = "launcher"
        })
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, {
            description = "toggle fullscreen", 
            group = "client"
        }),
    awful.key({ modkey, "Shift" }, "c",      
        function (c) c:kill() end, {
            description = "close", 
            group = "client"
        }),
    awful.key({ modkey, "Control" }, "space",  
        awful.client.floating.toggle, 
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", 
        function (c) c:swap(awful.client.getmaster()) end, 
        { description = "move to master", group = "client" }),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

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
awful.rules.rules = {
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
     -- vlc media player, floating
    {   rule = { class = "vlc" },
        properties = {
            floating = true,
            width = 800, 
            height = 600,
            maximized_vertical = false,
            maximized_horizontal = false,
            maximized = false,
            placement = awful.placement.centered
        }
    },
    -- Archive browser/extractor, floating
    {   rule = { class = "File-roller" },
        properties = {
            floating = true,
            maximized_vertical = false,
            maximized_horizontal = false,
            maximized = false,
            placement = awful.placement.centered
        }
    },
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

    { rule = { class = "nemo" },
        properties = {
            opacity = 1,
            tag = 1,
            screen = screen.count(), -- open on secondary screen if present
            maximized = false,
            floating = false
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
                "mpv",
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

awful.util.spawn_with_shell("~/.config/awesome/autostart.sh")
-- restore wallpaper, must run nitrogen at least once to set a wallpaper before
awful.util.spawn_with_shell("lua ~/.config/awesome/nitrogen-random.lua")
