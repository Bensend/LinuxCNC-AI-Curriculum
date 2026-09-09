# S02-003 — frozen observability preflight attempt 3 artifact reconciliation

Date: 2026-09-09
Workflow: `34395045007`
Job: `102612545123`
Artifact: `10121277076`
Job runtime: 2026-09-09T19:26:17Z–2026-09-09T19:29:42Z = 3.4 min
Source commit: `8cf4064ab15dee70c5e0e253c58740f1027099de`

## Classification

**NON-AUTHORITATIVE PREFLIGHT PASS — artifact-level evidence retention validated.** Frozen S02 Gates A–J remain **UNSCORED** until a separate authoritative execution.

This is the third/final incremental run in the initial preflight lineage. The lineage ends in a valid preflight, so no fourth incremental preflight is permitted or needed.

## Independent artifact inspection

Artifact `10121277076` was downloaded and unpacked independently of the workflow success flag. The uploaded run tree contains:

- `atomic.samples` — 89,890 bytes;
- `analysis.txt`;
- `predeclared-model.txt`;
- `s02_model.comp` and generated `s02.hal`;
- pinned `linuxcnc-commit.txt`;
- `topology.txt` and `thread.txt`;
- `halsampler.stderr` (empty);
- `recorder-health.txt`;
- HAL/realtime setup logs.

Fresh offline parsing of `atomic.samples` found:

- exactly **1,400** retained rows;
- sample tags exactly contiguous **0..1399** (no gaps or duplicates);
- phase counts: P0=185, P1=200, P2=200, P3=200, P4=200, P5=415;
- `sampler-overruns=0` and empty `halsampler.stderr`;
- transport healthy in every retained phase row.

### Frozen discriminator checks

- **P0:** zero pair-disagreement, oracle-stale, restricted-detector, common-mode or quadrature assertions.
- **P1:** pair disagreement asserted on the first retained P1 sample (phase-relative sample 0), satisfying the frozen `<=1` servo-cycle bound with transport healthy.
- **P2:** synthetic physical B spans 2.000..2.398 while reported B remains exactly 2.000; oracle-stale first asserts at phase-relative sample 26, satisfying the frozen `<=30` servo-cycle bound with transport healthy.
- **P3:** all retained P3 rows explicitly assert `freshness_unknown`; unchanged/equal values are not labeled healthy.
- **P4:** reported A and B agree exactly while both are 0.5 units away from the synthetic physical oracle; pair disagreement and the restricted detector remain false in all 200 P4 rows while transport remains healthy.
- **P5:** modeled quadrature diagnostic asserts throughout retained P5 rows while pair disagreement/restricted detector remain false.

## Evidence boundary

The synthetic `physical_*` and `oracle_*` signals are test-only laboratory ground truth. They demonstrate observability limits but are not LinuxCNC production sensor-validity signals and cannot be assumed in a real machine design.

## Next action

Launch one separate authoritative execution using the **unchanged** frozen P0–P5 semantics, Gates A–J, and numeric contract validated here. Score Gates A–J only after independently inspecting the authoritative retained artifact; workflow success alone is insufficient.
