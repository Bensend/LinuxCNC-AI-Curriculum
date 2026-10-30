# 4000-LC-DXF-01 — ezdxf LWPOLYLINE bulges, INSERT transforms and CAM geometry loss boundaries
**2026-10-30 | pinned ezdxf commit `5265e6e6d02388a95f406c26983e5c39452ad003` | SOURCE-CONFIRMED static inspection | NO EXECUTION / NON-GRADUATED**

## Question, scope and novelty
Can an OpenPressBrake/plasma DXF import path safely flatten a `LWPOLYLINE` to straight vertex-to-vertex chords, then copy block `INSERT` geometry without handling scale, rotation, mirroring or MINSERT? **No.** The inspected open-source `ezdxf` implementation contains explicit rules and exceptions that make those shortcuts observably geometry-changing. This extends the [shared DXF/CAD/CAM discovery](shared-dxf-cad-cam-discovery-2026-09-14.md) and [LinuxCNC G64 Q post review](4400_LINUXCNC_G64_Q_NAIVECAM_MULTI_TURN_DXF_POST_SOURCE_AUDIT_2026-10-30.md); it does not reopen graduated 3300 or 3600.

## Pinned inspectable source
All links below use immutable commit `5265e6e6d02388a95f406c26983e5c39452ad003` of [ezdxf](https://github.com/mozman/ezdxf), not an unpinned documentation landing page.
- [`src/ezdxf/math/bulge.py`](https://github.com/mozman/ezdxf/blob/5265e6e6d02388a95f406c26983e5c39452ad003/src/ezdxf/math/bulge.py), blob `81258ded4e7852662e90c2e79d20f645bff4b289`, `bulge_to_arc` lines ~83–115.
- [`src/ezdxf/render/polyline.py`](https://github.com/mozman/ezdxf/blob/5265e6e6d02388a95f406c26983e5c39452ad003/src/ezdxf/render/polyline.py), blob `0122ba637c4de110e61ce857a3d49346fe31a89b`, `virtual_lwpolyline_entities` ~18–40 and `_virtual_polyline_entities` ~100–135.
- [`src/ezdxf/entities/lwpolyline.py`](https://github.com/mozman/ezdxf/blob/5265e6e6d02388a95f406c26983e5c39452ad003/src/ezdxf/entities/lwpolyline.py), blob `f07dc747cc0d399301a850474acc3955b086513b`, `transform` ~353–408 and `virtual_entities` ~412–422.
- [`src/ezdxf/entities/insert.py`](https://github.com/mozman/ezdxf/blob/5265e6e6d02388a95f406c26983e5c39452ad003/src/ezdxf/entities/insert.py), blob `a5c3d621793da3dcd7b292ff6438b94d2c14f005`, `matrix44` ~507–538, `virtual_entities` ~603–650 and `multi_insert` ~668–710.
- [`src/ezdxf/explode.py`](https://github.com/mozman/ezdxf/blob/5265e6e6d02388a95f406c26983e5c39452ad003/src/ezdxf/explode.py), blob `b53ae4a9d2d32776ae36d8f295b5235288d8d58b`, `virtual_block_reference_entities` ~166–258 and `transform` exception handler ~226–252.
- [`tests/test_06_math/test_601_bulge.py`](https://github.com/mozman/ezdxf/blob/5265e6e6d02388a95f406c26983e5c39452ad003/tests/test_06_math/test_601_bulge.py), blob `81438d8c650d29c6540457449b10d4b9a69342ff`, pre-existing upstream tests for radius/center/negative bulge. **Their presence is SOURCE-CONFIRMED; they were NOT run in this session.**

## Geometry semantics that a CAM import must preserve
1. **Bulge belongs to the start vertex of a segment**, not the following endpoint. `virtual_lwpolyline_entities` calls `get_points("xyb")`, appends the first point only when `closed`, and passes each previous point's bulge to `bulge_to_arc(prev_point, point, prev_bulge)`. Thus the **last stored bulge controls the closing edge** for a closed polyline. Dropping it can silently change a rounded closing corner into a chord.
2. `bulge_to_arc` returns a **counterclockwise-oriented** arc representation even for negative (clockwise) bulge: when `bulge < 0`, it swaps returned start/end angles. The original polyline traversal remains start-vertex → next-vertex, **clockwise** for a negative bulge. A CAM post that uses the returned CCW angles without remembering original direction can reverse the segment traversal.
3. `LWPolyline.transform` explicitly raises `NonUniformScalingError` if `has_arc` and the transform is nonuniform. It does not pretend a stretched circle remains a circle. Its note also says reflection can flip the OCS extrusion, so raw stored vertex coordinates after transform are not necessarily world coordinates; use `vertices_in_wcs` for WCS queries.
4. `Insert.matrix44` incorporates the block's scale factors, extrusion/OCS, rotation, **block base-point correction**, and final insertion translation. Applying only a translation or rotation loses the intended world geometry. `Insert.virtual_entities` does not itself resolve **MINSERT** grids: `mcount > 1` requires `multi_insert`. It also **ignores XCLIP clipping** and warns about nonuniform-scale text results.
5. `explode.virtual_block_reference_entities` catches `NonUniformScalingError`: for ARC/CIRCLE it converts to `Ellipse.from_arc(...).transform(m)`; for bulged LWPOLYLINE/POLYLINE it recursively transforms virtual LINE/ARC primitives. This is a **source-confirmed representational change**. A consumer that accepts only LINE/ARC must either handle ELLIPSE with a bounded approximation error or reject the entity explicitly; silently dropping it changes the nest.
6. `virtual_entities` objects are not inserted into the document's entity database and lack normal handles/layout membership. Maintain explicit **source provenance** (original entity/block reference, block path, transform, layer, units, geometry revision) when generating contours. An ephemeral virtual primitive is not a durable identity for CAD/CAM traceability.

## Concrete import/canonicalization contract (design guidance, not a product build)
A machine-neutral import pipeline should produce a **geometry manifest** before nesting or postprocessing:

| Field | Required reasoning |
|---|---|
| Original DXF document + units | Preserve original unit source, reject unknown unit assumptions, record conversion to mm/in |
| Original entity handle / block path / layer | Identify source feature; retain bend-line vs cut-contour classification separately |
| Transform stack | INSERT/MINSERT index, scale including sign, rotation, extrusion/OCS, block base point |
| Segment primitive + traversal | LINE/ARC/ELLIPSE or bounded approximation; preserve original clockwise/CCW and closed-edge bulge |
| Contour topology | Closedness, winding, open endpoints, self-intersections, holes/islands and nesting kerf side |
| Approximation budget | Explicit maximum deviation of ellipse/curve tessellation **before** LinuxCNC G64 Q/P; no silent line substitution |
| Rejection/warning ledger | Unsupported text, XCLIP, missing units, nonuniform transform, skipped entities and why |
| Post identity | Material, feed, lead-in/out, kerf, feature ID and G-code program/revision |

For plasma: do not let G64 Q erase critical contour features or conflate `M190/M66` material-ready with arc-ready. For press brakes: DXF bend lines are **not** automatically bend sequence, tool selection, backgauge contact or collision proof. LinuxCNC normal control and the CAM post do not own independent personnel safety.

## Bounded source-based acceptance scenarios (NOT RUN)
A future **local-only** importer unit fixture, if an actual implementation requires it, should freeze expected canonical output **before** execution:
- Closed LWPOLYLINE with nonzero bulge on its last vertex must produce a curved closing edge.
- Identical endpoints with `bulge=+1` versus `-1` must preserve opposite original traversal, even though the math helper returns CCW-normalized angles.
- Uniformly scaled/rotated INSERT must include block base point; reflected INSERT must preserve WCS geometry and correct winding/OCS.
- Nonuniformly scaled bulged LWPOLYLINE must become appropriate elliptical geometry or an explicit rejection, never silently become a circular arc or chord.
- MINSERT with `mcount>1` must expand each grid instance; an XCLIP must be marked unsupported or handled explicitly.
- Compare resulting canonical contours to source geometry with declared tolerance; **do not** infer LinuxCNC tool motion or machine safety from parser-only tests.

No test was dispatched because the source already answers the semantic question and no new importer implementation exists to validate. A future bounded test must use the isolated local `[self-hosted, openpressbrake]` runner if GitHub workflow compute is needed, never a hosted runner.

## Evidence ledger and next question
| Claim | Classification | Limit |
|---|---|---|
| Bulge applies to start vertex and closing segment | SOURCE-CONFIRMED | Pinned ezdxf render implementation |
| Negative bulge normalizes arc angles to CCW, reversing returned angle endpoints | SOURCE-CONFIRMED | Pinned helper; original traversal must be retained |
| Nonuniform scaling of bulged LWPOLYLINE raises; explode can convert arcs to ellipses | SOURCE-CONFIRMED | Pinned source; no runtime |
| INSERT includes scale/rotation/OCS/base point; MINSERT and XCLIP limitations | SOURCE-CONFIRMED | Pinned insert/explode source |
| Upstream bulge tests exist | SOURCE-CONFIRMED | **Not TEST-CONFIRMED here** |
| Accuracy of any actual imported DXF/nesting/NC output | UNKNOWN | No importer implementation, fixture or machine |
| New runtime verification | TEST-CONFIRMED **none** | Zero compute |

**Next discriminating source question:** Inspect a concrete open-source CAM post/nesting pipeline that consumes DXF (e.g. FreeCAD Path/CAM or a plasma-focused open-source project) and determine whether it preserves **bulge/ellipse and block provenance** into G-code, or whether it flattens geometry and loses feature identity. Prefer one real input→post trace over broad tool surveys. If source evidence stops, return to LinuxCNC HAL/HostMot2 timing or Task/interpreter internals. Preserve graduated levels and the existing external safety/evaluator gates.
