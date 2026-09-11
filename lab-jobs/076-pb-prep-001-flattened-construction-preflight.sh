#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 flattened construction PRELIGHT after the explicit 073-075
# three-attempt ESSENTIAL NOW decision. This job operates directly on 068 once,
# renders the final behavioral script, statically audits and retains it, and
# deliberately does NOT execute LinuxCNC behavior.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/068-pb-prep-001-p2-p7-packed-stream.sh"
GEN="${RUNNER_TEMP:-/tmp}/pb-prep-001-076-generator.sh"
EVID="${GITHUB_WORKSPACE:?}/lab-results/pb-prep-001-076-preflight"
mkdir -p "$EVID"
cp "$SRC" "$GEN"

python3 - "$GEN" "$EVID" <<'PATCH076'
from pathlib import Path
import sys
p=Path(sys.argv[1]); evid=Path(sys.argv[2]); s=p.read_text()

# Normalize the OUTER 068 Python here-document so the embedded analyzer's PY
# terminator cannot terminate it.
open_old = "python3 - \"$FIXED\" <<'PY'\n"
if s.count(open_old) != 1:
    raise SystemExit(f'HARNESS_INVALID: 076 outer PY opener count={s.count(open_old)}')
s=s.replace(open_old,"python3 - \"$FIXED\" <<'PY076'\n",1)
close_old = "\nPY\nchmod +x \"$FIXED\"\nprintf '%s\\n' 'PB-PREP-001 revision 2: 29 logical witnesses packed into stock sampler 21-element ceiling; behavioral contract unchanged.'"
if s.count(close_old) != 1:
    raise SystemExit(f'HARNESS_INVALID: 076 outer PY closer context count={s.count(close_old)}')
s=s.replace(close_old,"\nPY076\nchmod +x \"$FIXED\"\nprintf '%s\\n' 'PB-PREP-001 revision 2: 29 logical witnesses packed into stock sampler 21-element ceiling; behavioral contract unchanged.'",1)

# 068 section() preserves the END marker, so replacement raw strings may not
# also own the same final terminal marker.
def strip_raw_terminal(varname, terminal):
    global s
    prefix=varname+"=r'''"
    a=s.index(prefix)+len(prefix)
    b=s.index("\n'''",a)
    body=s[a:b]
    lines=body.splitlines()
    if not lines or lines[-1] != terminal:
        raise SystemExit(f'HARNESS_INVALID: 076 {varname} terminal={lines[-1] if lines else None!r}, expected={terminal!r}')
    s=s[:a]+"\n".join(lines[:-1])+s[b:]
strip_raw_terminal('component','EOF')
strip_raw_terminal('analyzer','PY')

# Structurally edit ONLY the retained 068 newnets literal. In 068, oldnets and
# newnets both close on the same line as their last HAL command.
def raw_block(text,varname):
    marker=varname+"='''"
    a=text.index(marker)+len(marker)
    b=text.index("'''",a)
    return a,b,text[a:b]
old_a,old_b,old_before=raw_block(s,'oldnets')
new_a,new_b,new_before=raw_block(s,'newnets')
if not (old_b < new_a < new_b):
    raise SystemExit(f'HARNESS_INVALID: 076 block ordering old_b={old_b} new_a={new_a} new_b={new_b}')
prefix_through_old=s[:old_b]
pairs=(
 ('net sr1 y1cmd => sampler.0.pin.2','net y1cmd => sampler.0.pin.2'),
 ('net sr2 y2cmd => sampler.0.pin.3','net y2cmd => sampler.0.pin.3'),
 ('net sy1 y1fb => sampler.0.pin.4','net y1fb => sampler.0.pin.4'),
 ('net sy2 y2fb => sampler.0.pin.5','net y2fb => sampler.0.pin.5'),
 ('net sref1 ref1 => sampler.0.pin.9','net ref1 => sampler.0.pin.9'),
 ('net sref2 ref2 => sampler.0.pin.10','net ref2 => sampler.0.pin.10'),
 ('net spid1 pid1out => sampler.0.pin.11','net pid1out => sampler.0.pin.11'),
 ('net spid2 pid2out => sampler.0.pin.12','net pid2out => sampler.0.pin.12'),
)
new_after=new_before
for bad,good in pairs:
    if new_after.count(bad)!=1:
        raise SystemExit(f'HARNESS_INVALID: 076 newnets expected one {bad!r}, found={new_after.count(bad)}')
    new_after=new_after.replace(bad,good,1)
for bad,good in pairs:
    if bad in new_after or new_after.count(good)!=1:
        raise SystemExit(f'HARNESS_INVALID: 076 scoped sampler correction failed for {bad!r}')
s=s[:new_a]+new_after+s[new_b:]
if s[:old_b] != prefix_through_old:
    raise SystemExit('HARNESS_INVALID: 076 bytes through oldnets changed')

# Replace 068's final behavioral exec with final rendered-script validation and
# retention. LinuxCNC must NOT execute in this preflight.
needle='exec "$FIXED"\n'
if s.count(needle)!=1:
    raise SystemExit(f'HARNESS_INVALID: 076 final exec count={s.count(needle)}')
validation=r'''bash -n "$FIXED"
python3 - "$FIXED" <<'VALIDATE076'
from pathlib import Path
import re,sys
q=Path(sys.argv[1]).read_text()
required={
 'ROWS=12000':1,
 'U_MAX=2.0':1,
 'SYNC_GAIN=1.0':1,
 'DIFF_MAX=0.25':1,
 'PGAIN=6.0':1,
 'SAMPLER_CFG="ssfffffffffffffffffss"':1,
}
for text,nexp in required.items():
    n=q.count(text)
    if n!=nexp: raise SystemExit(f'HARNESS_INVALID: 076 rendered frozen token {text!r} count={n} expected={nexp}')
m=re.search(r'SAMPLER_CFG="([sfu]+)"',q)
if not m or len(m.group(1))!=21:
    raise SystemExit(f'HARNESS_INVALID: 076 sampler type count={len(m.group(1)) if m else "missing"}')
badpins=[int(x) for x in re.findall(r'sampler\.0\.pin\.(\d+)',q) if int(x)>=21]
if badpins: raise SystemExit(f'HARNESS_INVALID: 076 sampler pin exceeds 20: {sorted(set(badpins))}')
for bad in (
 'net sr1 y1cmd => sampler.0.pin.2','net sr2 y2cmd => sampler.0.pin.3',
 'net sy1 y1fb => sampler.0.pin.4','net sy2 y2fb => sampler.0.pin.5',
 'net sref1 ref1 => sampler.0.pin.9','net sref2 ref2 => sampler.0.pin.10',
 'net spid1 pid1out => sampler.0.pin.11','net spid2 pid2out => sampler.0.pin.12'):
    if bad in q: raise SystemExit(f'HARNESS_INVALID: 076 rendered invalid sampler tap remains: {bad}')
for good in (
 'net y1cmd => sampler.0.pin.2','net y2cmd => sampler.0.pin.3',
 'net y1fb => sampler.0.pin.4','net y2fb => sampler.0.pin.5',
 'net ref1 => sampler.0.pin.9','net ref2 => sampler.0.pin.10',
 'net pid1out => sampler.0.pin.11','net pid2out => sampler.0.pin.12'):
    if q.count(good)!=1: raise SystemExit(f'HARNESS_INVALID: 076 rendered direct sampler join count !=1: {good}')
for token in (
 "if (phase_cmd == 3) { plant_gain2 = 0.75; }",
 "else if (phase_cmd == 4) { plant_alpha2 = 0.025; }",
 "else if (phase_cmd == 6 || phase_cmd == 7) { plant_gain2 = 0.20; }",
 "report['classification']='VALID COMPARISON' if bw else 'INCONCLUSIVE'",
 "'H':('PASS - A/B/C discriminators including B downstream-only P6 saturation observed' if bw else 'INCONCLUSIVE - B/P6 downstream-only saturation NOT OBSERVED')"):
    if token not in q: raise SystemExit(f'HARNESS_INVALID: 076 frozen contract token missing: {token}')
print('PB-PREP-001 076 fully rendered static validation: PASS')
VALIDATE076
mkdir -p "$GITHUB_WORKSPACE/lab-results/pb-prep-001-076-preflight"
cp "$FIXED" "$GITHUB_WORKSPACE/lab-results/pb-prep-001-076-preflight/behavioral-rendered.sh"
sha256sum "$FIXED" | tee "$GITHUB_WORKSPACE/lab-results/pb-prep-001-076-preflight/behavioral-rendered.sha256"
printf '%s\n' 'PB-PREP-001 076 PRELIGHT PASS: rendered script retained; LinuxCNC behavior deliberately not executed.'
'''
s=s.replace(needle,validation,1)

# Final generator-level invariants before execution of the construction compiler.
if s.count("<<'PY076'")!=1 or s.count("\nPY076\n")!=1:
    raise SystemExit('HARNESS_INVALID: 076 unique outer delimiter pair missing')
if "cat > /tmp/analyze_pb.py <<'PY'\n" not in s:
    raise SystemExit('HARNESS_INVALID: 076 analyzer inner PY unexpectedly altered')
p.write_text(s)
PATCH076

bash -n "$GEN"
printf '%s\n' 'PB-PREP-001 076 flattened construction compiler syntax: PASS'
exec bash "$GEN"
