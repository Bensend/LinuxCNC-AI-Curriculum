#!/usr/bin/env bash
set -euo pipefail

# Redesigned-cycle attempt 3. Correct only the helper-definition order defect in
# D01-016; experiment semantics, numeric values, observer placement, and frozen
# Gates A-J remain unchanged and unscored in this preflight.
SRC="lab-jobs/015-d01-redesigned-observer-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/d01-017-preflight.sh"

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
phase_fn = '''set_phase(){\n  local n="$1"\n  halcmd setp mux16.0.sel0 $(( n & 1 ))\n  halcmd setp mux16.0.sel1 $(( (n >> 1) & 1 ))\n  halcmd setp mux16.0.sel2 $(( (n >> 2) & 1 ))\n  halcmd setp mux16.0.sel3 $(( (n >> 3) & 1 ))\n}\n'''
needle = 'trap cleanup EXIT\n'
assert needle in s
s = s.replace(needle, needle + phase_fn, 1)
s, count = re.subn(r'halcmd setp mux16\.0\.sel ([0-9]+)', r'set_phase \1', s)
assert count == 8, count
s = s.replace('== D01 redesigned non-authoritative observer preflight ==',
              '== D01 redesigned non-authoritative observer preflight, attempt 3 ==', 1)
s = s.replace('This run validates topology/order/numerics and the test-only atomic Cartesian observer.',
              'This corrected run validates topology/order/numerics and the test-only atomic Cartesian observer.', 1)
dst.write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'D01-017 correction scope: valid mux16 interface plus phase helper defined before first phase mutation; frozen P0-P8/Gates A-J unchanged and unscored.'
diff -u "$SRC" "$TMP" || true
exec bash "$TMP"
