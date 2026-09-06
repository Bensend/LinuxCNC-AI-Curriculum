#!/usr/bin/env bash
set -euo pipefail
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-h04-order"

printf '== LinuxCNC H04 HAL execution-order lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Expected phase 1: sum2.0 before sum2.1 => B-A approximately +1\n'
printf 'Expected phase 2: sum2.1 before sum2.0 => A-B approximately +1\n'

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
cd ..
set +u
source scripts/rip-environment
set -u

cleanup() {
    trap - EXIT
    timeout --signal=TERM --kill-after=2s 5s halcmd stop >/dev/null 2>&1 || true
    timeout --signal=TERM --kill-after=2s 5s halcmd unload all >/dev/null 2>&1 || true
    timeout --signal=TERM --kill-after=2s 8s realtime stop >/dev/null 2>&1 || true
}
trap cleanup EXIT

realtime start
halcmd loadrt threads name1=h04-thread period1=10000000
halcmd loadrt sum2 count=2

printf '\n== Configure order-sensitive feedback network ==\n'
halcmd net h04-a sum2.0.out sum2.1.in0
halcmd net h04-b sum2.1.out sum2.0.in0
halcmd setp sum2.0.in1 1
halcmd setp sum2.1.in1 1

printf '\n== Phase 1: default -1 append order A then B ==\n'
halcmd addf sum2.0 h04-thread
halcmd addf sum2.1 h04-thread
halcmd show thread | tee /tmp/h04-thread-phase1.txt
A1_LINE="$(grep -n 'sum2\.0' /tmp/h04-thread-phase1.txt | head -1 | cut -d: -f1)"
B1_LINE="$(grep -n 'sum2\.1' /tmp/h04-thread-phase1.txt | head -1 | cut -d: -f1)"
printf 'phase1-lines: sum2.0=%s sum2.1=%s\n' "$A1_LINE" "$B1_LINE"
[[ "$A1_LINE" -lt "$B1_LINE" ]]

printf '\n== Duplicate non-reentrant add must fail ==\n'
set +e
halcmd addf sum2.0 h04-thread >/tmp/h04-dup.out 2>/tmp/h04-dup.err
DUP_RC=$?
set -e
printf 'duplicate-add-rc=%s\n' "$DUP_RC"
cat /tmp/h04-dup.err >&2 || true
[[ "$DUP_RC" -ne 0 ]]
grep -qi 'may only be added to one thread' /tmp/h04-dup.err

halcmd start
sleep 0.20
halcmd stop
sleep 0.05
A1="$(halcmd getp sum2.0.out | tr -d '[:space:]')"
B1="$(halcmd getp sum2.1.out | tr -d '[:space:]')"
BEAT1="$(halcmd getp h04-thread.threadbeat | tr -d '[:space:]')"
sleep 0.12
BEAT2="$(halcmd getp h04-thread.threadbeat | tr -d '[:space:]')"
printf 'phase1-values: A=%s B=%s B-A=%s\n' "$A1" "$B1" "$(awk -v a="$A1" -v b="$B1" 'BEGIN{printf "%.6f",b-a}')"
printf 'stopped-threadbeat: first=%s second=%s\n' "$BEAT1" "$BEAT2"
[[ "$BEAT1" == "$BEAT2" ]]
awk -v a="$A1" -v b="$B1" 'BEGIN { d=b-a; exit !(d>0.999 && d<1.001) }'

printf '\n== Phase 2: while stopped, delete B and re-add at +1 ==\n'
halcmd delf sum2.1 h04-thread
halcmd addf sum2.1 h04-thread 1
halcmd show thread | tee /tmp/h04-thread-phase2.txt
A2_LINE="$(grep -n 'sum2\.0' /tmp/h04-thread-phase2.txt | head -1 | cut -d: -f1)"
B2_LINE="$(grep -n 'sum2\.1' /tmp/h04-thread-phase2.txt | head -1 | cut -d: -f1)"
printf 'phase2-lines: sum2.0=%s sum2.1=%s\n' "$A2_LINE" "$B2_LINE"
[[ "$B2_LINE" -lt "$A2_LINE" ]]

printf '\n== Restart with reversed order ==\n'
halcmd start
sleep 0.20
halcmd stop
sleep 0.05
A2="$(halcmd getp sum2.0.out | tr -d '[:space:]')"
B2="$(halcmd getp sum2.1.out | tr -d '[:space:]')"
BEAT3="$(halcmd getp h04-thread.threadbeat | tr -d '[:space:]')"
printf 'phase2-values: A=%s B=%s A-B=%s threadbeat=%s\n' "$A2" "$B2" "$(awk -v a="$A2" -v b="$B2" 'BEGIN{printf "%.6f",a-b}')" "$BEAT3"
awk -v a="$A2" -v b="$B2" 'BEGIN { d=a-b; exit !(d>0.999 && d<1.001) }'
[[ "$BEAT3" =~ ^[0-9]+$ ]] && [[ "$BEAT3" -gt "$BEAT2" ]]

printf '\nH04 HAL execution-order observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
