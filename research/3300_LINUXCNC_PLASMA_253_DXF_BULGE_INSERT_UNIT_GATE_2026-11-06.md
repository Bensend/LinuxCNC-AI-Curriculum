# PLASMA-253 — DXF arc orientation, block transforms, and unit admission gate
Date: 2026-11-06. Track: 3300 plasma, NON-GRADUATED. Continuation of PLASMA-252. Evidence: upstream source inspection only; no executable converter or machine validation.

## Pinned inspectable implementation evidence
- ezdxf `src/ezdxf/math/bulge.py`, Git blob `81258ded4e7852662e90c2e79d20f645bff4b289`: [source](https://github.com/mozman/ezdxf/blob/81258ded4e7852662e90c2e79d20f645bff4b289/src/ezdxf/math/bulge.py). `bulge_to_arc` explicitly returns **counterclockwise** angular bounds even for negative bulges: for negative values it swaps the source and destination angle roles. `signed_bulge_radius` divides by bulge; zero is a line, not an arc input.
- ezdxf `src/ezdxf/entities/insert.py`, Git blob `a5c3d621793da3dcd7b292ff6438b94d2c14f005`: [source](https://github.com/mozman/ezdxf/blob/a5c3d621793da3dcd7b292ff6438b94d2c14f005/src/ezdxf/entities/insert.py). INSERT attributes include translation, x/y/z scaling, rotation, extrusion, row/column counts and spacing; negative scale can reflect geometry. `has_uniform_scaling` uses absolute scale magnitudes, so it does not prove orientation preservation.
- ezdxf `src/ezdxf/units.py`, Git blob `a82ae0fde94fe079efba6dba68beee6e3583ccf0`: [source](https://github.com/mozman/ezdxf/blob/a82ae0fde94fe079efba6dba68beee6e3583ccf0/src/ezdxf/units.py). DXF `$INSUNITS` 0 is unitless/unsupported by `conversion_factor`; 1 inches, 4 millimeters. Conversion is target-meter-factor/source-meter-factor. For inches to millimeters: 1000/39.37007874 ≈ 25.4.
- Prior QtPlasmaC G-code generator source evidence: [PLASMA-252](3300_LINUXCNC_PLASMA_252_QTPLASMAC_CONVERSATIONAL_CAM_BOUNDARY_2026-11-06.md) establishes incremental I/J and torch commands. This note does **not** claim any ezdxf→QtPlasmaC bridge exists.

## Newly established integration hazard
The DXF polyline bulge belongs to the **outgoing segment** of each vertex, including the last→first segment for a closed polyline. Its sign conveys travel orientation. A naïve converter that emits `bulge_to_arc` returned CCW start/end angles directly as toolpath traversal will **reverse the segment endpoints for negative bulges**. Correct converter logic must preserve the original vertex traversal and emit clockwise G2 for negative bulge, counterclockwise G3 for positive bulge, with I/J measured from the **actual motion start**, not from the library's canonicalized CCW arc start.

Example (untransformed XY): A=(0,0), B=(10,0), bulge=-1 is a clockwise semicircle with center (5,0), radius 5; emit `G2 X10 Y0 I5 J0` when starting at A. For bulge=+1 the same endpoints and center require `G3 X10 Y0 I5 J0`. This is a geometric prediction to be checked against the upstream function and LinuxCNC interpreter, not a runtime-confirmed G-code result.

## Transform admission contract
For each entity record: (1) resolve INSERT hierarchy and array instances, (2) apply block-local geometry and nested transforms, (3) apply drawing units to a single target XY unit, (4) calculate transformed segment orientation, (5) only then compute arc centers and incremental I/J, kerf and lead geometry. A transform with negative 2D determinant reverses handedness and swaps G2/G3; it also reverses signed contour winding. Nonuniform XY scaling of circles produces ellipses: reject or approximate to a declared tolerance, never silently retain circular G2/G3. Nested block references, OCS/extrusion and MINSERT grids must be resolved or explicitly rejected; a flat modelspace entity scan is incomplete.

## Fail-closed admission checks (offline; no torch execution)
| Fixture | Expected result | Failure it catches |
|---|---|---|
| Closed 10×10 square LWPOLYLINE, final vertex bulge=0 | Four segments including closing edge | Missing final segment |
| A=(0,0), B=(10,0), bulge=+1 and -1 | Same radius 5 and center (5,0), opposite G3/G2; same actual start A | CW/CCW reversal caused by library canonicalization |
| Reflect prior arc using xscale=-1, yscale=1 | Orientation reverses; transformed I/J recomputed from transformed start | Mirrored toolpath cuts wrong side |
| Scale x=2, y=1 on a circular arc | Reject or documented curve approximation | False circular arc after anisotropic scaling |
| $INSUNITS=1 vs 4, same numerical 10-unit edge | 254 mm vs 10 mm | Inch/mm scale error |
| $INSUNITS=0 or unsupported conversion | Require explicit unit declaration; no G-code output | Implicit unit guessing |
| Nested INSERT and MINSERT | Expand all intended instances or explicit unsupported error | Missing or displaced contours |
| Inner circular hole inside outer rectangle | Hole first; contour hierarchy and kerf ownership explicit | Wrong cut order or double kerf |
| Near-zero bulge | Treat as line using declared tolerance, no division by zero | Singular radius |
| Duplicate/zero-length segment | Reject or normalize with traceable warning | Degenerate G2/G3 |

## Minimal reproducible source inspection
```sh
git clone https://github.com/mozman/ezdxf.git
cd ezdxf
git cat-file -p 81258ded4e7852662e90c2e79d20f645bff4b289 | sed -n '60,115p'
git cat-file -p a5c3d621793da3dcd7b292ff6438b94d2c14f005 | grep -n -E 'xscale|yscale|rotation|column_count|row_count'
git cat-file -p a82ae0fde94fe079efba6dba68beee6e3583ccf0 | grep -n -E 'INSUNITS|conversion_factor|Unitless'
```
These are immutable blob references, not a claim that the upstream default branch is frozen.

## Explicit evidence boundary and next work
SOURCE-CONFIRMED: bulge canonicalization, INSERT transform attributes, DXF unit mapping. MATHEMATICALLY DERIVED, NOT EXECUTED: signed bulge examples and determinant orientation rule. NOT VERIFIED: end-to-end DXF normalization, QtPlasmaC material-selection/filter contract, nesting geometry, executable LinuxCNC interpreter behavior, actual cutting. Next: inspect QtPlasmaC material/filter source and a pinned nesting implementation, then add a tiny offline fixture with assertions if the code paths support it. Do not trigger GitHub-hosted Actions; only justified isolated [self-hosted, openpressbrake]. Maintain independent personnel-safety authority and existing evaluation gates.
