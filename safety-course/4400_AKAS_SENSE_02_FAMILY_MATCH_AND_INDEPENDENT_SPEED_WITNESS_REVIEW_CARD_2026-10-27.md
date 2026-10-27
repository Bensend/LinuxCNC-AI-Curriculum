# 4400-AKAS-SENSE-02 — identify the *actual* safe-speed source before trusting a mute

**NON-GRADUATED public technician/reviewer card.** A desk-only source-reading aid, not an installation diagram, live test procedure, validated PLC program or approval to operate a press brake.

Read the [exact Fiessler/OpenPressBrake source reconciliation](../research/4400_AKAS_AMS3_F_ONLY_VS_M_SAFETY_Y1_Y2_ENCODER_AUTHORITY_SOURCE_DELTA_2026-10-27.md) after [AKAS-M-01](../research/4400_AKAS_LCII_M_PILZ_MUTING_SLOW_SPEED_OVERTRAVEL_AUTHORITY_AUDIT_2026-10-27.md) and [MON-01](4400_MON_01_SAFE_SPEED_MODE_SELECTION_ENCODER_CCF_AND_PHYSICAL_STOP_MODULE_2026-10-25.md). Those predecessors already teach independent muting and safe-speed architecture. This card adds **exact product-family and machine-interface identification**, not a new generic safety principle.

## Field-facing one-pass classification

**Start with the installed label and program, not a convenient wiring name.** The current Fiessler product page describes AMS3 with **AKAS-F**, with a separate magnetic tape sensor for Y1 and Y2. The earlier LC-II M/F manufacturer manual says an 'AMS-System' can be used in some applications. These two statements do **not** prove AMS3 compatibility with an LC-II M or that any AMS exists on this press. The public OpenPressBrake Rev 1 design's Y1/Y2 ATEK scale channels terminate at the ordinary FPGA encoder block, not at a documented independent safety input.

| Classification question | Acceptable desk answer | Reject as false proof |
|---|---|---|
| Which AKAS is installed? | Model/variant, manual edition and qualified actual-machine evidence, or **UNKNOWN** | 'The drawing says AKAS, so F or M does not matter' |
| Is an AMS fitted? | Exact product/generation/compatibility and restricted as-built wiring, or **UNKNOWN** | 'Fiessler sells AMS3; therefore this press has it' |
| What measures safety speed and position? | Named physical sensor, independent safety-controller input, diagnostics and physical coupling review, or **UNKNOWN** | 'Two ATEK scales and an FPGA velocity estimate equal a safe speed function' |
| Who may authorize optical muting? | Actual independent safety application with qualified mode/speed/position/guard/OSSD conditions, or **UNKNOWN** | 'Normal CNC wire 44 is high; wire 402 must follow it' |
| What stops and holds the beam? | Actual safety final elements and independent qualified stop/hold evidence, or **UNKNOWN** | 'The Pilz SLOW lamp, valve feedback, or OSSD is green' |
| What permits deliberate restart? | Documented protective-device recovery, independent safety reset and **fresh** machine-start action, or **UNKNOWN** | 'CNC restarted and last MUTE command was retained' |

## Practical anti-bypass pattern

Make device identity and safety state visible without opening a hazardous enclosure or requiring a live stroke. Use accessible, revision-matched labels, a simple guarded tool-change alignment procedure, intelligible 'not ready' reasons and a deliberate fresh-start control. Treat recurring alignment nuisance trips as a design/service problem to fix, not an excuse to jumper a muting input. When evidence is missing, keep the machine out of personnel-exposed hazardous operation. Any experimental work requires a separately approved isolated/remote plan with people outside the danger zone and residual hazards controlled.

**Four planes remain separate:** LinuxCNC/FPGA commands and ATEK feedback are normal control; HMI and Pilz status are monitoring; a verified safety PLC/AKAS/safety speed path is safety-related control; valves, drive inhibition, mechanical load retention and isolation are physical final elements. A valid source-to-sink diagram does not by itself prove physical stop/hold.

## Existing G0 packet — no new forms or scores

Reuse [Stage A](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md), [OPB-D02](4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md) and [AKAS-M-01 restricted delta](4400_AKAS_M_01_RESTRICTED_PILZ_MUTING_OVERRUN_EVIDENCE_DELTA_2026-10-27.md). In the restricted record, add one annotated line for **physical sensor → independent safety input → logic qualification → safety output → actual final element**, with any ordinary CNC feedback separately labeled. Evidence remains **UNKNOWN** until a qualified reviewer can trace the actual installed program and physical machine. Do not upload private safety PLC exports or proprietary drawings to this public curriculum.

**Status:** source/documentary teaching only; **zero new public scored challenges and zero new documentary gates**. Independent evaluator NOT RUN. No simulation, bench or machine test. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.
