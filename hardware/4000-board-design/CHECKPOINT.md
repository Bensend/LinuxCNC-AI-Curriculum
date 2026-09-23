# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD48 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD48_CONFIGURATION_SELECTION_CLOSURE_AMBIGUITY_RESOLUTION_AND_FAIL_CLOSED_BOARD_GENERATION.md`.

BD48 teaches:

`eligible authorities -> exact configuration intent -> compatibility/constraint solving -> ambiguity detection -> explicit selection/VERIFY_AT_MACHINE -> deterministic board/resource output -> provenance lock -> generation audit`

## BD48 hard student-material audit

Every repository file named to students as finished material by BD48 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD47_AUTHORITY_STATE_PROPAGATION_SUPERSESSION_SAFE_DISCOVERY_AND_CONFIGURATION_CONSUMPTION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/machine_power/design/REV20_5V_ANALOG_CAPACITANCE_AND_BUCK_STARTUP_BOUNDARY.md` for current board-level startup/capacitance accounting and its explicit unresolved gates
- OpenPressBrake `hardware/blocks/machine_power/STATUS_CHECKLIST.md` for current incomplete machine-power status and remaining ILIM/dVdT, core-load, exact-connectivity, PCB/integration, and release work

The machine-power material is bounded board-integration evidence, not proof that `machine_power` is schematic-ready, production-proven, safety-rated, or `REV 1 READY`. The newly created BD48 lesson was re-opened from current main after commit and checked against these inspected sources.

## Rules frozen by BD48

- individually eligible artifacts are not automatically jointly feasible;
- catalog content does not define machine requirements;
- hard constraints, engineering preferences, and unknown physical facts are distinct input classes;
- an unknown physical fact is not a free design variable and remains `VERIFY_AT_MACHINE`/blocked unless the design truthfully covers all admissible cases;
- first valid match is not a justified selection when multiple valid candidates remain;
- configuration solving should report `UNIQUE_VALID_SELECTION`, `MULTIPLE_VALID_SELECTIONS`, `NO_VALID_SELECTION`, or `BLOCKED_UNKNOWN_FACT` rather than hiding ambiguity;
- connection blocks own board-specific connector/pin/mapping/location/label facts, not hidden electrical transformation circuitry;
- resource aggregation must preserve topology, domains, startup modes, package sharing, bank constraints, and return/current-path semantics;
- a right numeric total on the wrong electrical node is not a valid resource budget;
- partial deterministic accounting may be consumed without falsely closing unresolved component/configuration decisions;
- deterministic generation requires an exact selection lock over intent, authorities, connection blocks, decisions, resource allocations, generator/schema version, and output identity;
- generation success does not establish engineering closure;
- a uniquely solvable ordinary-controller configuration does not establish independent personnel-safety validation;
- required executable verification uses only `[self-hosted, openpressbrake]`; unavailable authorized compute remains `BLOCKED/NOT_RUN`.

## Worked-example stress test

Current OpenPressBrake machine-power Rev20 provides a bounded real partial-closure example. It freezes 15.3 uF nominal direct `5V_ANALOG` capacitance as a downstream LMR36520 startup load and 4.92 uF nominal direct `24V_LOGIC_PROTECTED` capacitance as the present simple TPS26633 protected-node inventory. Those values must not be summed across the buck as if they occupy one electrical node.

The same current evidence explicitly leaves final TPS26633 dVdT unresolved pending effective 5-V MLCC capacitance, LMR36520 startup behavior into the real load/network, and final FPGA/core startup demand. The status checklist also leaves TPS26633 ILIM/dVdT, FPGA-core power, remaining low-voltage load aggregation, exact connectivity, PCB/integration qualification, and human release open.

BD48 uses this to teach that automation may deterministically consume already frozen topology/accounting facts while refusing to fabricate a final component/programming decision from unresolved physical/electrical constraints.

## Catalog stress-test result

BD48 exposes a missing machine-readable **configuration-selection closure layer** above authority-state filtering. It should combine exact board/machine intent, eligible block/adapter authorities, board-specific connection blocks, topology-aware FPGA/bus/power/connector constraints, preferences, unresolved machine facts, explicit ambiguity state, decision rationale, and generation provenance.

The worked example adds a key requirement: selection infrastructure must support **partial closure** so known resource/topology facts can advance without converting unresolved effective-capacitance/startup evidence into false finality.

Proposed infrastructure remains `ENGINEERING_REVIEW_NEEDED`.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD47. Curriculum main also contained concurrent safety-course work, which remained intact. OpenPressBrake had advanced beyond the prior motor-drive handoff into active machine-power and digital-input Rev-1 reconciliation.

BD48 was committed as `5338c8c32f4d45a3c83b5b8c4add7260d02104d7` and re-opened from current main. Immediately before this checkpoint write, curriculum main had BD48 as its newest commit. OpenPressBrake current main was `2f41212b5405c3d62fa4d41f23258905c9044eb4` (`digital input: reconcile Rev1 EMC release gate`). OpenPressBrake was consumed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD49 on **configuration change control, deterministic regeneration, and semantic diff review**:

`locked configuration -> requested change -> semantic intent diff -> affected authority/resource set -> re-solve -> deterministic regeneration -> semantic output diff -> targeted verification -> promotion/release decision`

Stress a one-channel population change that alters shared-package packing, a connector-only mapping change that must not trigger block redesign, an upstream block contract change that invalidates generated resource evidence, an apparently identical regenerated schematic produced from different authority inputs, and a safety-related interface change whose ordinary-controller diff review must not be represented as safety validation.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD48. No GitHub-hosted runner was used.

## Safety boundary

BD48 teaches configuration closure and deterministic generation for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. A uniquely resolved status monitor, watchdog, inhibit, STO request, or interface remains an ordinary-controller function unless a separate safety-rated design and validation establishes more.
