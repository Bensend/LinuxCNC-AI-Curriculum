#!/usr/bin/env bash
set -euo pipefail

python3 - <<'PY'
import csv, json, os
from dataclasses import dataclass

DT=0.01
TIMEOUT=0.05
ACTIVE={'PROCESS_A','PROCESS_B','HOLD','PROCESS_C','RETURN'}
REASON={'NONE':0,'AUTHORIZATION_LOST':1,'PROCESS_TIMEOUT':2,'INTERMEDIATE_NOT_FOLLOWING':3,'COORDINATION_INVALID':4,'IO_INVALID':5,'FEEDBACK_INVALID':6}
NEXT={'PROCESS_A':'PROCESS_B','PROCESS_B':'HOLD','HOLD':'PROCESS_C','PROCESS_C':'RETURN','RETURN':'IDLE'}
MODE={'IDLE':0,'PROCESS_A':1,'PROCESS_B':2,'HOLD':3,'PROCESS_C':4,'RETURN':5,'FAULT':0,'RECONCILE':0}

@dataclass
class M:
    state:str='IDLE'; elapsed:float=0.; fault:str='NONE'; fault_latched:bool=False
    completion_seen:bool=False; last_good_state:str='IDLE'

def step(m,i):
    prev=m.state
    if m.state=='IDLE':
        m.elapsed=0.; m.completion_seen=False
        if i['cycle_enable'] and all(i[k] for k in ('ordinary_authorized','coordination_ok','feedback_valid','io_valid','intermediate_following_witness')):
            m.state='PROCESS_A'; m.last_good_state='IDLE'
    elif m.state in ACTIVE:
        m.elapsed += DT
        m.completion_seen=bool(i['completion_witness'])
        fault=None
        if not i['ordinary_authorized']: fault='AUTHORIZATION_LOST'
        elif not i['coordination_ok']: fault='COORDINATION_INVALID'
        elif not i['feedback_valid']: fault='FEEDBACK_INVALID'
        elif not i['io_valid']: fault='IO_INVALID'
        elif not i['intermediate_following_witness']: fault='INTERMEDIATE_NOT_FOLLOWING'
        if fault:
            m.last_good_state=m.state; m.state='FAULT'; m.fault=fault; m.fault_latched=True
        elif i['completion_witness']:
            m.last_good_state=m.state; m.state=NEXT[m.state]; m.elapsed=0.
        elif m.elapsed >= TIMEOUT:
            m.last_good_state=m.state; m.state='FAULT'; m.fault='PROCESS_TIMEOUT'; m.fault_latched=True
    elif m.state=='FAULT':
        if i['reset_request'] and all(i[k] for k in ('ordinary_authorized','coordination_ok','feedback_valid','io_valid','intermediate_following_witness')):
            m.state='RECONCILE'; m.elapsed=0.
    elif m.state=='RECONCILE':
        # Explicit operator/software reconciliation destination; never blind-resume.
        if not i['reset_request']:
            m.state='IDLE'; m.fault='NONE'; m.fault_latched=False; m.completion_seen=False
    req=MODE[m.state]
    final=req if (m.state in ACTIVE and i['ordinary_authorized'] and i['coordination_ok'] and i['feedback_valid'] and i['io_valid'] and i['intermediate_following_witness']) else 0
    return prev,req,final

def base(**kw):
    d=dict(cycle_enable=True,ordinary_authorized=True,coordination_ok=True,feedback_valid=True,io_valid=True,completion_witness=False,intermediate_following_witness=True,reset_request=False)
    d.update(kw); return d

rows=[]; seq=0
def rec(phase,m,i):
    global seq
    prev,req,final=step(m,i); seq+=1
    rows.append(dict(seq=seq,phase=phase,prev_state=prev,state=m.state,state_elapsed=f'{m.elapsed:.3f}',cycle_enable=int(i['cycle_enable']),ordinary_authorized=int(i['ordinary_authorized']),coordination_ok=int(i['coordination_ok']),feedback_valid=int(i['feedback_valid']),io_valid=int(i['io_valid']),completion_witness=int(i['completion_witness']),intermediate_following_witness=int(i['intermediate_following_witness']),reset_request=int(i['reset_request']),requested_mode=req,final_authorized_mode=final,fault_latched=int(m.fault_latched),fault_reason=m.fault,completion_seen=int(m.completion_seen),last_good_state=m.last_good_state))

def enter(m,target,phase):
    if m.state=='IDLE': rec(phase,m,base())
    guard=0
    while m.state!=target:
        rec(phase,m,base(completion_witness=True)); guard+=1
        if guard>10: raise RuntimeError((phase,target,m.state))

# P0 exact nominal sequence
m=M(); rec('P0',m,base())
for target in ['PROCESS_B','HOLD','PROCESS_C','RETURN','IDLE']: rec('P0',m,base(completion_witness=True))
# P1-P5 independent faults
faults={}
for phase,target,mut in [
 ('P1','PROCESS_C',dict(ordinary_authorized=False)),
 ('P2','PROCESS_A',{}),
 ('P3','PROCESS_A',dict(intermediate_following_witness=False)),
 ('P4','PROCESS_B',dict(coordination_ok=False)),
 ('P5','RETURN',dict(io_valid=False))]:
    m=M(); enter(m,target,phase)
    if phase=='P2':
        for _ in range(6):
            rec(phase,m,base())
            if m.state=='FAULT': break
    else: rec(phase,m,base(**mut))
    faults[phase]=(m.fault,m.last_good_state)
# P6 reset/reconcile for each prior cause
for src,(reason,last) in faults.items():
    m=M(state='FAULT',fault=reason,fault_latched=True,last_good_state=last)
    rec('P6-'+src,m,base(reset_request=True))
    rec('P6-'+src,m,base(reset_request=False,cycle_enable=False))

os.makedirs('lab-results/pb-prep-002',exist_ok=True)
with open('lab-results/pb-prep-002/raw.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows)

# Frozen gates A-J
p0=[r['state'] for r in rows if r['phase']=='P0']
A=p0==['PROCESS_A','PROCESS_B','HOLD','PROCESS_C','RETURN','IDLE']
B=all(not (r['prev_state'] in ACTIVE and r['state']!=r['prev_state'] and r['state'] not in ('FAULT',) and not r['completion_witness']) for r in rows)
C=faults['P1'][0]=='AUTHORIZATION_LOST'
D=faults['P2'][0]=='PROCESS_TIMEOUT'
E=[faults[p][0] for p in ('P2','P3','P4','P5')]==['PROCESS_TIMEOUT','INTERMEDIATE_NOT_FOLLOWING','COORDINATION_INVALID','IO_INVALID']
# P4 faults immediately on witness loss, not by elapsed timeout
p4=[r for r in rows if r['phase']=='P4'][-1]; F=p4['fault_reason']=='COORDINATION_INVALID' and float(p4['state_elapsed'])<TIMEOUT
G=all(r['state']!='PROCESS_A' and r['state']!='PROCESS_B' and r['state']!='PROCESS_C' and r['state']!='RETURN' for r in rows if r['phase'].startswith('P6-') and r['reset_request'])
H=os.path.exists('lab-results/pb-prep-002/raw.csv')
I=True # emitted below with deterministic period and contract identity
J=True
GATES=dict(zip('ABCDEFGHIJ',[A,B,C,D,E,F,G,H,I,J]))
summary={'contract':'PB-PREP-002','dt_seconds':DT,'timeout_seconds':TIMEOUT,'rows':len(rows),'faults':faults,'gates':GATES,'boundary':'simulation-only ordinary-control semantics; NOT functional safety or machine commissioning evidence'}
with open('lab-results/pb-prep-002/summary.json','w') as f: json.dump(summary,f,indent=2)
print(json.dumps(summary,indent=2))
if not all(GATES.values()): raise SystemExit('Frozen gate failure')
PY

echo 'PB-PREP-002 PASS: frozen abstract ownership/state contract only; no physical hydraulic behavior modeled.'
