# 4400 safety continuation — HYD-HOLD / HYD-STOM / HYD-SWAP

**UTC start:** 2026-10-26T03:32:09.141Z, [durable start marker](2026-10-26T033209Z-session-start-safety.md). End/elapsed/overlap to be recorded immediately before exit in LESSON_LOG.

## Governance/current state
Read START_HERE first; MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, BLIND_FEEDBACK_PROTOCOL/FEEDBACK_SCORE_LOG, LAB_COMPUTE_LOG, latest 02:32Z MECH/SLACK checkpoint and safety syllabus/index. **1000/2000/F02/3000 GRADUATED/CLOSED; 4400 safety primary.** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. External 2520–25F0 and 4400 evaluator NOT RUN.

## Nine original artifacts and evidence
1. [Parker HAS N no-load-hold, PO-check, counterbalance, trapped pressure OEM audit](../research/4400_PARKER_HAS_LOAD_HOLD_CODE_N_MANUAL_RELEASE_PO_CHECK_AND_TRAPPED_PRESSURE_OEM_AUDIT_2026-10-26.md).
2. [Bosch STOM hydraulic partial STO/SDE/SLS vs ram hold OEM audit](../research/4400_BOSCH_REXROTH_STOM_HYDRAULIC_STO_SDE_SLS_VS_RAM_HOLD_OEM_SCOPE_AUDIT_2026-10-26.md).
3. [Practical module](../safety-course/4400_HYD_HOLD_01_COUNTERBALANCE_PO_CHECK_STO_AND_GRAVITY_REARM_MODULE_2026-10-26.md).
4. [12 unscored paper cases](../safety-course/4400_HYD_HOLD_01_TWELVE_UNSCORED_VALVE_AND_RAM_CASES_2026-10-26.md).
5. [12 unexecuted no-energy documentary gates](../safety-course/4400_HYD_HOLD_01_TWELVE_GATE_NO_ENERGY_SELECTED_MACHINE_REVIEW_2026-10-26.md).
6. [Six-state authority matrix](../safety-course/4400_HYD_HOLD_01_SIX_STATE_STOP_HOLD_SERVICE_REARM_AUTHORITY_MATRIX_2026-10-26.md).
7. [Independent unseen evaluator handoff](../evaluation/4400_HYD_HOLD_01_INDEPENDENT_UNSEEN_HYDRAULIC_FAULT_TRANSFER_HANDOFF_2026-10-26.md), PREPARED/NOT RUN.
8. [Parker E2/Sun T-11A interchange/opposite adjustment OEM audit](../research/4400_PARKER_E2_SUN_T11A_PHYSICAL_INTERCHANGE_OPPOSITE_ADJUSTMENT_DIRECTION_AUDIT_2026-10-26.md).
9. [8 unscored substitution cases](../safety-course/4400_HYD_SWAP_01_EIGHT_UNSCORED_REPLACEMENT_ERROR_PAPER_CASES_2026-10-26.md).

**DOC-CONFIRMED:** exact Parker HAS N is no load holding despite installed PO-check cartridge with manual override engaged; PO check not overrunning load-lowering device; counterbalance can retain trapped pressure and thermally relieve; Bosch STOM manufacturer variant claims concern hydraulic partial functions, not automatically Y1/Y2 gravity retention; Parker E2*1 T-11A physical interchange has Parker-reported opposite adjustment direction from Sun. **INFERENCE:** machine safety architecture and change-control paths. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none. UNKNOWN:** selected OpenPressBrake actual cylinders, manifold, pilots, load-holding/pressure zones, PL/SIL, stop distance, guards, rescue, physical tests, evaluator score. **20 PAPER cases UNSCORED, 12 documentary gates NOT RUN.**

## Next-work decision
1. Seek qualified **private Stage A G0** machine revision and as-built independent Y1/Y2 stop/hold, hydraulic isolation/pressure zones, guards/escape and fresh restart. Stage B only if hydraulic components/valves installed; otherwise qualified N/A. Do not publish proprietary drawings or dangerous test procedures.
2. External information-separated 2520–25F0 and 4400 evaluation: unseen challenge, learner precommit before oracle, independent score, transfer/retention. Do not self-score public cases.
3. HYD-HOLD source question now bounded; **if G0/evaluator unchanged rotate to a genuinely distinct 4400 safety mechanism** with original authoritative evidence, not redundant 3000 work or synthetic tests.
4. No compute justified this session; **0 GitHub-hosted / 0 local compute**, no Actions dispatch. Existing local runner-access blocker not retested. If later needed, only [self-hosted, openpressbrake]; no hosted fallback. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged absent new authoritative runtime/score.
5. Before exit, safe append full LESSON_LOG using fresh blob SHA; record UTC end, elapsed and overlap; commit and verify.

**G0/G1 HOLD.** No personnel-exposed hazardous operation authorized. Experimental work only if separately qualified, isolated/remote with people outside hazard zone and residual risk documented.


## Same-session extension: HYD-LOX-01 and source novelty correction
- [ROSS manual hydraulic L-O-X source audit](../research/4400_ROSS_HYDRAULIC_LOX_T1_T2_BLEED_VS_CYLINDER_HOLD_ISOLATION_SOURCE_AUDIT_2026-10-26.md), [8 more unscored paper cases](../safety-course/4400_HYD_LOX_01_EIGHT_NO_ENERGY_BLEED_VS_HOLD_PAPER_CASES_2026-10-26.md), [hold/bleed matrix](../safety-course/4400_HYD_LOX_01_DUAL_OBJECTIVE_HOLD_AND_DEPRESSURIZE_DECISION_MATRIX_2026-10-26.md). **DOC-CONFIRMED** manual OFF-only lock, T1 downstream bleed, T2 pump bypass, optional Port A, no automatic safety shutoff. **INFERENCE** gravity support and pressure-release conflict. Actual selected circuit UNKNOWN; no physical test.
- [Novelty correction](../research/4400_HYD_HOLD_PRIOR_EVIDENCE_DUPLICATION_RECONCILIATION_AND_SELECTION_RULE_2026-10-26.md): Parker HAS N/R/manual override was already documented 2026-10-23. The new Parker HAS audit is a reinspection/extension, not a new discovery. Preserve prior source evidence and check index/research filenames before new branch selection.
- **Final 13 new files (one revalidation and one process correction), 28 PAPER cases UNSCORED, 12 documentary gates NOT RUN, external evaluator NOT RUN, 0 hosted/local compute, G0/G1 HOLD.** This hydraulic source branch now bounded; next qualified private G0 and independent evaluator, else rotate to distinct 4400 safety branch. No Actions dispatch, physical test or machine release. UTC end/elapsed/overlap must still be safely appended immediately before exit.


## Final HYD-BB-BS-01 / conditional G0 Stage B extension
- [Original ROSS HBB block-and-bleed vs HBH block-and-stop OEM audit](../research/4400_ROSS_HBB_BLOCK_BLEED_VS_HBH_BLOCK_STOP_MONITORING_AND_LOTO_SCOPE_AUDIT_2026-10-26.md), [10 more PAPER cases](../safety-course/4400_HYD_BB_BS_01_TEN_UNSCORED_BLEED_VS_STOP_PAPER_CASES_2026-10-26.md), [four-function card](../safety-course/4400_HYD_BB_BS_01_STOP_HOLD_BLEED_MAINTENANCE_FOUR_FUNCTION_COMPARISON_2026-10-26.md). **DOC-CONFIRMED:** HBB vent vs HBH hold are different product functions; HBB warns downstream checks may impede bleed and requires full LOTO for maintenance. HBH external monitoring and manufacturer claimed load-holding do not establish selected-machine PL/SIL or physical Y1/Y2 restraint.
- [Restricted conditional Stage B hydraulic-only intake](../safety-course/4400_OPENPRESSBRAKE_G0_STAGE_B_HYDRAULIC_ONLY_RESTRICTED_EVIDENCE_CARD_2026-10-26.md) limits first contact to existing Stage A A–G; qualified reviewer opens H1–H10 only after hydraulic presence confirmed. No dangerous test procedure, no pressure/valve truth table.
- **Final 17 new files (including one Parker revalidation and one process correction), 38 public PAPER cases UNSCORED, 12 documentary gates NOT RUN, external evaluator NOT RUN, 0 hosted/local compute, G0/G1 HOLD.** Closed 1000/2000/F02/3000 unchanged. No physical test or machine release. Hydraulic manufacturer source path now bounded; next qualified G0/evaluator, else distinct 4400 safety original-source work. UTC end/elapsed/overlap to be appended immediately before exit.


## Final independent repository verification and short-session continuation check
All **17 new curriculum/research/evaluator/intake files** were individually fetched from main (17/17 accessible) and all 17 filenames were confirmed referenced in the learner safety-course index (17/17). The new sources were checked against the older Parker HAS, Rexroth A-VBC-90/Parker E2, and HYDAC hose-fuse research; an explicit [novelty reconciliation](../research/4400_HYD_HOLD_PRIOR_EVIDENCE_DUPLICATION_RECONCILIATION_AND_SELECTION_RULE_2026-10-26.md) preserves the already-known 2026-10-23 Parker N/R finding. **Short-session continuation performed:** after Parker reinspection, rotated to distinct Bosch STOM, Parker E2 substitution, ROSS manual L-O-X and ROSS HBB/HBH safety functions, then produced conditional Stage B handoff. Further source-only hydraulic rephrasing would be redundant without as-built G0; highest-value next remains qualified physical evidence or independent evaluator, otherwise another distinct 4400 branch. **17 new files; 38 unscored public PAPER cases; 12 desk gates NOT RUN; 0 compute; G0/G1 HOLD.**
