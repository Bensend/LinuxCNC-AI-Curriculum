# 3600 Press-Brake Preparation — Empirical Bend-Table Semantics

Date: 2026-09-12
Status: dependency-safe 3600 documentation/source-interface research; no machine-specific values claimed.

## Question

After the public nominal-calculator audit established that formula inputs and actual consumed inputs can diverge, is there public evidence for a richer empirical/tool-aware bend-table layer, and what semantics/interpolation behavior would an importer need to preserve?

## Evidence reviewed

### Vertex G4 — Bend Deduction Table

Current public help describes a bend-deduction database organized by material, thickness, die opening `V`, punch radius and bend angle. For each material/thickness pair, the table stores **one half of the bend deduction**. The documentation states values may be determined experimentally and warns that machine-manufacturer tables may use a different full/half convention.

Classification: **DOC-CONFIRMED**.

### BricsCAD Mechanical — Bend Table

Current public help describes a CSV bend-table format whose header carries format/version, internal `AngleType`, tangent-point bend-deduction `LengthType`, and tables keyed by sheet thickness. Product documentation describes measured deformation data across bend angle, radius and thickness.

Classification: **DOC-CONFIRMED**.

### Ansys SpaceClaim / Discovery — compensation and radius table modes

Public help distinguishes compensation data from radius data. In radius-table mode, a thickness + Vee-die-width combination selects a table mapping tool radius and angle to the **actual radius applied to the geometry**; the looked-up radius becomes stored in the bend.

Classification: **DOC-CONFIRMED**.

### Onshape public API client — table retrieval provenance surface

Pinned public API client revision: `onshape-public/go-client@2df2d21df769407a32742102bc22134824d07061`.

`PartApi.GetBendTable` returns `BTTableResponse1546`, which contains `SourceMicroversion` plus a structured `Table`. `BTTable1825` exposes row values, column metadata, row/column counts, table ID, title/status and table rows.

This does not establish how empirical values were generated, but demonstrates a CAD interface exposing table data and source-version identity together.

Classification: **SOURCE-CONFIRMED** for the public API data model.

### FreeCAD SheetMetal — open-source lookup paths

Pinned revision: `shaise/FreeCAD_SheetMetal@db3f87556cf8930257b69096cabe00e660caa416`.

`SheetMetalKfactor.py::KFactorLookupTable` reads a spreadsheet whose key is explicitly `Radius / Thickness`; its K-factor column must identify a standard, and ambiguous/missing standards are rejected. Parsed standards are constrained to `ansi` or `din`.

`SMTests/testKfactor.py` creates radius/thickness keys `1`, `3`, `99`, verifies K values `0.38`, `0.43`, `0.5`, and verifies the standard is `ansi`.

Critically, two unfold engines at the **same pinned repository revision** use materially different lookup policies:

#### Legacy `SheetMetalUnfolder.py`

`k_Factor` calls:

`get_val_from_range(k_factor_lookup, innerRadius / thickness)`

without enabling interpolation. `lookup.py::get_val_from_range(..., interpolate=False)` therefore behaves as a step/range lookup: it sorts the table, returns the first table value at/above an in-range query, and clamps beyond the high end to the last value. The source contains assertions for this behavior.

#### Newer `SheetMetalNewUnfolder.py`

The newer lookup path consumes the same radius/thickness concept but source comments explicitly specify:

- below the lowest table ratio: first K-factor;
- above the highest ratio: last K-factor;
- between specified ratios: **piecewise linear interpolation**.

This is an adversarially important correction: it would be wrong to say "FreeCAD SheetMetal uses linear interpolation" without naming the unfold engine/versioned path. Lookup policy is part of implementation provenance even inside one repository revision.

Classification: **SOURCE-CONFIRMED**.

## Main finding — a "bend table" is not one portable semantic object

The phrase **bend table** is insufficient provenance. Public implementations/documentation demonstrate at least:

1. full or half bend deduction;
2. bend allowance/compensation;
3. K/Y-factor data;
4. actual bend radius lookup;
5. internal-angle versus other angle conventions;
6. tangent-point versus apex/outside-flange datums;
7. material/thickness-only indexing versus V-die/punch/tool indexing;
8. distinct interpolation/range-selection policies;
9. distinct policies even between old/new calculation engines in the same project.

Copying only rows without semantic, implementation and lookup-policy metadata can therefore create plausible but wrong flat patterns.

## Tooling/process implication

A tool-aware empirical table may sit between nominal CAD geometry and machine target generation, but remains a distinct artifact:

`MaterialRevision + Thickness + ToolingRevision + BendMethod + TableSemanticRevision + LookupEngineRevision -> EmpiricalBendTableLookup`

The result feeds nominal/compensated geometry; it does **not** create runtime machine authority.

## Required table provenance contract

A reusable table import should preserve or explicitly normalize:

- source system/repository and revision/microversion;
- calculation/unfold engine identity;
- table ID/version;
- material identity/revision;
- thickness units/value;
- tooling dimensions/identities used as keys;
- bend method when known;
- angle convention;
- value semantic (`full BD`, `half BD`, `BA`, `K`, `actual radius`, etc.);
- dimensional datum;
- units;
- lookup key definition such as `radius/thickness`;
- interpolation/range-selection policy;
- below-range and above-range behavior;
- exact/step-selected/interpolated/clamped result state;
- measurement/manufacturer/calculated origin when known;
- UNKNOWN for semantics not established by evidence.

Do not silently normalize an unknown table into a preferred internal convention.

## Adversarial cases

### Case 1 — half/full deduction confusion

Importing a Vertex-style half-deduction as full BD creates a factor-of-two error that remains dimensionally plausible.

### Case 2 — angle convention mismatch

Internal angle, material rotation and complementary/included angle can select different rows or calculations.

### Case 3 — radius table mistaken for deduction table

SpaceClaim radius-table output is an actual radius, not a bend-deduction length semantic.

### Case 4 — tooling-blind reuse

A V-opening/punch-radius indexed table cannot be reused safely under different tooling solely because material/thickness match.

### Case 5 — stale table revision

Without table/source revision identity, reconciliation after empirical or tooling updates is unreliable. Onshape `SourceMicroversion` illustrates one version-provenance mechanism.

### Case 6 — lookup-engine mismatch

The same FreeCAD K-factor rows can produce different in-between values depending on whether the legacy range/step lookup or newer linear-interpolation engine is used. Row provenance alone is therefore insufficient.

### Case 7 — extrapolation assumption

A consumer that linearly extrapolates beyond a table boundary can disagree with an implementation that clamps to its first/last value. Out-of-range policy must be explicit.

## Claims ledger

| Claim | Classification | Confidence |
|---|---|---:|
| Vertex can store half bend deduction by material/thickness/V opening/punch radius/angle | DOC-CONFIRMED | High |
| Vertex permits experimentally determined values and warns manufacturer table conventions may differ | DOC-CONFIRMED | High |
| BricsCAD bend tables carry angle and length/datum semantics | DOC-CONFIRMED | High |
| SpaceClaim supports radius-table semantics distinct from compensation | DOC-CONFIRMED | High |
| Onshape public bend-table response exposes `SourceMicroversion` plus structured table data | SOURCE-CONFIRMED | High |
| FreeCAD SheetMetal keys K-factor tables by radius/thickness and requires ANSI/DIN semantic identity | SOURCE-CONFIRMED | High |
| FreeCAD legacy unfold uses non-interpolating range lookup while newer unfold uses piecewise-linear interpolation | SOURCE-CONFIRMED at pinned revision | High |
| A project/repository name alone defines the interpolation policy | FALSIFIED by source trace | High |
| Raw bend-table rows are portable without semantic/engine metadata | FALSIFIED | High |
| A universal interpolation rule can be inferred across systems | UNKNOWN / unsupported | High confidence evidence insufficient |
| These tables define production ram/backgauge targets by themselves | UNKNOWN / explicitly unsupported | High confidence evidence insufficient |

## Experiment / verification decision

No new GitHub Actions experiment is justified. FreeCAD's implementation and source assertions already provide independently checkable behavior for the legacy lookup, while the newer source directly specifies its distinct interpolation path. A synthetic duplicate would not add meaningful evidence.

The source trace itself served as adversarial verification and produced a correction: the initial broad statement that "FreeCAD SheetMetal clamps and linearly interpolates" was narrowed to the newer unfold engine, with legacy non-interpolating behavior recorded separately.

Future experimental work becomes justified when there is an open measured-coupon **fitting/table-generation** algorithm or a real tool-aware backgauge/target solver whose transformations can be frozen and tested.

## Integration rule

`Source/TableRevision + CalculationEngineRevision + TableSemantic + LookupPolicy + ConsumedInputSet + Material/Thickness + ToolingLookupKeys + AngleConvention + DimensionDatum -> EmpiricalLookupResult(exact/step/interpolated/clamped) -> Nominal/CompensatedGeometry`

Keep machine calibration/correction, TargetSet generation and ExecutionEpisode authority separately versioned downstream.

## Next checkpoint

1. Re-check F02 first; do not self-score it.
2. Nominal-formula, bend-table semantic and table-lookup branches now have enough evidence for dependency-safe preparation. Stop collecting equivalent calculators/tables/interpolation examples.
3. Further calculation-domain work requires genuinely new implementation information: measured-coupon fitting/table generation, a real tool-aware flange/gauging-surface-to-backgauge solver, or production tooling/method calculation with explicit datums.
4. Preserve UNKNOWN when full/half, angle, datum, engine, interpolation, out-of-range or process origin is not established.
