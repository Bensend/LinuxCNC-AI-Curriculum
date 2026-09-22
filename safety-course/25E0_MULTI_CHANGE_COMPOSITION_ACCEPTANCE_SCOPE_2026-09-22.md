# 25E0 — Multi-Change Composition Acceptance Scope

Date: 2026-09-22

## Purpose

Teach the learner how to decide whether several individually small maintenance or modification changes can be closed with local reduced tests, or whether their interaction invalidates evidence for a larger composed safety function.

The method does **not** invent a universal threshold. Acceptance scope is derived from affected safety propositions, logical groups, interfaces, and machine physics.

## Evidence basis

### SOURCE-CONFIRMED — Siemens SINUMERIK/S120 acceptance methodology

Siemens documents that initial Safety Integrated commissioning requires a complete acceptance test. Later safety-related functional expansion, hardware change, software upgrade, series transfer, and modular-machine changes can require a new complete or partial acceptance test. A reduced/partial acceptance test is not selected merely because a technician calls a change minor: the acceptance-test objects must first be identified and grouped logically. Siemens also warns that component replacement can create non-safe states and requires a simplified functional test of affected drives before danger-area re-entry or resumed operation.

Source: Siemens, *SINUMERIK Operate acceptance test*, Function Manual 07/2022, 6FC5397-5KP10-0BA0, section 7.1.

### DOC-CONFIRMED — Pilz validation depth is change/application dependent

Pilz describes validation depth as application dependent. Its published validation examples distinguish re-checks, minor changes to previously validated machines, and complex/significant changes requiring more comprehensive examination. This supports impact-based scope selection but does not establish a transferable numeric threshold for when a particular machine crosses from partial to complete validation.

Sources: Pilz machinery-safety validation service documentation and 2023 validation-level publication.

## Core rule

**LOCAL TEST PASS + LOCAL TEST PASS != COMPOSED SAFETY FUNCTION REVALIDATED.**

For each change, identify what evidence became stale. Then take the union of those stale propositions and examine the interfaces between them. If an interface or end-to-end proposition is affected, the acceptance scope must include an end-to-end test of that proposition even when each component also has a passing local diagnostic.

## Learner-facing scope method

For every simultaneous or accumulated change set:

1. **Name every change.** Include hardware, wiring, firmware, safety parameters, ordinary-control parameters that affect dynamics, mechanical work, hydraulic/pneumatic plumbing, sensor relocation, temporary forces/simulation, and safeguard changes.
2. **Map each change to stale evidence.** Do not map only to the replaced component. Name the physical proposition previously supported by that evidence.
3. **Identify shared safety functions.** Determine whether two changes participate in the same safety function, stopping chain, access function, retaining function, or hazardous-energy boundary.
4. **Inspect interfaces.** Ask whether a changed input, logic/configuration element, final element, process witness, or machine dynamic interacts with another changed item.
5. **Define the minimum defensible acceptance scope.** Local component checks may remain necessary, but add composed end-to-end tests wherever the changed set invalidated end-to-end evidence.
6. **Escalate when scope cannot be bounded.** If the affected logical group, safety proposition, or machine consequence cannot be confidently isolated, do not guess a small test. Mark the boundary UNKNOWN and broaden validation until the required proposition can be defended.
7. **Restore production authority separately.** Passing validation does not itself create a fresh ordinary motion demand. Exceptional states must be cleared, reset/rearm handled according to the design, and normal production demand must satisfy its own freshness rules.

## Composition triggers that require explicit review

These are review triggers, not universal mandates for a complete machine acceptance test:

- two changed components participate in the same safety function;
- one change alters a witness while another alters the final element it is intended to prove;
- a control/drive change can alter stopping dynamics while a safeguard-positioning assumption depends on stopping performance;
- a mechanical/hydraulic change can alter the physical consequence of an otherwise unchanged safety output;
- two local logical groups share a common input, final element, energy source, reset/rearm path, or hazardous zone;
- temporary commissioning measures obscure whether a real field witness has actually been restored;
- configuration identity is known but the corresponding physical implementation has changed;
- the change boundary is UNKNOWN.

## Adversarial case — two individually healthy replacements

A servo machine has a guard interlock and a safety encoder. During one maintenance window:

- the guard switch is replaced and its local two-channel diagnostic reports healthy;
- the safety encoder is replaced and the drive reports valid encoder communication;
- wiring checks pass;
- no active safety fault remains;
- the safety configuration checksum matches the approved project.

The learner must reject the conclusion `machine validated`.

The guard replacement can stale evidence about physical guard actuation, alignment, defeat resistance, and the guard-related stop/access function. The encoder replacement can stale actual-value acquisition, direction/position/speed evidence and every safety function depending on that witness. If the guard-opening safety function relies on a monitored stop or safe speed derived from the replaced encoder, the two change sets overlap in the same composed proposition. Local guard and encoder health checks are therefore insufficient by themselves; the affected end-to-end guard-to-safe-motion behavior requires acceptance evidence.

### Required classification

- `guard local channels healthy` — evidence of local electrical/device state only.
- `encoder communications healthy` — evidence of communication/device state only.
- `checksum matches` — configuration-identity evidence only.
- `guard opening causes required safe machine behavior using valid physical motion evidence` — composed safety-function proposition requiring physical acceptance evidence.

## Hydraulic/gravity-axis transfer test

A pressure transducer is replaced while a load-holding valve is also replaced. Both pass local diagnostics/leak checks appropriate to their component procedures.

Do not infer that the gravity-axis personnel-safety function is restored. The two changes may overlap in a proposition involving hazardous-energy isolation, retained load, pressure/process evidence, and physical final-element behavior. Required acceptance scope must be derived from the actual machine architecture. No pressure threshold, valve truth table, stopping distance, or holding criterion is invented here.

## Rotating/servo transfer test

A safety encoder is replaced while drive firmware/control tuning is changed. The encoder may locally report valid and the drive may have the expected safety configuration, yet stopping dynamics or safety actual-value evidence can have changed. Where safeguard positioning or a stop function depends on those properties, end-to-end stopping evidence becomes stale.

## Frozen distinctions

- **COMPONENT DIAGNOSTIC PASS != SAFETY FUNCTION VALIDATED.**
- **TWO LOCAL PASSES != COMPOSED END-TO-END PASS.**
- **PARTIAL ACCEPTANCE != ARBITRARILY SMALL ACCEPTANCE.**
- **SAME CHECKSUM != SAME FIELD PHYSICS.**
- **CHANGE COUNT != ACCEPTANCE SCOPE.** Scope follows affected propositions and interfaces, not the number of work-order lines.
- **VALIDATION COMPLETE != FRESH PRODUCTION START DEMAND.**

## Human-factors rule

The change-impact record should make the safe path easier: technicians should be able to select affected functions/interfaces and receive the already-defined revalidation obligations. If the only practical way to determine required tests is to reconstruct the whole safety design under production pressure, the maintenance workflow itself invites shortcuts and should be improved.

## UNKNOWN handling

When the repository lacks machine-specific evidence for a hydraulic state, stopping distance, safe speed, diagnostic coverage, PL/SIL target, or physical acceptance threshold, mark it `UNKNOWN / MACHINE-SPECIFIC`. Do not convert absence of evidence into a generic acceptance criterion.
