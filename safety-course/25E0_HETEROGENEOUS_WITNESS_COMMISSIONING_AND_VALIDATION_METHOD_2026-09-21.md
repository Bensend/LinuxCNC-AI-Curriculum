# 25E0 — Heterogeneous Safety-Witness Commissioning and Validation Method

Date: 2026-09-21
Status: durable curriculum method

## Purpose

This module turns the preceding brake, motion, valve-position, feedback, and restart studies into a repeatable commissioning method. It does **not** define OpenPressBrake thresholds, hydraulic truth tables, stopping distances, PL/SIL targets, or diagnostic coverage. Those remain machine/design specific.

The central rule is:

> A signal is evidence only for the physical proposition that its sensing chain can actually witness, and commissioning must challenge both the proposition and the witness.

Do not collapse heterogeneous observations into a generic `SAFE=true` bit.

## Authoritative basis

- **DOC-CONFIRMED — Rockwell FactoryTalk safety commissioning guidance:** application validation requires documented test cases, including values inside the defined range, at limits, and invalid values; active validation with field devices is required to verify sensors/actuators are wired correctly; wiring and network-fault reactions must be tested.
  Source: https://www.rockwellautomation.com/en-se/docs/factorytalk-design-studio/current/technical-content/ftds-pm001/web_ftds-pm001-ditamap/safety-system-principles/commission-safety-system/validate-project.html
- **DOC-CONFIRMED — Rockwell AADvance Safety Manual (ICSTT-RM446S-EN-P, Oct. 2024):** commissioning measures are system-specific and defined before commissioning; temporary measures used for test/partial commissioning are to be removed before the complete system goes live; records include tests, problems, and resolutions. Integrated validation includes normal startup/shutdown, abnormal fault modes, performance criteria/process-safety-time requirements, and external common-cause conditions.
- **DOC-CONFIRMED — Rockwell actuator safety-function application technique SAFETY-AT146A-EN-P:** verification analyzes the resulting safety control system; validation functionally tests that specified safety-function requirements are met and outputs respond appropriately to safety inputs.
- **DOC-CONFIRMED — Pilz Safety Compendium validation-plan discussion:** the validation plan covers operational/environmental conditions, safety principles/components, fault assumptions/exclusions, analyses and tests, and explicitly includes testing safety functions under fault conditions.
- **DOC-CONFIRMED — ISO 13849-1:2023 scope as summarized by Pilz:** validation requirements formerly associated with ISO 13849-2 are incorporated and expanded in the current Part 1. Use the applicable purchased/controlled standard text for a real conformity project; this curriculum does not reproduce normative clauses.

## Witness taxonomy

For every safety-related observation create a witness card before testing it.

| Witness | May establish, if correctly designed/validated | Does not establish by itself |
|---|---|---|
| Contactor auxiliary / EDM contact | monitored contact state associated with the contactor mechanism | zero torque, zero voltage everywhere, stopping performance |
| Drive STO/status | the documented drive safety-function/status condition | mechanical load retention, brake torque, external hydraulic state |
| Valve position switch | monitored valve/spool position represented by that device | downstream pressure, decompression, zero flow, ram stationary |
| Pressure sensor/switch | pressure at its actual measurement point within validated limits | valve position, zero trapped pressure elsewhere, zero motion |
| Encoder/safe-speed witness | motion/speed represented by its sensing chain | retaining capability, hydraulic pressure, structural integrity |
| Brake switch | the switch's represented brake state | holding torque/capability |
| Active brake proof + motion measurement | brake response under the validated proof challenge | every future load case, all hazardous energy, indefinite future capability |

A machine may require several propositions simultaneously. Do not promote one witness into another proposition merely because both normally correlate.

## Commissioning sequence

### 1. Freeze the safety-function claim before testing

Write the hazard, demanded safe state, triggering condition, required physical final elements, required process result, restart/rearm condition, and acceptance evidence. Identify which parts are safety authority versus ordinary LinuxCNC/FPGA control and diagnostics.

If the acceptance statement is only `input X makes output Y false`, it is incomplete whenever the safety function depends on a physical result after Y changes.

### 2. Build a proposition-to-witness matrix

For each required proposition state:

- sensor/witness and exact physical location;
- what physical fact it can observe;
- expected normal transition;
- expected fault/disagreement transition;
- timing criterion source;
- whether the evidence is continuous, transition-specific, proof-test-only, or diagnostic-only;
- independence/common-cause concerns;
- what it explicitly cannot prove.

Unknown timing or thresholds stay `UNKNOWN`; do not borrow a vendor example value.

### 3. Validate nominal transitions end-to-end

Exercise the actual protective device and actual field chain. Observe the sequence from initiating event through safety logic, final element, and process witness. Include normal start, normal stop, safety demand, reset/rearm, and fresh-start behavior.

Record events against acceptance criteria rather than merely recording that the machine 'looked right'.

### 4. Inject disagreement deliberately and safely

Fault injection is question-driven and planned. Examples appropriate to a de-energized/simulated or otherwise safely controlled commissioning environment include disconnected monitored feedback, channel disagreement, commanded final element without expected feedback, invalid/out-of-range sensor state, network loss where applicable, and a stale ordinary Start/Jog/Cycle request held while safety evidence is invalid.

For every injection ask:

1. Was the fault detected?
2. Was it detected within the design-specific required time?
3. What authority was removed?
4. What remained energized and why?
5. Was the fault latched or self-clearing?
6. What evidence is required before reset/rearm?
7. Does correction alone restore eligibility?
8. Can an ordinary demand asserted during the fault become effective on recovery?

Do **not** inject a fault on energized hazardous machinery merely because it appears in this curriculum. If the fault could expose personnel to hazardous motion/energy, test it in simulation, with energy isolated, or in a controlled remote commissioning condition with people outside the danger zone and a machine-specific plan.

### 5. Challenge correlations between witness classes

Create cases where one witness is healthy and another is deliberately not. Examples:

- valve-position feedback indicates safe position while downstream pressure remains stored;
- zero speed while a gravity load is not independently retained;
- brake-status switch indicates applied while an approved brake proof test fails;
- EDM is valid while process motion has not yet met the stopping criterion.

The purpose is to prove that the implementation does not accidentally substitute one evidence class for another.

### 6. Validate reset, rearm, and demand freshness separately

Test at least these histories, where applicable:

- protective condition restored with Reset not operated;
- Reset held before evidence becomes valid;
- Reset operated after evidence becomes valid;
- Start/Jog/Cycle held before and throughout the safety interruption;
- ordinary demand released and freshly reasserted after rearm;
- mode transition with an ordinary demand already true;
- power cycle/restart with maintenance/bypass/exception state present.

Classify each ordinary demand explicitly as edge, level, latched, queued, cancelled, tracked, or regenerated. `permission restored` is not evidence that the demand is fresh.

### 7. Validate timing as a chain, not one timer

Where timing is safety-relevant, distinguish at minimum:

`protective-device detection -> safety logic response -> final-element transition -> process response -> witness detection -> acceptance/fault decision`

A controller timestamp alone cannot validate mechanical stopping time unless the measurement architecture actually witnesses the physical endpoints with adequate accuracy. Record measurement uncertainty and the source of every acceptance limit.

### 8. Validate common-cause and degraded conditions

Use the machine's actual safety requirements to decide applicable conditions. Consider loss/variation of power sources, communications loss, sensor supply failure, shared wiring/common reference failures, environmental limits, and failures that can make two apparently independent witnesses fail together. Do not count correlated signals as independent evidence without justification.

### 9. Remove temporary commissioning authority before production

Inventory forces, simulated inputs, jumpers, bypasses, maintenance modes, temporary guards/aids, debug configuration, relaxed limits, test credentials and temporary wiring. Removal/normalization is itself an acceptance item. Configuration cleanliness does not replace physical inspection where a physical temporary aid could remain.

Then repeat the minimum production-configuration safety validation needed to show that removing the commissioning aids did not change the safety function adversely.

### 10. Freeze evidence and define revalidation triggers

The validation record should identify hardware revision, safety configuration/signature/version as applicable, wiring revision, parameter set, witness calibration/status where relevant, test cases, actual results, deviations, corrections, retest results, and unresolved limits.

Revalidation scope must be reconsidered after changes that can affect the safety claim: sensor/final-element replacement with changed characteristics, wiring changes, safety logic/configuration changes, drive/valve/brake parameter changes, mechanical brake/load/transmission changes, hydraulic/pneumatic circuit changes, safeguard geometry changes, firmware changes affecting the safety function, or changes to timing/stop performance.

A checksum or unchanged program is not proof that a modified physical machine still satisfies the validated safety function.

## Human-factors acceptance rule

Commissioning must test the path a hurried operator or maintainer is likely to take, not only the ideal procedure. If returning a guard, interlock, enabling device, or normal mode to service is cumbersome enough that bypass is predictable, treat that inconvenience as a design defect to correct. Production should naturally converge toward the guarded, unforced, unbypassed state.

## Minimum safe-to-operate threshold

If required protective functions, final-element behavior, or physical process evidence cannot be validated sufficiently to establish the machine-specific minimum safe state, do not operate with people exposed to the hazard. Experimental operation belongs in an isolated/remote condition with people outside the danger zone and residual risk explicitly recorded.

## Curriculum freezes

- **SIGNAL TRUE != PHYSICAL PROPOSITION PROVED unless the witness chain supports that proposition.**
- **TWO SIGNALS != TWO INDEPENDENT WITNESSES.**
- **FINAL-ELEMENT FEEDBACK != PROCESS-RESULT FEEDBACK.**
- **FAULT CORRECTED != RESET/REARM COMPLETE.**
- **RESET/REARM COMPLETE != FRESH ORDINARY DEMAND.**
- **CONFIGURATION CLEAN != TEMPORARY PHYSICAL AIDS REMOVED.**
- **CONTROLLER TIMING != PHYSICAL STOPPING TIME unless the measurement chain witnesses the physical event.**
- **VALIDATED ONCE != VALID AFTER AN IMPACTING MODIFICATION.**

## OpenPressBrake transfer boundary

This method is reusable for a press brake, but it intentionally does not state which hydraulic valve positions, pressure points, ram speeds, stop times, brake/retaining mechanisms, PL/SIL, diagnostic coverage, or reset algorithm the actual machine requires. Those must come from the machine hazard analysis, circuit/mechanical design, component documentation, standards and physical commissioning evidence.

LinuxCNC and the ordinary FPGA may log, diagnose, inhibit ordinary commands, enforce demand freshness, and make commissioning evidence easier to collect. They must not be silently promoted into independent personnel-safety authority.