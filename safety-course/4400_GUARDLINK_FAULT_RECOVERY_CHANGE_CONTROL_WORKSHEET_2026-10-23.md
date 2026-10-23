# 4400 selected guard chain — fault recovery, hot replacement and rearm qualification

Use with `SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` and `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md`. This is a **blank** design/commissioning record. Do not treat a manufacturer example as a completed physical proof.

| Package ID | What must be established | Evidence / source / selected configuration | Status |
|---|---|---|---|
| BND / HAZ | Access route, exposure, whole-body entry, process and machine modes | | UNKNOWN |
| SF / PHY | Protective demand, actual physical stop/hold/energy/access proposition | | UNKNOWN |
| SRS | Demand-to-output response, independent reset, separate ordinary start, retained-start prevention | | UNKNOWN |
| AUTH | 440R-DG or 432ES + safety controller owner; ENETR/HMI diagnostics/control only when selected | | UNKNOWN |
| DEP | Shared 24 V/0 V, tap power, cable, terminator, output feedback, firmware, reset/HMI and pilot supply | | UNKNOWN |
| ARC | Exact OSSD/EMSS/passive tap, DG/432ES variant, selected device/receiver, topology and safety outputs | | UNKNOWN |
| HF | Nuisance fault, difficult replacement, obscure node diagnostics, incentive to issue global reset/bypass | | UNKNOWN |
| VAL | Fault, power-cycle, rearm, physical stop, locked access, occupied-cell and retained-start contradiction tests | | NOT RUN |
| PT | Periodic/after-replacement verification, interval justified by selected requirements | | NOT RUN |
| CHG | Tap/device replacement, firmware change, node-count change, terminator relocation, AOP update | | OPEN |
| UNK / RR | Unproved physical response, limits, occupancy, residual energy and restrictions | | OPEN |

## Distinguish five events in time

| Time | Event | What changed electrically | What physically must still be verified | Witness ID / result |
|---|---|---|---|---|
| t0 | Guard opens / protective demand | | | |
| t1 | Safety output demand reaches final element | | | |
| t2 | Physical hazard reaches justified safe state | | | |
| t3 | Tap or relay fault reset / replacement and GuardLink recovery | | | |
| t4 | Deliberate safety rearm and **separate fresh ordinary start** | | | |

If a person can enter the cell, include occupancy and escape observations. If a gravity-loaded beam exists, include independently established restraint. A time stamp on a status message is not the actual physical stopping time.

## Fault/firmware/command adversarial matrix

| Stimulus | Exact selected version? | Narrow manufacturer expectation | Required machine witness | `VAL-*` status |
|---|---|---|---|---|
| OSSD channel discrepancy | | 3 s tap fault criterion for documented family | Actual demand/stop response and receiver behavior | NOT RUN |
| EMSS contact timing discrepancy | | 10 s tap simultaneity for documented family | Actual demand/stop response | NOT RUN |
| GuardLink Operational with relay output OFF | | Possible due to other inputs/feedback/reset | Final element and safe-state evidence | NOT RUN |
| HMI `Reset1` while held start exists | | Relay reset request; selected reset configuration controls | No hazardous restart from retained ordinary command | NOT RUN |
| HMI `FaultReset` / `FaultResetCmd` | | Relay or tap/device power cycle | Physical safety during/recovery and diagnostic continuity | NOT RUN |
| Lock/unlock to nonlocking device | | Firmware-specific transient or persistent state | No reliance on command as safety stop | NOT RUN |
| Same-type hot tap replacement | | GuardLink may automatically recover | Installation/guard function and maintenance isolation | NOT RUN |
| Tap type/count or terminator change | | DG relearn and interface AOP review needed | Whole-chain validation and restart inhibition | NOT RUN |
| Feedback says healthy but physical hazard persists | | Controller status may be plausible | **PHY NOT ESTABLISHED; block exposed-person release** | NOT RUN |

**Acceptance rule:** no `VAL` PASS unless selected physical proposition, instrument/method and criterion are independently established. If not, mark `BLOCKED` or `UNKNOWN` and restrict to isolated/remote experiments with people outside danger zone.

**Sources:** GLINK-AT001A-EN-P July 2023; 440R-UM009E-EN-P February 2026, official Rockwell PDFs linked in research document. No bench data in this package.
