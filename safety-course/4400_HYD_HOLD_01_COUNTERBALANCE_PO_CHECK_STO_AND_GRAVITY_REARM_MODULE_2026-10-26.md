# 4400-HYD-HOLD-01 — Hydraulic load holding, supply shut-off and stored pressure are three different problems
**Practical safety module | 2026-10-26 | NON-GRADUATED / PAPER ONLY.**

## Learning objective
Given an as-built hydraulic circuit, identify whether it (a) commands controlled motion, (b) prevents uncontrolled descent after power/line fault, (c) safely isolates/depressurizes for maintenance, and (d) requires a fresh local restart. Refuse to infer any of these from a generic "safety valve" label.

## Primary source path
1. [Parker HAS original order-code, PO-check, counterbalance and trapped-pressure audit](../research/4400_PARKER_HAS_LOAD_HOLD_CODE_N_MANUAL_RELEASE_PO_CHECK_AND_TRAPPED_PRESSURE_OEM_AUDIT_2026-10-26.md).
2. [Bosch Rexroth STOM original hydraulic STO/SDE/SLS partial-function audit](../research/4400_BOSCH_REXROTH_STOM_HYDRAULIC_STO_SDE_SLS_VS_RAM_HOLD_OEM_SCOPE_AUDIT_2026-10-26.md).
3. [Twelve unsolved technician cases](4400_HYD_HOLD_01_TWELVE_UNSCORED_VALVE_AND_RAM_CASES_2026-10-26.md) and [12-gate qualified documentary review](4400_HYD_HOLD_01_TWELVE_GATE_NO_ENERGY_SELECTED_MACHINE_REVIEW_2026-10-26.md).

## Four separate engineering layers
| Layer | Typical evidence | Not proof of |
|---|---|---|
| **Ordinary control** | LinuxCNC target, FPGA valve command, pump/servo status | Physical holding, E-stop or isolation |
| **Safety-related control** | Independent risk-derived safety functions, safety logic, monitored shut-off valves | That load is mechanically supported or trapped pressure eliminated |
| **Hydraulic energy and load path** | Cylinder/valve/pilot/drain/accumulator as-built, component and mounting proof | No creep or maintenance-safe zero energy by name alone |
| **Physical access/energy isolation** | Guard, rated support, LOTO, pressure-zone verification, supervised release/rescue | Permission to restart automatically |

## The surprising manufacturer example
Parker HAS **N** means *no load holding*, even though the manufacturer describes an installed pilot-operated check whose **manual override is engaged** for free flow. Parker **P/R** pilot checks are on/off holding devices and the OEM warns against using them alone to lower overrunning loads; counterbalance valves modulate lowering and may relieve trapped thermal pressure. Meanwhile Bosch's hydraulic **STO** manifold is an upstream **supply shut-off partial safety function**; it is not automatically a cylinder-side gravity lock. All statements apply only to the named OEM products.

## Failure-response exercise (no assumed physical truth table)
1. Identify gravity direction and each independent Y1/Y2 cylinder/load path. Mark every unknown as UNKNOWN.
2. Draw normal control requests separately from safety controller commands and valve power states.
3. Mark each actuator chamber, pilot line, accumulator, return line, test point and physical support; do not assume unshown hardware.
4. Trace loss of electrical power, pump stop, upstream supply shut-off, downstream line break, pilot crossfeed, leaking valve and manual release **one at a time**, without guessing their outcomes.
5. For every hazard, require an independent physical witness of holding or safe no-person-exposure boundary, plus diagnostic and deliberate restart evidence.
6. Before service, confirm independent mechanical support and qualified pressure-zone isolation; a holding valve may *create* trapped pressure.
7. A reset, recovered sensor, or restored pressure must not automatically issue a motion command.

## Human-factors requirement
Make a positive load support captive, visible and quick to engage; make isolation/bleed access reachable without entering the pinch zone; use clear labels for *hold*, *supply isolated*, *pressure retained* and *maintenance safe*; require a simple two-person review for altered valve option/override or service release. A process that depends on invisible manual-release positions or difficult guard removal invites dangerous shortcuts.

## Completion and hard gate
**DOC-CONFIRMED:** exact Parker/Bosch statements. **INFERENCE:** proposed layered architecture. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none.** **UNKNOWN:** actual OpenPressBrake cylinders/valves/loads, pressure/PL/SIL, independent physical proof, evaluator. Paper cases **UNSCORED** and documentary review **NOT RUN**. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** Do not operate with people exposed unless qualified machine-specific validation establishes a minimum safe-to-operate threshold; experimental work, if independently approved, must isolate people outside the hazard zone.