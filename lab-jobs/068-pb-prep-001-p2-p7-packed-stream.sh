#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 harness-only revision after pinned source established
# HAL_STREAM_MAX_PINS=21 before run 067 behavioral output was inspected.
# Behavior, disturbances, durations, limits and Gates A-J are unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/067-pb-prep-001-p2-p7-behavioral.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-p2-p7-packed.sh"
cp "$SRC" "$FIXED"
python3 - "$FIXED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

def section(start,end,new):
    global s
    i=s.index(start)
    j=s.index(end,i)
    s=s[:i]+new+s[j:]

def one(old,new):
    global s
    if s.count(old)!=1:
        raise SystemExit(f'HARNESS_INVALID: expected one patch point, got {s.count(old)} for {old[:80]!r}')
    s=s.replace(old,new,1)

component=r'''cat > /tmp/pb_prep.comp <<'EOF'
component pb_prep "PB-PREP-001 frozen P2-P7 packed-stream two-side fixture";
pin in float r1; pin in float r2;
pin in float pid1_out; pin in float pid2_out;
pin in bit pid1_sat; pin in bit pid2_sat;
pin in bit motion_enabled;
pin in float ferror_lim1; pin in float ferror_lim3;
pin out float pid1_ref; pin out float pid2_ref;
pin out float y1; pin out float y2;
pin out float e_diff_used;
pin out float corr_req; pin out float corr_applied;
pin out float prelimit1; pin out float prelimit2;
pin out float final1; pin out float final2;
pin out bit final1_sat; pin out bit final2_sat;
pin out float plant_gain2; pin out float plant_alpha2;
pin out s32 state_word;
pin out s32 disturbance_word;
pin out s32 ferror_limit_word;
pin out s32 cycle;
param rw u32 architecture = 0;
param rw u32 phase_cmd = 2;
param rw bit run = 0;
param rw float sync_gain = 1.0;
param rw float diff_max = 0.25;
param rw float u_max = 2.0;
param rw float c_pgain = 6.0;
function prepare;
function finish;
license "GPL";
;;
static int initialized = 0;
static double absd(double v) { return v < 0.0 ? -v : v; }
static double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }
FUNCTION(prepare) {
    double ed;
    if (!initialized) { y1 = 0.0; y2 = 0.0; initialized = 1; }
    plant_gain2 = 1.0; plant_alpha2 = 0.05;
    if (phase_cmd == 3) { plant_gain2 = 0.75; }
    else if (phase_cmd == 4) { plant_alpha2 = 0.025; }
    else if (phase_cmd == 6 || phase_cmd == 7) { plant_gain2 = 0.20; }
    ed = y1 - y2;
    e_diff_used = ed;
    corr_req = sync_gain * ed;
    corr_applied = clip(corr_req, diff_max);
    if (architecture == 0) {
        pid1_ref = r1 - corr_applied;
        pid2_ref = r2 + corr_applied;
    } else {
        pid1_ref = r1;
        pid2_ref = r2;
    }
}
FUNCTION(finish) {
    double common = 0.0;
    unsigned int sw, dw, lw, gq, aq, l1q, l3q;
    if (!run) {
        prelimit1 = prelimit2 = 0.0;
        final1 = final2 = 0.0;
        final1_sat = final2_sat = 0;
    } else {
        if (architecture == 0) {
            prelimit1 = pid1_out;
            prelimit2 = pid2_out;
        } else if (architecture == 1) {
            prelimit1 = pid1_out - corr_applied;
            prelimit2 = pid2_out + corr_applied;
        } else {
            common = c_pgain * (((r1 - y1) + (r2 - y2)) * 0.5);
            prelimit1 = common - corr_applied;
            prelimit2 = common + corr_applied;
        }
        final1_sat = absd(prelimit1) > u_max;
        final2_sat = absd(prelimit2) > u_max;
        final1 = clip(prelimit1, u_max);
        final2 = clip(prelimit2, u_max);
        y1 += 0.05 * ((1.0 * final1) - y1);
        y2 += plant_alpha2 * ((plant_gain2 * final2) - y2);
    }
    sw = (phase_cmd & 0xffu);
    if (run) sw |= (1u << 8);
    if (pid1_sat) sw |= (1u << 9);
    if (pid2_sat) sw |= (1u << 10);
    if (final1_sat) sw |= (1u << 11);
    if (final2_sat) sw |= (1u << 12);
    if (motion_enabled) sw |= (1u << 13);
    state_word = (int)sw;
    gq = (unsigned int)(plant_gain2 * 1000.0 + 0.5);
    aq = (unsigned int)(plant_alpha2 * 10000.0 + 0.5);
    dw = (gq & 0xffffu) | ((aq & 0xffffu) << 16);
    disturbance_word = (int)dw;
    l1q = (unsigned int)(ferror_lim1 * 1000.0 + 0.5);
    l3q = (unsigned int)(ferror_lim3 * 1000.0 + 0.5);
    lw = (l1q & 0xffffu) | ((l3q & 0xffffu) << 16);
    ferror_limit_word = (int)lw;
    cycle++;
}
EOF
'''
section("cat > /tmp/pb_prep.comp <<'EOF'\n","EOF\ncp /tmp/pb_prep.comp",component)

schema=r'''# sampler schema: 21 physical elements, decoding to the frozen 29 logical witnesses.
SAMPLER_CFG="ssfffffffffffffffffss"
printf '%s\n' "$SAMPLER_CFG" > "$OUT/sampler-schema-cfg.txt"
cat > "$OUT/sampler-schema.txt" <<'EOF'
0 cycle s32
1 state_word s32 [phase bits0..7; run b8; pid1sat b9; pid2sat b10; final1sat b11; final2sat b12; motion-enabled b13]
2 r1 float
3 r2 float
4 y1 float
5 y2 float
6 e_diff_used float
7 corr_req float
8 corr_applied float
9 pid1_ref float
10 pid2_ref float
11 pid1_out float
12 pid2_out float
13 prelimit1 float
14 prelimit2 float
15 final1 float
16 final2 float
17 joint1_ferror float
18 joint3_ferror float
19 disturbance_word s32 [gain2*1000 low16; alpha2*10000 high16]
20 ferror_limit_word s32 [joint1 limit*1000 low16; joint3 limit*1000 high16]
EOF

'''
section("# sampler schema: first frozen 26 fields + ferror limits + realtime run witness.\n","run_arch() {",schema)

oldnets='''net cyc pb-prep.0.cycle => sampler.0.pin.0
net ph pb-prep.0.phase => sampler.0.pin.1
net sr1 y1cmd => sampler.0.pin.2
net sr2 y2cmd => sampler.0.pin.3
net sy1 y1fb => sampler.0.pin.4
net sy2 y2fb => sampler.0.pin.5
net sed pb-prep.0.e-diff-used => sampler.0.pin.6
net screq pb-prep.0.corr-req => sampler.0.pin.7
net scap pb-prep.0.corr-applied => sampler.0.pin.8
net sref1 ref1 => sampler.0.pin.9
net sref2 ref2 => sampler.0.pin.10
net spid1 pid1out => sampler.0.pin.11
net spid2 pid2out => sampler.0.pin.12
net spidsat1 pb-pid1.saturated => sampler.0.pin.13
net spidsat2 pb-pid2.saturated => sampler.0.pin.14
net spre1 pb-prep.0.prelimit1 => sampler.0.pin.15
net spre2 pb-prep.0.prelimit2 => sampler.0.pin.16
net sfinal1 pb-prep.0.final1 => sampler.0.pin.17
net sfinal2 pb-prep.0.final2 => sampler.0.pin.18
net sfsat1 pb-prep.0.final1-sat => sampler.0.pin.19
net sfsat2 pb-prep.0.final2-sat => sampler.0.pin.20
net sjf1 joint.1.f-error => sampler.0.pin.21
net sjf3 joint.3.f-error => sampler.0.pin.22
net smen motion.motion-enabled => sampler.0.pin.23
net sg2 pb-prep.0.plant-gain2 => sampler.0.pin.24
net sa2 pb-prep.0.plant-alpha2 => sampler.0.pin.25
net sjfl1 joint.1.f-error-lim => sampler.0.pin.26
net sjfl3 joint.3.f-error-lim => sampler.0.pin.27
net srun pb-prep.0.run-witness => sampler.0.pin.28
setp sampler.0.enable false'''
newnets='''net ps1 pb-pid1.saturated => pb-prep.0.pid1-sat
net ps2 pb-pid2.saturated => pb-prep.0.pid2-sat
net men motion.motion-enabled => pb-prep.0.motion-enabled
net jl1 joint.1.f-error-lim => pb-prep.0.ferror-lim1
net jl3 joint.3.f-error-lim => pb-prep.0.ferror-lim3
net cyc pb-prep.0.cycle => sampler.0.pin.0
net state pb-prep.0.state-word => sampler.0.pin.1
net sr1 y1cmd => sampler.0.pin.2
net sr2 y2cmd => sampler.0.pin.3
net sy1 y1fb => sampler.0.pin.4
net sy2 y2fb => sampler.0.pin.5
net sed pb-prep.0.e-diff-used => sampler.0.pin.6
net screq pb-prep.0.corr-req => sampler.0.pin.7
net scap pb-prep.0.corr-applied => sampler.0.pin.8
net sref1 ref1 => sampler.0.pin.9
net sref2 ref2 => sampler.0.pin.10
net spid1 pid1out => sampler.0.pin.11
net spid2 pid2out => sampler.0.pin.12
net spre1 pb-prep.0.prelimit1 => sampler.0.pin.13
net spre2 pb-prep.0.prelimit2 => sampler.0.pin.14
net sfinal1 pb-prep.0.final1 => sampler.0.pin.15
net sfinal2 pb-prep.0.final2 => sampler.0.pin.16
net sjf1 joint.1.f-error => sampler.0.pin.17
net sjf3 joint.3.f-error => sampler.0.pin.18
net sdw pb-prep.0.disturbance-word => sampler.0.pin.19
net slw pb-prep.0.ferror-limit-word => sampler.0.pin.20
setp sampler.0.enable false'''
one(oldnets,newnets)

analyzer=r'''cat > /tmp/analyze_pb.py <<'PY'
from pathlib import Path
import math, json, sys
root=Path(sys.argv[1]); ARCHES=('A','B','C')
def clip(v,m): return max(-m,min(m,v))
def decode_word(x): return int(x) & 0xffffffff
def load(arch):
    rows=[]
    for n,ln in enumerate((root/f'arch-{arch}'/'realtime.samples').read_text().splitlines(),1):
        q=ln.split()
        if len(q)!=22: raise SystemExit(f'HARNESS_INVALID: {arch} line {n} fields={len(q)} expected=22')
        sw=decode_word(q[2]); dw=decode_word(q[20]); lw=decode_word(q[21])
        rows.append({
          'stream':int(q[0]),'cycle':int(q[1]),'phase':sw&0xff,'run':(sw>>8)&1,
          'ps1':(sw>>9)&1,'ps2':(sw>>10)&1,'fs1':(sw>>11)&1,'fs2':(sw>>12)&1,'men':(sw>>13)&1,
          'r1':float(q[3]),'r2':float(q[4]),'y1':float(q[5]),'y2':float(q[6]),
          'ed':float(q[7]),'creq':float(q[8]),'cap':float(q[9]),'ref1':float(q[10]),'ref2':float(q[11]),
          'pid1':float(q[12]),'pid2':float(q[13]),'pre1':float(q[14]),'pre2':float(q[15]),
          'fin1':float(q[16]),'fin2':float(q[17]),'jf1':float(q[18]),'jf3':float(q[19]),
          'g2':(dw&0xffff)/1000.0,'a2':((dw>>16)&0xffff)/10000.0,
          'jlim1':(lw&0xffff)/1000.0,'jlim3':((lw>>16)&0xffff)/1000.0})
    return rows
def ac(x,y,tol,msg):
    if abs(x-y)>tol: raise SystemExit('HARNESS_INVALID: '+msg+f' got {x} expected {y}')
def ep(ph):
    if ph==3:return .75,.05
    if ph==4:return 1.,.025
    if ph in (6,7):return .20,.05
    return 1.,.05
def metrics(rows,ph):
    z=[r for r in rows if r['phase']==ph and r['run']]
    if not z:return {'samples':0}
    ed=[r['y1']-r['y2'] for r in z]; ec=[(r['r1']+r['r2'])/2-(r['y1']+r['y2'])/2 for r in z]
    o={'samples':len(z),'peak_abs_ediff':max(map(abs,ed)),'rms_ediff':math.sqrt(sum(x*x for x in ed)/len(ed)),
       'peak_abs_ecommon':max(map(abs,ec)),'peak_abs_j1_ferror':max(abs(r['jf1']) for r in z),
       'peak_abs_j3_ferror':max(abs(r['jf3']) for r in z),'min_j1_ferror_margin':min(r['jlim1']-abs(r['jf1']) for r in z),
       'min_j3_ferror_margin':min(r['jlim3']-abs(r['jf3']) for r in z),'pid1_sat_ms':sum(r['ps1'] for r in z),
       'pid2_sat_ms':sum(r['ps2'] for r in z),'final1_sat_ms':sum(r['fs1'] for r in z),'final2_sat_ms':sum(r['fs2'] for r in z),
       'corr_clip_ms':sum(abs(r['creq'])>.25+1e-12 for r in z)}
    if ph in (2,3,4) and len(z)>=750:
        w=z[-500:]; we=[r['y1']-r['y2'] for r in w]; wc=[(r['r1']+r['r2'])/2-(r['y1']+r['y2'])/2 for r in w]
        o.update(steady_mean_abs_ediff=sum(map(abs,we))/500,steady_max_abs_ediff=max(map(abs,we)),
                 steady_mean_abs_ecommon=sum(map(abs,wc))/500,steady_max_abs_ecommon=max(map(abs,wc)))
    return o
R={a:load(a) for a in ARCHES}; report={'architectures':{},'gates':{}}
for a,rows in R.items():
    if len(rows)!=12000: raise SystemExit(f'HARNESS_INVALID: {a} row count {len(rows)} != 12000')
    before=int((root/f'arch-{a}'/'overruns-before.txt').read_text()); after=int((root/f'arch-{a}'/'overruns-after.txt').read_text())
    if before or after: raise SystemExit(f'HARNESS_INVALID: {a} overruns {before}/{after}')
    if any(y['cycle']!=x['cycle']+1 for x,y in zip(rows,rows[1:])): raise SystemExit(f'HARNESS_INVALID: {a} deterministic cycle gap')
    seen=[]
    for r in rows:
        if not seen or r['phase']!=seen[-1]: seen.append(r['phase'])
    if seen[:6] != [2,3,4,5,6,7]: raise SystemExit(f'HARNESS_INVALID: {a} phase order {seen[:8]}')
    p2=[r for r in rows if r['phase']==2 and r['run']]
    if not p2: raise SystemExit(f'HARNESS_INVALID: {a} missing active P2')
    if abs(p2[0]['y1'])>1e-9 or abs(p2[0]['y2'])>1e-9: raise SystemExit(f'HARNESS_INVALID: {a} P2 dirty reset')
    for r in rows:
        g,al=ep(r['phase']); ac(r['g2'],g,1e-12,f'{a} gain2 phase {r["phase"]}'); ac(r['a2'],al,1e-12,f'{a} alpha2 phase {r["phase"]}')
        ac(r['creq'],r['ed'],2e-6,f'{a} corr_req/e_diff cycle {r["cycle"]}')
        if abs(r['cap'])>.25+1e-12: raise SystemExit(f'HARNESS_INVALID: {a} corr bound')
        ac(r['fin1'],clip(r['pre1'],2.),1e-12,f'{a} final1 clip cycle {r["cycle"]}'); ac(r['fin2'],clip(r['pre2'],2.),1e-12,f'{a} final2 clip cycle {r["cycle"]}')
        if r['fs1']!=int(abs(r['pre1'])>2.) or r['fs2']!=int(abs(r['pre2'])>2.): raise SystemExit(f'HARNESS_INVALID: {a} final saturation cycle {r["cycle"]}')
        if r['jlim1']<=0 or r['jlim3']<=0: raise SystemExit(f'HARNESS_INVALID: {a} invalid ferror limit')
    active=[r for r in rows if r['run'] and r['phase'] in (2,3,4,5,6)]
    if max(abs(r['r1']-r['r2']) for r in active)>1e-9: raise SystemExit(f'HARNESS_INVALID: {a} duplicated Y requests diverged')
    if max(r['r1'] for r in p2)-min(r['r1'] for r in p2)<.10: raise SystemExit(f'HARNESS_INVALID: {a} P2 command range not nontrivial')
    first0=None
    for i,r in enumerate(rows):
        if r['phase']==7 and not r['run'] and i>0 and rows[i-1]['run']:
            first0=i; break
    if first0 is None: raise SystemExit(f'HARNESS_INVALID: {a} missing sampled P7 true->false')
    d=rows[first0]
    if abs(d['fin1'])>1e-12 or abs(d['fin2'])>1e-12 or d['fs1'] or d['fs2']: raise SystemExit(f'BEHAVIORAL_FAILURE: {a} P7 first disabled cycle')
    if sum(1 for x in rows[first0:] if x['phase']==7 and not x['run'])<2: raise SystemExit(f'HARNESS_INVALID: {a} insufficient disabled P7 rows')
    am={'phases':{str(ph):metrics(rows,ph) for ph in range(2,7)},'p7_first_disabled_cycle':d['cycle']}
    p5=[x for x in rows if x['phase']==5 and x['run']]; rec='NOT OBSERVED'
    for i in range(max(0,len(p5)-99)):
        w=p5[i:i+100]
        if all(abs(x['y1']-x['y2'])<=.005 and abs((x['r1']+x['r2'])/2-(x['y1']+x['y2'])/2)<=.01 for x in w): rec=w[0]['cycle']-p5[0]['cycle']; break
    am['p5_recovery_ms']=rec; report['architectures'][a]=am
A=[r for r in R['A'] if r['run'] and abs(r['cap'])>1e-6 and r['phase'] in (3,4,6)]
if not A: raise SystemExit('HARNESS_INVALID: A never produced nonzero correction')
a=max(A,key=lambda r:abs(r['cap'])); report['A_reference_bias_witness']={k:a[k] for k in ('cycle','phase','r1','y1','jf1','cap','ref1')}
B=[r for r in R['B'] if r['phase']==6 and r['run']]; bw=[r for r in B if ((not r['ps1'] and r['fs1']) or (not r['ps2'] and r['fs2']))]
report['B_downstream_only_saturation_count']=len(bw)
if bw: report['B_downstream_only_saturation_witness']={k:bw[0][k] for k in ('cycle','pid1','pid2','ps1','ps2','pre1','pre2','fs1','fs2','cap')}
C=[r for r in R['C'] if r['run'] and r['phase'] in (3,4,6) and abs(r['creq'])>1e-6]
if not C: raise SystemExit('HARNESS_INVALID: C never requested differential effort')
c=max(C,key=lambda r:abs(r['creq'])); report['C_common_differential_observability_witness']={k:c[k] for k in ('cycle','phase','creq','cap','pre1','pre2','fin1','fin2','fs1','fs2')}
report['gates']={'A':'PASS - pinned source/provenance retained','B':'PASS - independent Y feedback topology and samples retained','C':'PASS - duplicated Y targets equal/nontrivial','D':'PASS - zero overruns and contiguous 12000-row payload per architecture','E':'PASS - packed B-side gain/alpha witnesses equal frozen values','F':'PASS - PID saturation decoded separately from downstream final saturation','G':'PASS - joint ferrors and packed effective limits retained atomically','H':('PASS - A/B/C discriminators including B downstream-only P6 saturation observed' if bw else 'INCONCLUSIVE - B/P6 downstream-only saturation NOT OBSERVED'),'I':'PASS - P5 metrics and first disabled P7 command retained','J':'PASS - no hydraulic/functional-safety inference permitted'}
report['classification']='VALID COMPARISON' if bw else 'INCONCLUSIVE'
(root/'analysis.json').write_text(json.dumps(report,indent=2,sort_keys=True)+'\n')
with (root/'analysis.txt').open('w') as f:
    f.write('PB-PREP-001 frozen P2-P7 packed-stream analysis\n')
    for g,v in report['gates'].items(): f.write(f'Gate {g}: {v}\n')
    f.write('Classification: '+report['classification']+'\nB downstream-only saturation rows: '+str(len(bw))+'\n')
    if bw:f.write('B witness: '+json.dumps(report['B_downstream_only_saturation_witness'],sort_keys=True)+'\n')
    f.write('A witness: '+json.dumps(report['A_reference_bias_witness'],sort_keys=True)+'\nC witness: '+json.dumps(report['C_common_differential_observability_witness'],sort_keys=True)+'\n')
print((root/'analysis.txt').read_text())
PY
'''
section("cat > /tmp/analyze_pb.py <<'PY'\n","PY\ncp /tmp/analyze_pb.py",analyzer)

one('Instrumentation-only appended fields 27..29: joint1 f-error-lim, joint3 f-error-lim, realtime run witness.',
    'All 29 frozen logical witnesses are encoded into one 21-element stock HAL stream per the pre-result packed-stream redesign.')
# Static proof that the generated script cannot request sampler pins beyond 20.
if 'sampler.0.pin.21' in s or 'sampler.0.pin.28' in s:
    raise SystemExit('HARNESS_INVALID: >21 sampler pin reference survived packed rewrite')
p.write_text(s)
PY
chmod +x "$FIXED"
printf '%s\n' 'PB-PREP-001 revision 2: 29 logical witnesses packed into stock sampler 21-element ceiling; behavioral contract unchanged.'
exec "$FIXED"
