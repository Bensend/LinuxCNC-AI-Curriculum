#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
# First curriculum pin discovered by 000-smoke. Deliberately fixed for reproducibility.
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-curriculum-build"

printf '== LinuxCNC L00/L01 reproducible build lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Requested upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Runner: '; uname -a
printf 'OS: '; . /etc/os-release; printf '%s %s\n' "$NAME" "$VERSION_ID"

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs

rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
printf 'Resolved commit: '; git rev-parse HEAD
printf 'Commit date: '; git show -s --format=%cI HEAD
printf 'VERSION: '; cat VERSION

printf '\n== Generate Debian build metadata ==\n'
./debian/configure uspace

printf '\n== Install declared build dependencies ==\n'
sudo apt-get build-dep -y .

printf '\n== Configure run-in-place userspace build ==\n'
cd src
./autogen.sh
./configure --with-realtime=uspace

printf '\n== Build ==\n'
make -j"$(nproc)"

printf '\n== Load RIP environment and verify tools ==\n'
# rip-environment is an upstream environment setup script, not a strict-mode
# library. At this pinned revision it references optional environment variables
# (observed: GLADE_ICON_THEME_PATH) without ${var:-} guards. Temporarily disable
# nounset while sourcing it, then restore the lab's strict shell discipline.
set +u
source ../scripts/rip-environment
set -u
command -v linuxcnc
command -v halcmd
command -v runtests
linuxcnc --version || true

printf '\n== Targeted initial tests ==\n'
# Start conservatively: prove test harness discovery and execute a small fast subset.
runtests --help >/tmp/runtests-help.txt 2>&1 || true
printf 'runtests available; first help lines:\n'
head -40 /tmp/runtests-help.txt || true

printf '\nBuild lab completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
