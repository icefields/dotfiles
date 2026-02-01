#!/usr/bin/env bash
set -euo pipefail

# ---- CONFIG ----
: "${VPN_HOME_USER:?VPN_HOME_USER env var not set}"
: "${VPN_HOME_PASS:?VPN_HOME_PASS env var not set}"
: "${OVPN_HOME_CONFIG:?OVPN_HOME_CONFIG env var not set}"

# Prefer tmpfs (cleared on reboot)
if [[ -d /run && -w /run ]]; then
  CREDS_DIR="/run/openvpn"
else
  CREDS_DIR="/tmp/openvpn"
fi

CREDS_FILE="$CREDS_DIR/home_credentials"

# ---- SETUP ----
mkdir -p "$CREDS_DIR"
chmod 700 "$CREDS_DIR"

# Remove old creds file if it exists
if [[ -f "$CREDS_FILE" ]]; then
  rm -f "$CREDS_FILE"
fi

# Create creds file
umask 077
printf "%s\n%s\n" "$VPN_HOME_USER" "$VPN_HOME_PASS" > "$CREDS_FILE"

# Ensure cleanup on exit
cleanup() {
  rm -f "$CREDS_FILE"
}
trap cleanup EXIT INT TERM

# ---- CONNECT ----
exec sudo openvpn \
  --config "$OVPN_HOME_CONFIG" \
  --auth-user-pass "$CREDS_FILE"

