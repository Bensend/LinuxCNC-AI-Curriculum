#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-s01-estop"

printf '== LinuxCNC S01 external E-stop software-boundary lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Prediction: from a verified enabled baseline, external-style emc-enable-in TRUE->FALSE makes Task report ESTOP and motion.motion-enabled go FALSE.'
printf '%s\n' 'Correction locked before execution: user-enable-out is NOT required to mirror the external assertion because the external-input synchronization path does not call emcAuxEstopOn().' 
printf '%s\n' 'Release prediction: returning external permissive TRUE can leave Task out of ESTOP while motion remains disabled; no automatic Machine ON is expected.'
printf '%s\n' 'Evidence boundary: LinuxCNC software/controller states only; no physical E-stop, STO, torque, stopping-time, PL/SIL/category evidence.'

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

# Replace the stock internal loopback with one controlled HAL_OUT writer so
# emc-enable-in behaves like an independently reported external permissive.
sed -i '/^[[:space:]]*net[[:space:]]\+estop-loop[[:space:]]/d' lcncrsh_sim.hal
cat >> lcncrsh_sim.hal <<'EOF'

# S01 controlled external E-stop permissive source.
loadrt or2 count=1
addf or2.0 servo-thread
setp or2.0.in0 1
setp or2.0.in1 0
net s01-external-permissive or2.0.out => iocontrol.0.emc-enable-in
EOF

rm -f /tmp/linuxcnc.lock s01-linuxcnc.stdout s01-linuxcnc.stderr /tmp/s01-*.txt
linuxcnc -r linuxcncrsh-test.ini >s01-linuxcnc.stdout 2>s01-linuxcnc.stderr &
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

printf '\n== Wait for runtime and verify sole external source wiring ==\n'
READY=0
for i in $(seq 1 120); do
    if nc -z localhost 5007 >/dev/null 2>&1 \
       && timeout 3s halcmd show sig s01-external-permissive >/tmp/s01-sig.txt 2>/tmp/s01-hal.err \
       && grep -q 'iocontrol.0.emc-enable-in' /tmp/s01-sig.txt \
       && grep -q 'or2.0.out' /tmp/s01-sig.txt; then
        READY=1
        printf 'readiness: linuxcncrsh + controlled E-stop signal visible at probe %s\n' "$i"
        break
    fi
    sleep 0.25
done
if [[ "$READY" != 1 ]]; then
    echo 'S01 runtime did not become ready.' >&2
    cat s01-linuxcnc.stdout >&2 || true
    cat s01-linuxcnc.stderr >&2 || true
    cat /tmp/s01-hal.err >&2 || true
    exit 2
fi
cat /tmp/s01-sig.txt

read_pin() { timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
is_true_value() { [[ "$1" == "TRUE" || "$1" == "1" ]]; }
is_false_value() { [[ "$1" == "FALSE" || "$1" == "0" ]]; }
rsh_get_estop() {
    local tag="$1"
    (
        printf '%s\n' 'set timestamp off'
        printf '%s\n' "hello EMC $tag"
        printf '%s\n' 'get estop'
    ) | timeout 3s nc localhost 5007
}

printf '\n== Establish enabled baseline through normal controller commands ==\n'
(
    printf '%s\n' 'set timestamp off'
    printf '%s\n' 'hello EMC s01enable'
    printf '%s\n' 'set echo off'
    printf '%s\n' 'set enable EMCTOO'
    printf '%s\n' 'set wait_mode done'
    printf '%s\n' 'set estop off'
    printf '%s\n' 'set machine on'
    sleep 1
) | timeout 6s nc localhost 5007 >/tmp/s01-enable.out 2>/tmp/s01-enable.err || true
cat /tmp/s01-enable.out || true
cat /tmp/s01-enable.err >&2 || true

BASELINE_OK=0
for _ in $(seq 1 80); do
    EXT="$(read_pin iocontrol.0.emc-enable-in)"
    MOT="$(read_pin motion.motion-enabled)"
    UEO="$(read_pin iocontrol.0.user-enable-out)"
    ESTOP_TEXT="$(rsh_get_estop s01base 2>/dev/null || true)"
    if is_true_value "$EXT" && is_true_value "$MOT" && grep -q 'ESTOP OFF' <<<"$ESTOP_TEXT"; then
        BASELINE_OK=1
        break
    fi
    sleep 0.05
done
printf 'baseline emc-enable-in=%s motion-enabled=%s user-enable-out=%s\n' "$EXT" "$MOT" "$UEO"
printf '%s\n' "$ESTOP_TEXT"
[[ "$BASELINE_OK" == 1 ]]
printf 'baseline-enabled=PASS\n'

printf '\n== Inject external E-stop condition ==\n'
date -u '+injection UTC: %Y-%m-%dT%H:%M:%SZ'
timeout 3s halcmd setp or2.0.in0 0
INJECT_OK=0
for _ in $(seq 1 100); do
    EXT="$(read_pin iocontrol.0.emc-enable-in)"
    MOT="$(read_pin motion.motion-enabled)"
    UEO="$(read_pin iocontrol.0.user-enable-out)"
    ESTOP_TEXT="$(rsh_get_estop s01fault 2>/dev/null || true)"
    if is_false_value "$EXT" && is_false_value "$MOT" && grep -q 'ESTOP ON' <<<"$ESTOP_TEXT"; then
        INJECT_OK=1
        break
    fi
    sleep 0.02
done
printf 'fault emc-enable-in=%s motion-enabled=%s user-enable-out=%s\n' "$EXT" "$MOT" "$UEO"
printf '%s\n' "$ESTOP_TEXT"
[[ "$INJECT_OK" == 1 ]]
printf 'external-estop-to-motion-disable=PASS\n'
printf 'user-enable-out-on-external-estop=%s (diagnostic only; not an acceptance mirror)\n' "$UEO"

printf '\n== Release external condition without Machine ON ==\n'
timeout 3s halcmd setp or2.0.in0 1
RELEASE_OK=0
for _ in $(seq 1 100); do
    EXT="$(read_pin iocontrol.0.emc-enable-in)"
    MOT="$(read_pin motion.motion-enabled)"
    ESTOP_TEXT="$(rsh_get_estop s01release 2>/dev/null || true)"
    if is_true_value "$EXT" && is_false_value "$MOT" && grep -q 'ESTOP OFF' <<<"$ESTOP_TEXT"; then
        RELEASE_OK=1
        break
    fi
    sleep 0.02
done
printf 'release emc-enable-in=%s motion-enabled=%s\n' "$EXT" "$MOT"
printf '%s\n' "$ESTOP_TEXT"
[[ "$RELEASE_OK" == 1 ]]
printf 'release-without-auto-motion-enable=PASS\n'

printf '\n== Final source wiring ==\n'
timeout 3s halcmd show sig s01-external-permissive

printf '\nS01 external E-stop software-boundary lab completed successfully.\n'
printf '%s\n' 'TEST scope if PASS: production LinuxCNC software controller-state transition in userspace simulation only.'
printf '%s\n' 'Explicit non-claim: no physical E-stop/STO/torque/stopping-time/functional-safety validation occurred.'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
