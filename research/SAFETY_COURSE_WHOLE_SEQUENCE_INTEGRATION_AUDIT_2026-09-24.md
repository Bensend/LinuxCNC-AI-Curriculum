# Safety Course Whole-Sequence Integration Audit — 2026-09-24

Status: DURABLE INTEGRATION AUDIT / CURRICULUM-GATE EVIDENCE
Scope: 2520 through 25F0, using current release-gate artifacts and newest durable checkpoint. This audit does not self-graduate any course that requires information-separated evaluation.

## 1. Purpose

Test whether the safety curriculum forms one defensible engineering workflow rather than a set of locally correct modules. The required end-to-end chain is:

`machine/lifecycle boundary -> hazards and hazardous energy -> risk/safety-function need -> physical safe-state proposition -> SRS requirement -> architecture/authority allocation -> composition + fault/CCF analysis -> guarding/human factors -> practical architecture selection -> verification/validation/commissioning -> machine-specific capstone transfer -> maintenance/change/revalidation`

A downstream module may refine an upstream artifact, but it may not silently replace a physical proposition with a controller bit, move personnel-safety authority into ordinary LinuxCNC/HAL/FPGA logic, or invent missing machine-specific facts.

## 2. Governance and progression result

The current governance is internally consistent on the important progression facts:

- 1000 and 2000 are closed/graduated and are prerequisites, not active work.
- F02 is graduated; completed 3000 specialization evidence remains preserved.
- 4000-series work may support the safety course but routine controller-board development is not the safety-course priority.
- 2520–25F0 use information-separated evaluation gates; READY FOR EXTERNAL/FRESH EVALUATION is not GRADUATED.
- Closed 3300 Plasma/Laser/Waterjet instruction is not reopened by the 25F0 plasma safety-transfer delta.

No governance contradiction requiring learner-facing repair was found.

## 3. Prerequisite and artifact-flow audit

### 2520 — machine/lifecycle boundary and hazard inventory
Produces the bounded machine, people/lifecycle exposure, hazardous-energy inventory, hazardous events, initial risk reasoning, and UNKNOWN register. This is the required input to every later physical proposition. PASS.

### 2530–2590 — safety-function and implementation foundations
The foundation sequence turns hazards into safety-function reasoning and then teaches stop/access, E-stop, reset/restart, isolation, guards/interlocks, diagnostics and related implementation boundaries. These modules provide the concepts later courses assume. The important invariant survives: a command/state indication is not automatically the physical safety proposition. PASS.

### 25A0 — physical propositions / SRS handoff
25A0 is the bridge from hazard reasoning into explicit safety requirements. It prevents later architecture work from starting with preferred components instead of required physical behavior. PASS.

### 25B0 — composition and architecture
25B0 consumes earlier requirements and tests the composed chain, including final elements, dependencies and common-cause paths. It explicitly requires the learner to preserve upstream authority boundaries. PASS.

### 25C0 — failure-path / diagnostic reasoning
25C0 deepens fault, diagnostic and common-cause reasoning without allowing diagnostic evidence to become a substitute for physical state. PASS.

### 25D0 — practical low-cost architectures
25D0 asks what economical architecture can satisfy the already-defined propositions and failure paths. Cost is therefore downstream of safety requirements, not the source of them. Guarding, STO/external isolation, fluid-power supply/dump/load-holding distinctions and common-cause reasoning are retained. PASS.

### 25E0 — validation, commissioning and proof testing
25E0 consumes the SRS and architecture and requires traceable validation evidence: `SRS -> physical proposition -> precondition/mode -> stimulus/fault -> expected response -> measurement/evidence -> acceptance criterion -> result -> correction/retest/release`. It preserves verification vs validation, physical stopping-time evidence, exceptional modes, change control and proof-test uncertainty. PASS.

### 25F0 — cross-machine transfer
25F0 requires the learner to replay the complete chain on mills/VMCs, lathes, robots/cells, press brakes and a narrow plasma/cutting safety delta. Machine-specific UNKNOWNs are retained rather than filled by analogy. PASS.

## 4. Cross-course invariants

The following invariants are continuous through the sequence and are release-critical:

1. **Normal control is not personnel-safety authority by convenience.** LinuxCNC/HAL/ordinary FPGA logic may command, request, monitor and diagnose, but independent safety-related control and physical final elements own justified personnel-safety functions.
2. **Status is not physics.** A green bit, valve command, STO request, pump-off command, guard input or software state is evidence only for the proposition it actually establishes.
3. **Stopping is not isolation.** Production safeguarding and stop functions do not replace hazardous-energy isolation, stored-energy control or maintenance restraint.
4. **Safe state is machine- and hazard-specific.** Torque removal, standstill, access prevention, pressure relief, gravity restraint, electrical isolation and process-energy removal are separate propositions unless evidence justifies combining them.
5. **Reset is not restart permission by itself.** Reset/rearm must not silently create hazardous motion, and occupancy/access conditions remain separate propositions.
6. **CCF survives redundancy.** Shared power, wiring, pilot pressure, software/configuration, environment and physical routing must be examined rather than hidden behind channel count.
7. **Human defeat is an engineering input.** Safeguards that are predictably awkward to use/reinstall require redesign; bypass risk is not dismissed as operator behavior.
8. **UNKNOWN stays UNKNOWN.** No invented PL/SIL, stopping distance/time, pressure threshold, hydraulic truth table, diagnostic coverage, proof-test interval or machine-specific fail state.
9. **Unsafe-to-operate threshold is explicit.** If basic personnel protection cannot be established, people are not exposed during experimental operation; isolated/remote testing and residual-risk disclosure are required.
10. **Change can invalidate evidence.** Safety-program, mechanical, drive, hydraulic, guarding, tooling, process and maintenance changes trigger impact review and, where applicable, revalidation.

No contradiction among these invariants was found in the current 25B0–25F0 release artifacts.

## 5. Learner handoff integrity

The strongest integration risk is not a missing technical topic but **artifact discontinuity**: a learner could understand each module yet restart the analysis from scratch at every course. To prevent that, the canonical safety-course route SHALL carry one evolving Safety Design Package forward.

Minimum persistent package fields:

- machine/lifecycle boundary and operating modes;
- hazard/energy register and hazardous events;
- stable safety-function / requirement IDs;
- physical safe-state propositions and assumptions;
- SRS requirements and acceptance criteria;
- authority allocation (normal control / monitoring / independent safety / physical final element / mechanical protection);
- dependency and common-cause map;
- foreseeable-defeat/human-factors findings;
- architecture decisions and rejected alternatives;
- verification/validation matrix and physical witnesses;
- commissioning/proof-test/change-control records;
- residual-risk and UNKNOWN register.

A later module may add fields or refine an item, but changes to an upstream proposition or assumption must mark dependent downstream evidence stale for review. This matches the repository's stable semantic-ID / dependency-tracking direction and makes the safety workflow auditable rather than narrative-only.

## 6. Information-separated evaluation boundary

Fresh evaluators must not receive answer keys, prior evaluator conclusions or solution-bearing hidden artifacts. They may receive the canonical learner route, learner-visible source pack, assignment/evaluation contract, and the learner's submitted Safety Design Package. Evaluation evidence is appended separately. A course remains READY FOR EXTERNAL/FRESH EVALUATION until that independent gate is satisfied under current governance.

## 7. Integration finding

**PASS WITH ONE INTEGRATION IMPROVEMENT FROZEN:** no missing prerequisite, authority-boundary contradiction or machine-transfer hole was found after the 25F0 plasma safety delta. The sequence is technically coherent. The remaining curriculum-level improvement is to make the evolving Safety Design Package the explicit cross-course handoff so requirements, assumptions, dependencies, validation evidence and UNKNOWNs cannot be silently reset between modules.

This is a curriculum integration improvement, not a reason to manufacture another specialization course or run simulation.

## 8. Next work

1. Create the canonical **Safety Design Package / traceability template** with stable semantic IDs and stale-dependency rules.
2. Map each 2520–25F0 learner route to the package fields it creates, consumes or validates.
3. Audit evaluator handoffs so fresh evaluation receives learner-visible artifacts but no solution leakage.
4. Then perform the safety-course top-level release/readiness audit. Do not self-graduate courses whose external/fresh evaluation is still outstanding.

No executable question survived this audit; no compute is justified by this checkpoint.
