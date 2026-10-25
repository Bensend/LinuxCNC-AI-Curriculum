# 4400-GUARD-01 — Job-shop press-brake safeguarding without the “safe-distance shortcut”
**4000 / safety design | 2026-10-25 | NON-GRADUATED / DOCUMENTARY**
Prerequisites: 2520 hazard/SRS, 2530 E-stop, 2580 hydraulics, 2590 guarding, 25E0 commissioning, 3600 historical press-brake source knowledge.

## Learning outcome
Given a frequently reconfigured press brake, identify which task/mode/person is exposed; design a **convenient protective architecture** rather than treating a historical OSHA enforcement exception as an engineering target; and defend why a front guard alone cannot prove Y1/Y2 gravity holding, rear-zone protection, maintenance isolation or safe restart.

Read [original 1997 directive/supersession audit](../research/4400_OSHA_CPL_1997_PRESS_BRAKE_SAFE_DISTANCE_SUPERSESSION_AND_JOB_SHOP_SCOPE_AUDIT_2026-10-25.md) first. The five-page 1997 CPL is direct **DOC-CONFIRMED** historical policy, **not** a selected machine approval. The current machine-specific standard edition and jurisdiction must be confirmed separately.

## Four separate hazard/authority layers
| Layer | Typical task | Design requirement / real witness | Insufficient proxy |
|---|---|---|---|
| Front die / workpiece | Setup, small bends, helper loading, sheet whip | Actual point-of-operation protection for each tool/part/mode, reach/approach and blanking coverage, independent safe stopping | “4 inches” from 1997 CPL, laser READY, ordinary slow command |
| Rear/backgauge | Adjustment, part handling, trapped/helper access | Rear access prevention or qualified protective stop for **both** ram and gauge, occupancy/escape and reset sightline | Front light curtain or X-axis “in position” |
| Vertical ram | Guard trip, power loss, E-stop, rescue | Independent stop **and gravity hold** plus selected safe-energy/removal path and physical witness | Y1/Y2 commanded zero, normal FPGA enable OFF |
| Maintenance/rescue | Tool change, jam, under-ram work | Qualified isolation, mechanical restraint, stored/reaccumulating pressure checks, separate rescue and rearm | Production hand-clearance rule, one pressure gauge |

## Practical low-friction safeguard selection (INFERENCE)
1. Start with the actual task: one-piece vs repeat run; tooling/part envelope; front and rear people; helper hands; sheet whip; setup and rescue. Do not assume one guard configuration covers all jobs.
2. Make **correct use the default**: captive/hinged adjustable guards with visible position indicators, clear protective-field status, tool-specific repeatable setup references, easy cleaning, simple accessible fault diagnosis and convenient approved reset location **outside** the danger zone. These are design options, not universal certified solutions.
3. Minimize reasons for defeat: long reset walks, nuisance trips, blocked sightline, awkward sheet support, inaccessible jam cleanup, or confusing guard reinstallation trigger a documented human-factors redesign. Do not solve nuisance trips by disabling diagnostics or widening muting.
4. Evaluate actual selected guarding devices, safe distance and stop time **using the adopted current method and measured selected response**. No numerical guard separation, PL/SIL or stop distance is supplied by this module.
5. Distinguish production, setup, tool change, jam clearing, rescue, cleaning and maintenance; mode selection must not silently eliminate independent personnel-safety authority.
6. Physical protective outputs should act through a separately engineered safety controller/final-element path. LinuxCNC/ordinary FPGA can **request/monitor** but must not own the sole protective stop, gravity hold or rearm authorization.
7. Reset is not start. After E-stop/guard recovery/power loss, verify area clear and independent safety readiness, discard retained ordinary motion requests, then require a fresh deliberate start.

## Historic exception trap
The 1997 OSHA CPL 02-01-025 only discusses a **conditional enforcement alternative** when physical safeguarding is demonstrated infeasible and additional job-shop/program requirements are met. Its 4-inch figure is **not** a modern machine design rule, not a stop-time result, and not a reason to omit guarding. Its §O rescinds older 1983 guidance; the 1986 letter was edited to refer to 1997. Current adopted law/standards and exact selected application are UNKNOWN. A cheaper, usable physical protective architecture is the engineering target.

## Concrete no-energy learner tasks
Use [GUARD-01 technician card](4400_GUARD_01_TECHNICIAN_DECISION_AND_BLANK_SELECTED_WITNESS_2026-10-25.md) and [guard usability desk review](4400_GUARD_01_LOW_FRICTION_SAFEGUARD_DESK_REVIEW_2026-10-25.md). Learner must create a hazard-to-safeguard map, identify three plausible bypass incentives and remove at least two **without lowering protection**, mark missing selected facts UNKNOWN, and separate production/rear/maintenance/rescue safety. The evaluator handoff is [here](../evaluation/4400_GUARD_01_FRESH_JOB_SHOP_GUARD_TRANSFER_HANDOFF_2026-10-25.md); independent test **PREPARED, NOT EXECUTED**.

## Graduation / promotion
No independent fresh transfer score, no selected OpenPressBrake physical VAL/PT, no safe-distance calculation, no physical human exposure. Source lesson **NON-GRADUATED**; selected machine G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. Promote selected geometry, safety performance and jurisdiction only to qualified machine-specific intake, **not** as assumed acceptance.
