#!/usr/bin/env bash
#
# ntfy.sh — reusable ntfy push-notification library + standalone CLI
# Requires bash (arrays + locals). NOT POSIX sh. curl >= 7.76 required
# (--fail-with-body).
#
# Two call modes:
#   Library:   source ~/Code/Bash/ntfy/ntfy.sh        (or source from any
#              script: source "${BASH_SOURCE[0]%/*}/ntfy.sh")
#   CLI:       ntfy-notify [options] [message]         (symlinked into
#              ~/.local/bin; topic/server come from env or flags)
#
# Environment (none of these are persisted in any rc yet — set them in the
# calling shell, or put them in ~/.config/environment.d/ntfy.conf to reach
# systemd/cron contexts too):
#   NTFY_URL              server base URL, e.g. https://ntfy.example.com
#   NTFY_DEFAULT_TOPIC    topic used when --topic is omitted
#   NTFY_TOKEN            optional bearer token -> "Authorization: Bearer ..."
#
# Library functions:
#   ntfy_send [options] [message...]          do the send (see options below)
#   ntfy_action_view  <label> <url>   [clear] -> action spec string
#   ntfy_action_http  <label> <url>   [k=v...] -> action spec string
#       keys: method=M  body=B  header.H=V  clear=C   (method defaults to POST!)
#   ntfy_action_copy <label> <value> [clear]  -> action spec string
#
#   clear (every action type accepts it) — dismiss the notification after
#   the button runs. Accepts true/yes/1 (dismiss) or false/no/0 (keep),
#   as key=value or bare; DEFAULTS TO TRUE. Pass clear=false to keep the
#   notification. Invalid values exit 1 instead of silently dropping.
#
# Options:
#   -t, --topic TOPIC       topic (default $NTFY_DEFAULT_TOPIC); a value
#                           containing "://" is used as the full target URL
#       --url URL           server base (default $NTFY_URL)
#   -T, --title TEXT        notification title
#   -p, --priority P        min|low|default|high|max|urgent or 1-5
#       --tags LIST         comma-separated tags / emoji short codes
#   -c, --click URL         URL (or other URI scheme) opened on tap
#   -a, --action SPEC       action spec, repeatable, max 3; raw form:
#                           "view, Open link, https://x, clear=true"
#                           or build with the ntfy_action_* helpers
#       --markdown          render the message body as markdown
#       --delay DURATION    delayed delivery, e.g. 30min, 9am, 2026-12-01
#       --attach URL|@file  URL: remote attachment (Attach header).
#                           @file: upload the local file as the request
#                           body (PUT + Filename header); the message
#                           then travels in the "Message" header and must
#                           be a single line. Max size is server-side
#                           (15 MB by default, 2 MB on ntfy.sh).
#       --icon URL          notification icon URL
#       --email ADDR        also forward to this email address
#       --firebase yes|no   Firebase upstream (default: no)
#       --token TOKEN       auth token (default $NTFY_TOKEN)
#   -q, --quiet             suppress the ntfy JSON response
#       --dry-run           print the exact curl command; send nothing
#   -h, --help              print this header
#
# Message sources (first match wins):
#   - positional args, joined with spaces
#   - first positional "-"     -> stdin
#   - first positional "@path"  -> file contents
#   - CLI mode only: piped stdin when no positional message given
#   - "--" ends options; the rest is the LITERAL message (escape hatch
#     for texts that start with "-" or "@")
#
# Action-spec wire format (matches ntfy's parser, action/action.go):
#   - actions separated by ";", fields by ",", max 3 actions
#   - values containing "," or ";" must be wrapped in 'single quotes';
#     inside quotes an apostrophe is escaped backslash-style: \' (NOT SQL
#     doubling). The builders handle this automatically; raw -a specs must
#     quote manually.
#   - http: method defaults to POST; "header.H=V" maps to wire "headers.H"
#
# Exit codes:
#   0   delivered (ntfy JSON on stdout; -q silences it)
#   1   usage/validation error (bad topic, priority, clear, too many
#       actions, unreadable file, missing env/option value, no message)
#   22  HTTP error from the server (--fail-with-body prints ntfy's error
#       JSON, so you still see WHY it failed)
#   28  curl timeout (15 s; 120 s for @file uploads)
#
# Examples:
#   # 1) CLI — mirror of the original upload-notification curl:
#   ntfy-notify -T "Upload Complete" -p low --click "$shareUrl" --tags skull \
#       -a "view, Open link, $shareUrl, clear=true" \
#       -a "copy, Copy, $shareUrl" \
#       "some message"
#
#   # 2) Library from another script — builders auto-quote, per-action clear:
#   source ~/Code/Bash/ntfy/ntfy.sh
#   ntfy_send -T "Upload Complete" -p low --click "$shareUrl" --tags skull,upload \
#       -a "$(ntfy_action_view 'Open link' "$shareUrl" clear=true)" \
#       -a "$(ntfy_action_copy 'Copy link' "$shareUrl" clear=false)" \
#       -a "$(ntfy_action_http 'Log it' https://api.example.com/log \
#              method=PUT body="{\"file\":\"$fileName\"}" clear=false)" \
#       "$fileName uploaded, share link ready."
#   # (see example_multi_action.sh in this directory for a runnable script)
#
#   # 3) http action with an auth header (method defaults to POST):
#   ntfy_send -T "Trigger" \
#       -a "$(ntfy_action_http 'Fire' https://api.example.com/hook \
#              header.Authorization='Bearer tok' body='{"k":1}')" \
#       "firing"
#
#   # 4) stdin / pipes:
#   echo "disk 95%" | ntfy-notify -p high -t alerts
#   grep ERROR /var/log/app.log | ntfy-notify -T "Log errors" -
#
#   # 5) attachments:
#   ntfy-notify --attach @~/pic.jpg -T "Screenshot" "check this"   # upload
#   ntfy-notify --attach https://example.com/pic.jpg "look at it"  # remote URL
#
#   # 6) preview without sending:
#   ntfy-notify --dry-run -T test "hello"

# Library-safety guard: this file uses arrays, `local`, and [[ ]] — bash only.
# When sourced by a non-bash shell (dash/POSIX sh), fail with a clear message
# BEFORE the parser hits the array syntax below. Kept POSIX-compatible.
if [ -z "${BASH_VERSION:-}" ]; then
    echo "ntfy.sh: bash is required (arrays/local); source this from bash, not sh/dash" >&2
    # shellcheck disable=SC2317
    return 1 2>/dev/null || exit 1
fi

_ntfy_quote() {
    # Wrap a value in 'single quotes' when ntfy's header syntax requires it
    # (it contains , or ;). Inside quotes an apostrophe is escaped with a
    # backslash (\' — backslash unescaping is what ntfy's parser implements;
    # SQL-style '' doubling would be parsed as end-quote + new-quote).
    # Raw backslashes elsewhere are safe: the parser only unescapes \+quote.
    # NOTE: the pattern/replacement below use a variable for the apostrophe —
    # a literal \' inside ${var//...} is a bash parse-time quote imbalance.
    local value="$1" apostrophe="'"
    case "$value" in
        *,*|*\;*)
            value="${value//$apostrophe/\\$apostrophe}"
            printf "'%s'" "$value"
            ;;
        *) printf '%s' "$value" ;;
    esac
}

_ntfy_clear_flag() {
    # Every ntfy action accepts clear=<bool>: dismiss the notification when
    # the action runs. Server accepts true/yes/1/false/no/0 (populateAction).
    # Accept key=value or bare form; default true. Emits ', clear=<v>'.
    local arg="${1:-clear=true}"
    arg="${arg#clear=}"
    case "$arg" in
        true|yes|1)  printf ', clear=true' ;;
        false|no|0)  printf ', clear=false' ;;
        *) echo "ntfy: invalid clear value '$arg' (use true|yes|1|false|no|0)" >&2; return 1 ;;
    esac
}

ntfy_action_view() {
    # <label> <url> [clear]   (clear defaults to true)
    (( $# < 2 )) && { echo "ntfy_action_view: need label and url" >&2; return 1; }
    (( $# > 3 )) && { echo "ntfy_action_view: too many arguments" >&2; return 1; }
    local flag
    flag="$(_ntfy_clear_flag "${3:-}")" || return 1
    printf 'view, %s, %s%s' "$(_ntfy_quote "$1")" "$(_ntfy_quote "$2")" "$flag"
}

ntfy_action_http() {
    # <label> <url> [method=M] [body=B] [header.H=V...] [clear=C]
    # method defaults to POST on the wire (ntfy source: "default is POST (!)")
    (( $# < 2 )) && { echo "ntfy_action_http: need label and url" >&2; return 1; }
    local label="$1" url="$2" spec kv key value
    shift 2
    spec="http, $(_ntfy_quote "$label"), $(_ntfy_quote "$url")"
    for kv in "$@"; do
        case "$kv" in
            method=*)  spec+=", method=${kv#method=}" ;;
            body=*)    spec+=", body=$(_ntfy_quote "${kv#body=}")" ;;
            header.*=*) key="${kv%%=*}"; value="${kv#*=}"
                       spec+=", headers.${key#header.}=$(_ntfy_quote "$value")" ;;
            clear=*)   flag="$(_ntfy_clear_flag "$kv")" || return 1
                       spec+="$flag" ;;
            *) echo "ntfy_action_http: unknown key '$kv' (use method= body= header.H=V clear=)" >&2; return 1 ;;
        esac
    done
    printf '%s' "$spec"
}

ntfy_action_copy() {
    # <label> <value> [clear]   (clear defaults to true)
    (( $# < 2 )) && { echo "ntfy_action_copy: need label and value" >&2; return 1; }
    (( $# > 3 )) && { echo "ntfy_action_copy: too many arguments" >&2; return 1; }
    local flag
    flag="$(_ntfy_clear_flag "${3:-}")" || return 1
    printf 'copy, %s, %s%s' "$(_ntfy_quote "$1")" "$(_ntfy_quote "$2")" "$flag"
}

ntfy_usage() {
    # Print the full leading comment block (up to the first code line).
    awk 'NR==1{next} /^#/{sub(/^#( |$)/,""); print; next} {exit}' \
        "${BASH_SOURCE[0]:-$0}"
}

ntfy_send() {
    local topic="${NTFY_DEFAULT_TOPIC:-}" server="${NTFY_URL:-}" token="${NTFY_TOKEN:-}"
    local title="" priority="" tags="" click="" markdown=false
    local firebase="no" delay="" attach="" icon="" email=""
    local quiet=false dryRun=false literalMessage=false
    local -a actions=() curlArgs=() messageParts=()

    while [[ $# -gt 0 ]]; do
        # Reject "option at end without value" before touching $2 (set -u safe)
        case "$1" in
            -t|--topic|--url|-T|--title|-p|--priority|--tags|-c|--click|\
            -a|--action|--delay|--attach|--icon|--email|--firebase|--token)
                [[ $# -ge 2 ]] || { echo "ntfy: option '$1' needs a value" >&2; return 1; } ;;
        esac
        case "$1" in
            -t|--topic)    topic="$2"; shift 2 ;;
            --url)         server="$2"; shift 2 ;;
            -T|--title)    title="$2"; shift 2 ;;
            -p|--priority) priority="$2"; shift 2 ;;
            --tags)        tags="$2"; shift 2 ;;
            -c|--click)    click="$2"; shift 2 ;;
            -a|--action)   actions+=("$2"); shift 2 ;;
            --markdown)    markdown=true; shift ;;
            --delay)       delay="$2"; shift 2 ;;
            --attach)      attach="$2"; shift 2 ;;
            --icon)        icon="$2"; shift 2 ;;
            --email)       email="$2"; shift 2 ;;
            --firebase)    firebase="$2"; shift 2 ;;
            --token)       token="$2"; shift 2 ;;
            -q|--quiet)    quiet=true; shift ;;
            --dry-run)     dryRun=true; shift ;;
            -h|--help)     ntfy_usage; return 0 ;;
            --)            shift; messageParts+=("$@"); literalMessage=true; break ;;
            -*)            echo "ntfy: unknown option '$1' (see --help)" >&2; return 1 ;;
            *)             messageParts+=("$1"); shift ;;
        esac
    done

    # --- resolve target ----------------------------------------------------
    if [[ -z "$server" ]]; then
        echo "ntfy: no server URL (set NTFY_URL or pass --url)" >&2; return 1
    fi
    if [[ -z "$topic" ]]; then
        echo "ntfy: no topic (set NTFY_DEFAULT_TOPIC or pass --topic)" >&2; return 1
    fi
    local target
    if [[ "$topic" == *"://"* ]]; then
        target="$topic"                                  # full URL passthrough
    else
        if [[ ! "$topic" =~ ^[-_A-Za-z0-9]{1,64}$ ]]; then
            echo "ntfy: invalid topic '$topic' (allowed: letters, numbers, -, _; max 64)" >&2; return 1
        fi
        target="${server%/}/$topic"
    fi

    # --- validate simple fields --------------------------------------------
    if [[ -n "$priority" ]]; then
        case "$priority" in
            min|low|default|high|max|urgent|[1-5]) ;;
            *) echo "ntfy: invalid priority '$priority' (min|low|default|high|max|urgent|1-5)" >&2; return 1 ;;
        esac
    fi
    case "$firebase" in
        yes|no) ;;
        *) echo "ntfy: --firebase must be yes or no" >&2; return 1 ;;
    esac

    # --- build headers ------------------------------------------------------
    [[ -n "$title"    ]] && curlArgs+=(-H "Title: $title")
    [[ -n "$priority" ]] && curlArgs+=(-H "Priority: $priority")
    [[ -n "$tags"     ]] && curlArgs+=(-H "Tags: $tags")
    [[ -n "$click"    ]] && curlArgs+=(-H "Click: $click")
    [[ -n "$delay"    ]] && curlArgs+=(-H "Delay: $delay")
    [[ -n "$icon"     ]] && curlArgs+=(-H "Icon: $icon")
    [[ -n "$email"    ]] && curlArgs+=(-H "Email: $email")
    $markdown            && curlArgs+=(-H "Markdown: yes")
    curlArgs+=(-H "Firebase: $firebase")
    if [[ -n "$token" ]]; then
        curlArgs+=(-H "Authorization: Bearer $token")
    fi
    if (( ${#actions[@]} )); then
        (( ${#actions[@]} > 3 )) && { echo "ntfy: max 3 actions, got ${#actions[@]}" >&2; return 1; }
        local actionsHeader="${actions[0]}" i
        for ((i=1; i<${#actions[@]}; i++)); do actionsHeader+="; ${actions[$i]}"; done
        curlArgs+=(-H "Actions: $actionsHeader")
    fi

    # --- attach: remote URL vs local file upload ---------------------------
    local attachFile="" attachName=""
    if [[ "$attach" == @* ]]; then
        attachFile="${attach#@}"
        [[ -r "$attachFile" ]] || { echo "ntfy: cannot read attach file '$attachFile'" >&2; return 1; }
        attachName="$(basename "$attachFile")"
    elif [[ -n "$attach" ]]; then
        curlArgs+=(-H "Attach: $attach")
    fi

    # --- resolve message body ------------------------------------------------
    local message
    if (( ${#messageParts[@]} )); then
        if $literalMessage; then
            # after "--": take the rest literally (no '-'/'@file' handling)
            message="${messageParts[*]}"
        else
            case "${messageParts[0]}" in
                -)  message="$(cat)" ;;
                @*) local file="${messageParts[0]#@}"
                    [[ -r "$file" ]] || { echo "ntfy: cannot read '$file'" >&2; return 1; }
                    message="$(<"$file")" ;;
                *)  message="${messageParts[*]}" ;;
            esac
        fi
    elif [[ "${_NTFY_CLI:-}" == true && ! -t 0 ]]; then
        message="$(cat)"
    fi
    if [[ -z "$message" ]]; then
        echo "ntfy: no message (pass text, '-', '@file', or pipe stdin)" >&2; return 1
    fi

    # --- request -------------------------------------------------------------
    if [[ -n "$attachFile" ]]; then
        # Local file: file IS the body (PUT + Filename), message rides in the
        # Message header — HTTP headers cannot contain raw newlines.
        [[ "$message" != *$'\n'* ]] || {
            echo "ntfy: message must be single-line with --attach @file (it travels in the Message header)" >&2; return 1; }
        curlArgs+=(-X PUT -H "Filename: $attachName" -H "Message: $message")
        curlArgs+=(-sS --fail-with-body --max-time 120 --data-binary "@$attachFile" "$target")
    else
        # --data-raw sends the message verbatim: no @file or -stdin special
        # meaning (unlike --data-binary/@), newlines preserved.
        curlArgs+=(-sS --fail-with-body --max-time 15 --data-raw "$message" "$target")
    fi

    if $dryRun; then
        printf 'curl'; printf ' %q' "${curlArgs[@]}"; printf '\n'
        return 0
    fi
    if $quiet; then
        curlArgs+=(-o /dev/null)
    fi
    curl "${curlArgs[@]}"
}

# --- CLI entry ---------------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    set -euo pipefail
    _NTFY_CLI=true
    ntfy_send "$@"
fi