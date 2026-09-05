# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; `call-flows/A01-task-to-motion-command-ack.md`; `guides/A01-lab-observation-validity.md`; pinned launcher/task/motion source | `004` timed out twice during build at former 60-minute ceiling; hardened 75-minute rerun `33965517203` still active at this checkpoint | adversarial exam + corrections complete | Runtime topology still needs successful fresh observation before handoff/graduation; no duplicate/full rebuild while current run is active |
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

The lab runner was hardened in commit `360a06030319ad3eaa4a83b211aa52386ca51b9c`: it now deletes checked-out `LATEST.*` files before executing a job, uses `if-no-files-found: warn` for cancellation-safe artifact handling, and permits 75 minutes so this already-near-complete source build has a bounded additional window. The 004 script was retriggered by commit `06c7bf7f0602fa577d20a00f92cef82527c61df2`; Actions run `33965517203` is the current candidate. At the 2026-09-05T13:10Z lesson it was still in `Run lab job and capture complete output`, more than 55 minutes after start; no topology claim was promoted.

`guides/A01-lab-observation-validity.md` now defines the exact freshness/assertion requirements and a source-grounded fallback. The upstream `tests/linuxcncrsh/linuxcncrsh-test.ini` explicitly selects `milltask`, `motmod`, `trivkins`, `linuxcncrsh`, and `lcncrsh_sim.hal`; the HAL file loads the configured kinematics/motion components and wires `iocontrol.0` loopbacks. This establishes what the topology experiment actually depends on and prevents a guessed partial build from being treated as equivalent.

If the 75-minute candidate times out, the preferred fallback is a reusable pinned run-in-place build artifact (or cache acceleration) keyed by LinuxCNC commit and configure/toolchain identity, followed by a short consumer job that verifies provenance and runs only the topology observation. A guessed hand-maintained minimal target list is explicitly rejected until the upstream Make dependency graph proves all required runtime dependencies.

## Laboratory compute-budget checkpoint

The curriculum target is a maximum of approximately four GitHub Actions laboratory hours per calendar day. September 5 already contains multiple long LinuxCNC source-build experiments, including two approximately 60-minute failed A01 attempts and the current long-running candidate in addition to earlier Phase-0 builds/tests. Do not trigger a fourth full A01 source build today merely because `33965517203` fails. Continue source/documentation/handoff preparation and implement/launch any reusable-build fallback only when doing so is consistent with the daily lab budget.

## A01 adversarial state

`exams/A01-process-component-architecture-adversarial.md` and `guides/A01-adversarial-corrections.md` cover the false premises and failure cases: all IPC is NML; `iocontrol.0` must be standalone; Task cannot precede motion; realtime should block on mutex contention; command echo means success; cancelled artifacts can be trusted; and old diagrams can be generalized to the pinned revision.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Inspect Actions run `33965517203`. Reject it unless fresh metadata identifies job `004-a01-runtime-topology`, curriculum source commit `06c7bf7f0602fa577d20a00f92cef82527c61df2`, the script output names pinned LinuxCNC commit `8bf4605ae81042248add031e94c77300406e0413`, and the `Key component assertions` section actually executed.
2. If assertions ran, reconcile `ps`/`pgrep`, `halcmd list comp`, and `halcmd list funct`: `linuxcncsvr` and `milltask` processes; `iocontrol.0`, `motmod`, and `trivkins` HAL components; no standalone `iocontrol` process. Promote only observed claims to `TEST-CONFIRMED`.
3. After successful experiment reconciliation, write the A01 fresh-AI handoff and graduate A01. Then begin R01 Realtime Model.
4. If the 75-minute run still cannot reach assertions, do **not** launch another full rebuild today. Use `guides/A01-lab-observation-validity.md` as the design contract for a reusable pinned run-in-place build artifact/cache consumer, preserving exact source/configuration provenance and the same upstream linuxcncrsh runtime assertions.

The complete module graph remains in `CURRICULUM.md`.
