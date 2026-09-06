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
| HM08 HostMot2 watchdog | GRADUATED | `guides/HM08-graduation-handoff.md`; `call-flows/HM08-watchdog-cycle-and-recovery.md` | fake-LLIO mutable watchdog model promoted to 2000 | passed | host cycle/recovery SOURCE-CONFIRMED; physical bite/electrical behavior not test-confirmed |
| IO01 Encoder path | SOURCE | `guides/IO01-encoder-register-to-hal-source.md` | pending fixture feasibility | — | descriptor/TRAM ordering, 16→64-bit count extension, reset/index, scale and velocity state machine traced |
| IO04 PWM/PDM path | PLANNED | — | — | — | critical path |

## Version baseline

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`. Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

## Current critical-path result

HM08 is **GRADUATED** at 1000 level. IO01 is now the highest-priority unblocked critical-path module and has advanced to **SOURCE**.

Pinned `encoder.c` establishes the normal host reconstruction path: encoder timestamp-count TRAM is registered before counter/latch TRAM; the 16-bit FPGA counter is extended into an internal 64-bit raw-count accumulator; reset and index act by changing host zero/latch state rather than resetting the raw FPGA counter; scaled position uses the internal 64-bit logical count; and velocity uses a STOPPED/MOVING timestamp state machine whose no-new-edge path decays the velocity bound until `vel-timeout` rather than immediately publishing zero.

Current documentation independently supports the public rawcounts/count/position/velocity/reset/index/scale/vel-timeout model. Physical quadrature capture, electrical integrity, exact count-extension ambiguity bounds, and safety/redundancy remain separate evidence questions.

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
- HM08 mutable fake-LLIO production host-state watchdog experiment: **2000 / MEDIUM**; synthetic status/write capture only, never physical evidence.
- HM08 physical watchdog reaction time, actual board pin electrical state, and output-module behavior after bite: **advanced hardware/commissioning / CRITICAL**; requires representative hardware/firmware and safety analysis.
- HM08 transport-specific path that clears/re-establishes communication after `io_error`: **E03/E06/E07 or 2000 / HIGH**.
- IO01 exact `hal_extend_counter()` ambiguity bound for large inter-sample count jumps: **IO03/2000 / HIGH**.
- IO01 FPGA quadrature/filter/timestamp capture implementation and physical maximum reliable edge rate: **HM05/IO03/2000 / HIGH**.
- IO01 quadrature-error causality under injected illegal A/B sequences: **IO03/2000 / HIGH**.
- IO01 precise index-arm/event/read cycle latency: **IO02/2000 / MEDIUM**.
- EVL/current-master versus pinned hm2_eth behavior: **2000 / HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL**, representative hardware/human involvement required.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC behavior is not safety certification.

## Current checkpoint / exact resume point

Continue **IO01 — Encoder path** from `guides/IO01-encoder-register-to-hal-source.md`. First write `call-flows/IO01-encoder-register-to-hal.md` around the generic `hm2_read()` → successful TRAM completion → `hm2_encoder_process_tram_read()`/control-register publication boundary. Then inspect upstream fake-LLIO fixtures to determine whether production encoder processing can be exercised by mutating only the TRAM image. A valid no-hardware experiment should discriminate 16-bit wrap extension, reset-as-zero-offset, scale publication, and the low-speed `vel-timeout` transition while explicitly not claiming FPGA electrical/quadrature capture. If fixture extension would require inventing substantial FPGA behavior, promote that part and test only host reconstruction semantics.