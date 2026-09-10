#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 revision-1 NON-AUTHORITATIVE P0/P1 preflight.
# Frozen revision: experiments/PB-PREP-001-revision-1-delay-stability-correction.md
# Material change from the original contract: SYNC_GAIN 2.0 -> 1.0 only, after
# retained run-063 evidence exposed a one-servo-period differential delay in A.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/059-pb-prep-001-y1y2-preflight-causal-state-witness.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-rev1-preflight.sh"
cp "$SRC" "$FIXED"
python3 - "$FIXED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

def one(a,b):
    global s
    if s.count(a)!=1:
        raise SystemExit(f'HARNESS_INVALID: expected exactly one occurrence: {a!r}, got {s.count(a)}')
    s=s.replace(a,b,1)

# Preserve 063's validated post-home seed construction.
one("    'static int initialized = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')",
    "    'static int initialized = 0;\\nstatic int seeded = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')")
one("one('    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')",
    "one('    if (!initialized) { y1 = initial_delta; y2 = 0.0; initialized = 1; }\\n    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    if (!initialized) { y1 = 0.0; y2 = 0.0; initialized = 1; }\\n    if (run && !seeded) { y1 += initial_delta; seeded = 1; }\\n    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')")

needle="if '#include <math.h>' in s or 'fabs(' in s: raise SystemExit('HARNESS_INVALID: math dependency survived')\np.write_text(s)"
replacement=r'''if '#include <math.h>' in s or 'fabs(' in s: raise SystemExit('HARNESS_INVALID: math dependency survived')
one('SYNC_GAIN=2.0', 'SYNC_GAIN=1.0')
one('  halcmd setp pb-prep.0.run true\n', '  # pb-prep.0.run remains false until the homed predicate passes\n')
one('import linuxcnc, time, sys, os\nc=linuxcnc.command()', 'import linuxcnc, time, sys, os, subprocess\nc=linuxcnc.command()')
one("c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))\nc.mode(linuxcnc.MODE_MDI); wc('mdi')",
    "c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))\nsubprocess.run(['halcmd','setp','pb-prep.0.run','true'],check=True)\nprint(os.environ['ARCH']+'-posthome-run-enable=PASS')\nc.mode(linuxcnc.MODE_MDI); wc('mdi')")
p.write_text(s)'''
one(needle,replacement)
p.write_text(s)
PY
chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 revision 1: SYNC_GAIN=1.0 with post-home sign seed; all frozen P0/P1 gates retained.'
exec "$FIXED"
