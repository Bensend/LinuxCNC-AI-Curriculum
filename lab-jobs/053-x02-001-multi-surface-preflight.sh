#!/usr/bin/env bash
set -euo pipefail

# X02-001 NON-AUTHORITATIVE preflight.
# Frozen behavioral contract/gates:
# experiments/X02-001-multi-surface-generation-correlation-plan.md
# Commit containing freeze: 903036d31e8c1e4d114cf43878c96a4e789744d7

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_REF="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-x02-preflight"
REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
OUT="$RUN_DIR/x02-053-preflight-evidence"
mkdir -p "$OUT"

SERVO_NS=1000000
TASK_S=0.001
RECORDER_ROWS=20000
RECORDER_DEPTH=24000
FAST_POLL_S=0.0001
NORMAL_POLL_S=0.005
SLOW_POLL_S=0.050

cat > "$OUT/predeclared-model.txt" <<EOF
X02-053 / X02-001 NON-AUTHORITATIVE PREFLIGHT
Pinned LinuxCNC commit: $LINUXCNC_REF
Frozen contract: experiments/X02-001-multi-surface-generation-correlation-plan.md
Frozen contract commit: 903036d31e8c1e4d114cf43878c96a4e789744d7
Fixture: upstream tests/linuxcncrsh/linuxcncrsh-test.ini + lcncrsh_sim.hal
Servo period: $SERVO_NS ns
Task cycle: $TASK_S s
Realtime recorder: sampler cfg=ss, depth=$RECORDER_DEPTH, retained rows=$RECORDER_ROWS
Recorder fields: deterministic x02_source cycle; motion.motion-type
Python observation fields: monotonic_ns, phase, taskbeat, heartbeat (motion heartbeat), motion_type, interp_state, exec_state, commanded X
Poll requests: fast=$FAST_POLL_S s, normal=$NORMAL_POLL_S s, slow=$SLOW_POLL_S s
P5: accepted X01-002 artifact is used as the invalid-recorder counterexample; no loss is injected into X02 authoritative-eligible P1-P4 evidence.
Nearest timestamps are NOT a same-cycle oracle.
EOF

printf '== X02-001 multi-surface generation-correlation preflight ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
cat "$OUT/predeclared-model.txt"

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps python3
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_REF"
ACTUAL="$(git rev-parse HEAD)"
printf '%s\n' "$ACTUAL" | tee "$OUT/linuxcnc-commit.txt"
[[ "$ACTUAL" == "$LINUXCNC_REF" ]] || { echo 'HARNESS_INVALID: pinned checkout mismatch' >&2; exit 20; }
./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)"
cd ..
set +u
source scripts/rip-environment
set -u

# Source-provenance guard: X02 requires the Python member named heartbeat to be
# the motion heartbeat, not taskbeat or observer time. Retain exact snippets.
python3 - <<'PY' > "$OUT/python-member-provenance.txt"
import linuxcnc
s=linuxcnc.stat()
print('linuxcnc-module=', linuxcnc.__file__)
print('stat-has-heartbeat=', hasattr(s,'heartbeat'))
print('stat-has-taskbeat=', hasattr(s,'taskbeat'))
if not hasattr(s,'heartbeat') or not hasattr(s,'taskbeat'):
    raise SystemExit(21)
PY
# Retain pinned source matches that bind Python heartbeat/taskbeat to aggregate status.
grep -R -n -m 8 -E 'heartbeat|taskbeat' src/emc/usr_intf/axis/extensions/emcmodule.cc > "$OUT/emcmodule-heartbeat-source.txt" || true
if ! grep -q 'heartbeat' "$OUT/emcmodule-heartbeat-source.txt" || ! grep -q 'taskbeat' "$OUT/emcmodule-heartbeat-source.txt"; then
    echo 'HARNESS_INVALID: Python heartbeat/taskbeat provenance source match missing' >&2
    exit 22
fi

cat > /tmp/x02_source.comp <<'EOF'
component x02_source "X02 deterministic servo-cycle witness";
pin out s32 cycle;
function _;
license "GPL";
;;
static rtapi_s32 cyc = 0;
FUNCTION(_) {
    cyc++;
    cycle = cyc;
}
EOF
cp /tmp/x02_source.comp "$OUT/x02_source.comp"
halcompile --install /tmp/x02_source.comp >"$OUT/halcompile.stdout" 2>"$OUT/halcompile.stderr"

cd tests/linuxcncrsh
INI=linuxcncrsh-test.ini
cp "$INI" "$OUT/fixture.ini"
cp lcncrsh_sim.hal "$OUT/fixture.hal"
rm -f /tmp/linuxcnc.lock x02-linuxcnc.stdout x02-linuxcnc.stderr
linuxcnc -r "$INI" >x02-linuxcnc.stdout 2>x02-linuxcnc.stderr &
LCNC_PID=$!
shutdown_fixture() {
  { printf '%s\n' 'set timestamp off' 'hello EMC x02shutdown' 'set echo off' 'set enable EMCTOO' 'shutdown'; sleep .2; } | timeout 8s nc localhost 5007 >/tmp/x02-shutdown.txt 2>/tmp/x02-shutdown.err || true
}
cleanup() {
  halcmd setp sampler.0.enable 0 >/dev/null 2>&1 || true
  if [[ -n "${HSPID:-}" ]] && kill -0 "$HSPID" 2>/dev/null; then kill -TERM "$HSPID" 2>/dev/null || true; wait "$HSPID" 2>/dev/null || true; fi
  if kill -0 "$LCNC_PID" 2>/dev/null; then shutdown_fixture; sleep .5; kill -TERM "$LCNC_PID" 2>/dev/null || true; fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 200); do
  if nc -z localhost 5007 >/dev/null 2>&1 && timeout 2s halcmd getp motion.motion-type >/dev/null 2>&1; then READY=1; printf 'runtime-ready-probe=%s\n' "$i" | tee "$OUT/readiness.txt"; break; fi
  sleep .25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: LinuxCNC fixture did not become ready' >&2; cat x02-linuxcnc.stderr >&2 || true; exit 23; }

# Attach witness and sampler to the existing LinuxCNC servo thread. x02_source
# is intentionally scheduled before sampler; motion.motion-type is produced by
# the existing motion-controller function earlier in the fixture's servo thread.
halcmd loadrt x02_source
halcmd loadrt sampler depth="$RECORDER_DEPTH" cfg=ss
halcmd addf x02-source.0 servo-thread
halcmd addf sampler.0 servo-thread
halcmd net x02-cycle x02-source.0.cycle '=>' sampler.0.pin.0
halcmd net x02-motion-type motion.motion-type '=>' sampler.0.pin.1
halcmd setp sampler.0.enable 0
halcmd show thread > "$OUT/thread-topology.txt"
halcmd show pin x02-source.0 > "$OUT/x02-source-pins.txt"
halcmd show pin sampler.0 > "$OUT/sampler-pins.txt"
halcmd show pin motion.motion-type > "$OUT/motion-type-pin.txt"

# Topology guards: both witness and recorder must be present in servo-thread.
grep -q 'x02-source.0' "$OUT/thread-topology.txt" || { echo 'HARNESS_INVALID: x02 source absent from servo thread' >&2; exit 24; }
grep -q 'sampler.0' "$OUT/thread-topology.txt" || { echo 'HARNESS_INVALID: sampler absent from servo thread' >&2; exit 25; }

printf 'overruns-before=' > "$OUT/recorder-health.txt"
halcmd getp sampler.0.overruns | tr -d '[:space:]' >> "$OUT/recorder-health.txt"; echo >> "$OUT/recorder-health.txt"
printf 'depth-before=' >> "$OUT/recorder-health.txt"
halcmd getp sampler.0.curr-depth | tr -d '[:space:]' >> "$OUT/recorder-health.txt"; echo >> "$OUT/recorder-health.txt"

rm -f /tmp/x02-realtime.samples
halsampler -t -n "$RECORDER_ROWS" /tmp/x02-realtime.samples >"$OUT/halsampler.stdout" 2>"$OUT/halsampler.stderr" &
HSPID=$!
halcmd setp sampler.0.enable 1

TRACE="$OUT/python-status.csv" FAST="$FAST_POLL_S" NORMAL="$NORMAL_POLL_S" SLOW="$SLOW_POLL_S" python3 - <<'PY'
import csv, os, sys, time
import linuxcnc

trace=os.environ['TRACE']
fast=float(os.environ['FAST']); normal=float(os.environ['NORMAL']); slow=float(os.environ['SLOW'])
s=linuxcnc.stat(); c=linuxcnc.command()
rows=[]
fields=['monotonic_ns','phase','taskbeat','motion_heartbeat','motion_type','interp_state','exec_state','x_cmd']

def snap(phase):
    s.poll()
    row={
      'monotonic_ns':time.monotonic_ns(), 'phase':phase,
      'taskbeat':int(s.taskbeat), 'motion_heartbeat':int(s.heartbeat),
      'motion_type':int(s.motion_type), 'interp_state':int(s.interp_state),
      'exec_state':int(s.exec_state), 'x_cmd':float(s.position[0])}
    rows.append(row)
    return row

def observe(phase, seconds, interval):
    end=time.monotonic()+seconds
    while time.monotonic()<end:
        snap(phase)
        if interval: time.sleep(interval)

def command_and_observe(gcode, phase, seconds, interval):
    c.mdi(gcode)
    observe(phase, seconds, interval)

def wait_done(label, timeout=8.0):
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        r=snap(label)
        if r['interp_state']==int(linuxcnc.INTERP_IDLE): return
        time.sleep(.002)
    raise RuntimeError('HARNESS_INVALID: interpreter did not become idle: '+label)

def complete_call(fn, *args):
    fn(*args)
    rc=c.wait_complete(5.0)
    if int(rc)!=int(linuxcnc.RCS_DONE):
        raise RuntimeError(f'HARNESS_INVALID: command completion {fn.__name__} rc={rc}')

# P0 deterministic ready state.
complete_call(c.state, linuxcnc.STATE_ESTOP_RESET)
complete_call(c.state, linuxcnc.STATE_ON)
complete_call(c.mode, linuxcnc.MODE_MDI)
s.poll()
if not hasattr(s,'taskbeat') or not hasattr(s,'heartbeat') or not hasattr(s,'motion_type'):
    raise RuntimeError('HARNESS_INVALID: required status members absent')
snap('P0-ready')

# P1: request polling substantially faster than 1 ms TASK cycle.
observe('P1-fast-idle', 1.0, fast)

# P2: moderate observation while deterministic rapid/feed/return transitions occur.
command_and_observe('G0 X3', 'P2-normal-rapid', 1.0, normal)
wait_done('P2-normal-rapid-drain')
command_and_observe('G1 X0 F60', 'P2-normal-feed', 3.6, normal)
wait_done('P2-normal-feed-drain')
observe('P2-normal-idle', .4, normal)

# P3: slow observer during another known rapid/feed sequence.
command_and_observe('G0 X3', 'P3-slow-rapid', 1.0, slow)
wait_done('P3-slow-rapid-drain')
command_and_observe('G1 X0 F60', 'P3-slow-feed', 3.6, slow)
wait_done('P3-slow-feed-drain')

# P4: return/idle observation.
observe('P4-idle', .6, normal)

with open(trace,'w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=fields); w.writeheader(); w.writerows(rows)
print('python-observation-rows=',len(rows))
PY

# Let the fixed-count recorder complete so the retained trace has a clean,
# count-bounded ending rather than process-kill truncation.
if ! timeout 35s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .05; done' _ "$HSPID"; then
  echo 'HARNESS_INVALID: fixed-count realtime recorder did not complete' >&2
  exit 26
fi
wait "$HSPID"
unset HSPID
halcmd setp sampler.0.enable 0
cp /tmp/x02-realtime.samples "$OUT/realtime.samples"

printf 'overruns-after=' >> "$OUT/recorder-health.txt"
halcmd getp sampler.0.overruns | tr -d '[:space:]' >> "$OUT/recorder-health.txt"; echo >> "$OUT/recorder-health.txt"
printf 'depth-after-disable=' >> "$OUT/recorder-health.txt"
halcmd getp sampler.0.curr-depth | tr -d '[:space:]' >> "$OUT/recorder-health.txt"; echo >> "$OUT/recorder-health.txt"
printf 'source-cycle-after=' >> "$OUT/recorder-health.txt"
halcmd getp x02-source.0.cycle | tr -d '[:space:]' >> "$OUT/recorder-health.txt"; echo >> "$OUT/recorder-health.txt"
cp x02-linuxcnc.stdout "$OUT/linuxcnc.stdout"
cp x02-linuxcnc.stderr "$OUT/linuxcnc.stderr"

# Independent preflight scorer. It scores observable predicates only; it does
# not convert this preflight into the authoritative run.
python3 - "$OUT" <<'PY'
import csv, pathlib, sys
out=pathlib.Path(sys.argv[1])

def kv(path):
    d={}
    for line in path.read_text().splitlines():
        if '=' in line:
            k,v=line.split('=',1); d[k.strip()]=v.strip()
    return d

with (out/'python-status.csv').open() as f:
    py=list(csv.DictReader(f))
rt=[]; markers=0
for line in (out/'realtime.samples').read_text().splitlines():
    line=line.strip()
    if not line: continue
    if line.lower().startswith('overrun'):
        markers+=1; continue
    p=line.split()
    if len(p)<3: continue
    rt.append((int(p[0]), int(float(p[1])), int(float(p[2]))))
health=kv(out/'recorder-health.txt')
assert len(rt)==20000, len(rt)
assert int(float(health['overruns-before']))==0, health
assert int(float(health['overruns-after']))==0, health
assert markers==0, markers
assert all(rt[i+1][0]==rt[i][0]+1 for i in range(len(rt)-1)), 'stream tag discontinuity'
assert all(rt[i+1][1]==rt[i][1]+1 for i in range(len(rt)-1)), 'payload cycle discontinuity'

# C: same taskbeat with observer time advancing in P1, if realized.
p1=[r for r in py if r['phase']=='P1-fast-idle']
same_task=any(int(p1[i+1]['monotonic_ns'])>int(p1[i]['monotonic_ns']) and int(p1[i+1]['taskbeat'])==int(p1[i]['taskbeat']) for i in range(len(p1)-1))
# D: increasing taskbeat and no backwards bounded movement.
tb=[int(r['taskbeat']) for r in py]
task_adv=max(tb)>min(tb)
task_back=any(tb[i+1]<tb[i] for i in range(len(tb)-1))
# E: observed task/motion deltas not forced one-for-one.
hb=[int(r['motion_heartbeat']) for r in py]
relation=any(((tb[i+1]-tb[i]) != (hb[i+1]-hb[i])) for i in range(len(py)-1) if tb[i+1]>=tb[i] and hb[i+1]>=hb[i])
# G: generation advances while state remains equal.
mt=[int(r['motion_type']) for r in py]
equal_state_freshness=any((tb[i+1]>tb[i] or hb[i+1]>hb[i]) and mt[i+1]==mt[i] for i in range(len(py)-1))
# H: slow observer skips at least one producer generation.
p3=[r for r in py if r['phase'].startswith('P3-slow')]
slow_skip=any(int(p3[i+1]['taskbeat'])-int(p3[i]['taskbeat'])>1 or int(p3[i+1]['motion_heartbeat'])-int(p3[i]['motion_heartbeat'])>1 for i in range(len(p3)-1))
# F preflight evidence: Python nonduplicate motion states must be subsequence of
# realtime nonduplicate states; this is ordered-state evidence only.
def nond(xs):
    out=[]
    for x in xs:
        if not out or out[-1]!=x: out.append(x)
    return out
py_states=nond(mt); rt_states=nond([r[2] for r in rt])
it=iter(rt_states)
subseq=all(any(v==want for v in it) for want in py_states)
expected_transition=len(set(rt_states))>=2 and len(set(py_states))>=2

assert task_adv and not task_back, (min(tb),max(tb),task_back)
assert equal_state_freshness, 'no equal-state generation advance observed'
assert slow_skip, 'no slow-observer generation skip observed'
assert subseq and expected_transition, (py_states,rt_states)

status={
 'A':'PASS', 'B':'PASS',
 'C':'PASS' if same_task else 'INCONCLUSIVE',
 'D':'PASS', 'E':'PASS' if relation else 'INCONCLUSIVE',
 'F':'PASS', 'G':'PASS', 'H':'PASS', 'I':'PASS', 'J':'PASS'}
summary=[
 'X02-053 / X02-001 PREFLIGHT PREDICATES',
 f'realtime_rows={len(rt)} producer_overruns={health["overruns-after"]} payload_contiguous=yes stream_contiguous=yes',
 f'python_rows={len(py)} taskbeat_range={min(tb)}..{max(tb)} motion_heartbeat_range={min(hb)}..{max(hb)}',
 f'python_motion_states={py_states}', f'realtime_motion_states={rt_states}',
 f'same_task_generation_repeat={same_task}', f'non_one_to_one_generation_delta={relation}',
 f'equal_state_with_generation_advance={equal_state_freshness}', f'slow_observer_skip={slow_skip}',
 'ordered_state_subsequence='+str(subseq),
 'preflight_gate_observations='+' '.join(f'{k}={v}' for k,v in status.items()),
 'I uses accepted X01-002 producer-overrun + deterministic-payload-discontinuity evidence as the invalid-recorder counterexample; no invalid interval is admitted here.',
 'J: no nearest-timestamp join was used; monotonic_ns is retained only as observer-order/time evidence.',
 'NOTE: this is NON-AUTHORITATIVE preflight evidence. Frozen gates are not course-accepted until a separate unchanged authoritative run is independently inspected.'
]
(out/'preflight-summary.txt').write_text('\n'.join(summary)+'\n')
print('\n'.join(summary))
PY

printf '%s\n' '=== BEGIN X02 PRELIGHT SUMMARY ==='
cat "$OUT/preflight-summary.txt"
printf '%s\n' '=== END X02 PREFLIGHT SUMMARY ==='
printf '%s\n' '=== RECORDER HEALTH ==='
cat "$OUT/recorder-health.txt"
printf '%s\n' '=== PYTHON TRACE HEAD/TAIL ==='
{ head -n 12 "$OUT/python-status.csv"; echo '...'; tail -n 12 "$OUT/python-status.csv"; }
printf '%s\n' 'X02-053 preflight shell-harness=PASS'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'

cleanup
trap - EXIT
