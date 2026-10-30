# 2026-10-30T014024Z — 4400 AMR fleet, manual-mode and payload safety continuation
**Session start UTC:** 2026-10-30T01:40:24.208Z (see [start witness](2026-10-30T014024Z-session-start-safety.md)). **NON-GRADUATED**.

## State and governance
START_HERE read first. 1000, 2000, F02 and completed 3000 remain CLOSED; 4400 safety course is primary. Full canonical index searched directly for AGV/AMR/mobile robot/fleet manager/docking: no existing mechanism; predecessor scanner, robot and cell safety studies preserved. Public G0 A–G board still has no qualified redacted status; restricted evidence receipt UNKNOWN. 2520–25F0 independent/fresh evaluation OPEN, not self-scored. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.

## New source depth
1. [AMR-FLEET-01](../research/4400_AMR_FLEET_01_OMRON_2019_2025_FLEET_WIFI_NOT_INTERLOCK_AND_EDGE_BARRIER_OEM_AUDIT_2026-10-30.md): original Omron I616-E-06 2019 safety guide explicitly says Fleet Manager over Wi-Fi is **not interlocked collision prevention**, scanner-slot mutual geometry can misstate footprint, physical dropoff barriers and traffic safety are separate. Official 2025 LD-250 I642-E-09 indexed manual corroborates fleet-vs-physical-interlock distinction, but 27-MB PDF not fully fetched. ISO 3691-4:2023 official scope includes AMRs; 2026 draft not published.
2. [AMR-MODE-01](../research/4400_AMR_MODE_01_OMRON_JOYSTICK_LIDAR_BYPASS_STOP_ENVELOPE_AND_REARM_OEM_AUDIT_2026-10-30.md): original I616 2019 p27 SF4 manual joystick **bypasses LIDAR zone detection**; p11 E-stop release plus motor enable can resume retained motion after two seconds. I680-E-02 2023 original integration guide ties stopping to payload/CoG/deceleration and field sizing. **Edition trap:** 2019 SF1 general 300 mm/s prose vs 2023 LD-250 first-field 225 mm/s table, not a universal threshold. [Eight unscored paper scenarios](../safety-course/4400_AMR_01_FLEET_MODE_PAYLOAD_AND_FRESH_RESTART_EIGHT_CASE_FIELD_CARD_2026-10-30.md) address transfer, docking, load and bypass human factors.
3. Integrated into CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, full learner index and cumulative Safety Design Package §§11NA–11NB. No hidden evaluator, no machine-specific acceptance.

## Evidence and compute
**DOC-CONFIRMED** named manufacturer editions and ISO public scope; **SOURCE-CONFIRMED** repository novelty/predecessor; **INFERENCE** cross-machine architecture; **TEST-CONFIRMED none**; **UNKNOWN** selected AMR, safety field config, fleet version, cell interface, physical stop, retained load, geometry, site and evaluator. No workflow, simulation, build, physical test or operation; GitHub-hosted 0 min and self-hosted 0 min. Local runner dispatch and panel-PC physical isolation unverified; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged.

## Exact next work
1. Check **qualified redacted** Stage A A–G public status and information-separated 2520–25F0 evaluator results once; do not infer private evidence absence.
2. If a mobile cell is actually selected, obtain model/serial/firmware, exact safety-guide revision, scanner safety-zone export, payload/CoG, fleet/traffic topology, transfer safety interlock, site dropoffs and qualified stop/restart plan. No unqualified tests or generic speed/PL/stop-distance assumptions.
3. Otherwise AMR source branch is at documentary information-gain stop. Rotate to a genuinely new 4400 safety mechanism after canonical index synonym scan, or deepen a specific existing unresolved original-source contradiction that changes a practical hazard proposition.
4. No GitHub-hosted compute. Local [self-hosted, openpressbrake] only after bounded unresolved question, verified dispatch access and independent physical isolation.
5. Immediately before end append full LESSON_LOG with UTC end, elapsed, overlap using verified current blob SHA; commit/re-fetch. Recurring curriculum stays enabled. No personnel-exposed hazardous operation.


## Same-session original conveyor/lift application source follow-through
[AMR-TRANSFER-01](../research/4400_AMR_TRANSFER_01_OMRON_I680_CONVEYOR_LIFT_HANDSHAKE_VS_INDEPENDENT_STOP_SOURCE_AUDIT_2026-10-30.md) and [four UNSCORED paper cases](../safety-course/4400_AMR_TRANSFER_01_HANDSHAKE_IS_NOT_SAFE_TRANSFER_FOUR_CASE_FIELD_CARD_2026-10-30.md) add directly inspected I680 printed pp.3-2–3-6 OEM application power diagram, normal handshake I/O and independent transfer considerations. Manufacturer's safety relay plus optional safety PLC in example does not prove a selected safety function. Transfer jam, gravity load, fresh restart and independent energy removal all UNKNOWN/NOT RUN. Design package §11NC. No additional compute or machine operation.
