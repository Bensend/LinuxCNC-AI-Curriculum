#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c07-full-preflight"

printf '== C07-047 full sequencer / ordering preflight (NON-AUTHORITATIVE) ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Predeclared preflight prediction: one fresh authorization causes exactly one machine-ON request; blocked request does not advance on request history; prerequisite restoration alone does not retry; successful ON is entered only after observed halui.machine.is-on; active status loss revokes cycle permission; post-fault recovery requires fresh authorization.'
printf '%s\n' 'Evidence boundary: this job validates the full P0-P8 sequencer topology and ordering only. Frozen C07-047 Gates A-J are NOT scored here.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
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

sha256sum src/emc/usr_intf/halui.cc src/emc/task/emctask.cc src/emc/task/emctaskmain.cc \
  src/emc/task/taskintf.cc src/emc/motion/command.c src/emc/motion/control.c src/emc/motion/motion.c \
  | tee /tmp/c07-production-source-sha256.txt

cd tests/linuxcncrsh
cp linuxcncrsh-test.ini c07-full-preflight.ini
python3 - <<'PY'
p='c07-full-preflight.ini'
s=open(p).read()
needle='[HAL]\nHALFILE = lcncrsh_sim.hal\n'
assert needle in s
s=s.replace(needle, needle+'HALUI = halui\n', 1)
open(p,'w').write(s)
PY
sha256sum c07-full-preflight.ini lcncrsh_sim.hal | tee /tmp/c07-test-config-sha256.txt

rm -f /tmp/linuxcnc.lock c07-linuxcnc.stdout c07-linuxcnc.stderr c07-trace.csv c07-preflight-analysis.txt
linuxcnc -r c07-full-preflight.ini >c07-linuxcnc.stdout 2>c07-linuxcnc.stderr &
LAUNCHER_PID=$!
cleanup() {
  trap - EXIT
  kill -TERM "$LAUNCHER_PID" 2>/dev/null || true
  for _ in $(seq 1 50); do
    if ! kill -0 "$LAUNCHER_PID" 2>/dev/null; then break; fi
    sleep 0.1
  done
  kill -KILL "$LAUNCHER_PID" 2>/dev/null || true
  wait "$LAUNCHER_PID" 2>/dev/null || true
}
trap cleanup EXIT

printf '\n== Wait for actual HAL objects ==\n'
READY=0
for i in $(seq 1 160); do
  if nc -z localhost 5007 >/dev/null 2>&1 \
     && timeout 3s halcmd show pin halui.machine.on >/tmp/c07-halui-on.txt 2>/tmp/c07-hal.err \
     && timeout 3s halcmd show pin halui.machine.is-on >/tmp/c07-halui-is-on.txt 2>>/tmp/c07-hal.err \
     && timeout 3s halcmd show pin halui.estop.reset >/tmp/c07-estop-reset.txt 2>>/tmp/c07-hal.err \
     && timeout 3s halcmd show pin halui.estop.is-activated >/tmp/c07-estop-state.txt 2>>/tmp/c07-hal.err \
     && timeout 3s halcmd show pin motion.enable >/tmp/c07-motion-enable.txt 2>>/tmp/c07-hal.err \
     && timeout 3s halcmd show pin motion.motion-enabled >/tmp/c07-motion-enabled.txt 2>>/tmp/c07-hal.err \
     && grep -q 'halui.machine.on' /tmp/c07-halui-on.txt \
     && grep -q 'halui.machine.is-on' /tmp/c07-halui-is-on.txt \
     && grep -q 'halui.estop.reset' /tmp/c07-estop-reset.txt \
     && grep -q 'halui.estop.is-activated' /tmp/c07-estop-state.txt \
     && grep -q 'motion.enable' /tmp/c07-motion-enable.txt \
     && grep -q 'motion.motion-enabled' /tmp/c07-motion-enabled.txt; then
    READY=1
    printf 'readiness=PASS probe=%s\n' "$i"
    break
  fi
  sleep 0.25
done
if [[ "$READY" != 1 ]]; then
  echo 'C07 full preflight runtime did not become ready.' >&2
  cat c07-linuxcnc.stdout >&2 || true
  cat c07-linuxcnc.stderr >&2 || true
  cat /tmp/c07-hal.err >&2 || true
  exit 2
fi
cat /tmp/c07-halui-on.txt /tmp/c07-halui-is-on.txt /tmp/c07-motion-enable.txt /tmp/c07-motion-enabled.txt | tee /tmp/c07-required-hal-objects.txt
(timeout 3s halcmd show sig || true) > /tmp/c07-signals.txt
printf '\n== motion.enable topology ==\n'
cat /tmp/c07-motion-enable.txt
printf '%s\n' 'Harness uses direct setp on the unlinked HAL_IN motion.enable; successful setp/readback below is the single controllable injection path for this preflight.'

cat > /tmp/c07_sequencer_preflight.py <<'PY'
#!/usr/bin/env python3
import csv, subprocess, time, sys

TRACE='c07-trace.csv'
STATE={
    'INIT':0,
    'WAIT_START':1,
    'ON_REQUEST_PULSE':2,
    'WAIT_ON_CONFIRM':3,
    'ON_CONFIRMED':4,
    'RECOVERY_REQUIRED':5,
    'RECOVERY_WAIT_START':6,
}

def cmd(*args):
    p=subprocess.run(['halcmd',*args],text=True,capture_output=True,timeout=3)
    if p.returncode:
        raise RuntimeError(f"halcmd {' '.join(args)} failed rc={p.returncode}: {p.stderr.strip()}")
    return p.stdout.strip()

def getb(pin):
    v=cmd('getp',pin).strip().upper()
    if v in ('TRUE','1'): return 1
    if v in ('FALSE','0'): return 0
    raise RuntimeError(f'unexpected boolean {pin}={v!r}')

def setb(pin,v): cmd('setp',pin,str(int(bool(v))))

def pulse_pin(pin, hi=0.10):
    setb(pin,0); time.sleep(0.04); setb(pin,1); time.sleep(hi); setb(pin,0)

class Harness:
    def __init__(self):
        self.phase=0; self.state=STATE['INIT']; self.auth=0; self.prev_auth=0
        self.request=0; self.cycle=0; self.seq=0; self.tick=0
        self.rows=[]

    def sample(self,event):
        t0=time.monotonic_ns()
        me=getb('motion.enable')
        mme=getb('motion.motion-enabled')
        mon=getb('halui.machine.is-on')
        estop=getb('halui.estop.is-activated')
        req=getb('halui.machine.on')
        t1=time.monotonic_ns()
        self.seq += 1
        self.rows.append({
            'seq':self.seq,'t0_ns':t0,'t1_ns':t1,'span_ns':t1-t0,'tick':self.tick,
            'phase':self.phase,'state':self.state,'start_authorize':self.auth,
            'request_internal':self.request,'request_actual':req,'motion_enable':me,
            'motion_motion_enabled':mme,'machine_is_on':mon,'estop_activated':estop,
            'cycle_permission':self.cycle,'event':event,
        })
        return me,mme,mon,estop,req

    def emit_request(self):
        self.state=STATE['ON_REQUEST_PULSE']; self.sample('request-state-before-high')
        self.request=1; setb('halui.machine.on',1); self.sample('request-high')
        time.sleep(0.12); self.sample('request-high-hold')
        self.request=0; setb('halui.machine.on',0); self.sample('request-low')
        self.state=STATE['WAIT_ON_CONFIRM']; self.sample('wait-on-after-request')

    def tick_once(self,event='tick'):
        self.tick += 1
        me,mme,mon,estop,req=self.sample(event+'-pre-eval')
        rising=(self.auth and not self.prev_auth)
        self.prev_auth=self.auth
        if self.state in (STATE['WAIT_START'],STATE['WAIT_ON_CONFIRM'],STATE['RECOVERY_WAIT_START']) and rising:
            self.emit_request()
            return
        if self.state==STATE['WAIT_ON_CONFIRM'] and mon:
            self.state=STATE['ON_CONFIRMED']; self.cycle=1
            self.sample(event+'-entered-on-confirmed')
            return
        if self.state==STATE['ON_CONFIRMED'] and not mon:
            self.cycle=0; self.state=STATE['RECOVERY_REQUIRED']
            self.sample(event+'-revoked-on-status-loss')
            return
        if self.state==STATE['RECOVERY_REQUIRED'] and me:
            self.state=STATE['RECOVERY_WAIT_START']
            self.sample(event+'-recovery-wait-start')

    def phase_before(self,p,label):
        self.phase=p
        self.sample('PHASE_P%d_%s_BEFORE_MUTATION'%(p,label))

    def set_motion_enable(self,v,label):
        setb('motion.enable',v)
        self.sample(label)

    def authorize_once(self,label):
        self.auth=1
        self.sample(label+'-auth-high-before-eval')
        self.tick_once(label)
        self.auth=0
        self.sample(label+'-auth-low')
        self.tick_once(label+'-after-auth-low')

    def monitor(self,seconds,label,interval=0.04):
        deadline=time.monotonic()+seconds
        while time.monotonic()<deadline:
            self.tick_once(label)
            time.sleep(interval)

    def wait_until(self,pred,seconds,label):
        deadline=time.monotonic()+seconds
        while time.monotonic()<deadline:
            self.tick_once(label)
            if pred(): return
            time.sleep(0.04)
        raise RuntimeError('timeout: '+label)

    def write(self):
        with open(TRACE,'w',newline='') as f:
            w=csv.DictWriter(f,fieldnames=list(self.rows[0].keys()))
            w.writeheader(); w.writerows(self.rows)

h=Harness()
# Deterministic out-of-estop / machine-off baseline.
pulse_pin('halui.estop.reset')
for _ in range(100):
    if not getb('halui.estop.is-activated'): break
    time.sleep(0.03)
else: raise RuntimeError('estop did not reset')
pulse_pin('halui.machine.off')
for _ in range(100):
    if not getb('halui.machine.is-on'): break
    time.sleep(0.03)
else: raise RuntimeError('machine did not reach OFF')
setb('motion.enable',1)
setb('halui.machine.on',0)
h.state=STATE['WAIT_START']; h.cycle=0

# P0 baseline.
h.phase_before(0,'BASELINE')
h.monitor(0.20,'P0-baseline')

# P1 block prerequisite; phase published first.
h.phase_before(1,'BLOCK_PREREQUISITE')
h.set_motion_enable(0,'P1-motion-enable-low')
h.monitor(0.20,'P1-hold')

# P2 fresh authorization -> exactly one request pulse while blocked.
h.phase_before(2,'BLOCKED_ON_REQUEST')
h.authorize_once('P2-start')
h.monitor(0.40,'P2-after-request')

# P3 bounded hold; no auth and no request.
h.phase_before(3,'HOLD_BLOCKED')
h.monitor(0.45,'P3-hold')

# P4 restore prerequisite but give no fresh authorization/request.
h.phase_before(4,'RESTORE_NO_RETRY')
h.set_motion_enable(1,'P4-motion-enable-high')
h.monitor(0.45,'P4-no-retry')

# P5 explicit fresh authorization -> fresh request -> wait for achieved ON.
h.phase_before(5,'EXPLICIT_RETRY')
h.authorize_once('P5-retry')
h.wait_until(lambda: h.state==STATE['ON_CONFIRMED'],4.0,'P5-wait-on')
h.monitor(0.20,'P5-confirmed')

# P6 active-state interruption. Publish phase before injected fault.
h.phase_before(6,'ACTIVE_FAULT')
h.set_motion_enable(0,'P6-motion-enable-low')
h.wait_until(lambda: h.state==STATE['RECOVERY_REQUIRED'],4.0,'P6-wait-loss')
h.monitor(0.15,'P6-recovery-required')

# P7 restore cause only; sequencer may enter RECOVERY_WAIT_START but cannot request/enable.
h.phase_before(7,'RESTORE_NO_AUTH')
h.set_motion_enable(1,'P7-motion-enable-high')
h.monitor(0.50,'P7-no-auth')

# P8 fresh post-fault authorization -> new request -> achieved ON -> cycle permission.
h.phase_before(8,'GUARDED_RECOVERY')
h.authorize_once('P8-recovery')
h.wait_until(lambda: h.state==STATE['ON_CONFIRMED'],4.0,'P8-wait-on')
h.monitor(0.20,'P8-confirmed')
h.write()
print(f'trace_rows={len(h.rows)} max_sample_span_ms={max(r["span_ns"] for r in h.rows)/1e6:.3f}')
PY
chmod +x /tmp/c07_sequencer_preflight.py

printf '\n== Execute full P0-P8 preflight ==\n'
python3 /tmp/c07_sequencer_preflight.py
cp /tmp/c07_sequencer_preflight.py c07-sequencer-preflight.py

printf '\n== Analyze preflight ordering and state behavior (NOT Gates A-J scoring) ==\n'
python3 - <<'PY' | tee c07-preflight-analysis.txt
import csv, collections
rows=list(csv.DictReader(open('c07-trace.csv')))
assert rows, 'empty trace'
for r in rows:
    for k in ('seq','t0_ns','t1_ns','span_ns','tick','phase','state','start_authorize','request_internal','request_actual','motion_enable','motion_motion_enabled','machine_is_on','estop_activated','cycle_permission'):
        r[k]=int(r[k])
assert all(b['seq']==a['seq']+1 for a,b in zip(rows,rows[1:])), 'sequence gap'
assert all(b['t0_ns']>=a['t0_ns'] for a,b in zip(rows,rows[1:])), 'non-monotonic timestamps'
assert all(r['t1_ns']>=r['t0_ns'] for r in rows), 'negative sample span'

def phase(p): return [r for r in rows if r['phase']==p]
def events(p): return [r['event'] for r in phase(p)]
def rises(p):
    rs=phase(p); n=0; prev=0
    # phase starts are deliberately quiescent before each request phase.
    for r in rs:
        cur=r['request_actual']
        if cur and not prev: n+=1
        prev=cur
    return n

def first_event_index(substr):
    for i,r in enumerate(rows):
        if substr in r['event']: return i
    raise AssertionError('missing event '+substr)

# Phase publication must precede each decisive mutation.
for p,mut in [(1,'P1-motion-enable-low'),(2,'P2-start-auth-high-before-eval'),(4,'P4-motion-enable-high'),(5,'P5-retry-auth-high-before-eval'),(6,'P6-motion-enable-low'),(7,'P7-motion-enable-high'),(8,'P8-recovery-auth-high-before-eval')]:
    mark=first_event_index(f'PHASE_P{p}_')
    mi=first_event_index(mut)
    assert mark < mi, (p,mark,mi)

# Baseline / blocked / no implicit retry.
assert all(r['machine_is_on']==0 for r in phase(0)), 'P0 not machine-off'
assert all(r['estop_activated']==0 for r in phase(0)), 'P0 estop active'
assert all(r['machine_is_on']==0 for r in phase(2)+phase(3)+phase(4)), 'ON appeared during blocked/no-retry phases'
assert all(r['cycle_permission']==0 for r in phase(0)+phase(1)+phase(2)+phase(3)+phase(4)), 'cycle permission before achieved ON'
assert rises(2)==1, f'P2 request rises={rises(2)}'
assert rises(3)==0 and rises(4)==0, f'hidden retry P3={rises(3)} P4={rises(4)}'

# Explicit retry must observe ON before sequencer/cycle advance.
p5=phase(5)
assert rises(5)==1, f'P5 request rises={rises(5)}'
on_idx=next(i for i,r in enumerate(p5) if r['machine_is_on']==1)
conf_idx=next(i for i,r in enumerate(p5) if r['state']==4)
cyc_idx=next(i for i,r in enumerate(p5) if r['cycle_permission']==1)
assert conf_idx >= on_idx and cyc_idx >= on_idx, (on_idx,conf_idx,cyc_idx)

# Active fault: loss of achieved ON must be followed in the same sequencer tick by revocation.
p6=phase(6)
loss_i=next(i for i,r in enumerate(p6) if r['machine_is_on']==0)
rev_i=next(i for i,r in enumerate(p6) if 'revoked-on-status-loss' in r['event'])
assert rev_i >= loss_i
assert p6[rev_i]['cycle_permission']==0 and p6[rev_i]['state']==5
assert p6[rev_i]['tick']==p6[loss_i]['tick'], (p6[loss_i]['tick'],p6[rev_i]['tick'])

# P7 restoration alone cannot request, enable, or restore cycle permission.
p7=phase(7)
assert rises(7)==0
assert all(r['machine_is_on']==0 for r in p7)
assert all(r['cycle_permission']==0 for r in p7)
assert any(r['state']==6 for r in p7), 'did not reach RECOVERY_WAIT_START'

# P8 fresh authorization/request, then achieved state before permission.
p8=phase(8)
assert rises(8)==1, f'P8 request rises={rises(8)}'
on8=next(i for i,r in enumerate(p8) if r['machine_is_on']==1)
conf8=next(i for i,r in enumerate(p8) if r['state']==4)
cyc8=next(i for i,r in enumerate(p8) if r['cycle_permission']==1)
assert conf8 >= on8 and cyc8 >= on8

print('PRECHECK observation-ordering=PASS')
print('PRECHECK phase-before-mutation=PASS')
print('PRECHECK one-authorization-one-request=PASS P2=1 P5=1 P8=1 P3/P4/P7=0')
print('PRECHECK blocked-request-waits-for-achieved-state=PASS')
print('PRECHECK restore-without-retry=PASS')
print('PRECHECK explicit-retry-status-gating=PASS')
print('PRECHECK active-status-loss-revokes-permission=PASS same-sequencer-tick')
print('PRECHECK no-auto-restart=PASS')
print('PRECHECK guarded-recovery=PASS')
print('PRECHECK safety-boundary=ordinary state-integrity fixture only; NOT functional-safety evidence')
print('PRECHECK RESULT=PASS; frozen C07-047 Gates A-J remain UNSCORED')
print('rows',len(rows),'max_sample_span_ms',max(r['span_ns'] for r in rows)/1e6)
PY

printf '\n== Retained artifacts ==\n'
mkdir -p c07-048-evidence
cp c07-trace.csv c07-preflight-analysis.txt c07-sequencer-preflight.py \
  c07-full-preflight.ini lcncrsh_sim.hal c07-linuxcnc.stdout c07-linuxcnc.stderr \
  /tmp/c07-production-source-sha256.txt /tmp/c07-test-config-sha256.txt \
  /tmp/c07-required-hal-objects.txt /tmp/c07-signals.txt c07-048-evidence/
sha256sum c07-048-evidence/* | tee c07-048-evidence/SHA256SUMS.txt
printf '%s\n' 'C07-048 FULL SEQUENCER PREFLIGHT PASS if exit code is 0. This job MUST NOT be used to score frozen C07-047 Gates A-J.'
printf '%s\n' 'Safety boundary: cycle_permission is a lab policy bit, not a safety-rated output. Physical state, stored energy, E-stop and restart interlocks are outside this fixture.'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
