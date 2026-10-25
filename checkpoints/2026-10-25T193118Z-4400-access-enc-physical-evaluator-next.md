# 4400 safety continuation — ACCESS-01 / ENC-01 / COMM-01 OEM guard release, encoder integrity and disabled commissioning mode
**UTC start:** `2026-10-25T19:31:18.674Z`, captured before substantive work and committed in [start marker](2026-10-25T193118Z-session-start-safety.md). Supersedes [18:39 SD-01/SD-02 checkpoint](2026-10-25T183937Z-4400-sd01-sd02-guard-release-physical-next.md) for work selection only.

## Governance / status
Read START_HERE first, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, BLIND_FEEDBACK_PROTOCOL, FEEDBACK_SCORE_LOG, LAB_COMPUTE_LOG, safety index, cumulative package and selected-machine intake. 1000/2000/F02/3000 **GRADUATED/CLOSED**. 4400 SAFETY priority; routine board design elsewhere. 2520–25F0 independent external/fresh evaluator **OPEN**, no self-scoring. Selected OpenPressBrake **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**; independent Y1/Y2 stop/hold, hydraulic pressure, gravity, guarding/inside escape, rescue and fresh command **UNKNOWN**.

## Nine original artifacts
1. [Rockwell original Kinetix 2013 timed unlock / status-only / polarity audit](../research/4400_ROCKWELL_KINETIX_SAFE_STOP_UNCHECKED_UNLOCK_STATUS_ONLY_AND_POWER_TO_LOCK_SOURCE_AUDIT_2026-10-25.md)
2. [ACCESS-01 integrated module](../safety-course/4400_ACCESS_01_TIMED_UNLOCK_MONITOR_ONLY_AND_FAULT_POLARITY_MODULE_2026-10-25.md)
3. [16 public ACCESS PAPER cases](../safety-course/4400_ACCESS_01_SIXTEEN_FALSE_SAFE_STATE_PAPER_CASES_2026-10-25.md)
4. [12 blank ACCESS G0 documentary gates](../safety-course/4400_ACCESS_01_TWELVE_GATE_NO_ENERGY_GUARD_SPEED_REACTION_WITNESS_2026-10-25.md)
5. [Fresh independent ACCESS evaluator handoff](../evaluation/4400_ACCESS_01_INDEPENDENT_FRESH_SAFE_ACCESS_TRANSFER_HANDOFF_2026-10-25.md)
6. [Exact Rockwell single-encoder coupling / motion-dependent diagnostics audit](../research/4400_KINETIX_SINGLE_ENCODER_SIL_CLAIM_COUPLING_EXCLUSION_AND_MOTION_DEPENDENT_DIAGNOSTICS_AUDIT_2026-10-25.md)
7. [10 ENC PAPER transfer cases](../safety-course/4400_ENC_01_TEN_COUPLING_DIAGNOSTIC_AND_SAFETY_RATING_PAPER_CASES_2026-10-25.md)

8. [Rockwell Kinetix Disabled-mode original source audit](../research/4400_ROCKWELL_KINETIX_DISABLED_MODE_SAFE_OUTPUTS_MOTION_POWER_ENABLED_SOURCE_AUDIT_2026-10-25.md)
9. [10 COMM commissioning return PAPER cases](../safety-course/4400_COMM_01_TEN_DISABLED_MODE_AND_COMMISSIONING_RETURN_PAPER_CASES_2026-10-25.md)

All nine independently fetched from main after final integration. Safety index now **430 Markdown links / 413 distinct targets** by regex (verify final); all nine new references present; not a full historical link-existence audit.

## Direct OEM evidence
**DOC-CONFIRMED:** Original Rockwell *Kinetix 6200/6500 Safe Speed Monitoring Safety Reference Manual*, **2094-RM001C-EN-P May 2013**, manufacturer PDF https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/2094-rm001_-en-p.pdf directly opened; printed pages **18–19, 60, 65, 84** visually inspected; pp.50–54,58–64 read.
- **STO without standstill checking** unlocks after configured maximum stop time **regardless of actual speed** (p.60).
- **SLS Status Only** reports a safety signal but does **not** initiate overspeed stop; downstream safety logic/final element needed (p.84).
- **Power to Lock** DC_Out OFF = unlocked, including selected fault states; already-unlocked can remain unlocked (p.65).
- Exact Kinetix **SS1 not for vertical axes** warning; SS2 retains drive power (pp.58–59), not hydraulic holding proof.
- Single-encoder up-to-PL-e capability **conditional** on PM brushless motor, field-oriented closed-loop commutation, suitable Sin/Cos feedback and **excluded shaft slip/breakage from encoder through load** (p.19). Dual encoder upper capability depends on independence/CCF; encoder1 determines speed, encoder2 diagnostic (pp.18,50). Some diagnostics need motion; **six-month** statement product-specific, **not** a universal maintenance interval or license for hazardous operation (p.18).
- **Disabled safety option paradox** (printed p.22, original visually inspected): all safety functions and diagnostics disabled and outputs in safe state while commissioning motion power remains enabled; does **not** imply automatic motion. This is a third distinct source branch, not an OpenPressBrake configuration claim.
- Pilz official IEC 61800-5-2 guidance independently separates monitored-only functions from active safety reactions: https://www.pilz.com/en-US/support/lexicon/articles/200448 .

**SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** independent safety chain and practical guard-access workflow. **UNKNOWN:** installed devices, actual motor/load/hydraulic architecture, fault exclusions, measured stop time, pressure, selected PL/SIL, physical proof, evaluator.

## Integration and compute
CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, safety index, selected-machine intake and cumulative safety package **§§11FH–11FJ** updated. **36 public PAPER cases UNSCORED**, **12 G0 documentary gates NOT RUN**, fresh external evaluator **PREPARED/NOT RUN**. No simulation/build/synthesis/benchmark, physical fault injection, GitHub Actions dispatch or new authoritative runtime. **0 GitHub-hosted minutes, 0 local self-hosted lab minutes**; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Prior self-hosted runner-access blocker remains unresolved; not retested because compute unjustified; never hosted fallback. No people-exposed operation authorized.

## Exact next-work priority
1. Qualified, privately held **selected OpenPressBrake G0**: machine ID, all Y1/Y2 independent stop and gravity hold, hydraulic isolation/stored pressure, service restraints, exact guard/escape/occupancy, selected safety device/controller/config and final-element fault behavior, deliberate reset/fresh motion, as-built drawings and actual measured stopping/release data under an authorized plan. Never copy proprietary as-built details into public repo. G1/G2 separate gates; no G3/G4.
2. Obtain genuinely independent unseen 2520–25F0 and 4400 evaluator results; preserve hidden oracle separation and only log real scores. ACCESS evaluator handoff is prepared, not executed.
3. If both blocked, rotate to highest-value **new** 4400 safety question with an inspectable manufacturer manual or LinuxCNC source that genuinely resolves an uncovered failure mode. Avoid duplicating the many existing generic guard/standstill/reset modules. Candidate: verified *mechanical load-to-encoder fault exclusion* for an exact new machine type or guard power-loss/escape architecture **only** if original source adds a materially new discriminator.
4. Only if a concrete unresolved executable question requires compute, use bounded workflow targeting **[self-hosted, openpressbrake]**. If repository dispatch is blocked, record and continue source work; **never** GitHub-hosted runners.

## Short-session continuation check
After original OEM ACCESS-01 uncovered three false-safe-state modes, rotated to **two distinct original-OEM evidence paths**: (1) conditional single-encoder mechanical fault exclusion/motion-dependent diagnostics, then (2) Disabled safety option with motion power available despite safe-state outputs. Produced 20 additional transfer cases and a fresh external evaluator handoff. No synthetic lab needed because manufacturer documents resolve product-specific questions. Safety branch remains NON-GRADUATED pending independent evaluator and qualified physical proof. Actual session UTC end/elapsed/overlap to be appended to complete LESSON_LOG immediately before exit.
