# 4400 safety continuation — GuardLink reset ambiguity and DSV10 residual-energy boundary

Session start UTC **2026-10-23T09:32:51Z**; latest prior canonical lesson ended **2026-10-23T08:45:07Z** (47m44s gap; no known overlap, external concurrency unverified). Active curriculum: 4000 safety/4400, with 1000–3000 GRADUATED/CLOSED and 2520–25F0 external/fresh evaluation gates OPEN.

## Published to main this session

Four archived candidates from `LinuxCNC_4400_20261023T064104Z_SAFETY_MODE_AUTHORITY_CONSOLIDATED_PUBLICATION_STAGED.zip` were copied byte-exactly and verified by fetching the new Git blob:

1. `safety-course/4400_GUARDLINK_AUTHORITY_AND_RESET_ARCHITECTURE_CARD_2026-10-23.md` — `428387a52841c1da9f387d297b799fb6990eabde`.
2. `safety-course/4400_GUARDLINK_FAULT_RECOVERY_CHANGE_CONTROL_WORKSHEET_2026-10-23.md` — `42d88d3f5dc5580b06ffe82e9798e92d431f6750`.
3. `safety-course/4400_GUARDLINK_RESET_AND_REPLACEMENT_TECHNICIAN_CARD_2026-10-23.md` — `3ad0a1f54035834d92a9d0396502a311131f9d11`.
4. `research/4400_HYDAC_DSV10_LOW_COST_SHUTOFF_DRAIN_SOURCE_SCOPE.md` — `c2b819fed1052a3c2276bda3741da16d036d3631`.

**62/85** original archived candidate paths remain pending, assuming no concurrent publication. See `research/4400_PUBLICATION_RELEASE_LEDGER_2026-10-23.md`. Do not overwrite destinations or claim remaining material has already been published.

Two original new learner-visible artifacts:
- `research/4400_ENETR_RESET_UNITS_AND_DIAGNOSTIC_XOR_CONFLICT_2026-10-23.md`: manufacturer 440R-UM009E-EN-P February 2026 printed p. 39 gives `Reset1` 0.25–3 s; p. 44 diagnostic 03 prints 250–3000 **s**. This is a documented inconsistency, likely unit error **INFERENCE**, manufacturer intent **UNKNOWN**. Same manual's Table 5 XOR all-diagnostics instruction is not established as an all-faults decoder. Selected firmware behavior UNKNOWN.
- `safety-course/4400_DSV10_COMBINED_ISOLATION_NEGATIVE_OVERLAP_FIELD_EXERCISE_2026-10-23.md`: historical HYDAC E 3.551.17/08.03 printed p. 10 documents momentary P/S/T interconnection during DSV10 manual changeover. Pressure-zone, pilot, gravity load, current product and physical witness all UNKNOWN/NOT RUN.

Updated `safety-course/SAFETY_COURSE_INDEX.md`, `PROGRESS.md`, and the publication ledger. Official manufacturer source links and exact applicability are inside the research. No hidden evaluator material was opened or self-scored.

## Compute, runner and physical boundary

No GitHub-hosted Actions dispatch, simulation, build, synthesis or test. No self-hosted lab or physical machine test. Previously queued self-hosted-only lesson-log workflow run `39919548510` was **still QUEUED** when read during this session; queued time is not runtime. `LAB_COMPUTE_LOG.md` unchanged because no new authoritative executed laboratory job runtime exists. Do not fall back to hosted runners. Independent safety logic and actual physical final elements retain personnel-safety authority; ordinary LinuxCNC/FPGA/HMI is diagnostics/control only.

## Exact next work

1. Source-review remaining **62** staged candidates in coherent groups: `research/4400_GUARDLINK_RESET_FAULT_RECOVERY_AND_SAFETY_AUTHORITY_2026-10-23.md` and `research/4400_HMI_GUARD_DIAGNOSTIC_EVENT_VS_SAFETY_STATE_CONTRACT_2026-10-23.md` are high-value next; avoid duplicating the new Table 5/6 contradiction note. Verify 432ES first-event versus current-state semantics, 440R reset/firmware and selected physical stop/rearm authority.
2. If documentary guard chain is at information-gain stop, rotate to maintenance isolation, pressure reaccumulation and independently witnessed physical final-element behavior. Keep selected hydraulic truth table, stop time, pressure threshold, PL/SIL and occupancy UNKNOWN until actual design-specific evidence.
3. Link source-checked findings into `SRS/PHY/AUTH/DEP/ARC/VAL/PT/CHG/HF/UNK` in cumulative Safety Design Package. Do not duplicate existing eight-field SO witness template.
4. Do not authorize hazardous operation with people exposed if minimum safe-state protection remains unproved; experimental work only isolated/remote with people outside the danger zone and residual risks controlled.
5. Recheck queued self-hosted log job only for authoritative state; no unnecessary lab. Preserve 2520–25F0 blind/fresh evaluation separation.
6. Record each session's actual UTC end and elapsed in canonical `LESSON_LOG.md` using complete-file SHA-guarded append; never overwrite from partial fetch. Keep recurring curriculum enabled.

**Evidence status:** documentary source-confirmed claims only; selected machine `VAL/PT` NOT RUN. No course graduation or safety certification claimed.

**Post-checkpoint integration:** cumulative `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` §11D now carries selected-device reset-unit conflict, diagnostic-set quality, authority, physical-witness and CHG/HF gates. Continue source-review of pending detailed GuardLink/HMI research; do not create another duplicate reset template.
