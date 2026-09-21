# Rockwell Running-Application Exceptional-State Observability and Audit Boundary

Date: 2026-09-21
Course: 4000 Practical Machine Safety Engineering / 25C0 human factors and production handoff

## Question

Can a real industrial controller expose enough exceptional commissioning state to the *running application* to support a production-handoff interlock, without pretending that ordinary controller logic is personnel-safety authority?

## Evidence

### I/O force state is directly program-readable

**DOC-CONFIRMED — Rockwell Logix 5000.** The `MODULE` object exposes `ForceStatus` through `GSV`. Bit 0 reports whether I/O forces are installed; bit 1 reports whether I/O forces are enabled. Rockwell's I/O/tag manual gives an explicit ladder example and warns that this attribute covers I/O forces, not SFC forces.

This is stronger than an engineering-UI indicator: ordinary controller logic can positively know at runtime that I/O force values remain installed even when globally disabled.

Source: Rockwell, *Logix 5000 Controllers I/O and Tag Data*, publication 1756-PM004L-EN-P (Nov. 2023), Force I/O / GSV instruction; current Logix Designer `Module` object documentation.

### Change history is also program-readable, but is not the same thing as current exceptional state

**DOC-CONFIRMED.** The `Controller` object exposes an `Audit Value` through `GSV`, and `ChangesToDetect` selects monitored changes. Rockwell recommends monitoring events including online edits and I/O/SFC force enable, disable, removal, and value changes. A monitored event changes the audit value.

This supports a useful production-handoff rule: an unexpected audit-value change can invalidate a previously accepted ordinary-production baseline and demand disposition.

It does **not** prove which exceptional state is currently active. An audit value is change evidence, not a complete live-state manifest.

Sources: Rockwell Logix Designer `Access the Controller object`; ControlLogix 5580/GuardLogix 5580 `Change Detection` documentation.

### Safety status is program-readable but remains a separate authority class

**DOC-CONFIRMED.** The Safety object exposes attributes such as `SafetyLockedState` and `SafetyStatus` by GSV from the standard task. Rockwell explicitly limits the meaning of safety locking: it protects safety components; safety locking alone does not satisfy the safety-integrity requirements, and standard routines remain a separate change surface.

Therefore a normal production-handoff monitor may display/consume diagnostic safety status, but `SafetyLockedState` must not be collapsed into `PRODUCTION_CONFIGURATION_CLEAN`, and neither ordinary handoff logic nor LinuxCNC-equivalent logic becomes personnel-safety authority merely by observing it.

Sources: Rockwell Logix Designer `Access the Safety object`; Logix SIS `Lock the Controller`.

### Engineering UI sees more classes than the documented running-application interface

**DOC-CONFIRMED.** Studio 5000's Online Bar separately displays controller mode/status, force status, online-edit status, redundancy status, and safety status. This proves that the platform itself distinguishes these state classes.

**UNKNOWN / NOT ESTABLISHED:** the reviewed authoritative documentation does not establish a single running-program attribute that provides the Online Bar's complete current online-edit state, SFC-force state, simulation state, maintenance bypasses, physical jumpers/test fixtures, and personnel presence as one live manifest.

Do not infer programmatic observability merely because an engineering UI can display a state.

## Important online-edit distinction

Rockwell documents that online edits in standard routines can occur independently of safety lock. Safety-program edits require impact-based revalidation before normal operation resumes; standard-routine edits still require assurance that timing/tag mapping remain acceptable to the safety application.

A particularly important human-factors consequence follows:

**NO PENDING ONLINE EDITS != KNOWN PRODUCTION BASELINE.**

Once an edit is assembled/accepted, the temporary edit state can disappear while the changed logic remains. A handoff architecture therefore needs both:

1. current exceptional-state checks where the platform exposes them; and
2. baseline/change-accounting evidence that detects or records accepted changes.

The audit/change-detection mechanism is useful for the second role, not a substitute for the first.

## Reusable production-handoff pattern

For an ordinary controller, define a non-safety `PRODUCTION_CONFIGURATION_CLEAN` gate from heterogeneous evidence rather than one generic `SAFE` bit.

Suggested evidence classes:

- **live machine-readable current state** — e.g. I/O `ForceStatus`: no force values installed, not merely disabled;
- **change-baseline integrity** — audit value equals the accepted production baseline or every change since baseline has documented disposition;
- **explicit platform-specific clearance** — exceptional classes not exposed to running logic, such as an edit/simulation class when no authoritative runtime attribute exists;
- **physical inspection clearance** — jumpers, test boxes, temporary hydraulic/mechanical aids, disconnected/replaced sensors, temporary guards;
- **independent safety readiness** — evaluated by the actual safety-related system and its validation evidence, not synthesized by ordinary handoff logic.

A practical state machine should fail closed for *production authorization* when a machine-readable exceptional state is positively present or when baseline integrity is unknown. That does not mean the ordinary controller is performing the personnel-safety function; it means ordinary automation refuses to claim normal production readiness.

## Adversarial cases

1. `ForceStatus = installed=1, enabled=0`: production handoff fails. Disabled force values remain an exceptional state and can later become active.
2. `ForceStatus = 0`, audit value changed unexpectedly: production handoff fails pending disposition even though no force is currently installed.
3. `ForceStatus = 0`, audit baseline matches, SafetyLocked=1: this is still insufficient to prove physical test aids removed, safeguards validated, or personnel clear.
4. Online edit was accepted, current UI says `No Edits`: do not infer original production logic is restored. Accepted configuration must be reconciled against the production baseline/change record.
5. Controller telemetry is clean but a temporary jumper remains in the cabinet: controller-only manifest passes falsely unless the handoff includes physical clearance.

## Curriculum freezes

- **FORCES DISABLED != FORCE VALUES REMOVED.**
- **NO I/O FORCES INSTALLED != NO SFC FORCES / EDITS / BYPASSES / PHYSICAL TEST AIDS.**
- **AUDIT VALUE UNCHANGED != PHYSICAL MACHINE UNCHANGED.**
- **AUDIT VALUE CHANGED != CURRENT EXCEPTION ACTIVE; it means baseline disposition is required.**
- **NO PENDING ONLINE EDITS != KNOWN PRODUCTION BASELINE.**
- **SAFETY LOCKED != PRODUCTION CONFIGURATION CLEAN != PERSONNEL-SAFETY FUNCTION VALIDATED.**
- **ENGINEERING UI CAN DISPLAY STATE != RUNNING APPLICATION CAN AUTHORITATIVELY READ THAT STATE.**

## Open question / next evidence target

The desired next source is a real industrial implementation that combines *more than one* live exceptional-state class in running logic (for example force + maintenance bypass/test mode + change/baseline status) and explicitly gates automatic production or return-to-service. If authoritative public evidence does not expose such an implementation, treat that as a source-availability limit and rotate rather than inventing a universal manifest API.

No simulation or executable compute was needed for this source/documentation result.
