# 4000 Safety Curriculum Checkpoint — 2520 Integration / Fresh-AI Handoff

UTC checkpoint: 2026-09-22T19:50Z

## Durable work completed

Added:

- `safety-course/2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`
- `safety-course/2520_COMMISSIONING_RELEASE_AND_CHANGE_CONTROL_2026-09-22.md`

The entry map establishes one canonical learner path from machine/lifecycle boundary through hazard, physical proposition, safety function/SRS, composition, fault analysis, architecture/dependency/CCF allocation, integrity-method/target selection, verification/validation/physical proof, and commissioning/change revalidation. It assigns ownership to existing detailed lessons and explicitly discourages duplicate narrow notes.

The commissioning bridge adds configuration identity, commissioning-readiness controls, temporary-measure tracking/removal, release-baseline discipline, bidirectional change-impact analysis and impact-derived partial/full revalidation. It is grounded in current Rockwell commissioning/signature and AADvance validation guidance plus Siemens Safety Integrated acceptance/retest guidance. No machine-specific acceptance value was invented.

`PROGRESS.md` was reconciled with the already-existing verification/validation lesson and matrix, which were present in the repository even though PROGRESS had still pointed at the older integrity-gate checkpoint.

No executable compute was justified. No GitHub-hosted runner was used.

## Exact next work

1. Perform a fresh-AI handoff audit using the new entry map: verify every referenced path exists and ownership is non-conflicting.
2. Create a compact commissioning/change-control worksheet only if that audit shows a reusable record surface is needed; do not duplicate `SAFETY_VERIFICATION_VALIDATION_MATRIX.md`.
3. Stress-test the full hazard-to-release method on a substantially different machine class while preserving machine-specific `UNKNOWN`s.
4. Decide whether 2520 is ready for formal syllabus placement/promotion and specify what evidence remains for a genuine fresh/information-separated competency check.
5. Keep ordinary LinuxCNC/FPGA outside personnel-safety authority.
