# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | GitHub Actions smoke/build/test results + official build docs + `guides/Phase0-graduation-handoff.md` | `000-smoke` passed; `001-build-linuxcnc` passed; `002` development representative test passed; stable `003` also passed | Phase-0 adversarial exam + correction/handoff complete | Reproducible software lab established; Actions runner is explicitly not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md`; exact stable tag dereference; stable/development experiments | development `8bf4605ae81042248add031e94c77300406e0413` and stable `86cdca76fa2a36274c432caa21952b23c267989a` both built/tested | covered by Phase-0 exam and handoff | Stable `v2.9.10` experimentally confirmed; native harness differences preserved |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md`; representative-test guide; pinned `src/Makefile` and `scripts/runtests.in` | development `002` and stable `003` each ran native upstream `tests/realtime-math` 1/1 | Phase-0 adversarial exam + corrections complete | Development/stable summary and shmem-hygiene differences are version-scoped; no realtime overclaim |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; `guides/Phase0-graduation-handoff.md` | exercised on build failure, stable/development comparison, and realtime-evidence boundary | Phase-0 adversarial/handoff pass complete | Evidence classes/conflict handling demonstrated on real contradictions/traps |
| A01 Process/component architecture | RESEARCH | `guides/A01-process-component-architecture.md`; current Code Notes; pinned `scripts/linuxcnc.in` and `emctaskmain.cc` | process-observation lab not yet created | pending | Initial runtime map distinguishes launcher, non-realtime Task, realtime motion and HAL; exact startup/transport trace next |
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

## A01 work started

`guides/A01-process-component-architecture.md` begins the runtime architecture map at development commit `8bf4605ae81042248add031e94c77300406e0413`.

Initial evidence establishes:

- current official Code Notes describe Task/interpreter coordinating motion and discrete I/O, with motion on the realtime side and non-realtime Task/GUI code communicating across the boundary through shared-memory messaging and HAL;
- `scripts/linuxcnc.in` is a userspace launcher/orchestration entry point, not the motion controller itself;
- `src/emc/task/emctaskmain.cc` documents and implements cyclic Task planning/execution, machine state/mode gating, interpreter-list sequencing, and command/status/error NML channel objects;
- community discussions are preserved as investigation leads showing that a defined NML message is not automatically executable in every Task mode/state and that public status does not necessarily preserve authored G-code identity.

## Current checkpoint / exact resume point

Continue A01, not Phase 0.

1. Trace the remaining startup section of `scripts/linuxcnc.in` at development commit `8bf4605ae81042248add031e94c77300406e0413` and record exact startup order for realtime backend, HAL, kinematics/motion modules, Task, UI and auxiliary processes.
2. Locate the concrete `milltask` executable/main build entry and trace initialization of Task command/status/error NML channels.
3. Trace the first concrete Task→motion userspace interface calls and identify the actual command/status transport boundary rather than labeling all communication generically as NML.
4. Resolve the runtime role of `iocontrol`/discrete I/O from source.
5. Add a bounded A01 lab job that launches a minimal simulation configuration and preserves a process tree plus HAL component/function inventory; use it only for runtime topology, not realtime timing claims.
6. Then build the A01 function/call-flow guide, adversarial exam and fresh-AI handoff before unblocking R01.

The complete module graph remains in `CURRICULUM.md`.
