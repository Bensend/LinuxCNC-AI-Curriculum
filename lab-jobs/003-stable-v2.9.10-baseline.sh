#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="86cdca76fa2a36274c432caa21952b23c267989a"
EXPECTED_TAG="v2.9.10"
TEST_PATH="tests/realtime-math"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-curriculum-stable"

printf '== LinuxCNC L01 stable v2.9.10 baseline lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned stable commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Expected release tag: %s\n' "$EXPECTED_TAG"
printf 'Selected upstream test: %s\n' "$TEST_PATH"
printf 'Prediction: the exact v2.9.10 commit will configure/build as a uspace RIP tree on the same Ubuntu runner used for the development baseline, then run upstream realtime-math through its own scripts/runtests harness with exit 0. Any build or harness incompatibility is evidence to preserve rather than mask.\n'
printf 'Comparison boundary: this job intentionally uses the stable checkout own build scripts, rip-environment, runtests, and test definition. It does not backport development-branch harness behavior.\n'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs

rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
printf 'Resolved commit: '; git rev-parse HEAD
printf 'Tags pointing at commit: '; git tag --points-at HEAD | tr '\n' ' '; printf '\n'
printf 'VERSION: '; cat VERSION

if ! git tag --points-at HEAD | grep -Fxq "$EXPECTED_TAG"; then
  printf 'Pinned commit is not tagged %s in this clone.\n' "$EXPECTED_TAG" >&2
  exit 11
fi

printf '\n== Stable harness identity ==\n'
printf 'scripts/runtests.in SHA256: '
sha256sum scripts/runtests.in
printf '%s/README SHA256: ' "$TEST_PATH"
sha256sum "$TEST_PATH/README"
printf '%s/test.sh SHA256: ' "$TEST_PATH"
sha256sum "$TEST_PATH/test.sh"

printf '\n== Configure Debian metadata and install declared dependencies ==\n'
./debian/configure uspace
sudo apt-get build-dep -y .

printf '\n== Configure/build run-in-place userspace LinuxCNC ==\n'
cd src
./autogen.sh
./configure --with-realtime=uspace
make -j"$(nproc)"
cd ..

printf '\n== Enter stable RIP environment ==\n'
# Upstream environment scripts contain optional variables and are not guaranteed
# to be nounset-clean. Restore strict mode immediately after sourcing.
set +u
source scripts/rip-environment
set -u
command -v linuxcnc
command -v halcmd
command -v halrun
command -v halcompile
command -v runtests
linuxcnc --version || true

printf '\n== Pre-test shared-memory state (observation only) ==\n'
ipcs -m || true

printf '\n== Selected stable upstream test definition ==\n'
printf '%s/README:\n' "$TEST_PATH"
cat "$TEST_PATH/README"
printf '\n%s/test.sh:\n' "$TEST_PATH"
cat "$TEST_PATH/test.sh"

printf '\n== Execute through stable upstream runtests harness ==\n'
set +e
runtests -n -p "$TEST_PATH"
STATUS=$?
set -e
printf 'runtests exit status: %d\n' "$STATUS"

printf '\n== Preserved per-test result ==\n'
if [[ -f "$TEST_PATH/result" ]]; then
  cat "$TEST_PATH/result"
else
  printf '(no result file preserved)\n'
fi
printf '\n== Preserved per-test stderr ==\n'
if [[ -f "$TEST_PATH/stderr" ]]; then
  cat "$TEST_PATH/stderr"
else
  printf '(no stderr file preserved)\n'
fi

printf '\n== Post-test shared-memory state (observation only) ==\n'
ipcs -m || true

runtests -c "$TEST_PATH" || true

if [[ "$STATUS" -ne 0 ]]; then
  printf 'Stable representative upstream test FAILED with status %d.\n' "$STATUS" >&2
  exit "$STATUS"
fi

printf '\nStable v2.9.10 baseline completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
