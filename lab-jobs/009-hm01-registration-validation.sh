#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-hm01-registration"

printf '== LinuxCNC HM01 HostMot2 registration validation lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Prediction: the upstream no-hardware hm2-idrom suite will drive hm2_test through hm2_register() and reject each malformed test pattern with its predeclared diagnostic.'
printf '%s\n' 'Evidence boundary: validates fake-LLIO registration rejection/diagnostics only; no successful physical-board registration, Ethernet timing, realtime deadline, watchdog safety, or functional-safety claim.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"

printf '\n== Confirm pinned source/test vehicle ==\n'
printf 'git-head=%s\n' "$(git rev-parse HEAD)"
grep -F 'This is a test of the hm2_register() function' tests/hm2-idrom/README
grep -F 'does not talk to any hardware' src/hal/drivers/mesa-hostmot2/hm2_test.c
# Do not couple the harness to whitespace/local-variable spelling: prove the
# pinned fake LLIO driver contains an actual generic registration call.
grep -E 'hm2_register\([^;]+\);' src/hal/drivers/mesa-hostmot2/hm2_test.c

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

printf '\n== Run pinned upstream hm2-idrom rejection matrix ==\n'
cd tests/hm2-idrom
rm -f halrun-stdout halrun-stderr /tmp/hm01-upstream.out
./test.sh | tee /tmp/hm01-upstream.out

EXPECTED_PATTERNS=15
OBSERVED_PATTERNS="$(grep -c '^hm2/hm2_test\\.0:' /tmp/hm01-upstream.out || true)"
printf 'expected-patterns=%s observed-pattern-lines=%s\n' "$EXPECTED_PATTERNS" "$OBSERVED_PATTERNS"
[[ "$OBSERVED_PATTERNS" -eq "$EXPECTED_PATTERNS" ]]

grep -Eq '^hm2/hm2_test\\.0: invalid cookie$' /tmp/hm01-upstream.out
grep -Eq '^hm2/hm2_test\\.0: invalid config name$' /tmp/hm01-upstream.out
grep -Eq '^hm2/hm2_test\\.0: invalid IDROM type$' /tmp/hm01-upstream.out
grep -Eq '^hm2/hm2_test\\.0: invalid IDROM PortWidth' /tmp/hm01-upstream.out
grep -Eq '^hm2/hm2_test\\.0: IDROM ClockLow is' /tmp/hm01-upstream.out
grep -Eq '^hm2/hm2_test\\.0: IDROM ClockHigh is' /tmp/hm01-upstream.out
grep -Eq '^hm2/hm2_test\\.0: pin 0 primary tag is 0' /tmp/hm01-upstream.out

printf '\n== Adversarial single-case check: invalid cookie must fail registration ==\n'
export TEST_PATTERN=0
set +e
halrun -f broken-load-test.hal >/tmp/hm01-p0.stdout 2>/tmp/hm01-p0.stderr
P0_RC=$?
set -e
printf 'pattern0-halrun-rc=%s\n' "$P0_RC"
grep -F 'loading HostMot2 test driver with test pattern 0' /tmp/hm01-p0.stderr
grep -F 'invalid cookie' /tmp/hm01-p0.stderr
grep -F 'hm2_test fails HM2 registration' /tmp/hm01-p0.stderr
if grep -Eq 'hm2/hm2_test\\.0\.(read|write)([[:space:]]|$)' /tmp/hm01-p0.stderr; then
    echo 'Unexpected evidence of exported operational board-cycle function after rejected registration.' >&2
    exit 20
fi

printf '\nHM01 no-hardware registration rejection matrix completed successfully.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
