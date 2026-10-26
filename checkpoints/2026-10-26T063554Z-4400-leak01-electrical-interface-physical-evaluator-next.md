# 4400 safety continuation — LEAK-01 OFF-state electrical interface, low-load contacts and transient status
**Session UTC start:** 2026-10-26T06:35:54.429478624Z (captured before substantive work and durably recorded in [start marker](2026-10-26T063554Z-session-start-safety.md)). End/elapsed/overlap to be appended to canonical complete LESSON_LOG.md using its current blob SHA immediately before final response.

## Governance
START_HERE first; MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, BLIND_FEEDBACK_PROTOCOL/FEEDBACK_SCORE_LOG, LAB_COMPUTE_LOG, current safety index/research and prior 05:36Z CYCLE/PULSE checkpoint inspected. **1000/2000/F02/3000 GRADUATED/CLOSED; 4400 SAFETY PRIMARY.** 2520–25F0 independent evaluation still OPEN; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No private machine as-built evidence.

## Original work
Six files on main:
1. [Visually inspected original Rockwell IntelliVAC 1503-UM052D-EN-P audit](../research/4400_ROCKWELL_INTELLIVAC_OFF_STATE_LEAKAGE_SNUBBER_POWER_UP_AND_DELAY_OEM_AUDIT_2026-10-26.md).
2. [Schmersal AES 2335 UE exact-part minimum-contact-load audit](../research/4400_SCHMERSAL_MINIMUM_RELAY_LOAD_AND_CONTACT_SUPPRESSION_SCOPE_AUDIT_2026-10-26.md).
3. [Practical learner module](../safety-course/4400_LEAK_01_OFF_COMMAND_LEAKAGE_MINIMUM_LOAD_AND_FRESH_REARM_MODULE_2026-10-26.md).
4. [12 PUBLIC PAPER cases UNSCORED](../safety-course/4400_LEAK_01_TWELVE_UNSCORED_OFF_STATE_INTERFACE_CASES_2026-10-26.md).
5. [8 documentary gates NOT RUN](../safety-course/4400_LEAK_01_EIGHT_GATE_NO_ENERGY_COMPATIBILITY_REVIEW_2026-10-26.md).
6. [Independent unseen evaluator handoff PREPARED / NOT RUN](../evaluation/4400_LEAK_01_INDEPENDENT_UNSEEN_INTERFACE_TRANSFER_HANDOFF_2026-10-26.md).

**DOC-CONFIRMED exact OEM:** IntelliVAC high-impedance CLOSE can stay asserted from OFF-state semiconductor leakage or RC snubber across opening contact; 2013 Table 1.A product-specific max OFF current 700 µA at 20 V AC or 900 µA at 30 V DC under stated test conditions; p. 5-2 Contactor Status relay can assert during 200 ms command window without independent physical proof; two-wire Power-Up Safety may be disabled; TDUV can delay opening. Separate Schmersal AES 2335 UE article 101180843 catalog minimum 10 VDC/10 mA switching load; Rockwell PointMax 5034-OW4I recommends suppression across inductive load coil with exact output-variant restrictions. **Do not transfer product values across interfaces or to OpenPressBrake.**

**INFERENCE:** no normal LinuxCNC/FPGA OFF, HMI status, or interposing relay automatically establishes safety-rated final-element control, physical Y1/Y2 stopping, gravity holding, hydraulic isolation or deliberate restart. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on. UNKNOWN** installed device, actual input/output thresholds, suppression, hydraulic/guard configuration, PL/SIL, stop distance, external score.

## Repository integration and integrity
CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, learner index and cumulative Safety Design Package **§11HA** updated. Six original files independently fetched and indexed **6/6**. Their three relative links resolve to two distinct existing targets (**2/2**); this is not a full historical index audit. No machine-specific drawings, credentials, secret topology or evaluator answer key published.

## Compute and gates
**0 GitHub-hosted / 0 local compute minutes.** No Actions dispatch, build, synthesis, benchmark, simulation, physical test or new authoritative job runtime. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Previously reported local runner access blocker not retested because no compute question justified; never hosted fallback. **12 PAPER cases UNSCORED, 8 desk gates NOT RUN, evaluator PREPARED/NOT RUN.** No personnel-exposed hazardous operation authorized.

## Next-work priority
1. Obtain qualified private selected OpenPressBrake Stage A evidence (seven packets A–G): independent Y1/Y2 stopping and gravity holding, hydraulic pressure-zone isolation, guards/escape, deliberate reset/restart and qualified isolated/remote witness logistics. Use existing one-screen G0 board and conditional Stage B only for installed hardware. Do not publish restricted topology.
2. Execute truly independent 2520–25F0/4400 competency evaluation under information separation. Do not self-score or inspect hidden answers.
3. If external gates remain unchanged, rotate to a genuinely distinct 4400 safety-source mechanism **after full index/research filename novelty check**. Avoid redoing LEAK/LOAD, RST/EDM, PULSE, hydraulic stop/hold or prior source-exhausted branches.
4. Keep G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED and G5 HOLD; no people-exposed operation. Separate OpenPressBrake Board Design automation owns routine controller hardware.

## Short-session continuation
After the Rockwell leakage source trace, independently inspected Schmersal minimum-load and Rockwell transient status/power-up/TDUV source details, including visual PDF tables/figures, then produced separate course, verification, evaluation and traceability artifacts. Further source-only paraphrase of these same electrical interfaces now has diminishing information gain; external physical evidence and independent evaluator remain highest-value. The hourly curriculum remains enabled.


## Same-session continuation: distinct SUPPRESS-01 branch
After the LEAK-01 source path was bounded, continued with a **separate physical mechanism**: a properly installed coil suppressor can lengthen inductive release time even after commanded OFF. Four additional originals on main: [Omron safety-relay / Schneider LC1D38BL OEM audit](../research/4400_OMRON_SAFETY_RELAY_DIODE_SUPPRESSION_RELEASE_DELAY_AND_SNEAK_CURRENT_OEM_AUDIT_2026-10-26.md), [practical module](../safety-course/4400_SUPPRESS_01_INDUCTIVE_COIL_RELEASE_DELAY_AND_STOP_BUDGET_MODULE_2026-10-26.md), [8 PUBLIC PAPER cases UNSCORED](../safety-course/4400_SUPPRESS_01_EIGHT_UNSCORED_RELEASE_AND_FEEDBACK_CASES_2026-10-26.md), [8 documentary gates NOT RUN](../safety-course/4400_SUPPRESS_01_EIGHT_GATE_DOCUMENTARY_STOP_RELEASE_REVIEW_2026-10-26.md). **DOC-CONFIRMED exact OEM:** Omron's safety-relay cautions distinguish diode/diode+Zener/CR release-time effects, sneak currents and coil LED from contact proof; Schneider 2018 LC1D38BL has built-in bidirectional suppressor and model-specific 20–30 ms opening rating. No universal stop-time figure or actual OpenPressBrake installation inferred. Cumulative Safety Design Package **§11HA–11HB**. Combined session: **10 original artifacts, 20 PUBLIC PAPER cases UNSCORED, 16 desk gates NOT RUN, LEAK external evaluator PREPARED/NOT RUN**, no physical/compute/test evidence. Source-only novelty check: prior index had no 'snubber' or 'minimum switching' heading, but related general relay/reset/feedback topics were acknowledged; no claim this is the first ever treatment of suppression in the entire repo.
