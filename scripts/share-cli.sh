#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/file"
  exit 1
fi

FILE_PATH="$1"

if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File '$FILE_PATH' not found!"
  exit 2
fi

if [ -z "$SHARE_LINK_AUTH" ]; then
  echo "Error: SHARE_LINK_AUTH environment variable is not set."
  exit 3
fi

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

response=$(curl -k -X POST \
  -H "X-Auth-Token: $SHARE_LINK_AUTH" \
  -F "file=@${FILE_PATH}" \
  $SHARE_LINK_URL)

echo $response
echo $response | jq -r .public_url | copyClipboard

