# 4000 practical acceptance — historical Deepnest/SVGnest → geometry → CAM → LinuxCNC QtPlasmaC

**2026-10-31 | 3300/3600 transfer + active 4000 | ALL CASES NOT RUN.** Accompanies [Deepnest CAM-77](../research/4400_LINUXCNC_CAM_77_DEEPNEST_DXF_CONVERSION_UNITS_AND_NO_GCODE_POST_SOURCE_AUDIT_2026-10-31.md) and [SVGnest CAM-78](../research/4400_LINUXCNC_CAM_78_SVGNEST_AFFINE_CONTOUR_TREE_AND_EXPORT_SOURCE_AUDIT_2026-10-31.md). These are **different historical tools/revisions**, not a tested integrated pipeline. A separate [2026 Deepnest-next comparison](../research/4400_LINUXCNC_CAM_79_2026_DEEPNEST_NEXT_CONVERTER_PLT_VS_LINUXCNC_POST_SOURCE_AUDIT_2026-10-31.md) examines current-fork changes. This guide is an engineering review and future disconnected-software test plan, **not** an executable machine program or product requirement.

## Frozen source and oracle boundaries

Deepnest `Jack000/Deepnest@2fb10513a30681971dcc991c528fa0738a2c0c76` (2018-08-26), SVGnest `Jack000/SVGnest@1248dc21efd3f90d1aa52ba5785e27e5217ed2c9` (2019-04-11), LinuxCNC `v2.9.10` [QtPlasmaC metric INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtplasmac/qtplasmac_metric_ini.inc) and [filter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py). Read the actual revision before running any case. Expected outcomes below are **source-based predictions**, not observed results. Keep original DXF/SVG, normalized geometry, nest output, CAM plan, filtered NC and interpreter log as **separate files**.

| Case | Frozen input / stimulus | Predicted discriminator / independent evidence |
|---|---|---|
| D1 | Deepnest historical UI: import a simple local SVG with no network | Local `readFile` path reaches `importsvg`; record accepted part count and dimensions. |
| D2 | Same shape supplied as DXF with conversion service disconnected | DXF path attempts `request.post` and reports conversion-server failure; **do not** call a local SVG pass proof of DXF support. |
| D3 | DXF with one 100-mm witness dimension; compare explicit import units `Points` vs `mm` | Capture server-returned SVG width/viewBox, `scalingFactor`, normalized dimension and selected units; compare to 100 mm, not screenshot size. No numeric output assumed in advance. |
| D4 | Export a known nest as SVG then request DXF | SVG path local; DXF export requires remote conversion. Record export-unit selection and physical dimension roundtrip. |
| D5 | Inspect the pinned G-code export UI handler | The `exportgcode` block is inside a JS comment. A G-code file appearing from a different post must have its own provenance; this tool is not a validated QtPlasmaC post. |
| D6 | Two adjacent rectangular parts with common-line merge OFF then ON | Compare exported segment graph, part IDs and cut-edge multiplicity; if shared line becomes one edge, require a *new* process-aware pierce/kerf/sequence plan. |
| S1 | SVGnest circle radius 10 with `transform="scale(2,1)"` | Geometric oracle: expected ellipse radii 20,10. Source transforms center and one scalar radius; capture parsed polygon and measure max deviation. |
| S2 | SVGnest path `M 10 0 A 10 10 0 0 1 0 10` under `scale(2,1)` | Correct transformed curve is an ellipse segment. Compare source `A` radii and transformed endpoint to independent geometric reference; do not accept screenshot alone. |
| S3 | Rectangles A `0,0 10,0 10,10 0,10`, B `5,5 15,5 15,15 5,15` | B first vertex inside A, but other vertices outside. Check `getParts` parent tree and independently detect edge crossings; do not treat a false child as a hole. |
| S4 | Self-crossing path that `SimplifyPolygon` separates into two nonzero-area loops | `cleanPolygon` keeps only largest component. Count input/retained components and log any lost geometry; exact shape-dependent result must be independently observed. |
| S5 | One deliberately oversized part and small bin | `PlacementWorker.placePaths` returns remaining `paths`; assert accepted count + unplaced count = requested count. No silent omission. |
| S6 | SVGnest export with bin width 100 SVG units | Inspect `viewBox` and `width="100px"` (assuming bounds width 100), then import into target CAM and measure physical witness; don't assume 100 mm. |
| L1 | Explicit LinuxCNC G21/G17/G90/G91.1 preamble, known 100-mm contour, no torch commands | Interpreter-only geometric check can test units/arc validity but cannot establish plasma process readiness. Keep the tool/torch inactive. |
| L2 | A separately designed QtPlasmaC post with M190/M66 material, feed, pierce, M3/M5 and any M62/M67 | Review post source, then filter output and canonical/Task interpretation separately. Existing [PLASMA-39](../research/4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md) and [PLASMA-32](../research/4400_LINUXCNC_PLASMA_32_QTPLASMAC_OVERCUT_M62_P3_TP_TIMING_AND_FILTER_SOURCE_AUDIT_2026-10-31.md) already describe relevant filter/torch limitations; no machine test authorized. |

## Current-fork 2026 Deepnest-next checks (also NOT RUN)

| Case | Frozen input / stimulus | Predicted discriminator / independent evidence |
|---|---|---|
| C1 | deepnest-next commit `e33e8889df40fed870dd4c2c68be27fd46ea0fdc`, disconnected DXF import | `convertAndImport` posts DXF to HTTPS conversion service; record failure/response and do not mark DXF geometry accepted. |
| C2 | Same fork, local PLT export of a known 100-mm witness | Capture SVG `width`/`viewBox`, computed inches-per-SVG-unit, HPGL path coordinates and independent dimension check; PLT is not LinuxCNC G-code. |
| C3 | Same geometry exported as SVG vs DXF vs PLT | SVG/PLT local; DXF export remote. Compare accepted contours, closure, physical units, and any tessellation before calling outputs equivalent. |
| C4 | Attempt to identify a current-fork LinuxCNC QtPlasmaC G-code post | UI G-code export item is commented out; require a separately version-pinned post with M190/M66/torch/kerf/pierce semantics. |
| C5 | Run reviewed upstream `tests/hpgl.cjs` only on a qualified isolated runner | Verify integer rounding, 1016 units/in, closed-path return, skipped short paths and 50-point PD chunking. Upstream expected outputs are inspected, **not executed** here. |
| C6 | Source geometry with two endpoints 0.01 mm apart exported to PLT | 0.01 mm = 0.4 HPGL unit; the difference can round away. Compare emitted PU/PD coordinates and independently bound ±0.0125 mm/axis quantization, before any polygonization. |

## Minimal SVG geometry inputs (text fixtures, NOT RUN)

A valid simple containment case:
```xml
<svg xmlns="http://www.w3.org/2000/svg" width="100mm" height="100mm" viewBox="0 0 100 100">
  <rect x="0" y="0" width="100" height="100" id="bin"/>
  <path id="outer" d="M 10 10 L 50 10 L 50 50 L 10 50 Z"/>
  <path id="hole" d="M 20 20 L 30 20 L 30 30 L 20 30 Z"/>
</svg>
```
Use **separate files** for S1 and S2 so the transformed circle/arc is not accidentally flattened or grouped by an unrelated case. For S3, use `<polygon points="..."/>` with A and B coordinates from the table, select a separate non-overlapping bin, and inspect the actual parent tree rather than trusting display order. SVGnest's original source is SVG-only; converting DXF first is a separate provenance and geometry step.

## Required handoff contract (not a compulsory build)

| Boundary | Required recorded fields | Fail closed when |
|---|---|---|
| CAD/DXF → canonical geometry | file hash, physical units, entity handles, original curves, holes, islands, layers/bend marks, INSERT/MINSERT transforms, unsupported entities | any requested feature is silently dropped or dimensional witness unknown |
| Canonical geometry → nest | polygon approximation tolerance in **physical units**, part IDs, winding/containment, complete intersection checks, spacing, rotations, unplaced count | nonuniform transform not represented or overlap/containment unresolved |
| Nest → CAM | placements, retained contour IDs, shared-edge graph, inside/outside cut order, kerf, lead-ins, pierce count, material/thickness | common-line merge has no process-aware interpretation |
| CAM → LinuxCNC | explicit G20/G21, G17, G90, G91.1/G90.1, G64, QtPlasmaC M190/M66/material/feed, M3/M5 and any M62/M67; NC hash | unvalidated generic mill/laser post or missing plasma state contract |
| LinuxCNC filter → interpreter → motion | filtered file hash, filter exit/errors, canonical geometry, Task status, simulated motion status independently | apparent GUI load or source inspection substituted for actual test |

**Press-brake caveat:** a bend line is not an outer cut contour. Keep tooling datums, bend order and gauge geometry outside the nesting-only representation; nothing in this guide authorizes OpenPressBrake machine motion.

## Fresh-AI transfer exercise (public, unscored)

A CAM engineer reports that a nested SVG looks correct, but the intended 100-mm cut becomes the wrong size and an inner contour is missing. Diagnose in this order: original DXF units and entity inventory → remote conversion result → SVG width/viewBox/transform → nest accepted/unplaced count and component simplification → post G20/G21 and generated contour inventory → QtPlasmaC filter output → interpreter. State what each observation can falsify. A second engineer proposes that enabling common-line merging will automatically improve plasma cut order: explain why shared geometry alone does not define pierce, kerf side or torch sequencing. **No hidden answer or blind score is attached.**

## Execution gate and disposition

ALL D1–D6, S1–S6, L1–L2 and C1–C6 = **NOT RUN** (20 cases). No browser/JS, DXF converter, LinuxCNC interpreter, simulation, Actions or physical operation was executed in this lesson. Before any software experiment, independently verify a **disconnected** `[self-hosted, openpressbrake]` runner is accessible and physically isolated; inspect its exact allowlist/script and use only a reviewed bounded job. **Never** use GitHub-hosted Actions or dispatch on an unverified panel PC. The remote Deepnest conversion step is *not* an offline runner test; replace it with a separately verified offline converter or mark D2–D4 BLOCKED. No independent evaluator or graduated level is changed. [Precise continuation checkpoint](../checkpoints/20261031T214200Z-4000-linuxcnc-nesting-cam-next.md).
