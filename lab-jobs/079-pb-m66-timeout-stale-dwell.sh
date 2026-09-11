#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-m66-timeout-001"

printf '== M66-TIMEOUT-001 stale-wait / subsequent-G4 regression ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'FROZEN PREDICTION: M66 P0 L1 Q0.20 times out with input held low. Source inspection shows the timeout branch does not clear emcAuxInputWaitIndex and leaves RISE internally transformed to HIGH. Because G4 shares WAITING_FOR_DELAY and its issue path only replaces taskExecDelayTimeout, raising the old input during the following G4 may terminate that dwell early.'
printf '%s\n' 'PRIMARY DISCRIMINATOR: compare a fresh G4 P0.50 control with M66-timeout -> G4 P0.50. Input 0 starts LOW and is forced HIGH 0.30 s after AUTO_RUN in the experimental program. exp-control <= -0.10 s confirms stale-wait interaction; exp-control >= +0.10 s falsifies it; the middle band is nondiscriminating.'
printf '%s\n' 'CONTRACT: Q=0.20, G4=0.50, input transition=0.30 s, thresholds and ordering are frozen before runtime result inspection.'
printf '%s\n' 'BOUNDARY: this is a stock loopback Task/interpreter regression test, not physical press-brake, field-I/O, realtime synchronization, or functional-safety evidence.'

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
case "$(readlink -f "$LINUXCNC_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: linuxcnc executable not from pinned tree' >&2; exit 21;; esac
case "$(readlink -f "$PYMOD_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: python linuxcnc module not from pinned tree' >&2; exit 22;; esac
printf 'gate-A-provenance=PASS\n'

cd tests/linuxcncrsh
INI=linuxcncrsh-test.ini
CONTROL="$PWD/m66-timeout-control.ngc"
EXPERIMENT="$PWD/m66-timeout-experiment.ngc"
cat > "$CONTROL" <<'EOF'
G21 G90
G4 P0.50
M2
EOF
cat > "$EXPERIMENT" <<'EOF'
G21 G90
M66 P0 L1 Q0.20
O100 if [#5399 NE -1]
  (abort,M66-TIMEOUT-001 expected #5399=-1)
O100 endif
G4 P0.50
M2
EOF
printf 'control-sha256=%s\n' "$(sha256sum "$CONTROL" | awk '{print $1}')"
printf 'experiment-sha256=%s\n' "$(sha256sum "$EXPERIMENT" | awk '{print $1}')"

rm -f /tmp/linuxcnc.lock m66-linuxcnc.stdout m66-linuxcnc.stderr
linuxcnc -r "$INI" >m66-linuxcnc.stdout 2>m66-linuxcnc.stderr &
LCNC_PID=$!
cleanup() {
  if kill -0 "$LCNC_PID" 2>/dev/null; then
    {
      echo 'set timestamp off'; echo 'hello EMC m66shutdown'; echo 'set echo off';
      echo 'set enable EMCTOO'; echo 'shutdown'; sleep 0.2;
    } | timeout 8s nc localhost 5007 >/tmp/m66-shutdown.txt 2>/tmp/m66-shutdown.err || true
    for _ in $(seq 1 50); do kill -0 "$LCNC_PID" 2>/dev/null || break; sleep 0.1; done
    kill -TERM "$LCNC_PID" 2>/dev/null || true
  fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 160); do
  if nc -z localhost 5007 >/dev/null 2>&1 && timeout 3s halcmd getp joint.0.homed >/dev/null 2>&1; then READY=1; echo "runtime-ready-probe=$i"; break; fi
  sleep 0.25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: LinuxCNC/NML fixture not ready' >&2; cat m66-linuxcnc.stderr >&2 || true; exit 23; }

CONTROL="$CONTROL" EXPERIMENT="$EXPERIMENT" python3 - <<'PY'
import os, subprocess, sys, time
import linuxcnc

control = os.environ['CONTROL']
experiment = os.environ['EXPERIMENT']
s = linuxcnc.stat(); c = linuxcnc.command(); e = linuxcnc.error_channel()

def poll(): s.poll(); return s

def complete(label, timeout=6.0):
    rc = c.wait_complete(timeout)
    print(f'{label}-wait_complete={rc}')
    if rc not in (0,1):
        print(f'HARNESS_INVALID: {label} wait_complete={rc}', file=sys.stderr); sys.exit(24)

def wait_pred(label, pred, timeout=15.0):
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        poll()
        if pred(): print(f'{label}=PASS'); return
        time.sleep(0.01)
    print(f'HARNESS_INVALID: timeout {label}', file=sys.stderr); sys.exit(25)

def set_din(value):
    subprocess.run(['halcmd','setp','motion.digital-in-00','1' if value else '0'], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    got=subprocess.check_output(['halcmd','getp','motion.digital-in-00'], text=True).strip()
    print(f'digital-in-commanded={int(value)} readback={got}')

def drain_errors(tag):
    out=[]
    while True:
        x=e.poll()
        if not x: break
        out.append(x); print(f'{tag}-error={x}')
    return out

# Healthy startup / homing.
poll(); c.state(linuxcnc.STATE_ESTOP_RESET); complete('estop-reset')
c.state(linuxcnc.STATE_ON); complete('machine-on')
c.mode(linuxcnc.MODE_MANUAL); complete('manual')
poll()
for j in range(int(s.joints)):
    c.home(j); wait_pred(f'joint-{j}-homed', lambda j=j: bool((poll().homed[j])))
wait_pred('inpos', lambda: bool(poll().inpos))
c.mode(linuxcnc.MODE_AUTO); complete('auto')

# Confirm target pin is writable/unlinked in this fixture.
try:
    set_din(False)
except Exception as ex:
    print(f'HARNESS_INVALID: cannot control motion.digital-in-00: {ex}', file=sys.stderr); sys.exit(26)
print('gate-B-fixture-input=PASS')

def run(path, transition_at=None, hard_timeout=4.0):
    c.program_open(path); complete('program-open')
    poll(); drain_errors('pre-run')
    t0=time.monotonic(); transitioned=False; saw_nonidle=False
    c.auto(linuxcnc.AUTO_RUN,0)
    deadline=t0+hard_timeout
    while time.monotonic()<deadline:
        now=time.monotonic(); poll()
        if transition_at is not None and not transitioned and now-t0 >= transition_at:
            set_din(True); transitioned=True; print(f'input-transition-elapsed={now-t0:.6f}')
        if s.interp_state != linuxcnc.INTERP_IDLE: saw_nonidle=True
        errs=drain_errors('run')
        if errs:
            print('HARNESS_INVALID: LinuxCNC error channel reported an error', file=sys.stderr); sys.exit(27)
        if saw_nonidle and s.interp_state == linuxcnc.INTERP_IDLE and s.exec_state == linuxcnc.EXEC_DONE and bool(s.inpos):
            return time.monotonic()-t0, transitioned
        time.sleep(0.001)
    print('HARNESS_INVALID: program did not finish', file=sys.stderr); sys.exit(28)

# Control first, before any M66 state exists.
set_din(False)
control_s,_=run(control)
print(f'control-duration-s={control_s:.6f}')
if not (0.35 <= control_s <= 1.20):
    print('HARNESS_INVALID: control G4 duration outside broad plausibility band', file=sys.stderr); sys.exit(29)
print('gate-C-control=PASS')

# Experimental contract: low through M66 Q0.20; high at t=0.30 during following G4.
set_din(False)
exp_s,transitioned=run(experiment, transition_at=0.30)
print(f'experiment-duration-s={exp_s:.6f}')
print(f'exp-minus-control-s={exp_s-control_s:.6f}')
if not transitioned:
    print('HARNESS_INVALID: frozen input transition was not executed', file=sys.stderr); sys.exit(30)
print('gate-D-experiment-completed=PASS')

delta=exp_s-control_s
if delta <= -0.10:
    verdict='STALE-WAIT INTERACTION CONFIRMED'
elif delta >= 0.10:
    verdict='HYPOTHESIS FALSIFIED'
else:
    verdict='NONDISCRIMINATING / HARNESS INVALID'
print(f'VERDICT={verdict}')
if verdict.startswith('NONDISCRIMINATING'):
    sys.exit(31)
print('gate-E-discriminator=PASS')
PY

printf '%s\n' 'M66-TIMEOUT-001 completed with frozen discriminator.'
