# 4400 safety continuation — 2026-10-23T14:37Z session

**Session start recorded before substantive work:** 2026-10-23T14:37:38Z. **Primary:** 2500 Safety Course / 4400 safety architecture. 1000/2000/3000 GRADUATED/CLOSED; F02 graduated; 2520–25F0 information-separated external/fresh competency gates remain OPEN. Do not regress to 3300 or displace safety with ordinary controller-board work.

## Completed, durable on main

- New original `research/4400_AKAS5M_SERIAL_DIAGNOSTIC_REPETITION_FRESHNESS_AND_HMI_AUTHORITY_2026-10-23.md`. Direct official Fiessler AKAS-5M operating instructions, document 1581, 2024-02-15, printed pp. 3–5, 25–26, 29–34. Serial messages are repeated, have parity/acceptance rules, and are status/warning/error **diagnostics**, not physical machine proof. Source: https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf .
- Corrected proposed HMI session epoch to **host-owned**; manufacturer documentation does not establish a device sequence counter or end-to-end maximum age. Source `DOC-CONFIRMED`; host data-quality contract `INFERENCE`; host worst-case freshness `UNKNOWN`.
- New learner-facing `safety-course/4400_SERIAL_DIAGNOSTIC_STALE_GREEN_CROSS_MACHINE_TECHNICIAN_CARD_2026-10-23.md` applies this boundary to press brake, lathe, plasma and robot cell. Not a sealed/blind evaluation.
- Updated `safety-course/SAFETY_COURSE_INDEX.md`, `PROGRESS.md` and `research/4400_PUBLICATION_RELEASE_LEDGER_2026-10-23.md`.
- Original staged ZIP still available locally this session; **no exact archived candidate release claimed**. Previous durable ledger baseline **19/85 pending**; a previously queried AKAS muting card already exists on main with original Git blob `0b715b5a34a0f9454038138de3d8fddc86538b8e`; reconcile archive ledger against main before any count change. Do not overwrite existing files.
- No GitHub-hosted Actions compute, no self-hosted lab compute, no physical test, no external score. No `LAB_COMPUTE_LOG.md` update without authoritative runtime.

## Engineering boundary

Ordinary LinuxCNC/HAL/FPGA and HMI can control/log/diagnose but are not automatically personnel-safety authorities. A serial message may be fresh and valid yet not prove the selected physical ram stopped, held, isolated or safe to access. A missing/late frame must not leave an unqualified green indicator. Actual selected-machine `IN-01..10` intake and independent `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` validation remain **UNKNOWN/NOT RUN**. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. Do not operate with people exposed absent independently established minimum protection; experimental work, if justified later, requires an isolated/remote qualified plan with people outside the danger zone and residual risk documented.

## Exact next work

1. Re-read `START_HERE.md`, current `PROGRESS.md`, latest checkpoint, safety-course index and publication ledger; check for concurrent main updates.
2. Reconcile the original 85-file archive manifest with main, then review/publish only a truly absent exact blob, prioritizing `research/4400_NORMAL_UNLOCK_VS_ESCAPE_RELEASE_TEMPORAL_PROOF_2026-10-22.md`, `research/4400_AKAS5M_SELECTED_SETTING_OVERRUN_AND_RETEST_2026-10-23.md`, `research/4400_HAWE_ACCUMULATOR_FAMILY_EXCEPTION_AND_PRESSURE_ZONE_WITNESS_2026-10-22.md`. Verify official source and exact Git blob; do not silently treat unresolved 11/13 mm manufacturer discrepancy as resolved.
3. If archive branch is source-limited, continue substantive independent physical-witness safety study (stop, load holding, escape, maintenance isolation, fresh restart) or human-factors/guard-defeat analysis. Do not invent machine-specific hydraulic facts, numeric criteria or PL/SIL.
4. Keep 2520–25F0 external evaluation information-separated; do not self-score or expose hidden answers.
5. Dispatch **no hosted Actions runner**. Any justified compute must target `[self-hosted, openpressbrake]`, be question-driven, and use actual completed job runtime for compute records.
6. Immediately before ending this session, append UTC end, elapsed minutes and overlap to canonical `LESSON_LOG.md` using a complete-file SHA-guarded update. Keep hourly automation enabled.

**Evidence labels:** manufacturer serial semantics `DOC-CONFIRMED`; diagnostic contract `INFERENCE`; selected machine `UNKNOWN`; physical `TEST-CONFIRMED` none.


## Same-session 14:43Z publication and code-table continuation (supersedes 19/85 baseline)

- Visually inspected manufacturer document 1581 printed pp. 33–34: serial diagnostic examples 195 box mode, 215 muting, 231 interrupted field, 146/145 safety-point sequence warning/error, 106/105 unequal fast/slow signals, 201 interlock without prior warning. Added these source-confirmed examples and the host-session freshness distinction to the original research. None is physical safe-state proof.
- Published exact original archive `research/4400_AKAS_OVERTRAVEL_TEXT_CONFLICT_AND_SECONDARY_HAZARD_SCOPE_2026-10-23.md`, independently fetched Git blob `ff7709e6792192780df099f88443a9bc4c1b45b9` matching the source ZIP. Original archive **18/85 pending**, superseding earlier 19/85 (assuming no unobserved concurrent release).
- Integrated §11O into cumulative Safety Design Package; index, ledger and progress updated. Manufacturer pp. 5 and 14 numeric discrepancy remains unresolved for actual selected setting; no numeric acceptance criterion approved. OSHA eTool link in archived source was not freshly accessible (403); do not claim it was reverified this session.
- Self-hosted-only log job `39919548510` / `120301190483` rechecked **QUEUED**, no authoritative runtime; `LAB_COMPUTE_LOG.md` unchanged. GitHub-hosted Actions compute 0, local lab compute 0, physical tests 0, external score 0.

**Exact next:** reconcile pending original archive against main, source-review `research/4400_NORMAL_UNLOCK_VS_ESCAPE_RELEASE_TEMPORAL_PROOF_2026-10-22.md`, `research/4400_AKAS5M_SELECTED_SETTING_OVERRUN_AND_RETEST_2026-10-23.md` and `research/4400_HAWE_ACCUMULATOR_FAMILY_EXCEPTION_AND_PRESSURE_ZONE_WITNESS_2026-10-22.md` before any exact release. Priority remains selected-machine intake `IN-01..10` and independent physical stop/hold/escape/isolation/restart evidence. Do not authorize personnel exposure or manufacture test numbers. End this session with safe SHA-guarded canonical lesson-log append.
