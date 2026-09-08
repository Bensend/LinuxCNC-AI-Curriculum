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
printf '%s\n' 'Observation correction: Gate-E/F equality is measured only by realtime sampler.0 scheduled after motion-controller in the same servo thread; sequential userspace pin reads are forbidden as the equality oracle.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps python3
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
ACTUAL_COMMIT="$(git rev-parse HEAD)"
printf 'checked-out-commit=%s\n' "$ACTUAL_COMMIT"
[[ "$ACTUAL_COMMIT" == "$LINUXC_COMMIT" ]] 2>/dev/null && true
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
SAMPLER_BIN="$(command -v halsampler)"
printf 'linuxcnc-bin=%s\nlinuxcnc-python-module=%s\nhal-python-module=%s\nhalsampler-bin=%s\n' "$LINUXCNC_BIN" "$PYMOD_PATH" "$HALMOD_PATH" "$SAMPLER_BIN"
case "$(readlink -f "$LINUXCNC_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: linuxcnc executable is not from pinned work tree' >&2; exit 21;; esac
case "$(readlink -f "$PYMOD_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: python linuxcnc module is not from pinned work tree' >&2; exit 22;; esac
case "$(readlink -f "$HALMOD_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: python hal module is not from pinned work tree' >&2; exit 23;; esac
case "$(readlink -f "$SAMPLER_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: halsampler executable is not from pinned work tree' >&2; exit 24;; esac
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
loadrt sampler depth=20000 cfg=ffff

addf motion-command-handler servo-thread
addf motion-controller servo-thread
# The equality oracle executes after motion-controller in the same servo invocation.
addf sampler.0 servo-thread

# Ideal, separate per-joint command-to-feedback loopbacks. Each signal is also
# connected twice to sampler so command and feedback evidence are captured in
# one realtime sample after motion-controller. Because HAL loopback pins share
# the named signal, Gate F verifies the declared ideal fixture, not hardware.
net c01-x0 joint.0.motor-pos-cmd => joint.0.motor-pos-fb
net c01-y1 joint.1.motor-pos-cmd => joint.1.motor-pos-fb sampler.0.pin.0 sampler.0.pin.2
net c01-z2 joint.2.motor-pos-cmd => joint.2.motor-pos-fb
net c01-y3 joint.3.motor-pos-cmd => joint.3.motor-pos-fb sampler.0.pin.1 sampler.0.pin.3

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
printf '%s\n' '-- realtime observation ordering --'
grep '^addf ' c01-023.hal

rm -f /tmp/linuxcnc.lock c01-linuxcnc.stdout c01-linuxcnc.stderr c01-023-status.csv c01-023-realtime.txt
linuxcnc -r c01-023.ini >c01-linuxcnc.stdout 2>c01-linuxcnc.stderr &
LCNC_PID=$!
SAMPLER_PID=""
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
  if [[ -n "${SAMPLER_PID:-}" ]] && kill -0 "$SAMPLER_PID" 2>/dev/null; then
    kill -TERM "$SAMPLER_PID" 2>/dev/null || true
    wait "$SAMPLER_PID" 2>/dev/null || true
  fi
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
  if nc -z localhost 5007 >/dev/null 2>&1 && timeout 3s halcmd getp joint.3.motor-pos-cmd >/dev/null 2>&1 && timeout 3s halcmd getp sampler.0.overruns >/dev/null 2>&1; then
    READY=1
    printf 'runtime-ready-probe=%s\n' "$i"
    break
  fi
  sleep 0.25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: LinuxCNC/NML/HAL fixture did not become ready' >&2; cat c01-linuxcnc.stderr >&2 || true; exit 25; }

printf '%s\n' '-- runtime joint endpoints --'
for p in joint.1.motor-pos-cmd joint.3.motor-pos-cmd joint.1.motor-pos-fb joint.3.motor-pos-fb; do
  v="$(halcmd getp "$p")" || { echo "HARNESS_INVALID: missing runtime pin $p" >&2; exit 26; }
  printf 'runtime-pin=%s value=%s\n' "$p" "$v"
done
printf '%s\n' '-- runtime sampler endpoints --'
for p in sampler.0.pin.0 sampler.0.pin.1 sampler.0.pin.2 sampler.0.pin.3 sampler.0.overruns; do
  v="$(halcmd getp "$p")" || { echo "HARNESS_INVALID: missing sampler endpoint $p" >&2; exit 27; }
  printf 'runtime-pin=%s value=%s\n' "$p" "$v"
done
printf 'gate-C=PASS\n'

# Drain the realtime FIFO continuously. -t prepends sample number; the four
# following values are j1_cmd, j3_cmd, j1_loopback, j3_loopback from one
# sampler.0 invocation in servo-thread.
halsampler -c 0 -t >c01-023-realtime.txt 2>c01-023-halsampler.stderr &
SAMPLER_PID=$!
printf 'halsampler-pid=%s\n' "$SAMPLER_PID"
sleep 0.2
kill -0 "$SAMPLER_PID" 2>/dev/null || { echo 'HARNESS_INVALID: halsampler exited before test motion' >&2; cat c01-023-halsampler.stderr >&2 || true; exit 28; }

TRACE="$FIXTURE/c01-023-status.csv" python3 - <<'PY'
import csv, os, sys, time
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
    sys.exit(29)

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
        sys.exit(30)

def endpoint(name):
    return float(hal.get_value(name))

# Direct userspace reads are retained only to prove separate endpoints exist;
# they are explicitly not used for simultaneous equality Gates E/F.
for p in ['joint.1.motor-pos-cmd','joint.3.motor-pos-cmd','joint.1.motor-pos-fb','joint.3.motor-pos-fb']:
    try:
        print(f'hal-python-endpoint-only={p} value={endpoint(p):.12f}')
    except Exception as exc:
        print(f'HARNESS_INVALID: cannot independently read {p}: {exc}', file=sys.stderr)
        sys.exit(31)

poll()
c.state(linuxcnc.STATE_ESTOP_RESET); cmd_wait('estop-reset')
c.state(linuxcnc.STATE_ON); cmd_wait('machine-on')
c.mode(linuxcnc.MODE_MANUAL); cmd_wait('manual-mode')
poll()
print(f'runtime-joint-count={int(s.joints)}')
if int(s.joints) != 4:
    print('PREDICTION_FALSIFIED: runtime did not report four joints', file=sys.stderr)
    sys.exit(40)

c.home(-1)
if not wait_pred('all-active-joints-homed', lambda st: all(bool(st.homed[j]) for j in range(4)), 12.0):
    print('HARNESS_INVALID: failed to establish four-joint homed state', file=sys.stderr)
    sys.exit(32)
if not wait_pred('pre-move-inpos', lambda st: bool(st.inpos), 5.0):
    sys.exit(33)
poll()
print('homed-vector=' + ','.join(str(int(bool(s.homed[j]))) for j in range(4)))
print(f'pre-move-task-state={int(s.task_state)} task-mode={int(s.task_mode)} motion-mode={int(s.motion_mode)}')
print('gate-B=PASS')

c.mode(linuxcnc.MODE_MDI); cmd_wait('mdi-mode')
poll()
base_y = float(s.position[1])
target = base_y + 5.0
print(f'baseline-world-y={base_y:.12f} target-world-y={target:.12f}')
c.mdi(f'G20 G90 G1 Y{target:.9f} F60')

fields=['t','world_y_cmd','world_y_actual','inpos']
rows=[]; errors=[]; saw_not_inpos=False; finished=False
start=time.monotonic()
with open(trace_path,'w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=fields); w.writeheader()
    deadline=start+12.0
    while time.monotonic() < deadline:
        now=time.monotonic(); poll()
        wyc=float(s.position[1]); wya=float(s.actual_position[1]); inp=bool(s.inpos)
        if not inp: saw_not_inpos=True
        row={'t':f'{now-start:.6f}','world_y_cmd':f'{wyc:.12f}','world_y_actual':f'{wya:.12f}','inpos':int(inp)}
        w.writerow(row); rows.append(row)
        while True:
            err=e.poll()
            if not err: break
            errors.append(err); print(f'error-channel={err}')
        if saw_not_inpos and inp and abs(wyc-target)<1e-6:
            finished=True; break
        time.sleep(0.005)
print(f'status-trace-samples={len(rows)}')
print(f'saw-moving-not-inpos={int(saw_not_inpos)}')
print(f'program-move-finished={int(finished)}')
print(f'error-count={len(errors)}')
if not saw_not_inpos:
    print('HARNESS_INVALID: no meaningful coordinated move was observed in controller status', file=sys.stderr)
    sys.exit(34)
if not finished:
    print('HARNESS_INVALID: coordinated move did not finish at expected world target', file=sys.stderr)
    sys.exit(35)
if errors:
    print('PREDICTION_FALSIFIED: unexpected LinuxCNC error-channel events occurred', file=sys.stderr)
    sys.exit(43)
print('gate-D-status-side=PASS')
PY

# Stop the userspace FIFO drain only after the motion has completed, then
# evaluate simultaneous equality exclusively from the captured realtime rows.
kill -TERM "$SAMPLER_PID" 2>/dev/null || true
wait "$SAMPLER_PID" 2>/dev/null || true
SAMPLER_PID=""
OVERRUNS="$(halcmd getp sampler.0.overruns)"
printf 'sampler-overruns=%s\n' "$OVERRUNS"
[[ "$OVERRUNS" == 0 ]] || { echo 'HARNESS_INVALID: realtime sampler FIFO overran; observation reliability lost' >&2; exit 36; }

set +e
python3 - c01-023-realtime.txt <<'PY'
import math, sys
path=sys.argv[1]
rows=[]
for lineno,line in enumerate(open(path),1):
    parts=line.split()
    if not parts:
        continue
    if len(parts) != 5:
        print(f'HARNESS_INVALID: realtime sample line {lineno} has {len(parts)} columns, expected 5: {line.rstrip()}', file=sys.stderr)
        sys.exit(37)
    try:
        n=int(parts[0]); vals=list(map(float,parts[1:]))
    except Exception as exc:
        print(f'HARNESS_INVALID: cannot parse realtime sample line {lineno}: {exc}', file=sys.stderr)
        sys.exit(38)
    if not all(math.isfinite(v) for v in vals):
        print(f'HARNESS_INVALID: non-finite realtime sample at line {lineno}', file=sys.stderr)
        sys.exit(39)
    rows.append((n,*vals))
if len(rows) < 100:
    print(f'HARNESS_INVALID: only {len(rows)} realtime samples captured', file=sys.stderr)
    sys.exit(44)
nums=[r[0] for r in rows]
if any(b != a+1 for a,b in zip(nums,nums[1:])):
    print('HARNESS_INVALID: realtime sample-number discontinuity detected', file=sys.stderr)
    sys.exit(45)
j1=[r[1] for r in rows]; j3=[r[2] for r in rows]; j1fb=[r[3] for r in rows]; j3fb=[r[4] for r in rows]
span1=max(j1)-min(j1); span3=max(j3)-min(j3)
max_cmd=max(abs(a-b) for a,b in zip(j1,j3))
max_l1=max(abs(a-b) for a,b in zip(j1,j1fb))
max_l3=max(abs(a-b) for a,b in zip(j3,j3fb))
print(f'realtime-samples={len(rows)}')
print(f'realtime-sample-first={nums[0]} last={nums[-1]}')
print(f'realtime-j1-command-span={span1:.12g}')
print(f'realtime-j3-command-span={span3:.12g}')
print(f'max-abs-j1-j3-command-diff={max_cmd:.12g}')
print(f'max-abs-j1-command-feedback-loopback-diff={max_l1:.12g}')
print(f'max-abs-j3-command-feedback-loopback-diff={max_l3:.12g}')
if span1 <= 0.01 or span3 <= 0.01:
    print('HARNESS_INVALID: realtime capture did not contain meaningful motion of both duplicated joints', file=sys.stderr)
    sys.exit(46)
print('gate-D=PASS')
if max_cmd > 1e-9:
    print('PREDICTION_FALSIFIED: duplicated Y joint commands diverged beyond frozen tolerance in same-cycle realtime samples', file=sys.stderr)
    sys.exit(41)
print('gate-E=PASS')
if max_l1 > 1e-9 or max_l3 > 1e-9:
    print('PREDICTION_FALSIFIED: realtime capture did not exhibit declared ideal per-joint command-feedback loopback', file=sys.stderr)
    sys.exit(42)
print('gate-F=PASS')
print('joint3-proof-source=direct realtime sampler capture of joint.3 HAL signal')
print('world-y-alone-used-as-joint3-proof=NO')
print('gate-G=PASS')
print('C01-023 behavioral-gates-A-through-G=PASS')
PY
BEHAVIOR_RC=$?
set -e

printf '\n== Raw realtime same-cycle evidence ==\n'
printf '%s\n' '-- first 10 samples --'
head -n 10 c01-023-realtime.txt || true
printf '%s\n' '-- midpoint samples --'
python3 - c01-023-realtime.txt <<'PY'
import sys
rows=[x.rstrip() for x in open(sys.argv[1]) if x.strip()]
if rows:
    mid=len(rows)//2
    for r in rows[max(0,mid-2):min(len(rows),mid+3)]: print(r)
PY
printf '%s\n' '-- final 10 samples --'
tail -n 10 c01-023-realtime.txt || true
printf '%s\n' '=== BEGIN C01-023 FULL REALTIME TRACE ==='
cat c01-023-realtime.txt
printf '%s\n' '=== END C01-023 FULL REALTIME TRACE ==='

printf '\n== Status-side trace evidence ==\n'
head -n 6 c01-023-status.csv || true
tail -n 6 c01-023-status.csv || true

# Gate H is performed before any behavioral failure is returned so a falsified
# prediction cannot suppress the cleanup evidence needed to interpret the run.
rsh_shutdown
for _ in $(seq 1 80); do
  if ! kill -0 "$LCNC_PID" 2>/dev/null; then break; fi
  sleep 0.1
done
if kill -0 "$LCNC_PID" 2>/dev/null; then
  echo 'HARNESS_INVALID: LinuxCNC launcher remained alive after shutdown request' >&2
  exit 47
fi
wait "$LCNC_PID" 2>/dev/null || true
trap - EXIT
if nc -z localhost 5007 >/dev/null 2>&1; then
  echo 'HARNESS_INVALID: linuxcncrsh TCP endpoint remained after launcher exit' >&2
  exit 48
fi
if halcmd getp joint.3.motor-pos-cmd >/dev/null 2>&1; then
  echo 'HARNESS_INVALID: joint HAL namespace remained after runtime shutdown' >&2
  exit 49
fi
printf 'gate-H=PASS\n'

if (( BEHAVIOR_RC != 0 )); then
  printf 'C01-023 overall=FAIL behavioral-rc=%d after Gate-H cleanup proof\n' "$BEHAVIOR_RC" >&2
  exit "$BEHAVIOR_RC"
fi
printf '%s\n' 'C01-023 overall=PASS'
printf '%s\n' 'Conclusion boundary: TEST evidence, if all gates pass, is limited to duplicated-coordinate command fan-out and separate simulated joint observability. It is not proof of physical actuator synchronization, physical feedback freshness, hydraulic behavior, or functional safety.'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
