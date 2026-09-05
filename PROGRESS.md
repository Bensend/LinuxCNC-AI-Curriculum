# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; pinned launcher/task/motion source | `004-a01-runtime-topology` first run timed out during build; corrected headless rerun `33960179986` in progress | `exams/A01-process-component-architecture-adversarial.md` created | Command/ack endpoint now closed to realtime `emcmotCommandHandler`; runtime topology still needs successful observation before correction/handoff/graduation |
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

Initial workflow run `33957356410` was **cancelled at the workflow's 60-minute timeout** while the full LinuxCNC build was still running. It never reached the topology assertions. Because cancellation occurred inside the shell step before the new result files were generated, the always-run artifact/commit steps uploaded and recommitted stale `lab-results/LATEST.*` content from the prior stable `003` checkout. Therefore neither that artifact nor the misleading bot commit is A01 topology evidence.

The lab was corrected in commit `26cf7fd3266741db2943211fe538ca145a3a0743` to configure the same pinned LinuxCNC revision with `--disable-gui --disable-manpages --disable-build-documentation`. LinuxCNC's own documentation explicitly provides `--disable-build-documentation`, and upstream CI uses these headless switches for RIP builds. Corrected workflow run `33960179986` was in progress at this checkpoint.

## A01 adversarial state

`exams/A01-process-component-architecture-adversarial.md` now attacks these false premises and failure cases:

- all LinuxCNC IPC is NML;
- `iocontrol.0` must be a standalone process;
- Task cannot start before motion is fully running;
- mutex contention should block realtime motion;
- `commandNumEcho` alone means command success;
- cancelled workflow artifacts can be trusted without checking metadata/version;
- old community diagrams can be generalized to the pinned revision.

The exam also includes a bounded diagnostic-counter modification task and a runtime process-vs-HAL observation design.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Inspect corrected Actions run `33960179986` and its generated metadata/output. Verify it actually names job `004-a01-runtime-topology`, source commit `26cf7fd...`, and pinned LinuxCNC commit `8bf4605...`; reject stale result files even if the workflow reports success.
2. Reconcile each prediction with `ps`/`pgrep`, `halcmd list comp`, and `halcmd list funct`: `linuxcncsvr` and `milltask` processes; `iocontrol.0`, `motmod`, and `trivkins` HAL components; no standalone `iocontrol` process.
3. If the rerun passes, promote only those topology claims to `TEST-CONFIRMED`. If it fails, preserve the exact runtime/configuration discrepancy before patching.
4. Perform the A01 correction pass against `exams/A01-process-component-architecture-adversarial.md`, then write a fresh-AI handoff artifact. Graduate A01 only after experiment reconciliation + corrections/handoff pass.
5. Once A01 graduates, begin R01 Realtime Model from official realtime documentation, current community failure reports, and pinned RTAPI/source boundaries.

The complete module graph remains in `CURRICULUM.md`.
