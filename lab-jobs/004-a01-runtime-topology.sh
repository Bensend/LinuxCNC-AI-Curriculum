#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-a01-topology"
HAL_TIMEOUT="${HAL_TIMEOUT:-3}"

printf '== LinuxCNC A01 runtime topology lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Prediction: a headless upstream linuxcncrsh simulation will expose linuxcncsvr and milltask as userspace processes, iocontrol.0 as a HAL component owned by Task rather than a standalone iocontrol process, and motmod/trivkins as loaded realtime HAL components.\n'
printf 'Evidence boundary: this observes process/component topology only. The GitHub runner is not realtime qualification.\n'
printf 'Observation hardening: every halcmd probe is individually timeout-bounded and progress-marked; controller-process readiness is checked independently of HAL attachment.\n'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs
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
    kill -TERM "$LAUNCHER_PID" 2>/dev/null || true
    wait "$LAUNCHER_PID" 2>/dev/null || true
}
trap cleanup EXIT

printf '\n== Controller-process readiness ==\n'
PROC_READY=0
for i in $(seq 1 80); do
    if pgrep -x milltask >/dev/null 2>&1 && pgrep -x linuxcncsvr >/dev/null 2>&1; then
        PROC_READY=1
        printf 'process-readiness: ready at probe %s\n' "$i"
        break
    fi
    if (( i % 10 == 0 )); then
        printf 'process-readiness: probe %s not ready\n' "$i"
    fi
    sleep 0.25
done
if [[ "$PROC_READY" != 1 ]]; then
    echo 'Controller processes did not become observable before timeout.' >&2
    ps -eo pid,ppid,stat,comm,args --forest | grep -E 'linuxcnc|milltask|rtapi|hal|motmod|trivkins' | grep -v grep || true
    cat topology-linuxcnc.stdout || true
    cat topology-linuxcnc.stderr >&2 || true
    exit 1
fi

printf '\n== HAL readiness ==\n'
HAL_READY=0
for i in $(seq 1 80); do
    printf 'hal-readiness: before probe %s\n' "$i"
    set +e
    timeout --signal=TERM --kill-after=1s "${HAL_TIMEOUT}s" halcmd list comp > /tmp/a01-components.txt 2> /tmp/a01-halcmd.stderr
    HAL_RC=$?
    set -e
    printf 'hal-readiness: after probe %s rc=%s\n' "$i" "$HAL_RC"
    if [[ "$HAL_RC" == 0 ]] && grep -q 'iocontrol.0' /tmp/a01-components.txt; then
        HAL_READY=1
        break
    fi
    if [[ "$HAL_RC" == 124 || "$HAL_RC" == 137 ]]; then
        echo "halcmd list comp timed out at readiness probe $i" >&2
        cat /tmp/a01-halcmd.stderr >&2 || true
        printf '\n== Timeout process snapshot ==\n' >&2
        ps -eo pid,ppid,stat,comm,args --forest | grep -E 'linuxcnc|milltask|rtapi|hal|motmod|trivkins' | grep -v grep >&2 || true
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
    shift
    printf '%s: before\n' "$label"
    timeout --signal=TERM --kill-after=1s "${HAL_TIMEOUT}s" halcmd "$@"
    local rc=$?
    printf '%s: after rc=%s\n' "$label" "$rc"
    return "$rc"
}

printf '\n== Process snapshot ==\n'
ps -eo pid,ppid,stat,comm,args --forest | grep -E 'linuxcnc|milltask|rtapi|hal|motmod|trivkins' | grep -v grep || true

printf '\n== HAL components ==\n'
bounded_halcmd 'hal-list-comp' list comp

printf '\n== HAL functions ==\n'
bounded_halcmd 'hal-list-funct' list funct

printf '\n== Key component assertions ==\n'
bounded_halcmd 'assert-iocontrol-components' list comp > /tmp/a01-components-final.txt
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

printf '\nA01 topology observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
