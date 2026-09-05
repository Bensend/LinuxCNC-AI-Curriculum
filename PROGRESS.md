# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | EXPERIMENT | `guides/A01-process-component-architecture.md`; pinned launcher, `Submakefile`, `emctaskmain.cc`, `taskintf.cc`, `usrmotintf.cc`, `taskclass.cc` | `004-a01-runtime-topology` launched as run `33957356410`; result pending at checkpoint | pending | Source trace now distinguishes UI↔Task NML from Task↔motion RTAPI shared memory; `iocontrol.0` is Task-owned HAL component inside milltask at dev pin |
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

Stable experiment `003`, Actions run `33952061943`, completed successfully against exact LinuxCNC `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a`. The stable checkout's own build system, RIP environment, `scripts/runtests`, and `tests/realtime-math` produced `1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped`, with `runtests` exit `0`. `halcompile` built/installed `rtmath.so`, `halrun dotest.hal` succeeded, and the runner reported POSIX non-realtime operation.

This confirmed the predicted stable-vs-development harness difference rather than contradicting it. Development run `33949095338` reports the additional `0 shmem errors` field and its pinned source contains explicit recognized-key shared-memory pre/post hygiene; the inspected stable harness does not contain that same explicit path. Wrapper-level `ipcs -m` snapshots were clean in both bounded experiments, which is an observation and not evidence that the stable harness implements development's cleanup mechanism.

`guides/Phase0-graduation-handoff.md` records the adversarial correction pass, failure-diagnosis workflow, bounded cross-version modification rules, remaining unknowns, and the fresh-AI operating contract. L00-L03 are therefore graduated without claiming realtime scheduling, hardware suitability, functional safety, full-suite compatibility, or later subsystem behavior.

## A01 source-level architecture result so far

`guides/A01-process-component-architecture.md` now reconstructs the runtime architecture at development commit `8bf4605ae81042248add031e94c77300406e0413` rather than relying on the earlier coarse diagram.

Source-confirmed findings:

- `scripts/linuxcnc.in` starts `linuxcncsvr` first because it creates/owns NML buffers, then starts the realtime/RTAPI/HAL backend, loads trajectory/homing modules, starts configured Task, loads optional userspace HAL interfaces, executes HAL files/commands, calls `halcmd start`, then launches applications/display;
- ordinary machine HAL files load kinematics and `motmod` after Task has already been started, explaining why Task retries motion initialization during startup;
- `src/emc/task/Submakefile` links `emctaskmain.cc`, `taskintf.cc`, `usrmotintf.cc`, `taskclass.cc`, and related sources into the concrete `milltask` executable;
- `emctask_startup()` attaches `emcCommand`, `emcStatus`, and `emcError` NML channels, then initializes I/O before retrying motion connection and initializing interpreter/Task;
- Task→motion is **not an RCS NML channel**: `taskintf.cc` builds `emcmot_command_t`; `usrmotWriteEmcmotCommand()` copies it through an RTAPI shared `emcmot_struct_t` command area under a mutex and polls shared motion status for a matching `commandNumEcho` or timeout;
- `Task::Task()` calls `hal_init("iocontrol.0")`, and `Task::iocontrol_hal_init()` exports the tool/coolant/enable handshake pins. Because `taskclass.cc` is linked into `milltask`, `iocontrol.0` is an integrated userspace HAL component owned by Task at this revision, not a separate launcher-started `iocontrol` process.

These distinctions are architecturally important for later realtime/HAL/HostMot2 work: NML/RCS UI↔Task communication, RTAPI Task↔motion shared memory, and HAL component/pin communication are separate interfaces and must not be conflated.

## A01 experiment state

`lab-jobs/004-a01-runtime-topology.sh` was committed at curriculum commit `55dd6f9956a65c4c4b18b3d1a344c87fb0e70d97`, triggering Actions run `33957356410`.

The experiment builds exact development commit `8bf4605...`, launches the upstream headless `tests/linuxcncrsh/linuxcncrsh-test.ini` simulation, captures a process snapshot plus `halcmd list comp` and `halcmd list funct`, and checks the pre-registered prediction that:

- `linuxcncsvr` and `milltask` are OS processes;
- `iocontrol.0`, `motmod`, and `trivkins` are visible HAL components;
- no separate executable named `iocontrol` is running.

The experiment is explicitly topology-only and cannot qualify realtime scheduling, latency, hardware timing or safety. At this checkpoint workflow run `33957356410` is still pending/in progress; its result must be inspected before any prediction is promoted to `TEST-CONFIRMED`.

## Current checkpoint / exact resume point

Continue A01; R01 remains blocked.

1. Inspect Actions run `33957356410` and the resulting `lab-results/LATEST.md`. Reconcile each 004 prediction with actual process/HAL output; if it fails, diagnose and preserve the exact failed architecture/startup assumption before modifying the test.
2. If 004 passes, update A01 claims with `TEST-CONFIRMED` runtime-topology evidence.
3. Trace the realtime receiving endpoint for the shared `emcmot_struct_t.command` just far enough to identify where `commandNumEcho` is produced and close the command/ack call flow. Leave full servo-period internals to M03.
4. Create the A01 adversarial exam. It must attack the false premises "all LinuxCNC IPC is NML", "iocontrol.0 must be a process", and "launcher startup order means Task waits until motion is fully running before it starts"; include one failure-path trace and a bounded architecture/source modification task.
5. Incorporate corrections and perform the fresh-AI handoff. Only after that may A01 graduate and unblock R01.

The complete module graph remains in `CURRICULUM.md`.
