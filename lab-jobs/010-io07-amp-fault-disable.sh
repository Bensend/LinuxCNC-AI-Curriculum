#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-io07-fault"

printf '== LinuxCNC IO07 amplifier-fault disable lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Prediction: once enabled, asserting a single-writer HAL signal into joint.0.amp-fault-in will assert joint.0.faulted and joint.0.error and will deassert motion.motion-enabled and joint.0.amp-enable-out.'
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

# Add a deterministic single-writer source for the motion amplifier-fault input.
# or2.0.out is the only writer on io07-amp-fault; we toggle only its input.
cat >> lcncrsh_sim.hal <<'EOF'

# IO07 experiment fault injector.
loadrt or2 count=1
addf or2.0 servo-thread
setp or2.0.in0 0
setp or2.0.in1 0
net io07-amp-fault or2.0.out => joint.0.amp-fault-in
EOF

rm -f /tmp/linuxcnc.lock io07-linuxcnc.stdout io07-linuxcnc.stderr
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

printf '\n== Wait for runtime and injected signal ==\n'
READY=0
for i in $(seq 1 120); do
    if nc -z localhost 5007 >/dev/null 2>&1 \
       && timeout 3s halcmd show sig io07-amp-fault >/tmp/io07-sig.txt 2>/tmp/io07-hal.err \
       && grep -q 'joint.0.amp-fault-in' /tmp/io07-sig.txt \
       && grep -q 'or2.0.out' /tmp/io07-sig.txt; then
        READY=1
        printf 'readiness: linuxcncrsh + io07-amp-fault signal visible at probe %s\n' "$i"
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

is_true() {
    local pin="$1" v
    v="$(timeout 3s halcmd getp "$pin" | tr -d '[:space:]')"
    printf '%s=%s\n' "$pin" "$v"
    [[ "$v" == "TRUE" || "$v" == "1" ]]
}
is_false() {
    local pin="$1" v
    v="$(timeout 3s halcmd getp "$pin" | tr -d '[:space:]')"
    printf '%s=%s\n' "$pin" "$v"
    [[ "$v" == "FALSE" || "$v" == "0" ]]
}

BASELINE_OK=0
for _ in $(seq 1 80); do
    if is_true motion.motion-enabled >/tmp/io07-baseline-motion.txt 2>&1 \
       && is_true joint.0.amp-enable-out >/tmp/io07-baseline-amp.txt 2>&1 \
       && is_false joint.0.amp-fault-in >/tmp/io07-baseline-fault.txt 2>&1; then
        BASELINE_OK=1
        break
    fi
    sleep 0.05
done
cat /tmp/io07-baseline-motion.txt /tmp/io07-baseline-amp.txt /tmp/io07-baseline-fault.txt
[[ "$BASELINE_OK" == 1 ]]
printf 'baseline-enabled=PASS\n'

printf '\n== Inject amplifier fault through source component ==\n'
timeout 3s halcmd setp or2.0.in0 1
# Prove source, signal and destination all reflect the asserted value.
timeout 3s halcmd show sig io07-amp-fault | tee /tmp/io07-sig-asserted.txt
is_true joint.0.amp-fault-in

FAULT_OK=0
for _ in $(seq 1 100); do
    F="$(timeout 3s halcmd getp joint.0.faulted | tr -d '[:space:]')"
    E="$(timeout 3s halcmd getp joint.0.error | tr -d '[:space:]')"
    M="$(timeout 3s halcmd getp motion.motion-enabled | tr -d '[:space:]')"
    A="$(timeout 3s halcmd getp joint.0.amp-enable-out | tr -d '[:space:]')"
    if [[ ( "$F" == TRUE || "$F" == 1 ) \
       && ( "$E" == TRUE || "$E" == 1 ) \
       && ( "$M" == FALSE || "$M" == 0 ) \
       && ( "$A" == FALSE || "$A" == 0 ) ]]; then
        FAULT_OK=1
        break
    fi
    sleep 0.02
done
printf 'after-fault joint.0.faulted=%s joint.0.error=%s motion.motion-enabled=%s joint.0.amp-enable-out=%s\n' "$F" "$E" "$M" "$A"
[[ "$FAULT_OK" == 1 ]]
printf 'fault-disable-state=PASS\n'

printf '\n== Deassert source and capture post-input-clear state ==\n'
timeout 3s halcmd setp or2.0.in0 0
sleep 0.05
printf 'post-clear amp-fault-in=%s faulted=%s error=%s motion-enabled=%s amp-enable=%s\n' \
  "$(timeout 3s halcmd getp joint.0.amp-fault-in | tr -d '[:space:]')" \
  "$(timeout 3s halcmd getp joint.0.faulted | tr -d '[:space:]')" \
  "$(timeout 3s halcmd getp joint.0.error | tr -d '[:space:]')" \
  "$(timeout 3s halcmd getp motion.motion-enabled | tr -d '[:space:]')" \
  "$(timeout 3s halcmd getp joint.0.amp-enable-out | tr -d '[:space:]')"

printf '\n== Diagnostic evidence ==\n'
cat io07-linuxcnc.stdout || true
cat io07-linuxcnc.stderr || true
if ! grep -Eqi 'joint[[:space:]]*0.*(amp|amplifier).*fault|amplifier.*fault.*joint[[:space:]]*0' io07-linuxcnc.stdout io07-linuxcnc.stderr; then
    echo 'Expected joint-0 amplifier-fault diagnostic not found.' >&2
    exit 20
fi
printf 'amplifier-fault-diagnostic=PASS\n'

printf '\nIO07 amplifier-fault disable observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
