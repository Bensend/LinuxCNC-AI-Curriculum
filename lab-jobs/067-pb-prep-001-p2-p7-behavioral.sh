#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 FIRST FROZEN P2-P7 BEHAVIORAL EXECUTION.
# Do not retune after seeing this result. HARNESS_INVALID and INCONCLUSIVE are
# legitimate outcomes under the frozen contracts.

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_REF="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-pb-prep-001-p2p7"
REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
OUT="$RUN_DIR/pb-prep-001-p2-p7-evidence"
mkdir -p "$OUT"

SERVO_NS=1000000
ROWS=12000
DEPTH=20000
U_MAX=2.0
SYNC_GAIN=1.0
DIFF_MAX=0.25
PGAIN=6.0

cat > "$OUT/predeclared-model.txt" <<EOF
PB-PREP-001 FIRST FROZEN P2-P7 BEHAVIORAL EXECUTION
Pinned LinuxCNC: $LINUXCNC_REF
Contracts:
  experiments/PB-PREP-001-y1y2-insertion-comparison-plan.md
  experiments/PB-PREP-001-behavioral-execution-freeze.md
  experiments/PB-PREP-001-P2-P7-runner-implementation-contract.md
  experiments/PB-PREP-001-P2-P7-observability-clarification.md
Servo period: $SERVO_NS ns
Rows/architecture: $ROWS; FIFO depth: $DEPTH
A/B stock P gain: $PGAIN; C common P gain: $PGAIN
SYNC_GAIN=$SYNC_GAIN; DIFF_MAX=$DIFF_MAX; U_MAX=$U_MAX
Plant: y_next = y + alpha * ((gain * final) - y)
A side fixed: gain=1.0 alpha=0.05
B side by phase: P2 1.0/0.05, P3 0.75/0.05, P4 1.0/0.025, P5 1.0/0.05, P6 0.20/0.05, P7 inherited P6 state until run=false.
Trajectory: duplicated Y move 0 -> 0.5 at F30 during P2.
Instrumentation-only appended fields 27..29: joint1 f-error-lim, joint3 f-error-lim, realtime run witness.
No physical hydraulic suitability or functional-safety conclusion is permitted.
EOF
cat "$OUT/predeclared-model.txt"

date -u '+UTC lab start: %Y-%m-%dT%H:%M:%SZ' | tee "$OUT/lab-time.txt"

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
for b in linuxcnc halsampler halcompile halcmd; do
  p="$(command -v "$b")"
  printf '%s-bin=%s\n' "$b" "$p" | tee -a "$OUT/binary-provenance.txt"
  case "$(readlink -f "$p")" in "$WORK"/*) ;; *) echo "HARNESS_INVALID: $b not from pinned tree" >&2; exit 21;; esac
done

cat > /tmp/pb_prep.comp <<'EOF'
component pb_prep "PB-PREP-001 frozen P2-P7 two-side software fixture";
pin in float r1; pin in float r2;
pin in float pid1_out; pin in float pid2_out;
pin out float pid1_ref; pin out float pid2_ref;
pin out float y1; pin out float y2;
pin out float e_diff_used;
pin out float corr_req; pin out float corr_applied;
pin out float prelimit1; pin out float prelimit2;
pin out float final1; pin out float final2;
pin out bit final1_sat; pin out bit final2_sat;
pin out float plant_gain2; pin out float plant_alpha2;
pin out bit run_witness;
pin out s32 cycle;
pin out s32 phase;
param rw u32 architecture = 0;
param rw u32 phase_cmd = 2;
param rw bit run = 0;
param rw float sync_gain = 1.0;
param rw float diff_max = 0.25;
param rw float u_max = 2.0;
param rw float c_pgain = 6.0;
function prepare;
function finish;
license "GPL";
;;
static int initialized = 0;
static double absd(double v) { return v < 0.0 ? -v : v; }
static double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }
FUNCTION(prepare) {
    double ed;
    if (!initialized) { y1 = 0.0; y2 = 0.0; initialized = 1; }
    phase = phase_cmd;
    run_witness = run;
    plant_gain2 = 1.0; plant_alpha2 = 0.05;
    if (phase_cmd == 3) { plant_gain2 = 0.75; }
    else if (phase_cmd == 4) { plant_alpha2 = 0.025; }
    else if (phase_cmd == 6 || phase_cmd == 7) { plant_gain2 = 0.20; }
    ed = y1 - y2;
    e_diff_used = ed;
    corr_req = sync_gain * ed;
    corr_applied = clip(corr_req, diff_max);
    if (architecture == 0) {
        pid1_ref = r1 - corr_applied;
        pid2_ref = r2 + corr_applied;
    } else {
        pid1_ref = r1;
        pid2_ref = r2;
    }
}
FUNCTION(finish) {
    double common = 0.0;
    if (!run) {
        prelimit1 = prelimit2 = 0.0;
        final1 = final2 = 0.0;
        final1_sat = final2_sat = 0;
        cycle++;
        return;
    }
    if (architecture == 0) {
        prelimit1 = pid1_out;
        prelimit2 = pid2_out;
    } else if (architecture == 1) {
        prelimit1 = pid1_out - corr_applied;
        prelimit2 = pid2_out + corr_applied;
    } else {
        common = c_pgain * (((r1 - y1) + (r2 - y2)) * 0.5);
        prelimit1 = common - corr_applied;
        prelimit2 = common + corr_applied;
    }
    final1_sat = absd(prelimit1) > u_max;
    final2_sat = absd(prelimit2) > u_max;
    final1 = clip(prelimit1, u_max);
    final2 = clip(prelimit2, u_max);
    y1 += 0.05 * ((1.0 * final1) - y1);
    y2 += plant_alpha2 * ((plant_gain2 * final2) - y2);
    cycle++;
}
EOF
cp /tmp/pb_prep.comp "$OUT/pb_prep.comp"
halcompile --install /tmp/pb_prep.comp >"$OUT/halcompile.stdout" 2>"$OUT/halcompile.stderr"

FIX="$WORK/pb-prep-p2p7-fixture"
mkdir -p "$FIX"
cd "$FIX"
cat > pb-prep.ini <<'EOF'
[EMC]
MACHINE=PB-PREP-001-P2P7
VERSION=1.1
DEBUG=0
[DISPLAY]
DISPLAY=linuxcncrsh -n PBPREP001
[TASK]
TASK=milltask
CYCLE_TIME=0.001
[RS274NGC]
PARAMETER_FILE=pb.var
[EMCMOT]
EMCMOT=motmod
COMM_TIMEOUT=4.0
BASE_PERIOD=0
SERVO_PERIOD=1000000
[EMCIO]
TOOL_TABLE=tool.tbl
[HAL]
HALFILE=pb-prep.hal
[TRAJ]
SPINDLES=1
COORDINATES=XYZY
LINEAR_UNITS=inch
ANGULAR_UNITS=degree
DEFAULT_LINEAR_VELOCITY=0.5
MAX_LINEAR_VELOCITY=2.0
NO_FORCE_HOMING=0
[KINS]
JOINTS=4
KINEMATICS=trivkins coordinates=XYZY kinstype=BOTH
[AXIS_X]
MIN_LIMIT=-5
MAX_LIMIT=5
MAX_VELOCITY=2
MAX_ACCELERATION=10
[AXIS_Y]
MIN_LIMIT=-5
MAX_LIMIT=5
MAX_VELOCITY=2
MAX_ACCELERATION=10
[AXIS_Z]
MIN_LIMIT=-5
MAX_LIMIT=5
MAX_VELOCITY=2
MAX_ACCELERATION=10
EOF
for j in 0 1 2 3; do cat >> pb-prep.ini <<EOF
[JOINT_$j]
TYPE=LINEAR
MIN_LIMIT=-5
MAX_LIMIT=5
MAX_VELOCITY=2
MAX_ACCELERATION=10
FERROR=5
MIN_FERROR=1
HOME=0
HOME_OFFSET=0
HOME_SEARCH_VEL=0
HOME_LATCH_VEL=0
HOME_SEQUENCE=$j
EOF
done
touch tool.tbl pb.var
cp pb-prep.ini "$OUT/fixture.ini"

# sampler schema: first frozen 26 fields + ferror limits + realtime run witness.
SAMPLER_CFG="ssfffffffffffbbffffbbffbffffb"
printf '%s\n' "$SAMPLER_CFG" > "$OUT/sampler-schema-cfg.txt"
cat > "$OUT/sampler-schema.txt" <<'EOF'
0 cycle s32
1 phase s32
2 r1 float
3 r2 float
4 y1 float
5 y2 float
6 e_diff_used float
7 corr_req float
8 corr_applied float
9 pid1_ref float
10 pid2_ref float
11 pid1_out float
12 pid2_out float
13 pid1_saturated bit
14 pid2_saturated bit
15 prelimit1 float
16 prelimit2 float
17 final1 float
18 final2 float
19 final1_sat bit
20 final2_sat bit
21 joint1_ferror float
22 joint3_ferror float
23 motion_enabled bit
24 plant_gain2 float
25 plant_alpha2 float
26 joint1_ferror_lim float
27 joint3_ferror_lim float
28 run_witness bit
EOF

run_arch() {
  local ARCH="$1" CODE="$2"
  local AOUT="$OUT/arch-$ARCH"
  mkdir -p "$AOUT"
  cat > pb-prep.hal <<EOF
loadrt [KINS]KINEMATICS
loadrt [EMCMOT]EMCMOT base_period_nsec=[EMCMOT]BASE_PERIOD servo_period_nsec=[EMCMOT]SERVO_PERIOD num_joints=[KINS]JOINTS num_spindles=[TRAJ]SPINDLES
loadrt pid names=pb-pid1,pb-pid2
loadrt pb_prep
loadrt sampler depth=$DEPTH cfg=$SAMPLER_CFG
setp pb-prep.0.architecture $CODE
setp pb-prep.0.phase-cmd 2
setp pb-prep.0.run false
setp pb-prep.0.sync-gain $SYNC_GAIN
setp pb-prep.0.diff-max $DIFF_MAX
setp pb-prep.0.u-max $U_MAX
setp pb-prep.0.c-pgain $PGAIN
setp pb-pid1.Pgain $PGAIN
setp pb-pid2.Pgain $PGAIN
setp pb-pid1.Igain 0
setp pb-pid2.Igain 0
setp pb-pid1.Dgain 0
setp pb-pid2.Dgain 0
setp pb-pid1.maxoutput $U_MAX
setp pb-pid2.maxoutput $U_MAX
setp pb-pid1.enable true
setp pb-pid2.enable true
addf motion-command-handler servo-thread
addf motion-controller servo-thread
addf pb-prep.0.prepare servo-thread
addf pb-pid1.do-pid-calcs servo-thread
addf pb-pid2.do-pid-calcs servo-thread
addf pb-prep.0.finish servo-thread
addf sampler.0 servo-thread
net x0 joint.0.motor-pos-cmd => joint.0.motor-pos-fb
net z2 joint.2.motor-pos-cmd => joint.2.motor-pos-fb
net y1cmd joint.1.motor-pos-cmd => pb-prep.0.r1
net y2cmd joint.3.motor-pos-cmd => pb-prep.0.r2
net y1fb pb-prep.0.y1 => joint.1.motor-pos-fb pb-pid1.feedback
net y2fb pb-prep.0.y2 => joint.3.motor-pos-fb pb-pid2.feedback
net ref1 pb-prep.0.pid1-ref => pb-pid1.command
net ref2 pb-prep.0.pid2-ref => pb-pid2.command
net pid1out pb-pid1.output => pb-prep.0.pid1-out
net pid2out pb-pid2.output => pb-prep.0.pid2-out
net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in
net tool-prep-loop iocontrol.0.tool-prepare iocontrol.0.tool-prepared
net tool-change-loop iocontrol.0.tool-change iocontrol.0.tool-changed
net cyc pb-prep.0.cycle => sampler.0.pin.0
net ph pb-prep.0.phase => sampler.0.pin.1
net sr1 y1cmd => sampler.0.pin.2
net sr2 y2cmd => sampler.0.pin.3
net sy1 y1fb => sampler.0.pin.4
net sy2 y2fb => sampler.0.pin.5
net sed pb-prep.0.e-diff-used => sampler.0.pin.6
net screq pb-prep.0.corr-req => sampler.0.pin.7
net scap pb-prep.0.corr-applied => sampler.0.pin.8
net sref1 ref1 => sampler.0.pin.9
net sref2 ref2 => sampler.0.pin.10
net spid1 pid1out => sampler.0.pin.11
net spid2 pid2out => sampler.0.pin.12
net spidsat1 pb-pid1.saturated => sampler.0.pin.13
net spidsat2 pb-pid2.saturated => sampler.0.pin.14
net spre1 pb-prep.0.prelimit1 => sampler.0.pin.15
net spre2 pb-prep.0.prelimit2 => sampler.0.pin.16
net sfinal1 pb-prep.0.final1 => sampler.0.pin.17
net sfinal2 pb-prep.0.final2 => sampler.0.pin.18
net sfsat1 pb-prep.0.final1-sat => sampler.0.pin.19
net sfsat2 pb-prep.0.final2-sat => sampler.0.pin.20
net sjf1 joint.1.f-error => sampler.0.pin.21
net sjf3 joint.3.f-error => sampler.0.pin.22
net smen motion.motion-enabled => sampler.0.pin.23
net sg2 pb-prep.0.plant-gain2 => sampler.0.pin.24
net sa2 pb-prep.0.plant-alpha2 => sampler.0.pin.25
net sjfl1 joint.1.f-error-lim => sampler.0.pin.26
net sjfl3 joint.3.f-error-lim => sampler.0.pin.27
net srun pb-prep.0.run-witness => sampler.0.pin.28
setp sampler.0.enable false
EOF
  cp pb-prep.hal "$AOUT/fixture.hal"
  printf 'architecture=%s code=%s\n' "$ARCH" "$CODE" > "$AOUT/identity.txt"
  sha256sum pb-prep.ini pb-prep.hal /tmp/pb_prep.comp > "$AOUT/provenance-sha256.txt"

  rm -f /tmp/linuxcnc.lock "$AOUT/realtime.samples"
  linuxcnc -r pb-prep.ini >"$AOUT/linuxcnc.stdout" 2>"$AOUT/linuxcnc.stderr" &
  local LPID=$!
  local ready=0 HSPID=""
  cleanup_arch() {
    if [[ -n "$HSPID" ]]; then kill "$HSPID" 2>/dev/null || true; fi
    kill "$LPID" 2>/dev/null || true
    wait "$LPID" 2>/dev/null || true
    rm -f /tmp/linuxcnc.lock
  }
  trap cleanup_arch RETURN

  for i in $(seq 1 200); do
    if nc -z localhost 5007 >/dev/null 2>&1 && halcmd getp pb-prep.0.y1 >/dev/null 2>&1 && halcmd getp joint.1.f-error-lim >/dev/null 2>&1 && halcmd getp sampler.0.curr-depth >/dev/null 2>&1; then ready=1; echo "ready-probe=$i" > "$AOUT/readiness.txt"; break; fi
    sleep .25
  done
  [[ "$ready" == 1 ]] || { cat "$AOUT/linuxcnc.stderr" >&2 || true; echo "HARNESS_INVALID: $ARCH runtime not ready" >&2; exit 30; }

  halcmd show thread > "$AOUT/thread-topology.txt"
  halcmd show pin pb-prep.0 > "$AOUT/pb-pins.txt"
  halcmd show pin joint.1 > "$AOUT/joint1-pins.txt"
  halcmd show pin joint.3 > "$AOUT/joint3-pins.txt"
  halcmd show sig > "$AOUT/signals.txt"
  grep -q 'pb-prep.0.prepare' "$AOUT/thread-topology.txt" || { echo "HARNESS_INVALID: $ARCH prepare missing" >&2; exit 31; }
  grep -q 'pb-prep.0.finish' "$AOUT/thread-topology.txt" || { echo "HARNESS_INVALID: $ARCH finish missing" >&2; exit 32; }
  grep -q 'sampler.0' "$AOUT/thread-topology.txt" || { echo "HARNESS_INVALID: $ARCH sampler missing" >&2; exit 33; }
  grep -q 'joint.1.motor-pos-fb' "$AOUT/joint1-pins.txt" || { echo "HARNESS_INVALID: $ARCH joint1 feedback witness missing" >&2; exit 34; }
  grep -q 'joint.3.motor-pos-fb' "$AOUT/joint3-pins.txt" || { echo "HARNESS_INVALID: $ARCH joint3 feedback witness missing" >&2; exit 35; }
  [[ "$(halcmd getp sampler.0.curr-depth | tr -d '[:space:]')" == 0 ]] || { echo "HARNESS_INVALID: $ARCH nonzero FIFO before enable" >&2; exit 36; }
  halcmd getp sampler.0.overruns | tr -d '[:space:]' > "$AOUT/overruns-before.txt"

  python3 - "$ARCH" "$AOUT" <<'PY' &
import linuxcnc, time, subprocess, sys
arch,aout=sys.argv[1:]
c=linuxcnc.command(); s=linuxcnc.stat()
def poll_until(label,pred,timeout=20.0):
    t=time.monotonic()+timeout
    while time.monotonic()<t:
        s.poll()
        if pred():
            open(aout+'/control-events.txt','a').write(label+'=PASS\n'); return
        time.sleep(.01)
    raise SystemExit('HARNESS_INVALID: timeout '+label)
def hp(name,val): subprocess.run(['halcmd','setp','pb-prep.0.'+name,str(val)],check=True)
c.state(linuxcnc.STATE_ESTOP_RESET); time.sleep(.05)
c.state(linuxcnc.STATE_ON); poll_until('machine-on',lambda: s.task_state==linuxcnc.STATE_ON)
c.mode(linuxcnc.MODE_MANUAL); poll_until('manual',lambda: s.task_mode==linuxcnc.MODE_MANUAL)
c.home(-1); poll_until('homed',lambda: all(bool(s.homed[j]) for j in range(4)),30)
c.mode(linuxcnc.MODE_MDI); poll_until('mdi',lambda: s.task_mode==linuxcnc.MODE_MDI)
# Sampling is enabled by parent shell only after homing and before this sentinel.
open(aout+'/controller-ready','w').write('ready\n')
while not __import__('os').path.exists(aout+'/sampling-enabled'):
    time.sleep(.005)
hp('phase-cmd',2); hp('run','true')
c.mdi('G1 Y0.5 F30'); c.wait_complete()
time.sleep(1.05)
hp('phase-cmd',3); time.sleep(1.55)
hp('phase-cmd',4); time.sleep(1.55)
hp('phase-cmd',5); time.sleep(2.05)
hp('phase-cmd',6); time.sleep(2.05)
hp('phase-cmd',7); time.sleep(.05)
hp('run','false'); time.sleep(.15)
open(aout+'/controller-done','w').write('done\n')
PY
  local CPID=$!
  for i in $(seq 1 400); do [[ -f "$AOUT/controller-ready" ]] && break; sleep .05; done
  [[ -f "$AOUT/controller-ready" ]] || { echo "HARNESS_INVALID: $ARCH controller never became ready" >&2; exit 37; }

  halsampler -t -n "$ROWS" "$AOUT/realtime.samples" >"$AOUT/halsampler.stdout" 2>"$AOUT/halsampler.stderr" & HSPID=$!
  sleep .1
  kill -0 "$HSPID" 2>/dev/null || { cat "$AOUT/halsampler.stderr" >&2 || true; echo "HARNESS_INVALID: $ARCH halsampler exited before enable" >&2; exit 38; }
  halcmd setp sampler.0.enable true
  : > "$AOUT/sampling-enabled"

  wait "$CPID"
  wait "$HSPID"
  HSPID=""
  halcmd getp sampler.0.overruns | tr -d '[:space:]' > "$AOUT/overruns-after.txt"
  halcmd setp sampler.0.enable false
  wc -l "$AOUT/realtime.samples" | tee "$AOUT/sample-count.txt"
  cleanup_arch
  trap - RETURN
}

run_arch A 0
run_arch B 1
run_arch C 2

cat > /tmp/analyze_pb.py <<'PY'
from pathlib import Path
import math, json, statistics, sys
root=Path(sys.argv[1])
ARCHES=('A','B','C')

def clip(v,m): return max(-m,min(m,v))
def b(v): return int(v)
def load(arch):
    p=root/f'arch-{arch}'/'realtime.samples'
    rows=[]
    for ln,n in enumerate(p.read_text().splitlines(),1):
        q=ln.split()
        if len(q)!=30: raise SystemExit(f'HARNESS_INVALID: {arch} line {n} fields={len(q)} expected=30')
        r={
          'stream':int(q[0]),'cycle':int(q[1]),'phase':int(q[2]),
          'r1':float(q[3]),'r2':float(q[4]),'y1':float(q[5]),'y2':float(q[6]),
          'ed':float(q[7]),'creq':float(q[8]),'cap':float(q[9]),
          'ref1':float(q[10]),'ref2':float(q[11]),'pid1':float(q[12]),'pid2':float(q[13]),
          'ps1':b(q[14]),'ps2':b(q[15]),'pre1':float(q[16]),'pre2':float(q[17]),
          'fin1':float(q[18]),'fin2':float(q[19]),'fs1':b(q[20]),'fs2':b(q[21]),
          'jf1':float(q[22]),'jf3':float(q[23]),'men':b(q[24]),
          'g2':float(q[25]),'a2':float(q[26]),'jlim1':float(q[27]),'jlim3':float(q[28]),'run':b(q[29])}
        rows.append(r)
    return rows

def assert_close(x,y,tol,msg):
    if abs(x-y)>tol: raise SystemExit('HARNESS_INVALID: '+msg+f' got {x} expected {y}')

def expected_plant(ph):
    if ph==3:return .75,.05
    if ph==4:return 1.0,.025
    if ph in (6,7):return .20,.05
    return 1.0,.05

def metrics(rows,ph):
    s=[r for r in rows if r['phase']==ph and r['run']]
    if not s:return {'samples':0}
    ed=[r['y1']-r['y2'] for r in s]
    ec=[(r['r1']+r['r2'])/2-(r['y1']+r['y2'])/2 for r in s]
    out={'samples':len(s),'peak_abs_ediff':max(map(abs,ed)),'rms_ediff':math.sqrt(sum(x*x for x in ed)/len(ed)),
         'peak_abs_ecommon':max(map(abs,ec)),'peak_abs_j1_ferror':max(abs(r['jf1']) for r in s),
         'peak_abs_j3_ferror':max(abs(r['jf3']) for r in s),'pid1_sat_ms':sum(r['ps1'] for r in s),
         'pid2_sat_ms':sum(r['ps2'] for r in s),'final1_sat_ms':sum(r['fs1'] for r in s),'final2_sat_ms':sum(r['fs2'] for r in s),
         'corr_clip_ms':sum(abs(r['creq'])>.25+1e-12 for r in s)}
    if ph in (2,3,4) and len(s)>=750:
        z=s[-500:]; ze=[r['y1']-r['y2'] for r in z]; zc=[(r['r1']+r['r2'])/2-(r['y1']+r['y2'])/2 for r in z]
        out.update(steady_mean_abs_ediff=sum(map(abs,ze))/500,steady_max_abs_ediff=max(map(abs,ze)),
                   steady_mean_abs_ecommon=sum(map(abs,zc))/500,steady_max_abs_ecommon=max(map(abs,zc)))
    return out

allrows={a:load(a) for a in ARCHES}
notes=[]; report={'architectures':{},'gates':{}}
for a,rows in allrows.items():
    if len(rows)!=12000: raise SystemExit(f'HARNESS_INVALID: {a} row count {len(rows)} != 12000')
    before=int((root/f'arch-{a}'/'overruns-before.txt').read_text()); after=int((root/f'arch-{a}'/'overruns-after.txt').read_text())
    if before or after: raise SystemExit(f'HARNESS_INVALID: {a} overruns before/after={before}/{after}')
    cyc=[r['cycle'] for r in rows]
    if any(y!=x+1 for x,y in zip(cyc,cyc[1:])): raise SystemExit(f'HARNESS_INVALID: {a} deterministic cycle gap')
    phases=[r['phase'] for r in rows]
    seen=[]
    for x in phases:
        if not seen or x!=seen[-1]: seen.append(x)
    if seen[:6] != [2,3,4,5,6,7]: raise SystemExit(f'HARNESS_INVALID: {a} phase order starts {seen[:8]}')
    p2=[r for r in rows if r['phase']==2 and r['run']]
    if not p2: raise SystemExit(f'HARNESS_INVALID: {a} missing active P2')
    if abs(p2[0]['y1'])>1e-9 or abs(p2[0]['y2'])>1e-9: raise SystemExit(f'HARNESS_INVALID: {a} P2 not clean reset y={p2[0]["y1"]},{p2[0]["y2"]}')
    for r in rows:
        g,al=expected_plant(r['phase']); assert_close(r['g2'],g,1e-12,f'{a} gain2 phase {r["phase"]}'); assert_close(r['a2'],al,1e-12,f'{a} alpha2 phase {r["phase"]}')
        assert_close(r['creq'],r['ed'],2e-6,f'{a} corr_req/e_diff cycle {r["cycle"]}')
        if abs(r['cap'])>.25+1e-12: raise SystemExit(f'HARNESS_INVALID: {a} corr_applied bound')
        assert_close(r['fin1'],clip(r['pre1'],2.0),1e-12,f'{a} final1 clip cycle {r["cycle"]}')
        assert_close(r['fin2'],clip(r['pre2'],2.0),1e-12,f'{a} final2 clip cycle {r["cycle"]}')
        if r['fs1'] != int(abs(r['pre1'])>2.0) or r['fs2'] != int(abs(r['pre2'])>2.0): raise SystemExit(f'HARNESS_INVALID: {a} final saturation oracle cycle {r["cycle"]}')
        if r['jlim1']<=0 or r['jlim3']<=0: raise SystemExit(f'HARNESS_INVALID: {a} nonpositive ferror limit')
    active=[r for r in rows if r['run'] and r['phase'] in (2,3,4,5,6)]
    if max(abs(r['r1']-r['r2']) for r in active)>1e-9: raise SystemExit(f'HARNESS_INVALID: {a} duplicated Y requests diverged')
    if max(r['r1'] for r in p2)-min(r['r1'] for r in p2)<0.10: raise SystemExit(f'HARNESS_INVALID: {a} P2 command range not nontrivial')
    # P7 first disabled-cycle oracle.
    first0=None
    for i,r in enumerate(rows):
        if r['phase']==7 and r['run']==0 and i>0 and rows[i-1]['run']==1:
            first0=i; break
    if first0 is None: raise SystemExit(f'HARNESS_INVALID: {a} no sampled P7 run true->false transition')
    r=rows[first0]
    if abs(r['fin1'])>1e-12 or abs(r['fin2'])>1e-12 or r['fs1'] or r['fs2']: raise SystemExit(f'BEHAVIORAL_FAILURE: {a} first disabled P7 cycle nonzero/saturated')
    if sum(1 for x in rows[first0:] if x['phase']==7 and x['run']==0)<2: raise SystemExit(f'HARNESS_INVALID: {a} fewer than two completed disabled P7 rows')
    am={'phases':{str(ph):metrics(rows,ph) for ph in range(2,7)},'p7_first_disabled_cycle':r['cycle']}
    # P5 first 100ms continuous recovery band.
    p5=[x for x in rows if x['phase']==5 and x['run']]
    rec='NOT OBSERVED'
    for i in range(0,max(0,len(p5)-99)):
        w=p5[i:i+100]
        if all(abs(x['y1']-x['y2'])<=.005 and abs((x['r1']+x['r2'])/2-(x['y1']+x['y2'])/2)<=.01 for x in w): rec=w[0]['cycle']-p5[0]['cycle']; break
    am['p5_recovery_ms']=rec
    report['architectures'][a]=am

# Gate H discriminators.
A=[r for r in allrows['A'] if r['run'] and abs(r['cap'])>1e-6 and r['phase'] in (3,4,6)]
if not A: raise SystemExit('HARNESS_INVALID: A never produced nonzero differential correction')
aex=max(A,key=lambda r:abs(r['cap']))
report['A_reference_bias_witness']={k:aex[k] for k in ('cycle','phase','r1','y1','jf1','cap','ref1')}
B6=[r for r in allrows['B'] if r['phase']==6 and r['run']]
bw=[r for r in B6 if ((not r['ps1'] and r['fs1']) or (not r['ps2'] and r['fs2']))]
report['B_downstream_only_saturation_count']=len(bw)
if bw: report['B_downstream_only_saturation_witness']={k:bw[0][k] for k in ('cycle','pid1','pid2','ps1','ps2','pre1','pre2','fs1','fs2','cap')}
C=[r for r in allrows['C'] if r['run'] and r['phase'] in (3,4,6) and abs(r['creq'])>1e-6]
if not C: raise SystemExit('HARNESS_INVALID: C requested differential effort never observed')
cex=max(C,key=lambda r:abs(r['creq']))
report['C_common_differential_observability_witness']={k:cex[k] for k in ('cycle','phase','creq','cap','pre1','pre2','fin1','fin2','fs1','fs2')}

report['gates']={
 'A':'PASS - pinned source/provenance retained by shell',
 'B':'PASS - independent Y1/Y2 feedback sampled and HAL joint feedback topology retained',
 'C':'PASS - duplicated Y requests equal within 1e-9 and P2 range nontrivial',
 'D':'PASS - 12000 rows/architecture, zero producer overruns, contiguous deterministic cycle',
 'E':'PASS - B gain/alpha phase witnesses equal frozen values; A-side/controller constants fixed in retained source',
 'F':'PASS - stock PID and downstream prelimit/final/saturation sampled separately',
 'G':'PASS - joint1/joint3 ferror and effective limits sampled atomically',
 'H':('PASS - A/B/C discriminators observed, including downstream-only B/P6 saturation' if bw else 'INCONCLUSIVE - B/P6 downstream-only saturation discriminator NOT OBSERVED'),
 'I':'PASS - P5 metrics retained and first sampled P7 disabled command is zero/unsaturated',
 'J':'PASS - retained contract/result boundary forbids physical hydraulic or functional-safety inference'}
report['classification']='VALID COMPARISON' if bw else 'INCONCLUSIVE'
(root/'analysis.json').write_text(json.dumps(report,indent=2,sort_keys=True)+'\n')
with (root/'analysis.txt').open('w') as f:
    f.write('PB-PREP-001 frozen P2-P7 analysis\n')
    for g,v in report['gates'].items(): f.write(f'Gate {g}: {v}\n')
    f.write('Classification: '+report['classification']+'\n')
    f.write('B downstream-only saturation rows: '+str(len(bw))+'\n')
    if bw: f.write('B witness: '+json.dumps(report['B_downstream_only_saturation_witness'],sort_keys=True)+'\n')
    f.write('A reference-bias witness: '+json.dumps(report['A_reference_bias_witness'],sort_keys=True)+'\n')
    f.write('C allocation witness: '+json.dumps(report['C_common_differential_observability_witness'],sort_keys=True)+'\n')
print((root/'analysis.txt').read_text())
PY
cp /tmp/analyze_pb.py "$OUT/analyze_pb.py"
python3 /tmp/analyze_pb.py "$OUT"

date -u '+UTC lab finish: %Y-%m-%dT%H:%M:%SZ' | tee -a "$OUT/lab-time.txt"
printf 'PB-PREP-001 behavioral execution complete. Frozen result classification is in %s/analysis.txt\n' "$OUT"
