# 4000 safety checkpoint — final-element feedback vs physical-hazard witness

UTC start: 2026-09-18T17:39:00Z
UTC end: 2026-09-18T17:41:00Z
Elapsed: 2.00 min
Overlap status: NONE OBSERVED; this session added a new evidence trace and did not replace shared PROGRESS.md.

## Durable result

Created `safety-course/FINAL_ELEMENT_FEEDBACK_VS_PHYSICAL_HAZARD_WITNESS_TRACE_2026-09-18.md`.

New freeze:

`SAFETY OUTPUT OFF != CONTACTOR OPEN != MOTOR/AXIS STATIONARY != HAZARDOUS ENERGY ABSENT != SAFE ACCESS.`

`EDM VALID != PHYSICAL HAZARD PROVED ABSENT.`

Rockwell CENTERLINE/GuardLogix evidence establishes N/C auxiliary-contact feedback as a concrete witness that monitored contactors opened. Rockwell safe-monitored-access evidence separately uses hazardous-motion sensing before full-body access, and Pilz standstill-monitor evidence independently supports physical motion/standstill monitoring. This closes the conceptual gap left by the prior linked-line E-stop trace: EDM proves a switching-state proposition, not every downstream physical hazard proposition.

No machine-specific hydraulic truth table, stopping distance, pressure threshold, PL/SIL/DC, or OpenPressBrake physical parameter was inferred.

## Compute

No simulation/build/test/synthesis/benchmark compute was justified or run. No GitHub-hosted runner minutes were used.

## Exact next work

Prefer a professional same-machine implementation exposing `safety output -> contactor/STO/valve feedback -> direct physical hazard witness -> access/rearm -> separate ordinary START`, especially one with injected disagreement between final-element feedback and the physical witness. Continue gravity/hydraulic evidence when valve/load-retention feedback and actual load motion/position are visible together.
