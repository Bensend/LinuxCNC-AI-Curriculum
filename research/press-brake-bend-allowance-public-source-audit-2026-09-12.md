# 3600 Press-Brake Preparation — Public Bend-Allowance Source Audit

Date: 2026-09-12
Status: dependency-safe 3600 preparation; F02 fresh-AI gate remains external and untouched.

## Why this pass exists

`PROGRESS.md` places generic 3600 work at an information-gain stop, but explicitly allows new public tooling/process-calculation source when it adds information beyond the established provenance contract. This pass inspects one concrete, downloadable calculator implementation and reconciles it against current CAD documentation.

The objective is not to endorse a universal bend formula. It is to determine what a real implementation actually assumes, what its call flow is, and which pieces are safe to reuse in a future bend-program/TargetCalculation layer.

## Sources

### Public implementation

Repository: `ramugopal92/Bend-Allowance-Calculator`
Pinned commit: `72fd7c4ba457281f689d7338d3483d1a5a49a171` (2026-03-12)
Primary source: `FrmBendCalc.vb`, blob `f8aaf385b610269398a7bce0d6a6c31ecd340fb4`

README describes the application as a simple utility taking sheet thickness, bend radius, bend angle and K-factor and returning setback, bend allowance and bend deduction.

### Documentation cross-checks

1. SOLIDWORKS Design Help, **K-Factor**: defines K as neutral-sheet location ratio and gives `BA = pi * (R + K*T) * A / 180`.
2. SOLIDWORKS Design Help, **Bend Allowance and Bend Deduction**: defines bend allowance as neutral-axis arc length and bend deduction in relation to outside setback; flat length may be expressed using explicit BA or BD values.
3. Autodesk Inventor Help, **Sheet Metal Unfold Reference**: linear unfold uses `(R + K*T) * angle_radians`; K-factor input is documented over 0..1.
4. Autodesk Inventor Help, **About Bend Tables for Sheet Metal Materials**: bend tables encode material/thickness/radius/angle behavior and may better reflect particular machinery/tooling than a single uniform K-factor.

These documentation sources are authoritative for their products' public semantics, not for the target press brake.

## Source inventory and call flow

### `FrmBendCalc_Load`
Calls `ClearOutputs()` only. No material/tool/process state is loaded.

### Text-change handlers
`txtThickness_TextChanged`, `txtRadius_TextChanged`, `txtAngle_TextChanged`, and `txtK_TextChanged` all call `CalculateValues()` immediately. Therefore the calculation is a pure UI-input calculation with no machine, tool-library, material-revision, or calibration lookup.

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

No source path introduces:
- material identity/revision;
- punch or die identity/geometry;
- air-bend/bottom/coining method;
- springback/overbend;
- empirical correction;
- machine calibration;
- target X/R/Z backgauge positions;
- ram/Y target;
- pressure/tonnage;
- bend-sequence authority.

Therefore this implementation is useful as a **nominal geometric flat-pattern calculator example only**.

## Documentation reconciliation

### Bend allowance equation — confirmed

The implementation's `BA = angle_rad * (R + K*T)` matches the current documented SOLIDWORKS K-factor equation and Autodesk Inventor's linear unfold equation when the same angle convention and inside radius are used.

Classification: **SOURCE-CONFIRMED + DOC-CONFIRMED** for the implementation and those CAD conventions.

### Bend deduction relation — structurally confirmed

The implementation uses `BD = 2*SB - BA`, consistent with the documented relationship between bend deduction, outside setback and bend allowance.

Classification: **SOURCE-CONFIRMED + DOC-CONFIRMED**, but only after the dimension/angle convention feeding `SB` is explicit.

### K-factor validation range — application policy, not universal physics

The implementation rejects `K > 0.5`. Autodesk documents its linear-unfold K-factor input over 0..1, and SOLIDWORKS defines K as the neutral-axis-location ratio `t/T`. Therefore the calculator's `0 < K <= 0.5` guard must not be promoted into a universal curriculum rule.

Classification: **SOURCE-CONFIRMED application behavior; conflict with broader CAD input domain; do not generalize**.

## Adversarial numeric checks

The exact source equations were evaluated without modifying them, using `T=1`, `R=1`, `K=0.4`:

| A (deg) | SB | BA | BD |
|---:|---:|---:|---:|
| 30 | 0.535898 | 0.733038 | 0.338758 |
| 90 | 2.000000 | 2.199115 | 1.800885 |
| 120 | 3.464102 | 2.932153 | 3.996050 |
| 170 | 22.860105 | 4.153884 | 41.566326 |
| 179 | 229.177300 | 4.373795 | 453.980805 |
| 180 | ~3.266e16 | 4.398230 | ~6.532e16 |

The UI explicitly permits `A=180`, but the tangent-based setback becomes singular at 180 degrees. This is a concrete invalid-input/failure boundary in the public implementation: it can display a finite floating-point approximation to a mathematically divergent outside-setback calculation instead of rejecting the geometry or changing representation.

This does **not** show that 180-degree sheet-metal forming is impossible. It shows that this particular outside-setback representation is not valid at that boundary.

## Semantic risk: angle and dimension convention must be provenance

The source names the input only `Bend Angle`; the README does not define whether that means material rotation, included angle, complementary angle, or a particular CAD convention. The BA equation can be correct while a user supplies a geometrically different angle convention. The setback equation is even more sensitive because it uses `tan(A/2)` and becomes singular at its 180-degree endpoint.

Therefore a reusable `TargetCalculation`/flat-pattern artifact must carry, at minimum:

- angle value;
- **angle convention/definition**;
- inside-radius definition;
- thickness;
- K-factor value **and source/convention**;
- dimensional datum used by any setback/deduction calculation;
- calculation-method/version identifier.

A scalar `angle`, `radius`, `thickness`, `K` tuple without those semantics is insufficient provenance.

## Process implication

Autodesk's bend-table documentation explicitly distinguishes a uniform linear K-factor model from tables that can represent particular machinery/tooling behavior. That reinforces the current curriculum boundary:

`nominal geometry calculation != machine/process correction != runtime machine target`

The public calculator is a good example of the first layer. It is not evidence for a press-brake backgauge solver or Y target model.

## Failure modes / adversarial review

1. **180-degree tangent singularity** — accepted by UI validation but produces unusable setback/BD magnitude.
2. **Undefined angle convention** — correct-looking equations can be fed semantically wrong angles.
3. **K-factor range overgeneralization** — UI rejects values above 0.5 although other CAD systems support a wider domain.
4. **No process provenance** — same numeric K is not tied to material/tool/method/revision.
5. **No empirical correction** — calculation cannot claim production accuracy for a particular machine/tool/material stack.
6. **Display rounding** — outputs are formatted to 0.001; downstream machine targets should not be reconstructed from rounded display strings when higher-precision calculation state exists.

## Claims ledger

| Claim | Classification | Confidence |
|---|---|---:|
| The audited app computes BA from `angle_rad*(R+K*T)` | SOURCE-CONFIRMED | High |
| That BA equation matches documented SOLIDWORKS/Inventor linear K-factor semantics | DOC-CONFIRMED | High |
| The app computes BD as `2*SB-BA` | SOURCE-CONFIRMED | High |
| The app's `K<=0.5` guard is not a universal CAD/physics limit | DOC-CONFIRMED conflict/reconciliation | High |
| `A=180` is unsafe for this app's tangent setback representation | SOURCE-CONFIRMED + deterministic numeric check | High |
| A future press-brake calculation layer must preserve angle/datum/calculation-method provenance | INFERENCE from source/documentation conflict | High |
| These equations determine production backgauge or ram targets by themselves | UNKNOWN / explicitly unsupported | High confidence that current evidence is insufficient |

## Information-gain decision

This source **does add new information** beyond the previous generic provenance model: it exposes a real implementation where a nominal BA formula is valid under documented CAD semantics while UI-domain choices and undefined angle conventions can still make the surrounding calculation unsafe or non-portable.

No GitHub Actions lab is justified. The discovered questions are deterministic source/math semantics, not LinuxCNC runtime behavior, and a synthetic workflow would only re-run arithmetic already directly inspectable.

## Durable rule added to 3600 preparation

Before importing or generating any bend-calculation result, preserve calculation semantics separately from the numeric result:

`CalculationMethodRevision + AngleConvention + DimensionDatum + Material/Thickness + RadiusDefinition + K/TableProvenance -> NominalFlatPatternResult`

Only later, separately versioned layers may add empirical process correction and generate machine targets.

## Next checkpoint

1. Re-check the information-separated F02 transfer first.
2. If F02 remains blocked, do not create another nominal calculator fixture merely to repeat these equations.
3. A next calculation-source pass is justified only if it adds one of: explicit tooling geometry, bend-method selection, empirical bend-table generation, measured-coupon fitting, or a real flange/gauging-surface-to-backgauge target solver with defined datums.
4. Preserve the tandem and sensor-bending SOURCE-UNAVAILABLE boundaries until genuinely new implementation evidence appears.
