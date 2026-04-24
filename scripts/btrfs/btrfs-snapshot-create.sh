#!/bin/bash
# Create Btrfs snapshots in unified @snapshots location
# Usage: btrfs-snapshot-create <root|home|both> [description]

set -e

SNAPSHOT_DIR="/.snapshots"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

create_snapshot() {
    local SOURCE="$1"
    local NAME="$2"
    local DESC="$3"
    
    local FULLNAME="${NAME}-${TIMESTAMP}"
    
    # Create read-only snapshot
    btrfs subvolume snapshot -r "$SOURCE" "${SNAPSHOT_DIR}/${FULLNAME}"
    
    # Write metadata
    cat > "${SNAPSHOT_DIR}/${FULLNAME}.info" << EOF
timestamp=$(date -Iseconds)
description=${DESC}
source=${SOURCE}
readonly=true
EOF
    
    echo "Created: ${SNAPSHOT_DIR}/${FULLNAME}"
}

case "$1" in
    root)
        create_snapshot "/" "root" "$2"
        ;;
    home)
        create_snapshot "/home" "home" "$2"
        ;;
    both)
        create_snapshot "/" "root" "$2"
        create_snapshot "/home" "home" "$2"
        ;;
    *)
        echo "Usage: $0 {root|home|both} [description]"
        exit 1
        ;;
esac
