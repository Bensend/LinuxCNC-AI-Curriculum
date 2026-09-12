# Press-brake 3600 — normalized bend feature / bend list contract

Date: 2026-09-12
Status: research contract; **not an implementation schema freeze**

## Purpose

Define the minimum normalized representation a future DXF/STEP-assisted press-brake UI should preserve between CAD import and backgauge target generation. The goal is to avoid coupling runtime machine commands directly to CAD-vendor-specific line/layer conventions.

## Concrete open-source evidence inspected

The public BenDFM example `example_files/0_sequence.json` contains one base-sheet record followed by seven ordered bend-operation records. Individual records carry fields such as:

- `face_name` and `edge_name` — stable-ish geometry references inside the generated model;
- `bend_angle` and `bend_radius`;
- `bend_height`;
- `orientation` (`up`/`down`);
- flange shape metadata;
- relationship/proximity information such as `distance_last_bend`;
- `punch_rotation`;
- `flip`;
- separate collision flags for self, punch and die.

Its companion `0_labels.json` summarizes the finished example independently: seven bends, one sheet flip, aggregate punch rotation/distance, geometry ranges and collision/manufacturability labels.

The important lesson is structural, not numeric: **operation order, per-bend attributes and part-level manufacturability summaries are distinct data products.**

## Minimum internal entities

### `ImportedPart`

Owns source provenance and imported flat/folded geometry.

Minimum conceptual fields:

- source file/revision identity;
- source coordinate system and units;
- material/thickness when known;
- cut/outline geometry;
- source metadata sufficient to trace later bend features back to the importer.

### `BendFeature`

Represents one physical bend candidate independently of recipe order.

Minimum conceptual fields:

- stable internal `bend_id` assigned by the importer/normalizer;
- source reference(s): DXF entity/layer or 3D face/edge provenance;
- bend line/axis geometry in normalized part coordinates;
- angle magnitude when known;
- direction/orientation when known, with `UNKNOWN` allowed rather than guessed;
- radius when known;
- confidence/provenance of each inferred attribute.

A bend feature should not acquire a backgauge target merely because it has a geometric line.

### `BendStep`

References a `bend_id` and adds recipe/order semantics.

Conceptual fields may include:

- `step_id` / ordinal;
- `bend_id`;
- operator-confirmed part orientation/flip state;
- tooling reference when later introduced;
- operator notes;
- whether the step is manually confirmed or algorithmically proposed;
- validation state.

Recipe order is explicitly separate from geometric bend identity so the operator can reorder bends without mutating the imported feature.

### `GaugePlan`

Describes how a bend step is to be located against the backgauge.

This is intentionally downstream of bend geometry. Conceptual information includes:

- chosen gauging edge/surface/datum identity;
- which gauge mechanisms participate;
- target calculation provenance;
- retraction/clearance requirements when later supported;
- human confirmation state.

The first 3600 implementation should allow the human to select/confirm the gauging feature rather than pretending a bend line uniquely determines the finger contact point.

### `TargetSet`

The runtime ordinary-control product derived from an accepted GaugePlan.

Conceptual fields:

- `target_set_generation`;
- source `step_id` and `bend_id`;
- per-mechanism target values;
- participating mechanism mask/list;
- authorization/reconciliation state;
- per-mechanism completion generations plus aggregate readiness.

This is where the PB-BG-003 episode-identity rule connects the CAD/recipe side to runtime control.

## Provenance rule

Every transformation should be reversible enough for diagnostics:

`source geometry -> BendFeature -> BendStep -> GaugePlan -> TargetSet`

The HMI should be able to explain, at least at a developer/commissioning level, why a displayed target exists: which imported bend, which recipe step and which selected gauging datum produced it.

Do not create machine target values directly from anonymous DXF line index/order and then discard provenance.

## Unknowns are first-class

The importer must be allowed to produce:

- bend direction `UNKNOWN`;
- radius `UNKNOWN`;
- sequence `UNASSIGNED`;
- gauge datum `UNASSIGNED`.

Unknown must not silently become zero, default-up, first-line, or another plausible-looking value. The staged workflow should surface these for human confirmation.

## BenDFM-inspired but not copied semantics

Fields such as `flip`, collision categories and punch rotation demonstrate useful concepts, but they are not yet mandatory parts of the first LinuxCNC contract. They should remain promoted capabilities until tooling/machine geometry and collision evidence are actually modeled.

Likewise, BenDFM's generated `face_name`/`edge_name` references are useful within its own model lineage; a generic DXF importer will need a different stable identity strategy.

## First-stage acceptance contract

A manually assisted import is sufficient at 3600 first-stage depth if it can:

1. preserve cut geometry separately from candidate bend lines;
2. assign stable internal bend IDs;
3. display candidate bend direction/angle metadata without inventing unknowns;
4. let a human confirm/reject bend features;
5. let a human order confirmed bends into a BendStep list;
6. retain provenance from each step back to imported geometry;
7. pass an accepted step to a separately defined gauge-planning surface rather than directly commanding hardware.

Automatic collision-free sequencing, automatic tooling, full 3D part manipulation and automatic finger-contact selection are **not** prerequisites for this first-stage contract.

## Adversarial cases to preserve for later validation

- Two collinear bend lines with different source metadata must not collapse accidentally.
- Two bends with the same angle/radius remain distinct bend IDs.
- Reordering steps must not renumber/lose bend identity.
- A source DXF containing cut and bend geometry on indistinguishable layers must be classified ambiguous rather than silently accepted.
- Reimport of a modified source must invalidate or explicitly remap stale BendStep/GaugePlan references; positional coincidence is not identity.
- A repeated recipe step may generate the same numeric gauge target while still requiring a new runtime target-set generation.

## Claims boundary

This contract is a data/ownership design derived from open-source examples and prior backgauge state work. It does not establish geometric inference accuracy, tooling compatibility, collision freedom, bend allowance, springback, physical gauge placement or safety.

## Precise next checkpoint

When 3600 work resumes after higher-priority gates, inspect one actual FreeCAD SheetMetal unfold-to-DXF path at source/example level to determine what bend-line identity/direction survives DXF export. Then design a minimal importer test fixture around **metadata retention and ambiguity**, not automatic sequencing.

The full 2000-series critical path remains blocked only by the independent F02 fresh-AI handoff, which this learner must not self-evaluate.
