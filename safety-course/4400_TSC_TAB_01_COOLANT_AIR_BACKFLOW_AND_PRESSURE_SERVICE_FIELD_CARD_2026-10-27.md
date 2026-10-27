# 4400-TSC/TAB-01 — High-pressure coolant / through-tool air: one-page technician decision card
**2026-10-27 | documentary teaching tool; NOT RUN; NOT a live test instruction**

**Question:** The control says “TSC OFF,” the TAB pressure input looks normal and the spindle is stopped. May a technician loosen a high-pressure coolant hose, check valve or TAB air line?

**Answer: No.** Those are *normal-control and sensor propositions*, not verified physical isolation. The exact Haas TSC/TAB variants include different coolant/air check valves, a pressure sensor connected through a small elbow slot, pump priming, relief and bypass paths. A pressure reading or OFF bit cannot establish the safe state of every service zone.

## Read the three physical boundaries
| Boundary | OEM evidence | Unsafe shortcut | What must be verified before exposure |
|---|---|---|---|
| Coolant into air | Haas TG0145 Rev C describes a failed TAB air check valve allowing coolant to travel into the CALM air line and out its muffler. | “Air blast OFF means air plumbing is dry.” | Installed valve and line identity; actual coolant-to-air separation and safely routed discharge. |
| Air into coolant | In the **spring-and-ball** design, a trapped ball can allow TAB air to flow into coolant tank; bubbling/overflow can result. | “Coolant pump OFF means tank cannot be pressurized by air.” | Check-valve design, physical condition, isolation of **both** energy sources and containment. |
| Sensor versus flow | In the **shuttle-and-ball** design, a slotted elbow deliberately transmits pressure to the sensor; pressure also depends on tool opening and relief bypass. | “Green pressure proves tool-tip flow, or zero pressure everywhere.” | As-built sensor tap, actual tool/relief path, and independent verification of all exposed zones. |

**Scope traps:** The manufacturer identifies VF-1..VF-5 machines built 2023-03-15 to 2023-05-19 as a particular slotted-elbow applicability group. Its TAB alarm threshold also changes with firmware 100.22.000.1000+. Neither a part number, firmware value nor alarm trip point is a safety certification. Haas M88/M89 and M73/M74 are **OEM-specific**, not standard LinuxCNC M-codes; a LinuxCNC retrofit needs its own verified output and isolation architecture.

## Practical shop handoff (existing records, no energized work)
Identify the machine and selected TSC/TAB option; trace pump electrical feed, air supply, check-valve types, sensor tap, purge, relief, bypass and service openings from the **as-built** documents. Separate routine guarded tool changes from filter/valve/hose servicing. Give maintainers a reachable, labeled, lockable way to isolate *both* relevant sources and verify pressure at the service point without standing in a jet path. Preserve approved replacement part numbers and easy-to-use guards. If the procedure forces technicians to bypass a guard or open pressurized fittings to diagnose a problem, redesign the access/diagnostic method.

**Do not use this card to run a pressure test, defeat an interlock, open a pressurized line or energize a machine with people in the hazard zone.** A qualified machine team must write and validate any physical test plan separately, with independent physical witnesses and appropriate exclusion/restraint.

## Restricted conditional evidence, only if the selected machine has TSC/TAB
**TSC-1** exact installed identity; **TSC-2** two-media/pressure-zone topology; **TSC-3** normal versus independent safety authority; **TSC-4** lockable isolation and independent pressure verification; **TSC-5** valve variant/firmware/change-control; **TSC-6** guard/tool-release/service and fresh restart. All **UNKNOWN/NOT RUN**; use existing [Stage A](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) and conditional Stage B, **not another owner questionnaire**.

**Provenance:** [full OEM/OSHA/LinuxCNC audit](../research/4400_TSC_TAB_01_HAAS_COOLANT_AIR_CHECK_VALVE_BACKFLOW_PRESSURE_WITNESS_SOURCE_AUDIT_2026-10-27.md). Manufacturer [TG0145 Rev C (2025-10)](https://legacy-aem.haascnc.com/service/troubleshooting-and-how-to/troubleshooting/through-tool-air-blast--tab----troubleshooting-guide.html), [AD0086 (updated 2020-10-06)](https://haascnc.com/service/troubleshooting-and-how-to/how-to/hpc-1000-tsc-1000---operator-s-manual-supplement), [OSHA §1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147). **DOC-CONFIRMED** product-specific mechanisms; **INFERENCE** cross-media failure-path consequence; **UNKNOWN** selected-machine proof. No test/evaluator/compute; OpenPressBrake G0/G1 HOLD.
