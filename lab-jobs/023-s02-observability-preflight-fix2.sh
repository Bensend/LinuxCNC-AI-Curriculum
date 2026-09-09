#!/usr/bin/env bash
set -euo pipefail

# S02 frozen observability preflight attempt 3 — final incremental attempt.
# Fixes only two already-classified harness defects from 021/022:
# (1) halcompile exported-object underscore->hyphen normalization;
# (2) standalone HAL lifetime: use realtime start + persistent halcmd setup.
# Frozen P0-P5, Gates A-J and all numeric thresholds/latencies are unchanged
# and remain UNSCORED.

BASE="lab-jobs/021-s02-observability-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/s02-023-preflight.sh"

python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
src,dst=map(Path,sys.argv[1:])
s=src.read_text()

# Attempt-1 correction: exported HAL object/function/pin namespace only.
count=s.count('s02_model.0')
assert count >= 10, count
s=s.replace('s02_model.0','s02-model.0')
assert 'loadrt s02_model\n' in s
assert 'component s02_model ' in s

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

dst.write_text(s)
print(f'S02-023 applied exported-HAL-name correction to {count} references and replaced only standalone HAL lifetime block.')
PY

chmod +x "$TMP"
printf '%s\n' 'S02-023: attempt 3/final incremental preflight; namespace+lifetime harness corrections only; frozen P0-P5/Gates A-J/numeric contract unchanged and UNSCORED.'
exec bash "$TMP"
