# 4000-LC-CAM-05 — FreeCAD DXF INSERT scaling: legacy importer versus native path
**2026-10-30 | SOURCE-CONFIRMED static audit | no runtime/physical test | NON-GRADUATED**

## Narrow question and predecessor
The preceding [DXF2GCODE source audit](4400_LINUXCNC_DXF2GCODE_02_BULGE_BLOCK_ELLIPSE_POST_ARC_VALIDATION_SOURCE_AUDIT_2026-10-30.md), [ezdxf geometry audit](4400_DXF_EZDXF_01_BULGE_INSERT_NONUNIFORM_MINSERT_SOURCE_AUDIT_2026-10-30.md), and [PathForge comparison](4400_LINUXCNC_PATHFORGE_04_SUPPORTED_TYPES_G04_X_DWELL_POST_SOURCE_AUDIT_2026-10-30.md) established that a library name or successful G-code export does not establish correct DXF block geometry. This study asks whether a **current FreeCAD DXF import path** actually applies INSERT scale before CAM consumes the resulting shape. It does **not** assert a defect in all FreeCAD importers.

## Exact inspected source
- FreeCAD/FreeCAD pinned commit [`bbc08916a0bab73fdb4b7f3dad7ff706a18924c9`](https://github.com/FreeCAD/FreeCAD/tree/bbc08916a0bab73fdb4b7f3dad7ff706a18924c9).
- [`src/Mod/Draft/importDXF.py`](https://github.com/FreeCAD/FreeCAD/blob/bbc08916a0bab73fdb4b7f3dad7ff706a18924c9/src/Mod/Draft/importDXF.py) `_import_dxf`/dispatch around lines 2838–2917, `readPreferences` around 4355–4397, `drawBlock` around 1621–1747, `drawInsert` around 1751–1851, `drawPolyline` around 900–969. Blob `2424ee0059ad66702e4c428d14e71563c7e0cbe8`.
- [`src/Mod/Import/App/dxf/ImpExpDxf.cpp`](https://github.com/FreeCAD/FreeCAD/blob/bbc08916a0bab73fdb4b7f3dad7ff706a18924c9/src/Mod/Import/App/dxf/ImpExpDxf.cpp) `ComposeFlattenedBlock` lines ~618–640 and `ComposeParametricBlock` ~693–720. Blob `9158059f253572fea32a79745cc80e1f582a69e0`.

## Call-flow and actual default selection
`_import_dxf` reads `dxfUseLegacyImporter` with **default false**. If true, it calls `getDXFlibs` → `processdxf` → legacy `drawInsert`; otherwise it calls **native** `ImportGui.readDXF` or `Import.readDXF`. Thus the issue below is **legacy-path conditional**, not a default-FreeCAD or native-importer finding. `readPreferences` selects the legacy non-clone path for `dxfCreatePart`/fused blocks; editable Draft/Sketch modes may use `drawInsert(...,clone=True)`.

## SOURCE-CONFIRMED legacy non-clone failure mechanism
1. `drawBlock` stores `blockshapes[blockref.name] = shape` (string key). In non-clone `drawInsert`, the cache lookup is `if insert in blockshapes:` but the following access uses `blockshapes[insert.block]`. The lookup compares the INSERT object rather than its block-name key. **INFERENCE:** ordinary insert objects will miss this cache and re-enter `drawBlock`, causing redundant work; object equality/key behavior has not been runtime tested.
2. After obtaining a shape, the code captures `scale = insert.scale`, constructs a matrix and calls `tsf.rotateZ(rot)`, then immediately calls `shape.transformGeometry(tsf)` inside `try`. **The scale is only applied in the `except Part.OCCError` branch** by `tsf.scale(scale[0],scale[1],0)` before a retry. Therefore, **if the initial rotation-only transform succeeds, the requested INSERT scale never enters the matrix**. Translation is applied afterward. This is a direct source-level branch property, not a measured output.
3. The `clone=True` path is distinct: it assigns `newob.Scale = vec([sc[0],sc[1],0])` and Placement. Do not transfer the non-clone result to clones without checking FreeCAD clone/placement behavior.
4. Legacy `drawPolyline` *does* use the outgoing vertex's bulge, including `polyline.points[-1].bulge` on the closing edge. This positive finding does not cancel the separate INSERT-transform issue.

**Minimal mathematical discriminator (INFERENCE):** A block with a LINE from (0,0) to (10,0), inserted with X-scale 2, Y-scale 1, rotation 0 and translation (100,0), should yield (100,0)→(120,0). In the successful first legacy non-clone `transformGeometry` branch the matrix contains rotation but no scale, so the source predicts (100,0)→(110,0). This is **not TEST-CONFIRMED**; geometry/kernel and imported-unit behavior need a controlled fixture before claiming actual coordinates.

## Native C++ contrast — do not conflate import paths
The inspected native `ComposeFlattenedBlock` explicitly calls `transform.scale(nestedInsert.Scale)` before `nestedShape.transformShape`. The native parametric path assigns `link->ScaleVector.setValue(nestedInsert.Scale)`. This is **SOURCE-CONFIRMED evidence that these native nested-block branches account for scale**; it is **not** a blanket validation of all top-level INSERTs, nonuniform ellipse conversions, MINSERT, extrusion/OCS, units, source handles, or CAM export. Those remain UNKNOWN until traced or independently tested.

## Manufacturing/diagnostic consequence and bounded oracle
For a plasma contour or press-brake bend reference, a scaled block can look plausible but have the wrong dimensions. Before trusting NC, preserve original DXF entity/INSERT-instance identity and compare **source dimensions → normalized geometry → FreeCAD object geometry → CAM path → emitted NC**. Test both native (default) and legacy non-clone/clone import modes separately; include unit scale, rotation, nonuniform scaling, nested INSERT, closing-edge bulge and a source-ID manifest. Fail on missing entities, scale mismatch, or unexpected topology; do not repair a wrong ellipse with a looser LinuxCNC arc tolerance. No test was run because the branch difference is directly source-explainable and the local panel-PC runner's dispatch/physical isolation are UNKNOWN.

## Evidence ledger and next
- **SOURCE-CONFIRMED:** legacy conditional dispatch; wrong cache key; scale only in legacy exception branch; separate clone path; native nested scale application; closing-edge bulge handling.
- **INFERENCE:** normal successful rotation-only branch omits requested nonunit scaling in output; repeated block construction and dimensional consequence.
- **UNKNOWN:** actual FreeCAD runtime output, default native top-level block behavior, geometry-kernel exceptions, imported MINSERT and provenance fidelity, user-selected settings.
- **TEST-CONFIRMED:** none. Zero hosted/self-hosted Actions minutes, no build, simulation, interpreter run, machine motion or independent evaluation.
- **Next source question:** trace native C++ top-level INSERT and MINSERT handling, or prepare a minimal offline fixture only when local isolation and a frozen acceptance oracle justify compute.

**Boundary:** CAM/DXF geometry acceptance is ordinary manufacturing data validation, not personnel safety. OpenPressBrake G0/G1 HOLD and external safety evaluator state unchanged.
