#!/usr/bin/env bash
set -euo pipefail

# Narrow construction-only correction to 056. The frozen PB-PREP-001 model,
# topology, thresholds, recorder, and P0/P1 classification are unchanged.
# 056 proved that halcompile's generated `#define y1 ...` collides with the
# libc math.h declaration of y1(). Remove the unnecessary math.h dependency
# and use an equivalent local absolute-value helper for saturation witnesses.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/056-pb-prep-001-y1y2-preflight.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-preflight-fixed.sh"
cp "$SRC" "$FIXED"
python3 - "$FIXED" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()
old = '''#include <math.h>\nstatic int initialized = 0;\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }'''
new = '''static int initialized = 0;\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }'''
if old not in s:
    raise SystemExit('HARNESS_INVALID: expected 056 component preamble not found')
s = s.replace(old, new, 1)
s = s.replace('fabs(u1) > u_max', 'absd(u1) > u_max')
s = s.replace('fabs(u2) > u_max', 'absd(u2) > u_max')
if '#include <math.h>' in s or 'fabs(' in s:
    raise SystemExit('HARNESS_INVALID: math.h/fabs construction dependency survived fix')
p.write_text(s)
PY
chmod +x "$FIXED"
printf 'PB-PREP-001 construction correction: removed math.h/y1 namespace collision; frozen experiment semantics unchanged.\n'
exec "$FIXED"
