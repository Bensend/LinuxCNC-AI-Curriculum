# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | EXPERIMENT | GitHub Actions smoke result + official build docs + captured build logs | `000-smoke` passed; first `001-build-linuxcnc` reached a completed build then failed while sourcing RIP environment | — | Lab runner correctly preserves stdout/stderr and exit code; rerun patched job |
| L01 Version pinning | EXPERIMENT | Upstream commit recorded by smoke/build lab | `001-build-linuxcnc` pins `8bf4605ae81042248add031e94c77300406e0413` | — | Exact revision checked out successfully; establish stable baseline later |
| L02 Repository/build/test map | RESEARCH | Official build documentation and upstream source/build output | Build lab begins source/build-system mapping | — | Spawned naturally from L00/L01 |
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

L00/L01 remain active. Actions run `33941257688` checked out the pinned LinuxCNC master revision `8bf4605ae81042248add031e94c77300406e0413`, generated Debian uspace metadata, installed build dependencies, configured, and compiled far enough to reach the RIP-environment verification stage. The actual failure was not a LinuxCNC compile failure: the curriculum lab globally enabled Bash `set -u`, while upstream `scripts/rip-environment` references optional `GLADE_ICON_THEME_PATH` without a nounset guard. This produced `../scripts/rip-environment: line 74: GLADE_ICON_THEME_PATH: unbound variable` after the build dependency scans completed.

`lab-jobs/001-build-linuxcnc.sh` is patched to temporarily disable nounset only while sourcing upstream `rip-environment`, then immediately restore it. This preserves strict-mode checking for the curriculum script without imposing a shell contract on an upstream environment script that does not claim nounset compatibility. Next lesson: inspect the Actions run triggered by commit `62777cc14a831157987c8c01497f6d6bebf6163e`; if it passes, record exact configure/build/test evidence and begin a concise L02 build/test map. If it fails, diagnose the next concrete failure from the preserved lab logs before broadening scope.

The complete module graph is maintained in `CURRICULUM.md`. Add rows here as modules enter active work rather than using this file as a duplicate syllabus.
