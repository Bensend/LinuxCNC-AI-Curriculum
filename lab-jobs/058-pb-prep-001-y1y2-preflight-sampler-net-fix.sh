#!/usr/bin/env bash
set -euo pipefail

# Construction-only correction following 056/057. Preserve the frozen model
# and P0/P1-only classification. Fix two harness defects proven by prior runs:
# 1) math.h's y1() declaration collides with halcompile's generated y1 macro;
# 2) sampler pins must attach to already-existing loop signals rather than
#    attempting to create second signals from already-linked HAL pins.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/056-pb-prep-001-y1y2-preflight.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-preflight-fixed2.sh"
cp "$SRC" "$FIXED"
python3 - "$FIXED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
old='''#include <math.h>\nstatic int initialized = 0;\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }'''
new='''static int initialized = 0;\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }'''
if old not in s: raise SystemExit('HARNESS_INVALID: expected component preamble not found')
s=s.replace(old,new,1).replace('fabs(u1) > u_max','absd(u1) > u_max').replace('fabs(u2) > u_max','absd(u2) > u_max')
repls={
'net sr1 pb-prep.0.r1 => sampler.0.pin.2':'net y1cmd => sampler.0.pin.2',
'net sr2 pb-prep.0.r2 => sampler.0.pin.3':'net y2cmd => sampler.0.pin.3',
'net sy1 pb-prep.0.y1 => sampler.0.pin.4':'net y1fb => sampler.0.pin.4',
'net sy2 pb-prep.0.y2 => sampler.0.pin.5':'net y2fb => sampler.0.pin.5',
'net sref1 pb-prep.0.pid1-ref => sampler.0.pin.8':'net ref1 => sampler.0.pin.8',
'net sref2 pb-prep.0.pid2-ref => sampler.0.pin.9':'net ref2 => sampler.0.pin.9',
'net spid1 pb-prep.0.pid1-out => sampler.0.pin.10':'net pid1out => sampler.0.pin.10',
'net spid2 pb-prep.0.pid2-out => sampler.0.pin.11':'net pid2out => sampler.0.pin.11',
}
for a,b in repls.items():
    if a not in s: raise SystemExit(f'HARNESS_INVALID: expected recorder line absent: {a}')
    s=s.replace(a,b,1)
if '#include <math.h>' in s or 'fabs(' in s: raise SystemExit('HARNESS_INVALID: math dependency survived')
p.write_text(s)
PY
chmod +x "$FIXED"
printf 'PB-PREP-001 construction correction: sampler observes existing HAL signals; frozen experiment semantics unchanged.\n'
exec "$FIXED"
