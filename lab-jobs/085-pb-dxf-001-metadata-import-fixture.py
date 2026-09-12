#!/usr/bin/env python3
import hashlib, json

TOL=1e-6

def q(v): return round(float(v)/TOL)*TOL

def fp(e):
    a=(q(e['p1'][0]),q(e['p1'][1])); b=(q(e['p2'][0]),q(e['p2'][1]))
    lo,hi=sorted((a,b))
    return f"LINE:{lo[0]:.6f},{lo[1]:.6f}:{hi[0]:.6f},{hi[1]:.6f}"

def cid(rev,e):
    # order-independent within one import revision; locator is provenance, not identity.
    s=f"{rev}|{fp(e)}|{e.get('semantic','UNKNOWN')}|{e.get('stable_uuid','')}"
    return hashlib.sha256(s.encode()).hexdigest()[:16]

def import_doc(name,rev,entities,sidecar_rev=None):
    cuts=[]; bends=[]; diags=[]
    groups={}
    for e in entities:
        if e.get('semantic')=='CUT': cuts.append({'locator':e['locator'],'fingerprint':fp(e)}); continue
        if e.get('semantic')!='BEND': continue
        stale=bool(e.get('stable_uuid')) and sidecar_rev != rev
        if stale: diags.append({'code':'STALE_SIDECAR','locator':e['locator']})
        sem_ok=not stale
        r={'candidate_id':cid(rev,e),'locator':e['locator'],'fingerprint':fp(e),
           'angle':e.get('angle','UNKNOWN') if sem_ok else 'UNKNOWN',
           'radius':e.get('radius','UNKNOWN') if sem_ok else 'UNKNOWN',
           'direction':e.get('direction','UNKNOWN') if sem_ok else 'UNKNOWN',
           'stable_uuid':e.get('stable_uuid') if sem_ok else None}
        bends.append(r); groups.setdefault(r['fingerprint'],[]).append(r)
    for k,v in groups.items():
        if len(v)>1: diags.append({'code':'COINCIDENT_CANDIDATES','fingerprint':k,'locators':sorted(x['locator'] for x in v)})
    bends.sort(key=lambda x:(x['candidate_id'],x['locator']))
    return {'name':name,'revision':rev,'cuts':cuts,'bends':bends,'diagnostics':diags}

def line(locator,x1,y1,x2,y2,semantic='BEND',**kw):
    return dict(locator=locator,p1=[x1,y1],p2=[x2,y2],semantic=semantic,**kw)

p0=[line('c1',0,0,10,0,'CUT'),line('b1',0,2,10,2),line('b2',0,4,10,4)]
r0=import_doc('part','R1',p0)
r1=import_doc('part','R1',[line('b1x',0,2,10,2),line('b1y',10,2,0,2)])
r2=import_doc('part','R1',[line('b2a',0,5,4,5),line('b2b',6,5,10,5)])
r3=import_doc('part','R1',[line('u1',0,7,10,7)])
r4=import_doc('part','R1',list(reversed(p0)))
r5=import_doc('part','R2',p0)
r6=import_doc('part','R2',[line('c1',0,0,10,0,'CUT'),line('b1',0,2.1,10,2.1),line('b2',0,4,10,4)])
r7=import_doc('part','R2',[line('s1',0,2,10,2,stable_uuid='BEND-A',angle=90,radius=1,direction='UP')],sidecar_rev='R1')
r8=import_doc('part','R2',[line('s1',0,2,10,2,stable_uuid='BEND-A',angle=90,radius=1,direction='UP')],sidecar_rev='R2')

checks={
'A':len(r0['bends'])==2 and len(r0['cuts'])==1,
'B':any(d['code']=='COINCIDENT_CANDIDATES' for d in r1['diagnostics']) and len(r1['bends'])==2,
'C':len(r2['bends'])==2 and not any(d['code']=='COINCIDENT_CANDIDATES' for d in r2['diagnostics']),
'D':all(r3['bends'][0][k]=='UNKNOWN' for k in ('angle','radius','direction')),
'E':[(x['candidate_id'],x['fingerprint']) for x in r0['bends']]==[(x['candidate_id'],x['fingerprint']) for x in r4['bends']],
'F':set(x['candidate_id'] for x in r0['bends']).isdisjoint(x['candidate_id'] for x in r5['bends']),
'G':fp(p0[1])!=r6['bends'][0]['fingerprint'] or fp(p0[1])!=r6['bends'][1]['fingerprint'],
'H':any(d['code']=='STALE_SIDECAR' for d in r7['diagnostics']) and r7['bends'][0]['stable_uuid'] is None and r7['bends'][0]['angle']=='UNKNOWN',
'I':r8['bends'][0]['stable_uuid']=='BEND-A' and r8['bends'][0]['angle']==90,
'J':not any(k in json.dumps([r0,r1,r2,r3,r4,r5,r6,r7,r8]).lower() for k in ('gauge_target','axis_command','tooling_choice','bend_order','machine_motion')),
}
print(json.dumps({'gates':checks,'pass':all(checks.values()),'evidence':{'P0':r0,'P1':r1,'P2':r2,'P3':r3,'P4':r4,'P5':r5,'P6':r6,'P7':r7,'P8':r8}},indent=2,sort_keys=True))
raise SystemExit(0 if all(checks.values()) else 1)
