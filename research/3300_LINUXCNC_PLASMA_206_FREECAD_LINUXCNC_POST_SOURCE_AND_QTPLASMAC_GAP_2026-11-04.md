# PLASMA-206 — real FreeCAD LinuxCNC CAM postprocessor versus QtPlasmaC contract (3300, NON-GRADUATED)

## Scope / provenance
Session follows START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, SOURCE_POLICY, evaluation protocol and PLASMA-205 checkpoint. **New inspectable generator obtained**, rather than inferring implementation from a generated NC file.

- FreeCAD/FreeCAD immutable source revision `0cafef1e58284d08a244f9eba85aee0002e3e350`: [LinuxCNC postprocessor](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py), [upstream LinuxCNC post tests](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/CAMTests/TestLinuxCNCPost.py). These are actual producer and test source, **not executed in this session**.
- Comparison: [LinuxCNC QtPlasmaC conversational producer](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd/lib/python/plasmac/line.py) pinned development revision `cdf957bd`, previously investigated in PLASMA-199; [LinuxCNC 2.9.10 trajectory source trace](../research/4400_LINUXCNC_MOTION_191_G64_PQ_CONVERSION_AND_MODAL_ORDER_2026-11-03.md).

## Source-confirmed generator details
`Linuxcnc(PostProcessor)` is a machine-type FreeCAD CAM postprocessor. Its defaults include extension `ngc`, preamble `G17 G54 G40 G49 G80 G90`, postamble `M05\nG17 G54 G90 G80 G40\nM2`, and a safety block `G40 G49 G80`. The class configures blend mode and tolerance at job scope; `_get_blend_command()` maps EXACT_PATH→G61, EXACT_STOP→G61.1, BLEND with tolerance >0→`G64 P{tolerance:.4f}`, otherwise bare G64. `_expand_prefix` inserts a whitespace separator before appending the mode, avoiding malformed `G90G64`.

The upstream `TestLinuxCNCPost` suite has specific assertions for the three modes, `G64 P0.0500`, `G64 P0.0200`, zero tolerance, placement in the preamble, and separator cases. These are **tests present in source**, not TEST-CONFIRMED runs here. The post also contains rigid-tapping conversion and tilted-work-plane support tied to an explicitly draft LinuxCNC PR; these are further reasons not to treat it as a QtPlasmaC-specialized torch post.

**Important cross-source consequence:** FreeCAD's `G64 P...` output has **no explicit Q**. Prior pinned LinuxCNC 2.9.10 interpreter research (MOTION-191) found P-only sets naive-CAM Q=P. Therefore an operator selecting FreeCAD's blend tolerance also selects that interpreter's naive-CAM joining tolerance, not solely a trajectory P tolerance. This is an inference across *two pinned revisions* and must be tested with actual generated geometry before asserting a specific contour deviation. The FreeCAD string tests cannot establish LinuxCNC motion semantics.

## What this does NOT solve
This is an **actual LinuxCNC-compatible CAM postprocessor source**, closing the generator-source availability gap in the *generic* case. It is **not evidence of a QtPlasmaC plasma postprocessor**: the inspected class defaults and blend logic do not provide the `M190 P...` + `M66 P3 L3 Q1` material transaction, `F#<_hal[plasmac.cut-feed-rate]>`, `M3 $0 S1`/ `M5 $0` torch lifecycle, pierce, kerf, THC, or QtPlasmaC-specific failure handling. Do not equate generic M05 spindle shutdown with validated plasma torch control. Generic FreeCAD CAM operations may emit other commands through the inherited base class; absence of those behaviors in the inspected class alone is not a global negative proof.

**Architecture:** Keep DXF import/OCS/bulge geometry, path planning, and machine postprocessing separate. Reuse FreeCAD's generic LinuxCNC output as a baseline for machine-independent geometry, but require a separate, explicitly validated QtPlasmaC post contract and a different OpenPressBrake bend/backgauge sequence. Do not retrofit the plasma material handshake by unreviewed string concatenation.

## Reproducible disconnected exercises / verification oracles (NOT RUN)
1. From the pinned FreeCAD class, evaluate `_get_blend_command` for EXACT_PATH, EXACT_STOP, BLEND 0, BLEND 0.05; expected text G61, G61.1, G64, G64 P0.0500. Compare with existing upstream test assertions.
2. Generate a simple rectangle in FreeCAD CAM and inspect modal units, plane, arc-center mode, G64 P/Q, M3/M5, tool changes and G2/G3. Do **not** assume arc-center mode from the shown preamble; inspect inherited formatter/base code and emitted NC first.
3. For a P-only program compare LinuxCNC 2.9.10 canonical Q handling with an explicit `G64 P0.05 Q0` control and `G61` control. Freeze the geometry oracle before running any LinuxCNC simulator.
4. Static QtPlasmaC compatibility gate: require known material transaction, feed binding, torch lifecycle, and documented timeout policy. Generic FreeCAD post must fail this gate without an audited adapter.
5. Negative test: a press-brake program must reject QtPlasmaC-specific `plasmac.*` HAL expressions and torch M3/M5 conventions.
6. Trace `PostProcessor` base-class G2/G3 and I/J formatter, FreeCAD operation/geometry source, then check negative DXF bulges, mirrored blocks and arc-center conventions against PLASMA-198.

## Evidence ledger and next work
| Claim | Class | Boundary |
|---|---|---|
| FreeCAD has inspectable LinuxCNC postprocessor and corresponding tests | SOURCE-CONFIRMED | pinned FreeCAD revision |
| FreeCAD emits G64 P-only for positive tolerance | SOURCE-CONFIRMED | class function; not executed |
| LinuxCNC 2.9.10 P-only sets Q=P | SOURCE-CONFIRMED in MOTION-191 | cross-revision comparison |
| FreeCAD post is QtPlasmaC-ready | **NOT ESTABLISHED** | dedicated plasma material/torch control not verified |
| Any physical machine path or cut quality | UNKNOWN | no simulation or hardware test |

No build, LinuxCNC run, Actions workflow, lab compute, or machine operation. No graduated levels or evaluator secrets changed. Independent personnel-safety authority and physical machine HOLD remain in force. Only isolated `[self-hosted, openpressbrake]` permitted if justified compute is later undertaken.

**Next checkpoint:** inspect FreeCAD's inherited `PostProcessor` arc formatting and G2/G3 center convention and its CAM operation→post pipeline; identify a genuinely QtPlasmaC-specific open-source post (if available). If not, build a source-grounded *disconnected* adapter contract with explicit material/torch transaction boundaries; no compulsory product build.
