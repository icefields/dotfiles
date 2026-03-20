#!/usr/bin/env bash
set -euo pipefail

filename="${1:-}"

if [[ -z "$filename" ]]; then
  echo "Usage: backup <filename>" >&2
  exit 1
fi

backup_name="${filename}.$(date +'%Y%m%d').bck"

cp "$filename" "$backup_name"
echo "Backup created: $backup_name"

