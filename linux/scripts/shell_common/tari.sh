#!/usr/bin/env bash
set -euo pipefail

filename="${1:-}"

if [[ -z "$filename" ]]; then
  echo "Usage: tari <filename>" >&2
  exit 1
fi

output_filename="${filename//\//}.tar.gz"

tar -zcvf "$output_filename" "$filename"

