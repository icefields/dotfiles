#!/usr/bin/env bash

CONFIG_PATH="$HOME/.config/awesome/config.lua"

get_lua_value() {
    local display=$1
    local key=$2
    lua -e "config = dofile('$CONFIG_PATH'); print(config.displays['$display'] and config.displays['$display'].$key or '')"
}

# Get only physically connected displays
connected_displays=($(xrandr --query | awk '/ connected/{print $1}'))

# Build command - start by turning OFF mirroring for all connected displays
CMD=""

# Loop over connected displays only
for display in "${connected_displays[@]}"; do
    MODE=$(get_lua_value "$display" "mode")
    DPI=$(get_lua_value "$display" "dpi")
    POS=$(get_lua_value "$display" "pos")
    ROT=$(get_lua_value "$display" "rotate")
    PRIMARY=$(get_lua_value "$display" "primary")
 
    if [ -n "$DPI" ]; then
        DPI="--dpi $DPI"
    else
        DPI=""
    fi

    if [ -n "$MODE" ]; then
        # Explicitly set mode and position - this breaks any existing mirror
        CMD="$CMD --output $display --mode $MODE --scale 1x1 $DPI --pos $POS --rotate $ROT"
        [ "$PRIMARY" = "true" ] && CMD="$CMD --primary"
    else
        # No config? Use --auto to enable it properly
        echo "No config for $display — using auto"
        CMD="$CMD --output $display --auto"
    fi

    #if [ -n "$MODE" ]; then
    #    CMD="$CMD --output $display --mode $MODE --pos $POS --rotate $ROT"
    #    [ "$PRIMARY" = "true" ] && CMD="$CMD --primary"
    #        else
    #    echo "No config found for $display — skipping"
    #fi
done

echo "Running: xrandr $CMD"
xrandr $CMD

#if xrandr | grep -q 'HDMI-1-0 connected' ; then
#    EDP_MODE=$(get_lua_value "eDP-1" "mode")
#    EDP_POS=$(get_lua_value "eDP-1" "pos")
#    EDP_ROT=$(get_lua_value "eDP-1" "rotate")
#
#    HDMI_MODE=$(get_lua_value "HDMI-1-0" "mode")
#    HDMI_POS=$(get_lua_value "HDMI-1-0" "pos")
#    HDMI_ROT=$(get_lua_value "HDMI-1-0" "rotate")
#
#    xrandr --output eDP-1 --mode "$EDP_MODE" --pos "$EDP_POS" --rotate "$EDP_ROT" \
#           --output HDMI-1-0 --primary --mode "$HDMI_MODE" --pos "$HDMI_POS" --rotate "$HDMI_ROT"
#fi

#if xrandr | grep -q 'HDMI-1-0 connected' ; then
#	xrandr --output eDP-1 --mode 1920x1080 --pos 0x360 --rotate normal --output HDMI-1-0 --primary --mode 2560x1440 --pos 1920x0 --rotate normal    
#fi
