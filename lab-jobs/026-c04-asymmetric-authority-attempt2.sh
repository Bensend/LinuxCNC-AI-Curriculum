#!/usr/bin/env bash
set -euo pipefail

# C04-026 materially redesigned correction harness after three-attempt review.
# Only observation/evidence handling changes. Frozen Gates A-H, Kc=0.5,
# PID gains, plant gains, maxoutput=1.0, phase durations, and thresholds remain unchanged.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
SRC="$ROOT/lab-jobs/026-c04-asymmetric-authority.sh"
TMP="${RUNNER_TEMP:-/tmp}/026-c04-asymmetric-authority-corrected-outer.sh"
EVID="$ROOT/lab-results/c04-026-evidence"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"

# Prevent stale evidence from satisfying retention.
rm -rf "$EVID"
mkdir -p "$RUN_EVID"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
old="ok=(r[18]==1 and abs(r[8]-1.0)<=1e-9) # outB index 8; positive move"
new="ok=(r[18]==1 and abs(r[9]-1.0)<=1e-9) # outB index 9; positive move"
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)
p.write_text(s)
PY

printf '%s\n' '== C04-026 redesigned correction preflight =='
printf '%s\n' 'frozen-gates=A-H unchanged'
printf '%s\n' 'control-values=unchanged'
printf '%s\n' 'correction=Gate-F outB tuple index 9 only'
grep -n 'outB index 9' "$TMP"
printf 'corrected-outer-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"

# Let the inherited inner fixture run normally. Its EXIT trap copies raw/internal
# evidence to $EVID even if the frozen analyzer returns nonzero.
set +e
bash "$TMP"
STATUS=$?
set -e

# Mirror fresh evidence into the workflow run directory included by upload-artifact.
for f in c04-026-realtime.txt c04-linuxcnc.stdout c04-linuxcnc.stderr c04-026-halsampler.stderr; do
  if [[ ! -f "$EVID/$f" ]]; then
    printf 'HARNESS_INVALID: fresh post-run evidence missing: %s\n' "$f" >&2
    exit 32
  fi
  cp "$EVID/$f" "$RUN_EVID/$f"
  printf 'post-run-retained-evidence=%s sha256=%s bytes=%s\n' "$f" "$(sha256sum "$EVID/$f" | awk '{print $1}')" "$(wc -c < "$EVID/$f")"
done
printf 'post-run-retained-realtime-lines=%s\n' "$(wc -l < "$EVID/c04-026-realtime.txt")"
printf 'inner-status=%s\n' "$STATUS"
exit "$STATUS"
