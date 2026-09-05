#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-a01-topology"
HAL_TIMEOUT="${HAL_TIMEOUT:-3}"

printf '== LinuxCNC A01 runtime topology lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Prediction: the upstream linuxcncrsh simulation will expose linuxcncsvr, milltask, and linuxcncrsh as userspace processes, iocontrol.0 as a HAL component owned by Task rather than a standalone iocontrol process, and motmod/trivkins as loaded realtime HAL components.\n'
printf 'Evidence boundary: this observes process/component topology only. The GitHub runner is not realtime qualification.\n'
printf 'Observation hardening: no external HAL query is issued until linuxcncsvr, milltask, and linuxcncrsh are all visible; every HAL probe is wall-clock bounded; a stalled probe is backtraced before forced termination so startup/registration can be distinguished from list-query locking.\n'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs gdb
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
rm -f /tmp/linuxcnc.lock
linuxcnc -r linuxcncrsh-test.ini > topology-linuxcnc.stdout 2> topology-linuxcnc.stderr &
LAUNCHER_PID=$!
cleanup() {
    trap - EXIT
    if kill -0 "$LAUNCHER_PID" 2>/dev/null; then
        kill -TERM "$LAUNCHER_PID" 2>/dev/null || true
        local i
        for i in $(seq 1 40); do
            if ! kill -0 "$LAUNCHER_PID" 2>/dev/null; then
                break
            fi
            sleep 0.1
        done
        if kill -0 "$LAUNCHER_PID" 2>/dev/null; then
            echo 'linuxcnc launcher did not exit after TERM; capturing teardown snapshot and forcing launcher exit.' >&2
            ps -eo pid,ppid,stat,wchan:32,etime,comm,args --forest | grep -E 'linuxcnc|milltask|rtapi|hal|motmod|trivkins' | grep -v grep >&2 || true
            kill -KILL "$LAUNCHER_PID" 2>/dev/null || true
        fi
    fi
    wait "$LAUNCHER_PID" 2>/dev/null || true
}
trap cleanup EXIT

printf '\n== Controller/display readiness ==\n'
SEEN_SERVER=0
SEEN_TASK=0
SEEN_DISPLAY=0
PROC_READY=0
for i in $(seq 1 240); do
    if [[ "$SEEN_SERVER" == 0 ]] && pgrep -x linuxcncsvr >/dev/null 2>&1; then
        SEEN_SERVER=1
        printf 'process-readiness: linuxcncsvr visible at probe %s\n' "$i"
    fi
    if [[ "$SEEN_TASK" == 0 ]] && pgrep -x milltask >/dev/null 2>&1; then
        SEEN_TASK=1
        printf 'process-readiness: milltask visible at probe %s\n' "$i"
    fi
    if [[ "$SEEN_DISPLAY" == 0 ]] && pgrep -x linuxcncrsh >/dev/null 2>&1; then
        SEEN_DISPLAY=1
        printf 'process-readiness: linuxcncrsh visible at probe %s\n' "$i"
    fi
    if [[ "$SEEN_SERVER" == 1 && "$SEEN_TASK" == 1 && "$SEEN_DISPLAY" == 1 ]]; then
        PROC_READY=1
        printf 'process-readiness: all required processes visible at probe %s\n' "$i"
        break
    fi
    if (( i % 20 == 0 )); then
        printf 'process-readiness: probe %s server=%s task=%s display=%s\n' "$i" "$SEEN_SERVER" "$SEEN_TASK" "$SEEN_DISPLAY"
    fi
    sleep 0.25
done
if [[ "$PROC_READY" != 1 ]]; then
    echo 'Controller/display phase did not become observable before timeout; no external HAL probe was issued.' >&2
    printf 'readiness-final: server=%s task=%s display=%s\n' "$SEEN_SERVER" "$SEEN_TASK" "$SEEN_DISPLAY" >&2
    ps -eo pid,ppid,stat,wchan:32,etime,comm,args --forest | grep -E 'linuxcnc|milltask|rtapi|hal|motmod|trivkins' | grep -v grep >&2 || true
    printf '\n== linuxcnc stdout ==\n' >&2
    cat topology-linuxcnc.stdout >&2 || true
    printf '\n== linuxcnc stderr ==\n' >&2
    cat topology-linuxcnc.stderr >&2 || true
    exit 1
fi

capture_halcmd_backtrace() {
    local pid="$1"
    local label="$2"
    local trace="/tmp/a01-${label}-gdb.txt"
    printf '%s: stalled pid=%s; capturing process state and gdb backtrace\n' "$label" "$pid" >&2
    ps -o pid,ppid,stat,wchan:32,etime,comm,args -p "$pid" >&2 || true
    cat "/proc/$pid/status" >&2 2>/dev/null || true
    sudo timeout --signal=TERM --kill-after=1s 6s gdb -q -nx -batch \
        -ex 'set pagination off' \
        -ex 'thread apply all bt' \
        -p "$pid" > "$trace" 2>&1 || true
    printf '%s: gdb backtrace follows\n' "$label" >&2
    cat "$trace" >&2 || true
}

bounded_halcmd_capture() {
    local label="$1"
    local stdout_file="$2"
    local stderr_file="$3"
    shift 3
    printf '%s: before\n' "$label" >&2
    halcmd "$@" > "$stdout_file" 2> "$stderr_file" &
    local pid=$!
    local ticks=$(( HAL_TIMEOUT * 20 ))
    local i
    for i in $(seq 1 "$ticks"); do
        if ! kill -0 "$pid" 2>/dev/null; then
            local rc
            if wait "$pid"; then
                rc=0
            else
                rc=$?
            fi
            printf '%s: after rc=%s\n' "$label" "$rc" >&2
            return "$rc"
        fi
        sleep 0.05
    done

    capture_halcmd_backtrace "$pid" "$label"
    kill -TERM "$pid" 2>/dev/null || true
    for i in $(seq 1 20); do
        if ! kill -0 "$pid" 2>/dev/null; then
            break
        fi
        sleep 0.05
    done
    kill -KILL "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    printf '%s: after rc=124 (monitor timeout)\n' "$label" >&2
    return 124
}

printf '\n== HAL readiness ==\n'
HAL_READY=0
for i in $(seq 1 80); do
    printf 'hal-readiness: before probe %s\n' "$i"
    if bounded_halcmd_capture "hal-readiness-${i}" /tmp/a01-components.txt /tmp/a01-halcmd.stderr list comp; then
        HAL_RC=0
    else
        HAL_RC=$?
    fi
    printf 'hal-readiness: after probe %s rc=%s\n' "$i" "$HAL_RC"
    if [[ "$HAL_RC" == 0 ]] && grep -q 'iocontrol.0' /tmp/a01-components.txt; then
        HAL_READY=1
        break
    fi
    if [[ "$HAL_RC" == 124 ]]; then
        echo "halcmd list comp timed out at readiness probe $i" >&2
        cat /tmp/a01-halcmd.stderr >&2 || true
        printf '\n== Timeout process snapshot ==\n' >&2
        ps -eo pid,ppid,stat,wchan:32,etime,comm,args --forest | grep -E 'linuxcnc|milltask|rtapi|hal|motmod|trivkins' | grep -v grep >&2 || true
        printf '\n== linuxcnc stdout ==\n' >&2
        cat topology-linuxcnc.stdout >&2 || true
        printf '\n== linuxcnc stderr ==\n' >&2
        cat topology-linuxcnc.stderr >&2 || true
        exit 3
    fi
    sleep 0.25
done
if [[ "$HAL_READY" != 1 ]]; then
    echo 'HAL topology did not become observable before bounded readiness window.' >&2
    cat /tmp/a01-components.txt >&2 || true
    cat /tmp/a01-halcmd.stderr >&2 || true
    exit 4
fi

bounded_halcmd() {
    local label="$1"
    local stdout_file="$2"
    shift 2
    local stderr_file="/tmp/a01-${label}.stderr"
    local rc
    if bounded_halcmd_capture "$label" "$stdout_file" "$stderr_file" "$@"; then
        rc=0
    else
        rc=$?
    fi
    if [[ -s "$stdout_file" ]]; then
        cat "$stdout_file"
    fi
    if [[ -s "$stderr_file" ]]; then
        cat "$stderr_file" >&2
    fi
    return "$rc"
}

printf '\n== Process snapshot ==\n'
ps -eo pid,ppid,stat,comm,args --forest | grep -E 'linuxcnc|milltask|rtapi|hal|motmod|trivkins' | grep -v grep || true

printf '\n== HAL components ==\n'
bounded_halcmd 'hal-list-comp' /tmp/a01-list-comp.txt list comp

printf '\n== HAL functions ==\n'
bounded_halcmd 'hal-list-funct' /tmp/a01-list-funct.txt list funct

printf '\n== Key component assertions ==\n'
if bounded_halcmd_capture 'assert-iocontrol-components' /tmp/a01-components-final.txt /tmp/a01-assert.stderr list comp; then
    ASSERT_RC=0
else
    ASSERT_RC=$?
fi
cat /tmp/a01-assert.stderr >&2 || true
if [[ "$ASSERT_RC" != 0 ]]; then
    exit "$ASSERT_RC"
fi
grep -q 'iocontrol.0' /tmp/a01-components-final.txt
grep -q 'motmod' /tmp/a01-components-final.txt
grep -q 'trivkins' /tmp/a01-components-final.txt
if pgrep -x iocontrol >/dev/null 2>&1; then
    echo 'Unexpected standalone iocontrol process observed.' >&2
    pgrep -a -x iocontrol >&2 || true
    exit 2
fi
pgrep -a -x milltask
pgrep -a -x linuxcncsvr
pgrep -a -x linuxcncrsh

printf '\nA01 topology observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
