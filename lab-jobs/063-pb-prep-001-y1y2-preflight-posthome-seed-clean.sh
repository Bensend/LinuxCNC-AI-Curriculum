#!/usr/bin/env bash
set -euo pipefail

# Clean construction correction after 062's wrapper quoting error. Modify 059's
# generator using only quote-safe substrings: equal synthetic states through
# homing, one-shot sign seed on run, and run asserted by the Python controller
# immediately after all joints report homed. Frozen experiment semantics remain.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/059-pb-prep-001-y1y2-preflight-causal-state-witness.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-preflight-fixed7.sh"
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

one("    'static int initialized = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')",
    "    'static int initialized = 0;\\nstatic int seeded = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')")
one("one('    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')",
    "one('    if (!initialized) { y1 = initial_delta; y2 = 0.0; initialized = 1; }\\n    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    if (!initialized) { y1 = 0.0; y2 = 0.0; initialized = 1; }\\n    if (run && !seeded) { y1 += initial_delta; seeded = 1; }\\n    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')")

needle="if '#include <math.h>' in s or 'fabs(' in s: raise SystemExit('HARNESS_INVALID: math dependency survived')\np.write_text(s)"
replacement=r'''if '#include <math.h>' in s or 'fabs(' in s: raise SystemExit('HARNESS_INVALID: math dependency survived')
one('  halcmd setp pb-prep.0.run true\n', '  # pb-prep.0.run remains false until the homed predicate passes\n')
one('import linuxcnc, time, sys, os\nc=linuxcnc.command()', 'import linuxcnc, time, sys, os, subprocess\nc=linuxcnc.command()')
one("c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))\nc.mode(linuxcnc.MODE_MDI); wc('mdi')",
    "c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))\nsubprocess.run(['halcmd','setp','pb-prep.0.run','true'],check=True)\nprint(os.environ['ARCH']+'-posthome-run-enable=PASS')\nc.mode(linuxcnc.MODE_MDI); wc('mdi')")
p.write_text(s)'''
one(needle,replacement)
p.write_text(s)
PY
chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 correction: clean post-home sign-seed generation; frozen P0/P1 contract unchanged.'
exec "$FIXED"
