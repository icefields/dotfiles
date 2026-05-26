#!/bin/bash

# this script will randomize Mullvad location.
# The wireguard service is called wg-quick@mullvad.service, and must be created
# for the override that calls this script to work.
# -- SYSTEMD OVERRIDE --
# cd /etc/systemd/system
# mkdir "wg-quick@mullvad.service.d"
# vim "wg-quick@mullvad.service.d"/override.conf
# # add this:
# [Service]
# # Run this before the VPN tunnel starts (replace <user>)
# ExecStartPre=/home/<user>/scripts/systemd/wg_mullvad_randomizer.sh

# Directory where the config files are stored
CONFIG_DIR="/etc/wireguard"
PATTERN="ca" #"ca-tor-wg-"
TARGET="$CONFIG_DIR/mullvad.conf"

# Find matching files
files=("$CONFIG_DIR"/$PATTERN*)

# Check if any matching files exist
if [ ${#files[@]} -eq 0 ]; then
  echo "No files starting with '$PATTERN' found in $CONFIG_DIR."
  exit 1
fi

random_file="${files[RANDOM % ${#files[@]}]}"
/usr/bin/rm $TARGET
/usr/bin/cp "$random_file" "$TARGET"

# save name to file so it can be picked up by scripts
echo $random_file > /tmp/wg_mullvad_current.txt

echo "Wireguard now using: $random_file"

