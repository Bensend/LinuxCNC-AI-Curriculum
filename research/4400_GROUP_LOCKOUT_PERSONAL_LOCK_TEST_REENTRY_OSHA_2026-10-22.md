# 4400 — Group lockout: personal protection, powered test, and re-entry

**2026-10-22 | Evidence:** DOC-CONFIRMED for OSHA text and interpretations; INFERENCE for the two-ledger training model; UNKNOWN for any installed machine. This is curriculum research, not an approved site procedure or physical validation.

## New documentary discriminator

**Question:** May a supervisor's lock plus a signed crew roster substitute for each servicing worker's personal lock when a crew temporarily energizes a machine for positioning? **No**, under the OSHA 2021-05-21 interpretation's rejected scenario. In its accepted satellite-lockbox example, each worker retains personal control and the coordinator cannot retrieve the upstream key while those locks remain.

- **DOC-CONFIRMED:** 29 CFR 1910.147(f)(3)(ii)(D) requires each authorized servicing worker's personal device on the group lockout mechanism. OSHA explicitly rejected the supervisor-lock-plus-roster example and accepted a specified nested lockbox arrangement. Source: https://www.osha.gov/laws-regs/standardinterpretations/2021-05-21 .
- **DOC-CONFIRMED:** 29 CFR 1910.147(f)(1)(i–v) orders tool clearance, employee clearance, authorized lock removal, limited testing/positioning, and reapplication of energy control before further service. Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 .
- **DOC-CONFIRMED:** OSHA's 2024-10-21 interpretation restricts this temporary allowance to necessary testing/positioning, requires effective protection during the energized phase, and does **not** accept ANSI B11.0 / Z244.1 'alternative methods' as a blanket replacement for applicable OSHA LOTO requirements. It is not blanket permission for unguarded personnel exposure. Source: https://www.osha.gov/laws-regs/standardinterpretations/2024-10-21 .
- **DOC-CONFIRMED:** 1910.147(f)(4) requires continuity across shift/personnel changes. Section (d)(5–6) requires appropriate control of stored energy and verification of isolation. Source: same OSHA regulation; shift tutorial https://www.osha.gov/etools/lockout-tagout/tutorial/shift-personnel-changes .
- **UNKNOWN:** The selected machine's isolators, actual stored-energy state, restraint/holding behavior, guard coverage, installed safety-controller program, qualified test mode, stopping performance, and jurisdiction/task applicability. No PL/SIL, pressure or stopping values are inferred.

## Two evidence ledgers — engineering inference, not safety software

**Personnel ledger:** Identify every exposed authorized worker, individual personal lock, group/satellite box custody, responsible coordinator, affected contractors, location/clearance, and shift transfer. A roster or HMI indicator is supplementary communication, not the worker's required personal control.

**Physical energy ledger:** Identify each energy source and isolation point; hydraulic/pneumatic trapped volumes; gravity, inertia and mechanical restraints; task-specific physical witnesses; the limited energized-test boundary; and renewed isolation verification after the test. A software E-stop, contactor auxiliary contact, valve feedback, or 'pump off' indication cannot prove all of these propositions.

**Joint gate:** Do not authorize a temporary powered test while any worker remains exposed, any personal lock remains unresolved, or the test's protection/physical load boundary is unknown. Do not allow servicing re-entry merely because the test ended or LinuxCNC indicates E-stop. Reapply the appropriate energy controls and establish a new physical verification after re-energization.

## Adversarial transfer checks

| Contradiction | Required disposition |
|---|---|
| Supervisor roster says clear, one worker's lock remains on satellite box | STOP; reconcile personal control with that worker and the authorized procedure. |
| All locks removed, but a helper's location is unknown | STOP; physical personnel clearance is not established. |
| Shift changes while the test is pending | STOP/HOLD until the documented protection and coordination transfer is complete. |
| Previous pressure check was made before a powered positioning step | Prior verification is STALE; re-isolate and reverify before service. |
| Valve feedback says safe but ram/beam movement or trapped energy contradicts it | Physical hazard evidence wins; do not release exposure. |
| Ordinary LinuxCNC setup mode and a three-position switch are proposed as a generic LOTO replacement | NOT ESTABLISHED; determine the actual task, jurisdiction, selected safeguards, and isolation obligations. |

**Human factors:** Place identifiable personal-lock points, readable energy maps, test/clearance coordination, and service-friendly isolation/restraint access where workers can use them without defeating guards. Redesign repeated inconvenience rather than normalizing bypass.

**Traceability:** Carry the task and exposure through `BND/HAZ/ENE`; safe-to-enter through `SRS/PHY`; individual/coordinator/independent-safety authority through `AUTH`; lockbox and shared-energy dependencies through `DEP/ARC`; bypass incentives through `HF`; physical proof through `VAL/PT`; and stale evidence/unknowns through `CHG/UNK/RR`. This extends the staged temporary re-energization lesson; it does not replace machine-specific energy-control procedures.

**Release:** NOT FROZEN / NOT VALIDATED. No personnel-exposed hazardous operation when minimum safe-to-operate protection is unproved. No physical or hosted-runner compute was used to establish these documentary findings.
