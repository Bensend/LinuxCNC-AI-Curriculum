# BD33 — Production Escape Containment, Nonconformance Trends, and Catalog Feedback

## Purpose

BD31 established serialized production evidence and BD32 established causal production-test coverage. BD33 addresses what happens after a defect escapes production, recurs, or appears as a trend.

The governing flow is:

`serialized escape -> immediate containment -> affected release/as-built/installed population -> defect ownership -> occurrence/trend analysis -> common-cause hypothesis -> corrective design/process action -> dependency/evidence invalidation -> regression -> effectiveness check -> release/field applicability`

This lesson develops both linked skills:

1. **block engineering** — determine when production evidence reveals a generic reusable-block weakness and revise/requalify the block without converting anecdotes into qualification evidence; and
2. **board integration** — contain actual populations, classify board/process/fixture/supplier defects, preserve as-built identity, and propagate justified corrections without contaminating reusable contracts with board-specific fixes.

OpenPressBrake is used only as a current governance/example source. It is not represented as production-proven hardware.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD32_PRODUCTION_TEST_COVERAGE_ESCAPE_ANALYSIS_AND_DFT_FEEDBACK.md` — causal coverage, escape analysis, DFT ownership and production-versus-qualification separation.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD33 — exact board-lane assignment and current catalog gaps.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — evidence truthfulness, status gates and maintenance after material changes.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block, adapter and board-integration ownership.
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — current evidence scope and unresolved Rev1 isolated-path qualification/release gates.
- OpenPressBrake `hardware/blocks/digital_output_24v/manifest.yaml` — current generic output interfaces, shared resources, diagnostics, verification requirements and unresolved board envelope.

The current `digital_output_24v` is not assigned as finished production hardware. Its reusable non-isolated variant remains `SIMULATION-READY`; its first-machine isolated path is not yet `SCHEMATIC-READY`. For finished production use it remains `ENGINEERING_REVIEW_NEEDED`.

---

## 1. An escape creates two immediate questions

When a nonconforming unit is found after the production gate, separate:

1. **containment:** what physical/configuration population might contain the same defect now? and
2. **cause/correction:** what mechanism created the defect and which engineering authority owns it?

Do not delay containment while waiting for perfect root cause. Do not redesign hardware merely because containment is broad.

Freeze:

> **ROOT CAUSE UNKNOWN != CONTAINMENT OPTIONAL**

and:

> **BROAD CONTAINMENT != GENERIC DESIGN DEFECT PROVED**

A minimal escape record should preserve serialized identity, discovery point, symptom, released/as-built identity, installed state if known, production evidence revision, fixture/procedure identity, supplier/lot identity when available, and the exact facts still unknown.

## 2. Bound the affected population from identity, not family resemblance

Use the configuration identity methods from BD29–BD31. Population bounding may depend on:

- immutable release ID;
- PCB/BOM revision;
- exact fitted part/approved alternate;
- supplier/manufacturer lot where traceable;
- assembly date/work order/process revision;
- programmed FPGA/software/HAL identity;
- fixture/procedure/limit revision;
- rework/deviation history;
- serialized board identity;
- installed asset/machine identity.

If the necessary identity is missing, do not guess a narrow population.

> **UNKNOWN TRACEABILITY != UNAFFECTED**

Use `VERIFY_AT_MACHINE` or an explicit unbounded/partially bounded state until installed identity is established.

## 3. Preserve the escaped unit's negative evidence

Do not overwrite the original production PASS, field failure, failed retest, teardown evidence, or rework history after the unit is repaired.

The record should be able to show:

`what was believed at release -> what was observed later -> what evidence contradicted it -> what was changed -> what later evidence supports closure`

Freeze:

> **REPAIR PASS != ORIGINAL ESCAPE ERASED**

A corrected unit can be conforming while the original escape remains essential evidence for trend and effectiveness analysis.

## 4. Classify defect ownership before corrective redesign

Use the same authority separation as the block catalog.

### Reusable-block owned

Choose this only when evidence shows the generic block contract/topology/component choice/DFT requirement is defective or incomplete across its intended reusable envelope.

### Adapter owned

Use when the defect lies in a reusable transformation or protection boundary between otherwise valid blocks.

### Board-integration owned

Use for instance mapping, connector/pin assignment, return/power composition, placement/routing, population, board-specific test access, shared-resource sizing, or other board composition errors.

### Manufacturing/process owned

Use for solder/open/short, wrong placement, workmanship, programming operation, uncontrolled rework, inspection weakness, or process escape when the released design itself remains valid.

### Fixture/test-system owned

Use when false failures or false passes originate in fixture wiring, calibration, stimulus, load, software, limit selection, or masking.

### Supplier/material owned

Use when received material, counterfeit/mislabeled material, lot variation, or an unapproved/incorrect substitution is causal. A supplier label does not remove engineering responsibility for containment and approved-part controls.

### Machine/installation owned

Use when the installed harness, load, environment, parameterization, bonding, or other machine fact violates or falls outside the released contract.

Freeze:

> **WHERE DEFECT WAS FOUND != WHERE DEFECT IS OWNED**

## 5. Occurrence trend is not design qualification

Production and field history are powerful evidence about occurrence, process capability and blind spots. They do not by themselves prove electrical margins or the full reusable design envelope.

Ten thousand units with no observed short-circuit failure do not replace a justified fault-survival qualification claim. Conversely, one well-characterized failure can invalidate a design assumption if it directly contradicts the claimed envelope.

> **LOW OBSERVED FAILURE RATE != QUALIFIED DESIGN MARGIN**

> **ONE CONTRADICTORY VALID CASE CAN INVALIDATE A UNIVERSAL CLAIM**

Trend evidence must therefore retain its evidence class: production occurrence, field occurrence, supplier/process data, qualification, simulation, calculation, machine verification, or inference.

## 6. A trend needs a denominator and an exposure definition

Counts alone are misleading. Record, where available:

- affected count;
- inspected/tested/shipped/installed population denominator;
- date or build range;
- release/as-built variants included;
- supplier/process/fixture revisions included;
- relevant operating exposure if known;
- censoring or missing-return bias;
- discovery mechanism.

Do not invent failure rates when the denominator or exposure is unknown.

> **THREE FAILURES != A FAILURE RATE WITHOUT A DEFENSIBLE DENOMINATOR**

For early prototype or low-volume builds, a qualitative recurrence pattern may be the correct evidence rather than false statistical precision.

## 7. Apparent common cause may be multiple mechanisms

Grouping failures by symptom can hide different causes. For example, “output dead” could result from an open solder joint, wrong FPGA mapping, fixture false fail, damaged smart switch, missing field supply, or machine harness fault.

Before declaring common cause, compare discriminating evidence:

- failure signature and location;
- as-built/release identity;
- lot/process/fixture correlation;
- teardown measurements;
- environmental or machine exposure;
- whether the same semantic claim actually failed.

Freeze:

> **SAME SYMPTOM != SAME FAILURE MECHANISM**

and:

> **CORRELATION WITH LOT/DATE/FIXTURE != ROOT CAUSE PROVED**

## 8. Correct at the owning layer

Examples:

- repeated solder opens with correct released pads and assembly drawing: process correction, inspection/fixture coverage and perhaps board DFT access — not automatic reusable-block redesign;
- the same generic output topology fails its declared inductive envelope on multiple unrelated boards: reusable-block engineering review and qualification revision;
- false failures occur only with one fixture adapter that adds an unintended return path: fixture/adapter correction and affected production-evidence review;
- one board variant maps a compatible block to the wrong connector pin: board connection-definition correction;
- an unapproved supplier substitution changes an electrical property: material/BOM control plus engineering equivalence review before qualification inheritance.

A correction should be the smallest architectural change that fixes the proved mechanism without hiding it elsewhere.

## 9. Corrective action invalidates evidence by semantic impact

Use the BD23–BD28 dependency logic rather than “retest everything” or “retest only the failed unit.”

For each corrective change record:

- changed semantic IDs/facets;
- owning artifact revision;
- affected `SHOW WHERE USED` consumers;
- affected released variants;
- evidence made stale/superseded;
- serialized/installed population affected;
- regression required;
- evidence explicitly preserved as still valid and why.

A board-process solder correction may preserve generic block electrical qualification while invalidating production-screen/process evidence for a build range. A block topology correction can invalidate every dependent board/release claim that consumed the changed facet.

> **LOCAL CORRECTION PASS != DEPENDENT EVIDENCE CURRENT**

## 10. Effectiveness is a separate claim from implementation

Closing a corrective-action work item because the drawing, fixture, process or circuit changed proves implementation only.

Effectiveness asks whether the intended recurrence/escape mechanism was actually reduced or eliminated over an appropriate opportunity window.

Possible bounded effectiveness evidence includes:

- direct regression of the corrected causal path;
- challenge units or seeded defects where appropriate;
- fixture self-test demonstrating the formerly blind path;
- controlled process inspection data;
- subsequent production population with known denominator;
- field follow-up for the bounded affected population;
- confirmation that no new masking or authority path was introduced.

> **CORRECTIVE ACTION IMPLEMENTED != CORRECTIVE ACTION EFFECTIVE**

Do not require arbitrary calendar time or unit counts without a process-specific rationale.

## 11. Supplier substitutions need identity before trend conclusions

A suspected supplier/material trend requires exact fitted identity where possible. If lot traceability is incomplete, containment may need to span multiple lots, date codes, purchase orders or builds.

Do not infer that all same-MPN parts are equivalent to the failed lot, and do not infer that an alternate is qualified because it shares nominal ratings.

> **SAME MPN FAMILY != SAME LOT HISTORY**

> **NOMINAL EQUIVALENCE != QUALIFICATION INHERITANCE**

If a substitution changes a consumed semantic facet, use engineering change control and requalification rules rather than treating procurement approval as electrical evidence.

## 12. Fixture-induced trends can corrupt both yield and diagnosis

Repeated false failures are themselves a production-system defect. They can drive unnecessary rework that creates real defects and can conceal actual yield trends.

When fixture correlation appears:

1. quarantine the fixture/procedure revision as needed;
2. preserve affected test records;
3. identify whether the fixture caused false fail, false pass, or both;
4. determine which serialized evidence can still be trusted;
5. retest only under a current justified fixture/procedure;
6. keep original results in history.

> **FIXTURE FAULT FOUND != ALL PRODUCT FAILURES FALSE**

## 13. Field escapes join engineering and installed-asset graphs

A field escape requires both `SHOW WHERE USED` and `SHOW WHAT IS INSTALLED`.

Engineering dependency tells which releases could contain the changed/failed facet. Installed-asset identity tells where those releases or affected as-built variants physically exist.

If installed identity is missing, mark the field population unresolved and verify rather than silently excluding assets.

Field action is a separate disposition from design correction. A new design release does not automatically prove retrofit necessity, and a retrofit decision does not rewrite historical release identity.

## 14. OpenPressBrake worked governance example

The inspected `digital_output_24v` manifest publishes a generic protected output primitive, command and diagnostic interfaces, shared resources, fault requirements and board-integration tests while explicitly leaving board channel current, inrush, duty, simultaneous-use assumptions, connector rating and PCB current/thermal limits unresolved.

The inspected status checklist separately states that the reusable non-isolated variant is `SIMULATION-READY` while the first-machine isolated path still has open KiCad mapping, structural validation, abnormal/fault qualification, PCB thermal/current, integration and human-release gates.

That separation is exactly what an escape system must preserve. A future repeated solder open on one board's isolated-path device would not, by itself, prove the generic reusable output primitive electrically defective. A future cross-board failure that contradicts the reusable primitive's declared generic electrical envelope could justify block-level review. The evidence must decide ownership.

No OpenPressBrake production population, serial range, failure rate or field escape is asserted here.

## 15. Cross-machine reuse

The method applies unchanged to mills, lathes, plasma tables, routers, robots, press brakes and custom automation:

- reusable electrical defects follow reusable semantic contracts;
- board/process defects follow the actual build configuration;
- field applicability follows installed identity;
- machine-specific physics remain machine-specific;
- unresolved identity remains unknown rather than guessed.

## 16. Safety boundary

An ordinary controller may receive a safety-system status signal, and production/field trends may reveal defects in that ordinary receiver or status path. That evidence proves only the bounded ordinary electrical/status claim.

Do not convert occurrence rates, production coverage, successful corrective actions, or ordinary-interface regressions into safety diagnostic coverage, PL/SIL/category, stopping-performance or independent personnel-safety claims.

> **ORDINARY SAFETY-STATUS INTERFACE TREND != SAFETY-FUNCTION VALIDATION**

---

## Lab — eight adversarial escape and trend cases

Use a fictional multi-machine controller family. Preserve every original failure and test result.

### Case 1 — repeated solder/open defect

Three boards from one assembly period show open connections between a board-specific connector path and a correctly specified reusable output stage. Determine containment, likely board/process ownership, coverage weakness and whether any reusable-block revision is justified.

### Case 2 — generic block weakness across boards

Two unrelated board designs using the same reusable block fail the same declared generic electrical-envelope claim under independently reproduced conditions. Determine which semantic claim is contradicted, what evidence becomes stale and what downstream variants require regression.

### Case 3 — fixture-induced false-failure trend

Failures cluster on one fixture. Later inspection finds an intermittent fixture load connection. Determine which old product failures remain unresolved, which production evidence is untrustworthy and what fixture effectiveness evidence is needed.

### Case 4 — supplier substitution with incomplete lot identity

A nominally equivalent alternate part appears in several builds, but lot/build traceability is incomplete and failures correlate imperfectly with the substitution. Bound containment without inventing unaffected serial ranges; separate procurement facts from qualification inheritance.

### Case 5 — initially unbounded field escape

One installed controller fails, but its as-built BOM and FPGA/HAL identity were not recorded. Use `SHOW WHERE USED` plus `SHOW WHAT IS INSTALLED`; identify `VERIFY_AT_MACHINE` work and explain why family name alone cannot bound field action.

### Case 6 — one symptom, two mechanisms

Five “dead output” reports exist. Teardown shows three solder opens and two intact boards with incorrect configuration mapping. Reject the false common-cause claim and create separate finding/corrective-action paths.

### Case 7 — local correction, stale dependent evidence

A reusable block component value changes and the corrected block passes its local regression. A dependent board power/thermal claim consumed the changed facet but was not rerun. Determine release state and exact remaining regression.

### Case 8 — ordinary safety-status interface trend

An ordinary FPGA input receiving independent safety-system status intermittently reports the wrong state because of a board receiver defect. Correct and regress the electrical/status interface while explicitly refusing unsupported personnel-safety validation claims.

For each case submit:

- preserved original negative evidence;
- immediate containment decision;
- affected population and identity basis;
- unknown identity/`VERIFY_AT_MACHINE` items;
- defect ownership and alternative hypotheses;
- trend denominator/exposure quality;
- common-cause evidence versus correlation;
- corrective action at the owning layer;
- semantic facets changed;
- `SHOW WHERE USED` and `SHOW WHAT IS INSTALLED` impact;
- stale/superseded/preserved evidence;
- regression plan;
- effectiveness criterion and evidence window;
- release/field-action disposition;
- safety-authority statement.

### Lab pass criteria

A passing submission must contain before root cause is complete; preserve negative evidence; bound populations from identity rather than family resemblance; separate occurrence trends from qualification; avoid false common-cause conclusions; correct at the owning architectural layer; propagate evidence invalidation; distinguish implementation from effectiveness; keep unknown field identity explicit; and preserve the independent personnel-safety boundary.

---

## Catalog stress-test result

BD33 exposes a concrete next infrastructure need: a future quality/field-feedback layer should join **serialized nonconformance/finding records** to release/as-built/installed identity, failure mechanism, owning semantic facet, supplier/process/fixture identity, containment population, corrective-action revision, stale evidence, regression, and effectiveness evidence.

That layer should not live inside reusable block manifests as raw production history. Reusable blocks should receive only justified generic engineering feedback: changed requirements/contracts, generic DFT needs, proven component/topology corrections, and references to the findings that motivated revision. Board/process/fixture history remains owned by its respective configuration and quality records.

Current OpenPressBrake files do not establish a production population or field nonconformance registry, so this need is `ENGINEERING_REVIEW_NEEDED`; do not fabricate serials, yields, lots, escapes or release states.

No OpenPressBrake engineering file is changed by BD33 because current main shows active hardware development adjacent to board-resource contracts.

## Compute

No simulation, synthesis, place-and-route, timing/resource run or other executable engineering verification is required for this methodology lesson. No GitHub-hosted compute is used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]` when a named engineering question justifies it.

## Next lesson pressure

BD34 should cover **field-return evidence, repair/retrofit configuration reconciliation, and service-induced drift**:

`installed identity -> service finding -> repair/part substitution/configuration change -> post-service as-maintained identity -> affected qualification evidence -> regression/functional verification -> installed baseline update -> future field applicability`

The adversarial question is how to keep a once-released controller traceable after years of repairs, replacement boards, firmware/FPGA/HAL changes and machine-specific service without silently treating the original release baseline as the current installed truth.