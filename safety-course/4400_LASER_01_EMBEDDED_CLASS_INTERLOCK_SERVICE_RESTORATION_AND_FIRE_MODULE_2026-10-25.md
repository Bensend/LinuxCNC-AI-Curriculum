# 4400-LASER-01 — Laser enclosure, embedded source, service restoration and fire
**2026-10-25 | 4000 safety | LEARNER-READY / NON-GRADUATED | NO LIVE OR BLIND TEST**

## Learning objective and prerequisites
Teach a LinuxCNC integrator to distinguish **source emission**, **accessible product class**, **guard optical integrity**, **interlock input**, **independent beam-inhibit final element**, **physical beam containment**, **fume capture**, **fire control** and **maintenance isolation**. Prerequisites: 2520 hazard-to-SRS, 2530 E-stop, 2540 relays/final elements, 2590 guarding, 4400-GUARD-01 anti-defeat, 4400-DUST-01 extraction command/capture boundary, 4400-PEDAL-01 fresh start.

Read the [exact manufacturer/OSHA/LinuxCNC source audit](../research/4400_LASER_CLASS_EMBEDDED_SOURCE_INTERLOCK_SERVICE_BYPASS_AND_FIRE_OEM_AUDIT_2026-10-25.md) before assuming one machine's class or service mode transfers to another.

## Hazard map: different failure consequences
| Hazard | Physical source | Independent control / witness needed | Invalid shortcut |
|---|---|---|---|
| Eye/skin exposure | direct, reflected or diffuse laser beam; wrong optical path | appropriate rated enclosure/window, qualified beam isolation/shutter and accessible-emission assessment | lid LED green; CNC 'laser off' |
| Fire/smoldering | ignition of stock, scraps, deposits | material/fire risk review, observation/detection/response and post-stop checks | beam request zero implies no fire |
| Toxic/corrosive fumes | laser/material reaction and extraction failure | approved material inventory and effective capture/exhaust evidence | exhaust motor commanded ON |
| Electric shock | laser PSU/high-voltage storage | qualified isolation and verified residual energy controls | E-stop or unplugging one signal cable |
| Unexpected motion | CNC axes/gantry while service access exists | selected axis stop/access protection | beam shutter closed implies axes stopped |
| Restart after service | retained program/output, wrong guard, leftover override | qualified restoration, independent protective inhibition and fresh start | reset/closing cover itself restarts |

**Different stop authorities:** stopping axes, preventing optical emission, maintaining extraction for smoke control and safely isolating stored electrical energy may need **different** final elements and sequencing. Do not assume E-stop means instantaneous removal of all utilities or that continued extraction is universally correct during fire; selected design and emergency response govern.

## Original-source discriminator
- Boss LS **855-901 Rev 006 (2024)** labels its LS product a Class IV CO2 laser machine, describes two hood interlocks and warns of fire and alignment escape. These are **OEM claims for one family**, not proof of a selected retrofit's safety integrity.
- Trotec official FAQ distinguishes enclosed Class 2 products and some Class 4 hatch configurations. **An embedded hazardous source is not automatically the same as accessible machine class.** Actual configuration, aperture, service mode and optical path matter.
- Boss **WI-855-407 Rev 002** service troubleshooting contains temporary bypass-based diagnostics, with a restoration warning. **This is evidence of a service/restoration hazard, not permission or a generic bypass recipe.** This course deliberately omits connector/pin instructions.
- LinuxCNC M62/M63 are queued until subsequent motion; M64/M65 are immediate ordinary digital output requests. Neither semantics nor HAL status proves independent beam isolation. Source-level trace is a promoted optional task if a concrete LinuxCNC implementation discrepancy emerges; no synthetic lab justified now.
- OSHA laser guidance is useful scope evidence; ISO 11553-1:2020 publisher scope addresses laser radiation. **Full ISO normative clauses were not reviewed**; never invent eyewear OD, NOHD, shutter time, safety PL or optical enclosure rating.

## Abstract architecture, NOT a wiring diagram
**Normal:** G-code -> interpreter/Task -> motion digital output -> ordinary laser process request and UI diagnostics. This path is **not** a personnel-safety authority.

**Safety-related:** selected guard/entry channels and relevant diagnostics -> independent evaluated safety function -> verified beam isolation/shutter/power-inhibit final element. The selected design must define how to detect dangerous faults, prevent stale-command restart and verify that hazardous accessible radiation is prevented. A shutter-closed indicator alone is not an optical leakage measurement.

**Physical:** enclosure panels, windows, apertures, reflections, beam path, emission source and stored electrical energy; these are physical witnesses and maintenance controls, not just Boolean states.

**Process/environment:** extraction/capture, material restrictions, smoke/fire observation and response, chiller and air assist. Their failure consequences and interlocks must be separately justified; do not automatically classify a water-flow permissive as a personnel-safety channel.

## Five invariants for review
1. A closed lid contact never substitutes for actual optical containment, and a green CNC output never substitutes for a qualified beam-inhibit path.
2. A service override, diagnostic connector or substituted guard component makes the affected proof **STALE** until restoration and revalidation.
3. Closing a cover, restoring mains power, clearing E-stop or resetting a diagnostic must **not by itself** emit the laser or start hazardous axes; require a selected deliberate fresh start.
4. Optical safe state, axis safe state, fume safe state, fire state and electrical maintenance-isolated state are **separate propositions**.
5. No ordinary LinuxCNC/FPGA motion or M-code path may be the sole means of personnel laser protection.

## Adversarial review cases
**A — Green lid / cracked window.** Optical barrier damaged but both switches indicate closed. Status is insufficient; physical barrier replacement and selected optical verification needed. Do not expose personnel to a test beam.

**B — Temporary service bypass forgotten.** Guard is physically openable while control reports ready. Stop commissioning, isolate, restore per qualified procedure, reconcile version/configuration and obtain independent revalidation before normal operation.

**C — M62 command queued but no next motion.** LinuxCNC docs say no output transition until next motion; never use this queue as a safety beam-off mechanism. A separate safety demand must physically inhibit emission independent of motion scheduling.

**D — Chiller healthy, smoke visible.** Coolant status does not establish extraction/capture or fire safety. Stop work safely and follow qualified emergency procedure, with people excluded from the beam/fire zone.

**E — Material substituted mid-job.** Material ID and fire/fume hazard assumptions become stale; do not treat unchanged G-code as permission to process a new stock.

**F — Power restored while process request high.** Independently prevent emission and axis motion until qualified reset and a new deliberate command; a power-good LED does not establish this.

## Low-friction protection and minimum operating threshold
Prefer convenient fully enclosed operation, viewable diagnostics, service-friendly non-emitting checks, accessible filter maintenance, captive guard hardware, clear safe material list, unambiguous override status and restoration sign-off. Do **not** publish or teach live interlock bypass as a quick fix. A workflow that rewards leaving the cover defeated is a human-factors defect.

If qualified optical containment, independent emission inhibition, safe access and restart, fire/fume controls or isolation are not established for the actual laser machine, **no people-exposed hazardous operation**. Any research with a real Class IV source requires a separate qualified laser-safety-controlled area and approved isolation/remote plan with personnel outside the danger zone; this module grants **no** energized test authority.

## Evidence, transfer and graduation
[Paper technician scenarios](4400_LASER_01_OPTICAL_ENERGY_SERVICE_RESTORATION_TECHNICIAN_CARD_2026-10-25.md) and [no-energy restoration audit](4400_LASER_01_NO_ENERGY_GUARD_RESTORATION_AND_FRESH_START_REVIEW_2026-10-25.md) are learning tools, not physical proof. [External handoff](../evaluation/4400_LASER_01_FRESH_EMBEDDED_CLASS_AND_SERVICE_RESTORATION_HANDOFF_2026-10-25.md) is PREPARED / NOT RUN.

**Evidence classes:** DOC-CONFIRMED exact manufacturer/OSHA/official LinuxCNC documentation; INFERENCE architecture/invariants; SOURCE-CONFIRMED none newly traced; TEST-CONFIRMED none; COMMUNITY-REPORTED none used; UNKNOWN any selected installation/class/shutter timing/guard performance/optical leakage.

**Promotion:** exact selected laser machine optical path, qualified source class and product classification, guard variant, service authority, beam-inhibit final element, physical emission containment and independent evaluation. These block machine-level safety release and module independent competency graduation; not a reason to fabricate test numbers. No laser equipment is claimed on OpenPressBrake.
