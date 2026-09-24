#!/usr/bin/env bash
# compress7z.sh: helper for Nemo actions, compress selection with 7-Zip
# usage: compress7z.sh <tar.gz|tar.xz|7z> <path> [path ...]
set -u

usage() { echo "usage: $0 <tar.gz|tar.xz|7z> <path...>" >&2; exit 2; }

fmt="${1:-}"
[ "$#" -gt 0 ] && shift
case "$fmt" in tar.gz|tar.xz|7z) ;; *) usage ;; esac
[ "$#" -gt 0 ] || usage

notify() {
    command -v notify-send >/dev/null 2>&1 && notify-send -u "$1" -a "Nemo 7-Zip" "$2" "$3"
}

szBin=""
for candidate in 7zz 7z 7za; do
    if command -v "$candidate" >/dev/null 2>&1; then
        szBin="$candidate"
        break
    fi
done
if [ -z "$szBin" ]; then
    notify critical "7-Zip not found" "Arch: sudo pacman -S 7zip"
    exit 1
fi

firstPath="$1"
targetDir="$(dirname -- "$firstPath")"

if [ "$#" -eq 1 ]; then
    baseName="$(basename -- "$firstPath")"
    # strip the extension of plain files, keep hidden files and dirs intact
    if [ -f "$firstPath" ] && [[ "$baseName" == *.* && "$baseName" != .* ]]; then
        baseName="${baseName%.*}"
    fi
else
    baseName="$(basename -- "$targetDir")"
fi

# never overwrite anything: name.tar.gz, name (1).tar.gz, ...
outPath="$targetDir/$baseName.$fmt"
count=1
while [ -e "$outPath" ]; do
    outPath="$targetDir/$baseName ($count).$fmt"
    count=$((count + 1))
done

# 7-Zip stores entry paths exactly as typed, so run it from the parent dir
relPaths=()
for p in "$@"; do
    relPaths+=("${p#"$targetDir"/}")
done

runInTarget() { ( cd "$targetDir" && "$szBin" "$@" ); }

# scratch dir on the same filesystem (/tmp is tmpfs on Arch, big payloads would eat RAM)
tmpDir="$targetDir/.compress7z.$$"
if ! mkdir "$tmpDir" 2>/dev/null; then
    tmpDir="$(mktemp -d "${TMPDIR:-/tmp}/compress7z.XXXXXX")"
fi
logFile="$(mktemp "${TMPDIR:-/tmp}/compress7z.log.XXXXXX")"
trap 'rm -rf "$tmpDir" "$logFile"' EXIT

fail() {
    rm -f -- "$outPath"   # never leave a half-written archive behind
    errMsg="$(tail -n 5 "$logFile" | tr '\n' ' ' | cut -c1-250)"
    notify critical "7-Zip compression failed" "$errMsg"
    exit 1
}

case "$fmt" in
    7z)
        runInTarget a -t7z -mx=9 "$outPath" -- "${relPaths[@]}" >"$logFile" 2>&1 || fail
        ;;
    tar.gz)
        runInTarget a -ttar "$tmpDir/$baseName.tar" -- "${relPaths[@]}" >"$logFile" 2>&1 || fail
        ( cd "$tmpDir" && "$szBin" a -tgzip "$outPath" -- "$baseName.tar" ) >>"$logFile" 2>&1 || fail
        ;;
    tar.xz)
        runInTarget a -ttar "$tmpDir/$baseName.tar" -- "${relPaths[@]}" >"$logFile" 2>&1 || fail
        ( cd "$tmpDir" && "$szBin" a -txz "$outPath" -- "$baseName.tar" ) >>"$logFile" 2>&1 || fail
        ;;
esac

notify normal "Compressed with $szBin" "Created $(basename -- "$outPath")"
exit 0

