# 4400 safety continuation — FDI discrepancy fault vs STO and external SS1 braking authority

**UTC start:** 2026-10-26T00:33:55.040Z, [durable start marker](2026-10-26T003355Z-session-start-safety.md). Supersedes the 2026-10-25T23:33Z ACC-SAF/FIRE checkpoint for work selection; earlier physical evidence and non-graduated status unchanged.

## Current state and governance
START_HERE first; MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, safety syllabus/index, external blind score and lab ledger inspected. **1000/2000/F02/3000 GRADUATED/CLOSED; 4400 safety active**. External 2520–25F0 and 4400 independent competency still OPEN; no self-scoring. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed operation.

## Six original artifacts (all NON-GRADUATED)
1. [Siemens S210 asymmetric F-DI discrepancy fault→STO original OEM audit](../research/4400_SIEMENS_S210_FDI_ASYMMETRIC_DISCREPANCY_FAULT_TO_STO_SOURCE_AUDIT_2026-10-26.md)
2. [FDI-01 learner module](../safety-course/4400_FDI_01_DISCREPANCY_ERROR_VS_PHYSICAL_STOP_AND_REARM_MODULE_2026-10-26.md)
3. [12 FDI public PAPER cases UNSCORED](../safety-course/4400_FDI_01_TWELVE_ASYMMETRIC_INPUT_AND_STOP_PAPER_CASES_2026-10-26.md)
4. [12-gate documentary review NOT RUN](../safety-course/4400_FDI_01_TWELVE_GATE_INPUT_TO_PHYSICAL_STOP_DOCUMENTARY_REVIEW_2026-10-26.md)
5. [Siemens S210 SS1 external-stop/no-OFF3/no-monitoring/timer OEM audit](../research/4400_SIEMENS_S210_SS1_EXTERNAL_STOP_NO_RAMP_MONITORING_AND_TIMER_SOURCE_AUDIT_2026-10-26.md)
6. [8 SS1E public PAPER cases UNSCORED](../safety-course/4400_SS1E_01_EIGHT_BRAKING_AUTHORITY_AND_TIMER_PAPER_CASES_2026-10-26.md)

**DOC-CONFIRMED** direct Siemens original *SINUMERIK MC/SINAMICS S210 Safety Integrated Commissioning Manual* 07/2021 A5E47011139B AC §§5.1.1–5.2.6, 7.4, 9.3.1–9.3.2. Initially LOW F-DI discrepancy can generate F01611 but allow STO deselection before p9658 expires if both go HIGH; initially HIGH F-DI demand invokes SS1/STO after debounce but error may precede STO. Time-controlled SS1 OFF3 ramp not monitored; SS1 external-stop requires higher-level deceleration setpoint, with no OFF3/SBR/SAM/standstill monitoring in cited extended variant; timer may outlive deselection. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied upon; INFERENCE** architecture and failure paths; **UNKNOWN** selected Siemens equipment, parameters, actual Y1/Y2/pressure/guard/holding/restart, PL/SIL, independent evaluator. Siemens separate application note 109810528 direct-open 403, not relied upon for full-text assertions.

## Durable integration and compute
CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, learner index, cumulative Safety Design Package §§11FV–11FW, selected-machine intake updated. **20 public PAPER cases UNSCORED, 12 documentary gates NOT RUN, external evaluator NOT RUN.** No simulations, builds, synthesis, benchmarks, physical tests or Actions dispatch; **0 GitHub-hosted / 0 local lab minutes**, no new authoritative job runtime; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Local self-hosted runner blocker not retested (compute not justified), never hosted fallback.

## Precise next work
1. **Qualified private selected-machine evidence first:** actual drive/hydraulic/ram architecture, independent Y1/Y2 stop/hold, gravity restraint, pressure zones, guarding/escape, service LOTO and fresh rearm. Exact Siemens variants only if installed; keep private as-built drawings out of public repository. No invented parameters, PL/SIL, stopping distances or valve truth tables.
2. **Independent competency:** run information-separated 2520–25F0 and 4400 fresh handoffs, preserving hidden-answer separation; public 20 cases are teaching material, not scored evidence.
3. **If external gates unchanged:** rotate to distinct authoritative 4400 safety mechanism (not repeat FDI, SS1E or accumulator); prioritize inspectable original source and practical low-cost independent safety architecture. No synthetic labs.
4. **Compute only if justified:** local runner [self-hosted, openpressbrake] exclusively; record blocker if dispatch unavailable, no hosted fallback.
5. Immediately before end: append full LESSON_LOG with actual UTC end, elapsed and overlap using current blob SHA, commit, preserve hourly task.

**G0/G1 HOLD.** If minimum safe-to-operate threshold not met, no personnel-exposed operation. Any experimental operation must be independently authorized, isolated/remote with people excluded and residual risk documented.

## Same-session SS2E-01 extension (information-gain continuation)
[Original Siemens S210 external SS2E / p9553 / delayed SOS / retained-torque audit](../research/4400_SIEMENS_S210_SS2E_EXTERNAL_DECELERATION_SOS_TORQUE_RETENTION_SOURCE_AUDIT_2026-10-26.md) and [8 additional public PAPER cases UNSCORED](../safety-course/4400_SS2E_01_EIGHT_SOS_EXTERNAL_STOP_AND_MAINTENANCE_PAPER_CASES_2026-10-26.md). **DOC-CONFIRMED** §7.4.5.3 pp.229–231: SS2E has external setpoint authority and no SBR/SAM/standstill monitoring during p9553; subsequent SOS is monitored standstill with torque retained, not SS1E's STO. **Final session 8 originals / 28 PAPER cases UNSCORED / 12 desk gates NOT RUN / evaluator NOT RUN**; cumulative package §11FX, selected intake, index and course plan updated. No compute, physical tests or release. Same physical/evaluator/runner next-work gates above remain active.
