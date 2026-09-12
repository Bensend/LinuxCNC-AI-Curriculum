# Press-brake 3600 — bounded open-source backgauge target-calculation search

Date: 2026-09-12
Status: BOUNDED SOURCE SEARCH / SOURCE UNAVAILABLE FOR EXECUTABLE TARGET SOLVER

## Search question

Locate an inspectable open-source implementation that takes explicit sheet/part geometry and computes a press-brake backgauge contact/target position strongly enough to trace the target calculation end to end.

## Searches performed

Repository/code searches covered combinations of:

- `backgauge` + `flange length`;
- `gauge position` + `bend` + `flange`;
- press-brake backgauge target/placement terminology;
- previously identified bend/CAM projects.

## Results

### FreeCAD SheetMetal

Inspectable open-source source exists for bend development/unfold geometry, including bend allowance based on inside radius, thickness, K-factor and bend angle. It does **not** implement press-brake finger placement or X/R/Z target generation. It remains useful input-model evidence only.

### BenDFM / other open sheet-metal tooling

Previously inspected open-source material provides bend-feature/sequence/manufacturability concepts but no located executable backgauge placement function in the bounded search.

### Public CAM documentation/code-index material

Searches surfaced documentation describing a mature CAM backgauge-placement subsystem with concepts such as backgauge model/path/placement and stating that placement is complex because of stability, collision and rotation. However, the surfaced public repository contains documentation/index material rather than the referenced executable placement source itself. It therefore cannot be audited as an open implementation and is not used as algorithmic evidence.

### Miscellaneous repositories

Other hits were fabrication articles, AI training text, documentation mirrors, or generic sheet-metal design code. None supplied a traceable geometry -> physical gauge datum -> machine target implementation suitable for this curriculum's source standard.

## Bounded conclusion

**Executable open-source backgauge target solver: SOURCE UNAVAILABLE in this pass.**

This negative result is now strong enough to stop broad searching rather than repeatedly querying the same vocabulary. The evidence from FreeCAD and the official CybTouch manual already establishes the important architecture:

- finished/drawing dimension is not identical to flat/developed geometry in general;
- a controller may accept flange length and separately calculate X;
- optional R can be calculated separately;
- machine backgauge geometry, corrections and recalculation state exist;
- mature gauge placement may involve stability/collision/orientation concerns beyond scalar bend allowance.

## Next justified design step

Freeze a **generic TargetCalculation / TargetSet provenance interface**, not a universal formula.

The interface should allow calculation plugins/methods to declare their required inputs and provenance, for example:

- direct machine-coordinate target entered by a trained operator;
- finished-flange-to-X method tied to a specific machine/tool/calibration implementation;
- future geometry-aware placement method;
- imported target from validated offline CAM.

Every generated target must identify its method/version and dependency revisions, and must be invalidated when those dependencies change. The first fixture should test provenance/invalidation and direct-vs-calculated ownership, not the numerical correctness of an invented bend formula.

## Promotion / future source target

A real open or licensed implementation may later replace SOURCE UNAVAILABLE if it becomes inspectable. At that point trace contact selection, geometry transformation, stability/collision checks, orientation, machine-axis mapping and corrections separately before adopting any algorithm.

## Claims boundary

This artifact records a bounded negative source search. It does not claim no such open-source implementation exists anywhere; only that none meeting the inspectability/evidence criteria was located in this bounded pass. It makes no numeric target, physical-machine, collision, tooling or functional-safety claim.
