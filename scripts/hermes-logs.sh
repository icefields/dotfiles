#!/usr/bin/env bash
set -euo pipefail

question="${*:-}"
if [[ -z "$question" ]]; then
  question="Read every *.log file under /syslogs/ plus /logs/pacman.log. Summarize everything abnormal from the last 24 hours and the previous boot: failed units, kernel messages, service errors, and anything that correlates with recent package updates. Rank findings by likely impact."
fi

mkdir -p /mnt/lucie/hermes/syslogs
journalctl -p err --since=-24h --no-pager > /mnt/lucie/hermes/syslogs/errors-24h.log
journalctl -b -1 -p warning --no-pager > /mnt/lucie/hermes/syslogs/journal-prev-boot.log 2>/dev/null || true
cp /tmp/awesome.log /mnt/lucie/hermes/syslogs/awesome.log
cp /tmp/picom.log /mnt/lucie/hermes/syslogs/picom.log


if [[ ! -s /mnt/lucie/hermes/syslogs/errors-24h.log ]]; then
  echo "WARNING: errors-24h.log came back empty. If you joined systemd-journal without re-logging-in, journalctl is only seeing your user units." >&2
fi

podman exec hermes hermes chat -q "$question"

