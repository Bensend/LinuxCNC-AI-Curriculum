# L02 — Representative Upstream Test Trace

Development revision: `8bf4605ae81042248add031e94c77300406e0413` (master / 2.10 prerelease baseline)

Selected test: `tests/realtime-math`

Laboratory job: `lab-jobs/002-upstream-realtime-math-test.sh`

Laboratory run: `33949095338`

## Why this test

LinuxCNC's official build documentation says that the test suite runs from a Run-In-Place (RIP) build. The official automated-test documentation says `scripts/runtests`, generated from `scripts/runtests.in`, recursively discovers `test`, `test.sh`, and `test.hal`, and may be limited to a selected test directory.

Official documentation:

- https://linuxcnc.org/docs/html/code/building-linuxcnc.html
- https://linuxcnc.org/docs/stable/html/code/writing-tests.html

The upstream `tests/README` at the pinned revision independently describes the tests as the HAL test suite, distinguishes regression versus functional tests, and says tests currently work with RIP builds. It also explains the `control` file restriction mechanism and the `-u` option for omitting tests requiring root/sudo.

`tests/realtime-math` is bounded, physical-hardware independent, and crosses several useful development boundaries without yet requiring a complete machine configuration.

## Upstream test anatomy

### `tests/realtime-math/README`

The upstream README states that the test verifies that all realtime math functions declared in `rtapi_math.h` are available at link time and should be kept synchronized with `src/rtapi/rtapi_math.h`.

Classification: **SOURCE-CONFIRMED**.

### `tests/realtime-math/test.sh`

The test performs two operations:

1. `${SUDO} halcompile --install rtmath.comp`
2. `halrun dotest.hal`

Therefore success requires both compilation/linking of the generated realtime component and successful HAL loading.

Classification: **SOURCE-CONFIRMED**.

### `tests/realtime-math/rtmath.comp`

The component includes `<rtapi_math.h>` and references realtime math interfaces including `sin`, `cos`, `tan`, `sqrt`, `fabs`, `atan`, `atan2`, `asin`, `acos`, `pow`, `round`, `ceil`, `floor`, `isnan`, `isinf`, `exp`, `fmod`, and `nan`. The component exports HAL pins and a function but this test does not exercise numerical correctness; it primarily proves that the generated realtime component can compile/link and then load.

Classification: **SOURCE-CONFIRMED**.

### `tests/realtime-math/dotest.hal`

The HAL file contains `loadrt rtmath`. Thus the second stage asks LinuxCNC's HAL/RTAPI loader to load the component produced by `halcompile`.

Classification: **SOURCE-CONFIRMED**.

### `tests/realtime-math/checkresult`

`checkresult` exits zero unconditionally and explicitly states that success/failure is determined by the return value of `test.sh`. Consequently the useful assertion is the successful build/install/load path itself, not output comparison.

Classification: **SOURCE-CONFIRMED**.

### `tests/realtime-math/control`

The file contains `Restrictions: sudo`. `scripts/runtests.in` checks this restriction only when invoked with its normal-user-only `-u` mode; without `-u`, the test is eligible to run. In a RIP build `runtests` does not itself populate `SUDO=sudo`, so the test's `${SUDO}` may be empty and `halcompile --install` targets the writable RIP development environment.

Classification: **SOURCE-CONFIRMED** for harness behavior at the pinned revision and **TEST-CONFIRMED** for this Actions RIP environment.

## Harness call flow for this experiment

`lab-jobs/002-upstream-realtime-math-test.sh`

→ clone exact LinuxCNC revision

→ `./debian/configure uspace`

→ install declared build dependencies

→ `src/autogen.sh`

→ `src/configure --with-realtime=uspace`

→ `make`

→ source `scripts/rip-environment`

→ `runtests -n -p tests/realtime-math`

→ `scripts/runtests` discovers `tests/realtime-math/test.sh`

→ `run_shell_script()` executes it under Bash

→ `halcompile --install rtmath.comp`

→ generated realtime component references interfaces from `rtapi_math.h`

→ `halrun dotest.hal`

→ `loadrt rtmath`

→ successful `test.sh` exit

→ `checkresult result`

→ harness checks/removes known LinuxCNC/HAL shared-memory keys

→ final runtests summary/exit status

## Pre-run prediction

Before run `33949095338` was launched, the recorded prediction was:

- the pinned uspace RIP build will compile again;
- `runtests` will discover exactly the selected upstream functional test;
- `halcompile` will compile/install `rtmath.comp`;
- `halrun` will successfully execute `loadrt rtmath`;
- `checkresult` will return zero;
- the harness will report one successful test and zero failures;
- no LinuxCNC/HAL shared-memory keys will remain after the test.

This prediction is intentionally stronger than merely predicting a zero workflow exit; it gives several observations that can disagree independently.

## Experiment result

Run `33949095338` completed successfully on the GitHub Actions Ubuntu 24.04 runner.

Observed evidence:

- the exact pinned development revision rebuilt successfully;
- `runtests -n -p tests/realtime-math` reported `1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped, 0 shmem errors`;
- `runtests` returned exit status `0`;
- the preserved result shows `halcompile` compiling `rtmath.c`, linking `rtmath.so`, and copying it into the RIP `rtlib` directory;
- the preserved shell trace shows `halcompile --install rtmath.comp` followed by `halrun dotest.hal`;
- pre-test and post-test `ipcs -m` output both contained no shared-memory segments;
- workflow job and laboratory job both completed successfully.

The main prediction therefore matched observation.

### Important discrepancy / execution-boundary finding

The test did **not** run under actual realtime scheduling. `halrun` reported that `sched_setscheduler(SCHED_FIFO)` was not permitted because the runner lacks `cap_sys_nice` and `cap_ipc_lock`, then explicitly fell back to POSIX non-realtime execution.

This does not invalidate the intended L02 assertion: the experiment proves the build/test harness, `halcompile`, RTAPI math linkability, HAL component loading, harness result handling, and shared-memory cleanup behavior in the curriculum's cloud software laboratory. It does **not** prove realtime scheduler behavior, latency, deadline performance, or physical-hardware suitability. Those belong to the realtime modules and/or controlled hardware testing.

Classification:

- **TEST-CONFIRMED**: representative upstream functional test runs successfully through the real `scripts/runtests` harness in the curriculum environment.
- **TEST-CONFIRMED**: `rtmath.comp` compiles/links and `loadrt rtmath` succeeds in POSIX non-realtime fallback mode.
- **TEST-CONFIRMED**: the selected run began and ended with no listed System V shared-memory segments and the harness reported zero shmem errors.
- **UNKNOWN / NOT TESTED HERE**: realtime scheduling behavior and realtime performance.

## Version-sensitive harness finding

Source comparison found that the pinned master `scripts/runtests.in` contains explicit LinuxCNC/HAL shared-memory cleanliness checks before the suite and after each test. The stable `v2.9.10` source at commit `86cdca76fa2a36274c432caa21952b23c267989a` does not contain that newer SHMERR cleanup/check path in the inspected harness implementation.

This is an example of why test-harness behavior must remain version-scoped rather than silently projected from master to stable.

Classification: **SOURCE-CONFIRMED**, development-vs-stable difference.

## Community lead

A LinuxCNC forum report from 2019 describes the same practical developer sequence: configure a uspace build, `make`, source `rip-environment`, and run `runtests`. This is useful corroborating field practice but is not implementation authority and is classified **COMMUNITY-REPORTED**.

- https://forum.linuxcnc.org/38-general-linuxcnc-questions/37889-python-script-importerror-no-module-named-linuxcnc

## Stable reference baseline discovered during this lesson

The official LinuxCNC site identifies **2.9.10** as the current stable release, while 2.10/master is prerelease/development documentation. Git tag `v2.9.10` dereferences to commit `86cdca76fa2a36274c432caa21952b23c267989a` (annotated tag object `4e7abeab3e764a42ef9def932333a1d4004e547b`).

This establishes the exact stable reference pin for L01. It has not yet been experimentally built by this curriculum, so its status is **DOC-CONFIRMED + SOURCE-CONFIRMED pin, not TEST-CONFIRMED**.

References:

- https://linuxcnc.org/
- https://linuxcnc.org/documents/
- https://github.com/LinuxCNC/linuxcnc/releases/tag/v2.9.10

## Next verification

1. Create a bounded stable-baseline build/test job for `v2.9.10` / commit `86cdca76fa2a36274c432caa21952b23c267989a` so L01 has experimentally reproducible stable and development pins.
2. Preserve stable-vs-master build/test-harness differences rather than assuming identical behavior.
3. Begin the adversarial exam/corrections pass for the Phase-0 laboratory/build/test material once the stable baseline is captured.
4. Do not use this POSIX-fallback experiment as evidence for R01/R02 realtime scheduling claims.
