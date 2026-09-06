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
| H04 HAL execution ordering | EXPERIMENT | `guides/H04-hal-execution-ordering.md`; `call-flows/H04-addf-to-thread-dispatch.md`; community notes | `007` run `34024102367`, job `101461896527`, SHA `f15451ee...` launched | pending | within-thread list semantics source-traced; live list mutation promoted, not assumed safe |
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

## H04 current result

Durable artifacts created this lesson:

- `guides/H04-hal-execution-ordering.md`
- `forum-findings/H04-execution-ordering-field-notes.md`
- `call-flows/H04-addf-to-thread-dispatch.md`
- `lab-jobs/007-h04-execution-ordering.sh`

Core source conclusions at `8bf4605...`: `hal_add_funct_to_thread()` constructs an explicit ordered `thread->funct_list`; `thread_task()` calls entries sequentially in next-link order; `hal_start_threads()` / `hal_stop_threads()` set/clear the shared dispatch gate rather than creating/deleting each RTAPI task; each HAL thread is its own RTAPI task; non-reentrant duplicate scheduling is rejected via `funct->users`; deletion routes through `free_funct_entry_struct()` which decrements `users` and permits later re-add.

Important boundary: add/delete configuration takes the HAL mutex but `thread_task()` traverses the function list without that mutex, and no explicit `threads_running == 0` guard was found in add/delete. Live mutation semantics are therefore not assumed safe in H04. The bounded `007` experiment mutates ordering only while dispatch is stopped.

`007` was launched once from curriculum SHA `f15451ee92f7f5d82310f6f182b20cdf10b51418`: Actions run `34024102367`, job `101461896527`. Predeclared gates distinguish configured list order from actual same-cycle dataflow using two cross-coupled `sum2` functions, exercise duplicate non-reentrant rejection, verify stopped `threadbeat` stability, then stop/delete/re-add/restart with reversed order.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and cross-process unusual mapping behavior: **2000 / MEDIUM**.
- Robust recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions across supported architectures: **2000 / HIGH**.
- Stable-vs-development comparison of ready/unready and object lifetime semantics: **2000 / MEDIUM**.
- H04 live `addf`/`delf` mutation race/support semantics while realtime dispatch is active: **2000 / HIGH**.
- H04 cross-thread signal memory visibility and cross-CPU ordering: **2000 / HIGH**.
- Development-only one-shot `initf` behavior versus stable 2.9.x: **2000 / MEDIUM**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL** and requires representative hardware/human involvement.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC functional behavior is not safety certification.

## Current checkpoint / exact resume point

Continue **H04 — HAL execution ordering**.

1. Inspect exactly Actions run `34024102367` / job `101461896527`; do not launch a duplicate while it is active.
2. Require fresh metadata for SHA `f15451ee92f7f5d82310f6f182b20cdf10b51418` and job `007-h04-execution-ordering.sh`.
3. Reconcile every predeclared gate: phase-1 `show thread` A-before-B, duplicate non-reentrant add failure, phase-1 `B-A ~= 1`, stable stopped `threadbeat`, stopped `delf` + successful re-add at `+1`, phase-2 `show thread` B-before-A, phase-2 `A-B ~= 1`, increasing beat after restart, completion marker.
4. If the run is harness-invalid, correct only log-proven harness errors before one materially corrected rerun; do not promote semantic claims from a harness-invalid run.
5. If valid, promote the observed subset to `TEST-CONFIRMED`, create/grade the H04 adversarial exam, incorporate corrections, run the fresh-AI handoff, and decide 1000-level graduation.
6. Preserve live-list mutation, cross-thread memory ordering, and version-depth questions in the 2000-series queue rather than expanding H04 indefinitely.
