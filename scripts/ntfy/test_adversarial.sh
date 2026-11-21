#!/usr/bin/env bash
# shellcheck disable=SC2015
# Adversarial edge-case suite for ntfy.sh (beyond test_ntfy.sh).
# Pure dry-run / builder tests; no network sends.
cd "$(dirname "$0")" || exit 1
# shellcheck disable=SC1091
source ./ntfy.sh
export NTFY_URL=https://ntfy.example.com NTFY_DEFAULT_TOPIC=skullbox
u="https://ex.com/share"
fail=0

# A1: bare "--" with no message -> clean error, not crash
ntfy_send -- 2>&1 | grep -q "no message" && echo "PASS: bare -- -> no message" \
    || { echo "FAIL: bare --"; fail=1; }

# A2: --dry-run and -q together -> still prints curl
out=$(ntfy_send --dry-run -q "x"); [[ "$out" == curl* ]] \
    && echo "PASS: dry-run beats quiet" || { echo "FAIL: dry-run+quiet -> [$out]"; fail=1; }

# A3: full-URL topic ignores --url
ntfy_send --dry-run --url https://ignored.com -t https://ntfy.sh/abc "x" | grep -q "https://ntfy.sh/abc" \
    && echo "PASS: URL topic passthrough" || { echo "FAIL: passthrough"; fail=1; }

# A4: -- with message starting with dash + extra args joined
ntfy_send --dry-run -- "-40" "degrees" | grep -q -- "--data-raw" \
    && echo "PASS: -- joins literal args" || { echo "FAIL: -- join"; fail=1; }

# A5: token with special characters survives quoting
ntfy_send --dry-run --token 'tk_abc123/xyz+9==' "x" | grep -q "Authorization" \
    && echo "PASS: token header present" || { echo "FAIL: token"; fail=1; }

# A6: value with semicolon gets single-quoted (builder)
v=$(ntfy_action_copy "C" "a;b" clear=false)
expected="copy, C, 'a;b', clear=false"
[[ "$v" == "$expected" ]] && echo "PASS: semicolon value quoted" \
    || { echo "FAIL: semicolon quote -> [$v]"; fail=1; }

# A7: http body containing BOTH comma and semicolon
v=$(ntfy_action_http "T" "https://x.y" "body=a,b;c" clear=false)
expected="http, T, https://x.y, body='a,b;c', clear=false"
[[ "$v" == "$expected" ]] && echo "PASS: complex body quoted" \
    || { echo "FAIL: complex body -> [$v]"; fail=1; }

# A8: label containing apostrophe AND comma (the full escaping path)
label="O'Brien, Inc"
v=$(ntfy_action_view "$label" "$u" clear=false)
expected="view, 'O\'Brien, Inc', $u, clear=false"
[[ "$v" == "$expected" ]] && echo "PASS: apostrophe+comma escaped" \
    || { echo "FAIL: apostrophe -> [$v]"; fail=1; }

# A9: CLI entry via bash and via symlink
bash ntfy.sh --help | grep -q "Examples:" && echo "PASS: CLI --help via bash" \
    || { echo "FAIL: CLI help"; fail=1; }
~/.local/bin/ntfy-notify --help | grep -q "ntfy.sh" && echo "PASS: symlink --help" \
    || { echo "FAIL: symlink help"; fail=1; }

# A10: CLI with no message and empty stdin -> clean error, not hang
NTFY_URL=https://x NTFY_DEFAULT_TOPIC=t bash ntfy.sh < /dev/null 2>&1 | grep -q "no message" \
    && echo "PASS: CLI no-msg errors cleanly" || { echo "FAIL: CLI no-msg"; fail=1; }

# A11: option value that LOOKS like an option (-T -p as value)
v=$(ntfy_send --dry-run -T "-p" "msg")
echo "$v" | grep -q -- "Title:.*-p" && echo "PASS: option-looking value accepted" \
    || { echo "FAIL: option-like value -> [$v]"; fail=1; }

# A12: 3 actions exactly (boundary of max)
v=$(ntfy_send --dry-run -a "copy, A, 1" -a "copy, B, 2" -a "copy, C, 3" "x")
[[ "$v" == curl* ]] && echo "PASS: exactly 3 actions OK" \
    || { echo "FAIL: 3 actions -> [$v]"; fail=1; }

# A13: empty-string option values (valid, headers just carry empties)
v=$(ntfy_send --dry-run -T "" "msg")
echo "$v" | grep -q "Title" && { echo "FAIL: empty title emitted header"; fail=1; } \
    || echo "PASS: empty title skipped"

# A14: message from file (@path) end to end (dry-run output is %q-escaped:
# spaces render as backslash-space, so match with .*)
printf 'file body here' > /tmp/ntfy-msg-test.txt
ntfy_send --dry-run "@/tmp/ntfy-msg-test.txt" | grep -q 'file.*body.*here' \
    && echo "PASS: @file message" || { echo "FAIL: @file message"; fail=1; }
rm -f /tmp/ntfy-msg-test.txt

# A15: source-into-subshell isolation: _NTFY_CLI must NOT leak when sourced
( # shellcheck disable=SC1091
  source ./ntfy.sh; [[ "${_NTFY_CLI:-}" == true ]] && echo "FAIL: _NTFY_CLI leaked" ) | grep -q FAIL \
    && fail=1 || echo "PASS: no CLI flag leak when sourced"

echo
[[ $fail == 0 ]] && echo "=== ADVERSARIAL ALL PASS ===" || echo "=== ADVERSARIAL FAILURES ABOVE ==="
exit $fail
