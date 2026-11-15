#!/usr/bin/env bash
set -euo pipefail

question="${*:-}"
if [[ -z "$question" ]]; then
  question="hi Hermes, please execute this task without any introduction or anything unrelated to the task completion. Here's the task: Read every log file under /syslogs/ plus /logs/pacman.log, /syslogs/awesome.log and /syslogs/picom.log. Summarize everything abnormal from the last 24 hours and the previous boot: failed units, kernel messages, service errors, and anything that correlates with recent package updates. Rank findings by likely impact. Write a report in a file: /opt/data/workspace/reports/logs-<current-date-and-timesmap>.md . Please perform that task without asking follow up questions. Do not look into other folders, do not try to fetch system data, do not introduce yourself to me, just read the log files and generate the report at the location specified. IMPORTANT: there is no reason to check /opt/hermes , and there is no reason to check project yml files or git repository, all I want is you to scan the specified logs and write the report, no reason to even check anything outside of the log directories I specified, that's it"
fi

mkdir -p /mnt/lucie/hermes/syslogs
journalctl -p err --since=-24h --no-pager > /mnt/lucie/hermes/syslogs/errors-24h.log
journalctl -b -1 -p warning --no-pager > /mnt/lucie/hermes/syslogs/journal-prev-boot.log 2>/dev/null || true
cp /tmp/awesome.log /mnt/lucie/hermes/syslogs/awesome.log
cp /tmp/picom.log /mnt/lucie/hermes/syslogs/picom.log


if [[ ! -s /mnt/lucie/hermes/syslogs/errors-24h.log ]]; then
  echo "WARNING: errors-24h.log came back empty. If you joined systemd-journal without re-logging-in, journalctl is only seeing your user units." >&2
fi

# This one always missed the answer on first try. Once chat opens, ask again.
# podman exec hermes hermes chat -q "$question"
#
# One-shot mode (recommended for scripts/ cron jobs). Runs without outpyt 
# except for the final summary. $question not used.
podman exec hermes hermes -z "Run the log-analysis skill" -s log-analysis

# Interactive chat mode. $question not used.
# podman exec hermes hermes chat -s log-analysis
