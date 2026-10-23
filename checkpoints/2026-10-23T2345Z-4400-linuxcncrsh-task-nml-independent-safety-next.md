# 4400 safety continuation checkpoint — 2026-10-23T23:45Z

**Supersedes** `checkpoints/2026-10-23T2241Z-4400-remote-authority-physical-witness-next.md`. START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, safety syllabus/index and 2570/2580 entry maps reviewed. 1000/2000/F02/3000 closed; 2500 external evaluation OPEN; 4400 safety primary. Separate board-design automation owns ordinary electronics.

## Session evidence
- **Start UTC** 2026-10-23T23:32:48Z before substantive work.
- New original [pinned v2.9.10 `linuxcncrsh` source trace](../research/4400_LINUXCNCRSH_2910_REMOTE_COMMAND_AUTHORITY_AND_STALE_STATUS_SOURCE_TRACE_2026-10-23.md) and [eight-case technician card](../safety-course/4400_LINUXCNCRSH_REMOTE_COMMAND_STALE_STATE_AND_REARM_FIELD_CARD_2026-10-23.md). Both committed to main and indexed. Design package §11AT; progress and publication ledger updated.
- **SOURCE-CONFIRMED:** `emcrsh.cc` blob `81b387c20f297d43b7fb63ad26fcf4d25ec0aa62`, v2.9.10: TCP `INADDR_ANY` bind, ordinary password/session/enable gate, normal-control commands for E-stop reset/machine on/jog/MDI/run/limit override, optionally stale GET status, and no independent protective-stop action in client disconnect path. **DOC-CONFIRMED:** official LinuxCNC 2.9 manual says passwords transmitted in cleartext and UPDATE NONE can return stale data.
- **SOURCE-CONFIRMED deeper call flow:** `shcom.cc` blob `28eb924291788f64effd4fd9376220d23dc3c1c2` sends `EMC_TASK_SET_STATE`; `emctaskmain.cc` blob `7292a172023a5b42b023447c2458cb766c93fc9b` dispatches; `emctask.cc` blob `ef96ceb4de247a96a1ff64309850383864d05179` performs Task/auxiliary E-stop and motion enable requests. Not physical proof.
- **INFERENCE/UNTESTED:** potential socket-descriptor lifetime issue; no exploit or actual selected-machine behavior asserted. Minimal read-only telemetry exporter and local deliberate start are proposed engineering architecture, not safety-rated implementation.
- **TEST-CONFIRMED:** none this session. `NET-01..08 NOT RUN`, `REM-01..08 NOT RUN`, selected `IN-01..10`, `OPT-01..08`, `PHY-*` UNKNOWN, `VAL/PT NOT RUN`, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation authorized.
- Historical exact archive remains **6/85 pending** (original bytes unavailable; no fabricated recovery). External 2520–25F0 independent competency gates OPEN; no self-grading.
- Self-hosted-only lesson-log workflow run `39919548510`, job `120301190483`, freshly observed **QUEUED**, no authoritative runtime. GitHub-hosted compute 0; local lab compute 0; physical tests 0; simulations 0. `LAB_COMPUTE_LOG.md` unchanged.

## Next highest-information work
1. Obtain selected OpenPressBrake as-built safety schematic and hydraulic/guard topology: `IN-01..10`, `OPT-01..08`, `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART`; exact safety final elements, selected controller, reset authority and local/remote permission map. Only then freeze physical acceptance questions; no numeric stop time, PL/SIL or hydraulic truth table invented.
2. If hardware still unavailable, rotate to a **new** 4400 safety source path with an unresolved causal question (for example independent protective-device restart/rearm under maintenance mode), not another generic remote-access summary. Preserve source version, exact lines, adversarial counterexample and physical unknowns.
3. Original six archived candidate files require verifiable exact bytes/manifest SHA before publication. No synthetic replacement. External evaluator remains information-separated.
4. No hosted Actions compute. Bounded justified tests only on `[self-hosted, openpressbrake]` after a frozen unresolved question, and never live personnel-exposed testing.

## Short-session continuation decision
The current source branch has gained new implementation-level evidence and a deeper Task/NML trace. Its next decisive questions are selected-machine physical wiring/permission facts or a specific isolated protocol-lifecycle experiment; neither is justified without a machine target or frozen hypothesis. Other useful work is preserved above and remains OPEN, so **keep the hourly automation enabled**. Do not claim curriculum completion.

**End-of-session requirement:** immediately before ending, append UTC end, actual elapsed minutes and overlap status to full canonical `LESSON_LOG.md` with SHA guard and verify. Never overwrite a truncated log. No unverified lab runtime in compute ledger.
