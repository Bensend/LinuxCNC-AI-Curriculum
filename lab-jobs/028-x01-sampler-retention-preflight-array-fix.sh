#!/usr/bin/env bash
set -euo pipefail

# X01-001 non-authoritative preflight, clean-lineage attempt 2.
# Attempt 1 failed before runtime phases because the local test component used
# invalid halcompile array declaration syntax (`value[15]`). The frozen P0-P5
# model and Gates A-J are unchanged. This wrapper corrects only that demonstrated
# harness defect to halcompile's indexed-pin syntax (`value-##[15]`).

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="${RUNNER_TEMP:-/tmp}/x01-028-fixed-preflight.sh"
cp "$ROOT/lab-jobs/027-x01-sampler-retention-preflight.sh" "$TMP"
sed -i 's/pin out float value\[15\];/pin out float value-##[15];/' "$TMP"
if grep -q 'pin out float value\[15\];' "$TMP"; then
  echo 'array syntax correction did not apply' >&2
  exit 90
fi
if ! grep -q 'pin out float value-##\[15\];' "$TMP"; then
  echo 'corrected indexed-pin declaration missing' >&2
  exit 91
fi
chmod +x "$TMP"
printf 'X01-028 clean-lineage preflight attempt 2: harness-only halcompile array syntax correction; frozen P0-P5/Gates A-J unchanged.\n'
exec "$TMP"
