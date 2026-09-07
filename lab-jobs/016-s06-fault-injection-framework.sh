#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
CURRICULUM="$PWD"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-s06-fi"
TRACE="$CURRICULUM/lab-results/S06-016.trace.txt"
RESULT="$CURRICULUM/lab-results/S06-016.result.json"

printf '== LinuxCNC S06-016 deterministic fault-injection framework lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen prediction: freeze => age+eventual value detector; one-cycle jump => value-only detector; one-cycle skew => age-only detector; recovery clears both.'
printf '%s\n' 'Evidence boundary: software HAL fixture only; no physical sensor, transport, HostMot2, FPGA, or safety-integrity claim.'

mkdir -p "$CURRICULUM/lab-results"
sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)"
sudo make setcap
cd ..
set +u
source scripts/rip-environment
set -u
export LINUXCNC_FORCE_REALTIME=1

cat >/tmp/s06fi.comp <<'EOF'
component s06fi "Deterministic test-only source/fault scheduler for curriculum S06";
pin out float cycle;
pin out float healthy;
pin out float published;
pin out float healthy_seq;
pin out float published_seq;
pin out s32 mode;
variable int cycle_count = 0;
variable double held_value = 0.0;
variable double held_seq = 0.0;
variable double previous_healthy = 0.0;
function _;
license "GPL";
;;
cycle_count += 1;
cycle = (double)cycle_count;
healthy = ((double)cycle_count) * 0.01;
healthy_seq = (double)cycle_count;
mode = 0;
published = healthy;
published_seq = healthy_seq;

if (cycle_count >= 50 && cycle_count <= 79) {
    if (cycle_count == 50) {
        held_value = previous_healthy;
        held_seq = (double)(cycle_count - 1);
    }
    mode = 1;
    published = held_value;
    published_seq = held_seq;
} else if (cycle_count == 100) {
    mode = 2;
    published = healthy + 5.0;
    published_seq = healthy_seq;
} else if (cycle_count >= 130 && cycle_count <= 139) {
    mode = 3;
    published = previous_healthy;
    published_seq = (double)(cycle_count - 1);
}

previous_healthy = healthy;
EOF

halcompile --install /tmp/s06fi.comp

cat >/tmp/s06-framework.hal <<'EOF'
loadrt threads name1=servo period1=10000000 fp1=1
loadrt s06fi count=1
loadrt sum2 count=2
loadrt abs count=2
loadrt comp count=2
loadrt sampler depth=512 cfg=fffffsffbb

addf s06fi.0 servo
addf sum2.0 servo
addf abs.0 servo
addf comp.0 servo
addf sum2.1 servo
addf abs.1 servo
addf comp.1 servo
addf sampler.0 servo

setp sum2.0.gain0 -1.0
setp sum2.0.gain1 1.0
setp sum2.1.gain0 -1.0
setp sum2.1.gain1 1.0
setp comp.0.in0 0.05
setp comp.0.hyst 0.0
setp comp.1.in0 0.5
setp comp.1.hyst 0.0

net fi-cycle s06fi.0.cycle => sampler.0.pin.0
net fi-healthy s06fi.0.healthy => sum2.0.in0 sampler.0.pin.1
net fi-published s06fi.0.published => sum2.0.in1 sampler.0.pin.2
net fi-hseq s06fi.0.healthy-seq => sum2.1.in0 sampler.0.pin.3
net fi-pseq s06fi.0.published-seq => sum2.1.in1 sampler.0.pin.4
net fi-mode s06fi.0.mode => sampler.0.pin.5
net fi-vdelta sum2.0.out => abs.0.in
net fi-vabs abs.0.out => comp.0.in1 sampler.0.pin.6
net fi-adelta sum2.1.out => abs.1.in
net fi-aabs abs.1.out => comp.1.in1 sampler.0.pin.7
net fi-vfault comp.0.out => sampler.0.pin.8
net fi-afault comp.1.out => sampler.0.pin.9
EOF

rm -f /tmp/s06-hal.stdout /tmp/s06-hal.stderr /tmp/s06-hal.stdin "$TRACE" "$RESULT"
mkfifo /tmp/s06-hal.stdin
exec 9<>/tmp/s06-hal.stdin
halrun -I -f /tmp/s06-framework.hal <&9 >/tmp/s06-hal.stdout 2>/tmp/s06-hal.stderr &
HALRUN_PID=$!
cleanup() {
    trap - EXIT
    printf 'stop\n' >&9 2>/dev/null || true
    exec 9>&- || true
    kill -TERM "$HALRUN_PID" 2>/dev/null || true
    wait "$HALRUN_PID" 2>/dev/null || true
    rm -f /tmp/s06-hal.stdin
}
trap cleanup EXIT

READY=0
for i in $(seq 1 100); do
    if timeout 3s halcmd show thread >/tmp/s06-thread.txt 2>/tmp/s06-probe.err \
       && grep -q 's06fi.0' /tmp/s06-thread.txt \
       && grep -q 'sampler.0' /tmp/s06-thread.txt; then
        READY=1; printf 'HAL ready at probe %s\n' "$i"; break
    fi
    sleep 0.1
done
if [[ "$READY" != 1 ]]; then
    echo 'HARNESS INVALID: HAL topology did not become ready.' >&2
    cat /tmp/s06-hal.stdout >&2 || true
    cat /tmp/s06-hal.stderr >&2 || true
    exit 60
fi
cat /tmp/s06-thread.txt

printf '\n== Gate A: verify realtime function order before execution ==\n'
python3 - /tmp/s06-thread.txt <<'PY'
import sys
s=open(sys.argv[1]).read()
names=['s06fi.0','sum2.0','abs.0','comp.0','sum2.1','abs.1','comp.1','sampler.0']
pos=[]
for n in names:
    p=s.find(n)
    if p < 0:
        raise SystemExit(f'missing function {n}')
    pos.append(p)
if pos != sorted(pos):
    raise SystemExit(f'wrong function order {list(zip(names,pos))}')
print('gate-A-thread-order=PASS', list(zip(names,pos)))
PY

printf '\n== Start realtime drain before starting the thread ==\n'
halsampler -c 0 -n 170 >"$TRACE" &
SAMPLER_PID=$!
sleep 0.1
printf 'start\n' >&9
if ! timeout 12s tail --pid="$SAMPLER_PID" -f /dev/null; then
    echo 'HARNESS INVALID: halsampler did not complete 170 rows.' >&2
    exit 61
fi
wait "$SAMPLER_PID"
OVERRUNS="$(timeout 3s halcmd getp sampler.0.overruns | tr -d '[:space:]')"
printf 'stop\n' >&9
printf 'sampler-overruns=%s trace-lines=%s\n' "$OVERRUNS" "$(wc -l <"$TRACE")"

set +e
python3 - "$TRACE" "$RESULT" "$OVERRUNS" "$LINUXCNC_COMMIT" <<'PY'
import json, math, sys
trace_path, result_path, overruns_s, commit = sys.argv[1:5]

def b(tok):
    return tok.upper() in ('TRUE','1')
rows=[]
try:
    for raw in open(trace_path):
        parts=raw.split()
        if not parts: continue
        if len(parts) != 10:
            raise ValueError(f'expected 10 columns, got {len(parts)}: {raw!r}')
        c,h,p,hs,ps = map(float, parts[:5])
        mode=int(parts[5])
        va=float(parts[6]); aa=float(parts[7]); vf=b(parts[8]); af=b(parts[9])
        rows.append(dict(c=int(round(c)),h=h,p=p,hs=hs,ps=ps,mode=mode,va=va,aa=aa,vf=vf,af=af))
except Exception as e:
    result={'schema_version':'linuxcnc-ai-fi-v1','module':'S06','experiment':'S06-016','linuxcnc_commit':commit,'overall':'HARNESS_INVALID','exit_code':63,'reason':f'trace parse failure: {e}'}
    open(result_path,'w').write(json.dumps(result,indent=2,sort_keys=True)+'\n')
    print(json.dumps(result,indent=2,sort_keys=True)); raise SystemExit(63)
by={r['c']:r for r in rows}
required=set(range(1,171))
missing=sorted(required-set(by))
try: overruns=int(overruns_s)
except: overruns=-1
capture_ok=(overruns==0 and not missing and len(rows)==170)
result={
 'schema_version':'linuxcnc-ai-fi-v1','module':'S06','experiment':'S06-016','linuxcnc_commit':commit,
 'attempt_family':'s06-016-deterministic-rt-source-v1','thread_order_verified':True,
 'capture_health':{'sampler_overruns':overruns,'trace_rows':len(rows),'trace_complete_for_required_windows':not missing},
 'cases':[],
 'invalid_oracle_example':{'proposition':'fixture mode indicates fault, therefore injection and downstream response are proven','valid':False,'reason':'mode is fixture self-report; accepted evidence uses raw healthy/published values+sequence and independent stock observer outputs'},
 'non_claims':['physical sensor fault coverage','HostMot2/FPGA fault coverage','Ethernet/packet-loss behavior','physical-machine timing','PL/SIL/category/diagnostic-coverage/safe-stop validation']
}
if not capture_ok:
    result.update(overall='HARNESS_INVALID',exit_code=64,reason=f'capture unhealthy; missing={missing[:20]}')
    open(result_path,'w').write(json.dumps(result,indent=2,sort_keys=True)+'\n'); print(json.dumps(result,indent=2,sort_keys=True)); raise SystemExit(64)

inj_fail=[]; beh_fail=[]
def close(a,b,t=1e-6): return abs(a-b)<=t

def addcase(cid, inj, resp, rec, obs):
    result['cases'].append({'id':cid,'injection_evidence':{'pass':inj},'response_evidence':{'pass':resp},'recovery_evidence':{'pass':rec},'observations':obs})
    if not inj: inj_fail.append(cid)
    if not resp or not rec: beh_fail.append(cid)

healthy=all(close(by[c]['h'],by[c]['p']) and close(by[c]['hs'],by[c]['ps']) and not by[c]['vf'] and not by[c]['af'] for c in range(10,40))
addcase('healthy-baseline',healthy,healthy,True,['cycles 10-39 publication matches reference and detectors clear'])

freeze_inj=(len({round(by[c]['ps'],6) for c in range(50,80)})==1 and all(by[c]['hs']>by[50]['hs'] for c in range(51,80)))
freeze_resp=(all(by[c]['af'] for c in range(56,80)) and any(by[c]['vf'] for c in range(56,80)))
freeze_rec=all(close(by[c]['h'],by[c]['p']) and close(by[c]['hs'],by[c]['ps']) and not by[c]['vf'] and not by[c]['af'] for c in range(80,90))
addcase('freeze',freeze_inj,freeze_resp,freeze_rec,[f"published_seq_50={by[50]['ps']}",f"published_seq_79={by[79]['ps']}",f"age_abs_79={by[79]['aa']}"])

jump_inj=(close(by[100]['p']-by[100]['h'],5.0) and close(by[100]['ps'],by[100]['hs']) and close(by[99]['p'],by[99]['h']) and close(by[101]['p'],by[101]['h']))
jump_resp=(by[100]['vf'] and not by[100]['af'] and not by[99]['vf'] and not by[99]['af'] and not by[101]['vf'] and not by[101]['af'])
jump_rec=(close(by[101]['p'],by[101]['h']) and not by[101]['vf'] and not by[101]['af'])
addcase('single-cycle-jump',jump_inj,jump_resp,jump_rec,[f"cycle100_delta={by[100]['p']-by[100]['h']}",f"cycle100_age={by[100]['aa']}"])

skew_inj=all(close(by[c]['hs']-by[c]['ps'],1.0) and close(by[c]['h']-by[c]['p'],0.01,1e-5) for c in range(130,140))
skew_resp=all((not by[c]['vf']) and by[c]['af'] for c in range(130,140))
skew_rec=all(close(by[c]['h'],by[c]['p']) and close(by[c]['hs'],by[c]['ps']) and not by[c]['vf'] and not by[c]['af'] for c in range(140,150))
addcase('one-cycle-age-skew',skew_inj,skew_resp,skew_rec,[f"cycle130_value_abs={by[130]['va']}",f"cycle130_age_abs={by[130]['aa']}"])

result['recovery']={'freeze':freeze_rec,'jump':jump_rec,'skew':skew_rec}
if inj_fail:
    result.update(overall='HARNESS_INVALID',exit_code=65,reason='intended injection absent: '+','.join(inj_fail))
elif beh_fail or not healthy:
    result.update(overall='BEHAVIOR_FAIL',exit_code=20,reason='behavior/recovery mismatch: '+','.join(beh_fail))
else:
    result.update(overall='PASS',exit_code=0,reason='all frozen Gates A-J passed')
open(result_path,'w').write(json.dumps(result,indent=2,sort_keys=True)+'\n')
print('\n== Machine-readable result ==')
print(json.dumps(result,indent=2,sort_keys=True))
raise SystemExit(result['exit_code'])
PY
STATUS=$?
set -e

printf '\n== Trace excerpts ==\n'
awk 'NR>=45 && NR<=85 {print}' "$TRACE"
awk 'NR>=95 && NR<=105 {print}' "$TRACE"
awk 'NR>=125 && NR<=145 {print}' "$TRACE"
printf '\n== S06-016 result file ==\n'
cat "$RESULT"
printf '\nlab-classifier-exit=%s\n' "$STATUS"
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
exit "$STATUS"
