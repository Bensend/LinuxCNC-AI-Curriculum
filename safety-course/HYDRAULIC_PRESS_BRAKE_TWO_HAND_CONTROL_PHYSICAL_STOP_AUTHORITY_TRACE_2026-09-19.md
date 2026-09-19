# Hydraulic press-brake two-hand control and physical-stop authority trace

Date: 2026-09-19

## Question

What does authoritative hydraulic press-brake evidence add to the Lane-B two-hand-control chain, especially the boundary between valid two-hand logic and the physical stopping performance that makes its placement protective?

## Evidence

### IRSST RF-651 — Safeguarding Hydraulic Power Press Brakes

**DOC-CONFIRMED.** IRSST's hydraulic press-brake safeguarding guide describes a two-hand control as a protective device for the sole person using it. Simultaneous and maintained actuation initiates/maintains ram movement. Its protection depends on safety distance, and that distance depends principally on ram stopping time. IRSST therefore states that stopping time must be reliable and repeatable before this safeguarding method is considered.

The guide also documents two press-brake operating patterns rather than treating the control as an abstract pair of buttons:

1. two-hand control maintained through the complete cycle; and
2. two-hand approach followed by an automatic stop about 6 mm from the sheet, after which pedal control performs the bend so the operator can support the workpiece.

Source: IRSST RF-651, *Safeguarding Hydraulic Power Press Brakes* (2010), section 4.A, public PDF/search extract.

### California press-brake regulation

**DOC-CONFIRMED.** California Title 8 §4214 explicitly lists a two-hand control device among accepted press-brake safeguarding methods and requires press-brake point-of-operation devices/control reliability to satisfy the referenced press provisions. It separately distinguishes setup/inching behavior.

Source: 8 CCR §4214.

### OSHA mechanical-press two-hand architecture — transfer evidence only

**DOC-CONFIRMED / NOT PRESS-BRAKE-SPECIFIC.** 29 CFR 1910.217 provides a clear multi-operator two-hand-control architecture: each operator gets a separate two-hand control; all operators' controls must be concurrent; release of a hand causes the slide to stop; safety distance is derived from measured stopping time. This is useful architecture evidence, but it is a mechanical-power-press rule and is not transplanted as OpenPressBrake compliance truth.

## Freeze

**TWO-HAND INPUTS VALID != SAFETY DISTANCE VALID != STOPPING TIME RELIABLE/REPEATABLE != PHYSICAL RAM STOP PROVED != OPERATOR PROTECTED.**

**BUTTON SIMULTANEITY PASS != HYDRAULIC FINAL ELEMENT RESPONDED != RAM STOPPED WITHIN THE ASSUMED ENVELOPE.**

**ONE OPERATOR'S TWO-HAND DEVICE VALID != BYSTANDER/HELPER PROTECTED.**

**TWO-HAND APPROACH MODE != PEDAL BEND MODE != SAFEGUARDING CONDITIONS IDENTICAL.** A professional hydraulic press-brake sequence can intentionally change control modality near the workpiece; each phase needs its own validated hazard/safeguarding assumptions.

## Curriculum / commissioning consequence

A two-hand evaluator can prove simultaneity, release and anti-tiedown semantics, but it cannot prove the physical quantity used to place the station. Commissioning must therefore keep at least these witnesses separate:

`operator control state -> safety evaluator result -> safety output/final-element demand -> physical ram stopping response -> measured/repeatable stopping performance -> validated station safety distance -> fresh cycle authority`.

If the stopping system changes through hydraulic service, valve replacement, drive/control changes, deterioration or other maintenance that can affect stop time, a previously correct physical station location does not by itself prove the safeguarding distance remains valid. The required revalidation trigger and acceptance criterion must come from the applicable machine/OEM/standard procedure; they are not invented here.

## Human factors

Two-hand safeguarding can conflict with the need to support a workpiece. IRSST's documented two-stage approach is evidence that professional designs solve that conflict by changing the safeguarded sequence rather than encouraging an operator to defeat one palm button. Curriculum examples should treat an awkward safeguard that predictably encourages tie-down/bypass as an engineering problem to redesign, not merely an operator-discipline problem.

## OpenPressBrake unknowns

`UNKNOWN`: whether OpenPressBrake should use a two-hand station at all; number of exposed operators; station location; safety distance; actual stopping time/distribution; measurement method; final hydraulic elements; required PL/category/SIL; safe approach/transition position; whether a pedal transition is appropriate; and machine-specific revalidation interval/trigger.

No numeric distance, stopping time, 6 mm transition, hydraulic truth table or performance level is assigned to OpenPressBrake from these sources.

## Compute

No executable test is justified. This question is resolved at the source/architecture level. No GitHub-hosted or self-hosted compute was used.
