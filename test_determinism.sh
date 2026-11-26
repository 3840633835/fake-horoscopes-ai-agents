#!/bin/sh
# Verify main.py is deterministic: two runs into separate directories
# must produce byte-identical entry.txt files of 1-200 characters
# with no trailing newline.
set -eu
cd "$(dirname "$0")"

D1="$(mktemp -d)"
D2="$(mktemp -d)"
trap 'rm -rf "$D1" "$D2"' EXIT

MAKEFUN_OUTPUT_DIR="$D1" python3 main.py
MAKEFUN_OUTPUT_DIR="$D2" python3 main.py

H1="$(sha256sum "$D1/entry.txt" | cut -d' ' -f1)"
H2="$(sha256sum "$D2/entry.txt" | cut -d' ' -f1)"
[ "$H1" = "$H2" ] || { echo "FAIL: hashes differ: $H1 vs $H2"; exit 1; }

CHARS="$(python3 -c "print(len(open('$D1/entry.txt', encoding='utf-8').read()))")"
[ "$CHARS" -ge 1 ] && [ "$CHARS" -le 200 ] || { echo "FAIL: $CHARS characters, not 1-200"; exit 1; }

LAST="$(tail -c 1 "$D1/entry.txt" | od -An -tx1 | tr -d ' \n')"
[ "$LAST" != "0a" ] || { echo "FAIL: trailing newline"; exit 1; }

# Must match the committed entry.txt byte for byte.
cmp -s "$D1/entry.txt" entry.txt || { echo "FAIL: output differs from committed entry.txt"; exit 1; }

echo "PASS: deterministic ($H1), $CHARS characters, no trailing newline, matches entry.txt"
