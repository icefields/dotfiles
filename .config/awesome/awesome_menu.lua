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
local icons = require("wm_applications").icons
local debian = require("debian.menu") -- Load Debian menu entries

local function getFavourites(awful, favouriteApps, configDir)
    local favourites = { }
    for _, app in ipairs(favouriteApps) do
        local item = {
            app.label,
            function()
                 if app.command.shell then
                    awful.spawn.with_shell(app.command.command)
                else
                    awful.spawn(app.command.command)
                end
            end,
            app.icon or get_icon_for_application(configDir, app.label)
        }
        table.insert(favourites, item)
    end
    return favourites
end

local function buildMenu(args, awesomeApplications)
    local awesome = args.awesome
    local awful = args.awful
    local beautiful = args.beautiful
    local hotkeys_popup = args.hotkeys_popup
    local terminal = awesomeApplications.terminal.command.command
    local configDir = string.match(awesome.conffile, "^(.+/)rc.lua$")
    local editor_cmd =  terminal .. " -e " .. awesomeApplications.editor.command.command

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
            get_icon_for_application(configDir, appName)
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
                get_icon_for_application(configDir, flatpakAppName)
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

    -- other menus
    local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
    local menu_apps = { "Apps", appsMenu, icons.defaultIcon }

    local favourites = awesomeApplications:getFavourites()
    local flaggedmenu = getFavourites(awful, favourites, configDir)
    local menu_flagged = { "Favourites", flaggedmenu, icons.favourite }

    local customMenu = { }
    table.insert(customMenu, menu_flagged)
    table.insert(customMenu, menu_apps)

    for groupName, appsGroup in pairs(awesomeApplications:bySubGroup()) do
        if type(appsGroup) == "table" then
            local menu_custom = {
                groupName,
                getFavourites(awful, appsGroup, configDir),
                get_icon_for_application(configDir, groupName)
            }
            table.insert(customMenu, menu_custom)
        end
    end

    local menu_fdo = { "Debian", debian.menu.Debian_menu.Debian, 
        get_icon_for_application(configDir, "debian") 
    }
    local menu_terminal = { awesomeApplications.terminal.label, terminal, awesomeApplications.terminal.icon }

    table.insert(customMenu, menu_fdo)
    table.insert(customMenu, menu_awesome)
    table.insert(customMenu, menu_terminal)

    local mymainmenu = awful.menu({ items = customMenu })

    --if has_fdo then
    --    mymainmenu = freedesktop.menu.build({
    --       before = customMenu,
    --        after =  { menu_awesome, menu_terminal }
    --    })
    --else
    --    mymainmenu = awful.menu({
    --        items = {
    --            menu_flagged,
    --            menu_apps,
    --            { "Debian", debian.menu.Debian_menu.Debian },
    --            menu_awesome,
    --            menu_terminal
    --        }
    --    })
    --end

    return mymainmenu
end

return buildMenu

