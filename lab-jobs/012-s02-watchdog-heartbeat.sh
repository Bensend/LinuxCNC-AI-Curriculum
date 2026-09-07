#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-s02-watchdog"

printf '== LinuxCNC S02 generic watchdog heartbeat/freeze/re-arm lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Prediction: healthy transitions keep ok-out true; frozen heartbeat bites; resumed heartbeat alone cannot recover; enable FALSE->TRUE is required.'
printf '%s\n' 'Evidence boundary: production LinuxCNC HAL software behavior only; no physical watchdog, charge-pump, STO, stopping-time or functional-safety evidence.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
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
sudo make setcap
cd ..
set +u
source scripts/rip-environment
set -u
# Hosted-runner semantic test only. LinuxCNC labels this override testing-only;
# no production realtime latency/deadline or physical-machine claim is allowed.
export LINUXCNC_FORCE_REALTIME=1

cat >/tmp/s02-watchdog.hal <<'EOF'
loadrt threads name1=fast period1=1000000 fp1=0 name2=servo period2=10000000 fp2=1
loadrt watchdog num_inputs=1
loadrt estop_latch count=1
loadrt and2 count=1

addf watchdog.process fast
addf estop-latch.0 servo
addf and2.0 servo
addf watchdog.set-timeouts servo

setp watchdog.timeout-0 0.050
setp watchdog.enable-in 0
setp estop-latch.0.ok-in 1
setp estop-latch.0.fault-in 0
setp estop-latch.0.reset 0
setp and2.0.in1 1
net s02-heartbeat-raw estop-latch.0.watchdog => and2.0.in0
net s02-heartbeat-gated and2.0.out => watchdog.input-0
start
EOF

rm -f /tmp/s02-hal.stdout /tmp/s02-hal.stderr /tmp/s02-hal.stdin
mkfifo /tmp/s02-hal.stdin
# Hold a read/write descriptor open so halrun -I cannot see CI stdin EOF and
# tear the realtime environment down before the external halcmd probes attach.
exec 9<>/tmp/s02-hal.stdin
halrun -I -f /tmp/s02-watchdog.hal <&9 >/tmp/s02-hal.stdout 2>/tmp/s02-hal.stderr &
HALRUN_PID=$!
cleanup() {
    trap - EXIT
    exec 9>&- || true
    kill -TERM "$HALRUN_PID" 2>/dev/null || true
    for _ in $(seq 1 30); do
        if ! kill -0 "$HALRUN_PID" 2>/dev/null; then break; fi
        sleep 0.1
    done
    kill -KILL "$HALRUN_PID" 2>/dev/null || true
    wait "$HALRUN_PID" 2>/dev/null || true
    rm -f /tmp/s02-hal.stdin
}
trap cleanup EXIT

read_pin() { timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
is_true_value() { [[ "$1" == "TRUE" || "$1" == "1" ]]; }
is_false_value() { [[ "$1" == "FALSE" || "$1" == "0" ]]; }

printf '\n== Wait for HAL topology ==\n'
READY=0
for i in $(seq 1 100); do
    if timeout 3s halcmd show funct >/tmp/s02-funct.txt 2>/tmp/s02-probe.err \
       && grep -q 'watchdog.process' /tmp/s02-funct.txt \
       && grep -q 'watchdog.set-timeouts' /tmp/s02-funct.txt \
       && timeout 3s halcmd show thread >/tmp/s02-thread.txt 2>/tmp/s02-thread.err; then
        READY=1
        printf 'HAL ready at probe %s\n' "$i"
        break
    fi
    sleep 0.1
done
if [[ "$READY" != 1 ]]; then
    echo 'S02 HAL topology did not become ready.' >&2
    cat /tmp/s02-hal.stdout >&2 || true
    cat /tmp/s02-hal.stderr >&2 || true
    cat /tmp/s02-probe.err >&2 || true
    exit 2
fi
cat /tmp/s02-thread.txt
cat /tmp/s02-funct.txt

printf '\n== Gate 1: initially disabled ==\n'
V="$(read_pin watchdog.enable-in)"; O="$(read_pin watchdog.ok-out)"
printf 'enable=%s ok-out=%s\n' "$V" "$O"
is_false_value "$V" && is_false_value "$O"
printf 'initial-disabled=PASS\n'

printf '\n== Prepare heartbeat generator ==\n'
timeout 3s halcmd setp estop-latch.0.reset 1
sleep 0.04
timeout 3s halcmd setp estop-latch.0.reset 0
sleep 0.04
EOK="$(read_pin estop-latch.0.ok-out)"
is_true_value "$EOK"
printf 'estop-latch-heartbeat-source-ok=PASS\n'

printf '\n== Gate 2: arm on enable rising edge ==\n'
timeout 3s halcmd setp watchdog.enable-in 1
ARMED=0
for _ in $(seq 1 80); do
    O="$(read_pin watchdog.ok-out)"
    if is_true_value "$O"; then ARMED=1; break; fi
    sleep 0.005
done
printf 'armed ok-out=%s\n' "$O"
[[ "$ARMED" == 1 ]]
printf 'enable-rise-arms=PASS\n'

printf '\n== Gate 3: healthy heartbeat remains OK ==\n'
A="$(read_pin watchdog.input-0)"
sleep 0.035
B="$(read_pin watchdog.input-0)"
sleep 0.035
C="$(read_pin watchdog.input-0)"
O="$(read_pin watchdog.ok-out)"
printf 'heartbeat samples=%s,%s,%s ok-out=%s\n' "$A" "$B" "$C" "$O"
is_true_value "$O"
[[ "$A" != "$B" || "$B" != "$C" ]]
printf 'healthy-heartbeat=PASS\n'

printf '\n== Gate 4: freeze heartbeat and require bite ==\n'
timeout 3s halcmd setp and2.0.in1 0
FREEZE="$(read_pin watchdog.input-0)"
BIT=0
for _ in $(seq 1 100); do
    O="$(read_pin watchdog.ok-out)"
    if is_false_value "$O"; then BIT=1; break; fi
    sleep 0.005
done
printf 'frozen-input=%s bitten-ok-out=%s\n' "$FREEZE" "$O"
[[ "$BIT" == 1 ]]
printf 'freeze-causes-bite=PASS\n'

printf '\n== Gate 5: heartbeat resume alone must not re-arm ==\n'
timeout 3s halcmd setp and2.0.in1 1
sleep 0.12
O="$(read_pin watchdog.ok-out)"
printf 'post-resume-with-enable-still-high ok-out=%s\n' "$O"
is_false_value "$O"
printf 'resume-alone-does-not-rearm=PASS\n'

printf '\n== Gate 6: explicit enable FALSE->TRUE re-arms ==\n'
timeout 3s halcmd setp watchdog.enable-in 0
sleep 0.04
OLOW="$(read_pin watchdog.ok-out)"
timeout 3s halcmd setp watchdog.enable-in 1
REARM=0
for _ in $(seq 1 80); do
    O="$(read_pin watchdog.ok-out)"
    if is_true_value "$O"; then REARM=1; break; fi
    sleep 0.005
done
printf 'enable-low ok-out=%s; after rising edge ok-out=%s\n' "$OLOW" "$O"
[[ "$REARM" == 1 ]]
printf 'explicit-enable-cycle-rearms=PASS\n'

printf '\n== Final evidence ==\n'
timeout 3s halcmd show sig s02-heartbeat-raw
timeout 3s halcmd show sig s02-heartbeat-gated
timeout 3s halcmd show pin watchdog
printf 'S02 generic watchdog heartbeat lab completed successfully.\n'
printf '%s\n' 'TEST scope if PASS: generic HAL watchdog transition-timeout and explicit re-arm behavior at pinned revision in userspace software laboratory.'
printf '%s\n' 'Explicit non-claim: this hosted run used LinuxCNC testing-only FORCE_REALTIME; no production realtime latency, HostMot2 firmware bite, physical output state, STO or functional-safety validation occurred.'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
