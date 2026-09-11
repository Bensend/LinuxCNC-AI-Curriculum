# Press-brake layered interface contract — machine-agnostic draft

Date: 2026-09-11

Status: **DRAFT RESEARCH CONTRACT / NOT A MACHINE IMPLEMENTATION**

Purpose: turn the source/community architecture findings into a bounded interface vocabulary for the 4600 track. This deliberately specifies ownership and evidence signals before choosing machine-specific valve sequences, gains, currents, pressures, or safety architecture.

## Design objective

Keep four ordinary-control responsibilities separable and observable:

1. press-cycle sequencing;
2. LinuxCNC geometric/joint motion ownership;
3. Y1/Y2 synchronization/final ordinary actuator allocation;
4. machine-specific hydraulic-mode decoding.

Functional safety remains external to this ordinary-control contract. Safety-system state may be observed as permission/status, but this document does not make LinuxCNC the safety function.

## Layer A — press-cycle coordinator

### Owns

- operator mode and ordinary cycle phase;
- bend-program step index;
- requested bend target / return target;
- requested motion class (`approach`, `bend`, `dwell`, `decompress`, `return`, etc.) at a semantic level;
- ordinary pressure/tonnage intent at a semantic/setpoint level where appropriate;
- deciding when a phase is complete based on explicitly named observations.

### Must not silently own

- raw per-side servo output;
- Y1/Y2 differential correction;
- low-level spool combination for an unknown machine;
- functional-safety validation.

### Commands out

| Signal concept | Type | Meaning |
|---|---|---|
| `cycle_enable_req` | bool | Ordinary request to execute the current press cycle. |
| `y_target` | float | Desired common geometric ram/beam target in configured units. |
| `y_velocity_class` or bounded velocity request | enum/float | Ordinary trajectory intent; exact representation depends on motion architecture. |
| `motion_mode_req` | enum | Semantic hydraulic/motion phase such as approach/bend/decompress/return. |
| `pressure_or_tonnage_req` | float | Requested ordinary process setpoint; no claim about physical safety limit. |
| `hold_req` | bool | Ordinary pause/hold request. |

### Observations in

- motion in-position / trajectory complete;
- Y1/Y2 synchronization validity;
- hydraulic mode ready/valid;
- ordinary drive/feedback fault aggregate;
- pressure/tonnage feedback if the machine exposes it;
- safety-system permissive/status as an external fact, never synthesized here.

## Layer B — LinuxCNC motion/joint owner

Candidate duplicated-Y topology for investigation:

```text
trivkins ...YY... kinstype=BOTH
```

### Owns

- common nominal trajectory generation;
- nominal per-joint commands produced by inverse kinematics;
- ordinary per-joint motion feedback/following-error supervision when those sides remain ordinary kinematic joints;
- homing/mode semantics assigned to motmod.

### Commands out

- nominal Y1 joint command `r1`;
- nominal Y2 joint command `r2`;
- enable state / other existing joint controls.

### Observations out

- Y1 and Y2 `motor-pos-fb` / derived joint feedback;
- Y1 and Y2 following error and effective limit;
- motion enabled/error state;
- common Cartesian Y as convenience only.

### Critical invariant

Do not use Cartesian Y as proof of Y1/Y2 agreement. At the pinned `trivkins` implementation, inverse kinematics fans common Y to all Y-mapped joints but forward Cartesian Y comes from the principal/first Y joint.

## Layer C — Y1/Y2 synchronization and final ordinary actuator allocation

Exact insertion point remains the subject of PB-PREP-001 A/B/C; this contract fixes required information regardless of the eventual ordinary-control structure.

### Required inputs

- nominal `r1`, `r2`;
- independent measured `y1`, `y2`;
- ordinary motion/servo enable;
- side-specific drive/actuator availability if exposed;
- final ordinary command limits.

### Required observations

```text
y_common = (y1+y2)/2
e_diff   = y1-y2
```

Retain separately:

- differential correction requested;
- correction applied after authority limiting;
- pre-limit side command;
- final side command;
- final-side saturation/authority-exhaustion witness;
- stock PID saturation separately if stock PID sits upstream;
- per-side motion ferror separately if motmod owns the joint.

### Must not claim from alignment alone

Small `abs(y1-y2)` does not prove correct common position. Both sides can agree while both are wrong relative to the trajectory. Common tracking and differential tracking require separate witnesses.

## Layer D — machine-specific hydraulic-mode decoder

This layer exists because public press-brake retrofits repeatedly show that proportional/servo-valve command and discrete hydraulic routing are different problems.

### Inputs

- semantic `motion_mode_req` from press-cycle layer;
- requested direction / sign derived from an authoritative command source;
- ordinary pressure/tonnage request;
- ordinary servo/final side commands where this machine architecture requires them;
- machine-specific hydraulic sensor/status inputs;
- external safety permissive/status.

### Outputs

Machine-specific only, potentially including:

- discrete spool/route valve commands;
- proportional relief/pressure command;
- servo/proportional valve enable;
- side-specific electrical commands if not owned by a separate drive interface;
- hydraulic-mode-valid / ready / fault status.

### Required contract property

Every supported semantic mode must map to an explicitly documented set of outputs and prerequisites. Unknown/unsupported mode must fail closed at the ordinary-control boundary rather than guessing a valve combination.

This document deliberately does **not** supply generic valve truth tables. Public reports show different machines use materially different hydraulic circuits.

## Layer E — electrical/drive interface

This may be a Mesa analog/PWM/current interface, an existing valve amplifier, servo drive, EtherCAT device, or another hardware boundary.

The contract must state whether LinuxCNC is commanding:

- valve spool position;
- amplifier current/force request;
- velocity;
- pressure;
- another nested controller's setpoint.

If an existing valve amplifier closes a local LVDT/spool loop, preserve that as a nested control boundary rather than pretending the LinuxCNC command directly controls hydraulic flow.

## Layer F — external safety system boundary

### Examples of information LinuxCNC may observe

- safety permissive / safety relay healthy;
- guard/light-curtain status intended for ordinary diagnostics;
- E-stop status;
- safety-valve feedback where exposed for diagnostics.

### Explicit non-claim

An ordinary HAL component, PID, state machine, watchdog or UI interlock is not thereby a functional-safety function. Required safety architecture must be established independently for the physical machine and applicable standards/hazards.

## Ownership matrix

| Responsibility | Press-cycle | Motmod/joints | Sync/final allocation | Hydraulic decoder | External safety |
|---|---:|---:|---:|---:|---:|
| Program/cycle phase | **Own** | observe | observe | observe | — |
| Common geometric trajectory | request | **Own** candidate | observe | observe | — |
| Independent Y1/Y2 feedback truth | observe | **Own/retain** candidate | **consume** | optional observe | independent where required |
| Differential correction | no | no automatic cross-coupling | **Own** | no | — |
| Final ordinary side command limiting | no | stock PID may have internal limit | **Own/explicit witness** | downstream only if machine requires | — |
| Spool/route valve truth table | no | no | no | **Own** | safety valves may be separate |
| Pressure/tonnage process request | **Own semantic request** | no | no | translate to hardware | independent safety limits where required |
| Homing geometric semantics | coordinate/request | **Own if motmod topology** | cooperate/observe | must support resulting direction/mode | safety permissive independent |
| Functional safety | no | no | no | no | **Own outside ordinary control** |

## Admission gates between layers

A command should cross a boundary only with explicit validity rather than implicit hope.

### Cycle -> motion

Require at minimum ordinary cycle enable, valid target, supported mode, no ordinary motion fault, and external safety permissive status if used as an ordinary prerequisite.

### Motion/sync -> hydraulic decoder

Require:

- command direction/mode coherent;
- sync controller state valid;
- final side commands bounded;
- requested hydraulic semantic mode supported by this decoder;
- any machine-specific prerequisite sensors in expected state.

### Hydraulic decoder -> outputs

Require an explicit mode truth table and known safe ordinary inactive state. Detect impossible/conflicting sensor or output requests rather than selecting the “closest” mode.

These are ordinary-control engineering requirements, not a certification argument.

## Failure-observation matrix

| Failure | Witness required | Ordinary reaction concept | What must not be inferred |
|---|---|---|---|
| Y1/Y2 divergence | direct `e_diff`, independent feedback | withdraw/limit ordinary motion authority per validated design | Cartesian Y alone is insufficient |
| both Y sides track each other but miss target | common error + per-joint ferror | motion/servo fault handling | small `e_diff` does not mean position correct |
| differential authority exhausted | applied-vs-requested correction + final saturation | explicit fault/degraded state | stock PID saturation alone may miss downstream clipping |
| frozen/plausible feedback | freshness/independent validity mechanism | fault/authority withdrawal | numerical plausibility is not freshness |
| unsupported hydraulic mode | decoder validity | inhibit ordinary hydraulic output | never synthesize an undocumented valve combination |
| contradictory spool/sensor state | machine-specific state validation | inhibit/fault | do not treat as a tuning problem |
| external safety permissive lost | external status | ordinary commands inactive; safety system acts independently | software response does not prove safety performance |

## Relationship to PB-PREP-001

PB-PREP-001 only asks where ordinary Y1/Y2 differential correction should enter relative to motion/PID/final command limiting in a synthetic software plant. It does not model or choose the hydraulic decoder above. This separation prevents a generic control-structure experiment from being mistaken for validation of a real press hydraulic circuit.

## Next verification work

1. Audit 077 raw traces against the frozen A/B/C contract when the already-running job completes.
2. Locate a public downloadable press-brake HAL/COMP/config and map every signal to this ownership matrix; revise the matrix only when source/config evidence requires it.
3. Create one adversarial architecture exercise where a monolithic component receives conflicting homing direction and press-state mode, and require the learner to identify the ownership error without needing a hydraulic simulation.
4. Keep machine-specific valve states, coil currents, pressure limits and safety circuits out of the generic contract unless authoritative public evidence supports them.
