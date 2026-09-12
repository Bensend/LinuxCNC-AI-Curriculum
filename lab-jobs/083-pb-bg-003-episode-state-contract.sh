#!/usr/bin/env bash
set -euo pipefail

# Pure software state-contract test. It has no LinuxCNC, HAL, hardware, motion,
# actuator, network, or machine I/O. Boolean witnesses are synthetic.
python3 - <<'PY'
import csv, json, os

counter=0
active=0
valid=False
reconcile_required=False
completed=0
rows=[]

def emit(phase, *, new=False, healthy=True, done=False, reconcile=False, target=0):
    global counter,active,valid,reconcile_required,completed
    if not healthy:
        valid=False; reconcile_required=True; completed=0
    if reconcile and healthy:
        reconcile_required=False; valid=False; completed=0
    if new and healthy and not reconcile_required:
        counter += 1; active=counter; valid=True; completed=0
    if valid and healthy and not reconcile_required and done:
        completed=active
    at_position = bool(valid and healthy and not reconcile_required and done and completed==active and active!=0)
    rows.append(dict(seq=len(rows)+1,phase=phase,new=int(new),healthy=int(healthy),done=int(done),reconcile=int(reconcile),target=target,active_episode=active,episode_valid=int(valid),reconcile_required=int(reconcile_required),completed_episode=completed,at_position=int(at_position)))

# P0 nominal episode 1
emit('P0',new=True,target=10); emit('P0',target=10); emit('P0',done=True,target=10)
# P1 same target reissue: new episode cannot inherit old completion
emit('P1',new=True,target=10); emit('P1',target=10); emit('P1',done=True,target=10)
# P2 validity loss and raw recovery do not resurrect episode 2
emit('P2',healthy=False,target=10); emit('P2',healthy=True,done=True,target=10)
# P3 reconcile alone does not resurrect; new ep3 can complete
emit('P3',healthy=True,reconcile=True,target=10); emit('P3',new=True,target=12); emit('P3',done=True,target=12)
# P4 post-completion validity loss and raw recovery
emit('P4',healthy=False,target=12); emit('P4',healthy=True,done=True,target=12)
# P5 reconcile/new ep4/complete, one-invocation invalidation, healthy snapshot remains invalid
emit('P5',healthy=True,reconcile=True,target=12); emit('P5',new=True,target=14); emit('P5',done=True,target=14); emit('P5',healthy=False,done=True,target=14); emit('P5',healthy=True,done=True,target=14)
# P6/P7 repeat independent invalidation families using the same abstract validity input
emit('P6',healthy=True,reconcile=True,target=14); emit('P6',new=True,target=16); emit('P6',done=True,target=16); emit('P6',healthy=False,done=True,target=16); emit('P6',healthy=True,done=True,target=16)
emit('P7',healthy=True,reconcile=True,target=16); emit('P7',new=True,target=18); emit('P7',done=True,target=18); emit('P7',healthy=False,done=True,target=18); emit('P7',healthy=True,done=True,target=18)

p=lambda name:[r for r in rows if r['phase']==name]
A=[r['seq'] for r in rows]==list(range(1,len(rows)+1))
B=p('P0')[-1]['active_episode']==1 and p('P0')[-1]['at_position']==1
C=p('P1')[0]['active_episode']==2 and p('P1')[0]['target']==10 and p('P1')[0]['at_position']==0
D=p('P1')[-1]['active_episode']==2 and p('P1')[-1]['at_position']==1
E=p('P2')[0]['episode_valid']==0 and p('P2')[0]['reconcile_required']==1 and p('P2')[1]['at_position']==0
F=p('P3')[0]['episode_valid']==0 and p('P3')[0]['at_position']==0 and p('P3')[1]['active_episode']==3 and p('P3')[-1]['at_position']==1
G=p('P4')[0]['at_position']==0 and p('P4')[1]['episode_valid']==0 and p('P4')[1]['at_position']==0
H=p('P5')[-2]['reconcile_required']==1 and p('P5')[-1]['healthy']==1 and p('P5')[-1]['episode_valid']==0 and p('P5')[-1]['at_position']==0
I=all(p(x)[-2]['at_position']==0 and p(x)[-1]['episode_valid']==0 and p(x)[-1]['at_position']==0 for x in ('P6','P7'))
J=all((not r['at_position']) or (r['healthy']==1 and r['episode_valid']==1 and r['reconcile_required']==0 and r['done']==1 and r['completed_episode']==r['active_episode']) for r in rows)
gates=dict(zip('ABCDEFGHIJ',[A,B,C,D,E,F,G,H,I,J]))
os.makedirs('lab-results/pb-bg-003',exist_ok=True)
with open('lab-results/pb-bg-003/raw.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows)
summary={'contract':'PB-BG-003','rows':len(rows),'gates':gates,'prediction_match':all(gates.values()),'boundary':'pure synthetic state-logic verification; no machine or hardware behavior'}
with open('lab-results/pb-bg-003/summary.json','w') as f: json.dump(summary,f,indent=2)
print(json.dumps(summary,indent=2))
if not all(gates.values()): raise SystemExit('Frozen gate failure')
PY
