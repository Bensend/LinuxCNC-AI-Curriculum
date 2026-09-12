#!/usr/bin/env bash
set -euo pipefail

# Pure synthetic software-state test. No LinuxCNC/HAL connection, hardware I/O,
# motion command, actuator model, machine parameter, or physical behavior.
python3 - <<'PY'
import csv, json, os
counter=active=completed=0
valid=False
reconcile_required=False
rows=[]

def emit(phase, *, new=False, target=0, reference_valid=True, ordinary_authority=True,
         drive_valid=True, feedback_valid=True, controller_fault_clear=True,
         completion_ready=False, reconcile=False):
    global counter,active,completed,valid,reconcile_required
    current_health=all((reference_valid,ordinary_authority,drive_valid,feedback_valid,controller_fault_clear))
    if not current_health:
        valid=False; reconcile_required=True; completed=0
    if reconcile and current_health:
        reconcile_required=False; valid=False; completed=0
    if new and current_health and not reconcile_required:
        counter += 1; active=counter; valid=True; completed=0
    if valid and current_health and not reconcile_required and completion_ready:
        completed=active
    at_position=bool(valid and current_health and not reconcile_required and completion_ready and completed==active and active!=0)
    rows.append(dict(seq=len(rows)+1,phase=phase,new=int(new),target=target,
        reference_valid=int(reference_valid),ordinary_authority=int(ordinary_authority),
        drive_valid=int(drive_valid),feedback_valid=int(feedback_valid),
        controller_fault_clear=int(controller_fault_clear),completion_ready=int(completion_ready),
        reconcile=int(reconcile),active_episode=active,episode_valid=int(valid),
        reconcile_required=int(reconcile_required),completed_episode=completed,at_position=int(at_position)))

# Frozen P0-P7, with distinct invalidation input retained in each relevant phase.
emit('P0',new=True,target=10); emit('P0',target=10); emit('P0',target=10,completion_ready=True)
emit('P1',new=True,target=10); emit('P1',target=10); emit('P1',target=10,completion_ready=True)
emit('P2',target=10,reference_valid=False,completion_ready=True); emit('P2',target=10,reference_valid=True,completion_ready=True)
emit('P3',target=10,reconcile=True); emit('P3',new=True,target=12); emit('P3',target=12,completion_ready=True)
emit('P4',target=12,drive_valid=False,completion_ready=True); emit('P4',target=12,drive_valid=True,completion_ready=True)
emit('P5',target=12,reconcile=True); emit('P5',new=True,target=14); emit('P5',target=14,completion_ready=True); emit('P5',target=14,feedback_valid=False,completion_ready=True); emit('P5',target=14,feedback_valid=True,completion_ready=True)
emit('P6',target=14,reconcile=True); emit('P6',new=True,target=16); emit('P6',target=16,completion_ready=True); emit('P6',target=16,controller_fault_clear=False,completion_ready=True); emit('P6',target=16,controller_fault_clear=True,completion_ready=True)
emit('P7',target=16,reconcile=True); emit('P7',new=True,target=18); emit('P7',target=18,completion_ready=True); emit('P7',target=18,ordinary_authority=False,completion_ready=True); emit('P7',target=18,ordinary_authority=True,completion_ready=True)

p=lambda x:[r for r in rows if r['phase']==x]
A=[r['seq'] for r in rows]==list(range(1,len(rows)+1))
B=p('P0')[0]['at_position']==0 and p('P0')[1]['at_position']==0 and p('P0')[2]['active_episode']==1 and p('P0')[2]['at_position']==1
C=p('P1')[0]['target']==10 and p('P1')[0]['active_episode']==2 and p('P1')[0]['at_position']==0
D=p('P1')[-1]['active_episode']==2 and p('P1')[-1]['completed_episode']==2 and p('P1')[-1]['at_position']==1
E=p('P2')[0]['reference_valid']==0 and p('P2')[0]['episode_valid']==0 and p('P2')[0]['reconcile_required']==1 and p('P2')[1]['reference_valid']==1 and p('P2')[1]['at_position']==0
F=p('P3')[0]['episode_valid']==0 and p('P3')[0]['reconcile_required']==0 and p('P3')[0]['at_position']==0 and p('P3')[1]['active_episode']==3 and p('P3')[2]['at_position']==1
G=p('P4')[0]['drive_valid']==0 and p('P4')[0]['at_position']==0 and p('P4')[1]['drive_valid']==1 and p('P4')[1]['episode_valid']==0 and p('P4')[1]['at_position']==0
H=p('P5')[-2]['feedback_valid']==0 and p('P5')[-2]['reconcile_required']==1 and p('P5')[-1]['feedback_valid']==1 and p('P5')[-1]['episode_valid']==0 and p('P5')[-1]['at_position']==0
I=(p('P6')[-2]['controller_fault_clear']==0 and p('P6')[-1]['controller_fault_clear']==1 and p('P6')[-1]['episode_valid']==0 and p('P6')[-1]['at_position']==0 and p('P7')[-2]['ordinary_authority']==0 and p('P7')[-1]['ordinary_authority']==1 and p('P7')[-1]['episode_valid']==0 and p('P7')[-1]['at_position']==0)
J=all((not r['at_position']) or (r['reference_valid']==1 and r['ordinary_authority']==1 and r['drive_valid']==1 and r['feedback_valid']==1 and r['controller_fault_clear']==1 and r['completion_ready']==1 and r['episode_valid']==1 and r['reconcile_required']==0 and r['completed_episode']==r['active_episode']) for r in rows)
gates=dict(zip('ABCDEFGHIJ',[A,B,C,D,E,F,G,H,I,J]))
os.makedirs('lab-results/pb-bg-003-corrected',exist_ok=True)
with open('lab-results/pb-bg-003-corrected/raw.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows)
summary={'contract':'PB-BG-003','attempt':'corrected-separated-witnesses','rows':len(rows),'gates':gates,'prediction_match':all(gates.values()),'boundary':'pure synthetic state logic only; no physical machine or hardware behavior'}
with open('lab-results/pb-bg-003-corrected/summary.json','w') as f: json.dump(summary,f,indent=2)
print(json.dumps(summary,indent=2))
if not all(gates.values()): raise SystemExit('Frozen gate failure')
PY
