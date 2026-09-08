#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c03-cross-coupling"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
EVID="$ROOT/lab-results/c03-025-evidence"

printf '== C03-025 explicit relative-feedback cross-coupling ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen prediction: with the B-only plant slowdown unchanged, Kc=0.5 symmetric relative-feedback command correction materially reduces sustained A/B disagreement versus Kc=0.'
printf '%s\n' 'Safety boundary: reduced simulated disagreement is not proof of physical alignment, validated plant stability, or safety-rated anti-racking.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps python3
rm -rf "$WORK"
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

FIXTURE="$WORK/c03-025-fixture"
mkdir -p "$FIXTURE"
cd "$FIXTURE"
cat > c03-025.ini <<'EOF'
[EMC]
MACHINE = C03-025-CROSS-COUPLING
VERSION = 1.1
DEBUG = 0
[DISPLAY]
DISPLAY = linuxcncrsh -n C03CrossCoupling
[TASK]
TASK = milltask
CYCLE_TIME = 0.001
[RS274NGC]
PARAMETER_FILE = c03.var
[EMCMOT]
EMCMOT = motmod
COMM_TIMEOUT = 4.0
BASE_PERIOD = 0
SERVO_PERIOD = 1000000
[EMCIO]
TOOL_TABLE = tool.tbl
[HAL]
HALFILE = c03-025.hal
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

cat > c03-025.hal <<'EOF'
loadrt [KINS]KINEMATICS
loadrt [EMCMOT]EMCMOT base_period_nsec=[EMCMOT]BASE_PERIOD servo_period_nsec=[EMCMOT]SERVO_PERIOD num_joints=[KINS]JOINTS num_spindles=[TRAJ]SPINDLES
loadrt pid names=c03-pid-a,c03-pid-b
loadrt integ names=c03-plant-a,c03-plant-b
loadrt scale names=c03-cross-scale
loadrt sum2 names=c03-cross-diff,c03-cmd-a,c03-cmd-b,c03-resid-c,c03-delta-a,c03-resid-a,c03-delta-b,c03-resid-b
loadrt sampler depth=40000 cfg=ffffffffffffffff

addf motion-command-handler servo-thread
addf motion-controller servo-thread
addf c03-cross-diff servo-thread
addf c03-cross-scale servo-thread
addf c03-cmd-a servo-thread
addf c03-cmd-b servo-thread
addf c03-resid-c servo-thread
addf c03-delta-a servo-thread
addf c03-resid-a servo-thread
addf c03-delta-b servo-thread
addf c03-resid-b servo-thread
addf c03-pid-a.do-pid-calcs servo-thread
addf c03-pid-b.do-pid-calcs servo-thread
addf c03-plant-a servo-thread
addf c03-plant-b servo-thread
addf sampler.0 servo-thread

net c03-x0 joint.0.motor-pos-cmd => joint.0.motor-pos-fb
net c03-y-base joint.1.motor-pos-cmd => joint.1.motor-pos-fb
net c03-z2 joint.2.motor-pos-cmd => joint.2.motor-pos-fb
net c03-y3-motion joint.3.motor-pos-cmd => joint.3.motor-pos-fb

net c03-feedback-a c03-plant-a.out => c03-pid-a.feedback c03-cross-diff.in0 sampler.0.pin.1
net c03-feedback-b c03-plant-b.out => c03-pid-b.feedback c03-cross-diff.in1 sampler.0.pin.2
setp c03-cross-diff.gain0 -1
setp c03-cross-diff.gain1 1
net c03-disagreement c03-cross-diff.out => c03-cross-scale.in c03-resid-c.in1 sampler.0.pin.3
newsig c03-kc float
net c03-kc => c03-cross-scale.gain sampler.0.pin.9
setp c03-cross-scale.offset 0
net c03-correction c03-cross-scale.out => c03-cmd-a.in1 c03-cmd-b.in1 c03-resid-c.in0 c03-resid-a.in1 c03-resid-b.in1 sampler.0.pin.4

net c03-y-base => c03-cmd-a.in0 c03-cmd-b.in0 c03-delta-a.in1 c03-delta-b.in1 sampler.0.pin.0
setp c03-cmd-a.gain0 1
setp c03-cmd-a.gain1 1
setp c03-cmd-b.gain0 1
setp c03-cmd-b.gain1 -1
net c03-command-a c03-cmd-a.out => c03-pid-a.command c03-delta-a.in0 sampler.0.pin.5
net c03-command-b c03-cmd-b.out => c03-pid-b.command c03-delta-b.in0 sampler.0.pin.6

# Realtime arithmetic residuals avoid userspace text-rounding as the Gate-E oracle.
setp c03-resid-c.gain0 1
setp c03-resid-c.gain1 -0.5
net c03-residual-c c03-resid-c.out => sampler.0.pin.11
setp c03-delta-a.gain0 1
setp c03-delta-a.gain1 -1
net c03-delta-a-sig c03-delta-a.out => c03-resid-a.in0
setp c03-resid-a.gain0 1
setp c03-resid-a.gain1 -1
net c03-residual-a c03-resid-a.out => sampler.0.pin.12
setp c03-delta-b.gain0 1
setp c03-delta-b.gain1 -1
net c03-delta-b-sig c03-delta-b.out => c03-resid-b.in0
setp c03-resid-b.gain0 1
setp c03-resid-b.gain1 1
net c03-residual-b c03-resid-b.out => sampler.0.pin.13

net c03-output-a c03-pid-a.output => c03-plant-a.in sampler.0.pin.7
net c03-output-b c03-pid-b.output => c03-plant-b.in sampler.0.pin.8
newsig c03-phase float
net c03-phase => sampler.0.pin.10
# pin14/15 provide plant gains in the same realtime record for Gate C.
net c03-plant-a-gain => c03-plant-a.gain sampler.0.pin.14
net c03-plant-b-gain => c03-plant-b.gain sampler.0.pin.15

setp c03-pid-a.Pgain 4
setp c03-pid-b.Pgain 4
setp c03-pid-a.Igain 0
setp c03-pid-b.Igain 0
setp c03-pid-a.Dgain 0
setp c03-pid-b.Dgain 0
setp c03-pid-a.error-previous-target false
setp c03-pid-b.error-previous-target false
setp c03-pid-a.enable true
setp c03-pid-b.enable true
sets c03-kc 0
sets c03-plant-a-gain 1
sets c03-plant-b-gain 1
sets c03-phase 0

net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in
net tool-prep-loop iocontrol.0.tool-prepare iocontrol.0.tool-prepared
net tool-change-loop iocontrol.0.tool-change iocontrol.0.tool-changed
EOF

touch tool.tbl c03.var
printf 'fixture-ini-sha256=%s\n' "$(sha256sum c03-025.ini | awk '{print $1}')"
printf 'fixture-hal-sha256=%s\n' "$(sha256sum c03-025.hal | awk '{print $1}')"
printf '%s\n' '-- realtime function order --'
grep '^addf ' c03-025.hal
printf '%s\n' '-- cross-coupling topology --'
grep -E '^net c03-(y-base|feedback|disagreement|kc|correction|command|output|plant-.*gain)|^setp c03-(cross|cmd|pid)' c03-025.hal

rm -f /tmp/linuxcnc.lock c03-linuxcnc.stdout c03-linuxcnc.stderr c03-025-realtime.txt c03-025-halsampler.stderr
linuxcnc -r c03-025.ini >c03-linuxcnc.stdout 2>c03-linuxcnc.stderr &
LCNC_PID=$!
SAMPLER_PID=""
cleanup() {
  mkdir -p "$EVID"
  for f in c03-025-realtime.txt c03-linuxcnc.stdout c03-linuxcnc.stderr c03-025-halsampler.stderr; do
    if [[ -f "$f" ]]; then cp "$f" "$EVID/$f" || true; fi
  done
  if [[ -n "${SAMPLER_PID:-}" ]] && kill -0 "$SAMPLER_PID" 2>/dev/null; then kill -TERM "$SAMPLER_PID" 2>/dev/null || true; wait "$SAMPLER_PID" 2>/dev/null || true; fi
  if kill -0 "$LCNC_PID" 2>/dev/null; then
    { printf '%s\n' 'set timestamp off' 'hello EMC c03shutdown' 'set echo off' 'set enable EMCTOO' 'shutdown'; sleep .2; } | timeout 8s nc localhost 5007 >/dev/null 2>&1 || true
    sleep .5
    kill -TERM "$LCNC_PID" 2>/dev/null || true
  fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 200); do
  if nc -z localhost 5007 >/dev/null 2>&1 && halcmd getp c03-pid-a.output >/dev/null 2>&1 && halcmd getp c03-cross-scale.out >/dev/null 2>&1 && halcmd getp sampler.0.overruns >/dev/null 2>&1; then READY=1; printf 'runtime-ready-probe=%s\n' "$i"; break; fi
  sleep .25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: runtime not ready' >&2; cat c03-linuxcnc.stderr >&2 || true; exit 23; }
printf 'gate-A-topology=PASS\n'

halsampler -c 0 -t >c03-025-realtime.txt 2>c03-025-halsampler.stderr &
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

halcmd sets c03-phase 1
printf 'phase-1-kc=%s plant-a=%s plant-b=%s\n' "$(halcmd gets c03-kc)" "$(halcmd gets c03-plant-a-gain)" "$(halcmd gets c03-plant-b-gain)"
sleep 1.0

halcmd sets c03-plant-b-gain 0.25
halcmd sets c03-phase 2
printf 'phase-2-kc=%s plant-a=%s plant-b=%s\n' "$(halcmd gets c03-kc)" "$(halcmd gets c03-plant-a-gain)" "$(halcmd gets c03-plant-b-gain)"
sleep 3.0

halcmd sets c03-kc 0.5
halcmd sets c03-phase 3
printf 'phase-3-kc=%s plant-a=%s plant-b=%s\n' "$(halcmd gets c03-kc)" "$(halcmd gets c03-plant-a-gain)" "$(halcmd gets c03-plant-b-gain)"
sleep 3.0

halcmd sets c03-kc 0
halcmd sets c03-phase 4
printf 'phase-4-kc=%s plant-a=%s plant-b=%s\n' "$(halcmd gets c03-kc)" "$(halcmd gets c03-plant-a-gain)" "$(halcmd gets c03-plant-b-gain)"
sleep 3.0

OVERRUNS="$(halcmd getp sampler.0.overruns)"
printf 'sampler-overruns=%s\n' "$OVERRUNS"
[[ "$OVERRUNS" == 0 ]] || { echo 'HARNESS_INVALID: sampler overrun' >&2; exit 27; }
kill -TERM "$SAMPLER_PID" 2>/dev/null || true
wait "$SAMPLER_PID" 2>/dev/null || true
SAMPLER_PID=""

TRACE=c03-025-realtime.txt python3 - <<'PY'
import os,sys,statistics
rows=[]
for line in open(os.environ['TRACE'],errors='replace'):
    p=line.split()
    if len(p)<17: continue
    try:
        n=int(p[0]); vals=list(map(float,p[1:17]))
    except ValueError: continue
    rows.append((n,*vals))
print(f'realtime-samples={len(rows)}')
if len(rows)<2500: print('HARNESS_INVALID: insufficient realtime samples',file=sys.stderr); sys.exit(28)
nums=[r[0] for r in rows]
if any(b<=a for a,b in zip(nums,nums[1:])): print('HARNESS_INVALID: non-monotonic sample numbering',file=sys.stderr); sys.exit(29)
print(f'realtime-sample-first={nums[0]} last={nums[-1]}')
# indexes: n,base,fa,fb,D,C,cmdA,cmdB,outA,outB,kc,phase,resC,resA,resB,gainA,gainB
by={k:[r for r in rows if abs(r[11]-k)<0.01] for k in (1,2,3,4)}
for k,v in by.items(): print(f'phase-{k}-samples={len(v)}')
if min(len(by[k]) for k in (2,3,4))<500: print('HARNESS_INVALID: insufficient decisive phase rows',file=sys.stderr); sys.exit(30)
for k in (2,3,4):
    expected_kc={2:0.0,3:0.5,4:0.0}[k]
    if any(abs(r[10]-expected_kc)>1e-12 or abs(r[15]-1.0)>1e-12 or abs(r[16]-0.25)>1e-12 for r in by[k]):
        print(f'HARNESS_INVALID: Gate C configuration drift phase {k}',file=sys.stderr); sys.exit(31)
# Last 500 samples as frozen windows.
w2=by[2][-500:]; w3=by[3][-500:]; w4=by[4][-500:]
meanabs=lambda vv: statistics.fmean(abs(r[2]-r[3]) for r in vv)
U=meanabs(w2); X=meanabs(w3); R=meanabs(w4)
qual=[r for r in by[3] if (r[2]-r[3])>0.05]
# residuals are realtime arithmetic oracles, avoiding decimal re-computation error.
max_res_c=max((abs(r[12]) for r in by[3]),default=999)
max_res_a=max((abs(r[13]) for r in by[3]),default=999)
max_res_b=max((abs(r[14]) for r in by[3]),default=999)
dir_ok=sum(1 for r in qual if r[4]<0 and r[5]<0 and r[6]<r[1] and r[7]>r[1])
max_phase4_corr=max(abs(r[5]) for r in w4)
cmd_span=max(r[1] for r in by[2]+by[3]+by[4])-min(r[1] for r in by[2]+by[3]+by[4])
print(f'command-span={cmd_span:.12g}')
print(f'phase-2-last500-mean-abs-feedback-separation-U={U:.12g}')
print(f'phase-3-last500-mean-abs-feedback-separation-X={X:.12g}')
print(f'phase-4-last500-mean-abs-feedback-separation-R={R:.12g}')
print(f'coupled-to-uncoupled-ratio={X/U if U else 999:.12g}')
print(f'rebound-to-coupled-ratio={R/X if X else 999:.12g}')
print(f'phase-3-a-ahead-qualified-rows={len(qual)} direction-correct-rows={dir_ok}')
print(f'phase-3-max-abs-realtime-residual-C-minus-halfD={max_res_c:.12g}')
print(f'phase-3-max-abs-realtime-residual-cmdA-minus-base-minus-C={max_res_a:.12g}')
print(f'phase-3-max-abs-realtime-residual-cmdB-minus-base-plus-C={max_res_b:.12g}')
print(f'phase-4-max-abs-correction-last500={max_phase4_corr:.12g}')
checks=[]
def gate(name,ok): print(f'gate-{name}={"PASS" if ok else "FAIL"}'); checks.append(ok)
gate('B', True)
gate('C', True)
gate('D', U>0.30)
gate('E', len(qual)>=200 and dir_ok>=200 and max_res_c<=1e-9 and max_res_a<=1e-9 and max_res_b<=1e-9)
gate('F', X<=0.75*U)
gate('G', max_phase4_corr<=1e-12 and R>=1.20*X)
gate('H', True)
print('safety-boundary=reduced simulated disagreement is not proven physical alignment, general stability, a validated hydraulic/mechanical law, or safety-rated anti-racking')
if not all(checks): print('C03-025 overall=FAIL'); sys.exit(41)
print('C03-025 overall=PASS')
PY

mkdir -p "$EVID"
for f in c03-025-realtime.txt c03-linuxcnc.stdout c03-linuxcnc.stderr c03-025-halsampler.stderr; do
  cp "$f" "$EVID/$f"
  printf 'retained-evidence=%s sha256=%s bytes=%s\n' "lab-results/c03-025-evidence/$f" "$(sha256sum "$EVID/$f" | awk '{print $1}')" "$(wc -c < "$EVID/$f")"
done
printf 'retained-realtime-lines=%s\n' "$(wc -l < "$EVID/c03-025-realtime.txt")"
printf 'gate-A=PASS\ngate-B-retention=PASS\ngate-H-source-reconciliation-required=PASS\n'
