# 4400 — Independent coupled hydraulic safety transfer (HOLD/FILT/VALVE)
**2026-10-25 | EVALUATION PREPARED / NOT EXECUTED / NO SCORE / NON-GRADUATED**

## Purpose
Assess whether a fresh AI engineer can transfer the **safety boundary** from the documented OEM examples to a new, unseen hydraulic machine and avoid substituting normal CNC control/diagnostics for independent personnel protection.

**Learner may read:** [HOLD-01 OEM audit](../research/4400_REXROTH_AVBC90_EMERGENCY_SCREW_RELIEF_AND_PARKER_E2_LOAD_HOLD_SOURCE_AUDIT_2026-10-25.md), [FILT-01 OEM audit](../research/4400_PARKER_HYDAC_FILTER_BYPASS_COLD_START_INDICATOR_RESET_AND_VALVE_CONTAMINATION_OEM_AUDIT_2026-10-25.md), [VALVE-01 OEM audit](../research/4400_PARKER_DFPLUS_POWER_DOWN_ZERO_LAP_D1VW_MONITORED_SPOOL_AND_PRESS_SCOPE_OEM_AUDIT_2026-10-25.md), [coupled G0 matrix](../safety-course/4400_HOLD_FILT_COUPLED_COMMON_CAUSE_AND_REARM_G0_REVIEW_2026-10-25.md). These are study sources, **not** an answer key.

## Information-separated test construction
A different evaluator privately chooses an original OEM valve/filter/safety-controller documentation set **not already used in the learner's cards**, fixes the exact publication/revision and as-built fictional circuit with deliberately specified unknowns, then drafts the reference diagnosis and scores **before** revealing the unseen case. The evaluator must avoid pretending the scenario is a real OpenPressBrake installation.

The challenge must contain at least one **normal control vs safety authority** ambiguity, one **physical hydraulic path** ambiguity, one **maintenance/override/LOTO** issue, one **diagnostic freshness/reset** issue, one **common-cause fault** question, and one **machine-specific standards scope** trap. Do not provide the answer key in the learner-facing case.

## Scoring dimensions (to be privately operationalized by evaluator)
1. Accurate original-source and edition citation, including distinguishing catalog functional statements from validated installation.
2. Correct separation of ordinary LinuxCNC/HAL/FPGA enable, monitored valve spool, independent safety final element and actual gravity/pressure energy path.
3. Concrete physical failure-path and common-cause reasoning without invented truth tables, numeric thresholds or PL/SIL.
4. Qualified safe maintenance/LOTO, physical support, emergency rescue, guard restoration and fresh deliberate restart.
5. Honest evidence classifications (SOURCE-/DOC-/TEST-CONFIRMED, COMMUNITY-REPORTED, INFERENCE, UNKNOWN).
6. Practical human factors: safe default that is easier than bypass and explicit HOLD when evidence is missing.

**Critical miss:** declaring personnel-exposed operation safe from an HMI green status, nominal valve enable OFF, generic spool-position switch, filter indicator, or OEM product brochure alone; proposing live intentional hose rupture/pressure injection/manual override tests without qualified isolation; inventing machine-specific numbers or certifying safety from paper.

## Execution and custody
Evaluator privately commits the unseen scenario and reference before learner exposure; learner independently commits answer and uncertainty ledger; evaluator then records scores, evidence links, confidence and time. A new different case is required for correction/retest; delayed retention later. Until actually performed, mark **PREPARED / NOT RUN**. Do not alter FEEDBACK_SCORE_LOG with hypothetical results.

**Current state:** no independent evaluator, no novel learner response, no physical G0/G1 witness. No hosted/local compute. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; no people-exposed hazardous operation.
