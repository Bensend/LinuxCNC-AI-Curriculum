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
| H01 HAL architecture | GRADUATED | H01 lifecycle/call-flow/community/handoff guides | corrected `006` run `34018699909` | passed | object/connectivity semantics TEST-CONFIRMED for pinned host |
| H04 HAL execution ordering | GRADUATED | H04 guide/call-flow/community/handoff + accepted result | `007` run `34024102367` | passed | within-thread order/dataflow TEST-CONFIRMED; cross-thread/live mutation not promoted |
| M03 One servo-period trace | GRADUATED | M03 source/call-flow/accepted-result/handoff guides | `008` run `34029848545` | passed | canonical loopback phase relationship TEST-CONFIRMED; not universal latency |
| HM01 HostMot2 architecture | GRADUATED | `guides/HM01-graduation-handoff.md`; call flow + accepted result | corrected `009` run `34038328272` | passed | fake-LLIO malformed-registration rejection TEST-CONFIRMED; no physical transport/safety claim |
| E01 hm2_eth architecture | GRADUATED | `guides/E01-graduation-handoff.md`; `call-flows/E01-hm2-eth-transport.md` | production-path no-hardware transport experiment promoted | passed | architecture/discovery/LLIO ownership SOURCE-CONFIRMED; no physical network claim |
| HM08 HostMot2 watchdog | RESEARCH | `guides/HM08-watchdog-initial.md` | — | — | active critical path |
| IO01 Encoder path | PLANNED | — | — | — | critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Version baseline

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`. Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

## Current critical-path result

E01 is **GRADUATED** at its 1000-level architecture/discovery scope. Pinned source establishes that hm2_eth owns Ethernet LLIO transport mechanics, constructs `hm2_lowlevel_io_t`, and hands a probed/configured board to generic HostMot2 through `hm2_register()`. Direct initialization reads and cyclic queued I/O are distinct paths. Deeper packet-loss/recovery/timing mechanics remain assigned to E03-E07.

No suitable upstream no-hardware fixture was found that executes the production static hm2_eth receive state machine. Copying those functions into a model would not justify TEST-CONFIRMED production behavior; physical discovery also requires hardware. This experiment is therefore promoted rather than faked, and E01 graduates on documentation/community/source/call-flow/adversarial/fresh-AI evidence appropriate to its architecture objective.

HM08 is now active. Initial pinned source establishes HAL `watchdog.has_bit`, RW `watchdog.timeout_ns` (5 ms default), TRAM status/reset regions, first-write enable behavior, timeout conversion, recovery gating on `io_error`/`has_bit`, and `needs_reset` propagation after observed watchdog status. These are mechanism claims only, not safety qualification.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and unusual cross-process mappings: **2000 / MEDIUM**.
- Recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions: **2000 / HIGH**.
- Stable/development ready/unready and object-lifetime comparison: **2000 / MEDIUM**.
- H04 live `addf`/`delf` mutation semantics while realtime dispatch is active: **2000 / HIGH**.
- H04 cross-thread signal visibility/cross-CPU ordering: **2000 / HIGH**.
- Development-only one-shot `initf` versus stable: **2000 / MEDIUM**.
- M03 Task-side command-mutex hold duration and command-to-echo latency distribution: **2000 / HIGH**.
- M03 full planner/kinematics branch trace: **M08/M01/M02 then 2000 / HIGH**.
- HM01 exact IDROM/module descriptor semantics: **HM02 then 2000 / HIGH**.
- HM01 TRAM/register-cycle ordering: **HM03/HM09 / HIGH**.
- HM01 successful fake-board registration fixture extension: **HM02 or 2000 / MEDIUM**.
- E01 production-path stale/duplicate/wrong-size/lost-packet fault injection: **E03/E06 or 2000 / HIGH**.
- E01 exact socket/interface/routing/firewall setup: **E02 / MEDIUM**.
- E01 servo-period Ethernet timing and recovery: **E05/E07 / HIGH**.
- EVL/current-master versus pinned hm2_eth behavior: **2000 / HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL**, representative hardware/human involvement required.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC behavior is not safety certification.

## Current checkpoint / exact resume point

Continue **HM08 — HostMot2 watchdog**. Trace callers/order of `hm2_watchdog_prepare_tram_write()`, `hm2_watchdog_process_tram_read()`, `hm2_watchdog_write()`, and `hm2_watchdog_force_write()` through generic HostMot2 read/write cycles at pinned `8bf4605...`. Reconcile `needs_reset`, `needs_soft_reset`, LLIO `io_error`, `hm2_force_write()`, HAL `has_bit`, timeout updates and pet/reset writes. Then add official documentation/community findings and inspect fake-LLIO/upstream tests for a production-function no-hardware experiment. Preserve the safety boundary: register/watchdog mechanism is not proof of a safe physical state.