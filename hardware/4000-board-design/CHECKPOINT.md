# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD57 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD57_EVIDENCE_EQUIVALENCE_DECISIONS_AND_PRESERVATION_PROOFS.md`.

BD57 teaches:

`changed dependency -> claimed equivalence -> equivalence criteria -> counterexample search -> bounded preservation proof -> reviewer authority -> preserved-evidence record -> future invalidation trigger`

## BD57 hard student-material audit

Every repository file named to students as finished material by BD57 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `README.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `hardware/4000-board-design/BD56_EVIDENCE_DEPENDENCY_GRAPHS_SELECTIVE_INVALIDATION_AND_MINIMUM_SAFE_REVALIDATION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/lvdt_input/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/lvdt_input/manifest.yaml`
- OpenPressBrake `hardware/blocks/lvdt_input/integration/REV1_BOARD_INTEGRATION_HANDOFF.md`

`ENGINEERING_REVIEW_NEEDED` as a complete current-status authority:

- OpenPressBrake `hardware/blocks/lvdt_input/REFERENCE_REBASE.md` — its current-exact-connectivity section still says `manifest.yaml` is Rev-2-era and must be reconciled, while current `manifest.yaml` and the authoritative status checklist record that Rev 9 already reconciled it. BD57 uses the file only for bounded provenance/delta facts consistent with current authority and as defect evidence.

BD57 itself was re-opened from current main after commit.

## Rules frozen by BD57

- preservation is a claim-specific proof obligation, not a convenience decision;
- unchanged output does not prove unchanged premises;
- unchanged topology does not prove unchanged operating envelope;
- equivalence criteria must be defined against the named claim and complete relevant premise set;
- counterexample search is mandatory before evidence preservation;
- evidence may be `PROVEN_EQUIVALENT_FOR_CLAIM`, `PRESERVED_WITH_NARROWER_SCOPE`, `NOT_EQUIVALENT_REVALIDATE`, `BLOCKED_UNKNOWN`, `SUPERSEDED`, or `HISTORICAL_ONLY`;
- stale/contradictory authority blocks a trustworthy preservation proof;
- old evidence cannot be promoted merely by relabeling it against a new topology;
- negative scope and future invalidation triggers belong in every preservation record;
- board-specific equivalence does not justify contaminating a reusable primitive; and
- ordinary-control equivalence arguments receive zero personnel-safety credit without separate safety-rated authority.

## Worked-example stress test

Current OpenPressBrake valve-position feedback is a useful mixed-equivalence case. The legacy block ID remains `lvdt_input`, but current machine authority resolves a powered three-wire 0..12-V transducer rather than a raw LVDT. That interface change is not semantically equivalent merely because both measure valve position.

The current checklist also explicitly bounds historical Rev-2 simulation evidence to the Rev-2 topology. Rev-7 changed buffer/protection/acquisition details, so historical simulation is not current-topology qualification. Conversely, the new Rev-1 board handoff says it creates no new electrical topology: it consumes the existing primitive and shared ADS7953 contract. Therefore a bounded primitive claim such as nominal divider mapping may preserve its existing calculation evidence if every claim-relevant premise is demonstrated unchanged, while sensor branch protection, installed endpoint, calibration, bandwidth, grounding, PCB noise, transient qualification and connector mapping remain separate/open claims.

The current `REFERENCE_REBASE.md` stale manifest-reconciliation paragraph demonstrates the central BD57 risk: an equivalence proof can be internally logical yet compare against the wrong authority. Current authority must be pinned before old/new equivalence is evaluated.

## Catalog stress-test result

Classification: **ENGINEERING_REVIEW_NEEDED** for a machine-readable preservation-proof layer supporting stable claim/facet IDs, old/new authority digests, claim-specific equivalence dimensions, counterexample results, negative scope, reviewer authority, future invalidation triggers, BD56 dependency-graph links, and fail-closed behavior when current authority is contradictory.

OpenPressBrake remained read-only because the valve-position/integration area had just advanced on current main. The stale `REFERENCE_REBASE.md` item was recorded rather than overwriting active engineering work.

## Current repository reconciliation

At run start the board-design lane ended at BD56. Curriculum main also contained concurrent safety-course work and was preserved. OpenPressBrake had advanced beyond the prior BD56 checkpoint to current valve-position integration work.

BD57 was committed as `c967ab54104911541a3fc991cbbd9d15937e4f64` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD57 commit and OpenPressBrake main was `2265a71695487998d3f0bab32c504c4ce7438dba` (`valve position: publish Rev1 board integration handoff`). OpenPressBrake stayed read-only.

## Next exact work

Build BD58 on **equivalence-proof lifecycle, review expiration, and assumption drift**:

`preserved-evidence record -> monitored assumptions -> authority/resource/machine-fact drift -> trigger evaluation -> proof expiration or continued validity -> targeted revalidation -> renewed promotion`

Stress cases where an initially valid preservation proof becomes stale later because a shared resource, operating envelope, physical-machine fact, tool/model, or board-layout assumption changes without touching the original evidence file.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was required for BD57. No GitHub-hosted compute was initiated.

## Safety boundary

BD57 teaches evidence-equivalence decisions for ordinary board-design/controller authority. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation, or personnel-safety authority. Ordinary LinuxCNC/FPGA evidence remains zero-credit for personnel safety unless separate safety-rated design and validation explicitly establishes otherwise.
