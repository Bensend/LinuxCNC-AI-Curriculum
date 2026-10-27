# 4400-DUST-01 — Practical combustible-dust / dust-collector safety field module

**Status:** PUBLIC PAPER PRACTICE ONLY — 10 scenarios **UNSCORED**, 12 documentary gates **NOT RUN**, no selected-machine validation. Source: [original OSHA/CSB/HSE/Fike/NFPA publisher audit](../research/4400_DUST_01_OSHA_CSB_FIKE_NFPA660_COMBUSTIBLE_PARTICULATE_AND_COLLECTOR_PROPAGATION_AUDIT_2026-10-27.md). Not a substitute for competent dust-hazard assessment, fire-code review or actual protection engineering. This is 4000-series safety transfer, not reopened 3000 work.

## Learning objectives

A fresh learner must be able to (a) distinguish ordinary dust capture/air quality from combustible-dust explosion protection; (b) identify **primary vs secondary** deflagration paths; (c) separate the collector vessel, inlet/outlet duct, hopper and room as physical hazard zones; (d) recognize material- and process-specific unknowns; (e) prevent predictable maintenance bypass; and (f) avoid claiming that ordinary LinuxCNC/FPGA/HMI status is personnel-safety authority.

## Minimal hazard-boundary drawing (illustrative, NOT an installed machine)

```text
 [CNC / process] -- dusty inlet duct --> [collector vessel] -- clean-air outlet --> [fan / return]
         |                  |                 |                    |
  cutting/ignition    propagation path  fire/deflagration     return path
         |                  |                 |
 [occupied zone]      isolation? UNKNOWN   vent/suppress? UNKNOWN
                            |                 |
                        connected process    [hopper/bin] -- disposal/maintenance
                            |                 |
                  accumulated dust in room/overhead structure
```

**Design rule:** mark each arrow with the actual material, air/dust flow, possible ignition/pressure/flame propagation, isolation boundary, service access and residual hazard. Do not convert this sketch into a product specification.

## Authority separation

| Layer | Legitimate role | Must not be credited as |
|---|---|---|
| Ordinary LinuxCNC / FPGA / normal PLC | Run spindle, fan, dust extraction; show filter/airflow diagnostics; stop a normal production cycle. | Independent explosion prevention, collector containment, duct isolation, safe maintenance energy removal. |
| Process instrumentation | Indicate airflow, pressure differential, fan motor status, temperature when selected and calibrated. | Proof of material nonexplosibility, absence of hidden deposits, flame isolation, complete safe state. |
| Independently engineered safety/fire protection | Product/installation-specific explosion venting, suppression, isolation, fire detection and protection where justified by hazard analysis. | Generic plug-and-play solution independent of dust properties and geometry. |
| Physical boundaries | Properly designed collector, ducts, protective devices, safe vent discharge/exclusion zone, guards and maintainable access. | Equivalent to a software reset or an alarm acknowledgement. |
| Maintenance energy control | Qualified isolation, lockout, cooling, residual dust/fire/pressure assessment and deliberate return to service. | 'Fan OFF' or 'LinuxCNC E-stop' alone. |

## Ten technician scenarios — PAPER, UNSCORED (do not publish answer keys as blind evaluations)

For each: identify `BND/ENE/HAZ/PHY/AUTH/DEP/VAL/CHG/UNK`, select the first **safe** diagnostic/documentary action, name a tempting but false inference, and specify evidence that would change your answer.

1. **DUST-P01 — Fan-green fallacy.** A router HMI shows extractor running, but fine dust coats an overhead beam. Does green airflow prove the fire/explosion hazard controlled? Separate airborne capture from deposited dust and physical collector/room hazards.
2. **DUST-P02 — Collector vent only.** A collector has an explosion panel but an unreviewed return-air duct enters an occupied room. Which separate propagation/vent discharge propositions remain UNKNOWN?
3. **DUST-P03 — Good filter, wrong material.** A shop switches from wood to dry aluminum grinding and keeps the same vacuum. Identify the material compatibility, ignition and collection-system questions before work; do not infer an approved method.
4. **DUST-P04 — The quiet near miss.** The operator reports a smoldering smell inside a hopper, then it disappears. A normal controller reset clears the alarm. Explain why resetting is not proof of extinguishment or safe access.
5. **DUST-P05 — Helpful compressed air.** Cleaning staff blow dust from overhead ledges while the collector fan is operating. Trace potential resuspension and secondary-event exposure; propose an approved low-defeat cleaning/access strategy.
6. **DUST-P06 — Convenience duct change.** A technician shortens an extraction duct and moves the collector indoors. Which material, geometry, vent path, isolation, building/fire-code and `CHG` dependencies become stale?
7. **DUST-P07 — Machine stop versus fire control.** An ordinary LinuxCNC interlock stops the spindle on fan fault. Distinguish what this does and does not prove about collector smoldering, flame propagation and residual stored hazards.
8. **DUST-P08 — Dust history argument.** A manager says coarse wood chips have never burned and therefore fine sawdust from a new sanding head needs no review. Explain the particle/process evidence gap without inventing MEC/Kst.
9. **DUST-P09 — One sensor for everything.** A differential-pressure switch reads normal, but an inlet isolation device is removed for easier cleaning. Identify independent physical claims and foreseeable bypass incentive.
10. **DUST-P10 — Metal and wood in one collector.** A facility plans to connect a new dry metal-grinding station to an existing woodworking duct. Specify what must be established **before** any physical connection or operation; do not prescribe an unqualified collector or suppressant.

## Twelve documentary/engineering verification gates — all NOT RUN

| Gate | Required artifact or observation | Status |
|---|---|---|
| DUST-G01 | As-built process inventory: each material and whether it creates fine particulate; dust-generating modes, people and spaces. | NOT RUN |
| DUST-G02 | Representative dust combustibility/explosibility assessment by competent method and authority; record material/process differences and UNKNOWNs. | NOT RUN |
| DUST-G03 | Exact applicable jurisdiction, adopted fire/building rules, manufacturer instructions and NFPA edition applicability. | NOT RUN |
| DUST-G04 | As-built collector, duct, hopper, fan, return-air, vent discharge and occupied-zone boundary drawing. | NOT RUN |
| DUST-G05 | Primary-event ignition and confinement review, including cutting sparks, friction, bearings, static, hot particles and smoldering. | NOT RUN |
| DUST-G06 | Secondary propagation paths through inlet/outlet/return/hopper/room and deposits; independent mitigation/physical witnesses. | NOT RUN |
| DUST-G07 | Selected product evidence for vent/suppression/isolation, installation limits and compatibility; no catalog-name-only qualification. | NOT RUN |
| DUST-G08 | Source-capture and exposure/air-quality assessment **separate** from combustible-dust fire/explosion protection. | NOT RUN |
| DUST-G09 | Accessible, sustainable cleaning/inspection schedule; hidden deposits, permitted tools, dust removal and no compressed-air blowdown shortcuts. | NOT RUN |
| DUST-G10 | Maintenance isolation, residual fire/smoldering and safe opening/return-to-service sequence with deliberate restart. | NOT RUN |
| DUST-G11 | Fault injection/validation plan by competent designer **without hazardous dust or ignition experiments**; proof of required protective function from independent evidence. | NOT RUN |
| DUST-G12 | `CHG` review for material, cutting process, collector, duct, filter, vent, sensor, fire-protection, cleaning method or building occupancy change; downstream `VAL/PT` stale until reviewed. | NOT RUN |

**Never promote desk-gate completion to a physical test.** No selected machine, material properties, collector or protective devices are identified here; all 12 remain NOT RUN.

## Anti-bypass, low-cost-first architecture principles

1. Put dust-generating equipment, collector and service doors in a layout that can be inspected and cleaned without reaching through hazardous motion zones. Safe access should be faster than defeating a guard.
2. Keep normal dust-capture alarms informative and actionable; avoid nuisance alarms that encourage permanent bypass. If nuisance occurs, correct root cause and revalidate protection, not silence a safety requirement.
3. Use material/process labels at the collector and at each connection. Make incompatible connections mechanically or administratively difficult, and approved replacements obvious.
4. Use a clearly marked, easily reached maintenance isolation point with a documented safe handback; do not substitute fan OFF or LinuxCNC disabled for physical isolation.
5. Where a dust hazard requires explosion protection, select and qualify the **complete** collector/duct/vent/isolation arrangement with competent engineering. Do not rely on the cheapest standalone sensor, filter, shop vacuum or software logic as a replacement.
6. Make inspection/cleaning feasible on every shift. Hard-to-reach hidden deposits and cleaning requiring frequent guard defeat are design defects to fix.

## Conditional transfer to OpenPressBrake

**No evidence says OpenPressBrake has combustible dust, a collector or any of these devices.** The press-brake selected-machine Stage A A–G Y1/Y2 stop/hold/hydraulic/guard/restart gate remains higher priority. Only reopen DUST-G01–G12 if an actual machine/process inventory shows relevant particulate hazards. Do not divert routine controller-board development here.

**Minimum safe-to-operate threshold:** If credible combustible-dust hazards are unresolved and workers could be exposed to fire/deflagration, **do not operate with people exposed**. Isolated/remote experimentation still requires qualified controls for off-machine fire, explosion, pressure, fumes and propagation risks; simply removing the operator from the CNC is insufficient.

## Independent learning/evaluation status

Public paper cases are for study, not blind scoring. Hidden answers, external evaluator records, independent validation, material test data, physical machine witnesses and external safety competency remain **NOT RUN / UNKNOWN**. No laboratory simulation, build, Actions dispatch or physical dust test is justified by this document.
