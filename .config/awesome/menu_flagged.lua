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

return function(awful, icons)
  return {
    {   "Kitty Arch",
        function()
            awful.spawn.with_shell("~/.config/awesome/open_kitty_arch.sh")
        end,
        icons.kittyArch
    },
    {   "Kitty Isolated",
        function()
            awful.spawn.with_shell("~/.config/awesome/open_kitty_arch-isolated.sh")
        end,
        icons.arcoLinux
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
    {   "Berry Amp",
        function()
            awful.spawn.with_shell("\"$HOME/apps/BerryAmpCharlesCaswell Standalone\" &")
        end,
        icons.berryAmp
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
            awful.spawn("gimp")
        end,
        icons.gimp
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
    {   "Telegram",
        function()
            awful.spawn.with_shell("$HOME/apps/Telegram/Telegram")
        end,
        icons.telegram
    }
  }
end

