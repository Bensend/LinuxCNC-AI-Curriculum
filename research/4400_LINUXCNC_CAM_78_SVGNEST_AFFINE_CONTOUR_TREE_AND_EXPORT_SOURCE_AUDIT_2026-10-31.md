# 4000-LC-CAM-78 — SVGnest polygon normalization, hole containment, affine transforms and LinuxCNC NC handoff

**2026-10-31 | 3300 plasma / 3600 geometry transfer / 4000 implementation | NON-GRADUATED, SOURCE-ONLY.** This is a distinct algorithm-level follow-up to [Deepnest CAM-77](4400_LINUXCNC_CAM_77_DEEPNEST_DXF_CONVERSION_UNITS_AND_NO_GCODE_POST_SOURCE_AUDIT_2026-10-31.md), not a claim that SVGnest is a current DXF reader or a LinuxCNC post. Its source is historically published **2019**, not newly published in 2026.

## Immutable provenance and exact source paths

- [Jack000/SVGnest commit `1248dc21efd3f90d1aa52ba5785e27e5217ed2c9`](https://github.com/Jack000/SVGnest/commit/1248dc21efd3f90d1aa52ba5785e27e5217ed2c9), dated **2019-04-11**.
- [`svgnest.js`](https://github.com/Jack000/SVGnest/blob/1248dc21efd3f90d1aa52ba5785e27e5217ed2c9/svgnest.js), blob `187356ad5acd8c3aa9d13002f5f0749a3820a342`: `parsesvg` ~46–74, `start` ~130–239, `getParts` ~593–668, `cleanPolygon` ~695–722, `applyPlacement` ~746–810.
- [`svgparser.js`](https://github.com/Jack000/SVGnest/blob/1248dc21efd3f90d1aa52ba5785e27e5217ed2c9/svgparser.js), blob `f7f96be13907f41c1fe3e06dc00165b01667e164`: `applyTransform` ~223–395, `polygonify` ~590–779.
- [`util/placementworker.js`](https://github.com/Jack000/SVGnest/blob/1248dc21efd3f90d1aa52ba5785e27e5217ed2c9/util/placementworker.js), blob `e51c95f85dd891c8d4b7f7f0c2986439aef85e73`: `rotatePolygon`, `placePaths` ~59–288.
- [Official project README](https://github.com/Jack000/SVGnest/blob/1248dc21efd3f90d1aa52ba5785e27e5217ed2c9/readme.md) blob `949c87916fd9a35d32d353d1494e41d44807bd7b`: SVG input, bin selection, spacing/curve tolerance/part-in-part options.
- Downstream controller reference: LinuxCNC stable **v2.9.10** [QtPlasmaC INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtplasmac/qtplasmac_metric_ini.inc) and [G-code filter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py); see existing [PLASMA-39](4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md) for filter state defects, not re-audited here.

## Source execution trace

`SvgNest.parsesvg` → `SvgParser.load` → `SvgParser.clean` (apply transforms, flatten/split paths) → `getParts` (`polygonify` and `cleanPolygon`, containment tree) → select bin → `start` (part spacing offset and bin inset) → `launchWorkers` (no-fit polygon / genetic placement) → `PlacementWorker.placePaths` (rotate, candidate NFP intersection/difference, fitness, `paths` unplaced) → `applyPlacement` (SVG groups and viewBox). No inspected step here emits LinuxCNC G-code or validates a pierce/toolpath plan.

## New source-confirmed geometry findings

**S1 — Nonuniform affine scaling is not correctly preserved for SVG arcs/circles.** In `SvgParser.applyTransform` ~240–245, a single scalar `sqrt(tarray[0]^2+tarray[2]^2)` is extracted from the affine matrix. For an `A` arc ~304–309, *both* radii are multiplied by that scalar while the endpoint is transformed by the full matrix (~313–318). A circle element likewise has its center transformed but its sole radius multiplied by the scalar (~380–386). The source itself notes that only uniform scale/no skew works. **Concrete mathematical discriminator:** an original radius-10 circle under `scale(2,1)` should become an ellipse with X radius 20 and Y radius 10. This code retains a circle with scalar radius 20, not that ellipse. Actual parsed/output polygon and placement are **NOT TESTED**; the affine contract is source-confirmed, not a measured nesting overlap.

**S2 — Containment uses one vertex rather than complete contour topology.** `getParts` ~623–639 treats a polygon `p` as a child of polygon `list[j]` when `pointInPolygon(p[0],list[j])` is true. It does not establish that every edge lies inside or that boundaries do not cross. For rectangles A=[(0,0),(10,0),(10,10),(0,10)] and B=[(5,5),(15,5),(15,15),(5,15)], B's first vertex is inside A while B extends outside. **SOURCE-CONFIRMED:** this predicate is sufficient to mark B a child of A in the inspected algorithm; whether an actual browser run produces a visually invalid nest or later rejection is **UNKNOWN**. For plasma, a false hole relationship would compromise inside/outside classification if blindly reused for cut planning.

**S3 — Self-intersecting polygon simplification can drop geometry.** `cleanPolygon` ~695–722 calls `Clipper.SimplifyPolygon` and deliberately retains only the **largest-area** result when multiple polygons are returned. `getParts` ~602–609 also silently omits polygons with invalid/too-small cleaned area (source TODO says to warn). This is a valid nesting simplification policy but **not** a lossless DXF/CAD normalization contract. Require an original-feature-to-accepted-feature inventory and explicitly reject unexplained missing contours, islands or bend marks.

**S4 — Spacing and placement are not kerf compensation.** `start` ~147–159 expands part exteriors by half of `config.spacing`, contracts child holes by half, and insets the bin by half when possible (~173–179). The placement worker rotates and positions these *nesting polygons*; it does not select a physical kerf side, plasma pierce point or lead-in. Its return object includes `paths` for unplaced shapes (~285–288), which must be checked rather than assuming all requested parts fit. **INFERENCE:** an apparently compact visual nest can still fail a process-aware cut plan; actual cutting behavior is UNKNOWN.

**S5 — Exported SVG carries pixel dimensions, not an NC unit contract.** `applyPlacement` ~756–760 creates a `viewBox` and sets `width`/`height` to `binBounds.width + 'px'` and `binBounds.height + 'px'`. It adds per-part `translate(... ) rotate(... )` groups (~767–789). The exported placement is SVG geometry; it does not establish whether one SVG user unit corresponds to one millimeter/inch in a later CAM tool. By contrast, the historical Deepnest export in CAM-77 can emit explicit `mm`/`in` dimensions. **Do not conflate these projects or assert SVGnest accepts DXF.**

## LinuxCNC-specific implementation decisions

A source-grounded transfer must keep three independent coordinate frames: (1) CAD physical units and original entity/feature IDs, (2) SVG user units and all nested affine transforms, (3) LinuxCNC G20/G21 machine-program units and G90/G91.1 arc state. Never use a visually correct `viewBox` as a dimensional calibration. If using tessellated SVG polygons, choose an explicit chord-error budget and verify the **physical** deviation after all transforms; `curveTolerance` is in SVG units, not automatically mm. Reconstruct and verify complete contour containment and winding, and preserve holes/bend marks/source IDs separately from nesting polygons. Postprocess with explicit QtPlasmaC material/feed/torch and inside-before-outside sequence; do not infer these from SVGnest's fitness or group order.

**Cross-check:** the stable LinuxCNC QtPlasmaC metric simulation INI uses `[FILTER] ngc/nc/tap=qtplasmac_gcode` and `RS274NGC_STARTUP_CODE=G21...`. A G-code filter is *after* CAM; it cannot restore omitted DXF features or resolve an SVG affine mistake. A separate `[FILTER]` configuration may differ on a real machine.

## Evidence ledger and bounded acceptance

| Mechanism | Class | Runtime/physical gap |
|---|---|---|
| Nonuniform arc/circle transform uses one scale | SOURCE-CONFIRMED | exact SVG/Clipper output NOT RUN |
| First-vertex containment decides parent | SOURCE-CONFIRMED | overlap/child reproduction NOT RUN |
| Simplification chooses largest component; invalid contour excluded | SOURCE-CONFIRMED | feature-loss counts NOT RUN |
| Half-spacing offsets; unplaced `paths` returned | SOURCE-CONFIRMED | fit/kerf/lead-in validation NOT RUN |
| Export `px` and transform groups | SOURCE-CONFIRMED | physical unit roundtrip NOT RUN |
| Safe/correct LinuxCNC NC | UNKNOWN | post, filter, interpreter and isolated acceptance |

Use the [bounded acceptance guide](../guides/4000-linuxcnc-nesting-dxf-svg-plasma-handoff-acceptance-2026-10-31.md) and [checkpoint](../checkpoints/20261031T214200Z-4000-linuxcnc-nesting-cam-next.md). No product build, no Actions, no physical machine or independent evaluation. The prior 3000 graduation and personnel-safety gates are unchanged.
