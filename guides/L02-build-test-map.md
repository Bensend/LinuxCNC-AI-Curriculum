# L02 — LinuxCNC Repository / Build / Test Map

Development revision studied: `8bf4605ae81042248add031e94c77300406e0413` (`master`, pinned by L01 lab).

Stable reference identified: `v2.9.10` → commit `86cdca76fa2a36274c432caa21952b23c267989a` (not yet experimentally built by this curriculum).

## Reproducible build evidence

`lab-jobs/001-build-linuxcnc.sh` completed successfully in GitHub Actions run `33943964198` on Ubuntu 24.04 uspace. The preserved artifact reports:

- Debian metadata configured for `uspace-Ubuntu-24.04`.
- `src/configure` completed successfully.
- `make` completed and produced the run-in-place tree.
- `scripts/linuxcnc`, `bin/halcmd`, and `scripts/runtests` resolved from that run-in-place tree after sourcing `scripts/rip-environment`.
- The job exited `0`.
- Build-lab wall time was about 4m06s (04:13:16Z–04:17:22Z).

This converts the development source pin from merely cloneable to experimentally buildable in the curriculum's cloud environment.

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

The stable `v2.9.10` harness inspected at commit `86cdca76fa2a36274c432caa21952b23c267989a` predates the explicit SHMERR pre/post test handling seen on the pinned development revision. Treat harness cleanup behavior as version-sensitive.

## Representative upstream test — TEST-CONFIRMED

`lab-jobs/002-upstream-realtime-math-test.sh` executed upstream `tests/realtime-math` through the real `scripts/runtests` harness in Actions run `33949095338`.

The test path is useful because upstream describes it as verifying that realtime math functions declared in `rtapi_math.h` are available at link time. Its `test.sh` runs `halcompile --install rtmath.comp` and then `halrun dotest.hal`; `dotest.hal` performs `loadrt rtmath`.

Observed result:

- `Runtest: 1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped, 0 shmem errors`.
- `runtests exit status: 0`.
- `halcompile` compiled `rtmath.c`, linked `rtmath.so`, and copied it into the RIP `rtlib` directory.
- `halrun` then executed the HAL file successfully.
- Both the pre-test and post-test `ipcs -m` snapshots listed no System V shared-memory segments.

The detailed trace and prediction-vs-observation record are in `guides/L02-representative-test.md`.

### Critical limitation of that evidence

The GitHub Actions runner lacks `cap_sys_nice` and `cap_ipc_lock`. During `halrun`, LinuxCNC reported that `sched_setscheduler(SCHED_FIFO)` was not permitted and fell back to POSIX non-realtime operation.

Therefore experiment `002` validates the build/test machinery, `halcompile`, RTAPI math symbol linkability, HAL component loading, result handling, and cleanup in a non-realtime software laboratory. It is **not** evidence about actual realtime scheduling, latency, deadline behavior, or machine-hardware suitability.

## Important laboratory lesson

The curriculum wrapper uses strict Bash mode, but upstream `rip-environment` does not promise `set -u` compatibility. The lab temporarily disables nounset only while sourcing that script and restores it immediately. This is an environment-contract boundary, not a LinuxCNC compile defect.

## Evidence classifications

- `TEST-CONFIRMED`: pinned development revision configures and compiles successfully on the current GitHub Actions Ubuntu 24.04 runner; RIP tools resolve; job exits 0.
- `TEST-CONFIRMED`: representative `tests/realtime-math` executes through `scripts/runtests` and passes 1/1 with zero harness-reported shmem errors in POSIX non-realtime fallback mode.
- `SOURCE-CONFIRMED`: default/userspace target relationships and source-directory inclusion are defined in `src/Makefile`.
- `SOURCE-CONFIRMED`: development test discovery/execution/cleanup behavior above is implemented by `scripts/runtests.in` at the pinned revision.
- `SOURCE-CONFIRMED`: the stable 2.9.10 harness differs from development with respect to the inspected explicit shared-memory hygiene path.
- `UNKNOWN`: how much of the full upstream test suite is stable/appropriate for this curriculum runner without realtime privileges.
- `NOT TESTED HERE`: genuine realtime scheduling and timing behavior.

## Next experiment

Establish the stable-release side of L01 reproducibility: build exact `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a` in a bounded `003` job and run an appropriate representative test if its stable harness/test definition supports it. Preserve any stable-vs-development differences. After that, begin the adversarial exam/corrections pass for the Phase-0 lab/build/test material rather than carrying unresolved infrastructure assumptions into A01.
