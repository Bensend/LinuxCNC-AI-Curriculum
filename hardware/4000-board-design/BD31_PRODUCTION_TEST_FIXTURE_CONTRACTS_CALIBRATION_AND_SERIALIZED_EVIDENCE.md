# BD31 — Production Test Architecture, Fixture Contracts, Calibration Identity, and Serialized Evidence

## Purpose

BD30 separated released design identity from as-built and installed identity. BD31 adds the production-test layer without confusing screening with qualification.

The governing flow is:

`released/as-built identity -> testable production claims -> fixture interface contract -> test procedure/limit revision -> fixture/calibration identity -> serialized execution -> bounded result/evidence -> deviation/retest disposition -> shipment/installation gate`

This lesson develops both linked skills:

1. **block engineering** — publish generic, reusable test requirements at the block contract boundary without embedding board connector numbers or fixture wiring; and
2. **board integration** — map those requirements through the released board connection definitions into a controlled fixture, limits, programming/calibration records, serialized evidence, and release/shipment decisions.

OpenPressBrake is a worked governance example, not a production-released example. Nothing here claims that the current controller or any current fixture is production-proven.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD30_MANUFACTURING_PROGRAMMING_COMMISSIONING_HANDOFF_AND_AS_BUILT_RECONCILIATION.md` — released/as-built/programmed/installed identity and deviation preservation.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD31 — exact lane assignment.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — evidence truthfulness and separation of integration readiness from full Rev-1 qualification.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable block, adapter, and board-integration ownership.
- OpenPressBrake `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md` — current ISO1212 evidence scope and unresolved release gates.
- OpenPressBrake `hardware/blocks/digital_input_24v/manifest.yaml` — current reusable field/input logic interface, connector requirement, FPGA resource and PCB requirement data.

The current `digital_input_24v` block is **not** assigned as a finished production block. Its current status is `SIMULATION-READY`; PCB/layout review, complete BOM/cost, shared-resource closure, and human Rev-1 signoff remain open. It is used only as a bounded example of a reusable block publishing generic field-side and logic-side testable interfaces while physical connector selection remains board integration. Its finished-student-material classification remains `ENGINEERING_REVIEW_NEEDED`.

---

## 1. Production screening and qualification answer different questions

Qualification asks whether a design satisfies a declared engineering envelope. Production screening asks whether a particular manufactured unit conforms to the released/as-built configuration and selected production acceptance criteria.

A production test may reuse methods or limits derived from qualification, but it does not automatically recreate qualification evidence.

Freeze:

> **PRODUCTION TEST PASS != DESIGN QUALIFICATION**

Likewise, a qualified design does not prove that a particular manufactured board was assembled, programmed, calibrated, or connected correctly.

> **QUALIFIED DESIGN != CONFORMING SERIALIZED UNIT**

## 2. Derive production claims from released authority

Before designing a fixture, name the claims that production test must screen. Examples include:

- correct power-rail behavior within a released acceptance window;
- field input transition reaches the intended FPGA-side state;
- commanded output causes the intended field-side electrical response;
- default/de-energized state is correct;
- programmed image identity matches the released configuration;
- required calibration data is written, read back, and bound to the unit;
- board-specific connector mapping matches the released connection definition.

Each claim should identify its owning release facet and evidence class. Do not invent a production limit merely because the fixture can measure something.

## 3. Generic block test requirements stop at the reusable contract

A reusable block may publish requirements such as:

- stimulus interface/class;
- expected observable interface;
- polarity/direction;
- valid operating range or threshold class;
- default state;
- isolation/return constraints relevant to test;
- test points or observability requirements when intrinsic to the generic function;
- calibration requirement when calibration is intrinsic to the reusable function.

It should not publish the first board's J-number, fixture pogo-pin number, harness color, bed-of-nails location, or machine destination.

The inspected OpenPressBrake `digital_input_24v` manifest demonstrates this boundary: it publishes `FIELD_INPUT_24V`, `FIELD_RETURN`, `INPUT_STATE`, a generic `DIGITAL_INPUT_FIELD_PAIR` connector requirement, FPGA-side 3V3 logic, and field-return semantics while explicitly leaving physical connector selection to board integration.

Freeze:

> **GENERIC TEST REQUIREMENT != FIXTURE PIN MAP**

## 4. The fixture has its own interface contract

A fixture contract must identify at least:

- fixture hardware identity/revision;
- compatible product release/connection-definition revisions;
- product-side connector/pogo/harness mapping;
- fixture-side supplies, returns, loads and measurement references;
- allowed stimulus envelope;
- measurement accuracy/resolution where relevant to acceptance limits;
- protection/current limiting;
- default state when fixture control is absent;
- fixture firmware/software identity when behavior depends on it;
- calibration requirements and calibration identity;
- any fixture adapter/conditioning stages;
- known exclusions and `UNKNOWN`/out-of-scope conditions.

A fixture that can physically plug into a board is not automatically compatible with that board revision.

Freeze:

> **FIXTURE CONNECTS != FIXTURE CONTRACT MATCHES**

## 5. Obsolete mapping must fail closed

If a board connection definition changes while the generic reusable block remains electrically unchanged, generic block qualification may remain current but the fixture mapping can become stale.

A fixture wired to an old J-number/pin assignment must not inherit compatibility merely because the same signal names exist somewhere on the new board.

Required disposition:

`product release -> connection-definition revision -> fixture mapping revision -> compatibility result`

If the mapping cannot be proved current, result is `FIXTURE_MAPPING_STALE` or `UNRESOLVED`, not PASS.

## 6. Test limits are versioned engineering inputs

Every acceptance limit must trace to the semantic revision that justifies it. Store enough identity to answer:

- which released claim generated this limit?
- which units and conditions apply?
- which test-procedure revision consumes it?
- what invalidates it?

A current board tested with a stale limit can produce a numerically valid measurement and still yield invalid release evidence.

Freeze:

> **MEASUREMENT IN RANGE != CURRENT LIMIT APPLICABLE**

## 7. Hidden fixture conditioning is still real circuitry

A fixture may contain relays, buffers, dividers, isolators, current sources, loads, level translation, filters, protection, or protocol conversion. Classify this circuitry rather than calling all of it wiring.

- Board-specific pin breakout or pogo routing belongs to the fixture mapping.
- Generic reusable electrical transformation that materially affects stimulus/measurement deserves an independently specified and qualified fixture adapter/interface module.
- Product circuitry must never be modified merely to simplify the fixture.

This mirrors the OpenPressBrake block/adapter/integration rule.

Freeze:

> **FIXTURE CIRCUITRY != FREE UNQUALIFIED GLUE**

## 8. Test the causal path, not only the command bit

For an output, observing an FPGA/HAL command proves only the command state. It does not prove the driver, protection, connector path, fixture load, or field-side response.

For an input, toggling an internal FPGA signal proves neither the field receiver nor connector path. Stimulus must enter at the boundary needed by the production claim and observation must occur far enough downstream to cover that claim.

The current OpenPressBrake digital input is a useful bounded example: a production-screen requirement for the physical input path would need board-specific fixture mapping to the released field connector, field stimulus consistent with the released input envelope, and observation of the resulting logic-side state. Merely forcing `INPUT_STATE` in FPGA logic would bypass the product circuitry being screened.

Freeze:

> **COMMAND-SIDE PASS != FIELD-PATH PASS**

## 9. Calibration is identity, not just a successful write

When a unit-specific calibration constant exists, preserve:

`serialized unit -> hardware/release identity -> calibration procedure revision -> reference/instrument identity -> raw observations -> derived constant -> written value -> readback -> applicable firmware/configuration -> date/operator/system identity -> status`

Writing a plausible number successfully is not proof that the number belongs to this board.

Freeze:

> **CALIBRATION WRITE SUCCESS != CALIBRATION TRACEABILITY**

If fixture calibration affects acceptance accuracy, fixture/instrument calibration identity and validity must also be captured.

## 10. Serialized evidence must bind all causally relevant identities

A production-test record should bind at least:

```yaml
unit_id: BUILD.A00173
claimed_release: REL.CONTROLLER_A.R1.0007
as_built_revision: BUILDREC.A00173.R2
fixture_id: FIX.CONTROLLER_A.FCT.03
fixture_hw_revision: R4
fixture_fw_hash: sha256:...
fixture_mapping_revision: MAP.R1.0007.02
test_procedure_revision: TP.CONTROLLER_A.12
test_limit_set_revision: LIM.CONTROLLER_A.09
fixture_calibration_id: CAL.FIX03.2026-09
programmed_fpga_hash: sha256:...
unit_calibration_id: CAL.A00173.01
result: PASS
open_deviations: 0
shipment_gate: ELIGIBLE_SUBJECT_TO_OTHER_RELEASE_GATES
```

A PASS with missing material identity is not equivalent to a fully traceable PASS.

## 11. Failed evidence survives rework and retest

If a unit fails, preserve the original result. Record finding/disposition, rework, affected configuration identity, and regression/retest result as new evidence.

Do not replace FAIL with PASS in place.

Freeze:

> **RETEST PASS != ORIGINAL FAILURE NEVER HAPPENED**

The resulting unit may be acceptable after approved rework and successful regression, but its evidence history remains causal and auditable.

## 12. Shipment/install gate composes more than production test

Production test can be one required release gate. It does not erase unresolved configuration deviations, stale programming identity, open qualification evidence, required machine verification, or other release blockers.

Use bounded states such as:

- `PRODUCTION_SCREEN_PASS`;
- `PRODUCTION_SCREEN_FAIL`;
- `EVIDENCE_IDENTITY_INCOMPLETE`;
- `FIXTURE_MAPPING_STALE`;
- `CALIBRATION_TRACEABILITY_BLOCKED`;
- `SHIPMENT_BLOCKED_OTHER_RELEASE_GATE`.

Freeze:

> **FCT PASS != SHIPMENT/INSTALLATION AUTHORITY BY ITSELF**

## 13. Cross-machine reuse

The same reusable digital-input, encoder, analog-output, relay, or communications block may appear in a mill, lathe, plasma table, router, robot, press brake, or custom cell.

The reusable block should carry generic test requirements. Each released board owns connector/population/resource mapping, and each production fixture owns the physical means of exercising that released mapping.

Do not create machine-specific variants of a generic block solely to make fixture documentation convenient.

## 14. Safety boundary

A production check may prove that an ordinary controller's safety-status receiver is populated, electrically connected, programmed, and reports the expected ordinary status under the tested stimulus. It does not establish safety integrity, PL/SIL/category, diagnostic coverage, stopping performance, final-element behavior, or independent personnel-safety validation.

Freeze:

> **SAFETY-STATUS INPUT PRODUCTION PASS != SAFETY FUNCTION VALIDATED**

---

## Lab — eight adversarial production-test cases

Use a fictional released controller family with two board variants, reusable blocks, board-specific connection definitions, controlled FPGA/HAL artifacts, a bed-of-nails fixture, a field-I/O fixture, and serialized production records.

Disposition these cases:

1. **Obsolete fixture mapping.** Fixture is electrically healthy but wired to the previous connection-definition revision.
2. **Stale limit set.** Measurement passes the old limit while the current semantic revision narrowed the acceptance window.
3. **Unbound calibration.** Calibration value writes and reads back successfully but the record cannot prove which serialized board generated it.
4. **Hidden fixture adapter.** A reusable fixture daughtercard performs level translation/filtering but has no independent contract or qualification.
5. **Command-only escape.** Output command bit toggles correctly while the field driver/connector path is open.
6. **Rework/retest.** Unit fails, is reworked, then passes; student must preserve both evidence records and disposition.
7. **Cross-machine reuse.** One generic input block appears on a router and press-brake controller with different connectors; keep the generic production requirement reusable while fixtures own mapping.
8. **Safety-status input.** Production screen proves ordinary electrical/status function only; student must state what safety claims remain unproved.

For each submit:

- testable released claim and semantic revision;
- evidence class: qualification or production screen;
- unit/release/as-built identity;
- reusable block test requirement;
- board-specific fixture mapping;
- fixture hardware/software/adapter identity;
- fixture and instrument calibration state;
- procedure and limit-set revision;
- stimulus boundary and observed boundary;
- result and raw evidence reference;
- finding/rework/retest chain if applicable;
- shipment/install gate result;
- unresolved facts and exact next evidence;
- safety-authority statement.

### Lab pass criteria

A passing submission must keep qualification and production screening separate; keep reusable test requirements free of board connector data; fail closed on stale fixture mappings/limits/calibration identity; classify real fixture conditioning as engineered circuitry; cover the causal field path required by the claim; preserve failed evidence after rework; bind calibration and programmed identity to the serialized unit; and preserve the independent safety boundary.

---

## Catalog stress-test result

BD31 exposes a concrete infrastructure pressure: OpenPressBrake has useful block contracts and verification artifacts, but no repository-wide production-test schema that joins released/as-built identity to generic block test requirements, board-specific fixture mappings, fixture hardware/software revisions, test-limit provenance, fixture calibration, unit calibration, serialized raw/results evidence, and rework/retest history.

That missing layer belongs to manufacturing/release traceability. Do **not** solve it by adding fixture pogo-pin numbers, board J-numbers, or machine destinations to reusable block manifests.

A future implementation should support `SHOW TEST REQUIREMENTS`, `SHOW FIXTURE APPLICABILITY`, `SHOW TEST EVIDENCE FOR UNIT`, and invalidation when a consumed semantic facet, connection definition, limit set, fixture adapter, or calibration state changes.

Current OpenPressBrake activity is still engineering development. No production fixture, production serial population, production calibration record, or shipment authority is invented here.

## Compute

No simulation, FPGA synthesis/place-and-route, timing/resource check, or executable verification is required to establish this methodology. No hosted compute is used. Future executable verification remains restricted to the self-hosted runner `[self-hosted, openpressbrake]` when a named engineering question justifies it.

## Next lesson pressure

BD32 should cover **production-test coverage models and escape analysis**:

`released failure modes/critical claims -> observable/stimulatable boundaries -> production-screen coverage -> untestable/indirectly-tested claims -> escape risk -> sampling versus 100% screening -> diagnostic coverage of fixture itself -> evidence retention -> feedback into block/board design-for-test`

The adversarial question is whether a green production test is green because the product was adequately screened or merely because the fixture could not observe the defect.