#!/bin/bash

# THIS IS A BACKUP, PLEASE USE THE LUA SCRIPT WITH THE SAME NAME INSTEAD
# Luci4 script to set a random wallpaper for each screen
# use this every restart or in chronjob that will change the background over
# time. 

for x in {0..1}
do
    nitrogen --set-zoom-fill --random ~/.config/awesome/themes/luci4/wallpapers --head=$x > /dev/null 2>&1
done
