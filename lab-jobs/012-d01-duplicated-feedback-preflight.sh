#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-d01-preflight"

printf '== D01 non-authoritative duplicated-feedback preflight ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Purpose: validate a real motmod+trivkins XYY fixture, independent duplicate feedback injection, and duplicate-only ferror disable before authoritative instrumentation.'
printf '%s\n' 'This run DOES NOT score frozen D01-002 Gates A-J.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps
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
cd ..
set +u
source scripts/rip-environment
set -u

mkdir -p /tmp/d01
cp configs/sim/axis/gantry/gantry_mm.ini /tmp/d01/d01.ini
cp configs/sim/axis/gantry/gantry_mm.hal /tmp/d01/d01.hal
: > /tmp/d01/d01.var
: > /tmp/d01/tool.tbl

# Run headlessly with the already-built linuxcncrsh userspace display.
sed -i 's/^DISPLAY = axis$/DISPLAY = linuxcncrsh -n D01Preflight/' /tmp/d01/d01.ini
sed -i 's#^PARAMETER_FILE = gantry_mm.var$#PARAMETER_FILE = /tmp/d01/d01.var#' /tmp/d01/d01.ini
sed -i 's#^HALFILE = gantry_mm.hal$#HALFILE = /tmp/d01/d01.hal#' /tmp/d01/d01.ini
sed -i 's#^TOOL_TABLE = gantry_mm.tbl$#TOOL_TABLE = /tmp/d01/tool.tbl#' /tmp/d01/d01.ini

# Give Y joints deterministic following-error thresholds suitable for a
# below-limit and above-limit offset test after settling.
cat >> /tmp/d01/d01.ini <<'EOF'
EOF
# Existing gantry sample omits FERROR/MIN_FERROR; insert into duplicated joints.
sed -i '/^\[JOINT_1\]/,/^\[JOINT_2\]/{ /^MAX_ACCELERATION = 1000$/a FERROR = 0.100\
MIN_FERROR = 0.050
}' /tmp/d01/d01.ini
sed -i '/^\[JOINT_2\]/,/^\[JOINT_3\]/{ /^MAX_ACCELERATION = 1000$/a FERROR = 0.100\
MIN_FERROR = 0.050
}' /tmp/d01/d01.ini

# Replace direct duplicate-Y loopback with an independently offsettable realtime
# feedback path. sum2 executes after motion-controller and therefore presents the
# current motor command (+ offset) for the next servo cycle's process_inputs().
sed -i '/^net Y2pos joint\.2\.motor-pos-cmd => joint\.2\.motor-pos-fb$/d' /tmp/d01/d01.hal
cat >> /tmp/d01/d01.hal <<'EOF'

# D01 preflight duplicate-only feedback injector and recorder.
loadrt sum2 count=1
loadrt sampler depth=4000 cfg=ffffffbfffb
addf sum2.0 servo-thread
addf sampler.0 servo-thread
setp sum2.0.gain0 1
setp sum2.0.gain1 1
setp sum2.0.in1 0
setp sampler.0.enable 0
net D01-y2-cmd joint.2.motor-pos-cmd => sum2.0.in0 sampler.0.pin.1
net D01-y2-fb sum2.0.out => joint.2.motor-pos-fb sampler.0.pin.3
net D01-y1-cmd joint.1.motor-pos-cmd => sampler.0.pin.0
net D01-y1-fb joint.1.motor-pos-fb => sampler.0.pin.2
net D01-y1-ferr joint.1.f-error => sampler.0.pin.4
net D01-y2-ferr joint.2.f-error => sampler.0.pin.5
net D01-y2-ferrored joint.2.f-errored => sampler.0.pin.6
net D01-y1-flim joint.1.f-error-lim => sampler.0.pin.7
net D01-y2-flim joint.2.f-error-lim => sampler.0.pin.8
net D01-offset sum2.0.in1 => sampler.0.pin.9
net D01-motion-enabled motion.motion-enabled => sampler.0.pin.10
EOF

rm -f /tmp/linuxcnc.lock /tmp/d01.samples /tmp/d01-halsampler.stderr /tmp/d01-halsampler.stdout
cd /tmp/d01
linuxcnc -r d01.ini >linuxcnc.stdout 2>linuxcnc.stderr &
LCPID=$!
cleanup() {
  trap - EXIT
  kill -TERM "$LCPID" 2>/dev/null || true
  sleep 0.2
  kill -KILL "$LCPID" 2>/dev/null || true
  wait "$LCPID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 120); do
  if timeout 3s halcmd show pin joint.2.f-errored >/tmp/d01/ready.txt 2>/tmp/d01/ready.err \
     && grep -q 'joint.2.f-errored' /tmp/d01/ready.txt \
     && timeout 3s halcmd show pin sampler.0.pin.10 >/tmp/d01/sampler-ready.txt 2>>/tmp/d01/ready.err \
     && grep -q 'sampler.0.pin.10' /tmp/d01/sampler-ready.txt; then
    READY=1; break
  fi
  sleep 0.25
done
if [[ "$READY" != 1 ]]; then
  echo 'D01 fixture failed readiness.' >&2
  cat linuxcnc.stdout >&2 || true
  cat linuxcnc.stderr >&2 || true
  cat /tmp/d01/ready.err >&2 || true
  exit 2
fi

printf '\n== Topology ==\n'
halcmd show pin joint.1.motor-pos-cmd joint.2.motor-pos-cmd joint.1.motor-pos-fb joint.2.motor-pos-fb joint.1.f-error joint.2.f-error joint.2.f-errored motion.motion-enabled | tee topology.txt
halcmd show thread | tee thread.txt

# Enable and command a nonzero world-Y move through LinuxCNC's normal Python/NML path.
python3 - <<'PY'
import linuxcnc, time
c=linuxcnc.command(); s=linuxcnc.stat()
c.state(linuxcnc.STATE_ESTOP_RESET); c.wait_complete(); time.sleep(.1)
c.state(linuxcnc.STATE_ON); c.wait_complete(); time.sleep(.1)
c.mode(linuxcnc.MODE_MDI); c.wait_complete();
c.mdi('G0 Y10'); c.wait_complete(); time.sleep(.3)
s.poll()
print('status-after-move task_state=%s interp_state=%s actual_position=%r position=%r' % (s.task_state, s.interp_state, s.actual_position, s.position))
PY

readp(){ timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
printf 'settled y1cmd=%s y2cmd=%s y1fb=%s y2fb=%s motion=%s\n' \
  "$(readp joint.1.motor-pos-cmd)" "$(readp joint.2.motor-pos-cmd)" \
  "$(readp joint.1.motor-pos-fb)" "$(readp joint.2.motor-pos-fb)" \
  "$(readp motion.motion-enabled)" | tee settled.txt

# Start atomic realtime capture before fault injection.
halsampler -t -n 1200 /tmp/d01.samples >/tmp/d01-halsampler.stdout 2>/tmp/d01-halsampler.stderr &
HSPID=$!
halcmd setp sampler.0.enable 1
sleep .050

# Low offset: should remain below MIN_FERROR at settled velocity.
halcmd setp sum2.0.in1 0.020
sleep .080
printf 'low-offset y2-ferror=%s lim=%s errored=%s motion=%s\n' \
  "$(readp joint.2.f-error)" "$(readp joint.2.f-error-lim)" \
  "$(readp joint.2.f-errored)" "$(readp motion.motion-enabled)" | tee low.txt

# Return to zero, then high offset: should exceed threshold and trip duplicate joint.
halcmd setp sum2.0.in1 0
sleep .050
halcmd setp sum2.0.in1 0.200
sleep .080
printf 'high-offset y1-ferror=%s y2-ferror=%s y2lim=%s y1-errored=%s y2-errored=%s motion=%s\n' \
  "$(readp joint.1.f-error)" "$(readp joint.2.f-error)" "$(readp joint.2.f-error-lim)" \
  "$(readp joint.1.f-errored)" "$(readp joint.2.f-errored)" "$(readp motion.motion-enabled)" | tee high.txt

halcmd setp sum2.0.in1 0
sleep .050

if ! timeout 3s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .02; done' _ "$HSPID"; then
  kill -TERM "$HSPID" 2>/dev/null || true
  wait "$HSPID" 2>/dev/null || true
  echo 'halsampler capture did not complete' >&2
  exit 3
fi
wait "$HSPID"
halcmd setp sampler.0.enable 0 || true
OV="$(readp sampler.0.overruns)"
printf 'sampler-overruns=%s\n' "$OV" | tee recorder-health.txt
[[ "$OV" == 0 ]]
[[ ! -s /tmp/d01-halsampler.stderr ]]

# cfg=ffffffbfffb with -t gives:
# index, y1cmd,y2cmd,y1fb,y2fb,y1ferr,y2ferr,y2ferrored,y1lim,y2lim,offset,motion-enabled
python3 - <<'PY'
from pathlib import Path
p=Path('/tmp/d01.samples')
rows=[]
for line in p.read_text().splitlines():
    f=line.split()
    if len(f) < 12: continue
    def b(x): return x.lower() in ('1','true')
    rows.append((int(f[0]), *map(float,f[1:7]), b(f[7]), float(f[8]), float(f[9]), float(f[10]), b(f[11])))
print('sample-count',len(rows))
assert len(rows) > 100
assert all(rows[i][0] < rows[i+1][0] for i in range(len(rows)-1))
# tuple: n,y1c,y2c,y1fb,y2fb,y1fe,y2fe,y2fault,y1lim,y2lim,off,motion
aligned=[r for r in rows if abs(r[1]-10)<.01 and abs(r[2]-10)<.01 and abs(r[4]-r[3])<.005 and r[11]]
low=[r for r in rows if abs(r[10]-.020)<.002 and abs(r[4]-r[3])>.010 and not r[7] and r[11]]
high=[r for r in rows if abs(r[10]-.200)<.002 and abs(r[6])>r[9] and r[7]]
disabled=[r for r in high if not r[11]]
principal_clean=[r for r in high if abs(r[5]) < r[8]]
cmddup=[r for r in rows if abs(r[1]-r[2]) < 1e-6]
print('analysis aligned=%d low-hidden=%d high-trip=%d high-disabled=%d high-principal-clean=%d cmd-duplicate=%d' %
      (len(aligned),len(low),len(high),len(disabled),len(principal_clean),len(cmddup)))
assert aligned
assert low
assert high
assert disabled
assert principal_clean
assert cmddup
print('D01-PREFLIGHT=PASS')
PY

head -8 /tmp/d01.samples > samples-head.txt
tail -8 /tmp/d01.samples > samples-tail.txt
cp /tmp/d01.samples full-samples.txt
cp /tmp/d01-halsampler.stderr halsampler.stderr
cp /tmp/d01-halsampler.stdout halsampler.stdout

git diff --exit-code "$LINUXCNC_COMMIT" -- src/emc/motion src/emc/kinematics || {
  echo 'Unexpected production motion/kinematics source modification' >&2
  exit 20
}
git status --short | tee source-status.txt
printf '\nD01 non-authoritative duplicated-feedback preflight completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
