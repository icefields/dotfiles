#!/bin/bash
# ~/scripts/shell_common/extract-7z.sh
# Silently extracts archives via 7z CLI into a 0_EXTRACTED subdirectory

archivePath="$1"

if [ -z "$archivePath" ]; then
    notify-send -u critical "7z Extract" "No file provided"
    exit 1
fi

if [ ! -f "$archivePath" ]; then
    notify-send -u critical "7z Extract" "File not found: $archivePath"
    exit 1
fi

archiveDir="$(dirname "$archivePath")"
archiveName="$(basename "$archivePath")"
extractDir="${archiveDir}/0_EXTRACTED"

mkdir -p "$extractDir"

7z x "$archivePath" -o"$extractDir" -y > /dev/null 2>&1

exitCode=$?

if [ $exitCode -eq 0 ]; then
    notify-send "7z Extract" "✅ Extracted to 0_EXTRACTED: ${archiveName}"
else
    notify-send -u critical "7z Extract" "❌ Failed (exit ${exitCode}): ${archiveName}"
fi

