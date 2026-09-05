# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; `guides/A01-lab-observation-validity.md`; `guides/A01-runtime-observation-hang-diagnosis.md`; pinned launcher/task/motion source | `004` timed out twice at 60 min; third run `33965517203` timed out at 75 min but decoded job logs prove runtime had launched; corrected bounded-observation rerun pending next lab-budget window | adversarial exam + corrections complete | Immediate blocker is now an unbounded runtime observation/HAL-query path, not a proven build-time ceiling; A01 still needs fresh intended assertions before handoff/graduation |
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

The intended `Key component assertions` still did not complete and no fresh `LATEST.*`/`run-33965517203-1` result was produced, so A01 topology claims are not promoted to `TEST-CONFIRMED`. `guides/A01-runtime-observation-hang-diagnosis.md` records the constrained working hypothesis: the nominally 20-second readiness loop is not actually bounded because `halcmd list comp` has no per-command timeout; one blocked HAL query can hold the script indefinitely. Upstream `scripts/linuxcnc.in` itself uses `halcmd list comp`, confirming the command is legitimate, but the exact blocking instruction remains `INFERENCE` until progress markers/bounded probes verify it.

The immediate correction is therefore to bound every external `halcmd` observation with `timeout`, separately wait for controller process presence, add before/after progress markers, capture process/lock/runtime logs on HAL-query failure, and make the workflow preserve the partial run directory even when the lab shell is cancelled. The reusable pinned-build artifact/cache design remains a useful future efficiency improvement but is no longer the immediate A01 blocker.

## Laboratory compute-budget checkpoint

The curriculum target is a maximum of approximately four GitHub Actions laboratory hours per calendar day. September 5 already consumed the allowed budget through multiple long LinuxCNC experiments, including the two 60-minute A01 attempts and the 75-minute third attempt. Do not launch another full A01 run on September 5. Research, source work, failure diagnosis, exam/correction work, and experiment patch preparation may continue without consuming laboratory compute.

## A01 adversarial state

`exams/A01-process-component-architecture-adversarial.md` and `guides/A01-adversarial-corrections.md` cover the false premises and failure cases: all IPC is NML; `iocontrol.0` must be standalone; Task cannot precede motion; realtime should block on mutex contention; command echo means success; cancelled artifacts can be trusted; and old diagrams can be generalized to the pinned revision.

A new adversarial correction from run `33965517203`: a workflow timeout during a monolithic shell step does not establish which internal phase consumed the time. Runner cleanup proved LinuxCNC runtime processes were alive, invalidating the previous build-boundary assumption. Similarly, a readiness loop is not truly bounded when a command inside the loop lacks its own timeout.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Do **not** launch another LinuxCNC lab run on September 5.
2. At the next laboratory-budget window, patch `lab-jobs/004-a01-runtime-topology.sh` so every `halcmd` query is individually timeout-bounded and progress-marked; wait for `milltask`/`linuxcncsvr` separately and capture diagnostics on HAL-query timeout.
3. Harden `.github/workflows/lab-runner.yml` so partial `run-${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}` stdout/stderr is uploadable even if the lab shell never returns; do not depend on a step output emitted only after completion.
4. Run exactly one corrected `004`. If `Key component assertions` executes, reconcile `ps`/`pgrep`, `halcmd list comp`, and `halcmd list funct`, write the A01 fresh-AI handoff, and graduate A01.
5. If a bounded HAL query fails, preserve the fresh partial logs and investigate HAL attachment/readiness. Do not repeat the unchanged full build.

The complete module graph remains in `CURRICULUM.md`.
