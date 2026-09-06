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
| IO01 Encoder path | GRADUATED | `guides/IO01-graduation-handoff.md`; `call-flows/IO01-encoder-register-to-hal.md` | stock `hm2_test` judged structurally unable to produce changing encoder samples; mutable fixture promoted | passed | host register-to-HAL path SOURCE-CONFIRMED; physical/FPGA behavior not test-confirmed |
| IO04 PWM/PDM path | GRADUATED | `guides/IO04-graduation-handoff.md`; `call-flows/IO04-pwm-command-to-register.md` | write-capturing valid-PWM fake board promoted to 2000 | passed | cyclic TRAM value path and slow mode/enable/rate path SOURCE-CONFIRMED; physical analog output explicitly outside evidence |
| IO05 Analog-servo interface patterns | RESEARCH | initial docs/community pass | pending | — | highest-priority unblocked follow-on after PWM command path |

## Version baseline

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`. Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

## Current critical-path result

IO04 is **GRADUATED** at 1000 level. Generic `hm2_write()` prepares PWMGen cyclic command values with `hm2_pwmgen_prepare_tram_write()` before the combined `hm2_tram_write()`. It then runs `hm2_pwmgen_write()`, which only emits mode/enable/PWM-rate/PDM-rate LLIO writes when cached configuration changed. This prevents the command value and configuration/enable path from being falsely modeled as a single atomic register operation.

Pinned source confirms finite `value/scale` clipping, normal/PDM/offset encoding, board-clock-dependent PWM resolution, change-detected configuration writes and explicit invalid-mode repair. A key debugging/safety correction is now durable: `enable=false`, zero command, zero PWM duty and zero physical analog voltage are not synonymous. In offset mode, disabled host command zero maps to 50% centered duty; physical behavior depends on the specific interface hardware.

The stock upstream `hm2_test` write callback discards address/data and its stock patterns do not provide a useful PWM command oracle. A valid fake PWM descriptor plus write capture is therefore promoted to 2000/HIGH as synthetic host-path verification, not hardware evidence.

IO05 — analog-servo interface patterns — is now the highest-priority unblocked follow-on. Initial documentation/community research already establishes that HostMot2 PWM semantics alone do not define physical analog voltage; some Mesa interfaces use centered PWM conversion while 7I77 smart-serial analog outputs expose board-specific limits/scaling.

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
- IO01 mutable fake-LLIO production encoder experiment: **IO03/2000 / HIGH**; synthetic register producer only, never FPGA/electrical evidence.
- IO01 FPGA quadrature/filter/timestamp capture implementation and physical maximum reliable edge rate: **HM05/IO03/2000 / HIGH**.
- IO01 quadrature-error causality under injected illegal A/B sequences: **IO03/2000 / HIGH**.
- IO01 precise index-arm/event/read cycle latency: **IO02/2000 / MEDIUM**.
- IO04 valid fake-PWM descriptor + production LLIO/TRAM write capture experiment: **2000 / HIGH**; synthetic host register evidence only.
- IO04 scale=0 / NaN / Inf behavior: **2000 / HIGH**; no explicit pinned source guard, do not rely on pathological inputs.
- IO04 exact FPGA PWMGen mode/value/sign/dither interpretation and waveform timing: **HM06/2000 / HIGH**.
- IO04/IO05 physical PWM-to-analog transfer, polarity and limits: **IO05/commissioning / CRITICAL**; board-specific evidence required.
- EVL/current-master versus pinned hm2_eth behavior: **2000 / HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL**, representative hardware/human involvement required.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**; LinuxCNC behavior is not safety certification.

## Current checkpoint / exact resume point

Continue **IO05 — analog-servo interface patterns**. Establish a taxonomy of LinuxCNC/Mesa analog-command paths rather than assuming every ±10 V interface is generic PWMGen. Start with current HostMot2/sserial documentation and representative Mesa board manuals: distinguish direct HostMot2 PWM/PDM + external converter patterns from smart-serial analog outputs such as 7I77, and centered PWM analog interfaces such as 7I97/7I97T. Trace which HAL object owns scaling/limits/enable for each pattern, where the generic HostMot2 path ends, and where board-specific smart-serial/firmware/electronics behavior begins. Preserve physical enable/fault and functional-safety questions as separate commissioning/safety evidence. Then select one representative source-level path for a complete command-to-analog-interface call flow and decide what can be tested without hardware.