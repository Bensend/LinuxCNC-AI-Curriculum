# PB-PREP-002 run 079 — authoritative audit

Date: 2026-09-11
Contract: `experiments/PB-PREP-002-abstract-process-state-contract.md`
Implementation commit: `214e0b7218b5848d19027aa935f8b2bdf6340331`
Workflow: `34626267634`
Job: `103352015350`
Artifact: `10274194188`
Result commit produced by lab bot: `f34d181`

## Provenance and boundary

Run 079 implemented the already-frozen PB-PREP-002 abstract process-state contract without adding hydraulic valves, cylinders, pressure, force, stopping-distance, or safety models. The deterministic invocation period was 10 ms and the deliberately abstract semantic timeout was 50 ms. These are test-fixture values only and are not machine design values.

The retained raw evidence contains 38 invocation-level rows in `lab-results/pb-prep-002/raw.csv`; the generated summary is `lab-results/pb-prep-002/summary.json`.

## Independent gate audit

- **A PASS:** P0 state observations are exactly `PROCESS_A -> PROCESS_B -> HOLD -> PROCESS_C -> RETURN -> IDLE`.
- **B PASS:** active-state semantic completion is never inferred solely from a requested command change; non-fault progress uses the symbolic completion witness.
- **C PASS:** live ordinary-authorization loss during P1 produces `AUTHORIZATION_LOST` from `PROCESS_C`.
- **D PASS:** P2 with command/authorization present but no completion witness transitions to `FAULT / PROCESS_TIMEOUT`.
- **E PASS:** P2/P3/P4/P5 retain distinct causes: `PROCESS_TIMEOUT`, `INTERMEDIATE_NOT_FOLLOWING`, `COORDINATION_INVALID`, and `IO_INVALID`.
- **F PASS:** P4 coordination loss faults before the slower semantic timeout and is not relabeled as timeout.
- **G PASS:** reset from each injected fault enters `RECONCILE`; it never blind-resumes the interrupted active state.
- **H PASS:** raw invocation-level input/state/output evidence is retained.
- **I PASS:** executable commit, workflow/job identity, 10 ms invocation period, phase labels and raw evidence are retained.
- **J PASS:** both contract and result explicitly limit the result to simulation-only ordinary-control semantics.

Frozen Gates A-J: **10/10 PASS**.

## Adversarial interpretation check

This result does **not** prove that a hydraulic actuator moved, that a timeout identifies a particular failed device, that loss of ordinary authorization makes stored energy safe, that servo-thread software is functional safety, or that two physical feedback channels agree. It proves only that the proposed abstract ownership pattern can be implemented deterministically without conflating request, authorization, completion, fault cause and reconciliation.

## Correction / limitation found during audit

The fixture includes `feedback_valid` as a separately detectable cause (`FEEDBACK_INVALID`) even though the frozen P0-P6 phase list does not inject it. This does not affect Gates A-J because the frozen diagnostic-separation gate names P2/P3/P4/P5 only. A later experiment must not silently claim that run 079 independently exercised every declared input merely because the transition function contains a branch for it.

Likewise, `RECONCILE -> IDLE` after reset release is an abstract test choice. It is not evidence that a real press brake can safely reconcile physical position, pressure, tooling, workpiece state, or stored hydraulic energy by returning to an idle software state.

## Sufficiency decision

PB-PREP-002 is **TEST-CONFIRMED for its deliberately narrow abstract software contract**. The pre-execution prediction matched: a tiny deterministic transition model was sufficient; no invented physical parameters were required.

This closes the generic mode-ownership simulation question. Additional simulation should require a new evidence-backed question, not merely more physical detail.

## Next work

Use the passed contract as a review oracle for the 3600 Press Brake specialization. The next useful work is to consolidate the accumulated public press-brake evidence into an explicit 3600 module/evidence-gap map: identify which objectives already have documentation/community/source/test support, which require genuinely machine-specific evidence, and which next lesson has the highest information gain. Do not reopen PB-PREP-001 or add numeric hydraulic dynamics merely to deepen the simulation.
