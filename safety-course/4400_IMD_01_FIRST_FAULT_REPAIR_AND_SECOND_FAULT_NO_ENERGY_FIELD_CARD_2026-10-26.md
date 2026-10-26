# 4400-IMD-01 — Do not normalize the first insulation fault
**PUBLIC no-energy technician card; NON-GRADUATED. Four PAPER cases UNSCORED; six documentary gates NOT RUN.**

Read [Bender/OSHA original-source audit](../research/4400_IMD_01_UNGROUNDED_CONTROL_FIRST_FAULT_SECOND_FAULT_AND_VFD_VARIANT_OEM_AUDIT_2026-10-26.md). Do not intentionally introduce ground faults into any powered machine or disconnect PE to “demonstrate” a condition.

## Four UNSCORED paper cases
**IMD-P01:** An unearthed 24 V control circuit reports its first insulation fault but production continues. The alarm is silenced indefinitely. Identify the failure chain if a second conductor develops a fault; separate possible fault-current path from unproven machine-motion effects and define a qualified repair/escalation route.

**IMD-P02:** A buyer substitutes an iso415R for an iso685 on a VFD-containing IT system because both are Bender ISOMETER products. Which exact manufacturer application distinction defeats the shortcut, and which design facts remain UNKNOWN?

**IMD-P03:** An IMD's Modbus alarm clears from the LinuxCNC HMI after a reboot, but its physical alarm relay and history are not inspected. Does a green screen establish insulation recovery, fault detector health or independent physical safe state? Explain freshness, latching and witness ownership.

**IMD-P04:** A designer proposes wiring any IMD alarm to drop the press brake's hydraulic pump immediately. Explain why the actual SRS must first establish the physical effect on Y1/Y2 stopping, load holding, trapped pressure and restart. Do not invent the hydraulic truth table.

## Six documentary gates — NOT RUN
| Gate | Selected-machine evidence needed | State |
|---|---|---|
| IMD-G01 | Exact grounded/ungrounded topology and applicable electrical standard/exception | NOT RUN |
| IMD-G02 | Selected IMD model/manual and VFD/rectifier compatibility | NOT RUN |
| IMD-G03 | First/second fault analysis for exact control wiring and loads | NOT RUN |
| IMD-G04 | Alarm contact configuration, self-test, measurement connection, diagnostic freshness and maintenance plan | NOT RUN |
| IMD-G05 | Qualified physical safe-state effects of fault response, loss of power, stop/hold and rearm | NOT RUN |
| IMD-G06 | Independent isolation, stored-energy control, repair verification and approval record | NOT RUN |

## Practical low-friction pattern
Show “FIRST INSULATION FAULT: REPAIR BEFORE SECOND FAULT” with affected circuit and a one-step qualified maintenance route; keep the alarm physically visible until the cause is addressed, with a documented acknowledgement/rearm distinction. Avoid nuisance-causing alarm designs that predictably encourage bypass. Use approved parts and straightforward access for diagnosis; no silent auto-clear from a restarted HMI.

**Limits:** original OEM/OSHA claims are DOC-CONFIRMED for their scope; first/second fault sequence is an INFERENCE until selected circuit analysis; machine-specific outcomes UNKNOWN. No simulated, energized or physical test and no independent competency score. G0/G1 HOLD; no personnel-exposed hazardous operation.
