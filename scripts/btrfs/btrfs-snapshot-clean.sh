#!/usr/bin/env bash
# btrfs_cleanup.sh — Prune btrfs snapshots, keeping only N most recent per type
# Usage: btrfs_cleanup.sh --keep 6 --type home,config,root,dotfiles [--dry-run] [--snapshot-dir /.snapshots]

set -euo pipefail

SNAPSHOT_DIR="/.snapshots"
KEEP=6
TYPES=""
DRY_RUN=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    cat <<EOF
Usage: $(basename "$0") --keep N --type type1,type2,... [options]

Options:
  --keep N           Snapshots to keep per type (default: 6)
  --type types       Comma-separated types: config,home,dotfiles,root
  --snapshot-dir     Base directory (default: /.snapshots)
  --dry-run          Preview without deleting
  -h, --help         This message
EOF
    exit 0
}

die() {
    printf "${RED}Error:${NC} %s\n" "$1" >&2
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --keep)         KEEP="$2"; shift 2 ;;
        --type)         TYPES="$2"; shift 2 ;;
        --snapshot-dir) SNAPSHOT_DIR="$2"; shift 2 ;;
        --dry-run)      DRY_RUN=true; shift ;;
        -h|--help)      usage ;;
        *)              die "Unknown argument: $1" ;;
    esac
done

# --- Validation ---
[[ -z "$TYPES" ]] && die "--type is required"
[[ "$KEEP" =~ ^[0-9]+$ ]] || die "--keep must be a non-negative integer, got: $KEEP"
[[ -d "$SNAPSHOT_DIR" ]] || die "Snapshot directory does not exist: $SNAPSHOT_DIR"
command -v btrfs >/dev/null 2>&1 || die "btrfs command not found — install btrfs-progs"

IFS=',' read -ra TYPE_LIST <<< "$TYPES"

for snapType in "${TYPE_LIST[@]}"; do
    printf "${CYAN}=== %s ===${NC}\n" "$snapType"

    # Collect snapshot dirs matching the type, sorted newest-first.
    # Names are {type}-{YYYYMMDD}-{HHMMSS} — lexicographic sort = chronological.
    # The || true prevents set -e from aborting when mapfile reads zero lines.
    mapfile -t snapshots < <(find "${SNAPSHOT_DIR}" -maxdepth 1 -type d -name "${snapType}-*" | sort -r) || true
    total=${#snapshots[@]}

    if [[ $total -le $KEEP ]]; then
        printf "  ${GREEN}%d snapshot(s) found (keep=%d) — nothing to prune.${NC}\n" "$total" "$KEEP"
        continue
    fi

    pruneCount=$((total - KEEP))
    printf "  ${YELLOW}%d snapshots found, keeping %d newest, pruning %d.${NC}\n" "$total" "$KEEP" "$pruneCount"

    for ((i = KEEP; i < total; i++)); do
        snap="${snapshots[$i]}"
        snapName="$(basename "$snap")"
        infoFile="${SNAPSHOT_DIR}/${snapName}.info"

        if [[ $DRY_RUN == true ]]; then
            printf "  ${YELLOW}[DRY-RUN]${NC} Would delete subvol: %s\n" "$snap"
            [[ -f "$infoFile" ]] && printf "  ${YELLOW}[DRY-RUN]${NC} Would delete info:   %s\n" "$infoFile"
        else
            printf "  ${RED}Deleting subvol:${NC} %s\n" "$snap"
            # -c commits the transaction so snapshots don't reappear after a crash [1][2]
            if btrfs subvolume delete -c "$snap"; then
                if [[ -f "$infoFile" ]]; then
                    printf "  ${RED}Deleting info:${NC}   %s\n" "$infoFile"
                    rm -f "$infoFile"
                fi
            else
                printf "  ${RED}Failed to delete subvol:${NC} %s (continuing)\n" "$snap" >&2
            fi
        fi
    done
    echo ""
done

printf "${GREEN}=== Done ===${NC}\n"

