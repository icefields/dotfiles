local config = {}
local home = os.getenv("HOME")

config.toggleScript     = home .. "/scripts/toggle-wifi-profile.sh toggle"
config.getScript        = home .. "/scripts/toggle-wifi-profile.sh get"
config.statusScript     = home .. "/scripts/toggle-wifi-profile.sh status"
config.reconnectScript  = "mullvad reconnect"
config.buttonSize = 24
config.font = "Symbols Nerd Font Mono 9"

return config

