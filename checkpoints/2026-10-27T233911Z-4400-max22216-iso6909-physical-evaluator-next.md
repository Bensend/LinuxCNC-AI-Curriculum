# 4400 Safety Curriculum — 2026-10-27T23:39:11Z session continuation

**Status:** source/documentary NON-GRADUATED. The current branch remains **4400 safety**, not historical 3300; 1000/2000/F02 and completed 3000 are GRADUATED/CLOSED. No personnel-exposed hazardous operation authorized.

## What this session actually advanced

1. [Original Analog Devices MAX22216 Rev. 2 audit](../research/4400_OPB_MAX22216_FAULT_AUTORECOVERY_CRC_STALE_COMMAND_AND_ENABLE_EVIDENCE_AUDIT_2026-10-27.md) against exact public OpenPressBrake Rev1 board schema: fault-specific output behavior (OVT auto-recovery, HHF non-tristating, OCP tristating), UVLO register retention, ENABLE-low clearing fault registers, CRC rejected-write old-state persistence, pipelined COMER/readback, N_FAULT masking. [Practical reviewer](../safety-course/4400_OPB_DRV_05_MAX22216_FAULT_RECOVERY_AND_INDEPENDENT_SAFETY_REVIEW_CARD_2026-10-27.md); existing OPB-D04/D08 restricted card refined. **DOC/SOURCE only**, not firmware/PCB/physical proof.
2. [Newly identified ISO 6909:2026 press-brake Type-C edition/scope](../research/4400_PRESS_BRAKE_ISO6909_2026_TYPE_C_PUBLICATION_SCOPE_AND_LEGACY_RETROFIT_GATE_2026-10-27.md): ISO publisher confirms publication **2026-05-29**; EN adoption and EU 2026/2015 reference. Publisher abstract excludes pre-publication manufactured machines and automatic loading/unloading safety; ISO 16092-1/-3 hydraulic-press family is not an automatic press-brake substitute. Prior RESCUE-01 and Stage A F corrected. **Normative clauses not read**, actual machine applicability UNKNOWN.
3. Updated CURRICULUM.md, PROGRESS.md, SAFETY_COURSE_RESEARCH.md, canonical index, and cumulative Safety Design Package **§§11JU–11JV**. No additional scored/unscored challenge bank, machine intake questionnaire, lab or safety-PLC logic.
4. Checked **13 relative-link occurrences across 11 distinct targets** in three new source/reviewer artifacts: **zero broken**. Start marker committed before source work.

## Immediate next-work priority, in order

**A — qualified restricted G0 Stage A A–G evidence.** Obtain dated as-built machine/revision and jurisdiction/manufacture/retrofit scope, actual installed Pilz/AKAS model and *active* program identity, Y1/Y2 physical stop/hold and hydraulic isolation architecture, 11K2 L7/L07 two-pole/feedback, wire-75 conditioning, guards/foot/reset, and independent final elements. Stage A F must select applicable **press-brake-specific** standard/edition (ANSI B11.3-2022, ISO/EN ISO 6909:2026, legacy EN 12622, or justified alternative) with qualified scope rationale; never copy paid normative clauses or guess thresholds. Use the existing [one-page request](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) and [OPB-D01..D08 restricted card](../safety-course/4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md); no new owner packet. No selected-machine evidence has been received in this session.

**B — independent physical witness and external evaluation.** A qualified reviewer must map STOP/HOLD/ACCESS/ENERGY/GUARD/RESTART to actual safety-controlled final elements and physical evidence; G1 isolated/remote test plan only after documentary readiness. No energized tests with people in danger zone. Independent 2520–25F0 competency evaluator remains **NOT RUN**; do not mark a learner graduated from public paper cards.

**C — if A/B information is unavailable:** continue highest-value open 4400 safety source-depth branch; do not manufacture 3000 work. When OpenPressBrake board implementation/FPGA firmware becomes inspectable, check the actual MAX22216 dual-ENABLE wiring, fault history, CRC frame/rejected-write handling, and fresh-current recovery. Only freeze a bounded local-runner test for an unresolved implementation question. Ordinary driver design stays with the separate board-design automation. Do not use GitHub-hosted Actions minutes.

## Gates and evidence

- **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**
- **DOC-CONFIRMED:** original ADI datasheet and ISO/EVS/official EU publisher scope.
- **SOURCE-CONFIRMED:** public OpenPressBrake board contracts and historical source identity; not installed machine.
- **INFERENCE:** conditional lost driver diagnostic history/stale SPI command; applicability and failure-path review.
- **UNKNOWN:** installed Pilz program, physical Y1/Y2/11K2, fabricated board, firmware, legal/standard applicability to selected machine, actual pressure/stopping/PL/SIL, external evaluator.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on.
- **GitHub-hosted compute 0 min; local self-hosted compute 0 min; no workflow dispatch, simulations, builds, physical tests or new authoritative runtime.** LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged.
- **Overlap:** previous same-curriculum session ended 2026-10-27T22:42:51Z, before this session started at 23:39:11Z (gap ~56 min 20 s); **no known same-curriculum overlap**. Other automation overlap not established. Exact end time/elapsed minutes to be recorded in LESSON_LOG immediately before ending.
