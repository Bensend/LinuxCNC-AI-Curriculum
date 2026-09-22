# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD33 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD33_PRODUCTION_ESCAPE_CONTAINMENT_NONCONFORMANCE_TRENDS_AND_CATALOG_FEEDBACK.md`

BD33 teaches:

`serialized escape -> immediate containment -> affected release/as-built/installed population -> defect ownership -> occurrence/trend analysis -> common-cause hypothesis -> corrective design/process action -> dependency/evidence invalidation -> regression -> effectiveness check -> release/field applicability`

## BD33 hard student-material audit

Every repository file named to students by BD33 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD32_PRODUCTION_TEST_COVERAGE_ESCAPE_ANALYSIS_AND_DFT_FEEDBACK.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/manifest.yaml`

The newly created BD33 lesson was re-opened from current main after commit and checked against the inspected sources.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `digital_output_24v` reusable non-isolated variant remains `SIMULATION-READY`;
- the Rev1 isolated board path is not yet `SCHEMATIC-READY` and exact isolated-path CAD/connectivity, fault/abnormal qualification, PCB thermal/current evidence, integration and human release remain open;
- OpenPressBrake has no repository-wide serialized production nonconformance/field-return registry joined to release/as-built/installed identity;
- current engineering development is not evidence of a production population, field escape rate, supplier-lot history, shipment authority or production corrective-action system.

No inspected file is used to claim complete OpenPressBrake production readiness.

## Rules frozen by BD33

- root cause may remain unknown while containment is still required;
- broad containment does not prove a generic design defect;
- unknown traceability does not mean an asset is unaffected;
- repair/retest success does not erase original negative evidence;
- where a defect is observed is not necessarily where it is owned;
- occurrence trends and low observed failure rates are not substitutes for design qualification;
- a valid contradictory case can invalidate a universal design claim;
- failure counts are not rates without a defensible denominator/exposure basis;
- same symptom does not prove same failure mechanism;
- correlation with lot/date/fixture does not prove root cause;
- local corrective-action success does not make dependent evidence current;
- corrective action implemented is distinct from corrective action effective;
- nominal part equivalence does not create qualification inheritance;
- a fixture fault does not prove every product failure was false;
- field escape applicability requires engineering dependency plus installed-asset identity;
- ordinary safety-status interface trends do not establish safety-function validation.

## Current OpenPressBrake worked-example result

The current `digital_output_24v` manifest remains a useful bounded governance example because it separates a generic protected output primitive and its command/diagnostic/shared-resource contracts from unresolved board channel current, inrush, duty, simultaneous-use assumptions, connector rating and PCB current/thermal limits.

The current status checklist separately preserves `SIMULATION-READY` for the reusable non-isolated variant while leaving the first-machine isolated path short of schematic/release readiness. BD33 uses that separation to teach defect ownership: a future repeated board solder open would not automatically become a reusable primitive defect, while a reproduced cross-board failure that contradicts the primitive's declared generic electrical envelope could justify block-level review.

No OpenPressBrake production population, serial range, failure rate or field escape is asserted, and no OpenPressBrake engineering file was changed during BD33.

## Current repository reconciliation

Before the BD33 lesson commit, current main was re-read in both repositories. Curriculum main was `7c1069279e4b7e2f5c2d752a41b17580d1c3bb82`; its concurrent safety-lane timing/progress work did not overlap the board-design lesson path. OpenPressBrake main was `4541bf626e3f1aa9ff25e8edaa3574942ded709b` (`analog output: bound clear-logic 3V3 demand`), showing active hardware engineering adjacent to board-resource work, so OpenPressBrake remained read-only.

BD33 was committed as `4345eda4f1b295339d8fe01c27660b2243f26834` and re-opened from current main. Immediately before this checkpoint write, curriculum main was re-read again and still pointed to the BD33 commit with no overlapping post-BD33 board-design change.

## Catalog stress-test result

BD33 exposes a concrete quality/field-feedback infrastructure need: future tooling should join serialized nonconformance/finding records to release/as-built/installed identity, failure mechanism, owning semantic facet, supplier/process/fixture identity, containment population, corrective-action revision, stale evidence, regression and effectiveness evidence.

Do not dump raw board/process/fixture history into reusable block manifests. Reusable blocks should consume only justified generic engineering feedback: changed contracts/requirements, proven topology/component corrections, generic DFT needs and references to the findings that motivated revision. Board, process, fixture, supplier and installed-machine history remain owned by their respective configuration/quality records.

This infrastructure need remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing serials, yields, lots, escapes or release states.

## Next exact work

Build BD34 on **field-return evidence, repair/retrofit configuration reconciliation, and service-induced drift**.

Teach the flow:

`installed identity -> service finding -> repair/part substitution/configuration change -> post-service as-maintained identity -> affected qualification evidence -> regression/functional verification -> installed baseline update -> future field applicability`

The adversarial lab should include a like-for-like replacement with uncertain lot identity, an apparently equivalent substitute that changes a consumed semantic facet, a replacement board carrying a different FPGA/HAL image, a field technician jumper/wiring change, a repaired unit whose original negative evidence must remain, a machine whose installed identity is initially unknown, a retrofit that fixes one issue while leaving stale dependent evidence, and an ordinary safety-status interface repair that must not be promoted into personnel-safety validation.

Require students to distinguish released/as-built/as-installed/as-maintained identity; preserve service and negative-evidence history; use `SHOW WHERE USED` and `SHOW WHAT IS INSTALLED`; classify service changes at the correct reusable/adapter/board/machine layer; keep `VERIFY_AT_MACHINE` for unresolved physical facts; and prove post-service conformance without assuming the original release baseline still describes the machine.

## Compute

No simulation, synthesis, place-and-route, timing run or other executable engineering verification was justified for BD33. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD33 teaches containment, nonconformance trends and corrective-action feedback for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation or independent personnel-safety authority. A corrected ordinary receiver for a safety-system status signal proves only the bounded ordinary electrical/status claim actually verified.