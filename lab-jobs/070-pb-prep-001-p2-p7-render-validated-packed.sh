#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 materially redesigned harness-construction cycle after 067-069.
# Behavioral experiment contract remains frozen. This wrapper fixes only known
# source-rendering defects, renders the final behavioral script, performs static
# validation BEFORE the expensive LinuxCNC execution, then executes once.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/068-pb-prep-001-p2-p7-packed-stream.sh"
GEN="${RUNNER_TEMP:-/tmp}/pb-prep-001-070-generator.sh"
cp "$SRC" "$GEN"

python3 - "$GEN" <<'PATCH070'
from pathlib import Path
import sys

p = Path(sys.argv[1])
s = p.read_text()

# 1. Make the OUTER 068 patcher's delimiter unique so the embedded analyzer's
#    legitimate PY terminator cannot terminate the outer shell here-document.
open_old = "python3 - \"$FIXED\" <<'PY'\n"
open_new = "python3 - \"$FIXED\" <<'PYFIX070'\n"
if s.count(open_old) != 1:
    raise SystemExit(f"HARNESS_INVALID: outer PY opener count={s.count(open_old)}")
s = s.replace(open_old, open_new, 1)

close_old = "\nPY\nchmod +x \"$FIXED\"\nprintf '%s\\n' 'PB-PREP-001 revision 2: 29 logical witnesses packed into stock sampler 21-element ceiling; behavioral contract unchanged.'"
close_new = "\nPYFIX070\nchmod +x \"$FIXED\"\nprintf '%s\\n' 'PB-PREP-001 revision 2: 29 logical witnesses packed into stock sampler 21-element ceiling; behavioral contract unchanged.'"
if s.count(close_old) != 1:
    raise SystemExit(f"HARNESS_INVALID: outer PY closer context count={s.count(close_old)}")
s = s.replace(close_old, close_new, 1)

# 2. The 068 section() helper preserves its END marker. Therefore replacement
#    raw strings must NOT also own the same terminal marker. Strip only the
#    final raw-string marker from component/analyzer replacement payloads.
def strip_raw_terminal(varname: str, terminal: str):
    global s
    prefix = varname + "=r'''"
    a = s.index(prefix) + len(prefix)
    b = s.index("\n'''", a)
    body = s[a:b]
    lines = body.splitlines()
    if not lines or lines[-1] != terminal:
        raise SystemExit(f"HARNESS_INVALID: {varname} terminal was {lines[-1] if lines else None!r}, expected {terminal!r}")
    body2 = "\n".join(lines[:-1])
    s = s[:a] + body2 + s[b:]

strip_raw_terminal('component', 'EOF')
strip_raw_terminal('analyzer', 'PY')

# 3. Replace final exec with render validation followed by the same exec.
needle = 'exec "$FIXED"\n'
if s.count(needle) != 1:
    raise SystemExit(f"HARNESS_INVALID: expected one final exec, found {s.count(needle)}")
validation = r'''# Static validation of the fully rendered behavioral script BEFORE LinuxCNC setup.
bash -n "$FIXED"
python3 - "$FIXED" <<'VALIDATE070'
from pathlib import Path
import re, sys
q = Path(sys.argv[1]).read_text()

required = {
    'ROWS=12000': 1,
    'U_MAX=2.0': 1,
    'SYNC_GAIN=1.0': 1,
    'DIFF_MAX=0.25': 1,
    'PGAIN=6.0': 1,
    'SAMPLER_CFG="ssfffffffffffffffffss"': 1,
}
for text, expected in required.items():
    n=q.count(text)
    if n != expected:
        raise SystemExit(f'HARNESS_INVALID: rendered frozen token {text!r} count={n}, expected={expected}')

m=re.search(r'SAMPLER_CFG="([sfu]+)"', q)
if not m or len(m.group(1)) != 21:
    raise SystemExit(f'HARNESS_INVALID: rendered sampler type count={len(m.group(1)) if m else "missing"}')

bad=re.findall(r'sampler\.0\.pin\.(\d+)', q)
bad=[int(x) for x in bad if int(x) >= 21]
if bad:
    raise SystemExit(f'HARNESS_INVALID: rendered sampler pin exceeds 20: {sorted(set(bad))}')

lines=q.splitlines()
for a,b in zip(lines,lines[1:]):
    if a == b and a in {'EOF','PY','PYFIX070'}:
        raise SystemExit(f'HARNESS_INVALID: consecutive duplicate rendered terminator {a}')

for token in (
    "if (phase_cmd == 3) { plant_gain2 = 0.75; }",
    "else if (phase_cmd == 4) { plant_alpha2 = 0.025; }",
    "else if (phase_cmd == 6 || phase_cmd == 7) { plant_gain2 = 0.20; }",
    "report['classification']='VALID COMPARISON' if bw else 'INCONCLUSIVE'",
    "'H':('PASS - A/B/C discriminators including B downstream-only P6 saturation observed' if bw else 'INCONCLUSIVE - B/P6 downstream-only saturation NOT OBSERVED')",
):
    if token not in q:
        raise SystemExit(f'HARNESS_INVALID: rendered frozen contract token missing: {token}')

print('PB-PREP-001 070 rendered-script static validation: PASS')
VALIDATE070
printf '%s\n' 'PB-PREP-001 070 render validation passed; executing unchanged frozen packed behavioral script.'
exec "$FIXED"
'''
s=s.replace(needle,validation,1)

# Generator itself must have exactly one unique outer delimiter pair.
if s.count("<<'PYFIX070'") != 1 or s.count("\nPYFIX070\n") != 1:
    raise SystemExit('HARNESS_INVALID: generator PYFIX070 delimiter pair not unique')
if "cat > /tmp/analyze_pb.py <<'PY'\n" not in s:
    raise SystemExit('HARNESS_INVALID: analyzer inner PY here-document unexpectedly altered')

p.write_text(s)
PATCH070

bash -n "$GEN"
printf '%s\n' 'PB-PREP-001 070 generator syntax validation: PASS'
exec "$GEN"
