# BD01 — Reusable Block vs Board-Specific Connection Contract

Status: **RESEARCH / FIRST DURABLE LESSON**  
Lane: 4000 board-design curriculum  
Date: 2026-09-21

## Purpose

Teach the first architecture boundary required for reusable controller-board engineering:

`machine requirement -> reusable electrical block -> board-specific connection definition -> board integration -> machine harness`

A reusable block owns electrical function and its engineering contract. A connection definition is a board-specific mold that binds one physical connector instance to semantic interfaces, placement, labels, harness destination, and board resources. Neither is allowed to silently absorb the other's authority.

This lesson uses the OpenPressBrake repository as an adversarial worked example, not as a production-proven board and not as the only valid machine architecture.

## Learning objectives

After this lesson the learner must be able to:

1. classify a requirement as reusable-block, machine-configuration, board-integration, connection-definition, or evidence authority;
2. explain why physical connector facts must not leak into a reusable functional primitive;
3. explain why a board connection definition must not duplicate internal circuit engineering;
4. identify incomplete physical facts and keep them `VERIFY_AT_MACHINE`/TBD rather than guessing;
5. distinguish knowledge maturity from implementation/release readiness;
6. derive resource consequences from a reusable block contract without pretending those allocations are intrinsic to the block;
7. preserve the personnel-safety boundary: ordinary controller feedback and enables are not independent safety authority.

## Current-file verification audit

The student-facing examples below were opened and inspected in their current `main` form during lesson construction. The labels are lesson-readiness labels, not claims of production qualification.

| Artifact | Lesson-readiness | Why |
|---|---|---|
| `Bensend/OpenPressBrake/hardware/CONNECTION_DEFINITION_CONTRACT.md` | **VERIFIED_FOR_LESSON** | Clear ownership split, required fields, pin/return/placement/silkscreen rules, fail-closed unresolved-fact policy, and safety boundary. |
| `Bensend/OpenPressBrake/hardware/blocks/differential_encoder/engineering.yaml` | **VERIFIED_FOR_LESSON** for teaching reusable-contract structure | Current file explicitly separates reusable receiver engineering, board FPGA/resource allocation, machine encoder/cable facts, evidence, recalculation triggers, and safety credit. It does **not** prove the block is fully released. |
| `Bensend/OpenPressBrake/hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` | **VERIFIED_FOR_LESSON** for teaching maturity/readiness distinction | Current status explicitly retains open cable/termination, field-supply, abnormal-condition, schematic-review, PCB and release gates. It must not be presented as schematic-ready or Rev-1-ready. |
| `Bensend/OpenPressBrake/hardware/connections/rev1/J_Y2_SCALE.yaml` | **INCOMPLETE_NOT_STUDENT_MATERIAL** as a finished connector example; usable only as an incompleteness case study | Electrical mapping is explicit, but connector manufacturer/family/MPN, footprint, pad verification, wire/current envelope, placement/orientation, harness facts and physical-machine checks remain unresolved. `board_capture_ready: false` is correct. |
| `Bensend/OpenPressBrake/hardware/blocks/machine_power/engineering.yaml` | **ENGINEERING_REVIEW_NEEDED** before assignment as a finished block | It is the repository's knowledge-format gold standard, but it still contains board/machine inputs that are intentionally TBD and points to incomplete release work. Useful to instructors as a schema example, not a finished electrical design exercise. |
| `Bensend/OpenPressBrake/hardware/blocks/machine_power/STATUS_CHECKLIST.md` | **INCOMPLETE_NOT_STUDENT_MATERIAL** as a completed-design example | It explicitly says `NOT YET SCHEMATIC-READY`; ILIM/dVdT, fault pull-up/receiver, grounding/return topology, field distribution, PCB/current-path and qualification gates remain open. |
| `Bensend/OpenPressBrake/hardware/blocks/maturity_index.yaml` | **VERIFIED_FOR_LESSON** for maturity taxonomy only | It explicitly warns that knowledge maturity is not electrical qualification and records remaining migration/status debt. |

This audit is intentionally strict: a useful engineering artifact can be `VERIFIED_FOR_LESSON` for one teaching claim while still being incomplete for production release.

## Worked architecture trace: one encoder primitive

Start with a generic machine requirement: the board needs one differential incremental encoder input with A, B and Z differential pairs. Do **not** begin with a connector part number or FPGA ball.

The current reusable encoder contract owns the AM26LV32E receiver topology, A/B/Z semantics, protection requirements, optional termination variants, receiver timing envelope, pair/return-path constraints and provenance. It deliberately does not own how many encoders a board needs, which FPGA pins are used, which field connector is fitted, how much aggregate 3.3-V current the board consumes, which encoder is installed, or the cable/remote termination facts.

That separation makes the primitive reusable on a mill spindle encoder, lathe spindle/index encoder, plasma gantry feedback axis, robot joint encoder, press-brake scale, or another automation board without renaming the primitive after a particular machine.

### Resource consequences are outputs of integration

For `N` instantiated encoder primitives, the current contract exposes integration calculations:

- FPGA logic inputs: `3 * N`;
- receiver-package count: `N`;
- maximum receiver 3.3-V current budget contribution: `0.017 A * N`.

Those equations belong to the reusable knowledge package because they describe consequences of instantiation. The selected value of `N`, actual FPGA balls, bank compatibility, field-supply budget, connector count and board placement belong to board integration.

### Machine facts remain machine facts

Termination population cannot be selected merely because the reusable block provides a 120-ohm option. Installed encoder electrical class, cable type/length/impedance, remote-end termination, maximum edge rate and encoder supply current remain machine/configuration evidence. If they are unknown, the correct engineering output is an unresolved gate, not a guessed resistor population.

## Connection-definition role

A board-specific connection definition consumes semantic interfaces and resolves the physical human/machine boundary. It owns the J-number, exact connector and mate, verified footprint/pad numbering, every pin disposition, voltage/current/wire envelope, power/return/shield contacts, source/destination block instance, placement/orientation/service access, silkscreen, and harness destination.

The current Y2 scale connection definition is a useful **failure-to-finish-cleanly** example. It correctly maps every legacy electrical contact and preserves shield/return domains, while refusing to invent the physical connector, footprint, cable, encoder model, termination choice or placement facts. Therefore it is not board-capture-ready. This is desired fail-closed behavior, not a documentation failure.

## Adversarial classification lab

For each statement, assign exactly one primary owner: `REUSABLE_BLOCK`, `MACHINE_CONFIGURATION`, `BOARD_INTEGRATION`, `CONNECTION_DEFINITION`, or `EVIDENCE`.

1. Receiver guaranteed differential sensitivity.
2. Installed encoder maximum edge rate.
3. FPGA package ball used for Encoder 4 Z.
4. J17 printed label `SPINDLE ENC`.
5. Connector mating plug MPN.
6. Number of encoder primitives instantiated on this board.
7. Cable length on the installed machine.
8. Production-circuit bench-test result.
9. Board aggregate 3.3-V current budget.
10. Rule that a termination variant requires machine evidence.
11. Exact pin-to-semantic-net map for a retained harness.
12. Whether an ordinary encoder receives personnel-safety credit.

### Expected reasoning

A correct learner should recognize that 1, 10 and the reusable safety-credit boundary are reusable-contract facts; 2 and 7 are machine facts; 3, 6 and 9 are board-integration facts; 4, 5 and 11 are connection-definition facts; 8 is evidence. If an implementation needs a different ownership split, the learner must explain why rather than silently duplicating authority.

## Catalog stress-test findings

This lesson exposed two important catalog lessons without requiring an electrical redesign:

1. **Knowledge maturity must never be used as release readiness.** The repository already encodes this distinction; curriculum material must preserve it. `ENGINEERED` means the knowledge package is structurally mature, not that PCB/layout/bench/machine qualification is complete.
2. **A partially instantiated connection definition is valuable evidence but not a finished student example.** The current Y2 scale definition demonstrates correct fail-closed behavior, yet cannot be assigned as a completed connector design until physical connector/harness facts are verified.

No OpenPressBrake catalog file was changed in this run because the observed gaps are already represented accurately by current status and `VERIFY_AT_MACHINE` fields. Changing them without machine evidence would weaken the architecture.

## Safety boundary

The ordinary FPGA/LinuxCNC controller may consume encoder feedback, report safety status, implement watchdogs/output inhibits, and interface to enable/STO mechanisms. None of those facts makes this ordinary controller the independent personnel-safety authority. This board-design course teaches the interface boundary; the independent safety curriculum owns safety-function architecture and validation.

## Exit check

The learner passes BD01 only if it can take a new machine requirement and produce a five-column ownership table without embedding connector names into reusable circuitry or moving machine facts into the block. Any unknown physical fact must remain explicit. A learner that resolves ambiguity by guessing has failed the lesson even if the guessed circuit looks plausible.

## Next checkpoint

Build BD02 around **block requirements -> proven-reference/topology selection -> electrical calculations -> protection/default state -> resource declaration**. Before naming any OpenPressBrake block as a finished worked example, open and inspect every referenced current file and classify it with the lesson-readiness labels. Prefer a block whose implementation gates are sufficiently complete to teach calculations and protection without implying production proof. If no such block exists, make the catalog gap itself the exercise rather than lowering the verification rule.
