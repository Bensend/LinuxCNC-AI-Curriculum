#!/usr/bin/env bash
set -euo pipefail

# C05-029 materially redesigned observation transport after retirement of the
# split-FIFO family. Start from the original frozen-behavior implementation and
# change only observation transport: 20 primitive fields in one sampler FIFO;
# Gate-G residuals are recomputed from those same-cycle primitives offline.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/030-c05-scale-jump.sh"
TMP="${RUNNER_TEMP:-/tmp}/037-c05-scale-jump-single-atomic-sampler.sh"

[[ -f "$BASE" ]] || { echo "HARNESS_INVALID: missing $BASE" >&2; exit 90; }
[[ -f "$ROOT/lab-jobs/028-c05-feedback-freeze.sh" ]] || { echo "HARNESS_INVALID: missing inherited 028 source" >&2; exit 90; }

python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

def one(old,new,label):
    global s
    n=s.count(old)
    if n != 1:
        raise SystemExit(f'HARNESS_INVALID: 037 patch {label} count={n}')
    s=s.replace(old,new,1)

# Pinned HAL_STREAM_MAX_PINS=21. Keep 18 float primitives + 2 selector bits
# in one FIFO (20 configured pins); sample number comes from halsampler -t.
one('loadrt sampler depth=50000 cfg=fffffffffffffffffffffbb',
    'loadrt sampler depth=50000 cfg=ffffffffffffffffffbb',
    'single-fifo-config')

# Move selector bits into the two final fields of the one FIFO.
one('net c05-sel0 => c05-sensor-b.sel0 sampler.0.pin.21',
    'net c05-sel0 => c05-sensor-b.sel0 sampler.0.pin.18',
    'sel0-index')
one('net c05-sel1 => c05-sensor-b.sel1 sampler.0.pin.22',
    'net c05-sel1 => c05-sensor-b.sel1 sampler.0.pin.19',
    'sel1-index')

# The three residual helper outputs are algebraically redundant transport
# fields. Keep the realtime helper calculations, but do not sample their
# outputs; Gate G is computed from the atomically sampled operands.
one('net c05-residual-d c05-resid-d.out => sampler.0.pin.18',
    'net c05-residual-d c05-resid-d.out',
    'drop-residual-d-pin')
one('net c05-residual-c c05-resid-c.out => sampler.0.pin.19',
    'net c05-residual-c c05-resid-c.out',
    'drop-residual-c-pin')
one('net c05-residual-err-b c05-resid-err-b.out => sampler.0.pin.20',
    'net c05-residual-err-b c05-resid-err-b.out',
    'drop-residual-err-pin')

# Parse one sample-number column + 20 data columns. Primitive tuple indexes are
# unchanged through Kc; selector bits become indexes 19 and 20.
one('if len(p)<24: continue', 'if len(p)<21: continue', 'row-width')
one('n=int(p[0]); vals=list(map(float,p[1:22])); sel0=int(p[22]); sel1=int(p[23])',
    'n=int(p[0]); vals=list(map(float,p[1:19])); sel0=int(p[19]); sel1=int(p[20])',
    'row-parse')
one('# 18 Kc; 19 residD; 20 residC; 21 residErr; 22 sel0; 23 sel1.',
    '# 18 Kc; 19 sel0; 20 sel1. Gate-G residuals are derived offline from this atomic row.',
    'tuple-comment')
one('def mode(r): return (r[23]<<1)|r[22]',
    'def mode(r): return (r[20]<<1)|r[19]',
    'mode-index')

# Preserve the frozen Gate-G equations/thresholds, but evaluate them directly
# from same-row primitives instead of redundant sampled residual-helper pins.
one("resD=mx(fault,lambda r:r[19]); resC=mx(fault,lambda r:r[20]); resE=mx(fault,lambda r:r[21])",
    "resD=mx(fault,lambda r:r[8]-(r[7]-r[2])); resC=mx(fault,lambda r:r[9]-r[18]*r[8]); resE=mx(fault,lambda r:r[14]-(r[11]-r[7]))",
    'gate-g-derived-residuals')

Path(sys.argv[2]).write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'C05-029 materially redesigned attempt: one 20-pin realtime sampler FIFO; no split stream/join; frozen Gates A-H and all behavioral values unchanged.'
printf '%s\n' 'Observation note: Gate-G residuals are calculated offline only from primitives in the same atomic FIFO row.'
printf 'base-030-sha256=%s\n' "$(sha256sum "$BASE" | awk '{print $1}')"
printf 'patched-037-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
