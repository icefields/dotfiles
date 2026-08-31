#!/bin/bash

#if ! pgrep -f "picom" ;
#  then
#    sleep 3
    picom -b --no-frame-pacing --log-level warn --log-file /tmp/picom.log
    # picom -b --log-level warn --log-file /tmp/picom.log
    #picom -b
#fi
