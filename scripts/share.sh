#!/bin/bash

# This script leverages this share-upload util:
#   https://github.com/icefields/self-hosted-sharelink
# follow the instructions in the readme for configuration.
#
# Before using this, define 2 env variables:
#   SHARE_LINK_AUTH:    the user defined auth token for the sharelink application.
#   SHARE_LINK_URL:     the url of the sharelink service

showmenu() {
    # Read input from standard input
    input=$(cat)
   
    if command -v wofi >/dev/null 2>&1; then
        echo "$input" | wofi --conf $HOME/.config/wofi/config-smenu --style $HOME/.config/wofi/styleS.css 
    elif command -v dmenu >/dev/null 2>&1; then
        echo "$input" | dmenu -i -l 25
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

secretFlag=false
pathValue=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--secret)
            secretFlag=true
            shift
            ;;
        -p|--path)
            pathValue="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ "$secretFlag" == true ]]; then
    source ~/scripts/zip_and_cloak.sh
    dir=$(uuidgen | cut -d'-' -f1)
    mkdir /tmp/$dir
fi

if [[ -n "$pathValue" ]]; then
    # file=$pathValue
    # case pathvalue present, and encryption true
    if [[ "$secretFlag" == true ]]; then
        cp "$pathValue" /tmp/$dir
        file=$(zipAndCloak "/tmp/$dir")
        if [[ -z "$file" ]]; then
            echo "Encryption failed, porcodio!"
            rm -rf "/tmp/$dir"
            exit 1
        fi
        file=$(echo "$file" | tr -d '\n' | xargs)
    else
        # case pathvalue present, and encryption false
        file=$pathValue
    fi
else
    file=$(~/scripts/share_find.sh | showmenu)
    if [[ "$secretFlag" == true ]]; then
        cp "$file" /tmp/$dir
        file=$(zipAndCloak "/tmp/$dir")
        if [[ -z "$file" ]]; then
            echo "Encryption failed, porcodio!"
            rm -rf "/tmp/$dir"
            exit 1
        fi
    fi
fi

# curl -F"file=@$file" 0x0.st | copyClipboard
shareUrl=$(curl -k -X POST \
  -H "X-Auth-Token: $SHARE_LINK_AUTH" \
  -F "file=@$file" $SHARE_LINK_URL | jq -r .public_url)
echo $shareUrl | copyClipboard

echo $shareUrl

# ntfy notification
curl \
    -H "Title: Upload Complete" \
    -H "Priority: low" \
    -H "Tags: skull" \
    -d "$shareUrl" \
    $SHARE_LINK_NOTIFICATION_URL

notify-send "Link Copied for $file"

