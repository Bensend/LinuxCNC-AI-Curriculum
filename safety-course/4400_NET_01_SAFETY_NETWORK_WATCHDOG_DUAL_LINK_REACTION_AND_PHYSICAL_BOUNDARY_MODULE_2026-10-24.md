# 4400-NET-01 — Ordinary EtherCAT watchdogs, safety-network timeouts, and physical stop proof
**Status:** RESEARCH / NON-GRADUATED; 2026-10-24. **Prerequisites:** 2520 safety-function derivation, 2530 E-stop, 2570 validation, 2580 selected-machine evidence, 25E0 network reintegration, 4400-HYD-01 hydraulic load hold, 4400-RST-01 fresh start. **Cross-machine:** press brake, mill, robot/cell and distributed I/O. **No claim any studied network is installed on OpenPressBrake.**

## Learning objective
Explain why a fast LinuxCNC/EtherCAT cycle, an ordinary EtherCAT SM/PDI watchdog, a certified Safety-over-EtherCAT (FSoE) communication watchdog, a safety controller's state, and an actuator's **actual safe physical condition** are five distinct propositions. Trace worst-case **two-link communication loss**, restart/rearm, and a practical low-cost alternative that uses hardwired independent safety authority.

## Required source reading
- [Original Beckhoff TwinCAT Safety PLC v1.2.0 and 2024 InfoSys, plus PI source audit](../research/4400_BECKHOFF_FSOE_VS_ORDINARY_ETHERCAT_WATCHDOG_REACTION_TIME_SOURCE_AUDIT_2026-10-24.md). Evidence **DOC-CONFIRMED** within exact manufacturer/version scope.
- [Existing 25E0 safety-network reintegration module](25E0_SAFETY_NETWORK_REINTEGRATION_COMMON_CAUSE_AND_CELL_TRANSFER_2026-09-22.md). Avoid conflating connection restoration with machine restart.
- [4400-RST-01](4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md) and [4400-HYD-01](4400_HYD_01_FASTDOWN_DRIVE_LOSS_VALVE_FEEDBACK_AND_PHYSICAL_HOLD_MODULE_2026-10-24.md) for final-element and gravity-load boundaries.

## Boundary map
| Layer | May establish | Cannot establish |
|---|---|---|
| LinuxCNC/ordinary FPGA/normal EtherCAT | requested motion, diagnostics, ordinary I/O | personnel-safety integrity or independent energy isolation |
| EtherCAT SM/PDI watchdog | documented ordinary data freshness response | certified safety telegram validity or safe physical stop |
| FSoE or PROFIsafe certified safety transport | configured safety-channel validity, fault detection and safe representation **within certified product scope** | whole-machine PL/SIL or physical load holding |
| Qualified independent safety logic/output | configured safety reaction at specified terminal | that a downstream contactor, brake or valve actually worked |
| Physical final elements, load path and protective measures | actual safe state when validated | automatic permission to restart without a fresh human decision |

## Failure-path trace (source-grounded; no experiment)
**Fault A — ordinary EtherCAT master cable unplugged:** normal SM watchdog behavior is terminal/revision/configuration-specific; Beckhoff documents that SM=0 can disable it on applicable terminals. This does **not** describe the independent FSoE watchdog. Never use a green normal EtherCAT OP flag as safety evidence.

**Fault B — guard changes just as safe-input communication fails:** a valid safety telegram may not reach the logic until its communication watchdog expires. A second failure between logic and safe output may incur another watchdog. Beckhoff's worst-case method explicitly considers **two communication faults**. End-to-end reaction also includes sensor, input, logic, output and actuator delays. Do not replace this with 'one cycle + one timeout.'

**Fault C — communication returns and operator presses reset:** FSoE connection may progress through Reset/Session/Connection/Parameter/Data. The 2017 Beckhoff manual describes optional per-connection ComErrAck and group ErrAck. Even a recovered Data state is not proof the guard is closed correctly, a person is absent, hydraulic load is held or a new production cycle was requested. Hold retained commands inactive until a separate deliberate start.

**Fault D — safe output goes FALSE but the machine continues moving:** this is a final-element or physical-energy-path failure, not necessarily a safety-network communication failure. Independent contactor/valve feedback, mechanical load path, fault detection and qualified physical witness are needed. For a press brake, evaluate Y1 and Y2 separately and jointly, with gravity energy, accumulator and hose/valve fault paths.

## Bounded engineering exercise — no compute justified
Use [12 non-blind technician scenarios and witness contract](4400_SAFETY_NETWORK_TWO_WATCHDOG_TECHNICIAN_AND_SELECTED_WITNESS_2026-10-24.md). For each, mark **SOURCE-CONFIRMED / DOC-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN**, exact device/revision, and what falsifies the claim. Do not self-grade as an independent blind score.

## Practical safer-by-default pattern
For a compact single press brake, start with **fixed hardwired E-stop, accessible guards/interlocks, independent appropriately rated safety relay/PLC and proven physical final elements**. Keep the LinuxCNC screen as a *diagnostic observer*. For distributed robots/cells, use a certified safety network only when the design needs it; provide unique safety addresses, locked configuration, watchdog/acknowledgement documentation, terminal evidence and tested whole-chain reaction. A technician should be able to diagnose BUS versus SAFETY versus FINAL ELEMENT faults without disabling protection. Cable routing, labels, spare-part compatibility, and clear fault recovery are part of the safety design.

## Cross-machine transfer
- **Press brake:** stop and gravity hold for both Y axes, no automatic pressure dump assumption.
- **Mill/lathe:** spindle inertia and guard-lock timing after network loss; STO alone does not stop coasting instantaneously.
- **Robot/cell:** distributed safe I/O, access/occupancy and multiple-zone restart authority; link reintegration is not person-clear.
- **Plasma/laser:** stored electrical energy, process source enable and fume/fire hazards; safe fieldbus state does not extinguish all physical hazards.

## Acceptance / graduation gates
G0 exact selected as-built device and certified interface **UNKNOWN**; G1 actual safety configuration/dual-link timing and failure behavior **UNKNOWN**; G2 qualified isolated terminal and physical stopping/holding **NOT RUN**; G3/G4 personnel-exposed hazardous operation **NOT AUTHORIZED**; G5 independent fresh-AI evaluation **OPEN**. No TEST-CONFIRMED selected-machine behavior. No universal watchdog time, stopping distance, hydraulic truth table or PL/SIL is claimed.

## Promotion / counterfactual
The remaining selected-machine timing, final-element fault reaction and holding capacity could invalidate an **actual machine safety claim**; therefore **BLOCK** physical release and 4400-NET-01 graduation. Generic manufacturer mechanism is sufficiently documented to teach as non-graduated evidence. Future physical measurements cannot be replaced with ordinary LinuxCNC simulation.
