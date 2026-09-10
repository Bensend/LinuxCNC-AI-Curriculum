#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 correction after 061 failed before execution because its wrapper
# attempted to patch generated 056 text at the outer 059 layer. This wrapper
# patches 059's generator itself: equal plant states through homing, one-shot
# seed on run, and run asserted only after the Python homed predicate succeeds.
# Frozen architecture laws, plant/controller constants, thresholds, and P0/P1
# classification remain unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/059-pb-prep-001-y1y2-preflight-causal-state-witness.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-preflight-fixed6.sh"
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

# Modify 059's transformation so the generated component starts equal and seeds
# only on the first cycle after pb-prep.0.run becomes true.
one("    'static int initialized = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')",
    "    'static int initialized = 0;\\nstatic int seeded = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')")
one("one('    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')",
    "one('    if (!initialized) { y1 = initial_delta; y2 = 0.0; initialized = 1; }\\n    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    if (!initialized) { y1 = 0.0; y2 = 0.0; initialized = 1; }\\n    if (run && !seeded) { y1 += initial_delta; seeded = 1; }\\n    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')")

# Insert transformations into 059's inner generator, where s is the copied 056.
needle="if '#include <math.h>' in s or 'fabs(' in s: raise SystemExit('HARNESS_INVALID: math dependency survived')\np.write_text(s)"
replacement="""if '#include <math.h>' in s or 'fabs(' in s: raise SystemExit('HARNESS_INVALID: math dependency survived')
one('  halcmd setp pb-prep.0.run true\\n\\n  ARCH=\"$ARCH\" python3 - <<\'PY\'\\nimport linuxcnc, time, sys, os',
    '  # controller intentionally remains disabled through homing\\n\\n  ARCH=\"$ARCH\" python3 - <<\'PY\'\\nimport linuxcnc, time, sys, os, subprocess')
one("c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))\\nc.mode(linuxcnc.MODE_MDI); wc('mdi')",
    "c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))\\nsubprocess.run(['halcmd','setp','pb-prep.0.run','true'],check=True)\\nprint(f'{os.environ[\\\"ARCH\\\"]}-posthome-run-enable=PASS')\\nc.mode(linuxcnc.MODE_MDI); wc('mdi')")
p.write_text(s)"""
one(needle,replacement)

p.write_text(s)
PY
chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 correction: seed enable is now generated after the homed predicate; frozen P0/P1 contract otherwise unchanged.'
exec "$FIXED"
