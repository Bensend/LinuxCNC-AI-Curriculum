# Press-brake 3600 — correction diagnosis matrix

Date: 2026-09-12
Status: SOURCE/DOC-CONFIRMED diagnostic framework
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

A production correction should not be promoted into machine calibration merely because a part measured wrong. This matrix defines discriminating measurements for several ordinary-control failure families before deciding whether to apply a bend/product correction or investigate machine calibration.

It is intentionally diagnostic rather than prescriptive: no actual press-brake commissioning constants are supplied.

## Evidence from LinuxCNC

### Encoder scale

LinuxCNC/HostMot2 documentation defines encoder position as count divided by scale. A scale error therefore changes the relationship between measured encoder position and physical travel. A purely constant datum error is a different signature from a proportional error that grows with travel.

### Backlash and mapped position compensation

LinuxCNC INI documentation distinguishes simple `BACKLASH` from `COMP_FILE`. A compensation file maps nominal command position to measured/offset values and carries separate positive- and negative-direction values. If `COMP_FILE` is configured, `BACKLASH` is not used.

At the pinned source revision, `control.c` computes ordinary joint screw/backlash compensation separately from trajectory command generation, then forms ordinary-joint motor command from joint command plus filtered backlash compensation and `motor_offset`. This is machine-motion compensation, not a product/bend correction.

For homed extra joints, the pinned source directly publishes `posthome-cmd + motor_offset` to `motor-pos-cmd`. That branch reinforces the need to know the actual architecture before assuming ordinary-joint compensation behavior applies to a press-brake backgauge extra joint.

## Measurement prerequisites

Before classifying an error, capture enough context to distinguish the hypotheses:

- machine/calibration revision and homing/reference episode;
- commanded target and controller-reported feedback;
- an independently justified physical measurement when diagnosing machine geometry/scale;
- approach direction;
- several positions across usable travel rather than one point;
- repeated measurements at the same points;
- installed finger/tool identity and relevant configuration revision;
- product/BendStep identity, material and tooling when evaluating bend-result corrections;
- left/right values separately for a tandem or multi-point beam when squareness is relevant.

A single bad part at one target generally cannot identify which layer is wrong.

## Diagnostic matrix

| Observed pattern | Stronger candidate hypotheses | Discriminating next check | Do not conclude yet |
|---|---|---|---|
| Approximately constant physical position error at several targets, same sign from both directions | reference/datum offset, finger geometry offset, constant configuration error | repeat across unrelated programs and after a controlled reference cycle; compare controller feedback with independent position reference | do not rewrite HOME_OFFSET from one product result |
| Error magnitude changes roughly in proportion to commanded travel | encoder/drive scale or geometric scale mismatch | compare physical displacement over a long known interval against encoder-count/scale relationship; check whether residual slope is stable | do not hide a scale error with many product-specific offsets |
| Error changes sign or magnitude with approach direction | backlash, hysteresis, mechanical lost motion, direction-dependent compensation | approach identical targets from positive and negative directions; repeat cycles | do not call this a constant X correction |
| Repeatable nonlinear error as a function of position, with direction dependence mapped separately | leadscrew/geometry map error or localized mechanical behavior | measure multiple ordered points in both directions and inspect residual map | do not construct a compensation table from sparse/noisy measurements |
| Controller feedback reaches target correctly but an independent gauge says physical position is wrong | scale/reference/mechanical coupling/feedback truth problem | verify independent reference provenance, encoder coupling, scale and datum | do not treat reported in-position as physical truth |
| Physical backgauge position is correct but flange dimension is wrong only for a particular bend/product | product geometry, gauging datum/contact choice, material/tool/process correction | verify actual contact datum, bend identity, tool/material setup and repeat same product | do not recalibrate the machine from product outcome alone |
| Bend angle changes with material/tool lot while backgauge position remains physically correct | springback/material/tool/process behavior | repeat measured-angle correction with same geometry and compare material/tool provenance | do not convert angle error into X-axis machine calibration |
| Similar product errors appear across many unrelated parts immediately after reference/encoder/mechanical work | machine calibration/reference regression | test independent machine-coordinate position before applying product corrections | do not propagate new compensating offsets into every product |
| Left/right ram or beam measurements disagree while average/primary position looks plausible | Y1/Y2 synchronization, squareness, independent-feedback or mechanical issue | inspect both independent physical feedback channels and differential witness; compare sides under same motion | do not fix a differential error with one global Y correction |
| Error grows after repeated direction reversals or load changes | mechanical compliance, backlash, actuator/load-dependent behavior | repeat unloaded/loaded and same-direction/reversal tests with independent measurements | do not infer encoder scale from load-sensitive data |
| Same numeric target survives a configuration revision but provenance changed | stale TargetSet/correction provenance | force recalculation/review and issue a new TargetSet generation | numeric equality is not evidence of validity |

## Simple residual models as diagnostic aids

These are classification tools, not automatic calibration algorithms.

Let:

```text
r(x,d) = physical_measured_position - commanded_machine_position
```

where `x` is position and `d` is approach direction.

Useful qualitative signatures include:

- `r ≈ c`: constant-offset family;
- `r ≈ a*x + c`: scale-plus-offset family;
- `r(x,+) != r(x,-)`: direction/hysteresis family;
- repeatable curved `r(x,d)`: position-map/geometric family;
- non-repeatable residuals larger than measurement uncertainty: do not fit a calibration model yet.

A model is only meaningful when the physical measurement system is sufficiently accurate and independently justified.

## Product-result residual is a different quantity

For a finished flange or bend angle, define a separate process residual, for example:

```text
product_residual = measured_finished_dimension - requested_finished_dimension
```

Do **not** equate this directly with machine-coordinate residual. Bending changes geometry through tooling, material deformation, springback and the selected gauging datum. The first-piece correction workflow may use a product residual to create an empirical correction without asserting that the machine coordinate itself was wrong.

## Correction routing decision

```text
bad measured result
    |
    v
validate measurement + provenance
    |
    v
is independent machine-coordinate error demonstrated?
    |                       \
   yes                       no/unknown
    |                          |
    v                          v
classify offset/scale/      inspect product/tool/
direction/map/differential  material/gauge-plan layer
    |                          |
    v                          v
machine calibration review  bend/program correction review
```

The branches can remain UNKNOWN until sufficient evidence exists; the workflow should not force a correction merely to clear an alarm or complete a part.

## Extra-joint caution

A LinuxCNC extra joint used for a press-brake backgauge is not automatically equivalent to an ordinary coordinated joint. At the pinned revision, once homed, the final extra-joint command path is `posthome-cmd + motor_offset`. Any desired application-level target correction must therefore be explicit upstream of `posthome-cmd` or in a separately justified downstream hardware/control layer. Do not assume an ordinary-joint `COMP_FILE` architecture without tracing the actual configured path.

## Safety and commissioning boundary

This matrix is ordinary diagnostic/control guidance. It does not authorize energized maintenance, bypass guarding, prescribe compensation magnitudes, or establish functional-safety performance. Machine calibration changes should follow machine-specific commissioning and verification procedures.

## Next work

The next useful 3600 evidence step is to connect this diagnosis matrix to an operator correction-review policy: define what evidence is required before promoting a bend-specific correction to program-wide or reusable material/tool-class scope, and what evidence instead forces machine-calibration review. Prefer real controller/documented production workflows; do not add a synthetic physics model solely to test these data-ownership rules.
