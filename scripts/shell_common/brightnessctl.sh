#!/usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

# Detect notification method
if command -v dunstify >/dev/null 2>&1; then
    NOTIFY_CMD="dunstify"
else
    NOTIFY_CMD="notify-send"
fi

# Get brightness percentage
get_brightness() {
    current=$(brightnessctl g)
    max=$(brightnessctl m)
    echo $(( current * 100 / max ))
}

# Get icon based on brightness %
get_icon() {
    current=$(get_brightness)

    if (( current <= 20 )); then
        icon="$iDIR/brightness-20.png"
    elif (( current <= 40 )); then
        icon="$iDIR/brightness-40.png"
    elif (( current <= 60 )); then
        icon="$iDIR/brightness-60.png"
    elif (( current <= 80 )); then
        icon="$iDIR/brightness-80.png"
    else
        icon="$iDIR/brightness-100.png"
    fi
}

# Notify using dunstify
notify_user_dunst() {
    current=$(get_brightness)

    dunstify -r 9991 \
        -u low \
        -i "$icon" \
        "Brightness: ${current}%"
}

# Notify (uses dunstify if available, otherwise notify-send)
notify_user() {
    current=$(get_brightness)

    if [[ "$NOTIFY_CMD" == "dunstify" ]]; then
        dunstify -r 9991 \
            -u low \
            -i "$icon" \
            "Brightness: ${current}%"
    else
        notify-send -h string:x-canonical-private-synchronous:sys-notify \
            -u low \
            -i "$icon" \
            "Brightness: ${current}%"
    fi
}

# Increase brightness
inc_backlight() {
    brightnessctl set 10%+ && get_icon && notify_user
}

# Decrease brightness
dec_backlight() {
    brightnessctl set 10%- && get_icon && notify_user
}

# Execute
if [[ "$1" == "--get" ]]; then
    get_brightness
elif [[ "$1" == "--inc" ]]; then
    inc_backlight
elif [[ "$1" == "--dec" ]]; then
    dec_backlight
else
    get_brightness
fi

