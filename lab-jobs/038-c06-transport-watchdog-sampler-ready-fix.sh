#!/usr/bin/env bash
set -euo pipefail

# Redesigned C06 behavioral harness attempt 2.
# Harness-only correction to C06-037: wait for the realtime sampler stream before
# userspace halsampler attaches, and reject a dead/empty sampler before P1.
# Frozen C06-030 fixture, P0-P6, threshold, watchdog bit, and Gates A-H are unchanged.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/037-c06-transport-watchdog-authoritative-redesigned.sh"
TMP="${RUNNER_TEMP:-/tmp}/c06-038-authoritative.sh"
[[ -s "$BASE" ]] || { echo 'HARNESS_INVALID: C06-037 base harness missing' >&2; exit 20; }
cp "$BASE" "$TMP"
python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
old='''# Wait for real fixture objects before starting authoritative sampling.\nready=0\nfor _ in $(seq 1 100); do\n  if halcmd show pin hm2_test.0.watchdog.has_bit >/dev/null 2>&1 && halcmd show param hm2_test.0.io_error >/dev/null 2>&1; then ready=1; break; fi\n  sleep .05\ndone\n[[ "$ready" == 1 ]] || { cat /tmp/c06-hal.out; echo 'HARNESS_INVALID: fixture did not become ready' >&2; kill "$HALPID" 2>/dev/null || true; exit 24; }\n\nhalsampler -c 0 -t >"$RUN_EVID/c06-trace.txt" 2>"$RUN_EVID/halsampler.stderr" &\nSAMPID=$!\nsleep .35\n'''
new='''# Wait for BOTH the real fixture objects and the realtime sampler-owned objects.\n# C06-037 waited only for HostMot2 objects, allowing halsampler to race loadrt sampler.\nready=0\nfor _ in $(seq 1 200); do\n  if halcmd show pin hm2_test.0.watchdog.has_bit >/dev/null 2>&1 \\\n     && halcmd show param hm2_test.0.io_error >/dev/null 2>&1 \\\n     && halcmd show pin sampler.0.pin.9 >/dev/null 2>&1 \\\n     && halcmd show pin sampler.0.enable >/dev/null 2>&1; then ready=1; break; fi\n  sleep .05\ndone\n[[ "$ready" == 1 ]] || { cat /tmp/c06-hal.out; echo 'HARNESS_INVALID: fixture/sampler did not become ready' >&2; kill "$HALPID" 2>/dev/null || true; exit 24; }\n\nhalsampler -c 0 -t >"$RUN_EVID/c06-trace.txt" 2>"$RUN_EVID/halsampler.stderr" &\nSAMPID=$!\n# Observation barrier: the userspace reader must stay alive and produce baseline rows before P1.\nobserving=0\nfor _ in $(seq 1 100); do\n  if ! kill -0 "$SAMPID" 2>/dev/null; then\n    cat "$RUN_EVID/halsampler.stderr" >&2 || true\n    echo 'HARNESS_INVALID: halsampler exited before P0 observation' >&2\n    kill "$HALPID" 2>/dev/null || true\n    exit 27\n  fi\n  if [[ -s "$RUN_EVID/c06-trace.txt" ]] && [[ $(wc -l <"$RUN_EVID/c06-trace.txt") -ge 50 ]]; then observing=1; break; fi\n  sleep .01\ndone\n[[ "$observing" == 1 ]] || { cat "$RUN_EVID/halsampler.stderr" >&2 || true; echo 'HARNESS_INVALID: no initial atomic sampler rows' >&2; kill "$SAMPID" "$HALPID" 2>/dev/null || true; exit 28; }\nsleep .30\n'''
if s.count(old)!=1:
    raise SystemExit('HARNESS_INVALID: expected C06-037 readiness block not unique')
s=s.replace(old,new,1)
# Keep the job identity/evidence visibly distinct without changing frozen experiment semantics.
s=s.replace("echo '== C06-030 authoritative redesigned run =='", "echo '== C06-030 authoritative redesigned run / sampler-ready correction =='", 1)
p.write_text(s)
PY
chmod +x "$TMP"
mkdir -p "$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
cp "$TMP" "$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}/executed-authoritative-harness.sh"
exec "$TMP"
