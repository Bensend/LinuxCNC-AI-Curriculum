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
