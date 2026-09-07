#!/usr/bin/env bash
set -euo pipefail

# Pre-run correction wrapper for S04-014.  The original implementation mistakenly
# required actual motor-pos-cmd travel of 0.20 units after freeze.  That would be
# incompatible with the predeclared prediction that LinuxCNC disables motion when
# following error crosses the much smaller runtime limit.  The immutable plan
# requires >=0.20 units of REQUESTED move remaining, while observed motion must
# continue far enough to exceed the runtime f-error limit.

SRC="lab-jobs/014-s04-feedback-freeze.sh"
TMP="${RUNNER_TEMP:-/tmp}/014-s04-feedback-freeze-corrected-body.sh"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()
old = '''timeout 3s halcmd setp mux2.0.sel 1\nprintf 'freeze-asserted hold=%s cmd-at-freeze=%s\\n' "$HOLD" "$(read_pin joint.0.motor-pos-cmd)"\n'''
new = '''timeout 3s halcmd setp mux2.0.sel 1\nFREEZE_CMD="$(read_pin joint.0.motor-pos-cmd)"\nprintf 'freeze-asserted hold=%s cmd-at-freeze=%s\\n' "$HOLD" "$FREEZE_CMD"\nawk -v c="$FREEZE_CMD" 'BEGIN{remaining=1.0-c; if(remaining<0)remaining=-remaining; exit !(remaining>=0.20)}' || {\n    echo 'HARNESS INVALID: commanded move did not have the predeclared >=0.20 units remaining at freeze.' >&2\n    exit 6\n}\n'''
if old not in s:
    raise SystemExit('freeze-site patch anchor not found')
s = s.replace(old, new, 1)
old = '''        if (travel>max_travel) max_travel=travel\n        if (abs(fe)>lim) crossed++\n'''
new = '''        if (travel>max_travel) max_travel=travel\n        if (lim>max_lim) max_lim=lim\n        if (abs(fe)>lim) crossed++\n'''
if old not in s:
    raise SystemExit('analysis-limit patch anchor not found')
s = s.replace(old, new, 1)
old = '''    printf("moving-analysis frozen=%d max_travel=%.9g crossed=%d ferrored=%d exact_fault=%d disable=%d\\n", frozen,max_travel,crossed,ferrored,exact_fault,disable)\n    if (frozen < 1) exit 20\n    if (max_travel < 0.20) exit 21\n'''
new = '''    printf("moving-analysis frozen=%d max_travel=%.9g max_runtime_limit=%.9g crossed=%d ferrored=%d exact_fault=%d disable=%d\\n", frozen,max_travel,max_lim,crossed,ferrored,exact_fault,disable)\n    if (frozen < 1) exit 20\n    if (max_travel <= max_lim + 1e-6) exit 21\n'''
if old not in s:
    raise SystemExit('impossible-travel gate patch anchor not found')
s = s.replace(old, new, 1)
p.write_text(s)
PY

bash -n "$TMP"
exec bash "$TMP"
