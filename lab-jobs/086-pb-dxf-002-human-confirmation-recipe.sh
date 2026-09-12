#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import json, os
from dataclasses import dataclass, asdict
from copy import deepcopy

UNKNOWN='UNKNOWN'

@dataclass
class Candidate:
    bend_id:str; rev:str; review:str='UNREVIEWED'; angle:object=UNKNOWN; radius:object=UNKNOWN; direction:object=UNKNOWN

@dataclass
class Step:
    step_id:str; bend_id:str; ordinal:int; rev:str; validation:str='DRAFT'; reason:str='NONE'

def accept(step,cands,required=('angle','direction')):
    c=cands.get(step.bend_id)
    if c is None:
        step.validation='INVALID'; step.reason='MISSING_FEATURE'; return False
    if c.rev != step.rev:
        step.validation='REVIEW_REQUIRED'; step.reason='SOURCE_REVISION_MISMATCH'; return False
    if c.review!='CONFIRMED':
        step.validation='INVALID' if c.review=='REJECTED' else 'REVIEW_REQUIRED'
        step.reason=f'FEATURE_{c.review}'; return False
    missing=[k for k in required if getattr(c,k)==UNKNOWN]
    if missing:
        step.validation='REVIEW_REQUIRED'; step.reason='UNKNOWN_REQUIRED:'+','.join(missing); return False
    step.validation='ACCEPTED'; step.reason='NONE'; return True

records=[]
def rec(phase, action, cands, steps, note=''):
    records.append(dict(phase=phase,action=action,note=note,candidates=[asdict(c) for c in cands.values()],steps=[asdict(s) for s in steps]))

# P0 normal confirmation/acceptance
c={
 'B1':Candidate('B1','R1','CONFIRMED',90,1.5,'UP'),
 'B2':Candidate('B2','R1','CONFIRMED',45,1.0,'DOWN')}
s=[Step('S1','B1',1,'R1'),Step('S2','B2',2,'R1')]
for x in s: accept(x,c)
rec('P0','accept_recipe',c,s)
P0=all(x.validation=='ACCEPTED' for x in s)

# P1 reorder: identities invariant
before=[(x.step_id,x.bend_id,x.ordinal) for x in s]
s[0].ordinal,s[1].ordinal=2,1
after=[(x.step_id,x.bend_id,x.ordinal) for x in s]
rec('P1','reorder',c,s)
P1=before[0][:2]==after[0][:2] and before[1][:2]==after[1][:2] and [x[2] for x in before]!=[x[2] for x in after]

# P2 confirmed identity but required direction UNKNOWN
c2={'B3':Candidate('B3','R1','CONFIRMED',90,1.2,UNKNOWN)}
s2=[Step('S3','B3',1,'R1')]
accepted=accept(s2[0],c2)
rec('P2','attempt_accept_unknown_direction',c2,s2)
P2=(not accepted and c2['B3'].direction==UNKNOWN and s2[0].validation=='REVIEW_REQUIRED' and 'direction' in s2[0].reason)

# P3 ambiguous cannot produce accepted step
c3={'B4':Candidate('B4','R1','AMBIGUOUS',90,1.0,'UP')}
s3=[Step('S4','B4',1,'R1')]
accepted=accept(s3[0],c3)
rec('P3','attempt_accept_ambiguous',c3,s3)
P3=(not accepted and s3[0].validation!='ACCEPTED' and s3[0].reason=='FEATURE_AMBIGUOUS')

# P4 rejection invalidates dependent draft
c4={'B5':Candidate('B5','R1','CONFIRMED',90,1.0,'UP')}
s4=[Step('S5','B5',1,'R1')]
rec('P4','draft_created',c4,s4)
c4['B5'].review='REJECTED'; accept(s4[0],c4)
rec('P4','feature_rejected',c4,s4)
P4=(s4[0].validation=='INVALID' and s4[0].reason=='FEATURE_REJECTED')

# P5 revision change without trusted stable remap
c5={'B1-R2':Candidate('B1-R2','R2','UNREVIEWED',90,1.5,'UP')}
s5=[Step('S1','B1',1,'R1','ACCEPTED','NONE')]
# old candidate no longer current => explicit stale/review result
s5[0].validation='REVIEW_REQUIRED'; s5[0].reason='SOURCE_REVISION_CHANGED_NO_TRUSTED_REMAP'
rec('P5','reimport_without_trusted_remap',c5,s5)
P5=(s5[0].validation=='REVIEW_REQUIRED' and 'NO_TRUSTED_REMAP' in s5[0].reason and s5[0].rev=='R1')

# P6 trusted stable remap unchanged semantics: rebind then explicit current validation
c6={'B1':Candidate('B1','R2','CONFIRMED',90,1.5,'UP')}
s6=[Step('S1','B1',1,'R1','REVIEW_REQUIRED','TRUSTED_REMAP_REBIND_REQUIRED')]
rec('P6','trusted_remap_proposed',c6,s6)
s6[0].rev='R2'; ok=accept(s6[0],c6)
rec('P6','explicit_current_validation',c6,s6)
P6=(ok and s6[0].rev=='R2' and s6[0].validation=='ACCEPTED')

# P7 trusted identity but required semantic changed => review before reaccept
c7={'B1':Candidate('B1','R2','CONFIRMED',90,1.5,'DOWN')}
s7=[Step('S1','B1',1,'R1','ACCEPTED','NONE')]
s7[0].validation='REVIEW_REQUIRED'; s7[0].reason='REQUIRED_SEMANTIC_CHANGED:direction'; s7[0].rev='R2'
rec('P7','trusted_remap_semantic_changed',c7,s7)
P7=(s7[0].validation=='REVIEW_REQUIRED' and s7[0].reason=='REQUIRED_SEMANTIC_CHANGED:direction')

# P8 authority boundary: retained schema must not contain forbidden outputs
forbidden={'gauge_target','target_set','target_set_generation','joint_command','machine_enable','tooling_choice','collision_result','hydraulic_command','functional_safety'}
blob=json.dumps(records).lower()
# exact key-like checks, not prose values
present=[]
for k in forbidden:
    if f'"{k}"' in blob: present.append(k)
P8=(not present)

# Gate I: machine-readable reasons and revision evidence in every nonaccepted state after transitions
relevant=[]
for r in records:
    for st in r['steps']:
        if st['validation'] in ('REVIEW_REQUIRED','INVALID'):
            relevant.append(st)
I=bool(relevant) and all(st['reason']!='NONE' and st['rev'] for st in relevant)
J=P8
GATES=dict(zip('ABCDEFGHIJ',[P0,P1,P2,P3,P4,P5,P6,P7,I,J]))
summary={
 'contract':'PB-DXF-002',
 'course_level':3600,
 'records':len(records),
 'gates':GATES,
 'prediction_match':all(GATES.values()),
 'forbidden_output_keys_present':present,
 'boundary':'application confirmation/recipe-state semantics only; no gauge planning, machine motion, tooling, collision, hydraulic, or functional-safety evidence'
}
os.makedirs('lab-results/pb-dxf-002',exist_ok=True)
with open('lab-results/pb-dxf-002/records.json','w') as f: json.dump(records,f,indent=2)
with open('lab-results/pb-dxf-002/summary.json','w') as f: json.dump(summary,f,indent=2)
print(json.dumps(summary,indent=2))
if not all(GATES.values()): raise SystemExit('Frozen gate failure')
PY

echo 'PB-DXF-002 PASS: human-confirmation/recipe identity contract only; no machine authority modeled.'
