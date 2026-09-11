#!/usr/bin/env bash
set -euo pipefail

python3 - <<'PY'
import csv, json, os
from dataclasses import dataclass, field

BITS = [
    'TRANSPORT_INVALID','WATCHDOG_NOT_CLEAR','FEEDBACK_INVALID',
    'FEEDBACK_NOT_REVALIDATED','REFERENCE_INVALID','INTERLOCK_INVALID',
    'FOLLOWING_ERROR','RECORDER_INVALID'
]
CONTROL_BITS = set(BITS) - {'RECORDER_INVALID'}

@dataclass
class M:
    state: str = 'READY'
    history: set = field(default_factory=set)
    rearm_latched: bool = False
    reconcile_required: bool = False
    stale_command_present: bool = False

seq = 0
rows = []

def base(**kw):
    d = dict(
        run_request=False,
        transport_ok=True,
        watchdog_clear=True,
        feedback_valid=True,
        feedback_independent_or_revalidated=True,
        reference_valid=True,
        required_interlocks_ok=True,
        following_error=False,
        recorder_valid=True,
        reconcile_request=False,
        reconcile_complete=False,
        explicit_rearm=False,
    )
    d.update(kw)
    return d

def current_bits(i):
    b = set()
    if not i['transport_ok']: b.add('TRANSPORT_INVALID')
    if not i['watchdog_clear']: b.add('WATCHDOG_NOT_CLEAR')
    if not i['feedback_valid']: b.add('FEEDBACK_INVALID')
    if not i['feedback_independent_or_revalidated']: b.add('FEEDBACK_NOT_REVALIDATED')
    if not i['reference_valid']: b.add('REFERENCE_INVALID')
    if not i['required_interlocks_ok']: b.add('INTERLOCK_INVALID')
    if i['following_error']: b.add('FOLLOWING_ERROR')
    if not i['recorder_valid']: b.add('RECORDER_INVALID')
    return b

def immediate_reconcile_ok(i):
    # Revalidation/reference are allowed to be established during reconciliation;
    # all other immediate control prerequisites must already be sound.
    return (i['transport_ok'] and i['watchdog_clear'] and i['feedback_valid']
            and i['required_interlocks_ok'] and not i['following_error'])

def control_ok(i):
    return immediate_reconcile_ok(i) and i['feedback_independent_or_revalidated'] and i['reference_valid']

def step(m, phase, i):
    global seq
    prev = m.state
    bits = current_bits(i)
    m.history.update(bits)
    revoked = False

    if m.state == 'READY':
        if i['explicit_rearm'] and control_ok(i) and not m.reconcile_required:
            m.rearm_latched = True
        if i['run_request'] and m.rearm_latched and control_ok(i) and not m.reconcile_required:
            m.state = 'RUNNING'
            m.stale_command_present = True

    elif m.state == 'RUNNING':
        if not control_ok(i):
            m.state = 'FAULTED'
            m.rearm_latched = False
            m.reconcile_required = True
            m.stale_command_present = False
            revoked = True
        # recorder validity is deliberately NOT part of control_ok

    elif m.state == 'FAULTED':
        # explicit_rearm is deliberately ignored before reconciliation.
        if i['reconcile_request'] and immediate_reconcile_ok(i):
            m.state = 'RECONCILE'

    elif m.state == 'RECONCILE':
        if not immediate_reconcile_ok(i):
            m.state = 'FAULTED'
            m.rearm_latched = False
            m.reconcile_required = True
            m.stale_command_present = False
            revoked = True
        elif i['reconcile_complete'] and i['feedback_independent_or_revalidated'] and i['reference_valid']:
            m.state = 'READY'
            m.reconcile_required = False
            m.rearm_latched = False
            m.stale_command_present = False

    motion_authorized = (m.state == 'RUNNING' and control_ok(i) and m.rearm_latched)
    evidence_valid = bool(i['recorder_valid'])

    seq += 1
    row = dict(
        seq=seq, phase=phase, prev_state=prev, state=m.state,
        **{k:int(v) for k,v in i.items()},
        motion_authorized=int(motion_authorized),
        stale_command_present=int(m.stale_command_present),
        current_faults='|'.join(sorted(bits)) if bits else 'NONE',
        latched_history='|'.join(sorted(m.history)) if m.history else 'NONE',
        evidence_valid=int(evidence_valid), rearm_latched=int(m.rearm_latched),
        reconcile_required=int(m.reconcile_required), revoked_this_invocation=int(revoked)
    )
    rows.append(row)
    return row

# P0 nominal start: explicit rearm then fresh run request.
m = M()
p0a = step(m,'P0',base(explicit_rearm=True))
p0b = step(m,'P0',base(run_request=True))

# P1 transport loss, then following error as a secondary observation.
p1a = step(m,'P1',base(transport_ok=False))
p1b = step(m,'P1',base(transport_ok=False, following_error=True))

# P2 transport recovery does not repair watchdog/reference/revalidation.
p2 = step(m,'P2',base(watchdog_clear=False,
                      feedback_independent_or_revalidated=False,
                      reference_valid=False))

# P3 recorder loss during same episode adds evidence defect without erasing history.
p3 = step(m,'P3',base(watchdog_clear=False,
                      feedback_independent_or_revalidated=False,
                      reference_valid=False, recorder_valid=False))

# P4 premature rearm remains faulted.
p4 = step(m,'P4',base(watchdog_clear=False,
                      feedback_independent_or_revalidated=False,
                      reference_valid=False, explicit_rearm=True))

# P5 enter reconcile once immediate conditions are sound, then inject second fault.
p5a = step(m,'P5',base(feedback_independent_or_revalidated=False,
                       reference_valid=False, reconcile_request=True))
p5b = step(m,'P5',base(feedback_independent_or_revalidated=False,
                       reference_valid=False, required_interlocks_ok=False))

# P6 successful retry: enter reconcile, independently revalidate/reference, complete.
p6a = step(m,'P6',base(feedback_independent_or_revalidated=False,
                       reference_valid=False, reconcile_request=True))
p6b = step(m,'P6',base(feedback_independent_or_revalidated=True,
                       reference_valid=True, reconcile_complete=True))

# P7 explicit rearm does not run until a NEW run request arrives.
p7a = step(m,'P7',base(explicit_rearm=True))
p7b = step(m,'P7',base())
p7c = step(m,'P7',base(run_request=True))

# P8 separate fresh episode: agreement/valid samples but no independent revalidation.
m8 = M(state='FAULTED', reconcile_required=True, history={'FEEDBACK_NOT_REVALIDATED'})
p8a = step(m8,'P8',base(feedback_independent_or_revalidated=False,
                        reconcile_request=True))
p8b = step(m8,'P8',base(feedback_independent_or_revalidated=False,
                        reconcile_complete=True, explicit_rearm=True))

# P9 separate fresh run: recorder-only degradation must not invent motion revocation.
m9 = M()
step(m9,'P9',base(explicit_rearm=True))
step(m9,'P9',base(run_request=True))
p9 = step(m9,'P9',base(recorder_valid=False))

os.makedirs('lab-results/f02-001', exist_ok=True)
raw = 'lab-results/f02-001/raw.csv'
with open(raw,'w',newline='') as f:
    w = csv.DictWriter(f, fieldnames=rows[0].keys())
    w.writeheader(); w.writerows(rows)

# Frozen Gates A-J.
A = (p0a['state']=='READY' and p0a['rearm_latched']==1 and p0a['motion_authorized']==0
     and p0b['state']=='RUNNING' and p0b['motion_authorized']==1)
B = (p1a['prev_state']=='RUNNING' and p1a['state']=='FAULTED'
     and p1a['motion_authorized']==0 and p1a['revoked_this_invocation']==1)
hist3 = set(p3['latched_history'].split('|'))
C = {'TRANSPORT_INVALID','FOLLOWING_ERROR','RECORDER_INVALID'}.issubset(hist3)
D = (p2['state']=='FAULTED' and p2['motion_authorized']==0
     and 'WATCHDOG_NOT_CLEAR' in p2['current_faults']
     and 'FEEDBACK_NOT_REVALIDATED' in p2['current_faults']
     and 'REFERENCE_INVALID' in p2['current_faults'])
E = (p3['evidence_valid']==0 and p9['evidence_valid']==0
     and p9['state']=='RUNNING' and p9['motion_authorized']==1
     and p9['current_faults']=='RECORDER_INVALID')
F = (p4['state']=='FAULTED' and p4['motion_authorized']==0 and p4['rearm_latched']==0)
G = (p5a['state']=='RECONCILE' and p5b['state']=='FAULTED'
     and 'INTERLOCK_INVALID' in p5b['latched_history'])
H = (p6b['state']=='READY' and p6b['motion_authorized']==0
     and p6b['stale_command_present']==0 and p6b['rearm_latched']==0)
I = (p7a['state']=='READY' and p7a['motion_authorized']==0 and p7a['rearm_latched']==1
     and p7b['state']=='READY' and p7b['motion_authorized']==0
     and p7c['state']=='RUNNING' and p7c['motion_authorized']==1)
J = (p8a['state']=='RECONCILE' and p8b['state']=='RECONCILE'
     and p8b['motion_authorized']==0 and p8b['rearm_latched']==0
     and 'FEEDBACK_NOT_REVALIDATED' in p8b['current_faults'])
GATES = dict(zip('ABCDEFGHIJ',[A,B,C,D,E,F,G,H,I,J]))

# Retention sanity required by frozen rejection conditions.
seqs = [r['seq'] for r in rows]
retention = {
    'strict_monotonic_complete_seq': seqs == list(range(1,len(rows)+1)),
    'rows': len(rows),
    'required_columns_present': all(k in rows[0] for k in [
        'seq','phase','prev_state','state','motion_authorized','stale_command_present',
        'current_faults','latched_history','evidence_valid','rearm_latched',
        'reconcile_required','revoked_this_invocation'])
}
summary = {
    'contract':'F02-001', 'course_level':2000,
    'pinned_linuxcnc':'8bf4605ae81042248add031e94c77300406e0413',
    'rows':len(rows), 'retention':retention, 'gates':GATES,
    'prediction_match':all(GATES.values()),
    'boundary':'deterministic ordinary-control policy only; not physical, network, machine-commissioning, or functional-safety evidence'
}
with open('lab-results/f02-001/summary.json','w') as f:
    json.dump(summary,f,indent=2)
print(json.dumps(summary,indent=2))
if not all(retention.values()): raise SystemExit('HARNESS INVALID: retention contract failed')
if not all(GATES.values()): raise SystemExit('F02-001 behavioral gate failure')
PY

echo 'F02-001 PASS: compound-fault policy contract only; no physical-machine or functional-safety claim.'
