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
| H04 HAL execution ordering | GRADUATED | H04 guide/call-flow/community/handoff + accepted result | `007` run `34024102367`, job `101461896527`, SHA `f15451ee...` passed all gates | passed | within-thread order/dataflow TEST-CONFIRMED; cross-thread/live mutation not promoted |
| M03 One servo-period trace | GRADUATED | M03 source/call-flow/accepted-result/handoff guides | `008` run `34029848545`, job `101477262140`, SHA `10f187e8...` passed all gates | passed | canonical loopback phase relationship TEST-CONFIRMED; not universal latency |
| HM01 HostMot2 architecture | GRADUATED | `guides/HM01-graduation-handoff.md`; call flow + accepted result | corrected `009` run `34038328272`, job `101500386969`, SHA `b3cdebcd...` passed all gates | passed | fake-LLIO malformed-registration rejection TEST-CONFIRMED; no physical transport/safety claim |
| E01 hm2_eth architecture | RESEARCH | initial work pending this session | — | — | active critical path after HM01 |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | critical path |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Version baseline

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`. Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

## Graduated evidence summary

A01 accepted run `34000879408` confirmed the required process/HAL topology for its pinned simulation. R01 corrected run `34011177375` confirmed explicit non-realtime fallback, expected HAL periods, and TS scheduling for periodic pthreads. H01 corrected run `34018699909` confirmed dummy/signal linkage semantics, second-writer rejection and cyclic function execution. H04 run `34024102367` confirmed same-thread configured function order drives same-cycle dataflow, while cross-thread ordering/live mutation remained outside the promoted claim. M03 run `34029848545` confirmed the canonical direct motor-command→feedback loopback phase relationship while explicitly rejecting a universal latency claim. HM01 corrected run `34038328272` confirmed the exercised fake-LLIO malformed HostMot2 registration paths reject the 15 upstream matrix cases and an independent bad-cookie case. None of these cloud results is physical-machine realtime or safety qualification.

## HM01 graduation result

HM01 is **GRADUATED** at 1000-level foundation depth.

Durable artifacts:

- `guides/HM01-hostmot2-registration-initial.md`
- `call-flows/HM01-lowlevel-registration-lifecycle.md`
- `lab-jobs/009-hm01-registration-validation.sh`
- `lab-results/HM01-009-accepted-34038328272.md`
- `exams/HM01-adversarial-exam.md`
- `exams/HM01-adversarial-answer-key.md`
- `guides/HM01-graduation-handoff.md`

Accepted runtime evidence is corrected run `34038328272` / job `101500386969` at curriculum SHA `b3cdebcd51653aaf415d2c9032cc045518a966d0`. The downloaded artifact matched the intended job, built pinned LinuxCNC `8bf4605...`, reported `expected-patterns=15 observed-pattern-lines=15`, rejected the independent bad-cookie load with rc=1 and explicit diagnostics, reached the completion marker, and exited 0. The earlier run `34035539216` remains HARNESS INVALID and contributes no semantic evidence.

Current source-grounded conclusions at `8bf4605...` remain: generic HostMot2 and low-level drivers are separate layers; `hm2_lowlevel_io_t` is their register-I/O/capability boundary; `hm2_eth` fills that interface before calling `hm2_register()`; generic registration validates cookie/IDROM/descriptors and builds module/TRAM/HAL state; unknown GTAGs are warned/ignored rather than automatically fatal; significant post-initialization failures require `hm2_cleanup()`; and unregister watchdog activity is not itself a safety-rated conclusion.

A passing 009 promotes only fake-LLIO registration validation/rejection behavior for the pinned userspace build. Successful physical-board registration, Ethernet timing, realtime deadlines, TRAM ordering, watchdog effectiveness and functional safety remain outside HM01.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and unusual cross-process mappings: **2000 / MEDIUM**.
- Recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions: **2000 / HIGH**.
- Stable/development ready/unready and object-lifetime comparison: **2000 / MEDIUM**.
- H04 live `addf`/`delf` mutation semantics while realtime dispatch is active: **2000 / HIGH**.
- H04 cross-thread signal visibility/cross-CPU ordering: **2000 / HIGH**.
- Development-only one-shot `initf` versus stable: **2000 / MEDIUM**.
- M03 Task-side command-mutex hold duration and command-to-echo latency distribution: **2000 / HIGH** unless needed earlier.
- M03 full planner/kinematics branch trace: **M08/M01/M02 then 2000 / HIGH**.
- M03 cross-thread/base-thread exchange timing: **2000 / HIGH** unless required earlier.
- HM01 exact IDROM/module descriptor semantics: **HM02 then 2000 / HIGH**.
- HM01 TRAM/register-cycle ordering: **HM03/HM09 / HIGH**.
- HM01 successful fake-board registration fixture extension: **HM02 or 2000 / MEDIUM**.
- HM01 hotplug/re-registration/partial-failure lifetime edges: **2000 / MEDIUM-HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL**, representative hardware/human involvement required.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC behavior is not safety certification.

## Current checkpoint / exact resume point

Begin **E01 — hm2_eth architecture and board discovery/registration ownership**. Start at the pinned `hm2_eth` LLIO boundary already established by HM01, then source-trace board discovery/selection, socket/interface setup, concrete `read`/`write` transaction paths, queued/split-I/O handling, timeout/error/reset behavior and how low-level failures propagate through `hm2_lowlevel_io_t` to generic HostMot2. Use official documentation and community configurations to identify field assumptions, but keep transport timing, physical watchdog and safety claims unpromoted until separately tested.