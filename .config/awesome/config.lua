local config = {}
--local home = os.getenv("HOME")

config.chosenThemeDir = "/themes/luci4/"
config.chosenThemePath = config.chosenThemeDir .. "awesome_theme.lua"
config.location = HomeEnv.LOCATION_COORDINATES or "43.6426,-79.3871" --fallback to Toronto

local hdmi1Display = {
    primary = true,
    mode = "2560x1440",
    pos = "1920x0",
    rotate = "normal",
}

config.displays = {
    ["HDMI-1-0"] = hdmi1Display,
    ["HDMI-1"] = hdmi1Display,
    ["eDP-1"] = {
        primary = false,
        mode = "1920x1080",
        pos = "0x360",
        rotate = "normal",
    },
    ["VNC-0"] = {
        primary = false,
        mode = "1280x720",
        pos = "0x0",
        rotate = "normal",
    }
}

return config

