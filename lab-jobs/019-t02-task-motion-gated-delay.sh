#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-t02-task"

printf '== T02-019 Task motion-gated dwell experiment ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen prediction: a queued G4 dwell remains behind WAITING_FOR_MOTION_AND_IO until prior motion/I/O are complete, then Task enters WAITING_FOR_DELAY for the dwell interval.'
printf '%s\n' 'Anti-circular boundary: program/read-line progress is logged but is never accepted as the motion-completion oracle.'
printf '%s\n' 'Simulation boundary: this verifies Task/motion state-machine behavior in the stock loopback simulator; it does not prove physical actuator, transport, feedback-device, or safety behavior.'

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
printf 'linuxcnc-bin=%s\nlinuxcnc-python-module=%s\n' "$LINUXCNC_BIN" "$PYMOD_PATH"
case "$(readlink -f "$LINUXCNC_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: linuxcnc executable is not from pinned work tree' >&2; exit 21;; esac
case "$(readlink -f "$PYMOD_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: python linuxcnc module is not from pinned work tree' >&2; exit 22;; esac
printf 'gate-A=PASS\n'

cd tests/linuxcncrsh
INI=linuxcncrsh-test.ini
PROGRAM="$PWD/t02-019.ngc"
TRACE="$PWD/t02-019-trace.csv"
cat > "$PROGRAM" <<'EOF'
G21 G90
G0 X0
G1 X20 F120
G4 P0.75
M2
EOF
printf 'program-sha256=%s\n' "$(sha256sum "$PROGRAM" | awk '{print $1}')"
printf '%s\n' 'Program: metric absolute; 20 mm feed move at 120 mm/min (~10 s nominal) followed by G4 P0.75.'

rm -f /tmp/linuxcnc.lock t02-linuxcnc.stdout t02-linuxcnc.stderr "$TRACE"
linuxcnc -r "$INI" >t02-linuxcnc.stdout 2>t02-linuxcnc.stderr &
LCNC_PID=$!

rsh_shutdown() {
  {
    printf '%s\n' 'set timestamp off'
    printf '%s\n' 'hello EMC t02shutdown'
    printf '%s\n' 'set echo off'
    printf '%s\n' 'set enable EMCTOO'
    printf '%s\n' 'shutdown'
    sleep 0.2
  } | timeout 8s nc localhost 5007 >/tmp/t02-shutdown.txt 2>/tmp/t02-shutdown.err || true
}
cleanup() {
  if kill -0 "$LCNC_PID" 2>/dev/null; then
    rsh_shutdown
    for _ in $(seq 1 50); do
      kill -0 "$LCNC_PID" 2>/dev/null || break
      sleep 0.1
    done
    kill -TERM "$LCNC_PID" 2>/dev/null || true
  fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 160); do
  if nc -z localhost 5007 >/dev/null 2>&1 && timeout 3s halcmd getp joint.0.homed >/dev/null 2>&1; then
    READY=1
    printf 'runtime-ready-probe=%s\n' "$i"
    break
  fi
  sleep 0.25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: LinuxCNC/NML fixture did not become ready' >&2; cat t02-linuxcnc.stderr >&2 || true; exit 23; }

PROGRAM="$PROGRAM" TRACE="$TRACE" python3 - <<'PY'
import csv, os, sys, time
import linuxcnc

program = os.environ['PROGRAM']
trace_path = os.environ['TRACE']

required_constants = [
    'EXEC_DONE', 'EXEC_WAITING_FOR_MOTION_AND_IO', 'EXEC_WAITING_FOR_DELAY',
    'INTERP_IDLE', 'MODE_MANUAL', 'MODE_AUTO', 'STATE_ESTOP_RESET', 'STATE_ON', 'AUTO_RUN'
]
missing = [n for n in required_constants if not hasattr(linuxcnc, n)]
if missing:
    print('HARNESS_INVALID: missing python constants: ' + ','.join(missing), file=sys.stderr)
    sys.exit(24)
for n in required_constants:
    print(f'constant-{n}={getattr(linuxcnc,n)}')

s = linuxcnc.stat()
c = linuxcnc.command()
e = linuxcnc.error_channel()

def poll():
    s.poll()
    return s

def wait_pred(label, predicate, timeout=15.0):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        poll()
        if predicate(s):
            print(f'{label}=PASS')
            return True
        err = e.poll()
        if err:
            print(f'error-during-{label}={err}')
        time.sleep(0.01)
    print(f'HARNESS_INVALID: timeout waiting for {label}', file=sys.stderr)
    return False

def cmd_wait(label, timeout=5.0):
    rc = c.wait_complete(timeout)
    print(f'{label}-wait-complete={rc}')
    if rc not in (0, 1):
        print(f'HARNESS_INVALID: {label} wait_complete returned {rc}', file=sys.stderr)
        sys.exit(26)

# Healthy startup and ordinary homing before AUTO. Home active joints explicitly
# in configured sequence order; attempt 1 showed home(-1) was not a valid
# orchestration oracle for this stock headless fixture.
poll()
c.state(linuxcnc.STATE_ESTOP_RESET); cmd_wait('estop-reset')
c.state(linuxcnc.STATE_ON); cmd_wait('machine-on')
c.mode(linuxcnc.MODE_MANUAL); cmd_wait('manual-mode')
poll()
joint_count = int(s.joints)
print(f'active-joint-count={joint_count}')
if joint_count <= 0:
    print('HARNESS_INVALID: no active joints reported', file=sys.stderr)
    sys.exit(27)
for j in range(joint_count):
    c.home(j)
    if not wait_pred(f'joint-{j}-homed', lambda st, j=j: bool(st.homed[j]), 12.0):
        sys.exit(28)
if not wait_pred('all-active-joints-homed', lambda st: all(bool(st.homed[j]) for j in range(joint_count)), 5.0):
    sys.exit(28)
if not wait_pred('pre-run-inpos', lambda st: bool(st.inpos), 5.0):
    sys.exit(29)

c.mode(linuxcnc.MODE_AUTO); cmd_wait('auto-mode')
c.program_open(program); cmd_wait('program-open')
poll()
print(f'loaded-file={s.file}')
if os.path.realpath(s.file) != os.path.realpath(program):
    print('HARNESS_INVALID: status did not report requested program file', file=sys.stderr)
    sys.exit(25)
print('gate-B=PASS')

start_actual = float(s.actual_position[0])
start_cmd = float(s.position[0])
print(f'start-x-actual={start_actual:.9f} start-x-commanded={start_cmd:.9f}')

fields = ['t','exec_state','interp_state','state','current_line','read_line','motion_line','inpos','actual_x','commanded_x','dtg','queue','active_queue']
rows = []
errors = []
run_start = time.monotonic()
c.auto(linuxcnc.AUTO_RUN, 0)

saw_motion = False
saw_barrier_while_incomplete = False
wait_delay_while_incomplete = False
delay_times = []
line4_while_incomplete = False
saw_program_nonidle = False
finished = False

with open(trace_path, 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=fields)
    w.writeheader()
    deadline = run_start + 25.0
    while time.monotonic() < deadline:
        now = time.monotonic()
        poll()
        actual_x = float(s.actual_position[0])
        cmd_x = float(s.position[0])
        inpos = bool(s.inpos)
        exec_state = int(s.exec_state)
        interp_state = int(s.interp_state)
        current_line = int(s.current_line)
        read_line = int(s.read_line)
        motion_line = int(s.motion_line)
        row = {
            't': f'{now-run_start:.6f}', 'exec_state': exec_state, 'interp_state': interp_state,
            'state': int(s.state), 'current_line': current_line, 'read_line': read_line,
            'motion_line': motion_line, 'inpos': int(inpos), 'actual_x': f'{actual_x:.9f}',
            'commanded_x': f'{cmd_x:.9f}', 'dtg': f'{float(s.distance_to_go):.9f}',
            'queue': int(s.queue), 'active_queue': int(s.active_queue)
        }
        w.writerow(row); rows.append(row)

        moved = abs(actual_x-start_actual) > 1e-4 or abs(cmd_x-start_cmd) > 1e-4
        incomplete = not inpos
        if moved and incomplete:
            saw_motion = True
        if exec_state == linuxcnc.EXEC_WAITING_FOR_MOTION_AND_IO and incomplete:
            saw_barrier_while_incomplete = True
        if exec_state == linuxcnc.EXEC_WAITING_FOR_DELAY:
            delay_times.append(now-run_start)
            if incomplete:
                wait_delay_while_incomplete = True
        if (current_line >= 4 or read_line >= 4) and incomplete:
            line4_while_incomplete = True
        if interp_state != linuxcnc.INTERP_IDLE:
            saw_program_nonidle = True

        while True:
            err = e.poll()
            if not err: break
            errors.append(err)
            print(f'error-channel={err}')

        if saw_program_nonidle and interp_state == linuxcnc.INTERP_IDLE and exec_state == linuxcnc.EXEC_DONE and inpos and (now-run_start) > 0.5:
            finished = True
            break
        time.sleep(0.005)

print(f'trace-samples={len(rows)}')
print(f'saw-independent-motion={int(saw_motion)}')
print(f'saw-WAITING_FOR_MOTION_AND_IO-while-incomplete={int(saw_barrier_while_incomplete)}')
print(f'WAITING_FOR_DELAY-while-incomplete={int(wait_delay_while_incomplete)}')
print(f'line-at-or-past-dwell-while-motion-incomplete={int(line4_while_incomplete)}')
print(f'error-count={len(errors)}')
print(f'program-finished={int(finished)}')

if not saw_motion:
    print('HARNESS_INVALID: no independently observed moving/not-in-position state', file=sys.stderr)
    sys.exit(30)
print('gate-C=PASS')
if not saw_barrier_while_incomplete:
    print('HARNESS_INVALID: sampling did not capture WAITING_FOR_MOTION_AND_IO while motion incomplete', file=sys.stderr)
    sys.exit(31)
print('gate-D=PASS')
if wait_delay_while_incomplete:
    print('PREDICTION_FALSIFIED: WAITING_FOR_DELAY observed while independent inpos oracle was false', file=sys.stderr)
    sys.exit(40)
print('gate-E=PASS')
if not delay_times:
    print('HARNESS_INVALID: WAITING_FOR_DELAY not observed', file=sys.stderr)
    sys.exit(32)
delay_span = max(delay_times)-min(delay_times)
print(f'waiting-for-delay-observed-span={delay_span:.6f}')
if not (0.60 <= delay_span <= 1.10):
    print('PREDICTION_FALSIFIED: observed WAITING_FOR_DELAY span outside frozen 0.60..1.10 s window', file=sys.stderr)
    sys.exit(41)
print('gate-F=PASS')
if not finished or errors:
    print('PREDICTION_FALSIFIED: program did not finish cleanly', file=sys.stderr)
    sys.exit(42)
poll()
if int(s.exec_state) != linuxcnc.EXEC_DONE or int(s.interp_state) != linuxcnc.INTERP_IDLE or not bool(s.inpos):
    print('PREDICTION_FALSIFIED: final Task/interpreter/motion state not clean', file=sys.stderr)
    sys.exit(43)
print(f'final-x-actual={float(s.actual_position[0]):.9f} final-x-commanded={float(s.position[0]):.9f}')
print('gate-G=PASS')
print('anti-circular-line-ahead-observed=' + ('YES' if line4_while_incomplete else 'NO'))
print('T02-019 overall=PASS')
PY

printf '\n== Trace evidence slices ==\n'
printf '%s\n' '-- first 12 samples --'
head -n 13 "$TRACE"
printf '%s\n' '-- samples containing exec_state transitions --'
python3 - "$TRACE" <<'PY'
import csv, sys
p=sys.argv[1]
rows=list(csv.DictReader(open(p)))
last=None
for i,r in enumerate(rows):
    cur=r['exec_state']
    if cur != last:
        lo=max(0,i-1); hi=min(len(rows),i+2)
        print(f'transition-index={i} exec_state={cur}')
        for x in rows[lo:hi]: print(','.join(x[k] for k in x.keys()))
        last=cur
PY
printf '%s\n' '-- final 12 samples --'
tail -n 12 "$TRACE"
printf '%s\n' '=== BEGIN T02-019 FULL RAW TRACE CSV ==='
cat "$TRACE"
printf '%s\n' '=== END T02-019 FULL RAW TRACE CSV ==='

printf '\nT02-019 shell-harness=PASS\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
