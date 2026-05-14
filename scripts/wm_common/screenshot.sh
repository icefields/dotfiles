#!/usr/bin/env bash

### Full credit for this script to https://github.com/TheGassyNinja

export DISPLAY=:0
if [ -d "$HOME/Downloads/Screenshots" ]; then
    DIR="$HOME/Downloads/Screenshots"
elif [ -d "$HOME/Downloads" ]; then
    DIR="$HOME/Downloads"
else
    DIR="$HOME"
fi
current=$(date +%H-%M-%S-%d-%m-%Y).png
FILE="$DIR/$current"

if [[ -z "${1}" ]]; then
	import -window root $FILE || exit 0 # If no argument, full screen (all monitors)
else
	import $FILE || exit 0 # Custom selection, or click a window
fi

notify-send "Screenshot ${current} taken successfully!"
