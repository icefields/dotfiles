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
-- WARNING:
-- removed `config.location`, access location with `HomeEnv.LOCATION_COORDINATES` or `config.env.LOCATION_COORDINATES`
-- config.location = HomeEnv.LOCATION_COORDINATES or os.getenv("LOCATION_COORDINATES") or "43.6426,-79.3871" --fallback to Toronto
--
-- This Lua config file could be called by external scripts, for this reason it
-- must be added to the package path programmatically. Calling just
-- HomeEnv = require("home_env")
-- will fail if config.lua is called from a bash script or externally
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/awesome/?.lua"
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/awesome/?.lua"
local success, homeEnv = pcall(require, "home_env")
if success then
    HomeEnv = homeEnv   -- global, access it anywhere in Awesome
else
    local err_msg = HomeEnv:gsub('"', '\\"')
    os.execute(string.format(
        'notify-send -u critical "Config Error" "Failed to load home_env: %s"',
        err_msg
    ))
    -- HomeEnv = { }
end

local hdmi1Display = {
    primary = true,
    mode = "2560x1440",
    pos = "1920x0",
    rotate = "normal",
}

local hdmiDisplayScaled = {
    primary = true,
    mode = "2560x1440",
    pos = "2560x0",
    rotate = "normal",
    --scale = "1.667x1.667"
    scale = "1.75x1.75"
}

local displays = {
    ["HDMI-1-0"] = hdmi1Display,
    ["HDMI-1"] = hdmi1Display,
    ["HDMI-A-0"] = hdmiDisplayScaled,
    ["eDP-1"] = {
        primary = false,
        mode = "1920x1080",
        pos = "0x360",
        rotate = "normal",
    },
    ["eDP"] = {
        primary = false,
        --dpi = 144,
        mode = "2560x1600",
        pos = "0x280",--"0x360",
        rotate = "normal",
    },
    ["VNC-0"] = {
        primary = false,
        mode = "1280x720",
        pos = "0x0",
        rotate = "normal",
    }
}

local config = {}
config.home = os.getenv("HOME")
config.isRotateWallpapers = true
config.wallpaperRotationInterval = 3600
config.garbageCollectionInterval = 1800
config.chosenThemeDir = "/themes/luci4/"
config.chosenThemePath = config.chosenThemeDir .. "awesome_theme.lua"
config.env = HomeEnv
config.displays = displays

return config

