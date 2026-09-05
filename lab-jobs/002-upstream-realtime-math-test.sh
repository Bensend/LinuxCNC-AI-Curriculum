#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
TEST_PATH="tests/realtime-math"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-curriculum-test"

printf '== LinuxCNC L02 representative upstream test lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf 'Selected upstream test: %s\n' "$TEST_PATH"
printf 'Prediction: the pinned uspace RIP build will run the upstream realtime-math test through scripts/runtests; halcompile will build/install rtmath.comp into the RIP environment, halrun will load it, checkresult will validate output, runtests will report 1 successful test, and no LinuxCNC/HAL shared-memory keys will remain afterward.\n'
printf 'Why this test: upstream README states that it verifies realtime math functions declared in rtapi_math.h are available at link time; it exercises halcompile + HAL/RTAPI loading without physical hardware.\n'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs

rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
printf 'Resolved commit: '; git rev-parse HEAD
printf 'VERSION: '; cat VERSION

printf '\n== Configure Debian metadata and install declared dependencies ==\n'
./debian/configure uspace
sudo apt-get build-dep -y .

printf '\n== Configure/build run-in-place userspace LinuxCNC ==\n'
cd src
./autogen.sh
./configure --with-realtime=uspace
make -j"$(nproc)"
cd ..

printf '\n== Enter RIP environment ==\n'
set +u
source scripts/rip-environment
set -u
command -v runtests
command -v halrun
command -v halcompile

printf '\n== Pre-test shared-memory state ==\n'
ipcs -m || true

printf '\n== Selected upstream test definition ==\n'
printf '%s/README:\n' "$TEST_PATH"
cat "$TEST_PATH/README"
printf '\n%s/test.sh:\n' "$TEST_PATH"
cat "$TEST_PATH/test.sh"

printf '\n== Execute through upstream runtests harness ==\n'
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

printf '\n== Post-test shared-memory state ==\n'
ipcs -m || true

# Clean harness-generated result files after capture; the workflow itself preserves stdout/stderr.
runtests -c "$TEST_PATH" || true

if [[ "$STATUS" -ne 0 ]]; then
  printf 'Representative upstream test FAILED with status %d.\n' "$STATUS" >&2
  exit "$STATUS"
fi

printf '\nRepresentative upstream test completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
