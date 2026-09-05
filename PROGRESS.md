# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | EXPERIMENT | GitHub Actions smoke result + official build docs | `000-smoke` passed; `001-build-linuxcnc` submitted | — | Validate full reproducible uspace build/test environment before graduation |
| L01 Version pinning | EXPERIMENT | Upstream commit recorded by smoke lab | `001-build-linuxcnc` pins `8bf4605ae81042248add031e94c77300406e0413` | — | Establish exact-revision reproducibility; later add stable baseline |
| L02 Repository/build/test map | RESEARCH | Official build documentation and upstream source | Build lab begins source/build-system mapping | — | Spawned naturally from L00/L01 |
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

L00/L01 are active. The existing `000-smoke` lab proved the Actions runner can clone upstream LinuxCNC and recorded master commit `8bf4605ae81042248add031e94c77300406e0413` (`VERSION` `2.10.0~pre1`). `lab-jobs/001-build-linuxcnc.sh` now pins that exact revision, generates Debian uspace metadata, installs declared build dependencies, configures `--with-realtime=uspace`, compiles the run-in-place tree, loads `rip-environment`, and verifies the core command/test harness. Inspect the resulting Actions run and correct dependency/build assumptions before marking either module graduated.

The complete module graph is maintained in `CURRICULUM.md`. Add rows here as modules enter active work rather than using this file as a duplicate syllabus.
