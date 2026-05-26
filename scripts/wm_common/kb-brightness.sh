#!/usr/bin/env bash

#iDIR="$HOME/.config/mako/icons"
iDIR="$HOME/scripts/wm_common/icons/notifications"

device=""
if [ -d /sys/class/leds/asus::kbd_backlight ]; then
    device="asus::kbd_backlight"
elif [ -d /sys/class/leds/kbd_backlight ]; then
    device="kbd_backlight"
else
    echo "No"
    exit 1
fi

# Get brightness
get_backlight() {
	LIGHT=$(brightnessctl -d "$device" i | awk -F'[()%]' '{print $2}')
    #LIGHT=$(printf "%.0f\n" $(brightnessctl --device="$device" i))
	echo "${LIGHT}%"
}

# Get icons
get_icon() {
	backlight="$(brightnessctl -d "$device" g)"
	current="${backlight%%%}"
	if [[ ("$current" -ge "0") && ("$current" -le "1") ]]; then
		icon="$iDIR/brightness-20.png"
	elif [[ ("$current" -ge "1") && ("$current" -le "2") ]]; then
		icon="$iDIR/brightness-60.png"
	elif [[ ("$current" -ge "2") && ("$current" -le "3") ]]; then
		icon="$iDIR/brightness-100.png"
	fi
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$icon" "Keyboard Brightness : $(brightnessctl -d "$device" g)"
}

# Increase brightness
inc_backlight() {
	brightnessctl --device="$device" set 8%+ && get_icon && notify_user
}

# Decrease brightness
dec_backlight() {
	# brightnessctl -d *::kbd_backlight set 33%- && get_icon && notify_user
	brightnessctl --device="$device" set 8%- && get_icon && notify_user
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	brightnessctl -d '*::kbd_backlight' g
elif [[ "$1" == "--inc" ]]; then
	inc_backlight
elif [[ "$1" == "--dec" ]]; then
	dec_backlight
else
	get_backlight
fi
