# PLASMA-198 — DXF LWPOLYLINE bulge → LinuxCNC arc geometry (2026-11-03)

Status: **SOURCE-CONFIRMED for inspected implementation; analytical fixture NOT RUN; NON-GRADUATED**. Track 3300, transfer to 3600. This increment closes the specific parser gap in PLASMA-197; it does **not** claim a complete CAM postprocessor.

## Immutable provenance
- ezdxf commit `c498560bb491c357deda538360ed0c8fdb11f5a7` (2026-11-02), [`src/ezdxf/entities/lwpolyline.py`](https://github.com/mozman/ezdxf/blob/c498560bb491c357deda538360ed0c8fdb11f5a7/src/ezdxf/entities/lwpolyline.py), `LWPolyline.__iter__`, `closed`, `has_arc`, `vertices_in_wcs`: vertex tuple is (x,y,start_width,end_width,bulge) **in OCS**; closed polyline adds final-to-first segment. Width and extrusion/elevation are not optional to a correct interpretation.
- Same commit [`src/ezdxf/math/bulge.py`](https://github.com/mozman/ezdxf/blob/c498560bb491c357deda538360ed0c8fdb11f5a7/src/ezdxf/math/bulge.py), `bulge_to_arc`, `signed_bulge_radius`, `bulge_from_arc_angle`: `bulge=tan(sweep/4)`; radius is `abs(chord*(1+b²)/(4*b))`; negative bulges are **clockwise** in original vertex traversal, but `bulge_to_arc` **returns CCW-oriented angles with start/end swapped**. A caller must not mistake the returned CCW convention for the original contour direction.
- LinuxCNC annotated tag `v2.9.10` tag object `4e7abeab3e764a42ef9def932333a1d4004e547b` peels to **commit `86cdca76fa2a36274c432caa21952b23c267989a`** (resolves PLASMA-197 pin gap). [`lib/python/plasmac/line.py`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/lib/python/plasmac/line.py), `do_arc_3_points`: emits G2/G3 X/Y endpoint and **start-relative I/J**. This is an output geometry convention, not a complete QtPlasmaC cutting program.

## Adapter contract (SOURCE-CONFIRMED inputs; proposed integration)
1. Determine explicit drawing units. Reject ambiguous `$INSUNITS=0` until the operator/project supplies a unit policy. Normalize to target machine units **once**; set G21 or G20 explicitly.
2. Resolve each entity's OCS and block INSERT transformations into a common planar frame before emission. A mirrored transform reverses winding and G2/G3; nonuniform scaling turns circles into ellipses, so **reject or tolerance-flatten** rather than falsely output a circular G2/G3. This is a required adapter rule, not a verified ezdxf exporter behavior.
3. For LWPOLYLINE vertex `i`, the bulge describes segment **i → i+1**, including last→first only when closed. For `b=0` emit G1; for `b>0` emit G3; for `b<0` emit G2, preserving the original endpoint order. Obtain center from `bulge_to_arc` but **ignore its normalized CCW start/end angles for traversal**; compute I=center.x-start.x and J=center.y-start.y.
4. Validate chord > epsilon, finite bulge/center, start/end radius agreement, unit-scaled geometry, planar extrusion, closed-contour topology, widths, arc sweep and machine bounds. Do not silently discard widths or splines. Emit G17 G90 and explicit arc-center mode G91.1 in the target dialect (verify interpreter/config compatibility before runtime).
5. Keep geometric output separate from QtPlasmaC material/kerf/pierce/arc-OK/THC sequencing and from press-brake backgauge/bend semantics. Nesting applies placement transforms before toolpath generation; it is not itself a cutting controller.

## Independently checkable analytical fixture (not executed)
A DXF LWPOLYLINE in mm with vertices `(0,0,b=+1)`, `(20,0,b=0)`, open, defines the **CCW upper-or-lower?** semicircle from (0,0) to (20,0) with center (10,0), radius 10; by CCW traversal it passes through **(10,-10)**. Its proposed geometry-only output:
```ngc
G21 G17 G90 G91.1
G0 X0 Y0
G3 X20 Y0 I10 J0
```
Changing only the bulge to `-1` gives clockwise traversal via **(10,+10)** and `G2 X20 Y0 I10 J0`. Both arcs have radius 10; a center-only assertion cannot detect a reversed bulge. This fixture is NOT a plasma cut: no F, torch, material, pierce, lead or Z control. The direction/midpoint values are mathematical predictions, not LinuxCNC runtime results.

## Discriminating review/test matrix
A positive/negative bulge semicircle; closed last→first bulge; zero-length chord with nonzero bulge; unitless and inch units; OCS extrusion not +Z; mirrored INSERT; nonuniform INSERT; polyline widths; near-full-circle bulge; multiple nested contours with islands. For each record source entity, normalized geometry, emitted arc/line, orientation, midpoint, center/radius error, and rejection reason. Runtime interpreter acceptance and QtPlasmaC material sequencing remain **UNKNOWN**.

## Source/evidence limitations
No ezdxf installation, generated DXF file, executable CAM postprocessor, QtPlasmaC simulator, test run, or physical machine was used. The exact QtPlasmaC `first_segment` and circle body remain pending. Do not call these source predictions TEST-CONFIRMED. The negative-bulge CCW-normalization trap is the highest-value reusable finding; next inspect a real pinned LinuxCNC-compatible CAM postprocessor and actual QtPlasmaC simulation config, rather than inventing a complete toolchain.
