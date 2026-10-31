# 4000-LC-CAM-60 — FreeCAD LinuxCNC G64 P before G20/G21: unit-context contract

**Status:** SOURCE-CONFIRMED cross-project ordering and branch logic; CONDITIONAL unit-impact INFERENCE; NOT TESTED; NON-GRADUATED. First audited 2026-10-31. This is a practical mill/router CAM postprocessor investigation, not a compulsory FreeCAD build.

## Pinned sources
- FreeCAD/FreeCAD commit **24ea8589aa8676049f7fe53ca9d1d1c398c38d26** (2026-10-31 11:19:06 UTC), `src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py` blob `f686609e4e815bb7ff5fecd709d315e5a0b315fc`, [lines 193–249 and 364–388](https://github.com/FreeCAD/FreeCAD/blob/24ea8589aa8676049f7fe53ca9d1d1c398c38d26/src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py#L193-L249).
- FreeCAD `src/Mod/CAM/Path/Post/Processor.py` blob `df5d105361699d3828094bc297073e08c6fef083`, [prefix order lines 1813–1859](https://github.com/FreeCAD/FreeCAD/blob/24ea8589aa8676049f7fe53ca9d1d1c398c38d26/src/Mod/CAM/Path/Post/Processor.py#L1813-L1859).
- FreeCAD `CAMTests/TestLinuxCNCPost.py` blob `cdd9b5d0758679fe76b255c7de57f743ed1c5c77`, [preamble tests 115–303](https://github.com/FreeCAD/FreeCAD/blob/24ea8589aa8676049f7fe53ca9d1d1c398c38d26/src/Mod/CAM/CAMTests/TestLinuxCNCPost.py#L115-L303).
- LinuxCNC **v2.9.10** `src/emc/rs274ngc/interp_convert.cc` blob `f01a359652d588d59c9e210fa441a99d2ee19598`, [`convert_control_mode` 1633–1669](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L1633-L1669); `src/emc/task/emccanon.cc` blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, [`SET_MOTION_CONTROL_MODE` 1193–1223](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1193-L1223).

## Cross-project ordering
FreeCAD's LinuxCNC post loads `BLEND_MODE` and `BLEND_TOLERANCE` from machine postprocessor properties. Its `_get_blend_command` emits `G64 P{tolerance:.4f}` when mode BLEND and tolerance >0, with **no explicit unit conversion** at that call site. `Linuxcnc._expand_prefix` appends this G64 to `PREAMBLE`. Base `PostProcessor._expand_prefix` inserts **SAFETYBLOCK, HEADER, PREAMBLE, then OUTPUT_UNITS**, and `_collect_unit_command` emits G21 for metric or G20 for imperial.

**SOURCE-CONFIRMED:** the generated G64 P word precedes the generated explicit G20/G21 output-units command. FreeCAD's own tests locate G21 after the preamble and check the earlier `G90G64` separator bug, but do not establish G64 P numeric-unit equivalence across different LinuxCNC startup modal units.

LinuxCNC's `convert_control_mode` receives the P word as `block->p_number` and passes it to `SET_MOTION_CONTROL_MODE`; `emccanon.cc` converts it using `FROM_PROG_LEN(tolerance)` under the **then-current program-unit mode**. The later G20/G21 cannot retroactively change that already emitted G64 tolerance. This is a cross-project source-level timing dependency.

## Conditional numerical discriminator
Suppose the intended blend tolerance is 0.05 **mm** (the FreeCAD sanity text labels its thresholds in mm) and the post emits `G64 P0.0500` followed by `G21`:
- If LinuxCNC enters the program in metric mode, the G64 P value denotes 0.05 mm.
- If LinuxCNC enters in inch mode, the same earlier G64 P denotes 0.05 inch = **1.27 mm**, even though subsequent G21 geometry is metric.
This is a **conditional source prediction**, not an observed machine run. The stored tolerance property's actual unit contract must also be verified; the post's sanity messages label it mm, but that alone does not prove how every UI stores it. Conversely, when output is inch G20, the preamble may still execute under prior metric mode. A robust post should establish units before a length-bearing G64 P or explicitly convert the tolerance for the active mode.

## Separate warning-severity branch defect
`Linuxcnc.get_sanity_checks` checks `if blend_tolerance > 0.1` to emit NOTE and then `elif blend_tolerance > 0.5` to emit CAUTION. The second branch is unreachable for ordinary finite real tolerances: every value >0.5 already satisfies >0.1. Therefore a value 0.6 produces the NOTE branch, not CAUTION, in the inspected function. This is **SOURCE-CONFIRMED** branch logic, not a measured GUI result. Reordering thresholds or testing >0.5 first is a candidate correction, not applied.

## Frozen software-only acceptance cases (NOT RUN)
| ID | Initial LinuxCNC unit mode | FreeCAD output units | P value | Expected interpreter unit interpretation |
|---|---|---|---|---|
| B1 | G21 metric | G21 metric | 0.0500 before G21 | 0.05 mm |
| B2 | G20 inch | G21 metric | 0.0500 before G21 | 1.27 mm |
| B3 | G21 metric | G20 inch | 0.0500 before G20 | 0.05 mm (prior mode) |
| B4 | G20 inch | G20 inch | 0.0500 before G20 | 1.27 mm |
| B5 | same as B2 but explicit G21 placed **before** G64 P | metric output | 0.0500 | 0.05 mm |
| B6 | `blend_tolerance=0.6` | n/a | n/a | source chooses NOTE, not CAUTION |

A correct test must capture **both** emitted post text and the LinuxCNC canonical motion tolerance (or Task trajectory setting), not merely assert the G64 line exists. Freeze FreeCAD machine/post configuration and output units, LinuxCNC initial unit state, source SHAs, and test output. Do not claim a runtime mismatch without a pinned interpreter/post run. This is separate from G64 P/Q corner geometry and the development-only G64 R planner.

## Practical decision
Until a cross-project test is run, emit an explicit G20/G21 **before** any unit-bearing G64 P and define whether the stored tolerance is mm, output units, or machine units. Treat FreeCAD's `supports_tool_radius_compensation` boolean and G64 P output as capability signals, **not** geometric/units acceptance certificates. See [CAM-59](4400_LINUXCNC_CAM_59_FREECAD_POST_G41_G42_G64_CONTRACT_SOURCE_AUDIT_2026-10-31.md) and [CAM-58](4400_LINUXCNC_CAM_58_G41_G42_ENTRY_STRICT_RADIUS_G40_EXIT_SOURCE_DOC_AUDIT_2026-10-31.md).

## Evidence and gates
SOURCE-CONFIRMED: prefix ordering, no conversion at emission, LinuxCNC canonical current-units conversion, unreachable severity branch. INFERENCE: actual scale discrepancy under contrasting startup units; initial mode and UI storage must be established. TEST-CONFIRMED none. No build, simulation, Actions compute, machine operation or evaluator; no safety/physical release or graduation claim. If qualified isolated `[self-hosted, openpressbrake]` compute becomes available, execute B1–B6; otherwise rotate to distinct LinuxCNC implementation work.
