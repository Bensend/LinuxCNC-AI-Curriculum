# BD32 — Production-Test Coverage, Escape Analysis, and Design-for-Test Feedback

## Purpose

BD31 established traceable production tests. BD32 asks the harder question: **what defects can those tests actually detect?**

The governing flow is:

`released failure modes/critical claims -> stimulatable/observable boundaries -> coverage classification -> escape analysis -> 100%/sampled/qualification-only decision -> fixture self-diagnostics -> retained evidence -> DFT/catalog feedback`

This develops both linked skills:

1. **block engineering** — publish generic observability/stimulus needs and improve reusable circuitry when recurring production blind spots reveal a generic design defect; and
2. **board integration** — map those needs through connection definitions, shared resources, fixtures, test points and production strategy without contaminating reusable blocks with board-specific fixture details.

OpenPressBrake is a worked engineering-governance example, not a production-released example.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD31_PRODUCTION_TEST_FIXTURE_CONTRACTS_CALIBRATION_AND_SERIALIZED_EVIDENCE.md` — production-test identity, fixture contracts, causal-path testing and evidence preservation.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD32 — exact board-lane assignment.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — evidence truthfulness and separation of integration readiness from full qualification.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block, adapter and integration ownership.
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — current output-path evidence scope and unresolved qualification/release gates.
- OpenPressBrake `hardware/blocks/digital_output_24v/manifest.yaml` — current generic field output, command/fault interfaces, FPGA resources, shared resources, test requirements and unresolved electrical/PCB envelope.

The current `digital_output_24v` is **not** assigned as finished student production hardware. Its reusable non-isolated variant is `SIMULATION-READY`; the Rev1 isolated board path is not yet `SCHEMATIC-READY`, and exact isolated-path CAD/connectivity, fault qualification, PCB thermal/current evidence, integration and human release remain open. Classification for finished production use: `ENGINEERING_REVIEW_NEEDED`.

---

## 1. Test execution is not coverage

A test step covers a failure mode only when the chosen stimulus and observation can distinguish that failure from an acceptable unit with adequate confidence.

Freeze:

> **TEST STEP EXECUTED != FAILURE MODE COVERED**

For every critical claim or credible production defect, record:

- failure mode;
- affected semantic claim;
- stimulus entry boundary;
- observation boundary;
- expected defect signature;
- masking conditions;
- coverage class;
- evidence retained.

## 2. Build a coverage matrix from causal paths

Use at least these coverage classes:

- `DIRECT` — production stimulus and observation traverse the defect-sensitive causal path;
- `INDIRECT` — correlated evidence exists, but the defect is not uniquely or fully observed;
- `STRUCTURAL` — inspection/connectivity/identity evidence covers assembly structure rather than operating behavior;
- `QUALIFICATION_ONLY` — justified at design/envelope qualification, not screened on every unit;
- `SAMPLED` — screened only on a controlled sample with an explicit sampling rationale;
- `UNCOVERED` — no adequate current production evidence.

Do not turn `INDIRECT` into `DIRECT` because the test usually catches failures.

> **CORRELATED OBSERVATION != DIRECT COVERAGE**

## 3. Stimulate and observe across the claimed path

The current OpenPressBrake output contract exposes `OUTPUT_COMMAND`, field-side `OUTPUT_24V`/`LOAD_RETURN`, and overload/overtemperature diagnostics. A test that observes only `OUTPUT_COMMAND` cannot cover the field driver, field supply, connector path, or load-current behavior. A fixture relay clicking also does not prove the product field output unless the product path caused that response.

For a production claim such as “commanded channel produces the released field response,” stimulus must enter upstream of the product function under test and observation must occur at a boundary that includes the product circuitry claimed.

> **COMMAND TOGGLES != FIELD DRIVER COVERED**

## 4. Threshold and margin defects need discriminating stimuli

A binary input can appear healthy at one generous stimulus while its switching threshold has drifted dangerously close to an acceptance boundary. Likewise an output may switch a tiny fixture load while failing its released production-load screen.

Where production acceptance depends on a threshold or margin, choose stimuli around the released acceptance region with fixture uncertainty included. If every-unit measurement is not justified, classify the claim honestly as sampled or qualification-only.

> **ONE NOMINAL POINT != THRESHOLD MARGIN COVERAGE**

## 5. Shared resources require simultaneous or adversarial loading where justified

One-channel-at-a-time testing can miss defects in shared regulators, returns, protection, clocks, buses, connector commons, thermal paths, or simultaneous-resource assumptions.

The inspected output manifest explicitly declares shared `FIELD_24V_PROTECTED`, `LOGIC_3V3`, `FIELD0`, FPGA resources, and board-level simultaneous-output/thermal tests. Therefore a production strategy must ask which shared-resource assembly defects are visible under sequential channel tests and which require concurrent loading or another direct observation.

> **EACH CHANNEL PASSES ALONE != SHARED RESOURCE COVERED**

Do not invent a simultaneous-channel production current for OpenPressBrake; the manifest still marks channel current, duty, inrush and simultaneous-instance assumptions as unresolved board/integration parameters.

## 6. The fixture must not mask the defect

Fixtures can accidentally improve the product:

- tying isolated or intentionally separate returns together;
- adding pull-ups/pull-downs that hide missing product bias;
- supplying a rail that the product should generate;
- bypassing a connector or protection element;
- filtering noise or transients the product must tolerate;
- providing an alternate ground/current path.

A coverage review therefore traces current and reference paths through **product plus fixture**, not product alone.

> **FIXTURE-AIDED PASS != PRODUCT-PATH COVERAGE**

An isolation/return test is invalid if the fixture itself defeats the isolation/return condition being evaluated.

## 7. Fixture self-diagnostics have their own coverage envelope

Fixture self-test should prove the fixture functions needed to trust product acceptance, including where relevant:

- stimulus source range and current limit;
- switching matrix continuity/isolation;
- measurement-channel range and reference;
- programmable load behavior;
- fixture adapter identity;
- stuck relay/open pogo detection;
- software/firmware identity;
- calibration validity.

But a fixture self-test at 5 V does not prove a 24 V measurement path across its actual acceptance range.

> **FIXTURE SELF-TEST PASS != ALL ACCEPTANCE RANGES VERIFIED**

## 8. Decide 100%, sampled, and qualification-only screening explicitly

Not every qualified property belongs in every-unit production test. Classify deliberately.

Use **100% screening** when the failure is plausibly introduced by manufacture/programming/assembly, materially affects conformance, and can be screened safely and economically with meaningful coverage.

Use **sampled screening** only with an explicit population/process rationale and retained sample identity. A sampled pass is population/process evidence; it is not a serialized pass for untested units.

Use **qualification-only** where the property is principally a design-envelope characteristic, destructive or impractical to screen, and production controls plus other evidence adequately preserve the design assumption.

> **SAMPLE PASS != EVERY UNIT TESTED**

Examples that are often qualification rather than every-unit screens include destructive fault survival and full thermal-envelope characterization. The exact classification remains product/process specific.

## 9. Escape analysis starts with plausible undetected defects

For each `INDIRECT`, `SAMPLED`, `QUALIFICATION_ONLY`, or `UNCOVERED` item, ask:

1. What defect could escape?
2. How could it be introduced?
3. What existing control might detect it?
4. What consequence follows if it escapes?
5. Is the residual risk acceptable for this ordinary controller claim?
6. What evidence supports that judgment?
7. Would a DFT change materially improve detection?

Use bounded language. This is not a numeric safety-integrity calculation and does not create PL/SIL credit.

## 10. Repeated escapes are design feedback, not operator folklore

When production repeatedly cannot observe a meaningful defect, do not solve the problem only by adding operator instructions.

Classify the missing observability at the correct authority:

- **reusable block** — add a generic test point, diagnostic, self-test hook, or interface fact only if it improves the block generically across boards;
- **adapter** — create/qualify a reusable measurement/stimulus transformation if real circuitry is needed;
- **board integration** — add board-specific test pads, muxing, connector access, population options, or fixture mapping when the need is physical/integration-specific;
- **fixture** — improve fixture stimulus/observation when the product already exposes adequate boundaries;
- **process** — improve inspection/programming/traceability when no product design change is justified.

Freeze:

> **PRODUCTION ESCAPE != AUTOMATIC BLOCK REDESIGN**

But also:

> **RECURRING GENERIC BLIND SPOT != OPERATOR-INSTRUCTION PROBLEM**

## 11. DFT must preserve architecture

A DFT feature must not silently alter functional authority, return domains, default state, protection, safety boundary, or qualification envelope.

A test mux, forced-enable, diagnostic override, or external stimulus path that can energize outputs must have an explicit default/inactive state and authority contract. Production convenience does not justify bypassing watchdog/output-off behavior in normal operation.

Board-specific pogo pads and J-number mappings remain board integration. Machine names do not belong in reusable circuitry.

## 12. Retain coverage evidence, not only PASS/FAIL

A mature production record should bind the serialized result from BD31 to a coverage-model revision. Store enough information to answer:

`SHOW FAILURE MODE -> SHOW COVERAGE METHOD -> SHOW FIXTURE/PROCEDURE/LIMIT -> SHOW SERIALIZED EVIDENCE`

When a semantic facet, fixture mapping, test limit, or DFT path changes, affected coverage claims become stale pending review.

Suggested coverage record:

```yaml
failure_mode_id: FM.OUT.OPEN_FIELD_PATH
claim_id: IFACE.DOUT.FIELD_RESPONSE
coverage_revision: COV.DOUT.07
coverage_class: DIRECT
stimulus_boundary: OUTPUT_COMMAND_via_released_FPGA_path
observation_boundary: released_field_output_fixture_load
masking_controls_checked: [fixture_return_isolation, load_identity]
production_scope: EVERY_UNIT
retained_evidence: [command, field_voltage, load_current, diagnostic_state]
status: CURRENT
```

The identifiers are illustrative, not claims that OpenPressBrake currently implements this registry.

## 13. Cross-machine reuse

A generic high-side output may serve a mill coolant valve, lathe solenoid, router accessory, robot auxiliary output, plasma-table relay, press-brake control output, or custom cell. Generic block DFT requirements should describe the electrical function to stimulate/observe, not machine destinations.

Board releases decide population, connectors, test-pad placement and fixture mapping. Production strategy may differ by board/process while consuming the same reusable block contract.

## 14. Safety boundary

Coverage of an ordinary controller's safety-status receiver or ordinary STO/enable status interface proves only the ordinary electrical/status claim tested. Do not convert production-test coverage percentages into safety diagnostic coverage, PL/SIL/category, stopping-performance, or independent personnel-safety claims.

> **PRODUCTION COVERAGE != SAFETY DIAGNOSTIC COVERAGE**

---

## Lab — eight adversarial coverage cases

Use a fictional controller family so no unfinished OpenPressBrake hardware is presented as production-ready.

1. **Command/fixture relay false green.** FPGA command and a fixture relay toggle, but the product field driver is never observed.
2. **Threshold blind spot.** Input logic changes at a strong nominal stimulus; a marginal field threshold remains indistinguishable.
3. **Shared-resource escape.** Every channel passes alone; simultaneous loading reveals a shared rail/return defect.
4. **Fixture masks return fault.** Fixture unintentionally ties two product returns and hides an assembly/open-return defect.
5. **Shallow fixture self-test.** Self-test checks continuity and a low measurement range but not the range used for acceptance.
6. **Qualification-only fault survival.** A destructive short-circuit survival claim is design-qualified but not repeated on every serialized unit; student must identify production controls and residual escape assumptions.
7. **Sampling overclaim.** Ten sampled boards pass and the record incorrectly marks every unit `PRODUCTION_SCREEN_PASS` for that test.
8. **Recurring escape / DFT feedback.** A repeated connector-to-driver open cannot be localized with existing observability; decide whether the correction belongs in the reusable block, board test points, adapter, fixture, or process and justify it.

For each submit:

- failure mode and affected semantic claim;
- likely introduction mechanism;
- stimulus and observation boundaries;
- direct/indirect/structural/qualification-only/sampled/uncovered classification;
- masking paths checked;
- fixture self-diagnostic dependency;
- 100%/sampled/qualification-only scope and rationale;
- retained evidence;
- plausible escape and consequence;
- DFT action, owning architectural layer and invalidated evidence;
- exact regression needed after a DFT change;
- safety-authority statement.

### Lab pass criteria

A passing submission must prove coverage rather than count test steps; trace the causal path; identify threshold/shared-resource/fixture-masking escapes; distinguish direct and indirect evidence; keep sampled results from becoming per-unit evidence; preserve qualification versus production-screen scope; place DFT changes at the correct architectural layer; and preserve the independent safety boundary.

---

## Catalog stress-test result

BD32 exposes two related infrastructure needs:

1. the future production-test traceability layer identified by BD31 needs a machine-readable **failure-mode/claim-to-coverage matrix**, not merely procedure steps and PASS/FAIL records; and
2. reusable block contracts need a disciplined place for **generic DFT/observability requirements** when those requirements are intrinsic to the reusable function, while board-specific test pads, fixture pins and physical mappings remain integration/manufacturing authority.

The current `digital_output_24v` manifest already helps by publishing command, field output/return, diagnostics, shared resources, and verification questions. It does not yet define a production coverage model, and its unresolved channel/load/thermal envelope prevents inventing production limits. That is an honest gap, not permission to fill values from assumption.

No OpenPressBrake engineering file is changed by BD32 because active current-main engineering is adjacent to these output/shared-resource contracts. Record the coverage/DFT schema as `ENGINEERING_REVIEW_NEEDED` rather than racing the active board-design lane.

## Compute

No simulation, synthesis, place-and-route, timing/resource run, or other executable engineering verification is required for this methodology lesson. No GitHub-hosted compute is used. Future executable verification remains restricted to `[self-hosted, openpressbrake]` when a named engineering question justifies it.

## Next lesson pressure

BD33 should cover **production escape containment, nonconformance trends, and catalog feedback without corrupting qualification evidence**:

`serialized escapes -> containment -> affected release/as-built population -> defect ownership -> trend/common-cause analysis -> corrective design/process action -> evidence invalidation/regression -> effectiveness check -> release/field applicability`

The adversarial question is whether recurring manufacturing evidence can improve reusable blocks and board designs without turning anecdotal production history into unsupported design qualification.