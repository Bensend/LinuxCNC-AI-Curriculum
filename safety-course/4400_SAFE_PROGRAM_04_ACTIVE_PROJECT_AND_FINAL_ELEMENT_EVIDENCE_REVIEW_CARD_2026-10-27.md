# 4400-SAFE-PROGRAM-04 — one-pass technician review of an *active* safety project

**Learning use:** documentary transfer card, NOT RUN/UNSCORED, no new graded exam or machine authorization. Read [the source/provenance audit](../research/4400_SAFETY_PROGRAM_IDENTITY_FPSC_EXAMPLE_PILZ_CRC_VALVE_FEEDBACK_AND_BACKFEED_SOURCE_REVIEW_2026-10-27.md) and the existing [restricted OpenPressBrake Stage B intake](4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md) first. This card does **not** add a second private evidence request.

## What to show the reviewer, in order

| Review stage | What the qualified reviewer needs | Common incorrect substitute | Evidence status now |
|---|---|---|---|
| 1. **Installed hardware** | Actual safety controller base/expansion part numbers, revisions, installed AKAS variant and guarded-access devices. | Product-family brochure, board design YAML, photo of a different controller. | UNKNOWN |
| 2. **Active application** | Revision-matched **active** safety application/program identity from that installed model, including supported checksum/CRC, firmware and approved export/readback. | Source project on a PC, matching filename, ordinary CNC HMI "READY". | UNKNOWN |
| 3. **Normal/safety interface** | Actual classification and polarity of CNC OK wire 45, MUTE wire 44, other normal-controller inputs, stale/held-command handling and safety qualification. | Labels copied from an unrelated Fiessler FPSC example or assumed PLC logic. | UNKNOWN |
| 4. **External devices** | Credited safety outputs, final-element identity, contact/valve feedback and independent hydraulic stop/hold mechanisms. | Output command, relay LED, one auxiliary contact, a zero gauge at an unrelated port. | UNKNOWN |
| 5. **Fresh start and physical state** | Guard/AKAS/pedal demand, fault/reset, released-start and new-start behavior, independently verified stop/hold, isolation and exposed-person protection. | Project CRC alone, safety reset accepted, LinuxCNC E-stop state. | UNKNOWN |

**Two concrete manufacturer anchors:** Pilz's original PNOZ m B0 manual `1002660-EN-13` documents device project name/CRC and commissioning function checks after project/chip-card changes; it also distinguishes external feedback-loop and supply faults. This is **DOC-CONFIRMED only for B0**, not evidence that OpenPressBrake has B0. A third-party transcription of Fiessler FPSC manual `BA FPSC_GB_1008_V1.27_01` (2006) illustrates CNC requests passing through safety/valve-feedback logic and warns of possible AKAS receiver-off FUO/FUS backfeed. It is **COMMUNITY-REPORTED mirrored text**, not original-PDF or selected-machine evidence.

## Source-to-machine comparison without a dangerous experiment

- **Paper case A:** The approved file says CRC A; the installed safety controller displays CRC B. Record **CONTRADICTORY/HOLD**, do not select whichever CRC is convenient. Reconcile model, program and change record before any qualification.
- **Paper case B:** A contactor auxiliary NC reports released but the ram can still be supported by pressure in another hydraulic path. Distinguish **feedback contact status** from **physical load retention**; never infer a safe stop from a contact alone.
- **Paper case C:** A held wire-44 MUTE request is present during reset or switched L7 power restoration. The active Pilz/AKAS program must independently qualify protective conditions and fresh restart. Do not attempt a live bypass or fault injection.
- **Paper case D:** A technician proposes using the 2006 Fiessler FPSC macros as the actual Pilz program because both use a signal called CNC OK. Reject cross-product transfer. Compare exact installed program and qualified source documents.
- **Paper case E:** The HMI shows all faults LOW after L7 loss. Existing OPB-ISO-03 source evidence shows LOW can mean **invalid diagnostics**. Project identity does not repair this observability failure.

## Practical acceptance / release rule

The qualified reviewer may mark a **documentary identity subcheck** only when exact installed device and active program can be matched to a reviewed configuration; the safety function and physical final elements still require their own independent evidence. If any required machine-specific witness is missing, preserve UNKNOWN/HOLD. No paper exercise, document CRC or ordinary controller diagnostic grants permission to operate with people exposed. Maintenance needs its own electrical/hydraulic isolation and gravity restraint.

**Sources:** https://www.pilz.com/download/open/PNOZ_m_B0_Operating_Manual_1002660-EN-13.pdf ; https://www.pilz.com/en-INT/support/lexicon/articles/072106 ; third-party transcription https://manualzilla.com/doc/6875583/operating-instructions ; [public Rev1 design](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/REV1_BOARD_INTEGRATION.yaml).

**Disposition:** Existing Stage A/OPB-D01/D02/D03/D06/D08 remain UNKNOWN; no new paper bank, physical test, external evaluator or compute. **G0/G1 HOLD.**


**Source-depth diagnostic trap:** The legacy Fiessler FPSC HTML transcription associates the label `F19` with **both** missing output-group supply and possible AKAS receiver-off FUO/FUS backfeed in different passages; the separate annex `0x19` must **not** be assumed equivalent without the original manual. Do not diagnose a selected Pilz controller from a legacy Fiessler fault code. The original Pilz B0 manual separately requires a qualified supply arrangement for safety-system/inputs and powered semiconductor-output domain. An all-green CNC screen cannot substitute for model-specific supply and active-project evidence.
