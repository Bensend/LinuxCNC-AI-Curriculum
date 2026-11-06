# PLASMA-252 — QtPlasmaC conversational CAM boundary and DXF integration contract
Date: 2026-11-06 UTC. Track: 3300, NON-GRADUATED. Scope: LinuxCNC v2.9.10; source inspection only.

## Question and result
What must an external DXF/nesting tool produce to integrate with a LinuxCNC QtPlasmaC plasma machine without accidentally bypassing the established torch/material/kerf conventions?

**SOURCE-CONFIRMED:** The QtVCP conversational circle UI is a parameter adapter, *not* a DXF importer. `lib/python/qtvcp/lib/qtplasmac/conv_circle.py::preview` passes material number/name, lead-in/out, origin, kerf width, inside/outside, overcut, hole diameter and speed to `plasmac.circle.preview`. The actual G-code emitter is `lib/python/plasmac/circle.py::preview`. This split is a reusable implementation boundary: GUI selection/validation → geometric generator → .ngc preview → LinuxCNC interpreter.

**SOURCE-CONFIRMED:** The generator writes `m3 $0 s1` to start the cut and `m5 $0` to stop, uses `g0` for positioning, `g1` for straight lead-in in some cases, and `g2`/`g3` with **incremental I/J center offsets relative to the current arc start** (e.g. lead-in `xlcenter - xlStart`). The full circle is emitted as a G2 or G3 whose endpoint equals its start and whose I/J specify the center displacement. It computes `kOffset = kerfWidth / 2` and applies geometry offsets in the generator; it does not merely assume a universal G41/G42 policy. For small holes and overcut, code follows distinct branches. These details matter more than choosing a generic “DXF to G-code” converter.

### Immutable upstream evidence
- LinuxCNC v2.9.10 `lib/python/qtvcp/lib/qtplasmac/conv_circle.py`, Git blob `0f4c9d356ec8037bf84f2deca53f4dcb30f09ce0`, `preview` near lines 27–49: UI delegates to `plasmac.circle` with explicit kerf/material/lead parameters. https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/qtvcp/lib/qtplasmac/conv_circle.py
- LinuxCNC v2.9.10 `lib/python/plasmac/circle.py`, Git blob `f22a91d119d120fa3123628b482df3c6e6750ed6`, `preview` near lines 40–90 (input parsing, half-kerf, lead geometry), 136–189 (material marker, M3/M5, lead-in/out and G2/G3 arcs). https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/plasmac/circle.py
- LinuxCNC v2.9.10 `lib/python/qtvcp/lib/qtplasmac/conv_block.py`, blob `4a2447d6d79660613c3bb4e032d81a0afb921cb9`, near lines 92–96: block transform checks G20/G21 in source G-code. **Do not infer unit safety from this narrow code path.** https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/python/qtvcp/lib/qtplasmac/conv_block.py

## External CAD/CAM integration: what is established and what is not
An external tool can reasonably target a *G-code interchange contract*, rather than import arbitrary DXF directly into the QtPlasmaC conversational shape widgets. This is an **architectural inference**, not an implemented plugin. The `ezdxf` project (https://github.com/mozman/ezdxf) provides a source-accessible DXF parser ecosystem, and `SVGnest` (https://github.com/Jack000/SVGnest) is a distinct open-source vector nesting project. Their repository presence was checked on 2026-11-06; **no version-pinned code path was inspected establishing a complete DXF→nest→QtPlasmaC postprocessor**, so no claim of turnkey interoperability or license compatibility is made.

Keep three stages separately inspectable:
1. **DXF normalization:** record `$INSUNITS`, units fallback, modelspace entity types and transforms. Explicitly resolve LINE, ARC, CIRCLE, LWPOLYLINE bulges, block INSERT transforms, closed/open contours, mirrored geometry and tolerances. Unsupported SPLINE/ELLIPSE should be rejected or tessellated with a declared tolerance; never silently drop them.
2. **Nesting and geometry:** preserve contour winding and hole/outer containment; offset tool-center paths by half kerf **exactly once**. Establish lead placement, pierce clearance, cut ordering (holes before outer profiles), sheet margins, bridge/tab semantics and collision constraints. Nesting polygons are not automatically valid cut paths.
3. **QtPlasmaC postprocessing:** explicit G20/G21, G17, G90, G91.1 (or explicitly verified equivalent arc-center convention), G40, feed/material semantics, G0 to pierce start, `M3 $0 S1` / `M5 $0` around each contour, end code and no unintended modal state inheritance. Verify QtPlasmaC material selection and hole-speed conventions against the specific machine's settings before accepting a postprocessor.

## Minimal inspectable acceptance fixture (design only; NOT executed)
**Input geometry:** one 20×10 mm outer rectangle, one Ø4 mm inner circle centered at (10,5), no duplicate contours, `$INSUNITS=4` (mm), and a second deliberately unitless variant. Do not use these dimensions as a real cutting recipe.

**Expected geometric properties:** a closed outer contour and one closed inner contour; first cut is inner; both within the sheet after kerf offset; arcs have a valid center and orientation; no zero-length travel mistakenly triggers a cut. The unitless variant must stop for unit confirmation. A mirrored ARC/LWPOLYLINE variant must preserve actual direction after transform.

**Expected postprocessor properties:** one torch-on and one torch-off per contour, no torch-on during rapids, explicitly established units and arc mode, no double kerf, and all generated path coordinates within machine-specific XY travel and sheet bounds. Test with LinuxCNC's interpreter/QtPlasmaC simulator and compare interpreter preview against a reference geometric path *before* any physical machine run. Use only justified self-hosted [self-hosted, openpressbrake] compute; no hosted Actions.

### Diagnostic traps and falsifiable predictions
- A G2/G3 arc whose I/J are absolute center coordinates instead of center-minus-start can produce a radically different radius or interpreter rejection. Test by comparing start/end radius to the I/J center distance.
- Applying an external kerf offset and then also enabling generator compensation changes feature size by approximately another half-kerf per side. Compare tool-center and finished-edge contours independently.
- Swapping G20/G21 without scaling numeric coordinates changes geometry by 25.4×. Freeze an explicit unit header and assert expected bounding box.
- Treating DXF bulge as a straight segment destroys arc geometry. Round-trip the Ø4 hole and a nonzero-bulge polyline independently.
- A generic M3 without QtPlasmaC's documented/inspected channel convention is **not** proven equivalent to `M3 $0 S1`; simulator must establish behavior.

## Evidence ledger / limits
SOURCE-CONFIRMED: v2.9.10 conversational UI delegation and circle G-code emitter, half-kerf and I/J-relative formulas.
REPOSITORY-CONFIRMED: ezdxf and SVGnest exist as public open-source projects; no pinned implementation details or working bridge verified.
INFERENCE: modular DXF→nest→postprocessor architecture and proposed validation.
UNKNOWN: actual material-change and feed semantics across all QtPlasmaC modes; full DXF entity coverage; nesting robustness; postprocessor runtime; installed machine behavior.
TEST-CONFIRMED: none. No build, simulator, machine, lab compute or Actions executed.

## Next evidence-gain checkpoint
Inspect a real open-source DXF parser's `LWPOLYLINE` bulge and INSERT transform handling at an immutable revision, plus a specific nesting algorithm's input/output contract. Then trace QtPlasmaC material selection and G-code filter behavior from pinned LinuxCNC source; construct a *purely offline* reference contour/arc fixture and validation harness if justified. Rotate to 4000 HostMot2 if the DXF chain lacks sufficient inspectable evidence. Preserve existing graduation, blind-evaluation and independent personnel-safety gates.
