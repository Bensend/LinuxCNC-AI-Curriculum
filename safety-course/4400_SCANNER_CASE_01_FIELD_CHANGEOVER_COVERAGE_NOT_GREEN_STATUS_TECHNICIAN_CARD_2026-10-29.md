# 4400-SCANNER-CASE-01 — A green scanner after switching is not proof of continuous protection

**Safety course technician card | 2026-10-29 | DOCUMENTARY ONLY / NO MACHINE RELEASE.** Read the [2025 SICK original-source audit](../research/4400_SCANNER_CASE_01_SICK_MICROSCAN3_2025_SWITCH_TIMING_COVERAGE_GAP_AND_INPUT_DELAY_AUDIT_2026-10-29.md) before changing any installation. This extends the [existing S300/S3000 EFI signal/restart module](4400_ESPE_01_SAFETY_SCANNER_EFI_SIGNAL_SEMANTICS_AND_RESTART_MODULE_2026-10-24.md), not a new scored examination.

## The practical question

When a rear scanner changes from *tool-change* to *automatic-cycle* coverage, **what protects both areas during the change**? The correct field being active afterward is not enough. A person may reach the newly hazardous space before the new field is effective, or remain in the old area after the old field is retired.

**Separate four propositions:** (1) ordinary CNC/HMI **requested** a mode; (2) scanner **selected** a monitoring case; (3) independent safety system **permitted** the relevant protective function; (4) physical machine **stopped and remained safely held**. These are not interchangeable. No ordinary LinuxCNC/FPGA bit can supply (3) or (4) by itself.

## Before approving any variable field — documentary checklist

- **Exact product:** record scanner part number, firmware/manual revision, field geometry, optical blind zones, and whether each selected case is *protective*, warning-only, or sleep/passive.
- **Old and new areas:** show both access routes on one plan. Prove *old coverage is not removed prematurely* and *new coverage is effective before exposure*. Consider someone already inside and a person entering from another side.
- **Timing chain:** include upstream control/network latency, scanner configured input delay, case-processing time, scan/sampling/interference time, safety output/PLC/final-element response, and **actual physical stop**. Never substitute a scanner's 12 ms input-processing constant for machine stop time.
- **Inputs and faults:** review every allowed input combination, antivalent pair, contact bounce, startup, power return, invalid selection, network loss, reset and mode change. SICK's 2025 Core I/O manual warns that a non-inverted antivalent pair causes OFF/fault even when the input is otherwise marked irrelevant.
- **Recovery:** explain faults in operator language. A nuisance-trip pattern that encourages taping a sensor or bypassing a guard is a design problem to fix.
- **Independent proof:** qualified reviewer must establish safety-controller logic, actual stopping/holding elements, occupancy/escape and deliberate reset/restart. A healthy scanner or an OSSD OFF status is not hydraulic ram restraint.

## Manufacturer-specific reminder

The 2025 SICK microScan3 Core I/O manual uses `tCSR = tID + tI` for internal case-switch time, with **12 ms local-input processing**, and compares it against `tCSA = (n-nCS) × tS`. If the first exceeds the second, switching must start early; **the required advance also depends on upstream signal propagation and real application geometry**. Manufacturer examples put relay-contact input delays in the **30–150 ms** range. These are **DOC-CONFIRMED device excerpts**, not OpenPressBrake settings or a stopping-distance calculation.

Where uncertain processing time makes exact handover unreliable, the OEM discusses **partially overlapping fields**. An independent safety design may instead keep both areas monitored or prevent hazardous motion until handover is qualified. These choices need actual SRS/geometry and final-element validation; do not implement them by unqualified LinuxCNC mode bits.

## Six documentary counterexamples (UNSCORED)

| Plausible claim | Required correction |
|---|---|
| “The new field is green now.” | Show **when** it became protective relative to access and motion. |
| “Switch sooner and it is fixed.” | Show the **old** zone was not left unprotected too soon. |
| “Increase debounce to stop false trips.” | Re-evaluate the **switch timing** and operator bypass incentive. |
| “Both scanner inputs look fine.” | Check **antivalent pairing**, all combinations and actual field/cut-off mapping. |
| “The laser scanner has a reset button.” | Establish which device owns **restart interlock** and fresh start. |
| “OSSD OFF means the press is held.” | Verify the independent **physical stop/hold** chain and stored/gravity energy. |

**OpenPressBrake status:** installed scanner/field configuration, Pilz/AKAS, Y1/Y2 final elements, guarding and physical witness are **UNKNOWN**. Keep [Stage A A–G owner request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) unchanged and short; do not request a powered demonstration just to complete this card. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation.** Experimental operation, if ever qualified, requires remote/isolation with people outside danger and explicit residual risk.
