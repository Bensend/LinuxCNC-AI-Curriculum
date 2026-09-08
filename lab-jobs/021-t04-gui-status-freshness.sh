#!/usr/bin/env bash
set -euo pipefail
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-t04-gui"

printf '== T04-021 GUI status freshness versus retained presentation ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen prediction: after a deliberate GUI-adapter poll failure, independent controller state can advance while GStat cached/presented state remains at its prior value; the next successful poll catches up.'
printf '%s\n' 'Boundary: this is GUI/status-adapter freshness evidence, not remote packet-loss, physical E-stop, or safety validation.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps python3 python3-gi python3-zmq
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
./configure --with-realtime=uspace --disable-manpages --disable-build-documentation
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
GSTAT_PATH="$(python3 - <<'PY'
import common.hal_glib
print(common.hal_glib.__file__)
PY
)"
printf 'linuxcnc-bin=%s\nlinuxcnc-python-module=%s\ngstat-module=%s\n' "$LINUXCNC_BIN" "$PYMOD_PATH" "$GSTAT_PATH"
case "$(readlink -f "$LINUXCNC_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: linuxcnc executable not from pinned tree' >&2; exit 21;; esac
case "$(readlink -f "$PYMOD_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: python module not from pinned tree' >&2; exit 22;; esac
case "$(readlink -f "$GSTAT_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: GStat module not from pinned tree' >&2; exit 23;; esac
printf 'gate-A=PASS\n'

cd tests/linuxcncrsh
INI=linuxcncrsh-test.ini
TRACE="$PWD/t04-021-trace.csv"
rm -f /tmp/linuxcnc.lock t04-linuxcnc.stdout t04-linuxcnc.stderr "$TRACE"
linuxcnc -r "$INI" >t04-linuxcnc.stdout 2>t04-linuxcnc.stderr &
LCNC_PID=$!
rsh_shutdown() {
  { printf '%s\n' 'set timestamp off' 'hello EMC t04shutdown' 'set echo off' 'set enable EMCTOO' 'shutdown'; sleep 0.2; } | timeout 8s nc localhost 5007 >/tmp/t04-shutdown.txt 2>/tmp/t04-shutdown.err || true
}
cleanup() {
  if kill -0 "$LCNC_PID" 2>/dev/null; then rsh_shutdown; sleep 0.5; kill -TERM "$LCNC_PID" 2>/dev/null || true; fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT
READY=0
for i in $(seq 1 160); do
  if nc -z localhost 5007 >/dev/null 2>&1 && timeout 3s halcmd getp joint.0.homed >/dev/null 2>&1; then READY=1; printf 'runtime-ready-probe=%s\n' "$i"; break; fi
  sleep 0.25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: LinuxCNC fixture did not become ready' >&2; cat t04-linuxcnc.stderr >&2 || true; exit 24; }

TRACE="$TRACE" GSTAT_PATH="$GSTAT_PATH" python3 - <<'PY'
import csv, os, sys, time
import linuxcnc
from common.hal_glib import GStat

trace_path=os.environ['TRACE']
for n in ['STATE_ESTOP','STATE_ESTOP_RESET','RCS_DONE','RCS_ERROR']:
    if not hasattr(linuxcnc,n):
        print('HARNESS_INVALID: missing constant '+n, file=sys.stderr); sys.exit(25)
    print(f'constant-{n}={getattr(linuxcnc,n)}')

class PollProxy:
    def __init__(self, real):
        object.__setattr__(self, 'real', real)
        object.__setattr__(self, 'blocked', False)
        object.__setattr__(self, 'attempts', 0)
        object.__setattr__(self, 'failures', 0)
    def poll(self):
        object.__setattr__(self, 'attempts', self.attempts + 1)
        if self.blocked:
            object.__setattr__(self, 'failures', self.failures + 1)
            raise RuntimeError('T04-021 deliberate GUI observation failure')
        return self.real.poll()
    def __getattr__(self, name):
        return getattr(self.real, name)
    def __setattr__(self, name, value):
        if name in ('real','blocked','attempts','failures'):
            object.__setattr__(self, name, value)
        else:
            setattr(self.real, name, value)

observer=linuxcnc.stat()
producer=linuxcnc.command()
gui_real=linuxcnc.stat()
proxy=PollProxy(gui_real)
g=GStat(stat=proxy)
rows=[]; events=[]; presentation={'state':None}; t0=time.monotonic()
fields=['t','phase','producer_serial','semantic_result','observer_state','proxy_blocked','proxy_attempts','proxy_failures','gstat_active','gstat_cached_state','presentation_state','event']

def on_state(name):
    def cb(*args):
        if name == 'state-estop': presentation['state']=linuxcnc.STATE_ESTOP
        elif name == 'state-estop-reset': presentation['state']=linuxcnc.STATE_ESTOP_RESET
        elif name == 'state-on': presentation['state']=linuxcnc.STATE_ON
        elif name == 'state-off': presentation['state']=linuxcnc.STATE_OFF
        events.append((time.monotonic()-t0,name,presentation['state']))
    return cb
for name in ('state-estop','state-estop-reset','state-on','state-off','periodic'):
    g.connect(name,on_state(name))

def obs(): observer.poll(); return int(observer.task_state)

def cached(): return int(g.old.get('state',-999))

def snap(phase,semantic=''):
    state=obs()
    ev=events[-1][1] if events else ''
    row={'t':f'{time.monotonic()-t0:.6f}','phase':phase,'producer_serial':int(producer.serial),'semantic_result':semantic,'observer_state':state,'proxy_blocked':int(proxy.blocked),'proxy_attempts':proxy.attempts,'proxy_failures':proxy.failures,'gstat_active':int(bool(g._status_active)),'gstat_cached_state':cached(),'presentation_state':presentation['state'] if presentation['state'] is not None else '', 'event':ev}
    rows.append(row); print('TRACE',row); return row

def write_trace():
    with open(trace_path,'w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=fields); w.writeheader(); w.writerows(rows)
    with open(trace_path+'.events','w') as f:
        for t,n,s in events: f.write(f'{t:.6f},{n},{s}\n')

def fail(msg,code): write_trace(); print(msg,file=sys.stderr); sys.exit(code)

def set_state(target,label):
    producer.state(target)
    rc=producer.wait_complete(5.0)
    deadline=time.monotonic()+3.0
    seen=None
    while time.monotonic()<deadline:
        seen=obs()
        if seen==target: break
        time.sleep(0.01)
    print(f'{label}-serial={producer.serial} wait-complete={rc} observer={seen}')
    if int(rc)!=int(linuxcnc.RCS_DONE) or seen!=target:
        fail('HARNESS_INVALID: could not establish requested controller state '+label,26)
    return int(rc)

# Phase A: establish ESTOP, then one successful GUI refresh and a presentation baseline.
set_state(linuxcnc.STATE_ESTOP,'baseline-estop')
proxy.blocked=False
g.update()
presentation['state']=cached()
r=snap('baseline-after-successful-gui-update',linuxcnc.RCS_DONE)
if r['observer_state']!=linuxcnc.STATE_ESTOP or r['gstat_cached_state']!=linuxcnc.STATE_ESTOP or int(r['presentation_state'])!=linuxcnc.STATE_ESTOP:
    fail('PREDICTION_FALSIFIED: baseline observer/GStat/presentation disagreement',40)
if not g._status_active:
    fail('HARNESS_INVALID: baseline GStat update was not active',27)
print('gate-B=PASS')

# Phase B: block ONLY the GUI adapter's stat.poll, then transition controller independently.
proxy.blocked=True
rc=set_state(linuxcnc.STATE_ESTOP_RESET,'controller-reset-while-gui-blocked')
snap('controller-reset-proven-before-failed-gui-update',rc)
print('gate-C=PASS')
pre_attempts=proxy.attempts; pre_failures=proxy.failures; pre_events=len(events)
g.update()
r=snap('decisive-failed-gui-update',rc)
if proxy.attempts!=pre_attempts+1 or proxy.failures!=pre_failures+1:
    fail('HARNESS_INVALID: deliberate GUI proxy failure did not occur exactly on decisive update',28)
if r['observer_state']!=linuxcnc.STATE_ESTOP_RESET:
    fail('HARNESS_INVALID: independent observer failed during decisive GUI failure',29)
print('gate-D=PASS')
if r['gstat_active']!=0 or r['gstat_cached_state']!=linuxcnc.STATE_ESTOP or int(r['presentation_state'])!=linuxcnc.STATE_ESTOP:
    fail('PREDICTION_FALSIFIED: GUI cache/presentation did not remain stale at ESTOP during failed poll',41)
print('gate-E=PASS')
new_events=events[pre_events:]
state_transition_names={'state-estop-reset','state-estop','state-on','state-off'}
if any(name in state_transition_names for _,name,_ in new_events):
    fail('PREDICTION_FALSIFIED: failed GUI poll emitted a controller-state transition signal',42)
if not any(name=='periodic' for _,name,_ in new_events):
    fail('HARNESS_INVALID: expected generic periodic activity from failed GStat update not observed',30)
print('gate-F=PASS')

# Phase C: remove only observation failure and refresh same controller state.
proxy.blocked=False
pre_recovery_events=len(events)
g.update()
r=snap('recovered-gui-update',rc)
if r['observer_state']!=linuxcnc.STATE_ESTOP_RESET or r['gstat_active']!=1 or r['gstat_cached_state']!=linuxcnc.STATE_ESTOP_RESET:
    fail('PREDICTION_FALSIFIED: GStat did not catch up after poll recovery',43)
recovery_events=events[pre_recovery_events:]
if not any(name=='state-estop-reset' for _,name,_ in recovery_events):
    fail('PREDICTION_FALSIFIED: recovery did not emit state-estop-reset',44)
# listener callback should have updated presentation as part of emitted signal
if int(presentation['state'])!=linuxcnc.STATE_ESTOP_RESET:
    fail('PREDICTION_FALSIFIED: presentation did not catch up on recovery event',45)
snap('recovery-presentation-confirmed',rc)
print('gate-G=PASS')
print('gate-H=PASS')
write_trace()
print(f'poll-attempts={proxy.attempts} deliberate-poll-failures={proxy.failures} events={len(events)} rows={len(rows)}')
print('T04-021 overall=PASS')
PY

printf '%s\n' '=== BEGIN T04-021 FULL RAW TRACE CSV ==='
cat "$TRACE"
printf '%s\n' '=== END T04-021 FULL RAW TRACE CSV ==='
printf '%s\n' '=== BEGIN T04-021 EVENT TRACE ==='
cat "$TRACE.events"
printf '%s\n' '=== END T04-021 EVENT TRACE ==='
printf '\nT04-021 shell-harness=PASS\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'