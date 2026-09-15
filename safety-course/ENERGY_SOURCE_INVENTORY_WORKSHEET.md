# Energy-Source Inventory and Verification Worksheet

Date: 2026-09-15
Status: curriculum worksheet; machine-agnostic

## Purpose

Use this worksheet to teach the difference between an ordinary machine stop and a verified maintenance energy-isolation state. It is not a machine-specific procedure until populated from actual machine documentation, inspection, measurement, and the site's authorized energy-control procedure.

Evidence labels: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`. UNKNOWN never counts as safe.

## Source basis

OSHA 29 CFR 1910.147 requires hazardous-energy procedures to address shutdown, physical isolation, stored/residual-energy control, and verification. Potentially hazardous stored energy must be relieved, disconnected, restrained, or otherwise rendered safe; possible reaccumulation requires continued verification. Verification is an affirmative step before servicing begins.

Primary source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

OSHA interpretation and guidance also make clear that verification may require an appropriate combination of isolator walkdown, visual checks, deliberate try/start verification, or test instruments depending on the energy and task; a status indicator alone does not establish effective isolation.

Sources:
- https://www.osha.gov/laws-regs/standardinterpretations/2000-11-16
- https://www.osha.gov/laws-regs/standardinterpretations/2012-12-12
- https://www.osha.gov/enforcement/directives/std-01-05-019

## A. Scope

| Field | Entry |
|---|---|
| Machine/subsystem | |
| Service task | |
| Physical work zone | |
| Drawing/manual/procedure revision | |
| Components that may move or release energy | |
| Adjacent/shared systems that can feed this boundary | |

Different tasks may require different isolation boundaries.

## B. Energy inventory

Create one row for every credible source. Do not combine unlike sources just because one device appears to affect both.

| ID | Energy type | Source/origin | Hazard mechanism | Physical isolating device | Stored/residual mechanism | Dissipation/restraint method | Reaccumulation possible? | Verification method | Evidence | State |
|---|---|---|---|---|---|---|---|---|---|---|
| E01 | electrical | | | | capacitor/DC bus/backfeed? | | | | UNKNOWN | UNKNOWN |
| E02 | hydraulic | | | | trapped pressure/accumulator? | | | | UNKNOWN | UNKNOWN |
| E03 | gravity/mechanical | | | | elevated member/spring/tooling? | | | | UNKNOWN | UNKNOWN |
| E04 | pneumatic | | | | trapped pressure? | | | | UNKNOWN | UNKNOWN |
| E05 | thermal | | | | retained heat/pressure? | | | | UNKNOWN | UNKNOWN |
| E06 | other | | | | | | | | UNKNOWN | UNKNOWN |

Add rows until complete.

Use explicit states: source = CONNECTED / ISOLATED / UNKNOWN; stored energy = HAZARDOUS / RENDERED_SAFE_OR_RESTRAINED / UNKNOWN; verification = NOT_VERIFIED / VERIFIED / INVALID_OR_EXPIRED / UNKNOWN.

## C. Walkdown questions

For every source confirm and record evidence for:

1. Correct physical isolating device identified.
2. Device state directly confirmed.
3. Required securing/restraint applied under the procedure.
4. Alternate, shared, feedback, gravity, accumulator, regenerative, or backfeed paths considered.
5. Stored/residual energy rendered safe or physically restrained.
6. Verification method appropriate to energy type and task.
7. Verification actually performed rather than inferred from HMI/PLC/FPGA indication.
8. If reaccumulation is credible, monitoring/reverification is defined.

A LinuxCNC ESTOP indication, safety relay status, FPGA watchdog, zero output command, stopped motor, pump-off command, HMI lamp, or software variable is not by itself evidence of physical hazardous-energy isolation.

## D. Maintenance-isolation gate

The curriculum model may assert `MAINTENANCE_ISOLATION_VERIFIED` only when the task/boundary is defined, every credible source is identified, required physical isolation is established, hazardous stored energy is controlled, required verification has been affirmatively completed, no required state remains UNKNOWN, and credible reaccumulation is being handled by the procedure.

Fail closed on false, unknown, stale, bypassed, or contradictory evidence.

## E. Reaccumulation record

| Energy ID | Reaccumulation mechanism | Observable state | Monitoring/reverification method | Event invalidating verified state | Evidence |
|---|---|---|---|---|---|
| | | | | | |

The teaching simulator should invalidate maintenance permission when the modeled condition becomes hazardous or required monitoring evidence becomes stale.

## F. Return-to-service handoff

Record that the work area/personnel checks required by the applicable procedure are complete, the energy-control devices/restraints are handled under that procedure, and normal controller commands are neutral. Restoration of energy must not replay stale actuator commands. Safety restoration, ordinary controller rearm, and deliberate production start remain separate concepts.

## G. Safety Sandbox tests

- **ESW-01 Missing source:** omit a modeled energy source; isolation declaration fails.
- **ESW-02 Software-only claim:** software says isolated while physical-isolator model is connected; declaration fails.
- **ESW-03 Stored energy omitted:** source isolated but stored energy remains hazardous; declaration fails.
- **ESW-04 Unknown evidence:** favorable state but verification/evidence unknown; declaration fails.
- **ESW-05 Indicator-only verification:** status lamp alone cannot substitute for required affirmative verification.
- **ESW-06 Reaccumulation:** verified state is invalidated if modeled hazardous energy returns or required monitoring becomes stale.
- **ESW-07 Alternate feed:** a shared/backfeed source keeps the declaration false until identified and controlled.
- **ESW-08 Restoration does not start:** restoring energy leaves commands neutral until separate restoration/rearm/start requirements are met.
- **ESW-09 Task boundary change:** changing the service task can invalidate the prior inventory and require reevaluation.

## H. OpenPressBrake mapping rule

Populate machine-specific entries only from actual OpenPressBrake/ERMAK drawings, manuals, component documentation, inspection, and measurements. Do not assume accumulator presence, bleed paths, safe pressure thresholds, ram restraint methods, drive discharge times, or lockable isolation points.

## Next independent work

Study maintenance bypass/temporary override lifecycle architecture: explicit authorization, visible state, bounded scope, restoration proof, auditability, and failure cases where a bypass remains active. Keep safety-rated implementation requirements machine/design-specific and do not make ordinary LinuxCNC/FPGA software the personnel-safety authority.