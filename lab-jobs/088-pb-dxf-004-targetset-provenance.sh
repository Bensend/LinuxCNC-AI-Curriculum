#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import json, os
from dataclasses import dataclass, asdict

@dataclass
class GP:
    gid:str; rev:str; mechanisms:tuple; validation:str='ACCEPTED'
@dataclass
class TS:
    tid:str; gid:str; kind:str; method:str; deps:dict; targets:dict; validation:str='DRAFT'; reason:str='NONE'; generation:int=0

generation=0
current={'gp_rev':'R1','calibration':'C1','tooling':'T1','bend_model':'B1','cam_package':'PK1','cam_compat':'MC1'}
def validate(t,g):
    global generation
    if g.validation!='ACCEPTED': t.validation='REVIEW_REQUIRED'; t.reason='GAUGEPLAN_'+g.validation; return False
    if t.gid!=g.gid: t.validation='INVALID'; t.reason='GAUGEPLAN_BINDING_MISMATCH'; return False
    if set(t.targets)!=set(g.mechanisms): t.validation='REVIEW_REQUIRED'; t.reason='MECHANISM_COVERAGE_MISMATCH'; return False
    for k,v in t.deps.items():
        if k in current and current[k]!=v: t.validation='REVIEW_REQUIRED'; t.reason='DEPENDENCY_CHANGED:'+k; return False
    if t.kind=='IMPORTED_CAM' and not all(k in t.deps for k in ('cam_package','cam_compat','calibration','gp_rev')):
        t.validation='REVIEW_REQUIRED'; t.reason='CAM_PROVENANCE_INCOMPLETE'; return False
    if not all(k in t.deps for k in ('calibration','gp_rev')):
        t.validation='REVIEW_REQUIRED'; t.reason='BASE_PROVENANCE_INCOMPLETE'; return False
    t.validation='ACCEPTED'; t.reason='NONE'; generation+=1; t.generation=generation; return True
rows=[]
def rec(p,a,g,t): rows.append({'phase':p,'action':a,'gp':asdict(g),'targetset':asdict(t)})

g=GP('GP1','R1',('X',))
t0=TS('TS0','GP1','DIRECT_MACHINE_COORDINATE','manual-v1',{'gp_rev':'R1','calibration':'C1'},{'X':100.0}); A=validate(t0,g) and t0.generation==1; rec('P0','direct_accept',g,t0)
t1=TS('TS1','GP1','CALCULATED','flange-x-demo-v1',{'gp_rev':'R1','calibration':'C1','tooling':'T1','bend_model':'B1'},{'X':95.0}); B=validate(t1,g) and t1.generation!=t0.generation and t1.deps['bend_model']=='B1'; rec('P1','calculated_accept',g,t1)
oldgen=t1.generation; current['calibration']='C2'; C=(not validate(t1,g) and t1.reason=='DEPENDENCY_CHANGED:calibration'); rec('P2','calibration_changed',g,t1)
# same number under new provenance stays noncurrent until explicit dependency rebind + validation
t2=TS('TS2','GP1','CALCULATED','flange-x-demo-v1',{'gp_rev':'R1','calibration':'C1','tooling':'T1','bend_model':'B1'},{'X':95.0},'REVIEW_REQUIRED','DEPENDENCY_CHANGED:calibration',oldgen); rec('P3','numeric_coincidence_stale',g,t2); D=(t2.targets==t1.targets and t2.validation=='REVIEW_REQUIRED' and t2.generation==oldgen); t2.deps['calibration']='C2'; ok=validate(t2,g); rec('P3','explicit_revalidate_same_number',g,t2); D=D and ok and t2.generation>oldgen
gbad=GP('GP1','R1',('X',),'REVIEW_REQUIRED'); t4=TS('TS4','GP1','DIRECT_MACHINE_COORDINATE','manual-v1',{'gp_rev':'R1','calibration':'C2'},{'X':100.0}); E=(not validate(t4,gbad) and t4.validation=='REVIEW_REQUIRED'); rec('P4','gp_invalid',gbad,t4)
gxr=GP('GP1','R1',('X','R')); t5=TS('TS5','GP1','DIRECT_MACHINE_COORDINATE','manual-v1',{'gp_rev':'R1','calibration':'C2'},{'X':100.0}); F=(not validate(t5,gxr) and t5.reason=='MECHANISM_COVERAGE_MISMATCH'); rec('P5','coverage_mismatch',gxr,t5)
t6bad=TS('TS6','GP1','IMPORTED_CAM','cam-import-v1',{'gp_rev':'R1','calibration':'C2','cam_package':'PK1'},{'X':91.0}); bad=not validate(t6bad,g) and t6bad.reason=='CAM_PROVENANCE_INCOMPLETE'; rec('P6','cam_missing_compat',g,t6bad)
t6=TS('TS6b','GP1','IMPORTED_CAM','cam-import-v1',{'gp_rev':'R1','calibration':'C2','cam_package':'PK1','cam_compat':'MC1'},{'X':91.0}); good=validate(t6,g); rec('P6','cam_current_accept',g,t6); G=bad and good
t7=TS('TS7','GP1','DIRECT_MACHINE_COORDINATE','manual-v1',{'gp_rev':'R1','calibration':'C2'},{'X':101.0}); H=validate(t7,g); rec('P7','direct_still_provenanced',g,t7)
gens=[r['targetset']['generation'] for r in rows if r['targetset']['validation']=='ACCEPTED']; I=(gens==sorted(gens) and len(set(gens))==len(gens) and all(x>0 for x in gens) and t2.generation>oldgen)
forbidden=['joint_command','posthome_cmd','limit3_input','machine_enable','tooling_choice','collision_result','hydraulic_command','safety_authorization']; blob=json.dumps(rows).lower(); present=[k for k in forbidden if f'"{k}"' in blob]; J=not present
GATES=dict(zip('ABCDEFGHIJ',[A,B,C,D,E,F,G,H,I,J])); summary={'contract':'PB-DXF-004','course_level':3600,'records':len(rows),'gates':GATES,'prediction_match':all(GATES.values()),'forbidden_output_keys_present':present,'boundary':'TargetSet provenance/generation only; numeric values opaque and not physically validated'}
os.makedirs('lab-results/pb-dxf-004',exist_ok=True); json.dump(rows,open('lab-results/pb-dxf-004/records.json','w'),indent=2); json.dump(summary,open('lab-results/pb-dxf-004/summary.json','w'),indent=2); print(json.dumps(summary,indent=2))
if not all(GATES.values()): raise SystemExit('Frozen gate failure')
PY
echo 'PB-DXF-004 PASS: TargetSet provenance/generation semantics only.'
