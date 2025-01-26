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
-- ----- Luci4 Custom local for Awesome WM ------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------

local gfs = require("gears.filesystem")
local baseDir = gfs.get_configuration_dir() .. "/themes/luci4/icons/"

-- application icons
local powerampache2speaker_icon = baseDir .. "ic_speaker_colored_432px.svg"
local favourite_icon = baseDir .. "ic_favourite-applications.svg"
local kitty_icon = baseDir .. "kitty-candy.svg"
local kittyArch_icon = baseDir .. "kitty-arch.svg"
local ubuntu_icon = baseDir .. "distributor-logo-ubuntu.svg"
local signal_icon = baseDir .. "signal-desktop.svg"
local notepadqq_icon = baseDir .. "notepadqq-candy.svg"
local kdenlive_icon = baseDir .. "kdenlive.svg"
local neovim_icon = baseDir .. "org.daa.NeovimGtk.svg"
local androidStudio_icon = baseDir .. "studio.svg"
local calibre_icon = baseDir .. "accessories-ebook-reader.svg"
local gimp_icon = baseDir .. "gimp.svg"
local vivaldi_icon = baseDir .. "vivaldi.svg"
local reaper_icon = baseDir .. "reaper.png"
local arch_icon = baseDir .. "distributor-logo-archlinux.svg"
local arcolinux_icon = baseDir .. "arcolinux-hello.svg"
local supertux_icon = baseDir .. "supertux.svg"
local tor_icon = baseDir .. "tor.svg"
local jack_icon = baseDir .. "qv4l2.svg"
local telegram_icon = baseDir .. "telegram.svg"
local freetube_icon = baseDir .. "freetube.svg"
local steam_icon = baseDir .. "steam.svg"

-- LUCI4 ICON THEME
local icons = {
    defaultIcon = powerampache2speaker_icon,
    favourite = favourite_icon,
    kitty = kitty_icon,
    kittyArch = kittyArch_icon,
    ubuntu = ubuntu_icon,
    signal = signal_icon,
    notepadqq = notepadqq_icon,
    kdenlive = kdenlive_icon,
    neoVim = neovim_icon,
    androidStudio =  androidStudio_icon,
    calibre = calibre_icon,
    gimp = gimp_icon,
    vivaldi = vivaldi_icon,
    reaper = reaper_icon,
    arch = arch_icon,
    arcoLinux = arcolinux_icon,
    superTux = supertux_icon,
    tor = tor_icon,
    jack = jack_icon,
    telegram = telegram_icon,
    freeTube = freetube_icon,
    steam = steam_icon,
    berryAmp = baseDir .. "berryamp.svg"
}
-- END LUCI4 Icon Theme
return icons

