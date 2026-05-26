#!/bin/bash

# Only launch xfce4-power-manager if asusctl is NOT present
# and xfce4-power-manager IS installed
if ! command -v asusctl &>/dev/null; then
    if command -v xfce4-power-manager &>/dev/null; then
        xfce4-power-manager --daemon --no-tray-icon
    fi
fi

