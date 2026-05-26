#!/usr/bin/env bash

# Icons (Nerd Font codepoints - same format as your wifi script)
ICON_WIFI_CONNECTED="󰖩"
ICON_WIFI_DISCONNECTED="󰖪"
ICON_ETHERNET="󰈀"
ICON_NO_CONNECTION="󱚵"

# Parse arguments
mode=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--icon)
            mode="icon"
            shift
            ;;
        -s|--status)
            mode="status"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Default to icon mode if no argument
[[ -z "$mode" ]] && mode="icon"

# Get network status using nmcli
# Check for active ethernet connection
ethernet_connected=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | \
    grep 'ethernet:connected' | head -1)

# Check for active wifi connection
wifi_ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | cut -d: -f2-)

# Determine connection state
if [[ -n "$ethernet_connected" ]]; then
    connection_type="ethernet"
    connection_name=$(echo "$ethernet_connected" | cut -d: -f1)  # Device name (e.g., enp0s31f6)
elif [[ -n "$wifi_ssid" && "$wifi_ssid" != "" ]]; then
    connection_type="wifi"
    connection_name="$wifi_ssid"
else
    connection_type="disconnected"
    connection_name=""
fi

# Output based on mode
case "$mode" in
    icon)
        case "$connection_type" in
            ethernet)
                echo "$ICON_ETHERNET"
                ;;
            wifi)
                echo "$ICON_WIFI_CONNECTED"
                ;;
            disconnected)
                echo "$ICON_WIFI_DISCONNECTED"
                ;;
        esac
        ;;
    status)
        case "$connection_type" in
            ethernet)
                echo "Ethernet: $connection_name"
                ;;
            wifi)
                echo "WiFi: $connection_name"
                ;;
            disconnected)
                echo "Disconnected"
                ;;
        esac
        ;;
esac

