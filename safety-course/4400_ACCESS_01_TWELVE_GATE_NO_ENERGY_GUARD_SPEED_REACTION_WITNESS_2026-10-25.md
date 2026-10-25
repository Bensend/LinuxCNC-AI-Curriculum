# 4400-ACCESS-01 — Twelve-gate G0 documentary witness (blank, NOT RUN)
**2026-10-25 | Qualified custodian only | no energized tests authorized**

| Gate | Required selected-machine document / independently checkable fact | Owner / revision / evidence location | Status |
|---|---|---|---|
| ACCESS-G01 | Machine ID, hazard zones, access lifecycle and every relevant hazardous axis/energy source | | UNKNOWN |
| ACCESS-G02 | Exact safety controller, drive, guard hardware, firmware, original manuals and config checksum | | UNKNOWN |
| ACCESS-G03 | Guard unlock mode: timer-only vs measured standstill vs status-only; verified parameter set | | UNKNOWN |
| ACCESS-G04 | Safety speed sensor(s), mechanical attachment to actual load, diagnostics and common-cause assessment | | UNKNOWN |
| ACCESS-G05 | Independent logic receives correct safe signal; status-only reporting is not mistaken for reaction | | UNKNOWN |
| ACCESS-G06 | Safety output, wiring, polarity, feedback and final element to actual hazardous energy | | UNKNOWN |
| ACCESS-G07 | Loss of power, short, fault and already-unlocked state for guard and all safety outputs | | UNKNOWN |
| ACCESS-G08 | Qualified stop-time / coast-down / access-time evidence for selected physical machine, with uncertainty | | UNKNOWN |
| ACCESS-G09 | Gravity, Y1/Y2 asymmetric ram support, hydraulic stored pressure and independent hold/isolation | | UNKNOWN |
| ACCESS-G10 | Guard reinstatement, inside escape, occupancy and emergency rescue (including power loss) | | UNKNOWN |
| ACCESS-G11 | Reset/rearm cannot restart old motion; independent fresh command, maintenance mode and change control | | UNKNOWN |
| ACCESS-G12 | Independent evaluator, risk assessment, SRS, PL/SIL method and commissioning signoff | | UNKNOWN |

**Disposition:** G0 **HOLD**; G1 isolated experiment permission **HOLD**; G2 selected physical validation **NOT RUN**; G3/G4 personnel-exposed operation **NOT AUTHORIZED**; G5 **HOLD**. A blank/UNKNOWN is not a PASS. Do not invent a press-brake hydraulic truth table, safe speed threshold, stopping distance, load rating or installed hardware. Public repository contains no private as-built drawings.

**Adversarial desk test:** explicitly challenge three superficially green states: (i) timer elapsed while motion continues; (ii) safe speed status detects violation but no final element acts; (iii) faulted DC_Out=OFF while a power-to-lock door unlocks. Then challenge a fourth: standstill encoder valid while gravity/pressure moves the ram. For each, reject release unless the complete physical chain is demonstrated. This is a **review protocol**, not a performed test.
