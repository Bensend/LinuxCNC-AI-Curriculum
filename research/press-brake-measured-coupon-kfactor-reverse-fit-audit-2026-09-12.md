# Press Brake Measured-Coupon Reverse-Fit Audit

Date: 2026-09-12
Course: 3600 dependency-safe preparation
Status: bounded public implementation-behavior audit + independent arithmetic verification

## Why this pass was allowed

The current checkpoint explicitly permits more calculation-domain work only when genuinely new evidence appears, including **measured-coupon fitting/table-generation** behavior. This pass does not add another nominal bend calculator. It audits a current public calculator that reverses measured coupon geometry into an empirical K-factor and documents how the result should be governed.

## Public implementation behavior

Source inspected: SizingKit, **K-Factor Calculator** (published 2026; retrieved 2026-09-12):

- https://sizingkit.com/k-factor-calculator

The page states that the calculation runs client-side and describes a reverse-fit function named `kFactorFromMeasuredBend`. Its declared inputs are:

- original blank length;
- two measured outside legs after bending;
- number of identical bends in the coupon;
- finished bend angle after springback;
- finished inside radius after springback;
- measured material thickness.

The material-class selector is explicitly described as comparison-only and not an input to the fitted value. The page also states that the fit rejects K outside 0..0.50 and recommends retaining the coupon measurements with the derived value.

This is **DOC-/PUBLIC-BEHAVIOR-CONFIRMED**, not SOURCE-CONFIRMED: the rendered implementation contract is inspectable, but a downloadable source repository for the calculator was not found in this bounded pass.

## Reconstructed call/data flow

The published equations and worked example imply the following reversible geometry path for `n` identical bends:

1. `measured_BD = (leg1 + leg2 - blank_length) / n`
2. `OSSB = tan(theta/2) * (R + T)`
3. `BA = 2*OSSB - measured_BD`
4. `K = (BA/theta_rad - R) / T`

where `theta` is the angle bent through, `R` is the **finished measured** inside radius, and `T` is the measured coupon thickness.

This is materially different from merely selecting K from a material table: the empirical value is solved from measured geometry and therefore inherits the measurement and process provenance of that coupon.

## Independent reproduction of the worked example

Published example:

- blank = 4.0000 in
- legs = 2.0540 + 2.0540 in
- thickness = 0.0598 in
- finished inside radius = 0.0625 in
- bend angle = 90 deg
- bends = 1

Independent calculation performed during this session produced:

- measured BD = `0.1080 in`
- OSSB = `0.1223 in`
- BA = `0.1366 in`
- fitted K = `0.4090679`

which reproduces the displayed `K = 0.4091`.

Classification: **TEST-CONFIRMED arithmetic reproduction of the published behavior**, not an execution of the site's private/client bundle.

## Sensitivity / adversarial checks

The page claims that, for the worked dimensions, a +0.005 in blank-length error changes fitted K by about 0.0532 for one bend and that four identical bends divide that effect by four.

Independent perturbation of the reconstructed equations gave:

- `n=1`: delta K = `+0.0532291`
- `n=4`: delta K = `+0.0133073`

This matches the published sensitivity and demonstrates a useful design consequence: **bend count is part of the measurement protocol, not just descriptive metadata**.

Additional adversarial boundary checks:

1. Substituting intended punch radius for the finished measured radius changes the fitted K and therefore silently aliases springback/tooling behavior into the coefficient.
2. Changing bend count without changing measured total deduction changes fitted K; the count must be bound to the raw coupon record.
3. A fitted K without angle convention is not portable because the tangent setback and arc equations depend on that convention.
4. A fitted K without forming method/tooling/material provenance can be mathematically correct for the coupon and still be invalid for another process.
5. A rejected K outside 0..0.50 should be treated as a failed measurement/model consistency check, not automatically clamped into a production table.

Frozen review result for this bounded pass: **5/5 boundary checks PASS**.

## New durable ownership rule

A measured empirical bend coefficient must not be stored as a naked scalar. At minimum its durable record should bind:

`EmpiricalBendFit -> raw coupon measurements + measurement units + angle convention + bend count + finished radius + measured thickness + material identity/revision + grain/orientation when controlled + forming method + punch/die/tooling identity/revision + machine/process identity + fit implementation/version + acceptance/rejection result`

Only after that record is accepted should a derived coefficient/table row be promoted into a versioned bend-technology dataset consumed by later `TargetCalculation` generation.

Recommended chain:

`CouponMeasurementSet -> EmpiricalBendFit -> AcceptedBendTechnologyRevision -> TargetCalculation -> TargetSet -> ExecutionEpisode`

This keeps measurement evidence distinct from production command authority.

## What this does NOT establish

- It does not prove that K must always be <=0.50 for every material/model convention; that is the audited calculator's declared model boundary and must remain versioned with the implementation.
- It does not establish a universal coupon geometry, number of bends, material table, die opening, springback model or acceptance tolerance.
- It does not establish a universal rule for transferring one coupon's fitted coefficient across coils, machines, grain directions, tooling or forming methods.
- It does not provide source-level proof of SizingKit's private/client JavaScript implementation beyond the published behavior and independently reproduced equations.

## Evidence classification

| Claim | Classification | Confidence |
|---|---|---:|
| Calculator accepts measured coupon geometry and reverse-fits K | DOC-/PUBLIC-BEHAVIOR-CONFIRMED | high |
| Worked example yields K ~= 0.4091 | TEST-CONFIRMED arithmetic reproduction | high |
| 0.005 in blank error changes K by ~0.0532 for one bend | TEST-CONFIRMED arithmetic reproduction | high |
| Four identical bends reduce that specific blank-error effect by factor 4 | TEST-CONFIRMED arithmetic reproduction | high |
| Material-class selector is comparison-only | DOC-CONFIRMED for this implementation | high |
| Exact private/client source implementation matches the reconstructed equations in all branches | UNKNOWN | low / not claimed |

## Information-gain decision

This evidence clears the prior checkpoint's measured-coupon exception because it adds a concrete reverse-fitting contract, a reproducible sensitivity discriminator, and a new provenance requirement. It does **not** justify further generic K-factor calculator surveys.

The calculation branch returns to the information-gain stop after this artifact. Reopen only for inspectable source implementing coupon/table generation, multi-sample fitting/uncertainty, or a production tooling-aware target solver with explicit datums.
