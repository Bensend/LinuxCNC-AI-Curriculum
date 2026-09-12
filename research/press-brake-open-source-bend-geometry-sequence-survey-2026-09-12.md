# Press-brake 3600 — open-source bend geometry and sequence survey

Date: 2026-09-12
Purpose: identify reusable public data/geometry ideas for the future staged DXF-assisted workflow without jumping prematurely into automatic bend sequencing.

## Curriculum boundary

The 3600 track currently targets a staged path:

1. manual jog/typed positioning;
2. reliable homing and `at_position`/episode semantics;
3. bend-program target ownership;
4. imported geometry with human-confirmed sequencing;
5. only later, if justified, automatic sequencing/collision assistance.

This survey asks what open-source work can inform stages 3–5. It does **not** select a production algorithm or claim that DXF alone contains all information necessary for safe/valid bending.

## 1. FreeCAD SheetMetal — unfolded geometry plus bend lines

The FreeCAD SheetMetal workbench documentation shows an unfolded solid and an unfold sketch containing bend lines suitable for DXF export. The documentation also warns that fold lines must be handled appropriately when DXF is used for cutting, because an undifferentiated downstream process may interpret them as cut paths.

Reusable lesson:

- preserve bend geometry as a separate semantic entity from cut-profile geometry;
- do not reduce imported DXF to one anonymous set of lines;
- layer/color/entity metadata may be useful for classifying bend lines, but classification must be explicit and validated rather than assumed from appearance.

This supports the curriculum's existing interest in commercial workflows where bend lines are represented using distinct line types/layers.

Evidence classification: **OPEN-SOURCE/DOC-CONFIRMED workflow concept**.

## 2. BenDFM — explicit ordered bend sequence as data

The public `UGent-CVAMO/bendfm` project is particularly useful because each generated sheet-metal example includes:

- a folded STEP model;
- an unfolded STEP model;
- an `identifier_sequence.json` with an ordered bend sequence;
- labels for geometric/configurational manufacturability, including tooling-collision and unfolding-overlap tasks.

The dataset spans multi-bend parts rather than treating a flat pattern as sufficient representation of the manufacturing process.

Reusable lesson:

**Store bend order as structured data separate from geometry.** A future OpenPressBrake/LinuxCNC UI should be able to represent a bend list explicitly—bend identity, order, direction/angle and later associated gauge/tooling information—rather than encoding recipe order implicitly in DXF entity order.

BenDFM is a research dataset, not a press-brake controller and not evidence that its generated sequence is appropriate for a particular physical machine. Its value here is the data-model separation: folded geometry, unfolded geometry, sequence, and manufacturability labels are distinct artifacts.

Evidence classification: **OPEN-SOURCE RESEARCH / DATA-MODEL EVIDENCE**.

## 3. SolidWorks/other flat-pattern exporters — bend lines can be retained intentionally

Public SolidWorks DXF-export tooling such as `Johanss-on/Assem2DXF` explicitly supports exporting flat patterns with bend lines. This is useful corroboration that bend-line retention in manufacturing DXF is a practical CAD-export concept rather than something unique to one package.

Reusable lesson:

- importer must understand the originating export convention;
- preserving bend lines is useful only if their role/direction/metadata can be distinguished from cut geometry;
- a later machine-facing pipeline should normalize source-specific conventions into an internal bend representation instead of spreading CAD-vendor-specific assumptions through the controller.

Evidence classification: **OPEN-SOURCE TOOLING EXAMPLE**.

## 4. Commercial workflow cross-check — sequence and finger positioning are coupled but distinct

Commercial press-brake programming descriptions (for example Metalix MBend) consistently separate several tasks:

- tooling selection/setup;
- bend sequencing;
- collision checking;
- finger/backgauge positioning and retraction;
- final machine/NC generation.

This is not source code and is not an implementation oracle, but it is a useful workflow taxonomy. In particular, backgauge position is a consequence of the selected bend/gauging strategy rather than simply the coordinates of a bend line.

Reusable lesson:

Do not make the first DXF-assisted feature attempt to solve everything. A sensible early pipeline is:

`import geometry -> identify/confirm bend lines -> create/confirm bend list -> operator selects/accepts sequence -> operator confirms gauging surface/side -> software derives target proposal -> human confirms -> target episode issued`

Collision-free automatic sequencing and automatic finger placement can remain later promoted capabilities.

Evidence classification: **COMMERCIAL WORKFLOW REFERENCE**, not LinuxCNC behavior.

## 5. Emerging open-source sheet-metal kernels

Current open-source sheet-metal work is beginning to expose bend sequence as a first-class software concept rather than only flat geometry. The `vcad-kernel-sheet` documentation, for example, includes a `sequence` module explicitly described as bend order for press-brake forming, alongside unfold, DXF and manufacturability modules.

This is promising research evidence, but it is too new to treat as a mature press-brake planning oracle without source-level inspection and examples. Preserve it as a future lead rather than immediately depending on it.

Evidence classification: **CURRENT OPEN-SOURCE LEAD / NEEDS DEEPER SOURCE REVIEW**.

## Internal representation implication

A future curriculum playbook should avoid making DXF itself the canonical bend program. Prefer an internal normalized model along these lines:

- `PartGeometry` — cut profile / unfolded faces;
- `BendFeature[]` — stable bend IDs plus geometric line/axis, angle/direction and source provenance;
- `BendSequence[]` — ordered references to bend IDs;
- `GaugePlan` per bend — selected datum/contact feature and target mechanisms;
- `TargetSet` — concrete X/R/Z-style numeric targets for the current bend step;
- `target_set_generation` — runtime identity used by the episode-safe completion contract.

The exact schema is not frozen here. The important architectural rule is stable identities and separation of **geometry**, **recipe order**, **gauging choice**, and **runtime machine target generation**.

## What DXF does not prove

A bend line in a flat DXF does not by itself establish:

- which side/surface should touch a backgauge finger;
- which bend should occur first;
- part orientation in the operator's hands;
- tooling choice or availability;
- collision clearance;
- springback/overbend requirement;
- safe machine envelope;
- target values for every backgauge mechanism.

These missing semantics are why the staged/human-confirmed approach is appropriate for the 3600 first draft.

## Next research checkpoint

Before implementing DXF import, inspect two concrete machine-readable examples:

1. one FreeCAD SheetMetal unfolded/bend-line output path to learn what bend identity/direction metadata survives export;
2. one BenDFM `*_sequence.json` example to understand how sequence references geometry/features.

Then define a **course-level normalized bend-feature/bend-list contract**. Do not yet implement collision-free automatic sequencing, tooling optimization or machine-specific backgauge geometry.

The external F02 fresh-AI handoff remains the higher critical-path gate for closing the 2000 series and must remain information-separated.
