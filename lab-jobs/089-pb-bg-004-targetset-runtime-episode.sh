#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import json, os

state={'episode':0,'bound_gen':0,'authorized':False,'completion':False,'last_invalidated_gen':0,'reason':'NONE'}
rows=[]
def rec(phase,action,**inp):
    rows.append({'phase':phase,'action':action,'inputs':inp.copy(),'state':state.copy()})

def invalidate(reason):
    if state['bound_gen']:
        state['last_invalidated_gen']=max(state['last_invalidated_gen'],state['bound_gen'])
    state['authorized']=False; state['completion']=False; state['reason']=reason

def step(phase,action,targetset_valid,generation,arm=False,ordinary=True,reference=True,drive=True,feedback=True,fault_clear=True,at_position=False):
    if not targetset_valid: invalidate('TARGETSET_INVALID')
    elif not ordinary: invalidate('AUTHORIZATION_INVALID')
    elif not reference: invalidate('REFERENCE_INVALID')
    elif not drive: invalidate('DRIVE_INVALID')
    elif not feedback: invalidate('FEEDBACK_INVALID')
    elif not fault_clear: invalidate('CONTROLLER_FAULT')
    elif state['authorized']:
        if generation != state['bound_gen']: invalidate('GENERATION_CHANGED')
        else:
            state['completion']=bool(at_position); state['reason']='NONE'
    elif arm:
        if generation <= state['last_invalidated_gen']:
            state['reason']='STALE_GENERATION_REARM_BLOCKED'
        else:
            state['episode']+=1; state['bound_gen']=generation; state['authorized']=True; state['completion']=bool(at_position); state['reason']='NONE'
    else:
        state['reason']='ARM_REQUIRED'
    rec(phase,action,targetset_valid=targetset_valid,generation=generation,arm=arm,ordinary=ordinary,reference=reference,drive=drive,feedback=feedback,fault_clear=fault_clear,at_position=at_position)

# P0 arm generation 10 then current completion
step('P0','arm_gen10',True,10,arm=True); step('P0','complete_gen10',True,10,at_position=True)
A=state['authorized'] and state['episode']==1 and state['bound_gen']==10 and state['completion']
# P1 invalidate
step('P1','targetset_invalid',False,10); B=(not state['authorized'] and not state['completion'] and state['last_invalidated_gen']==10)
# P2 same gen cannot rearm
step('P2','same_gen_rearm',True,10,arm=True); C=(not state['authorized'] and state['reason']=='STALE_GENERATION_REARM_BLOCKED')
# P3 new gen but no arm
step('P3','gen11_no_arm',True,11); D=(not state['authorized'] and state['reason']=='ARM_REQUIRED')
# P4 explicit arm creates E2
step('P4','arm_gen11',True,11,arm=True); E=(state['authorized'] and state['episode']==2 and state['bound_gen']==11)
# P5 auth loss
step('P5','ordinary_auth_loss',True,11,ordinary=False,at_position=True); F=(not state['authorized'] and not state['completion'] and state['last_invalidated_gen']==11)
# P6 recovery same gen cannot resume/rearm
step('P6','recovery_no_arm',True,11); noresume=(not state['authorized']); step('P6','same_gen_rearm_after_auth',True,11,arm=True); G=noresume and not state['authorized'] and state['reason']=='STALE_GENERATION_REARM_BLOCKED'
# P7 ref and feedback independent invalidation using fresh gens
step('P7','arm_gen12',True,12,arm=True); step('P7','reference_loss',True,12,reference=False); refok=(not state['authorized'] and state['reason']=='REFERENCE_INVALID')
step('P7','arm_gen13',True,13,arm=True); step('P7','feedback_loss',True,13,feedback=False); fbok=(not state['authorized'] and state['reason']=='FEEDBACK_INVALID'); H=refok and fbok
# P8 equal opaque numeric target not represented at all; fresh gen identity governs
step('P8','arm_gen14_equal_numeric_external',True,14,arm=True); I=(state['authorized'] and state['bound_gen']==14 and state['episode']==5)
forbidden=['limit3','posthome','motor_command','hydraulic_command','safety_authorization']; blob=json.dumps(rows).lower(); present=[k for k in forbidden if f'"{k}"' in blob]; J=not present
GATES=dict(zip('ABCDEFGHIJ',[A,B,C,D,E,F,G,H,I,J])); summary={'contract':'PB-BG-004','course_level':3600,'records':len(rows),'gates':GATES,'prediction_match':all(GATES.values()),'forbidden_output_keys_present':present,'boundary':'TargetSet-generation/runtime-episode ownership only; no planner, motion, hydraulic, physical, or functional-safety evidence'}
os.makedirs('lab-results/pb-bg-004',exist_ok=True); json.dump(rows,open('lab-results/pb-bg-004/records.json','w'),indent=2); json.dump(summary,open('lab-results/pb-bg-004/summary.json','w'),indent=2); print(json.dumps(summary,indent=2))
if not all(GATES.values()): raise SystemExit('Frozen gate failure')
PY
echo 'PB-BG-004 PASS: TargetSet generation/runtime episode ownership only.'
