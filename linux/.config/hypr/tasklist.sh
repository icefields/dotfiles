#!/bin/bash

# Dependencies: hyprctl, jq, wofi

# Get list of open windows in JSON format
clients=$(hyprctl clients -j)

# Sort the windows by focusHistoryID (descending order) to get the most recently used windows first
options=$(echo "$clients" | jq -r 'sort_by(.focusHistoryID) | reverse | .[] | "\(.class) - \(.title | .[:44]) [WS: \(.workspace.name)]"')

# Show the menu in wofi and capture the selected line
selected=$(echo "$options" | wofi --dmenu --prompt "Windows" --width 666 --height 400)

# If nothing was selected, exit
[ -z "$selected" ] && exit 0

# Extract the address from the selected line
address=$(echo "$clients" | jq -r --arg selected "$selected" '.[] | select("\(.class) - \(.title | .[:44]) [WS: \(.workspace.name)]" == $selected) | .address')

# Ensure the address is correctly formatted (address should start with "address:")
if [[ ! $address =~ ^0x ]]; then
    echo "Invalid address format: $address"
    exit 1
fi

hyprctl dispatch focuswindow "address:$address"

