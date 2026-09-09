#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-d01-redesign"

printf '== D01 redesigned non-authoritative observer preflight ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Three-attempt classification: ESSENTIAL NOW / REDESIGN. Retired linuxcncrsh command-driver lineage.'
printf '%s\n' 'This run validates topology/order/numerics and the test-only atomic Cartesian observer. It DOES NOT score frozen D01-002 Gates A-J.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"

# Minimal test-only observer patch. It exports already-computed Cartesian Y
# immediately after do_forward_kins(). It is never consumed by motion logic.
python3 - <<'PY'
from pathlib import Path
p=Path('src/emc/motion/mot_priv.h')
s=p.read_text()
needle='    hal_real_t distance_to_go;\t/* RPI: distance to go in current move*/\n'
assert needle in s
s=s.replace(needle, needle+'    hal_real_t d01_cart_y_observer; /* D01 test-only Cartesian-Y observer */\n',1)
p.write_text(s)

p=Path('src/emc/motion/motion.c')
s=p.read_text()
needle='    CALL_CHECK(hal_pin_new_real(mot_comp_id, HAL_OUT, &(emcmot_hal_data->distance_to_go), 0.0, "motion.distance-to-go"));\n'
assert needle in s
s=s.replace(needle, needle+'    CALL_CHECK(hal_pin_new_real(mot_comp_id, HAL_OUT, &(emcmot_hal_data->d01_cart_y_observer), 0.0, "motion.d01-cart-y-observer"));\n',1)
p.write_text(s)

p=Path('src/emc/motion/control.c')
s=p.read_text()
needle='    process_inputs();\n    do_forward_kins();\n    process_probe_inputs();\n'
assert needle in s
s=s.replace(needle,'    process_inputs();\n    do_forward_kins();\n    hal_set_real(emcmot_hal_data->d01_cart_y_observer, emcmotStatus->carte_pos_fb.tran.y);\n    process_probe_inputs();\n',1)
p.write_text(s)
PY

git diff -- src/emc/motion/mot_priv.h src/emc/motion/motion.c src/emc/motion/control.c | tee /tmp/d01-observer.patch

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

sed -i 's/^DISPLAY = axis$/DISPLAY = linuxcncrsh -n D01Preflight/' /tmp/d01/d01.ini
sed -i '/^INTRO_GRAPHIC =/d; /^INTRO_TIME =/d' /tmp/d01/d01.ini
sed -i 's#^PARAMETER_FILE = gantry_mm.var$#PARAMETER_FILE = /tmp/d01/d01.var#' /tmp/d01/d01.ini
sed -i 's#^HALFILE = gantry_mm.hal$#HALFILE = /tmp/d01/d01.hal#' /tmp/d01/d01.ini
sed -i 's#^TOOL_TABLE = gantry_mm.tbl$#TOOL_TABLE = /tmp/d01/tool.tbl#' /tmp/d01/d01.ini

# Deterministic thresholds for the duplicated Y joints.
sed -i '/^\[JOINT_1\]/,/^\[JOINT_2\]/{ /^MAX_ACCELERATION = 1000$/a FERROR = 0.100\
MIN_FERROR = 0.050
}' /tmp/d01/d01.ini
sed -i '/^\[JOINT_2\]/,/^\[JOINT_3\]/{ /^MAX_ACCELERATION = 1000$/a FERROR = 0.100\
MIN_FERROR = 0.050
}' /tmp/d01/d01.ini

# Replace only duplicate-Y loopback with an independently offsettable plant.
sed -i '/^net Y2pos joint\.2\.motor-pos-cmd => joint\.2\.motor-pos-fb$/d' /tmp/d01/d01.hal
cat >> /tmp/d01/d01.hal <<'EOF'

# D01 redesigned test-only plant, phase marker and atomic recorder.
loadrt mux16 count=1
loadrt mux2 count=1
loadrt sum2 count=1
# phase,y1cmd,y2cmd,y1fb,y2fb,y1ferr,y2ferr,y2fault,y1lim,y2lim,offset,motion,cartY,y1fault
loadrt sampler depth=5000 cfg=fffffffbfffbfb
addf mux16.0 servo-thread
addf mux2.0 servo-thread
addf sum2.0 servo-thread
addf sampler.0 servo-thread
setp mux16.0.sel 0
setp mux16.0.in00 0
setp mux16.0.in01 1
setp mux16.0.in02 2
setp mux16.0.in03 3
setp mux16.0.in04 4
setp mux16.0.in05 5
setp mux16.0.in06 6
setp mux16.0.in07 7
setp mux16.0.in08 8
setp mux2.0.sel 0
setp mux2.0.in0 0
setp mux2.0.in1 0
setp sum2.0.gain0 1
setp sum2.0.gain1 1
setp sampler.0.enable 0

net D01-phase mux16.0.out => sampler.0.pin.0
net Ypos => sampler.0.pin.1 sampler.0.pin.3
net D01-y2-cmd joint.2.motor-pos-cmd => sum2.0.in0 sampler.0.pin.2
net D01-offset mux2.0.out => sum2.0.in1 sampler.0.pin.10
net D01-y2-fb sum2.0.out => joint.2.motor-pos-fb sampler.0.pin.4
net D01-y1-ferr joint.1.f-error => sampler.0.pin.5
net D01-y2-ferr joint.2.f-error => sampler.0.pin.6
net D01-y2-ferrored joint.2.f-errored => sampler.0.pin.7
net D01-y1-flim joint.1.f-error-lim => sampler.0.pin.8
net D01-y2-flim joint.2.f-error-lim => sampler.0.pin.9
net D01-motion-enabled motion.motion-enabled => sampler.0.pin.11
net D01-cart-y motion.d01-cart-y-observer => sampler.0.pin.12
net D01-y1-ferrored joint.1.f-errored => sampler.0.pin.13
EOF

rm -f /tmp/linuxcnc.lock /tmp/d01.samples /tmp/d01-halsampler.stderr /tmp/d01-halsampler.stdout
cd /tmp/d01
linuxcnc -r d01.ini >linuxcnc.stdout 2>linuxcnc.stderr &
LCPID=$!
cleanup() {
  trap - EXIT
  kill -TERM "$LCPID" 2>/dev/null || true
  sleep .2
  kill -KILL "$LCPID" 2>/dev/null || true
  wait "$LCPID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 160); do
  if kill -0 "$LCPID" 2>/dev/null \
     && timeout 3s halcmd show pin motion.d01-cart-y-observer >/tmp/d01/ready.txt 2>/tmp/d01/ready.err \
     && grep -q 'motion.d01-cart-y-observer' /tmp/d01/ready.txt \
     && timeout 3s halcmd show pin sampler.0.pin.13 >/tmp/d01/sampler-ready.txt 2>>/tmp/d01/ready.err \
     && grep -q 'sampler.0.pin.13' /tmp/d01/sampler-ready.txt; then
    READY=1; printf 'readiness PASS at probe %s\n' "$i"; break
  fi
  sleep .25
done
if [[ "$READY" != 1 ]]; then
  echo 'D01 redesigned fixture failed readiness' >&2
  cat linuxcnc.stdout >&2 || true; cat linuxcnc.stderr >&2 || true; cat /tmp/d01/ready.err >&2 || true
  exit 2
fi

printf '\n== Retained topology/order ==\n'
halcmd show pin joint.1.motor-pos-cmd joint.2.motor-pos-cmd joint.1.motor-pos-fb joint.2.motor-pos-fb joint.1.f-error joint.2.f-error joint.1.f-errored joint.2.f-errored motion.motion-enabled motion.d01-cart-y-observer | tee topology.txt
halcmd show thread | tee thread.txt
cp /tmp/d01-observer.patch observer.patch

# Start the atomic recorder at P0 before machine state changes.
halsampler -t -n 2200 /tmp/d01.samples >/tmp/d01-halsampler.stdout 2>/tmp/d01-halsampler.stderr &
HSPID=$!
halcmd setp sampler.0.enable 1
sleep .030

# P1 is visible before enabling/homing/MDI mutations.
halcmd setp mux16.0.sel 1
sleep .010
python3 - <<'PY'
import linuxcnc,time
c=linuxcnc.command(); s=linuxcnc.stat()
c.state(linuxcnc.STATE_ESTOP_RESET); c.wait_complete(); time.sleep(.05)
c.state(linuxcnc.STATE_ON); c.wait_complete(); time.sleep(.05)
c.mode(linuxcnc.MODE_MANUAL); c.wait_complete(); time.sleep(.05)
c.home(-1)
deadline=time.time()+5
while time.time()<deadline:
    s.poll()
    if all(bool(x) for x in s.homed[:4]): break
    time.sleep(.02)
else:
    raise SystemExit('homing timeout: %r' % (s.homed[:4],))
c.mode(linuxcnc.MODE_MDI); c.wait_complete(); time.sleep(.05)
c.mdi('G0 Y10'); c.wait_complete()
deadline=time.time()+5
while time.time()<deadline:
    s.poll()
    if s.interp_state == linuxcnc.INTERP_IDLE and abs(s.position[1]-10) < .01: break
    time.sleep(.02)
else:
    raise SystemExit('MDI settle timeout: pos=%r actual=%r interp=%r' % (s.position,s.actual_position,s.interp_state))
print('python-driver PASS homed=%r posY=%s actualY=%s task_state=%s' % (s.homed[:4],s.position[1],s.actual_position[1],s.task_state))
PY

readp(){ timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
halcmd setp mux16.0.sel 2
sleep .030
printf 'settled y1cmd=%s y2cmd=%s y1fb=%s y2fb=%s cartY=%s motion=%s\n' \
  "$(readp joint.1.motor-pos-cmd)" "$(readp joint.2.motor-pos-cmd)" "$(readp joint.1.motor-pos-fb)" "$(readp joint.2.motor-pos-fb)" \
  "$(readp motion.d01-cart-y-observer)" "$(readp motion.motion-enabled)" | tee settled.txt

# P3 must precede low offset.
halcmd setp mux16.0.sel 3
sleep .015
halcmd setp mux2.0.in0 0.020
sleep .060
halcmd setp mux16.0.sel 4
sleep .030
printf 'low y2-ferror=%s lim=%s y2fault=%s cartY=%s motion=%s\n' \
  "$(readp joint.2.f-error)" "$(readp joint.2.f-error-lim)" "$(readp joint.2.f-errored)" "$(readp motion.d01-cart-y-observer)" "$(readp motion.motion-enabled)" | tee low.txt

halcmd setp mux2.0.in0 0
sleep .040
# P5 must precede high offset.
halcmd setp mux16.0.sel 5
sleep .015
halcmd setp mux2.0.in0 0.200
sleep .060
halcmd setp mux16.0.sel 6
sleep .030
printf 'high y1-ferror=%s y2-ferror=%s y2lim=%s y1fault=%s y2fault=%s cartY=%s motion=%s\n' \
  "$(readp joint.1.f-error)" "$(readp joint.2.f-error)" "$(readp joint.2.f-error-lim)" "$(readp joint.1.f-errored)" "$(readp joint.2.f-errored)" "$(readp motion.d01-cart-y-observer)" "$(readp motion.motion-enabled)" | tee high.txt

halcmd setp mux16.0.sel 7
sleep .010
halcmd setp mux2.0.in0 0
sleep .060

# Fresh explicit re-enable only after cause clear; behavior is retained, not forced.
halcmd setp mux16.0.sel 8
sleep .010
python3 - <<'PY'
import linuxcnc,time
c=linuxcnc.command(); s=linuxcnc.stat()
c.state(linuxcnc.STATE_ON); c.wait_complete(); time.sleep(.08); s.poll()
print('fresh-reenable observed task_state=%s enabled=%s' % (s.task_state, s.enabled))
PY
sleep .050

if ! timeout 4s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .02; done' _ "$HSPID"; then
  kill -TERM "$HSPID" 2>/dev/null || true; wait "$HSPID" 2>/dev/null || true
  echo 'halsampler capture did not complete' >&2; exit 3
fi
wait "$HSPID"
halcmd setp sampler.0.enable 0 || true
OV="$(readp sampler.0.overruns)"
printf 'sampler-overruns=%s\n' "$OV" | tee recorder-health.txt
[[ "$OV" == 0 ]]
[[ ! -s /tmp/d01-halsampler.stderr ]]

python3 - <<'PY'
from pathlib import Path
rows=[]
for line in Path('/tmp/d01.samples').read_text().splitlines():
    f=line.split()
    if len(f)<15: continue
    b=lambda x:x.lower() in ('1','true')
    # index, phase,y1c,y2c,y1fb,y2fb,y1fe,y2fe,y2fault,y1lim,y2lim,off,motion,cart,y1fault
    rows.append((int(f[0]),float(f[1]),float(f[2]),float(f[3]),float(f[4]),float(f[5]),float(f[6]),float(f[7]),b(f[8]),float(f[9]),float(f[10]),float(f[11]),b(f[12]),float(f[13]),b(f[14])))
print('sample-count',len(rows))
assert len(rows)>500
assert all(rows[i][0] < rows[i+1][0] for i in range(len(rows)-1))
# phase-before-mutation witnesses
p3=[r for r in rows if abs(r[1]-3)<.1 and abs(r[11])<.002]
low=[r for r in rows if abs(r[1]-4)<.1 and abs(r[11]-.020)<.002 and abs(r[5]-r[4])>.010 and not r[8] and r[12]]
p5=[r for r in rows if abs(r[1]-5)<.1 and abs(r[11])<.002]
high=[r for r in rows if abs(r[1]-6)<.1 and abs(r[11]-.200)<.002 and abs(r[7])>r[10] and r[8]]
principal_clean=[r for r in high if not r[14] and abs(r[6])<r[9]]
cart_low=[r for r in low if abs(r[13]-r[4])<1e-6 and abs(r[13]-r[5])>.010]
cmddup=[r for r in rows if r[1]>=2 and abs(r[2]-r[3])<1e-6]
disabled=[r for r in high if not r[12]]
print('analysis p3-pre=%d low-hidden=%d cart-low=%d p5-pre=%d high-trip=%d principal-clean=%d disabled=%d cmddup=%d' %
      (len(p3),len(low),len(cart_low),len(p5),len(high),len(principal_clean),len(disabled),len(cmddup)))
assert p3 and low and cart_low and p5 and high and principal_clean and disabled and cmddup
assert min(r[0] for r in p3) < min(r[0] for r in low)
assert min(r[0] for r in p5) < min(r[0] for r in high)
print('D01-REDESIGNED-PREFLIGHT=PASS')
PY

cp /tmp/d01.samples full-samples.txt
cp /tmp/d01-halsampler.stderr halsampler.stderr
cp /tmp/d01-halsampler.stdout halsampler.stdout
head -10 /tmp/d01.samples > samples-head.txt
tail -10 /tmp/d01.samples > samples-tail.txt

# Only the three explicit observer edits may touch production motion source.
git diff "$LINUXCNC_COMMIT" -- src/emc/motion/mot_priv.h src/emc/motion/motion.c src/emc/motion/control.c > final-observer.patch
python3 - <<'PY'
from pathlib import Path
p=Path('final-observer.patch').read_text()
for required in ('d01_cart_y_observer','motion.d01-cart-y-observer','carte_pos_fb.tran.y'):
    assert required in p
print('observer-patch-check PASS')
PY
git status --short | tee source-status.txt
printf '\nD01 redesigned non-authoritative preflight completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
