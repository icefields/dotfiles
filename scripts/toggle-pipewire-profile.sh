#!/bin/bash

NORMAL_CONF="$HOME/.config/pipewire/pipewire.conf.d/normal.conf"
LOWLATENCY_CONF="$HOME/.config/pipewire/pipewire.conf.d/lowlatency.conf"
NORMAL_CONF_DISABLED="$HOME/.config/pipewire/pipewire.conf.d/normal.conf.disabled"
LOWLATENCY_CONF_DISABLED="$HOME/.config/pipewire/pipewire.conf.d/lowlatency.conf.disabled"

# Check which config is currently active
if [ -f "$NORMAL_CONF" ]; then
    # echo "Switching to low-latency profile..."
    mv "$NORMAL_CONF" "$NORMAL_CONF_DISABLED"
    mv "$LOWLATENCY_CONF_DISABLED" "$LOWLATENCY_CONF"
    PROFILE="Low-Latency"
elif [ -f "$LOWLATENCY_CONF" ]; then
    # echo "Switching to normal profile..."
    mv "$LOWLATENCY_CONF" "$LOWLATENCY_CONF_DISABLED"
    mv "$NORMAL_CONF_DISABLED" "$NORMAL_CONF"
    PROFILE="Normal"
else
    echo "Error: Config files not found or already disabled."
    exit 1
fi

# Restart PipeWire user services to apply changes
systemctl --user restart pipewire pipewire-pulse

echo "$PROFILE"

