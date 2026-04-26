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
    # check if mullvad CLI exists
    if command -v mullvad >/dev/null 2>&1; then
        mullvad_check_connection
        return
    fi

    # fallback: check if any wg interface exists
    if command -v wg >/dev/null 2>&1 && ip link show type wireguard >/dev/null 2>&1; then
        wg_check_connection
        return
    fi

    # nothing found
    echo "disconnected"
}

get_vpn_status() {
    if command -v mullvad >/dev/null 2>&1; then
        get_mullvad_status
        return
    fi

    if command -v wg >/dev/null 2>&1 && ip link show type wireguard >/dev/null 2>&1; then
        get_wg_status
        return
    fi
}

mullvad_check_connection() {
    status=$(mullvad status 2>/dev/null)
    if [[ $? -eq 0 && "$status" == *Connected* ]]; then
        echo "connected"
    else
        echo "disconnected"
    fi
}

wg_check_connection() {
    if ip route get 1.1.1.1 2>/dev/null | grep -qE 'dev (wg|mullvad)'; then
        echo "connected"
    else
        echo "disconnected"
    fi
}

get_wireguard_status() {
    local vpnstatus
    local iface

    # reuse your existing logic indirectly via get_status
    vpnstatus="$(get_status)"

    # extract interface name (lightweight, no connection logic here)
    iface=$(ip link show type wireguard 2>/dev/null | awk -F': ' '/: / {print $2; exit}')

    printf "VPN: %s\nInterface: %s\n\n" "$vpnstatus" "${iface:-none}"
}

get_wg_status() {
    vpnstatus="$(wg_check_connection)"

    iface=$(ip link show type wireguard 2>/dev/null | awk -F': ' '/: / {print $2; exit}')

    printf "VPN: %s\nInterface: %s\n\n" "$vpnstatus" "${iface:-none}"
}

get_mullvad_status() {
    mullstatus="$(mullvad status -v)"
    lockdown=$( [[ $(mullvad lockdown-mode get | xargs) == "Block traffic when the VPN is disconnected: on" ]] && echo "on" || echo "off" )    
    autoconnect=$( [[ $(mullvad auto-connect get | xargs) == "Autoconnect: on" ]] && echo "on" || echo "off" ) 
    vpnstatus="$(get_status)"
    printf "VPN: %s\nLockdown: %s\nAutoconnect: %s\n\n%s\n" "$vpnstatus" "$lockdown" "$autoconnect" "$mullstatus"
    #echo "VPN: $status\nLockdown: $lockdown\nAutoconnect: $autoconnect\n\n$mullstatus"
}

reconnect() {
    if command -v wg >/dev/null 2>&1 && ip link show type wireguard >/dev/null 2>&1; then
        sudo systemctl restart wg-quick@mullvad.service
    elif command -v mullvad >/dev/null 2>&1; then
        mullvad reconnect
    fi
}

toggle_vpn() {
    status=$(get_status)

    if command -v wg >/dev/null 2>&1 && ip link show type wireguard >/dev/null 2>&1; then
        if [[ $status == "connected" ]]; then
            sudo systemctl stop wg-quick@mullvad.service
        else
            sudo systemctl start wg-quick@mullvad.service
        fi
    elif command -v mullvad >/dev/null 2>&1; then
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
    fi

    sleep 5
    statusStr="$(get_vpn_status)"
    notify-send "WiFi Toggle" "$statusStr" #"VPN: $status\nLockdown: $lockdown\nAutoconnect: $autoconnect\n\n$mullstatus"
    echo $status
}


if [[ -z $1 ]]; then
    echo "$(mullvad status -v)"
    exit 0
fi

case "$1" in
    status)
        echo "$(get_vpn_status)"
        ;;
    get)
        get_status
        ;;
    toggle)
        toggle_vpn
        ;;
    reconnect)
        reconnect
        ;;
    *)
        echo "Invalid argument: $1"
        echo "Usage: $0 [get|toggle]"
        exit 1
        ;;
esac

