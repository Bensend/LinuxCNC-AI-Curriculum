#!/usr/bin/env bash
set -euo pipefail

# Redesigned-cycle attempt 2. Keep D01-015 semantics/gates unchanged and correct
# only the mux16 HAL interface error found by workflow 34347323567.
SRC="lab-jobs/015-d01-redesigned-observer-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/d01-016-preflight.sh"

python3 - "$SRC" "$TMP" <<'PY'
from pathlib import Path
import re, sys
src, dst = map(Path, sys.argv[1:])
s = src.read_text()
s = s.replace(
    'setp mux16.0.sel 0\n',
    'setp mux16.0.sel0 0\nsetp mux16.0.sel1 0\nsetp mux16.0.sel2 0\nsetp mux16.0.sel3 0\n',
    1,
)
s = s.replace('net D01-phase mux16.0.out => sampler.0.pin.0',
              'net D01-phase mux16.0.out-f => sampler.0.pin.0', 1)
needle = "readp(){ timeout 3s halcmd getp \"$1\" | tr -d '[:space:]'; }\n"
assert needle in s
phase_fn = '''set_phase(){\n  local n="$1"\n  halcmd setp mux16.0.sel0 $(( n & 1 ))\n  halcmd setp mux16.0.sel1 $(( (n >> 1) & 1 ))\n  halcmd setp mux16.0.sel2 $(( (n >> 2) & 1 ))\n  halcmd setp mux16.0.sel3 $(( (n >> 3) & 1 ))\n}\n'''
s = s.replace(needle, needle + phase_fn, 1)
s, count = re.subn(r'halcmd setp mux16\.0\.sel ([0-9]+)', r'set_phase \1', s)
assert count == 8, count
s = s.replace('== D01 redesigned non-authoritative observer preflight ==',
              '== D01 redesigned non-authoritative observer preflight, attempt 2 ==', 1)
s = s.replace('This run validates topology/order/numerics and the test-only atomic Cartesian observer.',
              'This corrected run validates topology/order/numerics and the test-only atomic Cartesian observer.', 1)
dst.write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'D01-016 correction scope: mux16 uses sel0..sel3 and out-f; frozen P0-P8 semantics and Gates A-J are unchanged/unscored.'
diff -u "$SRC" "$TMP" || true
exec bash "$TMP"
