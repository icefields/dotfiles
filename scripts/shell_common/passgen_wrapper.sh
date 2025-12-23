#!/usr/bin/env bash
set -euo pipefail

length="${1:-}"

if [[ -z "$length" ]]; then
  echo "Usage: passgen <length>" >&2
  exit 1
fi

# Run the password generator ONCE and store result
password="$($HOME/scripts/passgen.sh "$length")"

# Copy to clipboard
echo "$password" | xclip -selection clipboard

# Print it
echo "$password"

