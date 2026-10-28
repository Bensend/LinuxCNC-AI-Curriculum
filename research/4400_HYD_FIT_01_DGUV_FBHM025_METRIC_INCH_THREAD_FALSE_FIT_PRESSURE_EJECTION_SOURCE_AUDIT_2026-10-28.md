# 4400 HYD-FIT-01 — A hydraulic fitting that threads in is not pressure-safe
**2026-10-28; original DGUV/IFA maintenance hazard source audit, NON-GRADUATED.** No selected OpenPressBrake fitting or pressure test.

## Why this branch and what is already known
Predecessor [HOSE-ROUTE-01](4400_HOSE_ROUTE_01_GATES_2025_HOSE_ASSEMBLY_ROUTING_CLAMP_TWIST_SERVICE_PROVENANCE_AUDIT_2026-10-26.md), HYD-SURGE-01, INJ-01 and HYD-DYN-01 cover hose twist, transient pressure, injection, whip and arrest. They do **not** establish the **distinct, deceptively hand-assemblable thread-mismatch failure**: two different port/stud standards can screw together without stripping, yet have dangerously inadequate pressure retention. This is a high-value maintenance human-factor failure because normal hand-feel can positively mislead a rushed repairer.

## Direct original safety-body document
[DGUV Fachbereich Holz und Metall, FB HM-025, edition **09/2017**, “Hydraulikverschraubungen — Verwechselungsgefahr zwischen metrischen und zölligen Gewinden”](https://dguv.de/medien/fb-holzundmetall/publikationen-dokumente/infoblaetter/infobl_deutsch/025_hydraulikverschraubung.pdf). **DOC-CONFIRMED**: original **3-page** PDF text and page images **pp.1–2 directly inspected**. It superseded a 09/2014 issue. Published by DGUV Fachbereich Holz und Metall, with IFA participation. The document reports that historical thread confusions have caused accidents; it does **not** provide a case-specific incident count or establish any particular OpenPressBrake fault.

**Exact example from original pp.1–2:** an inch-family **G 1/2** male stud can screw into a metric **M22×1.5** female port almost normally, without visibly damaging either thread. DGUV says the mismatched joint does not remotely withstand intended working pressure and may eject suddenly, launching components and hydraulic fluid. Other size pairs are shown in original tables; **do not treat any listed pair as an approved interchangeable adapter**. This is an *example of a dangerous false fit*, not a statement that the two have equivalent pressure ratings.

The document attributes the problem to visually similar diameters and often absent manufacturer thread markings. It distinguishes ISO **1179** inch-family pipe-thread connections and ISO **9974** metric-family connections, and discusses marked ISO **6149** metric O-ring port/stud practices. It recommends reducing the number of fitting series in a machine, unambiguous identification/marking, controlled purchasing/specification, and training designers, maintainers and operators. These are **2017 DGUV recommendations**, not proof of the current exact wording or legal applicability of ISO 4413/6149/1179/9974 editions.

## Why pressure-testing the repaired fitting is not the first answer
**INFERENCE:** A technician who can hand-tighten a fitting, observe a dry static gauge, or run a pump briefly may conclude the repair is correct. Those observations cannot identify thread form/pitch/seal geometry or establish joint pull-out resistance and transient pressure performance. A live proof test itself can launch the stud or inject fluid. See [existing HYD-SURGE-01](4400_HYD_SURGE_01_PARKER_GS4_PEAK_PRESSURE_GAUGE_BLIND_SPOT_AND_TEST_RIG_SAFETY_SOURCE_AUDIT_2026-10-28.md) and its HSE GS4 test-fixture hazards. **No generic live pressure test is recommended**; identify the parts from controlled drawings/port standards and qualified inspection while safely isolated.

## Practical safe-by-default repair architecture (INFERENCE)
- **One connection series where practicable:** standardize selected machine ports and stocked replacements. For mixed-series legacy equipment, maintain a simple **as-built port map** by location with port/stud standard, exact SKU, approved adapter and pressure rating; keep the map next to spares and in controlled service instructions.
- **Mark physically, not by memory:** durable port/connector identification and labeled approved kits; the original DGUV recommends metric grooves/stamped marks analogous to ISO 6149 and clearly different identification for inch-family parts. Do not improvise marks that could weaken pressure-retaining parts; use manufacturer-approved identification methods.
- **Design against easy mistakes:** physically segregate bins, use keyed/uniquely identified assemblies where possible, require positive verification of both mating parts, thread pitch and seal type from drawings/measurement rather than “it starts by hand”. Do not trust a supplier part title alone.
- **Make the safe repair quicker:** keep exact replacement kits, short illustrated identification chart, proper tooling and isolation steps at the machine. If obtaining the right fitting is so difficult that operators adapt a near-fit, fix the inventory/procurement design.
- **After any substitution:** create **CHG**, mark affected pressure integrity and physical energy/holding witnesses **STALE**, and require qualified requalification before personnel exposure. A fitting can be upstream of a safety-related hydraulic hold circuit even if it is not itself an electrical safety device.

## Adversarial evidence map
| Proposition | Required evidence | Wrong shortcut |
|---|---|---|
| **DEP-FIT-01** exact port/stud standards | Manufacturer port drawing, actual component marking/measurement, approved fitting SKU, seal and rated assembly | “Threads in smoothly” |
| **ENE-FIT-02** pressure and stored energy | As-built zone map, isolated chambers/accumulators, residual energy and secondary ram restraint | Zero pressure at a different gauge |
| **ARC-FIT-03** mechanical retention under selected envelope | Qualified rated compatible connection and manufacturer installation procedure | Catalog pressure of one constituent or brief pump-on |
| **HF-FIT-04** predictable wrong-part selection | Marking, spares, operator/service access and mix-up prevention | Training alone with mixed unmarked bins |
| **CHG/PHY-FIT-05** post-repair release | Signed part identity and change record, independent qualified safe pressure/hold witness where justified | Dry fitting, reset or green HMI |

**UNKNOWN:** actual OpenPressBrake thread families, exact hydraulic ports, working/transient pressure, installed hose and valve arrangement, gravity holding, Pilz/AKAS safety program, independent evaluator. No actual thread mismatch is asserted. **TEST-CONFIRMED none**. No pressure test, live leak check, simulation, workflow or GitHub-hosted/self-hosted compute. G0/G1 **HOLD**, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.

## Reopen
Qualified restricted [Stage A IN-01..10](../safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) with exact fitting/port drawing and independent hydraulic/physical evaluator. Otherwise rotate to an unrelated open safety module rather than inventing a pressure rating, leak threshold or another unscored test bank.
