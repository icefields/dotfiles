#!/usr/bin/env bash
# shlink-shorten — Shorten URLs via self-hosted Shlink REST API
# Usage: shlink-shorten <long_url> [options]

set -euo pipefail

# ─── Config ───────────────────────────────────────────────────
# Check environment first, then fall back to .env file
if [[ -z "${SHLINK_BASE_URL:-}" || -z "${SHLINK_API_KEY:-}" ]]; then
    SHLINK_ENV="${XDG_CONFIG_HOME:-$HOME/.config}/shlink-shorten/.env"
    if [[ -f "$SHLINK_ENV" ]]; then
        # shellcheck source=/dev/null
        source "$SHLINK_ENV"
    fi
fi

: "${SHLINK_BASE_URL:?SHLINK_BASE_URL is not set. Export it or add it to ${XDG_CONFIG_HOME:-$HOME/.config}/shlink-shorten/.env}"
: "${SHLINK_API_KEY:?SHLINK_API_KEY is not set. Export it or add it to ${XDG_CONFIG_HOME:-$HOME/.config}/shlink-shorten/.env}"

# ─── Defaults ─────────────────────────────────────────────────
customSlug=""
tags=""
domain=""
maxVisits=""
validSince=""
validUntil=""
findRedirect=""
outputQuiet=false

# ─── Help ─────────────────────────────────────────────────────
usage() {
    cat <<EOF
Usage: $(basename "$0") <long_url> [options]

Shorten a URL using a self-hosted Shlink instance.

Required:
  <long_url>              The URL to shorten

Options:
  -s, --slug SLUG         Custom slug for the short URL
  -t, --tags TAGS         Comma-separated tags
  -d, --domain DOMAIN     Domain to use (must be configured in Shlink)
  -m, --max-visits N      Maximum visits before redirect fails
  -v, --valid-since DATE  ISO-8601 datetime when the short URL becomes active
  -V, --valid-until DATE  ISO-8601 datetime when the short URL expires
  -f, --find-redirect     If the long URL already has a short URL, return it
  -q, --quiet             Only output the short URL (no extra text)
  -h, --help              Show this help message

Config:
  SHLINK_BASE_URL     Base URL of your Shlink instance (e.g. https://link.example.com)
  SHLINK_API_KEY      Your Shlink API key

  Checked in order:
    1. Environment variables (SHLINK_BASE_URL, SHLINK_API_KEY)
    2. ${XDG_CONFIG_HOME:-$HOME/.config}/shlink-shorten/.env

Examples:
  $(basename "$0") "https://example.com/very/long/url"
  $(basename "$0") "https://example.com/page" --slug "my-page" --tags "dev,blog"
  $(basename "$0") "https://example.com/page" -s "temp" -m 1000 -q | xclip -sel clip
EOF
    exit 0
}

# ─── Arg Parsing ───────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
    echo "Error: long URL is required." >&2
    echo "Run '$(basename "$0") --help' for usage." >&2
    exit 1
fi

longUrl="$1"
shift

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--slug)          customSlug="$2"; shift 2 ;;
        -t|--tags)          tags="$2"; shift 2 ;;
        -d|--domain)        domain="$2"; shift 2 ;;
        -m|--max-visits)    maxVisits="$2"; shift 2 ;;
        -v|--valid-since)   validSince="$2"; shift 2 ;;
        -V|--valid-until)   validUntil="$2"; shift 2 ;;
        -f|--find-redirect) findRedirect="true"; shift ;;
        -q|--quiet)         outputQuiet=true; shift ;;
        -h|--help)          usage ;;
        *)                  echo "Error: unknown option '$1'" >&2; exit 1 ;;
    esac
done

# ─── Build JSON Payload ───────────────────────────────────────
buildPayload() {
    local payload="{\"longUrl\":\"${longUrl}\""
    [[ -n "$customSlug" ]]    && payload="${payload},\"customSlug\":\"${customSlug}\""
    [[ -n "$domain" ]]        && payload="${payload},\"domain\":\"${domain}\""
    [[ -n "$maxVisits" ]]     && payload="${payload},\"maxVisits\":${maxVisits}"
    [[ -n "$validSince" ]]    && payload="${payload},\"validSince\":\"${validSince}\""
    [[ -n "$validUntil" ]]    && payload="${payload},\"validUntil\":\"${validUntil}\""
    [[ -n "$findRedirect" ]]  && payload="${payload},\"findRedirect\":true"
    if [[ -n "$tags" ]]; then
        local tagArray
        tagArray=$(echo "$tags" | awk -F',' '{for(i=1;i<=NF;i++) printf "\"%s\"%s", $i, (i<NF?",":""); print ""}')
        payload="${payload},\"tags\":[${tagArray}]"
    fi
    payload="${payload}}"
    echo "$payload"
}

# ─── API Call ──────────────────────────────────────────────────
payload=$(buildPayload)

response=$(curl -s -w "\n%{http_code}" -X POST \
    "${SHLINK_BASE_URL}/rest/v3/short-urls" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "X-Api-Key: ${SHLINK_API_KEY}" \
    -d "$payload")

# Separate body and status code
httpCode=$(echo "$response" | tail -1)
body=$(echo "$response" | sed '$d')

# ─── Handle Response ──────────────────────────────────────────
if [[ "$httpCode" -lt 200 || "$httpCode" -ge 300 ]]; then
    echo "Error: Shlink API returned HTTP $httpCode" >&2
    echo "$body" | jq -r '.detail // .title // .' 2>/dev/null || echo "$body" >&2
    exit 1
fi

shortUrl=$(echo "$body" | jq -r '.shortUrl // empty')

if [[ -z "$shortUrl" ]]; then
    echo "Error: could not extract shortUrl from response" >&2
    echo "$body" | jq . 2>/dev/null || echo "$body" >&2
    exit 1
fi

if [[ "$outputQuiet" == true ]]; then
    echo "$shortUrl"
else
    echo "✓ Shortened: $shortUrl"
fi

