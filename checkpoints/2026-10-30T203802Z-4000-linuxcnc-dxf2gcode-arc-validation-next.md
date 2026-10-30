# 2026-10-30T20:38:02.397Z — LinuxCNC-first DXF2GCODE-to-interpreter source checkpoint
**4000-LC-CAM-02 | NON-GRADUATED | NO ACTIONS COMPUTE | no machine operation**

## Current authority and completed work
Read `START_HERE.md` first; then master mission, level order, owner-updated work-selection policy, curriculum, source policy, module template, progress, blind protocol/score, compute ledger and prior 19:32Z checkpoint. **LinuxCNC source/implementation is primary**, not routine safety-course work. 1000/2000/F02/3000 remain GRADUATED/CLOSED; 2520–25F0 independent evaluator OPEN and selected OpenPressBrake G0/G1 HOLD.

[4000-LC-CAM-02 research](../research/4400_LINUXCNC_DXF2GCODE_02_BULGE_BLOCK_ELLIPSE_POST_ARC_VALIDATION_SOURCE_AUDIT_2026-10-30.md) traced an **older pinned 2016** `cnc-club/dxf2gcode` DXF import→contour→block expansion→absolute geometry→post path and the pinned LinuxCNC v2.9.10 `convert_arc2 → arc_data_ijk` rejection path. LWPOLYLINE bulges and explicit ELLIPSE are handled in this snapshot, but nonuniformly scaled block circular arcs remain circular `ArcGeo` even though endpoints/center are scaled independently; a 2:1 example produces unequal center-to-start/end radii. Arc radii above configured `max_arc_radius` become G1 chords; MINSERT row/column and source entity handles are not retained by the inspected importer. TSP reorders cuts, not sheet nesting. Two actual pinned DXF sample files inspected statically (36 INSERT + closed bulged polyline in one; four rotated INSERTs/two ELLIPSEs in another). [Practical acceptance guide](../guides/4000-linuxcnc-dxf-to-gcode-geometry-acceptance-2026-10-30.md) records a machine-neutral source/geometry/CAM/NC contract.

**Evidence:** SOURCE-CONFIRMED for pinned source paths, DOC-CONFIRMED official LinuxCNC G2/G3 semantics, mathematical INFERENCE for illustrative 2:1 example. No TEST-CONFIRMED runtime, no measured machine result, no assertion that a modern upstream release has the same implementation. The two DXF fixtures are source-data inspection, not tests.

## Compute and external state
No hosted or self-hosted Actions runs, builds, simulations, benchmarks, test suites or physical operation. Zero GitHub-hosted/self-hosted Actions minutes; no new authoritative runtime, so `LAB_COMPUTE_LOG.md` unchanged. No new information-separated blind score, so `evaluation/FEEDBACK_SCORE_LOG.md` unchanged. Local panel PC runner access and machine I/O isolation remain UNKNOWN; do not dispatch. No G0/G1 or independent evaluator status change.

## Next highest-value unblocked LinuxCNC task
1. **Preferred:** pin a current maintained CAM/geometry pipeline (FreeCAD CAM/Path or another inspectable DXF-to-LinuxCNC post) and compare its actual nonuniform arc/ellipse transformation, MINSERT expansion and source-feature provenance to the historical DXF2GCODE case. Distinguish current behavior from 2016 historical behavior and cite exact commit/files. Look for an existing source test or real fixture before proposing new execution.
2. **Alternative LinuxCNC internals:** trace `interp_arc.cc` configurable center-arc tolerance from INI initialization to `convert_arc2`, and the G64 Q/P post/interpreter handoff, if a current CAM source path is unavailable. This should answer a concrete diagnostic question, not repeat the prior G64 overview.
3. If source resolves the question, do not simulate. If an actual unresolved acceptance question remains, freeze one disconnected fixture with predeclared geometry/NC oracle and use only verified isolated `[self-hosted, openpressbrake]`, never hosted Actions.
4. Update `PROGRESS.md` and safely append complete `LESSON_LOG.md` with UTC end, actual minutes and overlap. Keep hourly task enabled.

**Current safety boundary:** ordinary LinuxCNC/CAM/FPGA is not independent personnel-safety authority. No personnel-exposed hazardous operation authorized by these documents.
