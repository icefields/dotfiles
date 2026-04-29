#!/bin/bash

if command -v rofi >/dev/null 2>&1; then
    rofi -show drun
elif command -v wofi >/dev/null 2>&1; then
    # TODO    
    wofi --conf $HOME/.config/wofi/config-smenu --style $HOME/.config/wofi/styleS.css 
elif command -v dmenu >/dev/null 2>&1; then
    dmenu_run
elif command -v fzf >/dev/null 2>&1; then
    # TODO
    fzf
else
    echo "Neither dmenu nor rofi is installed."
    return 1
fi

