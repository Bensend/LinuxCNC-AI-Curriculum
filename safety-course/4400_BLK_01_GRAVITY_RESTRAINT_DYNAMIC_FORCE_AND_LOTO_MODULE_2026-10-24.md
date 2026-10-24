# 4400-BLK-01 — Gravity restraint, dynamic stroke and maintenance isolation
**4000 safety | 2026-10-24 | SOURCE-READING / NOT GRADUATED / NO PHYSICAL VALIDATION**

## Purpose and prerequisites
Use 2520 (hazard/SRS), 2540 (final elements), 2580 (hydraulic/gravity), 2590 (access), 4400-SET-01 (setup versus LOTO) and the cumulative Safety Design Package. Read the [original OSHA slide-lock/press-brake scope investigation](../research/4400_OSHA_SLIDE_LOCK_GRAVITY_VS_POWERED_STROKE_AND_PRESS_BRAKE_TRANSFER_AUDIT_2026-10-24.md), then the [technician cases](4400_GRAVITY_SUPPORT_DYNAMIC_LOAD_AND_TEST_POSITION_TECHNICIAN_CARD_2026-10-24.md), and use the [blank selected-machine witness](4400_RAM_SUPPORT_AND_PERSONAL_LOTO_BLANK_WITNESS_2026-10-24.md).

## Learning outcomes
A fresh engineer can (1) separate static gravity restraint from powered hydraulic force; (2) distinguish lock indication, actual engagement, structural capacity and independent energy isolation; (3) describe why a mechanical support and electrical/hydraulic isolation are complementary; (4) apply OSHA 1910.147(f)(1) temporary test/positioning without treating it as unrestricted hands-in work; (5) preserve personal control in group maintenance; and (6) reject automatic transfer of 1910.217 press requirements to press brakes.

## Engineering authority chain (design pattern only)
`LinuxCNC motion request -> ordinary drive/valve command` is **normal control**. Independent safety logic can remove hazardous motion authority, but its outputs alone do not prove a stationary or supported ram. Qualified electrical/hydraulic isolation controls energized sources; a **physically engaged, rated mechanical restraint** addresses gravity where appropriate; authorized personnel retain personal control of applicable isolation. Qualified physical witnesses establish the actual safe condition before exposure. An E-stop, STO, safety PLC 'healthy' indication, pressure gauge at one port, or an FPGA disable does not prove all these propositions.

## A four-proposition decision matrix
| Proposition | Possible evidence | Insufficient substitute |
|---|---|---|
| Support indicates engaged | Selected-device limit/indicator with configuration and freshness | HMI bit as physical proof |
| Support actually engaged | Safe-location independent visual/mechanical witness, selected OEM method | Single stale limit switch |
| Support load path adequate | Selected OEM design, rating, anchorage, load-case and inspection evidence | 'Looks strong', universal factor, static hold anecdote |
| Powered energy isolated and residual controlled | Task-specific locked isolators, stored-energy restraint/release, qualified verification | Pump OFF, software E-stop, SLS, two-hand jog |

Do not enter a hazardous ram zone to obtain a witness. If engagement cannot be verified from a safe location, redesign the witness/access method first.

## Maintenance transition: isolate -> temporary position -> re-isolate
For covered servicing, establish all applicable energy isolation and stored-energy restraint before hands-in work. Where testing/positioning requires energy, apply the documented OSHA 1910.147(f)(1) transition: clear the area, remove people, remove locks by authorized procedure, energize for the limited purpose, then deenergize and **reapply/verify** all controls before anyone resumes exposure. A remote test or jog does not establish an exception by itself. Multiple exposed workers retain personal protection under group lockout rules. An eligible minor-servicing alternative is a separate, task-specific determination; never infer eligibility from 'setup mode'.

## Human-factor design review
Place and store the support where it is needed; prefer captive or keyed components that cannot be casually misplaced, clear engagement visibility from outside the danger zone, simple lock attachment for each worker, readable capacity/inspection labels, and a procedure that does not require defeating a guard to reach the restraint. An interlock is useful to detect misuse, but cannot replace the mechanical member or the required isolation. Investigate any workflow that makes the shortcut easier than the safe method.

## Release gates
- **G0/G1 HOLD:** selected machine boundary, loads, isolation, and hazard map incomplete.
- **G2 NOT RUN:** as-built electrical/hydraulic/structural verification and qualified proof procedure absent.
- **G3/G4 NOT AUTHORIZED:** no personnel-exposed operation or machine release.
- **G5 HOLD:** no documented maintenance/inspection/change-control acceptance.
- **External fresh-AI evaluation OPEN:** paper cases are learner-readable practice, not blind competency evidence.

Do not calculate selected load, factor, pressure, stopping distance or PL/SIL from this generic module. If minimum physical safe-to-operate protection is not demonstrated, people must remain outside the danger zone; any experimental operation must be isolated/remote with residual risks stated.
