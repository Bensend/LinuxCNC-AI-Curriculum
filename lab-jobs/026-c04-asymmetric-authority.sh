#!/usr/bin/env bash
set -euo pipefail

# C04-026 implementation. The experiment plan and Gates A-H were frozen before
# this implementation. Reuse the C03 source-grounded fixture and alter only the
# module-specific phase controls, saturation telemetry, and frozen analysis.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
SRC="$ROOT/lab-jobs/025-c03-explicit-cross-coupling.sh"
TMP="${RUNNER_TEMP:-/tmp}/026-c04-asymmetric-authority-inner.sh"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
# Give all generated fixtures/evidence independent C04 names so accepted C03
# evidence is never overwritten.
s=s.replace('c03-025','c04-026').replace('C03-025','C04-026').replace('c03-','c04-').replace('C03CrossCoupling','C04AsymmetricAuthority')
s=s.replace('linuxcnc-c03-cross-coupling','linuxcnc-c04-asymmetric-authority')

old='loadrt sampler depth=40000 cfg=ffffffffffffffff'
new='loadrt sampler depth=40000 cfg=ffffffffffffffffbbsf'
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

old='''net c04-plant-a-gain => c04-plant-a.gain sampler.0.pin.14
net c04-plant-b-gain => c04-plant-b.gain sampler.0.pin.15
'''
new='''net c04-plant-a-gain => c04-plant-a.gain sampler.0.pin.14
net c04-plant-b-gain => c04-plant-b.gain sampler.0.pin.15
net c04-saturated-a c04-pid-a.saturated => sampler.0.pin.16
net c04-saturated-b c04-pid-b.saturated => sampler.0.pin.17
net c04-saturated-count-b c04-pid-b.saturated-count => sampler.0.pin.18
newsig c04-b-maxoutput float
net c04-b-maxoutput => c04-pid-b.maxoutput sampler.0.pin.19
'''
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

old='''sets c04-kc 0
sets c04-plant-a-gain 1
sets c04-plant-b-gain 1
sets c04-phase 0
'''
new='''sets c04-kc 0
sets c04-plant-a-gain 1
sets c04-plant-b-gain 1
sets c04-b-maxoutput 0
sets c04-phase 0
'''
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

start=s.index('halcmd sets c04-phase 1\n')
end_marker="sleep 3.0\n\nOVERRUNS=\"$(halcmd getp sampler.0.overruns)\""
end=s.index(end_marker,start)
phase='''# Phase publication discipline: phase 0 is an unscored transition state.
halcmd sets c04-phase 0
sleep 0.020
halcmd sets c04-kc 0.5
halcmd sets c04-plant-b-gain 1.0
halcmd sets c04-b-maxoutput 0
sleep 0.020
halcmd sets c04-phase 1
printf 'phase-1-kc=%s plant-a=%s plant-b=%s b-maxoutput=%s\\n' "$(halcmd gets c04-kc)" "$(halcmd gets c04-plant-a-gain)" "$(halcmd gets c04-plant-b-gain)" "$(halcmd gets c04-b-maxoutput)"
sleep 1.0

halcmd sets c04-phase 0
sleep 0.020
halcmd sets c04-plant-b-gain 0.35
halcmd sets c04-b-maxoutput 0
sleep 0.020
halcmd sets c04-phase 2
printf 'phase-2-kc=%s plant-a=%s plant-b=%s b-maxoutput=%s\\n' "$(halcmd gets c04-kc)" "$(halcmd gets c04-plant-a-gain)" "$(halcmd gets c04-plant-b-gain)" "$(halcmd gets c04-b-maxoutput)"
sleep 3.0

halcmd sets c04-phase 0
sleep 0.020
halcmd sets c04-b-maxoutput 1.0
sleep 0.020
halcmd sets c04-phase 3
printf 'phase-3-kc=%s plant-a=%s plant-b=%s b-maxoutput=%s\\n' "$(halcmd gets c04-kc)" "$(halcmd gets c04-plant-a-gain)" "$(halcmd gets c04-plant-b-gain)" "$(halcmd gets c04-b-maxoutput)"
sleep 3.0

halcmd sets c04-phase 0
sleep 0.020
halcmd sets c04-plant-b-gain 1.0
halcmd sets c04-b-maxoutput 0
sleep 0.020
halcmd sets c04-phase 4
printf 'phase-4-kc=%s plant-a=%s plant-b=%s b-maxoutput=%s\\n' "$(halcmd gets c04-kc)" "$(halcmd gets c04-plant-a-gain)" "$(halcmd gets c04-plant-b-gain)" "$(halcmd gets c04-b-maxoutput)"
sleep 3.0

'''
s=s[:start]+phase+s[end:]

# Replace C03-specific result analysis with the frozen C04 Gates B-H analysis.
a0=s.index("TRACE=c04-026-realtime.txt python3 - <<'PY'\n")
a1=s.index('\nPY\n\nmkdir -p "$EVID"',a0)+4
analysis=r'''TRACE=c04-026-realtime.txt python3 - <<'PY'
import os,sys,statistics
rows=[]
for line in open(os.environ['TRACE'],errors='replace'):
    p=line.split()
    if len(p)<21: continue
    try:
        n=int(p[0]); f=list(map(float,p[1:17])); sa=int(p[17]); sb=int(p[18]); sc=int(p[19]); mo=float(p[20])
    except ValueError: continue
    rows.append((n,*f,sa,sb,sc,mo))
print(f'realtime-samples={len(rows)}')
if len(rows)<2500: print('HARNESS_INVALID: insufficient realtime samples',file=sys.stderr); sys.exit(28)
nums=[r[0] for r in rows]
if any(b<=a for a,b in zip(nums,nums[1:])): print('HARNESS_INVALID: non-monotonic sample numbering',file=sys.stderr); sys.exit(29)
print(f'realtime-sample-first={nums[0]} last={nums[-1]}')
# indexes n,base,fa,fb,D,C,cmdA,cmdB,outA,outB,kc,phase,resC,resA,resB,gainA,gainB,satA,satB,satCountB,maxOutB
by={k:[r for r in rows if abs(r[11]-k)<0.01] for k in (1,2,3,4)}
for k,v in by.items(): print(f'phase-{k}-samples={len(v)}')
if min(len(by[k]) for k in (2,3,4))<500: print('HARNESS_INVALID: insufficient decisive phase rows',file=sys.stderr); sys.exit(30)
expect={1:(1.0,0.0),2:(0.35,0.0),3:(0.35,1.0),4:(1.0,0.0)}
for k,v in by.items():
    gb,mo=expect[k]
    if any(abs(r[10]-0.5)>1e-12 or abs(r[15]-1.0)>1e-12 or abs(r[16]-gb)>1e-12 or abs(r[20]-mo)>1e-12 for r in v):
        print(f'HARNESS_INVALID: Gate C configuration drift phase {k}',file=sys.stderr); sys.exit(31)
meanabs=lambda vv: statistics.fmean(abs(r[2]-r[3]) for r in vv)
w={k:by[k][-500:] for k in by}
S={k:meanabs(w[k]) for k in w}
qual=[r for r in by[2]+by[3] if (r[2]-r[3])>0.05]
max_res_c=max((abs(r[12]) for r in by[2]+by[3]),default=999)
max_res_a=max((abs(r[13]) for r in by[2]+by[3]),default=999)
max_res_b=max((abs(r[14]) for r in by[2]+by[3]),default=999)
dir_ok=sum(1 for r in qual if r[4]<0 and r[5]<0 and r[6]<r[1] and r[7]>r[1])
# Longest consecutive phase-3 interval satisfying the frozen B-only saturation predicate.
best=[]; cur=[]
for r in by[3]:
    ok=(r[18]==1 and abs(r[8]-1.0)<=1e-9) # outB index 8; positive move
    if ok: cur.append(r)
    else:
        if len(cur)>len(best): best=cur
        cur=[]
if len(cur)>len(best): best=cur
b_interval=len(best)
a_unsat=(sum(1 for r in best if r[17]==0)/len(best)) if best else 0.0
satcount_span=(best[-1][19]-best[0][19]) if len(best)>1 else 0
p4_unsat=sum(1 for r in w[4] if r[18]==0)/len(w[4])
print(f'phase-1-S1={S[1]:.12g}')
print(f'phase-2-S2={S[2]:.12g}')
print(f'phase-3-S3={S[3]:.12g}')
print(f'phase-4-S4={S[4]:.12g}')
print(f'qualified-direction-rows={len(qual)} direction-correct={dir_ok}')
print(f'max-residual-c={max_res_c:.12g} max-residual-a={max_res_a:.12g} max-residual-b={max_res_b:.12g}')
print(f'phase-3-longest-b-saturated-at-limit={b_interval}')
print(f'phase-3-a-unsaturated-fraction-during-b-limit={a_unsat:.12g}')
print(f'phase-3-b-saturated-count-span={satcount_span}')
print(f'phase-4-b-unsaturated-fraction-last500={p4_unsat:.12g}')
checks=[]
def gate(name,ok): print(f'gate-{name}={"PASS" if ok else "FAIL"}'); checks.append(ok)
gate('B',True)
gate('C',True)
gate('D',S[2]>=max(0.10,2.0*S[1]))
gate('E',len(qual)>=200 and dir_ok>=200 and max_res_c<=1e-9 and max_res_a<=1e-9 and max_res_b<=1e-9)
gate('F',b_interval>=500 and a_unsat>=0.90 and satcount_span>=499)
gate('G',S[3]>=0.10 and p4_unsat>=0.99 and S[4]<=0.60*S[3])
gate('H',True)
print('source-reconciliation=maxoutput clamps local PID output and drives limit_state/saturated telemetry; same-direction integral update is held while limited; integ gain scales only the toy plant derivative')
print('safety-boundary=PID software saturation is not physical stall, drive current limit, hydraulic pressure/flow limit, sensor-fault diagnosis, or a safety-rated fault decision')
if not all(checks): print('C04-026 overall=FAIL'); sys.exit(41)
print('C04-026 overall=PASS')
PY'''
s=s[:a0]+analysis+s[a1:]
# C04 text must not retain the old C03 prediction/result wording.
s=s.replace('Frozen prediction: with the B-only plant slowdown unchanged, Kc=0.5 symmetric relative-feedback command correction materially reduces sustained A/B disagreement versus Kc=0.', 'Frozen prediction: truthful B response asymmetry plus a B-only maxoutput bound yields same-cycle local saturation and persistent disagreement, reversible after restoring authority and plant symmetry.')
s=s.replace('Safety boundary: reduced simulated disagreement is not proof of physical alignment, validated plant stability, or safety-rated anti-racking.', 'Safety boundary: PID software saturation is not physical stall, drive/current/pressure limit proof, sensor diagnosis, or safety-rated fault authority.')
p.write_text(s)
PY

printf '%s\n' '== C04-026 implementation preflight =='
printf '%s\n' 'frozen-gates=A-H unchanged'
printf '%s\n' 'derived-from=C03-025 accepted topology; C04 adds mixed-type realtime saturation telemetry and frozen four-phase authority test'
grep -n -E 'cfg=|saturated|maxoutput|sets c04-phase [1234]|plant-b-gain 0.35' "$TMP" | head -80
printf 'c04-inner-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
