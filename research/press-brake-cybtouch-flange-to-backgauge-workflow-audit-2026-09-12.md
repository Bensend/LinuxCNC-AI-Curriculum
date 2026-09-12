# Press-brake 3600 — Cybelec CybTouch flange/backgauge workflow audit

Date: 2026-09-12
Status: OFFICIAL-DOCUMENTATION WORKFLOW EVIDENCE
Source: Cybelec `CybTouch Series – User Manual`, V5.0, January 2020, synchronized press brakes.

## Why this source matters

The previous bounded controller search did not expose a universal backgauge formula. The official CybTouch V5 manual does, however, establish a useful and narrower architecture boundary: the controller distinguishes the operator's desired **flange length** from the calculated **X-axis target**, and it treats recalculation/corrections/tool configuration as separately controlled state.

That is enough to improve the 3600 interface contract without reverse-engineering proprietary calculation internals.

## Documented workflow

On the Bend Numerical Page the manual presents separate fields/modes for:

- beam Y setpoint / bend angle;
- backgauge X setpoint / flange length;
- optional backgauge R position;
- material and thickness;
- tools management and corrections.

For X, the operator can use a flange-length mode in which the desired flange length is entered and the controller calculates the backgauge X position. A separate mode displays the resulting X target. Relative X movement is a different mode with restrictions (for example, it is not available on the first sequence or on graphical parts).

For optional R, the controller calculates a vertical position and allows manual override; deleting the override restores the calculated value.

The manual also states that backgauge dimensions are defined in machine parameters and that the operator may select among available backgauge finger support/stop positions depending on machine configuration.

## Recalculation ownership

The user preference `Show L first` controls which X entry surface is shown and, in its `never` behavior, can decouple backgauge position from bend-angle recalculation.

The manual separately exposes a product-load recalculation preference because tools or backgauge configuration may have changed since the program was last run. It explicitly recommends retaining corrections while recalculating the part.

This strongly supports revision/provenance ownership in our proposed TargetSet layer: a previously calculated numeric X is not immutable truth when its calculation dependencies change.

## Correction ownership

CybTouch maintains bend/correction behavior separately from basic programmed geometry. The manual includes X/R correction functions, and it distinguishes calculated values from manually overridden values. Therefore the curriculum should not collapse:

- requested finished-part dimension;
- nominal calculated machine target;
- empirical/operator correction;
- machine-parameter geometry;

into one opaque number.

A useful generic representation is:

`requested dimension semantic + GaugePlan datum + calculation method/version + machine/tool inputs -> nominal target -> correction layer -> effective target`

with each layer retaining provenance.

## Other machine-dependent evidence

The manual shows additional sequence and machine-dependent inputs that reinforce why a universal formula is inappropriate:

- backgauge retraction is a per-sequence parameter;
- bending length contributes to force/crowning calculations;
- material/thickness/sigma are part-level calculation inputs;
- backgauge finger dimensions/stop positions come from machine parameters;
- opening, force and crowning can be calculated and/or overridden depending on mode/configuration.

This is evidence for a dependency-rich controller architecture, not evidence that all those inputs affect X in exactly the same way.

## Consequence for OpenPressBrake/LinuxCNC curriculum design

The first useful numeric-target interface should imitate the **separation of concerns**, not attempt to clone Cybelec's proprietary math:

1. operator/CAD supplies an explicitly typed finished-part or datum dimension;
2. GaugePlan identifies the physical datum/contact and mechanism set;
3. a named calculation method with versioned dependencies produces nominal X/R/etc.;
4. machine/calibration configuration and empirical corrections are separately recorded;
5. effective per-mechanism TargetSet receives a new generation/episode before runtime motion;
6. runtime planner (`limit3` or equivalent) shapes only the already-authorized effective target.

If any calculation dependency changes, old nominal/effective targets become REVIEW_REQUIRED even when the numeric value happens to remain identical.

## What the manual still does not reveal

The inspected public manual does not expose the internal formula that converts flange length to X, nor enough internals to state generically how punch/die geometry, bend allowance, finger shape, machine reference and correction tables are combined.

Therefore:

- **DOCUMENTED:** flange length and X target are separate; X may be calculated from flange length; R may be calculated; machine backgauge geometry and correction/recalculation concepts exist.
- **NOT DOCUMENTED / SOURCE UNAVAILABLE:** universal internal flange-to-X formula and its exact dependency graph.

## Next-work discriminator

Do not freeze a numeric formula. First do one bounded open-source/offline implementation search specifically for a function that computes gauge position from part geometry. If found, trace it as an example implementation rather than a universal truth. If not found, freeze a generic TargetCalculation/TargetSet provenance interface using the documented separation above and leave calculation methods pluggable/machine-specific.

## Claims boundary

This artifact documents controller UI/data ownership and recalculation semantics from an official manual. It does not validate a machine-specific target, physical gauge contact, tooling compatibility, collision freedom, bend accuracy, calibration values, or functional safety.
