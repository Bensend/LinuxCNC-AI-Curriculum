# 3600 Press-Brake Preparation — Public Bend-Calculation Source Audit

Date: 2026-09-12
Status: dependency-safe 3600 preparation; F02 fresh-AI gate remains external and untouched.

## Why this pass exists

`PROGRESS.md` places generic 3600 work at an information-gain stop, but explicitly allows new public tooling/process-calculation source when it adds information beyond the established provenance contract. This pass inspects two concrete, downloadable implementations and reconciles them against current CAD documentation.

The objective is not to endorse a universal bend formula. It is to determine what real implementations actually assume, which inputs their geometry paths really consume, what fails at their domain boundaries, and which semantics must survive into a future bend-program/TargetCalculation layer.

## Sources

### Implementation A — explicit bend calculator

Repository: `ramugopal92/Bend-Allowance-Calculator`
Pinned commit: `72fd7c4ba457281f689d7338d3483d1a5a49a171` (2026-03-12)
Primary source: `FrmBendCalc.vb`, blob `f8aaf385b610269398a7bce0d6a6c31ecd340fb4`

The README describes a simple utility taking sheet thickness, bend radius, bend angle and K-factor and returning setback, bend allowance and bend deduction.

### Implementation B — flat-pattern/DXF generator

Repository: `1Lab-vibe/SheetMetalGen-AI`
Pinned commit: `10e1d1968d83d8cfd4d79665e7c6d14b3f04c87b` (2026-01-25)
Primary source: `services/geometryService.ts`, blob `0e698e935e0c0343858688af289f00618d799557`
Input schema: `types.ts`, blob `1a2a51840ec9049ed4cdd5301bbb6fb1c34d271b`

The README tells the operator to supply thickness, K-factor and bend radius and specifically recommends a K-factor matching the material and bending equipment. The `Dimensions` type indeed carries both `bendRadius` and `kFactor`.

### Documentation cross-checks

1. SOLIDWORKS Design Help, **K-Factor**: defines K as neutral-sheet location ratio and gives `BA = pi * (R + K*T) * A / 180`.
2. SOLIDWORKS Design Help, **Bend Allowance and Bend Deduction**: defines bend allowance as neutral-axis arc length and bend deduction in relation to outside setback.
3. Autodesk Inventor Help, **Sheet Metal Unfold Reference**: linear unfold uses `(R + K*T) * angle_radians`; K-factor input is documented over 0..1.
4. Autodesk Inventor Help, **About Bend Tables for Sheet Metal Materials**: bend tables encode material/thickness/radius/angle behavior and may better reflect particular machinery/tooling than a single uniform K-factor.

These documentation sources establish CAD semantics, not target-machine values.

## Implementation A — source inventory and call flow

### UI path

`txtThickness_TextChanged`, `txtRadius_TextChanged`, `txtAngle_TextChanged`, and `txtK_TextChanged` all call `CalculateValues()` immediately. No material/tool/process state is loaded.

### `CalculateValues()`

Inputs:
- `T`: sheet thickness
- `R`: bend radius
- `A`: bend angle in degrees
- `K`: K-factor

Validation:
- `T > 0`
- `R > 0`
- `0 < A <= 180`
- `0 < K <= 0.5`

Equations:

```
Arad = A * pi / 180
SB   = (R + T) * tan((A / 2) * pi / 180)
BA   = Arad * (R + K*T)
BD   = 2*SB - BA
```

Outputs are rounded for display to 0.001 units.

No source path introduces material identity/revision, punch/die identity, bend method, springback, empirical correction, machine calibration, backgauge targets, ram target, pressure/tonnage, or bend-sequence authority. This is a nominal geometric calculator only.

## Implementation A — documentation reconciliation and adversarial checks

The BA equation matches the documented SOLIDWORKS/Inventor linear K-factor equation when the same angle convention and inside radius are used. The BD relation is structurally consistent with bend deduction as outside-setback sum minus bend allowance.

The app's `K <= 0.5` validation is application policy, not a universal physics/CAD limit: Autodesk documents a broader 0..1 linear-unfold K-factor domain. Therefore this guard must not become a curriculum rule.

The exact source equations were checked at `T=1`, `R=1`, `K=0.4`:

| A (deg) | SB | BA | BD |
|---:|---:|---:|---:|
| 30 | 0.535898 | 0.733038 | 0.338758 |
| 90 | 2.000000 | 2.199115 | 1.800885 |
| 120 | 3.464102 | 2.932153 | 3.996050 |
| 170 | 22.860105 | 4.153884 | 41.566326 |
| 179 | 229.177300 | 4.373795 | 453.980805 |
| 180 | ~3.266e16 | 4.398230 | ~6.532e16 |

The UI permits `A=180`, but tangent-based setback is singular there. The finite floating-point magnitude is an implementation artifact, not a meaningful setback. This does **not** mean a 180-degree formed geometry is impossible; it means this outside-setback representation is invalid at that boundary.

The source/README also leave the meaning of `Bend Angle` implicit. Material rotation, included angle and complementary angle are not interchangeable. A correct equation can therefore be fed a semantically wrong angle.

## Implementation B — actual geometry call flow

The input type explicitly contains:

- `thickness`
- `bendRadius`
- `kFactor`

and the README instructs the operator to choose K-factor according to material/equipment.

However the actual geometry path is:

`generateGeometry()` -> `generateCassette()` -> `calculateBendDeduction(dims)` -> `bd` -> outer/bend-line coordinates.

`calculateBendDeduction()` contains comments describing itself as simplified/demo logic and then returns only:

```
return dims.thickness * 1.8;
```

It does **not** read `dims.bendRadius` or `dims.kFactor`. It has no bend-angle input at all. `generateCassette()` then uses that fixed-thickness deduction in expressions such as:

```
extLeft  = -(D + F - bd)
innerLeft = -(D - bd/2)
```

with analogous right/top/bottom coordinates.

### Adversarial consequence

For otherwise identical geometry and thickness, changing the declared `kFactor` or `bendRadius` leaves this generator's bend deduction unchanged. At thickness 1.0, the geometry path receives `bd = 1.8` whether K is 0.30 or 0.50 and whether bend radius is 1 or 5.

This is stronger evidence than a prose warning: a field can exist in the schema and UI, and documentation can instruct the operator to tune it, while the production geometry path never consumes it.

Classification:
- presence of K/radius inputs: **SOURCE-CONFIRMED**;
- non-consumption by the bend-deduction/flat-geometry path: **SOURCE-CONFIRMED**;
- README expectation that K relates to material/equipment: **DOC/PROJECT-DESCRIPTION evidence for intended use, contradicted by current implementation path**.

## Source-to-interface conflict rule

The second implementation adds a new curriculum requirement: **input provenance is insufficient without input-consumption provenance**.

A future importer or AI-generated bend workflow must not infer that a generated flat pattern embodies K-factor/radius/tooling semantics merely because those fields appear in its UI, JSON schema, prompt, or metadata. The exact calculation implementation/version and the set of inputs actually consumed by that path matter.

For generated manufacturing geometry, preserve enough provenance to answer:

1. Which calculation implementation/version generated this result?
2. Which input fields were actually consumed by that implementation path?
3. Which values were ignored/defaulted/approximated?
4. Was the result produced by a nominal formula, empirical table, rule-of-thumb, or machine-calibrated model?
5. What angle/radius/dimension datum conventions did that implementation use?

If those answers are unavailable, the process semantics are **UNKNOWN**, even if the DXF geometry itself is parseable.

## Process implication

Autodesk's bend-table documentation distinguishes uniform linear K-factor calculation from tables intended to capture material/process/machinery behavior. The two public implementations show why the existing curriculum separation is necessary:

`nominal geometry calculation != empirical process correction != machine target != runtime authority`

Implementation A is a recognizable nominal formula with a domain/convention trap. Implementation B is a usable example of an apparently richer UI/schema whose actual geometry path falls back to a fixed `1.8 * thickness` approximation.

Neither is evidence for a production press-brake backgauge solver or ram/Y target model.

## Failure modes / adversarial review

1. **180-degree tangent singularity** — Implementation A accepts a domain endpoint where its setback representation diverges.
2. **Undefined angle convention** — a mathematically correct BA expression can still receive a semantically wrong angle.
3. **K-factor range overgeneralization** — Implementation A's K <= 0.5 guard is narrower than Autodesk's documented model domain.
4. **Declared-but-unused inputs** — Implementation B exposes bend radius and K-factor but its geometry deduction ignores both.
5. **Rule-of-thumb silently entering manufacturing geometry** — Implementation B's `1.8*T` approximation directly affects exported flat-pattern extents.
6. **No process provenance** — neither implementation binds the calculation to a material/tool/method revision or measured coupon evidence.
7. **No empirical correction** — neither implementation demonstrates production accuracy for a particular machine/tool/material stack.
8. **Display/serialization precision** — downstream targets should not be reconstructed from rounded presentation values when higher-precision calculation state exists.

## Claims ledger

| Claim | Classification | Confidence |
|---|---|---:|
| Implementation A computes BA from `angle_rad*(R+K*T)` | SOURCE-CONFIRMED | High |
| That BA equation matches documented SOLIDWORKS/Inventor linear K-factor semantics | DOC-CONFIRMED | High |
| Implementation A computes BD as `2*SB-BA` | SOURCE-CONFIRMED | High |
| Implementation A's `K<=0.5` guard is not a universal CAD/physics limit | DOC-CONFIRMED conflict/reconciliation | High |
| `A=180` is invalid for Implementation A's tangent setback representation | SOURCE-CONFIRMED + deterministic numeric check | High |
| Implementation B's schema contains `bendRadius` and `kFactor` | SOURCE-CONFIRMED | High |
| Implementation B's actual bend-deduction path ignores both and returns `1.8*thickness` | SOURCE-CONFIRMED | High |
| A UI/schema field proves the generated geometry used that field | FALSIFIED by source trace | High |
| Bend-calculation provenance must include method/version, conventions and actual consumed inputs | INFERENCE from source/documentation reconciliation | High |
| These public formulas determine production backgauge or ram targets by themselves | UNKNOWN / explicitly unsupported | High confidence that evidence is insufficient |

## Information-gain decision

This pass adds concrete information beyond the previous generic provenance model:

- source-valid equations can still fail at representation-domain boundaries;
- angle and datum convention are first-class semantic state;
- a UI/schema can advertise K-factor/radius while the actual manufacturing-geometry path ignores them;
- therefore calculation provenance must include **implementation and consumed-input lineage**, not merely the values presented to the user.

No GitHub Actions lab is justified. These are deterministic source/math/dataflow questions, and a synthetic workflow would only re-run directly inspectable arithmetic.

## Durable rule added to 3600 preparation

Before importing or generating any bend-calculation result, preserve calculation semantics and consumption lineage separately from the numeric result:

`CalculationMethodRevision + ConsumedInputSet + AngleConvention + DimensionDatum + Material/Thickness + RadiusDefinition + K/TableProvenance -> NominalFlatPatternResult`

Only later, separately versioned layers may add empirical process correction and generate machine targets.

## Next checkpoint

1. Re-check the information-separated F02 transfer first.
2. If F02 remains blocked, treat the generic nominal-calculator branch as sufficiently sampled; do not add another calculator merely to collect another formula.
3. A next calculation-source pass is justified only if it adds one of: explicit tooling geometry/method selection, empirical bend-table generation, measured-coupon fitting, or a real flange/gauging-surface-to-backgauge target solver with defined datums.
4. Preserve tandem Y1/Y2 and active sensor-bending SOURCE-UNAVAILABLE boundaries until genuinely new implementation evidence appears.
