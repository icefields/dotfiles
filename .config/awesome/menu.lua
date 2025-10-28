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

-- menu.lua
require("get_app_icon")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- Load Debian menu entries
local debian = require("debian.menu")

local function buildMenu(args, awesomeCmds, editor_cmd)
    local awesome = args.awesome
    local awful = args.awful
    local beautiful = args.beautiful
    local hotkeys_popup = args.hotkeys_popup
    local terminal = awesomeCmds.terminal.command

    -- your existing menu-building code goes here
    local myawesomemenu = {
        { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
        { "manual", terminal .. " -e man awesome" },
        { "edit config", editor_cmd .. " " .. awesome.conffile },
        { "restart", awesome.restart },
        { "quit", function() awesome.quit() end },
    }

    -- Luci4 scan all the apps in the folder $HOME/apps and add to menu
    local appsMenu = { }
    local appImageCommandFile = io.popen([[ls -pa $HOME/apps/ | grep -v /]])
    for appExecutableName in appImageCommandFile:lines() do
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
            end,
            get_icon_for_application(awesome, appName)
        })
    end
    appImageCommandFile:close()

    -- Luci4 scan for Flatpak
    local flatpakCommandFile = io.popen("flatpak list --app --columns=application")
    if flatpakCommandFile then
        for flatpakApp in flatpakCommandFile:lines() do
            if flatpakApp == "im.riot.Riot" then flatpakApp = "Element" end
            local flatpakAppName = string.match(flatpakApp, "([^%.]+)$") 
            table.insert(appsMenu, { flatpakAppName,
                function ()
                    awful.spawn.with_shell("flatpak run "..flatpakApp)
                end,
                get_icon_for_application(awesome, flatpakAppName)
            })
        end
        flatpakCommandFile:close()
    end

    -- Luci4 Sort the apps menu by the first element (app name)
    table.sort(appsMenu,
        function(a, b)
            return string.lower(a[1]) < string.lower(b[1])
        end
    )

    -- Luci4 custom menu with favourite applications
    local flaggedmenu = require("menu_flagged")(awful, beautiful.icons, awesomeCmds)
    -- other menus
    local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
    local menu_flagged = { "Favourites", flaggedmenu, beautiful.icons.favourite }
    local menu_apps = { "Apps", appsMenu, beautiful.icons.defaultIcon }
    local menu_terminal = { "open terminal", terminal, beautiful.icons.kitty }

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

    return mymainmenu
end

return buildMenu

