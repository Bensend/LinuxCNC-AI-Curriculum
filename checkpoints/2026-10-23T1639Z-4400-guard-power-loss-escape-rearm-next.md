# Active 4400 safety checkpoint — 2026-10-23T16:39Z

**Session UTC start:** 2026-10-23T16:39:05Z, recorded before substantive work. Supersedes `checkpoints/2026-10-23T1531Z-4400-accumulator-rearm-exact-release-next.md`. START_HERE.md read first, followed by mission, level order, curriculum, selection policy, source/template/progress, external evaluation, compute state, active checkpoint, safety-course index and physical witness intake. The 1000/2000/3000 series and F02 remain GRADUATED/CLOSED. 4000 safety is active; ordinary board design belongs to its separate automation.

## Durable session output

- New original `research/4400_GUARD_POWER_LOSS_ESCAPE_AND_REARM_VARIANT_SOURCE_MATRIX_2026-10-23.md`, fetched after commit, blob SHA `139b7660ee913de383dd153273537ff523e0fb1d`.
- New original `safety-course/4400_GUARD_POWER_LOSS_ESCAPE_RESTART_TECHNICIAN_FIELD_CARD_2026-10-23.md`, fetched after commit, blob SHA `3e37dc367c113e1328761f7bb5cd1040aff8cd79`.
- Updated `safety-course/SAFETY_COURSE_INDEX.md`, `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` §11AA, `research/4400_PUBLICATION_RELEASE_LEDGER_2026-10-23.md`, and `PROGRESS.md`.
- Source-checked SICK TR110 Lock **8023119/1K8B/2023-09-15** §§3.3,4.4,8.2–8.3; EUCHNER CTP-AP **2124217-08-06/21** §§3,6.6–6.8,7; Pilz PSEN ml b **1003884-EN-17** §§4.6–4.8; and Pilz PSENmlock product-family power-reset/automatic-reset distinctions.
- Distinct hazard propositions: **premature access on power-to-lock voltage loss**, **entrapment on power-to-release voltage loss**, **unexpected restart after local device recovery**. Local device safety outputs, mechanical escape, independent machine stop/hold, maintenance isolation and fresh ordinary start are separate.
- Both new artifacts are **non-archive** research/training; they do not decrement the original archive backlog.

## Open and blocked evidence

All six original consolidated-archive research candidates were independently checked against main and returned 404. **6/85 pending**, no change:
1. `research/4400_AKAS5M_MUTING_SLOW_SPEED_SAFETY_AUTHORITY_2026-10-23.md`
2. `research/4400_CROSS_DOMAIN_SAFETY_PROPOSITION_CONTRADICTION_AUDIT_2026-10-22.md`
3. `research/4400_GUARD_LOCKING_POWER_LOSS_ESCAPE_RELEASE_AUTHORITY_2026-10-22.md`
4. `research/4400_PILZ_GUARD_MOUNTING_ESCAPE_MECHANICS_2026-10-22.md`
5. `research/4400_SAFETY_COURSE_ROUTE_REGRESSION_AND_RELEASE_AUDIT_2026-10-22.md`
6. `research/4400_SERIES_GUARD_INTERLOCK_FAULT_MASKING_AND_SELF_MONITORING_2026-10-22.md`

Original archive remains available as `LinuxCNC_4400_20261023T064104Z_SAFETY_MODE_AUTHORITY_CONSOLIDATED_PUBLICATION_STAGED.zip`; preserve exact bytes and verify Git blobs for any future exact release. The historical route-regression document includes superseded main SHA and a stale write blocker: either label historical and supplement with current routing, or keep staged; never publish its obsolete claim as current. Avoid replacing exact archival source with a paraphrase while calling it an exact release.

The selected-machine `IN-01..10` packet is **UNKNOWN**; `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` and `VAL/PT` remain **NOT RUN**. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation; any experimental test requires independently approved isolated/remote exclusion and residual-risk review. 2520–25F0 information-separated external evaluations OPEN and not self-scored.

Existing self-hosted-only Append Lesson Log workflow run **39919548510** was checked and remains **QUEUED**; no authoritative job runtime. No GitHub-hosted runners or hosted Actions minutes used; no self-hosted laboratory compute, simulations, builds, physical tests or new LAB_COMPUTE_LOG entries. No duplicate workflow dispatched.

## Precise next work

1. Prioritize remaining archive source releases **only after original edition review**: SICK/Pilz/EUCHNER guard power-loss/escape (cross-check new matrix), AKAS-5M muting versus independently qualified slow motion, Pilz mechanical mounting and release, series contact fault masking and cross-domain witness contradictions. Keep exact-byte verification and publication ledger honest.
2. Correct or preserve historical route-regression audit with explicit supersession. Do not introduce stale navigation links.
3. When selected machine artifacts become available, complete `IN-01..10` before any proposed physical test. Prove independent physical stop, hold, escape, pressure zones, maintenance isolation and deliberate fresh restart; no invented hydraulic truth tables or PL/SIL.
4. Apply human-factors field questions: make correct release/guard installation and maintenance verification easier than bypass.
5. Keep external evaluations sealed and the recurring curriculum enabled. Immediately before end, append UTC end, actual elapsed minutes and overlap to canonical `LESSON_LOG.md` via complete-file SHA-guarded update, then verify.

**Evidence classes:** manufacturer behavior DOC-CONFIRMED at stated editions; safety event allocation INFERENCE; selected machine and physical outcomes UNKNOWN/NOT RUN; TEST-CONFIRMED none.