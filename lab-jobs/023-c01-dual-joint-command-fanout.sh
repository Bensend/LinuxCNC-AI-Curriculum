#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c01-dual-joint"

printf '== C01-023 duplicated-coordinate dual-joint command fan-out ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen prediction: a nonzero coordinated Y move with trivkins coordinates=XYZY kinstype=BOTH produces matching joint.1 and joint.3 motor position commands while preserving separate joint HAL interfaces.'
printf '%s\n' 'Simulation boundary: per-joint motor-pos-cmd -> motor-pos-fb is an ideal loopback fixture, not proof that two physical actuators are synchronized.'
printf '%s\n' 'Observation boundary: world Y alone is never accepted as proof of joint.3 feedback or physical position truth.'

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
PYMOD_PATH="$(python3 - <<'PY'
import linuxcnc
print(linuxcnc.__file__)
PY
)"
HALMOD_PATH="$(python3 - <<'PY'
import hal
print(hal.__file__)
PY
)"
printf 'linuxcnc-bin=%s\nlinuxcnc-python-module=%s\nhal-python-module=%s\n' "$LINUXCNC_BIN" "$PYMOD_PATH" "$HALMOD_PATH"
case "$(readlink -f "$LINUXCNC_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: linuxcnc executable is not from pinned work tree' >&2; exit 21;; esac
case "$(readlink -f "$PYMOD_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: python linuxcnc module is not from pinned work tree' >&2; exit 22;; esac
case "$(readlink -f "$HALMOD_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: python hal module is not from pinned work tree' >&2; exit 23;; esac
printf 'gate-A=PASS\n'

FIXTURE="$WORK/c01-023-fixture"
mkdir -p "$FIXTURE"
cd "$FIXTURE"
cat > c01-023.ini <<'EOF'
[EMC]
MACHINE = C01-023-DUAL-JOINT-SIM
VERSION = 1.1
DEBUG = 0

[DISPLAY]
DISPLAY = linuxcncrsh -n C01DualJointSim

[TASK]
TASK = milltask
CYCLE_TIME = 0.001

[RS274NGC]
PARAMETER_FILE = c01.var

[EMCMOT]
EMCMOT = motmod
COMM_TIMEOUT = 4.0
BASE_PERIOD = 0
SERVO_PERIOD = 1000000

[EMCIO]
TOOL_TABLE = tool.tbl

[HAL]
HALFILE = c01-023.hal

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
MIN_LIMIT = -10
MAX_LIMIT = 10
MAX_VELOCITY = 4
MAX_ACCELERATION = 20

[AXIS_Y]
MIN_LIMIT = -10
MAX_LIMIT = 10
MAX_VELOCITY = 4
MAX_ACCELERATION = 20

[AXIS_Z]
MIN_LIMIT = -10
MAX_LIMIT = 10
MAX_VELOCITY = 4
MAX_ACCELERATION = 20

[JOINT_0]
TYPE = LINEAR
MIN_LIMIT = -10
MAX_LIMIT = 10
MAX_VELOCITY = 4
MAX_ACCELERATION = 20
FERROR = 1
MIN_FERROR = 0.01
HOME = 0
HOME_OFFSET = 0
HOME_SEARCH_VEL = 0
HOME_LATCH_VEL = 0
HOME_SEQUENCE = 0

[JOINT_1]
TYPE = LINEAR
MIN_LIMIT = -10
MAX_LIMIT = 10
MAX_VELOCITY = 4
MAX_ACCELERATION = 20
FERROR = 1
MIN_FERROR = 0.01
HOME = 0
HOME_OFFSET = 0
HOME_SEARCH_VEL = 0
HOME_LATCH_VEL = 0
HOME_SEQUENCE = -1

[JOINT_2]
TYPE = LINEAR
MIN_LIMIT = -10
MAX_LIMIT = 10
MAX_VELOCITY = 4
MAX_ACCELERATION = 20
FERROR = 1
MIN_FERROR = 0.01
HOME = 0
HOME_OFFSET = 0
HOME_SEARCH_VEL = 0
HOME_LATCH_VEL = 0
HOME_SEQUENCE = 2

[JOINT_3]
TYPE = LINEAR
MIN_LIMIT = -10
MAX_LIMIT = 10
MAX_VELOCITY = 4
MAX_ACCELERATION = 20
FERROR = 1
MIN_FERROR = 0.01
HOME = 0
HOME_OFFSET = 0
HOME_SEARCH_VEL = 0
HOME_LATCH_VEL = 0
HOME_SEQUENCE = -1
EOF

cat > c01-023.hal <<'EOF'
loadrt [KINS]KINEMATICS
loadrt [EMCMOT]EMCMOT base_period_nsec=[EMCMOT]BASE_PERIOD servo_period_nsec=[EMCMOT]SERVO_PERIOD num_joints=[KINS]JOINTS num_spindles=[TRAJ]SPINDLES

addf motion-command-handler servo-thread
addf motion-controller servo-thread

# Ideal, separate per-joint command-to-feedback loopbacks.
net c01-x0 joint.0.motor-pos-cmd => joint.0.motor-pos-fb
net c01-y1 joint.1.motor-pos-cmd => joint.1.motor-pos-fb
net c01-z2 joint.2.motor-pos-cmd => joint.2.motor-pos-fb
net c01-y3 joint.3.motor-pos-cmd => joint.3.motor-pos-fb

# Standard simulation ESTOP loopback.
net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in
net tool-prep-loop iocontrol.0.tool-prepare iocontrol.0.tool-prepared
net tool-change-loop iocontrol.0.tool-change iocontrol.0.tool-changed
EOF

printf 'fixture-ini=%s\n' "$FIXTURE/c01-023.ini"
printf 'fixture-ini-sha256=%s\n' "$(sha256sum c01-023.ini | awk '{print $1}')"
printf 'fixture-hal-sha256=%s\n' "$(sha256sum c01-023.hal | awk '{print $1}')"
printf '%s\n' '-- active declared topology --'
grep -E '^(JOINTS|KINEMATICS|COORDINATES)[[:space:]]*=' c01-023.ini

rm -f /tmp/linuxcnc.lock c01-linuxcnc.stdout c01-linuxcnc.stderr c01-023-trace.csv
linuxcnc -r c01-023.ini >c01-linuxcnc.stdout 2>c01-linuxcnc.stderr &
LCNC_PID=$!
printf 'linuxcnc-launcher-pid=%s\n' "$LCNC_PID"

rsh_shutdown() {
  {
    printf '%s\n' 'set timestamp off'
    printf '%s\n' 'hello EMC c01shutdown'
    printf '%s\n' 'set echo off'
    printf '%s\n' 'set enable EMCTOO'
    printf '%s\n' 'shutdown'
    sleep 0.2
  } | timeout 8s nc localhost 5007 >/tmp/c01-shutdown.txt 2>/tmp/c01-shutdown.err || true
}
cleanup() {
  if kill -0 "$LCNC_PID" 2>/dev/null; then
    rsh_shutdown
    for _ in $(seq 1 60); do
      kill -0 "$LCNC_PID" 2>/dev/null || break
      sleep 0.1
    done
    kill -TERM "$LCNC_PID" 2>/dev/null || true
  fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 200); do
  if nc -z localhost 5007 >/dev/null 2>&1 && timeout 3s halcmd getp joint.3.motor-pos-cmd >/dev/null 2>&1; then
    READY=1
    printf 'runtime-ready-probe=%s\n' "$i"
    break
  fi
  sleep 0.25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: LinuxCNC/NML/HAL fixture did not become ready' >&2; cat c01-linuxcnc.stderr >&2 || true; exit 24; }

printf '%s\n' '-- runtime joint endpoints --'
for p in joint.1.motor-pos-cmd joint.3.motor-pos-cmd joint.1.motor-pos-fb joint.3.motor-pos-fb; do
  v="$(halcmd getp "$p")" || { echo "HARNESS_INVALID: missing runtime pin $p" >&2; exit 25; }
  printf 'runtime-pin=%s value=%s\n' "$p" "$v"
done

TRACE="$FIXTURE/c01-023-trace.csv" python3 - <<'PY'
import csv, math, os, sys, time
import hal
import linuxcnc

trace_path = os.environ['TRACE']
s = linuxcnc.stat()
c = linuxcnc.command()
e = linuxcnc.error_channel()

required = ['STATE_ESTOP_RESET','STATE_ON','MODE_MANUAL','MODE_MDI']
missing = [n for n in required if not hasattr(linuxcnc,n)]
if missing:
    print('HARNESS_INVALID: missing linuxcnc constants: ' + ','.join(missing), file=sys.stderr)
    sys.exit(26)

def poll():
    s.poll(); return s

def wait_pred(label, predicate, timeout=12.0):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        poll()
        if predicate(s):
            print(f'{label}=PASS')
            return True
        err = e.poll()
        if err: print(f'error-during-{label}={err}')
        time.sleep(0.01)
    print(f'HARNESS_INVALID: timeout waiting for {label}', file=sys.stderr)
    return False

def cmd_wait(label, timeout=5.0):
    rc = c.wait_complete(timeout)
    print(f'{label}-wait-complete={rc}')
    if rc not in (0,1):
        print(f'HARNESS_INVALID: {label} wait_complete returned {rc}', file=sys.stderr)
        sys.exit(27)

def hv(name):
    return float(hal.get_value(name))

# Runtime topology and distinct HAL object proof.
pins = ['joint.1.motor-pos-cmd','joint.3.motor-pos-cmd','joint.1.motor-pos-fb','joint.3.motor-pos-fb']
for p in pins:
    try:
        print(f'hal-python-pin={p} value={hv(p):.12f}')
    except Exception as exc:
        print(f'HARNESS_INVALID: cannot independently read {p}: {exc}', file=sys.stderr)
        sys.exit(28)
print('gate-C=PASS')

poll()
c.state(linuxcnc.STATE_ESTOP_RESET); cmd_wait('estop-reset')
c.state(linuxcnc.STATE_ON); cmd_wait('machine-on')
c.mode(linuxcnc.MODE_MANUAL); cmd_wait('manual-mode')

poll()
print(f'runtime-joint-count={int(s.joints)}')
if int(s.joints) != 4:
    print('PREDICTION_FALSIFIED: runtime did not report four joints', file=sys.stderr)
    sys.exit(40)

# Home all joints using the configured sequences, including synchronized
# negative sequence for the duplicated Y joints.
c.home(-1)
if not wait_pred('all-active-joints-homed', lambda st: all(bool(st.homed[j]) for j in range(4)), 12.0):
    print('HARNESS_INVALID: failed to establish four-joint homed state', file=sys.stderr)
    sys.exit(29)
if not wait_pred('pre-move-inpos', lambda st: bool(st.inpos), 5.0):
    sys.exit(30)
poll()
print('homed-vector=' + ','.join(str(int(bool(s.homed[j]))) for j in range(4)))
print(f'pre-move-task-state={int(s.task_state)} task-mode={int(s.task_mode)} motion-mode={int(s.motion_mode)}')
print('gate-B=PASS')

# Establish MDI/world coordinated motion. 5 in at 60 in/min gives enough
# time to collect a dense trace without excessive CI time.
c.mode(linuxcnc.MODE_MDI); cmd_wait('mdi-mode')
poll()
base_y = float(s.position[1])
base_j1 = hv('joint.1.motor-pos-cmd')
base_j3 = hv('joint.3.motor-pos-cmd')
print(f'baseline-world-y={base_y:.12f} joint1-cmd={base_j1:.12f} joint3-cmd={base_j3:.12f}')

target = base_y + 5.0
c.mdi(f'G20 G90 G1 Y{target:.9f} F60')

fields = ['t','world_y_cmd','world_y_actual','inpos','j1_cmd','j3_cmd','j1_fb','j3_fb','cmd_diff','j1_loopback_diff','j3_loopback_diff']
rows=[]
errors=[]
start=time.monotonic()
saw_nontrivial=False
saw_not_inpos=False
finished=False
max_cmd_diff=0.0
max_j1_loop=0.0
max_j3_loop=0.0

with open(trace_path,'w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=fields); w.writeheader()
    deadline=start+12.0
    while time.monotonic() < deadline:
        now=time.monotonic(); poll()
        j1c=hv('joint.1.motor-pos-cmd'); j3c=hv('joint.3.motor-pos-cmd')
        j1f=hv('joint.1.motor-pos-fb'); j3f=hv('joint.3.motor-pos-fb')
        diff=abs(j1c-j3c); d1=abs(j1c-j1f); d3=abs(j3c-j3f)
        max_cmd_diff=max(max_cmd_diff,diff); max_j1_loop=max(max_j1_loop,d1); max_j3_loop=max(max_j3_loop,d3)
        wyc=float(s.position[1]); wya=float(s.actual_position[1]); inp=bool(s.inpos)
        if abs(j1c-base_j1)>0.01 and abs(j3c-base_j3)>0.01: saw_nontrivial=True
        if not inp: saw_not_inpos=True
        row={'t':f'{now-start:.6f}','world_y_cmd':f'{wyc:.12f}','world_y_actual':f'{wya:.12f}','inpos':int(inp),
             'j1_cmd':f'{j1c:.12f}','j3_cmd':f'{j3c:.12f}','j1_fb':f'{j1f:.12f}','j3_fb':f'{j3f:.12f}',
             'cmd_diff':f'{diff:.12g}','j1_loopback_diff':f'{d1:.12g}','j3_loopback_diff':f'{d3:.12g}'}
        w.writerow(row); rows.append(row)
        while True:
            err=e.poll()
            if not err: break
            errors.append(err); print(f'error-channel={err}')
        if saw_nontrivial and saw_not_inpos and inp and abs(j1c-target)<1e-6 and abs(j3c-target)<1e-6:
            finished=True; break
        time.sleep(0.005)

print(f'trace-samples={len(rows)}')
print(f'saw-nontrivial-both-joints={int(saw_nontrivial)}')
print(f'saw-moving-not-inpos={int(saw_not_inpos)}')
print(f'program-move-finished={int(finished)}')
print(f'max-abs-j1-j3-command-diff={max_cmd_diff:.12g}')
print(f'max-abs-j1-command-feedback-loopback-diff={max_j1_loop:.12g}')
print(f'max-abs-j3-command-feedback-loopback-diff={max_j3_loop:.12g}')
print(f'error-count={len(errors)}')

if not saw_nontrivial or not saw_not_inpos:
    print('HARNESS_INVALID: no meaningful coordinated move was independently observed', file=sys.stderr)
    sys.exit(31)
print('gate-D=PASS')
if max_cmd_diff > 1e-9:
    print('PREDICTION_FALSIFIED: duplicated Y joint commands diverged beyond frozen tolerance', file=sys.stderr)
    sys.exit(41)
if not finished:
    print('HARNESS_INVALID: coordinated move did not finish at expected duplicated-joint target', file=sys.stderr)
    sys.exit(32)
print('gate-E=PASS')
if max_j1_loop > 1e-9 or max_j3_loop > 1e-9:
    print('PREDICTION_FALSIFIED: runtime did not exhibit the declared ideal per-joint command-feedback loopback', file=sys.stderr)
    sys.exit(42)
print('gate-F=PASS')
if errors:
    print('PREDICTION_FALSIFIED: unexpected LinuxCNC error-channel events occurred', file=sys.stderr)
    sys.exit(43)

# Gate G is an evidence discipline gate: joint.3 was directly observed above;
# world Y was not used as a substitute for the second joint's own feedback.
print('joint3-proof-source=direct joint.3.motor-pos-fb observation')
print('world-y-alone-used-as-joint3-proof=NO')
print('gate-G=PASS')
print('C01-023 behavioral-gates-A-through-G=PASS')
PY

printf '\n== Raw trace evidence ==\n'
printf '%s\n' '-- first 10 samples --'
head -n 11 c01-023-trace.csv
printf '%s\n' '-- midpoint samples --'
python3 - c01-023-trace.csv <<'PY'
import csv,sys
rows=list(csv.reader(open(sys.argv[1])))
if len(rows)>2:
    mid=max(1,(len(rows)-1)//2)
    print(','.join(rows[0]))
    for r in rows[max(1,mid-2):min(len(rows),mid+3)]: print(','.join(r))
PY
printf '%s\n' '-- final 10 samples --'
tail -n 10 c01-023-trace.csv
printf '%s\n' '=== BEGIN C01-023 FULL RAW TRACE CSV ==='
cat c01-023-trace.csv
printf '%s\n' '=== END C01-023 FULL RAW TRACE CSV ==='

# Controlled cleanup and independent disappearance proof for Gate H.
rsh_shutdown
for _ in $(seq 1 80); do
  if ! kill -0 "$LCNC_PID" 2>/dev/null; then break; fi
  sleep 0.1
done
if kill -0 "$LCNC_PID" 2>/dev/null; then
  echo 'HARNESS_INVALID: LinuxCNC launcher remained alive after shutdown request' >&2
  exit 33
fi
wait "$LCNC_PID" 2>/dev/null || true
trap - EXIT

if nc -z localhost 5007 >/dev/null 2>&1; then
  echo 'HARNESS_INVALID: linuxcncrsh TCP endpoint remained after launcher exit' >&2
  exit 34
fi
if halcmd getp joint.3.motor-pos-cmd >/dev/null 2>&1; then
  echo 'HARNESS_INVALID: joint HAL namespace remained after runtime shutdown' >&2
  exit 35
fi
printf 'gate-H=PASS\n'
printf '%s\n' 'C01-023 overall=PASS'
printf '%s\n' 'Conclusion boundary: TEST evidence, if all gates pass, is limited to duplicated-coordinate command fan-out and separate simulated joint observability. It is not proof of physical actuator synchronization, physical feedback freshness, hydraulic behavior, or functional safety.'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
