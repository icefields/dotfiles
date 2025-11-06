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
-- applications, a table that holds all the application properties in a
-- centralized objeect, to be used anywhere needed.
--
-- ModKey:
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

local icons = require("themes.luci4.application_icons")
local groupLuci4 = "luci4"
local groupLauncher = "launcher"

local browserCmd = "librewolf"
local fileBrowserCmd = "nemo ~/Desktop/"
local terminalCmd = "kitty"
local editorCmd = terminalCmd .. " -e " .. (os.getenv("EDITOR") or "nvim")
local modkey = "Mod4"

local homeDir = os.getenv("HOME")

local browser = {
    command = browserCmd,
    description = "Open browser",
    group = groupLuci4,
    shell = false,
    keyBinding = {
        key1 = { modkey },
        key2 = "b"
    }
}
local fileBrowser = {
    command = fileBrowserCmd,
    description = "Open file browser",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 = { modkey },
        key2 = "e"
    }
}
local kittyArchDistrobox =  {
    command = homeDir .. "/.config/awesome/scripts/open_kitty_arch.sh",
    description = "Open Kitty Terminal in Arch Distrobox container",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 =  { modkey, },
        key2 = "c"
    }
}
local kittyArchDistroboxIsolated =  {
    command = homeDir .. "/.config/awesome/scripts/open_kitty_arch-isolated.sh",
    description = "Open Kitty Terminal in an isolated Arch Distrobox container",
    group = groupLuci4,
    shell = true
}
local androidStudio = {
    command = "/opt/android-studio/bin/studio",
    description = "Open Android Studio",
    group = groupLuci4,
    shell = false,
    keyBinding = {
        key1 =  { modkey },
        key2 = "a"
    }
}
local terminal = {
    command = terminalCmd,
    description = "Open a terminal",
    group = groupLauncher,
    shell = false,
    keyBinding = {
        key1 = { modkey, },
        key2 = "Return"
    }
}
local editor = {
    command = editorCmd,
    description = "Open editor",
    group = groupLauncher,
    shell = true
}
local screenshotArea = {
    command = "gnome-screenshot -a",
    description = "Print area of the screen",
    group = groupLuci4,
    shell = false,
    keyBinding = {
        key1 = { "Control" },
        key2 = "Print"
    }
}
local screenshotFull = {
    command = "gnome-screenshot",
    description = "Print entire screen",
    group = groupLuci4,
    shell = false,
    keyBinding = {
        key1 = { },
        key2 = "Print"
    }
}
local raiseVolume = {
    command = "amixer -D pulse sset Master 2%+",
    description = "Raise audio volume",
    group = groupLuci4,
    shell = false,
    keyBinding = {
        key1 = { },
        key2 = "XF86AudioRaiseVolume"
    }
}
local lowerVolume = {
    command = "amixer -D pulse sset Master 2%-",
    description = "Lower audio volume",
    group = groupLuci4,
    shell = false,
    keyBinding = {
        key1 =  { },
        key2 = "XF86AudioLowerVolume"
    }
}
local  muteVolume = {
    command = "amixer -D pulse sset Master toggle",
    description = "Mute/Unmute audio volume",
    group = groupLuci4,
    shell = false,
    keyBinding = {
        key1 =  { },
        key2 = "XF86AudioMute"
    }
}
local lockScreen = {
    command = homeDir .. "/.config/awesome/scripts/lockscreen.sh",
    description = "Lock Screen",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 = { modkey, "Mod1" },
        key2 = "l"
    }
}
local dmenu = {
    command = "dmenu_run",
    description = "run prompt",
    group = groupLuci4,
    shell = false,
    keyBinding = {
        key1 = { modkey },
        key2 = "space",
    }
}
local shareMenu = {
    command = "fish -c " .. homeDir .. "/scripts/share.sh &",
    description = "Get a share-link, copy to clipboard",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 =  { modkey, "Mod1" },
        key2 = "space"
    }
}
local shareMenuEncrypted = {
    command = "kitty " .. homeDir .. "/scripts/sharesec.sh",
    description = "Zip, encrypt, get a share link and copy to clipboard",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 = { modkey, "Mod1" },
        key2 = "s"
    }
}
local ampachePlaySong = {
    command = homeDir .. "/Code/Lua/ampache/play.sh",
    description = "Play song from Ampache server",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 =  { modkey, "Control" },
        key2 = "p"
    }
}
local askOllama = {
    command = homeDir .. "/Code/Lua/ollama/askollama.sh",
    description = "Ask Ollama a question",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 =  { modkey, "Control" },
        key2 = "o"
    }
}
local resetTor = {
    command = "fish -c '$HOME/scripts/tor_relay_reset.sh'",
    description = "Reset tor relay, change ip address",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 =  { modkey },
        key2 = "i"
    }
}

local placement = {
    centered = "centered"
}

local subGroup = {
    internet = "Internet",
    messaging = "Messaging",
    multimedia = "Multimedia",
    music = "Music",
    utils = "Utils",
    terminals = "Terminals",
    documents = "Documents",
    graphics = "Graphics",
    games = "Games"
}

-- Default property for floating window.
local propertiesFloatingCentered = {
    floating = true,
    windowPlacement = placement.centered
}

-- centralized object to use for all apps.
-- omit label to not show the app in the menu.
-- add keyBinding to open the app with shortcut.
-- add properties to make the application follow defined window rules.
-- set favourite to true to add the application to the favourite menu.
local applications = {
    raiseVolume = {
        command = raiseVolume
    },
    lowerVolume = {
        command = lowerVolume
    },
    muteVolume = {
        command = muteVolume
    },
    lockScreen = {
        command = lockScreen
    },
    screenshotFull = {
        command =  screenshotFull
    },
    screenshotArea = {
        command = screenshotArea
    },
    dmenu = {
        command = dmenu
    },
    shareMenu = {
        command = shareMenu
    },
    shareMenuEncrypted = {
        command = shareMenuEncrypted
    },
    ampachePlaySong = {
        command = ampachePlaySong
    },
    askOllama =  {
        command = askOllama
    },
    resetTor = {
        command = resetTor
    },
    terminal = {
        label = "Kitty terminal",
        class = "kitty",
        command = terminal,
        subGroup = subGroup.terminals,
        icon = icons.kitty,
        favourite = true
    },
    editor = {
        label = "NeoVim",
        class = "",
        command = editor,
        subGroup = subGroup.terminals,
        icon = icons.neoVim,
        favourite = true
    },
    kittyArchDistrobox = {
        label = "Kitty Arch",
        class = "kitty",
        command = kittyArchDistrobox,
        subGroup = subGroup.terminals,
        icon = icons.kittyArch,
        favourite = true
    },
    kittyArchDistroboxIsolated = {
        label = "Kitty Isolated",
        class = "kitty",
        command = kittyArchDistroboxIsolated,
        subGroup = subGroup.terminals,
        icon = icons.arcoLinux,
        favourite = true
    },
    browser = {
        label = "LibreWolf",
        class = "",
        favourite = true,
        command = browser,
        subGroup = subGroup.internet,
        -- icon = icons.,
    },
    fileBrowser = {
        label = "Nemo File Manager",
        class = "nemo",
        favourite = false,
        command = fileBrowser,
        subGroup = subGroup.utils,
        icon = icons.fileManager,
        properties = {
            opacity = 1,
            tag = 1,
            maximized = false,
            floating = false
        }
    },
    vlc = {
        label = "Vlc",
        class = "vlc",
        favourite = false,
        command = {
            command = "vlc",
            description = "Vlc Media Player",
            group = "",
            shell = false
        },
        subGroup = subGroup.multimedia,
        icon = icons.vlc,
        properties = {
            floating = true,
            width = 800,
            height = 600,
            maximized_vertical = false,
            maximized_horizontal = false,
            maximized = false,
            windowPlacement = placement.centered
        }
    },
    archiveManager =  {
        label = "Archive Manager",
        class = "File-roller",
        favourite = false,
        command = {
            command = "file-roller",
            description = "File Roller",
            group = "",
            shell = false
        },
        subGroup = subGroup.utils,
        icon = icons.archiveManager,
        properties = {
            floating = true,
            maximized_vertical = false,
            maximized_horizontal = false,
            maximized = false,
            windowPlacement = placement.centered
        }
    },
    keepassxc = {
        label = "KeePass XC",
        class = "KeePassXC",
        favourite = false,
        command = {
            command = "keepassxc",
            description = "Password manager",
            group = "",
            shell = false
        },
        subGroup = subGroup.utils,
       -- icon = icons.keePass,
        properties = {
            floating = true,
            maximized_vertical = false,
            maximized_horizontal = false,
            maximized = false,
            windowPlacement = placement.centered
        }
    },
    androidStudio = {
        label = "Android Studio",
        class = "jetbrains-studio",
        favourite = true,
        command = androidStudio,
        subGroup = "Development",
        icon = icons.androidStudio,
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
    tutanota = {
        label = "Tutanota",
        class = "tutanota-desktop",
        favourite = false,
        command = {
            command = homeDir .. "/apps/tutanota-desktop-linux.AppImage -a",
            description = "Tutanota email client",
            group = "",
            shell = false
        },
        subGroup = subGroup.internet,
        icon = icons.tutanota,
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
    lxAppearance = {
        label = "LxAppearance",
        class = "Lxappearance",
        favourite = false,
        command = {
            command = "lxappearance",
            description = "Appearance Settings",
            group = "",
            shell = false
        },
        subGroup = subGroup.utils,
        -- icon = icons.
        properties = {
            floating = true,
            maximized = false,
            windowPlacement = placement.centered
        }
    },
    vivaldi = {
        label = "Vivaldi Browser",
        class = "Vivaldi-stable",
        favourite = true,
        command = {
            command = "vivaldi",
            description = "Vivaldi web browser",
            group = "",
            shell = false
        },
        subGroup = subGroup.internet,
        icon = icons.vivaldi,
        properties = {
            -- tag = "2",
            opacity = 1,
            maximized = false,
            floating = false
        }
    },
    signal = {
        label = "Signal",
        class = "Signal",
        favourite = false,
        command = {
            command = homeDir .. "/apps/Signal",
            description = "Signal messenger",
            group = "",
            shell = true
        },
        subGroup = subGroup.messaging,
        icon = icons.signal,
        properties = {
            tag = "8"
        }
    },
    telegram = {
        label = "Telegram",
        class = "TelegramDesktop",
        favourite = false,
        command = {
            command = homeDir .. "/apps/Telegram",
            description = "Telegram messenger",
            group = "",
            shell = true
        },
        subGroup = subGroup.messaging,
        icon = icons.telegram,
        properties = {
            tag = "8"
        }
    },
    element = {
        class = "Element",
        label = "Element",
        favourite = true,
        command = {
            command = "flatpak run im.riot.Riot",
            description = "Element messenger",
            group = "",
            shell = false
        },
        subGroup = subGroup.messaging,
        -- icon = icons.telegram,
        properties = {
            tag = "8",
            floating = true,
            width = 1200,
            height = 900,
            windowPlacement = placement.centered
        }
    }, 
    nheko = {
        class = "nheko",
        label = "Nheko",
        favourite = true,
        command = {
            command = "flatpak run im.nheko.Nheko",
            description = "Nheko messenger",
            group = "",
            shell = false
        },
        subGroup = subGroup.messaging,
        -- icon = icons.telegram,
        properties = {
            tag = "8",
            floating = true,
            width = 1000,
            height = 800,
            windowPlacement = placement.centered
        }
    },
    ampLocker = {
        label = "Audio Assault Amp Locker",
        class = "Amp Locker",
        favourite = true,
        command = {
            command = "\"$HOME/apps/Amp Locker Standalone\" &",
            description = "Audio Assault Amp Locker standalone amp sim",
            group = "",
            shell = false
        },
        icon = icons.audioAssault,
        subGroup = "Music",
        properties = propertiesFloatingCentered
    },
    berryAmp = {
        label = "Berry Amp",
        class = "Berry Amp - Charles Caswell",
        favourite = true,
        command = {
            command = "\"$HOME/apps/BerryAmpCharlesCaswell Standalone\" &",
            description = "Audio Assault Berry Amp standalone amp sim",
            group = "",
            shell = false
        },
        icon = icons.berryAmp,
        subGroup = "Music",
        properties = propertiesFloatingCentered
    },
    reaper = {
        label = "Reaper",
        class = "",
        favourite = true,
        command = {
            command = homeDir .. "/apps/reaper_linux_x86_64/REAPER/reaper",
            description = "Reaper",
            group = "",
            shell = false
        },
        icon = icons.reaper,
        subGroup = "Music"
    },
    qJackCtl = {
        label = "QjackCtl",
        class = "QjackCtl",
        favourite = true,
        command = {
            command = "qjackctl",
            description = "jack audio controller",
            group = "",
            shell = false
        },
        icon = icons.jack,
        subGroup = "Music",
        properties = propertiesFloatingCentered
    },
    freetube = {
        label = "Freetube",
        class = "",
        favourite = true,
        command = {
            command = homeDir .. "/apps/FreeTube",
            description = "Freetube YouTube Invidious client",
            group = "",
            shell = true
        },
        icon = icons.freeTube,
        subGroup = subGroup.multimedia
    },
    transmission = {
        label = "Transmission",
        class = "",
        favourite = true,
        command = {
            command = homeDir .. "/apps/Transmission",
            description = "Freetube YouTube Invidious client",
            group = "",
            shell = true
        },
        icon = icons.transmission,
        subGroup = subGroup.internet
    },
    calibre = {
        label = "Calibre",
        class = "",
        favourite = true,
        command = {
            command = homeDir .. "/apps/Calibre",
            description = "Calibre books",
            group = "",
            shell = true
        },
        icon = icons.calibre,
        subGroup = subGroup.documents
    },
    upscayl = {
        label= "UpScayl",
        class = "",
        favourite = true,
        command = {
            command = homeDir .. "/apps/Upscayl",
            description = "Use AI to upscale images",
            group = "",
            shell = true
        },
        icon = icons.superTux,
        subGroup = subGroup.graphics
    },
    gimp = {
        label = "Gimp",
        class = "",
        favourite = true,
        command = {
            command = "gimp",
            description = "Gimp image editor",
            group = "",
            shell = false
        },
        icon = icons.gimp,
        subGroup = subGroup.graphics
    },
    gimpDev = {
        label = "Gimp Dev",
        class = "",
        favourite = true,
        command = {
            command = homeDir .. "/apps/Gimp3",
            description = "Gimp image editor",
            group = "",
            shell = true
        },
        icon = icons.gimp,
        subGroup = subGroup.graphics
    },
    torBrowser = {
        label = "Tor Browser",
        class = "Tor Browser",
        favourite = true,
        command = {
            command = homeDir .. "/apps/tor-browser/Tor Browser",
            description = "Tor web browser",
            group = "",
            shell = false
        },
        icon = icons.tor,
        subGroup = subGroup.internet,
        properties = propertiesFloatingCentered
    },
    steam = {
        label = "Steam",
        class = "",
        favourite = true,
        command = {
            command = "steam",
            description = "Steam gaming",
            group = "",
            shell = false
        },
        icon = icons.steam,
        subGroup = subGroup.games
    },
    mumble = {
        label = "Mumble",
        class = "Mumble",
        favourite = true,
        command = {
            command = "mumble",
            description = "Mumble messenger",
            group = "",
            shell = false
        },
        icon = icons.mumble,
        subGroup = subGroup.messaging,
        properties = propertiesFloatingCentered
    },
    mpv = {
        -- omit from menu. label = "Mpv",
        class = "mpv",
        favourite = false,
        command = {
            command = "mpv",
            description = "Mpv video player",
            group = "",
            shell = false
        },
        -- icon = icons.,
        subGroup = subGroup.multimedia,
        properties = {
            floating = true, 
            -- windowPlacement = placement.centered,
            width = 800,
            height = 800
        }
    },
    videoDownloader = {
        label = "Video Downloader",
        class = "video-downloader",
        favourite = false,
        command = {
            command = "flatpak run com.github.unrud.VideoDownloader",
            description = "Video Downloader",
            group = "",
            shell = false
        },
        -- icon = icons.,
        subGroup = subGroup.multimedia,
        properties = propertiesFloatingCentered
    },
    tigerVnc = {
        label = "TigerVNC",
        class = "Vncviewer",
        favourite = true,
        command = {
            command = "flatpak run org.tigervnc.vncviewer",
            description = "VNC viewer",
            group = "",
            shell = false
        },
        -- icon = ,
        subGroup = subGroup.internet,
        properties = propertiesFloatingCentered
    },
    libreOffice = {
        label = "LibreOffice",
        class = "",
        favourite = false,
        command = {
            command = "libreoffice",
            description = "LibreOffice office suite",
            group = "",
            shell = false
        },
        -- icon = ,
        subGroup = subGroup.documents,
    },
    nextcloud = {
        label = "Nextcloud",
        class = "Nextcloud",
        favourite = false,
        command = {
            command = homeDir .. "/apps/nextcloud.appimage",
            description = "Nextcloud cloud",
            group = "",
            shell = false
        },
        -- icon = ,
        subGroup = subGroup.internet,
    },
    joplin = {
        label = "Joplin",
        class = "Joplin",
        favourite = false,
        command = {
            command = homeDir .. "/apps/Joplin/Joplin.AppImage",
            description = "Joplin markdown editor",
            group = "",
            shell = false
        },
        -- icon = ,
        subGroup = subGroup.documents,
    },
    redshift = {
        label = "Redshift",
        class = "",
        favourite = false,
        command = {
            command = "redshift-gtk",
            description = "Redshift blue light filter",
            group = "",
            shell = false
        },
        -- icon = ,
        subGroup = subGroup.utils,
    },
    geforcenow = {
        label = "GeForce Now",
        class = "",
        favourite = true,
        command = {
            command = homeDir .. "/apps/geforcenow-electron.AppImage",
            description = "GeForce Now (Electron application)",
            group = "",
            shell = false
        },
        subGroup = subGroup.games
    },
    soundsettings = {
        label = "Sound Settings",
        class = "", -- "cinnamon-settings sound"
        favourite = false,
        command = {
            command = homeDir .. "/scripts/sound-settings.sh",
            description = "Linux audio settings",
            group = "",
            shell = true
        },
        icon = icons.sound,
        subGroup = subGroup.utils
    }
}

function applications:bySubGroup()
    local grouped = {}

    for _, app in pairs(self) do
        if type(app) == "table" and app.label then
            local group = app.subGroup or "Ungrouped"

            -- Only create the group if we need to insert an app
            if not grouped[group] then
                grouped[group] = { }
            end

            table.insert(grouped[group], app)
        end
    end

    -- Remove empty groups (mostly for "Ungrouped")
    for group, apps in pairs(grouped) do
        if #apps == 0 then
            grouped[group] = nil
        end
    end

    -- Sort each subgroup alphabetically by label
    for _, apps in pairs(grouped) do
        table.sort(apps, function(a, b)
            return a.label:lower() < b.label:lower()
        end)
    end

    return grouped
end

function applications:getFavourites()
    local favourites = {}

    for _, app in pairs(self) do
        if type(app) == "table" and app.favourite then
            table.insert(favourites, app)
        end
    end

    table.sort(favourites, function(a, b)
        return a.label:lower() < b.label:lower()
    end)

    return favourites
end

return {
    modkey = modkey,
    groupLuci4 = groupLuci4,
    groupLauncher = groupLauncher,
    applications = applications,
    icons = icons
}

