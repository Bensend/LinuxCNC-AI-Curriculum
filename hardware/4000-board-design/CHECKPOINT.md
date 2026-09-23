# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD58 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD58_EQUIVALENCE_PROOF_LIFECYCLE_REVIEW_EXPIRATION_AND_ASSUMPTION_DRIFT.md`.

BD58 teaches:

`preserved-evidence record -> monitored assumptions -> authority/resource/machine-fact drift -> trigger evaluation -> proof expiration or continued validity -> targeted revalidation -> renewed promotion`

## BD58 hard student-material audit

Every repository file named to students as finished material by BD58 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `README.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `hardware/4000-board-design/BD57_EVIDENCE_EQUIVALENCE_DECISIONS_AND_PRESERVATION_PROOFS.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/shared_adc_dac/design/REV32_ADC_REFERENCE_POWER_RECONCILIATION.md`

`ENGINEERING_REVIEW_NEEDED` as complete current-status authority:

- OpenPressBrake `hardware/blocks/shared_adc_dac/STATUS_CHECKLIST.md` — current main contains Rev32 REF5020 worst-case power reconciliation, but the authoritative checklist still describes authority through Rev31 and omits Rev32 from its evidence and next-checkpoint sections. Its other bounded statements remain useful. This is status drift under `STATUS_RULES.md` maintenance requirements.

BD58 itself was re-opened from current main after commit.

## Rules frozen by BD58

- a preservation proof is itself versioned evidence with dependencies;
- proof file unchanged does not mean proof current;
- prior engineering review is not permanent engineering authority;
- lifecycle states are `CURRENT_PRESERVED`, `CURRENT_NARROWED`, `STALE_TRIGGERED`, `BLOCKED_UNKNOWN`, `SUPERSEDED`, and `HISTORICAL_ONLY`;
- invalidation follows claim-relevant semantic triggers rather than arbitrary repository churn or blanket elapsed-time rules;
- authority, operating envelope, shared resources, physical-machine facts, PCB implementation, and tool/model/method changes can independently expire a proof;
- proof expiration does not mean the historical test was wrong; it means applicability to the current claim is no longer established;
- minimum-safe renewal uses the evidence class required by the changed premise rather than rerunning everything;
- renewal is a new promotion event linked to, not rewriting, historical proof state;
- reusable primitive evidence and board-integration evidence remain independently invalidatable; and
- ordinary-control proof lifecycle receives zero personnel-safety credit without separate safety-rated authority.

## Worked-example stress test

Current OpenPressBrake `shared_adc_dac` Rev32 closes a narrow manufacturer-backed power-budget fact without changing topology: ADS7953 +VA contributes 3.0 mA maximum and REF5020 VIN contributes 1.2 mA maximum over -40 C to +125 C, yielding a known guaranteed 4.2-mA `5V_ANALOG` subtotal per populated shared resource. OPA192 `5V_ANALOG` and ADS7953 `+VBD`/3V3 maximum terms remain open, so 4.2 mA is explicitly not the complete shared-ADC controller-side power.

This change can preserve topology/connectivity evidence while invalidating downstream board-power claims that consumed the older guaranteed subtotal. It also preserves the rail boundary: board integration must not add 5-V milliamps directly to protected-24-V current without the actual regulator topology, efficiency and startup behavior.

The adversarial finding is that `shared_adc_dac/STATUS_CHECKLIST.md` has not yet incorporated Rev32 despite the repository rule that material evidence/design changes update the checklist in the same change. A lifecycle consumer that looked only at that status surface could therefore miss current evidence. This is exactly why proof/status applicability needs dependency-driven drift detection rather than passive files.

## Catalog stress-test result

Classification: **ENGINEERING_REVIEW_NEEDED** for a machine-readable proof-lifecycle layer supporting stable proof/claim/facet IDs, reverse dependencies, exact authority/configuration digests, trigger classes, partial/narrowed state, unresolved physical facts, proof-to-generated-artifact/release consumption, renewal lineage, Show Where Used for evidence, and fail-closed detection when current status authority omits material newer evidence.

OpenPressBrake remained read-only because current main is actively advancing independent block/integration work. The Rev32/checklist drift was recorded rather than racing engineering changes.

## Current repository reconciliation

At run start the board-design lane ended at BD57. Curriculum main also contained concurrent safety-course work and was preserved. OpenPressBrake had advanced to current shared-ADC and motor-drive integration work.

BD58 was committed as `0ec7bdc20cdfd4b416b3e32a3815ddff342f04fd` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD58 commit and OpenPressBrake main was `cbce2e989dffd756d96524309423238c4abd36c5` (`motor drive: publish machine-readable Rev1 resource contract`). OpenPressBrake stayed read-only.

## Next exact work

Build BD59 on **evidence consumption locks, release manifests, and stale-proof rejection**:

`current claims + promoted evidence/proofs -> release evidence manifest -> exact consumption locks -> generation/release candidate -> dependency drift -> stale-proof rejection -> targeted recovery -> release promotion`

Stress the transition from maintaining evidence correctly to proving that a particular generated schematic/board/FPGA/HAL/release candidate consumed only current evidence. Include mixed cases where most proof records remain current but one shared-resource or machine-fact dependency has expired.

## Compute

No simulation, synthesis, place-and-route, timing run or other executable engineering verification was required for BD58. No GitHub-hosted compute was initiated.

## Safety boundary

BD58 teaches proof lifecycle for ordinary board-design/controller authority. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation or personnel-safety authority. Ordinary LinuxCNC/FPGA evidence remains zero-credit for personnel safety unless separate safety-rated design and validation explicitly establishes otherwise.
