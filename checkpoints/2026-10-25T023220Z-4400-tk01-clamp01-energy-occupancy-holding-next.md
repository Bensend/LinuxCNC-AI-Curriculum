# Active 4400 safety checkpoint — 2026-10-25T02:32:20Z TK-01 / CLAMP-01
**PRIMARY SAFETY COURSE | ORIGINAL OEM DOCUMENTARY ONLY | NON-GRADUATED | G0/G1 HOLD / G3/G4 NOT AUTHORIZED**

## Governance and recovery
Read START_HERE.md then MASTER_MISSION.md, LEVEL_ORDER.md, WORK_SELECTION_POLICY.md, CURRICULUM.md, SOURCE_POLICY.md, MODULE_TEMPLATE.md, PROGRESS.md, SAFETY_COURSE_RESEARCH.md, safety-course/SAFETY_COURSE_INDEX.md, safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md, safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md, evaluation/BLIND_FEEDBACK_PROTOCOL.md, FEEDBACK_SCORE_LOG.md, LAB_COMPUTE_LOG.md and LESSON_LOG.md. This checkpoint supersedes 2026-10-25T013224Z MON-01 for *next-work selection only*. Historical evidence remains. **1000/2000/F02/3000 formally GRADUATED/CLOSED**; do not restart 3300.

UTC start recorded **2026-10-25T02:32:20.618Z** before substantive work in [durable start marker](2026-10-25T023220Z-session-start-safety.md). Session end, elapsed and overlap belong in final safely appended LESSON_LOG.md row.

## This session's durable original work — 10 artifacts, 38 learner PAPER cases
### TK-01/02/03 (seven artifacts, 22 paper cases)
- [Original Castell X Issue 7 05-25, DOLD STS and OSHA audit](../research/4400_CASTELL_X_DOLD_STS_TRAPPED_KEY_EXCHANGE_PERSONNEL_KEY_AND_LOTO_SOURCE_AUDIT_2026-10-25.md): one primary key trapped at exchange to release multiple access keys, but returned keys do not establish all-person occupancy or every physical energy source.
- [Original Castell BEMF Issue 3 motor-sensing audit](../research/4400_CASTELL_BEMF_MOTOR_STANDSTILL_AUTO_RESET_VS_HYDRAULIC_LOAD_SOURCE_AUDIT_2026-10-25.md): winding back-EMF standstill gates key release, but not gravity holding; switched-winding/DC broken-wire auto-reset instructions are not CNC restart authority.
- [Original Fortress amGardpro LOK manual audit](../research/4400_FORTRESS_LOK_LOCK_MONITOR_VS_PROCESS_ONLY_AND_ESCAPE_CONTACT_VARIANTS_AUDIT_2026-10-25.md): PTU/PTL and monitored/unmonitored process-locking contacts differ; SR/ZR/LR versus SE/LE escape releases open different contacts; OEM explicitly forbids treating LOK as mains isolator/E-stop/mechanical stop.
- [TK-01 non-graduated module](../safety-course/4400_TK_01_TRAPPED_KEY_EXCHANGE_PERSONNEL_KEYS_MOTOR_SENSING_AND_LOTO_MODULE_2026-10-25.md), [22 PAPER cases and blank selected witness](../safety-course/4400_TRAPPED_KEY_ACCESS_PERSONNEL_AND_ENERGY_TECHNICIAN_CARD_2026-10-25.md), [12-gate no-energy safety-case verification plan](../safety-course/4400_TK_01_KEY_SEQUENCE_ENERGY_OCCUPANCY_AND_RESTART_DESK_VERIFICATION_PLAN_2026-10-25.md), and [independent fresh evaluator handoff](../evaluation/4400_TK_01_FRESH_KEY_EXCHANGE_OCCUPANCY_TRANSFER_HANDOFF_2026-10-25.md) PREPARED/NOT RUN/NOT SCORED.

### CLAMP-01 (three artifacts, 16 paper cases)
- [Original Festo KP/KPE/KEC versus KEC-S and DNCKE versus DNCKE-S, SMC OEM source audit](../research/4400_FESTO_KP_KPE_KEC_S_STATIC_VS_DYNAMIC_CLAMP_SAFETY_OEM_AUDIT_2026-10-25.md): non-certified static-only standard variants versus distinct safety-related dynamic brake -S variants; air trapped by a 5/3 valve does not establish sustained vertical load holding; unbalanced-force release can lurch; dynamic overtravel varies with selected load/valve/line/wear. The original Festo 2024-hosted PDF is internally **2020/09**; DNCKE PDF **2017/10**. No model interchangeability, numeric stopping or achieved machine PL inferred.
- [CLAMP-01 non-graduated module](../safety-course/4400_CLAMP_01_STATIC_ROD_HOLD_DYNAMIC_BRAKING_AND_RELEASE_LURCH_MODULE_2026-10-25.md) and [16 PAPER cases / blank selected witness](../safety-course/4400_CLAMP_STATIC_DYNAMIC_RELEASE_TECHNICIAN_AND_WITNESS_2026-10-25.md).

## Evidence status and physical gates
**DOC-CONFIRMED** original OEM manuals and OSHA 1910.147; **SOURCE-CONFIRMED** no new LinuxCNC path (prior pinned source preserved); **TEST-CONFIRMED** none; **COMMUNITY-REPORTED** none relied upon; **INFERENCE** qualitative failure cuts and generic architecture; **UNKNOWN** selected OpenPressBrake hardware, full energy/occupancy, Y1/Y2 physical independent stop and gravity holding, hydraulic isolation, rear/backgauge guard, deliberate new start, actual PL/SIL, reaction/stop distances, and independent evaluator. Conditional IN-04am/an UNKNOWN. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 OPEN. No personnel-exposed operation. Experimental operation only under separately approved isolated/remote personnel-exclusion and residual-risk plan.

## Source-to-design package
Cumulative safety design §§11DJ–11DO and selected-machine intake IN-04am/an updated. TK and CLAMP do **not** assert Castell, DOLD, Fortress, Festo or SMC hardware is installed on OpenPressBrake. No private OpenPressBrake drawings or machine-specific truth tables copied into public curriculum.

## Highest-value next work (in order)
1. **Qualified restricted selected-machine physical evidence** for Y1/Y2 independent stop and sustained gravity hold, actual hydraulic isolators/accumulators, rear/backgauge access, escape and deliberate fresh restart. Conditional key/rod clamp modules may be marked N/A **only after qualified inventory**. Do not request hazardous testing from unqualified operators.
2. **Information-separated independent evaluation** for 2520–25F0 and/or 4400 MON/CELL/TK. No self-scoring or hidden-oracle exposure; FEEDBACK_SCORE_LOG unchanged without actual evaluator results.
3. **If both blocked**, rotate to highest-value genuinely open 4400 safety source/implementation branch after checking the safety index; avoid repeating completed OEM topics or inventing 3000 work.
4. **Compute only if a concrete unresolved question needs it.** Self-hosted [self-hosted, openpressbrake] only. Last authoritative local runner observation was canceled unassigned job 120301190483 (runner_id 0, no steps), so access remains blocked; no hosted fallback. No new workflow, lab runtime or physical test this session; LAB_COMPUTE_LOG deliberately unchanged.
5. On each future session: record UTC start before work; at end safely append complete LESSON_LOG with actual UTC end, elapsed and overlap, commit. Do not disable recurring curriculum until owner stops or genuinely no justified open work.

## Human-factors and minimum operation threshold
Make keys, guards, personal exclusion, mechanical load restraint, diagnostics and safe restart easy to use. A jammed lock, inaccessible escape, excessive nuisance trips or awkward guard alignment predicts bypass; correct the architecture rather than hiding the hazard. If the minimum independent stopping/holding/guarding/restart threshold cannot be demonstrated, do not operate with people exposed.
