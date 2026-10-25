# Active 4400 safety checkpoint — 2026-10-25T03:34:34Z DUST-01/02/03/04
**PRIMARY SAFETY COURSE | SOURCE/OEM DOCUMENTARY ONLY | NON-GRADUATED | G0/G1 HOLD / G3/G4 NOT AUTHORIZED**

## Governance and current state
Read `START_HERE.md` first; then `MASTER_MISSION.md`, `LEVEL_ORDER.md`, `WORK_SELECTION_POLICY.md`, `CURRICULUM.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, `PROGRESS.md`, `SAFETY_COURSE_RESEARCH.md`, safety index/design package/selected-machine intake, blind protocol/score log, lab compute ledger and complete lesson log. This supersedes `2026-10-25T023220Z-4400-tk01-clamp01-energy-occupancy-holding-next.md` for **next-work selection**, not prior evidence. 1000/2000/F02/3000 remain GRADUATED/CLOSED; 2520–25F0 and 4400 independent competency gates remain OPEN. No old 3300 manufacturing work.

UTC session start **2026-10-25T03:34:34.572Z**, recorded before substantive work and durably committed in [start marker](2026-10-25T033434Z-session-start-safety.md). Final UTC end/elapsed/overlap belongs in safely appended complete `LESSON_LOG.md`.

## Original published artifacts (8, 18 learner PAPER cases)
1. [OSHA/NFPA660/CSB + LinuxCNC Task source audit](../research/4400_OSHA_NFPA660_CSB_WOOD_DUST_LEV_FIRE_VS_CNC_COOLANT_PIN_SOURCE_AUDIT_2026-10-25.md) — wood-dust occupational exposure and combustible collector fire are distinct physical propositions; `iocontrol.0.coolant-flood` is a requested output, not capture.
2. [DUST-01 integrated non-graduated safety module](../safety-course/4400_DUST_01_WOOD_ROUTER_LEV_CAPTURE_FIRE_AND_CNC_COMMAND_BOUNDARY_MODULE_2026-10-25.md) — normal CNC, qualified hood capture, independent collector fire/deflagration response, independent machine protective stop and deliberate restart.
3. [18 learner-visible PAPER cases and blank selected witness](../safety-course/4400_DUST_01_TECHNICIAN_SCENARIOS_AND_BLANK_WITNESS_2026-10-25.md) — NOT SCORED/NOT RUN.
4. [Fresh external evaluator handoff](../evaluation/4400_DUST_01_FRESH_CAPTURE_FIRE_CONTROL_TRANSFER_HANDOFF_2026-10-25.md) — PREPARED, no hidden answer inspected, not executed.
5. [DUST-02 pinned 2.9/development source comparison](../research/4400_LINUXCNC_2_9_VS_DEVELOPMENT_COOLANT_REQUEST_AND_ESTOP_VERSION_BOUNDARY_2026-10-25.md) — 2.9 Task abort -> `EMC_TOOL_ABORT` -> `ioControl.cc` or `ioControl_v2.cc` clears flood; development direct Task HAL writes including ON-state OFF. No physical timing inference.
6. [DUST-03 direct Donaldson CPC Rev6/HSE LEV audit](../research/4400_DONALDSON_POWERCORE_FILTER_DELTA_P_VENT_AND_SPRINKLER_OEM_AUDIT_2026-10-25.md) — filter Delta-P is not each-hood capture, explosion vent discharge must avoid personnel, sprinkler water load can threaten collector support, competent commissioning baseline needed.
7. [14-gate no-energy collector/LEV/fire desk review](../safety-course/4400_DUST_01_NO_ENERGY_COLLECTOR_CAPTURE_AND_FIRE_DESK_VERIFICATION_PLAN_2026-10-25.md) — all selected gates UNKNOWN/NOT RUN.
8. [DUST-04 pinned M8/M9 remap/interpreter queue source trace](../research/4400_LINUXCNC_M8_M9_INTERP_QUEUE_REMAP_VS_PHYSICAL_LEV_READINESS_SOURCE_TRACE_2026-10-25.md) — interpreter `settings->flood`, queued canonical command, Task status/HAL output not immediate fan/hood readiness.

All source claims pinned to `LinuxCNC/linuxcnc@062dc7c097693bb68e76192516cd92878dd5ecdf` and 2.9 `a33293f46575c809e082e0806e79ab996f982513` where relevant. No claim that any Donaldson/wood collector is installed on OpenPressBrake.

## Evidence status and authority
**SOURCE-CONFIRMED:** exact M8/M9 interpreter remap/queue -> NML -> Task -> normal HAL output, 2.9 separate iocontrol abort path. **DOC-CONFIRMED:** OSHA wood-dust/LEV/fire guidance, NFPA 660 2025 publisher scope only, distinct CSB U.S. Ink incident, Donaldson CPC Rev6 original IOM, HSE LEV commissioning. **INFERENCE:** shared-collector and cutting-permissive architecture. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** 3400 prior forum examples, not relied on for physical safety. **UNKNOWN:** selected material and dust explosibility, adopted NFPA/code/AHJ, collector/hood, airflow/exposure, vent/suppression/structural adequacy, physical stop/restart, actual PL/SIL and independent evaluation.

Cumulative Safety Design Package §§**11DP–11DT**, conditional selected-machine intake **IN-04ao UNKNOWN**. No physical test, lab, simulation, synthesis or compute dispatched; `LAB_COMPUTE_LOG.md` unchanged. `FEEDBACK_SCORE_LOG.md` unchanged. Prior local self-hosted `[self-hosted, openpressbrake]` runner job 120301190483 was canceled unassigned, no steps; access remains last-observed blocked, no hosted fallback. No personnel-exposed hazardous operation authorized.

## Highest-value next work
1. **Qualified restricted OpenPressBrake physical evidence** for Y1/Y2 independent stopping, sustained gravity holding, hydraulic isolation/accumulator, backgauge/rear guarding and deliberate new start. The dust-specific IN-04ao may be marked N/A only if qualified selected inventory proves it absent; do not confuse that with OpenPressBrake machine release.
2. **Information-separated independent competency evaluation** for 2520–25F0 and/or 4400 MON/CELL/TK/DUST; preserve hidden oracles and precommitments. No self-scoring.
3. If both remain blocked, rotate to highest-information-gain distinct 4400 safety source/implementation after inspecting safety index. Avoid another cosmetic dust document or old 3000 work.
4. Only freeze a lab for a concrete unresolved source/control question; use **only** `[self-hosted, openpressbrake]` if available. No GitHub-hosted Actions minutes. A documentary answer does not require a simulation.
5. Maintain precise evidence labels, safe human-factors design, physical energy-removal boundary and no people-exposed operation absent minimum independent safety proof.

## Short-session continuation
After DUST-01 OSHA/NFPA/CSB and Task source, continued into DUST-02 **different 2.9 iocontrol architecture**, DUST-03 **original Donaldson/HSE physical capture/vent/structural source**, and DUST-04 **M8/M9 remap/queue** instead of stopping after one document. Remaining questions are site-physical or external-evaluator gated; no synthetic test justified. End may use context-density/coherent-branch-complete exception rather than producing low-value unrelated work.

## Final publication integrity audit
Untruncated recursive `main` tree **4,350 entries**; safety-course learner index **308 relative Markdown links / 293 distinct targets / zero missing**. All eight original research/module/evaluation/desk artifacts and this checkpoint independently fetched from `main` with nonempty blob SHA. No GitHub-hosted/self-hosted Actions, no new authoritative job runtime, no physical tests or independent evaluation; compute and feedback ledgers deliberately unchanged. The 18 technician cases are PAPER only. This is a non-graduated source/design extension; OpenPressBrake physical safety gates remain open.
