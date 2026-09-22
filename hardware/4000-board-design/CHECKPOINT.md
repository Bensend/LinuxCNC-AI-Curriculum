# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD32 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD32_PRODUCTION_TEST_COVERAGE_ESCAPE_ANALYSIS_AND_DFT_FEEDBACK.md`

BD32 teaches:

`released failure modes/critical claims -> stimulatable/observable boundaries -> coverage classification -> escape analysis -> 100%/sampled/qualification-only decision -> fixture self-diagnostics -> retained evidence -> DFT/catalog feedback`

## BD32 hard student-material audit

Every repository file named to students by BD32 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD31_PRODUCTION_TEST_FIXTURE_CONTRACTS_CALIBRATION_AND_SERIALIZED_EVIDENCE.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/manifest.yaml`

The newly created BD32 lesson was re-opened from current main after commit and checked for internal consistency.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `digital_output_24v` reusable non-isolated variant remains `SIMULATION-READY`; the Rev1 isolated board path is not yet `SCHEMATIC-READY` and exact isolated-path CAD/connectivity, fault/abnormal qualification, PCB thermal/current evidence, integration and human release remain open;
- OpenPressBrake has no repository-wide production failure-mode/claim-to-coverage model;
- reusable manifests do not yet have a standardized generic DFT/observability section separated from board-specific test-point/fixture mapping;
- current engineering development is not evidence of a production fixture, serialized production population, production acceptance limits, or shipment authority.

No inspected file is used to claim complete OpenPressBrake production readiness.

## Rules frozen by BD32

- executing a test step does not prove coverage of a failure mode;
- correlated observation is not automatically direct coverage;
- command-side activity does not prove field-driver behavior;
- one nominal stimulus does not prove threshold/margin coverage;
- one-channel-at-a-time success does not prove shared-resource behavior;
- fixture wiring must not mask return/isolation/bias/power defects in the product;
- fixture self-test has a declared range/envelope and does not prove untested acceptance ranges;
- sampled evidence is population/process evidence, not a serialized PASS for every untested unit;
- qualification-only and production-screen claims remain separate;
- recurring production escapes are design feedback but do not automatically justify modifying a reusable block;
- generic recurring observability needs may belong in a reusable block; board-specific pads/pins/mappings remain integration/manufacturing authority;
- DFT hooks must preserve default state, authority, return domains, protection and safety boundaries;
- production-test coverage percentages are not safety diagnostic coverage.

## Current OpenPressBrake worked-example result

The current `digital_output_24v` manifest is a useful bounded coverage example because it publishes `OUTPUT_COMMAND`, field `OUTPUT_24V`/`LOAD_RETURN`, overload/overtemperature diagnostics, FPGA resource demand, shared `FIELD_24V_PROTECTED`/`LOGIC_3V3`/`FIELD0` resources, and explicit block/integration verification questions.

That structure lets a student reason about causal coverage without inventing a board connector or fixture. It also exposes why one-at-a-time or command-only tests can miss field-path and shared-resource defects. The manifest still leaves board channel current, inrush, duty, simultaneous-instance assumptions, connector rating and PCB current/thermal limits unresolved, so BD32 does not invent production limits.

No OpenPressBrake engineering file was changed during BD32.

## Current repository reconciliation

BD32 was committed as `97d8a313b21c3fa5f58303c8e2a3b55423fa1ba1` and re-opened from current main.

Immediately before this checkpoint write, current main was re-read in both repositories. Curriculum main was `97d8a313b21c3fa5f58303c8e2a3b55423fa1ba1`; the newer safety-lane timing/progress commits were preserved and no overlapping post-BD32 board-design change was present. OpenPressBrake main was `2b27aafa9ecb805ba8415d5b8c34f0ad1b3778df` (`infrastructure: trigger panel control from owner issues`). The newest hardware engineering immediately below it includes RS-485 and digital-output packing work, so OpenPressBrake remained read-only.

## Catalog stress-test result

BD32 exposes two concrete infrastructure gaps:

1. the production-test layer needs a machine-readable failure-mode/semantic-claim-to-coverage matrix linking stimulus, observation, masking controls, coverage class, screening scope and retained serialized evidence; and
2. reusable block contracts need a standardized place for generic DFT/observability requirements when intrinsic to the reusable function, while board-specific test pads, J-numbers, pogo pins and fixture mappings remain integration/manufacturing authority.

Do not solve these gaps by putting fixture details or machine-specific production limits into reusable block manifests. Do not call a test `DIRECT` merely because it usually detects a defect.

## Next exact work

Build BD33 on **production escape containment, nonconformance trends, and catalog feedback without corrupting qualification evidence**.

Teach the flow:

`serialized escape -> containment -> affected release/as-built population -> defect ownership -> trend/common-cause analysis -> corrective design/process action -> evidence invalidation/regression -> effectiveness check -> release/field applicability`

The adversarial lab should include a repeated solder/open defect that is board/process-owned, a generic block weakness revealed across multiple boards, a fixture-induced false failure trend, a supplier substitution trend with incomplete lot identity, a field escape whose affected population cannot initially be bounded, an apparent common-cause issue that is actually two mechanisms, a corrective action that passes locally but leaves dependent evidence stale, and an ordinary safety-status interface trend that must not be promoted into unsupported safety validation claims.

Require students to preserve negative evidence, distinguish occurrence trend from design qualification, classify ownership before redesign, use release/as-built/installed identity to bound containment, and prove corrective-action effectiveness without erasing the original failure history.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD32. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD32 teaches production-test coverage and DFT for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, or independent personnel-safety authority. Production coverage of a safety-status receiver proves only the bounded ordinary-interface claim actually tested.