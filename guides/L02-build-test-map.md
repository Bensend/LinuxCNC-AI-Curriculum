# L02 — LinuxCNC Repository / Build / Test Map (initial)

Revision studied: `8bf4605ae81042248add031e94c77300406e0413` (`master`, pinned by L01 lab).

## Reproducible build evidence

`lab-jobs/001-build-linuxcnc.sh` completed successfully in GitHub Actions run `33943964198` on Ubuntu 24.04 uspace. The preserved artifact reports:

- Debian metadata configured for `uspace-Ubuntu-24.04`.
- `src/configure` completed successfully.
- `make -C src -j2` completed and produced the run-in-place tree.
- `scripts/linuxcnc`, `bin/halcmd`, and `scripts/runtests` resolved from that run-in-place tree after sourcing `scripts/rip-environment`.
- The job exited `0`.
- Build-lab wall time was about 4m06s (04:13:16Z–04:17:22Z).

This converts the initial source pin from merely cloneable to experimentally buildable in the curriculum's cloud environment.

## Top-level build shape

`src/Makefile` says the default target is `build-software`. For a userspace build, `build-software` depends on `headers userspace modules`. In a run-in-place uspace build it may warn that `sudo make setuid` or `sudo make setcap` is required for hardware access; that warning does not mean the software build failed.

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

The generated `scripts/runtests` comes from `scripts/runtests.in`. Source inspection establishes:

1. It enables `pipefail`, unsets `DISPLAY`, and fixes locale to reduce non-interactive/locale variability.
2. In run-in-place mode it sources `scripts/rip-environment` and points test headers/libraries at the source tree.
3. Tests are discovered as files named `test.hal`, `test.sh`, or `test` beneath supplied paths.
4. `.hal` tests execute via `halrun -f`; `.sh` tests execute via Bash; other tests execute directly.
5. HAL tests have special overrun handling: an `overrun` result causes retries up to ten attempts.
6. The harness checks for stale LinuxCNC/HAL shared-memory keys because leftover state can invalidate subsequent tests.
7. Supported modes include ordinary path execution, cleanup (`-c`), user-only selection (`-u`), verbose output (`-v`), and crash-dump collection (`-d`).

The first build lab only verified harness presence/help; it did **not** yet execute a representative LinuxCNC test. That remains an L02 experiment requirement.

## Important laboratory lesson

The curriculum wrapper uses strict Bash mode, but upstream `rip-environment` does not promise `set -u` compatibility. The lab now temporarily disables nounset only while sourcing that script and restores it immediately. This is an environment-contract boundary, not a LinuxCNC compile defect.

## Evidence classifications

- `TEST-CONFIRMED`: pinned revision configures and compiles successfully on the current GitHub Actions Ubuntu 24.04 runner; RIP tools resolve; job exits 0.
- `SOURCE-CONFIRMED`: default/userspace target relationships and source-directory inclusion are defined in `src/Makefile`.
- `SOURCE-CONFIRMED`: test discovery/execution behavior above is implemented by `scripts/runtests.in` at the pinned revision.
- `UNKNOWN`: which smallest representative test best validates RTAPI/HAL behavior in the unprivileged Actions environment.
- `UNKNOWN`: how much of the full upstream test suite is stable/appropriate for this curriculum runner without realtime privileges.

## Next experiment

Create a bounded `002` lab that executes a small representative upstream test through `scripts/runtests`, preferably one that exercises HAL/RTAPI without physical hardware. Record selected test path, expected behavior before execution, exact command, exit status, result/stderr, and any shared-memory cleanup behavior. Use the result to refine the build/test map before L02 examination/graduation.
