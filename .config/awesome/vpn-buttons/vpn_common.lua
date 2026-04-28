local config = {}
local home = os.getenv("HOME")

config.toggleScript     = home .. "/scripts/toggle-wifi-profile.sh toggle"
config.getScript        = home .. "/scripts/toggle-wifi-profile.sh get"
config.statusScript     = home .. "/scripts/toggle-wifi-profile.sh status"
config.reconnectScript  = home .. "/scripts/toggle-wifi-profile.sh reconnect"
config.wifiIconScript  = home .. "/scripts/wm_common/wifi-status.sh -i"
config.wifiStatusScript  = home .. "/scripts/wm_common/wifi-status.sh -s"
config.wifiMenuScript  = home .. "/scripts/wm_common/wifi-menu.sh"
--config.buttonSize = 24

return config

