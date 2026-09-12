# 3600 Press-Brake Preparation — Empirical Bend-Table Semantics

Date: 2026-09-12
Status: dependency-safe 3600 documentation/source-interface research; no machine-specific values claimed.

## Question

After the public nominal-calculator audit established that formula inputs and actual consumed inputs can diverge, is there public evidence for a richer empirical/tool-aware bend-table layer, and what semantics/interpolation behavior would an importer need to preserve?

## Evidence reviewed

### Vertex G4 — Bend Deduction Table

Current public help describes a bend-deduction database organized by material, thickness, die opening `V`, punch radius and bend angle.

For each material/thickness pair, the table stores **one half of the bend deduction**, not necessarily a full bend-deduction value. The documentation states values may be determined experimentally; it also warns that machine-manufacturer tables may use a different convention and should not automatically be assumed to contain half-deductions.

Classification: **DOC-CONFIRMED** for Vertex semantics.

### BricsCAD Mechanical — Bend Table

Current public help describes a CSV bend-table format whose header explicitly carries semantic metadata including format/version, internal `AngleType`, tangent-point bend-deduction `LengthType`, and multiple tables keyed by sheet thickness.

Product documentation also describes bend tables as a measured-deformation representation in which observations may be collected for different bend angles, radii and thicknesses.

Classification: **DOC-CONFIRMED** for BricsCAD table semantics.

### Ansys SpaceClaim / Discovery — compensation and radius table modes

Public help documents editable CSV bend tables and distinguishes compensation data from radius data.

In radius-table mode, a thickness + Vee-die-width combination selects a table mapping tool radius and angle to the **actual radius applied to the geometry**. The looked-up actual radius is then stored in the created bend.

Classification: **DOC-CONFIRMED** for this CAD representation.

### Onshape public API client — table retrieval provenance surface

Pinned public API client revision: `onshape-public/go-client@2df2d21df769407a32742102bc22134824d07061`.

`PartApi.GetBendTable` returns `BTTableResponse1546`. The generated response model contains `SourceMicroversion` plus a structured `Table`. `BTTable1825` exposes row values, column metadata, row/column counts, table ID, title/status and table rows.

This is not evidence of how empirical values were generated, but it demonstrates that a CAD table-retrieval interface can expose table data and source-version identity together.

Classification: **SOURCE-CONFIRMED** for the public API data model, not for measurement/fitting method.

### FreeCAD SheetMetal — open-source lookup and interpolation path

Pinned revision: `shaise/FreeCAD_SheetMetal@db3f87556cf8930257b69096cabe00e660caa416`.

`SheetMetalKfactor.py::KFactorLookupTable` reads a spreadsheet whose key column is explicitly labeled `Radius / Thickness` and whose value column must declare a `K-factor` standard. It rejects missing/ambiguous K-factor standard semantics and accepts only `ansi` or `din` after parsing.

The accompanying source test builds a table with radius/thickness keys `1`, `3`, and `99`, verifies corresponding K values `0.38`, `0.43`, and `0.5`, and verifies the parsed standard is `ansi`.

The newer unfold source consumes the table as a function of `innerRadius / thickness`. Its source explicitly documents these lookup behaviors:

- below the table range: use the first K-factor value;
- above the table range: use the last K-factor value;
- within the range: perform **piecewise linear interpolation**.

Thus an open implementation confirms that interpolation/extrapolation policy is not an incidental implementation detail: it directly changes the effective K-factor used by the unfold calculation.

Classification: **SOURCE-CONFIRMED** at the pinned FreeCAD SheetMetal revision.

## Main finding — a "bend table" is not one portable semantic object

The phrase **bend table** is insufficient provenance.

Public implementations/documentation demonstrate at least these distinct semantics:

1. full or half bend deduction;
2. bend allowance/compensation;
3. K/Y-factor style data;
4. actual bend radius lookup;
5. internal-angle versus other angle conventions;
6. tangent-point versus apex/outside-flange dimension references;
7. material/thickness-only indexing versus explicit V-die/punch/tool indexing;
8. different interpolation and out-of-range policies.

Therefore copying raw rows between systems without carrying semantic and lookup-policy metadata can produce numerically plausible but wrong flat patterns.

## Tooling/process implication

A tool-aware empirical table can legitimately sit between nominal CAD geometry and machine target generation, but it must remain a distinct artifact:

`MaterialRevision + Thickness + ToolingRevision + BendMethod + TableSemanticRevision + LookupPolicyRevision -> EmpiricalBendTableLookup`

The lookup result feeds nominal/compensated geometry. It does **not** itself create runtime machine authority.

For a table keyed by tooling, minimum useful tooling identity includes enough information to distinguish the actual lookup axes used by the source system, e.g. V opening and punch/tool radius where those are table keys.

## Required table provenance contract

A reusable table import should preserve or explicitly normalize:

- source system and source revision/microversion;
- table ID/version;
- material identity/revision;
- thickness units/value;
- tooling dimensions/identities used as lookup keys;
- bend method when known;
- angle convention (`internal`, `included`, `rotation`, etc.);
- length/value semantic (`full BD`, `half BD`, `BA`, `K`, `actual radius`, etc.);
- dimensional datum (`tangent`, `apex`, outside flange, etc.);
- units;
- lookup key definition such as `radius/thickness`;
- interpolation policy;
- below-range and above-range behavior;
- exact-match versus derived/interpolated/clamped result state;
- measurement/manufacturer/calculated origin when known;
- UNKNOWN for any semantic field not established by evidence.

Do not silently normalize an unknown table into a preferred internal convention.

## Adversarial cases

### Case 1 — half/full deduction confusion

If a Vertex-style half-deduction row is imported as full BD, compensation is wrong by a factor of two while remaining dimensionally plausible. Numeric schema validation does not catch it.

### Case 2 — angle convention mismatch

A row keyed by internal angle can select the wrong value if an importer supplies material rotation or included/complementary angle without conversion and provenance.

### Case 3 — radius table mistaken for deduction table

SpaceClaim's radius-table mode can return actual bend radius, not flat-pattern deduction. Treating that numeric length as BD is a semantic/type error.

### Case 4 — tooling-blind reuse

A table whose values depend on V opening and punch radius cannot be safely reused under different tooling merely because material and thickness match.

### Case 5 — stale table revision

A table result without source/table revision identity cannot be reliably reconciled after tooling, material, or empirical values change. Onshape's `SourceMicroversion` illustrates one version-provenance surface.

### Case 6 — interpolation-policy mismatch

Given identical table rows, a clamp-at-endpoints + linear-interpolation implementation can return a different value than nearest-neighbor, spline, extrapolated-linear, or reject-out-of-range behavior. FreeCAD SheetMetal's explicit clamp + piecewise-linear policy makes this concrete.

An importer must not preserve only the rows and silently substitute its own interpolation policy.

## Claims ledger

| Claim | Classification | Confidence |
|---|---|---:|
| Vertex bend tables can store half bend deduction indexed by material/thickness/V opening/punch radius/angle | DOC-CONFIRMED | High |
| Vertex explicitly allows experimentally determined values and warns manufacturer tables may use different full/half conventions | DOC-CONFIRMED | High |
| BricsCAD bend-table format carries angle and length/datum semantics | DOC-CONFIRMED | High |
| SpaceClaim supports radius-table semantics distinct from compensation | DOC-CONFIRMED | High |
| Onshape's public bend-table API response exposes `SourceMicroversion` plus structured table rows/columns | SOURCE-CONFIRMED at pinned API-client revision | High |
| FreeCAD SheetMetal material tables explicitly key K-factor by radius/thickness and require ANSI/DIN semantic identity | SOURCE-CONFIRMED | High |
| FreeCAD SheetMetal clamps below/above table range and linearly interpolates inside it | SOURCE-CONFIRMED | High |
| Raw bend-table numbers are portable without semantic/lookup metadata | FALSIFIED by documentation/source comparison | High |
| A universal interpolation rule can be inferred across systems | UNKNOWN / unsupported | High confidence evidence is insufficient |
| These tables define production ram/backgauge targets by themselves | UNKNOWN / explicitly unsupported | High confidence evidence is insufficient |

## Experiment decision

No new GitHub Actions experiment is justified. The FreeCAD implementation and source-level unit test already provide independently checkable implementation evidence for a real lookup table. A synthetic duplicate would add little.

Future experimental work becomes justified when there is an actual open measured-coupon **fitting/generation** algorithm or a real tool-aware backgauge/target solver whose transformations can be frozen and tested.

## Integration rule

Extend the current calculation lineage to:

`Source/TableRevision + TableSemantic + LookupPolicyRevision + ConsumedInputSet + Material/Thickness + ToolingLookupKeys + AngleConvention + DimensionDatum -> EmpiricalLookupResult(exact/interpolated/clamped) -> Nominal/CompensatedGeometry`

Then keep separately versioned machine calibration/correction, TargetSet generation and ExecutionEpisode authority downstream.

## Next checkpoint

1. Re-check F02 first; do not self-score it.
2. The generic nominal-formula, bend-table semantic and table-lookup branches now have enough evidence for current dependency-safe preparation. Do not keep collecting equivalent tables or interpolation examples.
3. Further calculation-domain research requires new information: measured-coupon fitting/table generation source, a real tool-aware flange/gauging-surface-to-backgauge solver, or a production tooling/method calculation path with explicit datums.
4. Preserve UNKNOWN when a table's full/half, angle, datum, interpolation, out-of-range or process origin cannot be established.
