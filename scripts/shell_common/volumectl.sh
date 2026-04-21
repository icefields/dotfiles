#!/bin/bash
# volumectl.sh - Audio volume control with automatic backend detection
# Usage: volumectl.sh -r|-l|-m

set -e

# --- Helper Functions ---

raiseVolume() {
    if command -v pamixer &>/dev/null; then
        pamixer --increase 4
    elif command -v amixer &>/dev/null; then
        amixer -D pulse sset Master 2%+
    else
        echo "porcodio: no audio backend found" >&2
        return 1
    fi
}

lowerVolume() {
    if command -v pamixer &>/dev/null; then
        pamixer --decrease 4
    elif command -v amixer &>/dev/null; then
        amixer -D pulse sset Master 2%-
    else
        echo "porcodio: no audio backend found" >&2
        return 1
    fi
}

muteVolume() {
    if command -v pamixer &>/dev/null; then
        pamixer --toggle-mute
    elif command -v amixer &>/dev/null; then
        amixer -D pulse sset Master toggle
    else
        echo "porcodio: no audio backend found" >&2
        return 1
    fi
}

usage() {
    echo "Usage: $0 [-r]aise | [-l]ower | [-m]ute-toggle"
    exit 1
}

# --- Main ---

while getopts "rlmh" opt; do
    case "${opt}" in
        r) raiseVolume; exit $? ;;
        l) lowerVolume; exit $? ;;
        m) muteVolume; exit $? ;;
        h) usage ;;
        *) usage ;;
    esac
done

# show usage if no args
if [[ $OPTIND -eq 1 ]]; then
    usage
fi

