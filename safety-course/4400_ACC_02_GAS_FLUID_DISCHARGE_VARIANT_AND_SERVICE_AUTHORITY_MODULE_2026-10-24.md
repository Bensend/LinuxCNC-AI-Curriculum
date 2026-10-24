# 4400-ACC-02 — Accumulator gas/fluid energy, bleed variants and safe service authority
**4000 Safety Course | 2026-10-24 | RESEARCH / NOT GRADUATED | no physical test or independent evaluator score**

## Placement and prerequisite
Deepens the existing 2580 fluid-power route, [accumulator dual-role source study](../research/4400_ACCUMULATOR_DUAL_ROLE_SAFE_CYCLE_VS_ISOLATION_2026-10-22.md), [reaccumulation contract](../research/4400_ACCUMULATOR_PROTECTIVE_CYCLE_REACCUMULATION_WITNESS_CONTRACT_2026-10-23.md), 4400-HYD-01 and 4400-BLK-01. It is **not** a duplicate generic 'pump off is not safe' lesson. It teaches two new OEM-specific discriminators: **gas-vessel residual energy despite hydraulic draining**, and **normally-open vs normally-closed discharge hardware within one safety-block family**.

## Learning outcome
A fresh AI engineer can separate: (1) controlled protective-cycle energy; (2) fluid-side isolation/bleed; (3) gas-side stored energy and vessel-service permission; (4) gravity-load restraint; (5) independent physical pressure/motion witness; (6) restart/reaccumulation controls. It can identify a Y/Z or M/E replacement that invalidates the previous safety argument without inventing a hydraulic truth table.

## Sources and confidence
- [Original Parker PVSI-01 audit](../research/4400_PARKER_PVSI_GAS_FLUID_RESIDUAL_ENERGY_DISASSEMBLY_OEM_AUDIT_2026-10-24.md): **DOC-CONFIRMED, original PDF directly inspected**, printed pp. 3–5. Distinct fluid drain and gas precharge service; resistance during disassembly is a stop sign.
- [HYDAC SAF catalog-variant audit](../research/4400_HYDAC_SAF_Y_Z_BLEED_VARIANT_AND_PHYSICAL_WITNESS_AUDIT_2026-10-24.md): **DOC-CONFIRMED from official indexed catalog and part page, full PDF NOT directly opened**; Y normally open vs Z normally closed; M manual vs E solenoid+manual. Do not extrapolate any selected machine state.
- [OSHA 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) (d)(5)–(6): stored energy rendered safe; continued verification when hazardous reaccumulation is possible; authorized worker verifies isolation. **DOC-CONFIRMED** regulatory text, not an installed-circuit design.

## Six propositions that require different evidence
| Claim | Needed independent evidence | Not a substitute |
|---|---|---|
| P1 Protective motion finished | Actual safe direction/result, Y1/Y2 or other relevant motion, selected SRS | Pump off or LinuxCNC motion command zero |
| P2 Gravity load held | Physical restraint/holding and defined interval under selected hazards | One fluid gauge zero |
| P3 Fluid side rendered safe for task | Lockable isolators, identified zones, actual qualified pressure verification | 'Bleed commanded' or one remote transducer |
| P4 Gas vessel safe for proposed intervention | Exact vessel OEM, qualified gas-side service evidence, task-specific release criteria | Fluid-side zero reading or gas cap |
| P5 Reaccumulation controlled | Refeed/temperature/pilot/check-valve review and continuing verification where required | Single snapshot |
| P6 Restart deliberate | Personnel clear, guard restored, independent rearm, new ordinary start | E-stop reset or retained pedal/queued command |

## Authority partition
- **Ordinary LinuxCNC / normal FPGA:** commands, logging, status and non-safety diagnostics. No authority to declare pressure vessel safe, approve service entry or perform personnel-safety stop.
- **Independent safety-related controller:** selected demand/monitoring/rearm of safety functions, with justified hardware and integration.
- **Physical final elements:** identified lockable isolators, selected bleed valves, verified holding/restraint, vessel and ports.
- **Qualified authorized personnel:** energy-control procedure, zone-specific verification, OEM vessel servicing and physical access release. A safety PLC is not a personal lock.

## State-machine *requirements*, not executable hydraulic commands
`RUN -> PROTECTIVE_DEMAND -> PHYSICAL_SAFE_RESULT_UNKNOWN/PROVED -> RESTRICTED_HOLD -> MAINTENANCE_ISOLATION_PENDING -> VERIFIED_TASK_SAFE -> SERVICE -> RESTORE_GUARDS_AND_PEOPLE_CLEAR -> SAFETY_REARM -> NEW_NORMAL_START`.
Every arrow has its own preconditions; **PROTECTIVE_DEMAND** is not permission to drain a load-bearing cylinder and **PHYSICAL_SAFE_RESULT_PROVED** is not permission to open a gas-charged vessel. If any required witness is UNKNOWN, remain in HOLD. No generic valve sequence or pressure value is supplied.

## Failure/maintenance adversarial review
- OEM Y block swapped to Z: power-loss bleed expectation may reverse. Mark affected SRS, ARC, DEP, VAL/PT and change records **STALE** until independently reconciled.
- E swapped to M: electrical bleed demand loses the presumed solenoid final element.
- Local fluid gauge zero, gas precharge remains: vessel-opening service **NOT AUTHORIZED**.
- Closed/obstructed return, false pressure witness or blocked tap: physical discharge **NOT PROVEN**.
- Drain opens while ram depends on pressure: gravity hold **NOT PROVEN**; physical restraint design required before service.
- Reset with held start: new deliberate ordinary command required after safety rearm; no automatic movement.
- Human-factors defeat: put protected, labeled test points and removable/captive guards where safe verification is easiest; redesign any procedure that forces technicians to improvise.

## Exercises, proof and graduation
Complete [18 non-blind paper cases](4400_ACCUMULATOR_GAS_FLUID_SAF_VARIANT_TECHNICIAN_CARD_2026-10-24.md) and use [blank qualified witness](4400_ACCUMULATOR_GAS_FLUID_ZONE_AND_REARM_BLANK_WITNESS_2026-10-24.md) only as a planning record. These are **not** physical tests, certification or independent learner scores. **No hazardous gas charging, disassembly or induced rupture is authorized.**

**UNKNOWN:** OpenPressBrake actual accumulator presence, vessel type, Y1/Y2 fluid zone map, bleed-valve variant, gas charge, safe stop/hold, release, safety integrity, guard/escape and fresh restart. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** This module is NOT GRADUATED. If there is no selected accumulator, document that from qualified inventory, but do not waive the machine's independent physical stop/hold obligations.

**Next:** selected-machine as-built packet and independent fresh evaluator; if unavailable, rotate to another source-supported 4400 safety gap. No synthetic lab or GitHub-hosted compute justified.
