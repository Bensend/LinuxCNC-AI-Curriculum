# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD26 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD26_FULL_BOARD_QUALIFICATION_PLANNING_AND_EVIDENCE_CLOSURE.md`

BD26 turns the BD25 release/evidence graph into a release-oriented verification campaign:

`release dependency -> unresolved/current evidence -> verification question -> prerequisite/risk ordering -> staged evidence -> residual-open-claim ledger -> composed release review`

## BD26 hard student-material audit

Every repository file named to students by BD26 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD08_QUALIFICATION_EVIDENCE_VERIFICATION_MATRIX_AND_REGRESSION_TRIGGERS.md`
- Curriculum `hardware/4000-board-design/BD09_STAGED_BOARD_BRINGUP_AND_COMMISSIONING_EVIDENCE.md`
- Curriculum `hardware/4000-board-design/BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md`
- OpenPressBrake commit `99a95e45ea077c0ade1ee2c61517751845f82ae8`, specifically the added `hardware/blocks/digital_output_24v/integration/STISO620_SUPPLY_CURRENT_BOUND.md` evidence

The newly created BD26 lesson was re-opened from current main after commit and checked for internal consistency.

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake still lacks a repository-wide machine-readable campaign-derivation/closure layer that enumerates unresolved release claims, binds each to an evidence method/prerequisites/owner, ingests results, and recomputes the residual release graph.
- The current `digital_output_24v` isolated Rev1 path is intentionally not presented as finished student hardware. Its status still leaves exact isolated-path production BOM/capture, board-contract validator closure, rendered connectivity, abnormal-condition qualification, simultaneous-channel corners, PCB current/thermal qualification, board integration, and human release open.

No current file inspected for BD26 is used to claim complete OpenPressBrake production readiness.

## Rules frozen by BD26

- qualification campaigns are derived from release dependencies, not generic checklists;
- campaign order must respect prerequisites, risk, information value, and destructive potential;
- evidence classes complement one another and do not silently promote across reusable/board/PCB/FPGA/HAL/machine scopes;
- current-limited staged-power survival does not qualify production protection;
- a bounded device/load calculation can feed a thermal analysis without closing actual-PCB thermal qualification;
- default/reset, watchdog/command loss, partial-power/back-power, and declared electrical fault cases remain distinct questions;
- a successfully commissioned and working machine may still correctly remain not released;
- stale reusable evidence, unresolved `VERIFY_AT_MACHINE` facts, stale FPGA implementation evidence, envelope gaps, and failed criteria remain release blockers even after successful operation;
- negative evidence is preserved and superseded rather than hidden;
- completion of test execution is not the same as passing the final release review;
- ordinary safety-status monitoring by LinuxCNC/FPGA remains outside independent personnel-safety authority.

## Catalog stress-test result

The current OpenPressBrake digital-output work is a useful positive example: the newest STISO620 datasheet/current arithmetic closes one named resource question while its own evidence and block status explicitly leave PCB thermal, exact capture, fault qualification, integration, and release gates open. That is the desired behavior of bounded evidence.

BD26 exposes the next catalog pressure: generate a qualification campaign from the dependency/evidence graph and maintain a residual-open-claim ledger without duplicating electrical authority. This should eventually support grouping by article/setup, prerequisite ordering, evidence ingestion, and causal release blockers.

No OpenPressBrake engineering file was changed. Active engineering is adjacent to these qualification/resource questions, so OpenPressBrake remained read-only.

## Current repository reconciliation

The curriculum repository contained newer safety-lane commits after the prior BD25 checkpoint. Those were preserved.

BD26 was committed as `6a1edd6e672fb1ed897002c9ad8188418bd81be4` and re-opened from current main.

Immediately before this checkpoint write, current main was re-read in both repositories. Curriculum main was `6a1edd6e672fb1ed897002c9ad8188418bd81be4`; no overlapping post-BD26 board-design change was present. OpenPressBrake main was `99a95e45ea077c0ade1ee2c61517751845f82ae8` (`digital output: close STISO620 switched-5V load bound`) and remained read-only.

## Next exact work

Build BD27 on **qualification finding disposition and regression closure**.

Teach the flow:

`failed/anomalous evidence -> preserve evidence -> classify finding -> locate owning authority -> block defect / adapter defect / board integration / connection definition / FPGA/HAL / machine fact -> corrective revision -> dependency SHOW WHERE USED -> scoped regression selection -> rerun/recalculate/review/requalify -> residual release recomposition`

The adversarial lab should include a board-level failure that reveals a genuine reusable-block defect, a machine-only mismatch that must not contaminate the reusable block, an adapter/interface defect, a J-number-only correction that should not stale generic electrical qualification, a fix that changes a shared resource and therefore invalidates neighboring consumers, and a safety-status observation that must not become a safety-function design correction in the ordinary controller lane.

Require preservation of failed/superseded evidence and explicit proof that a local fix did not silently invalidate other blocks or the complete-board release claim.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD26. The work was campaign methodology and current source review. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD26 plans qualification of ordinary controller hardware and its interfaces. It does not establish PL/SIL/category, diagnostic coverage, stopping performance, or independent personnel-safety authority. A correctly read safety-system status signal proves only the bounded ordinary electrical/status interface claim unless the separate safety architecture and validation establish more.