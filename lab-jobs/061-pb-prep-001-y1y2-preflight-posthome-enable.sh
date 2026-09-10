#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 construction correction after 060 proved that pb-prep.0.run was
# asserted before the Python homing sequence. Keep the synthetic sides equal
# throughout homing, then assert run and inject the frozen +initial_delta seed
# only after all four joints report homed. Frozen controller/plant constants,
# thresholds, and P0/P1-only classification are unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/059-pb-prep-001-y1y2-preflight-causal-state-witness.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-preflight-fixed5.sh"
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

# Extend 059's generated component with a one-shot post-enable seed.
one("    'static int initialized = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')",
    "    'static int initialized = 0;\\nstatic int seeded = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')")
one("one('    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')",
    "one('    if (!initialized) { y1 = initial_delta; y2 = 0.0; initialized = 1; }\\n    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    if (!initialized) { y1 = 0.0; y2 = 0.0; initialized = 1; }\\n    if (run && !seeded) { y1 += initial_delta; seeded = 1; }\\n    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')")

# Crucial ordering correction: 059 enables the controller before Python homes.
# Delay that assertion until immediately after the homed predicate succeeds.
one('  halcmd setp pb-prep.0.run true\n\n  ARCH="$ARCH" python3 - <<\'PY\'\nimport linuxcnc, time, sys, os',
    '  # pb-prep.0.run intentionally remains false through homing.\n\n  ARCH="$ARCH" python3 - <<\'PY\'\nimport linuxcnc, time, sys, os, subprocess')
one("c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))\nc.mode(linuxcnc.MODE_MDI); wc('mdi')",
    "c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))\nsubprocess.run(['halcmd','setp','pb-prep.0.run','true'],check=True)\nprint(f'{os.environ[\"ARCH\"]}-posthome-run-enable=PASS')\nc.mode(linuxcnc.MODE_MDI); wc('mdi')")

p.write_text(s)
PY
chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 correction: run/sign-seed enable now occurs only after homing; frozen P0/P1 contract otherwise unchanged.'
exec "$FIXED"
