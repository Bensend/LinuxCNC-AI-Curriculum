# Press-brake 3600 — calibration and correction ownership contract

Date: 2026-09-12
Status: DOC/SOURCE/COMMUNITY CROSS-CHECK
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Define which state belongs to machine calibration, product geometry, bend/program corrections and LinuxCNC runtime motion. The central question is whether a measured first-piece error should mutate the machine reference, nominal target calculation, product program, or only an explicit correction layer.

## Independent controller evidence

### Cybelec CybTouch

The previously audited CybTouch V5 workflow separates:

- requested flange length from calculated X target;
- calculated R from manual override;
- machine/backgauge geometry from product data;
- recalculation from retained corrections;
- angle and X/R corrections from the original programmed geometry.

The manual's semi-automatic workflow allows an operator to repeat one bend while applying corrections before advancing. This is direct evidence that first-piece correction is a production/program concern, not equivalent to redefining the machine's home/reference.

### Delem DA-66T / DA-69T family documentation

Public DA-66T/DA-69T operating/reference documentation provides an independent controller family with the same separation. It documents per-bend and general corrections, including X-axis corrections, angle/depth/crowning corrections, and measured-angle driven correction calculation. Public reference text states that production corrections can be stored in the active product program; optional correction databases can later offer corrections for similar bends.

This independently supports a layered model instead of one mutable `target` number.

Evidence classification: DOC-CONFIRMED for controller workflow/data ownership. It does not reveal universal proprietary calculation formulas.

## LinuxCNC source boundary

Pinned `src/emc/motion/control.c` establishes a different, lower-level compensation boundary.

The controller loop explicitly runs:

```text
get_pos_cmds()
compute_screw_comp()
...
output_to_hal()
```

The source describes screw/backlash compensation as a value computed from joint command position and direction. For ordinary joints, `output_to_hal()` forms the motor command as:

```text
motor_pos_cmd = pos_cmd + backlash_filt + motor_offset
```

and feedback processing subtracts the corresponding backlash/motor offset before deriving joint-space feedback.

For a **homed extra joint**, the normal joint compensation path is bypassed: the source directly publishes

```text
joint.N.motor-pos-cmd = joint.N.posthome-cmd + motor_offset
```

and then continues. The extra-joint source path therefore does not magically apply a product-specific press-brake bend correction or generic backgauge geometry solver. `posthome-cmd` must already represent the desired machine-coordinate target, while `motor_offset` retains LinuxCNC's homing/reference offset role.

Evidence classification: SOURCE-CONFIRMED at the pinned revision.

## Ownership layers

The resulting generic contract is:

```text
Part/Bend intent
  requested flange / angle / datum semantics
        |
        v
Nominal calculation
  method + tool/material/machine-geometry dependencies
        |
        v
Nominal TargetSet
        |
        +--> product/bend correction layer
        |      measured first-piece error, operator correction,
        |      optional learned correction database provenance
        v
Effective TargetSet generation
        |
        v
Runtime ExecutionEpisode
        |
        v
LinuxCNC machine-coordinate command
        |
        +--> LinuxCNC homing motor_offset / ordinary screw compensation where applicable
        v
Physical axis / plant
```

Each layer has different invalidation rules and must not be silently merged.

## Machine calibration vs production correction

### Machine calibration / configuration

Examples:

- encoder/drive scale and sign;
- home-switch/index relationship and HOME_OFFSET/reference geometry;
- backgauge finger geometry and machine reference datum;
- axis squareness/geometry parameters;
- tool geometry tables when they describe the installed tooling rather than a product tweak.

A change here potentially invalidates many products and TargetSets. It should create a machine/calibration revision and force dependent target recalculation/review.

### Product/bend correction

Examples:

- measured flange is 0.4 mm long, so apply an explicit X correction for this bend/product;
- measured angle differs from requested angle, so apply a bend-angle/Y-depth correction;
- empirical crowning adjustment for a product/material/tool combination.

These corrections should preserve the original requested geometry and nominal calculation. They belong to a correction record with provenance such as product/bend ID, measured result, author/operator, timestamp, units, source method and dependency revisions.

They must not rewrite HOME_OFFSET, encoder scale or a machine geometry datum merely to make one part come out correctly.

## General vs bend-specific correction

Independent controller documentation shows both scopes are useful:

- **bend-specific correction** — applies to one BendStep;
- **program/general correction** — applies across bends in a product;
- **correction database / learned correction** — reusable only when similarity criteria and provenance are explicit.

A future generic schema should therefore make scope explicit rather than using one global fudge factor.

Suggested fields:

```text
CorrectionRecord
  correction_id
  scope = BEND | PROGRAM | MATERIAL_TOOL_CLASS | MACHINE
  target_kind = X | R | Y_DEPTH | ANGLE | CROWNING | OTHER
  requested_value
  measured_value (optional)
  correction_value
  units
  bend_id / program_id
  tool_revision
  material_revision
  machine_calibration_revision
  calculation_method_revision
  created_by
  created_at
  status = ACTIVE | REVIEW_REQUIRED | RETIRED
```

## Invalidation rules

1. **Machine calibration revision changes** -> old nominal/effective targets become `REVIEW_REQUIRED`; product corrections must not be blindly re-applied without compatibility review.
2. **Tool/material/calculation dependency changes** -> recalculate nominal targets; retain old correction provenance but require review before reuse.
3. **Product geometry or BendStep identity changes** -> invalidate bend-specific correction mapping unless an explicit stable-ID reconciliation succeeds.
4. **Numeric target coincidentally remains unchanged** -> does not preserve validity if provenance revisions changed.
5. **Runtime abort/reference loss** -> invalidates ExecutionEpisode authority, but does not itself delete durable product corrections.
6. **Re-home with unchanged machine calibration** -> produces a fresh runtime/reference episode; durable product correction can remain valid, but the TargetSet must be regenerated/re-authorized under the current reference state.

## Failure modes prevented by the separation

- fixing one bad part by corrupting machine zero;
- reusing a correction after changing punch/die/material without review;
- treating an old effective X number as valid after machine calibration changed;
- losing the original design intent because nominal and empirical values were overwritten in-place;
- assuming LinuxCNC `motor_offset` is a press-brake product correction mechanism;
- silently carrying an old correction into a same-number-but-different BendStep after import/revision changes.

## What remains machine-specific

This work deliberately does **not** define:

- the proprietary or machine-specific flange-to-X formula;
- how much correction should be applied for any measured error;
- angle-depth springback equations;
- allowable correction limits;
- tool/material similarity thresholds for learned correction reuse;
- safe commissioning procedures or functional-safety behavior.

Those require a specific machine/controller/tooling process or stronger public implementation evidence.

## Counterfactual check

If a future machine uses different formulas or correction heuristics, the central ownership claim still holds: machine reference/calibration, requested geometry, nominal calculation, empirical correction and runtime motion authority are distinct state with different provenance and invalidation rules. No specific numeric formula is required for this conclusion.

## Next work

The next high-value 3600 question is no longer another ownership fixture. Inspect real press-brake calibration/first-piece workflows for **angle/Y-depth correction versus backgauge X correction**, then define the operator review/acceptance path that decides whether a correction is bend-specific, program-wide, reusable by material/tool class, or evidence of a machine-calibration fault.
