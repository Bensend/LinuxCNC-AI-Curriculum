#!/usr/bin/env bash
set -euo pipefail

# X01-001 non-authoritative preflight, clean-lineage attempt 3.
# Attempt 2 proved the component compiles, but halcompile's `##` HALNAME
# produces zero-padded array pins (value-00..value-14). Correct only those
# harness references; frozen P0-P5, sample counts, FIFO depths, predicates,
# and Gates A-J remain unchanged.

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="${RUNNER_TEMP:-/tmp}/x01-029-fixed-preflight.sh"
cp "$ROOT/lab-jobs/027-x01-sampler-retention-preflight.sh" "$TMP"

sed -i 's/pin out float value\[15\];/pin out float value-##[15];/' "$TMP"
sed -i 's@echo "net x01-v$i x01-source\.0\.value-$i => sampler\.0\.pin\.$i"@printf '\''net x01-v%d x01-source.0.value-%02d => sampler.0.pin.%d\\n'\'' "$i" "$i" "$i"@' "$TMP"
sed -i 's/x01-source\.0\.value-0/x01-source.0.value-00/g' "$TMP"

if grep -q 'pin out float value\[15\];' "$TMP"; then
  echo 'array syntax correction did not apply' >&2
  exit 90
fi
if grep -q 'x01-source\.0\.value-$i' "$TMP"; then
  echo 'unpadded loop pin reference remains' >&2
  exit 91
fi
if grep -q 'x01-source\.0\.value-0\([^0-9]\|$\)' "$TMP"; then
  echo 'unpadded literal pin reference remains' >&2
  exit 92
fi

chmod +x "$TMP"
printf 'X01-029 clean-lineage preflight attempt 3: harness-only zero-padded indexed-pin reference correction; frozen P0-P5/Gates A-J unchanged.\n'
exec "$TMP"
