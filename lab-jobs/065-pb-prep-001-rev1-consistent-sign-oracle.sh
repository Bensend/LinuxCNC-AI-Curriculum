#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 revision-1 oracle correction. Run 064 proved the behavioral
# generator used the frozen SYNC_GAIN=1.0 but inherited 059's analyzer oracle
# `corr_req == 2*e_diff`. Patch only that stale expected relationship. No plant,
# controller, sampling, motion, or acceptance-threshold change is made here.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/064-pb-prep-001-rev1-delay-stable-preflight.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-rev1-oracle-fixed.sh"
cp "$SRC" "$FIXED"
python3 - "$FIXED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
old="if abs(creq - 2.0*ed) > 2e-6 or creq<=0 or cap<=0: print('HARNESS_INVALID: causal e_diff/correction relationship wrong',file=sys.stderr); sys.exit(44)"
new="if abs(creq - 1.0*ed) > 2e-6 or creq<=0 or cap<=0: print('HARNESS_INVALID: causal e_diff/correction relationship wrong',file=sys.stderr); sys.exit(44)"
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: expected one stale gain oracle, got {s.count(old)}')
s=s.replace(old,new,1)
p.write_text(s)
PY
chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 revision 1 oracle correction: expected corr_req=1.0*e_diff; behavior and frozen thresholds unchanged.'
exec "$FIXED"
