# Active continuation — 4400-RAD-01/02/03 radio STOP and mobile HMI; selected physical evidence next
**UTC start:** 2026-10-24T21:32:59.060283636Z, clock-captured before substantive work; [durable start marker](2026-10-24T213259Z-session-start-safety.md). **SOURCE RESEARCH / NON-GRADUATED / NO PHYSICAL TEST.** Supersedes [20:38Z ACC-02/VAC-01 checkpoint](2026-10-24T203825Z-4400-acc02-vac01-gas-fluid-vacuum-physical-next.md) for next-work selection; preserve historical evidence.

## Current governance and open gates
START_HERE first; read MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, evaluation blind protocol and score log, LAB_COMPUTE_LOG, safety index and selected intake. 1000/2000/F02/3000 **GRADUATED/CLOSED**; 4000 safety course primary, separate board-design automation owns routine electronics. External 2520–25F0 and current 4400 fresh-AI evaluation OPEN; no learner answer contamination or self-score. Selected OpenPressBrake Y1/Y2 independent stopping, hydraulic/gravity holding, energy isolation, guarding, reset and deliberate restart **UNKNOWN / NOT RUN**; retained safety PLC design intent in private OpenPressBrake README is not physical validation. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No exposed-person hazardous operation.

## Eleven new original artifacts
1. [Original Tele Radio R15 v09/T19 v04 OEM manual audit](../research/4400_TELE_RADIO_R15_T19_WIRELESS_STOP_CONFIGURATION_AND_RESTART_OEM_AUDIT_2026-10-24.md).
2. [Scanreco G5 CAN/MOSFET manufacturer cross-check](../research/4400_SCANRECO_G5_CAN_STOP_OUTPUT_VS_ORDINARY_CAN_CROSSCHECK_2026-10-24.md).
3. [RAD-01 non-graduated module](../safety-course/4400_RAD_01_WIRELESS_PENDANT_STOP_LINK_LOSS_AND_RESTART_MODULE_2026-10-24.md).
4. [16 RAD-01 PAPER technician scenarios](../safety-course/4400_RADIO_PENDANT_LINK_LOSS_OWNERSHIP_AND_REARM_TECHNICIAN_CARD_2026-10-24.md).
5. [Blank conditional selected physical witness](../safety-course/4400_RADIO_PENDANT_SELECTED_MACHINE_BLANK_WITNESS_2026-10-24.md).
6. [Fresh independent evaluator handoff](../evaluation/4400_RAD_01_FRESH_RADIO_STOP_TRANSFER_HANDOFF_2026-10-24.md) PREPARED / NOT RUN / NOT SCORED.
7. [IEC 62745 publisher scope and FME mobile HMI guideline provenance audit](../research/4400_IEC62745_FME_MOBILE_DEVICE_CABLELESS_SAFETY_AUTHORITY_SCOPE_2026-10-24.md).
8. [10 RAD-02 PAPER consumer-device scenarios](../safety-course/4400_MOBILE_HMI_VS_CERTIFIED_RADIO_STOP_TECHNICIAN_CARD_2026-10-24.md).
9. [R15 v09/v11 direct original manual edition comparison](../research/4400_TELE_RADIO_R15_V09_V11_VERSION_SCOPE_AND_POWER_CYCLE_AUDIT_2026-10-24.md).
10. [8 RAD-03 PAPER firmware/transmitter transfer scenarios](../safety-course/4400_RADIO_MANUAL_VERSION_AND_PAIRING_CHANGE_TECHNICIAN_CARD_2026-10-24.md).
11. [Staged qualified commissioning and 14-fault-path plan](../safety-course/4400_RADIO_PENDANT_STAGED_COMMISSIONING_AND_FAULT_REVIEW_PLAN_2026-10-24.md), **PLAN ONLY**, not test authorization.

All eleven independently re-fetched from main with nonempty Git blob SHA and expected nonzero content; index 253 relative links / 247 distinct targets, all 11 new artifacts referenced. Complete historical repository-tree link audit NOT performed this session; prior full 240/236 zero-missing audit preserved. No selected radio installation asserted.

## New high-consequence findings
- **DOC-CONFIRMED original Tele Radio R15 v09** (54 pp., receiver SW0014-14v24+) and T19-02 v04 (36 pp.): PLd Cat3 applies to exact qualified **radio STOP subsystem**, not entire machine. R15 safety configuration requires continuous mode, all relays OFF on lost link, <=500 ms **radio** timeout, login/logout ON, Custom ID OFF and Require start ON. Discontinuous mode 5 **cancels** classified STOP. Require start OFF can reenable radio stop relays on receiver power return from incoming packets; that is not a machine fresh start. Transmitter may remain logged in after power-off; OEM no-load shift check includes battery removal.
- **DOC-CONFIRMED original R15 v11** (57 pp.): safety applicability adds T29-12 to v09's T19-02; both manuals gate on SW0014-14v24+; v11 explicitly directs receiver power-cycle after PLd-to-non-PLd configuration change. This does not prove T29 interchangeability or justify energized service.
- **DOC-CONFIRMED official IEC publisher**: IEC 62745:2017 scope includes cableless portable operator stations. **Full licensed normative text NOT inspected**. **DOC-CONFIRMED FME industry guideline** (uploaded 2024, internal status March 2023): consumer phones/tablets are not intrinsically certified safety controllers; fixed local controls, communication-loss handling, authorization and no automatic restart are practical guidance. FME 0.5 s is **not** a universal machine stop limit.
- **DOC-CONFIRMED manufacturer web only Scanreco**: separate certified STOP output versus ordinary CAN/MOSFET/PWM. Original full installation manual not inspected; no exact Scanreco physical truth.
- **INFERENCE:** a retained LinuxCNC/FPGA command, radio handoff, wrong transmitter, hidden operator, receiver power return, stuck final element or pressure dump can create dangerous physical behavior despite a healthy UI or receiver LED.
- **UNKNOWN:** selected radio device presence, certification, end-to-end PL/SIL, physical stop distance, hydraulic truth, Y1/Y2 stop/hold, guard/occupancy and rearm.

## Cumulative and compute
Safety Design Package **§§11CS–11CV**, selected conditional **IN-04ag UNKNOWN**. 11 original documents; **34 learner-visible PAPER cases** (16+10+8) plus 14 paper fault paths. Independent evaluator prepared only. No GitHub-hosted workflow, local self-hosted workflow, simulation, build, synthesis, bench or physical test dispatched; **0 hosted and 0 local compute minutes**, no authoritative runtime; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged.

## Precise next work
1. **Highest priority:** qualified restricted selected OpenPressBrake Y1/Y2 independent stop, gravity load holding, hydraulic isolation, safety PLC/final elements, guarding, reset/restart and physical witness. Confirm selected radio/consumer remote device presence before activating conditional IN-04ag; otherwise mark device-specific N/A after inventory, not machine safety N/A. No private wiring in public curriculum.
2. **Independent information-separated evaluation:** 2520–25F0 or RAD-01 handoff to a genuinely separate evaluator, no hidden answer before learner commitment; do not self-score.
3. **If both blocked:** choose a distinct, underdeveloped 4400 safety source/implementation branch with real evidence gain; do not manufacture 3000 work, duplicate paper cards or routine board circuitry. Potential high-value branch: emergency-rescue motion authorization and residual load energy on a multi-person cell, only if not already covered.
4. **Before ending:** exact UTC end, elapsed minutes and overlap in complete SHA-guarded LESSON_LOG; verify post-write; commit current state. Keep hourly curriculum enabled; no personnel-exposed hazardous operation until minimum physical safety threshold is demonstrated.
