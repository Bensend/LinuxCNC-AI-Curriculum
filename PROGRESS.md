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
| IO01 Encoder path | GRADUATED | `guides/IO01-graduation-handoff.md`; `call-flows/IO01-encoder-register-to-hal.md` | stock `hm2_test` structurally unable to produce changing encoder samples; mutable fixture promoted | passed | host register-to-HAL path SOURCE-CONFIRMED; physical/FPGA behavior not test-confirmed |
| IO04 PWM/PDM path | GRADUATED | `guides/IO04-graduation-handoff.md`; `call-flows/IO04-pwm-command-to-register.md` | write-capturing valid-PWM fake board promoted to 2000 | passed | cyclic TRAM value path and slow mode/enable/rate path SOURCE-CONFIRMED; physical analog output outside evidence |
| IO05 Analog-servo interface patterns | GRADUATED | `guides/IO05-graduation-handoff.md`; `guides/IO05-smart-serial-analog-source-guide.md`; call flow | mutable fake Smart Serial remote promoted to 2000/HIGH | passed | 7I77-style descriptor-driven scale/limit/pack path SOURCE-CONFIRMED; physical +/-10 V and safety outside cloud evidence |
| IO06 GPIO input/output path | GRADUATED | `guides/IO06-graduation-handoff.md`; `guides/IO06-gpio-source-guide.md`; `call-flows/IO06-gpio-hal-register-path.md` | mutable IOPort fake + write capture promoted to 2000/HIGH | passed | host TRAM/config/ownership path SOURCE-CONFIRMED; electrical/safety behavior outside cloud evidence |
| IO07 Hardware enable and fault patterns | GRADUATED | `guides/IO07-graduation-handoff.md`; `guides/IO07-enable-fault-source-guide.md`; `call-flows/IO07-amp-fault-to-disable.md`; accepted result | corrected run `34076164338` passed lab assertions | passed | software/HAL amp-fault-to-disable TEST-CONFIRMED; drive/STO/torque/safety not inferred |
| S01 Machine control versus functional safety | SOURCE | `guides/S01-machine-control-vs-functional-safety-research.md`; `guides/S01-estop-machine-enable-source-guide.md`; `call-flows/S01-estop-machine-enable-boundary.md`; claims matrix | bounded software E-stop experiment planned | — | iocontrol/Task/motion state boundary SOURCE-CONFIRMED; physical risk reduction and PL/SIL/category explicitly outside software evidence |

## Version baseline

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`. Stable reference: `86cdca76fa2a36274c432caa21952b23c267989a` where applicable.

## Current critical-path result

IO07 remains **GRADUATED** at the intended 1000-level scope. The corrected bounded simulation at workflow run `34076164338` returned lab exit code 0 and TEST-CONFIRMED the LinuxCNC software/HAL amplifier-fault disable transition for the pinned simulation; it did not establish HostMot2 command delivery, drive response, STO, torque-removal time, or functional-safety performance.

S01 is now **SOURCE**. At pinned revision `8bf4605ae81042248add031e94c77300406e0413`, the software E-stop/machine-enable boundary has been traced through `iocontrol`, Task state handling, the Task→motion enable/disable command boundary, realtime motion state, and `motion.motion-enabled`. `iocontrol.0.emc-enable-in` is an active-low external-interface status input; `Task::run()` maps it into `io.aux.estop`. `emcTaskSetState()` implements ESTOP/RESET/ON/OFF software actions, `emcAuxEstopOn/Off()` drives `user-enable-out` and the reset-request pulse, and realtime motion publishes its enable flag to `motion.motion-enabled`.

The source pass found and recorded a legacy-comment polarity trap in `taskclass.hh`: executable source and current official iocontrol documentation agree that external E-stop is represented by `emc-enable-in=FALSE`, so the contradictory shorthand comments are not used as behavioral authority. The adversarial claims matrix now explicitly rejects conversions from controller states (`ESTOP`, `user-enable-out=0`, `motion.motion-enabled=0`, watchdog bites, software limits) into claims of zero torque, STO, stopping time, or PL/SIL/category.

A bounded S01 simulation is predeclared in `experiments/S01-software-estop-boundary-plan.md`. It will verify only the production software state transition from a verified enabled baseline through an external-style `emc-enable-in` assertion to controller ESTOP/motion disabled. Passing that lab is still required before S01 graduation; physical emergency-stop effectiveness remains outside the experiment by construction.

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
- HM08 physical watchdog reaction time, actual board pin electrical state, and output-module behavior after bite: **advanced hardware/commissioning / CRITICAL**.
- HM08 transport-specific path that clears/re-establishes communication after `io_error`: **E03/E06/E07 or 2000 / HIGH**.
- IO01 exact `hal_extend_counter()` ambiguity bound for large inter-sample count jumps: **IO03/2000 / HIGH**.
- IO01 mutable fake-LLIO production encoder experiment: **IO03/2000 / HIGH**.
- IO01 FPGA quadrature/filter/timestamp capture implementation and physical maximum reliable edge rate: **HM05/IO03/2000 / HIGH**.
- IO01 quadrature-error causality under injected illegal A/B sequences: **IO03/2000 / HIGH**.
- IO01 precise index-arm/event/read cycle latency: **IO02/2000 / MEDIUM**.
- IO04 valid fake-PWM descriptor + production LLIO/TRAM write capture experiment: **2000 / HIGH**.
- IO04 scale=0 / NaN / Inf behavior: **2000 / HIGH**.
- IO04 exact FPGA PWMGen mode/value/sign/dither interpretation and waveform timing: **HM06/2000 / HIGH**.
- IO04/IO05 physical PWM-to-analog transfer, polarity and limits: **commissioning / CRITICAL**.
- IO05 mutable production-path fake Smart Serial remote with descriptor discovery and write capture: **2000 / HIGH**.
- IO05 exact 7I77 descriptor field ordering/bit widths across firmware versions: **2000 / MEDIUM**.
- IO05 zero/NaN/Inf Smart Serial `scalemax` behavior: **2000 / HIGH**; normal guidance requires finite nonzero scale.
- IO05 Smart Serial remote watchdog interaction with HostMot2/machine fault handling: **S02/S03/2000 / HIGH**.
- IO05 physical analog disabled state, transfer tolerance, polarity and drive-enable/STO safety: **commissioning/safety / CRITICAL**.
- IO06 mutable valid IOPort fake-LLIO with mutable read state and write capture: **2000 / HIGH**.
- IO06 exact FPGA IOPort/readback semantics and same-cycle Data/direction transition behavior: **HM04/2000 / HIGH**.
- IO06 board-specific pull-ups, voltage, drive current, output transients and fail-state behavior: **commissioning/safety / CRITICAL**.
- IO07 exact command-to-physical-torque disable reaction time across HAL/HostMot2/network/drive: **2000 + commissioning / CRITICAL**.
- IO07 combined injected amp fault + HostMot2 `io_error`/watchdog/stale-feedback behavior: **S03/S06/2000 / HIGH**.
- IO07 drive-specific fault reset, STO semantics and certified external safety architecture: **safety/commissioning / CRITICAL**.
- S01 exact applicability of machine-safety laws/standards and required PL/SIL/category: **machine-specific safety engineering / CRITICAL**; do not generalize from community posts.
- S01 Task-cycle-to-motion-disable latency distribution: **2000 / HIGH**; useful controller-performance evidence but cannot establish physical stop time.
- S01 physical E-stop/STO/brake/contactor reaction and stopping time: **commissioning/safety / CRITICAL**.
- EVL/current-master versus pinned hm2_eth behavior: **2000 / HIGH**.
- Physical-machine latency/jitter qualification: **advanced commissioning / CRITICAL**.
- Functional-safety architecture/hazard analysis: **advanced safety / CRITICAL**.

## Current checkpoint / exact resume point

Continue **S01 — LinuxCNC machine control versus functional safety** at pinned revision `8bf4605ae81042248add031e94c77300406e0413`. Implement the predeclared `experiments/S01-software-estop-boundary-plan.md` using the existing hardened headless lab pattern. Before launching, inspect the current workflow selector and latest numbered runner so the new experiment cannot upload stale artifacts or accidentally reuse the IO07 fault source. Require a verified enabled baseline, a single controlled writer feeding `iocontrol.0.emc-enable-in`, observation of the TRUE→FALSE injection, Task/controller E-stop response, and `motion.motion-enabled=FALSE`. Preserve raw evidence and exact SHA. A pass confirms only LinuxCNC software state transitions. Then run the S01 adversarial exam and fresh-AI novel-scenario handoff; do not graduate if the experiment or handoff blurs controller state into physical functional-safety evidence.
