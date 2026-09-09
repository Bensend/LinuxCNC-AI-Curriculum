#!/usr/bin/env bash
set -euo pipefail

# S02 independent authoritative execution.
# Runtime model, P0-P5 semantics, Gates A-J and all numeric thresholds/latencies
# are identical to the artifact-validated 023 preflight. This file changes only
# already-validated harness namespace/lifetime corrections and provenance labels.
# Gates are scored later from retained artifact evidence, never from workflow status.

BASE="lab-jobs/021-s02-observability-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/s02-024-authoritative.sh"

python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
src,dst=map(Path,sys.argv[1:])
s=src.read_text()

# Same validated exported-HAL-name correction as 023.
count=s.count('s02_model.0')
assert count >= 10, count
s=s.replace('s02_model.0','s02-model.0')
assert 'loadrt s02_model\n' in s
assert 'component s02_model ' in s

# Same validated persistent standalone HAL lifetime as 023.
old='''rm -f /tmp/s02.samples /tmp/s02-halsampler.stdout /tmp/s02-halsampler.stderr
halrun -f /tmp/s02.hal >"$OUT/halrun.stdout" 2>"$OUT/halrun.stderr" &
HALPID=$!
cleanup(){
  trap - EXIT
  kill -TERM "$HALPID" 2>/dev/null || true
  sleep .1
  kill -KILL "$HALPID" 2>/dev/null || true
  wait "$HALPID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 80); do
  if kill -0 "$HALPID" 2>/dev/null && timeout 2s halcmd show pin s02-model.0.phase >/tmp/s02-ready.txt 2>/tmp/s02-ready.err && grep -q s02-model.0.phase /tmp/s02-ready.txt; then
    READY=1; break
  fi
  sleep .05
done
[[ "$READY" == 1 ]] || { cat "$OUT/halrun.stderr" >&2; cat /tmp/s02-ready.err >&2 || true; exit 2; }
'''
new='''rm -f /tmp/s02.samples /tmp/s02-halsampler.stdout /tmp/s02-halsampler.stderr
cleanup(){
  trap - EXIT
  timeout --signal=TERM --kill-after=2s 5s halcmd stop >/dev/null 2>&1 || true
  timeout --signal=TERM --kill-after=2s 5s halcmd unload all >/dev/null 2>&1 || true
  timeout --signal=TERM --kill-after=2s 8s realtime stop >/dev/null 2>&1 || true
}
trap cleanup EXIT
realtime start >"$OUT/realtime-start.stdout" 2>"$OUT/realtime-start.stderr"
halcmd -f /tmp/s02.hal >"$OUT/hal-setup.stdout" 2>"$OUT/hal-setup.stderr"

READY=0
for i in $(seq 1 80); do
  if timeout 2s halcmd show pin s02-model.0.phase >/tmp/s02-ready.txt 2>/tmp/s02-ready.err && grep -q s02-model.0.phase /tmp/s02-ready.txt && timeout 2s halcmd show pin sampler.0.enable >/tmp/s02-sampler-ready.txt 2>>/tmp/s02-ready.err && grep -q sampler.0.enable /tmp/s02-sampler-ready.txt; then
    READY=1; break
  fi
  sleep .05
done
[[ "$READY" == 1 ]] || { cat "$OUT/hal-setup.stderr" >&2 || true; cat /tmp/s02-ready.err >&2 || true; exit 2; }
'''
assert old in s
s=s.replace(old,new,1)

# Label the retained package as the authoritative execution while preserving
# every behaviorally relevant line and numeric declaration.
s=s.replace('S02 non-authoritative preflight for the already-frozen P0-P5 model and Gates A-J.', 'S02 authoritative execution for the already-frozen P0-P5 model and Gates A-J.')
s=s.replace('This script validates only harness behavior and retained evidence. It does NOT\n# score the frozen gates', 'This script performs the independent authoritative runtime. The frozen gates are\n# scored only later from retained evidence')
s=s.replace('S02-021 NON-AUTHORITATIVE PREFLIGHT', 'S02-024 AUTHORITATIVE EXECUTION')
s=s.replace('Frozen P0-P5 and Gates A-J remain unchanged and UNSCORED in this preflight.', 'Frozen P0-P5 and Gates A-J remain unchanged; gate scoring occurs only from retained authoritative evidence.')
s=s.replace('== S02 frozen observability model non-authoritative preflight ==', '== S02 frozen observability model authoritative execution ==')
s=s.replace('NOTE: this is non-authoritative harness validation; frozen S02 Gates A-J remain UNSCORED.', 'NOTE: authoritative runtime evidence retained; Gates A-J must be scored independently from the artifact.')
s=s.replace('S02-021 PREFLIGHT RUNTIME PREDICATES PASS', 'S02-024 AUTHORITATIVE RUNTIME PREDICATES PASS')
s=s.replace('S02-021 EVIDENCE-RETENTION PREFLIGHT PASS; frozen Gates A-J remain UNSCORED.', 'S02-024 AUTHORITATIVE EVIDENCE RETENTION PASS; score frozen Gates A-J independently from this artifact.')

# Keep evidence inside workflow-uploaded run tree; use a distinct directory.
s=s.replace('s02-021-evidence','s02-024-authoritative-evidence')

dst.write_text(s)
print(f'S02-024 authoritative fixture generated with {count} namespace corrections; validated lifetime correction; frozen behavioral contract unchanged.')
PY

chmod +x "$TMP"
printf '%s\n' 'S02-024: independent authoritative execution; frozen P0-P5/Gates A-J/numeric contract unchanged from validated preflight.'
exec bash "$TMP"
