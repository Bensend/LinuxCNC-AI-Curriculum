#!/usr/bin/env bash
# C02-024 evidence-retention wrapper.
# Frozen Gates A-H and numerical thresholds remain unchanged. The only change
# from the already-passing corrected harness is durable publication of the
# complete realtime evidence files inside lab-results/, which is included in
# the authoritative workflow artifact and repository result commit.
set -uo pipefail
ROOT="${GITHUB_WORKSPACE:-$(pwd)}"
cd "$ROOT"
set +e
bash lab-jobs/024-c02-independent-feedback-disturbance-correction.sh
STATUS=$?
set -e
EVID="$ROOT/lab-results/c02-024-evidence"
mkdir -p "$EVID"
for f in c02-024-realtime.txt c02-linuxcnc.stdout c02-linuxcnc.stderr c02-024-halsampler.stderr; do
  if [[ -f "$ROOT/$f" ]]; then
    cp "$ROOT/$f" "$EVID/$f"
    printf 'retained-evidence=%s sha256=%s bytes=%s\n' \
      "lab-results/c02-024-evidence/$f" \
      "$(sha256sum "$EVID/$f" | awk '{print $1}')" \
      "$(wc -c < "$EVID/$f")"
  else
    printf 'HARNESS_INVALID: required retained evidence missing after inner run: %s\n' "$f" >&2
    [[ "$STATUS" -ne 0 ]] || STATUS=44
  fi
done
if [[ -s "$EVID/c02-024-realtime.txt" ]]; then
  printf 'retained-realtime-lines=%s\n' "$(wc -l < "$EVID/c02-024-realtime.txt")"
else
  printf 'HARNESS_INVALID: retained realtime trace empty\n' >&2
  [[ "$STATUS" -ne 0 ]] || STATUS=45
fi
printf 'inner-c02-024-status=%s\n' "$STATUS"
exit "$STATUS"
