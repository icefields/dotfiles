#!/bin/bash
# Send snapshots to external drive
# Usage: btrfs-backup-external

set -euo pipefail

BACKUP_DRIVE="/mnt/backup"
DATE=$(date +%Y%m%d-%H%M%S)

[ ! -d "$BACKUP_DRIVE" ] && { echo "Backup drive not mounted"; exit 1; }

SNAPDIR="/.snapshots"

# Create fresh backup snapshots (ALL under /.snapshots)
btrfs subvolume snapshot -r / "${SNAPDIR}/root-backup-$DATE"
btrfs subvolume snapshot -r /home "${SNAPDIR}/home-backup-$DATE"

# Send to external
mkdir -p "$BACKUP_DRIVE/root"
mkdir -p "$BACKUP_DRIVE/home"

btrfs send "${SNAPDIR}/root-backup-$DATE" | btrfs receive "$BACKUP_DRIVE/root/"
btrfs send "${SNAPDIR}/home-backup-$DATE" | btrfs receive "$BACKUP_DRIVE/home/"

# Cleanup local backup snapshots
btrfs subvolume delete "${SNAPDIR}/root-backup-$DATE"
btrfs subvolume delete "${SNAPDIR}/home-backup-$DATE"

# Cleanup old backups (keep 7)
ls -1t "$BACKUP_DRIVE/root" | tail -n +8 | while read -r snap; do
    btrfs subvolume delete "$BACKUP_DRIVE/root/$snap" 2>/dev/null || true
done

ls -1t "$BACKUP_DRIVE/home" | tail -n +8 | while read -r snap; do
    btrfs subvolume delete "$BACKUP_DRIVE/home/$snap" 2>/dev/null || true
done

echo "Backup complete."

