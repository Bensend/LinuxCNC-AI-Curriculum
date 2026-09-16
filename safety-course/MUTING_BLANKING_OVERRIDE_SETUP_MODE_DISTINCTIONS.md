# Safety Function Distinctions — Muting, Blanking, Override, Setup Mode, and Defeated Safeguard

Status: WORKING SOURCE STUDY — architecture vocabulary and evidence boundaries

Purpose: prevent the curriculum, Safety Sandbox, and future OpenPressBrake design work from collapsing several materially different safety concepts into a generic `BYPASS` bit.

## Core rule

A safeguard being intentionally unavailable does **not** by itself describe why, under whose authority, for how long, for what task, or what compensating protection exists. The design must name the mechanism and its lifecycle.

Never infer equivalence among `muting`, `blanking`, `override`, `setup/service mode`, `temporary removal for testing/positioning`, and a defeated safeguard.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — supported by inspectable source/code or manufacturer implementation documentation.
- **DOC-CONFIRMED** — supported by authoritative manuals/regulatory documentation.
- **TEST-CONFIRMED** — demonstrated by a recorded test of the actual implementation/configuration.
- **COMMUNITY-REPORTED** — reported in a community source but not independently established.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence; must remain bounded.
- **UNKNOWN** — evidence is absent, contradictory, or insufficient for the claim.

## 1. Muting

**SOURCE-CONFIRMED — Rockwell GuardLogix TSSM/TSAM/FSBM documentation:** muting is a temporary **automatic** disabling of a light curtain protective function to permit material transport. The muting sensors and light curtain must follow a specified sequence/timing; invalid sequencing de-energizes the safety output/faults the instruction. The documentation distinguishes material from personnel as the application purpose.

Architecture consequence:

`MUTED` must mean a validated automatic condition has satisfied the muting logic. It must not mean “operator wants the guard ignored.” The enabling conditions, sequence, timeout/fault behavior, and indication belong to the safety-function design and validation.

The ordinary LinuxCNC controller may know that production material transfer is requested, but a normal-control request is not itself proof that the muting safety conditions are satisfied.

## 2. Muting override

**SOURCE-CONFIRMED — Rockwell GuardLogix TSSM/TSAM/FSBM documentation:** override is a separate feature from normal muting. It temporarily energizes the muting output regardless of normal input/fault state so obstructing material can be cleared. Rockwell requires a hold-to-run device with the operator able to see the hazard point and provides a bounded Maximum Override Time (documented instruction range up to 30 s).

**DOC-CONFIRMED — Rockwell SAFETY-AT136 application technique:** its worked conveyor validation explicitly checks override indication, configured timeout, release of override causing the safety relay to trip while the light curtain remains interrupted, and use of override to clear trapped material.

Architecture consequence:

`OVERRIDE_ACTIVE` is not a synonym for `MUTED`. It is a deliberately exceptional, bounded recovery state. Its permission must not silently survive release, timeout, restart, controller reconnect, or a return to normal production.

Do **not** copy Rockwell's example timeout as an OpenPressBrake value. The only source-confirmed conclusion here is that this manufacturer implements a bounded override and constrains its operation; an actual machine's permitted duration and behavior require its own design/validation.

## 3. Blanking

**SOURCE-CONFIRMED — Rockwell 450L product documentation:** the advanced 450L-E light curtain exposes both blanking and integrated muting as separate features.

That separation is enough to freeze one curriculum rule: **blanking is not muting**. This source study does not yet claim the exact permissible blanking geometry, object-resolution effects, or protective-distance consequences because the inspected evidence here does not establish those details.

Required evidence before using blanking in a machine design:

1. exact device/manual definition of fixed/floating blanking behavior;
2. effect on detection capability/resolution;
3. resulting protective-distance and access implications;
4. configuration authority and tamper/change control;
5. indication and validation method.

Until those are traced for the selected device/configuration, they remain **UNKNOWN**.

## 4. Setup/service mode

`SETUP_MODE` is a machine operating mode, not evidence that a safeguard may be ignored.

A setup mode must state, independently:

- which hazards remain possible;
- which safety functions remain authoritative;
- which normal functions are inhibited or restricted;
- what deliberate enabling/hold-to-run controls are required, if any;
- what speed/force/motion limits are actually safety-related versus ordinary control limits;
- how entry, exit, reset, and return to production are proven.

A LinuxCNC mode bit can select normal-control behavior. It cannot manufacture a personnel-safety-rated reduced-speed, limited-force, enabling-device, or safe-stop function. If the architecture lacks independent validated safety authority for a claimed setup protection, mark that claim **UNKNOWN** and do not expose people to the hazard on the strength of the LinuxCNC bit.

## 5. Temporary removal for servicing test/positioning

This remains governed by the separate `MAINTENANCE_BYPASS_TEMPORARY_OVERRIDE_LIFECYCLE.md` contract. Temporary energized testing/positioning during servicing is not production muting and is not a generic setup permission. Its task boundary, isolation/restoration lifecycle, personnel clearing, and return-to-isolation proof must remain explicit.

## 6. Defeated safeguard

A defeated safeguard is not a legitimate operating mode merely because software records it.

Examples include a taped interlock, permanently asserted override, bridged channel, removed guard left off for convenience, or muting sensor arrangement manipulated so personnel can satisfy the material sequence.

Architecture response:

- do not rename defeat as `maintenance`, `setup`, or `mute`;
- preserve unmistakable indication and diagnostic evidence where detectable;
- inhibit normal production where the safety design requires the safeguard;
- correct nuisance/task design that predictably drives defeat;
- require restoration and affected validation before treating the protection as available again.

## State/authority comparison

| State/concept | Typical initiator | Automatic? | Safety function intentionally unavailable? | Recovery intent | Ordinary LinuxCNC/FPGA may authorize it alone? |
|---|---|---:|---:|---|---:|
| Normal safeguard active | safety device/function | n/a | No | normal operation | No |
| Muting | validated safety logic + process/material sensors | Yes | Selected protective function temporarily | material passage | No |
| Muting override | deliberate operator recovery control + safety logic | No | Selected protective function exceptionally bypassed | clear obstructing material | No |
| Blanking | safety-device configuration | configuration-dependent | Portions/detection behavior altered | accommodate defined application geometry/object | No |
| Setup/service mode | deliberate mode selection | No | Not implied; must be enumerated | setup/test task | No |
| Servicing test/positioning exception | authorized servicing procedure | No | energy-control state temporarily changes | necessary test/positioning | No |
| Defeated safeguard | improper bypass/removal/manipulation | Either | Yes, without valid lifecycle | convenience/unknown | Never |

## Safety Sandbox failure paths

### MBO-01 — production request impersonates muting
LinuxCNC asserts `material_transfer = TRUE`; no valid muting-sensor sequence is evidenced. Evaluator must reject `MUTED = TRUE` as unsupported.

### MBO-02 — muting timeout ignored
Material stalls in the sensing field beyond the validated muting conditions. Normal production must not simply leave the protective function suppressed indefinitely.

### MBO-03 — override becomes maintained bypass
Operator turns a selector on and walks away. A design that treats this as acceptable override fails; source-backed Rockwell examples use bounded, deliberate hold-to-run override with hazard visibility.

### MBO-04 — override survives reconnect
LinuxCNC/network reconnect occurs while an override request was previously true. Stale state must not recreate exceptional permission automatically.

### MBO-05 — blanking mislabeled as muting
A beam/object is intentionally ignored by device configuration. Learner claims material-sequence muting protections apply. Fail unless actual blanking behavior/evidence is traced.

### MBO-06 — setup mode claims safe reduced speed
LinuxCNC caps commanded velocity, but no independent safety-rated speed supervision is evidenced. “Personnel-safe reduced speed” remains UNKNOWN.

### MBO-07 — safeguard defeat renamed maintenance
Interlock is bridged for repeated production adjustments. HMI displays `MAINTENANCE MODE`. Labeling does not make the bypass legitimate.

### MBO-08 — return to production without restoration proof
Exceptional state ends but guard/interlock/light-curtain configuration is not independently proven restored. Production rearm remains inhibited/UNKNOWN.

### MBO-09 — mute indication mistaken for physical safety
Muting lamp/status reports active. Learner concludes the hazard is safe. Fail: muting means the protective function is intentionally suspended under defined conditions; it is not evidence that hazardous motion/energy disappeared.

### MBO-10 — permanent enable-mute configuration copied blindly
A manufacturer instruction permits an Enable Mute configuration option. Learner treats that as permission to enable muting universally on another machine. Fail: device capability is not application validation.

## OpenPressBrake boundary

For a press brake, do not introduce `MUTE`, `BLANK`, `SETUP_SAFE`, or `OVERRIDE` semantics from generic machinery examples without identifying the actual protective device, task, hazard boundary, applicable safety architecture, and machine-specific validation evidence. No stopping distance, hydraulic safe-state truth table, pressure threshold, reduced-speed value, or protective-device placement is established by this study.

The normal FPGA/LinuxCNC path may request a production phase or expose diagnostics. Personnel-safety authority must remain with the independently designed/validated safety architecture.

## Source trace

1. Rockwell Automation, Studio 5000 Logix Designer safety instruction **Two-sensor Symmetrical Muting (TSSM)**, current web documentation inspected 2026-09-16. SOURCE-CONFIRMED: temporary automatic muting; sequenced sensors; separate override; hold-to-run/hazard visibility; bounded override timer.
2. Rockwell Automation, **Two Sensor Asymmetrical Muting (TSAM)** and **Four Sensor Bi-Directional Muting (FSBM)**, current web documentation inspected 2026-09-16. SOURCE-CONFIRMED: sequence/timing fault behavior and separate override semantics.
3. Rockwell Automation, **Safety Function: Light Curtain with Muting (two sensor L-type) and Configurable Safety Relay**, SAFETY-AT136C-EN-P. DOC-CONFIRMED: worked validation checks for override indication, timeout, release/trip, and clearing obstructing material.
4. Rockwell Automation, **GuardShield 450L Safety Light Curtain** product/user documentation. SOURCE/DOC-CONFIRMED: advanced 450L-E exposes blanking and integrated muting as distinct features; detailed blanking constraints are intentionally not inferred here.

## Next evidence branch

Trace one selected manufacturer's authoritative blanking documentation deeply enough to freeze fixed/floating blanking semantics, detection-capability consequences, configuration/change-control expectations, and validation questions. Keep it separate from the primary lane's reset/restart/rearm matrices and executable Safety Sandbox fixture. Do not turn device-specific capability into an OpenPressBrake safety claim.

No executable verification is justified by this source study; no runner compute consumed.
