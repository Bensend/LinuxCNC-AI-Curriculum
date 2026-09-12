# Press-brake 3600 — target-calculation evidence boundary

Date: 2026-09-12
Status: RESEARCH / SOURCE / COMMUNITY CROSS-CHECK

## Purpose

After PB-DXF-003, the next architectural boundary is converting an accepted BendStep plus a human-confirmed GaugePlan datum into numeric backgauge targets. This note identifies what can be reused from public/open-source sheet-metal math and, more importantly, what **cannot** yet be inferred safely.

## Open-source source evidence: FreeCAD SheetMetal unfold calculator

`shaise/FreeCAD_SheetMetal/tools/calc-unfold.py` explicitly calculates bend allowance from:

- inside radius `r`;
- thickness `T`;
- K-factor `K`;
- bend angle;

using a neutral-axis radius `r + T*K`. Its example then derives leg/flange relationships relative to a mold-line distance. The project README likewise treats thickness, K-factor, effective inner radius and flange/leg geometry as distinct quantities and permits material-specific K-factor tables.

This is SOURCE-CONFIRMED evidence that a geometric conversion involving a bend cannot be represented faithfully by `finished flange length == flat distance` in general. Material/bend model inputs matter.

It is **not** source evidence for a universal press-brake backgauge formula. FreeCAD's calculation is an unfold/development calculation, not a machine/tool/finger contact solver.

## Independent fabrication references

Public fabrication references describe bend allowance (BA), outside setback (OSSB) and bend deduction (BD) as related but distinct quantities. A common formulation is `BD = 2*OSSB - BA`, with bend deduction used to convert specified outside flange dimensions into flat-pattern length. These references also emphasize that thickness, inside radius, bend angle and K-factor affect the calculation.

This corroborates the FreeCAD source at a terminology/math level. It does not establish that a LinuxCNC X target equals any one of BA/BD/OSSB or a simple flange length.

## Why GaugePlan must precede target calculation

A backgauge target is a machine-coordinate consequence of a **chosen physical contact/datum**, not merely a bend-line property.

Even for a simple first bend, target calculation needs an explicit definition of:

1. which part edge/surface contacts the gauge;
2. which bend line / tooling reference defines the forming plane;
3. whether the recipe dimension is an outside flange, inside flange, mold-line distance, flat distance, or another drawing convention;
4. what bend model/material table converts between finished and flat geometry when necessary;
5. which machine mechanism coordinate (X, R, X1/X2, etc.) represents that physical contact;
6. calibration/offset provenance that maps model distance to machine coordinate.

After prior bends, the problem may also depend on current part orientation/flip and the actual 3D surface presented to the gauge. Therefore the first implementation must not assume every BendStep can be reduced to `X = flange_length`.

## Minimum target-calculation contract before numeric execution

A future target calculation should consume an immutable/current set of evidence, conceptually:

- accepted `step_id` / `bend_id` / source revision;
- accepted `gauge_plan_id` and datum identity/provenance;
- part orientation state relevant to that step;
- dimension semantic (`OUTSIDE_FLANGE`, `MOLD_LINE`, `FLAT_DATUM_DISTANCE`, etc. — exact enum still research work);
- thickness and bend-model provenance when conversion is required;
- bend angle/radius and K-factor/material-table provenance when used;
- tooling/forming-plane reference when it changes the geometric meaning;
- machine calibration/offset revision;
- participating mechanism set.

The output should then carry:

- calculation method/version;
- all input provenance/revisions;
- per-mechanism numeric targets;
- validation status and uncertainty/review reasons;
- a new application-owned target generation, later converted into the PB-BG-003 style runtime episode.

## Invalidation rules

A numeric target must become REVIEW_REQUIRED/INVALID if any input on which it depends changes, including:

- GaugePlan datum/revision;
- source geometry or accepted bend semantics;
- part orientation/recipe state;
- material/thickness/bend model used in the calculation;
- tooling/forming reference if the method depends on it;
- machine calibration/offset revision;
- participating mechanism set.

Numeric coincidence after a change is not evidence that old target authority is still valid.

## Important distinction: unfold truth vs shop truth

K-factor and theoretical bend allowance are useful geometric models, but a production target may require shop-specific calibration or empirically validated bend tables because actual bend radius/springback/tooling/material behavior may differ from nominal geometry.

Therefore the curriculum should preserve at least three layers:

1. **drawing/CAD geometry semantics**;
2. **bend-development/material model**;
3. **machine/tooling/calibration mapping**.

Collapsing them into a single unexplained correction number would make diagnostics and revalidation weak.

## `limit3` remains downstream

The pinned LinuxCNC `limit3` source only shapes a numeric input subject to position/velocity/acceleration limits. It does not know whether that input came from correct sheet-metal geometry, the correct gauge datum, current tooling, or current machine calibration. Its output therefore cannot validate target-calculation correctness.

## What remains UNKNOWN / next research

Before freezing a numeric TargetSet experiment, obtain stronger evidence for at least one concrete **gauging-surface-to-target** workflow from a mature press-brake implementation, controller manual, or inspectable open-source project. Specifically determine:

- dimension convention accepted by the controller;
- where bend deduction/allowance or shop tables enter;
- how tooling/forming-plane offsets enter;
- how part flip/prior bends alter gauging datum;
- whether X/R/Z targets are calculated together or in layers;
- how target/calibration revisions are invalidated.

If no inspectable source is available after a bounded search, record SOURCE UNAVAILABLE and freeze only a generic provenance/calculation-method contract rather than inventing a commercial formula.

## Evidence boundary

SOURCE-CONFIRMED: FreeCAD SheetMetal bend-allowance/unfold example and pinned LinuxCNC `limit3` command-shaping behavior.
PUBLIC FABRICATION REFERENCE: bend allowance/deduction/setback terminology and formulas.
INFERENCE / DESIGN CONTRACT: proposed target-calculation provenance and invalidation boundary.
UNKNOWN: universal machine target formula, tooling-specific offsets, shop calibration values, collision/reachability, and physical accuracy.
No functional-safety claim is made.
