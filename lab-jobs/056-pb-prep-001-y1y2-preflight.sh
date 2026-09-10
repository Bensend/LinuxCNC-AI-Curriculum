#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 NON-AUTHORITATIVE PREFLIGHT ONLY.
# Frozen contract: experiments/PB-PREP-001-y1y2-insertion-comparison-plan.md
# This run may validate P0/P1 and retention, but MUST NOT be used to rank A/B/C
# or recommend any physical press-brake control architecture.

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_REF="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-pb-prep-001"
REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
OUT="$RUN_DIR/pb-prep-001-preflight-evidence"
mkdir -p "$OUT"

SERVO_NS=1000000
ROWS=2500
DEPTH=5000
U_MAX=2.0
SYNC_GAIN=2.0
DIFF_MAX=0.25
PLANT_ALPHA=0.05
INITIAL_DELTA=0.02

printf '== PB-PREP-001 Y1/Y2 insertion architecture preflight ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
cat > "$OUT/predeclared-model.txt" <<EOF
PB-PREP-001 NON-AUTHORITATIVE P0/P1 PREFLIGHT
Pinned LinuxCNC: $LINUXCNC_REF
Frozen contract: experiments/PB-PREP-001-y1y2-insertion-comparison-plan.md
Servo period: $SERVO_NS ns
Architectures: A=pre-PID reference bias; B=post-PID effort correction; C=explicit two-channel P controller
Common synthetic plant equation, once per servo cycle after controller output:
  y_next = y + PLANT_ALPHA * ((gain * u_final) - y)
PLANT_ALPHA=$PLANT_ALPHA; gain1=gain2=1.0; dimensionless software-only model
U_MAX=$U_MAX; SYNC_GAIN=$SYNC_GAIN; DIFF_MAX=$DIFF_MAX
P1 sign seed: y1-y2 starts at +$INITIAL_DELTA with otherwise identical plant parameters.
Positive e_diff=y1-y2 therefore requires side-1 reduction and side-2 increase.
Recorder: sampler depth=$DEPTH, requested rows=$ROWS, atomic same-thread payload with deterministic component cycle.
No P2-P7 comparative scoring in this run.
No physical hydraulic suitability or functional-safety claim may be derived from this fixture.
EOF
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
for b in linuxcnc halsampler halcompile; do
  p="$(command -v "$b")"; printf '%s-bin=%s\n' "$b" "$p" | tee -a "$OUT/binary-provenance.txt"
  case "$(readlink -f "$p")" in "$WORK"/*) ;; *) echo "HARNESS_INVALID: $b not from pinned tree" >&2; exit 21;; esac
done

# One component owns the shared plant and the architecture-specific insertion
# points. prepare() runs before stock PID; finish() runs after stock PID and
# performs the one shared final limiter + one shared plant update.
cat > /tmp/pb_prep.comp <<'EOF'
component pb_prep "PB-PREP-001 generic two-side software preflight fixture";
pin in float r1; pin in float r2;
pin in float pid1_out; pin in float pid2_out;
pin out float pid1_ref; pin out float pid2_ref;
pin out float y1; pin out float y2;
pin out float corr_req; pin out float corr_applied;
pin out float final1; pin out float final2;
pin out bit final1_sat; pin out bit final2_sat;
pin out s32 cycle;
pin out s32 phase;
param rw u32 architecture = 0;
param rw bit run = 0;
param rw float sync_gain = 2.0;
param rw float diff_max = 0.25;
param rw float u_max = 2.0;
param rw float plant_alpha = 0.05;
param rw float plant_gain1 = 1.0;
param rw float plant_gain2 = 1.0;
param rw float initial_delta = 0.02;
param rw float c_pgain = 6.0;
function prepare;
function finish;
license "GPL";
;;
#include <math.h>
static int initialized = 0;
static double clip(double v, double m) { return v > m ? m : (v < -m ? -m : v); }
FUNCTION(prepare) {
    double ed, c;
    if (!initialized) { y1 = initial_delta; y2 = 0.0; initialized = 1; }
    ed = y1 - y2;
    corr_req = sync_gain * ed;
    c = clip(corr_req, diff_max);
    corr_applied = c;
    if (architecture == 0) { pid1_ref = r1 - c; pid2_ref = r2 + c; }
    else { pid1_ref = r1; pid2_ref = r2; }
}
FUNCTION(finish) {
    double c = corr_applied, u1 = 0.0, u2 = 0.0, common;
    if (!run) {
        final1 = final2 = 0.0; final1_sat = final2_sat = 0; phase = 0; cycle++;
        return;
    }
    phase = 1;
    if (architecture == 0) { u1 = pid1_out; u2 = pid2_out; }
    else if (architecture == 1) { u1 = pid1_out - c; u2 = pid2_out + c; }
    else {
        common = c_pgain * (((r1 - y1) + (r2 - y2)) * 0.5);
        u1 = common - c; u2 = common + c;
    }
    final1_sat = fabs(u1) > u_max; final2_sat = fabs(u2) > u_max;
    final1 = clip(u1, u_max); final2 = clip(u2, u_max);
    y1 += plant_alpha * ((plant_gain1 * final1) - y1);
    y2 += plant_alpha * ((plant_gain2 * final2) - y2);
    cycle++;
}
EOF
cp /tmp/pb_prep.comp "$OUT/pb_prep.comp"
halcompile --install /tmp/pb_prep.comp >"$OUT/halcompile.stdout" 2>"$OUT/halcompile.stderr"

FIX="$WORK/pb-prep-fixture"
mkdir -p "$FIX"
cd "$FIX"
cat > pb-prep.ini <<'EOF'
[EMC]
MACHINE=PB-PREP-001
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

run_arch() {
  local ARCH="$1" CODE="$2"
  local AOUT="$OUT/arch-$ARCH"
  mkdir -p "$AOUT"
  cat > pb-prep.hal <<EOF
loadrt [KINS]KINEMATICS
loadrt [EMCMOT]EMCMOT base_period_nsec=[EMCMOT]BASE_PERIOD servo_period_nsec=[EMCMOT]SERVO_PERIOD num_joints=[KINS]JOINTS num_spindles=[TRAJ]SPINDLES
loadrt pid names=pb-pid1,pb-pid2
loadrt pb_prep
loadrt sampler depth=$DEPTH cfg=ssffffffffffffbb
setp pb-prep.0.architecture $CODE
setp pb-prep.0.run false
setp pb-prep.0.sync-gain $SYNC_GAIN
setp pb-prep.0.diff-max $DIFF_MAX
setp pb-prep.0.u-max $U_MAX
setp pb-prep.0.plant-alpha $PLANT_ALPHA
setp pb-prep.0.plant-gain1 1
setp pb-prep.0.plant-gain2 1
setp pb-prep.0.initial-delta $INITIAL_DELTA
setp pb-prep.0.c-pgain 6
setp pb-pid1.Pgain 6
setp pb-pid2.Pgain 6
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
net sr1 pb-prep.0.r1 => sampler.0.pin.2
net sr2 pb-prep.0.r2 => sampler.0.pin.3
net sy1 pb-prep.0.y1 => sampler.0.pin.4
net sy2 pb-prep.0.y2 => sampler.0.pin.5
net screq pb-prep.0.corr-req => sampler.0.pin.6
net scap pb-prep.0.corr-applied => sampler.0.pin.7
net sref1 pb-prep.0.pid1-ref => sampler.0.pin.8
net sref2 pb-prep.0.pid2-ref => sampler.0.pin.9
net spid1 pb-prep.0.pid1-out => sampler.0.pin.10
net spid2 pb-prep.0.pid2-out => sampler.0.pin.11
net sfinal1 pb-prep.0.final1 => sampler.0.pin.12
net sfinal2 pb-prep.0.final2 => sampler.0.pin.13
net ssat1 pb-prep.0.final1-sat => sampler.0.pin.14
net ssat2 pb-prep.0.final2-sat => sampler.0.pin.15
setp sampler.0.enable false
EOF
  cp pb-prep.hal "$AOUT/fixture.hal"
  printf 'architecture=%s code=%s\n' "$ARCH" "$CODE" > "$AOUT/identity.txt"
  sha256sum pb-prep.ini pb-prep.hal /tmp/pb_prep.comp > "$AOUT/provenance-sha256.txt"

  rm -f /tmp/linuxcnc.lock "$AOUT/realtime.samples"
  linuxcnc -r pb-prep.ini >"$AOUT/linuxcnc.stdout" 2>"$AOUT/linuxcnc.stderr" &
  local LPID=$!
  local HSPID=""
  local ready=0
  for i in $(seq 1 160); do
    if nc -z localhost 5007 >/dev/null 2>&1 && halcmd getp pb-prep.0.y1 >/dev/null 2>&1 && halcmd getp sampler.0.curr-depth >/dev/null 2>&1; then ready=1; echo "ready-probe=$i" > "$AOUT/readiness.txt"; break; fi
    sleep .25
  done
  if [[ "$ready" != 1 ]]; then cat "$AOUT/linuxcnc.stderr" >&2 || true; kill "$LPID" 2>/dev/null || true; wait "$LPID" 2>/dev/null || true; echo "HARNESS_INVALID: $ARCH runtime not ready" >&2; exit 30; fi

  halcmd show thread > "$AOUT/thread-topology.txt"
  halcmd show pin pb-prep.0 > "$AOUT/pb-pins.txt"
  halcmd show pin joint.1.motor-pos-fb > "$AOUT/joint1-feedback-pin.txt"
  halcmd show pin joint.3.motor-pos-fb > "$AOUT/joint3-feedback-pin.txt"
  grep -q 'pb-prep.0.prepare' "$AOUT/thread-topology.txt" || { echo "HARNESS_INVALID: $ARCH prepare missing" >&2; exit 31; }
  grep -q 'pb-prep.0.finish' "$AOUT/thread-topology.txt" || { echo "HARNESS_INVALID: $ARCH finish missing" >&2; exit 32; }
  grep -q 'sampler.0' "$AOUT/thread-topology.txt" || { echo "HARNESS_INVALID: $ARCH sampler missing" >&2; exit 33; }
  [[ "$(halcmd getp sampler.0.curr-depth | tr -d '[:space:]')" == 0 ]] || { echo "HARNESS_INVALID: $ARCH nonzero FIFO before enable" >&2; exit 34; }

  halsampler -t -n "$ROWS" "$AOUT/realtime.samples" >"$AOUT/halsampler.stdout" 2>"$AOUT/halsampler.stderr" & HSPID=$!
  sleep .1
  kill -0 "$HSPID" 2>/dev/null || { cat "$AOUT/halsampler.stderr" >&2 || true; echo "HARNESS_INVALID: $ARCH halsampler exited before enable" >&2; exit 35; }
  halcmd setp sampler.0.enable true
  halcmd setp pb-prep.0.run true

  ARCH="$ARCH" python3 - <<'PY'
import linuxcnc, time, sys, os
c=linuxcnc.command(); s=linuxcnc.stat(); e=linuxcnc.error_channel()
def wc(label):
    r=c.wait_complete(5); print(f'{os.environ["ARCH"]}-{label}-wait={r}')
    if r not in (0,1): raise SystemExit(36)
def wp(label,pred,limit=10):
    end=time.monotonic()+limit
    while time.monotonic()<end:
        s.poll()
        if pred(): print(f'{os.environ["ARCH"]}-{label}=PASS'); return
        er=e.poll()
        if er: print(f'{os.environ["ARCH"]}-error={er}')
        time.sleep(.01)
    print(f'HARNESS_INVALID: {os.environ["ARCH"]} timeout {label}', file=sys.stderr); raise SystemExit(37)
c.state(linuxcnc.STATE_ESTOP_RESET); wc('estop-reset')
c.state(linuxcnc.STATE_ON); wc('on')
c.mode(linuxcnc.MODE_MANUAL); wc('manual')
c.home(-1); wp('homed',lambda: all(bool(s.homed[j]) for j in range(4)))
c.mode(linuxcnc.MODE_MDI); wc('mdi')
c.mdi('G20 G90 G1 Y0.5 F30')
time.sleep(2.0)
PY

  wait "$HSPID" || { cat "$AOUT/halsampler.stderr" >&2 || true; echo "HARNESS_INVALID: $ARCH recorder failed" >&2; exit 38; }
  HSPID=""
  halcmd setp sampler.0.enable false
  local ov="$(halcmd getp sampler.0.overruns | tr -d '[:space:]')"
  echo "overruns=$ov" > "$AOUT/recorder-health.txt"
  [[ "$ov" == 0 ]] || { echo "HARNESS_INVALID: $ARCH sampler overrun" >&2; exit 39; }

  TRACE="$AOUT/realtime.samples" ARCH="$ARCH" ROWS="$ROWS" python3 - <<'PY' | tee "$AOUT/analysis.txt"
import os, sys, math
arch=os.environ['ARCH']; want=int(os.environ['ROWS']); rows=[]
for line in open(os.environ['TRACE'],errors='replace'):
    p=line.split()
    if len(p)<17: continue
    try:
        stream=int(p[0]); cyc=int(p[1]); phase=int(p[2]); f=list(map(float,p[3:15])); sat1=int(p[15]); sat2=int(p[16])
    except ValueError: continue
    rows.append((stream,cyc,phase,*f,sat1,sat2))
print(f'architecture={arch} retained-rows={len(rows)}')
if len(rows)!=want: print('HARNESS_INVALID: wrong retained row count',file=sys.stderr); sys.exit(40)
cyc=[r[1] for r in rows]
gaps=[(a,b) for a,b in zip(cyc,cyc[1:]) if b!=a+1]
print(f'payload-cycle-first={cyc[0]} last={cyc[-1]} gaps={len(gaps)}')
if gaps: print(f'HARNESS_INVALID: deterministic payload gaps sample={gaps[:5]}',file=sys.stderr); sys.exit(41)
# tuple after first 3: r1,r2,y1,y2,corr_req,corr_applied,ref1,ref2,pid1,pid2,final1,final2,sat1,sat2
active=[r for r in rows if r[2]==1]
if len(active)<1000: print('HARNESS_INVALID: insufficient P1 rows',file=sys.stderr); sys.exit(42)
# Proven sign discriminator from early positive y1-y2 seed.
sign=None
for r in active[:500]:
    r1,r2,y1,y2,creq,cap,ref1,ref2,pid1,pid2,fin1,fin2=r[3:15]
    if y1-y2 > 0.005 and abs(cap)>1e-5:
        sign=(y1-y2,creq,cap,ref1,ref2,fin1,fin2); break
if sign is None: print('HARNESS_INVALID: sign seed not observed',file=sys.stderr); sys.exit(43)
ed,creq,cap,ref1,ref2,fin1,fin2=sign
print(f'sign-row e_diff={ed:.9f} corr_req={creq:.9f} corr_applied={cap:.9f} ref1={ref1:.9f} ref2={ref2:.9f} final1={fin1:.9f} final2={fin2:.9f}')
if creq<=0 or cap<=0: print('HARNESS_INVALID: positive e_diff did not request positive correction',file=sys.stderr); sys.exit(44)
if arch=='A':
    if not ref1 < ref2: print('HARNESS_INVALID: A bias sign wrong',file=sys.stderr); sys.exit(45)
else:
    if not fin1 < fin2: print(f'HARNESS_INVALID: {arch} effort sign wrong',file=sys.stderr); sys.exit(46)
# Duplicated nominal requests must remain common during actual common move.
common=[r for r in active if max(abs(r[3]),abs(r[4]))>0.05]
if not common: print('HARNESS_INVALID: no nontrivial common motion target',file=sys.stderr); sys.exit(47)
max_req_diff=max(abs(r[3]-r[4]) for r in common)
max_side_sep=max(abs(r[5]-r[6]) for r in common)
span=max(r[3] for r in common)-min(r[3] for r in common)
print(f'common-request-span={span:.9f} max-r1-r2={max_req_diff:.12g} max-y1-y2={max_side_sep:.9f}')
if max_req_diff>1e-9: print('HARNESS_INVALID: duplicated Y targets differ',file=sys.stderr); sys.exit(48)
if span<0.1: print('HARNESS_INVALID: common target span too small',file=sys.stderr); sys.exit(49)
if max_side_sep>0.08: print('HARNESS_INVALID: baseline side separation too large',file=sys.stderr); sys.exit(50)
print('P0/P1-preflight=PASS')
PY

  { printf '%s\n' 'set timestamp off' 'hello EMC pbshutdown' 'set echo off' 'set enable EMCTOO' 'shutdown'; sleep .2; } | timeout 8s nc localhost 5007 >/dev/null 2>&1 || true
  sleep .4
  kill -TERM "$LPID" 2>/dev/null || true
  wait "$LPID" 2>/dev/null || true
  rm -f /tmp/linuxcnc.lock
}

run_arch A 0
run_arch B 1
run_arch C 2

python3 - "$OUT" <<'PY' | tee "$OUT/final-verdict.txt"
import pathlib,sys
root=pathlib.Path(sys.argv[1])
for a in 'ABC':
    t=(root/f'arch-{a}'/'analysis.txt').read_text()
    if 'P0/P1-preflight=PASS' not in t: raise SystemExit(f'HARNESS_INVALID: {a} missing PASS')
print('PB-PREP-001-PREFLIGHT=PASS')
print('classification=NON-AUTHORITATIVE P0/P1 HARNESS VALIDATION ONLY')
print('P2-P7=NOT EXECUTED; no architecture ranking or physical-machine recommendation')
PY

date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
