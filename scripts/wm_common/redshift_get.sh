#!/bin/bash

# Check if Redshift is running
if pgrep -x "redshift" > /dev/null
then
    # Redshift is running, check the period
    period=$(redshift -p | grep -oP 'Period: \K\w+')
    
    if [[ "$period" == "Night" ]]; then
        echo ""  # Moon icon for night
    elif [[ "$period" == "Daytime" ]]; then
        echo "" 
    elif [[ "$period" == "Transition" ]]; then
        echo "󰖚" #"󱩸" 
    else
        echo ""  # Fallback (lightbulb)
    fi
else
    # Redshift is not running
    echo ""  
fi

