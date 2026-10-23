# 4400 technician exercise — Manual release, uncertain door state and maintenance isolation

**Learner-visible practice, NOT a blind competency test or machine acceptance procedure.** All devices and situations below are hypothetical; do not inject physical faults on a machine with exposed people.

## Scenario

A guarded vertical-load cell uses an exact CTP-L1 family safety switch, an external safety controller, a hydraulic actuator, an accumulator and ordinary LinuxCNC diagnostics. During a power disturbance, the spring-locked guard cannot be opened by the ordinary unlock request. A worker operates the inside escape release. FO1A/FO1B and OL go OFF; OD remains ON on the HMI. The gate is hard to move because the actuator is under mechanical load. The hydraulic valve's position feedback is healthy, a fluid gauge reads zero at one port, and a camera shows slight ram drift. Maintenance wants to enter to clear the obstruction.

## Required learner output

1. For each observation, classify the narrow supported proposition and the broader proposition it cannot establish. State whether OD=ON can be used as evidence that the manual release failed.
2. Allocate `AUTH-*` for ordinary LinuxCNC request/display, safety-related unlock decision, and actual energy-removal/holding/physical guard mechanisms. Do not let one replace another.
3. Identify the manufacturer's escape-release constraints and why an electrically successful release might not provide physical egress.
4. Draw an `ENE/PHY` register for electrical supply, hydraulic pump/pilot/actuator, accumulator gas/fluid volumes and gravity load. Name every still-UNKNOWN valve/tap connection. Do not draw an invented circuit.
5. Separate production access from maintenance entry. List the lockable isolation, personal protection, stored-energy and physical restraint/verification evidence that would be needed before exposed servicing.
6. Trace the fault through `CHG -> SRS/PHY/AUTH/DEP/ARC/VAL/PT/UNK`; identify stale evidence after a replacement or cable reroute.
7. Propose a non-hazardous document/fixture-based preflight and the independent, safely isolated physical validation plan. Do not instruct anyone to test release under a live suspended load or inside an energized hazard zone.
8. Recommend two human-factor improvements that make correct access/escape and guard restoration easier than defeating the guard.

## Instructor review rubric (not a sealed answer key)

- Rejects `OD=ON -> guard definitely closed` during documented manual release; acknowledges OD may be undefined.
- Does not equate FO/OL state with actual gate movement or escape availability.
- Treats mechanical tensile loading and cable routing as potential egress failure paths.
- Separates external guard-unlock safety authority from safety-rated lock monitoring and from normal LinuxCNC.
- Rejects `valve feedback healthy + one zero gauge -> gravity load held and all pressure safe`.
- Requires actual energy-isolating mechanisms, stored-energy control, personal protection and independent verification for applicable servicing.
- Blocks exposed operation pending real physical evidence; proposes remote/isolated validation only.
- Keeps exact product variant, receiver compatibility, reset/rearm, manual restoration and stale-change evidence explicit.

Sources: EUCHNER 2124217-08-06/21 §§3, 6.8, 7.1–7.4, 10.10; EUCHNER 2126290-08-07/24 §§2–3, 6.8; OSHA 1910.147(d)(5)–(6); OSHA interpretation 2012-12-12. See accompanying research for official URLs.
