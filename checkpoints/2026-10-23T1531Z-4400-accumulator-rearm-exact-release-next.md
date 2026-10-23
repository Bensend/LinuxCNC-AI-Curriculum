# Active 4400 safety checkpoint — 2026-10-23T15:31Z session

**Governing start:** `START_HERE.md` read first; `MASTER_MISSION.md`, `LEVEL_ORDER.md`, `CURRICULUM.md`, `WORK_SELECTION_POLICY.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, `PROGRESS.md`, external blind feedback and laboratory compute state consulted. Safety Course / 4000 safety architecture is the active priority. 1000/2000/3000 and F02 are GRADUATED/CLOSED; 2520–25F0 external/fresh competency evaluations remain OPEN. This checkpoint supersedes `checkpoints/2026-10-23T1452Z-4400-safety-source-release-physical-witness-next.md`.

## Durable output and evidence

Session UTC start recorded before work: **2026-10-23T15:31:10Z**.

Five original archived research files published to `main` and independently fetched; exact original Git blob equality:

1. `research/4400_ACCUMULATOR_DUAL_ROLE_SAFE_CYCLE_VS_ISOLATION_2026-10-22.md` — `737131a69b48393b3a6118e6052ddabd2b0b26c7`. Parker 2016 bladder-accumulator intended protective-cycle use, OSHA stored energy and isolation, selected circuit UNKNOWN.
2. `research/4400_LINUXCNC_ESTOP_LATCH_FIRST_SCAN_RESET_AUTHORITY_2026-10-22.md` — `06ab264878abdd4920af7ab78707b06767ce9e20`. Independent pinned `LinuxCNC/linuxcnc` v2.9.10 source fetch confirmed `estop_latch.comp` `e95fabd323f3c7ccbc8a18146ddd93d6f7d70e20`, `halcompile.g` `ed605845e745a1d0be474fcf05e9746191cb2984`, and plasma simulation `estop.hal` `9dd7ea33506a46dd3d637483e615afc7c0687afb`. Software first-call reset-high counterexample SOURCE-CONFIRMED; not personnel-safety authority.

3. `research/4400_LOCKABLE_ISOLATION_TAGOUT_RETROFIT_EVIDENCE_2026-10-22.md` — `a902445214ac5adebbcacda1839215adb1ee3379`. OSHA 1910.147, Siemens 3KD9201-1 accessory and Schneider VCCF01 switch-disconnector source review; actual isolator and residual-energy proof UNKNOWN.

4. `research/4400_SAFE_STANDSTILL_UNLOCK_PNOZ_S30_SENSOR_DIAGNOSTIC_SCOPE_2026-10-22.md` — `3c0646e98b35b1ef6493ae62b7992420bb3851ad`. Pilz PNOZ s30 official manual 1001715-EN-24 confirms standstill plausibility-check cut-off and parameter-set open-circuit trap; no selected physical stop/hold validation.

5. `research/4400_HYDAC_SAF_GAUGE_TOPOLOGY_ZERO_READING_PHYSICAL_WITNESS_2026-10-22.md` — `4e34a51de7cfa6b9929613e60ea48c40e0647b42`. HYDAC 2011 fluid-side zero versus gas precharge and exact SAF catalog model-code ambiguity; selected port/ram topology UNKNOWN.

New original learner research: `research/4400_ACCUMULATOR_PROTECTIVE_CYCLE_REACCUMULATION_WITNESS_CONTRACT_2026-10-23.md` — separates P protective response, M maintenance isolation/reaccumulation, R fresh restart and physical witness independence. Cumulative Safety Design Package §§11U–11Y and learner index updated. Publication ledger and `PROGRESS.md` updated. Original ZIP `LinuxCNC_4400_20261023T064104Z_SAFETY_MODE_AUTHORITY_CONSOLIDATED_PUBLICATION_STAGED.zip` manifest 85/85 SHA-256 and size PASS; ZIP CRC PASS. **Original archive 7/85 candidates pending**, reduced from 12; all 7 are research files (no remaining safety-course candidates).

Remaining original archive research paths, verify absent before each write and preserve exact bytes:
- `research/4400_AKAS5M_MUTING_SLOW_SPEED_SAFETY_AUTHORITY_2026-10-23.md`
- `research/4400_CROSS_DOMAIN_SAFETY_PROPOSITION_CONTRADICTION_AUDIT_2026-10-22.md`
- `research/4400_EUCHNER_CTP_I1_L1_MANUAL_OUTPUT_SEMANTICS_2026-10-22.md`
- `research/4400_GUARD_LOCKING_POWER_LOSS_ESCAPE_RELEASE_AUTHORITY_2026-10-22.md`
- `research/4400_LOCKABLE_ISOLATION_TAGOUT_RETROFIT_EVIDENCE_2026-10-22.md`
- `research/4400_PILZ_GUARD_MOUNTING_ESCAPE_MECHANICS_2026-10-22.md`
- `research/4400_SAFETY_COURSE_ROUTE_REGRESSION_AND_RELEASE_AUDIT_2026-10-22.md`
- `research/4400_SAFE_STANDSTILL_UNLOCK_PNOZ_S30_SENSOR_DIAGNOSTIC_SCOPE_2026-10-22.md`
- `research/4400_SERIES_GUARD_INTERLOCK_FAULT_MASKING_AND_SELF_MONITORING_2026-10-22.md`

## Safety and source constraints

- Parker HY10-1632-M2/US official PDF indexed under `test.parker.com`, but `www.parker.com` endpoint returned 404 on fresh open; preserve edition/URL provenance. Official OSHA 1910.147(d)(5)–(6) and HAWE D 7571 manufacturer documentation rechecked. Do not invent selected accumulator or hydraulic circuit.
- LinuxCNC HAL software E-stop/reset is ordinary controller coordination, not a safety-rated reset or final element. Independent safety logic and physical mechanisms own protective stopping/holding/rearm and maintenance isolation.
- G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Selected-machine `IN-01..10` physical intake incomplete; `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` and all `VAL/PT` remain UNKNOWN/NOT RUN. No personnel-exposed hazardous operation authorized; isolated/remote testing requires qualified hazard review.
- No physical tests, simulations, GitHub-hosted Actions minutes or local laboratory compute. Existing self-hosted-only log workflow run `39919548510` / job `120301190483` freshly checked and **QUEUED**, no authoritative runtime; `LAB_COMPUTE_LOG.md` unchanged. Do not dispatch GitHub-hosted runners. If a question justifies compute, use only `[self-hosted, openpressbrake]`.
- External blind evaluations remain information-separated, unscored. No hidden answers or self-graduation.

## Next work

1. Continue the **7** remaining archived research files, source-review each against official manufacturer/pinned-source edition, verify Git blob exactly after publication and update the ledger. The 2026-10-22 historical route regression file contains superseded main SHA and a stale publication blocker: publish only with an explicit historical label and current route cross-check, or preserve it as historical staged evidence.
2. Prioritize selected-machine physical intake and independent witness mapping: exact hydraulic diagram, accumulator/valve/gauge variants, load/gravity restraint, guard escape and accessible protected service test points. No made-up pressure limits, stopping distances, hydraulic truth table, PL/SIL or diagnostic coverage.
3. Develop low-friction guard/test-point/lockout access that is easier to use than defeat. Explicitly separate P protective response, M maintenance energy control and R fresh restart; retain `CHG` invalidation on substitutions.
4. Preserve 2520–25F0 external/fresh evaluator separation and close no gate without independent evidence.
5. At session end append actual UTC end/elapsed/overlap in `LESSON_LOG.md` with a complete-file SHA-guarded update. Keep hourly curriculum automation enabled.
