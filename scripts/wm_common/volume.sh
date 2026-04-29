#!/bin/bash

iDIR="$HOME/.config/mako/icons"

# Detect notification method
if command -v dunstify >/dev/null 2>&1; then
    NOTIFY_CMD="dunstify"
else
    NOTIFY_CMD="notify-send"
fi

# Get Volume
get_volume() {
	volume=$(pamixer --get-volume)
	echo "$volume"
}

# Get icons
get_icon() {
	current=$(get_volume)
	if [[ "$current" -eq "0" ]]; then
		echo "$iDIR/volume-mute.png"
	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
		echo "$iDIR/volume-low.png"
	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
		echo "$iDIR/volume-mid.png"
	elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
		echo "$iDIR/volume-high.png"
	fi
}

# Notify (uses dunstify if available, otherwise notify-send)
notify_user() {
    if [[ "$NOTIFY_CMD" == "dunstify" ]]; then
        dunstify -r 9991 -u low -i "$(get_icon)" "Volume : $(get_volume) %"
    else
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume : $(get_volume) %"
    fi
}

# Increase Volume
inc_volume() {
	if command -v pamixer &>/dev/null; then
        pamixer --increase 1 && notify_user
    elif command -v amixer &>/dev/null; then
        amixer -D pulse sset Master 2%+ && notify_user
    else
        echo "porcodio: no audio backend found" >&2
        return 1
    fi
    #pamixer -i 1 && notify_user
}

# Decrease Volume
dec_volume() {
	if command -v pamixer &>/dev/null; then
        pamixer --decrease 1 && notify_user
    elif command -v amixer &>/dev/null; then
        amixer -D pulse sset Master 2%- && notify_user
    else
        echo "porcodio: no audio backend found" >&2
        return 1
    fi
    notify_user
    #pamixer -d 1 && notify_user
}

# Toggle Mute
toggle_mute() {
	if command -v pamixer &>/dev/null; then
        if [ "$(pamixer --get-mute)" == "false" ]; then
		    pamixer -m && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
	    elif [ "$(pamixer --get-mute)" == "true" ]; then
		    pamixer -u && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Switched ON"
	    fi
    elif command -v amixer &>/dev/null; then
        amixer -D pulse sset Master toggle
    else
        echo "porcodio: no audio backend found" >&2
        return 1
    fi
}

# Toggle Mic
toggle_mic() {
	if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
		pamixer --default-source -m && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/microphone-mute.png" "Microphone Switched OFF"
	elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		pamixer -u --default-source u && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/microphone.png" "Microphone Switched ON"
	fi
}
# Get icons
get_mic_icon() {
	current=$(pamixer --default-source --get-volume)
	if [[ "$current" -eq "0" ]]; then
		echo "$iDIR/microphone.png"
	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
		echo "$iDIR/microphone.png"
	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
		echo "$iDIR/microphone.png"
	elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
		echo "$iDIR/microphone.png"
	fi
}
get_mic_text_icon() {
	current=$(pamixer --default-source --get-volume)
    if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
	    echo ""
    elif [[ "$current" -eq "0" ]]; then
		echo ""
	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
		echo ""
	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
		echo ""
	elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
		echo ""
	fi
}

# Notify
notify_mic_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_mic_icon)" "Mic-Level : $(pamixer --default-source --get-volume) %"
}

# Increase MIC Volume
inc_mic_volume() {
	pamixer --default-source -i 1 && notify_mic_user
}

# Decrease MIC Volume
dec_mic_volume() {
	pamixer --default-source -d 1 && notify_mic_user
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
	get_mic_icon
elif [[ "$1" == "--get-mic-text-icon" ]]; then
	get_mic_text_icon
elif [[ "$1" == "--mic-inc" ]]; then
	inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
	dec_mic_volume
else
	get_volume
fi
