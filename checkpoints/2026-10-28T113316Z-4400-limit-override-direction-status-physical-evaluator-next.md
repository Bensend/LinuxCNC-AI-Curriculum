# 2026-10-28T11:33:16.586Z — 4400 source-traced shared hard-limit override and status-scope checkpoint
[UTC start marker](../sessions/2026-10-28T113316Z-4400-safety-session-start.md) was committed before substantive work. Read START_HERE, mission/governance, LEVEL_ORDER, CURRICULUM, WORK_SELECTION_POLICY, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, newest 10:39Z checkpoint, safety syllabus/index/entry card, Stage A G0 board, evaluation protocol/log and LAB_COMPUTE_LOG. 1000/2000/F02/3000 remain CLOSED; 4400 safety priority; 2520–25F0 external evaluator OPEN.

## New evidence
- [Pinned LinuxCNC v2.9.10 source audit](../research/4400_LIM_01_LINUXCNC_2910_SHARED_HARD_LIMIT_OVERRIDE_DIRECTION_AND_STATUS_SCOPE_SOURCE_AUDIT_2026-10-28.md) and [field card](../safety-course/4400_LIM_01_SHARED_LIMIT_RECOVERY_DIRECTION_AND_STATUS_FIELD_CARD_2026-10-28.md).
- SOURCE-CONFIRMED `command.c`: override mask captures **all currently tripped** joint limits; `joint_jog_ok` explicitly cannot know safe direction if both + and - bits are set and returns before its own direction check.
- SOURCE-CONFIRMED `taskintf.cc`: per-joint `overrideLimits` is assigned a **global any-mask** boolean; `halui.cc` exposes it per joint. Not per-joint override proof.
- SOURCE-CONFIRMED `control.c`: masking ordinary hard-limit fault and clearing on completed jog/transition; no general timeout proved. Homing `HOME_IGNORE_LIMITS` is a different exception.
- DOC-CONFIRMED pinned AXIS/homing manuals warn about separate-direction checking and wrong-side homing crashes. No runtime test; no machine physical evidence.
- Source-novelty check: prior repository search found no `joint_jog_ok` or `overrideLimitMask` study. No new unscored exam bank, no new owner questionnaire.

## Gate and compute
No new restricted A–G as-built evidence or independent 2520–25F0 score was observed in the checked public repository. Installed Pilz/AKAS, Y1/Y2 final elements, gravity holding, guarding, isolation, fresh restart remain UNKNOWN. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** GitHub-hosted compute 0; self-hosted compute 0; no simulation/build/workflow/physical test. LAB_COMPUTE_LOG unchanged.

## Precise next work
First check for restricted qualified Stage A A–G and external evaluator results. If absent, select a genuinely nonduplicate 4400 safety question, prioritizing source-level ordinary-control/independent-safety contradictions, physical final elements and human-factor defeat resistance. Preserve pinned versions, no invented safety performance numbers. No hosted compute; if a frozen question eventually needs runtime, only [self-hosted, openpressbrake] if dispatchable. Before end append UTC end/elapsed/overlap to **complete** LESSON_LOG using current SHA and expected-head Git commit; verify. Keep recurring curriculum enabled.

## Same-session pinned documentation reconciliation
Pinned v2.9.10 Code Notes (blob `75b7fe7135edcdbac3163f38a6f997d6c9d53a08`) retain outdated “all limits / broken until explicit override” prose despite v2.9.10 source mask+clear. Inspected master `command.c`/`control.c`/`taskintf.cc` retain the key code paths; master Code Notes (blob `e3b72e492a9a2eb54562afc6af40a3b4992a80cc`) describe tripped-only mask and completed-jog clearing. No runtime test; source is controlling evidence for pinned code claim. OpenPressBrake public main still `92cf5424be90f45f664ba2652dc725b38e1895f9`; external FEEDBACK_SCORE_LOG unchanged.

**Additional pinned wiring proof:** v2.9.10 `docs/src/config/stepper.adoc` blob `588cca46281e8ad8da5aa2e6c3786214755ee112` shows shared Xlimits connected to both +/− pins and warns the faulted switch/axis cannot be identified. `HOME_IS_SHARED`, `HOME_IGNORE_LIMITS`, jog override are distinct. Its `iocontrol` E-stop loopback is a teaching example, not independent personnel protection.
