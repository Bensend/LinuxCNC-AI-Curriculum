# 4400-COMPOSE-01 — Grinder wheel, magnetic chuck and shared dust collector: three hazards, three authorities

**2026-10-27 | Cross-machine safety architecture synthesis | NON-GRADUATED / NO SELECTED MACHINE.** This is a **conditional combination** for a grinder/mill or automated cell **only if** it actually has the named equipment. It does not claim OpenPressBrake has a grinding wheel, magnetic chuck or collector. No invented valve, drive, magnet or dust protection truth table.

## Provenance and predecessor discipline

- [ABRASIVE-01 original HSE/Norton/OSHA audit](../research/4400_ABRASIVE_01_HSE_NORTON_OSHA_WHEEL_BURST_OVERSPEED_GUARD_COMPATIBILITY_AUDIT_2026-10-27.md): **DOC-CONFIRMED direct** physical wheel burst, actual speed, mounting and guard containment; **indexed-only** OSHA type-specific §1910.215.
- [MAGCHUCK-01 HSE/Walker/Walmag audit](../research/4400_MAGCHUCK_01_HSE_WALKER_WALMAG_POWER_LOSS_CONTACT_AND_EJECTION_SOURCE_AUDIT_2026-10-27.md): **DOC-CONFIRMED direct** permanent/electro-permanent power-loss retention but material, pole, contact and force dependence; residual crush.
- [Existing 2026-10-25 DUST-01 module](4400_DUST_01_WOOD_ROUTER_LEV_CAPTURE_FIRE_AND_CNC_COMMAND_BOUNDARY_MODULE_2026-10-25.md) already establishes LEV/capture, collector fire/deflagration, fan stop ambiguity and ordinary LinuxCNC M8/M9 limits. [DUST-05 correction](../research/4400_DUST_05_PREDECESSOR_OVERLAP_RECONCILIATION_AND_SOURCE_DELTA_2026-10-27.md) and [new Fike/CSB transfer audit](../research/4400_DUST_05_OSHA_CSB_FIKE_NFPA660_COLLECTOR_PROPAGATION_SOURCE_DELTA_2026-10-27.md) add source corroboration, **not** a new generic mechanism.
- This **COMPOSE-01** is **INFERENCE** about interactions among three established mechanisms; it is not an OEM certified architecture, functional-safety rating or observed machine event.

## Hazard/authority/energy map

| Boundary | Physical energy and event | Normal controller may do | Independent/physical witness still required |
|---|---|---|---|
| Wheel | Rotational kinetic energy, fracture/fragment trajectory, coast | Request speed, report encoder, stop spindle | Correct wheel rating/actual speed, compatible guard/fasteners, safe standstill and physical exclusion |
| Workpiece/chuck | Magnetic field, attraction/crush, machining shear/ejection | Request magnetize/demagnetize, show status | Exact technology, material/poles/air gap/fixtures, actual retention, guarding, supported safe release |
| Collector/duct | Combustible particulate, ignition/smolder, confined deflagration, secondary propagation, compressed-air pulses | Request extraction, show fan/Delta-P/hood indication | Qualified capture, collector and connected-path protection, vent/exclusion, material compatibility and service isolation |
| People/access | Body in wheel plane, between part and chuck, at collector door or vent discharge | HMI prompts, ordinary alarms, motion request | Physical guards/access, independent stopping/holding, maintenance isolation, deliberate rearm and human-factors design |
| Shared power/logic | AC/24 V/ground/network/PLC supply and reboot | Log faults and state, fail ordinary process requests | No single normal status bit credited as all three safety functions; separate CCF and power-return analysis |

## Power-loss / fault / restart analysis — illustrative propositions, not a machine sequence

| Disturbance | Tempting but false assumption | What must be established before any selected operation |
|---|---|---|
| AC power lost during grinding | 'All energy is gone.' | Wheel may coast; permanent magnet may hold/attract; collector can retain hot dust, fire and pressure; independent personnel exclusion and service plan. |
| AC returns with stored CNC job | 'Magnet stayed ON, so resume.' | Actual part position/retention, wheel condition, guard/collector readiness and **new deliberate start**; no auto-resume from restored signals. |
| Electromagnetic chuck supply fails | 'Every magnetic chuck holds without power.' | Actual selected electromagnetic vs electro-permanent vs manual permanent behavior, backup and ejection containment. |
| Magnet OFF command accepted | 'The part is released and safe to grab.' | Exact demagnetization/retained attraction, physical part support, stopped wheel and isolated access. |
| E-stop asserted | 'Fan and magnet must both switch OFF immediately.' | Wheel stop, part retention and collector fire response are **different** functions; fan/magnet sequencing is product- and hazard-specific and cannot be prescribed generically. |
| Collector fire/spark alarm | 'Keep fan running to evacuate dust.' | Qualified collector-specific detection, vent/isolation/suppression and coordinated machine response; no universal fan ON/OFF instruction. |
| Wheel fractures while guard switch still green | 'The interlock proves containment.' | Correct guard material, geometry, fasteners, condition, fragment exclusion and inspection after event. |
| Shared 24 V / network fault | 'All healthy bits were true before the fault.' | Independent protective system dependencies, fault reaction, stale feedback and physical final-element truth. |
| Technician bypasses guard to clear a dust hose | 'Machine program is paused.' | Physically safe access, wheel standstill, magnetic crush, collector isolation and redesign to avoid bypass incentives. |
| Material change from steel to another alloy/metal dust | 'Same spindle program and HMI settings.' | New wheel/part holding and dust combustibility/collector compatibility evidence; reopen `CHG/VAL/PT`. |

## Minimum practical low-defeat architecture

1. Put a **correct, easily reinstallable fragment guard** around the wheel. Provide a tool/fixture combination that fits the guard; never substitute a splash shield or rely on HMI.
2. Make correct **magnetic pole extensions, mechanical stops and part setup** obvious, available and quick. Mark unqualified materials/setups as HOLD. Ensure the safe maintenance procedure addresses persistent magnetic force, not just electrical isolation.
3. Make the **collector and duct** accessible for inspection/cleaning without opening a hazardous machine zone. Keep normal fan/hood status distinct from engineered fire/deflagration protection. Do not connect incompatible dust materials or bypass protective duct devices for convenience.
4. Provide **separate physical witness fields** for wheel, workpiece and collector. One green 'machine ready' lamp may summarize normal operation but must not become the sole safety authority.
5. Document a **fresh-start handback** that verifies the exact installed physical protection, restores maintenance isolation, clears personnel, re-arms independent safety only after valid reset, and requires deliberate new motion authorization.
6. Make ordinary LinuxCNC/FPGA failure observable and logged without depending on it to contain fragments, retain a part, isolate a dust explosion or remove stored energy.

## Conditional precommissioning evidence (no tests executed)

- **WHEEL-PHY:** selected wheel/machine rating, actual speed envelope, mounting, guard and standstill/occupancy.
- **MAG-PHY:** selected chuck technology, workpiece material/pole/air gap, load case, ejection guard and maintenance crush.
- **DUST-PHY:** selected material, collection layout, qualified vent/isolation, deposits and service energy.
- **COMMON-PHY:** supply/ground/network fault and restart dependency; exact device feedback and independently justified stop/rearm.
- **HF/CHG:** guard restoration, fixture setup, collector cleaning and changes to wheel, part or dust material.
- **VAL/PT:** all **UNKNOWN/NOT RUN**; no physical test, no safe-operation claim, no new public paper cases or scores.

**Decision:** If any required basic physical protection is unresolved, **do not operate with people exposed**. Remote experimental operation must itself be isolated with residual fragment/ejection/fire/explosion propagation risks explicitly addressed; merely removing the CNC operator does not establish safety. Existing OpenPressBrake G0/G1 HOLD and 2520–25F0 independent evaluator NOT RUN remain unchanged.
