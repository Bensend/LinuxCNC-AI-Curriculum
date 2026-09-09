#!/usr/bin/env bash
set -euo pipefail

# C06-030 authoritative run using the exact phase-first harness that passed
# C06-045 non-authoritative publication preflight. No behavioral parameter,
# threshold, phase meaning, watchdog address, production HostMot2 source, or
# frozen Gate A-H logic is changed here.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-results/run-34312552726-1/executed-phase-first-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/c06-046-authoritative.sh"
[[ -s "$BASE" ]] || { echo 'HARNESS_INVALID: retained C06-045 executed harness missing' >&2; exit 20; }
cp "$BASE" "$TMP"
python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
old="echo '== C06 phase-publication redesign preflight (NON-AUTHORITATIVE) =='"
new="echo '== C06-030 authoritative phase-first run =='"
if s.count(old)!=1: raise SystemExit('HARNESS_INVALID: expected preflight banner not unique')
s=s.replace(old,new,1)
old="echo 'NON-AUTHORITATIVE PREFLIGHT: internal analyzer reached PASS; frozen Gates remain unaccepted'"
new="echo 'AUTHORITATIVE C06-030: frozen Gates A-H PASS with preflight-proven phase publication'"
if s.count(old)!=1: raise SystemExit('HARNESS_INVALID: expected preflight verdict label not unique')
s=s.replace(old,new,1)
p.write_text(s)
PY
chmod +x "$TMP"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"
cp "$TMP" "$RUN_EVID/executed-authoritative-harness.sh"
diff -u "$BASE" "$TMP" >"$RUN_EVID/preflight-to-authoritative-label-only.diff" || true
exec "$TMP"
