# Active continuation — 4400-RST-01 power return, EDM and LinuxCNC internal E-stop authority
**Session UTC start:** 2026-10-24T18:31:45.533Z, recorded in `checkpoints/2026-10-24T183145Z-session-start-safety.md` **before substantive research**. **SOURCE-READING / NOT GRADUATED / NO PHYSICAL TEST.** Supersedes 17:36Z BLK-01 checkpoint for next-work selection; preserves all previous evidence.

## Current governance and active branch
Read START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, blind protocol/score log, LAB_COMPUTE_LOG, latest 17:36Z BLK-01 checkpoint, safety-course index, research plan and selected-machine intake. Closed 1000/2000/F02/3000 remain GRADUATED/CLOSED. Priority: 4000-series LinuxCNC/OpenPressBrake **safety**, not routine board development or old 3300. Prior session ended 17:43:09Z; start gap **48.61 min**, no known overlap (external concurrency not independently excluded).

## Seven new original artifacts
1. [Direct original Pilz/Rockwell OEM reset/EDM audit](../research/4400_RESET_POWER_RETURN_EDM_WELDED_CONTACTOR_OEM_SOURCE_AUDIT_2026-10-24.md).
2. [SICK EDM error-reset manufacturer-indexed warning with original-PDF access caveat](../research/4400_SICK_EDM_ERROR_RESET_UNEXPECTED_SWITCH_ON_MANUFACTURER_INDEXED_AUDIT_2026-10-24.md).
3. [RST-01 non-graduated integrated safety module](../safety-course/4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md).
4. [18 learner-visible PAPER technician scenarios](../safety-course/4400_POWER_RETURN_EDM_RESET_TECHNICIAN_CARD_2026-10-24.md).
5. [Blank selected-machine qualified physical witness](../safety-course/4400_POWER_RETURN_EDM_AS_BUILT_BLANK_WITNESS_2026-10-24.md).
6. [Independent fresh-AI evaluator contract](../evaluation/4400_RST_01_FRESH_POWER_RETURN_EDM_TRANSFER_HANDOFF_2026-10-24.md) **PREPARED, NOT RUN, NOT SCORED**.
7. [Pinned LinuxCNC HALUI→NML→Task→IOControl source trace](../research/4400_LINUXCNC_INTERNAL_ESTOP_RESET_HALUI_NML_IOCONTROL_SOURCE_TRACE_2026-10-24.md).

All seven original artifacts independently re-fetched from main with nonempty Git blob SHAs; all seven links present in the safety-course index. **Full historical index/tree link audit not performed**; do not claim all links valid.

## Most important evidence and limits
- **DOC-CONFIRMED original Pilz PNOZ X3P 20899-EN-13:** automatic start can rearm on restored safeguard; monitored start is different. Auxiliary 41–42 is not safety; Y32 is status; welded relay reactivation and off/on diagnostic limits are model-specific.
- **DOC-CONFIRMED original Rockwell 440R-IN046 (2012) / 440R-IN037 (2011):** AM reset does not monitor edge and can rearm after power restoration if input/reset circuits are closed; MM requires a model-specific timed close/reopen. DI cross-fault detection depends on wiring, not merely 'dual-channel' naming.
- **Manufacturer-indexed DOC only, original PDF NOT directly opened:** SICK Flexi Soft EDM Error reset with Control=1/feedback=0 can reenable Output 1/2, per 2024 p.132 and 2023 p.109 manufacturer-domain indexed excerpts. Do not claim original PDF inspected or cross-firmware generality.
- **SOURCE-CONFIRMED pinned LinuxCNC `062dc7c097693bb68e76192516cd92878dd5ecdf`:** rising `halui.estop.reset` → `EMC_TASK_SET_STATE::ESTOP_RESET` → `emcTaskSetState` → `emcAuxEstopOff` → normal HAL `iocontrol.0.user-enable-out=1` and `user-request-enable=1`. A **different** ON state calls `emcTrajEnable()`. These are **not** independent safety outputs; software E-stop reset cannot prove physical contactor/valve/ram safe. No software program-autorestart behavior inferred or tested.
- Separate restoration, fault acknowledgment, EDM eligibility, safety rearm, physical stop/hold, guard occupancy, and deliberate new normal start. No universal reset timing, PL/SIL, pressure, hydraulic valve state, stopping distance or diagnostic coverage invented.

## Physical selected-machine and evaluator status
OpenPressBrake private README checked only for architecture intent to retain an independent safety PLC, **not as-built validation**. No private drawings/details copied publicly. Exact selected controller/firmware, Y1/Y2 independent stop, gravity hold, hydraulic energy isolation, actual contactor/valve state, guard coverage, brownout/held-command response and fresh start **UNKNOWN**. Cumulative Safety Design Package **§11CM**, selected intake **IN-04ab UNKNOWN**. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. If basic minimum safe-to-operate cannot be demonstrated, no people exposed; experimental work isolated/remote with residual risk plainly stated. External independent 2520–25F0 and RST-01 evaluation remains OPEN; do not self-score 18 paper cases.

## Compute and study method
No GitHub Actions dispatched; **GitHub-hosted compute 0 min, local self-hosted compute 0 min**. No simulations, builds, benches or physical tests; no new authoritative runtime, LAB_COMPUTE_LOG unchanged. Local runner availability not tested and not assumed. Source reasoning answered the software/OEM questions; no synthetic lab justified. FEEDBACK_SCORE_LOG unchanged. Method gain: distinguish a software signal **named** E-stop from a qualified independent safety function; source-trace its actual state transition before granting any authority.

## Precise next work
1. **Highest priority, restricted selected-machine evidence:** qualified as-built safety PLC, reset/EDM mode and final-element topology, Y1/Y2 stop/hold, hydraulic pressure/accumulator and gravity boundaries, guarding/escape, no-unexpected-restart on brownout/held pedal, new deliberate start, maintenance isolation. Do not publish proprietary details or test with people exposed. If unavailable, G0/G1 HOLD.
2. **Independent information-separated fresh evaluator:** novel reset/EDM/power-return transfer challenge or existing 2520–25F0; precommit learner response, retain independent oracle and score externally, then novel transfer/retention. Do not score learner-readable cases as blind.
3. **Source follow-on only if useful:** exact selected safety PLC/final-element OEM, physical reset and feedback variant; if absent, rotate to another unblocked 4400 safety topic (e.g. redundant monitored hydraulic valve feedback discrepancy, multiple-person occupancy/rearm, safety controller power-supply/common-cause) without inventing hydraulic truth tables. Routine controller-board design belongs to separate automation.
4. Before ending any session, append actual UTC end/elapsed/overlap to the **complete** SHA-guarded `LESSON_LOG.md` and verify commit. Keep hourly automation enabled.
