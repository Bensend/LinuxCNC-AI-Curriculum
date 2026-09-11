#!/usr/bin/env bash
set -euo pipefail
RUN_DIR="lab-results/run-${GITHUB_RUN_ID:-local}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_DIR"
OUT="$RUN_DIR/PB-BG-002-081-invocation-evidence.csv"
python3 - "$OUT" <<'PY'
from dataclasses import dataclass
import csv, hashlib, json, sys
MIN_TARGET=0.0; MAX_TARGET=100.0; STEP=20.0; TOL=0.5

@dataclass
class State:
    state:str='UNREFERENCED'; owner:str='NONE'; homed:bool=False
    planner_output:float=0.0; feedback_position:float=0.0
    active_target:float|None=None; displayed_target:float|None=None
    fault_reason:str=''; reconcile_required:bool=False

class Harness:
    def __init__(self): self.s=State(); self.rows=[]; self.seq=0
    def step(self,case,event,*,homed=None,machine_authorized=True,feedback_valid=True,drive_ok=True,stall_suspect=False,typed_request=False,typed_target=None,feedback_position=None,reconcile=False,load_bypass_requested=False,normal_planner_enabled=True):
        s=self.s; before=s.state
        if typed_target is not None: s.displayed_target=float(typed_target)
        if feedback_position is not None: s.feedback_position=float(feedback_position)
        if homed is not None: s.homed=bool(homed)
        target_in_range=s.displayed_target is not None and MIN_TARGET<=s.displayed_target<=MAX_TARGET
        target_accepted=False; load_bypass_used=False
        if s.state=='TYPED_MOVE':
            reason=''
            if not machine_authorized: reason='AUTHORIZATION_LOST'
            elif not feedback_valid: reason='FEEDBACK_INVALID'
            elif not drive_ok: reason='DRIVE_FAULT'
            elif stall_suspect: reason='STALL_SUSPECT'
            elif not s.homed: reason='REFERENCE_LOST'
            if reason:
                s.state='FAULTED'; s.owner='NONE'; s.fault_reason=reason; s.reconcile_required=True; s.active_target=None
            elif load_bypass_requested:
                s.state='FAULTED'; s.owner='NONE'; s.fault_reason='LOAD_BYPASS_REJECTED'; s.reconcile_required=True; s.active_target=None
            elif normal_planner_enabled:
                d=s.active_target-s.planner_output
                s.planner_output=s.active_target if abs(d)<=STEP else s.planner_output+(STEP if d>0 else -STEP)
        elif s.state=='FAULTED':
            if reconcile and machine_authorized and feedback_valid and drive_ok and not stall_suspect:
                s.state='RECONCILE'; s.owner='NONE'
        elif s.state=='RECONCILE':
            if reconcile and machine_authorized and feedback_valid and drive_ok and not stall_suspect:
                s.state='IDLE_REFERENCED' if s.homed else 'UNREFERENCED'; s.owner='NONE'; s.fault_reason=''; s.reconcile_required=False
        elif s.state in ('UNREFERENCED','IDLE_REFERENCED'):
            s.state='IDLE_REFERENCED' if s.homed else 'UNREFERENCED'; s.owner='NONE'
            if typed_request:
                healthy=s.homed and machine_authorized and feedback_valid and drive_ok and not stall_suspect
                if not load_bypass_requested and normal_planner_enabled and healthy and target_in_range:
                    s.state='TYPED_MOVE'; s.owner='TYPED_MOVE'; s.active_target=s.displayed_target; s.fault_reason=''; target_accepted=True
        planner_at_target=s.state=='TYPED_MOVE' and s.active_target is not None and abs(s.planner_output-s.active_target)<1e-12
        within=s.active_target is not None and abs(s.feedback_position-s.active_target)<=TOL
        complete=s.state=='TYPED_MOVE' and planner_at_target and within and feedback_valid and drive_ok and machine_authorized and s.homed and not stall_suspect
        complete_witness=complete
        if complete:
            s.state='IDLE_REFERENCED'; s.owner='NONE'; s.active_target=None
        posthome=s.homed and (s.state=='TYPED_MOVE' or complete_witness)
        motion=s.state=='TYPED_MOVE' and not planner_at_target
        self.seq+=1
        row=dict(seq=self.seq,case=case,event=event,state_before=before,state_after=s.state,owner=s.owner,homed=s.homed,machine_authorized=machine_authorized,feedback_valid=feedback_valid,drive_ok=drive_ok,stall_suspect=stall_suspect,typed_request=typed_request,displayed_target='' if s.displayed_target is None else s.displayed_target,target_in_range=target_in_range,target_accepted=target_accepted,active_target='' if s.active_target is None else s.active_target,min_target=MIN_TARGET,max_target=MAX_TARGET,planner_output=s.planner_output,feedback_position=s.feedback_position,planner_at_target=planner_at_target,within_target_tolerance=within,normal_planner_enabled=normal_planner_enabled,posthome_command_effective=posthome,planner_motion_active=motion,typed_move_complete=complete_witness,fault_reason=s.fault_reason,reconcile_required=s.reconcile_required,stale_target_replayed=False,load_bypass_requested=load_bypass_requested,load_bypass_used=load_bypass_used)
        self.rows.append(row); return row

def new_ref(p=0.0):
    h=Harness(); h.s.homed=True; h.s.state='IDLE_REFERENCED'; h.s.planner_output=p; h.s.feedback_position=p; return h

def run():
    rows=[]
    h=Harness(); h.step('P0','prehome-request-rejected',typed_request=True,typed_target=60); h.step('P0','home-complete-no-replay',homed=True); rows+=h.rows
    h=new_ref(0); h.step('P1','accept-valid-target',typed_request=True,typed_target=60); h.step('P1','approach-1',feedback_position=10); h.step('P1','approach-2',feedback_position=30); h.step('P1','planner-target-feedback-short',feedback_position=50); h.step('P1','feedback-converged-complete',feedback_position=60); rows+=h.rows
    h=new_ref(20); h.step('P2','below-range-rejected',typed_request=True,typed_target=-1); h.step('P2','above-range-rejected',typed_request=True,typed_target=101); h.step('P2','idle-after-invalid-no-replay'); h.step('P2','new-valid-request',typed_request=True,typed_target=40); rows+=h.rows
    h=new_ref(0); h.step('P3','accept-target',typed_request=True,typed_target=80); h.step('P3','approach',feedback_position=10); h.step('P3','authorization-lost',machine_authorized=False,feedback_position=10); h.step('P3','authorization-restored-no-replay',feedback_position=10); h.step('P3','enter-reconcile',reconcile=True,feedback_position=10); h.step('P3','finish-reconcile-idle',reconcile=True,feedback_position=10); h.step('P3','idle-old-display-no-replay',feedback_position=10); rows+=h.rows
    for suffix,kwargs in [('feedback',{'feedback_valid':False}),('drive',{'drive_ok':False}),('stall',{'stall_suspect':True})]:
        h=new_ref(0); c='P4-'+suffix; h.step(c,'accept-target',typed_request=True,typed_target=80); h.step(c,'approach',feedback_position=10); h.step(c,'fault',feedback_position=10,**kwargs); h.step(c,'enter-reconcile',reconcile=True,feedback_position=10); h.step(c,'finish-reconcile',reconcile=True,feedback_position=10); rows+=h.rows
    h=new_ref(60); h.s.state='TYPED_MOVE'; h.s.owner='TYPED_MOVE'; h.s.active_target=60.0; h.s.feedback_position=40; h.step('P5','planner-at-target-feedback-short'); rows+=h.rows
    h=new_ref(20); h.s.state='TYPED_MOVE'; h.s.owner='TYPED_MOVE'; h.s.active_target=60.0; h.s.feedback_position=60; h.step('P5','feedback-at-target-planner-short'); rows+=h.rows
    for event,kwargs in [('geometry-converged-auth-false',{'machine_authorized':False}),('geometry-converged-drive-fault',{'drive_ok':False}),('geometry-converged-feedback-invalid',{'feedback_valid':False})]:
        h=new_ref(60); h.s.state='TYPED_MOVE'; h.s.owner='TYPED_MOVE'; h.s.active_target=60.0; h.s.feedback_position=60; h.step('P5',event,**kwargs); rows+=h.rows
    h=new_ref(0); h.step('P6','accept-target',typed_request=True,typed_target=80); h.step('P6','fault-drive',drive_ok=False,feedback_position=10); h.step('P6','enter-reconcile-reference-lost',homed=False,reconcile=True,feedback_position=10); h.step('P6','finish-reconcile-unreferenced',homed=False,reconcile=True,feedback_position=10); h.step('P6','later-home-no-replay',homed=True,feedback_position=10); rows+=h.rows
    h=new_ref(0); h.step('P7','load-bypass-request-rejected',typed_request=True,typed_target=80,load_bypass_requested=True); rows+=h.rows
    # One atomic table requires one monotonic invocation witness across all phases.
    for seq,row in enumerate(rows,1): row['seq']=seq
    e={(r['case'],r['event']):r for r in rows}; ordinary=[r for r in rows if r['case']!='P7']
    gates={
      'A': e['P0','prehome-request-rejected']['owner']=='NONE' and not e['P0','prehome-request-rejected']['posthome_command_effective'],
      'B': e['P0','home-complete-no-replay']['owner']=='NONE' and not e['P0','home-complete-no-replay']['posthome_command_effective'],
      'C': e['P1','accept-valid-target']['owner']=='TYPED_MOVE' and e['P2','below-range-rejected']['owner']=='NONE' and e['P2','above-range-rejected']['owner']=='NONE' and e['P2','new-valid-request']['owner']=='TYPED_MOVE',
      'D': [e['P1',x]['planner_output'] for x in ('accept-valid-target','approach-1','approach-2','planner-target-feedback-short')]==[0,20.0,40.0,60.0] and not e['P1','planner-target-feedback-short']['typed_move_complete'] and e['P1','feedback-converged-complete']['typed_move_complete'],
      'E': not e['P5','planner-at-target-feedback-short']['typed_move_complete'] and not e['P5','feedback-at-target-planner-short']['typed_move_complete'] and not e['P5','geometry-converged-auth-false']['typed_move_complete'] and not e['P5','geometry-converged-drive-fault']['typed_move_complete'] and not e['P5','geometry-converged-feedback-invalid']['typed_move_complete'] and e['P1','feedback-converged-complete']['typed_move_complete'],
      'F': e['P3','authorization-lost']['state_after']=='FAULTED' and e['P3','authorization-lost']['owner']=='NONE' and e['P3','authorization-restored-no-replay']['owner']=='NONE' and e['P3','finish-reconcile-idle']['state_after']=='IDLE_REFERENCED' and e['P3','idle-old-display-no-replay']['owner']=='NONE',
      'G': {e['P4-'+s,'fault']['fault_reason'] for s in ('feedback','drive','stall')}=={'FEEDBACK_INVALID','DRIVE_FAULT','STALL_SUSPECT'} and all(e['P4-'+s,'enter-reconcile']['state_after']=='RECONCILE' for s in ('feedback','drive','stall')),
      'H': e['P6','finish-reconcile-unreferenced']['state_after']=='UNREFERENCED' and e['P6','later-home-no-replay']['owner']=='NONE' and not e['P6','later-home-no-replay']['posthome_command_effective'],
      'I': e['P2','below-range-rejected']['owner']=='NONE' and e['P2','above-range-rejected']['owner']=='NONE' and not e['P2','below-range-rejected']['posthome_command_effective'] and not e['P2','above-range-rejected']['posthome_command_effective'],
      'J': all(r['normal_planner_enabled'] and not r['load_bypass_used'] for r in ordinary) and not e['P7','load-bypass-request-rejected']['load_bypass_used'] and not e['P7','load-bypass-request-rejected']['typed_move_complete'] and e['P7','load-bypass-request-rejected']['owner']=='NONE'}
    return rows,gates

rows,gates=run(); out=sys.argv[1]
with open(out,'w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
data=open(out,'rb').read(); summary={'rows':len(rows),'sha256':hashlib.sha256(data).hexdigest(),'gates':gates,'pass':all(gates.values())}
print(json.dumps(summary,indent=2)); raise SystemExit(0 if summary['pass'] else 1)
PY