#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 construction/preflight correction after 058 exposed a temporal
# ambiguity: correction is computed in prepare() from pre-plant feedback, but
# y1/y2 are sampled after finish() updates the plant. Record the exact e_diff
# consumed by the correction law so command/state causality is explicit.
# Frozen plant/controller constants and P0/P1-only classification are unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/056-pb-prep-001-y1y2-preflight.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-preflight-fixed3.sh"
cp "$SRC" "$FIXED"
python3 - "$FIXED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

def one(a,b):
    global s
    if s.count(a)!=1: raise SystemExit(f'HARNESS_INVALID: expected exactly one occurrence: {a!r}, got {s.count(a)}')
    s=s.replace(a,b,1)

# 057 compile fix.
one('#include <math.h>\nstatic int initialized = 0;\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }',
    'static int initialized = 0;\nstatic double absd(double v) { return v < 0.0 ? -v : v; }\nstatic double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }')
one('fabs(u1) > u_max','absd(u1) > u_max')
one('fabs(u2) > u_max','absd(u2) > u_max')

# Add a causal-state witness generated in the same prepare() invocation as corr_req.
one('pin out float corr_req; pin out float corr_applied;', 'pin out float e_diff_used;\npin out float corr_req; pin out float corr_applied;')
one('    ed = y1 - y2;\n    corr_req = sync_gain * ed;', '    ed = y1 - y2;\n    e_diff_used = ed;\n    corr_req = sync_gain * ed;')

# 058 non-invasive sampler attachment fix plus shifted payload for e_diff_used.
one('loadrt sampler depth=$DEPTH cfg=ssffffffffffffbb','loadrt sampler depth=$DEPTH cfg=ssfffffffffffffbb')
repls={
'net sr1 pb-prep.0.r1 => sampler.0.pin.2':'net y1cmd => sampler.0.pin.2',
'net sr2 pb-prep.0.r2 => sampler.0.pin.3':'net y2cmd => sampler.0.pin.3',
'net sy1 pb-prep.0.y1 => sampler.0.pin.4':'net y1fb => sampler.0.pin.4',
'net sy2 pb-prep.0.y2 => sampler.0.pin.5':'net y2fb => sampler.0.pin.5',
'net screq pb-prep.0.corr-req => sampler.0.pin.6':'net sedused pb-prep.0.e-diff-used => sampler.0.pin.6\nnet screq pb-prep.0.corr-req => sampler.0.pin.7',
'net scap pb-prep.0.corr-applied => sampler.0.pin.7':'net scap pb-prep.0.corr-applied => sampler.0.pin.8',
'net sref1 pb-prep.0.pid1-ref => sampler.0.pin.8':'net ref1 => sampler.0.pin.9',
'net sref2 pb-prep.0.pid2-ref => sampler.0.pin.9':'net ref2 => sampler.0.pin.10',
'net spid1 pb-prep.0.pid1-out => sampler.0.pin.10':'net pid1out => sampler.0.pin.11',
'net spid2 pb-prep.0.pid2-out => sampler.0.pin.11':'net pid2out => sampler.0.pin.12',
'net sfinal1 pb-prep.0.final1 => sampler.0.pin.12':'net sfinal1 pb-prep.0.final1 => sampler.0.pin.13',
'net sfinal2 pb-prep.0.final2 => sampler.0.pin.13':'net sfinal2 pb-prep.0.final2 => sampler.0.pin.14',
'net ssat1 pb-prep.0.final1-sat => sampler.0.pin.14':'net ssat1 pb-prep.0.final1-sat => sampler.0.pin.15',
'net ssat2 pb-prep.0.final2-sat => sampler.0.pin.15':'net ssat2 pb-prep.0.final2-sat => sampler.0.pin.16',
}
for a,b in repls.items(): one(a,b)

# Replace the analysis block's parser/schema and sign discriminator.
one("if len(p)<17: continue", "if len(p)<18: continue")
one("stream=int(p[0]); cyc=int(p[1]); phase=int(p[2]); f=list(map(float,p[3:15])); sat1=int(p[15]); sat2=int(p[16])",
    "stream=int(p[0]); cyc=int(p[1]); phase=int(p[2]); f=list(map(float,p[3:16])); sat1=int(p[16]); sat2=int(p[17])")
one("# tuple after first 3: r1,r2,y1,y2,corr_req,corr_applied,ref1,ref2,pid1,pid2,final1,final2,sat1,sat2",
    "# tuple after first 3: r1,r2,y1_post,y2_post,e_diff_used,corr_req,corr_applied,ref1,ref2,pid1,pid2,final1,final2,sat1,sat2")
old='''# Proven sign discriminator from early positive y1-y2 seed.\nsign=None\nfor r in active[:500]:\n    r1,r2,y1,y2,creq,cap,ref1,ref2,pid1,pid2,fin1,fin2=r[3:15]\n    if y1-y2 > 0.005 and abs(cap)>1e-5:\n        sign=(y1-y2,creq,cap,ref1,ref2,fin1,fin2); break\nif sign is None: print('HARNESS_INVALID: sign seed not observed',file=sys.stderr); sys.exit(43)\ned,creq,cap,ref1,ref2,fin1,fin2=sign\nprint(f'sign-row e_diff={ed:.9f} corr_req={creq:.9f} corr_applied={cap:.9f} ref1={ref1:.9f} ref2={ref2:.9f} final1={fin1:.9f} final2={fin2:.9f}')\nif creq<=0 or cap<=0: print('HARNESS_INVALID: positive e_diff did not request positive correction',file=sys.stderr); sys.exit(44)'''
new='''# Proven sign discriminator uses e_diff_used captured in prepare(), not post-update y.\nsign=None\nfor r in active[:500]:\n    r1,r2,y1,y2,edused,creq,cap,ref1,ref2,pid1,pid2,fin1,fin2=r[3:16]\n    if edused > 0.005 and abs(cap)>1e-5:\n        sign=(edused,creq,cap,ref1,ref2,fin1,fin2); break\nif sign is None: print('HARNESS_INVALID: causal sign seed not observed',file=sys.stderr); sys.exit(43)\ned,creq,cap,ref1,ref2,fin1,fin2=sign\nprint(f'sign-row e_diff_used={ed:.9f} corr_req={creq:.9f} corr_applied={cap:.9f} ref1={ref1:.9f} ref2={ref2:.9f} final1={fin1:.9f} final2={fin2:.9f}')\nif abs(creq - 2.0*ed) > 2e-6 or creq<=0 or cap<=0: print('HARNESS_INVALID: causal e_diff/correction relationship wrong',file=sys.stderr); sys.exit(44)'''
one(old,new)
# Remaining metrics indexes: nominal refs unchanged at r[3],r[4]; y post unchanged r[5],r[6].
if '#include <math.h>' in s or 'fabs(' in s: raise SystemExit('HARNESS_INVALID: math dependency survived')
p.write_text(s)
PY
chmod +x "$FIXED"
printf 'PB-PREP-001 correction: explicit causal e_diff_used witness added; frozen control semantics unchanged.\n'
exec "$FIXED"
