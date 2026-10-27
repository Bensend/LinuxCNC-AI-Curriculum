# 4400-OXY-COMPAT-02 — technician transfer: electrically compatible is not oxygen-service compatible

**2026-10-27 | NON-GRADUATED, UNSCORED source-reading card; no hardware test.** Read the [original NASA/OSHA/HSE audit](../research/4400_OXY_COMPAT_02_OXYGEN_SERVICE_MATERIAL_IGNITION_CONTAMINATION_AND_CNC_GAS_VALVE_SOURCE_AUDIT_2026-10-27.md).

## Maintenance decision

A CNC oxy-fuel cutting station has an electronically controlled oxygen valve. A replacement has the same voltage, connector and nominal flow rating. It appears to solve an intermittent process fault. Can the technician install it and resume cutting because LinuxCNC's output and pressure traces look normal?

**No. HOLD.** Electrical/process equivalence does not establish oxygen-wetted material compatibility, oxygen cleanliness, ignition resistance or a valid change-controlled gas-safety architecture. The qualified reviewer must obtain the exact approved oxygen-service valve/seal/filter/cleaning and operating-envelope evidence, not infer it from a connector or process graph.

## Three discriminators

| Claim | Source-backed response |
|---|---|
| “Oxygen is not fuel, so the new valve cannot burn.” | NASA's oxygen-compatibility methodology explicitly considers materials that can ignite and propagate fire in oxygen, with pressure, temperature, flow, concentration and contamination affecting risk. |
| “The flashback arrestor protects the valve.” | An arrestor addresses a particular **backward flame propagation** path; it does not prove that a contaminated or incompatible oxygen-wetted component cannot ignite internally. |
| “The oxygen pressure and LinuxCNC command are normal.” | Normal control/diagnostics can show commanded process behavior, not cleanliness, material flammability, ignition sources, independent isolation or safe maintenance access. |

**Exact sources:** [NASA WSTF oxygen compatibility](https://www.nasa.gov/centers-and-facilities/white-sands/oxygen-compatibility-assessment-and-hazards-evaluation/) (2016), [NASA-TM-104823 abstract](https://ntrs.nasa.gov/citations/19970001787) (1996; full PDF not inspected), [eCFR §1910.253](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-Q/section-1910.253) oxygen-piping cleaning and oil-free requirements, [HSE flamecutting](https://www.hse.gov.uk/mvr/mechanical-repair/welding.htm) no grease/oil on oxygen fittings.

## Make the safe repair easy

Stock clearly identified oxygen-service parts and protected clean spares, avoid interchangeable unlabeled fittings, maintain OEM-approved replacement/cleaning records, and make a replacement trigger a qualified review rather than an informal “it fits.” A normal CNC reset or HMI green bit cannot release this change. No live oxygen, ignition or contamination experiment is authorized.

**Status:** selected machine, oxygen branch, wetted materials, operating conditions and isolation all UNKNOWN; OX-1..4 NOT PROVED. Not evidence of an OpenPressBrake oxygen system. G0/G1 HOLD and no personnel-exposed hazardous operation.
