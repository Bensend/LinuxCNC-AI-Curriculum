# 4400-HAL-MUTATION-01 — When a sensor is unplugged in software, does permission disappear?

**Status:** practical 4000 safety design module; **PAPER ONLY / NON-GRADUATED**. Prerequisites: 2520 hazard-to-function allocation, 2530 E-stop, 2540 final elements, 2580 hydraulic/gravity energy, LinuxCNC HAL source literacy. Source: [pinned stable/development HAL audit](../research/4400_LINUXCNC_HAL_UNLINK_STALE_TRUE_AND_SETS_WRITER_BOUNDARY_SOURCE_TRACE_2026-10-26.md).

## Objective
A fresh AI/technician can trace a LinuxCNC HAL pin disconnection through actual source, predict why the pin may remain TRUE, distinguish a writerless manually set signal from a physical sensor, identify what `setp` cannot change, and design a practical independent machine-safety boundary without claiming HAL is safety-rated.

## Four distinct layers
| Layer | Appropriate job | What it cannot prove |
|---|---|---|
| Normal LinuxCNC/HAL + optional FPGA | Request motion, implement process permissives, sequence, display state | Personnel protection or safe physical stop/hold |
| Diagnostics/configuration management | Detect missing writer, stale data, wrong nets, change drift; block normal start | Independent protective final-element operation |
| Independent safety-related control | Validated guard/E-stop input logic, reset interlock, qualified final-element control | Gravity load held solely from status bits |
| Physical energy removal/restraint | Rated final elements, lockable isolation, load support, pressure-zone verification | Cannot be inferred from a green HMI |

## Mechanism walkthrough
- A scalar HAL input linked to a TRUE signal may be **unlinked**; pinned source copies that TRUE into the pin's private dummy. The disconnected component may continue to see TRUE until its own code changes it. **SOURCE-CONFIRMED** HAL behavior; machine consequence conditional.
- A connected pin is rejected by `setp`; a writerless signal can be changed by `sets`. A visible `TRUE` is therefore **not** proof of a live, validated physical sensor. **SOURCE-CONFIRMED / DOC-CONFIRMED**.
- HAL configuration locking rejects certain topology changes, but is not a safety-rated protective circuit or substitute for locking out electrical/hydraulic energy. **SOURCE-CONFIRMED lock check; INFERENCE safety allocation**.
- On a reconnect, recheck source/writer identity and the actual sensor-to-actuator path. A UI status alone cannot witness a press-brake ram, motor torque, hydraulic pressure or gravity load.

## Low-friction builder pattern
Keep the independent safety loop short and inspectable: suitable protective devices -> qualified safety logic -> monitored, suitable final elements -> actual safe physical state. Keep LinuxCNC's enable/request state behind that boundary. Put diagnostic detail on the HMI: `writer missing`, `pin unlinked`, `signal stale`, `guard open`, `reset needed`, `start needed`, and avoid one ambiguous green READY light. Make service guards captive, isolation points labeled, and recovery possible without bridging inputs. Reset may rearm safety after verification but **must not by itself issue a fresh hazardous-motion command**.

## Worked counterexample
A CNC process interlock shows TRUE. During troubleshooting, a technician disconnects its HAL input; the sensor subsequently reports FALSE. **Wrong conclusion:** the input must fall FALSE because the sensor fell. **Source-grounded conclusion:** the HAL input may initially retain TRUE in dummy storage. **Engineering response:** treat topology drift as a normal-control fault and preserve an independent personnel-safety path. Do not infer the physical actuator is safe or unsafe solely from this trace.

## Cross-machine transfer
For **press brakes**, track both Y1 and Y2 stopping, load holding and pressure zones; an input pin does not certify any of them. For **lathes/mills**, distinguish spindle/axis coasting and door access. For **plasma**, distinguish normal torch-enable from physical high-voltage/arc isolation. For **automated cells**, distinguish reset/occupancy from commanded cycle start. Each machine requires its own hazard analysis and validated safe-state evidence.

## Verification and advancement
Read the [12 unscored paper cases](4400_HAL_MUTATION_01_TWELVE_CONFIG_DRIFT_PAPER_CASES_2026-10-26.md), then the [12-gate unexecuted no-energy desk review](4400_HAL_MUTATION_01_TWELVE_GATE_NO_ENERGY_CONFIG_REVIEW_2026-10-26.md). The [fresh evaluator handoff](../evaluation/4400_HAL_MUTATION_01_INDEPENDENT_UNSEEN_TOPOLOGY_TRANSFER_HANDOFF_2026-10-26.md) requires information separation and remains **NOT RUN**. Source-only understanding is not physical commissioning evidence. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**.

## Promotion / uncertainty
| Open item | Label | Priority | Why not invented |
|---|---|---|---|
| Actual selected-machine HAL topology and whether normal controls detect missing writer | UNKNOWN | HIGH | Requires private as-built config and controlled read-only review |
| Selected physical Y1/Y2, pressure, guards, independent stop/hold and reset | UNKNOWN | CRITICAL | Qualified hardware design and validation; blocks machine release |
| Optional `halrmt` service exposure and security configuration | UNKNOWN | MEDIUM | Source shows handlers, not enabled service |
| Exact dynamic component behavior after pin unlink | UNKNOWN | MEDIUM | Source proves HAL dummy handoff, not every component's internal state |
No graduation claim. If all unknowns resolve differently, the core source finding still stands, but selected-machine release remains blocked.
