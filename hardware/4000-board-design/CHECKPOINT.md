# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD31 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD31_PRODUCTION_TEST_FIXTURE_CONTRACTS_CALIBRATION_AND_SERIALIZED_EVIDENCE.md`

BD31 teaches:

`released/as-built identity -> testable production claims -> fixture interface contract -> test procedure/limit revision -> fixture/calibration identity -> serialized execution -> bounded result/evidence -> deviation/retest disposition -> shipment/installation gate`

## BD31 hard student-material audit

Every repository file named to students by BD31 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD30_MANUFACTURING_PROGRAMMING_COMMISSIONING_HANDOFF_AND_AS_BUILT_RECONCILIATION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/digital_input_24v/manifest.yaml`

The newly created BD31 lesson was re-opened from current main after commit and checked for internal consistency.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `digital_input_24v` remains `SIMULATION-READY`, not `SCHEMATIC-READY` or `REV 1 READY`; PCB/layout review, complete BOM/cost, shared-resource closure, and human Rev-1 signoff remain open;
- OpenPressBrake has no repository-wide production-test/fixture/calibration/serialized-evidence schema;
- current engineering development is not evidence of a production fixture, production serial population, production calibration program, or shipment authority.

No inspected file is used to claim complete OpenPressBrake production readiness.

## Rules frozen by BD31

- production-screen evidence and design-qualification evidence are different evidence classes;
- a qualified design does not prove a particular serialized unit conforms;
- reusable blocks own generic test requirements, not board J-numbers or fixture pogo-pin mappings;
- fixtures have explicit compatibility/interface contracts against released board/connection-definition revisions;
- a fixture that physically connects is not thereby compatible;
- test limits are versioned engineering inputs bound to the semantic revision that justifies them;
- a measurement inside an obsolete limit does not create current release evidence;
- reusable fixture conditioning/translation is real circuitry and must not be hidden as unqualified wiring;
- production tests must stimulate/observe enough of the causal field path to prove the named claim;
- command-side or forced-FPGA tests do not prove field circuitry that they bypass;
- calibration write/readback success is not calibration traceability unless the value is bound to the correct serialized unit, procedure, reference and configuration;
- failed production evidence survives rework/retest;
- FCT/production-screen PASS is not shipment or installation authority by itself;
- ordinary safety-status production checks prove only the bounded ordinary electrical/status claim tested.

## Current OpenPressBrake worked-example result

The current `digital_input_24v` manifest is a useful bounded example of the correct reusable test boundary. It publishes generic `FIELD_INPUT_24V`, `FIELD_RETURN`, `INPUT_STATE`, `INPUT_VALID`, a generic `DIGITAL_INPUT_FIELD_PAIR` connector requirement, FPGA 3V3 resource needs, return/isolation semantics, and PCB constraints while explicitly leaving physical connector selection to board integration.

Its status checklist remains truthfully `SIMULATION-READY`. That makes it suitable for teaching how a future production test requirement could say "stimulate the released field-input interface and observe the logic-side state" without hard-coding a particular board connector or fixture pogo pin into the reusable block. It is not presented as a finished production block.

No OpenPressBrake engineering file was changed during BD31.

## Current repository reconciliation

BD31 was committed as `315370369a6128d6a1d92be8635355581bc343bc` and re-opened from current main.

Immediately before this checkpoint write, current main was re-read in both repositories. Curriculum main was `315370369a6128d6a1d92be8635355581bc343bc`; the prior safety-lane commits were preserved and no overlapping post-BD31 board-design change was present. OpenPressBrake main was `dc821b0481ee131055af47169f9e9d47cbea6d5a` (`digital input: publish ISO1212 3V3 packing power contract`) and remained read-only because active engineering is adjacent to the worked example.

## Catalog stress-test result

BD31 exposes a concrete infrastructure gap: production/release traceability needs a machine-readable layer joining released/as-built identity to generic block test requirements, board-specific fixture mappings, fixture hardware/software revisions, fixture adapter identities, test procedure and limit provenance, fixture/instrument calibration, unit calibration, serialized raw/results evidence, and rework/retest history.

Do not solve this by adding fixture pogo-pin numbers, board J-numbers, machine destinations, or fixture-only conditioning to reusable product-block contracts. Fixture mapping is manufacturing integration; genuine reusable fixture conditioning deserves its own engineered fixture-adapter contract.

A mature system should be able to answer `SHOW TEST REQUIREMENTS`, `SHOW FIXTURE APPLICABILITY`, and `SHOW TEST EVIDENCE FOR UNIT`, and mark evidence stale when a consumed semantic facet, board connection definition, limit set, fixture adapter, or calibration state changes.

## Next exact work

Build BD32 on **production-test coverage models, escape analysis, and design-for-test feedback**.

Teach the flow:

`released failure modes/critical claims -> stimulatable/observable boundaries -> production-screen coverage -> untestable/indirectly tested claims -> escape risk -> 100% versus sampled screening -> fixture self-diagnostics -> retained evidence -> DFT/catalog feedback`

The adversarial lab should include:

- an output whose FPGA command and fixture relay both toggle while the product field driver remains unobserved;
- an input test that proves logic state but cannot distinguish a marginal field threshold from a healthy channel;
- a shared power/resource defect that one-at-a-time channel tests miss;
- an isolation/return fault hidden by a fixture that unintentionally ties returns together;
- a fixture self-test that passes but does not exercise the measurement range used by product acceptance;
- a failure mode covered only by qualification, not economically by every-unit production screening;
- a sampled test incorrectly treated as evidence that every serialized unit passed;
- a recurring production escape that should feed back into block/board design-for-test rather than only tightening operator instructions.

Require students to distinguish coverage of a failure mode from mere execution of a test step, direct from indirect evidence, product observability from fixture observability, qualification-only claims from every-unit screening, and DFT changes that belong in reusable blocks versus board integration.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD31. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD31 teaches production-test traceability for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, diagnostic coverage of a safety function, stopping performance, final-element validation, or independent personnel-safety authority. A production pass on an ordinary safety-status receiver proves only the bounded ordinary-interface claim actually tested.