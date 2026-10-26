#!/usr/bin/env bash
#
# ntfy.sh — reusable ntfy notification library + standalone CLI
#
# Source it:      source ~/Code/Bash/ntfy/ntfy.sh
# Execute it:     ntfy-notify --title "Hi" -p low "message"   (symlinked)
#
# Environment:
#   NTFY_URL              base server URL, e.g. https://ntfy.example.com
#   NTFY_DEFAULT_TOPIC    topic used when --topic is not passed
#   NTFY_TOKEN            optional bearer token (Authorization: Bearer ...)
#
# Library functions:
#   ntfy_send [options] [message...]
#   ntfy_action_view  <label> <url> [clear=true|false]   -> action spec string
#   ntfy_action_http  <label> <url> [key=value...]      -> action spec string
#       keys: method=M body=B header.H=V clear=true     (method defaults to POST!)
#   ntfy_action_copy <label> <value> [clear=true|false]  -> action spec string
#
#   clear defaults to true for every action (dismiss notification on tap);
#   pass clear=false (or bare false) to keep the notification.
#
# Options:
#   -t, --topic TOPIC       topic (default $NTFY_DEFAULT_TOPIC; full URL also OK)
#       --url URL           server URL (default $NTFY_URL)
#   -T, --title TEXT        notification title
#   -p, --priority P        min|low|default|high|max|urgent|1-5
#       --tags LIST         comma-separated tags/emoji short codes
#   -c, --click URL        URL (or other URI scheme) opened on notification tap
#   -a, --action SPEC       repeatable, up to 3; use builders above or raw spec:
#                           "view, Open link, https://..., clear=true"
#       --markdown          render message body as markdown
#       --delay DURATION    ntfy delay, e.g. 30min, 9am, 2026-01-02T15:04:05
#       --attach URL|@file  attach remote image or local file (@path)
#       --icon URL          load notification icon from URL
#       --email ADDR        also forward to email address
#       --firebase yes|no  Firebase upstream (default: no)
#       --token TOKEN       auth token (default $NTFY_TOKEN)
#   -q, --quiet             suppress ntfy JSON response
#       --dry-run           print the curl command instead of sending
#   -h, --help              usage
#
# Message: positional args joined by spaces; '-' reads stdin; '@file' reads
# a file. With no args and piped stdin, stdin is read (CLI mode only).
#
# Examples:
#   # CLI, mirroring the original curl:
#   ntfy-notify -T "Upload Complete" -p low --click "$shareUrl" --tags skull \
#       -a "view, Open link, $shareUrl, clear=true" \
#       -a "copy, Copy, $shareUrl" \
#       "some message"
#
#   # Library, same thing with builders (auto-quotes values containing , or ;):
#   source ~/Code/Bash/ntfy/ntfy.sh
#   ntfy_send -T "Upload Complete" -p low --click "$shareUrl" --tags skull \
#       -a "$(ntfy_action_view  'Open link' "$shareUrl" clear=true)" \
#       -a "$(ntfy_action_copy  'Copy'      "$shareUrl")" \
#       "some message"
#
#   # http action (method defaults to POST per ntfy source):
#   ntfy_send -T "Doorbell" \
#       -a "$(ntfy_action_http 'Turn down' https://api.example.com/ac \
#            body='{"temp":65}' header.Authorization='Bearer x')" \
#       "Someone at the door"

_ntfy_quote() {
    # Quote an action value only when ntfy's header syntax requires it:
    # values containing , or ; must be wrapped in single quotes.
    local value="$1"
    case "$value" in
        *,*|*\;*) printf "'%s'" "${value//\'/\'\'}" ;;
        *)         printf '%s'  "$value" ;;
    esac
}

_ntfy_clear_flag() {
    # Every ntfy action accepts clear=<bool> (dismiss the notification when
    # the action runs). Accept the key=value and bare-value forms; default true.
    # Emits ', clear=true' or ', clear=false'; invalid values die loudly.
    local arg="${1:-clear=true}"
    case "$arg" in
        clear=true|true)     printf ', clear=true' ;;
        clear=false|false)   printf ', clear=false' ;;
        *) echo "ntfy: invalid clear value '$arg' (use clear=true|clear=false|true|false)" >&2; return 1 ;;
    esac
}

ntfy_action_view() {
    # <label> <url> [clear=true|false]   (default: clear=true)
    (( $# < 2 )) && { echo "ntfy_action_view: need label and url" >&2; return 1; }
    (( $# > 3 )) && { echo "ntfy_action_view: too many arguments" >&2; return 1; }
    local flag
    flag="$(_ntfy_clear_flag "${3:-}")" || return 1
    printf 'view, %s, %s%s' "$(_ntfy_quote "$1")" "$(_ntfy_quote "$2")" "$flag"
}

ntfy_action_http() {
    # <label> <url> [method=M] [body=B] [header.H=V...] [clear=true]
    (( $# < 2 )) && { echo "ntfy_action_http: need label and url" >&2; return 1; }
    local label="$1" url="$2"; shift 2
    local spec="http, $(_ntfy_quote "$label"), $(_ntfy_quote "$url")" kv key value
    for kv in "$@"; do
        case "$kv" in
            method=*)  spec+=", method=${kv#method=}" ;;
            body=*)    spec+=", body=$(_ntfy_quote "${kv#body=}")" ;;
            header.*=*) key="${kv%%=*}"; value="${kv#*=}"
                       spec+=", headers.${key#header.}=$(_ntfy_quote "$value")" ;;
            clear=*)   case "${kv#clear=}" in
                           true|false) spec+=", clear=${kv#clear=}" ;;
                           *) echo "ntfy: invalid clear value '${kv#clear=}'" >&2; return 1 ;;
                       esac ;;
            *) echo "ntfy_action_http: unknown key '$kv' (use method= body= header.H=V clear=)" >&2; return 1 ;;
        esac
    done
    printf '%s' "$spec"
}

ntfy_action_copy() {
    # <label> <value> [clear=true|false]   (default: clear=true)
    (( $# < 2 )) && { echo "ntfy_action_copy: need label and value" >&2; return 1; }
    (( $# > 3 )) && { echo "ntfy_action_copy: too many arguments" >&2; return 1; }
    local flag
    flag="$(_ntfy_clear_flag "${3:-}")" || return 1
    printf 'copy, %s, %s%s' "$(_ntfy_quote "$1")" "$(_ntfy_quote "$2")" "$flag"
}

ntfy_usage() {
    sed -n '2,60p' "${BASH_SOURCE[0]:-$0}" | sed 's/^# \{0,1\}//'
}

ntfy_send() {
    local topic="${NTFY_DEFAULT_TOPIC:-}" server="${NTFY_URL:-}" token="${NTFY_TOKEN:-}"
    local title="" priority="" tags="" click="" markdown=false
    local firebase="no" delay="" attach="" icon="" email=""
    local quiet=false dryRun=false
    local -a actions=() curlArgs=() messageParts=()

    while [[ $# -gt 0 ]]; do
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
            --)            shift; messageParts+=("$@"); break ;;
            -*)            echo "ntfy: unknown option '$1' (see --help)" >&2; return 1 ;;
            *)             messageParts+=("$1"); shift ;;
        esac
    done

    # Resolve target URL
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

    # Priority sanity check
    if [[ -n "$priority" ]]; then
        case "$priority" in
            min|low|default|high|max|urgent|[1-5]) ;;
            *) echo "ntfy: invalid priority '$priority'" >&2; return 1 ;;
        esac
    fi

    # Build headers
    [[ -n "$title"    ]] && curlArgs+=(-H "Title: $title")
    [[ -n "$priority" ]] && curlArgs+=(-H "Priority: $priority")
    [[ -n "$tags"     ]] && curlArgs+=(-H "Tags: $tags")
    [[ -n "$click"    ]] && curlArgs+=(-H "Click: $click")
    [[ -n "$delay"    ]] && curlArgs+=(-H "Delay: $delay")
    [[ -n "$attach"   ]] && curlArgs+=(-H "Attach: $attach")
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

    # Resolve message body: args, '-' (stdin), '@file', or piped stdin (CLI only)
    local message
    if (( ${#messageParts[@]} )); then
        case "${messageParts[0]}" in
            -)  message="$(cat)" ;;
            @*) local file="${messageParts[0]#@}"
                [[ -r "$file" ]] || { echo "ntfy: cannot read '$file'" >&2; return 1; }
                message="$(<"$file")" ;;
            *)  message="${messageParts[*]}" ;;
        esac
    elif [[ "${_NTFY_CLI:-}" == true && ! -t 0 ]]; then
        message="$(cat)"
    fi
    if [[ -z "$message" ]]; then
        echo "ntfy: no message (pass text, '-', '@file', or pipe stdin)" >&2; return 1
    fi

    curlArgs+=(-sS --max-time 15 --data-binary "$message" "$target")

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