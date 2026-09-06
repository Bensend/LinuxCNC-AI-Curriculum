#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-m03-cycle"

printf '== LinuxCNC M03 one-servo-period loopback lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Prediction: in the canonical linuxcncrsh loopback, a sampler scheduled after motion-controller will see joint.0.pos-fb[n] match Xpos/motor-pos-cmd[n-1], while joint.0.pos-cmd[n] matches Xpos[n] during ordinary zero-compensation motion.'
printf '%s\n' 'Evidence boundary: software/simulation ordering only; no realtime deadline, physical I/O timing, or safety qualification.'

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

# Instrument the pinned canonical simulation without altering motmod itself.
# The existing Xpos signal is joint.0.motor-pos-cmd -> joint.0.motor-pos-fb.
cat >> lcncrsh_sim.hal <<'EOF'

# M03 experiment instrumentation: sample AFTER motion-controller.
loadrt sampler depth=6000 cfg=fff
setp sampler.0.enable 0
addf sampler.0 servo-thread
net Xpos sampler.0.pin.0
net m03-j0-fb joint.0.pos-fb sampler.0.pin.1
net m03-j0-cmd joint.0.pos-cmd sampler.0.pin.2
EOF

rm -f /tmp/linuxcnc.lock /tmp/m03.samples m03-linuxcnc.stdout m03-linuxcnc.stderr
linuxcnc -r linuxcncrsh-test.ini >m03-linuxcnc.stdout 2>m03-linuxcnc.stderr &
LAUNCHER_PID=$!
cleanup() {
    trap - EXIT
    kill -TERM "$LAUNCHER_PID" 2>/dev/null || true
    for _ in $(seq 1 50); do
        if ! kill -0 "$LAUNCHER_PID" 2>/dev/null; then break; fi
        sleep 0.1
    done
    kill -KILL "$LAUNCHER_PID" 2>/dev/null || true
    wait "$LAUNCHER_PID" 2>/dev/null || true
}
trap cleanup EXIT

printf '\n== Wait for linuxcncrsh and HAL instrumentation ==\n'
READY=0
for i in $(seq 1 120); do
    if nc -z localhost 5007 >/dev/null 2>&1 \
       && timeout 3s halcmd show pin sampler.0.pin.0 >/tmp/m03-pin.txt 2>/tmp/m03-hal.err \
       && grep -q 'sampler.0.pin.0' /tmp/m03-pin.txt; then
        READY=1
        printf 'readiness: linuxcncrsh + sampler visible at probe %s\n' "$i"
        break
    fi
    sleep 0.25
done
if [[ "$READY" != 1 ]]; then
    echo 'M03 runtime did not become ready.' >&2
    cat m03-linuxcnc.stdout >&2 || true
    cat m03-linuxcnc.stderr >&2 || true
    cat /tmp/m03-hal.err >&2 || true
    exit 2
fi

printf '\n== Confirm configured order ==\n'
timeout 3s halcmd show thread | tee /tmp/m03-thread.txt
CMD_LINE="$(grep -n 'motion-command-handler' /tmp/m03-thread.txt | head -1 | cut -d: -f1)"
CTL_LINE="$(grep -n 'motion-controller' /tmp/m03-thread.txt | head -1 | cut -d: -f1)"
SAMP_LINE="$(grep -n 'sampler\.0' /tmp/m03-thread.txt | head -1 | cut -d: -f1)"
printf 'thread-order-lines: command-handler=%s controller=%s sampler=%s\n' "$CMD_LINE" "$CTL_LINE" "$SAMP_LINE"
[[ "$CMD_LINE" -lt "$CTL_LINE" && "$CTL_LINE" -lt "$SAMP_LINE" ]]

# Start the userspace reader before enabling sampler so the FIFO cannot silently
# fill with startup-idle samples.  3000 samples at the 1 ms servo period gives a
# long moving interval without exhausting the FIFO.
halsampler -t -n 3000 /tmp/m03.samples > /tmp/m03-halsampler.stdout 2>/tmp/m03-halsampler.stderr &
HS_PID=$!
timeout 3s halcmd setp sampler.0.enable 1

printf '\n== Command a slow MDI move while sampling ==\n'
(
    printf '%s\n' 'set timestamp off'
    printf '%s\n' 'hello EMC mt'
    printf '%s\n' 'set echo off'
    printf '%s\n' 'set enable EMCTOO'
    printf '%s\n' 'set wait_mode received'
    printf '%s\n' 'set estop off'
    printf '%s\n' 'set machine on'
    printf '%s\n' 'set mode mdi'
    printf '%s\n' 'set mdi f0.25'
    printf '%s\n' 'set mdi g1 x1.0'
    sleep 4
) | timeout 5s nc localhost 5007 > /tmp/m03-rsh.out 2>/tmp/m03-rsh.err || true

# The reader should have obtained its bounded sample count independently of the
# command connection lifetime.
if ! timeout 8s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep 0.05; done' _ "$HS_PID"; then
    echo 'halsampler did not finish bounded capture.' >&2
    kill -TERM "$HS_PID" 2>/dev/null || true
    wait "$HS_PID" 2>/dev/null || true
    exit 3
fi
wait "$HS_PID"

timeout 3s halcmd setp sampler.0.enable 0 || true
OVERRUNS="$(timeout 3s halcmd getp sampler.0.overruns | tr -d '[:space:]')"
printf 'sampler-overruns=%s\n' "$OVERRUNS"
[[ "$OVERRUNS" == "0" ]]

printf '\n== Sample preview ==\n'
head -8 /tmp/m03.samples
printf '...\n'
tail -8 /tmp/m03.samples

# Columns with -t and cfg=fff:
# 1 sample number, 2 Xpos (= motor-pos-cmd signal after controller),
# 3 joint.0.pos-fb published by controller, 4 joint.0.pos-cmd.
# Evaluate only rows where the motor command changed enough to distinguish a
# one-cycle lag from a same-sample relationship.
awk '
function abs(x){return x<0?-x:x}
NR==1 { prev_cmd=$2; next }
{
    cmd=$2; fb=$3; jcmd=$4
    d=abs(cmd-prev_cmd)
    if (d > 1e-7) {
        moving++
        lag=abs(fb-prev_cmd)
        same=abs(fb-cmd)
        cmderr=abs(jcmd-cmd)
        lag_sum+=lag
        same_sum+=same
        cmd_sum+=cmderr
        if (lag > lag_max) lag_max=lag
        if (cmderr > cmd_max) cmd_max=cmderr
    }
    prev_cmd=cmd
}
END {
    if (moving == 0) { print "analysis: no moving samples" > "/dev/stderr"; exit 10 }
    lag_avg=lag_sum/moving
    same_avg=same_sum/moving
    cmd_avg=cmd_sum/moving
    printf("analysis: moving=%d lag_avg=%.12g same_avg=%.12g cmd_avg=%.12g lag_max=%.12g cmd_max=%.12g\n", moving, lag_avg, same_avg, cmd_avg, lag_max, cmd_max)
    # Strong discriminators, deliberately tolerant of floating formatting:
    # at least 100 moving servo samples; lag relation near exact; same-sample
    # feedback error must be materially larger; joint command equals motor
    # command because this config has zero backlash and zero motor offset.
    if (moving < 100) exit 11
    if (lag_avg > 1e-8 || lag_max > 1e-7) exit 12
    if (same_avg < 20 * lag_avg + 1e-7) exit 13
    if (cmd_avg > 1e-8 || cmd_max > 1e-7) exit 14
}
' /tmp/m03.samples | tee /tmp/m03-analysis.txt

grep -q '^analysis: moving=' /tmp/m03-analysis.txt
printf '\nM03 one-servo-period loopback observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
