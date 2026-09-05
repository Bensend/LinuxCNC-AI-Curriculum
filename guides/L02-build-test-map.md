# L02 — LinuxCNC Repository / Build / Test Map

Development revision studied: `8bf4605ae81042248add031e94c77300406e0413` (`master`, pinned by L01 lab).

Stable reference: `v2.9.10` → commit `86cdca76fa2a36274c432caa21952b23c267989a`, experimentally built/tested in run `33952061943`.

## Reproducible build evidence

`lab-jobs/001-build-linuxcnc.sh` completed successfully in GitHub Actions run `33943964198` on Ubuntu 24.04 uspace. The preserved artifact reports:

- Debian metadata configured for `uspace-Ubuntu-24.04`.
- `src/configure` completed successfully.
- `make` completed and produced the run-in-place tree.
- `scripts/linuxcnc`, `bin/halcmd`, and `scripts/runtests` resolved from that run-in-place tree after sourcing `scripts/rip-environment`.
- The job exited `0`.
- Build-lab wall time was about 4m06s (04:13:16Z–04:17:22Z).

This converts the development source pin from merely cloneable to experimentally buildable in the curriculum's cloud environment.

The stable `v2.9.10` baseline independently configured/built in run `33952061943`, using the stable checkout's own build metadata and scripts. That run also exited `0`, giving L01/L02 a reproducible stable-release comparison rather than only a source pin.

## Top-level build shape

`src/Makefile` says the default target is `build-software`. For a userspace build, `build-software` depends on `headers userspace modules`. In a run-in-place uspace build it may warn that `sudo make setuid` or `sudo make setcap` is required for hardware/realtime privileges; that warning does not mean the software build failed.

The Makefile assembles the build from many `Submakefile` fragments. Its `SUBDIRS` ordering provides a useful first repository map:

- `libposemath` — pose/math support
- `libnml` — NML infrastructure
- `rtapi` — realtime abstraction and examples
- `hal/components`, `hal/drivers`, `hal/user_comps`, `hal/utils` — HAL components, hardware drivers, userspace components and tools
- `emc/usr_intf` — operator interfaces
- `emc/nml_intf` — EMC/LinuxCNC message interfaces
- `emc/task` — task layer
- `emc/kinematics` — kinematics
- `emc/rs274ngc` — interpreter
- `emc/motion*` — motion-related implementation
- `tests` — integrated test definitions

This is a build-oriented map, not yet an architecture boundary map; A01 must establish runtime process/component boundaries from source and experiments.

## Test harness

The generated `scripts/runtests` comes from `scripts/runtests.in`. Source inspection at the pinned development revision establishes:

1. It enables `pipefail`, unsets `DISPLAY`, and fixes locale to reduce non-interactive/locale variability.
2. In run-in-place mode it sources `scripts/rip-environment` and points test headers/libraries at the source tree.
3. Tests are discovered as files named `test.hal`, `test.sh`, or `test` beneath supplied paths.
4. `.hal` tests execute via `halrun -f`; `.sh` tests execute via Bash; other tests execute directly.
5. HAL tests have special overrun handling: an `overrun` result causes retries up to ten attempts.
6. The development harness checks for stale LinuxCNC/HAL shared-memory keys before testing and after each test because leftover state can invalidate later tests.
7. Supported modes include ordinary path execution, cleanup (`-c`), user-only selection (`-u`), verbose output (`-v`), and crash-dump collection (`-d`).

The stable `v2.9.10` harness at commit `86cdca76fa2a36274c432caa21952b23c267989a` uses the same broad discovery/dispatch model for `test.hal`, `test.sh`, and executable `test`, including the `.hal` overrun retry branch and `wait_for_result_close()`. It predates the explicit `SHMERR` recognized-key pre/post cleanup path seen on the pinned development revision, and its summary ends after the skipped count.

Treat harness cleanup and output formats as version-sensitive. The human-readable summary is not a stable machine API.

## Representative upstream test — development `002`

`lab-jobs/002-upstream-realtime-math-test.sh` executed upstream `tests/realtime-math` through the real development `scripts/runtests` harness in Actions run `33949095338`.

The test path is useful because upstream describes it as verifying that realtime math functions declared in `rtapi_math.h` are available at link time. Its `test.sh` runs `halcompile --install rtmath.comp` and then `halrun dotest.hal`; `dotest.hal` performs `loadrt rtmath`.

Observed result:

- `Runtest: 1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped, 0 shmem errors`.
- `runtests exit status: 0`.
- `halcompile` compiled `rtmath.c`, linked `rtmath.so`, and copied it into the RIP `rtlib` directory.
- `halrun` then executed the HAL file successfully.
- Both the pre-test and post-test `ipcs -m` snapshots listed no System V shared-memory segments.

The detailed trace and prediction-vs-observation record are in `guides/L02-representative-test.md`.

## Stable comparison — `003`

`lab-jobs/003-stable-v2.9.10-baseline.sh` ran the corresponding stable checkout's own `tests/realtime-math` through the stable checkout's own `scripts/runtests` in Actions run `33952061943`.

Observed result:

- exact stable checkout: `86cdca76fa2a36274c432caa21952b23c267989a` / `v2.9.10`;
- `Runtest: 1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped`;
- `runtests exit status: 0`;
- `halcompile` compiled/linked `rtmath.so` into the stable RIP `rtlib`;
- `halrun dotest.hal` succeeded;
- stable emitted `Note: Using POSIX non-realtime`;
- wrapper post-test `ipcs -m` observation was clean.

This is intentionally not normalized to the development summary. The absence of `0 shmem errors` is expected from the stable harness source and is itself useful compatibility evidence.

## Critical limitation of both experiments

The GitHub Actions runner does not provide the privileges needed to establish genuine LinuxCNC realtime scheduling. Development explicitly reported inability to use `SCHED_FIFO` and fallback to POSIX non-realtime; stable likewise reported POSIX non-realtime operation.

Therefore experiments `002` and `003` validate build/test machinery, `halcompile`, RTAPI math symbol linkability, HAL component loading, selected harness behavior, and version-comparison reproducibility in a software lab. They are **not** evidence about actual realtime scheduling, latency, deadline behavior, deterministic servo execution, or machine-hardware suitability.

## Important laboratory lessons

### Upstream environment contracts

The curriculum wrapper uses strict Bash mode, but upstream `rip-environment` does not promise `set -u` compatibility. The lab temporarily disables nounset only while sourcing that script and restores it immediately. This is an environment-contract boundary, not a LinuxCNC compile defect.

### Preserve native version behavior

Cross-version experiments must use each revision's own build scripts, harness, and test definitions. Copying the development harness into stable would erase exactly the compatibility differences L01 is meant to detect.

### Separate observation from mechanism

A clean post-test `ipcs -m` snapshot in stable proves only that no segment remained after this bounded run. It does not prove the stable harness contains or provides the development harness's explicit recognized-key cleanup mechanism.

## Evidence classifications

- `TEST-CONFIRMED`: pinned development revision configures and compiles successfully on the current GitHub Actions Ubuntu 24.04 runner; RIP tools resolve; job exits 0.
- `TEST-CONFIRMED`: pinned stable v2.9.10 revision configures/builds and its representative `tests/realtime-math` passes 1/1, exit 0, in POSIX non-realtime mode.
- `TEST-CONFIRMED`: development representative `tests/realtime-math` passes 1/1 with zero harness-reported shmem errors in POSIX non-realtime fallback mode.
- `SOURCE-CONFIRMED`: default/userspace target relationships and source-directory inclusion are defined in `src/Makefile`.
- `SOURCE-CONFIRMED`: development and stable harnesses share basic test discovery/dispatch behavior but differ in the inspected explicit shared-memory hygiene path and summary format.
- `UNKNOWN`: how much of the full upstream test suite is stable/appropriate for this curriculum runner without realtime privileges.
- `NOT TESTED HERE`: genuine realtime scheduling and timing behavior.

## Phase-0 correction result

The stable experiment did not contradict the prior source model. It experimentally demonstrated the exact version-sensitive output difference used by the adversarial exam: stable passes without the development `shmem errors` summary field. The correction is therefore not to make the two versions look alike, but to make the guide explicitly warn that harness text output and cleanup mechanisms are revision-scoped.

## Next checkpoint

Use the completed stable/development evidence in the Phase-0 fresh-AI handoff/graduation record. Once L00-L03 are explicitly graduated, move to A01 and build a runtime architecture map rather than extending this build-oriented repository map into unsupported process-boundary claims.
