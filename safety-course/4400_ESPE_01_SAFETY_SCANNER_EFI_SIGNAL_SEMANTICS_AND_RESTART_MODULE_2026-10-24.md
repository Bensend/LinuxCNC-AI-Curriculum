# 4400-ESPE-01 — Safety scanner signal semantics, restart ownership and physical access proof

## Identity

- **Course:** 4000 / OpenPressBrake Safety Course.
- **Status:** **SOURCE-READING / TEACHING DRAFT, NOT GRADUATED**.
- **Prerequisites:** 2520 safety-function derivation; 2540 final elements; 2580 physical proposition/energy isolation; 4400 selected-machine intake.
- **Unlocks:** documentary scanner/PLC interface review, not machine operation.
- **Source revisions:** SICK S300 **8010948/ZD76/2025-08-19** and S3000 **8009942/ZE09/2026-09-09**; no new LinuxCNC code revision tested.
- **Last reviewed:** 2026-10-24 UTC. No machine hardware evidence or external evaluation.

## Learning objective

A fresh AI engineer should identify the actual safety output *semantics*, not merely signal names; distinguish allocated versus unallocated fields, local versus external OSSDs, internal scanner versus safety-PLC restart interlocks, and access passage versus sustained occupancy. It must be able to reject plausible but unsafe shortcuts in a press-brake rear/backgauge zone without inventing stop time, PL/SIL, scan geometry or hydraulic truth tables.

## Required original source reading

1. [S300 2025 OEM integration and restart audit](../research/4400_SICK_S300_EFI_RESTART_INTERLOCK_SIGNAL_SELECTION_AND_REAR_ZONE_SOURCE_AUDIT_2026-10-24.md) — S300 8010948/ZD76/2025-08-19 pp.23–25, 31–32, 88–90; original https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf .
2. [S3000 2026 OEM EFI field/OSSD mode audit](../research/4400_SICK_S3000_EFI_UNALLOCATED_FIELD_CLEAR_AND_OSSD_BIT_INTEGRATION_TRAPS_2026-10-24.md) — S3000 8009942/ZE09/2026-09-09 pp.20, 93, 98–101; original https://www.sick.com/media/docs/3/63/863/operating_instructions_s3000_safety_laser_scanner_en_im0011863.pdf .
3. [TRUMPF B35 OEM press-brake guard/backgauge transfer](../research/4400_TRUMPF_B35_SIDE_DOOR_ASYMMETRY_MUTE_REMOTE_SUPPORT_AND_DISASSEMBLY_AUDIT_2026-10-23.md) — distinct guard reactions, backgauge STO and unbraked mechanical/hydraulic hazards.
4. OSHA 1910.212 general machine guarding: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212 . Do not misapply 1910.217 mechanical-press provisions to press brakes.

## Minimum mechanism

**Normal control:** `LinuxCNC / FPGA / HMI → ordinary X/R/Z/Y motion and status`. No personnel-safety authority.

**Safety-related control:** `protected area → actual protective sensor and field → configured safe signal / safety PLC logic → restart/EDM state → qualified independent final elements → physical stopping`.

**Physical/maintenance:** `backgauge and ram motion, gravity, workpiece sweep, stored pressure → independent stop/hold/occupancy/energy isolation witness`. A scanner is an *input* to this system; it cannot mechanically hold a ram or guarantee that the person who crossed the scanner has left the danger zone.

## Source-scope decision table

| Question | DOC-CONFIRMED answer | Unsafe simplification to reject |
|---|---|---|
| Is an S300 scanner internal restart interlock inherited by Flexi Soft? | **Only** if PLC consumes the relevant scanner OSSD status; if raw protective-field status is consumed, PLC must implement interlock. | 'Scanner reset enabled means PLC restart safe.' |
| Is the EFI OSSD bit always safe to consume? | **No**: S3000 §7.9 says when local OSSDs are unused the EFI OSSD bit is always active and not safety-authoritative. | 'Use OSSD bit in every scanner configuration.' |
| Is unallocated field safely interrupted by default? | **No**: S3000 §7.6.5 initially transmits unallocated as **1 clear**; OEM instructs transfer-unallocated-as-interrupted when evaluating fields in Flexi Soft. | 'Unused field defaults safe.' |
| Does dual protective field 2 switch local S3000 OSSDs? | **No**; external independent cut-off via EFI/Flexi Soft is required. | 'One local pair protects both.' |
| Is warning field personnel safety? | **No**, S3000 p.20 prohibits using warning fields for personnel protection. | 'Prewarning lamp equals safety stop.' |
| Does a clear access plane prove no person inside? | **No**, S300 p.25 warns someone behind it is not detected. | 'Field clear means zone empty.' |

The apparent S300/S3000 'use OSSD' versus 'use field status' tension is **not** resolved by declaring one manufacturer statement wrong. It is explained by **device family, mode, and whether local OSSDs are meaningful**. Exact installed configuration remains the deciding evidence.

## Paper design task

A hypothetical press brake has a rear access scanner, Flexi Soft, powered X/R backgauge and a hydraulic ram. The CNC offers an automatic bend-cycle restart. The scanner is configured for manual restart; the PLC uses a raw protective-field status, a second field index is unallocated, and an ordinary HMI shows READY after power returns.

The learner must:

1. Draw separate chains for ordinary CNC motion, safety PLC decisions, final elements, gravity/pressure load and human occupancy.
2. Identify at least **three** source-confirmed reasons the observed READY state cannot prove safe restart.
3. Identify the exact evidence needed to decide whether the raw-field path can safely rearm.
4. Propose a local deliberate reset and *separate* start concept without asserting an actual wiring schematic.
5. State what evidence must exist before any qualified physical validation could be designed.
6. State why no personnel-exposed operation is authorized.

This is a **teaching exercise**, not a blind assessment. Do not use it as a scored sealed benchmark.

## Failure-path matrix

| Failure path | Detection/evidence needed | Practical design improvement |
|---|---|---|
| Wrong EFI signal selected | PLC variable, scanner local/external OSSD mode, versioned configuration | Explicit signal-contract table and protected configuration review |
| Unallocated field used as clear | Allocation map and OEM unallocated behavior | Safe-default field allocation, version control and validation |
| Field 2 not connected to final element | Field-mode and output route trace | Separate validated cut-off path |
| Person hidden after crossing access field | Full 3D access/escape geometry and occupancy proof | Fixed barriers or validated whole-zone/trapped-person measures |
| Reset button not visible/easy | Operator sightline, service/guard ergonomics | Visible local reset and easy guard restoration |
| Field switch late during mode change | Case selection source, timing and protected field geometry | Safety-controlled mode selection and transition validation |
| STO credited as load hold | Drive safety manual, mechanical brake, gravity witness | Independent holding/energy control |
| Power return resumes queued CNC command | Safety reset/start sequencing and stale-command behavior | New deliberate local start and command invalidation |

## Paper adversarial exercises and assessment

Work [S300 16-case card](4400_S300_EFI_SIGNAL_SELECTION_RESTART_AND_REAR_ACCESS_TECHNICIAN_CARD_2026-10-24.md), [S3000 10-case card](4400_S3000_UNALLOCATED_FIELD_AND_EXTERNAL_OSSD_SIGNAL_TRAPS_FIELD_CARD_2026-10-24.md), and the [blank interface review](4400_REAR_ACCESS_AND_EFI_RESTART_SAFETY_INTERFACE_REVIEW_WORKSHEET_2026-10-24.md). An evaluator should ask a *novel* machine/controller/field-set problem with model edition withheld until the learner identifies it as a needed fact. Keep evaluator hidden outcomes information-separated; no score has been assigned.

## Evidence, prediction and graduation status

- **DOC-CONFIRMED:** original SICK 2025/2026 manuals, TRUMPF 2023 prior source audit, OSHA 1910.212.
- **SOURCE-CONFIRMED:** existing LinuxCNC 2.9.10 ordinary command-path evidence only; no new source trace.
- **TEST-CONFIRMED:** none; no hardware or simulation tests.
- **INFERENCE:** proposed layered architecture, specific failure-path consequences and ergonomic controls.
- **UNKNOWN:** actual installed device, safety-PLC configuration, machine physical stop/hold, PL/SIL, stop time, protective field geometry and local rearm behavior.
- **Predeclared prediction/independent verification:** **NOT RUN**; paper cases do not count as tests.
- **Fresh-AI blind handoff:** **NOT RUN / NOT SCORED**.
- **Counterfactual promotion test:** if a selected machine uses no SICK scanner, documentary teaching remains valid but cannot support any claim about that machine. Actual selected physical safety cannot be promoted away and **blocks operational release**.
- **Graduation:** **NOT GRADUATED**. Documentary source coverage does not satisfy independent physical proof or information-separated evaluation. No laboratory compute is justified merely to replay known manufacturer logic.

## Next work

Collect exact installed rear-access/guard design and safety-controller signal trace, field allocation, reset logic, backgauge STO/brake, independent Y1/Y2 final elements, physical stop/hold/occupancy and maintenance isolation. If absent, continue a new unblocked 4400 safety source gap or arrange a truly independent fresh-AI paper evaluation. No personnel-exposed hazardous operation.

## Additional documentary discriminator — field switching before exposure

Original SICK S3000 8009942/ZE09/2026-09-09 **§4.3.3 pp.39–40** requires advancing monitoring-case switching when input delay, external EFI control inputs or external OSSDs add delay; if deterministic timing cannot be guaranteed, protective-field overlap or temporary simultaneous monitoring is described. **§7.8.2 pp.97–98** documents complementary dual-channel sampling versus 1-of-n sampling and invalid-state errors. **§7.13.1 p.111** requires the case-switching control to meet the required safety level. **DOC-CONFIRMED for this product**, but no SICK timing number is an OpenPressBrake stop-time or field-overlap acceptance. A student must distinguish `field selection`, `field evaluation`, `restart authority`, and `physical stopping` as four different proof obligations.


## 2026-10-24 optical/service continuation (not graduation)

A correct EFI/OSSD protective-field signal path does **not** establish optical coverage. Read the [original SICK S3000 2026 optical shadow/front-screen calibration audit](../research/4400_SICK_S3000_OPTICAL_SHADOW_FRONT_SCREEN_REPLACEMENT_CALIBRATION_AUDIT_2026-10-24.md) and [12-case paper technician card](4400_S3000_OPTICAL_SHADOW_SCREEN_SERVICE_TECHNICIAN_CARD_2026-10-24.md). Obstacles and highly reflective objects can leave unmonitored areas; improvised clear covers may circumvent contamination detection. **Front-screen replacement requires optical calibration** even with saved system-plug configuration. This extension remains documentary only: no selected scanner, physical stop/hold or fresh independent competency score; ESPE-01 NOT GRADUATED.
