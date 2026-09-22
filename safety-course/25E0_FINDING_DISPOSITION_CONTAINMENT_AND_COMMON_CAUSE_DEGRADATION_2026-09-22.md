# 25E0 — Finding Disposition, Containment, and Common-Cause Degradation

Date: 2026-09-22
Status: learner-facing safety-course method

## Learning objective

Turn an adverse inspection/proof result into controlled safety engineering rather than a repeated test, an alarm acknowledgement, or a maintenance ticket that silently leaves dependent safety evidence accepted.

The required chain is:

`finding -> immediate disposition/containment -> affected propositions -> dependency/show-where-used trace -> cause/corrective action -> physical re-proof -> acceptance/closure -> reset/rearm -> fresh ordinary demand`

A finding is evidence. It is not itself the repair, root cause, acceptance decision, or proof of restored safety.

## Evidence basis

### SICK stop-time measurement — DOC-CONFIRMED

SICK describes stop-time measurement as a lifecycle check of whether hazardous motion stops before the hazard can be reached. It specifically identifies changes such as brake wear as detectable by repeated measurement and says corresponding measures can then be initiated. The measurement is used to establish/check the required safety distance and produces a measurement report for machine documentation.

Engineering consequence: a degraded stop result is not merely a request to rerun the instrument. It contradicts the physical stopping baseline on which one or more safeguarding propositions may depend.

Source: SICK, `Nachlaufmessung - Wartung und Inspektion`, accessed 2026-09-22.

### Pilz safeguard inspection and validation — DOC-CONFIRMED

Pilz describes safeguard inspection as checking current condition, correct installation, safe function, integration, and overrun/safety distance. It also states that upgrades, manipulation, or changed work processes can undermine protection and that inspection produces a detailed report. Pilz validation separately treats validation as demonstration that risk-reduction measures are correctly implemented and offers different validation depth for re-inspection, minor changes, and complex installations.

Engineering consequence: inspection, corrective work, and validation are distinct lifecycle activities. A failed inspection finding should be dispositioned, not transformed into `PASS` merely because the observed component was repaired.

Sources: Pilz, `Inspection of safeguards`; Pilz, `Safety validation for machinery safety`, accessed 2026-09-22.

### Rockwell safety diagnostics boundary — DOC-CONFIRMED

Rockwell's Logix SIS safety reference states that status indicators provide only general diagnostics and must not be used to determine operational status. Rockwell also assigns the system user responsibility for validation of connected safety sensors/actuators and functional testing.

Engineering consequence: controller diagnostics can be useful evidence about controller/device state, but cannot close a physical-machine finding whose proposition requires field or process proof.

Sources: Rockwell Automation, `Monitor Safety Status and Handle Faults`; `ControlLogix 5590 Functional Safety`, accessed 2026-09-22.

## Finding record contract

Create a stable `FIND-*` record whenever inspection, proof testing, commissioning, troubleshooting, observation, or incident evidence contradicts or materially weakens an accepted proposition.

Minimum fields:

| Field | Meaning |
|---|---|
| `FIND-ID` | stable identity; never recycle |
| observed UTC/time/use state | when and under what operating state evidence was obtained |
| observation | what was actually observed, without embedding the diagnosis |
| evidence identity | measurement/report/photo/log/test identity and calibration/version context where relevant |
| acceptance criterion | the criterion the observation is compared with; `UNKNOWN` if not established |
| result | `PASS`, `FAIL`, `INDETERMINATE`, or `UNKNOWN` |
| immediate hazard implication | what accepted proposition may no longer be relied upon |
| containment/disposition | what operation is prohibited, restricted, isolated, or otherwise controlled pending resolution |
| affected dependencies | `DEP-*` records implicated by the finding |
| affected propositions/functions | reverse show-where-used result, not an assumed one-to-one mapping |
| suspected cause | hypothesis only; preserve as `INFERENCE` until proved |
| corrective action | what was actually changed/repaired/cleaned/adjusted |
| re-proof obligation | physical/configuration/function evidence required after correction |
| acceptance authority | who/what is permitted to close the finding under the machine's process |
| closure evidence | `VAL-*`/`EVID-*` identities demonstrating the affected proposition again |
| residual/open uncertainty | anything not established |

Do not overwrite the original failed observation after repair. Closure adds evidence; it does not rewrite history.

## State model

Recommended finding states:

`OPEN -> CONTAINED -> CORRECTIVE_ACTION_IN_PROGRESS -> READY_FOR_REPROOF -> REPROOF_COMPLETE -> ACCEPTED_CLOSED`

Alternate terminal states may include `REJECTED/REDESIGN_REQUIRED` or `DECOMMISSIONED`.

`REPAIR COMPLETE` is intentionally not a closure state.

If a safety-critical acceptance criterion is unknown, the finding cannot be closed by assumption. The dependent production operation remains unavailable until authoritative design evidence, measurement, or redesign establishes a defensible criterion.

## Containment before root cause

A failed safety proposition can require immediate operational containment before the root cause is known. Containment is proposition-specific.

Examples:

- A failed stop-time result can invalidate personnel access/separation assumptions that depend on that stopping result. Do not continue exposed production merely because the cause might be brake wear.
- A guard-position witness that behaves intermittently invalidates reliance on that witness even before the cable, actuator, switch, input channel, or logic cause is isolated.
- A gravity-axis holding test that fails invalidates the demonstrated holding proposition; ordinary controller status does not substitute for it.

Experimental operation before restoration is acceptable only when the machine-specific safety plan isolates/remotely controls the experiment with people outside the danger zone and states residual risk explicitly.

## Common-cause degradation stress test

### Scenario

A machine has two safety functions that appear logically independent:

1. `SF-A`: an electro-sensitive protective device commands a stop; its protective distance depends on accepted total machine stopping performance.
2. `SF-B`: a locked access guard is released only after a machine-specific condition demonstrates that hazardous motion/energy is safe for access.

Both functions have separate safety inputs and separate safety logic paths. However, their physical outcome can share a brake, drive, mechanical transmission, supply condition, contamination/temperature environment, or another machine-specific physical dependency.

A periodic measurement discovers degraded stopping performance. No maintenance change is recorded. Controller diagnostics remain green.

### Required reasoning

1. Create `FIND-STOP-*` from the measurement. The finding exists even before a repair work order.
2. Mark the old stopping-performance evidence non-current/failed for every proposition that actually depends on it.
3. Reverse-trace the implicated `DEP-*` physical dependency.
4. `SF-A` is affected if its protective-distance proposition uses that stopping result.
5. Do **not** mechanically declare `SF-B` failed. Determine its actual access-release proposition:
   - if release is based on a delay derived from expected stopping behavior, the degradation can invalidate it;
   - if release uses a genuinely independent, validated stopped-motion/energy witness, its dependency may differ;
   - if that independence is not established, classify it `UNKNOWN`, not safe by assumption.
6. Investigate the common physical/environmental cause. A single cause can cross safety-function boundaries even when safety PLC logic and sensors are separate.
7. Correct the cause, then re-prove each affected proposition with the evidence its own dependency requires.
8. Only after acceptance/closure may reset/rearm and a fresh ordinary production demand be considered.

### Adversarial variant

Suppose the brake is replaced and `SF-A` stop time passes. That does not automatically close an `SF-B` proposition involving a separate stopped-motion witness, guard locking force, hydraulic retained energy, or another physical mechanism. Conversely, a healthy stopped-motion witness does not prove protective distance adequate.

The lesson is dependency composition, not maximal retesting.

## Human-factors rule

The finding process must be easier than hiding a defect. Provide a short record path, visible containment state, clear owner/next action, and a direct route to attach re-proof evidence. A process that requires excessive paperwork merely to report a failed measurement creates an incentive to repeat the test until a convenient result appears or to omit the finding.

Never reward `test until pass`. Repeated measurements are legitimate only when their purpose is declared—for example, checking instrument/setup error or characterizing variability—and the original adverse result remains preserved and dispositioned.

## Frozen distinctions

- **FINDING RECORDED != ROOT CAUSE KNOWN.**
- **ROOT CAUSE SUSPECTED != CORRECTIVE ACTION VALIDATED.**
- **REPAIR COMPLETE != SAFETY PROPOSITION RESTORED.**
- **REPEATED TEST PASSES != ORIGINAL ADVERSE RESULT DISPOSITIONED.**
- **GREEN CONTROLLER DIAGNOSTICS != PHYSICAL MACHINE SAFE.**
- **LOGICALLY INDEPENDENT SAFETY FUNCTIONS != PHYSICALLY INDEPENDENT SAFETY FUNCTIONS.**
- **COMMON PHYSICAL DEPENDENCY != IDENTICAL REVALIDATION OBLIGATION.**
- **FINDING CLOSED != RESET/REARM != FRESH ORDINARY START DEMAND.**

## Boundary / UNKNOWN

This method deliberately does not assign a universal stop-time limit, safety distance, brake wear percentage, proof interval, PL/SIL, hydraulic pressure, access-delay value, diagnostic coverage, or acceptable degradation percentage. Those are machine/design-specific and require authoritative design evidence or physical validation.

## Next study

1. Add a compact `FIND-*` / disposition template that interoperates with the accepted-safety-baseline ledger.
2. Trace common-cause physical/environmental degradation beyond brakes—especially contamination, supply loss/degradation, or mechanical coupling—that can cross apparently independent safety channels.
3. Develop escalation rules for repeated findings: when recurrence indicates a design/maintenance/human-factors defect rather than another isolated repair.
4. Keep normal LinuxCNC/FPGA diagnostics as evidence consumers/reporting surfaces; do not transfer personnel-safety acceptance authority into ordinary control software.
