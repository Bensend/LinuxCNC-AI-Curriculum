# 2520 Information-Separated Competency Handoff

Status: evaluator-facing protocol surface; **no hidden answer or solution is stored here**.

## Purpose

Measure whether a fresh learner can transfer the 2520 hazard-to-release method to a machine scenario not used in learner-readable worked examples. This is an external/fresh competency gate, not another self-graded adversarial exam.

The learner-facing course currently contains press/gravity-fluid-power, cut/feed, spindle/robot-tending, and recovery examples. The evaluator should therefore choose a materially different machine surface.

## Challenge-selection requirements

Choose one scenario with all of the following:

- at least two hazardous energy forms or hazardous-motion mechanisms;
- at least one personnel-access/protective-device issue;
- at least one ordinary-control path that is useful operationally but is not personnel-safety authority;
- at least one shared dependency/common-cause possibility;
- at least one final-element or physical-process proposition that cannot be proved merely from command/status bits;
- at least one reset/restart/recovery trap;
- at least one maintenance/change event requiring impact analysis;
- enough authoritative device/machine information to score the reasoning, but with at least one legitimate physical/integrity value intentionally unavailable so the learner must preserve `UNKNOWN` rather than invent it.

Preferred distinct surfaces include a saw/feed line, palletizer/conveyor transfer cell, packaging machine, winding/unwinding machine, or another machine class not substantially isomorphic to the existing worked examples.

Do not use a scenario whose resolution, grading key, or near-verbatim worked solution already appears in learner-readable repository material.

## Learner packet

Reveal only:

1. machine/process description and lifecycle/mode context;
2. initial observable facts and device capabilities that are safe to reveal;
3. explicitly allowed documentation/source references;
4. the requested deliverables below;
5. time/resource constraints.

Do **not** reveal the evaluator's expected architecture, hidden fault list, grading rationale, or authoritative outcome before learner commitment.

## Required learner deliverables

The committed response must include:

- machine/lifecycle boundary;
- hazardous events and risk-reduction hierarchy decisions;
- explicit physical safe-state propositions;
- safety-function/SRS statements with trigger, required reaction/safe state, reset/restart behavior, assumptions and `UNKNOWN`s;
- function composition/conflict analysis;
- credible single, latent and common-cause fault analysis;
- diagnostic claims tied only to the propositions they actually support;
- architecture/dependency/final-element allocation;
- integrity-method/target gate: identify what must be derived or verified without inventing PLr/SIL/Category/DC/MTTFd/PFH/PFD/CCF values;
- verification, validation and physical-proof plan;
- commissioning/release baseline and change/revalidation logic;
- ordinary LinuxCNC/FPGA role versus independent safety authority;
- confidence, alternatives, falsifiers, resources consulted and elapsed solution time as required by `BLIND_FEEDBACK_PROTOCOL.md`.

## Scoring dimensions

Use the repository blind-feedback 0/1/2 scale for its five mandatory dimensions, and preserve those scores unchanged for the global feedback log:

1. prediction/design disposition;
2. causal mechanism;
3. diagnostic efficiency;
4. uncertainty/safety boundary;
5. confidence calibration.

For 2520 competency interpretation, also record pass/fail observations for these curriculum-specific dimensions without collapsing them into the global `/10` score:

- hazard/boundary completeness;
- proposition quality (physical, testable, non-circular);
- safety-function/SRS quality;
- fault/diagnostic/CCF reasoning;
- final-element and physical-witness reasoning;
- integrity-target discipline;
- verification/validation/physical-proof quality;
- reset/restart/recovery authority separation;
- commissioning/change/revalidation reasoning;
- LinuxCNC/FPGA safety-authority boundary.

## Critical-fail conditions

A response cannot establish 2520 transfer competency if it materially does any of the following:

- assigns personnel-safety authority solely to ordinary LinuxCNC/FPGA/PC software without evidence supporting that role;
- treats a command, network-health bit, or electronic diagnostic as proof of an unrelated physical safe-state proposition;
- invents a machine-specific stopping time/distance, hydraulic/pneumatic truth, required PL/SIL, diagnostic coverage, or integrity value;
- permits reset/reintegration itself to initiate hazardous motion without a separately justified fresh start demand;
- ignores an identified hazardous energy form or shared dependency in a way that can defeat the claimed safety function;
- claims the machine safe for exposed personnel while a required physical proposition remains unresolved.

## Information-separation procedure

1. Evaluator selects and retains the challenge oracle/expected reasoning outside learner-readable curriculum state.
2. Perform contamination check against learner-readable 2520 examples.
3. Give learner only the learner packet.
4. Preserve immutable precommitment before revealing evaluator material.
5. Score independently under `evaluation/BLIND_FEEDBACK_PROTOCOL.md`.
6. Record misses by error class; make only minimal transferable curriculum corrections.
7. If correction is needed, use a novel surface for transfer retest; never repeat the same answer as proof of learning.
8. Preserve a delayed-retention opportunity where practical.

## Graduation interpretation

Formal placement of 2520 is already durable. This protocol does not mark 2520 graduated by itself. Secure transfer requires an actually information-separated attempt with a valid oracle and scoring record. If such an evaluator is unavailable, leave the gate open and continue another unblocked safety-course branch rather than self-generating and self-reading a hidden solution.
