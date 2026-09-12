# 3600 Press-Brake Preparation — Bend-Table Interpolation Cross-System Pass

Date: 2026-09-12
Status: bounded continuation of `press-brake-empirical-bend-table-semantics-2026-09-12.md`.

## Question

Is piecewise-linear interpolation a reasonable portable default for bend tables, or is the lookup/interpolation policy itself system/process semantics?

## Evidence

### FreeCAD SheetMetal — same repository, two engine policies

Pinned revision: `shaise/FreeCAD_SheetMetal@db3f87556cf8930257b69096cabe00e660caa416`.

Legacy `SheetMetalUnfolder.py` calls `lookup.py::get_val_from_range()` without enabling interpolation. The helper's built-in assertions show range/step selection with endpoint clamping.

Newer `SheetMetalNewUnfolder.py` instead documents first/last endpoint clamping plus piecewise-linear interpolation between radius/thickness keys.

With the repository's own test table `{1:0.38, 3:0.43, 99:0.50}`, `R/T=4` selects `K=0.50` in the legacy range/step path but approximately `0.430729` in the newer linear path.

Classification: **SOURCE-CONFIRMED**.

### PTC Creo — interpolation plus explicit outside-table formula

Current public sheet-metal bend-table help states:

- table data carries radius/thickness values and bend allowance/developed-length values;
- values missing between tabulated data are interpolated;
- a formula is used for radius/thickness values outside the table-data range.

Therefore Creo's documented out-of-range behavior is not equivalent to FreeCAD's endpoint clamping.

Classification: **DOC-CONFIRMED** for current Creo semantics.

### BricsCAD Mechanical — interpolation is explicitly not naive adjacent-linear BD

Current public bend-table help says measured bend data can be collected over angle/radius/thickness. It explicitly warns that linear interpolation on adjacent bend-deduction values can produce unnatural results that do not match real bending behavior. The product applies its own interpolation algorithm and also checks whether an implied K-factor is physically valid in `[0,1]`, falling back to the default K-factor when a random/impossible BD would imply a neutral surface outside the sheet.

Classification: **DOC-CONFIRMED** for BricsCAD semantics; exact proprietary algorithm remains unavailable.

## Adversarial conclusion

A portable bend-table importer must **not** silently assign `linear interpolation` merely because the rows are numeric.

At least these policies now have real evidence:

1. step/range selection + endpoint clamp;
2. piecewise-linear interpolation + endpoint clamp;
3. interpolation inside range + formula outside range;
4. product-specific non-naive interpolation with physical-validity fallback.

Thus `LookupPolicy` and `OutOfRangePolicy` are first-class versioned semantics, not an implementation convenience.

## Failure case

Suppose an empirical table was validated in a source system using a product-specific nonlinear algorithm. Exporting just the rows and re-importing them into a controller that performs linear interpolation can change compensation between measured points without any row changing. The data file may compare byte-for-byte equal while the produced flat geometry changes.

That is a **semantic version mismatch**, not a numeric-table corruption.

## Required provenance addition

For every derived table lookup result preserve:

- table revision;
- calculation/lookup engine revision;
- lookup policy identity;
- out-of-range policy identity;
- queried coordinates/keys;
- whether result was exact, stepped, interpolated, formula-derived, fallback-derived, or clamped;
- source rows/region used when available.

If the source system's interpolation algorithm is proprietary or undocumented, preserve `UNKNOWN/PROPRIETARY` rather than replacing it with a guessed linear model.

## Information-gain decision

This closes the generic interpolation-policy question for current preparation. More CAD help pages are unlikely to add useful information. Resume this branch only for:

- inspectable measured-coupon fitting/table-generation source;
- a real process-specific lookup algorithm whose source can be traced;
- target-machine empirical data when available.

No laboratory compute is justified by this pass.
