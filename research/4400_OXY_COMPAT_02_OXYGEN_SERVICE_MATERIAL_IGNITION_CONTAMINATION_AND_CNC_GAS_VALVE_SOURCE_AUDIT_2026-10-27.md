# 4400-OXY-COMPAT-02 — oxygen-service ignition, materials compatibility and maintenance contamination

**2026-10-27 UTC | DOCUMENTARY SOURCE RESEARCH ONLY | NON-GRADUATED | NO OXYGEN HARDWARE TEST**

## Predecessor and exact information gain

Directly scanned the full canonical `safety-course/SAFETY_COURSE_INDEX.md`, `SAFETY_COURSE_RESEARCH.md` and historical `PROGRESS.md` for `oxygen cleanliness`, `oxygen service`, `adiabatic`, `oil-free`, `grease`, `particle impact` and `oxygen ignition`; **zero matches before this branch**. The new [OXYFUEL-01 backflow/flashback study](4400_OXYFUEL_01_BACKFLOW_FLASHBACK_ARRESTOR_CNC_GAS_ISOLATION_SCOPE_SOURCE_AUDIT_2026-10-27.md) mentions the **no-oil/grease** precaution but does not analyze the *oxygen system itself as a fire-propagation environment*, oxygen-compatibility of replacement components or the kindling chain. Existing WELD-GAS-01 is about **oxygen deficiency** from inert gas, the opposite atmospheric mechanism. Classify as **new material/ignition compatibility mechanism plus source-depth transfer**; not a new general CNC E-stop lesson.

## Original authoritative source ledger

| ID | Evidence and edition | Supported fact | Limit |
|---|---|---|---|
| OC-1 | **DOC-CONFIRMED direct**, NASA White Sands Test Facility, [Oxygen Compatibility Assessment and Hazards Evaluation](https://www.nasa.gov/centers-and-facilities/white-sands/oxygen-compatibility-assessment-and-hazards-evaluation/), published **2016-06-15**, page last updated 2023-08-16, directly inspected 2026-10-27 | Assessment begins with **worst-case oxygen concentration, temperature, pressure, flow and contamination**; then material flammability, ignition mechanisms, **kindling chain** and consequences. Thin sections, fine mesh and sintered filters may ignite more readily than bulk metal. | NASA general oxygen-system methodology; not a machine-specific approved material, oxygen cleanliness class, flow/pressure limit, or selected gas-valve qualification. |
| OC-2 | **DOC-CONFIRMED direct original NASA technical-report abstract**, [Guide for Oxygen Hazards Analyses on Components and Systems, NASA-TM-104823](https://ntrs.nasa.gov/citations/19970001787), published **1996-10-01**, metadata/abstract inspected 2026-10-27 | Oxygen-enriched conditions lower ignition resistance and increase burning intensity; **lubricants, tapes, gaskets, fuels and solvents** can worsen ignition. A systematic hazard analysis precedes introducing materials/components into oxygen service. | **Abstract/metadata inspected; full PDF NOT inspected.** Do not attribute detailed ignition tests or thresholds to uninspected pages. |
| OC-3 | **DOC-CONFIRMED direct**, US [eCFR 29 CFR 1910.253](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-Q/section-1910.253), directly inspected 2026-10-27; Title 29 displayed through 2026-10-23 | §(d)(3)(vii) requires oxygen piping/fittings cleaning to remove grease/dirt with oxygen-compatible cleaning agents; §(d)(3)(ii),(viii) specifies **oil-free** air/nitrogen/CO2 for oxygen piping blowout; §(e)(6)(iii) oxygen regulator gauges marked **USE NO OIL**. | Clause scope is oxygen piping/regulators; **not** a permission for an unqualified user to improvise solvents, purge sequences or oxygen-system cleaning. |
| OC-4 | **DOC-CONFIRMED direct**, UK [HSE Welding and flamecutting](https://www.hse.gov.uk/mvr/mechanical-repair/welding.htm), section “Safeguards for flammable gas cylinders,” inspected 2026-10-27 | Do not apply oil, grease or other lubricants to oxygen fittings; use correct gas-specific equipment and qualified inspection. | UK guidance, not proof of a selected oxygen valve material, seal compatibility, or installed system. |
| OC-5 | **DOC-CONFIRMED direct**, original ESAB [Combirex PRO CNC oxy-fuel machine](https://esab.com/us/nam_en/products-solutions/product/cutting-automation/cutting-machines/combirex-pro/) | A real CNC cutting product uses electronic **proportional gas control** for preheat and cutting oxygen. | Product description does not specify oxygen-wetted internal valve materials, cleaning, contamination history or safety qualification. |

## A different failure path from flashback

**Flashback path:** a flame propagates backward from a torch through gas path; check valves and flashback arrestors have separate physical functions (OXYFUEL-01).

**Oxygen-service ignition path:** oxygen-wetted valve, fitting, regulator, seal or filter contains a susceptible material/contaminant; pressure/flow/temperature and a credible ignition mechanism initiate local combustion; the **kindling chain** propagates fire to adjacent materials or components. **DOC-CONFIRMED NASA** supports the physical framework, not the presence of a fault in any selected machine. **INFERENCE:** a generic pneumatic proportional valve, lubricant, replacement seal, pipe thread tape, cleaning solvent residue or damaged filter used without oxygen-service qualification could create a new ignition risk even if gas check valves/arrestors are present.

**Critical distinction:** oxygen is an oxidizer; “no fuel-gas leak” and “torch extinguished” do not prove oxygen-wetted components are compatible. Conversely a rated oxygen-compatible component does not prove personnel access, line depressurization, guard status or a complete gas-system safety function.

## Transfer to ordinary CNC, safety authority and physical proof

| Authority / physical layer | Evidence or action | What it cannot prove |
|---|---|---|
| Normal LinuxCNC/FPGA/ordinary PLC | Requests preheat/cutting oxygen and electronic valve profiles, reports commanded valve state. | Materials compatibility, oxygen cleanliness, flame prevention, physical isolation, safe access. |
| Diagnostics | Can show selected pressure/flow, faults and service status if correctly instrumented. | Absence of internal ignition hazards or that an unobserved contaminant is absent. |
| Independent safety system | Can demand selected approved gas isolation, ignition inhibit, guarded motion stop and fresh start when validated. | That oxygen-service materials, filters, seals and cleaning were qualified or that residual oxygen/heat is absent. |
| Physical equipment / process | Oxygen-compatible approved valves, seals, lubricants (if any), materials, cleanliness process, regulator, isolation and inspection records. | Whole-machine safe state without the actual gas/guard/fire/access proof. |

**Conditional change event (INFERENCE):** maintenance replaces a proportional valve with an electrically equivalent generic part. The CNC commands and pressure graph may still look correct, yet the new oxygen-wetted seals, lubricants, filter and contamination history are **UNKNOWN**. This is a **safety-significant materials/maintenance change**, not a software-only substitution. Require OEM oxygen-service compatibility review, documented cleaning/handling and qualified revalidation before restoring oxygen service. No on-machine oxygen ignition or pressure test is proposed.

## Selected-machine evidence/witness and human factors

| ID | Existing qualified record needed | Status |
|---|---|---|
| OX-1 | Confirm oxygen supply, pressure/temperature/flow range, oxygen concentration, duty cycles and actual wetted parts for every branch. | **UNKNOWN** |
| OX-2 | OEM-approved valve/regulator/hoses/seals/filters, material/oxygen-service compatibility and contamination/cleanliness history for the selected conditions. | **UNKNOWN** |
| OX-3 | Maintenance substitution and cleaning controls: correct labeled spares, protected caps, no cross-use of grease/oil, approved service process, change log and competency. | **UNKNOWN** |
| OX-4 | Qualified ignition/kindling/consequence assessment and independent physical gas isolation/guard/thermal/restart evidence; links to OXYFUEL OF-1..5. | **UNKNOWN / NOT RUN** |

**Human factors:** make oxygen-service-only spare parts, labels, capped clean fittings and correct maintenance kits easier to access than a visually similar general-purpose valve or “just a little grease.” Make the physical change trigger a mandatory review rather than relying on an operator to remember a warning. A flashback arrestor is not a substitute for oxygen compatibility.

**Safety threshold:** where essential oxygen-service component/material and isolation hazards are unqualified, do not operate with people exposed. Any necessary engineering investigation must be separately designed for isolated/remote work by qualified personnel; this curriculum does not authorize live oxygen, ignition, contaminant or pressure tests.

## Status and next evidence

This is **DOC-CONFIRMED** source-level methodology for the exact NASA/OSHA/HSE evidence; it is **not TEST-CONFIRMED**, not a certified safety design and not a physical OpenPressBrake finding. No selected oxy-fuel machine or oxygen service on OpenPressBrake has been established. **All OX-1..4 UNKNOWN/NOT RUN; G0/G1 HOLD; independent 2520–25F0 evaluator OPEN.** No hosted/local compute.
