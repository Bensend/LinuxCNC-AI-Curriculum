# 4400 safety — HOLD-01 / FILT-01 / VALVE-01 continuation checkpoint
**Session started 2026-10-25T13:40:09.004Z UTC.** This checkpoint supersedes the 2026-10-25T12:31:22Z PANEL/BOND checkpoint for **work selection**, without erasing graduated 1000/2000/F02 or prior 3000/4000 evidence. End/elapsed/overlap will be recorded in the complete LESSON_LOG.md using its current blob SHA.

## Governance and current gates
Read START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, safety course index/research plan, selected physical intake, latest previous checkpoint, independent feedback protocol/log and LAB_COMPUTE_LOG. **1000 and 2000 formally GRADUATED/CLOSED, F02 graduated, completed 3000 specialization preserved.** Primary priority remains 4400/2500 safety. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No personnel-exposed hazardous operation.

## Original outputs (11 artifacts, all fetched back and linked in index)
1. [Bosch Rexroth A-VBC-90 DX/SX, Parker E2 and standards-scope original audit](../research/4400_REXROTH_AVBC90_EMERGENCY_SCREW_RELIEF_AND_PARKER_E2_LOAD_HOLD_SOURCE_AUDIT_2026-10-25.md).
2. [HOLD-01 integrated module](../safety-course/4400_HOLD_01_CYLINDER_SIDE_LOAD_HOLD_RELIEF_OVERRIDE_AND_RESTART_MODULE_2026-10-25.md).
3. [18 HOLD-01 PAPER technician cases and blank witness](../safety-course/4400_HOLD_01_18_TECHNICIAN_CASES_AND_BLANK_WITNESS_2026-10-25.md).
4. [12 HOLD-01 no-energy gates NOT RUN](../safety-course/4400_HOLD_01_12_GATE_NO_ENERGY_REVIEW_2026-10-25.md).
5. [HOLD-01 independent evaluator PREPARED/NOT RUN](../evaluation/4400_HOLD_01_FRESH_VALVE_OVERRIDE_TRANSFER_HANDOFF_2026-10-25.md).
6. [Parker/HYDAC filtration bypass, cold-start and indicator original audit](../research/4400_PARKER_HYDAC_FILTER_BYPASS_COLD_START_INDICATOR_RESET_AND_VALVE_CONTAMINATION_OEM_AUDIT_2026-10-25.md).
7. [14 FILT-01 PAPER cases](../safety-course/4400_FILT_01_FILTER_BYPASS_INDICATOR_MEMORY_AND_COLD_START_TECHNICIAN_CARD_2026-10-25.md).
8. [HOLD/FILT common-cause and G0 matrix](../safety-course/4400_HOLD_FILT_COUPLED_COMMON_CAUSE_AND_REARM_G0_REVIEW_2026-10-25.md).
9. [Parker DFplus/D1VW enable/power-down/monitored-spool original audit](../research/4400_PARKER_DFPLUS_POWER_DOWN_ZERO_LAP_D1VW_MONITORED_SPOOL_AND_PRESS_SCOPE_OEM_AUDIT_2026-10-25.md).
10. [12 VALVE-01 PAPER cases](../safety-course/4400_VALVE_01_ENABLE_OFF_POWER_DOWN_MONITORED_SPOOL_TECHNICIAN_CARD_2026-10-25.md).
11. [HOLD/FILT/VALVE information-separated transfer handoff PREPARED/NOT RUN](../evaluation/4400_HOLD_FILT_VALVE_COUPLED_UNSEEN_TRANSFER_HANDOFF_2026-10-25.md).

**Totals:** 11 original artifacts, 44 unscored PAPER cases, 12 desk gates NOT RUN, two evaluator handoffs PREPARED/NOT RUN. New index links all 11 verified by GitHub blob fetch; safety index currently 387 local markdown links, 371 distinct targets by simple string count (not a complete repository-wide link-existence audit). Cumulative design package extended §11EU–§11EW; G0 conditional intake IN-04ay/az/ba UNKNOWN. No new LinuxCNC source code, physical test or evaluator score.

## Durable source findings and limitations
- **DOC-CONFIRMED:** Rexroth 2022 A-VBC-90 check/metering has pilot, overload/shock relief and factory-sealed emergency lowering E-screw opening paths; OEM says restore and lock E screw. ISO 8643:2024 publisher scope is excavator/backhoe boom/arm lowering control; 2022 OEM reference does not specify edition. ANSI B11.3-2022 publisher scope is power press brakes; paid normative clauses not inspected. Exact selected machine UNKNOWN.
- **DOC-CONFIRMED:** Parker original filtration handbook bypass-to-downstream vs bypass-to-tank vs no-bypass, indicator independent of bypass, cold/peak-flow differential pressure; HYDAC 2022 electric/B auto-reset vs BM retained history and optional thermal lockout. Parker CF/RF printed p. 7 troubleshooting chart visually inspected after text extraction failed. Parker 1997 MMV-IPC printed p. 10 explicitly describes continued flow after coils OFF when spool sticks. These are **product-specific OEM examples**, not installed-machine failure findings.
- **DOC-CONFIRMED:** Parker DFplus 2024 manual explicitly says normal enable input is not accident-prevention safety; for zero-lap spool, power-down can be approx. 10% open rather than neutral. Parker D1VW 2024 start/end inductive monitoring and no-manual-override T hydraulic-press DIN EN ISO 16092-3 ordering note **do not transfer automatically to power press brakes**.
- **INFERENCE:** independent stop/hold/LOTO/rescue/rearm and candidate common-cause fault paths. **SOURCE-CONFIRMED** no new LinuxCNC source; **TEST-CONFIRMED none; COMMUNITY-REPORTED none; UNKNOWN** selected valve/filtration/safety architecture, physical Y1/Y2 hold, numerical stopping/pressure, PL/SIL and external competency.

## Precise next-work priority (do not invent data)
**Priority A:** obtain qualified **restricted** OpenPressBrake G0 as-built identity, hydraulic Y1/Y2 chamber/pilot/return/relief/accumulator, actual valve full ordering codes and manual override, filter bypass/indicator/cold-start, physical mechanical support, independent safety final elements, front/rear guarding, rescue, electrical/hydraulic isolation and deliberate restart evidence. Use public [one-page request](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md), [selected physical intake](../safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) and [coupled matrix](../safety-course/4400_HOLD_FILT_COUPLED_COMMON_CAUSE_AND_REARM_G0_REVIEW_2026-10-25.md). Keep proprietary drawings outside this public repo; publish only status IDs. G0/G1 HOLD until qualified evidence; G2 NOT RUN; G3/G4 NOT AUTHORIZED.

**Priority B:** independent information-separated unseen safety competency evaluation using the prepared handoffs; only record real scores in FEEDBACK_SCORE_LOG.

**Priority C if A/B genuinely information-gain blocked:** rotate to highest-value open safety/4000 module with authoritative OEM/standards or LinuxCNC source evidence; avoid duplicating older 3000 work and avoid repetitive safety catalogs without new mechanisms. Do not let routine controller-board development displace safety.

## Compute and overlap
No simulation, build, test suite, synthesis, benchmark or Actions dispatch. **GitHub-hosted 0 minutes; self-hosted local 0 minutes.** LAB_COMPUTE_LOG unchanged (no new authoritative runtime). Previous local runner access blocker remains unverified/unresolved; do not fall back to hosted. No known overlapping same-curriculum session at start: previous logged end 12:36:29.470Z, start 13:40:09.004Z; current GitHub writes checked, no competing safety author observed. External overlap cannot be independently excluded. Final actual UTC end/elapsed/overlap belongs in LESSON_LOG, appended safely immediately before exit.
