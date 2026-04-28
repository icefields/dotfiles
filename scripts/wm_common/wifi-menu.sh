#!/usr/bin/env bash

notify-send "Scanning for available Wi-Fi networks..."

# Get Wi-Fi status
wifi_status=$(nmcli -t -f WIFI g)
if [[ "$wifi_status" == "enabled" ]]; then
    toggle="󰖪  Disable Wi-Fi"
else
    toggle="󰖩  Enable Wi-Fi"
fi

# Get available Wi-Fi networks
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

# Build menu
menu=$(echo -e "$toggle\n$wifi_list" | uniq -u)

# Get currently connected SSID
current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

# Find index of current SSID for highlighting (0-based)
selected_index=$(printf "%s\n" "$menu" | nl -v 0 | grep -F "$current_ssid" | awk '{print $1}')
selected_index=${selected_index:-0}  # fallback if no match

# Show menu
chosen_network=$(printf "%s\n" "$menu" | rofi -dmenu -i -p "Wi-Fi SSID:" -selected-row "$selected_index")

# Exit if nothing selected
[[ -z "$chosen_network" ]] && exit

# Handle Wi-Fi toggle
if [[ "$chosen_network" == "󰖩  Enable Wi-Fi" ]]; then
    nmcli radio wifi on
    notify-send "Wi-Fi Enabled"
    exit
elif [[ "$chosen_network" == "󰖪  Disable Wi-Fi" ]]; then
    nmcli radio wifi off
    notify-send "Wi-Fi Disabled"
    exit
fi

# Extract SSID from selected line
chosen_id="${chosen_network:3}"  # remove icon/prefix

# Check if connection already exists
if nmcli -g NAME connection show | grep -xq "$chosen_id"; then
    nmcli connection up id "$chosen_id" && notify-send "Connected" "You are now connected to \"$chosen_id\"."
else
    # Prompt for password if network is secured
    if [[ "$chosen_network" == *""* ]]; then
        wifi_password=$(rofi -dmenu -p "Password for $chosen_id:")
    else
        wifi_password=""
    fi
    nmcli device wifi connect "$chosen_id" password "$wifi_password" && \
        notify-send "Connected" "You are now connected to \"$chosen_id\"."
fi
