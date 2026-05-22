#!/usr/bin/env bash
# mount_lib.sh — Reusable mount/unmount functions
# Source this: source "$(dirname "$0")/mount_lib.sh"

mount_nfs() {
    local server="$1"
    local mountpoint="$2"
    local opts="${3:-nfsvers=4,_netdev,timeo=20,retrans=3}"

    if mountpoint -q "$mountpoint" 2>/dev/null; then
        echo "Already mounted at $mountpoint"
        return 0
    fi

    mkdir -p "$mountpoint"
    mount -t nfs -o "$opts" "$server" "$mountpoint"
}

unmount_nfs() {
    local mountpoint="$1"

    if mountpoint -q "$mountpoint" 2>/dev/null; then
        umount "$mountpoint"
    else
        echo "Not mounted"
    fi
}

mount_btrfs() {
    local device="$1"
    local mountpoint="$2"
    local opts="${3:-compress=zstd:3,noatime}"

    if mountpoint -q "$mountpoint" 2>/dev/null; then
        echo "Already mounted at $mountpoint"
        return 0
    fi

    mkdir -p "$mountpoint"
    mount -t btrfs -o "$opts" "$device" "$mountpoint"
}

unmount_btrfs() {
    unmount_nfs "$1"
}

