#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c05-feedback-freeze"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
EVID="$ROOT/lab-results/c05-028-evidence"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"

printf '== C05-028 frozen B feedback versus independent toy plant state ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen plan=experiments/C05-028-feedback-freeze-plan.md'
printf '%s\n' 'Frozen prediction=measured B can remain frozen while independently sampled toy true B continues moving; PID/cross-coupler arithmetic follows measured B.'
printf '%s\n' 'Safety boundary=fixture true state is not physical metrology truth; ordinary HAL/PID logic is not safety-rated sensor-fault handling.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps python3
rm -rf "$WORK" "$EVID"
mkdir -p "$RUN_EVID"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
ACTUAL_COMMIT="$(git rev-parse HEAD)"
printf 'checked-out-commit=%s\n' "$ACTUAL_COMMIT"
[[ "$ACTUAL_COMMIT" == "$LINUXCNC_COMMIT" ]] || { echo 'HARNESS_INVALID: pinned checkout mismatch' >&2; exit 20; }

./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)"
cd ..
set +u
source scripts/rip-environment
set -u

LINUXCNC_BIN="$(command -v linuxcnc)"
SAMPLER_BIN="$(command -v halsampler)"
case "$(readlink -f "$LINUXCNC_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: linuxcnc not from pinned tree' >&2; exit 21;; esac
case "$(readlink -f "$SAMPLER_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: halsampler not from pinned tree' >&2; exit 22;; esac
printf 'linuxcnc-bin=%s\nhalsampler-bin=%s\ngate-A-provenance=PASS\n' "$LINUXCNC_BIN" "$SAMPLER_BIN"

FIXTURE="$WORK/c05-028-fixture"
mkdir -p "$FIXTURE"
cd "$FIXTURE"
cat > c05-028.ini <<'EOF'
[EMC]
MACHINE = C05-028-FEEDBACK-FREEZE
VERSION = 1.1
DEBUG = 0
[DISPLAY]
DISPLAY = linuxcncrsh -n C05FeedbackFreeze
[TASK]
TASK = milltask
CYCLE_TIME = 0.001
[RS274NGC]
PARAMETER_FILE = c05.var
[EMCMOT]
EMCMOT = motmod
COMM_TIMEOUT = 4.0
BASE_PERIOD = 0
SERVO_PERIOD = 1000000
[EMCIO]
TOOL_TABLE = tool.tbl
[HAL]
HALFILE = c05-028.hal
[TRAJ]
SPINDLES = 1
COORDINATES = XYZY
LINEAR_UNITS = inch
ANGULAR_UNITS = degree
DEFAULT_LINEAR_VELOCITY = 1.0
MAX_LINEAR_VELOCITY = 4.0
NO_FORCE_HOMING = 0
[KINS]
JOINTS = 4
KINEMATICS = trivkins coordinates=XYZY kinstype=BOTH
[AXIS_X]
MIN_LIMIT=-30
MAX_LIMIT=30
MAX_VELOCITY=4
MAX_ACCELERATION=20
[AXIS_Y]
MIN_LIMIT=-30
MAX_LIMIT=30
MAX_VELOCITY=4
MAX_ACCELERATION=20
[AXIS_Z]
MIN_LIMIT=-30
MAX_LIMIT=30
MAX_VELOCITY=4
MAX_ACCELERATION=20
[JOINT_0]
TYPE=LINEAR
MIN_LIMIT=-30
MAX_LIMIT=30
MAX_VELOCITY=4
MAX_ACCELERATION=20
FERROR=1
MIN_FERROR=0.01
HOME=0
HOME_OFFSET=0
HOME_SEARCH_VEL=0
HOME_LATCH_VEL=0
HOME_SEQUENCE=0
[JOINT_1]
TYPE=LINEAR
MIN_LIMIT=-30
MAX_LIMIT=30
MAX_VELOCITY=4
MAX_ACCELERATION=20
FERROR=1
MIN_FERROR=0.01
HOME=0
HOME_OFFSET=0
HOME_SEARCH_VEL=0
HOME_LATCH_VEL=0
HOME_SEQUENCE=-1
[JOINT_2]
TYPE=LINEAR
MIN_LIMIT=-30
MAX_LIMIT=30
MAX_VELOCITY=4
MAX_ACCELERATION=20
FERROR=1
MIN_FERROR=0.01
HOME=0
HOME_OFFSET=0
HOME_SEARCH_VEL=0
HOME_LATCH_VEL=0
HOME_SEQUENCE=2
[JOINT_3]
TYPE=LINEAR
MIN_LIMIT=-30
MAX_LIMIT=30
MAX_VELOCITY=4
MAX_ACCELERATION=20
FERROR=1
MIN_FERROR=0.01
HOME=0
HOME_OFFSET=0
HOME_SEARCH_VEL=0
HOME_LATCH_VEL=0
HOME_SEQUENCE=-1
EOF

cat > c05-028.hal <<'EOF'
loadrt [KINS]KINEMATICS
loadrt [EMCMOT]EMCMOT base_period_nsec=[EMCMOT]BASE_PERIOD servo_period_nsec=[EMCMOT]SERVO_PERIOD num_joints=[KINS]JOINTS num_spindles=[TRAJ]SPINDLES
loadrt pid names=c05-pid-a,c05-pid-b
loadrt integ names=c05-plant-a,c05-plant-b
loadrt mux4 names=c05-sensor-b
loadrt scale names=c05-cross-scale,c05-check-c-scale
loadrt sum2 names=c05-cross-diff,c05-cmd-a,c05-cmd-b,c05-check-d,c05-resid-d,c05-resid-c
loadrt sampler depth=40000 cfg=ffffffffffffffffffb

# Frozen C05 order: prior-cycle effort advances plant first; then sensor,
# controller arithmetic, PID, same-cycle residuals and sampler.
addf motion-command-handler servo-thread
addf motion-controller servo-thread
addf c05-plant-a servo-thread
addf c05-plant-b servo-thread
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
addf sampler.0 servo-thread

# Motion itself uses ideal joint command->feedback loopbacks. The C05 toy plant
# is an independent control fixture driven by the shared Y command.
net c05-x0 joint.0.motor-pos-cmd => joint.0.motor-pos-fb
net c05-y-base joint.1.motor-pos-cmd => joint.1.motor-pos-fb sampler.0.pin.0
net c05-z2 joint.2.motor-pos-cmd => joint.2.motor-pos-fb
net c05-y3-motion joint.3.motor-pos-cmd => joint.3.motor-pos-fb

# Independent toy plant states. A is measured truthfully; B passes through mux.
net c05-true-a c05-plant-a.out => c05-pid-a.feedback c05-cross-diff.in0 c05-check-d.in1 sampler.0.pin.1
net c05-true-b c05-plant-b.out => c05-sensor-b.in0 sampler.0.pin.2
newsig c05-freeze-value float
net c05-freeze-value => c05-sensor-b.in1 sampler.0.pin.4
setp c05-sensor-b.in2 0
setp c05-sensor-b.in3 0
setp c05-sensor-b.sel1 false
net c05-measured-b c05-sensor-b.out => c05-pid-b.feedback c05-cross-diff.in1 c05-check-d.in0 sampler.0.pin.3
net c05-sensor-freeze c05-sensor-b.sel0 => sampler.0.pin.18

# measured disagreement = measured_B - true_A
setp c05-cross-diff.gain0 -1
setp c05-cross-diff.gain1 1
net c05-disagreement c05-cross-diff.out => c05-cross-scale.in c05-resid-d.in0 sampler.0.pin.5
newsig c05-kc float
net c05-kc => c05-cross-scale.gain c05-check-c-scale.gain sampler.0.pin.15
setp c05-cross-scale.offset 0
setp c05-check-c-scale.offset 0
net c05-correction c05-cross-scale.out => c05-cmd-a.in1 c05-cmd-b.in1 c05-resid-c.in0 sampler.0.pin.6

# symmetric correction around shared motion command
net c05-y-base => c05-cmd-a.in0 c05-cmd-b.in0
setp c05-cmd-a.gain0 1
setp c05-cmd-a.gain1 1
setp c05-cmd-b.gain0 1
setp c05-cmd-b.gain1 -1
net c05-command-a c05-cmd-a.out => c05-pid-a.command sampler.0.pin.7
net c05-command-b c05-cmd-b.out => c05-pid-b.command sampler.0.pin.8
net c05-output-a c05-pid-a.output => c05-plant-a.in sampler.0.pin.9
net c05-output-b c05-pid-b.output => c05-plant-b.in sampler.0.pin.10
net c05-error-b c05-pid-b.error => sampler.0.pin.11

# Realtime residual: diff - (measured_B - true_A)
setp c05-check-d.gain0 1
setp c05-check-d.gain1 -1
net c05-check-d-out c05-check-d.out => c05-resid-d.in1
setp c05-resid-d.gain0 1
setp c05-resid-d.gain1 -1
net c05-residual-d c05-resid-d.out => sampler.0.pin.16
# Realtime residual: correction - Kc*diff
net c05-disagreement => c05-check-c-scale.in
net c05-check-c-out c05-check-c-scale.out => c05-resid-c.in1
setp c05-resid-c.gain0 1
setp c05-resid-c.gain1 -1
net c05-residual-c c05-resid-c.out => sampler.0.pin.17

newsig c05-phase float
net c05-phase => sampler.0.pin.12
net c05-plant-a-gain => c05-plant-a.gain sampler.0.pin.13
net c05-plant-b-gain => c05-plant-b.gain sampler.0.pin.14

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
sets c05-freeze-value 0
sets c05-phase 0

net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in
net tool-prep-loop iocontrol.0.tool-prepare iocontrol.0.tool-prepared
net tool-change-loop iocontrol.0.tool-change iocontrol.0.tool-changed
EOF

touch tool.tbl c05.var
printf 'fixture-ini-sha256=%s\n' "$(sha256sum c05-028.ini | awk '{print $1}')"
printf 'fixture-hal-sha256=%s\n' "$(sha256sum c05-028.hal | awk '{print $1}')"
printf '%s\n' '-- frozen realtime function order --'
grep '^addf ' c05-028.hal
printf '%s\n' '-- sensor topology --'
grep -E '^net c05-(true|measured|freeze|sensor|disagreement|correction|command|output|error|plant|kc)|^setp c05-(sensor|pid|cross)' c05-028.hal

rm -f /tmp/linuxcnc.lock c05-linuxcnc.stdout c05-linuxcnc.stderr c05-028-realtime.txt c05-028-halsampler.stderr
linuxcnc -r c05-028.ini >c05-linuxcnc.stdout 2>c05-linuxcnc.stderr &
LCNC_PID=$!
SAMPLER_PID=""
cleanup() {
  mkdir -p "$EVID" "$RUN_EVID"
  for f in c05-028-realtime.txt c05-linuxcnc.stdout c05-linuxcnc.stderr c05-028-halsampler.stderr; do
    if [[ -f "$f" ]]; then cp "$f" "$EVID/$f" || true; cp "$f" "$RUN_EVID/$f" || true; fi
  done
  if [[ -n "${SAMPLER_PID:-}" ]] && kill -0 "$SAMPLER_PID" 2>/dev/null; then kill -TERM "$SAMPLER_PID" 2>/dev/null || true; wait "$SAMPLER_PID" 2>/dev/null || true; fi
  if kill -0 "$LCNC_PID" 2>/dev/null; then
    { printf '%s\n' 'set timestamp off' 'hello EMC c05shutdown' 'set echo off' 'set enable EMCTOO' 'shutdown'; sleep .2; } | timeout 8s nc localhost 5007 >/dev/null 2>&1 || true
    sleep .5
    kill -TERM "$LCNC_PID" 2>/dev/null || true
  fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 200); do
  if nc -z localhost 5007 >/dev/null 2>&1 && halcmd getp c05-pid-a.output >/dev/null 2>&1 && halcmd gets c05-true-b >/dev/null 2>&1 && halcmd getp sampler.0.overruns >/dev/null 2>&1; then READY=1; printf 'runtime-ready-probe=%s\n' "$i"; break; fi
  sleep .25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: runtime not ready' >&2; cat c05-linuxcnc.stderr >&2 || true; exit 23; }
printf 'gate-A-topology=PASS\n'

halsampler -c 0 -t >c05-028-realtime.txt 2>c05-028-halsampler.stderr &
SAMPLER_PID=$!
sleep .2
kill -0 "$SAMPLER_PID" 2>/dev/null || { echo 'HARNESS_INVALID: halsampler exited' >&2; exit 24; }

python3 - <<'PY'
import time,sys,linuxcnc
c=linuxcnc.command(); s=linuxcnc.stat(); e=linuxcnc.error_channel()
def waitc(label):
    rc=c.wait_complete(5); print(f'{label}-wait-complete={rc}')
    if rc not in (0,1): sys.exit(25)
def waitp(label,pred,t=12):
    end=time.monotonic()+t
    while time.monotonic()<end:
        s.poll()
        if pred(): print(f'{label}=PASS'); return
        er=e.poll()
        if er: print(f'error-{label}={er}')
        time.sleep(.01)
    print(f'HARNESS_INVALID: timeout {label}',file=sys.stderr); sys.exit(26)
c.state(linuxcnc.STATE_ESTOP_RESET); waitc('estop-reset')
c.state(linuxcnc.STATE_ON); waitc('machine-on')
c.mode(linuxcnc.MODE_MANUAL); waitc('manual')
c.home(-1); waitp('all-homed',lambda: all(bool(s.homed[j]) for j in range(4)))
waitp('inpos-before-move',lambda: bool(s.inpos),5)
c.mode(linuxcnc.MODE_MDI); waitc('mdi-mode')
s.poll(); target=float(s.position[1])+20.0
print(f'mdi-target-y={target:.9f}')
c.mdi(f'G20 G90 G1 Y{target:.9f} F60')
time.sleep(.3)
PY

# Phase 1: normal B measurement.
halcmd sets c05-phase 0
halcmd setp c05-sensor-b.sel0 false
sleep 0.020
halcmd sets c05-phase 1
printf 'phase-1-selector=%s kc=%s plant-a=%s plant-b=%s\n' "$(halcmd getp c05-sensor-b.sel0)" "$(halcmd gets c05-kc)" "$(halcmd gets c05-plant-a-gain)" "$(halcmd gets c05-plant-b-gain)"
sleep 1.0

# Unscored transition: capture current toy true-B in userspace, then publish
# selector only after the freeze value has settled through realtime mux cycles.
halcmd sets c05-phase 0
sleep 0.020
FREEZE="$(halcmd gets c05-true-b | awk '{print $2}')"
halcmd sets c05-freeze-value "$FREEZE"
halcmd setp c05-sensor-b.sel0 true
sleep 0.050
printf 'transition-freeze-value=%s true-b-after-settle=%s selector=%s\n' "$(halcmd gets c05-freeze-value)" "$(halcmd gets c05-true-b)" "$(halcmd getp c05-sensor-b.sel0)"
halcmd sets c05-phase 2
sleep 2.0

# Phase 3: restore truthful B measurement; do not require plant convergence.
halcmd sets c05-phase 0
halcmd setp c05-sensor-b.sel0 false
sleep 0.050
halcmd sets c05-phase 3
sleep 1.0

OVERRUNS="$(halcmd getp sampler.0.overruns)"
printf 'sampler-overruns=%s\n' "$OVERRUNS"
kill -TERM "$SAMPLER_PID" 2>/dev/null || true
wait "$SAMPLER_PID" 2>/dev/null || true
SAMPLER_PID=""
sleep .1

mkdir -p "$EVID" "$RUN_EVID"
for f in c05-028-realtime.txt c05-linuxcnc.stdout c05-linuxcnc.stderr c05-028-halsampler.stderr; do
  [[ -f "$f" ]] || { echo "HARNESS_INVALID: required evidence missing before analysis: $f" >&2; exit 27; }
  cp "$f" "$EVID/$f"
  cp "$f" "$RUN_EVID/$f"
  printf 'retained-evidence=%s sha256=%s bytes=%s\n' "$f" "$(sha256sum "$f" | awk '{print $1}')" "$(wc -c < "$f")"
done
printf 'retained-realtime-lines=%s\n' "$(wc -l < c05-028-realtime.txt)"

OVERRUNS="$OVERRUNS" TRACE=c05-028-realtime.txt python3 - <<'PY'
import os,sys,statistics
rows=[]
for line in open(os.environ['TRACE'],errors='replace'):
    p=line.split()
    if len(p)<20: continue
    try:
        n=int(p[0]); f=list(map(float,p[1:19])); sel=int(p[19])
    except ValueError:
        continue
    rows.append((n,*f,sel))
print(f'realtime-samples={len(rows)}')
if len(rows)<2500:
    print('HARNESS_INVALID: insufficient realtime samples',file=sys.stderr); sys.exit(28)
nums=[r[0] for r in rows]
if any(b<=a for a,b in zip(nums,nums[1:])):
    print('HARNESS_INVALID: non-monotonic sample numbering',file=sys.stderr); sys.exit(29)
if int(float(os.environ.get('OVERRUNS','-1'))) != 0:
    print('HARNESS_INVALID: sampler overruns nonzero',file=sys.stderr); sys.exit(30)
# tuple indexes: n,base,trueA,trueB,measB,freeze,D,C,cmdA,cmdB,outA,outB,errB,phase,gainA,gainB,kc,resD,resC,sel
by={k:[r for r in rows if abs(r[13]-k)<0.01] for k in (1,2,3)}
for k,v in by.items(): print(f'phase-{k}-samples={len(v)}')
if min(len(v) for v in by.values())<500:
    print('HARNESS_INVALID: insufficient decisive phase rows',file=sys.stderr); sys.exit(31)
for k,v in by.items():
    expected_sel=1 if k==2 else 0
    if any(abs(r[14]-1.0)>1e-12 or abs(r[15]-1.0)>1e-12 or abs(r[16]-0.5)>1e-12 or r[19]!=expected_sel for r in v):
        print(f'HARNESS_INVALID: Gate C configuration drift phase {k}',file=sys.stderr); sys.exit(32)
f2=[r[5] for r in by[2]]
if max(f2)-min(f2)>1e-12:
    print('HARNESS_INVALID: phase-2 freeze value drift',file=sys.stderr); sys.exit(33)
w1=by[1][-500:]; w3=by[3][-500:]
normal1=max(abs(r[4]-r[3]) for r in w1)
normal3=max(abs(r[4]-r[3]) for r in w3)
freeze_res=max(abs(r[4]-r[5]) for r in by[2])
meas2=[r[4] for r in by[2]]; true2=[r[3] for r in by[2]]
meas_span=max(meas2)-min(meas2)
true_span=max(true2)-min(true2)
separation=max(abs(r[3]-r[4]) for r in by[2])
resD=max(abs(r[17]) for r in by[2])
resC=max(abs(r[18]) for r in by[2])
err_res=max(abs(r[12]-(r[9]-r[4])) for r in by[2])
print(f'phase-1-max-measured-minus-trueB={normal1:.12g}')
print(f'phase-2-max-measured-minus-freeze={freeze_res:.12g}')
print(f'phase-2-measured-span={meas_span:.12g}')
print(f'phase-2-trueB-span={true_span:.12g}')
print(f'phase-2-max-trueB-measured-separation={separation:.12g}')
print(f'phase-2-max-disagreement-residual={resD:.12g}')
print(f'phase-2-max-correction-residual={resC:.12g}')
print(f'phase-2-max-pidB-error-residual={err_res:.12g}')
print(f'phase-3-max-measured-minus-trueB={normal3:.12g}')
checks=[]
def gate(name,ok): print(f'gate-{name}={"PASS" if ok else "FAIL"}'); checks.append(ok)
gate('A',True)
gate('B',True)
gate('C',True)
gate('D',normal1<=1e-9)
gate('E',freeze_res<=1e-9 and meas_span<=1e-9 and true_span>=0.10 and separation>=0.10)
gate('F',len(by[2])>=500 and resD<=1e-9 and resC<=1e-9 and err_res<=1e-9)
gate('G',normal3<=1e-9)
gate('H',True)
print('interpretation-boundary=fixture true state != physical metrology truth; frozen measured feedback != proven frozen actuator; controller reaction to bad measurement != proof plant needed correction; ordinary HAL/PID logic != safety-rated sensor fault handling')
if not all(checks):
    print('C05-028 overall=FAIL'); sys.exit(41)
print('C05-028 overall=PASS')
PY

printf 'gate-H-cleanup=PASS\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
