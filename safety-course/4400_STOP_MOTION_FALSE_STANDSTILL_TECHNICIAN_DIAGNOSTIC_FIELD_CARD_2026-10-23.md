# 4400 technician field card — False standstill, sensor fault, and guard key release

**2026-10-23 | Open-book training exercise; not a blind competency challenge, not an executable wiring diagram, and not a machine acceptance test.** Read [the Rockwell/Pilz/Schmersal source audit](../research/4400_STOP_MOTION_SENSOR_COVERAGE_FAULT_AND_COUPLING_SOURCE_AUDIT_2026-10-23.md) first.

## Task boundary

A generic machine has a guarded rotating drive and a separate gravity-loaded actuator. The production controller is LinuxCNC with an ordinary FPGA I/O board. A technician sees “spindle stopped” on the HMI and “key free” on the trapped-key panel. No as-built drawings, safety device order numbers, coupling diagram or physical stopping records are available.

**Initial disposition:** neither HMI text nor key-release indication is sufficient to authorize personnel access or machine operation with people exposed. Do not physically insert faults into an energized hazardous machine as part of this paper exercise.

## Five adversarial work orders

**A — The disconnected sensor supply.** Two proximity sensors lose their common 24 V feed. Both pulse trains stop. The maintenance note says, “CU2 is cross-monitored, so both missing pulses must be safe.” Identify the exact manufacturer's statement that exists, the **missing** fault truth table, the independent power/dependency evidence needed and the correct access disposition.

**B — The sheared coupling.** Both sensors monitor the motor shaft; the drive stops but a mechanically disconnected downstream spindle coasts. A second person argues, “Two sensors means redundancy.” Draw the motor–coupling–hazard chain and explain why electrical redundancy does not necessarily cover this failure.

**C — The creeping ram.** The monitored shaft is stopped, but the elevated hydraulic ram moves due to leakage or gravity. Name which physical propositions the monitor cannot prove. Specify what an actual machine-specific stopping/holding and stored-energy witness would have to cover without inventing a pressure, stop time or performance level.

**D — The low-speed region.** A PNOZ s30 configuration is proposed to replace a CU2. The commissioning worksheet copies a default standstill frequency from an online example and assumes dual-sensor plausibility checking is active at all frequencies. Use the Pilz manual to find the **validation cut-off** behavior and the sensor-to-load slippage/shear-pin warning. State what configuration, target and independent validation evidence is missing. Explain why a product-level PL or SIL does not close the machine-level proof.

**E — The shortcut that creates defeat pressure.** A machine frequently requires operators to wait for a trapped-key release. The key-release solenoid also becomes inconvenient after power interruptions. Someone proposes bypassing the monitor and relying on LinuxCNC's velocity reading plus a fixed 1-second timer. Describe a practical redesign process that reduces needless waiting **without** moving personnel-safety authority into ordinary software or silently reducing coverage. Include emergency inside escape, restart-after-power-loss and maintenance isolation as separate requirements.

## Expected engineering reasoning (learner-visible, not a sealed answer key)

- **A:** The historical CU2-IN001 sheet shows two sensors and says timer/output circuits are fail-safe and cross-monitored; it does **not** publish the claimed complete two-sensor supply-loss diagnostic table. Treat selected CU2 behavior as **UNKNOWN**, prohibit unqualified release, and seek exact wiring/manual/validated fault response.
- **B:** Both sensors share the same mechanical observation target. A sheared coupling is a **common-cause mechanical coverage gap**. Independent physical hazard observation or an adequately justified mechanical integrity measure is needed.
- **C:** Stopped rotation is not evidence of hydraulic load restraint, zero stored energy, a safe access route, or deliberate restart. Selected as-built hydraulic zones, mechanical support/holding and actual ram motion evidence are required.
- **D:** Pilz 1001715-EN-24 p. 74 says sensor plausibility checking ceases below the configured validation cut-off. The manual separately warns about broken shear pins/slippage. The selected encoder type, signal ratio, low-speed coverage, output allocation, start mode, load coupling and physical witness must be verified. A copied default is not a machine-specific threshold.
- **E:** Map legitimate workflow delays and power-loss recovery, then evaluate properly engineered monitored stopping, qualified release criteria, accessible reset and visible diagnostics, durable key handling and inside mechanical egress. Reduce friction by better installation and operator workflow rather than bypass. A normal controller may display diagnostics but cannot replace the safety-related release path. Maintenance LOTO remains separate.

## Field qualification worksheet — to complete only with selected-machine evidence

| Record | Required evidence | Present status |
|---|---|---|
| `BND/HAZ` | Exact machine, operating modes, exposed people and access routes | UNKNOWN |
| `SRS-RELEASE` | Intended release condition, selected monitor/manual, guard/key device, restart conditions | UNKNOWN |
| `DEP/CCF` | Each sensor target, mounting, supply, coupling, wiring, mechanical common cause | UNKNOWN |
| `AUTH` | Independent safety controller/monitor and physical final-element ownership | UNKNOWN |
| `PHY-STOP` | Independent actual hazard motion endpoint and selected acceptance criteria | NOT RUN |
| `PHY-HOLD` | Gravity/external-force restraint and credible degradation paths | NOT RUN |
| `PHY-ACCESS/ESCAPE` | Guard-lock polarity, power-loss egress and access coverage | NOT RUN |
| `PHY-ENERGY` | Lockable maintenance isolation, pressure/kinetic/gravity residual energy | NOT RUN |
| `PHY-RESTART` | No held-demand auto-restart; independent rearm then fresh production start | NOT RUN |
| `VAL/PT` | Fault-specific physical qualification with authorized remote/isolated setup | NOT RUN |

**Decision:** `G0/G1 HOLD`; `G2 NOT RUN`; `G3/G4 NOT AUTHORIZED`; `G5 HOLD`. If minimum protective stopping, holding, escape or energy control cannot be demonstrated, **do not operate with personnel exposed**. Any experimental motion must be isolated/remote with people outside the danger zone and residual risk expressly assessed.

## Instructor review criteria

The learner must distinguish **DOC-CONFIRMED** product statements from **UNKNOWN** selected-machine fault response; identify the mechanical common-cause path, the low-frequency plausibility gap and the separate physical-energy propositions; reject a software-only safety release; and propose an ergonomic improvement that preserves the safety boundary. No numerical PL/SIL, stop time, hydraulic threshold or diagnostic coverage is to be invented.
