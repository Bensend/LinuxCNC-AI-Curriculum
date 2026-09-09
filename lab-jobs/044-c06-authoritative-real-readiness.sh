#!/usr/bin/env bash
set -euo pipefail

# C06-030 authoritative behavioral attempt after C06-043 proved the exact
# startup-race root cause. Base directly on the clean redesigned C06-037
# harness; change ONLY the observation/readiness barrier. Frozen P0-P6,
# threshold=3, watchdog register 0x2004:0, fixture, and Gates A-H are unchanged.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/037-c06-transport-watchdog-authoritative-redesigned.sh"
TMP="${RUNNER_TEMP:-/tmp}/c06-044-authoritative.sh"
[[ -s "$BASE" ]] || { echo 'HARNESS_INVALID: C06-037 base harness missing' >&2; exit 20; }
cp "$BASE" "$TMP"
python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
old='''# Wait for real fixture objects before starting authoritative sampling.\nready=0\nfor _ in $(seq 1 100); do\n  if halcmd show pin hm2_test.0.watchdog.has_bit >/dev/null 2>&1 && halcmd show param hm2_test.0.io_error >/dev/null 2>&1; then ready=1; break; fi\n  sleep .05\ndone\n[[ "$ready" == 1 ]] || { cat /tmp/c06-hal.out; echo 'HARNESS_INVALID: fixture did not become ready' >&2; kill "$HALPID" 2>/dev/null || true; exit 24; }\n\nhalsampler -c 0 -t >"$RUN_EVID/c06-trace.txt" 2>"$RUN_EVID/halsampler.stderr" &\nSAMPID=$!\nsleep .35\n'''
new='''# C06-043 correction: readiness must prove the requested HAL objects EXIST,\n# not merely that `halcmd show` returned exit status 0. Also prove halrun alive.\nready=0\nfor _ in $(seq 1 400); do\n  PINS="$(halcmd show pin 2>/dev/null || true)"\n  PARAMS="$(halcmd show param 2>/dev/null || true)"\n  FUNCTS="$(halcmd show funct 2>/dev/null || true)"\n  if grep -Fq 'hm2_test.0.watchdog.has_bit' <<<"$PINS" \\\n     && grep -Fq 'hm2_test.0.c06.fail-reads-remaining' <<<"$PINS" \\\n     && grep -Fq 'sampler.0.pin.9' <<<"$PINS" \\\n     && grep -Fq 'sampler.0.enable' <<<"$PINS" \\\n     && grep -Fq 'hm2_test.0.io_error' <<<"$PARAMS" \\\n     && grep -Fq 'sampler.0' <<<"$FUNCTS" \\\n     && kill -0 "$HALPID" 2>/dev/null; then ready=1; break; fi\n  sleep .025\ndone\n{\n  echo "ready=$ready"\n  echo "halrun_alive=$(kill -0 \"$HALPID\" 2>/dev/null && echo yes || echo no)"\n  halcmd show comp || true\n  halcmd show pin 'sampler.*' || true\n  halcmd show pin 'hm2_test.0.*' || true\n  halcmd show param 'hm2_test.0.*' || true\n  ipcs -m || true\n} >"$RUN_EVID/readiness-proof.txt" 2>&1\n[[ "$ready" == 1 ]] || { cat /tmp/c06-hal.out; echo 'HARNESS_INVALID: actual fixture/sampler objects did not become ready' >&2; kill "$HALPID" 2>/dev/null || true; exit 24; }\n\nhalsampler -c 0 -t >"$RUN_EVID/c06-trace.txt" 2>"$RUN_EVID/halsampler.stderr" &\nSAMPID=$!\n# Authoritative observation barrier: reader remains alive and at least 50 baseline\n# rows exist before any P1 mutation.\nobserving=0\nfor _ in $(seq 1 150); do\n  if ! kill -0 "$SAMPID" 2>/dev/null; then\n    cat "$RUN_EVID/halsampler.stderr" >&2 || true\n    echo 'HARNESS_INVALID: halsampler exited before P0 observation' >&2\n    kill "$HALPID" 2>/dev/null || true\n    exit 27\n  fi\n  if [[ -s "$RUN_EVID/c06-trace.txt" ]] && [[ $(wc -l <"$RUN_EVID/c06-trace.txt") -ge 50 ]]; then observing=1; break; fi\n  sleep .01\ndone\n[[ "$observing" == 1 ]] || { cat "$RUN_EVID/halsampler.stderr" >&2 || true; echo 'HARNESS_INVALID: no initial atomic sampler rows' >&2; kill "$SAMPID" "$HALPID" 2>/dev/null || true; exit 28; }\nsleep .30\n'''
if s.count(old) != 1:
    raise SystemExit('HARNESS_INVALID: expected C06-037 readiness block not unique')
s=s.replace(old,new,1)
s=s.replace("echo '== C06-030 authoritative redesigned run =='", "echo '== C06-030 authoritative redesigned run / real-readiness correction =='", 1)
p.write_text(s)
PY
chmod +x "$TMP"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"
cp "$TMP" "$RUN_EVID/executed-authoritative-harness.sh"
# Retain a diff proving the correction is confined to readiness/observation plumbing.
diff -u "$BASE" "$TMP" >"$RUN_EVID/harness-readiness-only.diff" || true
exec "$TMP"
