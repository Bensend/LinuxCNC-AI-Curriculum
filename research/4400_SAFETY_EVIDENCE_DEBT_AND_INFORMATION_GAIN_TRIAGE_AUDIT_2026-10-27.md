# 4400 safety study-method audit — documentary coverage versus independent evidence debt
2026-10-27 | Process/selection evidence | Not a machine safety validation.

## Question
Does publishing another safety module or public scenario bank meaningfully advance the **critical path** when the 2520–25F0 independent evaluator and OpenPressBrake G0/G1 physical release evidence are still missing?

## Direct repository evidence
- [PROGRESS.md](../PROGRESS.md) and [canonical safety-course index](../safety-course/SAFETY_COURSE_INDEX.md): 1000/2000/F02/3000 are closed; 4400 safety is active. 2520–25F0 independent information-separated evaluation remains OPEN/NOT RUN. Selected OpenPressBrake independent Y1/Y2 stop/hold, guarding, hydraulic isolation and restart remain G0/G1 HOLD.
- [Latest preceding 04:36Z checkpoint](../checkpoints/2026-10-27T043626Z-4400-opb-pilz-gate-return-source-precedence-physical-evaluator-next.md): exact Pilz/CNC interface and MAX22216 source-precedence work is design-source evidence, not installed safety program or physical proof. Source-only branch is now gated by actual new rendered circuit/program/field evidence.
- [This session's AIR-CLEAN field module](../safety-course/4400_AIR_CLEAN_01_DEADEND_PRESSURE_CHIP_SHIELD_MIST_AND_RESTART_FIELD_MODULE_2026-10-27.md) and [SOLVENT-CLEAN field module](../safety-course/4400_SOLVENT_CLEAN_01_CHEMICAL_VAPOR_IGNITION_AND_RESTART_FIELD_MODULE_2026-10-27.md) add **20 public paper scenarios UNSCORED** and **22 documentary gates NOT RUN**. These are useful retrieval/transfer teaching material, not independent competence or physical release.
- [Pinned LinuxCNC M62/M63/Task/TP/HAL source trace](4400_AIR_CLEAN_01_LINUXCNC_PINNED_M62_M63_QUEUED_AIR_OUTPUT_SOURCE_TRACE_2026-10-27.md) does close a genuine **source-level uncertainty** (queued output OFF versus immediate output and M2/M30 program end) without needing a redundant simulation.
- [FEEDBACK_SCORE_LOG](../evaluation/FEEDBACK_SCORE_LOG.md) has no new independent 2520–25F0 scores; [LAB_COMPUTE_LOG](../LAB_COMPUTE_LOG.md) has no new authoritative local compute this session. No physical test occurred.

## Findings
1. **Evidence quantity is not competence.** Scenario and gate counts may grow while all remain unexecuted. This is not bad if they teach a new mechanism, but counting them as completed validation would be a serious category error.
2. **Source-depth can be higher value than adding another hazard title.** The M62/M63 direct trace changed a concrete operational misconception: M2/M30 stops coolant, but the inspected handlers do not explicitly clear motion DIO. No test was required to establish the narrow source proposition.
3. **Selected-machine proof is the dominant open safety gate.** Repeated generic safety lessons cannot establish independent ram stop, gravity retention, safety-PLC muting, hydraulic isolation, guard protection or restart for the real press brake.
4. **Blind evaluation is a separate critical path.** Public paper scenarios are exposed to the learner; they cannot substitute for an unseen, information-separated evaluator and actual score.
5. **Human factors matter in release work.** A low-cost guard or cleaning process that operators routinely defeat must be redesigned, not papered over with a new warning module.

## Selection rule for next sessions (recommendation adopted in WORK_SELECTION_POLICY)
At every 4400 safety session boundary, first ask whether there is **new** qualified physical Stage A/Stage B evidence or an independent evaluator result. If yes, reconcile that evidence before new modules. If not, source-trace a **specific unresolved high-consequence mechanism** only if it changes an architecture decision, physical witness, diagnostic discriminator, or transfer capability; record exact predecessor comparison. When the documentary branch reaches a genuine information-gain stop, rotate to a different open branch rather than manufacturing more UNSCORED scenarios. New modules should state their *incremental physical witness* and *why that witness is not already taught*. Keep the scheduler enabled.

## Not a graduation or operation release
No selected OpenPressBrake physical safe state, safety PLC program, PL/SIL, stop time, hydraulic valve truth table, pressure threshold or evaluator score is established here. **G0/G1 HOLD** and no personnel-exposed hazardous operation. No hosted/local runner or physical compute; laboratory ledger unchanged.
