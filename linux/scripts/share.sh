#!/bin/bash

# This script leverages this share-upload util:
#   https://github.com/icefields/self-hosted-sharelink
# follow the instructions in the readme for configuration.
#
# Before using this, define 2 env variables:
#   SHARE_LINK_AUTH:    the user defined auth token for the sharelink application.
#   SHARE_LINK_URL:     the url of the sharelink service

# Help function
showHelp() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    -s, --secret      Enable secret mode (boolean flag)
    -p, --path PATH   Specify a custom path
    -m, --mega        Execute mega.sh script
    -h, --help        Show this help message

Examples:
    $(basename "$0") -s -p /home/lucie/data
    $(basename "$0") --mega
    $(basename "$0") -sm
EOF
}

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

megaShare() {
    local filename="$1"
    local scriptPath=""
    if [[ -f "./share-mega.py" ]]; then
        scriptPath="./share-mega.py"
    elif [[ -f "$HOME/scripts/share-mega.py" ]]; then
        scriptPath="$HOME/scripts/share-mega.py"
    else
        echo "Error: share-mega.py not found" >&2
        return 1
    fi
    python3 "$scriptPath" "${filename}"
}

secretFlag=false
pathValue=""
megaFlag=false
ntfyFlag=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--ntfy)
            ntfyFlag=true
            shift
            ;;
        -s|--secret)
            secretFlag=true
            shift
            ;;
        -p|--path)
            pathValue="$2"
            shift 2
            ;;
        -m|--mega)
            megaFlag=true
            shift
            ;;
        -h|--help)
            showHelp
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            showHelp
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

if [[ "$megaFlag" == true ]]; then
    shareUrl=$(megaShare "$file") || { notify-send "Error: megaShare failed"; exit 1; }
    # megaShare "$file" || exit 1
else
    # curl -F"file=@$file" 0x0.st | copyClipboard
    shareUrl=$(curl -k -X POST \
      -H "X-Auth-Token: $SHARE_LINK_AUTH" \
      -F "file=@$file" $SHARE_LINK_URL | jq -r .public_url)
fi

echo $shareUrl | copyClipboard
echo $shareUrl

# ntfy notification
if [[ "$ntfyFlag" == true ]]; then
  curl \
    -H "Title: Upload Complete" \
    -H "Priority: low" \
    -H "Tags: skull" \
    -d "$shareUrl" \
    $SHARE_LINK_NOTIFICATION_URL
fi

notify-send "Link Copied for $file"


