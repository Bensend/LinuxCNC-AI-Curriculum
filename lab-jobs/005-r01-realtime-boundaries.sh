#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-r01-realtime"

printf '== LinuxCNC R01 realtime-boundary lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Prediction: an ordinary GitHub Actions host/build without installed rtapi_app privileges will select POSIX non-realtime, and created HAL periodic pthreads will report ordinary/SCHED_OTHER scheduling rather than FIFO.\n'
printf 'Period prediction: requested 1000000 ns and 2000000 ns HAL threads will report those exact periods because the first requested period becomes the uspace POSIX base period and the second is an integer multiple.\n'
printf 'Evidence boundary: this lab verifies selection/runtime state only. It does NOT qualify GitHub Actions latency or any physical-machine realtime suitability.\n'

printf '\n== Host pre-state ==\n'
uname -a
printf 'uid/euid: '; id
printf 'RTPRIO limit: '; ulimit -r || true
printf 'MEMLOCK limit (KiB): '; ulimit -l || true
if command -v capsh >/dev/null 2>&1; then capsh --print || true; fi

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs libcap2-bin procps
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

printf '\n== Built rtapi_app privilege state ==\n'
command -v rtapi_app
getcap "$(command -v rtapi_app)" || true
ls -l "$(command -v rtapi_app)"

printf '\n== Realtime capability classification ==\n'
set +e
realtime check > /tmp/r01-realtime-check.out 2> /tmp/r01-realtime-check.err
CHECK_RC=$?
set -e
printf 'realtime-check-rc=%s\n' "$CHECK_RC"
cat /tmp/r01-realtime-check.out
cat /tmp/r01-realtime-check.err >&2 || true

# An ordinary Actions environment is expected to fail the realtime-capability
# check. Fail closed if the environment unexpectedly has realtime capability;
# a different observation needs separate interpretation, not silent acceptance.
if [[ "$CHECK_RC" -eq 0 ]]; then
    echo 'Unexpected: host reported realtime capability. Refusing to reuse the non-realtime prediction.' >&2
    exit 10
fi
if ! grep -qiE 'No realtime|realtime scheduling unavailable|non-realtime' /tmp/r01-realtime-check.out /tmp/r01-realtime-check.err; then
    echo 'Expected an explicit non-realtime classification message.' >&2
    exit 11
fi

cleanup() {
    trap - EXIT
    halcmd stop >/dev/null 2>&1 || true
    halcmd unload all >/dev/null 2>&1 || true
    timeout --signal=TERM --kill-after=2s 8s realtime stop >/dev/null 2>&1 || true
}
trap cleanup EXIT

printf '\n== Start RTAPI environment ==\n'
realtime start > /tmp/r01-realtime-start.out 2> /tmp/r01-realtime-start.err
cat /tmp/r01-realtime-start.out
cat /tmp/r01-realtime-start.err >&2 || true

printf '\n== Load two periodic HAL threads ==\n'
halcmd loadrt threads name1=r01fast period1=1000000 name2=r01slow period2=2000000
halcmd start
sleep 0.5

printf '\n== HAL thread report ==\n'
halcmd show thread | tee /tmp/r01-hal-threads.txt

# `show thread` output format varies slightly by release; assert names and
# requested periods independently instead of depending on a fixed column index.
grep -q 'r01fast' /tmp/r01-hal-threads.txt
grep -q 'r01slow' /tmp/r01-hal-threads.txt
grep -Eq '1000000|1[.]000[[:space:]]*ms' /tmp/r01-hal-threads.txt
grep -Eq '2000000|2[.]000[[:space:]]*ms' /tmp/r01-hal-threads.txt

printf '\n== rtapi_app process/thread scheduler snapshot ==\n'
mapfile -t RTAPI_PIDS < <(pgrep -x rtapi_app)
if [[ "${#RTAPI_PIDS[@]}" -ne 1 ]]; then
    echo "Expected exactly one rtapi_app master, found ${#RTAPI_PIDS[@]}." >&2
    pgrep -a -x rtapi_app >&2 || true
    exit 12
fi
RTAPI_PID="${RTAPI_PIDS[0]}"
printf 'rtapi_app-pid=%s\n' "$RTAPI_PID"
ps -L -p "$RTAPI_PID" -o pid=,tid=,cls=,rtprio=,pri=,psr=,stat=,comm= | tee /tmp/r01-scheduler.txt

# Rtapi periodic pthread names are set to rtapi_app:T#<id>. Find at least the
# two task threads and require ordinary time-sharing scheduling on this
# predeclared non-realtime path. `ps` class may render SCHED_OTHER as TS/OTHER.
mapfile -t TASK_ROWS < <(grep 'rtapi_app:T#' /tmp/r01-scheduler.txt || true)
if [[ "${#TASK_ROWS[@]}" -lt 2 ]]; then
    echo 'Expected at least two RTAPI task pthread rows.' >&2
    cat /tmp/r01-scheduler.txt >&2
    exit 13
fi
if printf '%s\n' "${TASK_ROWS[@]}" | awk '{print $3}' | grep -qE '^(FF|FIFO|RR)$'; then
    echo 'Unexpected FIFO/RR task scheduling after non-realtime classification.' >&2
    printf '%s\n' "${TASK_ROWS[@]}" >&2
    exit 14
fi
printf 'scheduler-assertion: periodic RTAPI task pthreads are non-FIFO on the predicted fallback path\n'

printf '\n== Memory-hardening diagnostics captured from rtapi_app start ==\n'
if grep -qi 'mlockall failed' /tmp/r01-realtime-start.err; then
    echo 'memory-lock-observation: rtapi_app reported mlockall failure (warning path)'
else
    echo 'memory-lock-observation: no mlockall failure was emitted; do not infer lock success without independent evidence'
fi

printf '\nR01 realtime-boundary observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
