# FreeCAD SheetMetal unfold/DXF bend-metadata audit

Date: 2026-09-12
Purpose: determine what bend identity/metadata exists before DXF export and what an importer can safely assume from the resulting separated bend sketch.
Inspected upstream: `shaise/FreeCAD_SheetMetal` master, including `SheetMetalUnfolder.py`, `SheetMetalNewUnfolder.py`, `SheetMetalUnfoldCmd.py`, public documentation and issue history.

## Documentation-level behavior

FreeCAD SheetMetal's Unfold workflow generates an unfolded object and a projection sketch containing bend lines. Current documentation exposes a **Separate projection layers** option and separate bend/internal line colors. This makes bend geometry visually and structurally separable from outline/internal geometry before export.

That is useful for a human-assisted importer, but layer/color separation alone is not bend identity, bend direction or recipe order.

## Old unfolder source trace

`SheetMetalUnfolder.getUnfoldSketches(...)` receives the unfolded shape and `foldLines`. In split-sketch mode it:

1. projects the perimeter/face edges;
2. creates an outline sketch named approximately `<label>_Sketch_Outline`;
3. creates an internal-lines sketch when needed;
4. compounds/project all `foldLines` into `foldEdges`;
5. creates one bend sketch named `<label>_Sketch_bends` using the configured bend color.

The corresponding `generateSketch(...)` function creates ordinary sketch geometry from the supplied edges and assigns the selected visual line/point color.

### Consequence

At that old projection-sketch boundary, **all bend edges are aggregated into one bend sketch**. The inspected function does not attach per-line bend angle, radius, up/down direction, feature UUID, sequence number or gauge datum metadata to each projected sketch entity.

Therefore an exported DXF derived from that sketch cannot be assumed to contain those semantics merely because its bend lines have a distinct layer/color.

Evidence classification: **SOURCE-CONFIRMED for inspected old-unfolder path**.

## New unfolder source trace

The newer unfolder contains a `BendInfo` object with at least:

- a bend-line edge;
- bend angle;
- bend radius.

Its graph/unfold path carries transformed per-bend `BendInfo` records internally. The new unfolder can later create a separate `<label>_Sketch_Bends` object from the transformed bend-line edges.

This is an important distinction:

**richer per-bend metadata exists inside the unfolder before projection/export, but the ordinary bend sketch remains primarily geometry.**

The bend-cut feature in `SheetMetalUnfoldCmd.py` explicitly notes that it depends on per-bend `BendInfo` supplied by the new unfolder, corroborating that this information is richer than the legacy fold-line list.

Evidence classification: **SOURCE-CONFIRMED for current upstream internal data path**.

## Importer implication

There are two materially different integration opportunities:

### A. DXF-only import

Treat bend lines as candidate geometry with source layer/color/name provenance. Do not assume:

- stable bend ID;
- bend angle/radius;
- up/down direction;
- sequence;
- tooling;
- gauge datum.

These fields remain `UNKNOWN` until explicitly supplied or confirmed.

### B. CAD-side metadata export

A future richer integration could export the new unfolder's per-bend metadata alongside the DXF (for example as a sidecar JSON produced by a FreeCAD macro/add-on). That could preserve bend line geometry plus angle/radius and an explicit generated bend ID before DXF strips those relationships.

This is an architectural opportunity, not an implemented curriculum feature yet.

## Identity stability warning

FreeCAD SheetMetal documentation also warns about FreeCAD's topological naming problem: edits earlier in model history can renumber faces and disturb downstream bend features. Therefore raw source face/edge numbers should not automatically be treated as durable cross-revision manufacturing IDs.

A sidecar exporter should generate its own import-session/source-revision-scoped bend identity and retain geometry/provenance needed for reconciliation after source changes.

## Failure evidence from public issue history

Public issue reports show that unfold sketches/DXF are not perfect semantic carriers:

- issue #284 reports duplicate bend lines in some unfold sketches, which can cause multiple CAM operations; manually deleting duplicates may produce a usable DXF, while exporting only an unfolded face loses bend lines;
- issue #450 reports cases where generated sketch detail or exported/re-imported DXF positioning was wrong in particular versions/examples.

These are community issue reports, not universal defects, but they reinforce the need for importer validation and source-version provenance instead of blind acceptance.

## Course-level normalized rule

For the first DXF-assisted 3600 implementation:

1. use layer/sketch separation to **discover candidate bend lines**;
2. geometrically deduplicate within a declared tolerance only with traceable diagnostics;
3. assign new stable internal `bend_id`s during normalization;
4. keep angle/radius/direction `UNKNOWN` unless trustworthy metadata is present;
5. require human confirmation of bend candidates/order;
6. keep imported source revision/hash and layer/entity provenance;
7. never infer recipe order from entity order in the DXF.

If FreeCAD-side automation is later justified, prefer an explicit sidecar metadata export rather than trying to recover lost angle/radius/direction solely from the 2D DXF.

## Adversarial importer cases now justified

A future importer fixture should include:

- duplicate coincident bend lines;
- outline and bend line on the same/ambiguous layer;
- two distinct collinear bends;
- source metadata absent;
- source re-export where entity ordering changes;
- bend lines present but angle/direction unavailable.

The correct behavior is visible ambiguity/reconciliation, not plausible-looking silent defaults.

## Precise next checkpoint

The backgauge operator/reference/completion ownership branch is sufficiently documented for now. When 3600 continues, prototype the **metadata-only importer contract** using synthetic DXF-like entity records plus optional sidecar metadata; test identity/deduplication/unknown handling only. Do not implement automatic bend sequencing or machine target calculation yet.

The higher critical-path gate remains the information-separated F02 fresh-AI evaluation required to fully close the 2000 series.
