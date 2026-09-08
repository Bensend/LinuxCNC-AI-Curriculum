#!/usr/bin/env bash
set -euo pipefail

# C04-026 attempt 2: observation-harness correction only.
# Frozen Gates A-H, Kc=0.5, PID gains, plant gains, maxoutput=1.0,
# phase durations, and thresholds remain unchanged.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
SRC="$ROOT/lab-jobs/026-c04-asymmetric-authority.sh"
TMP="${RUNNER_TEMP:-/tmp}/026-c04-asymmetric-authority-attempt2-outer.sh"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()

# Correction 1: Gate F must test PID-B output, tuple index 9.
old="ok=(r[18]==1 and abs(r[8]-1.0)<=1e-9) # outB index 8; positive move"
new="ok=(r[18]==1 and abs(r[9]-1.0)<=1e-9) # outB index 9; positive move"
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

# Correction 2: preserve the raw realtime trace and internal runtime logs before
# the analyzer can terminate under set -e. Also mirror them into the workflow
# run directory, which upload-artifact includes even when the analyzer fails.
needle="a0=s.index(\"TRACE=c04-026-realtime.txt python3 - <<'PY'\\n\")"
inject=r'''# Attempt-2 evidence-retention correction: insert a copy block into the
# generated inner script immediately before its analyzer.
retain = r'''\nmkdir -p "$EVID"\nRUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"\nmkdir -p "$RUN_EVID"\nfor f in c04-026-realtime.txt c04-linuxcnc.stdout c04-linuxcnc.stderr c04-026-halsampler.stderr; do\n  if [[ -f "$f" ]]; then\n    cp "$f" "$EVID/$f"\n    cp "$f" "$RUN_EVID/$f"\n    printf 'pre-analyzer-retained-evidence=%s sha256=%s bytes=%s\\n' "$f" "$(sha256sum "$f" | awk '{print $1}')" "$(wc -c < "$f")"\n  else\n    printf 'HARNESS_INVALID: required pre-analyzer evidence missing: %s\\n' "$f" >&2\n    exit 32\n  fi\ndone\nprintf 'pre-analyzer-retained-realtime-lines=%s\\n' "$(wc -l < c04-026-realtime.txt)"\n'''\ntrace_marker="TRACE=c04-026-realtime.txt python3 - <<'PY'\\n"\nassert s.count(trace_marker)==1, s.count(trace_marker)\ns=s.replace(trace_marker, retain+trace_marker, 1)\n'''
assert s.count(needle)==1, s.count(needle)
s=s.replace(needle, inject+"\n"+needle)

p.write_text(s)
PY

printf '%s\n' '== C04-026 attempt-2 observation correction preflight =='
printf '%s\n' 'frozen-gates=A-H unchanged'
printf '%s\n' 'control-values=unchanged'
printf '%s\n' 'corrections=Gate-F outB tuple index 9; raw/internal logs retained before analyzer'
grep -n -E 'outB index 9|Attempt-2 evidence-retention|pre-analyzer-retained' "$TMP"
printf 'attempt2-outer-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
