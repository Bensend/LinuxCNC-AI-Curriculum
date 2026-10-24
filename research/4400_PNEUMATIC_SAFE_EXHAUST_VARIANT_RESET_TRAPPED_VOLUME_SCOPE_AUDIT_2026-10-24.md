# 4400 — Pneumatic safe-exhaust scope, connector variant, fault memory and trapped-volume source audit
Date: 2026-10-24 UTC. Status: **original documentary research / NOT machine validation**.
Session UTC start: 2026-10-24T03:34:27.998Z. Primary priority remains the LinuxCNC/OpenPressBrake safety course; this is an unblocked cross-machine 4400 safety branch, not new 3000 specialization work.

## Concrete engineering question

Can a monitored pneumatic dump valve's safe-exhaust indication, component PL claim or deliberate reset be used to assert that a clamp, robot gripper, press accessory or automated cell is safe to enter, service and restart? **No such machine-level proposition follows from the device claim alone.** The location of the final element, all downstream check/isolation paths, load response when pressure is lost, and actual restart authority must be traced independently.

## Sources inspected and evidence scope

1. **Festo, _Soft-start/quick exhaust valves MS-SV, MS series_, 2023/05**, manufacturer-hosted catalogue PDF: https://www.festo.com/media/pim/796/D15000100122796.pdf. Particularly PDF pp. 3, 32–35, 50–51 (page labels vary by viewer). **DOC-CONFIRMED** as a manufacturer datasheet; not an as-built OpenPressBrake drawing.
2. **ROSS Controls, DM2C Series C product page**, retrieved 2026-10-24: https://www.rosscontrols.com/en/series/1295-dm2c-series-double-valve. **DOC-CONFIRMED** for manufacturer's published product descriptions and catalog-scoped fault/feedback behavior.
3. **ROSS Controls, RC-DMC-OI operating-instructions landing page**: https://www.rosscontrols.com/en/documents/259/dm-series-c-valves-operating-instructions; and **SS301 installation-instructions landing page**: https://www.rosscontrols.com/en/documents/74/dm2-series-c-valves-installation-instructions. **DOC-CONFIRMED** for manufacturer-published page statements on DM1 versus DM2 fault reset, anti-tie-down and press clutch/brake limitation. The linked downloadable PDF bytes were **not independently inspected in this session**; do not cite a PDF-only diagram, wiring detail or acceptance criterion as verified.
4. **OSHA 29 CFR 1910.147**, official regulation: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147, especially (b) definition of energy-isolating device; (d)(3)–(6) isolation, stored energy and verification; (f)(1) temporary test energization. **DOC-CONFIRMED** for the U.S. general-industry rule within its scope, not a universal design standard or declaration of legal applicability to every machine/jurisdiction.

No new LinuxCNC code or actual pneumatic hardware was inspected. **SOURCE-CONFIRMED**: none newly claimed. **TEST-CONFIRMED**: none. **COMMUNITY-REPORTED**: none relied on. **UNKNOWN**: selected devices, circuit topology, actuator/load behavior and safe-state witness.

## Manufacturer-specific traps — preserve exact product and edition

| ID | Source-confirmed proposition | Invalid shortcut / consequence | Status |
|---|---|---|---|
| PN-01 | Festo MS6-SV-...-E-10V24 datasheet lists exhausting and avoidance of unexpected pressurisation as its safety functions, with component/system-conditional high integrity claims. | A component's published PL/SIL is not an achieved machine safety function or proof that a downstream cylinder chamber has vented. | DOC-CONFIRMED |
| PN-02 | Festo explicitly restricts downstream components to ones that do **not** impair safe exhausting; it recommends a specific exhaust silencer to avoid back pressure. | A check valve, trapped chamber, blocked/replaced muffler, quick coupling or added regulator may break the intended pneumatic boundary. Their actual effect is a design-specific **INFERENCE/UNKNOWN**, not a proven failure on this machine. | DOC-CONFIRMED + INFERENCE |
| PN-03 | The 2023/05 Festo catalogue says MS6-SV-D **and** MS6-SV-E are **not approved for use as a press safety valve**. | Do not select the product as a press safety final element merely because its PL label is high. Nor generalize this restriction to all Festo products or all non-press auxiliary uses. | DOC-CONFIRMED |
| PN-04 | Festo MS6-SV-E uses the selected NECA interface; **MP3** monitors EN1/EN2 transition/cross-circuit conditions in the stated static opposite-potential configuration, while **MP5** does not itself detect a cross-circuit and requires appropriate external monitoring. MP1 has a different clocked/static interface. | Same valve body + different NECA suffix is not a safety-equivalent replacement. Do not invent universal test-pulse widths, wiring or diagnostic coverage. | DOC-CONFIRMED |
| PN-05 | Festo notes the mechanical valve system is not tested while held pressurised; the 2023/05 catalogue specifies a forced switching frequency at least monthly for this family. | Continuous READY status is not proof that the exhaust function has been exercised recently. Actual test cadence and safe method require the selected revision and risk assessment. | DOC-CONFIRMED |
| PN-06 | ROSS DM2C is a dynamically monitored redundant pneumatic valve; a detected element mismatch latches it in a faulted state. Manufacturer describes manual/electrical solenoid reset and a status switch reporting **ready/locked-out**, not downstream actuator position. | A ready signal does not prove air has vented everywhere or the load cannot move; a reset is not a fresh machine-cycle START. | DOC-CONFIRMED |
| PN-07 | ROSS manufacturer's RC-DMC-OI page distinguishes **DM1 Series C automatic fault reset** from **DM2 Series C latched fault requiring deliberate reset**; DM2 reset requires both main solenoids de-energised (anti-tie-down). | A visually similar Series C substitution can change restart semantics. Do not mistake anti-tie-down of valve pilots for whole-machine occupancy or deliberate restart protection. | DOC-CONFIRMED |
| PN-08 | ROSS explicitly excludes **DM Series C** from press **clutch/brake** control, directing users to a different Series D family. | A mechanical-power-press clutch/brake restriction is not a complete hydraulic-press-brake safety analysis; neither family can be substituted without exact manufacturer approval and selected design proof. | DOC-CONFIRMED |
| PN-09 | OSHA treats line valves as possible energy-isolating devices and explicitly excludes ordinary control buttons from that definition; residual/reaccumulating energy must be relieved, restrained or otherwise made safe and isolation verified. | Safety-valve electrical dropout, safety relay reset and an HMI zero-pressure indication do **not** substitute for lockable physical isolation and zone-specific verification during servicing. | DOC-CONFIRMED |

### Evidence boundary that matters most

**Valve exhausted != all hazardous energy removed.** A downstream nonreturn valve can retain one actuator chamber while another vents; a spring or gravity-loaded cylinder can move *because* air is exhausted; a vacuum cup may release a load when supply disappears; an accumulator or separate branch can re-pressurise the protected volume. These are **INFERENCE** generic failure paths pending selected circuit and load analysis. No specific check valve, stored volume, spring, vacuum line or air accumulator has been established on OpenPressBrake.

**Feedback proposition:** Festo/ROSS component indication can support the exact component state claimed in its manual, within validated wiring. It is not an independent measurement of pressure in each downstream trapped volume, mechanical load support, access-zone occupancy, or an acceptable machine stopping distance.

## Authority and physical-energy chain (illustrative, NOT a circuit)

`Guard / E-stop / access request -> independent safety logic -> qualified pneumatic final element(s) -> protected air zone -> actuator/load response -> physical witness`.

Separate `LinuxCNC/HAL/FPGA -> ordinary valve/sequence requests and diagnostics` from safety authority. The independent safety system must remain effective if the LinuxCNC PC, FPGA, network or normal command output fails high or stops updating. **Physical** upstream lockable air isolation, branch-specific bleed/test provision and independent mechanical restraint belong to the maintenance energy-control plan; they are not software bits.

For each selected zone create a trace `ENE -> HAZ -> SF/SRS -> AUTH/ARC/DEP -> PHY -> VAL/PT -> CHG`:
- Name the **actual** valve full model, connector/NECA or reset variant, documentation edition and intended safety function.
- Draw every path from supply to actuator chambers and exhaust, including bypasses, check valves, accumulators, vacuum generators, quick couplers, silencers and parallel branches.
- Describe **what moves when air is lost**, not just what happens to pressure. Include suspended tooling, clamps, robot grippers and gravity/spring return.
- Identify physical measurement locations and independently qualified safe-state witnesses; valve feedback alone is insufficient.
- Separate protective stop/reset, intentional fresh production START, and maintenance LOTO/return-to-service.
- Check whether muffler replacement, service-unit reorder, connector swap, branch addition or software restart invalidates earlier evidence.

## Adversarial failure-path matrix (paper only)

| Hypothesis | Misleading positive indicator | Discriminator / required evidence | Safety disposition |
|---|---|---|---|
| Downstream check valve retains a cylinder chamber | Exhaust valve indicates deenergised | As-built chamber/line routing and independent zone pressure proof | `PHY-ENERGY UNKNOWN`; block service |
| Clamp releases a suspended part on exhaust | Outlet pressure falls | Mechanical holding/part-retention analysis and physical witness | `PHY-LOAD UNKNOWN`; block exposure |
| Exhaust silencer is blocked/replaced | Correct valve command/status | Manufacturer-approved exhaust path and actual performance proof | `VAL/PT NOT RUN` |
| MP5 used where MP3 diagnostic assumption was credited | Healthy Festo body/status | Exact NECA suffix and upstream short/cross-fault diagnostic allocation | `DEP/ARC STALE` |
| DM1 replaces DM2 | Both appear to vent on command | Exact suffix and fault reset/rearm comparison | `CHG`; no equivalence |
| DM2 fault reset occurs with pending ordinary command | Valve READY after reset | Independent local deliberate START edge and stale-command invalidation | `AUTH/VAL UNKNOWN` |
| Compressor isolated, trapped branch reaccumulates | Main line gauge reads zero | Qualified zone-specific pressure/isolation proof over required service period | `PHY-ENERGY UNKNOWN` |
| Press-clutch application assumes high-PL exhaust valve sufficient | PL e printed in catalogue | Manufacturer explicit application restriction and machine-specific SRS | `BND/ARC REJECT` |

## Practical human-factors engineering

Provide a labelled, padlockable **upstream** air isolator, accessible protected bleed/test points for each relevant zone, readable pressure indicators where they are actually meaningful, a clean exhaust/silencer service route, clear mechanical supports/part restraints and a visible local deliberate-restart station. Avoid requiring a technician to loosen fittings, defeat a guard or reach into an actuator's travel to establish zero energy. Guard and silencer replacement should restore the original safety function by default, with keyed/obvious connectors and documented equivalence checks. Treat a shortcut-inducing layout as a design defect to fix, not merely a training issue.

## Explicit non-conclusions / next evidence

- **UNKNOWN:** Whether OpenPressBrake uses any pneumatic safety valve or has auxiliary pneumatic/vacuum loads. This research transfers as a generic 4400 safety lesson for saws, feeders, mills, robot cells and press-brake accessories, **not** as a selected Y1/Y2 hydraulic safety circuit.
- **UNKNOWN:** Actual pressure decay, retained pressure, load fall/release, diagnostic coverage, safe stopping distance/time, PL/SIL achieved, and performance after muffler/connector change. No numerical limits or test outcomes invented.
- **NOT RUN:** all physical `VAL/PT`, simulation, self-hosted lab and external fresh evaluation. Paper exercise in companion field card is not a scored competency.
- **Next:** Obtain selected machine's pneumatic/vacuum existence, exact component/suffix and as-built zone/load/energy drawing before designing any hazardous tests. For OpenPressBrake the higher-priority Y1/Y2 hydraulic and safety-relay physical evidence remains missing; do not displace it with speculative pneumatic hardware.

**Information-gain decision:** OEM documents answer the variant/reset/application-scope question. No lab is justified to re-prove published component behavior; only selected hardware and qualified independent physical validation could resolve machine-specific questions. Preserve 4400-HY-01 and 2520–25F0 external evaluation gates as OPEN.