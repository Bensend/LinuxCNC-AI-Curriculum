# 3100/3200/3300/3400/4000 — G18 absolute arc-center and CAD/CAM post preflight
**Practical LinuxCNC-first walkthrough | 2026-11-01 | source-verified, NOT RUN**

Read [ARC-129](../research/4400_LINUXCNC_ARC_129_G901_G911_XZ_CENTER_WORD_DOC_SOURCE_FREECAD_HANDOFF_2026-11-01.md) for immutable LinuxCNC stable/development and FreeCAD source pins. This guide is for offline NC generation, controller interpretation and commissioning; it does not authorize machine motion.

## Contract to teach and implement
**G90/G91 control endpoints; G90.1/G91.1 control IJK centers.** Select G17 (XY: I/J), G18 (XZ: I/K), or G19 (YZ: J/K). G90.1 requires both in-plane center words; G91.1 allows zero-offset omission. The stable and development G90.1 documentation erroneously says J/K for **XZ**, but their interpreters reject J in G18. Do not let the G-code manual typo become a postprocessor contract.

For a normal CAM post that emits **incremental** IJK, the explicit startup sequence is:
```ngc
G21 G17 G90 G91.1 G40 G49 G80 G94
F120
```
A real job must additionally establish its fixture, tool, safe start position, and process-specific readiness; this snippet is **not** a machine-safe program. Do not substitute G90.1 without converting every arc center and emitting both required center words.

## Reproducible geometry without a running controller
Consider G18 XZ, start X10 Z0, end X0 Z10, center X0 Z0 (all mm). The start and end radii are both 10 mm.
- Absolute center: `G18 G90.1` followed by `G2 X0 Z10 I0 K0`.
- Incremental center: `G18 G91.1` followed by `G2 X0 Z10 I-10 K0`.
- Negative: `G18 G90.1` followed by `G2 X0 Z10 J0 K0` is rejected for J in the XZ plane, despite the erroneous manual sentence.
- Another negative: `G18 G90.1 G2 X0 Z10 I0` lacks required K and is predicted to be rejected.
- A copied `I0 K0` under G91.1 makes the center equal the starting point, triggering zero-radius rejection.

Use the two standalone [positive](../examples/4000_arc_center_mode/g18_center_mode_comparison.ngc) and [negative](../examples/4000_arc_center_mode/g18_documented_jk_negative.ngc) fixtures only in a qualified disconnected interpreter. Their comments freeze the expected outcome. These are NOT RUN, not acceptance results.

## Source-to-post walkthrough
1. LinuxCNC `rs274ngc_pre.cc` initializes IJK to incremental; `convert_ijk_distance_mode` updates the mode when G90.1/G91.1 appears; `convert_arc` validates the plane's words; `convert_arc2` calls `arc_data_ijk`; successful arcs emit `ARC_FEED`. Verify which interpreter revision is deployed.
2. FreeCAD's pinned `linuxcnc_post.py` default preamble emits G90 but **not** G91.1. The shared `Processor::_convert_arc_move` serializes Path.Command IJK and suppresses only the out-of-plane center word; `MachineState.Tracked` excludes IJK, so duplicate-value removal is not an explanation for missing I/K.
3. Review the **actual** CAM command and emitted .ngc together: confirm that IJK values are start-relative before adding G91.1 to the configured preamble. Do not infer from a post's name or a preview.
4. For DXF/nesting pipelines, transform arc endpoints and centers consistently through units, INSERT transforms, mirroring and origin changes; verify `|start-center|` vs `|end-center|` and direction/plane. This is geometry validation, not a machine-position permissive.
5. For lathe G18, explicitly test X/Z center-word handling; for plasma G17, ensure a QtPlasmaC filter does not rewrite G91.1 or modal G2/G3 unexpectedly. See [PLASMA-81](../research/4400_LINUXCNC_PLASMA_81_QTPLASMAC_MODAL_ARC_LASTG_AND_G911_REWRITE_SOURCE_AUDIT_2026-10-31.md).

## Acceptance matrix (all pending, not claimed executed)
| Case | Program/config | Predicted result | Oracle |
|---|---|---|---|
| A | Positive fixture, G90.1 I0 K0 | valid radius-10 G18 arc | interpreter exit + canonical arc center |
| B | Positive fixture, G91.1 I-10 K0 | same geometric arc as A | canonical comparison |
| C | Negative J0 K0 G18 G90.1 | rejected J out of plane | stderr + exit |
| D | G18 G90.1 I0 only | missing K error | stderr + exit |
| E | G18 G91.1 I0 K0 from X10 Z0 | zero-radius error | stderr + exit |
| F | FreeCAD post default preamble | no explicit G91.1 | generated .ngc; do not infer runtime state |
| G | FreeCAD post with verified relative IJK and added G91.1 | explicit arc-center ownership | generated .ngc plus pinned interpreter |
| H | G19 G90.1 J/K and G17 G90.1 I/J | both valid pairs | interpreter canonical |

Capture LinuxCNC binary/commit, INI, units, exact input, command, stdout/stderr, exit, canonical trace and **actual job timestamps**. For FreeCAD record exact commit, machine config, post options, operation Path.Commands and emitted NC. No physical machine, no speculative feed/motion, no GitHub-hosted runner. Run only on positively qualified physically disconnected `[self-hosted, openpressbrake]` compute.

## Fresh-AI transfer exercise (unscored)
A DXF-to-lathe post emits `G18 G90 G90.1 G2 X30 Z10 I25 K10` from X20 Z5. Is G90 enough to establish IJK interpretation? (No; G90.1 does.) Which center coordinates are intended? (X25 Z10.) If the same numeric I/K are emitted under G91.1, where is the actual center? (X45 Z15.) Compute start/end radii and decide whether the arc is valid before accepting preview. Record a diagnosis and a falsifying interpreter test; do not self-score a blind evaluation.

## Deferred work
The source/doc conflict is established, but runtime outcomes and real CAM IJK output are NOT RUN. No graduation or machine commissioning claim. Preserve independent personnel-safety authority and the existing OpenPressBrake G0/G1 hold.
