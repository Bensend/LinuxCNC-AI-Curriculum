#!/usr/bin/env bash
set -euo pipefail

# Clean rev-1 rerun after 065 showed the stale sign oracle lives inside 059's
# generated analyzer, not in 064's outer wrapper. Add the oracle correction to
# 064's inner-generator patch point. No behavioral parameter or threshold change.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/064-pb-prep-001-rev1-delay-stable-preflight.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-rev1-oracle-corrected.sh"
cp "$SRC" "$FIXED"
python3 - "$FIXED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
old="one('SYNC_GAIN=2.0', 'SYNC_GAIN=1.0')"
new="""one('SYNC_GAIN=2.0', 'SYNC_GAIN=1.0')
one(\"if abs(creq - 2.0*ed) > 2e-6 or creq<=0 or cap<=0: print('HARNESS_INVALID: causal e_diff/correction relationship wrong',file=sys.stderr); sys.exit(44)\",\n    \"if abs(creq - 1.0*ed) > 2e-6 or creq<=0 or cap<=0: print('HARNESS_INVALID: causal e_diff/correction relationship wrong',file=sys.stderr); sys.exit(44)\")"""
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: expected one rev1 gain patch point, got {s.count(old)}')
s=s.replace(old,new,1)
p.write_text(s)
PY
chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 revision 1: generated analyzer oracle aligned to frozen SYNC_GAIN=1.0; behavior/thresholds unchanged.'
exec "$FIXED"
