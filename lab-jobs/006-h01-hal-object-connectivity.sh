#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-h01-hal"

printf '== LinuxCNC H01 HAL object/connectivity lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Prediction 1: a newly linked scalar pin contributes its current dummy/default value to an otherwise undriven signal; changing the signal then changes the linked pin.\n'
printf 'Prediction 2: unlink snapshots the current signal value into the pin dummy; later signal changes no longer change that pin.\n'
printf 'Prediction 3: a second HAL_OUT writer on the same signal is rejected.\n'
printf 'Prediction 4: export and addf are separate object-model steps; after addf, or2.0 appears in h01-thread and the thread executes.\n'
printf 'Boundary: this is object/connectivity evidence on a pinned uspace simulation, not physical I/O, realtime qualification, or functional-safety evidence.\n'

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

printf '\n== Load object providers ==\n'
halcmd loadrt or2 count=2
halcmd loadrt threads name1=h01-thread period1=1000000
halcmd show comp | tee /tmp/h01-comp.txt
halcmd show pin 'or2.*' | tee /tmp/h01-pins.txt
halcmd show funct | tee /tmp/h01-functs-before.txt

grep -q 'or2.0' /tmp/h01-functs-before.txt
grep -q 'or2.1' /tmp/h01-functs-before.txt

printf '\n== Pin dummy -> signal pointer behavior ==\n'
halcmd setp or2.0.in0 TRUE
PRE_LINK="$(halcmd getp or2.0.in0 | tr -d '[:space:]')"
printf 'pre-link-pin=%s\n' "$PRE_LINK"
[[ "$PRE_LINK" == "TRUE" || "$PRE_LINK" == "1" ]]

halcmd net h01-scalar or2.0.in0
LINKED_PIN="$(halcmd getp or2.0.in0 | tr -d '[:space:]')"
LINKED_SIG="$(halcmd gets h01-scalar | tr -d '[:space:]')"
printf 'after-link-pin=%s signal=%s\n' "$LINKED_PIN" "$LINKED_SIG"
[[ "$LINKED_PIN" == "TRUE" || "$LINKED_PIN" == "1" ]]
[[ "$LINKED_SIG" == "TRUE" || "$LINKED_SIG" == "1" ]]

halcmd sets h01-scalar FALSE
LINKED_AFTER_SET="$(halcmd getp or2.0.in0 | tr -d '[:space:]')"
printf 'linked-pin-after-signal-false=%s\n' "$LINKED_AFTER_SET"
[[ "$LINKED_AFTER_SET" == "FALSE" || "$LINKED_AFTER_SET" == "0" ]]

halcmd unlinkp or2.0.in0
UNLINK_SNAPSHOT="$(halcmd getp or2.0.in0 | tr -d '[:space:]')"
halcmd sets h01-scalar TRUE
UNLINK_AFTER_SIG_CHANGE="$(halcmd getp or2.0.in0 | tr -d '[:space:]')"
SIG_AFTER_UNLINK="$(halcmd gets h01-scalar | tr -d '[:space:]')"
printf 'unlink-snapshot=%s pin-after-signal-change=%s signal-after-change=%s\n' "$UNLINK_SNAPSHOT" "$UNLINK_AFTER_SIG_CHANGE" "$SIG_AFTER_UNLINK"
[[ "$UNLINK_SNAPSHOT" == "FALSE" || "$UNLINK_SNAPSHOT" == "0" ]]
[[ "$UNLINK_AFTER_SIG_CHANGE" == "FALSE" || "$UNLINK_AFTER_SIG_CHANGE" == "0" ]]
[[ "$SIG_AFTER_UNLINK" == "TRUE" || "$SIG_AFTER_UNLINK" == "1" ]]

printf '\n== Single-writer invariant ==\n'
halcmd net h01-writer or2.0.out
set +e
halcmd net h01-writer or2.1.out >/tmp/h01-second-writer.out 2>/tmp/h01-second-writer.err
SECOND_WRITER_RC=$?
set -e
printf 'second-writer-rc=%s\n' "$SECOND_WRITER_RC"
cat /tmp/h01-second-writer.out
cat /tmp/h01-second-writer.err >&2 || true
if [[ "$SECOND_WRITER_RC" -eq 0 ]]; then
    echo 'Unexpected: second HAL_OUT writer was accepted.' >&2
    exit 20
fi
if ! grep -qiE 'already has output|already.*out|output.*pin' /tmp/h01-second-writer.out /tmp/h01-second-writer.err; then
    echo 'Second writer failed, but not with an identifiable writer-conflict diagnostic.' >&2
    exit 21
fi

printf '\n== Exported function -> addf scheduling link ==\n'
halcmd addf or2.0 h01-thread
halcmd show thread | tee /tmp/h01-thread.txt
grep -q 'h01-thread' /tmp/h01-thread.txt
grep -q 'or2.0' /tmp/h01-thread.txt

halcmd start
sleep 0.25
THREADBEAT="$(halcmd getp h01-thread.threadbeat | tr -d '[:space:]')"
printf 'h01-thread-threadbeat=%s\n' "$THREADBEAT"
if ! [[ "$THREADBEAT" =~ ^[0-9]+$ ]] || [[ "$THREADBEAT" -le 0 ]]; then
    echo 'Expected h01-thread.threadbeat to advance after starting HAL threads.' >&2
    exit 22
fi

printf '\n== Final HAL evidence ==\n'
halcmd show sig h01-scalar | tee /tmp/h01-final-signal.txt
halcmd show funct or2.0 | tee /tmp/h01-final-funct.txt

printf '\nH01 HAL object/connectivity observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
