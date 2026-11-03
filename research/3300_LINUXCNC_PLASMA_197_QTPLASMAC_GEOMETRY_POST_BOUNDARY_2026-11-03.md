# PLASMA-197 — QtPlasmaC conversational geometry to motion/control boundary (2026-11-03)

Status: **SOURCE-CONFIRMED (narrow), DOC-CONFIRMED (narrow); no executable or machine evidence.** Track 3300 Plasma, with 3600 press-brake transfer boundary. This is a research increment, not a new graduated module.

## Question and pinned evidence

Can an external DXF/nesting/CAM pipeline reuse QtPlasmaC's output contract without conflating geometric motion with torch-height control or press-brake bend commands?

Inspected **LinuxCNC tag v2.9.10** (tag identifier, not resolved commit SHA; obtain immutable commit SHA before executable qualification):
- [QtPlasmaC documentation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/plasma/qtplasmac.adoc), sections Introduction, Modes, Available I/Os.
- [QtVCP conversational line adapter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/qtvcp/lib/qtplasmac/conv_line.py), `preview`, `line_type_changed`.
- [Plasma line/arc generator](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/plasmac/line.py), `do_line_point_to_point`, `do_arc_3_points`, `do_arc_2_points_radius`, `first_segment`.
- [QtVCP circle adapter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/qtvcp/lib/qtplasmac/conv_circle.py), `preview`, `overcut_toggled`.
- [Realtime plasma component](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/plasmac.comp), input pin declarations.
- Attempted `configs/sim/axis/plasma/plasmac.ini`: **NOT_FOUND**, not a basis for asserting absence of simulation configurations.

## Observed source contract

1. The QtVCP line adapter calls the `plasmac.line` geometry helpers, receives either error or endpoint and G-code text, stages segments in temporary/NGC files and previews them. **SOURCE-CONFIRMED** at this tag. It does **not** import DXF in this inspected path.
2. `do_line_point_to_point` rejects zero-length lines and emits `g1 x... y...`; `do_arc_3_points` computes a circumcenter, selects G2/G3 from signed planar cross product and emits endpoint X/Y with **relative** center I/J. **SOURCE-CONFIRMED**. This is a concrete target for an external DXF importer/postprocessor; it is not evidence that arbitrary DXF splines, bulges, blocks or unit metadata are supported.
3. `conv_circle.preview` passes material number/name, kerf width, inside/outside, lead-in/lead-out, small-hole diameter/speed and overcut to `plasmac.circle.preview`. **SOURCE-CONFIRMED interface only**; the underlying circle algorithm and generated cutter compensation remain uninspected here.
4. `plasmac.comp` exposes `cutting_start` (documented connection to `spindle.0.on`), `arc_ok_in`, `arc_voltage_in`, `float_switch`, `ohmic_probe`, `cut_feed_rate`, `cut_height`, `pierce_height`, `kerf_width`, `motion_type`, and `current_velocity`. The docs define three modes: analog arc voltage with calculated Arc OK; analog voltage plus external Arc OK; external Arc OK plus up/down THC. **SOURCE-CONFIRMED pin interface / DOC-CONFIRMED mode semantics**. Do not infer the complete state machine from pin names.
5. **Architectural inference:** a CAM-generated planar path is not a complete plasma machine program merely because G1/G2/G3 parse. Material selection, kerf side, lead geometry, pierce/retract, arc transfer and THC state must be reconciled with the target QtPlasmaC configuration. Likewise press-brake backgauge and bend sequencing require a different semantic postprocessor, not repurposed plasma torch commands.

## Minimal inspectable *review-only* fixture

Input geometry in millimeters: line from (0,0) to (20,0); CCW quarter arc from (20,0) through (27.0710678,2.9289322) to (30,10), center (20,10). The expected **geometry-only** output is:

```ngc
G21 G17 G90
G1 X20 Y0
G3 X30 Y10 I0 J10
```

This is **not executable plasma cutting code**: it deliberately omits feed, torch M codes, material selection, pierce and machine-safe moves. It is a unit/arc-center interoperability fixture, not a qualified toolpath. A valid comparison should assert endpoint, direction, I/J-relative-center and 10 mm radius, and explicitly fail when importer supplies an R arc with ambiguous major/minor sweep or silently rescales units.

## DXF/CAM integration contract to investigate next

Before choosing a library, freeze the interchange schema: drawing unit (including unitless DXF), XY frame/origin, entity type (LINE, ARC, LWPOLYLINE bulge, SPLINE, INSERT transforms), contour closure/winding, hole/island topology, material/thickness/kerf, machine bounds and postprocessor dialect. Round-trip each source entity to geometry with tolerance and report unsupported constructs; never silently flatten without an error bound. Nesting changes part placement, not geometry semantics. Keep plasma output separate from bend-order/backgauge program representation. **No external DXF importer or nester was inspected this session; that remains a concrete source gap.**

## Verification and next gate

Review-only test matrix: (A) metric quarter arc; (B) inch drawing with explicit conversion; (C) clockwise arc; (D) reversed hole contour; (E) bulge semicircle; (F) unsupported spline; (G) duplicate/zero-length segment; (H) kerf offset near a narrow slot. Record geometric error and emitted G-code, then inspect interpreter/QtPlasmaC acceptance on an isolated permitted environment. No runtime result is claimed. Personnel-safety and machine-operation authority remain independent of this CAM pipeline.

**Evidence ledger:** narrow adapter/generator/component claims SOURCE-CONFIRMED at v2.9.10; three-mode descriptions DOC-CONFIRMED; full DXF interoperability, actual plasma timing, material M-code semantics, cutter-compensation placement and machine response UNKNOWN; cross-machine separation INFERENCE. No compute or workflows used.
