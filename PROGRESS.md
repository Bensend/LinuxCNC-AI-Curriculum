# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | EXPERIMENT | GitHub Actions smoke/build/test results + official build docs + captured logs | `000-smoke` passed; `001-build-linuxcnc` passed; `002-upstream-realtime-math-test` passed in run `33949095338` | — | Lab runner preserves stdout/stderr/exit code, builds pinned LinuxCNC, and executes bounded upstream tests; current Actions runner falls back to POSIX non-realtime |
| L01 Version pinning | EXPERIMENT | Development pin + official stable release + exact `v2.9.10` tag dereference | `001` builds development `8bf4605ae81042248add031e94c77300406e0413`; stable build pending | — | Stable reference is `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a`; must build/test it before graduation |
| L02 Repository/build/test map | EXPERIMENT | `guides/L02-build-test-map.md`; `guides/L02-representative-test.md`; `src/Makefile`; `scripts/runtests.in` | `002` ran upstream `tests/realtime-math`: 1/1 successful, exit 0, zero shmem errors | — | Representative harness path verified; master has explicit shmem hygiene absent from inspected 2.9.10 harness; realtime scheduling not tested by Actions fallback |
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

Actions run `33949095338`, triggered by curriculum commit `c2eb8e5a01a9360586281ac8352e8a5e94de3226`, completed successfully against LinuxCNC development revision `8bf4605ae81042248add031e94c77300406e0413`. The `002-upstream-realtime-math-test` job rebuilt the RIP uspace tree and ran upstream `tests/realtime-math` through `scripts/runtests`.

Preserved test evidence reports:

- `Runtest: 1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped, 0 shmem errors`.
- `runtests exit status: 0`.
- `halcompile` compiled `rtmath.c`, linked `rtmath.so`, and copied it into the RIP `rtlib` directory.
- the shell trace then ran `halrun dotest.hal`, whose upstream HAL file loads `rtmath`.
- pre-test and post-test `ipcs -m` snapshots listed no System V shared-memory segments.
- the Actions environment lacks realtime scheduling capabilities; LinuxCNC reported failed `SCHED_FIFO` setup and fell back to POSIX non-realtime execution. This is valid L00/L02 software-lab evidence but must not be reused as R01/R02 realtime evidence.

L02 documentation now includes the test anatomy, source-grounded call flow, prediction-versus-observation result, and an explicit evidence boundary in `guides/L02-representative-test.md`. Source comparison also found a version-sensitive harness difference: the pinned master has explicit pre/post shared-memory checks and SHMERR handling, while the inspected stable `v2.9.10` harness does not have that newer path.

L01 now has an exact current stable reference candidate: LinuxCNC tag `v2.9.10` dereferences to commit `86cdca76fa2a36274c432caa21952b23c267989a`. This pin is source/documentation-confirmed but not yet test-confirmed by this curriculum.

Next lesson: create a bounded `003` stable-baseline job using exact commit `86cdca76fa2a36274c432caa21952b23c267989a`. Build it reproducibly on the same runner and, if the stable test definition supports it, execute an equivalent representative upstream test. Preserve all stable-vs-development differences. Then begin the adversarial exam/corrections pass for L00/L01/L02 so Phase 0 can graduate before A01 process/component architecture begins.

The complete module graph is maintained in `CURRICULUM.md`. Add rows here as modules enter active work rather than using this file as a duplicate syllabus.
