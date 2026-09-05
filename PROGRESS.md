# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; `guides/A01-lab-observation-validity.md`; `guides/A01-runtime-observation-hang-diagnosis.md`; `guides/A01-halcmd-observation-boundary.md`; `guides/A01-halcmd-hal-lock-call-flow.md`; `guides/A01-stalled-halcmd-localization-plan.md`; pinned launcher/task/motion/HAL utility source | `004` timed out twice at 60 min; third run `33965517203` timed out at 75 min after runtime launch; corrected bounded-observation/backtrace patch prepared on branch `a01-bounded-observation` | adversarial exam + corrections complete | Source proves startup registration and `hal_list_*()` can block on the same unbounded HAL shared-data mutex; next run preserves the original stalled PID and captures a symbol-level backtrace before forced termination |
| R01 Realtime model | PLANNED | — | — | — | Critical path; blocked on A01 graduation |
| H01 HAL architecture | PLANNED | — | — | — | Critical path |
| H04 HAL execution ordering | PLANNED | — | — | — | Critical path |
| M03 One servo-period trace | PLANNED | — | — | — | Critical path |
| HM01 HostMot2 architecture | PLANNED | — | — | — | Critical path |
| E01 hm2_eth architecture | PLANNED | — | — | — | Critical path |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | Critical path |
| IO01 Encoder path | PLANNED | — | — | — | Critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | Critical path |

## Phase 0 graduation result

Stable experiment `003`, Actions run `33952061943`, completed successfully against exact LinuxCNC `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a`. The stable checkout's own build system, RIP environment, `scripts/runtests`, and `tests/realtime-math` produced `1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped`, with `runtests` exit `0`. The runner reported POSIX non-realtime operation. Development run `33949095338` additionally reports explicit shmem hygiene/accounting. L00-L03 are graduated without claiming realtime scheduling, hardware suitability, functional safety, full-suite compatibility, or later subsystem behavior.

## A01 source-level architecture result

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`.

Source-confirmed findings:

- `scripts/linuxcnc.in` starts `linuxcncsvr` first because it creates/owns NML buffers, starts realtime/RTAPI/HAL infrastructure, then starts configured Task before normal HAL files load kinematics/motmod; Task therefore retries motion initialization during startup.
- `src/emc/task/Submakefile` links `emctaskmain.cc`, `taskintf.cc`, `usrmotintf.cc`, `taskclass.cc`, and related sources into `milltask`.
- UI/external-control ↔ Task uses NML channels (`emcCommand`, `emcStatus`, `emcError`).
- Task ↔ realtime motion does **not** use another RCS/NML channel. `taskintf.cc` constructs `emcmot_command_t`; `usrmotWriteEmcmotCommand()` copies it under `emcmotStruct->command_mutex` into RTAPI shared `emcmot_struct_t.command` and polls shared status for a matching `commandNumEcho`.
- `src/emc/motion/motion.c` exports `emcmotCommandHandler` as HAL function `motion-command-handler`. `src/emc/motion/command.c::emcmotCommandHandler()` is the realtime receiving endpoint: it try-locks the command mutex, skips the cycle if Task is updating, detects a new `commandNum`, writes `commandEcho` and `commandNumEcho`, defaults `commandStatus`, then dispatches the command switch.
- A matching command-number echo is acknowledgement/observation, not proof of success; userspace separately evaluates `commandStatus` and distinguishes timeout from acknowledged command rejection.
- `Task::Task()` calls `hal_init("iocontrol.0")`, and `taskclass.cc` is linked directly into `milltask`; at this revision `iocontrol.0` is therefore an integrated userspace HAL component owned by Task, not evidence of a standalone `iocontrol` OS process.

Community cross-checks retain an important version/history warning: older forum explanations sometimes describe `task`/`iocontrol` as separate conceptual modules. They are useful investigation leads but do not override pinned build/source/runtime evidence for this revision.

## A01 experiment correction history

Runs `33957356410` and `33960179986` exhausted the former 60-minute workflow ceiling before a valid result was published. The first cancellation exposed a laboratory integrity bug: inherited `LATEST.*` files could be uploaded/recommitted after cancellation. The runner was hardened in commit `360a06030319ad3eaa4a83b211aa52386ca51b9c` to delete inherited `LATEST.*`, use cancellation-safe publication, and allow a bounded 75-minute window.

Third run `33965517203` (job `101304830830`, curriculum head `06c7bf7f0602fa577d20a00f92cef82527c61df2`) was cancelled at the 75-minute ceiling. Decoded GitHub job logs materially correct the earlier diagnosis: runner cleanup found live `linuxcnc`, `linuxcncsvr`, `rtapi_app`, `milltask`, and `linuxcncrsh` processes. Therefore the pinned build had reached the exact upstream linuxcncrsh runtime. This run is not evidence that compilation itself required more than 75 minutes.

The intended `Key component assertions` still did not complete and no fresh `LATEST.*`/`run-33965517203-1` result was produced, so A01 topology claims are not promoted to `TEST-CONFIRMED`.

Further pinned-source analysis now narrows the observation hang without overclaiming it. `halcmd_main.c::main()` calls `halcmd_startup(0)` before command dispatch. `halcmd_startup()` calls `hal_init()`. In ULAPI, `hal_init()` maps/initializes HAL state as needed and then calls `halpr_mutex_acquire()` before inspecting and modifying the shared component list. Under contention, `halpr_mutex_acquire()` enters `rtapi_mutex_get_rd()`, whose userspace implementation repeatedly tests the reverse-default mutex and calls `sched_yield()` with no timeout. After startup, `hal_list_comp()` and `hal_list_funct()` acquire the same HAL shared-data mutex before iteration. Therefore a single `halcmd list comp` contains at least two source-confirmed unbounded lock-acquisition opportunities. The failed run did not distinguish which one blocked, so the exact site remains `UNKNOWN`.

There is also a timeout-signal subtlety: while `halcmd_startup()` is inside `hal_init()`, `hal_flag` is set. `halcmd`'s SIGTERM/SIGINT handler then records `halcmd_done` instead of immediately exiting because the process may hold/acquire the HAL mutex. This source behavior justifies a hard-kill fallback; TERM alone is not a reliable wall-clock bound for every startup path. See `guides/A01-halcmd-hal-lock-call-flow.md`.

Community cross-check: LinuxCNC issue #2716 discusses HAL's fixed shared-memory resources and the current practical one-HAL-instance architecture. This is retained as `COMMUNITY-REPORTED` corroboration, not implementation authority.

Prepared branch `a01-bounded-observation` contains the corrected experiment without consuming another September 5 lab run. Commit `13063ce8c01fe2f3c462974acee2f6ae7a7b80e1` fixed a shell `set -e` defect that could erase timeout diagnostics. Commit `42a78f98863ec6ad6cd07e75a0bfc2c0df2c8666` further replaces kill-first whole-command timeout handling with monitored HAL child processes: if a probe stalls, the original `halcmd` PID is preserved long enough to capture process state and a privileged GDB backtrace, then bounded TERM/KILL cleanup is applied. This is intended to distinguish a stack still in `hal_init()` registration from one already in `hal_list_comp()`/`hal_list_funct()` query code. The attach result itself remains future experimental evidence; no blocking site is promoted in advance. See `guides/A01-stalled-halcmd-localization-plan.md`.

## Laboratory compute-budget checkpoint

The curriculum target is a maximum of approximately four GitHub Actions laboratory hours per calendar day. September 5 already consumed the allowed budget through multiple long LinuxCNC experiments, including the two 60-minute A01 attempts and the 75-minute third attempt. Do not merge the prepared branch to `main` or launch another full A01 run on September 5 because `lab-jobs/**`/workflow changes on `main` auto-trigger the runner. Research, source work, failure diagnosis, exam/correction work, and experiment preparation may continue without consuming laboratory compute.

## A01 adversarial state

`exams/A01-process-component-architecture-adversarial.md` and `guides/A01-adversarial-corrections.md` cover the false premises and failure cases: all IPC is NML; `iocontrol.0` must be standalone; Task cannot precede motion; realtime should block on mutex contention; command echo means success; cancelled artifacts can be trusted; and old diagrams can be generalized to the pinned revision.

Additional corrections: a workflow timeout during a monolithic shell step does not establish which internal phase consumed the time. A loop count does not bound elapsed time when a command inside the loop can itself block. A `halcmd list comp` timeout cannot be localized to list traversal because startup registration and the list query both use the shared HAL lock. A TERM-only timeout is not sufficient while `halcmd_startup()` has `hal_flag` set. An external wrapper intended to capture a failing command must neutralize shell `errexit` around that command or its own diagnostic path can be skipped. Finally, diagnosing a second reproduction after killing the original stalled process can lose a transient contention condition; the next instrumentation therefore diagnoses the original live PID before termination.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Do **not** launch or auto-trigger another LinuxCNC lab run on September 5.
2. At the next laboratory-budget window, reconcile `a01-bounded-observation` with current `main`. Preserve commit `13063ce8...`'s `errexit` fix and commit `42a78f98863ec6ad6cd07e75a0bfc2c0df2c8666`'s live-PID backtrace behavior.
3. Merge/apply the corrected lab/workflow changes to `main` and allow exactly one corrected `004` to auto-trigger; do not dispatch a duplicate.
4. Require fresh metadata identifying the corrected curriculum head and `004`; inspect process-readiness and HAL before/after markers before interpreting topology.
5. If a HAL probe stalls, inspect the captured backtrace first. Promote only the observed frame/call path: `hal_init()`/registration, `hal_list_comp()`/`hal_list_funct()` query, or remain `UNKNOWN` if the caller stack is insufficient. A GDB attach failure is not evidence of either stage.
6. If `Key component assertions` executes, reconcile `ps`/`pgrep`, bounded HAL component/function output, and the absence/presence of a standalone `iocontrol` process; write the A01 fresh-AI handoff and perform graduation review.
7. If the 70-minute inner timeout fires, verify result publication succeeded; diagnose from the last progress marker rather than inferring the phase from total runtime.
8. Do not change LinuxCNC source merely to make the observation pass. Diagnostic instrumentation may observe the pinned binary, but an upstream-source behavioral modification requires evidence of an actual defect and a separately bounded experiment.

The complete module graph remains in `CURRICULUM.md`.
