# 4400 HYD-AIR-01 — distinguish vapor cavitation, aeration and safe service
**2026-10-26 | PUBLIC PAPER TRANSFER / NON-GRADUATED**

Use [original Bosch/Parker/Danfoss source audit](../research/4400_HYD_AIR_01_BOSCH_PARKER_CAVITATION_AERATION_AND_ERRATIC_ACTUATOR_OEM_AUDIT_2026-10-26.md) and the existing [hydraulic pressure-zone witness worksheet](4400_PRESSURE_ZONE_PHYSICAL_WITNESS_TRACEABILITY_WORKSHEET.md). For each scenario, identify the *discriminating evidence* and the independent physical safe state; do not propose energized fitting release or uncontrolled bleeding.

## Six unscored paper scenarios
1. A pump sounds like gravel only when cold. The operator proposes ignoring it because it becomes quiet.
2. A service worker observes foam in a reservoir and immediately diagnoses vapor cavitation; a second worker points to a suction seal leak.
3. A Y-axis normal-controller position trace becomes irregular; an engineer proposes increasing PID gains without checking the hydraulic fluid or valve.
4. A Parker **T20 rotary** service page recommends bleeding; a technician proposes following the same port sequence on an unidentified press-brake cylinder.
5. A pressure gauge reads expected values, but the elevated beam's gravity hold and trapped volumes have not been independently witnessed.
6. A replacement suction filter has a finer rating; after installation the cold pump becomes noisy. The installer claims finer filtering is always safer.

## Eight documentary gates — all NOT RUN
| Gate | Required evidence or question | State |
|---|---|---|
| HA-G1 | Exact pump, actuator, fluid, cold-start limits and revisions? | NOT RUN |
| HA-G2 | Distinguish vapor cavitation vs external air vs dissolved gas using selected source? | NOT RUN |
| HA-G3 | Reservoir, suction seals, inlet vacuum, filter and return route mapped? | NOT RUN |
| HA-G4 | Separate ordinary position/PID fault from hydraulic cause without unsafe retuning? | NOT RUN |
| HA-G5 | Exact selected OEM bleed/inspection procedure and qualified isolation plan? | NOT RUN |
| HA-G6 | Independent gravity support, pressure-zone isolation and final-element proof? | NOT RUN |
| HA-G7 | Guard restoration, service ergonomics and fresh restart/CHG evidence? | NOT RUN |
| HA-G8 | Record contradiction, uncertainty, owner and no-operation decision? | NOT RUN |

**Evidence status:** Bosch and Parker direct OEM **DOC-CONFIRMED** exact scope; Danfoss indexed-only. **INFERENCE** potential impact on stopping/holding; selected machine **UNKNOWN**. Six PUBLIC PAPER cases UNSCORED, eight desk gates NOT RUN, no evaluator execution, no physical test, no hosted/local compute. This card does not qualify a pump, establish pressure thresholds or authorize hazardous operation. **G0/G1 HOLD.**
