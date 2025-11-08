#!/bin/bash

# mullvad auto-connect get
# Autoconnect: on
#
# mullvad auto-connect set on
# mullvad auto-connect set off
#
# mullvad lockdown-mode get 
# Block traffic when the VPN is disconnected: on
#

#get_status() {
#    status=$(mullvad status 2>/dev/null)
#    echo $([[ $? -eq 0 && "$status" == *Connected* ]] && echo "connected" || echo "disconnected")
#}

get_status() {
    status=$(mullvad status 2>/dev/null)
    if [[ $? -eq 0 && "$status" == *Connected* ]]; then
        echo "connected"
    else
        echo "disconnected"
    fi
}

get_mullvad_status() {
    mullstatus="$(mullvad status -v)"
    lockdown=$( [[ $(mullvad lockdown-mode get | xargs) == "Block traffic when the VPN is disconnected: on" ]] && echo "on" || echo "off" )    
    autoconnect=$( [[ $(mullvad auto-connect get | xargs) == "Autoconnect: on" ]] && echo "on" || echo "off" ) 
    vpnstatus="$(get_status)"
    printf "VPN: %s\nLockdown: %s\nAutoconnect: %s\n\n%s\n" "$vpnstatus" "$lockdown" "$autoconnect" "$mullstatus"
    #echo "VPN: $status\nLockdown: $lockdown\nAutoconnect: $autoconnect\n\n$mullstatus"
}

toggle_vpn() {
    status=$(get_status)

    if [[ $status == "connected" ]]; then
        echo "Disconnecting VPN..."
        mullvad lockdown-mode set off
        mullvad auto-connect set off
        mullvad disconnect
    else
        echo "Connecting VPN..."
        mullvad connect
        mullvad lockdown-mode set on
        mullvad auto-connect set on
    fi

    sleep 5
    statusStr="$(get_mullvad_status)"
    notify-send "WiFi Toggle" "$statusStr" #"VPN: $status\nLockdown: $lockdown\nAutoconnect: $autoconnect\n\n$mullstatus"
    echo $status
}


if [[ -z $1 ]]; then
    echo "$(mullvad status -v)"
    exit 0
fi

case "$1" in
    status)
        echo "$(get_mullvad_status)"
        ;;
    get)
        get_status
        ;;
    toggle)
        toggle_vpn
        ;;
    *)
        echo "Invalid argument: $1"
        echo "Usage: $0 [get|toggle]"
        exit 1
        ;;
esac

