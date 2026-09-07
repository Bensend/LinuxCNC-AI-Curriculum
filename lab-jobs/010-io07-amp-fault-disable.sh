#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-io07-fault"

printf '== LinuxCNC IO07 amplifier-fault disable lab (corrected sampler observation) ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Prediction: once enabled, a servo-cycle sample after motion processes the asserted amplifier fault will contain fault=1, faulted=1, error=1, motion-enabled=0, and amp-enable=0.'
printf '%s\n' 'Attempt-1 correction: asynchronous halcmd polling is not used as the oracle for transient joint.error; realtime sampler captures the post-controller servo-cycle state.'
printf '%s\n' 'Evidence boundary: LinuxCNC software/HAL state transitions only; no HostMot2, drive, STO, torque-removal-time, or functional-safety evidence.'

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

# Deterministic single-writer fault source plus a servo-period state recorder.
# The HAL fragment is appended, so the existing motion-controller functions are
# already in servo-thread. or2.0 executes later and sampler.0 later still.
cat >> lcncrsh_sim.hal <<'EOF'

# IO07 experiment fault injector and state sampler.
loadrt or2 count=1
loadrt sampler depth=2000 cfg=bbbbb
addf or2.0 servo-thread
addf sampler.0 servo-thread
setp or2.0.in0 0
setp or2.0.in1 0
setp sampler.0.enable 0
net io07-amp-fault or2.0.out => joint.0.amp-fault-in sampler.0.pin.0
net io07-faulted joint.0.faulted => sampler.0.pin.1
net io07-error joint.0.error => sampler.0.pin.2
net io07-motion-enabled motion.motion-enabled => sampler.0.pin.3
net io07-amp-enable joint.0.amp-enable-out => sampler.0.pin.4
EOF

rm -f /tmp/linuxcnc.lock /tmp/io07.samples /tmp/io07-errors.txt io07-linuxcnc.stdout io07-linuxcnc.stderr
linuxcnc -r linuxcncrsh-test.ini >io07-linuxcnc.stdout 2>io07-linuxcnc.stderr &
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

printf '\n== Wait for runtime, fault signal, and sampler ==\n'
READY=0
for i in $(seq 1 120); do
    if nc -z localhost 5007 >/dev/null 2>&1 \
       && timeout 3s halcmd show sig io07-amp-fault >/tmp/io07-sig.txt 2>/tmp/io07-hal.err \
       && timeout 3s halcmd show pin sampler.0.pin.0 >/tmp/io07-sampler-pin.txt 2>>/tmp/io07-hal.err \
       && grep -q 'joint.0.amp-fault-in' /tmp/io07-sig.txt \
       && grep -q 'or2.0.out' /tmp/io07-sig.txt \
       && grep -q 'sampler.0.pin.0' /tmp/io07-sampler-pin.txt; then
        READY=1
        printf 'readiness: linuxcncrsh + io07 signal + sampler visible at probe %s\n' "$i"
        break
    fi
    sleep 0.25
done
if [[ "$READY" != 1 ]]; then
    echo 'IO07 runtime did not become ready.' >&2
    cat io07-linuxcnc.stdout >&2 || true
    cat io07-linuxcnc.stderr >&2 || true
    cat /tmp/io07-hal.err >&2 || true
    exit 2
fi
cat /tmp/io07-sig.txt

timeout 3s halcmd show thread | tee /tmp/io07-thread.txt
CTL_LINE="$(grep -n 'motion-controller' /tmp/io07-thread.txt | head -1 | cut -d: -f1)"
OR_LINE="$(grep -n 'or2\.0' /tmp/io07-thread.txt | head -1 | cut -d: -f1)"
SAMP_LINE="$(grep -n 'sampler\.0' /tmp/io07-thread.txt | head -1 | cut -d: -f1)"
printf 'thread-order-lines: motion-controller=%s or2=%s sampler=%s\n' "$CTL_LINE" "$OR_LINE" "$SAMP_LINE"
[[ "$CTL_LINE" -lt "$OR_LINE" && "$OR_LINE" -lt "$SAMP_LINE" ]]

printf '\n== Enable machine through normal command path ==\n'
(
    printf '%s\n' 'set timestamp off'
    printf '%s\n' 'hello EMC io07'
    printf '%s\n' 'set echo off'
    printf '%s\n' 'set enable EMCTOO'
    printf '%s\n' 'set wait_mode done'
    printf '%s\n' 'set estop off'
    printf '%s\n' 'set machine on'
    sleep 1
) | timeout 6s nc localhost 5007 >/tmp/io07-rsh-enable.out 2>/tmp/io07-rsh-enable.err || true
cat /tmp/io07-rsh-enable.out || true
cat /tmp/io07-rsh-enable.err >&2 || true

read_pin() { timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
is_true_value() { [[ "$1" == "TRUE" || "$1" == "1" ]]; }
is_false_value() { [[ "$1" == "FALSE" || "$1" == "0" ]]; }

BASELINE_OK=0
for _ in $(seq 1 80); do
    M="$(read_pin motion.motion-enabled)"
    A="$(read_pin joint.0.amp-enable-out)"
    I="$(read_pin joint.0.amp-fault-in)"
    F="$(read_pin joint.0.faulted)"
    E="$(read_pin joint.0.error)"
    if is_true_value "$M" && is_true_value "$A" && is_false_value "$I" && is_false_value "$F" && is_false_value "$E"; then
        BASELINE_OK=1
        break
    fi
    sleep 0.05
done
printf 'baseline motion=%s amp-enable=%s amp-fault-in=%s faulted=%s error=%s\n' "$M" "$A" "$I" "$F" "$E"
[[ "$BASELINE_OK" == 1 ]]
printf 'baseline-enabled=PASS\n'

# Capture enough servo periods to contain pre-injection baseline, transition,
# and post-fault behavior. Reader starts before enabling the sampler FIFO.
halsampler -t -n 500 /tmp/io07.samples >/tmp/io07-halsampler.stdout 2>/tmp/io07-halsampler.stderr &
HS_PID=$!
timeout 3s halcmd setp sampler.0.enable 1
sleep 0.030

printf '\n== Inject amplifier fault through sole source component ==\n'
timeout 3s halcmd setp or2.0.in0 1
timeout 3s halcmd show sig io07-amp-fault | tee /tmp/io07-sig-asserted.txt
I="$(read_pin joint.0.amp-fault-in)"
printf 'joint.0.amp-fault-in=%s\n' "$I"
is_true_value "$I"

# Query the LinuxCNC error channel promptly. get error is documented by
# linuxcncrsh and avoids assuming the realtime diagnostic is on launcher stderr.
for n in $(seq 1 30); do
    (
        printf '%s\n' 'set timestamp off'
        printf '%s\n' "hello EMC io07err$n"
        printf '%s\n' 'get error'
    ) | timeout 2s nc localhost 5007 >>/tmp/io07-errors.txt 2>/dev/null || true
    if grep -Eqi 'joint[[:space:]]*0.*(amp|amplifier).*fault|amplifier.*fault.*joint[[:space:]]*0' /tmp/io07-errors.txt; then
        break
    fi
    sleep 0.01
done

# Let the fixed-length capture complete independently of userspace polling.
if ! timeout 3s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep 0.02; done' _ "$HS_PID"; then
    echo 'halsampler did not finish bounded IO07 capture.' >&2
    kill -TERM "$HS_PID" 2>/dev/null || true
    wait "$HS_PID" 2>/dev/null || true
    exit 3
fi
wait "$HS_PID"
timeout 3s halcmd setp sampler.0.enable 0 || true
OVERRUNS="$(read_pin sampler.0.overruns)"
printf 'sampler-overruns=%s\n' "$OVERRUNS"
[[ "$OVERRUNS" == "0" ]]

printf '\n== Realtime sample preview ==\n'
head -12 /tmp/io07.samples
printf '...\n'
tail -12 /tmp/io07.samples

# With -t and cfg=bbbbb, fields are:
# 1 sample index, 2 fault input signal, 3 joint.faulted, 4 joint.error,
# 5 motion.motion-enabled, 6 joint.amp-enable-out.
# Boolean text is normalized by awk to accept 0/1 or TRUE/FALSE.
awk '
function b(v) { return (v=="1" || v=="TRUE" || v=="true") ? 1 : 0 }
{
    fi=b($2); ff=b($3); er=b($4); me=b($5); ae=b($6)
    if (!fi && !ff && !er && me && ae) baseline++
    if (fi) injected++
    if (fi && ff && er && !me && !ae) exact_fault_cycle++
    if (fi && ff && !me && !ae) core_disable++
    if (fi && ff && !er && !me && !ae) later_error_clear++
}
END {
    printf("sample-analysis baseline=%d injected=%d exact_fault_cycle=%d core_disable=%d later_error_clear=%d\n", baseline, injected, exact_fault_cycle, core_disable, later_error_clear)
    if (baseline < 1) exit 10
    if (injected < 1) exit 11
    if (core_disable < 1) exit 12
    if (exact_fault_cycle < 1) exit 13
}
' /tmp/io07.samples | tee /tmp/io07-analysis.txt

grep -q 'exact_fault_cycle=' /tmp/io07-analysis.txt
printf 'servo-cycle-fault-disable=PASS\n'

printf '\n== Asynchronous final state (diagnostic only) ==\n'
printf 'final amp-fault-in=%s faulted=%s error=%s motion-enabled=%s amp-enable=%s\n' \
  "$(read_pin joint.0.amp-fault-in)" \
  "$(read_pin joint.0.faulted)" \
  "$(read_pin joint.0.error)" \
  "$(read_pin motion.motion-enabled)" \
  "$(read_pin joint.0.amp-enable-out)"

printf '\n== LinuxCNC error-channel evidence ==\n'
cat /tmp/io07-errors.txt || true
if ! grep -Eqi 'joint[[:space:]]*0.*(amp|amplifier).*fault|amplifier.*fault.*joint[[:space:]]*0' /tmp/io07-errors.txt; then
    echo 'Expected joint-0 amplifier-fault diagnostic was not captured through get error.' >&2
    exit 20
fi
printf 'amplifier-fault-diagnostic=PASS\n'

printf '\nIO07 corrected amplifier-fault observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
