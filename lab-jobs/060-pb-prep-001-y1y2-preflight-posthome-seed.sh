#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 construction correction after 059 exposed that the P1 differential
# seed was present during LinuxCNC homing. That allowed independent home/motor
# offsets to encode the deliberate y1/y2 seed, so motor-pos-cmd was no longer a
# clean witness of duplicated nominal command fanout. Keep both plants at the
# same coordinate through homing, then inject the frozen +initial_delta side-1
# seed exactly once when the scored/preflight run is enabled.
#
# This changes fixture initialization timing only. Architecture laws, gains,
# plant equation, limits, P0/P1-only classification, and frozen thresholds are
# unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/059-pb-prep-001-y1y2-preflight-causal-state-witness.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-preflight-fixed4.sh"
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

# 059 first transforms the component source to this initialization declaration.
one("    'static int initialized = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')",
    "    'static int initialized = 0;\\nstatic int seeded = 0;\\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')")

# Replace the source-side initial condition used by 056 before 059 adds the
# causal e_diff_used witness. The deliberate differential seed now appears only
# after pb-prep.0.run is asserted, i.e. after LinuxCNC homing has completed.
one("one('    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')",
    "one('    if (!initialized) { y1 = initial_delta; y2 = 0.0; initialized = 1; }\\n    ed = y1 - y2;\\n    corr_req = sync_gain * ed;', '    if (!initialized) { y1 = 0.0; y2 = 0.0; initialized = 1; }\\n    if (run && !seeded) { y1 += initial_delta; seeded = 1; }\\n    ed = y1 - y2;\\n    e_diff_used = ed;\\n    corr_req = sync_gain * ed;')")

p.write_text(s)
PY
chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 correction: differential sign seed moved after homing; frozen P0/P1 semantics otherwise unchanged.'
exec "$FIXED"
