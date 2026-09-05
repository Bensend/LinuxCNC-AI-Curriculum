# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; development `002` passed; stable `003` passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md` | development `8bf4605ae81042248add031e94c77300406e0413`; stable `86cdca76fa2a36274c432caa21952b23c267989a` | covered by Phase-0 exam/handoff | Stable `v2.9.10` experimentally confirmed |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md` | development `002` and stable `003` ran upstream `tests/realtime-math` | Phase-0 exam/corrections complete | Results are POSIX non-realtime evidence only |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md` | exercised on build failures, version comparison, and evidence boundaries | Phase-0 exam/handoff complete | Evidence/conflict workflow demonstrated |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; A01 observation/lock/cleanup/ownership guides | `004` timed out twice at 60 min and once at 75 min; corrected bounded observation is prepared off-main | adversarial exam + corrections complete | Source architecture is strong; runtime topology awaits one valid bounded observation before fresh-AI handoff/graduation |
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

## A01 source-level result

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`.

Source-confirmed findings include:

- `scripts/linuxcnc.in` starts `linuxcncsvr` first because it creates/owns NML buffers, starts RTAPI/HAL infrastructure, and later starts configured Task; normal HAL configuration loads kinematics/motmod.
- `src/emc/task/Submakefile` links `emctaskmain.cc`, `taskintf.cc`, `usrmotintf.cc`, `taskclass.cc`, and related sources into `milltask`.
- UI/external control to Task uses NML channels (`emcCommand`, `emcStatus`, `emcError`).
- Task to realtime motion uses RTAPI shared `emcmot_struct_t`; `usrmotWriteEmcmotCommand()` copies under `command_mutex` and waits for matching `commandNumEcho`.
- `motion.c` exports `emcmotCommandHandler` as HAL function `motion-command-handler`; `command.c::emcmotCommandHandler()` try-locks the command mutex, observes new command numbers, echoes them, initializes `commandStatus`, and dispatches commands.
- Command-number echo is acknowledgement/observation, not proof of command success; userspace separately evaluates `commandStatus`.
- `Task::Task()` executes `hal_init("iocontrol.0")`; `Task::iocontrol_hal_init()` exports the `iocontrol.0.*` pins and calls `hal_ready()`.
- In the userspace/ULAPI `hal_init()` path, the HAL component record stores `comp->pid = getpid()`. `halcmd show comp` exposes that PID for userspace components. Therefore component ownership can be tested directly rather than inferred from the absence of a standalone executable. See `guides/A01-iocontrol-component-ownership-verification.md`.

Older community explanations that describe task/iocontrol as separate conceptual modules remain version/history leads and do not override pinned source.

## A01 experiment history

- Run `33957356410` reached the former 60-minute workflow ceiling before valid topology assertions. It exposed a stale-artifact bug: inherited `LATEST.*` could be uploaded after cancellation. The runner was hardened to delete inherited `LATEST.*` before execution.
- Run `33960179986` also reached 60 minutes before valid assertions.
- Run `33965517203` (job `101304830830`, curriculum head `06c7bf7f0602fa577d20a00f92cef82527c61df2`) reached the 75-minute ceiling. Cleanup logs found live `linuxcnc`, `linuxcncsvr`, `rtapi_app`, `milltask`, and `linuxcncrsh`, proving the build had reached runtime. No fresh `004` assertions were produced, so topology remains not `TEST-CONFIRMED`.

## A01 observation-harness corrections

Pinned-source and adversarial analysis established:

- `halcmd_main.c::main()` calls `halcmd_startup(0)` before command dispatch; startup calls `hal_init()`.
- Both userspace component registration and later `hal_list_comp()`/`hal_list_funct()` can acquire the shared HAL metadata mutex, and the userspace wait lacks an internal wall-clock timeout. A stalled whole command therefore does not identify the blocking site.
- Loop-count readiness is not a wall-clock bound if an inner command can block.
- TERM alone is insufficient for every stalled `halcmd` path; diagnostics need a bounded TERM→KILL fallback.
- Expected nonzero probe results must be captured without unsafe global `set -e` toggling.
- A force-killed HAL-lock participant may leave shared lock accounting inconsistent; no subsequent HAL output from that instance is accepted as topology evidence.
- The original stalled PID must be inspected before termination; replacement-process observation can erase the transient state.
- `linuxcnc.in` cleanup itself invokes HAL commands without an independent wall-clock bound, so launcher teardown in the lab must also be bounded.
- Push-triggered lab selection must compare the GitHub event `before` SHA to `GITHUB_SHA`; merge commits cannot be safely selected with single-commit `diff-tree` alone. Multiple changed lab jobs fail closed.
- Runtime process readiness requires `linuxcncsvr`, `milltask`, and `linuxcncrsh` before the first external HAL query.
- A valid ownership assertion must compare `halcmd show comp iocontrol.0`'s userspace PID with the sole live `milltask` PID; existence plus standalone-process absence is weaker evidence.

## Prepared next-budget experiment

The canonical prepared branch is `a01-ready-next-budget-20260905T2211Z`. It was recreated from then-current `main` rather than depending on the older divergent `a01-bounded-observation` history.

Important prepared changes:

- bounded process readiness and HAL probes;
- original stalled PID process state + bounded GDB backtrace before forced termination;
- terminal evidence handling after any force-killed HAL probe;
- bounded LinuxCNC launcher teardown;
- 70-minute inner experiment ceiling inside the 75-minute Actions job ceiling;
- merge-safe push-range job selection with ambiguous multi-job pushes rejected;
- direct `iocontrol.0` ownership verification using HAL's recorded userspace PID, added in branch commit `6be2abbf9ec5566168784cab92510a4ed88bb8de`.

The branch is intentionally off `main`; its workflow only auto-runs lab paths on pushes to `main`.

## Laboratory compute-budget checkpoint

Target laboratory compute is at most approximately four GitHub Actions hours per calendar day. September 5 consumed the planned budget through three long A01 attempts. No additional LinuxCNC lab run should be launched on September 5. Research, source reading, documentation, adversarial review, and off-main preparation may continue.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Do **not** launch another LinuxCNC lab run on September 5.
2. At the next laboratory-budget window, compare `a01-ready-next-budget-20260905T2211Z` with then-current `main`. Preserve its lab/workflow changes, including ownership-test commit `6be2abbf...`, while retaining later main-side guides/checkpoints/logs.
3. Re-audit only the executable delta once more for shell/YAML blocking/error paths; do not spend another paid run on an unchanged harness defect.
4. Advance `main` exactly once with the corrected lab/workflow files and allow exactly one push-triggered corrected `004`; do not dispatch a duplicate.
5. Require fresh metadata identifying job `004`, the new curriculum source SHA, and all three process-readiness markers before accepting runtime evidence.
6. If any HAL probe stalls, classify only from the captured original-PID stack: startup/`hal_init`, `hal_list_*`, or `UNKNOWN`. A failed GDB attach proves neither stage. After a force-killed probe, issue/accept no further HAL assertions from that instance.
7. For a passing topology run, require execution of `Key component assertions`, `iocontrol.0`, `motmod`, and `trivkins` presence, exactly one `milltask`, no standalone `iocontrol`, and `iocontrol.0`'s HAL userspace PID equal to the live `milltask` PID.
8. If those criteria pass, reconcile the output against the source guide, promote only directly observed facts to `TEST-CONFIRMED`, write the A01 fresh-AI handoff, and perform graduation review. If A01 graduates, R01 becomes the highest-priority unblocked module.
9. If the 70-minute inner timeout fires, diagnose from the last preserved progress marker/artifact rather than inferring phase from total runtime.
10. Do not modify upstream LinuxCNC behavior merely to make observation pass; diagnostic instrumentation may observe the pinned binary, but behavioral changes require separate defect evidence.
