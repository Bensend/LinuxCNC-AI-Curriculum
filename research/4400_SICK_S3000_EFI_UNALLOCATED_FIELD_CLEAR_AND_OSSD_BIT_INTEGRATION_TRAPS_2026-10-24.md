# 4400 — SICK S3000 EFI: unallocated field reports clear; unused local OSSD bit reports active

**Original OEM source adjudication, 2026-10-24.** Primary: SICK AG *S3000 Safety Laser Scanners*, official operating instructions **8009942/ZE09/2026-09-09**, original 172-page PDF: https://www.sick.com/media/docs/3/63/863/operating_instructions_s3000_safety_laser_scanner_en_im0011863.pdf . Examined printed pp. **17–20, 93, 98–101, 108–109**. **DOC-CONFIRMED for exact S3000 edition and stated configurations**, not any installed OpenPressBrake system. No machine tests.

## Two integration hazards hidden behind plausible 'green' status

**Hazard A — an unallocated field can default to clear.** In §7.6.5 printed p.93 SICK defines evaluated protective-field status **1 = clear**, **0 = interrupted**. An **unallocated** protective field initially defaults to **1 (clear)**. SICK therefore instructs Flexi Soft users evaluating protective-field status to enable **Transfer unallocated fields as interrupted**; in **Dual protective fields** mode this option is selected automatically. A designer who assumes every unused field is a fault or occupied may build a dangerously permissive safety-PLC expression. This is **DOC-CONFIRMED signal behavior**, not proof a particular PLC is wired incorrectly.

**Hazard B — the EFI OSSD bit can be active even when no local OSSD protection is used.** In §7.9 printed p.98, SICK explicitly warns: if the S3000's local OSSDs are **not used**, the OSSD state is always transferred as **active** over EFI; the Flexi Soft **OSSD bit must not be used for safety-related functions**. Use protective-field status instead, with correctly designed safety-PLC evaluation and restart interlock. This is a **conditional** manufacturer rule, not a contradiction of S300 §7.10: the earlier S300 restart rule assumes a meaningful OSSD-status path. **The interface contract must first determine whether the selected OSSD bit actually represents the protective field.**

## Third integration hazard — dual protective fields need separate cut-off paths

SICK S3000 §7.9 printed p.98 says in **Dual protective fields** mode, protective field 2 and simultaneous protective field 2 **do not switch the scanner's local OSSDs**. Their cut-off signals must be routed via EFI to **external OSSD pairs** in Flexi Soft. The p.20 product section likewise calls for independent OSSD pairs for two protective fields. A single local OSSD pair cannot silently stand in for both protective cut-off paths. **DOC-CONFIRMED for this specific mode**, not an instruction to wire a press brake by copying a figure.

## Distinct non-safety signals

The same S3000 manual printed p.20 says a **warning field must not be used for personnel protection**. A warning field may produce pre-warning/slowdown, but it is not a protective field. A successful warning-light or HMI diagnostic does not prove the safety output chain. Printed p.108 says contour-reference configuration has limitations and in dual protective field mode protective field 2 is not evaluated in the area assigned to contour reference. These are **exact variant/mode caveats**, not blanket scanner inadequacy.

## End-to-end design proof needed (INFERENCE)

`physical hazard boundary → selected protective field (not warning) → allocated field and configuration checksum → correct logical polarity → correct EFI signal for the selected local/external OSSD mode → safety-PLC interlock and fault evaluation → independently qualified final-element cut-off → physical stop/hold/occupancy witness → local reset → separate new start`.

The earlier [S300 signal-selection audit](4400_SICK_S300_EFI_RESTART_INTERLOCK_SIGNAL_SELECTION_AND_REAR_ZONE_SOURCE_AUDIT_2026-10-24.md) establishes that scanner internal restart interlock is **not inherited** by a safety PLC consuming raw protective-field status; it must be implemented in Flexi Soft. **Combined conditional inference:** an integrator cannot safely choose 'always use OSSD bit' *or* 'always use raw field bit'. The correct source and reset ownership depend on model, configured field mode, local-versus-external OSSD routing and PLC logic. Neither signal alone proves physical stopping.

## Adversarial paper cases

- **UF-01:** Flexi Soft consumes field 4 as permissive; field 4 is unallocated. OEM p.93 says initial value is **clear**. HOLD pending correct allocation/default handling and qualified review.
- **UF-02:** S3000 external OSSD mode; safety PLC relies on EFI OSSD bit. OEM p.98 says bit is **always active** when local OSSDs unused. Reject as safety evidence.
- **UF-03:** Dual protective fields configured, only scanner's local OSSD pair wired. Field 2 cut-off is missing from local pair; require external independent cut-off path.
- **UF-04:** Scanner warning field triggers slowdown and is labeled 'people safe'. OEM p.20 prohibits warning-field personnel protection.
- **UF-05:** Scanner internal restart selected; PLC consumes raw protective-field bit. OEM §7.10 requires PLC-side restart interlock.
- **UF-06:** Two modes use different protective fields; CNC mode bit selects a smaller field during occupancy. Need independent case selection/timing, not only a normal-control variable.
- **UF-07:** Technician copies S3000's OSSD/field-bit advice to a different scanner model or revision. Reject cross-family inference; inspect exact manufacturer edition and selected configuration.
- **UF-08:** A machine's physical backgauge/ram continues after scanner outputs change. Scanner status is only one proposition; inspect safety final elements and actual stop/hold.

## Evidence ledger and no-test disposition

**DOC-CONFIRMED:** SICK 8009942/ZE09/2026-09-09 §§3.2.6, 7.6.5, 7.9, 7.10, 7.12.4. **SOURCE-CONFIRMED:** no new LinuxCNC source; ordinary control remains separate. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** integration failure consequences and recommended contract. **UNKNOWN:** installed scanner/PLC/field allocation, backgauge stop/hold, Y1/Y2 final elements, rear occupancy, machine risk assessment and acceptance. `VAL/PT NOT RUN`, G0/G1 HOLD, G3/G4 NOT AUTHORIZED. No physical person-in-field, automatic-restart or energized fault injection test authorized. Exact historical archive remains **6/85 pending**.

## Additional primary-source trace: case-switch timing is a separate safety function

SICK S3000 **§4.3.3 printed pp.39–40** describes the case-switching advance as the sum of input delay, external OSSD delay over EFI, and external control-input delay over EFI, with an example where a gantry robot changes protected side. It warns that a person can already be in the newly activated field; when timing is not determinable or the old field would cease too early, the manufacturer describes **overlapping protective fields or temporary simultaneous monitoring**. **§7.8.2 pp.97–98** distinguishes dual-channel *complementary* input evaluation (same-state channels are errors) from *1-of-n* input evaluation (no active input or more than one active is an error). **§7.13.1 pp.111–112** requires the case-switching control itself to meet the required safety level. These are **DOC-CONFIRMED S3000 product/edition statements**, not a generic press-brake speed, field overlap dimension, response-time acceptance or permission to connect ordinary LinuxCNC mode pins directly as safety controls.

**New integration discriminator:** even if the EFI status polarity, allocation, reset owner and OSSD routing are correct, a late switch to the protective field can leave an interval of unprotected motion. Capture **which safety-rated mode input selects the field, its sampling scheme, input delay, external EFI/OSSD path, old/new field coverage, and measured qualified stopping behavior**. Do not run a moving-person/robot/ram experiment to discover this; first complete documentary design and risk assessment.
