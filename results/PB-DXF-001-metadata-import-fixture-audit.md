# PB-DXF-001 metadata importer fixture — independent audit

Date: 2026-09-12
Status: TEST-CONFIRMED / frozen Gates A–J 10/10

## Provenance

- frozen contract: `experiments/PB-DXF-001-metadata-import-fixture-plan.md`
- implementation: `lab-jobs/085-pb-dxf-001-metadata-import-fixture.py`
- workflow: `34666985713`
- job: `103480777779`
- source commit: `6d34bb99fc8b4138a46db74732076825c90a05aa`
- retained artifact: `10289153538`, `pb-dxf-001-evidence`
- artifact digest reported by Actions: `sha256:d1f40446123603c362fe85ec8eb31b1ab88f9845488e217cd6a1ea0920db11b8`

## Independent result review

The job log shows the frozen fixture exited successfully and printed `pass: true`. Inspection of the retained-output content in the job log supports each gate independently:

- A PASS — P0 retained one CUT record separately and exactly two BEND candidates.
- B PASS — P1 retained both coincident source locators and emitted `COINCIDENT_CANDIDATES`.
- C PASS — P2 kept two non-coincident collinear finite segments distinct with no duplicate diagnostic.
- D PASS — P3 emitted explicit `UNKNOWN` for angle, radius and direction.
- E PASS — P4 permutation retained the same candidate IDs/fingerprints as P0.
- F PASS — P5 revision R2 generated revision-scoped candidate IDs distinct from R1, preventing silent old-identity reuse.
- G PASS — P6 moved geometry produced a distinct fingerprint/candidate for the changed bend.
- H PASS — P7 emitted `STALE_SIDECAR`, suppressed stable UUID authority and replaced stale angle/radius/direction with UNKNOWN.
- I PASS — P8 accepted `BEND-A` and its semantic metadata only with matching sidecar/source revision binding.
- J PASS — output remains metadata/provenance only and contains no gauge/motion/tooling/sequencing fields.

Frozen Gates A–J: **10/10 PASS**.

## Adversarial review / correction boundary

The result does not prove that candidate IDs are globally durable identities. They are deliberately scoped by source revision; cross-revision geometry is at most remap evidence unless a trusted revision-bound stable ID exists. Coincident source entities sharing a candidate hash are also not silently collapsed: both provenance records remain visible under a duplicate diagnostic. This distinction is required for auditability.

The fixture is intentionally source-neutral and does not validate arbitrary DXF parsing, tolerance choice for real CAD files, bend truth, automatic sequencing, backgauge target computation, tooling, collision avoidance, machine motion, or functional safety.

No post-result gate or threshold change was required.

## Sufficiency decision

PB-DXF-001 closes the current metadata-only importer semantics question. Do not deepen this into geometry/motor simulation merely for test volume. The next useful DXF/backgauge work should be source integration or human-confirmation workflow design unless a LinuxCNC-specific ambiguity appears.
