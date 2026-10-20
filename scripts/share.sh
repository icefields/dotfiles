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
    -n, --ntfy        Send the share URL via ntfy notification
    -l, --shorten     Shorten the share URL via url-shortener.sh
    -h, --help        Show this help message

Examples:
    $(basename "$0") -s -p /home/lucie/data
    $(basename "$0") --mega
    $(basename "$0") -s -l -p /home/lucie/data
EOF
}

showmenu() {
    # Read input from standard input
    input=$(cat)
  
    if command -v rofi >/dev/null 2>&1; then
        echo "$input" | rofi -dmenu -i -l 25
    elif command -v wofi >/dev/null 2>&1; then
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
   
    if command -v mega-login >/dev/null 2>&1; then
        mega-login "$MEGA_EMAIL" "$MEGA_PASSWORD"
        mega-put "${filename}" /
        local fileOnly="${filename##/tmp/}"
        LINK=$(mega-export -a "/${fileOnly}" | grep -o 'https://mega.nz/.*')
        echo "$LINK"
        echo "$LINK" | xclip -i -sel c -f #  xclip -selection clipboard
    else
        python3 "$scriptPath" "${filename}"
    fi
}

# Shortens the url passed as $1 via ~/scripts/url-shortener.sh:
#     url-shortener.sh <longUrl> -s <id> -m 6 -q
# <id> is a random 5-char slug generated here. Prints the short url
# to stdout, returns non-zero (loudly, on stderr) if anything fails.
shortenUrl() {
    local shortener="$HOME/scripts/url-shortener.sh"
    # first line only, stripped clean: megaShare can print the link
    # twice inside its command substitution, guard against that
    local longUrl
    longUrl=$(head -n 1 <<< "$1" | tr -d '[:space:]')
    local slug shortUrl expiry maxAccess

    if [[ ! -f "$shortener" ]]; then
        echo "Error: url-shortener.sh not found at $shortener" >&2
        return 1
    fi

    # random 5-char slug; switch the charset to 'a-z0-9' if your
    # shortener lowercases or rejects ids
    slug=$(LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 5)
    expiry=$(date -Iseconds -d "+6 days")
    maxAccess="66"

    if [[ -x "$shortener" ]]; then
        shortUrl=$("$shortener" "$longUrl" -s "$slug" -m "$maxAccess" -q --valid-until "$expiry")
    else
        shortUrl=$(bash "$shortener" "$longUrl" -s "$slug" -m "$maxAccess" -q --valid-until "$expiry")
    fi

    # $() already strips trailing newlines; kill stray spaces/CR too,
    # then sanity-check that we actually got a url back
    shortUrl=${shortUrl//[[:space:]]/}
    if [[ -z "$shortUrl" || "$shortUrl" != http* ]]; then
        echo "Error: url-shortener.sh returned nothing usable (slug: $slug)" >&2
        return 1
    fi

    echo "$shortUrl"
}

secretFlag=false
pathValue=""
megaFlag=false
ntfyFlag=false
shortenFlag=false

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
        -l|--shorten)
            shortenFlag=true
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

if [[ "$shortenFlag" == true ]]; then
    if shortUrl=$(shortenUrl "$shareUrl"); then
        shareUrl="$shortUrl"
    else
        echo "Shortening failed, porcodio! Keeping the long URL." >&2
        notify-send "Error: shortener failed, keeping the long URL"
    fi
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

