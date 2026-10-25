# 4400 safety continuation — EDM-01 / MIRROR-01 exact reset, feedback and contactor evidence
**Session start 2026-10-25T14:31:41.181Z UTC.** Supersedes the 2026-10-25T13:40:09Z HOLD/FILT/VALVE checkpoint **for work selection only**. Closed 1000/2000/F02/3000 work remains closed; earlier safety evidence remains intact.

## Governance and gates
START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, safety index/research/intake, blind protocol/score and LAB_COMPUTE_LOG reviewed. Primary 4400 safety priority. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** Selected OpenPressBrake physical Y1/Y2 stop, gravity hold, pressure isolation, front/rear guarding, rescue, deliberate restart, actual relay/contactor identity and external evaluation **UNKNOWN**. No people-exposed hazardous operation authorized.

## Seven original artifacts — created and independently fetched from main
1. [Pilz/OMRON/SICK original manufacturer reset/EDM source audit](../research/4400_PILZ_OMRON_SICK_EDM_RESET_EDGE_DEFAULT_CONFIG_AND_CONTACTOR_PROOF_AUDIT_2026-10-25.md).
2. [EDM-01 integrated safety module](../safety-course/4400_EDM_01_CONTACTOR_FEEDBACK_RESET_EDGE_AND_FRESH_MOTION_MODULE_2026-10-25.md).
3. [EDM-01 twenty PAPER technician cases](../safety-course/4400_EDM_01_TWENTY_TECHNICIAN_CASES_AND_BLANK_WITNESS_2026-10-25.md).
4. [EDM-01 twelve documentary gates NOT RUN](../safety-course/4400_EDM_01_TWELVE_GATE_NO_ENERGY_REVIEW_2026-10-25.md).
5. [EDM-01 independent unseen evaluator PREPARED/NOT RUN](../evaluation/4400_EDM_01_INDEPENDENT_UNSEEN_RESET_EDM_TRANSFER_HANDOFF_2026-10-25.md).
6. [Schneider/Siemens mirror versus guided NC source audit](../research/4400_SCHNEIDER_SIEMENS_MIRROR_NC_VS_GUIDED_AUX_EDM_VARIANT_SOURCE_AUDIT_2026-10-25.md).
7. [MIRROR-01 twelve PAPER replacement cases](../safety-course/4400_MIRROR_01_TWELVE_REPLACEMENT_AND_EDM_FAULT_CASES_2026-10-25.md).

**Totals:** seven original artifacts, **32 unscored PAPER cases**, **12 documentary gates NOT RUN**, one independent evaluator handoff **PREPARED/NOT RUN**. All seven source-to-course artifacts independently fetched from main; learner index now **394 relative markdown links / 378 distinct targets** by string parse (not a full repository-wide target-existence audit). Start marker, index, research plan, curriculum, selected physical intake and progress updated. No Safety Design Package section increment claimed; its last confirmed §11EW remains intact.

## Manufacturer-source findings and limits
- **DOC-CONFIRMED:** Pilz PNOZ s4 2015 21396-EN-14 distinguishes auto/simple manual/monitored rising/falling start and warns that bridged manual start may automatically re-enable after safeguard restoration; 41–42/Y32 auxiliary not safety outputs. Later Pilz editions exist and were not assumed equivalent.
- **DOC-CONFIRMED:** OMRON G9SE instruction sheet: illustrated forcibly guided NC feedback, manual OFF→ON→OFF reset, G9SE-221-T auto mode re-enable after off-delay if input recovered; component safety level does not transfer automatically to machine.
- **DOC-CONFIRMED:** SICK C4000 8012249/YT69/2016-02-25: internal reset can re-enable OSSDs while external machine restart interlock still required, EDM detects certain contactor faults, **factory default EDM deactivated**, and replacement configuration must be rechecked. Product-specific EDM timing is not a universal stopping-time claim.
- **DOC-CONFIRMED:** Schneider FA136111/FA142116 distinguishes IEC 60947-4-1 main-pole mirror NC from IEC 60947-5-1 auxiliary guided contacts; exact TeSys K 0601 vs 0610 mirror differences, base NC/optional auxiliary qualification. Schneider HTML table for some optional blocks is ambiguously rendered; **UNKNOWN** exact optional suffix without datasheet/certificate. Siemens 2023 official PDF indexed but direct open 403; do not promote to directly inspected claim.
- **INFERENCE:** independent reset/EDM/fresh ordinary start, qualified mirror-contact replacement, physical final-element stop/hold/isolation, anti-bypass usability. **SOURCE-CONFIRMED:** no new LinuxCNC code. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **UNKNOWN:** selected installed machine, PL/SIL, timing, pressure, independent physical witness, evaluator scores.

## Exact next-work selection
**A (highest):** qualified owner/team restricted as-built OpenPressBrake G0 packets A–G plus conditional `IN-03b/IN-05b/IN-10b`: exact safety relay/PLC and guard/ESPE config, monitored reset mode and visibility, EDM circuit and mirror NC part numbers, all final elements, Y1/Y2 chambers/pressure/gravity, mechanical support, rescue and isolation. Public repo receives status-only IDs. No personnel-exposed work before qualified G0/G1 and G2 proof.
**B:** genuinely information-separated external evaluation (existing HOLD/FILT/VALVE or new EDM-01 handoff), with privately sealed novel OEM source and reference *before* learner exposure. Do not self-score or edit FEEDBACK_SCORE_LOG without real independent result.
**C:** if A/B blocked, rotate to a **distinct** safety/4000 source or implementation question with real information gain (e.g., a selected guard/relay component's failure path, diagnostics and rearm), not repetitive 3000 manufacturing content or invented labs. Preserve edition and source-access limitations.
**Compute:** no simulation/build/test/synthesis/benchmark or Actions dispatch; hosted **0 min**, self-hosted **0 min**; no new authoritative runtime, LAB_COMPUTE_LOG unchanged. Local runner assignment blocker last observed unresolved; do not use hosted fallback. External scores unchanged. No physical tests. No selected-machine safety authorization.

## Overlap
Previous canonical session ended 2026-10-25T13:51:44.670Z; this session started 2026-10-25T14:31:41.181Z (39.94-minute gap). No known same-curriculum overlap in canonical log or observed sequential main writes; external concurrency cannot be excluded. Actual end/elapsed must be safely appended to full LESSON_LOG immediately before exit.
