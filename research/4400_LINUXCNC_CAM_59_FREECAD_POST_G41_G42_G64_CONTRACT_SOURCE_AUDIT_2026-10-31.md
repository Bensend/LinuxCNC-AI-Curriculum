# 4000-LC-CAM-59 — FreeCAD LinuxCNC postprocessor vs interpreter cutter-compensation contract

**Status:** SOURCE-CONFIRMED static integration review; NOT TESTED; NON-GRADUATED. First audited 2026-10-31. No compulsory CAD/CAM product build.

## Pinned cross-project provenance
- **FreeCAD/FreeCAD** commit `24ea8589aa8676049f7fe53ca9d1d1c398c38d26` (2026-10-31 11:19:06 UTC): `src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py`, blob `f686609e4e815bb7ff5fecd709d315e5a0b315fc`, [source](https://github.com/FreeCAD/FreeCAD/blob/24ea8589aa8676049f7fe53ca9d1d1c398c38d26/src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py); `Path/Post/Processor.py`, blob `df5d105361699d3828094bc297073e08c6fef083`, [source](https://github.com/FreeCAD/FreeCAD/blob/24ea8589aa8676049f7fe53ca9d1d1c398c38d26/src/Mod/CAM/Path/Post/Processor.py); `CAMTests/TestLinuxCNCPost.py`, blob `cdd9b5d0758679fe76b255c7de57f743ed1c5c77`, [source](https://github.com/FreeCAD/FreeCAD/blob/24ea8589aa8676049f7fe53ca9d1d1c398c38d26/src/Mod/CAM/CAMTests/TestLinuxCNCPost.py).
- **LinuxCNC v2.9.10** interpreter `interp_convert.cc`, blob `f01a359652d588d59c9e210fa441a99d2ee19598`, [source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc); detailed [CAM-58 audit](4400_LINUXCNC_CAM_58_G41_G42_ENTRY_STRICT_RADIUS_G40_EXIT_SOURCE_DOC_AUDIT_2026-10-31.md).
- LinuxCNC [2.9 G41/G42 and G40 reference](https://linuxcnc.org/docs/2.9/html/gcode/g-code.html) and [tool-compensation guide](https://linuxcnc.org/docs/2.9/html/gcode/tool-compensation.html).

## What FreeCAD actually promises
The current `Linuxcnc.get_common_property_schema` overrides `supports_tool_radius_compensation` to **True** (line 89–90). Its default preamble is `G17 G54 G40 G49 G80 G90`, postamble is `M05; G17 G54 G90 G80 G40; M2`, and safety block includes `G40 G49 G80` (lines 91–96). The base `Processor.py` schema describes this boolean as *whether the post can output G41/G42*, not whether a particular contour meets the LinuxCNC entry geometry constraints.

In `linuxcnc_post.py::get_sanity_checks` (lines 390–477), the G41/G42 warning loop is entered **only if the support flag is false**. It scans operation command names for G41/G42 and emits a configuration-support warning; it does **not** calculate planar entry length, effective tool radius, concave-corner geometry, or G40 exit clearance in this inspected function. The general unsupported-command warning path explicitly lists G41/G42 as known command names. In the base `Processor.py`, unhandled commands fall through to `_convert_generic_command`, which delegates to `_convert_move`; this is command serialization, not a LinuxCNC interpreter geometry oracle.

The pinned `TestLinuxCNCPost.py` tests G64 preamble placement and contains a regression for the malformed concatenation `G90G64`; its inspected test file does **not** contain an executable G41/G42 lead-in-length boundary fixture. **Source-confirmed coverage gap for that file**, not a claim that FreeCAD has no cutter-compensation tests elsewhere.

## Cross-project mismatch worth teaching
LinuxCNC's `convert_straight_comp1` rejects a first compensated G0/G1 with planar `distance <= radius`. FreeCAD's default "supports cutter compensation" flag can therefore be TRUE while a generated contour still fails the LinuxCNC entry length test. Neither the postprocessor's support boolean nor a successful G-code export certifies that the generated program will be accepted by the target LinuxCNC version. An upstream test that only checks `G41` appears in the output would miss this.

The FreeCAD post also emits configurable G64 path blending. The post's unit/geometry context matters: G64 tolerance changes the controller's path behavior and cannot repair an invalid cutter-compensation entry. Avoid coupling a plasma QtPlasmaC post or OpenPressBrake DXF-to-G-code pipeline to mill-specific cutter compensation by default.

## Disconnected acceptance contract (not executed)
| ID | CAM/NC input | Required oracle |
|---|---|---|
| F1 | FreeCAD LinuxCNC post with default support flag, G41 command | Confirm output contains G41, but do **not** call that geometry acceptance |
| F2 | Same tool, 10 mm diameter, first compensated lead-in 5.000 mm | LinuxCNC interpreter should reject strict equality; freeze emitted error |
| F3 | Change only lead-in to 5.010 mm | Length gate passes; check remaining geometry and canonical output |
| F4 | Force support flag false while G41 exists | FreeCAD sanity warning path should flag unsupported command |
| F5 | Postprocessor default G40 preamble and postamble | Confirm modal reset placement; separately verify no unsafe implied clearance |
| F6 | G64 P tolerance and G41 lead-in | Validate preamble command separation and actual interpreter geometry independently |
| F7 | G40 then an arc after established compensation | LinuxCNC arc rejection, independent of FreeCAD post success |

Freeze FreeCAD job/machine configuration, tool table and units, post options, emitted `.ngc`, LinuxCNC INI, interpreter revision, error/canonical trace, and source SHAs. F1/F4/F5/F6 require FreeCAD's own test harness; F2/F3/F7 require a pinned LinuxCNC interpreter. No runtime results are claimed.

## Recommended minimal integration boundary
For a mill/router pipeline, explicitly select one of: **(a)** CAM emits tool-center geometry and G40 throughout, or **(b)** CAM emits nominal profile geometry with G41/G42, correct tool D number/diameter, lead-in strictly longer than radius with margin, supported corner transitions, and explicit G40 exit. Validate the generated G-code with the actual LinuxCNC interpreter before machine use. This is a research recommendation, not a product-build requirement. Plasma torch kerf and press-brake bend allowance belong to different geometry/control contracts.

## Evidence and next
SOURCE-CONFIRMED: default FreeCAD support flag, warning gate, default G40/G64 behavior, inspected test coverage, LinuxCNC strict entry check. INFERENCE: a FreeCAD job could export invalid compensated geometry; not reproduced. TEST-CONFIRMED none. No build, simulation, physical machine, independent evaluation or Actions compute. Next: if qualified isolated `[self-hosted, openpressbrake]` compute exists, run F1–F7; otherwise rotate to a different LinuxCNC implementation subsystem rather than turn FreeCAD into a compulsory product.
