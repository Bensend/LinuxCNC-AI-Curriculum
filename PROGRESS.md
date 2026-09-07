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
| IO01 Encoder path | GRADUATED | `guides/IO01-graduation-handoff.md`; `call-flows/IO01-encoder-register-to-hal.md` | mutable encoder fixture promoted | passed | host register-to-HAL path SOURCE-CONFIRMED; physical/FPGA behavior not test-confirmed |
| IO04 PWM/PDM path | GRADUATED | `guides/IO04-graduation-handoff.md`; `call-flows/IO04-pwm-command-to-register.md` | write-capturing fake board promoted | passed | cyclic/slow-path source behavior confirmed; physical analog outside evidence |
| IO05 Analog-servo interface patterns | GRADUATED | IO05 source/handoff/call-flow guides | mutable fake Smart Serial remote promoted | passed | descriptor-driven command path SOURCE-CONFIRMED; physical +/-10 V and safety outside evidence |
| IO06 GPIO input/output path | GRADUATED | IO06 source/handoff/call-flow guides | mutable IOPort fake promoted | passed | host TRAM/config/ownership path SOURCE-CONFIRMED; electrical/safety outside evidence |
| IO07 Hardware enable and fault patterns | GRADUATED | IO07 source/handoff/call-flow + accepted result | corrected run `34076164338` | passed | software/HAL amp-fault disable TEST-CONFIRMED; drive/STO/torque/safety not inferred |
| S01 Machine control versus functional safety | GRADUATED | S01 source/call-flow/claims matrix/handoff | run `34079407413` passed | passed | external E-stop software boundary TEST-CONFIRMED; no physical functional-safety inference |
| S02 Watchdog design patterns | GRADUATED | `guides/S02-watchdog-source-and-design-guide.md`; `guides/S02-graduation-handoff.md`; accepted result | run `34091326973` passed after three HARNESS INVALID attempts | passed | generic HAL heartbeat bite/re-arm TEST-CONFIRMED; testing-only FORCE_REALTIME; no latency/physical-safety claim |
| S03 Communication-loss behavior | SOURCE | `guides/S03-communication-loss-initial-research.md`; `call-flows/S03-hm2-eth-loss-to-host-stale-state.md`; `experiments/S03-013-mutable-llio-feasibility-and-design.md` | stock `hm2_test` rejected as invalid oracle; mutable valid IOPort LLIO derivative specified | — | central stale-publication/write-suppression prediction still requires independent production-path verification |

## Version baseline

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`. Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

## Current critical-path result

S01 and S02 are **GRADUATED** at the intended 1000-level scope.

S03 remains **SOURCE**. The hm2_eth transport escalation and generic HostMot2 early-return call flow is source-confirmed. This session audited pinned `hm2_test.c` and rejected the stock fixture as an independent stale-state/write-suppression oracle: its reads come from an unchanging compiled-in register image and its write callback discards address/data/payload while returning success. An unchanged HAL value from that stock fixture would therefore be circular evidence, and the fixture has no observable write-delivery state.

The durable S03-013 design now requires a smallest-valid mutable IOPort LLIO derivative that leaves `hostmot2.c` unchanged, provides runtime-mutable backing register state, test-only `llio.io_error` control, and LLIO write capture. Baseline registration/fresh read/write is a mandatory harness-validity gate before injecting `io_error`. The existing predeclared prediction remains unchanged and graduation-blocking until independently checked.

## Promotion / uncertainty queue

- HAL allocator fragmentation/reuse and unusual cross-process mappings: **2000 / MEDIUM**.
- Recovery after process/thread death with inconsistent HAL recursive-mutex accounting: **2000 / HIGH**.
- Shared pin/signal atomicity and memory-ordering assumptions: **2000 / HIGH**.
- H04 live `addf`/`delf` mutation semantics while realtime dispatch is active: **2000 / HIGH**.
- H04 cross-thread signal visibility/cross-CPU ordering: **2000 / HIGH**.
- M03 Task-side command-mutex hold duration and command-to-echo latency distribution: **2000 / HIGH**.
- M03 full planner/kinematics branch trace: **M08/M01/M02 then 2000 / HIGH**.
- HM01 exact IDROM/module descriptor semantics: **HM02 then 2000 / HIGH**.
- HM01 TRAM/register-cycle ordering: **HM03/HM09 / HIGH**.
- E01 production-path stale/duplicate/wrong-size/lost-packet fault injection: **E03/E06 or 2000 / HIGH**.
- E01 exact socket/interface/routing/firewall setup: **E02 / MEDIUM**.
- E01 servo-period Ethernet timing and recovery: **E05/E07 / HIGH**.
- HM08 mutable fake-LLIO production host-state watchdog experiment: **2000 / MEDIUM**.
- HM08 physical watchdog reaction time, actual board pin electrical state, and output-module behavior after bite: **advanced hardware/commissioning / CRITICAL**.
- IO01 exact `hal_extend_counter()` ambiguity bound and mutable encoder fixture: **IO03/2000 / HIGH**.
- IO01 FPGA quadrature/filter/timestamp capture and physical maximum edge rate: **HM05/IO03/2000 / HIGH**.
- IO04 valid fake-PWM descriptor + production LLIO/TRAM write capture: **2000 / HIGH**.
- IO04 exact FPGA waveform/mode timing: **HM06/2000 / HIGH**.
- IO04/IO05 physical PWM/analog transfer, polarity and limits: **commissioning / CRITICAL**.
- IO05 mutable production-path fake Smart Serial remote: **2000 / HIGH**.
- IO05 Smart Serial remote watchdog interaction with HostMot2/machine fault handling: **S03/S06/2000 / HIGH**.
- IO05 physical analog disabled state and drive-enable/STO safety: **commissioning/safety / CRITICAL**.
- IO06 mutable valid IOPort fake-LLIO: **2000 / HIGH**.
- IO06 exact FPGA IOPort/readback and same-cycle Data/direction behavior: **HM04/2000 / HIGH**.
- IO06 board-specific electrical fail-state behavior: **commissioning/safety / CRITICAL**.
- IO07 exact command-to-physical-torque disable reaction time: **2000 + commissioning / CRITICAL**.
- IO07 combined amp fault + HostMot2 `io_error`/watchdog/stale-feedback behavior: **S03/S06/2000 / HIGH**.
- IO07 drive-specific fault reset/STO/certified external safety architecture: **safety/commissioning / CRITICAL**.
- S01 physical E-stop/STO/brake/contactor reaction and stopping time: **commissioning/safety / CRITICAL**.
- S02 exact worst-case watchdog detection latency under scheduler jitter/overrun: **2000 / HIGH**.
- S02 common-cause quantitative diagnostic coverage: **2000/safety engineering / HIGH**.
- S02 external charge-pump/STO/relay fail-state and PL/SIL/category: **commissioning/safety / CRITICAL**.
- S03 production-path transport-loss fault injection and stale-feedback verification: **current / HIGH**.
- S03 combined Smart Serial remote watchdog + HostMot2 watchdog + `io_error` recovery ordering: **S03/S06/2000 / HIGH**.
- EVL/current-master versus pinned hm2_eth behavior: **2000 / HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL**.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**.

## Current checkpoint / exact resume point

Continue **S03 — communication-loss behavior** at pinned revision `8bf4605ae81042248add031e94c77300406e0413`. Use `experiments/S03-013-mutable-llio-feasibility-and-design.md` as the experiment contract. Inspect the final pinned `hm2_test.c` IDROM patterns and the IOPort module-descriptor/register format in `hostmot2.h` and `ioport.c`; construct the smallest valid fake board with one IOPort instance. Add only LLIO-level test hooks: mutable register backing, an `io_error` control, and write capture. Do not modify HostMot2 read/write behavior to manufacture the result. Implement `lab-jobs/013-s03-hostmot2-stale-state.sh` and require a successful registration plus fresh baseline read/write before fault injection; any registration/baseline failure is HARNESS INVALID, not evidence against S03. Then test the predeclared stale-publication/write-suppression/recovery prediction. Do not claim UDP hardware behavior, FPGA watchdog timing, drive response, resynchronization safety, or physical functional safety from the fixture.