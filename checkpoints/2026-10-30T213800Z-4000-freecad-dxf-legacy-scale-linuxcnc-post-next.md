# 2026-10-30T21:38:00.595Z — LinuxCNC-first FreeCAD DXF and postprocessor continuation
**4000-LC-CAM-05 / 4000-LC-POST-06 | NON-GRADUATED | source-only | no machine operation**

## Governance recovered
START_HERE read first, then mission, level order, owner LinuxCNC-first work selection, curriculum, source policy, template, progress, blind protocol/score, compute ledger, latest 20:38Z checkpoint and CAM acceptance guide. 1000/2000/F02/3000 remain GRADUATED/CLOSED; 4000 implementation remains active. Safety course not routine queue; OpenPressBrake G0/G1 HOLD and independent 2520–25F0 evaluator OPEN/NOT RUN.

## Durable new evidence
1. [FreeCAD DXF legacy/native source audit](../research/4400_FREECAD_DXF_05_LEGACY_INSERT_SCALE_AND_NATIVE_IMPORT_BOUNDARY_SOURCE_AUDIT_2026-10-30.md): pinned FreeCAD `bbc08916...` legacy non-clone `drawInsert` applies `insert.scale` only inside exception retry; successful rotation-only branch omits scale. Cache key checks `insert` where cache uses `insert.block`. **Critical qualification:** `dxfUseLegacyImporter` defaults false and native C++ path has explicit nested-block scaling. No blanket claim about FreeCAD's default importer or actual geometry; no runtime.
2. [FreeCAD LinuxCNC post source audit](../research/4400_FREECAD_LINUXCNC_POST_06_BLEND_DWELL_TWP_VERSION_BOUNDARY_SOURCE_AUDIT_2026-10-30.md): generic dwell uses G4 P, LinuxCNC post emits G61/G61.1/G64/G64 P by settings, default bare G64, and tilted-work-plane output G68.2/G53.1/G69 only for configured TWP. Stable v2.9.10 lacks G68.2; pinned development has it and its five-axis sample REMAPs G53.1. Conditional version/configuration trap, not universal rejection. Tests were **inspected**, not run.
3. Updated [geometry acceptance guide](../guides/4000-linuxcnc-dxf-to-gcode-geometry-acceptance-2026-10-30.md) with importer-mode and post-version gates. No new blind evaluator or lab runtime.

## Next highest-value unblocked LinuxCNC source question
**Preferred:** inspect FreeCAD's current native C++ top-level INSERT and MINSERT path (including base point, nested nonuniform scaling and source feature provenance) rather than assuming legacy behavior applies. In parallel or after a source stop, trace LinuxCNC development G53.1 remap/kinematics and actual FreeCAD TWP output/INI compatibility. Distinguish inspectable source from execution. If a frozen runtime question survives source inspection, require verified isolated local `[self-hosted, openpressbrake]` access before dispatch; never hosted Actions.

## Compute and evidence status
No workflow, build, simulation, test suite, benchmark, physical machine operation, evaluator or upstream submission. Zero GitHub-hosted and zero self-hosted minutes; no new authoritative runtime, so LAB_COMPUTE_LOG unchanged. FEEDBACK_SCORE_LOG unchanged. Panel-PC runner dispatch and physical isolation UNKNOWN. Keep hourly curriculum enabled.
