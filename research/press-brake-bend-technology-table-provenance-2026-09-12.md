# 3600 Press Brake — Bend-Technology Table Provenance and Validation

Date: 2026-09-12
Status: DEPENDENCY-SAFE SOURCE PASS
Pinned public source: FreeCAD SheetMetal `db3f87556cf8930257b69096cabe00e660caa416`

## Objective

Strengthen the tooling/material/springback ownership contract with an inspectable example of how a real open-source sheet-metal implementation stores, validates and consumes material-dependent K-factor data rather than treating `K` as a context-free scalar.

## Source trace

### `SheetMetalKfactor.py::KFactorLookupTable`

The legacy/current compatibility parser searches a material spreadsheet for a `Radius / Thickness` key column and a `K-factor` value column. It accepts the standard from either the K-factor column label or an explicit `Options` entry, but rejects missing/ambiguous standard definitions. Only `ansi` or `din` are accepted. It builds a numeric lookup keyed by radius/thickness ratio.

Failure paths include:

- no material-definition spreadsheet;
- missing `Radius / Thickness` key;
- missing K-factor value column;
- missing standard declaration;
- multiple standard definitions;
- unsupported standard name.

These are not cosmetic errors: the same K-factor number can mean something different under a different convention, so standard identity is part of the calculation provenance.

### `SMTests/testKfactor.py`

The in-tree test constructs a material spreadsheet with explicit `Radius / Thickness` and `K-factor (ANSI)` headers, loads the table through `KFactorLookupTable`, and asserts both lookup values and `k_factor_standard == "ansi"`.

This is independent executable-test evidence that the standard is intended to survive parsing as semantic state rather than being discarded after loading the numeric values.

### Unfolder consumption

The older unfolder path obtains a K-factor from the radius/thickness lookup and converts DIN to the internal convention by dividing by two. The newer `BendAllowanceCalculator` likewise normalizes the declared standard before calculating bend allowance. `SheetMetalFoldCmd.py` then shows the geometric relationship directly: unfolded length is proportional to `(bend_radius + kfactor * thickness) * bend_angle`.

The data flow is therefore:

```text
material-definition table
  -> radius/thickness lookup
  -> declared K-factor standard
  -> validated/normalized K-factor
  -> neutral-radius / bend-allowance calculation
  -> flattened geometry
```

It does not become a machine Y command or empirical production correction.

## 3600 design implication

A press-brake bend-technology record should not store only a naked numeric K-factor. At minimum, provenance for a K-factor/table-based model should include:

- material/technology record ID and revision;
- lookup independent variable semantics (`radius/thickness` here);
- interpolation/range policy;
- K-factor convention/standard;
- table revision/source;
- thickness and radius values actually used;
- requested bend angle;
- calculation algorithm/version that consumed the data.

If a controller instead uses bend-deduction tables, proprietary formulas or empirical technology tables, preserve their own model identity rather than forcing them into K-factor terminology.

## Adversarial conclusions

- Two tables containing the same numeric values but declaring different K-factor standards are **not** interchangeable without conversion.
- A copied table with its header/standard stripped is semantically incomplete even if every numeric row survived.
- Changing the material table or its standard must invalidate dependent nominal geometry/TargetSet generations; it must not silently mutate an already-authorized runtime episode.
- A successful unfold calculation does not validate springback, machine calibration, tooling feasibility or achieved bend angle.

## Evidence classification

- Parser requirements and failure paths: **SOURCE-CONFIRMED**.
- Standard retained by the in-tree test: **TEST-SPECIFIED / IN-TREE TEST EVIDENCE**; this curriculum did not run FreeCAD's test suite in the LinuxCNC lab because doing so would not resolve a LinuxCNC-specific ambiguity.
- Provenance recommendations for the 3600 data model: **ENGINEERING INFERENCE** grounded in the inspected parser/calculation paths and the curriculum's established revision/generation contracts.

## Information-gain decision

No curriculum lab run is justified. The source and in-tree test expose the semantic issue directly. The important transferable lesson is not a particular K-factor value; it is that **calculation convention and table revision are first-class provenance**.
