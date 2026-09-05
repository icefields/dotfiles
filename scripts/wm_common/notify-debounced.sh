#!/usr/bin/env bash

# Use /run/user/$UID for PID files instead of /tmp
PID_DIR="/run/user/$(id -u)"
if [[ ! -d "$PID_DIR" ]]; then
    # Fallback to ~/.local/run if /run/user is not available
    PID_DIR="$HOME/.local/run"
    mkdir -p "$PID_DIR"
fi
DEBOUNCE_PID_FILE="$PID_DIR/debounce_notify.pid"

# Usage: debounce_notify <delay_seconds> "<command_string>"
# WARNING: Uses eval. Ensure <command_string> is strictly controlled, 
# as eval with untrusted input leads to command injection.
debounce_notify() {
    local delay="$1"
    local cmdString="$2"

    # Kill any pending notification process
    if [[ -f "$DEBOUNCE_PID_FILE" ]]; then
        local prevPid
        prevPid=$(cat "$DEBOUNCE_PID_FILE" 2>/dev/null)
        if [[ -n "$prevPid" ]] && kill -0 "$prevPid" 2>/dev/null; then
            kill "$prevPid" 2>/dev/null
            # No wait needed. The previous script has already exited, 
            # so the subshell was reparented to init, which reaps it.
        fi
    fi

    # Fork a background subshell that waits, evals the command, and cleans up
    (
        sleep "$delay"
        eval "$cmdString"
        rm -f "$DEBOUNCE_PID_FILE"  # Clean up PID file after execution
    ) &

    local subPid=$!
    
    # Detach the background job so it doesn't receive SIGHUP 
    # when the parent script exits.
    disown "$subPid" 2>/dev/null

    # Store the PID of the subshell
    echo "$subPid" > "$DEBOUNCE_PID_FILE"
}

