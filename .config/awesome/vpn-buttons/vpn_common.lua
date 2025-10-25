local config = {}

config.toggleScript = "$HOME/scripts/toggle-wifi-profile.sh toggle"
config.getScript = "$HOME/scripts/toggle-wifi-profile.sh get"
config.statusScript = os.getenv("HOME") .. "/scripts/toggle-wifi-profile.sh status"
config.reconnectScript = "mullvad reconnect"
config.buttonSize = 24
config.font = "Symbols Nerd Font Mono 9"

return config

