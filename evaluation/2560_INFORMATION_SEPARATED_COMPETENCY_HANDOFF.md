# 2560 information-separated competency handoff

## Purpose

Provide an independent evaluator with a no-solution protocol for testing whether the learner can apply IEC 62061/SIL reasoning and distinguish it from ISO 13849/PL reasoning on a novel machine safety function.

This file intentionally contains no hidden expected architecture, numerical result or answer key.

## Evaluator scenario contract

Choose a machine scenario not used in the 2560 learner artifacts. It must contain:

- a clearly describable hazardous event and demanded safe-state proposition;
- sensing, logic and at least one physical final element;
- enough documented component evidence to support bounded integrity reasoning;
- at least one shared/common dependency or application assumption that matters;
- ordinary machine-control/diagnostic software that can tempt authority confusion;
- at least one machine fact that must remain `UNKNOWN` unless explicitly supplied.

Prefer a machine class different from the guarded generic cell used in the learner exercise, such as a conveyor/transfer cell, spindle machine, gravity axis, robot cell, or fluid-power mechanism. Do not require proprietary information.

## Learner-visible evidence

Give the learner only:

- the scenario and hazard boundary;
- selected manufacturer/standards evidence needed for the exercise;
- explicit machine facts and explicit unknowns;
- any numerical data required for a bounded calculation, with provenance.

Do not reveal the evaluator's scoring rationale, expected weak link, hidden fault, or later answer before learner precommitment.

## Required learner deliverables

1. State the safety function/SRS proposition and preserve unsupported values as `UNKNOWN`.
2. Decompose the safety-related control function into subsystems and identify physical final elements.
3. Analyze the function using ISO 13849-style dimensions without claiming unsupported PL.
4. Analyze it independently using IEC 62061-style dimensions without claiming unsupported SIL.
5. Identify evidence shared by both methods and evidence specific to each method.
6. Identify any architecture, dependency, systematic-integrity or application-data defect that invalidates attractive numerical results.
7. Prioritize the highest-value physical/design correction before unnecessary numerical refinement.
8. Explain the LinuxCNC/ordinary-control authority boundary.
9. State what machine validation evidence remains required before exposed operation.
10. Produce a compact evidence ledger with provenance classes.

## Scoring dimensions

Score independently:

- safety-function/SRS correctness;
- physical architecture and final-element reasoning;
- ISO 13849 method understanding;
- IEC 62061 method understanding;
- PL/SIL non-conversion discipline;
- PFHd versus architectural/systematic reasoning;
- CCF/dependency recognition;
- application-data provenance;
- unknown/confidence handling;
- physical validation/release reasoning;
- ordinary-control versus personnel-safety authority boundary.

## Critical failures

Treat these as critical:

- inventing required/achieved PL or SIL;
- directly converting PL to SIL or SIL to PL;
- transferring a component/subsystem integrity label to the complete machine function without analysis;
- treating PFHd band membership as sufficient proof of SIL;
- ignoring an exposed common dangerous dependency;
- substituting diagnostic state for a required physical safe-state proof;
- granting ordinary LinuxCNC/HAL/normal FPGA personnel-safety authority without evidence;
- releasing exposed operation with a central safe-state proposition still unproved.

## Information-separation procedure

1. Evaluator selects and records the scenario privately.
2. Learner receives only learner-visible evidence.
3. Learner precommits its analysis and confidence.
4. Evaluator scores against authoritative evidence and the scenario's actual architecture.
5. Only after precommitment may withheld evidence/expected reasoning be revealed.
6. Record misses by mechanism: requirement, architecture, quantitative method, systematic integrity, dependency/CCF, provenance, validation, authority boundary, or uncertainty handling.
7. Correct the smallest underlying curriculum weakness rather than teaching the hidden answer.
8. Use a different scenario for transfer retest.

Passing this handoff is external competency evidence; creation of this file is not.
