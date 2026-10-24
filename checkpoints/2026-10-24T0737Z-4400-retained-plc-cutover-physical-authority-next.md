# Active continuation checkpoint — 4400-RET-01 brownfield CNC safety cutover

**Session UTC start:** 2026-10-24T07:37:58Z (recorded before substantive work).  
**Checkpoint written:** 2026-10-24 UTC. **Status:** SOURCE-READING ACTIVE / NOT GRADUATED.  
**Primary priority:** 4400 safety course, not closed 1000/2000/F02 or completed 3000 specialization. Separate OpenPressBrake Board Design automation owns routine FPGA/controller board work.

## Durable work this session

Published **nine original documents**, not replacements for six missing historical archive originals:

1. [OSHA/Pilz/LinuxCNC brownfield CNC safety PLC cutover audit](../research/4400_BROWNFIELD_CNC_RETROFIT_SAFETY_PLC_CUTOVER_AND_LOCKABLE_ISOLATION_AUDIT_2026-10-24.md).
2. [12-case retained-PLC cutover technician card](../safety-course/4400_RETAINED_SAFETY_PLC_RETROFIT_CUTOVER_TECHNICIAN_CARD_2026-10-24.md).
3. [Blank before/after safety-function continuity and isolation worksheet](../safety-course/4400_CNC_RETROFIT_SAFETY_FUNCTION_CONTINUITY_AND_ISOLATION_WORKSHEET_2026-10-24.md).
4. [Pilz PNOZ m B0 safe/aux/test-pulse exact manual audit](../research/4400_PILZ_PNOZ_MB0_SAFE_VS_AUX_OUTPUT_TEST_PULSE_CUTOVER_SOURCE_AUDIT_2026-10-24.md).
5. [10-case safety output substitution technician card](../safety-course/4400_SAFETY_OUTPUT_AUXILIARY_TEST_PULSE_SUBSTITUTION_FIELD_CARD_2026-10-24.md).
6. [Rockwell coil suppression and long AC cable false-hold original source audit](../research/4400_ROCKWELL_COIL_SUPPRESSION_LONG_CABLE_FALSE_HOLD_RETROFIT_AUDIT_2026-10-24.md).
7. [8-case contactor dropout technician card](../safety-course/4400_CONTACTOR_COIL_CABLE_CAPACITANCE_AND_DROPOUT_TECHNICIAN_CARD_2026-10-24.md).
8. [Integrated non-graduated 4400-RET-01 module](../safety-course/4400_RET_01_BROWNFIELD_CNC_SAFETY_CUTOVER_AND_FINAL_ELEMENT_MODULE_2026-10-24.md).
9. [Novel fresh independent 4400-RET-01 source-transfer handoff](../evaluation/4400_RET_01_FRESH_SOURCE_TRANSFER_HANDOFF_2026-10-24.md) — **PREPARED / NOT RUN / NOT SCORED**.

Source-confirmed pinned LinuxCNC software E-stop behavior; DOC-CONFIRMED OSHA 1910.147(c)(2)(iii) conditional lockable isolator requirement and 1910.302(c), Pilz PNOZ m B0 1002660-EN-13 exact output-role distinction and 330 µs versus 5 ms product-specific diagnostic OFF-pulse intervals, and Rockwell LVSAM-RM003A-EN-P November 2012 DC suppressor drop-out effect plus **AC-specific** long-line capacitive hold. No selected-machine or universal DC numerical transfer.

Updated `CURRICULUM.md`, `PROGRESS.md`, `safety-course/SAFETY_COURSE_INDEX.md`, cumulative Safety Design Package **§§11BJ–11BL**, selected-machine `IN-04h/i/j`, hardware qualification worksheet and publication ledger. **30 paper-only scenarios**, not machine tests. Full repository tree verified **4167 entries, non-truncated; index 143 relative Markdown links / 141 distinct targets / zero missing**. New original documents independently retrievable from main.

## Local-compute and evidence state

- **Zero GitHub-hosted Actions compute** triggered. **Zero local laboratory compute** or simulations used this session. No physical tests.
- Previously queued self-hosted-only `Append Lesson Log` workflow run **39919548510** was freshly rechecked: **completed/cancelled** at latest API update 2026-10-24T07:42:27Z; job **120301190483** completed/cancelled **without authoritative job start/end timestamps**. Do **not** infer runtime; `LAB_COMPUTE_LOG.md` unchanged. No new workflow dispatched.
- Exact original historical archive **6/85 pending**; new originals are **not** archive restoration.
- 2520–25F0, 4400-HY-01, 4400-ESPE-01 and 4400-RET-01 external/fresh independent evaluation and actual physical selected-machine safety proof remain OPEN.
- Selected OpenPressBrake safety PLC model, old/new wiring, actual hydraulic final elements, Y1/Y2 stop/hold, backgauge/rear occupancy, stored energy, isolators and restart are **UNKNOWN**. No personnel-exposed hazardous operation or live fault-injection authorized.

## Precise next work selection

1. **Highest-value evidence gate:** privately obtain the selected-machine *old and new* safety PLC/normal controller as-built electrical diagrams, actual terminal/output class, safety PLC project identity, E-stop/guard-to-final-element chain, hydraulic Y1/Y2 physical stop and gravity hold, backgauge/rear access, lockable isolation and deliberate reset/start evidence. Do not copy private diagrams into this public repo. Use `IN-04h/i/j` and blank cutover worksheet to track restricted evidence IDs. Without this, **G3/G4 remain NOT AUTHORIZED**.
2. **Independent documentary evaluation:** administer prepared novel `4400-RET-01` handoff to a genuinely fresh learner/evaluator with independent original-source verification and blind feedback. Do not self-score or count paper competence as physical safety proof. 4400-HY/ESPE and foundational safety evaluations remain open.
3. **If selected hardware/fresh evaluator unavailable:** continue source-led 4400 safety research at highest information gain, e.g. OEM-specific safety final-element interface compatibility, contactor/valve feedback physical scope, or maintenance/restart adversarial design. Avoid duplicating prior 3000 work and avoid speculative machine-specific truth tables.
4. **Compute:** only freeze a lab if a concrete unresolved question cannot be resolved by source/engineering reasoning, and only use `[self-hosted, openpressbrake]`. If dispatch unavailable, document blocker and continue source work; never use hosted runners. Update `LAB_COMPUTE_LOG.md` only after authoritative runtime exists.
5. **Session closure:** append UTC end, actual elapsed minutes and overlap to full, verified `LESSON_LOG.md` using SHA-guarded safe append. Prior canonical session ended 2026-10-24T06:47:16.041Z, ~50.7 minutes before this start. No known overlap; external concurrent activity not independently excluded.

**Release freeze:** `RETAINED PLC != RETAINED SAFETY FUNCTION`; `24V AUX != SAFETY OUTPUT`; `CONTROL CONTACT OPEN != CONTACTOR PHYSICALLY OPEN`; `PLC READY != HYDRAULIC/GRAVITY SAFE`. Source reading does not authorize personnel-exposed operation.
