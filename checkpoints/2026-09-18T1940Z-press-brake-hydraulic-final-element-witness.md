# Safety checkpoint — press-brake hydraulic final-element / physical-witness boundary

Date: 2026-09-18

## Completed

Created and strengthened `safety-course/PRESS_BRAKE_HYDRAULIC_FINAL_ELEMENT_PHYSICAL_WITNESS_BOUNDARY_2026-09-18.md`; final substantive commit `9df1f001b624f60326223f8bfd80c2f877c536c0`.

## New durable evidence

EN 12622:2009+A1:2013 Annex C publicly exposes an example redundant and monitored hydraulic control circuit for a down-stroking press brake. For a typical two-cylinder machine without mechanical linkage, gravity falls are prevented by two restraint valves on each cylinder; the example identifies monitored restraint, directional-control and safety valves. HAWE current press-brake material independently supplies real SAKB/ePRAX architecture and valve switching-position monitoring context.

## Frozen result

`SAFETY LOGIC SAFE DEMAND != ELECTRICAL VALVE COMMAND != COIL CURRENT != VALVE POSITION != REQUIRED REDUNDANT RESTRAINT PATHS PROVED != RAM/LOAD PHYSICALLY RETAINED != STORED HYDRAULIC ENERGY CONTROLLED != ALL HAZARDS ABSENT != SAFE ACCESS`.

`ONE RESTRAINT VALVE PROVED != REQUIRED REDUNDANT GRAVITY-RESTRAINT FUNCTION PROVED`.

OpenPressBrake valve truth tables, pressures, stopping distance/time, accumulator state, redundancy/performance level and exact safe-access state remain UNKNOWN until machine-specific evidence exists.

## Compute

No executable verification was justified. No self-hosted or GitHub-hosted compute was consumed.

## Overlap

Latest repository state before this lane included Lane-B checkpoint `a561c1f3281ad90bfeeccb3ae61c40a650a1ea94`. This work used a distinct new safety artifact/checkpoint and did not rewrite shared `PROGRESS.md`, avoiding collision with the parallel lane.

## Precise next work

Find a manufacturer/OEM hydraulic press or press-brake commissioning/service implementation exposing `safety demand -> redundant hydraulic final elements -> valve/pressure/motion disagreement -> physical load-safe disposition -> repair -> re-proof -> safety reset/rearm -> separate fresh cycle initiation`. Preserve UNKNOWN where public evidence stops; do not infer OpenPressBrake hydraulic behavior from Annex C.
