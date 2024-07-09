#!/bin/bash

dir=$(uuidgen | cut -d'-' -f1)
mkdir /tmp/$dir

# if arguments are provided use them, otherwise do a manual selection
if [ -z "$1" ]
  then
    cp $(find ~ -type f | fzf -m) /tmp/$dir
  else
    cp $1 /tmp/$dir
fi

zip -r /tmp/$dir.zip /tmp/$dir
zipcloak /tmp/$dir.zip
curl -F"file=@/tmp/$dir.zip" 0x0.st | xclip -selection c
notify-send "Link Copied"
