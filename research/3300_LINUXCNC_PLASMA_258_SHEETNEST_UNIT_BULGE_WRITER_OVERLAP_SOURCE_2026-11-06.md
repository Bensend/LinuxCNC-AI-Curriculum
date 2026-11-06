# PLASMA-258 — sheetnest exact units, bulge, DXF writer and overlap semantics (2026-11-06)

Status: **SOURCE-CONFIRMED, NON-GRADUATED, NO EXECUTION**. Follow-on to PLASMA-257; corrects one overbroad unit claim and narrows what final validation proves.

## Frozen upstream evidence
Repository: YJack0000/sheetnest. Git blob SHAs (not mutable branch URLs):
- `crates/sheetnest/src/dxf/read.rs`: `858e28311739c1b2b7847366a202f22f2af7d257`
- `crates/sheetnest/src/dxf/write.rs`: `ee66023cf5f06a75519802dd1ffa90106451bf3a`
- `crates/sheetnest/src/place.rs`: `502d8c0da651626023631c0101c712beac6ba4bc`

Inspect source at [reader](https://github.com/YJack0000/sheetnest/blob/main/crates/sheetnest/src/dxf/read.rs), [writer](https://github.com/YJack0000/sheetnest/blob/main/crates/sheetnest/src/dxf/write.rs), and [placement](https://github.com/YJack0000/sheetnest/blob/main/crates/sheetnest/src/place.rs); validate the hashes above before reusing a moving branch.

## Corrected unit matrix (reader lines 669–706)
PLASMA-257 described other unit declarations as assumed mm. That was **too broad**. `unit_scale` explicitly converts inches (25.4), feet (304.8), miles (1609344), centimeters (10), meters (1000), kilometers (1000000), microinches (2.54e-5), mils (0.0254), yards (914.4), angstroms (1e-7), nanometers (1e-6), microns (0.001), decimeters (100), decameters (10000), hectometers (100000), and US survey feet/inch/yard/mile. Millimeters and **Unitless** both return 1.0 **without warning**. Unrecognized enum values return 1.0 **with warning**. Thus a strict admission gate must reject Unitless and unsupported values, but must NOT reject valid non-mm units merely because conversion is needed. Verify scaled bounding boxes and chord tolerance (`local_tol = curve_tol / scale`) independently.

## Bulge and traversal (reader lines 397–455)
`emit_polyline` associates vertex i's bulge with edge i→i+1, including last→first on closed polylines. `bulge_arc` computes signed `theta = 4 atan(bulge)`, signed `sweep_deg`, and an arc centered using the chord left normal. Positive bulge is CCW, negative CW; unlike ezdxf's CCW canonical helper, this `Seg::Arc` retains the signed traversal. Degenerate/nonfinite bulges become lines. Existing upstream tests include positive semicircle, negative semicircle and 90-degree geometry; these tests were **inspected, not run**. External mirrored-block normalization must flip sweep handedness; sheetnest still does not expand INSERT.

## Writer and identity boundary (writer lines 32–145)
Writer declares DXF R2000, `$INSUNITS=Millimeters`, distinct `SHEET` and `CUT` layers. It draws sheet outlines, caches per-part local cut chains, applies each placement's rotation/translation and sheet X offset, and emits transformed segments to CUT. It **silently skips placements with an invalid part_id** (`parts.get(...)` None), a separate completeness risk. `seg_entity` serializes negative-sweep arcs as DXF CCW arcs with swapped start/end angles: this preserves the **geometric locus**, but the resulting DXF ARC does not preserve original clockwise cutting traversal as an instruction. A QtPlasmaC postprocessor must use source contour identity and signed sweep, not infer cut direction from emitted DXF ARC endpoints. Writer output is not a cutting program; CUT layer is not a complete toolpath order, lead, kerf, material or torch contract. Tabs are computed in local part coordinates and reused for each instance; they require explicit downstream treatment.

## Overlap verifier boundary (place.rs lines 292–320)
`verify_no_overlaps` transforms each placed instance's **raw outer ring**, compares same-sheet pairs, and reports pairs whose polygon intersection area exceeds `eps_area`. This catches significant **area overlap of outer silhouettes**, but does **not** prove requested positive clearance, kerf envelopes, tab accessibility, cut-order correctness, minimum web width, or that every requested instance was placed. Tangencies, near misses and intersections with area <= tolerance can pass. It is not a complete nesting acceptance oracle.

## Minimal offline acceptance exercise (not executed)
1. Unitless 1×1 rectangle: strict admission rejects; stock reader would scale as 1 mm without warning. Inches: accepted only with 25.4 mm measured side; meters: 1000 mm.
2. Unsupported unit enum: stock reader warns and uses 1.0; strict admission rejects. Validate warning collection and completeness.
3. Negative-bulge semicircle from (0,0) to (2,0): signed sweep -180°, midpoint (1,+1), center (1,0). Positive bulge midpoint (1,-1). Verify traversal before and after any mirrored transform.
4. Writer emits two layers; exclude SHEET from cut generation. Compare source clockwise arc to output DXF CCW encoding; preserve original directed segment in postprocessor.
5. Invalid placement part_id: writer silently omits it; assert requested quantity = accepted quantity = placed quantity = exported quantity before accepting.
6. Two rectangles separated by 0.01 mm: raw overlap verifier can pass while required 2 mm clearance fails; independent distance/kerf-envelope check must reject.
7. Overlapping contours with intersection area > eps_area: verifier must report; area below threshold must not be advertised as fully collision-free.
8. For every placed instance check sheet bounds/margins, holes, transforms, part identity, signed arc direction, exact minimum distance, cut order, and QtPlasmaC material handshake separately.

Reproduction (on a pinned checkout): `git hash-object crates/sheetnest/src/dxf/{read,write}.rs crates/sheetnest/src/place.rs`; inspect `unit_scale`, `emit_polyline`, `bulge_arc`, `seg_entity`, `verify_no_overlaps`. No test, build, simulation, GitHub Actions, physical machine or lab compute was performed in this session. A future executable fixture may use only an isolated approved self-hosted runner, never hosted Actions.

## Decision and next
Source question substantially closed. A standalone test is justified only when it can check independent geometry or export completeness, not merely rerun upstream tests. Rotate next to **4000 HostMot2/Mesa**: trace actual hm2_eth or hm2_pci read/write, watchdog, encoder/stepgen configuration and HAL scheduling with pinned LinuxCNC source and real machine config. Preserve existing graduates, independent personnel safety, blind evaluation and physical-machine gates.
