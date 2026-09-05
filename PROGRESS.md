# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; `guides/A01-lab-observation-validity.md`; `guides/A01-runtime-observation-hang-diagnosis.md`; `guides/A01-halcmd-observation-boundary.md`; pinned launcher/task/motion/HAL utility source | `004` timed out twice at 60 min; third run `33965517203` timed out at 75 min after runtime launch; corrected bounded-observation patch prepared on branch `a01-bounded-observation` | adversarial exam + corrections complete | HAL observation is now externally bounded and process readiness separated; next lab run waits for next compute-budget window |
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

The intended `Key component assertions` still did not complete and no fresh `LATEST.*`/`run-33965517203-1` result was produced, so A01 topology claims are not promoted to `TEST-CONFIRMED`. Source inspection now further constrains the hang diagnosis: `halcmd_main.c::main()` calls `halcmd_startup(0)` before it dispatches the requested command, so an apparent `halcmd list comp` hang cannot yet be localized to list traversal. The whole `halcmd` process must be treated as the externally bounded observation unit.

Prepared branch `a01-bounded-observation` contains two committed corrections without consuming another September 5 lab run: `004` separately waits for `milltask`/`linuxcncsvr`, wraps each `halcmd` in a 3-second external timeout with before/after progress markers and timeout diagnostics, and the workflow runs the lab under a 70-minute inner timeout inside its 75-minute job ceiling so publication has a cleanup window. The artifact path no longer depends on a post-completion step output. `guides/A01-halcmd-observation-boundary.md` records the source/evidence reasoning.

## Laboratory compute-budget checkpoint

The curriculum target is a maximum of approximately four GitHub Actions laboratory hours per calendar day. September 5 already consumed the allowed budget through multiple long LinuxCNC experiments, including the two 60-minute A01 attempts and the 75-minute third attempt. Do not merge the prepared branch to `main` or launch another full A01 run on September 5 because `lab-jobs/**`/workflow changes on `main` auto-trigger the runner. Research, source work, failure diagnosis, exam/correction work, and experiment preparation may continue without consuming laboratory compute.

## A01 adversarial state

`exams/A01-process-component-architecture-adversarial.md` and `guides/A01-adversarial-corrections.md` cover the false premises and failure cases: all IPC is NML; `iocontrol.0` must be standalone; Task cannot precede motion; realtime should block on mutex contention; command echo means success; cancelled artifacts can be trusted; and old diagrams can be generalized to the pinned revision.

Additional correction: a workflow timeout during a monolithic shell step does not establish which internal phase consumed the time. Likewise, a loop count does not bound elapsed time when a command inside the loop can itself block. Source shows `halcmd` performs startup/attachment before dispatching `list`, so the next experiment must not over-localize the internal wait without evidence.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Do **not** launch or auto-trigger another LinuxCNC lab run on September 5.
2. At the next laboratory-budget window, merge/apply branch `a01-bounded-observation` to `main` and run exactly one corrected `004` (the main-branch push may itself auto-trigger it; do not dispatch a duplicate).
3. Require fresh metadata identifying the corrected curriculum head and `004`; inspect progress markers before interpreting topology.
4. If `Key component assertions` executes, reconcile `ps`/`pgrep`, bounded `halcmd list comp`, and bounded `halcmd list funct`; write the A01 fresh-AI handoff and graduate A01.
5. If a bounded `halcmd` times out, preserve the fresh partial logs and trace `halcmd_startup()` plus HAL shared-memory/mutex attachment at pinned revision before any rerun. Do not repeat the unchanged full build.
6. If the 70-minute inner timeout fires, verify result publication succeeded; diagnose from the last progress marker rather than inferring the phase from total runtime.

The complete module graph remains in `CURRICULUM.md`.
