#!/usr/bin/env bash
set -euo pipefail

# C05-029 attempt 2. Patch only the observation transport of the frozen
# C05-029 implementation: split 23 realtime fields across two sampler FIFOs,
# then exact-join them by tagged sample number before running unchanged gates.

ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/030-c05-scale-jump.sh"
PATCHED="${RUNNER_TEMP:-/tmp}/031-c05-scale-jump-generator.sh"

[[ -f "$BASE" ]] || { echo "HARNESS_INVALID: missing base harness $BASE" >&2; exit 90; }

python3 - "$BASE" "$PATCHED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()

def one(old,new,label):
    global s
    n=s.count(old)
    if n != 1:
        raise SystemExit(f'HARNESS_INVALID: patch anchor {label} count={n}')
    s=s.replace(old,new)

one('TMP="${RUNNER_TEMP:-/tmp}/030-c05-scale-jump-body.sh"',
    'TMP="${RUNNER_TEMP:-/tmp}/031-c05-scale-jump-body.sh"', 'tmp')

# LinuxCNC streams carry at most twenty values per sample. Preserve every
# frozen field by splitting 20 floats + (1 float,2 bits) across two FIFOs.
one('loadrt sampler depth=50000 cfg=fffffffffffffffffffffbb',
    'loadrt sampler depth=50000,50000 cfg=ffffffffffffffffffff,fbb', 'sampler-config')
one('addf sampler.0 servo-thread',
    'addf sampler.0 servo-thread\naddf sampler.1 servo-thread', 'sampler-addf')
one('sampler.0.pin.20', 'sampler.1.pin.0', 'secondary-float')
one('sampler.0.pin.21', 'sampler.1.pin.1', 'secondary-sel0')
one('sampler.0.pin.22', 'sampler.1.pin.2', 'secondary-sel1')

# Make the frozen analyzer require both FIFO overrun counters.
one("OVERRUNS=\"$OVERRUNS\" TRACE=c05-029-realtime.txt python3 - <<'PY'",
    "OVERRUNS=\"$OVERRUNS\" OVERRUNS_B=\"$OVERRUNS_B\" TRACE=c05-029-realtime.txt python3 - <<'PY'", 'analyzer-env')
one("if int(float(os.environ['OVERRUNS'])) != 0:\n    print('HARNESS_INVALID: sampler overruns nonzero',file=sys.stderr); sys.exit(30)",
    "if int(float(os.environ['OVERRUNS'])) != 0 or int(float(os.environ['OVERRUNS_B'])) != 0:\n    print('HARNESS_INVALID: sampler overruns nonzero',file=sys.stderr); sys.exit(30)", 'overrun-check')

# Insert source-envelope transformations after phase generation and before
# analyzer replacement. These affect evidence transport only.
anchor="src=src[:phase_start]+phases+src[phase_end:]\n\n# Retain the original evidence-copy envelope, then replace the analyzer tail."
inject=r'''src=src[:phase_start]+phases+src[phase_end:]

# Observation-only split-FIFO correction. FIFO 0 is drained continuously;
# FIFO 1 has depth 50000 and is drained after sampling is disabled. Both are
# retained raw and exact-joined by realtime sample number before analysis.
src=src.replace(
    'rm -f /tmp/linuxcnc.lock c05-linuxcnc.stdout c05-linuxcnc.stderr c05-029-realtime.txt c05-029-halsampler.stderr',
    'rm -f /tmp/linuxcnc.lock c05-linuxcnc.stdout c05-linuxcnc.stderr c05-029-realtime.txt c05-029-realtime-a.txt c05-029-realtime-b.txt c05-029-halsampler.stderr c05-029-halsampler-b.stderr')
src=src.replace(
    'halsampler -c 0 -t >c05-029-realtime.txt 2>c05-029-halsampler.stderr &',
    'halsampler -c 0 -t >c05-029-realtime-a.txt 2>c05-029-halsampler.stderr &')
src=src.replace(
    'OVERRUNS="$(halcmd getp sampler.0.overruns)"',
    'halcmd setp sampler.0.enable false\nhalcmd setp sampler.1.enable false\nOVERRUNS="$(halcmd getp sampler.0.overruns)"\nOVERRUNS_B="$(halcmd getp sampler.1.overruns)"')
join_anchor='''wait "$SAMPLER_PID" 2>/dev/null || true
SAMPLER_PID=""
sleep .1

mkdir -p "$EVID" "$RUN_EVID"'''
join_repl=r'''wait "$SAMPLER_PID" 2>/dev/null || true
SAMPLER_PID=""
sleep .1

# Drain secondary FIFO after both sampler functions have been disabled.
SECONDARY_COUNT="$(halcmd getp sampler.1.sample-num)"
[[ "$SECONDARY_COUNT" =~ ^[0-9]+$ ]] || { echo "HARNESS_INVALID: bad sampler.1 sample count $SECONDARY_COUNT" >&2; exit 25; }
halsampler -c 1 -n "$SECONDARY_COUNT" -t >c05-029-realtime-b.txt 2>c05-029-halsampler-b.stderr

# Exact same-cycle join. No interpolation, nearest-neighbor matching, row
# deletion, or post-hoc relabeling is allowed.
python3 - c05-029-realtime-a.txt c05-029-realtime-b.txt c05-029-realtime.txt <<'PYJOIN'
from pathlib import Path
import sys

def load(path, expected_cols):
    out={}
    for line in Path(path).read_text(errors='replace').splitlines():
        p=line.split()
        if len(p) != expected_cols: continue
        try: n=int(p[0])
        except ValueError: continue
        if n in out: raise SystemExit(f'HARNESS_INVALID: duplicate sample {n} in {path}')
        out[n]=p[1:]
    return out

a=load(sys.argv[1],21)   # sample number + 20 floats
b=load(sys.argv[2],4)    # sample number + float + 2 bits
if not a or not b:
    raise SystemExit('HARNESS_INVALID: split sampler trace empty')
if set(a) != set(b):
    only_a=sorted(set(a)-set(b))[:10]; only_b=sorted(set(b)-set(a))[:10]
    raise SystemExit(f'HARNESS_INVALID: split sampler sample sets differ onlyA={only_a} onlyB={only_b}')
nums=sorted(a)
if any(y != x+1 for x,y in zip(nums,nums[1:])):
    raise SystemExit('HARNESS_INVALID: split sampler joined sample numbers are not consecutive')
with open(sys.argv[3],'w') as f:
    for n in nums:
        f.write(' '.join([str(n),*a[n],*b[n]])+'\n')
print(f'split-sampler-exact-join=PASS rows={len(nums)} first={nums[0]} last={nums[-1]}')
PYJOIN

mkdir -p "$EVID" "$RUN_EVID"'''
if join_anchor not in src:
    raise SystemExit('HARNESS_INVALID: join insertion anchor missing')
src=src.replace(join_anchor,join_repl,1)
src=src.replace(
    'for f in c05-029-realtime.txt c05-linuxcnc.stdout c05-linuxcnc.stderr c05-029-halsampler.stderr; do',
    'for f in c05-029-realtime.txt c05-029-realtime-a.txt c05-029-realtime-b.txt c05-linuxcnc.stdout c05-linuxcnc.stderr c05-029-halsampler.stderr c05-029-halsampler-b.stderr; do')

# Retain the original evidence-copy envelope, then replace the analyzer tail.'''
if anchor not in s:
    raise SystemExit('HARNESS_INVALID: generator injection anchor missing')
s=s.replace(anchor,inject,1)

# The cleanup trap must retain both raw traces even on failure before analysis.
s=s.replace(
    'for f in c05-029-realtime.txt c05-linuxcnc.stdout c05-linuxcnc.stderr c05-029-halsampler.stderr; do',
    'for f in c05-029-realtime.txt c05-029-realtime-a.txt c05-029-realtime-b.txt c05-linuxcnc.stdout c05-linuxcnc.stderr c05-029-halsampler.stderr c05-029-halsampler-b.stderr; do')

Path(sys.argv[2]).write_text(s)
PY

chmod +x "$PATCHED"
printf '%s\n' 'C05-029 attempt-2 correction=split sampler transport only; frozen Gates A-H unchanged.'
printf 'base-harness-sha256=%s\n' "$(sha256sum "$BASE" | awk '{print $1}')"
printf 'patched-generator-sha256=%s\n' "$(sha256sum "$PATCHED" | awk '{print $1}')"
exec bash "$PATCHED"
