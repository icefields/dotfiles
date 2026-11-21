#!/usr/bin/env bash
# Example: calling the ntfy library from another script, with multiple
# actions and explicit clear flags.
#
# Uses NTFY_URL + NTFY_DEFAULT_TOPIC from the environment, or pass
# --url / --topic to override per call.

# shellcheck disable=SC1091
source "${BASH_SOURCE[0]%/*}/ntfy.sh"

shareUrl="$1"
fileName="${2:-backup.tar}"

ntfy_send \
    --title "Upload Complete" \
    --priority low \
    --click "$shareUrl" \
    --tags skull,upload \
    -a "$(ntfy_action_view 'Open link' "$shareUrl" clear=true)" \
    -a "$(ntfy_action_copy 'Copy link' "$shareUrl" clear=false)" \
    -a "$(ntfy_action_http 'Log it' "https://api.example.com/uploads/log" \
            "method=PUT" "body={\"file\":\"$fileName\"}" clear=false)" \
    "$fileName uploaded to Nextcloud, share link ready."

# clear semantics (every action type accepts it):
#   clear=true  -> tapping the button dismisses the notification (default)
#   clear=false -> notification stays after the button runs
# Above: Open link clears it; Copy and Log it keep it around.