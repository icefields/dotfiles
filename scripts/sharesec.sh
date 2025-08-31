#!/bin/bash

# This script leverages this share-upload util:
#   https://github.com/icefields/self-hosted-sharelink
# follow the instructions in the readme for configuration.
#
# Before using this, define 2 env variables:
#   SHARE_LINK_AUTH:    the user defined auth token for the sharelink application.
#   SHARE_LINK_URL:     the url of the sharelink service

dir=$(uuidgen | cut -d'-' -f1)
mkdir /tmp/$dir

# if arguments are provided use them, otherwise do a manual selection
if [ -z "$1" ]
  then
    #selected_files=$(find ~ -type f | fzf -m)
    selected_files=$(find -L $HOME \( -path $HOME/.wine -o -path $HOME/.steam -o -path $HOME/Code -o -path '*/.*' \) -prune -o -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.mpg" -o -iname "*.mpeg" -o -iname "*.webp" -o -iname "*.pdf" -o -iname "*.jpeg" -o -iname "*.zip" -o -iname "*.txt" -o -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.gpt" -o -iname "*.apk" -o -iname "*.gp3" -o -iname "*.gp4" -o -iname "*.gp5" -o -iname "*.gp" -o -iname "*.gpx" -o -iname "*.mp4" -o -iname "*.webm" -o -iname "*.svg" -o -iname "*.gif" \) | fzf -m)

    # Check if selected_files is empty
    if [ -z "$selected_files" ]; then
        echo "No files selected."
        exit 1
    fi

    while IFS= read -r -d $'\n' file; do
        printf '"%s"\n' "$file"
    done <<< "$selected_files" | xargs -I{} cp {} /tmp/"$dir"
    # cp $(find ~ -type f | fzf -m) /tmp/$dir
  else
    cp $1 /tmp/$dir
fi

zip -r /tmp/$dir.zip /tmp/$dir
zipcloak /tmp/$dir.zip
#curl -F"file=@/tmp/$dir.zip" 0x0.st | xclip -selection clipboard
curl -k -X POST \
  -H "X-Auth-Token: $SHARE_LINK_AUTH" \
  -F "file=@/tmp/$dir.zip" $SHARE_LINK_URL | jq -r .public_url | xclip -selection clipboard

notify-send "Link Copied"

