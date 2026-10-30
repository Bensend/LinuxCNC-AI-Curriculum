# 4000-LC-CAM-07 — Native FreeCAD DXF MINSERT: parsed entity, lost array parameters
**Session start: 2026-10-30T22:35:16Z UTC | 2026-10-30 | NON-GRADUATED | SOURCE-CONFIRMED static analysis; no runtime or machine operation**

## Exact question and why this is new
The [CAM-05 native/legacy investigation](4400_FREECAD_DXF_05_LEGACY_INSERT_SCALE_AND_NATIVE_IMPORT_BOUNDARY_SOURCE_AUDIT_2026-10-30.md) established that native top-level INSERT receives XYZ scale but did not resolve DXF MINSERT array counts. This continuation traces the **attribute dispatch itself**, rather than assuming missing callback arguments prove every DXF reader discards those attributes. The consequence matters for plasma nesting and repeated press-brake bend/reference geometry: a plausible single imported shape can conceal omitted copies.

## Pinned sources and provenance
- FreeCAD/FreeCAD commit [`bbc08916a0bab73fdb4b7f3dad7ff706a18924c9`](https://github.com/FreeCAD/FreeCAD/tree/bbc08916a0bab73fdb4b7f3dad7ff706a18924c9).
- [`src/Mod/Import/App/dxf/dxf.cpp`](https://github.com/FreeCAD/FreeCAD/blob/bbc08916a0bab73fdb4b7f3dad7ff706a18924c9/src/Mod/Import/App/dxf/dxf.cpp) blob `7d78b3b90d2b659759a9b4eb987b4e619dee176a`: `SetupValueAttribute` ~1948; `ProcessAttribute` ~2015–2023; `ProcessAllAttributes` ~2024–2030; `ProcessAllEntityAttributes` ~2031–2035; `ReadInsert` ~2342–2358; `ReadEntity` INSERT dispatch ~2915–2916.
- [`src/Mod/Import/App/dxf/ImpExpDxf.cpp`](https://github.com/FreeCAD/FreeCAD/blob/bbc08916a0bab73fdb4b7f3dad7ff706a18924c9/src/Mod/Import/App/dxf/ImpExpDxf.cpp) blob `9158059f253572fea32a79745cc80e1f582a69e0`: `OnReadInsert` ~1373–1388.
- [`src/Mod/Import/App/dxf/ImpExpDxf.h`](https://github.com/FreeCAD/FreeCAD/blob/bbc08916a0bab73fdb4b7f3dad7ff706a18924c9/src/Mod/Import/App/dxf/ImpExpDxf.h) blob `ef9c4e05acb25978bb825c9e127ee8bef93687b3`: `DrawingEntityCollector::AddInsert` ~345–400.
- [Autodesk INSERT DXF entity specification](https://documentation.help/AutoCAD-DXF/WS1a9193826455f5ff18cb41610ec0a2e719-7a04.htm): **DOC-CONFIRMED** codes 70=column count, 71=row count, 44=column spacing, 45=row spacing; default counts 1 and spacings 0.

## End-to-end native call flow — actual missing-data mechanism
1. `ReadEntity` recognizes an `INSERT` and calls `CDxfRead::ReadInsert`. A multi-insert array uses the same entity type with additional group codes; there is no separately dispatched `MINSERT` entity in this reader.
2. `ReadInsert` initializes `center`, `scale=(1,1,1)`, `rotationDegrees`, `blockName`. It registers handlers for point 10/20/30, scales 41/42/43, angle 50 and block name 2. **It registers none for 70, 71, 44 or 45.**
3. `ProcessAllEntityAttributes` calls `ProcessAllAttributes`, which loops through the entity records and calls `ProcessAttribute`. That method looks up the group code in `m_coordinate_attributes` and **returns false without assigning anything when no handler exists**; its caller does not inspect the return value. Consequently, the four array-specific records are read past without populating an array-count or spacing value. This is a stronger finding than merely noticing missing callback parameters.
4. `ReadInsert` then calls `OnReadInsert(center,scale,blockName,radians(rotationDegrees))` **once**. `ImpExpDxfRead::OnReadInsert` delegates once to `Collector->AddInsert`, and `DrawingEntityCollector::AddInsert` creates **one** `App::Link` for the block and applies `ScaleVector`. No row/column expansion occurs in these inspected functions. An undefined block-name lookup returns without creating a link (a separate, source-confirmed silent omission branch).
5. The native reader's normal OCS/entity attributes and possible downstream document transformations were not exhaustively validated. The narrow conclusion is that **this pinned reader/collector path does not carry or expand DXF MINSERT array metadata**. No physical or runtime output has been observed; avoid an unqualified assertion about every FreeCAD release or importer mode.

## Concrete source-derived acceptance discriminator (NOT TEST-CONFIRMED)
Define one block `PART_A` containing a 10 mm LINE (0,0)→(10,0). Insert at (100,200), X/Y scale 1, rotation 0, with DXF group `70=3` columns, `71=2` rows, `44=25` column spacing, `45=40` row spacing. **DOC-CONFIRMED DXF semantics** require six instances, with origins (100,200), (125,200), (150,200), (100,240), (125,240), (150,240), assuming compatible units and a zero block base point. The inspected native code has one callback and one `App::Link` creation, predicting a single instance if no independent expansion path intervenes. This is a **SOURCE-GROUNDED PREDICTION**, not measured FreeCAD geometry.

A minimal fixture must additionally check nested blocks, rotation and nonunit scale, because a successful single-INSERT test does **not** cover array cardinality. Record the source INSERT handle plus `[row,column]` in the canonical geometry manifest. A `3×2` array must not silently collapse to one entity or be accepted based on a visually plausible preview.

## Engineering contract / learner transfer
- Before CAM or nesting, compare expected instance count and transformed origins against imported object count and geometry. If a DXF has 70/71 counts >1, **reject or explicitly expand** using a parser that preserves these fields; do not silently flatten.
- Treat the default native C++ importer, legacy Python importer and other CAD/CAM importers as separate implementation paths. Native top-level scaling is SOURCE-CONFIRMED; MINSERT array preservation is not.
- Require a rejected-entity/unsupported-feature manifest and fail production NC on missing geometry. For press-brake inputs, distinguish bend lines from cut contours and do not infer tooling from DXF alone.
- A future isolated FreeCAD/ezdxf fixture is justified only if the exact imported instance count remains consequential after source reasoning. No workflow should run until the local `[self-hosted, openpressbrake]` runner is accessible and physically isolated. **No GitHub-hosted Actions compute.**

## Evidence ledger and adversarial checks
| Claim | Classification | Boundary |
|---|---|---|
| Autodesk codes 70/71/44/45 carry array count/spacing | DOC-CONFIRMED | INSERT DXF specification; not an installed file |
| Native `ReadInsert` does not register those four group codes | SOURCE-CONFIRMED | FreeCAD pinned commit |
| Unknown registered attribute returns false and caller ignores it | SOURCE-CONFIRMED | `ProcessAttribute` / `ProcessAllAttributes` |
| Single callback and single top-level link construction | SOURCE-CONFIRMED | Pinned reader + collector |
| A real imported six-instance fixture will show only one | INFERENCE / UNKNOWN runtime | No FreeCAD execution or alternate importer proof |
| Physical machine geometry, NC acceptance or release | UNKNOWN | No motion or machine validation |
| New runtime tests | TEST-CONFIRMED: none | Zero hosted and self-hosted compute |

**Unscored transfer:** A DXF viewer shows six repeated slots but native FreeCAD reports one imported block. What exact source symbols explain the discrepancy? Why does the successful import of a uniformly scaled single INSERT fail to validate the array? How would you distinguish a missing row from a 25 mm spacing error without relying on screenshots?

**Next:** [TWP remap/kinematics continuation](4400_LINUXCNC_TWP_08_G531_REMAP_KINEMATICS_AND_FREECAD_POST_HANDOFF_SOURCE_AUDIT_2026-10-30.md), then inspect a version-specific parser/geometry test only when a source question remains unresolved. Existing G0/G1 HOLD and independent evaluator OPEN are unchanged.
