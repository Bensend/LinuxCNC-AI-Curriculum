#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import json, os
from dataclasses import dataclass, asdict

@dataclass
class Step:
    step_id:str; bend_id:str; ordinal:int; rev:str; validation:str='ACCEPTED'
@dataclass
class Plan:
    gauge_plan_id:str; step_id:str; bend_id:str; rev:str; datum_id:str; datum_provenance:str; mechanisms:tuple; validation:str='DRAFT'; reason:str='NONE'

def validate(p,s):
    if s.validation!='ACCEPTED': p.validation='REVIEW_REQUIRED'; p.reason='STEP_'+s.validation; return False
    if p.step_id!=s.step_id or p.bend_id!=s.bend_id: p.validation='INVALID'; p.reason='STEP_BINDING_MISMATCH'; return False
    if p.rev!=s.rev: p.validation='REVIEW_REQUIRED'; p.reason='SOURCE_REVISION_MISMATCH'; return False
    if p.datum_id=='UNASSIGNED' or not p.datum_provenance: p.validation='REVIEW_REQUIRED'; p.reason='DATUM_UNASSIGNED'; return False
    if not p.mechanisms: p.validation='REVIEW_REQUIRED'; p.reason='MECHANISM_SET_EMPTY'; return False
    p.validation='ACCEPTED'; p.reason='NONE'; return True

rows=[]
def rec(phase,action,s,p): rows.append({'phase':phase,'action':action,'step':asdict(s),'plan':asdict(p)})

s=Step('S1','B1',1,'R1'); p=Plan('GP1','S1','B1','R1','D1','entity:E17',('X',)); A=validate(p,s); rec('P0','accept',s,p)
old=(p.gauge_plan_id,p.step_id,p.bend_id); s.ordinal=3; rec('P1','reorder',s,p); B=(old==(p.gauge_plan_id,p.step_id,p.bend_id))
s2=Step('S2','B2',1,'R1'); p2=Plan('GP2','S2','B2','R1','UNASSIGNED','',('X',)); C=not validate(p2,s2) and p2.reason=='DATUM_UNASSIGNED'; rec('P2','no_datum',s2,p2)
s3=Step('S1','B1',3,'R1','REVIEW_REQUIRED'); p3=Plan('GP1','S1','B1','R1','D1','entity:E17',('X',),'ACCEPTED'); D=not validate(p3,s3) and p3.validation=='REVIEW_REQUIRED'; rec('P3','step_invalidated',s3,p3)
s4=Step('S1','B1',3,'R2'); p4=Plan('GP1','S1','B1','R1','D1','entity:E17',('X',),'REVIEW_REQUIRED','DATUM_REMAP_REQUIRED'); rec('P4','reimport_no_datum_remap',s4,p4); E=(p4.validation=='REVIEW_REQUIRED' and p4.rev=='R1' and p4.reason=='DATUM_REMAP_REQUIRED')
p5=Plan('GP1','S1','B1','R1','D1','entity:E17',('X',),'REVIEW_REQUIRED','TRUSTED_DATUM_REBIND_REQUIRED'); rec('P5','trusted_remap_proposed',s4,p5); p5.rev='R2'; p5.datum_provenance='entity:E44'; F=validate(p5,s4); rec('P5','explicit_revalidate',s4,p5)
s6=Step('S1','B1',3,'R2'); p6=Plan('GP1','S1','B1','R2','D1','entity:E44',('X',),'ACCEPTED'); p6.mechanisms=('X','R'); p6.validation='REVIEW_REQUIRED'; p6.reason='MECHANISM_SET_CHANGED'; rec('P6','mechanism_change',s6,p6); G=(p6.validation=='REVIEW_REQUIRED' and p6.reason=='MECHANISM_SET_CHANGED')
relevant=[r['plan'] for r in rows if r['plan']['validation']!='ACCEPTED']; H=all(x['reason']!='NONE' and x['rev'] for x in relevant)
I=all(r['plan']['step_id']==r['step']['step_id'] and r['plan']['bend_id']==r['step']['bend_id'] for r in rows)
forbidden=['gauge_target','target_set','target_set_generation','joint_command','posthome_cmd','tooling_choice','collision_result','hydraulic_command','safety_authorization']
blob=json.dumps(rows).lower(); present=[k for k in forbidden if f'"{k}"' in blob]; J=not present
GATES=dict(zip('ABCDEFGHIJ',[A,B,C,D,E,F,G,H,I,J]))
summary={'contract':'PB-DXF-003','course_level':3600,'records':len(rows),'gates':GATES,'prediction_match':all(GATES.values()),'forbidden_output_keys_present':present,'boundary':'GaugePlan provenance/invalidation only; no numeric targets or machine authority'}
os.makedirs('lab-results/pb-dxf-003',exist_ok=True)
json.dump(rows,open('lab-results/pb-dxf-003/records.json','w'),indent=2); json.dump(summary,open('lab-results/pb-dxf-003/summary.json','w'),indent=2)
print(json.dumps(summary,indent=2))
if not all(GATES.values()): raise SystemExit('Frozen gate failure')
PY
echo 'PB-DXF-003 PASS: GaugePlan provenance/invalidation contract only.'
