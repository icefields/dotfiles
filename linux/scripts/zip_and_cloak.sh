#!/bin/bash

zipAndCloak() {
    local inputPath="$1"
    local outputPath="${2:-$(dirname "$inputPath")}"
    local password
    local parentDir baseName
    
    parentDir=$(dirname "$inputPath")
    baseName=$(basename "$inputPath")
    
    read -s -p "Enter password: " password
    echo
    
    cd "$parentDir" || { echo ""; return 1; }
    
    # -bso0: suppress standard output
    # -bsp0: suppress progress
    7z a -p"$password" -mhe=on -bso0 -bsp0 "${baseName}.7z" "$baseName" || { echo ""; return 1; }
    
    if [[ "$outputPath" != "$parentDir" ]]; then
        mv "${baseName}.7z" "$outputPath/"
    fi
    
    echo "${outputPath}/${baseName}.7z"
}

# Run if called directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ -z "$1" ]]; then
        echo "Usage: zip_and_cloak.sh <path> [outputDir]"
        exit 1
    fi
    zipAndCloak "$1" "${2:-}"
fi

