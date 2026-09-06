# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | GRADUATED | `guides/Phase0-graduation-handoff.md` | `000`, `001`, development `002`, stable `003` passed | Phase-0 exam complete | Actions is not realtime qualification |
| L01 Version pinning | GRADUATED | `guides/L01-version-baseline.md` | dev `8bf4605...`; stable `86cdca76...` | Phase-0 | stable v2.9.10 confirmed |
| L02 Repository/build/test map | GRADUATED | `guides/L02-build-test-map.md` | representative upstream test passed | Phase-0 | POSIX non-realtime evidence only |
| L03 Evidence/claims workflow | GRADUATED | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md` | exercised | Phase-0 | evidence/conflict workflow demonstrated |
| A01 Process/component architecture | GRADUATED | A01 architecture/call-flow/handoff guides | corrected `004` run `34000879408` | passed | topology/ownership TEST-CONFIRMED for pinned simulation |
| R01 Realtime model | GRADUATED | R01 model/call-flow/boundary/handoff guides | corrected `005` run `34011177375` | passed | fallback scheduler/period behavior confirmed; no physical latency claim |
| H01 HAL architecture | GRADUATED | H01 lifecycle/call-flow/community/handoff guides | corrected `006` run `34018699909`, job `101447160463`, SHA `43fae7ea...` passed all gates | `exams/H01-adversarial-exam.md` + passing answer key | object/connectivity semantics TEST-CONFIRMED for pinned host; no realtime/physical/safety claim |
| H04 HAL execution ordering | PLANNED | — | — | — | **next critical path**, unblocked by H01 graduation |
| M03 One servo-period trace | PLANNED | — | — | — | critical path |
| HM01 HostMot2 architecture | PLANNED | — | — | — | critical path |
| E01 hm2_eth architecture | PLANNED | — | — | — | critical path |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | critical path |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Graduated evidence summary

Primary development revision remains `8bf4605ae81042248add031e94c77300406e0413`; stable reference remains `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

A01 accepted run `34000879408` observed the required process readiness, bounded HAL topology, `motmod`, `trivkins`, `iocontrol.0`, exactly one live `milltask`, and `iocontrol.0` HAL PID equal to the `milltask` PID. R01 accepted corrected run `34011177375` observed explicit non-realtime fallback, expected HAL periods, and actual TS scheduling for periodic pthreads. Neither result is a physical-machine realtime or safety qualification.

## H01 graduated result

Durable artifacts:

- `guides/H01-hal-object-lifecycle-initial.md`
- `call-flows/H01-registration-connectivity-and-function-scheduling.md`
- `forum-findings/H01-connectivity-ready-state-field-notes.md`
- `lab-jobs/006-h01-hal-object-connectivity.sh`
- `exams/H01-adversarial-exam.md`
- `exams/H01-adversarial-answer-key.md`
- `guides/H01-graduation-handoff.md`
- `checkpoints/H01-2026-09-06T0810Z-graduation.md`

Core source conclusions: HAL is a shared-memory object graph rooted at `hal_data_t`; component readiness is reversible lifecycle state rather than a global freeze; unlinked pins use component dummy storage; linking redirects pin data pointers to signal-owned shared storage; unlinking restores dummy storage with the scalar snapshot studied; writer conflicts are enforced object-model invariants; function export is distinct from `addf` scheduling and periodic dispatcher execution.

Corrected bounded experiment `006`, Actions run `34018699909`, job `101447160463`, curriculum SHA `43fae7ea1835058e9f6e85b9c5adcb7360f35195`, exited 0 with fresh metadata. Accepted observations: 1.25 dummy→signal preservation; linked propagation to 2.5; unlink snapshot retained pin 2.5 while signal later became 3.5; second OUT writer rejected with rc=1 and explicit diagnostic; `siggen.0.update` scheduled under a 1,000,000 ns thread; positive threadbeat 254; completion marker reached. These are TEST-CONFIRMED only for the pinned software/host.

The H01 adversarial exam and fresh-AI handoff pass. H01 therefore graduates at the 1000 level.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and cross-process unusual mapping behavior: **2000 / MEDIUM**.
- Robust recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions across supported architectures: **2000 / HIGH**.
- Stable-vs-development comparison of ready/unready and object lifetime semantics: **2000 / MEDIUM**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL** and requires representative hardware/human involvement.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC functional behavior is not safety certification.

## Current checkpoint / exact resume point

Begin **H04 — HAL execution ordering**, now unblocked by H01 graduation.

1. Establish documented semantics for HAL threads, `addf` position/order, start/stop, and function constraints.
2. Search community/developer history for ordering mistakes, multi-thread function restrictions, overruns, mutation/reconfiguration traps, and debugging practice.
3. At pinned development SHA, source-trace `hal_add_funct_to_thread()`, function-user accounting and insertion semantics, `thread_task()` traversal/execution, thread start/stop, and relevant failure branches.
4. Build a symbol/call-flow guide that distinguishes within-thread deterministic list order from cross-thread scheduler timing; do not infer realtime determinism from list order.
5. Predeclare and run one bounded software experiment only after source analysis identifies discriminating observations.
6. Preserve any deeper concurrency/timing uncertainty in the 2000-series queue rather than expanding H04 without bound.
