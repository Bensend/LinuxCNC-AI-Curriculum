#!/usr/bin/env bash
set -euo pipefail

# C04-026 corrected observation rerun. This wrapper changes observation only.
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

# Correction 2: make the generated inner script preserve raw realtime evidence
# and internal runtime logs before its analyzer can terminate under set -e.
needle="a0=s.index(\"TRACE=c04-026-realtime.txt python3 - <<'PY'\\n\")"
lines = [
    "# Corrected evidence retention inserted before the generated analyzer.",
    "retain = r'''",
    "mkdir -p \"$EVID\"",
    "RUN_EVID=\"$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}\"",
    "mkdir -p \"$RUN_EVID\"",
    "for f in c04-026-realtime.txt c04-linuxcnc.stdout c04-linuxcnc.stderr c04-026-halsampler.stderr; do",
    "  if [[ -f \"$f\" ]]; then",
    "    cp \"$f\" \"$EVID/$f\"",
    "    cp \"$f\" \"$RUN_EVID/$f\"",
    "    printf 'pre-analyzer-retained-evidence=%s sha256=%s bytes=%s\\\\n' \"$f\" \"$(sha256sum \"$f\" | awk '{print $1}')\" \"$(wc -c < \"$f\")\"",
    "  else",
    "    printf 'HARNESS_INVALID: required pre-analyzer evidence missing: %s\\\\n' \"$f\" >&2",
    "    exit 32",
    "  fi",
    "done",
    "printf 'pre-analyzer-retained-realtime-lines=%s\\\\n' \"$(wc -l < c04-026-realtime.txt)\"",
    "'''",
    "trace_marker=\"TRACE=c04-026-realtime.txt python3 - <<'PY'\\\\n\"",
    "assert s.count(trace_marker)==1, s.count(trace_marker)",
    "s=s.replace(trace_marker, retain+trace_marker, 1)",
]
inject="\n".join(lines)+"\n"
assert s.count(needle)==1, s.count(needle)
s=s.replace(needle, inject+needle)

p.write_text(s)
PY

printf '%s\n' '== C04-026 corrected observation preflight =='
printf '%s\n' 'frozen-gates=A-H unchanged'
printf '%s\n' 'control-values=unchanged'
printf '%s\n' 'corrections=Gate-F outB tuple index 9; raw/internal logs retained before analyzer'
grep -n -E 'outB index 9|Corrected evidence retention|pre-analyzer-retained' "$TMP"
printf 'corrected-outer-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
