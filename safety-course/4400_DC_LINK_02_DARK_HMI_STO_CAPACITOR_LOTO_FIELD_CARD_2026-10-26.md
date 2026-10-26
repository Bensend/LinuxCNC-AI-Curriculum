# DC-LINK-02 — The HMI is dark: is the drive safe to service?
**4400 safety | 2026-10-26 | PUBLIC PAPER ONLY | UNSCORED / NOT RUN**

Read [direct Rockwell/OSHA and limited ABB/Siemens audit](../research/4400_DC_LINK_02_STO_DARK_DISPLAY_VS_CAPACITOR_ISOLATION_AND_LOTO_OEM_AUDIT_2026-10-26.md). This is a documentary learning exercise **not an electrical test procedure**. Qualified electrical workers must follow exact selected OEM manuals and applicable regulations. No instruction here authorizes opening cabinets, touching conductors or making live measurements.

## Core mental model
**STO active ≠ DC bus discharged ≠ electrical isolation ≠ motor stopped ≠ suspended load supported.** A blank screen is not a voltage witness. A disconnect only isolates the circuits it actually interrupts. A wait period is product-specific and **must not substitute for verification**. OSHA's energy-control rules address stored energy and affirmative verification in covered servicing, not merely normal controller disable.

## Eight unscored technician scenarios
| ID | Initial situation | Evidence / distinction the learner must request |
|---|---|---|
| DL-01 | PowerFlex 400 display goes black immediately after disconnect. | Why manufacturer still requires a model-specific wait and measured zero at exact bus terminals by qualified personnel. |
| DL-02 | Maintenance procedure copied PowerFlex 520 **3 min** into a PowerFlex 400 **5 min** manual. | Product/model/version mismatch; no universal wait and no substitute for qualified verification. |
| DL-03 | A drive says STO and the spindle is motionless. | STO versus stored DC energy and separate shock/isolation proposition. |
| DL-04 | Technician sees a green 'safe' LED and wants to skip isolation walkdown. | OSHA LED interpretation; which independent evidence is missing. |
| DL-05 | The main disconnect is open but an auxiliary supply or common DC bus may still be connected. | Inventory of all possible energy sources and exact isolation boundaries. |
| DL-06 | A permanent-magnet motor or load can be externally rotated after mains off. | Why machine-specific backfeed/energy analysis and qualified source identification matter. |
| DL-07 | Bus has discharged but a vertical axis may descend when torque is removed. | Electrical de-energization versus independent mechanical/gravity restraint. |
| DL-08 | Drive model is replaced during maintenance and the old warning label remains. | Change-control trigger: exact OEM documentation, test points, isolation plan and reviewer. |

All **DL-01..DL-08 are PUBLIC PAPER / UNSCORED**. Do not reveal a hidden key or claim a blind competency score. If an independent evaluator is engaged, use different unseen evidence with immutable learner precommit and independent scoring.

## Eight documentary gates — all NOT RUN
| ID | Required existing qualified artifact (do not perform energized tests from this card) |
|---|---|
| DL-G01 | Dated as-built drive/auxiliary energy-source inventory and exact model suffix |
| DL-G02 | Matching OEM service manual revision, warnings and service task scope |
| DL-G03 | Documented mains, auxiliary, DC-link, regeneration and motor backfeed boundaries where applicable |
| DL-G04 | Actual lockable energy-isolating devices and responsible authorized persons |
| DL-G05 | OEM-specific stored-energy discharge/verification method and qualified tester procedure |
| DL-G06 | Documented separate gravity/pressure/mechanical load restraint and rescue boundary |
| DL-G07 | Evidence that dark LEDs, HMI status, STO and controller flags are not used as sole proof |
| DL-G08 | Change-control and return-to-service procedure with independent review and fresh restart |

All **DL-G01..DL-G08 NOT RUN**; none of the selected OpenPressBrake facts have been provided. Conditional Stage B only after qualified Stage A A–G establishes drive equipment. No numerical OpenPressBrake wait, bus voltage, discharge constant, stopping time, safe-speed or PL/SIL is claimed.

**Release:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation or electrical probing authorized.
