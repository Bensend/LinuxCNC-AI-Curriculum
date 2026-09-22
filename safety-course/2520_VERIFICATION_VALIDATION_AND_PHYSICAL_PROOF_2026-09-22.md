# 2520 — Verification, Validation, and Physical Proof

Date: 2026-09-22

## Purpose

Close the safety-design loop after hazard/SRS, fault analysis, architecture allocation, and integrity-method selection. The learner must derive evidence from requirements rather than inventing tests after implementation.

## Core chain

`HZ -> PROP -> SF -> FLT -> ARCH -> requirement -> verification/validation case -> EVID -> acceptance -> change/revalidation`

## Verification versus validation

**Verification** asks whether the design artifact satisfies its specified requirement: wiring matches the design, logic implements the SRS, configured parameters match the approved values, architecture calculations use the intended subsystem data, diagnostics are mapped to the faults they claim to detect, and documentation is internally traceable.

**Validation** asks whether the integrated safety function, in the actual application and operating modes, fulfills the safety requirements and reaches the required physical safe-state propositions under required normal and fault conditions.

Do not collapse these. A verified schematic can implement the wrong safety requirement. A correct PL/SIL calculation can coexist with a wrong guard location, wrong stopping-distance assumption, unproved brake/valve behavior, or unsafe restart semantics.

## Evidence classes

For every case classify evidence as SOURCE-CONFIRMED, DOC-CONFIRMED, TEST-CONFIRMED, COMMUNITY-REPORTED, INFERENCE, or UNKNOWN.

A safety test record must identify at minimum:

- requirement / HZ / PROP / SF / FLT / ARCH IDs;
- test purpose and acceptance criterion;
- prerequisite configuration and revision;
- operating mode and relevant energy state;
- stimulus/fault/change introduced;
- expected safety reaction;
- actual observation;
- witness/instrument/source of observation;
- result and unresolved findings;
- whether physical human/machine evidence was required;
- who/what is authorized to accept closure;
- revalidation trigger.

## Six distinct evidence activities

### 1. Design verification

Check SRS completeness, requirement allocation, schematics, wiring, configuration, software/logic, architecture/integrity evidence, common-cause controls, diagnostic mapping, and traceability. Analysis is useful but does not universally replace testing.

### 2. Functional validation

Exercise each safety function across applicable modes and transitions. Confirm trigger, reaction, final-element behavior, reset/rearm semantics, fresh-start requirement, and interaction with other simultaneous safety demands.

### 3. Fault/diagnostic validation

Introduce only controlled, justified faults or use manufacturer-supported test mechanisms. Show that the intended diagnostic detects the fault within the required application timing and that the resulting reaction preserves the residual physical proposition. A diagnostic bit is not itself physical proof.

### 4. Physical-process proof

Where the SRS depends on a physical quantity or state—standstill, stopping time/distance, load holding, pressure/exhaustion, guard geometry, contactor/valve state, trapped energy, etc.—obtain the application-specific measurement or witness required by that proposition. If that evidence is unavailable, keep the proposition UNKNOWN and do not fabricate a pass.

### 5. Recovery/restart validation

Test power loss, field-power loss, communications loss/reintegration, safety-controller restart, ordinary-controller restart, asymmetric recovery, reset/rearm, and held pre-fault production demand. Recovery must not silently turn stale state or a held command into start authority.

### 6. Maintenance/change revalidation

Perform impact analysis for changes to hardware, software, parameters, guards, mechanics, pneumatics/hydraulics, field wiring, network topology, final elements, proof methods, or maintenance procedures. Revalidate every proposition and function whose evidence was invalidated by the change; do not assume an unrelated green diagnostic restores that evidence.

## Authoritative professional anchors

- Pilz's current ISO 13849 guidance notes that ISO 13849-1:2023 integrates/revises validation requirements from ISO 13849-2:2012 and explicitly states that analysis supplements testing rather than replacing it. It also notes that fault-evaluation tables remain in ISO 13849-2.
- Siemens' SINAMICS guided Safety Acceptance Test checks that safety functions are correctly parameterized and executed in the application and produces an acceptance report; Siemens identifies the workflow with EN ISO 13849-2 and IEC 62061.
- Rockwell's AADvance safety manual states that integrated validation is against the safety requirements specification and includes normal startup/shutdown, abnormal fault modes, performance criteria, and external common causes such as power/environment. It also requires commissioning records and removal of temporary test/partial-commissioning measures before going live.
- Rockwell's machine-safety validation service explicitly evaluates circuit performance, fault tolerance/action, software logic, device application/function, reset behavior, and machine stop time where applicable.

These anchors support the methodology; they do not supply machine-specific acceptance values.

## Gravity/fluid-power stress test

Generic case: a vertical/gravity-loaded axis has an electrical motion command path, a safety-related stop demand, and one or more mechanical/hydraulic final elements. No machine-specific brake/valve truth table, pressure threshold, stopping time, load-holding capability, or integrity target is supplied.

Required reasoning:

1. Verify the intended electrical/hydraulic allocation against the SRS.
2. Validate the safety demand in each relevant mode.
3. Validate credible diagnostic faults only where the architecture claims detection.
4. Physically prove every required load-holding/stopping/pressure proposition using machine-specific evidence.
5. Validate restart after loss/recovery of relevant power/control domains.
6. After valve, brake, plumbing, sensor, or load-path maintenance, mark affected physical evidence stale until re-proved.

**Forbidden shortcut:** `safe output active -> gravity load proven held`.

## Rotating-tool / automated-cell stress test

Generic case: guarded cell with rotating tooling, powered feed, pneumatic workholding, full-body access, ordinary LinuxCNC/FPGA production control, independent safety authority, and multiple energy domains.

Required reasoning:

1. Validate guard/access safety functions and mode transitions.
2. Prove any required standstill/stopping proposition rather than substituting drive status.
3. Validate pneumatic stored-energy propositions independently from electrical stop status.
4. Test simultaneous demands and shared final elements/common dependencies.
5. Verify that reset/rearm does not itself start the process and that a held pre-fault Cycle Start is not accepted as a fresh production demand.
6. Revalidate guard geometry and tooling/pneumatic propositions after relevant maintenance.

**Forbidden shortcut:** `safety network healthy -> personnel-clear + tool standstill + pneumatic safe`.

## Human/physical evidence boundary

Tests requiring an energized hazardous machine, physical stopping measurement, load holding, hydraulic/pneumatic proof, guard geometry measurement, protective-device placement, or exposure-zone observation require an appropriate physical test plan and competent human involvement. The curriculum may specify the question, required evidence, instrumentation class, acceptance source, and safe preconditions; it must not claim a result that was not measured.

If the minimum physical safe-to-operate proposition cannot be established, do not operate with people exposed. Experimental operation must be isolated/remote with people outside the danger zone and residual risk stated.

## New freezes

- **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION.**
- **ANALYSIS SUPPORTS TESTING; IT DOES NOT UNIVERSALLY REPLACE APPLICATION TESTING.**
- **INTEGRITY CALCULATION PASS != PHYSICAL SAFE-STATE PROOF.**
- **DIAGNOSTIC TEST PASS != UNRELATED PROCESS PROPOSITION PROVED.**
- **ACCEPTANCE REPORT EXISTS != UNSUPPORTED MACHINE VALUE BECOMES KNOWN.**
- **CHANGE IMPLEMENTED != PRIOR VALIDATION STILL APPLICABLE.**
- **RESET/REARM VALIDATED != PRODUCTION START AUTHORIZED.**
- **NO PHYSICAL MEASUREMENT != PERMISSION TO INVENT A PASS.**

## Learner completion condition

The learner can derive a validation plan directly from the SRS/fault/architecture chain, distinguish verification from integrated validation and physical proof, identify which cases require actual machine/human evidence, preserve provenance, and define revalidation scope after change without inventing machine physics or integrity results.
