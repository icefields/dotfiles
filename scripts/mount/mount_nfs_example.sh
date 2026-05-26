#!/usr/bin/env bash
#!/usr/bin/env bash
# mount_nfs.sh — Mount the MidoriNC NFS share
# Usage: ./mount_nfs.sh [mount|unmount]

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
source "$SCRIPT_DIR/mount_lib.sh"

NFS_SERVER="192.168.15.177:/path/to/share"
NFS_MOUNT="/mnt/mymount"
NFS_OPTS="nfsvers=4,_netdev,timeo=20,retrans=3"

case "${1:-mount}" in
    mount)   mount_nfs "$NFS_SERVER" "$NFS_MOUNT" "$NFS_OPTS" ;;
    unmount) unmount_nfs "$NFS_MOUNT" ;;
    *) echo "Usage: $0 [mount|unmount]"; exit 1 ;;
esac

