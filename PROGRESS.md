# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | EXPERIMENT | GitHub Actions smoke result + official build docs + captured build logs | `000-smoke` passed; `001-build-linuxcnc` passed in run `33943964198` | — | Lab runner preserves stdout/stderr/exit code and can build pinned LinuxCNC master |
| L01 Version pinning | EXPERIMENT | Upstream commit recorded by smoke/build lab | `001-build-linuxcnc` pins and builds `8bf4605ae81042248add031e94c77300406e0413` | — | Development baseline is now experimentally reproducible; stable-release baseline still to establish |
| L02 Repository/build/test map | SOURCE | `guides/L02-build-test-map.md`; `src/Makefile`; `scripts/runtests.in`; build artifact | Build lab passed; representative upstream test still required | — | Initial source-grounded build/test map created |
| A01 Process/component architecture | PLANNED | — | — | — | Critical path |
| R01 Realtime model | PLANNED | — | — | — | Critical path |
| H01 HAL architecture | PLANNED | — | — | — | Critical path |
| H04 HAL execution ordering | PLANNED | — | — | — | Critical path |
| M03 One servo-period trace | PLANNED | — | — | — | Critical path |
| HM01 HostMot2 architecture | PLANNED | — | — | — | Critical path |
| E01 hm2_eth architecture | PLANNED | — | — | — | Critical path |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | Critical path |
| IO01 Encoder path | PLANNED | — | — | — | Critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | Critical path |

## Current checkpoint

Actions run `33943964198`, triggered by commit `62777cc14a831157987c8c01497f6d6bebf6163e`, completed successfully. It checked out LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`, configured Debian metadata for `uspace-Ubuntu-24.04`, completed `src/configure`, compiled the run-in-place userspace tree, sourced the RIP environment, resolved `scripts/linuxcnc`, `bin/halcmd`, and `scripts/runtests`, and exited `0`. Preserved lab timestamps were 04:13:16Z–04:17:22Z (~4m06s). The earlier nounset/RIP-environment failure is therefore resolved.

L02 has begun at source level in `guides/L02-build-test-map.md`. `src/Makefile` establishes the build-oriented subsystem map and `scripts/runtests.in` establishes test discovery/execution behavior. The build lab only verified that `runtests` exists and printed its usage; it did not execute a representative upstream test.

Next lesson: create/run a bounded `002` laboratory job that rebuilds the pinned revision and executes a small representative upstream HAL/RTAPI test through `scripts/runtests` without physical hardware. Record the predicted behavior before execution, exact selected test path, command, exit status, result/stderr, and cleanup/shared-memory observations. Then use that evidence to refine L02 and decide whether L00 can enter its exam/graduation stage. L01 additionally still needs a stable-release reference baseline before graduation.

The complete module graph is maintained in `CURRICULUM.md`. Add rows here as modules enter active work rather than using this file as a duplicate syllabus.
