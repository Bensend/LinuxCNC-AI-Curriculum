# 3600 Press-Brake Preparation — Empirical Bend-Table Semantics

Date: 2026-09-12
Status: dependency-safe 3600 documentation/source-interface research; no machine-specific values claimed.

## Question

After the public nominal-calculator audit established that formula inputs and actual consumed inputs can diverge, is there public evidence for a richer empirical/tool-aware bend-table layer, and what semantics would an importer need to preserve?

## Evidence reviewed

### Vertex G4 — Bend Deduction Table

Current public help describes a bend-deduction database organized by:

- material;
- thickness;
- die opening `V`;
- punch radius;
- bend angle.

For each material/thickness pair, the table stores **one half of the bend deduction**, not necessarily a full bend-deduction value. The documentation states values may be determined experimentally; it also warns that machine-manufacturer tables may use a different convention and should not automatically be assumed to contain half-deductions.

Classification: **DOC-CONFIRMED** for Vertex semantics.

### BricsCAD Mechanical — Bend Table

Current public help describes a CSV bend-table format whose header explicitly carries semantic metadata including:

- format/version;
- `AngleType` — currently internal bend angle;
- `LengthType` — currently tangent-point bend deduction semantics;
- multiple tables keyed by sheet thickness.

Older/current product documentation also describes bend tables as a more reliable way to express measured deformation behavior and notes measurements can be repeated for bend angle, bend radius and thickness.

Classification: **DOC-CONFIRMED** for BricsCAD table semantics.

### Ansys SpaceClaim / Discovery — bend deduction CSV and radius-table mode

Public help documents editable CSV bend tables and distinguishes at least two data meanings:

- compensation data;
- radius data.

In radius-table mode, a thickness + Vee-die-width combination selects a table mapping tool radius and angle to the **actual radius applied to the geometry**. The documentation explicitly states the looked-up actual radius becomes stored in the created bend.

Classification: **DOC-CONFIRMED** for this CAD representation.

### Onshape public API client — table retrieval provenance surface

Pinned public API client revision: `onshape-public/go-client@2df2d21df769407a32742102bc22134824d07061`.

`PartApi.GetBendTable` returns `BTTableResponse1546`. The generated response model contains:

- `SourceMicroversion`;
- `Table`.

`BTTable1825` contains row values, column metadata, row/column counts, table ID, title/status, and table rows. This is not evidence of how empirical values were generated, but it is useful evidence that a production CAD interface can expose both tabular bend data and a source-version identity in the same retrieval surface.

Classification: **SOURCE-CONFIRMED** for the public API data model, not for measurement/fitting method.

## Main finding — a "bend table" is not one portable semantic object

The phrase **bend table** is insufficient provenance.

Public implementations/documentation demonstrate at least these distinct semantics:

1. full or half bend deduction;
2. bend allowance/compensation;
3. K/Y-factor style data;
4. actual bend radius lookup;
5. internal-angle versus other angle conventions;
6. tangent-point versus apex/outside-flange dimension references;
7. material/thickness-only indexing versus explicit V-die/punch/tool indexing.

Therefore copying raw rows between systems without carrying the table's semantic header/convention can produce numerically plausible but wrong flat patterns.

## Tooling/process implication

This pass materially strengthens the 3600 calculation data model. A tool-aware empirical table can legitimately sit between nominal CAD geometry and machine target generation, but it must remain a distinct artifact:

`MaterialRevision + Thickness + ToolingRevision + BendMethod + TableSemanticRevision -> EmpiricalBendTableLookup`

The lookup result then feeds a nominal/compensated geometry calculation. It does **not** itself create runtime machine authority.

For a table keyed by tooling, the minimum useful tooling identity includes enough information to distinguish the actual lookup axes used by the source system, e.g. V opening and punch/tool radius when those are part of that table's indexing.

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
- interpolation/extrapolation policy when known;
- exact-match versus derived/interpolated result state;
- measurement/manufacturer/calculated origin when known;
- UNKNOWN for any semantic field not established by evidence.

Do not silently normalize an unknown table into a preferred internal convention.

## Adversarial cases

### Case 1 — half/full deduction confusion

If a Vertex-style half-deduction row is imported as full BD, the resulting compensation is wrong by a factor of two while still looking dimensionally reasonable. Schema-level numeric validation would not catch it.

### Case 2 — angle convention mismatch

A row keyed by internal angle can select the wrong value if an importer supplies material rotation or included/complementary angle without conversion and provenance.

### Case 3 — radius table mistaken for deduction table

SpaceClaim's radius-table mode can return actual bend radius, not flat-pattern deduction. Treating the returned numeric value as BD would be a type/semantic error even if units are both length.

### Case 4 — tooling-blind reuse

A table whose values depend on V opening and punch radius cannot be safely reused under different tooling merely because material and thickness match.

### Case 5 — stale table revision

A table result without source/table revision identity cannot be reliably reconciled after tooling, material, or empirical values are updated. Onshape's public API `SourceMicroversion` illustrates one way a CAD surface can expose version provenance alongside table data.

## Claims ledger

| Claim | Classification | Confidence |
|---|---|---:|
| Vertex bend tables can store half bend deduction indexed by material/thickness/V opening/punch radius/angle | DOC-CONFIRMED | High |
| Vertex explicitly allows experimentally determined values and warns manufacturer tables may use different full/half conventions | DOC-CONFIRMED | High |
| BricsCAD bend-table format carries angle and length semantics such as internal angle and tangent-point bend deduction | DOC-CONFIRMED | High |
| SpaceClaim supports a radius-table semantic distinct from compensation, indexed by thickness/V-die width/tool radius/angle | DOC-CONFIRMED | High |
| Onshape's public bend-table API response exposes `SourceMicroversion` plus structured table rows/columns | SOURCE-CONFIRMED at pinned API-client revision | High |
| Raw bend-table numbers are portable without semantic metadata | FALSIFIED by documentation comparison | High |
| A universal interpolation rule can be inferred across these systems | UNKNOWN / unsupported | High confidence evidence is insufficient |
| These tables define production ram/backgauge targets by themselves | UNKNOWN / explicitly unsupported | High confidence evidence is insufficient |

## Experiment decision

No GitHub Actions experiment is justified. The discriminator is representation semantics across documented/product interfaces, not LinuxCNC runtime behavior. A synthetic table lookup could verify arithmetic but would not establish which real machine/process convention is correct.

Future experimental work becomes justified when there is an actual open implementation of interpolation/fitting or a measured-coupon dataset whose transformation can be frozen and tested.

## Integration rule

Extend the current calculation lineage to:

`Source/TableRevision + TableSemantic + ConsumedInputSet + Material/Thickness + ToolingLookupKeys + AngleConvention + DimensionDatum -> EmpiricalLookupResult -> Nominal/CompensatedGeometry`

Then keep separately versioned machine calibration/correction, TargetSet generation and ExecutionEpisode authority downstream.

## Next checkpoint

1. Re-check F02 first; do not self-score it.
2. The generic nominal-formula and bend-table semantic branches have enough evidence for current dependency-safe preparation. Do not keep collecting equivalent CAD help pages.
3. Further calculation-domain research requires implementation-level information gain: measured-coupon fitting/interpolation source, a real tool-aware backgauge solver, or a tooling/method calculator that exposes its actual consumed inputs and datums.
4. Preserve UNKNOWN when a table's full/half, angle, datum, interpolation or process origin cannot be established.
