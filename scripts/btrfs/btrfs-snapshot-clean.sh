#!/bin/bash
# Cleanup old Btrfs snapshots based on retention policy
# Keeps: N hourly, M daily, W weekly, X monthly

set -euo pipefail

# Config
KEEP_HOURLY=${KEEP_HOURLY:-10}
KEEP_DAILY=${KEEP_DAILY:-7}
KEEP_WEEKLY=${KEEP_WEEKLY:-4}
KEEP_MONTHLY=${KEEP_MONTHLY:-6}

cleanup_dir() {
    local SNAPDIR="$1"
    local PREFIX="$2"

    [ ! -d "$SNAPDIR" ] && return

    echo "Cleaning $SNAPDIR ($PREFIX-*)..."

    mapfile -t SNAPSHOTS < <(
        find "$SNAPDIR" -maxdepth 1 -type d -name "${PREFIX}-*" | sort
    )

    local NOW
    NOW=$(date +%s)

    local HOUR_COUNT=0
    local DAY_COUNT=0
    local WEEK_COUNT=0
    local MONTH_COUNT=0

    for SNAP in "${SNAPSHOTS[@]}"; do
        local NAME TS_STR TS AGE_SEC AGE_HOUR AGE_DAY DELETE

        NAME=$(basename "$SNAP")
        TS_STR="${NAME#${PREFIX}-}"

        TS=$(date -d "${TS_STR:0:8} ${TS_STR:9:2}:${TS_STR:11:2}:${TS_STR:13:2}" +%s 2>/dev/null || true)
        if [[ -z "$TS" || ! "$TS" =~ ^[0-9]+$ ]]; then
            continue
        fi

        AGE_SEC=$((NOW - TS))
        AGE_HOUR=$((AGE_SEC / 3600))
        AGE_DAY=$((AGE_SEC / 86400))

        DELETE=false

        if [ "$AGE_HOUR" -lt 24 ]; then
            ((HOUR_COUNT++))
            [ "$HOUR_COUNT" -gt "$KEEP_HOURLY" ] && DELETE=true

        elif [ "$AGE_DAY" -lt 7 ]; then
            ((DAY_COUNT++))
            [ "$DAY_COUNT" -gt "$KEEP_DAILY" ] && DELETE=true

        elif [ "$AGE_DAY" -lt 30 ]; then
            ((WEEK_COUNT++))
            [ "$WEEK_COUNT" -gt "$KEEP_WEEKLY" ] && DELETE=true

        else
            ((MONTH_COUNT++))
            [ "$MONTH_COUNT" -gt "$KEEP_MONTHLY" ] && DELETE=true
        fi

        if [ "$DELETE" = true ]; then
            echo "  Deleting: $NAME"
            btrfs subvolume delete "$SNAP" 2>/dev/null || true
            rm -f "${SNAP}.info" 2>/dev/null || true
        fi
    done
}

# Run cleanup
cleanup_dir "/.snapshots" "root"
cleanup_dir "/.snapshots" "home"

echo "Cleanup complete."

