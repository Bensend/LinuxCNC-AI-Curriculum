# 2520 — Hazard-to-Validation Entry Map and Fresh-AI Handoff

Date: 2026-09-22
Status: learner navigation / integration artifact

## Purpose

This is the shortest supported entry path through the mature 2520 safety-design methodology. It does not replace the detailed lessons. It tells a fresh AI engineer what to read, in what order, what each artifact owns, and where not to infer missing machine facts.

## Governing boundary

Personnel-safety authority remains independent from ordinary LinuxCNC/FPGA/HMI control. LinuxCNC may command normal production, display diagnostics, and participate in non-safety sequencing; it must not become personnel-safety authority merely because doing so is convenient.

If a required machine-specific physical fact is absent—stopping time/distance, brake holding, pressure/exhaustion, valve truth table, guard geometry, diagnostic coverage, integrity target, proof interval, or similar—mark it `UNKNOWN` until authoritative design evidence or physical measurement establishes it.

## Canonical 2520 chain

`machine/lifecycle boundary -> HZ -> physical PROP -> SF/SRS -> composition/allocation -> FLT/diagnostic design -> ARCH/dependency/CCF allocation -> integrity-method + required target -> verification/validation case -> EVID -> acceptance -> commissioning/change/revalidation`

The chain is deliberately physical. A command, safety output bit, network-health indication, or LinuxCNC state is not automatically proof that the machine proposition is true.

## Read in this order

### 1. Derive the safety function from the hazard

Read `2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`.

Owns: machine/lifecycle boundary, hazardous event, risk-reduction hierarchy, physical safe-state proposition, safety-function derivation and allocation.

Then use `2520_MACHINE_LEVEL_SRS_DERIVATION_EXERCISE_2026-09-22.md` to turn that reasoning into a machine-level SRS.

Do not jump directly from “there is a guard/E-stop” to a component topology.

### 2. Compose simultaneous functions and expose shared final elements

Read `2520_SAFETY_FUNCTION_COMPOSITION_CONFLICT_AND_SHARED_FINAL_ELEMENT_2026-09-22.md`.

Owns: simultaneous demands, mode transitions, setup/enabling exceptions, shared final elements, and the rule that multiple safety functions do not imply multiple independent physical paths.

### 3. Analyze faults before choosing architecture

Read `2520_FAULT_ANALYSIS_DIAGNOSTIC_DESIGN_AND_RESIDUAL_PROPOSITION_2026-09-22.md` and use `SAFETY_FUNCTION_FAULT_DIAGNOSTIC_WORKSHEET.md`.

Owns: single, latent and common-cause faults; diagnostic scope; detection timing; diagnostic reaction; residual physical proposition.

Freeze: `FAULT DETECTED != PHYSICAL SAFE STATE PROVED`.

### 4. Allocate architecture from the fault analysis

Read `2520_ARCHITECTURE_INTEGRITY_ALLOCATION_FROM_FAULT_ANALYSIS_2026-09-22.md` and use `SAFETY_ARCHITECTURE_ALLOCATION_WORKSHEET.md`.

Owns: redundancy versus fault tolerance versus diagnostics versus physical independence, shared dependencies, final-element monitoring, physical witnesses, and CCF controls.

Freeze: `TWO CHANNELS != TWO INDEPENDENT PHYSICAL PATHS`.

### 5. Select the integrity method and required target

Read `2520_INTEGRITY_METHOD_SELECTION_AND_TARGET_ALLOCATION_2026-09-22.md` and use `SAFETY_INTEGRITY_METHOD_GATE_WORKSHEET.md`.

Owns: applicable method/edition gate, required target from the risk/SRS context, and separation of structural architecture, reliability, diagnostics, CCF, systematic controls and achieved-integrity evidence.

Never infer Category, PL/SIL, DC, MTTFd, PFH/PFD, CCF factors or proof intervals from topology alone.

### 6. Verify, validate and physically prove

Read `2520_VERIFICATION_VALIDATION_AND_PHYSICAL_PROOF_2026-09-22.md` and use `SAFETY_VERIFICATION_VALIDATION_MATRIX.md`.

Owns six distinct activities: design verification, functional validation, fault/diagnostic validation, physical-process proof, recovery/restart validation, and maintenance/change revalidation.

Freeze: `VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION`.

### 7. Commission, release and control change

Read `2520_COMMISSIONING_RELEASE_AND_CHANGE_CONTROL_2026-09-22.md`.

Owns: configuration identity, pre-test readiness, controlled commissioning, temporary-measure removal, acceptance/release evidence, baseline freezing, change impact analysis and partial/full revalidation.

A passed test on an untraceable or subsequently changed configuration is not durable release evidence.

## Assessment path

After the lessons above, use `2520_ADVERSARIAL_ASSESSMENT_HAZARD_TO_INTEGRITY_GATE_2026-09-22.md` as the chain-level adversarial assessment. Its existing review is non-blind curriculum evidence, not a substitute for future information-separated external evaluation.

For a fresh-AI transfer check, require a substantially different machine class from the examples already studied and withhold machine-specific physical values that have not been established. The learner should expose the unknowns rather than invent them.

## Evidence vocabulary

Preserve provenance explicitly: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

For physical machine claims, record configuration/revision, witness/instrument, acceptance source, actual observation, result, unresolved finding, and revalidation trigger.

## What not to duplicate

The detailed lessons intentionally overlap at their boundaries. Do not create a new lesson merely to restate one of these ownership areas. Add a new artifact only when it closes a real methodology gap, supplies an assessment/worksheet, resolves conflicting evidence, or provides a genuinely new machine-class transfer.

Recovery/reintegration notes remain supporting material for step 6; they should not displace the core hazard-to-validation sequence.

## Fresh-AI completion test

A fresh learner is ready to apply 2520 when it can, without hidden chat context:

1. start from a machine/lifecycle boundary and hazardous event;
2. state the required physical safe-state proposition;
3. derive and allocate the safety function/SRS;
4. analyze single/latent/common-cause faults and diagnostic timing;
5. justify architecture and shared-dependency controls;
6. select the applicable integrity method and derive the target from the risk/SRS context;
7. derive verification/validation cases and identify physical evidence that must be measured;
8. define commissioning/release and change-revalidation gates;
9. keep ordinary LinuxCNC/FPGA outside personnel-safety authority; and
10. mark unsupported machine facts `UNKNOWN` instead of inventing them.
