# Safety Reintegration / Return-to-Service State Table

Purpose: reusable learner worksheet for separating communication recovery, device reintegration, physical evidence, safety reset/rearm, and ordinary production demand.

This table is a reasoning aid, not a universal machine state machine. Device- and machine-specific transitions must be established from the actual safety design and manufacturer documentation. Unknown requirements remain `UNKNOWN`.

| Stage | What may now be true | Evidence required | What this stage does **not** prove | Typical blocker that remains |
|---|---|---|---|---|
| 0 — SAFE/FAULTED | Safety function has reacted to connection/device/power fault | fault/connection diagnostics or safe-state reaction evidence | fault cause known; field state known; physical hazard safe beyond defined reaction | `FIND-*`, unavailable witness, fault cause |
| 1 — TRANSPORT HEALTHY | Physical/network transport can exchange traffic | link/network/device communication evidence | safety protocol valid; safety data fresh; field device healthy | protocol/connection fault |
| 2 — SAFETY CONNECTION VALID | Safety producer/consumer connection is valid according to the safety protocol/device | device-specific connection status | device fault cleared; reintegration complete; machine proposition fresh | passivation/device diagnostic |
| 3 — DEVICE DIAGNOSTICS VALID | documented fault cause is absent/cleared | channel/module diagnostics and required field conditions | channel is reintegrated where acknowledgement is required; physical installation unchanged | reintegration request/acknowledgement |
| 4 — REINTEGRATION ELIGIBLE | device/channel meets documented prerequisites for reintegration | device-specific eligibility/request indication or documented automatic condition | acknowledgement occurred; machine acceptance complete | required manual acknowledgement |
| 5 — REINTEGRATED | safety device/channel is again supplying/accepting normal safety process data | device-specific reintegration state | guard geometry valid after impact; personnel clear; final element/process physically safe; stale `PROP-*` revalidated | stale/unknown physical propositions, open findings |
| 6 — PHYSICAL PROPOSITIONS FRESH | each required machine-level proposition has current applicable evidence | `PROP-*` acceptance criteria satisfied by named `EVID-*`; required `VAL-*` complete | reset/rearm performed; production start requested | open `FIND-*`, reset conditions |
| 7 — RESET/REARM ELIGIBLE | safety architecture permits deliberate reset/rearm | all required safety conditions and reset prerequisites satisfied | reset action occurred; production start authority exists | deliberate reset/rearm action |
| 8 — REARMED | safety function is armed/ready according to its design | accepted reset/rearm evidence | hazardous motion may start automatically; old held demand is fresh | fresh ordinary production demand |
| 9 — FRESH ORDINARY DEMAND REQUIRED | safety side is ready to accept normal control authority | demand-freshness contract | that a pre-fault held Cycle Start is valid | release/reassertion or other defined fresh demand |
| 10 — NORMAL OPERATION ELIGIBLE | both safety permission and fresh ordinary control demand are present | machine-specific final permission logic and all required evidence | future safety remains guaranteed without continued diagnostics/proof obligations | ongoing monitoring/proof obligations |

## Transition discipline

For every transition, record:

- previous stage and proposed next stage;
- exact evidence gained;
- `DEP-*` source of that evidence;
- affected `EVID-*` and `PROP-*` records;
- whether any `FIND-*` or `VAL-*` remains open;
- whether the transition makes evidence **available**, **fresh**, or both;
- whether a deliberate acknowledgement/reset is required;
- whether any ordinary demand predates the fault/recovery boundary and must be discarded.

## Availability versus freshness

A recovered connection can make an evidence source **available** without making every proposition it once supported **fresh**.

Example: a guard-switch OSSD becomes readable again after a network outage. The input-state evidence is available. If nothing occurred that challenges the validated installation and the evidence contract permits current state to re-establish the guard proposition, that proposition may become fresh from the new observation. If the outage coincided with a door impact, bracket work, actuator replacement, bypass, or other event that challenges installation validity, current OSSD state alone does not refresh the installation/geometry proposition; inspection or revalidation may be required.

Therefore classify separately:

- `UNAVAILABLE` — required evidence source cannot currently be observed;
- `AVAILABLE-NOT-YET-ACCEPTED` — source is observable but acceptance criteria/reintegration are incomplete;
- `FRESH` — evidence is current and applicable to the proposition under its contract;
- `STALE` — prior evidence no longer represents the accepted physical/configuration state;
- `UNKNOWN` — applicability/freshness cannot be established.

## Hard rules

- **AVAILABLE != FRESH.**
- **CONNECTION VALID != REINTEGRATED.**
- **REINTEGRATED != PHYSICAL VALIDATION COMPLETE.**
- **PHYSICAL VALIDATION COMPLETE != RESET/REARM ACTION.**
- **RESET/REARM COMPLETE != FRESH PRODUCTION DEMAND.**
- **A TRANSITION MAY REMOVE ONLY BLOCKERS SATISFIED BY THE EVIDENCE IT ACTUALLY ADDS.**

## Human-factors rendering

A production HMI should not expose all internal stages as engineering jargon. It should expose actionable truth such as `SAFETY NETWORK FAULT`, `DEVICE FAULT — REPAIR REQUIRED`, `SAFETY ACKNOWLEDGEMENT REQUIRED`, `PHYSICAL INSPECTION/VALIDATION REQUIRED`, `SAFETY RESET REQUIRED`, and `READY — NEW CYCLE START REQUIRED`. Keep ordinary HMI state subordinate to the independent safety authority.
