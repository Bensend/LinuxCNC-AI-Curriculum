# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD41 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD41_RELEASE_DEPENDENCY_INVALIDATION_SEMANTIC_CHANGE_AND_CONTROLLED_REPROMOTION.md`.

BD41 teaches:

`released artifact -> upstream semantic change -> SHOW WHERE USED -> affected claim/evidence classification -> stale/quarantine decision -> bounded regression -> new candidate -> re-promotion or documented non-impact -> downstream fleet/service applicability`

## BD41 hard student-material audit

Every repository file named to students by BD41 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD40_CONFIGURATION_PROVENANCE_ATTESTATIONS_TRUST_AND_ARTIFACT_PROMOTION.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`

`ENGINEERING_REVIEW_NEEDED` and deliberately **not** assigned as finished student material:

- OpenPressBrake `hardware/blocks/safety_interface/manifest.yaml`
- OpenPressBrake `hardware/blocks/safety_interface/STATUS_CHECKLIST.md`

The newly created BD41 lesson was re-opened from current main after commit and checked against the inspected sources.

## Catalog defect exposed by teaching

Current OpenPressBrake main `693c36491fe8a981bbbb199e9730e9dcb117a37c` changed `safety_interface/manifest.yaml` to a concrete Rev1 composition: seven protected Pilz status inputs, six protected operational command outputs, thirteen 3V3 FPGA GPIO total, L7/L07 command domain, and preserved independent wire-75/wire-63 boundaries.

The current `STATUS_CHECKLIST.md` is stale relative to that manifest: it still describes the output primitive as conditional, says exact channel count/output class/polarity/timing/returns depend on an unknown external contract, and says not to freeze the final output primitive until that contract is known.

This conflicts with `STATUS_RULES.md`, whose maintenance rule requires a material design/interface change to update the block's `STATUS_CHECKLIST.md` in the same change. The mismatch is therefore a concrete catalog-maintenance defect, not a lesson-writing ambiguity.

Because the safety-interface block is the newest active OpenPressBrake engineering work, the curriculum lane did not overwrite it. The active board-design lane should reconcile which semantic state is authoritative and propagate the correction through dependents. Until then, neither file may be presented as complete student material.

The safety boundary remains explicit: the manifest labels this interface monitoring/non-safety operational handshake only, keeps wires 75 and 63 outside ordinary controller authority, and prohibits PL/SIL/category or safety-rated-stop claims.

## Rules frozen by BD41

- file changes do not imply every downstream claim is stale;
- unchanged files do not prove unchanged semantic contracts;
- invalidate by stable semantic facet and `SHOW WHERE USED`, not filename proximity;
- preserve unaffected evidence only with an explicit dependency-based rationale;
- unknown dependency identity fails closed rather than being guessed into non-impact;
- component substitutions can invalidate limits/evidence even when topology is unchanged;
- stable HAL names do not prove the physical FPGA/bank/board path is unchanged;
- board connector remaps remain board integration when the reusable electrical contract is unchanged;
- unchanged source rebuilt with a different FPGA toolchain is a new candidate until equivalence and authority are established;
- reusable-block requalification and board/configuration re-promotion are separate operations;
- ordinary-controller regression does not validate an independent personnel-safety function.

## Catalog stress-test result

BD41 exposes a release/configuration infrastructure need above the reusable catalog: a machine-readable semantic invalidation/re-promotion ledger should bind stable semantic facet IDs and old/new revisions to change class, direct/reverse dependency edges, exact consumers, preserved/stale evidence, regression/requalification requirements, rebuilt candidate identity, re-promotion/non-impact authority, new-build/service/as-maintained applicability, installed populations, `VERIFY_AT_MACHINE` dependencies, and retained negative/rollback evidence.

Reusable manifests should publish stable generic semantic facets and evidence. Board/release infrastructure should record exactly which facets each board/configuration consumed. Machine-specific release authority must not leak into reusable block circuitry.

## Current repository reconciliation

At run start, curriculum main contained BD40 plus concurrent safety-lane work but no overlapping post-BD40 board-design lesson. OpenPressBrake main had advanced to `693c36491fe8a981bbbb199e9730e9dcb117a37c` (`safety interface: publish Rev1 composition resource contract`), so that active block was consumed read-only.

BD41 was committed as `c094d1c2ea31a2ef7e60fd5b17afac99c2ac286b` and re-opened from current main. Immediately before this checkpoint write, curriculum main was re-read and contained BD41 with no overlapping post-BD41 board-design change; OpenPressBrake main was also re-read and remained `693c36491fe8a981bbbb199e9730e9dcb117a37c`.

## Next exact work

Build BD42 on **change-wave planning, regression ordering, and release-train containment**:

`multiple upstream changes -> dependency graph -> common affected consumers -> merge/separate change waves -> regression ordering -> candidate lineage -> partial promotion -> incompatible population handling -> rollback points -> release-train closure`

Stress simultaneous power-contract and FPGA-map changes, two independent block revisions touching one board, a board-only connector change that should not force generic block requalification, a late regression failure after some evidence was already refreshed, and service populations that cannot migrate in one wave. Require students to minimize redundant testing without combining changes so aggressively that causality and rollback evidence are lost.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD41. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD41 teaches dependency invalidation and re-promotion for ordinary controller hardware/configuration. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, or independent personnel-safety authority. A regression pass on an ordinary monitor/handshake interface proves nothing about validation of the independent personnel-safety function.
