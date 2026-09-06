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
| H01 HAL architecture | GRADUATED | H01 lifecycle/call-flow/community/handoff guides | corrected `006` run `34018699909`, job `101447160463`, SHA `43fae7ea...` passed all gates | passed | object/connectivity semantics TEST-CONFIRMED for pinned host |
| H04 HAL execution ordering | GRADUATED | H04 guide/call-flow/community/handoff + accepted result | `007` run `34024102367`, job `101461896527`, SHA `f15451ee...` passed all gates | `exams/H04-adversarial-exam.md` + passing key | within-thread order/dataflow TEST-CONFIRMED; cross-thread/live mutation not promoted |
| M03 One servo-period trace | GRADUATED | M03 source/call-flow/accepted-result/handoff guides | `008` run `34029848545`, job `101477262140`, SHA `10f187e8...` passed all gates | passed | canonical loopback one-invocation phase relationship TEST-CONFIRMED; not universal latency |
| HM01 HostMot2 architecture | RESEARCH | `guides/HM01-hostmot2-registration-initial.md` | pending | pending | generic-core/LLIO registration boundary and major `hm2_register()` stages source-traced |
| E01 hm2_eth architecture | PLANNED | — | — | — | critical path |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | critical path |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Graduated evidence summary

Primary development revision remains `8bf4605ae81042248add031e94c77300406e0413`; stable reference remains `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

A01 accepted run `34000879408` observed the required process readiness, bounded HAL topology, `motmod`, `trivkins`, `iocontrol.0`, exactly one live `milltask`, and `iocontrol.0` HAL PID equal to the `milltask` PID. R01 accepted corrected run `34011177375` observed explicit non-realtime fallback, expected HAL periods, and actual TS scheduling for periodic pthreads. Neither result is a physical-machine realtime or safety qualification.

H01 accepted corrected run `34018699909` confirmed dummy→signal value preservation, linked propagation, unlink snapshot/separation, second-writer rejection, cyclic function scheduling, and positive thread execution on the pinned host. H01 graduated with its adversarial exam and fresh-AI handoff.

## H04 graduated result

Durable artifacts:

- `guides/H04-hal-execution-ordering.md`
- `forum-findings/H04-execution-ordering-field-notes.md`
- `call-flows/H04-addf-to-thread-dispatch.md`
- `lab-jobs/007-h04-execution-ordering.sh`
- `lab-results/H04-007-execution-ordering-accepted.md`
- `exams/H04-adversarial-exam.md`
- `exams/H04-adversarial-answer-key.md`
- `guides/H04-graduation-handoff.md`

Accepted `007` artifact metadata: curriculum SHA `f15451ee92f7f5d82310f6f182b20cdf10b51418`, Actions run `34024102367`, job `101461896527`, lab UTC `2026-09-06T09:14:59Z`–`09:19:17Z`, exit 0. Phase 1 displayed `sum2.0` before `sum2.1` and observed A=37, B=38, `B-A=1`. Duplicate non-reentrant add failed intentionally with rc=1 and the expected diagnostic. While stopped, threadbeat remained 19→19. After stopped delete/re-add at position +1, phase 2 displayed `sum2.1` before `sum2.0` and observed A=77, B=76, `A-B=1`, threadbeat=39. Completion marker was present.

The central H04 conclusion is therefore source-confirmed and test-confirmed at foundation depth: within one HAL thread pass, scheduled function entries execute sequentially in list order strongly enough for ordinary later-function dataflow to observe earlier-function updates. This does not create a total order across separate HAL threads and does not establish realtime deadlines, physical timing, safety, or safe live list mutation.

## M03 graduated result

Durable artifacts:

- `guides/M03-servo-period-trace-initial.md`
- `call-flows/M03-one-servo-period.md`
- `lab-jobs/008-m03-servo-cycle-loopback.sh`
- `lab-results/M03-008-servo-cycle-loopback-accepted.md`
- `exams/M03-adversarial-exam.md`
- `exams/M03-adversarial-answer-key.md`
- `guides/M03-graduation-handoff.md`

Accepted `008` metadata: curriculum SHA `10f187e8a33b741f9af5c12975150ddbb497af1a`, Actions run `34029848545`, job `101477262140`, lab UTC `2026-09-06T11:18:18Z`–`11:21:43Z`, exit 0. HAL order was command-handler < controller < sampler.0; sampler overruns were zero; 2175 moving samples were analyzed; `lag_avg=0`, `lag_max=0`, `same_avg=4.16551724138e-06`, `cmd_avg=0`, `cmd_max=0`; completion marker present.

The source-derived canonical loopback relationship is therefore TEST-CONFIRMED: with motor command directly looped to motor feedback and sampling after motion, published joint feedback in sample n reflects the prior motor-command signal value while the newly published joint command matches the current motor-command signal. This is configuration-specific and is not a universal one-servo-period LinuxCNC latency claim.

## HM01 current result

HM01 is now the active critical-path module. Initial documentation/community/source work is in `guides/HM01-hostmot2-registration-initial.md`.

Current source-grounded conclusions at `8bf4605...`:

- generic `hostmot2` and low-level board/transport drivers are separate architectural layers;
- a low-level driver populates `hm2_lowlevel_io_t` and calls exported `hm2_register()`;
- `hm2_register()` validates the LLIO contract, allocates a per-board `hostmot2_t`, parses config, optionally programs firmware, validates firmware identity/IDROM/descriptors through LLIO reads, initializes module/TRAM/HAL state, performs first read/write initialization, then exports per-board read/write HAL functions;
- missing queued-I/O callbacks fall back to synchronous wrappers around required `read`/`write` callbacks;
- registration failure removes the tentative board and cleans module state; `hm2_unregister()` attempts an immediate watchdog-safe action when a watchdog exists before cleanup, but no safety-rated conclusion is inferred;
- generic HostMot2 runtime orchestration calls through board-specific LLIO transport operations, which is the key boundary for later `hm2_eth` analysis.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and cross-process unusual mapping behavior: **2000 / MEDIUM**.
- Robust recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions across supported architectures: **2000 / HIGH**.
- Stable-vs-development comparison of ready/unready and object lifetime semantics: **2000 / MEDIUM**.
- H04 live `addf`/`delf` mutation race/support semantics while realtime dispatch is active: **2000 / HIGH**.
- H04 cross-thread signal memory visibility and cross-CPU ordering: **2000 / HIGH**.
- Development-only one-shot `initf` behavior versus stable 2.9.x: **2000 / MEDIUM**.
- M03 Task-side command mutex hold duration and command-to-echo latency distribution: **2000 / HIGH** unless needed by R05/T02 sooner.
- M03 full coordinated/free/teleop planner and kinematics branch trace: **M08/M01/M02 then 2000 / HIGH**; not required for foundation phase ordering.
- M03 cross-thread/base-thread exchange timing: **2000 / HIGH** unless required to make the one-servo-thread trace correct.
- HM01 exact IDROM/module descriptor semantics: **HM02 then 2000 / HIGH**.
- HM01 TRAM/register-cycle ordering: **HM03/HM09 / HIGH**.
- HM01 hotplug/re-registration/partial-failure lifetime edge cases: **2000 / MEDIUM-HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL** and requires representative hardware/human involvement.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC functional behavior is not safety certification.

## Current checkpoint / exact resume point

Continue **HM01 — HostMot2 architecture and registration lifecycle**.

1. Inventory pinned `hostmot2-lowlevel.h` / `hm2_lowlevel_io_t`: required callbacks, queued/split-read hooks, capability flags, board metadata, and error state.
2. Trace one concrete pinned low-level caller into `hm2_register()`—prefer `hm2_eth` only far enough to establish discovery/LLIO population/registration ownership, deferring Ethernet transaction mechanics to E01.
3. Trace `hm2_cleanup()` and module-descriptor dispatch sufficiently to document rollback/object lifetime and GTAG parser failure behavior.
4. Produce the HM01 function/call-flow guide joining low-level driver registration -> generic HostMot2 initialization -> HAL function export -> unregister.
5. Search for a simulation/test LLIO suitable for a bounded no-hardware registration experiment; design the experiment only after the source claims are explicit.
