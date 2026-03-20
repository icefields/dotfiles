#!/bin/bash

# Check if Redshift is running
if pgrep -x "redshift" > /dev/null
then
    pkill redshift
    sleep 5
    $HOME/scripts/applaunch/redshift_get.sh
    # redshift -x
else
    #redshift
    redshift > /dev/null 2>&1 &
    sleep 5
    $HOME/scripts/applaunch/redshift_get.sh
fi

