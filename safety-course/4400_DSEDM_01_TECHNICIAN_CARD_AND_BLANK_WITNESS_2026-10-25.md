# 4400-DSEDM-01 technician decision card — oil dielectric, fire and power-on
**16 learner-visible PAPER cases | 2026-10-25 | NOT EXECUTED / NOT SCORED**

Use the [module](4400_DSEDM_01_OIL_DIELECTRIC_FIRE_LEVEL_SPARK_POWER_AND_STARTUP_MODULE_2026-10-25.md) and [original OEM audit](../research/4400_MAKINO_EDGE3I_SINKER_EDM_DIELECTRIC_FIRE_Z_STARTUP_AND_VARIANT_OEM_AUDIT_2026-10-25.md). These are **open-book learning exercises, not blind external challenges**.

For every case fill **hazard → exact product/document evidence → ordinary status → independent safety demand/authority → final physical element → separate witness → residual hazard → no-energy/qualified validation request → rearm rule → evidence label**. Say UNKNOWN rather than inventing a setting, diagnostic coverage or safety integrity.

| # | Adversarial technician prompt |
|---|---|
| 01 | EDGE3i HMI level is green, but a new deep-pocket fixture may expose a spark region above the fluid. Is the level green enough to run? |
| 02 | A colleague copies a 53°C threshold from an older EDGE2 PDF mirror into a different EDGE3i. What exact source/version checks stop the change? |
| 03 | Someone assumes wire EDM uses water; an OEM UPV-3 page explicitly describes oil dielectric. Which hazards and SRS entries change? |
| 04 | A modified nozzle bracket improves tool clearance but shifts the automatic extinguisher discharge. Which `CHG/VAL/PT` records become stale? |
| 05 | E-stop removes EDM pulse command and stops pumps while the fluid remains hot. Does it prove the tank/fire hazard ended? |
| 06 | A technician wants to put a hand into the work tank after LinuxCNC M9 and no axis movement. Identify at least three remaining hazards. |
| 07 | POWER ON shows no CNC cycle request but OEM §2.3.2 says Z “break” is released and filter pump starts. What is known, what is not, and how should qualified commissioning respond? |
| 08 | A temperature input is disconnected yet the UI shows its last valid value. Which evidence may be stale and what is the minimum safe policy? |
| 09 | A float switch is manually held up to complete a tricky setup. Why is this a foreseeable defeat, and what practical redesign avoids it? |
| 10 | Fire suppression is present but its inspection date, charge and nozzle coverage are unverified. Can “device installed” authorize unattended operation? |
| 11 | A wire EDM uses oil, but the integrator reuses a water-dielectric fire checklist. Identify the invalid assumption and evidence request. |
| 12 | A person sets a portable control pendant on the work tank and accidentally hits axis jog with an elbow. What low-cost human-factors fix should precede adding more software warnings? |
| 13 | A machine is reset after a fire alarm with a retained start request. What separate checks and fresh command must precede resumption? |
| 14 | A supplier says a 45±3°C temperature switch makes the whole machine PL d. What logical leap invalidates this claim? |
| 15 | A workpiece is completely submerged, but the discharge electrode shank arcs above fluid. Why is workpiece immersion alone insufficient? |
| 16 | A user proposes a LinuxCNC/FPGA-only fire-inhibit bit because the control is already available. Identify the common-cause and final-element/physical-witness gaps. |

## Blank selected-machine physical evidence request — not a test report
| Field | Required entry | Status |
|---|---|---|
| Exact make/model/serial/year and OEM manual revisions | __________________ | UNKNOWN |
| Dielectric chemistry, SDS, flashpoint and OEM-approved fluid | __________________ | UNKNOWN |
| Actual fixture/part/electrode geometry, fluid fill and local level witness | __________________ | UNKNOWN |
| Fluid temperature/level sensor exact catalog, wiring, diagnostics and selected setpoints | __________________ | UNKNOWN |
| Abnormal gap detector, fault response, discharge generator isolation/final element | __________________ | UNKNOWN |
| Flame/fire detection, suppression agent, charge, nozzle geometry, inspection record | __________________ | UNKNOWN |
| Guard/tank/pendant access zones and modes | __________________ | UNKNOWN |
| Z “break”/brake OEM schematic, physical holding mechanism and power-on sequence | __________________ | UNKNOWN |
| E-stop/guard/fire demands and independent actual final-element responses | __________________ | UNKNOWN |
| Lockable maintenance energy isolation and zero-energy verification points | __________________ | UNKNOWN |
| Occupancy, bypass restoration, deliberate reset and fresh start | __________________ | UNKNOWN |
| Qualified witness, instrument calibration, dated evidence, result and residual risk | __________________ | NOT RUN |

**Hard stop:** No selected physical evidence is supplied here. These 16 scenarios are **not** test results, proof of protection, PL/SIL claims or permission for personnel-exposed hazardous operation. A qualified reviewer must determine appropriate physical verification without performing dangerous ignition or entrapment demonstrations.
