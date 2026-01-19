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

--local gfs = require("gears.filesystem")
-- local baseDir = gfs.get_configuration_dir() .. "/themes/luci4/icons/"
local config = require("config")
local baseDir = os.getenv("HOME") .. "/.config/awesome" .. config.chosenThemeDir ..  "icons/"

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
local androidStudio_icon = baseDir .. "androidstudio.svg" --  "studio.svg"
local calibre_icon = baseDir .. "accessories-ebook-reader.svg"
local gimp_icon = baseDir .. "gimp.svg"
local vivaldi_icon = baseDir .. "vivaldi.svg"
local reaper_icon = baseDir .. "cockos-reaper.svg" -- "reaper.png"
local arch_icon = baseDir .. "distributor-logo-archlinux.svg"
local arcolinux_icon = baseDir .. "arcolinux-hello.svg"
local supertux_icon = baseDir .. "supertux.svg"
local tor_icon = baseDir .. "tor.svg"
local jack_icon = baseDir .. "qv4l2.svg"
local telegram_icon = baseDir .. "telegram.svg"
local freetube_icon = baseDir .. "freetube.svg"
local steam_icon = baseDir .. "steam.svg"
local audioAssault_icon = baseDir .. "audioassault.svg"
local mumble_icon = baseDir .. "mumble.svg"
local vlc_icon = baseDir .. "vlc.svg"
local archive_icon = baseDir .. "archive.svg"
local file_manager_icon = baseDir .. "file-manager.svg"
local tutanota_icon = baseDir .. "tutanota-desktop.svg"
local sound_icon = baseDir .. "sound.svg"
local guitarPro_icon = baseDir .. "GuitarPro.svg"
local powerSettings_icon = baseDir .. "preferences-system-power.svg"
local cakeWallet_icon = baseDir .. "cake_wallet.svg"
local koreader_icon = baseDir .. "koreader.svg"

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
    audioAssault = audioAssault_icon,
    berryAmp = baseDir .. "berryamp.svg",
    transmission = baseDir .. "transmission.svg",
    mumble = mumble_icon,
    archiveManager = archive_icon,
    fileManager = file_manager_icon,
    tutanota = tutanota_icon,
    sound = sound_icon,
    guitarPro = guitarPro_icon,
    powerSettings = powerSettings_icon,
    cakeWallet = cakeWallet_icon,
    koreader = koreader_icon
}
-- END LUCI4 Icon Theme
return icons

