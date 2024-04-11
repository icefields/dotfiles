#!/usr/bin/env bash

function run {
    if ! pgrep $1 ; then
        $@&
    fi
}

if xrandr | grep -q 'HDMI-1-0 connected' ; then
	xrandr --output eDP-1 --mode 1920x1080 --pos 0x360 --rotate normal --output HDMI-1-0 --primary --mode 2560x1440 --pos 1920x0 --rotate normal    
fi
