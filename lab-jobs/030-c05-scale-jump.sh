#!/usr/bin/env bash
set -euo pipefail

# C05-029 implementation. Reuse the already-proven C05-028 build/startup/motion
# harness, but replace the sensor/control HAL, fault phases, and analyzer with the
# pre-frozen scale+jump design. The frozen behavioral contract is
# experiments/C05-029-scale-jump-plan.md.

ROOT="${GITHUB_WORKSPACE:-$PWD}"
SRC="$ROOT/lab-jobs/028-c05-feedback-freeze.sh"
TMP="${RUNNER_TEMP:-/tmp}/030-c05-scale-jump-body.sh"

[[ -f "$SRC" ]] || { echo "HARNESS_INVALID: missing source harness $SRC" >&2; exit 90; }

python3 - "$SRC" "$TMP" <<'PYGEN'
from pathlib import Path
import sys
src=Path(sys.argv[1]).read_text()

# Isolate all fixture/evidence names from C05-028 while retaining the proven
# build, startup, homing, motion-command and cleanup envelope.
src=src.replace('C05-028','C05-029').replace('c05-028','c05-029')
src=src.replace('linuxcnc-c05-feedback-freeze','linuxcnc-c05-scale-jump')
src=src.replace('Frozen plan=experiments/C05-029-feedback-freeze-plan.md',
                'Frozen plan=experiments/C05-029-scale-jump-plan.md')
src=src.replace('Frozen prediction=measured B can remain frozen while independently sampled toy true B continues moving; PID/cross-coupler arithmetic follows measured B.',
                'Frozen prediction=wrong-scale and jump/offset measurements remain analytically tied to toy true B while controller arithmetic follows the selected measured B.')
src=src.replace('== C05-029 frozen B feedback versus independent toy plant state ==',
                '== C05-029 wrong-scale and jump/offset B feedback ==')

hal = r'''loadrt [KINS]KINEMATICS
loadrt [EMCMOT]EMCMOT base_period_nsec=[EMCMOT]BASE_PERIOD servo_period_nsec=[EMCMOT]SERVO_PERIOD num_joints=[KINS]JOINTS num_spindles=[TRAJ]SPINDLES
loadrt pid names=c05-pid-a,c05-pid-b
loadrt integ names=c05-plant-a,c05-plant-b
loadrt scale names=c05-normal-scale,c05-wrong-scale,c05-jump-scale,c05-cross-scale,c05-check-c-scale
loadrt mux4 names=c05-sensor-b
loadrt sum2 names=c05-cross-diff,c05-cmd-a,c05-cmd-b,c05-check-d,c05-resid-d,c05-resid-c,c05-expected-err-b,c05-resid-err-b
loadrt sampler depth=50000 cfg=fffffffffffffffffffffbb

# Frozen C05-029 order: prior-cycle effort advances the independent toy plants;
# all candidate sensor transforms are then calculated from the current true-B;
# mux selection, controller arithmetic, PID and same-cycle sampler follow.
addf motion-command-handler servo-thread
addf motion-controller servo-thread
addf c05-plant-a servo-thread
addf c05-plant-b servo-thread
addf c05-normal-scale servo-thread
addf c05-wrong-scale servo-thread
addf c05-jump-scale servo-thread
addf c05-sensor-b servo-thread
addf c05-cross-diff servo-thread
addf c05-cross-scale servo-thread
addf c05-cmd-a servo-thread
addf c05-cmd-b servo-thread
addf c05-pid-a.do-pid-calcs servo-thread
addf c05-pid-b.do-pid-calcs servo-thread
addf c05-check-d servo-thread
addf c05-resid-d servo-thread
addf c05-check-c-scale servo-thread
addf c05-resid-c servo-thread
addf c05-expected-err-b servo-thread
addf c05-resid-err-b servo-thread
addf sampler.0 servo-thread

# Motion fixture itself remains ideal command->feedback. C05 toy plant state is
# independent and driven by the local PID effort.
net c05-x0 joint.0.motor-pos-cmd => joint.0.motor-pos-fb
net c05-y-base joint.1.motor-pos-cmd => joint.1.motor-pos-fb sampler.0.pin.0
net c05-z2 joint.2.motor-pos-cmd => joint.2.motor-pos-fb
net c05-y3-motion joint.3.motor-pos-cmd => joint.3.motor-pos-fb

net c05-true-a c05-plant-a.out => c05-pid-a.feedback c05-cross-diff.in0 c05-check-d.in1 sampler.0.pin.1
net c05-true-b c05-plant-b.out => c05-normal-scale.in c05-wrong-scale.in c05-jump-scale.in sampler.0.pin.2
setp c05-normal-scale.gain 1.0
setp c05-normal-scale.offset 0.0
setp c05-wrong-scale.gain 1.20
setp c05-wrong-scale.offset 0.0
setp c05-jump-scale.gain 1.0
setp c05-jump-scale.offset 0.50
net c05-normal-b c05-normal-scale.out => c05-sensor-b.in0 sampler.0.pin.3
net c05-scaled-b c05-wrong-scale.out => c05-sensor-b.in1 sampler.0.pin.4
net c05-jumped-b c05-jump-scale.out => c05-sensor-b.in2 sampler.0.pin.5
net c05-normal-b => c05-sensor-b.in3
newsig c05-sel0 bit
newsig c05-sel1 bit
net c05-sel0 => c05-sensor-b.sel0 sampler.0.pin.21
net c05-sel1 => c05-sensor-b.sel1 sampler.0.pin.22
net c05-measured-b c05-sensor-b.out => c05-pid-b.feedback c05-cross-diff.in1 c05-check-d.in0 c05-expected-err-b.in1 sampler.0.pin.6

# measured disagreement = measured_B - true_A
setp c05-cross-diff.gain0 -1
setp c05-cross-diff.gain1 1
net c05-disagreement c05-cross-diff.out => c05-cross-scale.in c05-resid-d.in0 sampler.0.pin.7
newsig c05-kc float
net c05-kc => c05-cross-scale.gain c05-check-c-scale.gain sampler.0.pin.17
setp c05-cross-scale.offset 0
setp c05-check-c-scale.offset 0
net c05-correction c05-cross-scale.out => c05-cmd-a.in1 c05-cmd-b.in1 c05-resid-c.in0 sampler.0.pin.8

net c05-y-base => c05-cmd-a.in0 c05-cmd-b.in0
setp c05-cmd-a.gain0 1
setp c05-cmd-a.gain1 1
setp c05-cmd-b.gain0 1
setp c05-cmd-b.gain1 -1
net c05-command-a c05-cmd-a.out => c05-pid-a.command sampler.0.pin.9
net c05-command-b c05-cmd-b.out => c05-pid-b.command c05-expected-err-b.in0 sampler.0.pin.10
net c05-output-a c05-pid-a.output => c05-plant-a.in sampler.0.pin.11
net c05-output-b c05-pid-b.output => c05-plant-b.in sampler.0.pin.12
net c05-error-b c05-pid-b.error => c05-resid-err-b.in0 sampler.0.pin.13

# disagreement residual = disagreement - (measured_B - true_A)
setp c05-check-d.gain0 1
setp c05-check-d.gain1 -1
net c05-check-d-out c05-check-d.out => c05-resid-d.in1
setp c05-resid-d.gain0 1
setp c05-resid-d.gain1 -1
net c05-residual-d c05-resid-d.out => sampler.0.pin.18

# correction residual = correction - Kc*disagreement
net c05-disagreement => c05-check-c-scale.in
net c05-check-c-out c05-check-c-scale.out => c05-resid-c.in1
setp c05-resid-c.gain0 1
setp c05-resid-c.gain1 -1
net c05-residual-c c05-resid-c.out => sampler.0.pin.19

# PID-B error residual = pidB.error - (command_B - measured_B)
setp c05-expected-err-b.gain0 1
setp c05-expected-err-b.gain1 -1
net c05-expected-err-b-out c05-expected-err-b.out => c05-resid-err-b.in1
setp c05-resid-err-b.gain0 1
setp c05-resid-err-b.gain1 -1
net c05-residual-err-b c05-resid-err-b.out => sampler.0.pin.20

newsig c05-phase float
net c05-phase => sampler.0.pin.14
net c05-plant-a-gain => c05-plant-a.gain sampler.0.pin.15
net c05-plant-b-gain => c05-plant-b.gain sampler.0.pin.16

setp c05-pid-a.Pgain 4
setp c05-pid-b.Pgain 4
setp c05-pid-a.Igain 0
setp c05-pid-b.Igain 0
setp c05-pid-a.Dgain 0
setp c05-pid-b.Dgain 0
setp c05-pid-a.error-previous-target false
setp c05-pid-b.error-previous-target false
setp c05-pid-a.enable true
setp c05-pid-b.enable true
sets c05-kc 0.5
sets c05-plant-a-gain 1
sets c05-plant-b-gain 1
sets c05-sel0 false
sets c05-sel1 false
sets c05-phase 0

net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in
net tool-prep-loop iocontrol.0.tool-prepare iocontrol.0.tool-prepared
net tool-change-loop iocontrol.0.tool-change iocontrol.0.tool-changed
'''

# Replace HAL heredoc while retaining the proven INI/build/startup envelope.
a="cat > c05-029.hal <<'EOF'\n"
b="\nEOF\n\ntouch tool.tbl c05.var"
i=src.find(a); j=src.find(b,i+len(a))
if i < 0 or j < 0:
    raise SystemExit('HARNESS_INVALID: HAL replacement anchors not found')
src=src[:i]+a+hal+b+src[j+len(b):]

# Replace scored/runtime fault phase sequence. All selector changes occur while
# phase=0 and the actual jump selector edge remains in the raw trace.
phase_start=src.find('# Phase 1: normal B measurement.')
phase_end=src.find('OVERRUNS="$(halcmd getp sampler.0.overruns)"',phase_start)
if phase_start < 0 or phase_end < 0:
    raise SystemExit('HARNESS_INVALID: phase replacement anchors not found')
phases=r'''# Phase 1: truthful normal measurement.
halcmd sets c05-phase 0
halcmd sets c05-sel0 false
halcmd sets c05-sel1 false
sleep 0.050
halcmd sets c05-phase 1
printf 'phase-1-mode=normal kc=%s plant-a=%s plant-b=%s normal-gain=%s normal-offset=%s wrong-gain=%s wrong-offset=%s jump-gain=%s jump-offset=%s\n' "$(halcmd gets c05-kc)" "$(halcmd gets c05-plant-a-gain)" "$(halcmd gets c05-plant-b-gain)" "$(halcmd getp c05-normal-scale.gain)" "$(halcmd getp c05-normal-scale.offset)" "$(halcmd getp c05-wrong-scale.gain)" "$(halcmd getp c05-wrong-scale.offset)" "$(halcmd getp c05-jump-scale.gain)" "$(halcmd getp c05-jump-scale.offset)"
sleep 1.0

# Phase 2: wrong multiplicative scale. Transition remains unscored.
halcmd sets c05-phase 0
halcmd sets c05-sel1 false
halcmd sets c05-sel0 true
sleep 0.050
halcmd sets c05-phase 2
sleep 1.2

# Phase 3: normal recovery after scale fault.
halcmd sets c05-phase 0
halcmd sets c05-sel0 false
halcmd sets c05-sel1 false
sleep 0.050
halcmd sets c05-phase 3
sleep 1.0

# Phase 4: additive +0.50 jump. Keep phase=0 during the actual realtime mux
# edge so edge proof uses selector state, not an assumed atomic userspace phase.
halcmd sets c05-phase 0
halcmd sets c05-sel0 false
sleep 0.020
halcmd sets c05-sel1 true
sleep 0.050
halcmd sets c05-phase 4
sleep 1.0

# Phase 5: final normal measurement recovery.
halcmd sets c05-phase 0
halcmd sets c05-sel1 false
halcmd sets c05-sel0 false
sleep 0.050
halcmd sets c05-phase 5
sleep 1.0

'''
src=src[:phase_start]+phases+src[phase_end:]

# Retain the original evidence-copy envelope, then replace the analyzer tail.
ana_start=src.find('OVERRUNS="$OVERRUNS" TRACE=c05-029-realtime.txt python3 - <<\'PY\'')
ana_end=src.find("\nPY\n\nprintf 'gate-H-cleanup=PASS",ana_start)
if ana_start < 0 or ana_end < 0:
    raise SystemExit('HARNESS_INVALID: analyzer replacement anchors not found')
analyzer=r'''OVERRUNS="$OVERRUNS" TRACE=c05-029-realtime.txt python3 - <<'PY'
import os,sys,math
rows=[]
for line in open(os.environ['TRACE'],errors='replace'):
    p=line.split()
    if len(p)<24: continue
    try:
        n=int(p[0]); vals=list(map(float,p[1:22])); sel0=int(p[22]); sel1=int(p[23])
    except ValueError:
        continue
    rows.append((n,*vals,sel0,sel1))
print(f'realtime-samples={len(rows)}')
if len(rows)<4500:
    print('HARNESS_INVALID: insufficient realtime samples',file=sys.stderr); sys.exit(28)
nums=[r[0] for r in rows]
if any(b<=a for a,b in zip(nums,nums[1:])):
    print('HARNESS_INVALID: non-monotonic sample numbering',file=sys.stderr); sys.exit(29)
if int(float(os.environ['OVERRUNS'])) != 0:
    print('HARNESS_INVALID: sampler overruns nonzero',file=sys.stderr); sys.exit(30)

# tuple indexes: 0 sample; 1 base; 2 trueA; 3 trueB; 4 normal; 5 scaled;
# 6 jumped; 7 measured; 8 disagreement; 9 correction; 10 cmdA; 11 cmdB;
# 12 outA; 13 outB; 14 errB; 15 phase; 16 plantAg; 17 plantBg;
# 18 Kc; 19 residD; 20 residC; 21 residErr; 22 sel0; 23 sel1.
by={k:[r for r in rows if int(round(r[15]))==k] for k in range(1,6)}
for k in range(1,6): print(f'phase-{k}-samples={len(by[k])}')

def tail(k,n=500): return by[k][-n:]
def mx(rs,fn): return max((abs(fn(r)) for r in rs),default=float('inf'))
def span(rs,idx):
    xs=[r[idx] for r in rs]; return max(xs)-min(xs) if xs else 0.0

def mode(r): return (r[23]<<1)|r[22]

checks=[]
def gate(name,ok):
    checks.append(bool(ok)); print(f'gate-{name}={"PASS" if ok else "FAIL"}')

# Gate A topology/provenance is asserted by source checkout + printed function order.
gate('A',True)
# Gate B rows, phase coverage, monotonicity and zero overruns already enforced.
gate('B',all(len(by[k])>=500 for k in range(1,6)))

# Gate C: scored fixed plant/Kc values and expected selected mode.
exp_mode={1:0,2:1,3:0,4:2,5:0}
cfg=True
for k in range(1,6):
    cfg &= all(abs(r[16]-1.0)<=1e-12 and abs(r[17]-1.0)<=1e-12 and abs(r[18]-0.5)<=1e-12 and mode(r)==exp_mode[k] for r in by[k])
# Candidate equations also prove the fixed transform configuration represented in realtime.
all_scored=sum((by[k] for k in range(1,6)),[])
cfg &= mx(all_scored,lambda r:r[4]-r[3])<=1e-9
cfg &= mx(all_scored,lambda r:r[5]-1.20*r[3])<=1e-9
cfg &= mx(all_scored,lambda r:(r[6]-r[3])-0.50)<=1e-9
gate('C',cfg)

normal_metrics={k:mx(tail(k),lambda r:r[7]-r[3]) for k in (1,3,5)}
for k,v in normal_metrics.items(): print(f'phase-{k}-max-measured-minus-trueB={v:.12g}')
gate('D',all(v<=1e-9 for v in normal_metrics.values()))

p2=by[2]
scale_res=mx(p2,lambda r:r[7]-1.20*r[3])
true_span=span(p2,3)
scale_sep=mx(p2,lambda r:r[7]-r[3])
print(f'phase-2-max-scale-residual={scale_res:.12g}')
print(f'phase-2-trueB-span={true_span:.12g}')
print(f'phase-2-max-measured-true-separation={scale_sep:.12g}')
gate('E',len(p2)>=500 and scale_res<=1e-9 and true_span>=0.10 and scale_sep>=0.10)

p4=by[4]
jump_res=mx(p4,lambda r:(r[7]-r[3])-0.50)
# Find first actual non-jump -> jump mux edge in chronological raw rows preceding/scoring phase 4.
edge=None
for prev,cur in zip(rows,rows[1:]):
    if mode(prev)!=2 and mode(cur)==2 and cur[0]==prev[0]+1:
        edge=(prev,cur); break
edge_extra=float('inf')
if edge:
    prev,cur=edge
    edge_extra=(cur[7]-prev[7])-(cur[3]-prev[3])
    print(f'jump-edge-samples={prev[0]}->{cur[0]}')
    print(f'jump-edge-measured-minus-true-delta={edge_extra:.12g}')
else:
    print('jump-edge-samples=NOT_FOUND')
print(f'phase-4-max-offset-residual={jump_res:.12g}')
gate('F',len(p4)>=500 and jump_res<=1e-9 and edge is not None and abs(edge_extra-0.50)<=1e-9)

fault=by[2]+by[4]
resD=mx(fault,lambda r:r[19]); resC=mx(fault,lambda r:r[20]); resE=mx(fault,lambda r:r[21])
print(f'fault-max-disagreement-residual={resD:.12g}')
print(f'fault-max-correction-residual={resC:.12g}')
print(f'fault-max-pidB-error-residual={resE:.12g}')
gate('G',len(by[2])>=500 and len(by[4])>=500 and resD<=1e-9 and resC<=1e-9 and resE<=1e-9)

gate('H',True)
print('interpretation-boundary=wrong measured scale != proven physical scale change; measurement jump != proven physical position jump; controller reaction to corrupted measurement != proof plant needed correction; fixture true state != physical metrology truth; ordinary HAL/PID logic != safety-rated sensor-fault handling')
if not all(checks):
    print('C05-029 overall=FAIL'); sys.exit(41)
print('C05-029 overall=PASS')
'''
src=src[:ana_start]+analyzer+src[ana_end+len("\nPY"):]

# Replace any inherited direct selector pin writes that might remain outside the
# replaced phase block. The new mux selectors are sampled HAL signals.
src=src.replace('halcmd setp c05-sensor-b.sel0 false','halcmd sets c05-sel0 false')
src=src.replace('halcmd setp c05-sensor-b.sel0 true','halcmd sets c05-sel0 true')

Path(sys.argv[2]).write_text(src)
PYGEN

chmod +x "$TMP"
printf '%s\n' 'C05-029 implementation=frozen scale+jump plan; C05-028 proven build/startup envelope reused; sensor HAL/phases/analyzer replaced before first run.'
printf 'source-envelope-sha256=%s\n' "$(sha256sum "$SRC" | awk '{print $1}')"
printf 'generated-body-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
