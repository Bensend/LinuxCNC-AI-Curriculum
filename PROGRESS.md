# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; pinned launcher/task/motion source | `004` timed out twice during build at former 60-minute ceiling; hardened 75-minute rerun `33965517203` queued | adversarial exam + corrections complete | Runtime topology still needs successful fresh observation before handoff/graduation |
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

## A01 experiment correction

Runs `33957356410` and `33960179986` both exhausted the former 60-minute workflow ceiling while building LinuxCNC and never reached the runtime topology assertions. Neither is topology evidence. The first cancellation also exposed a laboratory integrity bug: because `LATEST.*` files from repository checkout remained present, `if: always()` publication could upload/recommit stale prior results after cancellation.

The lab runner was hardened in commit `360a06030319ad3eaa4a83b211aa52386ca51b9c`: it now deletes checked-out `LATEST.*` files before executing a job, uses `if-no-files-found: warn` for cancellation-safe artifact handling, and permits 75 minutes so this already-near-complete source build has a bounded additional window. The 004 script was retriggered by commit `06c7bf7f0602fa577d20a00f92cef82527c61df2`; Actions run `33965517203` is the current candidate. A successful workflow is insufficient by itself: its metadata must identify `004-a01-runtime-topology`, source commit `06c7bf7...`, and pinned LinuxCNC commit `8bf4605...`, and its actual assertions must have executed.

## A01 adversarial state

`exams/A01-process-component-architecture-adversarial.md` and `guides/A01-adversarial-corrections.md` cover the false premises and failure cases: all IPC is NML; `iocontrol.0` must be standalone; Task cannot precede motion; realtime should block on mutex contention; command echo means success; cancelled artifacts can be trusted; and old diagrams can be generalized to the pinned revision.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Inspect Actions run `33965517203`. Reject it unless fresh metadata identifies job `004-a01-runtime-topology`, curriculum source commit `06c7bf7f0602fa577d20a00f92cef82527c61df2`, and the script output names pinned LinuxCNC commit `8bf4605ae81042248add031e94c77300406e0413`.
2. If assertions ran, reconcile `ps`/`pgrep`, `halcmd list comp`, and `halcmd list funct`: `linuxcncsvr` and `milltask` processes; `iocontrol.0`, `motmod`, and `trivkins` HAL components; no standalone `iocontrol` process. Promote only observed claims to `TEST-CONFIRMED`.
3. If the 75-minute run still cannot reach assertions, stop spending repeated full builds: redesign 004 around a reusable build artifact/cache or a narrower supported build target and document the cost/validity tradeoff.
4. After successful experiment reconciliation, write the A01 fresh-AI handoff and graduate A01. Then begin R01 Realtime Model.

The complete module graph remains in `CURRICULUM.md`.
