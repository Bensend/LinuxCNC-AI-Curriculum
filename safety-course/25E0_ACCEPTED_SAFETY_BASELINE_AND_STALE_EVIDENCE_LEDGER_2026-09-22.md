# 25E0 — Accepted Safety Baseline and Stale-Evidence Ledger

Date: 2026-09-22

## Purpose

A safety function can remain apparently healthy while the evidence that justified accepting it has become stale. This record gives the learner a durable way to answer four different questions:

1. What physical safety proposition was actually accepted?
2. Which evidence proved it at the accepted baseline?
3. Which later changes, faults, exceptions, inspections, or aging mechanisms can invalidate that evidence?
4. Where else is the same evidence or physical dependency used?

The ledger is not a substitute for risk assessment, validation, inspection, proof testing, or machine-specific acceptance criteria. It is the dependency/index layer that prevents those activities from becoming disconnected work-order paperwork.

## Evidence classes

Use repository claim classes exactly: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

A safety-critical `UNKNOWN` blocks the acceptance proposition that depends on it.

## Stable identities

Do not identify evidence only by a filename such as `test.pdf` or a statement such as “guard checked.” Use stable semantic IDs.

Suggested namespaces:

- `SF-...` — safety function
- `PROP-...` — proposition that must remain true
- `EVID-...` — evidence item / accepted result
- `DEP-...` — physical or configuration dependency
- `CHG-...` — change/fault/exception event
- `VAL-...` — validation/revalidation activity

IDs are permanent. Superseding a proposition or evidence item creates a new revision or successor identity; do not recycle the old identity.

## Minimum proposition record

| Field | Required content |
|---|---|
| Proposition ID | Stable ID |
| Safety function(s) | Every function relying on it |
| Claim | Concrete physical/configuration statement |
| Hazard boundary | What hazard this proposition helps control |
| Evidence IDs | Evidence that currently supports it |
| Dependency IDs | Inputs, logic, final elements, process witnesses, dynamics, guarding/access assumptions |
| Accepted revision/date | Last accepted baseline |
| Acceptance authority | Role/person/process authorized to accept it |
| Current state | `ACCEPTED`, `STALE`, `UNKNOWN`, `SUPERSEDED`, `REJECTED` |
| Stale reason | Event(s) invalidating prior evidence |
| Required re-proof | Physical/configuration checks needed to restore acceptance |

## Minimum evidence record

| Field | Required content |
|---|---|
| Evidence ID | Stable ID |
| Evidence class | Repository evidence class |
| Proposition(s) proved | Reverse references |
| Test/inspection identity | Procedure/revision/instrument or authoritative document |
| Machine/configuration identity | What physical/configuration baseline was actually tested |
| Result | Actual observation, not only pass/fail |
| Acceptance criterion | Machine-specific criterion or authoritative requirement; `UNKNOWN` if not established |
| Date / trigger | When and why evidence was produced |
| Validity assumptions | Dependencies that must remain unchanged |
| Current state | `CURRENT`, `STALE`, `UNKNOWN`, `SUPERSEDED` |

## Change/event record

Every relevant event must declare what it touched, not merely its maintenance trade or work-order title.

`CHG -> DEP -> PROP -> EVID`

Examples of event classes:

- component replacement;
- firmware/configuration change;
- ordinary servo/control tuning that changes machine dynamics;
- guard/sensor relocation;
- hydraulic/mechanical work affecting stopping or holding;
- safety force, simulation, jumper, muting/override or commissioning exception;
- significant fault or abnormal event;
- periodic inspection finding;
- process/tooling/load/speed change where a safety proposition depends on those conditions.

## Reverse `show where used`

For any `DEP` or `EVID`, the learner must be able to answer:

> Which accepted propositions and safety functions become stale if this item changes or is no longer trustworthy?

The lookup is intentionally reverse as well as forward. A technician replacing a brake, encoder, guard switch, valve, drive, pressure witness, or ordinary-control parameter should not need to know every safety function from memory.

## Invalidation algorithm

1. Record the event/change and affected dependency IDs.
2. Reverse-traverse each dependency to every proposition that uses it.
3. Mark evidence whose validity assumptions are violated `STALE`.
4. Mark each dependent proposition `STALE` or `UNKNOWN`; do not preserve `ACCEPTED` merely because diagnostics are healthy.
5. Union the stale proposition set across all simultaneous and accumulated changes since the last accepted baseline.
6. Derive revalidation scope from the propositions and interfaces made stale.
7. Perform the required physical/configuration re-proof.
8. Record new evidence; never silently relabel old evidence as current.
9. Obtain acceptance authority.
10. Only then proceed through reset/rearm and require fresh ordinary demand where the machine architecture requires it.

## Shared-change stress test

Consider a machine with two different safety functions that share one physical braking dependency.

- `SF-A`: protective device demands stop before a person can reach a rotating/linear hazard.
- `SF-B`: access is permitted only after hazardous motion has reached the machine-defined safe condition.
- Shared dependency: `DEP-BRAKE-01` contributes to actual stopping behavior.

A brake replacement makes `DEP-BRAKE-01` changed.

For `SF-A`, the stale proposition may be the **stopping-performance/separation-distance** proposition. Re-proof may require machine-specific stop-performance evidence under the conditions used by the safeguard design.

For `SF-B`, the brake change does **not automatically prove or disprove** the access-release proposition. If access release is based on an independent safety-rated stopped-motion witness, that witness path has different dependencies; however, if the access strategy relies on a fixed delay derived from stopping behavior, the brake change can affect that proposition too. The ledger therefore follows declared dependencies rather than assuming “same brake means same test.”

Result: **ONE PHYSICAL CHANGE != ONE UNIVERSAL REVALIDATION TEST** and **SHARED DEPENDENCY != IDENTICAL SAFETY PROPOSITION**.

A hydraulic/gravity-axis analogue is deliberately left machine-specific. A common valve, holding element, pressure witness, or mechanical restraint can participate differently in stop, prevention-of-unexpected-descent, access, or stored-energy propositions. Do not invent the machine's hydraulic truth table or pressure/holding acceptance values.

## Periodic proof/inspection versus event-driven revalidation

These are separate lifecycle triggers.

### Scheduled / recurrent proof

**DOC-CONFIRMED:** Rockwell's functional-safety documentation states that IEC 61508 requires proof tests at user-defined intervals and explicitly says the interval depends on the specific application. Different system elements can have different proof-test/useful-life requirements.

Source: Rockwell Automation, *Safety Application Requirements* (GuardLogix/Logix SIS and PowerFlex safety documentation), accessed 2026-09-22.

**DOC-CONFIRMED:** Pilz safeguard-inspection guidance describes regular inspection and includes installation, condition, function, and overrun measurement; its stop-time material explains that stopping performance can degrade with brake wear, mechanical degradation, tooling/load/speed changes, and control faults. Pilz's IEC 62046 training material distinguishes frequent functional checks from periodic inspection/test and includes measured overall stopping performance in periodic testing.

Scheduled proof therefore answers a question such as:

> Has an accepted function or physical performance remained valid over time despite latent failure, wear, drift, or degradation?

It is not evidence that no intervening change requires immediate revalidation.

### Event-driven revalidation / extraordinary inspection

**DOC-CONFIRMED:** Pilz's safeguard-inspection guidance distinguishes regular inspection from inspection after modifications and extraordinary events that could adversely affect safety, before reuse.

**DOC-CONFIRMED:** Siemens Safety Integrated acceptance documentation requires acceptance testing after commissioning and scopes acceptance/reacceptance around safety-relevant functions and machine parts. Prior 25E0 work has already established reduced acceptance after affected hardware/firmware/component changes.

Event-driven revalidation answers:

> Did this specific change/fault/exception invalidate an accepted proposition, and what must be re-proved before return to service?

It is not deferred merely because the next calendar proof test is months away.

## Lifecycle rule

Use two independent trigger lanes:

`calendar/use/degradation trigger -> periodic proof/inspection`

`change/fault/exception trigger -> proposition-specific revalidation`

Either lane can make evidence stale. Completing one lane does not automatically satisfy the other unless the performed work actually covers the same propositions, dependencies, acceptance criteria, and conditions and is recorded as such.

## Frozen distinctions

- `ACCEPTED ONCE != ACCEPTED FOREVER`.
- `CURRENT DIAGNOSTICS != CURRENT PHYSICAL VALIDATION EVIDENCE`.
- `PERIODIC PROOF DUE DATE != PERMISSION TO DEFER CHANGE-TRIGGERED REVALIDATION`.
- `EVENT REVALIDATION COMPLETE != FUTURE PERIODIC PROOF CANCELLED`.
- `ONE PHYSICAL CHANGE != ONE UNIVERSAL REVALIDATION TEST`.
- `SHARED DEPENDENCY != IDENTICAL SAFETY PROPOSITION`.
- `EVIDENCE FILE EXISTS != EVIDENCE APPLIES TO CURRENT MACHINE BASELINE`.
- `SHOW WHERE USED` must work from physical/configuration dependencies back to propositions and safety functions.

## Learner exercise

Given a machine with a light curtain, guard-locked service door, shared servo drive, mechanical brake, safety encoder, ordinary LinuxCNC motion controller, and independent safety controller:

1. Define at least four stable propositions without assigning invented PL/SIL, safe speed, stop distance, or timing values.
2. Define evidence and dependency IDs for each.
3. Apply three events: mechanical brake replacement, ordinary servo retuning, and a safety-encoder replacement two months later.
4. Reverse-trace every stale proposition after each event.
5. Separate evidence needed immediately after each event from evidence due only on a periodic schedule.
6. Explain why an unchanged safety checksum cannot restore any physical proposition made stale by those events.
7. Identify which `UNKNOWN` facts would block production return.

## Sources

- Rockwell Automation, *Safety Application Requirements* — functional proof tests are performed at application-dependent user-defined intervals; safety-system elements can have different proof-test/useful-life needs. https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um900/controllogix-5590-controller-user-manual-ditamap/controllogix-5590-multi-discipline-controller/controllogix-5590-functional-safety/safety-application-requirements.html
- Pilz, *Inspection of safeguards* — regular inspection plus inspection after relevant modifications/exceptional events; inspection includes safeguard condition/function and overrun measurement. https://www.pilz.com/en-CA/services/workplace-safety/inspection-of-safeguarding-devices
- Pilz, *Stop Time Measurement Service* — actual stopping performance supports safeguard placement and can change with wear, mechanics, tooling/load/speed and control faults. https://www.pilz.com/en-AU/company/news/articles/248042
- Pilz, *Installation and maintenance of light guards* — IEC 62046-oriented distinction between frequent functional checks and periodic inspection/test, including overall stopping-performance measurement. https://www.pilz.com/mam/pilz/images/uploads/unitedkingdom/uk_presentations_installation_maintenance_installation_light_curtains.pdf
- Siemens, *Safety Integrated Application Manual* (02/2025) — validation covers safety functions, achieved safety performance, environmental and maintenance requirements. https://support.industry.siemens.com/cs/attachments/download/81366718/application_manual_sirius_safety_integrated_en-US.pdf

## Compute decision

No simulation/build/test was needed. The unresolved questions were lifecycle/dependency questions answerable from authoritative documentation and engineering traceability. No GitHub-hosted compute was used.
