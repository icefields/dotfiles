#!/bin/bash
# find_files.sh - Find files with configurable prune paths

# XDG config location (defaults to ~/.config)
#configHome="${XDG_CONFIG_HOME:-$HOME/.config}"
configFile="$HOME/scripts/share_find.conf"  #"$configHome/find_files.conf"

# Read prune paths from config, expand $HOME
mapfile -t prunePaths < <(
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        eval echo "$line"
    done < "$configFile"
)

# Build find arguments array (avoids eval issues)
findArgs=()
findArgs+=(-L "$HOME")
findArgs+=(\()

# Add prune paths with -o between each
first=true
for path in "${prunePaths[@]}"; do
    $first || findArgs+=(-o)
    first=false
    findArgs+=(-path "$path")
done

# Add hidden files to prune and close group
findArgs+=(-o -path '*/.*')
findArgs+=(\))
findArgs+=(-prune -o)
findArgs+=(-type f)
findArgs+=(\()
findArgs+=(-iname "*.png")
findArgs+=(-o -iname "*.jpg")
findArgs+=(-o -iname "*.mpg")
findArgs+=(-o -iname "*.mpeg")
findArgs+=(-o -iname "*.webp")
findArgs+=(-o -iname "*.pdf")
findArgs+=(-o -iname "*.jpeg")
findArgs+=(-o -iname "*.zip")
findArgs+=(-o -iname "*.txt")
findArgs+=(-o -iname "*.mp3")
findArgs+=(-o -iname "*.flac")
findArgs+=(-o -iname "*.wav")
findArgs+=(-o -iname "*.apk")
findArgs+=(-o -iname "*.m4a")
findArgs+=(-o -iname "*.gpt")
findArgs+=(-o -iname "*.gp3")
findArgs+=(-o -iname "*.gp4")
findArgs+=(-o -iname "*.gp5")
findArgs+=(-o -iname "*.gp")
findArgs+=(-o -iname "*.gpx")
findArgs+=(-o -iname "*.svg")
findArgs+=(-o -iname "*.mov")
findArgs+=(-o -iname "*.mp4")
findArgs+=(-o -iname "*.opus")
findArgs+=(-o -iname "*.tar.xz")
findArgs+=(-o -iname "*.tar.gz")
findArgs+=(-o -iname "*.webm")
findArgs+=(-o -iname "*.gif")
findArgs+=(-o -iname "*.exe")
findArgs+=(\))
findArgs+=(-print)

# Execute find
find "${findArgs[@]}"

