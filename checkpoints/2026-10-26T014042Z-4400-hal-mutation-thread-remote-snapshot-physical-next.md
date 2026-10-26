# 4400 safety continuation — HAL configuration semantics, stopped callbacks, remote maintenance and snapshot fidelity

**UTC session start:** 2026-10-26T01:40:42.326Z, [durable start marker](2026-10-26T014042Z-session-start-safety.md). Supersedes the 2026-10-26T00:33Z FDI/SS1E/SS2E checkpoint for work selection, **not** its unresolved physical gates. Session end, elapsed and overlap will be appended to LESSON_LOG before final commit.

## Governance/current state
START_HERE first, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, safety course index/research/traceability, blind protocol/score and lab compute reviewed. **1000/2000/F02/3000 GRADUATED/CLOSED; 4400 safety active**. 2520–25F0 independent external competency remains OPEN; no self-scoring. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed operation.

## Eleven original artifacts, all NON-GRADUATED
1. [Pinned two-revision HAL unlink/value/writer source trace](../research/4400_LINUXCNC_HAL_UNLINK_STALE_TRUE_AND_SETS_WRITER_BOUNDARY_SOURCE_TRACE_2026-10-26.md).
2. [HAL-MUTATION learner module](../safety-course/4400_HAL_MUTATION_01_STALE_INPUT_AND_INDEPENDENT_SAFETY_MODULE_2026-10-26.md).
3. [12 public HAL-MUTATION PAPER cases UNSCORED](../safety-course/4400_HAL_MUTATION_01_TWELVE_CONFIG_DRIFT_PAPER_CASES_2026-10-26.md).
4. [12-gate selected-machine no-energy desk review NOT RUN](../safety-course/4400_HAL_MUTATION_01_TWELVE_GATE_NO_ENERGY_CONFIG_REVIEW_2026-10-26.md).
5. [Independent fresh unseen evaluator handoff PREPARED/NOT RUN](../evaluation/4400_HAL_MUTATION_01_INDEPENDENT_UNSEEN_TOPOLOGY_TRANSFER_HANDOFF_2026-10-26.md).
6. [HAL-THREAD two-revision scheduler-stop source audit](../research/4400_LINUXCNC_HAL_STOP_THREADS_NO_FINAL_ELEMENT_SAFE_STATE_TWO_REVISION_SOURCE_AUDIT_2026-10-26.md).
7. [8 HAL-THREAD PAPER cases UNSCORED](../safety-course/4400_HAL_THREAD_01_EIGHT_SCHEDULER_VS_PHYSICAL_STOP_PAPER_CASES_2026-10-26.md).
8. [Optional halrmt normal-configuration authority source audit](../research/4400_LINUXCNC_HALRMT_REMOTE_TOPOLOGY_CHANGE_AUTHORITY_AND_PHYSICAL_SAFETY_BOUNDARY_2026-10-26.md).
9. [8 HALRMT PAPER cases UNSCORED](../safety-course/4400_HALRMT_01_EIGHT_REMOTE_SERVICE_CHANGE_CONTROL_PAPER_CASES_2026-10-26.md).
10. [HAL save all/allu snapshot completeness source audit](../research/4400_LINUXCNC_HAL_SAVE_ALL_VS_ALLU_UNCONNECTED_INPUT_RESTORATION_AUDIT_2026-10-26.md).
11. [8 HAL-SNAPSHOT PAPER cases UNSCORED](../safety-course/4400_HAL_SNAPSHOT_01_EIGHT_RESTORE_FIDELITY_PAPER_CASES_2026-10-26.md).

## Findings and evidence labels
**SOURCE-CONFIRMED** pinned LinuxCNC v2.9.10 and development `062dc7c097693bb68e76192516cd92878dd5ecdf`: scalar HAL input `unlink_pin` copies last signal value into disconnected dummy; `setp` rejects linked input and `sets` permits writerless ordinary signal; `halcmd stop` gates cyclic function execution rather than asserting physical safe state, development ULAPI additionally waits for in-flight callbacks; optional `halrmt` has HELLO/ENABLE-tier ordinary HAL edit/stop commands; `save all` omits unconnected input dummy `setp` while `allu` includes it. **DOC-CONFIRMED** LinuxCNC official HAL/halcmd/halrmt manuals. **TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on. INFERENCE** independent safety/final-element/physical load boundary and human-friendly service controls. **UNKNOWN** selected OpenPressBrake HAL graph, optional remote service, controller/watchdog, physical Y1/Y2 stop/hold, pressure zones, guards, PL/SIL, fresh restart and independent evaluator. **36 public PAPER cases UNSCORED; 12 G0 documentary gates NOT RUN.** No safety release.

## Durable integration
Updated CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, learner index, cumulative Safety Design Package §§11FZ–11GC and selected-machine intake. All eleven original artifacts were published directly to main; index references checked for the first nine and remaining two to verify. No simulation/build/synthesis/benchmark/physical test/Actions dispatch. **0 GitHub-hosted / 0 self-hosted compute**, no new authoritative runtime; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Local runner-access blocker previously reported, not retested (no justified compute); never use hosted fallback.

## Precise next work
1. **Qualified private selected-machine G0 evidence first:** exact independent Y1/Y2 stop and gravity hold, hydraulic pressure zones and isolation, guards/escape, service LOTO, fresh reset/rearm/start, and actual normal-control graph/remote-service/watchdog only if installed. Do not publish private as-built configuration or network details; do not infer machine physical safe state from HAL values.
2. **Independent information-separated 2520–25F0 and 4400 evaluator:** select unseen challenge, preserve learner precommitment and hidden oracle, independently score, transfer/retention. Public paper cases are not scored evidence.
3. **If external gates unchanged:** rotate to another open 4400 safety mechanism with distinct original-source evidence; avoid repeating HAL semantic branches or manufacturing 3000 work. Source reasoning first; freeze a lab only for an unresolved question requiring execution.
4. **Compute if and only if justified:** bounded local [self-hosted, openpressbrake] workflow; no GitHub-hosted runner or fallback. If unavailable, record blocker and continue source work.
5. Before ending each session: record actual UTC end, elapsed minutes and overlap status in complete LESSON_LOG with fresh blob SHA; commit, preserve recurring curriculum.

**G0/G1 HOLD**. If minimum safe-to-operate threshold is unmet, no personnel-exposed operation. Any separately approved experimental operation must be isolated/remote with all people outside hazard zone and residual risk explicitly documented.


## Final same-session synthesis extension
[HAL-SERVICE-01 four-state source-grounded service/change/rearm matrix](../safety-course/4400_HAL_SERVICE_01_FOUR_STATE_CHANGE_CONTROL_AND_REARM_MATRIX_2026-10-26.md) joins HAL unlink, stopped callbacks, optional remote edits and `save all` omissions with separate independent physical safety. **Final 12 original artifacts / 36 public PAPER cases UNSCORED / 12 G0 desk gates NOT RUN / evaluator NOT RUN / 0 GitHub-hosted and local compute.** Safety package §11GD. The precise next-work gates above remain unchanged; selected G0/G1 HOLD.
