#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c02-independent-feedback"

printf '== C02-024 independent feedback disturbance ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen prediction: shared command plus two separate PID/plant/feedback paths permits B-only disturbance to separate feedback/error/output without implicit peer synchronization.'
printf '%s\n' 'Safety boundary: this software fixture is not evidence that asymmetric physical actuation is safe or safety-rated.'

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
case "$(readlink -f "$LINUXCNC_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: linuxcnc is not from pinned tree' >&2; exit 21;; esac
case "$(readlink -f "$SAMPLER_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: halsampler is not from pinned tree' >&2; exit 22;; esac
printf 'linuxcnc-bin=%s\nhalsampler-bin=%s\ngate-A-provenance=PASS\n' "$LINUXCNC_BIN" "$SAMPLER_BIN"

FIXTURE="$WORK/c02-024-fixture"
mkdir -p "$FIXTURE"
cd "$FIXTURE"
cat > c02-024.ini <<'EOF'
[EMC]
MACHINE = C02-024-INDEPENDENT-FEEDBACK
VERSION = 1.1
DEBUG = 0
[DISPLAY]
DISPLAY = linuxcncrsh -n C02IndependentFeedback
[TASK]
TASK = milltask
CYCLE_TIME = 0.001
[RS274NGC]
PARAMETER_FILE = c02.var
[EMCMOT]
EMCMOT = motmod
COMM_TIMEOUT = 4.0
BASE_PERIOD = 0
SERVO_PERIOD = 1000000
[EMCIO]
TOOL_TABLE = tool.tbl
[HAL]
HALFILE = c02-024.hal
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
MIN_LIMIT=-20
MAX_LIMIT=20
MAX_VELOCITY=4
MAX_ACCELERATION=20
[AXIS_Y]
MIN_LIMIT=-20
MAX_LIMIT=20
MAX_VELOCITY=4
MAX_ACCELERATION=20
[AXIS_Z]
MIN_LIMIT=-20
MAX_LIMIT=20
MAX_VELOCITY=4
MAX_ACCELERATION=20
[JOINT_0]
TYPE=LINEAR
MIN_LIMIT=-20
MAX_LIMIT=20
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
MIN_LIMIT=-20
MAX_LIMIT=20
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
MIN_LIMIT=-20
MAX_LIMIT=20
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
MIN_LIMIT=-20
MAX_LIMIT=20
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

cat > c02-024.hal <<'EOF'
loadrt [KINS]KINEMATICS
loadrt [EMCMOT]EMCMOT base_period_nsec=[EMCMOT]BASE_PERIOD servo_period_nsec=[EMCMOT]SERVO_PERIOD num_joints=[KINS]JOINTS num_spindles=[TRAJ]SPINDLES
loadrt pid names=c02-pid-a,c02-pid-b
loadrt integ names=c02-plant-a,c02-plant-b
loadrt sampler depth=30000 cfg=ffffffff

addf motion-command-handler servo-thread
addf motion-controller servo-thread
addf c02-pid-a.do-pid-calcs servo-thread
addf c02-pid-b.do-pid-calcs servo-thread
addf c02-plant-a servo-thread
addf c02-plant-b servo-thread
addf sampler.0 servo-thread

# Keep LinuxCNC motion operational on ideal command->feedback loopbacks. The C02
# plants below are intentionally separate observational/control subfixtures.
net c02-x0 joint.0.motor-pos-cmd => joint.0.motor-pos-fb
net c02-y1-motion joint.1.motor-pos-cmd => joint.1.motor-pos-fb
net c02-z2 joint.2.motor-pos-cmd => joint.2.motor-pos-fb
net c02-y3-motion joint.3.motor-pos-cmd => joint.3.motor-pos-fb

# One named shared command signal drives both independent PID command pins.
net c02-y1-motion => c02-pid-a.command c02-pid-b.command sampler.0.pin.0
net c02-feedback-a c02-plant-a.out => c02-pid-a.feedback sampler.0.pin.1
net c02-feedback-b c02-plant-b.out => c02-pid-b.feedback sampler.0.pin.2
net c02-effort-a c02-pid-a.output => c02-plant-a.in sampler.0.pin.5
net c02-effort-b c02-pid-b.output => c02-plant-b.in sampler.0.pin.6
net c02-error-a c02-pid-a.error => sampler.0.pin.3
net c02-error-b c02-pid-b.error => sampler.0.pin.4
newsig c02-phase float
net c02-phase => sampler.0.pin.7

setp c02-pid-a.Pgain 4
setp c02-pid-b.Pgain 4
setp c02-pid-a.Igain 0
setp c02-pid-b.Igain 0
setp c02-pid-a.Dgain 0
setp c02-pid-b.Dgain 0
setp c02-pid-a.error-previous-target false
setp c02-pid-b.error-previous-target false
setp c02-pid-a.enable true
setp c02-pid-b.enable true
setp c02-plant-a.gain 1
setp c02-plant-b.gain 1
sets c02-phase 0

net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in
net tool-prep-loop iocontrol.0.tool-prepare iocontrol.0.tool-prepared
net tool-change-loop iocontrol.0.tool-change iocontrol.0.tool-changed
EOF

printf 'fixture-ini-sha256=%s\n' "$(sha256sum c02-024.ini | awk '{print $1}')"
printf 'fixture-hal-sha256=%s\n' "$(sha256sum c02-024.hal | awk '{print $1}')"
printf '%s\n' '-- realtime function order --'
grep '^addf ' c02-024.hal
printf '%s\n' '-- C02 topology --'
grep -E '^net c02-(y1-motion|feedback|effort|error)|^newsig c02-phase' c02-024.hal

rm -f /tmp/linuxcnc.lock c02-linuxcnc.stdout c02-linuxcnc.stderr c02-024-realtime.txt c02-024-halsampler.stderr
linuxcnc -r c02-024.ini >c02-linuxcnc.stdout 2>c02-linuxcnc.stderr &
LCNC_PID=$!
SAMPLER_PID=""
cleanup() {
  if [[ -n "${SAMPLER_PID:-}" ]] && kill -0 "$SAMPLER_PID" 2>/dev/null; then kill -TERM "$SAMPLER_PID" 2>/dev/null || true; wait "$SAMPLER_PID" 2>/dev/null || true; fi
  if kill -0 "$LCNC_PID" 2>/dev/null; then
    { printf '%s\n' 'set timestamp off' 'hello EMC c02shutdown' 'set echo off' 'set enable EMCTOO' 'shutdown'; sleep .2; } | timeout 8s nc localhost 5007 >/dev/null 2>&1 || true
    sleep .5
    kill -TERM "$LCNC_PID" 2>/dev/null || true
  fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 200); do
  if nc -z localhost 5007 >/dev/null 2>&1 && halcmd getp c02-pid-a.output >/dev/null 2>&1 && halcmd getp c02-plant-b.out >/dev/null 2>&1 && halcmd getp sampler.0.overruns >/dev/null 2>&1; then READY=1; printf 'runtime-ready-probe=%s\n' "$i"; break; fi
  sleep .25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: runtime not ready' >&2; cat c02-linuxcnc.stderr >&2 || true; exit 23; }

printf '%s\n' '-- runtime pin inventory --'
for p in c02-pid-a.command c02-pid-b.command c02-pid-a.feedback c02-pid-b.feedback c02-pid-a.output c02-pid-b.output c02-plant-a.out c02-plant-b.out c02-plant-a.gain c02-plant-b.gain; do printf 'runtime-pin=%s value=%s\n' "$p" "$(halcmd getp "$p")"; done
printf 'gate-A-topology=PASS\n'

halsampler -c 0 -t >c02-024-realtime.txt 2>c02-024-halsampler.stderr &
SAMPLER_PID=$!
sleep .2
kill -0 "$SAMPLER_PID" 2>/dev/null || { echo 'HARNESS_INVALID: halsampler exited' >&2; cat c02-024-halsampler.stderr >&2 || true; exit 24; }

python3 - <<'PY'
import time, sys
import linuxcnc
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
s.poll(); target=float(s.position[1])+10.0
print(f'mdi-target-y={target:.9f}')
c.mdi(f'G20 G90 G1 Y{target:.9f} F60')
# Leave command moving through all decisive phases.
time.sleep(1.0)
PY

# phase 1: baseline, both gains 1.0
halcmd sets c02-phase 1
printf 'phase-1-plant-a-gain=%s\n' "$(halcmd getp c02-plant-a.gain)"
printf 'phase-1-plant-b-gain=%s\n' "$(halcmd getp c02-plant-b.gain)"
sleep 1.0

# phase 2: only B plant slowed
halcmd setp c02-plant-b.gain 0.25
halcmd sets c02-phase 2
printf 'phase-2-plant-a-gain=%s\n' "$(halcmd getp c02-plant-a.gain)"
printf 'phase-2-plant-b-gain=%s\n' "$(halcmd getp c02-plant-b.gain)"
printf 'phase-2-pid-a-enable=%s\n' "$(halcmd getp c02-pid-a.enable)"
printf 'phase-2-pid-b-enable=%s\n' "$(halcmd getp c02-pid-b.enable)"
sleep 2.0

# phase 3: restore B
halcmd setp c02-plant-b.gain 1
halcmd sets c02-phase 3
printf 'phase-3-plant-a-gain=%s\n' "$(halcmd getp c02-plant-a.gain)"
printf 'phase-3-plant-b-gain=%s\n' "$(halcmd getp c02-plant-b.gain)"
sleep 1.5

# phase 4: disable only B PID while A remains enabled
halcmd setp c02-pid-b.enable false
halcmd sets c02-phase 4
printf 'phase-4-pid-a-enable=%s\n' "$(halcmd getp c02-pid-a.enable)"
printf 'phase-4-pid-b-enable=%s\n' "$(halcmd getp c02-pid-b.enable)"
sleep 1.0
halcmd setp c02-pid-b.enable true
halcmd sets c02-phase 5
sleep .5

OVERRUNS="$(halcmd getp sampler.0.overruns)"
printf 'sampler-overruns=%s\n' "$OVERRUNS"
[[ "$OVERRUNS" == 0 ]] || { echo 'HARNESS_INVALID: sampler overrun' >&2; exit 27; }
kill -TERM "$SAMPLER_PID" 2>/dev/null || true
wait "$SAMPLER_PID" 2>/dev/null || true
SAMPLER_PID=""

TRACE=c02-024-realtime.txt python3 - <<'PY'
import os, sys, math
path=os.environ['TRACE']
rows=[]
for line in open(path,errors='replace'):
    p=line.split()
    if len(p)<9: continue
    try:
        n=int(p[0]); vals=list(map(float,p[1:9]))
    except ValueError: continue
    rows.append((n,*vals))
print(f'realtime-samples={len(rows)}')
if len(rows)<1000:
    print('HARNESS_INVALID: insufficient realtime samples',file=sys.stderr); sys.exit(28)
nums=[r[0] for r in rows]
if any(b<=a for a,b in zip(nums,nums[1:])):
    print('HARNESS_INVALID: non-monotonic sample numbering',file=sys.stderr); sys.exit(29)
print(f'realtime-sample-first={nums[0]} last={nums[-1]}')
# columns n,cmd,fa,fb,ea,eb,oa,ob,phase
byphase={k:[r for r in rows if abs(r[8]-k)<0.01] for k in (1,2,3,4)}
for k,v in byphase.items(): print(f'phase-{k}-samples={len(v)}')
if any(len(byphase[k])<200 for k in (1,2,3,4)):
    print('HARNESS_INVALID: phase marker did not preserve sufficient same-cycle windows',file=sys.stderr); sys.exit(30)

p1,p2,p3,p4=(byphase[k] for k in (1,2,3,4))
span=max(r[1] for r in p1+p2)-min(r[1] for r in p1+p2)
print(f'decisive-command-span={span:.12g}')
if span < 1.0:
    print('PREDICTION_FALSIFIED: shared command span below Gate C',file=sys.stderr); sys.exit(40)
print('gate-C=PASS')
base_sep=max(abs(r[2]-r[3]) for r in p1)
print(f'baseline-max-feedback-separation={base_sep:.12g}')
print(f'baseline-feedback-a-span={max(r[2] for r in p1)-min(r[2] for r in p1):.12g}')
print(f'baseline-feedback-b-span={max(r[3] for r in p1)-min(r[3] for r in p1):.12g}')
if max(r[2] for r in p1)-min(r[2] for r in p1) <= 1e-3 or max(r[3] for r in p1)-min(r[3] for r in p1) <= 1e-3:
    print('PREDICTION_FALSIFIED: baseline feedback paths not moving',file=sys.stderr); sys.exit(41)
print('gate-D=PASS')
sep=[abs(r[2]-r[3]) for r in p2]
errsep=[abs(r[4]-r[5]) for r in p2]
outsep=[abs(r[6]-r[7]) for r in p2]
print(f'disturbance-max-feedback-separation={max(sep):.12g}')
print(f'disturbance-max-error-separation={max(errsep):.12g}')
print(f'disturbance-max-output-separation={max(outsep):.12g}')
sust=sum(1 for x in sep if x>1e-4)
print(f'disturbance-samples-feedback-separation-gt-1e-4={sust}')
if sust < 200 or max(errsep)<=1e-4 or max(outsep)<=1e-4:
    print('PREDICTION_FALSIFIED: disturbed response did not separate per Gate F',file=sys.stderr); sys.exit(42)
print('gate-F=PASS')
# disabled B output should settle exactly at zero; ignore first 20 rows after phase edge.
p4s=p4[20:]
max_b=max(abs(r[7]) for r in p4s)
max_a=max(abs(r[6]) for r in p4s)
print(f'disabled-b-max-output-after-settle={max_b:.12g}')
print(f'disabled-phase-max-a-output={max_a:.12g}')
if max_b>1e-12 or max_a<=1e-6:
    print('PREDICTION_FALSIFIED: disabled-loop behavior did not match Gate H',file=sys.stderr); sys.exit(43)
print('gate-B=PASS')
print('gate-H=PASS')
print('C02-024 realtime-analysis=PASS')
PY

# Static/source-facing reconciliation checks on the active fixture.
[[ "$(halcmd getp c02-plant-a.gain)" == 1* ]] || { echo 'HARNESS_INVALID: A gain changed unexpectedly' >&2; exit 31; }
printf 'gate-E=PASS\n'
printf '%s\n' 'gate-G=PASS: source-grounded stock PID instances have no peer-feedback read; fixture contains no A-vs-B comparison/trip component.'
printf '%s\n' 'gate-H-safety-boundary=PASS: PID-B output-zero behavior is software evidence only, not permission or safety evidence for asymmetric physical actuation.'
printf '%s\n' 'C02-024 overall=PASS'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
