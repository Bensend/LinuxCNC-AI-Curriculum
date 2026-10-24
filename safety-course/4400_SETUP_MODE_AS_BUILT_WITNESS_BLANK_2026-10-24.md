# 4400-SET-01 — Blank selected-machine setup-mode safety witness
**2026-10-24 | ALL FIELDS BLANK / NO PHYSICAL TEST PERFORMED / NOT AN APPROVAL**

## Identity and source
Machine/serial/location: **UNKNOWN**
Jurisdiction and exact applicable standard/edition: **UNKNOWN**
Qualified responsible verifier and date: **NOT ASSIGNED**
As-built hydraulic/electrical/safety drawing revision (restricted repository only): **UNKNOWN**
Actual LinuxCNC revision and ordinary jog/HAL configuration: **UNKNOWN**
Exact safety controller, mode selector, enabling switch, drive/SLS or hydraulic safe-motion product, firmware and original manual: **UNKNOWN / MAY BE N/A**

## Hazard-to-physical proof table (fill only from evidence)
| ID | Question / observed evidence | Current result |
|---|---|---|
| BND-SET | Modes and human reach/occupancy boundaries for Y1/Y2, tooling, rear/side access | UNKNOWN |
| ENE-SET | Gravity, pressure, trapped volumes, accumulators, motors, electrical energy, coasting inertia | UNKNOWN |
| SF-SET | Required independent safe-motion/stop/hold function and permitted setup activity | UNKNOWN |
| AUTH-SET | Actual independent safety output and physical final elements (not just PLC indication) | UNKNOWN |
| DEP-SET | Shared feedback, encoder/power/common-return/communication failures | UNKNOWN |
| VAL-SET-01 | Mode selector changed during guard-open access / multiple entrants | NOT RUN |
| VAL-SET-02 | Enabling switch released, middle, fully squeezed; exact safety response | NOT RUN |
| VAL-SET-03 | Guard entry before/during/after SLS activation and delay | NOT RUN |
| VAL-SET-04 | Overspeed/fault/power-loss response with independent stop and gravity holding | NOT RUN |
| VAL-SET-05 | Door reclosure, reset, rearm and fresh start with retained CNC demand | NOT RUN |
| VAL-SET-06 | Qualified maintenance isolation, reaccumulation and mechanical support | NOT RUN |
| VAL-SET-07 | Actual point-of-operation/side/rear protection and ergonomic legitimate setup | NOT RUN |
| PT-SET | Manufacturer-required inspection/proof test and after-change validation | NOT RUN |
| CHG-SET | Changed mode/drive/guard/sensor/firmware/tooling and stale-evidence review | UNKNOWN |

## Task-by-task OSHA applicability (US machines only)
Task description and actual exposure: UNKNOWN
Normal-production, routine, repetitive, integral each independently established? UNKNOWN
Effective alternative protection demonstrated for minor-servicing claim? UNKNOWN
If not all established, applicable LOTO and qualified temporary test/positioning plan: UNKNOWN
No blanket "setup exception."

## Release rule
Do not populate stop distance, safe speed, PL/SIL, pressure, diagnostic coverage, or physical outcomes without actual qualified design/measurement evidence. Do not expose personnel to hazardous motion as a test. Until independently verified: **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**. Any experimental motion must be isolated/remote with people outside the danger zone and residual risk explicitly assessed. This is a **blank intake**, not a completed validation.
