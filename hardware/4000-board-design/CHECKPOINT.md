# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD27 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD27_QUALIFICATION_FINDING_DISPOSITION_AND_REGRESSION_CLOSURE.md`

BD27 closes the loop after BD26 campaign execution:

`failed/anomalous evidence -> preserve evidence -> classify finding -> locate owning authority -> corrective revision -> SHOW WHERE USED -> scoped regression -> residual release recomposition`

## BD27 hard student-material audit

Every repository file named to students by BD27 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md`
- Curriculum `hardware/4000-board-design/BD26_FULL_BOARD_QUALIFICATION_PLANNING_AND_EVIDENCE_CLOSURE.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md`

The newly created BD27 lesson was re-opened from current main after commit and checked for internal consistency.

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake still lacks a repository-wide machine-readable finding-disposition layer that binds failed evidence to owning authority, corrective semantic revision, `SHOW WHERE USED`, facet-scoped invalidation, regression results, and recomputed release state.
- The current `digital_output_24v` isolated Rev1 path remains intentionally not presented as finished student hardware. Its status still leaves isolated-path production BOM/capture, structural validation, rendered connectivity, fault/corner qualification, PCB current/thermal qualification, board integration, and human release open.

No current file inspected for BD27 is used to claim complete OpenPressBrake production readiness.

## Rules frozen by BD27

- failed evidence is preserved and superseded rather than deleted or rewritten;
- the location where a failure is observed does not determine the authority that owns the defect;
- findings are classified before corrective circuitry/configuration is invented;
- a reusable block is revised only when the generic reusable contract/circuit/envelope is actually defective or there is independent generic engineering justification;
- machine-only mismatches remain machine/configuration facts unless generic engineering justifies a reusable change;
- adapter defects, board integration defects, connection-definition defects, FPGA/HAL defects, machine mismatches, and test/evidence defects remain distinct corrective homes;
- J-number/label/mapping-only changes do not automatically stale generic reusable electrical qualification;
- shared-resource changes propagate through dependent aggregates, protection, thermal/startup evidence, neighboring consumers, and release where causal dependencies exist;
- regression selection is driven by changed semantic facets and dependency edges, not by convenience or indiscriminate full reruns;
- a corrected design is not a closed finding until affected regressions and release recomposition are complete;
- a previously released board is not automatically released after a material change;
- ordinary safety-status findings do not grant authority to redesign independent personnel-safety functions in FPGA/LinuxCNC.

## Catalog stress-test result

BD27 exposes the next machine-readable catalog pressure: finding disposition and corrective-change impact. A future layer should preserve the failed evidence, classify the owning authority, record the corrective semantic revision, generate the affected `SHOW WHERE USED` set, stale only causally affected evidence, preserve unrelated evidence current, ingest regression results, and recompute the release proposition.

The current OpenPressBrake digital-output status is useful as an ownership example because it distinguishes a reusable shared-reference output variant from the first-board isolated implementation and explicitly leaves the latter's unresolved production/qualification work open. A future failure at the field connector must not automatically be blamed on or patched into the reusable primitive; the cause may belong to the isolation/interface path, shared resource, board connectivity, or installed machine.

No OpenPressBrake engineering file was changed. Current main is actively changing analog-input protection/envelope work, so OpenPressBrake remained read-only.

## Current repository reconciliation

The curriculum repository contained newer safety-lane commits after the prior BD26 checkpoint. Those were preserved.

BD27 was committed as `129f493546bbfb0877bc97c615f582016c42e5db` and re-opened from current main.

Immediately before this checkpoint write, current main was re-read in both repositories. Curriculum main was `129f493546bbfb0877bc97c615f582016c42e5db`; no overlapping post-BD27 board-design change was present. OpenPressBrake main was `fd279a00dbfcce72744fed5abe4acaba5cd2c7ab` (`analog input: separate TPS26610 measurement and protection envelopes`) and remained read-only.

## Next exact work

Build BD28 on **engineering change control from qualified catalog through released board variants**.

Teach the flow:

`change proposal -> affected semantic IDs/facets -> compatibility classification -> reusable/adapter/board revision policy -> evidence invalidation -> board-variant applicability -> migration/retrofit decision -> qualification/regression -> configuration-baseline update -> release-note/field-action decision`

The adversarial lab should include:

- a backward-compatible reusable improvement that should not force unnecessary board respins;
- a breaking reusable interface revision requiring a different block, qualified adapter, or board respin;
- a BOM substitution that is not accepted as equivalent merely because nominal values match;
- a machine-only retrofit that must not mutate generic catalog authority;
- a board-specific connector/location change with narrow applicability;
- a change whose engineering benefit is real but does not justify automatic retrofit of already released machines;
- an ordinary safety-status interface change that must not redefine independent safety authority.

Require explicit old/new configuration baselines, applicability by board/machine revision, retained superseded evidence, causal regression selection, and a field-action decision distinct from design-release approval.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD27. The work was finding-disposition methodology and current source review. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD27 teaches disposition of ordinary controller findings and their interfaces. It does not establish PL/SIL/category, diagnostic coverage, stopping performance, or independent personnel-safety authority. An ordinary controller may correct its electrical/status interface to an independent safety system, but must not absorb the safety function merely because a qualification finding was observed there.