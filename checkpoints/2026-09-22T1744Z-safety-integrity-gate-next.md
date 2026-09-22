# 4000 Safety Curriculum Checkpoint — Integrity Method Gate

UTC checkpoint: 2026-09-22T17:44Z

## Durable work completed

Added:

- `safety-course/2520_INTEGRITY_METHOD_SELECTION_AND_TARGET_ALLOCATION_2026-09-22.md`
- `safety-course/SAFETY_INTEGRITY_METHOD_GATE_WORKSHEET.md`
- `safety-course/2520_ADVERSARIAL_ASSESSMENT_HAZARD_TO_INTEGRITY_GATE_2026-09-22.md`

The methodology now places integrity-method/edition selection and required-target derivation after hazard/SRS, fault analysis and architecture allocation. ISO 13849-style structural Category, reliability, DC and CCF inputs are separated from PLr derivation and validation. IEC 62061-style architectural/systematic constraints and dangerous-random-hardware evidence are likewise kept separate. No machine-specific PLr/SIL, PFHd, MTTFd, DC, CCF, timing or physical truth-table values were invented.

A symbolic example and explicit high-rated-controller/shared-final-element counterexample prevent component-rating substitution. A formal adversarial assessment now spans the complete 2520 chain through the integrity gate.

No executable compute was justified. No GitHub-hosted runner was used.

## Exact next work

1. Review/execute the chain-level adversarial assessment as a non-blind curriculum test and correct actual methodology gaps.
2. Build the next learner-facing stage: verification-versus-validation planning derived directly from HZ/PROP/SF/FLT/ARCH requirements.
3. Create a reusable validation matrix separating document/design verification, functional validation, diagnostic/fault validation, physical-process proof, recovery/restart validation and maintenance/change revalidation.
4. Mark machine/hardware-dependent tests as requiring physical evidence/human involvement; never fabricate results.
5. Stress-test across a gravity/fluid-power axis and a rotating-tool/automated cell without transferring machine-specific physics.
6. Audit 2520 for fresh-AI handoff readiness after validation methodology is durable.
