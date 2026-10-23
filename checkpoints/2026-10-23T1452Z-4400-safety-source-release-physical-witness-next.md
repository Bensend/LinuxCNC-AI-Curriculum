# Active 4400 safety checkpoint — 2026-10-23T14:52Z

**Governing entry:** read `START_HERE.md`, `LEVEL_ORDER.md`, `CURRICULUM.md`, `WORK_SELECTION_POLICY.md`, `PROGRESS.md`, `safety-course/SAFETY_COURSE_INDEX.md`, the cumulative Safety Design Package and this checkpoint. **Current priority: Safety Course / 4000 safety architecture.** 1000/2000/3000 and F02 are GRADUATED/CLOSED; 2520–25F0 external/fresh evaluations remain OPEN. Do not regress to 3300 or transfer safety authority into ordinary LinuxCNC/FPGA control.

## This session's durable verified output

Start UTC: **2026-10-23T14:37:38Z** (captured before work). Seven original archived source documents were committed to `main` and independently re-fetched; **all seven Git blobs match their original ZIP**:

1. `research/4400_AKAS_OVERTRAVEL_TEXT_CONFLICT_AND_SECONDARY_HAZARD_SCOPE_2026-10-23.md` — `ff7709e6792192780df099f88443a9bc4c1b45b9`.
2. `research/4400_AKAS5M_SELECTED_SETTING_OVERRUN_AND_RETEST_2026-10-23.md` — `5e0b14b723308ed86ca2090834a248e4d3071d71`.
3. `research/4400_HAWE_ACCUMULATOR_FAMILY_EXCEPTION_AND_PRESSURE_ZONE_WITNESS_2026-10-22.md` — `b690bcb1d0f11cf6aacae0fa5f23ed060e258e43`.
4. `research/4400_NORMAL_UNLOCK_VS_ESCAPE_RELEASE_TEMPORAL_PROOF_2026-10-22.md` — `95070fff954dca5add555bcbd93e8e35ab915edc`.
5. `research/4400_HYDRAULIC_ENERGY_FAULT_TREE_QUALITATIVE_2026-10-22.md` — `5d1c6cb200af8cb1cbe6ee3864caec60b5c5c8de`.
6. `research/4400_SAKB_MONITORING_COVERAGE_NSV_WITNESS_2026-10-22.md` — `2864efe988192ed293bfe33d4e56229997f2d65b`.
7. `research/4400_VENDOR_DIAGNOSTIC_CASCADE_GUARDLINK_SDD_BOUNDARY_2026-10-22.md` — `be62e46bfffa9401274f8f7fdb8c9714487b3c47`.

**Original 85-file archive: 12 candidates still pending**, reduced from 19 this session (subject to reconciliation if concurrent main writes occur). Original ZIP: `LinuxCNC_4400_20261023T064104Z_SAFETY_MODE_AUTHORITY_CONSOLIDATED_PUBLICATION_STAGED.zip`; `review/PUBLICATION_MANIFEST.json`. Verify missing paths against `main` before writing, preserve original hashes and do not overwrite existing files.

Two new original learner documents:
- `research/4400_AKAS5M_SERIAL_DIAGNOSTIC_REPETITION_FRESHNESS_AND_HMI_AUTHORITY_2026-10-23.md` (Fiessler document 1581, 2024-02-15, pp. 3–5, 25–26, 29–34; connector-level RS232 vs OSSD, host-owned age/epoch, visually checked diagnostic codes and no-warning interlock).
- `safety-course/4400_SERIAL_DIAGNOSTIC_STALE_GREEN_CROSS_MACHINE_TECHNICIAN_CARD_2026-10-23.md` (press brake/lathe/plasma/robot transfer, learner-visible, not a blind evaluation).

Cumulative `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` extended with **§§11O–11T**: serial diagnostic freshness, selected overrun setting, accumulator family exceptions, normal unlock versus escape, qualitative hydraulic CCF and SAKB/NSV monitoring, and diagnostic cascade boundaries. Course index, publication ledger and `PROGRESS.md` updated.

## Source/evidence limits

- `DOC-CONFIRMED`: Fiessler AKAS-5M 2024 (11/13 mm text remains inconsistent; DIP setting governs documented selected test; 30-hour retest belongs to that documented arrangement); HAWE D 7969/D 7571 family-specific accumulator differences; HAWE SAKB D 6335 2025 / NSV D 6368 2026; EUCHNER CTP-AP 2124217-08-06/21; Rockwell GuardLink and Pilz SDD manufacturer descriptions (Pilz diagnostic reaction time explicitly **not safety-related**).
- `INFERENCE`: HMI freshness contract, three separate hydraulic top events, pressure-zone and common-cause proof obligations, normal access versus emergency escape temporal requirements, practical anti-bypass design.
- `UNKNOWN/NOT RUN`: selected-machine hydraulic topology, actual DIP settings, pressure-zone map, sensor/valve/guard variants, stop/hold/escape/maintenance isolation, physical test results, stopping distances, PL/SIL, diagnostic coverage, external blind scores. Never invent these.
- The OSHA eTool URL in archived research returned HTTP 403 on fresh fetch; do not imply it was freshly checked. No physical machine operation, simulation, local lab or GitHub-hosted Actions compute was performed. Existing self-hosted-only lesson-log workflow run `39919548510` / job `120301190483` was checked and remains **QUEUED**; no authoritative runtime for `LAB_COMPUTE_LOG.md`.

## Precise next work

1. Reconcile the remaining **12/85** archive candidates against `main` and original manifest; publish a source-reviewed, truly absent high-value safety file with exact Git blob verification, or rotate to the highest-value unblocked 4400 safety source/module if archive review is exhausted.
2. Prioritize independent **selected-machine** `IN-01..10` intake and `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` evidence. Distinguish normal LinuxCNC commands/HMI, safety PLC/relay outputs, monitored valves, physical holding, pressure-zone isolation and maintenance LOTO. Use a practical human-factors review of guard defeat and accessible witness points.
3. Keep 2520–25F0 external evaluations information-separated; no hidden answer exposure or self-scoring.
4. Never dispatch hosted Actions runners. If a concrete unanswered question justifies compute, only use self-hosted `[self-hosted, openpressbrake]`; record actual completed runtime, not queued time.
5. No personnel-exposed hazardous operation without independently established minimum safety. Isolated/remote experiments require qualified hazard analysis and people outside danger zone.
6. At the end of each session append actual UTC start/end, elapsed and overlap to `LESSON_LOG.md` using full-file SHA-guarded update; never overwrite a truncated log. Keep the hourly automation enabled.

**Safety release status:** G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. All selected-machine physical `VAL/PT` remain NOT RUN.
