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
-- key-bindings.lua

local awesomeApps = require("awesome-applications")
local cmds = awesomeApps.commands
local groupLuci4 = awesomeApps.groupLuci4
local groupLauncher = awesomeApps.groupLauncher

local function getEntry(awful, key1, key2, cmdItem)
    return awful.key(key1, key2,
        function ()
            if cmdItem.shell then
                awful.spawn.with_shell(cmdItem.command)
            else
                awful.spawn(cmdItem.command)
            end
        end, {
            description = cmdItem.description,
            group = cmdItem.group
        }
    )
end

local function awesomeGlobalKeys(args, modkey, showMainMenu)
    local awesome = args.awesome
    local awful = args.awful
    local gears = args.gears
    local hotkeys_popup = args.hotkeys_popup
    local menubar = args.menubar
    local client = args.client

    local globalkeys = gears.table.join(
        awful.key({ modkey, }, "s", hotkeys_popup.show_help, {
            description="show help", group="awesome" }),

        awful.key({ modkey, }, "Escape", awful.tag.history.restore, {
            description = "go back", group = "tag" }),

        awful.key({ modkey, }, "j", function ()
            awful.client.focus.byidx(1)
        end, {
            description = "focus next by index",
            group = "client"
        }),

        awful.key({ modkey, }, "k", function ()
            awful.client.focus.byidx(-1)
        end, {
            description = "focus previous by index",
            group = "client"
        }),
        awful.key({ modkey, }, "w", showMainMenu, {
            description = "show main menu", group = "awesome" }),

        -- Layout manipulation
        awful.key({ modkey, "Shift" }, "j", function ()
            awful.client.swap.byidx(  1)
        end, {
            description = "swap with next client by index",
            group = "client"
        }),
        awful.key({ modkey, "Shift" }, "k", function ()
            awful.client.swap.byidx( -1)
        end,{
            description = "swap with previous client by index",
            group = "client"
        }),
        awful.key({ modkey, "Control" }, "j", function ()
            awful.screen.focus_relative( 1)
        end, {
            description = "focus the next screen",
            group = "screen"
        }),
        awful.key({ modkey, "Control" }, "k", function ()
            awful.screen.focus_relative(-1)
        end, {
            description = "focus the previous screen",
            group = "screen"
        }),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,{
            description = "jump to urgent client",
            group = "client"
        }),
        awful.key({ modkey,           }, "Tab", function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,{
            description = "go back",
            group = "client"
        }),

        -- Standard program
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

        awful.key({ modkey, "Control" }, "n", function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end, {
            description = "restore minimized",
            group = "client"
        }),
        -- Prompt (default)
        awful.key({ modkey }, "r",
            function ()
                awful.screen.focused().mypromptbox:run()
            end, {
                description = "run prompt",
                group = groupLauncher
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
        awful.key({ modkey }, "p", function() menubar.show() end, {
            description = "show the menubar", group = groupLauncher }),

        -- Luci4 changed arrows because of conflict with Collision
        -- awful.key({ modkey,           }, "[",
        --     awful.tag.viewprev,
        --     { description = "view previous", group = "tag"}
        -- ),
        -- awful.key({ modkey,           }, "]",
        --     awful.tag.viewnext,
        --     { description = "view next", group = "tag"}
        -- ),

        awful.key({ "Mod1" }, "Tab", function ()
            awful.menu.client_list( { theme = { width = 500 } } )
        end, {
            description = "show task list",
            group = groupLuci4
        }),
        getEntry(awful, { modkey,           }, "Return", cmds.terminal),
        -- Luci4 print area of screen
        getEntry(awful, { "Control" }, "Print", cmds.screenshotArea),
        -- Print full screen
        getEntry(awful, { }, "Print", cmds.screenshotFull),
        -- Luci4 Audio key bindings
        getEntry(awful, { }, "XF86AudioRaiseVolume", cmds.raiseVolume),
        getEntry(awful, { }, "XF86AudioLowerVolume", cmds.lowerVolume),
        getEntry(awful, { }, "XF86AudioMute", cmds.muteVolume),
        -- Lock screen shortcut
        getEntry(awful, { modkey, "Mod1" }, "l", cmds.lockScreen),
        -- LibreWolf
        getEntry(awful, { modkey }, "b", cmds.browser),
        -- Nemo
        getEntry(awful, { modkey }, "e", cmds.fileBrowser),
        -- Kitty on Arch Distrobox (c as in console)
        getEntry(awful, { modkey, }, "c", cmds.kittyArchDistrobox),
        -- Android Studio
        getEntry(awful, { modkey }, "a", cmds.androidStudio),
        -- Prompt (Dmenu)
        getEntry(awful, { modkey }, "space", cmds.dmenu),
        -- Dmenu Share
        getEntry(awful, { modkey, "Mod1" }, "space", cmds.shareMenu),
        -- encrypted Share
        getEntry(awful, { modkey, "Mod1" }, "s", cmds.shareMenuEncrypted),
        -- Play song from Ampache server
        getEntry(awful, { modkey, "Control" }, "p", cmds.ampachePlaySong),
        -- Interact with AI on an external local-network server
        getEntry(awful, { modkey, "Control" }, "o", cmds.askOllama),
        -- Tor reset
        getEntry(awful, { modkey }, "i", cmds.resetTor)
    )

    return globalkeys
end

local function awesomeClientKeys(args, modkey)
    local awful = args.awful
    local gears = args.gears

    local clientkeys = gears.table.join(
        awful.key({ modkey, }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end, {
                description = "toggle fullscreen",
                group = "client"
            }),
        awful.key({ modkey, "Shift" }, "c",
            function (c)
                c:kill()
            end, {
                description = "close",
                group = "client"
            }),
        awful.key({ modkey, "Control" }, "space",
            awful.client.floating.toggle, {
                description = "toggle floating",
                group = "client"
            }),
        awful.key({ modkey, "Control" }, "Return",
            function (c)
                c:swap(awful.client.getmaster())
            end, {
                description = "move to master",
                group = "client"
            }),
        awful.key({ modkey,           }, "o",
            function (c)
                c:move_to_screen()
            end, {
                description = "move to screen",
                group = "client"
            }),
        awful.key({ modkey,           }, "t",
            function (c)
                c.ontop = not c.ontop
            end, {
                description = "toggle keep on top",
                group = "client"
            }),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end, {
                description = "minimize",
                group = "client"
            }),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end, {
                description = "(un)maximize",
                group = "client"
            }),
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
    return clientkeys
end

return {
    awesomeGlobalKeys = awesomeGlobalKeys,
    awesomeClientKeys = awesomeClientKeys
}

