# PB-DXF-004 TargetCalculation / TargetSet provenance fixture — independent audit

Date: 2026-09-12
Status: TEST-CONFIRMED / frozen Gates A–J 10/10

## Provenance

- frozen experiment: `experiments/PB-DXF-004-targetset-provenance-plan.md`
- implementation: `lab-jobs/088-pb-dxf-004-targetset-provenance.sh`
- workflow: `34670122426`
- job: `103489793017`
- source commit: `3af3549b7ed5a0b852cd4d4067076e2f7cdcd22c`
- retained artifact: `10290852409`
- exact Actions job interval: `2026-09-12T03:21:01Z` to `2026-09-12T03:21:11Z` = 10 s = 0.17 min

## Independent retained-state review

Direct inspection of `lab-results/pb-dxf-004/records.json` supports every frozen gate:

- **A PASS** — P0 accepts a DIRECT_MACHINE_COORDINATE target only with current GP1/R1, complete X mechanism coverage and calibration provenance C1; generation 1 is assigned only after validation.
- **B PASS** — P1 CALCULATED target retains method `flange-x-demo-v1`, GP/calibration/tooling/bend-model dependencies and receives distinct generation 2.
- **C PASS** — P2 changes current calibration from C1 to C2; the previously accepted calculated target becomes REVIEW_REQUIRED with `DEPENDENCY_CHANGED:calibration`. Generation 2 is retained as historical provenance, not treated as renewed authority.
- **D PASS** — P3 deliberately reuses the same opaque numeric X=95.0 but remains REVIEW_REQUIRED until dependency rebinding/explicit validation; only then does it receive new generation 3. Numeric coincidence does not authenticate current provenance.
- **E PASS** — P4 makes the GaugePlan REVIEW_REQUIRED; dependent direct TargetSet becomes REVIEW_REQUIRED / `GAUGEPLAN_REVIEW_REQUIRED` and has no authorized generation.
- **F PASS** — P5 changes GaugePlan mechanism set to `{X,R}` while the TargetSet supplies only X; acceptance fails with `MECHANISM_COVERAGE_MISMATCH`.
- **G PASS** — P6 first rejects imported CAM target lacking compatibility provenance (`CAM_PROVENANCE_INCOMPLETE`), then accepts only after package, compatibility, calibration and GP revision provenance are present; generation 4 is assigned.
- **H PASS** — P7 demonstrates direct/operator coordinates are not exempt from provenance; current GP/calibration/mechanism evidence is still required before generation 5.
- **I PASS** — successful current acceptances advance generations 1,2,3,4,5 monotonically; invalid/review states do not create a new generation or resurrect an old one.
- **J PASS** — no LinuxCNC command, `posthome-cmd`, `limit3` input, machine-enable, tooling/collision decision, hydraulic command or safety authorization is emitted.

Frozen Gates A–J: **10/10 PASS**. The predeclared prediction matched observation.

## Adversarial interpretation

The fixture intentionally uses opaque numbers (100.0, 95.0, 91.0, 101.0). Their numerical values are not validated as physically correct backgauge locations. The evidence is solely about ownership, dependency provenance, invalidation and runtime-generation discipline.

A historical nonzero generation on a TargetSet that later becomes REVIEW_REQUIRED is provenance, not current motion authority. Downstream runtime code must consume an explicit current-authority decision and new/current episode rather than infer authority from `generation > 0` alone.

Likewise, DIRECT_MACHINE_COORDINATE means the operator supplied a machine-coordinate value; it does not mean the value bypasses current GaugePlan, calibration, mechanism-set or rearm checks.

## Sufficiency / next-work decision

PB-DXF-004 closes the current TargetCalculation/TargetSet provenance and generation-semantics question. Do not add further synthetic target-state cases merely for volume.

The next useful 3600 integration is the **TargetSet -> runtime target episode bridge**: bind a current accepted TargetSet generation to the PB-BG-003 application-owned command episode, ensure invalidation/revalidation cannot silently reuse an old episode, and preserve `limit3` as downstream numeric shaping rather than authorization. This can remain an application/control-ownership test; no motor physics or guessed flange-to-X formula is required.

The global 2000-series critical path remains unchanged: `handoffs/F02-fresh-ai-compound-fault-transfer.md` still requires a genuinely information-separated evaluator and must not be self-scored here.
