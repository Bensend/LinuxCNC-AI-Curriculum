# 25E0 — Safety-Function Validation Record and Acceptance Matrix

Date: 2026-09-21
Status: reusable curriculum template; not a machine approval record

## Purpose

Use this record to prevent a validation campaign from collapsing unlike evidence into a single `SAFE=true` conclusion. One completed record covers one named safety function and one defined machine/configuration baseline. Unknown design facts remain `UNKNOWN` and block only the acceptance claim that depends on them.

This template operationalizes `25E0_HETEROGENEOUS_WITNESS_COMMISSIONING_AND_VALIDATION_METHOD_2026-09-21.md`.

## A. Function identity and scope

| Field | Required entry |
|---|---|
| Safety-function ID / revision | Stable identifier and revision |
| Hazard controlled | Physical hazard, not merely signal name |
| Machine / zone / axis | Exact scope |
| Operating modes covered | Production, setup, maintenance, etc. |
| Initiating event/device | Guard, E-stop, light curtain, mode transition, etc. |
| Required physical safe state | What must become physically true |
| Safety authority | Safety relay/PLC/drive/other safety-related subsystem |
| Ordinary-control boundary | What LinuxCNC/normal FPGA may request, monitor or inhibit but does not safety-authorize |
| Applicable source baseline | Drawings, safety requirements, manuals, standards, revisions |
| Known exclusions / UNKNOWNs | Explicit unresolved facts |

## B. Authority and energy chain

Trace every hazardous-energy path separately.

| Stage | Device/function | Required transition | Evidence/witness | Evidence class | What it does NOT prove |
|---|---|---|---|---|---|
| Protective input |  |  |  |  |  |
| Safety logic |  |  |  |  |  |
| Final element 1 |  |  |  |  |  |
| Final element 2 / redundancy |  |  |  |  |  |
| Stored-energy control |  |  |  |  |  |
| Retaining element |  |  |  |  |  |
| Process response |  |  |  |  |  |
| Reset/rearm |  |  |  |  |  |
| Ordinary start/jog/cycle |  |  |  |  |  |

Allowed evidence labels: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

## C. Proposition-to-witness acceptance matrix

Each row states one physical proposition. Do not combine propositions simply because one sensor usually correlates with both.

| Proposition that must be true | Witness and physical location | Witness type | Acceptance criterion + authority | Continuity of evidence | Independence/common-cause analysis | Result |
|---|---|---|---|---|---|---|
|  |  | final-element / pressure / motion / retaining proof / other |  | continuous / transition / proof-test / diagnostic |  | PASS / FAIL / UNKNOWN |

A PASS is valid only when the criterion has a named design/source authority and the test actually challenges the proposition. `UNKNOWN` is preferable to a borrowed threshold.

## D. Timing chain

Record separate endpoints where timing matters:

`protective event -> safety detection -> safety output transition -> final-element physical transition -> process response -> process witness -> acceptance/fault decision`

| Endpoint pair | Required limit/source | Measurement point and instrument | Measurement uncertainty | Observed worst case | Result |
|---|---|---|---|---|---|
|  |  |  |  |  | PASS / FAIL / UNKNOWN |

Do not substitute controller task time for physical stopping time.

## E. Fault-injection matrix

Only perform energized tests under a machine-specific controlled commissioning plan. Otherwise isolate energy, simulate, or test remotely with personnel outside the danger zone.

| Fault/disagreement | Safe test method | Expected detection | Expected authority removal/retention | Latch/self-clear expectation | Required recovery evidence | Actual result |
|---|---|---|---|---|---|---|
| input channel disagreement |  |  |  |  |  |  |
| final-element command/feedback mismatch |  |  |  |  |  |  |
| process witness disagrees with final-element status |  |  |  |  |  |  |
| witness supply/wiring loss |  |  |  |  |  |  |
| communications loss where applicable |  |  |  |  |  |  |
| stale ordinary demand during safety interruption |  |  |  |  |  |  |
| common-cause candidate |  |  |  |  |  |  |

## F. Reset, rearm and demand-freshness history

Test history, not only steady-state Boolean values.

| History | Expected behavior/source | Actual behavior | Result |
|---|---|---|---|
| protective condition restored; no reset |  |  |  |
| reset held before evidence becomes valid |  |  |  |
| fresh reset after evidence becomes valid |  |  |  |
| Start/Jog/Cycle held throughout interruption |  |  |  |
| demand released then freshly reasserted |  |  |  |
| mode changes while demand already true |  |  |  |
| power cycle with maintenance/bypass state present |  |  |  |

Classify every ordinary demand: `edge`, `level`, `latched`, `queued`, `cancelled`, `tracked`, `regenerated`, or `UNKNOWN`.

## G. Temporary commissioning-state inventory

| Temporary state | Owner/purpose | Physical or configuration state | Production prohibition mechanism | Removal proof | Re-test after removal |
|---|---|---|---|---|---|
| force/simulated I/O |  |  |  |  |  |
| jumper/bypass |  |  |  |  |  |
| maintenance/setup mode |  |  |  |  |  |
| temporary guard/test aid |  |  |  |  |  |
| relaxed parameter/limit |  |  |  |  |  |
| temporary wiring/debug configuration |  |  |  |  |  |

A production configuration checksum cannot prove a physical jumper or temporary guard has been removed.

## H. Human-factors defeat-resistance check

Record whether normal guard/interlock/reset/reinstall behavior is easier than bypassing it. Include visibility of abnormal states, physical key/jumper control, access to bypass points, nuisance-trip causes, reset location/visibility, and whether maintenance can accidentally leave the machine in a permissive commissioning state. A safeguard that predictably encourages defeat is a design problem to correct, not merely a training issue.

## I. Modification-impact / revalidation matrix

| Change | Which propositions may become invalid | Minimum revalidation scope | Evidence retained | Evidence invalidated |
|---|---|---|---|---|
| sensor/witness replacement |  |  |  |  |
| final-element replacement |  |  |  |  |
| brake/load/transmission change |  |  |  |  |
| hydraulic/pneumatic circuit change |  |  |  |  |
| safeguard geometry change |  |  |  |  |
| safety logic/configuration/firmware change |  |  |  |  |
| ordinary-control change affecting demand history |  |  |  |  |

## J. Acceptance decision

The record closes only when each required proposition is PASS with traceable authority, required timing is PASS, required fault/recovery histories are PASS, temporary commissioning states are removed/controlled, and no safety-critical `UNKNOWN` remains.

If the minimum safe-to-operate threshold cannot be established, the machine is **not accepted for operation with personnel exposed to the hazard**. Experimental operation, if justified, must remain isolated/remote with personnel outside the danger zone and residual risk recorded.

## Curriculum freezes

- `RECORD COMPLETE != MACHINE SAFE` unless every required physical proposition has valid acceptance evidence.
- `PASSING LOGIC TEST != PASSING PHYSICAL SAFETY FUNCTION`.
- `FINAL-ELEMENT STATUS != PROCESS RESULT`.
- `ZERO MOTION != RETAINING CAPABILITY`.
- `RESET/REARM != FRESH ORDINARY DEMAND`.
- `UNCHANGED SOFTWARE != UNCHANGED PHYSICAL VALIDATION BASELINE`.
- `UNKNOWN != FAIL`, but a safety-critical UNKNOWN blocks the acceptance claim that depends on it.

## Source basis

- Rockwell FactoryTalk safety commissioning/validation guidance: active field-device validation and wiring/network fault reaction testing.
- Rockwell AADvance Safety Manual: system-specific commissioning, abnormal-fault validation, records, and removal of temporary commissioning measures before service.
- Pilz validation guidance: planned validation across operating/environmental conditions and fault assumptions.
- Rockwell ArmorKinetix Safe Monitor Functions Safety Reference Manual, Appendix B: function-specific validation checklists for safe-motion functions, including normal and abnormal operation.

This curriculum template is methodology, not a substitute for the applicable controlled standards, machine risk assessment, safety requirements specification, OEM component instructions, or qualified physical commissioning.