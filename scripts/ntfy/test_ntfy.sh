#!/usr/bin/env bash
# shellcheck disable=SC2015
# Regression suite for ntfy.sh — run from the library directory.
# Pure dry-run / builder tests; no network sends.
cd "$(dirname "$0")" || exit 1
# shellcheck disable=SC1091
source ./ntfy.sh
export NTFY_URL=https://ntfy.example.com NTFY_DEFAULT_TOPIC=skullbox
u="https://ex.com/share"
fail=0
check() {
    if [[ "$2" == "$3" ]]; then echo "PASS: $1"
    else echo "FAIL: $1"; echo "  want: [$2]"; echo "  got:  [$3]"; fail=1; fi
}

# --- clear flag: all accepted forms, all builders ---
check "view clear=true"   "view, Open, $u, clear=true"  "$(ntfy_action_view Open "$u" clear=true)"
check "view clear=false"  "view, Open, $u, clear=false" "$(ntfy_action_view Open "$u" clear=false)"
check "view default"      "view, Open, $u, clear=true"  "$(ntfy_action_view Open "$u")"
check "view bare false"   "view, Open, $u, clear=false" "$(ntfy_action_view Open "$u" false)"
check "view clear=no"     "view, Open, $u, clear=false" "$(ntfy_action_view Open "$u" clear=no)"
check "view clear=1"      "view, Open, $u, clear=true"  "$(ntfy_action_view Open "$u" clear=1)"
ntfy_action_view Open "$u" banana 2>/dev/null && { echo "FAIL: invalid clear accepted"; fail=1; } \
    || echo "PASS: invalid clear exits 1"
check "copy clear=false"  "copy, C, $u, clear=false" "$(ntfy_action_copy C "$u" clear=false)"
check "copy default"      "copy, C, $u, clear=true"  "$(ntfy_action_copy C "$u")"
check "http clear=true"   "http, T, $u, clear=true"  "$(ntfy_action_http T "$u" clear=true)"
check "http keys+clear"   "http, T, $u, method=PUT, clear=false" "$(ntfy_action_http T "$u" method=PUT clear=false)"

# --- apostrophe escaping: backslash style inside single quotes (ntfy action.go) ---
label=$'O\'Brien, Inc'          # contains apostrophe + comma
q=$(ntfy_action_view "$label" "$u" clear=false)
expected="view, 'O\\'Brien, Inc', $u, clear=false"
check "apostrophe backslash-escaped" "$expected" "$q"
q2=$(ntfy_action_view "plain" "$u" clear=false)
check "clean value unquoted" "view, plain, $u, clear=false" "$q2"

# --- message body: --data-raw (no @file/-stdin interpretation, no data-binary) ---
ntfy_send --dry-run "leading dash -40 here" | grep -q -- "--data-raw" \
    && echo "PASS: uses --data-raw" || { echo "FAIL: no data-raw"; fail=1; }
ntfy_send --dry-run "leading dash -40 here" | grep -q -- "--data-binary" \
    && { echo "FAIL: still data-binary"; fail=1; } || echo "PASS: no data-binary for text"
ntfy_send --dry-run -- "@literal at start" | grep -q -- "--data-raw" \
    && echo "PASS: -- escapes literal @ message" || { echo "FAIL: -- escape hatch"; fail=1; }
ntfy_send --dry-run -- "-40 leading dash" | grep -q -- "--data-raw" \
    && echo "PASS: -- escapes literal - message" || { echo "FAIL: -- dash escape"; fail=1; }
ntfy_send --dry-run "@/nonexistent-xyz" 2>&1 | grep -q "cannot read" \
    && echo "PASS: @path without -- still reads file" || { echo "FAIL: @file handling broken"; fail=1; }
ntfy_send --dry-run $'multi\nline' | grep -q "multi" \
    && echo "PASS: multiline message preserved" || { echo "FAIL: multiline"; fail=1; }

# --- attach: local file upload vs remote URL (dry-run output is %q-escaped) ---
ntfy_send --dry-run --attach @/etc/hostname "see file" | grep -q 'Filename:.*hostname' \
    && echo "PASS: attach @file sets Filename" || { echo "FAIL: attach file"; fail=1; }
ntfy_send --dry-run --attach @/etc/hostname "see file" | grep -q -- "-X PUT" \
    && echo "PASS: attach @file uses PUT" || { echo "FAIL: attach not PUT"; fail=1; }
ntfy_send --dry-run --attach @/etc/hostname "see file" | grep -q 'Message:.*see.*file' \
    && echo "PASS: message rides in Message header" || { echo "FAIL: Message header"; fail=1; }
ntfy_send --dry-run --attach @/etc/hostname "see file" | grep -q -- '--data-binary .*/etc/hostname' \
    && echo "PASS: file is the request body" || { echo "FAIL: file not body"; fail=1; }
ntfy_send --dry-run --attach https://ex.com/a.jpg "msg" | grep -q 'Attach:.*https://ex.com/a.jpg' \
    && echo "PASS: attach URL header" || { echo "FAIL: attach url"; fail=1; }
ntfy_send --dry-run --attach @/etc/hostname $'multi\nline' 2>&1 | grep -q "single-line" \
    && echo "PASS: multiline message + attach rejected" || { echo "FAIL: multiline attach accepted"; fail=1; }
ntfy_send --dry-run --attach @/nonexistent-xyz "msg" 2>&1 | grep -q "cannot read" \
    && echo "PASS: unreadable attach rejected" || { echo "FAIL: bad attach accepted"; fail=1; }

# --- guards ---
ntfy_send -T 2>/dev/null; rc=$?
[[ $rc == 1 ]] && echo "PASS: missing option value -> 1" || { echo "FAIL: missing value rc=$rc"; fail=1; }
ntfy_send --firebase banana "x" 2>&1 | grep -q "yes or no" \
    && echo "PASS: firebase validated" || { echo "FAIL: firebase"; fail=1; }
ntfy_send --banana "x" 2>&1 | grep -q "unknown option" \
    && echo "PASS: unknown option rejected" || { echo "FAIL: unknown option"; fail=1; }

# --- help: awk-based, prints the whole header ---
ntfy_send --help | head -2 | grep -q "ntfy.sh" && echo "PASS: help prints header" || { echo "FAIL: help"; fail=1; }
ntfy_send --help | grep -q "Examples:" && echo "PASS: help includes examples" || { echo "FAIL: help examples"; fail=1; }
ntfy_send --help | grep -q "clear=false" && echo "PASS: help documents clear" || { echo "FAIL: help clear"; fail=1; }

# --- original upload-notification curl shape, end to end ---
ntfy_send --dry-run -T "Upload Complete" -p low -c "$u" --tags skull \
  -a "$(ntfy_action_view "Open link" "$u" clear=true)" \
  -a "$(ntfy_action_copy "Copy" "$u")" \
  "some message" | grep -q 'clear=true.*copy.*Copy.*clear=true' \
  && echo "PASS: original curl shape" || { echo "FAIL: original shape"; fail=1; }

# --- example script still runs (dry-run injected via env trick not possible; just syntax-check) ---
bash -n example_multi_action.sh && echo "PASS: example script syntax OK" || { echo "FAIL: example broken"; fail=1; }

echo
[[ $fail == 0 ]] && echo "=== ALL TESTS PASSED ===" || echo "=== FAILURES ABOVE ==="
exit $fail