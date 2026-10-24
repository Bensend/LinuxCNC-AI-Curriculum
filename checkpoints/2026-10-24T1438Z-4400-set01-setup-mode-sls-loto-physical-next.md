# Active continuation — 4400-SET-01 setup mode, enabling, SLS, LOTO and LinuxCNC jog source paths
**Session UTC start:** 2026-10-24T14:38:06.767Z, recorded before substantive work. **SOURCE-READING / NOT GRADUATED / NO PHYSICAL TEST.** This checkpoint supersedes the 13:38Z ESPE-02 checkpoint for next-work selection; preserve all prior open optical/selected-machine evidence and independent evaluation gates.

## Recovered governance and state
START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, 13:38Z checkpoint, safety-course index, 2570/2580 release gates, selected-machine physical intake, blind feedback protocol/log and laboratory compute ledger reviewed. 1000/2000/F02 and completed 3000 specializations remain CLOSED. Primary 4400 safety. Previous canonical session end 2026-10-24T13:47:06.546Z, **51.00 minutes** before start; no known lesson overlap, external concurrent activity not independently excluded.

## New durable originals — seven
1. [Rockwell/Pilz/Siemens OEM enabling/SLS mode-transition source audit](../research/4400_SETUP_ENABLING_SWITCH_SLS_MODE_TRANSITION_OEM_AUDIT_2026-10-24.md).
2. [OSHA setup, minor servicing and LOTO source audit](../research/4400_OSHA_SETUP_MINOR_SERVICING_LOTO_ALTERNATIVE_PROTECTION_SCOPE_2026-10-24.md).
3. [LinuxCNC 2.7/current feed-inhibit/jog documentation and pinned source divergence](../research/4400_LINUXCNC_FEED_INHIBIT_JOG_DOCUMENTATION_VERSION_DRIFT_2026-10-24.md).
4. [4400-SET-01 non-graduated integrated module](../safety-course/4400_SET_01_SETUP_MODE_ENABLING_SLS_AND_LOTO_BOUNDARY_MODULE_2026-10-24.md).
5. [18-case technician paper card](../safety-course/4400_SETUP_MODE_SLS_ENABLE_AND_RESTART_TECHNICIAN_CARD_2026-10-24.md).
6. [Blank selected-machine witness](../safety-course/4400_SETUP_MODE_AS_BUILT_WITNESS_BLANK_2026-10-24.md).
7. [Fresh independent evaluation handoff](../evaluation/4400_SET_01_FRESH_MODE_TRANSFER_HANDOFF_2026-10-24.md) PREPARED / NOT ADMINISTERED / NOT SCORED.

## New source/evidence facts
- **DOC-CONFIRMED original manufacturer PDFs:** Rockwell 2094-RM001C May 2013 printed pp. 80–82 Kinetix 6200/6500 ESM monitoring not active until DM_In OFF in cited mode, guard-open release causes configured stop fault, SLS_In must not return normal while occupied. Siemens SINAMICS G April 2021 pp.14–15 encoderless direct speed monitoring only while converter senses energized induction motor; p.19 overspeed STOP A coast vs STOP B braking. Pilz product web page three-stage OFF–ON–OFF.
- **DOC-CONFIRMED official OSHA indexed texts, original direct pages 403:** 1910.147 minor-servicing exception requires normal-production, routine, repetitive, integral and effective alternatives; 2008 letter PLC not an energy isolator; 2007 temporary testing/positioning is separate. No blanket setup exemption.
- **SOURCE-CONFIRMED at pinned LinuxCNC revisions:** v2.7.15 control.c net_feed_scale and command.c JOG_CONT/JOG_INCR new-jog gate versus master commit **062dc7c097693bb68e76192516cd92878dd5ecdf** command.c jog_inhibit gate. Pinned master **joint jogwheel** path in control.c lines 1125–1185 separately checks net_feed_scale. This qualifies the broad current manual "feed-inhibit not jogs" statement: exact jog path and enables mask matter. Exact first-changing commit, already-moving jog behavior and runtime UNKNOWN.
- **INFERENCE:** ergonomic legitimate setup, independent mode/occupancy/restart safeguards reduce foreseeable defeat. **UNKNOWN:** installed OpenPressBrake components, actual Y1/Y2 stop/hold, guarding, mode logic, qualified safe speed, OSHA exception applicability, physical values, PL/SIL.
- Cumulative Safety Design Package §§11CA–11CC, selected-machine conditional IN-04v, learner index, curriculum/research plan and progress updated. Index **192 relative Markdown links / 188 distinct**; seven new original artifacts individually fetched and present. Complete repository-tree missing-link audit **NOT run**; do not claim historical zero missing.

## Release and compute gates
Selected physical VAL/PT **NOT RUN**, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Eighteen cases PAPER ONLY. No independent fresh evaluation or score. No workflow dispatched, **zero GitHub-hosted Actions minutes**, **zero local self-hosted laboratory compute**, no simulations or physical testing, no new authoritative runtime. LAB_COMPUTE_LOG.md and FEEDBACK_SCORE_LOG.md unchanged. Historical exact archive backlog **6/85 pending**. No personnel-exposed hazardous operation authorized; any experimental motion must be isolated/remote with people outside hazard and residual risk reviewed.

## Precise next-work selection
1. Briefly check for restricted actual OpenPressBrake Y1/Y2 hydraulic/electrical/safety/guard/mode drawings and an independent evaluator result. Do not copy private as-built materials into public curriculum. If available, map real independent stop, gravity hold, guarding, occupancy, energy isolation and fresh restart; only qualified measured physical witnesses can close release gates.
2. If selected setup mode has a three-position switch, SLS or guard-open movement, obtain exact model/firmware, original current OEM manual, as-built mode and output paths, entry delay, monitored feedback, panic/release behavior, exclusive mode selection, occupancy and physical final-element response. If not installed, mark device-specific intake N/A after evidence; generic lessons remain transferable.
3. For actual LinuxCNC installed version, if source behavior affects a concrete engineering decision, trace **all** jog entry paths, enables mask and already-active jog dynamics; current pinned master joint wheel path differs from command.c keyboard jog path. Freeze a bounded **local-only** test only if source cannot answer the specific unresolved control question. Never claim LinuxCNC jog/feed-inhibit as personnel-safety authority.
4. Obtain genuinely independent fresh evaluator/oracle without learner contamination; do not self-score published 18 cases.
5. If selected physical/evaluator gates remain blocked, rotate to a **different** high-information 4400 safety source branch. Do not manufacture 3000 work or simulations. Preserve latest session end/overlap in full SHA-guarded LESSON_LOG immediately before exit, and commit; keep hourly curriculum enabled.

## Learning-method correction
Source-trace a documentation contradiction before teaching it as universal: current motion(9) says feed-inhibit not jogs, but pinned master has **distinct keyboard and joint-wheel jog paths**. Separating command acceptance, running planner dynamics and physical stop avoids a false safety conclusion. Manufacturer examples and OSHA exceptions must likewise remain product/task-scoped.
