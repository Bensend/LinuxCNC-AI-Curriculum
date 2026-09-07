#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-s04-freeze"

printf '== LinuxCNC S04 frozen-feedback / following-error lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Predeclared prediction A: while command moves, holding motor-pos-fb fixed until |f-error| exceeds runtime f-error-lim causes following-error fault and motion/amp-enable deassertion.'
printf '%s\n' 'Predeclared prediction B: holding already-equal stationary feedback for >=250 servo cycles does not by itself produce following error.'
printf '%s\n' 'Evidence boundary: LinuxCNC software/simulation behavior only; no physical encoder, stopping time, drive/STO, diagnostic coverage, or functional-safety evidence.'

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

cd tests/linuxcncrsh

# Predeclared numerical configuration for joint 0 / X.
python3 - <<'PY'
from pathlib import Path
p = Path('linuxcncrsh-test.ini')
s = p.read_text()
s = s.replace('[AXIS_X]\nHOME =             0.000\nMIN_LIMIT =        -40.0\nMAX_LIMIT =        40.0\nMAX_VELOCITY =     4',
              '[AXIS_X]\nHOME =             0.000\nMIN_LIMIT =        -40.0\nMAX_LIMIT =        40.0\nMAX_VELOCITY =     1.0')
s = s.replace('[JOINT_0]\nTYPE =             LINEAR\nHOME =             0.000\nMAX_VELOCITY =     4',
              '[JOINT_0]\nTYPE =             LINEAR\nHOME =             0.000\nMAX_VELOCITY =     1.0')
s = s.replace('FERROR =           0.050\nMIN_FERROR =       0.010\nHOME_SEQUENCE =    0',
              'FERROR =           0.100\nMIN_FERROR =       0.010\nHOME_SEQUENCE =    0')
p.write_text(s)
PY

grep -A14 '^\[JOINT_0\]' linuxcncrsh-test.ini | tee /tmp/s04-joint0.ini

grep -q 'MAX_VELOCITY =     1.0' /tmp/s04-joint0.ini
grep -q 'FERROR =           0.100' /tmp/s04-joint0.ini
grep -q 'MIN_FERROR =       0.010' /tmp/s04-joint0.ini

# Replace only joint-0 feedback loopback with a selectable healthy/frozen path.
# mux2.0 is scheduled after motion-controller; its output therefore becomes the
# feedback seen by the next servo-cycle process_inputs(), preserving the normal
# one-cycle simulated loopback while selected live.
python3 - <<'PY'
from pathlib import Path
p = Path('lcncrsh_sim.hal')
s = p.read_text()
s = s.replace('loadrt hypot names=vel_xy,vel_xyz\n',
              'loadrt hypot names=vel_xy,vel_xyz\nloadrt mux2 count=1\n')
s = s.replace('addf motion-controller servo-thread\n',
              'addf motion-controller servo-thread\naddf mux2.0 servo-thread\n')
s = s.replace('net Xpos joint.0.motor-pos-cmd => joint.0.motor-pos-fb ddt_x.in\n',
              'net Xpos joint.0.motor-pos-cmd => ddt_x.in mux2.0.in0\n'
              'net Xfeedback mux2.0.out => joint.0.motor-pos-fb\n'
              'setp mux2.0.sel 0\n'
              'setp mux2.0.in1 0\n')
p.write_text(s)
PY

cat >> lcncrsh_sim.hal <<'EOF'

# S04 cycle-level instrumentation, scheduled after feedback mux and controller.
loadrt sampler depth=9000 cfg=ffffbbbb
setp sampler.0.enable 0
addf sampler.0 servo-thread
net Xpos sampler.0.pin.0
net Xfeedback sampler.0.pin.1
net s04-ferror joint.0.f-error => sampler.0.pin.2
net s04-ferror-lim joint.0.f-error-lim => sampler.0.pin.3
net s04-ferrored joint.0.f-errored => sampler.0.pin.4
net s04-error joint.0.error => sampler.0.pin.5
net s04-amp-enable joint.0.amp-enable-out => sampler.0.pin.6
net s04-motion-enabled motion.motion-enabled => sampler.0.pin.7
EOF

read_pin() { timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
is_true_value() { [[ "$1" == "TRUE" || "$1" == "1" ]]; }
is_false_value() { [[ "$1" == "FALSE" || "$1" == "0" ]]; }

LAUNCHER_PID=""
cleanup_runtime() {
    if [[ -n "${LAUNCHER_PID:-}" ]]; then
        kill -TERM "$LAUNCHER_PID" 2>/dev/null || true
        for _ in $(seq 1 50); do
            if ! kill -0 "$LAUNCHER_PID" 2>/dev/null; then break; fi
            sleep 0.1
        done
        kill -KILL "$LAUNCHER_PID" 2>/dev/null || true
        wait "$LAUNCHER_PID" 2>/dev/null || true
        LAUNCHER_PID=""
    fi
    rm -f /tmp/linuxcnc.lock
}
trap cleanup_runtime EXIT

start_runtime() {
    local tag="$1"
    rm -f /tmp/linuxcnc.lock
    linuxcnc -r linuxcncrsh-test.ini >"s04-${tag}.stdout" 2>"s04-${tag}.stderr" &
    LAUNCHER_PID=$!
    local ready=0
    for i in $(seq 1 120); do
        if nc -z localhost 5007 >/dev/null 2>&1 \
           && timeout 3s halcmd show pin mux2.0.out >/tmp/s04-mux-pin.txt 2>/tmp/s04-hal.err \
           && timeout 3s halcmd show pin sampler.0.pin.7 >/tmp/s04-sampler-pin.txt 2>>/tmp/s04-hal.err \
           && grep -q 'mux2.0.out' /tmp/s04-mux-pin.txt \
           && grep -q 'sampler.0.pin.7' /tmp/s04-sampler-pin.txt; then
            ready=1
            printf 'runtime-%s-ready probe=%s\n' "$tag" "$i"
            break
        fi
        sleep 0.25
    done
    if [[ "$ready" != 1 ]]; then
        echo "S04 runtime $tag did not become ready; HARNESS INVALID." >&2
        cat "s04-${tag}.stdout" >&2 || true
        cat "s04-${tag}.stderr" >&2 || true
        cat /tmp/s04-hal.err >&2 || true
        exit 2
    fi

    timeout 3s halcmd show thread >"/tmp/s04-${tag}-thread.txt"
    local ctl mux samp
    ctl="$(grep -n 'motion-controller' "/tmp/s04-${tag}-thread.txt" | head -1 | cut -d: -f1)"
    mux="$(grep -n 'mux2\.0' "/tmp/s04-${tag}-thread.txt" | head -1 | cut -d: -f1)"
    samp="$(grep -n 'sampler\.0' "/tmp/s04-${tag}-thread.txt" | head -1 | cut -d: -f1)"
    printf 'thread-order-%s: motion-controller=%s mux2=%s sampler=%s\n' "$tag" "$ctl" "$mux" "$samp"
    [[ "$ctl" -lt "$mux" && "$mux" -lt "$samp" ]]
}

enable_machine() {
    local tag="$1"
    (
        printf '%s\n' 'set timestamp off'
        printf '%s\n' "hello EMC s04${tag}"
        printf '%s\n' 'set echo off'
        printf '%s\n' 'set enable EMCTOO'
        printf '%s\n' 'set wait_mode done'
        printf '%s\n' 'set estop off'
        printf '%s\n' 'set machine on'
        printf '%s\n' 'set mode mdi'
        sleep 0.2
    ) | timeout 5s nc localhost 5007 >"/tmp/s04-${tag}-enable.out" 2>"/tmp/s04-${tag}-enable.err" || true

    local ok=0 m a fe er
    for _ in $(seq 1 80); do
        m="$(read_pin motion.motion-enabled)"
        a="$(read_pin joint.0.amp-enable-out)"
        fe="$(read_pin joint.0.f-errored)"
        er="$(read_pin joint.0.error)"
        if is_true_value "$m" && is_true_value "$a" && is_false_value "$fe" && is_false_value "$er"; then
            ok=1
            break
        fi
        sleep 0.05
    done
    printf 'enabled-%s motion=%s amp=%s f-errored=%s error=%s\n' "$tag" "$m" "$a" "$fe" "$er"
    [[ "$ok" == 1 ]] || { echo 'HARNESS INVALID: cannot establish enabled baseline.' >&2; exit 3; }
}

printf '\n== Gate A/B/C: healthy motion, freeze feedback, threshold fault ==\n'
rm -f /tmp/s04-moving.samples /tmp/s04-errors.txt
start_runtime moving
enable_machine moving

# Start cycle capture before motion. 6500 samples = 6.5 s at the 1 ms servo period.
halsampler -t -n 6500 /tmp/s04-moving.samples >/tmp/s04-moving-halsampler.out 2>/tmp/s04-moving-halsampler.err &
HS_PID=$!
timeout 3s halcmd setp sampler.0.enable 1

# Begin a 0.5 unit/s move (G-code feed units/minute => F30).
(
    printf '%s\n' 'set timestamp off'
    printf '%s\n' 'hello EMC s04move'
    printf '%s\n' 'set echo off'
    printf '%s\n' 'set enable EMCTOO'
    printf '%s\n' 'set wait_mode received'
    printf '%s\n' 'set mode mdi'
    printf '%s\n' 'set mdi g1 x1.0 f30'
    sleep 5
) | timeout 6s nc localhost 5007 >/tmp/s04-move-rsh.out 2>/tmp/s04-move-rsh.err &
RSH_PID=$!

# Gate A: prove command is changing, feedback follows, and no ferror state exists.
BASE_CMD="$(read_pin joint.0.motor-pos-cmd)"
BASELINE_OK=0
for _ in $(seq 1 150); do
    sleep 0.01
    CMD="$(read_pin joint.0.motor-pos-cmd)"
    FB="$(read_pin joint.0.motor-pos-fb)"
    FE="$(read_pin joint.0.f-error)"
    LIM="$(read_pin joint.0.f-error-lim)"
    FER="$(read_pin joint.0.f-errored)"
    ERR="$(read_pin joint.0.error)"
    M="$(read_pin motion.motion-enabled)"
    A="$(read_pin joint.0.amp-enable-out)"
    if awk -v c="$CMD" -v b="$BASE_CMD" -v f="$FB" 'BEGIN{d=c-b; if(d<0)d=-d; e=c-f;if(e<0)e=-e; exit !(d>0.03 && e<0.010)}' \
       && is_false_value "$FER" && is_false_value "$ERR" && is_true_value "$M" && is_true_value "$A"; then
        BASELINE_OK=1
        break
    fi
done
printf 'gate-A cmd=%s fb=%s ferror=%s limit=%s f-errored=%s error=%s motion=%s amp=%s\n' "$CMD" "$FB" "$FE" "$LIM" "$FER" "$ERR" "$M" "$A"
[[ "$BASELINE_OK" == 1 ]] || { echo 'Gate A failed; HARNESS INVALID.' >&2; exit 4; }
printf 'gate-A-healthy-baseline=PASS\n'

# Freeze at an explicit value sampled from current feedback. Setting in1 first
# avoids changing any command/enable path; only mux selection changes afterward.
HOLD="$(read_pin joint.0.motor-pos-fb)"
timeout 3s halcmd setp mux2.0.in1 "$HOLD"
timeout 3s halcmd setp mux2.0.sel 1
printf 'freeze-asserted hold=%s cmd-at-freeze=%s\n' "$HOLD" "$(read_pin joint.0.motor-pos-cmd)"

# Promptly collect the error channel while the move/fault transition occurs.
for n in $(seq 1 60); do
    (
        printf '%s\n' 'set timestamp off'
        printf '%s\n' "hello EMC s04err$n"
        printf '%s\n' 'get error'
    ) | timeout 2s nc localhost 5007 >>/tmp/s04-errors.txt 2>/dev/null || true
    if grep -Eqi 'joint[[:space:]]*0.*following error|following error.*joint[[:space:]]*0' /tmp/s04-errors.txt; then
        break
    fi
    sleep 0.01
done

wait "$RSH_PID" 2>/dev/null || true
if ! timeout 8s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep 0.05; done' _ "$HS_PID"; then
    echo 'Moving halsampler did not finish bounded capture.' >&2
    kill -TERM "$HS_PID" 2>/dev/null || true
    wait "$HS_PID" 2>/dev/null || true
    exit 5
fi
wait "$HS_PID"
timeout 3s halcmd setp sampler.0.enable 0 || true
OV="$(read_pin sampler.0.overruns)"
printf 'moving-sampler-overruns=%s\n' "$OV"
[[ "$OV" == "0" ]]

# -t + ffffbbbb fields:
# 1 idx, 2 motor-cmd, 3 motor-fb, 4 f-error, 5 f-error-lim,
# 6 f-errored, 7 joint.error, 8 amp-enable, 9 motion-enabled.
awk -v hold="$HOLD" '
function abs(x){return x<0?-x:x}
function b(v){return (v=="1" || v=="TRUE" || v=="true") ? 1 : 0}
{
    cmd=$2; fb=$3; fe=$4; lim=$5; fer=b($6); er=b($7); amp=b($8); mot=b($9)
    if (abs(fb-hold) < 1e-6) frozen++
    if (abs(fb-hold) < 1e-6) {
        travel=abs(cmd-hold)
        if (travel>max_travel) max_travel=travel
        if (abs(fe)>lim) crossed++
        if (fer) ferrored++
        if (fer && er && !amp && !mot) exact_fault++
        if (fer && !amp && !mot) disable++
    }
}
END{
    printf("moving-analysis frozen=%d max_travel=%.9g crossed=%d ferrored=%d exact_fault=%d disable=%d\n", frozen,max_travel,crossed,ferrored,exact_fault,disable)
    if (frozen < 1) exit 20
    if (max_travel < 0.20) exit 21
    if (crossed < 1) exit 22
    if (ferrored < 1) exit 23
    if (disable < 1) exit 24
    if (exact_fault < 1) exit 25
}
' /tmp/s04-moving.samples | tee /tmp/s04-moving-analysis.txt

grep -Eqi 'joint[[:space:]]*0.*following error|following error.*joint[[:space:]]*0' /tmp/s04-errors.txt || {
    echo 'Gate C missing joint-0 following-error diagnostic.' >&2
    cat /tmp/s04-errors.txt >&2 || true
    exit 26
}
printf 'gate-B-moving-freeze-threshold=PASS\n'
printf 'gate-C-following-error-disable=PASS\n'

printf '\n== Gate D: fresh stationary-frozen control ==\n'
cleanup_runtime
sleep 0.2
rm -f /tmp/s04-stationary.samples /tmp/s04-stationary-errors.txt
start_runtime stationary
enable_machine stationary

# Establish an equal stationary state, then freeze at exactly that feedback.
sleep 0.2
SCMD="$(read_pin joint.0.motor-pos-cmd)"
SFB="$(read_pin joint.0.motor-pos-fb)"
awk -v c="$SCMD" -v f="$SFB" 'BEGIN{e=c-f;if(e<0)e=-e; exit !(e<0.010)}' || {
    echo 'Gate D initial command/feedback mismatch; HARNESS INVALID.' >&2
    exit 30
}
timeout 3s halcmd setp mux2.0.in1 "$SFB"
timeout 3s halcmd setp mux2.0.sel 1
printf 'stationary-freeze hold=%s cmd=%s\n' "$SFB" "$SCMD"

# 600 cycles gives >2x the required >=250-cycle control interval.
halsampler -t -n 600 /tmp/s04-stationary.samples >/tmp/s04-stationary-halsampler.out 2>/tmp/s04-stationary-halsampler.err &
HS2_PID=$!
timeout 3s halcmd setp sampler.0.enable 1
if ! timeout 3s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep 0.02; done' _ "$HS2_PID"; then
    echo 'Stationary halsampler did not finish bounded capture.' >&2
    kill -TERM "$HS2_PID" 2>/dev/null || true
    wait "$HS2_PID" 2>/dev/null || true
    exit 31
fi
wait "$HS2_PID"
timeout 3s halcmd setp sampler.0.enable 0 || true
OV2="$(read_pin sampler.0.overruns)"
printf 'stationary-sampler-overruns=%s\n' "$OV2"
[[ "$OV2" == "0" ]]

awk '
function abs(x){return x<0?-x:x}
function b(v){return (v=="1" || v=="TRUE" || v=="true") ? 1 : 0}
NR==1 {firstcmd=$2; firstfb=$3}
{
    n++
    cmd=$2; fb=$3; fe=$4; lim=$5; fer=b($6); er=b($7); amp=b($8); mot=b($9)
    if (abs(cmd-firstcmd)>max_cmd_move) max_cmd_move=abs(cmd-firstcmd)
    if (abs(fb-firstfb)>max_fb_move) max_fb_move=abs(fb-firstfb)
    if (abs(fe)>lim+1e-9) overlim++
    if (fer) ferrored++
    if (er) errors++
    if (!mot) motion_off++
    if (!amp) amp_off++
}
END{
    printf("stationary-analysis cycles=%d max_cmd_move=%.9g max_fb_move=%.9g overlim=%d ferrored=%d errors=%d motion_off=%d amp_off=%d\n",n,max_cmd_move,max_fb_move,overlim,ferrored,errors,motion_off,amp_off)
    if (n < 250) exit 40
    if (max_cmd_move > 1e-6 || max_fb_move > 1e-6) exit 41
    if (overlim || ferrored || errors || motion_off || amp_off) exit 42
}
' /tmp/s04-stationary.samples | tee /tmp/s04-stationary-analysis.txt

printf 'gate-D-stationary-frozen-control=PASS\n'
printf '\nS04 frozen-feedback experiment completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
