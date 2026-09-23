# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD54 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD54_SEMANTIC_DEPENDENCY_COVERAGE_MUTATION_TESTING_AND_VALIDATOR_ADEQUACY.md`.

BD54 teaches:

`semantic rules -> validator claims -> targeted mutations -> expected detection -> undetected mutation analysis -> dependency-coverage map -> validator improvement -> adequacy gate`

## BD54 hard student-material audit

Every repository file named to students as finished material by BD54 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `README.md`
- Curriculum `hardware/4000-board-design/BD53_SEMANTIC_MIGRATION_VERIFICATION_GOLDEN_CORPORA_AND_NEGATIVE_COMPATIBILITY_TESTS.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/safety_interface/REV1_STRUCTURAL_COMPOSITION_CONTRACT.yaml`
- OpenPressBrake `hardware/blocks/safety_interface/STATUS_CHECKLIST.md` for its bounded current status/open-gate claims

The safety-interface block itself is not presented as schematic-ready, verified, safety-rated, or Rev-1 released. Its current checklist remains `BEHAVIORAL ONLY — NOT SCHEMATIC-READY` and retains physical-machine/no-bypass and generic additional-handshake work as open.

BD54 itself was re-opened from current main after commit.

## Rules frozen by BD54

- green current-tree validation is not validator adequacy;
- rule existence, check-source existence, authorized execution, and representative fault detection are separate evidence states;
- a rejected mutant proves little unless it is rejected for the intended semantic reason;
- semantic mutations should remain syntactically valid while violating one named engineering meaning;
- engineering dependency coverage is not equivalent to validator source-line coverage;
- every machine-checkable “must not” rule should have a representative negative mutation;
- surviving valid mutants are engineering findings and require classification;
- authority/provenance mutations matter even when electrical values are unchanged;
- `VERIFY_AT_MACHINE` must not become a plausible default merely to close generation;
- reusable-block mutation ownership stays separate from board-integration mutation ownership;
- board-specific composition failures do not justify machine-specific reusable primitives;
- cross-block FPGA/power/bus/connector/generation/HAL consistency needs board-level mutation coverage;
- validator adequacy is scoped to an explicit claim set, never blanket qualification;
- ordinary LinuxCNC/FPGA validation cannot manufacture independent personnel-safety authority;
- executable adequacy evidence, when required, uses only `[self-hosted, openpressbrake]`.

## Worked-example stress test

Current OpenPressBrake `safety_interface/REV1_STRUCTURAL_COMPOSITION_CONTRACT.yaml` publishes a drawing-derived non-safety Rev1 composition: exactly seven protected Pilz-status inputs consuming `digital_input_24v`, six protected operational outputs consuming `digital_output_24v`, seven FPGA inputs, six FPGA outputs, zero direct 24-V field-to-FPGA connections, preserved L7/L07 switched-domain ownership, no L07-to-L06 bridge, wire 75 outside ordinary FPGA command authority, wire 63 outside ordinary OpenPressBrake logic, and no personnel-safety credit assigned to the composition.

BD54 turns those declarations into a mutation plan rather than pretending declaration equals enforcement. Representative future mutations include count drift, aggregate-resource mismatch, direct 24-V FPGA connection, L7/L07-to-L6/L06 domain substitution, removal of the prohibited bridge rule, wire-75 authority escalation, wire-63 ordinary-logic routing, safety-authority manufacture, and replacement of `VERIFY_AT_MACHINE` items with guessed confirmation.

The board-specific seven/six population remains board composition. It does not redefine the reusable digital-input or digital-output primitive channel count.

## Catalog stress-test result

The hard audit exposed a concrete infrastructure gap: the Rev1 structural composition contract states strong fail-closed invariants, but no named validator/mutation-regression evidence was presented alongside it during this run demonstrating automated enforcement of those invariants.

Classification: **ENGINEERING_REVIEW_NEEDED** for automated enforcement/adequacy infrastructure, not for the bounded semantic claims in the inspected contract.

Required future catalog/tooling infrastructure includes stable claim IDs, claim-to-validator mapping, well-formed negative mutations, expected diagnostic identities, exact source/execution provenance, dependency/consumer coverage, and a distinction between validator-source presence and authorized execution evidence.

OpenPressBrake remained read-only because current main is actively reconciling Rev1 safety-interface composition. No active engineering artifact was overwritten.

## Current repository reconciliation

At run start the board-design lane ended at BD53. Curriculum main also contained concurrent non-board-design work; it was preserved. OpenPressBrake current main was `0dc43ab1522dec023f70c5af8e0f7c567969505e` (`safety interface: reconcile Rev1 composition checkpoint`).

BD54 was committed as `db78029ac54b39978f64bbd96ab4ab3de3697a16` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD54 commit and OpenPressBrake remained at `0dc43ab1522dec023f70c5af8e0f7c567969505e`. OpenPressBrake stayed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD55 on **validator evidence provenance, execution identity, and regression-result promotion**:

`validator source + claim set + mutation corpus + exact execution environment -> pinned result identity -> result-to-claim mapping -> stale-result detection -> promotion gate -> release evidence`

Stress the distinction between validator source existing, workflow configuration existing, a run occurring on `[self-hosted, openpressbrake]`, the run testing the intended source/claim/corpus revisions, the diagnostics proving intended semantic detection, and the resulting evidence remaining applicable after semantic/dependency changes.

## Compute

No simulation, synthesis, place-and-route, timing run, mutation executable, or other executable engineering verification was justified for BD54. The lesson creates a mutation/coverage methodology and a concrete mutation plan only. No GitHub-hosted runner was used.

## Safety boundary

BD54 teaches validator adequacy for ordinary board-design and composition authority. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. The worked example explicitly mutation-tests against accidental safety-authority escalation rather than treating ordinary controller checks as safety validation.