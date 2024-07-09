#!/bin/bash

dir=$(uuidgen | cut -d'-' -f1)
mkdir /tmp/$dir
cp $(find ~ -type f | fzf -m) /tmp/$dir
zip -r /tmp/$dir.zip /tmp/$dir
zipcloak /tmp/$dir.zip
curl -F"file=@/tmp/$dir.zip" 0x0.st | xclip -selection c
notify-send "Link Copied"
