# 4000 Safety Curriculum Checkpoint — Architecture / Integrity Allocation

UTC checkpoint: 2026-09-22T16:51Z

## Durable work completed

Added:

- `safety-course/2520_ARCHITECTURE_INTEGRITY_ALLOCATION_FROM_FAULT_ANALYSIS_2026-09-22.md`
- `safety-course/SAFETY_ARCHITECTURE_ALLOCATION_WORKSHEET.md`

The new stage follows the completed fault/diagnostic analysis. Dangerous-undetected, latent and common-cause gaps now drive explicit architecture requirements before component selection or PL/SIL arithmetic. Redundancy, fault tolerance, diagnostic coverage and physical independence are taught as separate properties. Every claimed independent path requires reverse `DEP-*` tracing. Final-element feedback is bounded to the proposition it actually supports, and architectures must expose practical physical/process validation surfaces.

Professional anchors include Pilz ISO 13849 guidance separating structural Category, MTTFd, DC and CCF contributions; Pilz safety-relay redundancy/self-monitoring as a concrete architecture example; and Rockwell Logix SIS redundancy behavior showing that redundancy/high availability is not a universal unchanged-integrity claim.

Stress tests cover the automated cut/feed cell and generic gravity/fluid-power axis. The shared-final-element trap is explicit. An adversarial case demonstrates that all electronic diagnostics may be healthy while a post-maintenance physical process proposition remains stale/unknown.

No executable compute was justified. No GitHub-hosted runner was used.

## Exact next work

1. Continue into integrity-method selection and target allocation from risk assessment/SRS, not topology.
2. Teach the roles of structural Category/architecture, reliability, DC, CCF/systematic-fault controls and validation without inventing values or silently mixing standard editions/methods.
3. Prefer a symbolic worked example; introduce manufacturer numerical data only with explicit provenance/applicability.
4. Add a counterexample where a high-rated component/redundant controller cannot compensate for an unproved shared final element/process proposition.
5. Review the completed 2520 chain for a formal adversarial assessment spanning hazard derivation through integrity-method gate.
6. Preserve the independent safety boundary and human-factors requirements.
