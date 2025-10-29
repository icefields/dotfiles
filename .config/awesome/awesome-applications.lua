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
-- This Lua script contains mainly 2 objects:
-- - commands, a table with common commands used by multiple scripts and by the
--   Application menu.
-- - applications, a table that holds all the application propierties in a
--   centralized objeect, to be used anywhere needed.

local icons = require("themes.luci4.application_icons")
local groupLuci4 = "luci4"
local groupLauncher = "launcher"

local browserCmd = "librewolf"
local fileBrowserCmd = "nemo ~/Desktop/"
local terminalCmd = "kitty"
local editorCmd = "nvim"

local browser = {
    command = browserCmd,
    description = "Open browser",
    group = groupLuci4,
    shell = false
}
local fileBrowser = {
    command = fileBrowserCmd,
    description = "Open file browser",
    group = groupLuci4,
    shell = true
}
local kittyArchDistrobox =  {
    command = "$HOME/.config/awesome/scripts/open_kitty_arch.sh",
    description = "Open Kitty Terminal in Arch Distrobox container",
    group = groupLuci4,
    shell = true
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
    shell = false
}
local terminal = {
    command = terminalCmd,
    description = "Open a terminal",
    group = groupLauncher,
    shell = false
}
local editor = {
    command = editorCmd,
    description = "Open editor",
    group = groupLauncher,
    shell = false
}

-- Common commands and attributes for common applications.
-- This is used everywhere but mainly to build the Application menu.
local commands = {
    terminal = terminal,
    editor = editor,
    screenshotArea = {
        command = "gnome-screenshot -a",
        description = "Print area of the screen",
        group = groupLuci4,
        shell = false
    },
    screenshotFull  = {
        command = "gnome-screenshot",
        description = "Print entire screen",
        group = groupLuci4,
        shell = false
    },
    raiseVolume = {
        command = "amixer -D pulse sset Master 2%+",
        description = "Raise audio volume",
        group = groupLuci4,
        shell = false
    },
    lowerVolume = {
        command = "amixer -D pulse sset Master 2%-",
        description = "Lower audio volume",
        group = groupLuci4,
        shell = false
    },
    muteVolume = {
        command = "amixer -D pulse sset Master toggle",
        description = "Mute/Unmute audio volume",
        group = groupLuci4,
        shell = false
    },
    lockScreen = {
        command = '$HOME/.config/awesome/scripts/lockscreen.sh',
        description = "Lock Screen",
        group = groupLuci4,
        shell = true
    },
    browser = browser,
    fileBrowser = fileBrowser,
    kittyArchDistrobox = kittyArchDistrobox,
    kittyArchDistroboxIsolated = kittyArchDistroboxIsolated,
    androidStudio = androidStudio,
    dmenu = {
        command = "dmenu_run",
        description = "run prompt",
        group = groupLuci4,
        shell = false
    },
    shareMenu =  {
        command = "fish -c $HOME/scripts/share.sh &",
        description = "Get a share-link, copy to clipboard",
        group = groupLuci4,
        shell = true
    },
    shareMenuEncrypted = {
        command = "kitty $HOME/scripts/sharesec.sh",
        description = "Zip, encrypt, get a share link and copy to clipboard",
        group = groupLuci4,
        shell = true
    },
    ampachePlaySong = {
        command = "$HOME/Code/Lua/ampache/play.sh",
        description = "Play song from Ampache server",
        group = groupLuci4,
        shell = true
    },
    askOllama = {
        command = "$HOME/Code/Lua/ollama/askollama.sh",
        description = "Ask Ollama a question",
        group = groupLuci4,
        shell = true
    },
    resetTor = {
        command = "fish -c '$HOME/scripts/tor_relay_reset.sh'",
        description = "Reset tor relay, change ip address",
        group = groupLuci4,
        shell = true
    }
}

local placement = {
    centered = "centered"
}

-- centralized object to use for all apps.
local applications = {
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
    }
}

return {
    commands = commands,
    groupLuci4 = groupLuci4,
    groupLauncher = groupLauncher,
    applications = applications,
    icons = icons
}

