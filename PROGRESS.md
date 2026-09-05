# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; development `002` passed; stable `003` passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md` | development `8bf4605ae81042248add031e94c77300406e0413`; stable `86cdca76fa2a36274c432caa21952b23c267989a` | covered by Phase-0 exam/handoff | Stable `v2.9.10` experimentally confirmed |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md` | development `002` and stable `003` ran upstream `tests/realtime-math` | Phase-0 exam/corrections complete | Results are POSIX non-realtime evidence only |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md` | exercised on build failures, version comparison, and evidence boundaries | Phase-0 exam/handoff complete | Evidence/conflict workflow demonstrated |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; A01 HAL-lock/observation guides including `guides/A01-linuxcnc-cleanup-boundary.md` | `004` timed out twice at 60 min and once at 75 min; corrected bounded-observation work remains isolated on `a01-bounded-observation` | adversarial exam + corrections complete | Source architecture is strong; runtime topology still awaits one valid bounded observation before handoff/graduation |
| R01 Realtime model | PLANNED | — | — | — | blocked on A01 graduation |
| H01 HAL architecture | PLANNED | — | — | — | critical path |
| H04 HAL execution ordering | PLANNED | — | — | — | critical path |
| M03 One servo-period trace | PLANNED | — | — | — | critical path |
| HM01 HostMot2 architecture | PLANNED | — | — | — | critical path |
| E01 hm2_eth architecture | PLANNED | — | — | — | critical path |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | critical path |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Phase 0 result

Phase 0 is graduated. Development experiment `002` and stable experiment `003` both built their pinned LinuxCNC revisions and ran the selected upstream representative test successfully. Stable `003`, Actions run `33952061943`, used exact LinuxCNC `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a`. No result is generalized to realtime scheduling, hardware suitability, functional safety, or full-suite compatibility.

## A01 source-level architecture result

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`.

Source-confirmed findings:

- `scripts/linuxcnc.in` starts `linuxcncsvr` first because it creates/owns NML buffers, starts RTAPI/HAL infrastructure, then starts configured Task before normal HAL files load kinematics/motmod; Task therefore retries motion initialization during startup.
- `src/emc/task/Submakefile` links `emctaskmain.cc`, `taskintf.cc`, `usrmotintf.cc`, `taskclass.cc`, and related sources into `milltask`.
- UI/external control to Task uses NML channels (`emcCommand`, `emcStatus`, `emcError`).
- Task to realtime motion uses RTAPI shared `emcmot_struct_t`, not another RCS/NML channel. `usrmotWriteEmcmotCommand()` copies the command under `command_mutex` and waits for matching `commandNumEcho`.
- `src/emc/motion/motion.c` exports `emcmotCommandHandler` as HAL function `motion-command-handler`; `command.c::emcmotCommandHandler()` try-locks the command mutex, detects new command numbers, echoes observation, initializes `commandStatus`, and dispatches the command.
- Command-number echo is acknowledgement/observation, not proof of command success; userspace separately evaluates `commandStatus`.
- `Task::Task()` calls `hal_init("iocontrol.0")`, and `taskclass.cc` is linked into `milltask`; at this revision `iocontrol.0` is an integrated userspace HAL component owned by Task, not evidence of a standalone `iocontrol` process.

Older community explanations that describe task/iocontrol as separate conceptual modules remain version/history leads and do not override pinned source.

## A01 experiment history and integrity corrections

- Run `33957356410` hit the former 60-minute workflow ceiling before valid topology assertions. It exposed a stale-artifact bug: inherited `LATEST.*` could be uploaded after cancellation. The runner was hardened to remove inherited `LATEST.*` before execution.
- Run `33960179986` also hit 60 minutes before valid assertions.
- Run `33965517203` (job `101304830830`, curriculum head `06c7bf7f0602fa577d20a00f92cef82527c61df2`) hit the 75-minute ceiling. Decoded cleanup logs found live `linuxcnc`, `linuxcncsvr`, `rtapi_app`, `milltask`, and `linuxcncrsh`, proving the pinned build had reached the upstream runtime. No fresh `004` assertions were produced, so topology was not promoted to `TEST-CONFIRMED`.

Pinned-source analysis established that `halcmd_main.c::main()` calls `halcmd_startup(0)` before command dispatch; startup calls `hal_init()`, and both startup registration and later `hal_list_comp()`/`hal_list_funct()` can acquire the same shared HAL metadata mutex. The userspace mutex wait can spin/yield without an internal wall-clock timeout. Therefore the exact stalled stage remains `UNKNOWN` until live-stack evidence localizes it.

Additional corrections:

- a loop count does not bound elapsed time when an inner command can block;
- TERM alone is not a sufficient diagnostic wall-clock bound for every `halcmd` startup path;
- expected nonzero probe results must be captured without re-enabling global `set -e` before return;
- a force-killed HAL-lock participant can strand shared lock accounting, so post-kill HAL output is not valid topology evidence;
- the original stalled PID must be inspected before termination; replacement-process observations can destroy transient evidence.

## New cleanup-boundary finding — 2026-09-05 19:09Z session

Pinned `scripts/linuxcnc.in` installs `trap 'Cleanup ; exit 0' SIGINT SIGTERM`. Its `Cleanup()` path has bounded TERM/KILL handling for several userspace processes, but later executes `$HALCMD stop`, `$HALCMD unload all`, and repeated `$HALCMD list comp` without an independent wall-clock bound. Because A01 is specifically diagnosing a possible HAL shared-data lock stall, the curriculum lab's former EXIT trap (`kill -TERM` then unbounded `wait`) was itself capable of losing the workflow publication window if LinuxCNC cleanup blocked in HAL.

`guides/A01-linuxcnc-cleanup-boundary.md` records the source analysis. Prepared branch `a01-bounded-observation` commit `6e1086c2c1e8fc9afe9dfd01394b00cff241baf8` now bounds launcher teardown: TERM, about four seconds of liveness polling, process/wchan snapshot if still alive, then KILL for publication containment. This is an experiment-harness correction, not a claim that launcher cleanup caused run `33965517203`.

## Prepared branch state

`a01-bounded-observation` remains intentionally separate from `main` so September 5 does not trigger another paid lab run. It is divergent from current `main` and must be reconciled rather than blindly merged.

Important prepared-branch commits:

- `13063ce8c01fe2f3c462974acee2f6ae7a7b80e1` — initial shell `set -e` diagnostic correction.
- `42a78f98863ec6ad6cd07e75a0bfc2c0df2c8666` — preserve original stalled `halcmd` PID for process state + bounded GDB backtrace before TERM/KILL.
- `23f62c8cb319323c2389a591f8dde7c63f746d62` — remove helper/caller global errexit toggles; make force-killed readiness timeout terminal for that HAL instance.
- `6e1086c2c1e8fc9afe9dfd01394b00cff241baf8` — independently bound LinuxCNC launcher teardown because pinned launcher cleanup itself invokes potentially blocking HAL commands.

GDB attachment remains future experiment evidence; hosted-runner ptrace policy may still prevent a usable stack.

## Laboratory compute-budget checkpoint

Target laboratory compute is approximately four GitHub Actions hours per calendar day. September 5 already consumed the allowed budget through the three long A01 attempts. No additional LinuxCNC lab run should be launched on September 5. Research, source reading, adversarial review, and preparation may continue off the auto-triggering `main` paths.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Do **not** launch another LinuxCNC lab run on September 5.
2. At the next laboratory-budget window, reconcile `a01-bounded-observation` with current `main`; preserve commits `13063ce8...`, `42a78f988...`, `23f62c8...`, and `6e1086c...` while retaining later main-side research/checkpoints.
3. Before allowing the paid run, re-audit the reconciled `004` script for every blocking path under `set -euo pipefail`: process readiness, each HAL probe, GDB attachment, forced probe cleanup, launcher EXIT cleanup, and the workflow's inner 70-minute publication margin.
4. Merge/apply the corrected lab/workflow files to `main` and allow exactly one corrected `004` to auto-trigger; do not dispatch a duplicate.
5. Require fresh metadata identifying the corrected curriculum head and `004` before accepting any result.
6. If a HAL probe stalls, classify only from the captured original-PID stack: startup/`hal_init`, `hal_list_comp`/`hal_list_funct`, or `UNKNOWN` if frames are insufficient. A failed GDB attach proves neither stage.
7. If a probe is force-killed, issue no further HAL assertions against that instance. If launcher teardown also needs KILL, treat that as cleanup evidence only.
8. If `Key component assertions` executes without a prior forced-kill diagnostic, reconcile `ps`/`pgrep`, bounded HAL component/function output, and standalone-`iocontrol` absence/presence; then write the A01 fresh-AI handoff and perform graduation review.
9. If the 70-minute inner timeout fires, diagnose from the last preserved progress marker/result artifact rather than inferring phase from total runtime.
10. Do not modify LinuxCNC source merely to make observation pass; diagnostic instrumentation may observe the pinned binary, but upstream behavioral changes require separate defect evidence.
