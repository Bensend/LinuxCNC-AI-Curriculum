# PLASMA-257 — sheetnest source audit: DXF admission, placement and QtPlasmaC boundary (2026-11-06)

Status: **SOURCE-CONFIRMED, NON-GRADUATED; NO EXECUTION**. This is research, not an installed or verified machine postprocessor.

## Why this branch
PLASMA-256 requested a real nesting implementation. This audit uses the upstream `YJack0000/sheetnest` Rust engine, not a hypothetical SVGnest adapter. It also tests the PLASMA-253 DXF admission contract against actual code and finds important mismatches.

## Immutable source evidence (Git blob SHA, repository YJack0000/sheetnest)
- `README.md` — `ed480dfcdc7125f448f2d40196d9a1e30dea1970`
- `docs/design.md` — `0942720b89032b73448be483c36cc954c13a3c53`
- `crates/sheetnest/src/dxf/read.rs` — `858e28311739c1b2b7847366a202f22f2af7d257`
- `crates/sheetnest/src/place.rs` — `502d8c0da651626023631c0101c712beac6ba4bc`
- `crates/sheetnest/src/ga.rs` — `362d71557bfd4904fc5f4184b525a1f0b0b981a9`
- `LICENSE-MIT` — `3cfcdf0125b41204c535a4dd3561131dd1fc393d`

Source URLs: https://github.com/YJack0000/sheetnest/blob/main/crates/sheetnest/src/dxf/read.rs ; https://github.com/YJack0000/sheetnest/blob/main/crates/sheetnest/src/place.rs ; https://github.com/YJack0000/sheetnest/blob/main/crates/sheetnest/src/ga.rs . Blob hashes above, rather than mutable main URLs, are the frozen evidence.

## Actual implementation
1. `dxf::parse_dxf` uses the Rust `dxf` crate; it recognizes LINE, ARC, CIRCLE, LWPOLYLINE bulges, POLYLINE, SPLINE and ELLIPSE. Analytic arcs survive parsing; spline/ellipse paths are linearized at configurable chord tolerance. Loose segments are chained at two endpoint tolerances; unclosed chains are **skipped with warnings**, not fatal if other closed loops survive.
2. **Critical admission mismatch:** `INSERT`/block references are **skipped** with a warning; they are not expanded. A DXF composed of a mixture of direct outlines and nested INSERTs can therefore produce a plausible but incomplete nest. PLASMA-253's mirrored/nested INSERT cases must be rejected or pre-expanded with independently verified transforms *before* this parser.
3. **Critical units mismatch:** `unit_scale(drawing.header.default_drawing_units,...)` scales inch input to mm; other units are assumed mm according to source documentation. PLASMA-253's requirement to reject unspecified `$INSUNITS=0` is **not enforced by default**. Require an external unit gate, verify all recognized unit codes and any warning, and reject ambiguous/mismatched units before nesting.
4. Containment depth classifies outer contours and holes; `Part::from_contours` normalizes outer CCW, holes CW, local bbox origin. Multiple top-level loops can yield multiple parts. Inspect nesting/cut order separately: classification does not by itself prove inner cuts precede outer cuts.
5. `place::prep_parts` simplifies rings for NFP calculations, adaptively increasing epsilon to cap vertex count at ~200, then inflates the moving polygon by `spacing`. `place::decode` tests rotations and existing sheets, calculates forbidden NFP regions, chooses minimum (resulting max X, X, Y), and opens a sheet if needed. This is **placement geometry**, not toolpath geometry.
6. `ga.rs` evolves order/rotation genes; `place::decode` supplies deterministic fitness. The objective is stock **length** (sheet count plus last sheet's max X), not directly area utilization. A seeded run stopped by stale-generation count is reproducible; wall-clock stop can change generation count. An overlap check is present after nesting, but that alone does not establish exact production kerf/clearance.
7. The code explicitly acknowledges simplification-induced clearance erosion: at default 2 mm spacing and 0.25 mm tolerance the described guaranteed clearance is about **1.5 mm**, not 2.0 mm. This matters when kerf, thermal allowance, and small web thickness approach the tolerance. Geometry uses Clipper2 on a 0.01 mm grid per design notes.
8. The upstream project offers Rust/Python/WASM/CLI APIs, DXF/SVG output and optional micro-joints. It is dual licensed MIT or Apache-2.0 at the project level; preserve attribution and audit transitive dependencies separately. Its DXF output is **not** LinuxCNC G-code. The project explicitly does not nest parts inside other parts' holes yet.

## LinuxCNC/QtPlasmaC integration contract
`DXF -> strict unit/INSERT/entity/closed-contour gate -> canonical contour set (analytic arcs + cut semantics) -> nesting placement transforms -> independent post-nest geometry audit -> QtPlasmaC-specific cut-order, kerf, lead, material handshake, feed and torch G-code`.

Keep the source contour identity, holes, per-instance rotation/translation, exact analytic geometry and selected units. Do not feed `SHEET` outlines to the torch. Apply kerf **exactly once**; nesting spacing must account for toolpath envelopes, not merely part outlines. Never infer a complete cut program from a successful DXF nest.

From PLASMA-254–256: external post must account for `M190 Pn`, `M66 P3 L3 Q1`, `#<_hal[plasmac.cut-feed-rate]>`, `M3 $0 S1`, `M5 $0` and appropriate small-hole behavior. M66 high-level wait may accept stale-high input, so process verification cannot rely on M190 exit code alone.

## Reproducible source audit
```sh
git clone https://github.com/YJack0000/sheetnest.git
cd sheetnest
git hash-object README.md docs/design.md crates/sheetnest/src/dxf/read.rs crates/sheetnest/src/place.rs crates/sheetnest/src/ga.rs LICENSE-MIT
rg -n 'INSERT|unit_scale|open chains|default_drawing_units' crates/sheetnest/src/dxf/read.rs
rg -n 'MAX_NFP_POINTS|simplify_ring|inflate_ring|candidate_positions' crates/sheetnest/src/place.rs
rg -n 'fitness|seed|verify_no_overlaps' crates/sheetnest/src/ga.rs
```
For reproducibility, checkout a commit whose blobs match the recorded hashes before executing tests. These commands are **not claimed executed**.

## Minimal falsifiable acceptance matrix (future isolated offline test)
- DXF with `$INSUNITS=0` and otherwise valid rectangle: **external admission must reject**; stock engine may assume mm.
- DXF with nested/mirrored INSERT and valid direct contour: **external admission must reject or correctly expand**; stock parser warns and skips INSERT.
- Inch square: transformed side length exactly 25.4 mm per inch, checked against independent geometric oracle.
- Negative bulge and mirrored arc: after transform, compare signed sweep, actual start/end and G2/G3 I/J against original travel.
- Two contours with gap exactly 2.0 mm and `curve_tolerance=0.25`: independently measure **exact output** clearance, not just NFP/approximate clearance.
- Hole and outer contours: validate containment, no unintended nesting inside holes, and cut inside before outside.
- Repeated fixed-seed/stale-generation runs: compare placements; separately classify wall-clock-limited nondeterminism.
- Material change: validate explicit M190/M66/feed/torch sequence and stale-high failure diagnostics; **no physical torch execution**.

## Evidence boundaries and next checkpoint
No build, test, runtime, machine, GitHub Actions or compute performed. Upstream design-document performance numbers are author reports, not reproduced benchmarks. No conclusion about all possible DXF units, polygon self-intersection behavior, Clipper2 dependency licensing, or exact output geometry is established beyond inspected code. Next: inspect `unit_scale`, `emit_polyline`, `dxf/write.rs` and overlap verifier; decide whether a minimal offline fixture is justified on permitted isolated compute, or rotate to 4000 HostMot2 if diminishing returns. Preserve independent personnel-safety authority and graduated/evaluation gates.
