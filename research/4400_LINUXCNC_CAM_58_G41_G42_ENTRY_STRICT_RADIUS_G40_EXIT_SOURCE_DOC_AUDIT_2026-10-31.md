# 4000-LC-CAM-58 — LinuxCNC G41/G42 lead-in and G40 exit: CAM postprocessor contract

**Status:** SOURCE/DOC-CONFIRMED implementation/documentation comparison, conditional INFERENCE; NOT TESTED; NON-GRADUATED. **First audited:** 2026-10-31. This is a new LinuxCNC G-code interpreter and mill/router CAM handoff, distinct from the earlier DXF import and QtPlasmaC G-code filter investigations.

## Official behavior and version provenance
The [LinuxCNC 2.9 G-code manual, G40 and G41/G42](https://linuxcnc.org/docs/2.9/html/gcode/g-code.html) states that the G41/G42 entry move must be **at least** the tool radius; it also describes a G40 exit straight move longer than the tool diameter and prohibits a following arc. The [tool-compensation explanation](https://linuxcnc.org/docs/2.9/html/gcode/tool-compensation.html) discusses entry geometry, inside/outside corners, and tool-table radius. These are **DOC-CONFIRMED intended guidance**, not sufficient proof of the exact interpreter inequality.

Pinned implementation:
- LinuxCNC **v2.9.10** `src/emc/rs274ngc/interp_convert.cc`, blob `f01a359652d588d59c9e210fa441a99d2ee19598`, [mode conversion 1872–2045](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L1872-L2045), [first straight compensated move 5201–5261](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L5201-L5261), [arc rejection 367–383](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L367-L383).
- Development **537cf2d765c96b6e75ae1db44e1dc0b9dba906a1** same file, blob `379b21eaba65840ce4160e7ea70df60c12fad9ff`, [first compensated straight 6152–6180](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_convert.cc#L6152-L6180).
- Upstream [`nc_files/comp-g1.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/nc_files/comp-g1.ngc), blob `ed74f96298aa6a482ea7420a4a17198ec8cae27a`, provides a real cutter-compensated contour and explicit G40 exit.

## Interpreter execution chain and exact entry inequality
`Interp::convert_cutter_compensation` dispatches G41/G42 (or G41.1/G42.1) to `convert_cutter_compensation_on`, which chooses plane, side and tool-table or dynamic diameter. It sets the modal radius and side **in interpreter state**; no separate hardware cutter-compensation command is emitted. The first following G0/G1 goes through `Interp::convert_straight` into `convert_straight_comp1`, which computes planar distance `hypot(px-cx,py-cy)` and rejects **`distance <= radius`**. Both pinned versions use that strict condition.

**SOURCE-CONFIRMED version-specific mismatch:** a lead-in **exactly equal to the radius** fails the inspected source check, despite the 2.9 prose's "at least" wording. A CAM postprocessor should choose an entry longer than the radius with tolerance/margin, not generate a mathematically equal-length lead-in. This does not establish that every >radius path is collision-free; subsequent compensated geometry and concave-corner checks remain relevant.

For an XY G41.1 D10 tool (radius 5 mm) starting at (0,0), the source entry condition rejects first move to (5,0) and passes this *particular length gate* for (5.01,0). This is a calculation from source, not a run. `convert_straight_comp2` can generate an arc around convex G1 corners but does not add such an arc for a G0 corner; toolpath geometry depends on G0/G1 selection, not only on the nominal vertex list.

## G40 exit: documentation versus inspected implementation
`convert_cutter_compensation_off` flushes/adjusts queued canonical endpoints via `move_endpoint_and_flush` (`interp_queue.cc`, blob `dc6c35f0d5329b8f875365dbaee33fc663c16948`) and sets `arc_not_allowed=true` after an established compensated move. `convert_arc` explicitly rejects the next arc. `convert_straight` clears `arc_not_allowed` and, with compensation now off, uses ordinary G0/G1 canonical output.

**Source audit limitation:** the inspected G40/off and next-straight paths show **no explicit check** requiring the next linear segment to exceed the tool *diameter*. This conflicts with the manual's statement that a shorter move is an error. A hidden check elsewhere, a geometry-dependent queue rejection, or another validation stage is not ruled out without integrated execution. Do **not** assert that a short G40 exit is accepted or safe. Treat the manual's larger clearance as the CAM contract until a pinned executable oracle resolves the discrepancy.

## Frozen disconnected G-code discriminators (NOT RUN)
All cases are non-executing review fixtures, for an isolated interpreter with dynamic G41.1 and G17/G21/G90, no powered machine:
```ngc
(Entry A: strict equality)
G21 G17 G90 G40
G0 X0 Y0
G41.1 D10
G1 X5 Y0 F100
M2
```
**A prediction:** error at the first compensated straight length check. **B:** replace X5 with X5.01; the strict length gate passes (other checks may apply). **C:** replace G1 with G0; same length gate applies. **D:** after a valid compensated move, command G40 followed immediately by G2 with valid arc geometry; predict the `arc_not_allowed` interpreter error. **E:** after a valid compensated move, command G40 then a 1 mm G1 exit with D10; source has no explicit diameter-length check in the traced paths, but integrated acceptance is **UNKNOWN**. **F:** compare a convex G1 corner and otherwise identical G0 corner; inspect canonical arc insertion rather than only final endpoints.

For each fixture freeze tool diameter, initial coordinates, active plane, tool-table/dynamic mode, G-code, exact interpreter revision, emitted canonical moves, error text and exit status. The standalone rs274 interpreter is useful for interpreter behavior, but it is **not** a machine soft-limit or physical-clearance oracle.

## Practical CAM integration decisions
A postprocessor that outputs already-offset tool-center geometry generally should not also turn on G41/G42, or it risks double offsetting. A postprocessor that emits nominal part geometry plus G41/G42 must own correct D/tool identity, entry side, radius margin, arc/corner geometry, and G40 exit. Do not assume the same postprocessor is valid for plasma torch kerf compensation: QtPlasmaC filtering, M3/M5 contracts and lead-ins have distinct semantics. This is a design recommendation/inference, not a tested product implementation.

## Evidence ledger / uncertainty
| Claim | Class | Next verification |
|---|---|---|
| G41.1 diameter is halved into radius | SOURCE-CONFIRMED | Standalone parser fixture |
| Equality rejected by first G0/G1 length gate | SOURCE-CONFIRMED | A/B with pinned interpreter |
| G40 next arc explicitly rejected | SOURCE-CONFIRMED | D |
| G40 short-exit diameter rule documented | DOC-CONFIRMED | E integrated interpreter comparison |
| No explicit diameter test in inspected G40/straight paths | SOURCE-CONFIRMED for traced paths | Search remaining validation / run E |
| Real tool clearance, cutter diameter, physical outcomes | UNKNOWN | Qualified machine evidence, not this lesson |

No build, simulation, Actions compute, physical motion or blind evaluation. Independent personnel safety remains separate; no graduation or physical release claim.

## Next checkpoint
If an isolated `[self-hosted, openpressbrake]` runner is verified, execute A–F against exact source and compare emitted canonical output; otherwise source-trace the remaining G40 validation paths and a real FreeCAD/CAM postprocessor, then rotate to another LinuxCNC subsystem.
