# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; `guides/A01-lab-observation-validity.md`; `guides/A01-runtime-observation-hang-diagnosis.md`; `guides/A01-halcmd-observation-boundary.md`; `guides/A01-halcmd-hal-lock-call-flow.md`; `guides/A01-stalled-halcmd-localization-plan.md`; `guides/A01-bounded-probe-errexit-lock-integrity.md`; pinned launcher/task/motion/HAL utility source | `004` timed out twice at 60 min; third run `33965517203` timed out at 75 min after runtime launch; corrected bounded-observation/backtrace patch remains isolated on branch `a01-bounded-observation` | adversarial exam + corrections complete | Source proves startup registration and `hal_list_*()` can block on the same unbounded HAL shared-data mutex; branch now also preserves nonzero probe status without re-enabling `errexit` prematurely and treats forced-kill lock diagnostics as terminal for that HAL instance |
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

Third run `33965517203` (job `101304830830`, curriculum head `06c7bf7f0602fa577d20a00f92cef82527c61df2`) was cancelled at the 75-minute ceiling. Decoded GitHub job logs materially corrected the earlier diagnosis: runner cleanup found live `linuxcnc`, `linuxcncsvr`, `rtapi_app`, `milltask`, and `linuxcncrsh` processes. Therefore the pinned build had reached the exact upstream linuxcncrsh runtime. The intended `Key component assertions` still did not complete and no fresh `LATEST.*`/`run-33965517203-1` result was produced, so A01 topology claims remain unpromoted to `TEST-CONFIRMED`.

Pinned-source analysis narrows the observation hang without overclaiming it. `halcmd_main.c::main()` calls `halcmd_startup(0)` before command dispatch. `halcmd_startup()` calls `hal_init()`. In ULAPI, `hal_init()` maps/initializes HAL state and calls `halpr_mutex_acquire()` before inspecting/modifying the shared component list. `halpr_mutex_acquire()` increments shared `lockcnt` and, under contention, can enter `rtapi_mutex_get_rd()`, whose userspace implementation repeatedly tests the reverse-default mutex and calls `sched_yield()` with no timeout. After startup, `hal_list_comp()` and `hal_list_funct()` acquire the same shared-data mutex before iteration. Thus one `halcmd list comp` has at least two source-confirmed unbounded acquisition opportunities; the exact failed-run site remains `UNKNOWN`.

There is also a timeout-signal subtlety: while `halcmd_startup()` is inside `hal_init()`, `hal_flag` is set. `halcmd`'s SIGTERM/SIGINT handler can defer immediate exit by recording `halcmd_done`, so TERM alone is not a reliable wall-clock bound for every startup path. A hard-kill fallback remains justified as diagnostic containment.

New September 5 source analysis adds a second boundary: `halpr_mutex_acquire()` increments shared `hal_data->lockcnt` before a contender may block. Killing a waiter can therefore strand shared lock accounting; killing an owner can strand `locktid`/`locklvl`/mutex state. LinuxCNC exposes `hal_mutex_force_release()`, but its source explicitly warns that forced release may crash the rest of the LinuxCNC applications. Therefore any forced-kill timeout branch is terminal evidence for that HAL instance: capture the live stack first, kill only for bounded cleanup, then abort without trusting later HAL observations. See `guides/A01-bounded-probe-errexit-lock-integrity.md`.

Community cross-check: LinuxCNC issue #2716 discusses HAL's fixed shared-memory resources and practical one-HAL-instance architecture. It remains `COMMUNITY-REPORTED` corroboration rather than implementation authority.

## Prepared branch state

`a01-bounded-observation` remains intentionally separate from `main` so September 5 cannot auto-trigger another paid lab run. The branch is currently six commits ahead of and twelve commits behind `main`; it must be reconciled rather than blindly merged.

Important branch commits:

- `13063ce8c01fe2f3c462974acee2f6ae7a7b80e1` — first shell `set -e` diagnostic correction.
- `42a78f98863ec6ad6cd07e75a0bfc2c0df2c8666` — preserve original stalled `halcmd` PID long enough for process state + privileged bounded GDB backtrace before TERM/KILL cleanup.
- `23f62c8cb319323c2389a591f8dde7c63f746d62` — adversarial follow-up: remove helper/caller global `set +e`/`set -e` toggles, capture expected failures through `if` conditions, and explicitly make a forced-kill readiness timeout terminal for that HAL instance.

The `23f62c8...` fix was prompted by a locally reproduced Bash failure: a helper that executes `set -e` immediately before `return 1` can terminate the shell even when the caller had disabled `errexit` in order to capture the function's status. This is `TEST-CONFIRMED` shell behavior; it does not require another full LinuxCNC build merely to establish the bug.

The GDB attachment result itself remains future experiment evidence. `sudo gdb -p` plus a bounded outer timeout is a diagnostic attempt, not a guarantee that hosted-runner ptrace policy will yield a usable stack.

## Laboratory compute-budget checkpoint

The curriculum target is a maximum of approximately four GitHub Actions laboratory hours per calendar day. September 5 already consumed the allowed budget through multiple long LinuxCNC experiments, including two 60-minute A01 attempts and the 75-minute third attempt. Do not merge the prepared branch to `main` or launch another full A01 run on September 5 because `lab-jobs/**`/workflow changes on `main` auto-trigger the runner. Research, source work, failure diagnosis, exam/correction work, and experiment preparation may continue without consuming laboratory compute.

No new Actions lab run was launched by the September 5 18:12Z session; the workflow is restricted to pushes on `main`, while the executable correction was committed only to `a01-bounded-observation`.

## A01 adversarial state

`exams/A01-process-component-architecture-adversarial.md` and `guides/A01-adversarial-corrections.md` cover the false premises and failure cases: all IPC is NML; `iocontrol.0` must be standalone; Task cannot precede motion; realtime should block on mutex contention; command echo means success; cancelled artifacts can be trusted; and old diagrams can be generalized to the pinned revision.

Additional corrections now include: a workflow timeout during a monolithic shell step does not establish which internal phase consumed the time; a loop count does not bound elapsed time when an internal command can block; `halcmd list comp` cannot be localized to list traversal because startup registration and list query both use the HAL lock; TERM-only timeout is insufficient while `hal_flag` is set; helper-level `set -e` can override a caller's intended status-capture context; diagnosing a replacement process after killing the original can destroy transient evidence; and a force-killed HAL-lock participant may leave shared lock accounting inconsistent, so post-kill HAL output must not be used as topology evidence.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Do **not** launch or auto-trigger another LinuxCNC lab run on September 5.
2. At the next laboratory-budget window, reconcile `a01-bounded-observation` with current `main`. Preserve `13063ce8...`, `42a78f988...`, and especially the follow-up `23f62c8...` conditional-status-capture/terminal-timeout correction. Do not resolve divergence by discarding later main-side research/checkpoints.
3. Before allowing the paid run, re-read the reconciled `004` script and verify there is no helper that re-enables global `errexit` before returning an expected nonzero status. Keep timeout/kill branches terminal for the current HAL instance.
4. Merge/apply the corrected lab/workflow changes to `main` and allow exactly one corrected `004` to auto-trigger; do not dispatch a duplicate.
5. Require fresh metadata identifying the corrected curriculum head and `004`; inspect process-readiness and HAL before/after markers before interpreting topology.
6. If a HAL probe stalls, inspect the captured original-PID backtrace first. Promote only the observed frame/call path: `hal_init()`/registration, `hal_list_comp()`/`hal_list_funct()` query, or remain `UNKNOWN` if caller frames are insufficient. A GDB attach failure is not evidence of either stage.
7. If a probe is forcibly terminated, end that experiment branch without subsequent HAL assertions against the same instance. Do not use `hal_mutex_force_release()` merely to continue the topology test; upstream labels that operation crash-risk recovery.
8. If `Key component assertions` executes without a prior forced-kill diagnostic, reconcile `ps`/`pgrep`, bounded HAL component/function output, and absence/presence of standalone `iocontrol`; then write the A01 fresh-AI handoff and perform graduation review.
9. If the 70-minute inner timeout fires, verify result publication succeeded and diagnose from the last progress marker rather than inferring phase from total runtime.
10. Do not change LinuxCNC source merely to make observation pass. Diagnostic instrumentation may observe the pinned binary, but upstream-source behavioral modification requires evidence of an actual defect and a separately bounded experiment.

The complete module graph remains in `CURRICULUM.md`.
