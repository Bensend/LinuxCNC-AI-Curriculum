#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-a01-topology"

printf '== LinuxCNC A01 runtime topology lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Prediction: a headless upstream linuxcncrsh simulation will expose linuxcncsvr and milltask as userspace processes, iocontrol.0 as a HAL component owned by Task rather than a standalone iocontrol process, and motmod/trivkins as loaded realtime HAL components.\n'
printf 'Evidence boundary: this observes process/component topology only. The GitHub runner is not realtime qualification.\n'

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
./configure --with-realtime=uspace
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

READY=0
for _ in $(seq 1 80); do
    if halcmd list comp >/tmp/a01-components.txt 2>/dev/null && grep -q 'iocontrol.0' /tmp/a01-components.txt; then
        READY=1
        break
    fi
    sleep 0.25
done
if [[ "$READY" != 1 ]]; then
    echo 'Topology did not become observable before timeout.' >&2
    cat topology-linuxcnc.stdout || true
    cat topology-linuxcnc.stderr >&2 || true
    exit 1
fi

printf '\n== Process snapshot ==\n'
ps -eo pid,ppid,stat,comm,args --forest | grep -E 'linuxcnc|milltask|rtapi|hal|motmod|trivkins' | grep -v grep || true

printf '\n== HAL components ==\n'
halcmd list comp

printf '\n== HAL functions ==\n'
halcmd list funct

printf '\n== Key component assertions ==\n'
halcmd list comp | grep -q 'iocontrol.0'
halcmd list comp | grep -q 'motmod'
halcmd list comp | grep -q 'trivkins'
if pgrep -x iocontrol >/dev/null 2>&1; then
    echo 'Unexpected standalone iocontrol process observed.' >&2
    pgrep -a -x iocontrol >&2 || true
    exit 2
fi
pgrep -a -x milltask
pgrep -a -x linuxcncsvr

printf '\nA01 topology observation completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
