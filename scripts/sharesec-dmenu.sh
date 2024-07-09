#!/bin/bash

dir=$(uuidgen | cut -d'-' -f1)
mkdir /tmp/$dir
file=$(find -L $HOME \( -path $HOME/.wine -o -path $HOME/.steam -o -path $HOME/Code -o -path '*/.*' \) -prune -o -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.mpg" -o -iname "*.mpeg" -o -iname "*.webp" -o -iname "*.pdf" -o -iname "*.jpeg" -o -iname "*.zip" -o -iname "*.txt" -o -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.gpt" -o -iname "*.gp3" -o -iname "*.gp4" -o -iname "*.gp5" -o -iname "*.gp" -o -iname "*.gpx" -o -iname "*.svg" -o -iname "*.gif" \) | dmenu -i -l 25)
cp $file /tmp/$dir
zip -r /tmp/$dir.zip /tmp/$dir
zipcloak /tmp/$dir.zip
curl -F"file=@/tmp/$dir.zip" 0x0.st | xclip -selection c
notify-send "Link Copied"

