#!/usr/bin/env bash
#
# mullvad-status.sh — query Mullvad's connection check API
# deps: curl, jq

set -euo pipefail

readonly API_URL="https://am.i.mullvad.net/json"
readonly TIMEOUT=10

requireDeps() {
    local dep
    for dep in curl jq; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            printf 'error: required dependency %s not found in PATH\n' "$dep" >&2
            exit 1
        fi
    done
}

fetchStatus() {
    # --proto '=https' blocks redirect-based protocol downgrades
    curl -fsSL --proto '=https' --max-time "$TIMEOUT" "$API_URL"
}

printStatus() {
    jq -r '
        def yesNo:
            if . == true then "Yes"
            elif . == false then "No"
            else "Unknown" end;

        "IP: \(.ip // "N/A")",
        "Country: \(.country // "N/A")",
        "City: \(.city // "N/A")",
        "Longitude: \(.longitude // "N/A")",
        "Latitude: \(.latitude // "N/A")",
        "Mullvad Exit IP: \(.mullvad_exit_ip | yesNo)",
        "Mullvad Exit IP Hostname: \(.mullvad_exit_ip_hostname // "N/A")",
        "Mullvad Server Type: \(.mullvad_server_type // "N/A")",
        "Organization: \(.organization // "N/A")",
        "Blacklisted: \(.blacklisted.blacklisted | yesNo)",
        (if .blacklisted.blacklisted == true
            and (.blacklisted.results | type) == "array"
            and (.blacklisted.results | length) > 0
         then
            "Blacklisted On:",
            (.blacklisted.results[]
             | "  - \(if type == "object"
                     then "\(.name // "?") (\(.link // "no link"))"
                     else tostring end)")
         else empty end)
    '
}

main() {
    requireDeps

    local response
    if ! response="$(fetchStatus)"; then
        printf 'error: failed to reach Mullvad API (%s)\n' "$API_URL" >&2
        exit 1
    fi
    if [[ -z "$response" ]]; then
        echo "error: empty response from API" >&2
        exit 1
    fi

    printStatus <<< "$response"
}

main "$@"

