# Safety curriculum Lane B checkpoint — professional press-brake maintenance trace

- UTC session: 2026-09-17T13:49Z
- Parallel overlap check: current main was read before selection, immediately before durable work, and after artifact commit. No intervening primary-lane commit or overlapping file appeared.
- Compute: NONE. No executable verification was justified; no GitHub-hosted Actions minutes were used and no self-hosted runner job was needed.

## Governance read

Read current `START_HERE.md`, `LEVEL_ORDER.md`, `CURRICULUM.md`, `WORK_SELECTION_POLICY.md`, `PROGRESS.md`, current safety-course inventory, recent commits, newest durable safety work, and latest active checkpoint evidence before selecting work.

The immediately preceding safety lane had completed test-point/witness maintainability and explicitly directed the next branch away from further narrow test-point repetition toward a complete professional-machine maintenance evidence trace.

## Durable work

Commit `86ff4ccf` adds:

- `safety-course/PROFESSIONAL_PRESS_BRAKE_MAINTENANCE_EVIDENCE_TRACE_TRUBEND_2000.md`

Primary OEM evidence is the public TRUMPF TruBend Series 2000 (B35) operator/install manual B1161en, 2023-05-01.

Frozen rule:

> Periodic safety maintenance must challenge the credited protective chain and its physical hazard result. A healthy controller indication, LinuxCNC/HAL bit, FPGA register, or successful production cycle is not a substitute for the OEM-required physical/functional check.

## Evidence gain

`DOC-CONFIRMED` — TRUMPF identifies side/rear monitored safety doors, EMERGENCY STOP, stop-function foot control, BendGuard, main switch, backgauge STO and hydraulic-unit switch-off as distinct parts/effects of the safety architecture.

`DOC-CONFIRMED` — TRUMPF requires side/rear guard safety-switch and E-stop/foot-stop functionality checks once per shift and after a collision, plus at-least-once-per-shift external damage inspection. It separately requires prescribed maintenance and regular visual inspection of safety-relevant components such as hydraulic hoses/pressure containers.

`DOC-CONFIRMED` — EMERGENCY STOP leaves backgauge drives supplied under STO while switching off the hydraulic unit. The manual separately identifies residual hydraulic pressure, suspended/moving assemblies and a press beam that can fall if hydraulic components are removed first. Therefore protective stop is not equivalent to task-level hazardous-energy isolation.

`DOC-CONFIRMED` — Unless expressly stated otherwise, maintenance is performed with the machine switched off, MAIN SWITCH off and padlocked. A special keyed energized-cabinet maintenance boundary exists for trained personnel; that exception is not generalized into ordinary energized maintenance.

`SOURCE-CONFIRMED` — OSHA 29 CFR 1910.147 is retained only for its actual servicing-energy-control scope: isolation, stored/residual-energy control, verification and periodic energy-control-procedure inspection.

## Deliberate UNKNOWNs

No PL/SIL/DC, stopping time/distance, hydraulic safety-valve truth table, accumulator data, BendGuard safety distance/mute setup, EDM topology, safety-controller program, installed main-switch boundary, or post-replacement proof-test sequence was invented. Public evidence used here does not establish those facts.

## Progress disposition

`PROGRESS.md` remains the shared primary-lane progress file and was not overwritten for this independent artifact because its current active-safety direction remains valid. This checkpoint is the durable Lane-B progress record.

## Precise next independent work

Build `safety-course/PROFESSIONAL_PRESS_BRAKE_BENDGUARD_PERIODIC_VALIDATION_TRACE.md` **only if the primary lane has not entered BendGuard/device validation**. Use the TRUMPF machine-level trace plus the applicable SICK BendGuard/V4000 manufacturer instructions to connect machine safeguard demand to device daily/tool-change inspection, correct test object/procedure, installation damage/alignment checks, muting/tool-change implications, fault disposition and the boundary between device self-diagnostics and machine-level physical stopping validation.

If that overlaps primary work, switch instead to a different OEM machine with a complete maintenance/safety chain. Do not turn manufacturer-specific intervals into universal OpenPressBrake intervals and do not invent stopping or hydraulic values.