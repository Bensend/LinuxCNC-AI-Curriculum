# 4000-LC-CAM-38 — OpenBuilds CAM DXF import and LinuxCNC G-code handoff: nested INSERT, units and curve tessellation
**2026-10-31 · SOURCE-CONFIRMED static, NON-GRADUATED.** Independent cross-tool source inspection for mill/router/plasma/OpenPressBrake CAD/CAM workflows, **not** a required product build. Not a duplicate of earlier **FreeCAD** CAM-05/POST-06/DXF-07 INSERT/MINSERT audits: this traces a separate JavaScript toolchain and a different recursion/units/post interface.

## Provenance and source inventory
Public [OpenBuilds/OpenBuilds-CAM](https://github.com/OpenBuilds/OpenBuilds-CAM), pinned **commit `7369478adfe6ac9fe154cebfe7ff1945ef90c409`** (commit date 2025-03-04; inspected 2026-10-31). Source blob IDs:
- [`js/main.js`](https://github.com/OpenBuilds/OpenBuilds-CAM/blob/7369478adfe6ac9fe154cebfe7ff1945ef90c409/js/main.js) `3635a8e51aeffb201ad9bfdf0fb7da6bc84ff281`: `FileReader.readAsText` DXF → `drawDXF`.
- [`js/dxf-render.js`](https://github.com/OpenBuilds/OpenBuilds-CAM/blob/7369478adfe6ac9fe154cebfe7ff1945ef90c409/js/dxf-render.js) `70afac89f594c68a5a7b539bbed894fc27395399`: `new DxfParser().parseSync(file)`; loops top-level entities with `drawEntity(i,entity,dxf2)`; a falsy return increments unsupported count and produces a toast.
- [`lib/dxf/three-dxf.js`](https://github.com/OpenBuilds/OpenBuilds-CAM/blob/7369478adfe6ac9fe154cebfe7ff1945ef90c409/lib/dxf/three-dxf.js) `d8ad5de66bda43c6da754be02b96fc19aaa35224`: `drawEntity`, `drawBlock`, `drawLine`, `drawCircle`, `THREE.BulgeGeometry`.
- [`js/advanced-cam-gcode.js`](https://github.com/OpenBuilds/OpenBuilds-CAM/blob/7369478adfe6ac9fe154cebfe7ff1945ef90c409/js/advanced-cam-gcode.js) `306562cc7da6eb1ad639590e9762ae74906d52b9`: `generateGcode` traverses Three.js toolpath vertices; final generator prepends `G21 ; mm-mode`; plasma operation sets `toolon = "M3S" + scommandscale`, `tooloff="M5"`.

## Finding A — Nested DXF INSERT loses the block dictionary
The **top-level** import calls `drawEntity(index, entity, dxf2)`, where `dxf2` is the parsed DXF object. An `INSERT` dispatches `drawBlock(entity,index,dxf)`. Inside `drawBlock`:
```js
var block = data.blocks[entity.name];
var group = new THREE.Object3D();
...
for (var i = 0; i < block.entities.length; i++) {
  var childEntity = drawEntity(index + '-' + i, block.entities[i], group);
  if (childEntity) group.add(childEntity);
}
```
**SOURCE-CONFIRMED:** recursion passes `group` (a newly constructed Three.js object), **not** the original parsed `data` containing `blocks`. If a child of an INSERT is itself an INSERT, its recursive `drawBlock` tries `data.blocks[entity.name]` on the group, for which `blocks` is not established in this path. **INFERENCE:** this produces a JavaScript property-access error and can interrupt the DXF import rather than merely counting an unsupported entity. Actual runtime and error presentation are **NOT TESTED**. The one-level INSERT path can work if the referenced block exists; do not generalize the nested failure to all INSERTs. The current source also dereferences `block.entities` without first checking whether `block` exists, so missing block definitions need separate validation.

A minimal candidate correction would thread the **original parsed DXF block dictionary** through recursive calls (`drawEntity(..., data)`), while retaining the Three.js group as the geometry parent. That proposal is not applied and requires a nested INSERT regression fixture to verify transforms and geometry.

## Finding B — DXF geometry reaches an explicitly metric G-code header
The inspected DXF path constructs Three.js geometry from DXF coordinates (`drawLine` uses `vertex.x,vertex.y`, `drawCircle` translates by `entity.center.x/y/z`). The inspected top-level DXF importer does **not** read or normalize `$INSUNITS`. The G-code assembly prepends **`G21 ; mm-mode` unconditionally** before optional user start G-code and generated toolpaths. **SOURCE-CONFIRMED:** that header is unconditional in the inspected generator; coordinates are passed through the inspected DXF draw path without a visible units conversion. **UNKNOWN:** whether other UI/import settings or upstream dependencies perform a unit conversion elsewhere. **INFERENCE:** an inch-authored DXF without an explicit 25.4 conversion could be interpreted in millimeters, producing a severe scale mismatch. Do not claim an actual miscut or assert that the entire codebase lacks any units handling based on these selected files.

**Acceptance discriminator:** import two DXFs representing the same 25.4 mm square (one with millimeter units, one with inch units); compare Three.js geometry bounds and generated G-code X/Y extents. Require explicit units confirmation and reject mismatches before machine execution.

## Finding C — The inspected path tessellates curves and uses configurable linear moves
`drawCircle` constructs `THREE.CircleGeometry(radius,128,startAngle,angleLength)` and removes its center vertex. `drawLine` turns nonzero DXF bulge into `THREE.BulgeGeometry` vertices. `generateGcode` iterates toolpath vertices and writes the user-configurable `g1command` plus `X/Y/Z` values, rather than retaining native DXF arc-center/radius metadata in the inspected output path. **SOURCE-CONFIRMED:** geometric tessellation occurs before this vertex-driven post; **UNKNOWN:** exact end-to-end chord error after all CAM offsets/transforms and UI settings. Do not claim the whole app can never emit G2/G3 through other code or user-supplied start/end snippets.

For precision plasma contours or bend tooling, acceptance must check maximum chord deviation and feature identity after offsets/nesting. For a full circle of radius R approximated by N equal segments, the theoretical per-chord sagitta is `R*(1-cos(pi/N))`; this is an **analytical bound only for the ideal equal-segment case**, not a measured bound for this complete toolchain.

## Finding D — Plasma post is not automatically QtPlasmaC-compatible
The inspected `Plasma` branch emits `M3S<scale>` for tool-on and `M5` for tool-off; an IHS string is separately configurable. This is **SOURCE-CONFIRMED output construction**, not a LinuxCNC QtPlasmaC compatibility guarantee. Compare it to the exact installed QtPlasmaC post/motion conventions before use; earlier [PLASMA-32](4400_LINUXCNC_PLASMA_32_QTPLASMAC_OVERCUT_M62_P3_TP_TIMING_AND_FILTER_SOURCE_AUDIT_2026-10-31.md) documents the distinct M62 P3 torch-off and M67 E3 velocity-reduction contracts. Do not assume M3S alone supplies QtPlasmaC probing, pierce timing, torch height control, overcut or cut-chart behavior.

## Minimal software-only acceptance matrix (not run)
| Fixture | Expected discriminator | What it can establish |
|---|---|---|
| One-level INSERT with a LINE | compare bounds and count | baseline block expansion |
| Two-level nested INSERT with transforms | catch exception; compare flattened vertices | recursive block dictionary propagation |
| Missing block reference | catch error vs unsupported toast | error-handling contract |
| Same square DXF in mm and inch | compare X/Y extents and G21 header | unit normalization/scale boundary |
| 100 mm radius ARC and bulged LWPOLYLINE | measure max deviation from exact analytic arc | actual tessellation tolerance |
| Plasma profile with IHS/overcut requirement | inspect emitted M-codes and installed QtPlasmaC conventions | post compatibility, not physical cut |

**Evidence:** SOURCE-CONFIRMED for the cited code paths; INFERENCE for runtime failure and scale risk; DOC/TEST-CONFIRMED none from new experiments. No LinuxCNC or OpenBuilds CAM execution, browser UI test, machine operation, build, Actions workflow, or external evaluation. Do not run generated code on a machine until independent geometry/unit/post validation. Preserve personnel-safety authority and existing gates.

**Next:** create a tiny offline DXF fixture set with nested INSERT and unit variants if isolated software execution becomes available; compare actual output and patch proposal only after reproducing. Otherwise rotate to source-grounded LinuxCNC Task/INI postprocessor contracts rather than building a compulsory CAD/CAM product.
