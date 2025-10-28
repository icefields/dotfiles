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

return function(awful, icons, awesomeCmds)
  return {
    {   "Kitty Arch",
        function()
            awful.spawn.with_shell(awesomeCmds.kittyArchDistrobox.command)
        end,
        icons.kittyArch
    },
    {   "Kitty Isolated",
        function()
            awful.spawn.with_shell(awesomeCmds.kittyArchDistroboxIsolated.command)
        end,
        icons.arcoLinux
    },
    {   "Audio Assault Amp Locker",
        function()
            awful.spawn.with_shell("\"$HOME/apps/Amp Locker Standalone\" &")
        end,
        icons.audioAssault
    },
    {   "Berry Amp",
        function()
            awful.spawn.with_shell("\"$HOME/apps/BerryAmpCharlesCaswell Standalone\" &")
        end,
        icons.berryAmp
    },
    {   "Reaper",
        function()
            awful.spawn.with_shell("$HOME/apps/reaper_linux_x86_64/REAPER/reaper")
        end,
        icons.reaper
    },
    {   "QjackCtl",
        function()
            awful.spawn("qjackctl")
        end,
        icons.jack
    },
    {   "Vivaldi",
        function()
            awful.spawn("vivaldi")
        end,
        icons.vivaldi
    },
    {   "Freetube",
        function()
            awful.spawn.with_shell("$HOME/apps/FreeTube")
        end,
        icons.freeTube
    },
    {   "Transmission",
        function()
            awful.spawn.with_shell("$HOME/apps/Transmission")
        end,
        icons.transmission
    },
    {   "Calibre",
        function()
            awful.spawn.with_shell("$HOME/apps/Calibre")
        end,
        icons.calibre
    },
    {   "UpScayl",
        function()
            awful.spawn.with_shell("$HOME/apps/Upscayl")
        end,
        icons.superTux
    },
    {   "Gimp",
        function()
            awful.spawn.with_shell("$HOME/apps/Gimp3")
        end,
        icons.gimp
    },
    {   "Tor Browser",
        function()
            awful.spawn.with_shell("$HOME/apps/tor-browser/Tor Browser")
        end,
        icons.tor
    },
    {   "Steam",
        function()
            awful.spawn("steam")
        end,
        icons.steam
    }, 
    {   "Mumble",
        function()
            awful.spawn("mumble")
        end,
        icons.mumble
    },
    {   "Telegram",
        function()
            awful.spawn.with_shell("$HOME/apps/Telegram")
        end,
        icons.telegram
    }
  }
end

