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
-- applications, a table that holds all the application propierties in a
-- centralized objeect, to be used anywhere needed.

local icons = require("themes.luci4.application_icons")
local groupLuci4 = "luci4"
local groupLauncher = "launcher"

local browserCmd = "librewolf"
local fileBrowserCmd = "nemo ~/Desktop/"
local terminalCmd = "kitty"
local editorCmd = os.getenv("EDITOR") or "nvim"
local modkey = "Mod4"

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
    command = "$HOME/.config/awesome/scripts/open_kitty_arch.sh",
    description = "Open Kitty Terminal in Arch Distrobox container",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 =  { modkey, },
        key2 = "c"
    }
}
local kittyArchDistroboxIsolated =  {
    command = "$HOME/.config/awesome/scripts/open_kitty_arch-isolated.sh",
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
    shell = false
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
    command = '$HOME/.config/awesome/scripts/lockscreen.sh',
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
    command = "fish -c $HOME/scripts/share.sh &",
    description = "Get a share-link, copy to clipboard",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 =  { modkey, "Mod1" },
        key2 = "space"
    }
}
local shareMenuEncrypted = {
    command = "kitty $HOME/scripts/sharesec.sh",
    description = "Zip, encrypt, get a share link and copy to clipboard",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 = { modkey, "Mod1" },
        key2 = "s"
    }
}
local ampachePlaySong = {
    command = "$HOME/Code/Lua/ampache/play.sh",
    description = "Play song from Ampache server",
    group = groupLuci4,
    shell = true,
    keyBinding = {
        key1 =  { modkey, "Control" },
        key2 = "p"
    }
}
local askOllama = {
    command = "$HOME/Code/Lua/ollama/askollama.sh",
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

-- centralized object to use for all apps.
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
        subGroup = "Terminals",
        icon = icons.kitty,
        favourite = true
    },
    editor = {
        label = "NeoVim",
        class = "",
        command = editor,
        subGroup = "Editor",
        icon = icons.neoVim,
        favourite = true
    },
    kittyArchDistrobox = {
        label = "Kitty Arch",
        class = "kitty",
        command = kittyArchDistrobox,
        subGroup = "Terminals",
        icon = icons.kittyArch,
        favourite = true
    },
    kittyArchDistroboxIsolated = {
        label = "Kitty Isolated",
        class = "kitty",
        command = kittyArchDistroboxIsolated,
        subGroup = "Terminals",
        icon = icons.arcoLinux,
        favourite = true
    },
    browser = {
        label = "LibreWolf",
        class = "",
        favourite = true,
        command = browser,
        subGroup = "Internet",
        -- icon = icons.,
    },
    fileBrowser = {
        label = "Nemo File Manager",
        class = "nemo",
        favourite = false,
        command = fileBrowser,
        subGroup = "Utils",
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
        subGroup = "Multimedia",
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
        subGroup = "Utils",
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
        subGroup = "Utils",
       -- icon = icons.keePass,
        properties = {
            floating = true,
            maximized_vertical = false,
            maximized_horizontal = false,
            maximized = false,
            placement = placement.centered
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
    }
}

return {
    modkey = modkey,
    groupLuci4 = groupLuci4,
    groupLauncher = groupLauncher,
    applications = applications,
    icons = icons
}

--local commands = {
--    terminal = terminal,
--    editor = editor,
--    screenshotArea = screenshotArea,
--    screenshotFull = screenshotFull,
--    raiseVolume = raiseVolume,
--    lowerVolume = lowerVolume,
--    muteVolume = muteVolume,
--    lockScreen = lockScreen,
--    browser = browser,
---    fileBrowser = fileBrowser,
--    kittyArchDistrobox = kittyArchDistrobox,
--    kittyArchDistroboxIsolated = kittyArchDistroboxIsolated,
--    androidStudio = androidStudio,
--    dmenu = dmenu,
--    shareMenu = shareMenu,
--    shareMenuEncrypted = shareMenuEncrypted,
--    ampachePlaySong = ampachePlaySong,
--    askOllama = askOllama,
--    resetTor = resetTor
--}

