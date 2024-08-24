#!/bin/bash

showmenu() {
    # Read input from standard input
    input=$(cat)
    
    # Check for dmenu or wofi and use the appropriate one
    if command -v dmenu >/dev/null 2>&1; then
        echo "$input" | dmenu -i -l 25
    elif command -v wofi >/dev/null 2>&1; then
        echo "$input" | wofi --dmenu -i -l 25
    elif command -v fzf >/dev/null 2>&1; then
        echo "$input" | fzf
    else
        echo "Neither dmenu nor wofi is installed."
        return 1
    fi
}

copyClipboard() {
    input=$(cat)
    if command -v wl-copy >/dev/null 2>&1; then
        echo "wlcopy $input"
        echo "$input" | wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        echo "$input" | xclip -selection c
    else
        echo "Neither wl-copy nor xclip is installed."
        return 1
    fi

}

file=$(find -L $HOME \( -path $HOME/.wine -o -path $HOME/.steam -o -path $HOME/Code -o -path '*/.*' \) -prune -o -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.mpg" -o -iname "*.mpeg" -o -iname "*.webp" -o -iname "*.pdf" -o -iname "*.jpeg" -o -iname "*.zip" -o -iname "*.txt" -o -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.gpt" -o -iname "*.gp3" -o -iname "*.gp4" -o -iname "*.gp5" -o -iname "*.gp" -o -iname "*.gpx" -o -iname "*.svg" -o -iname "*.mp4" -o -iname "*.webm" -o -iname "*.gif" \) | showmenu) #wofi --dmenu -i -l 25)
curl -F"file=@$file" 0x0.st | copyClipboard
notify-send "Link Copied"
