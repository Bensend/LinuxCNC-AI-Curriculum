# Board-design curriculum checkpoint — BD11

Date: 2026-09-21
Lane: independent LinuxCNC/OpenPressBrake board-design curriculum

## Completed

Created `hardware/4000-board-design/BD11_RELEASE_MAINTENANCE_AND_EVIDENCE_INVALIDATION_UNDER_CHANGE.md`.

BD11 advances BLOCK ENGINEERING maintenance rather than initial design. It teaches:

`requirement -> evidence -> applicability boundary -> change -> affected-evidence graph -> RERUN / RECALCULATE / REVIEW / REQUALIFY -> revised release state`

The current differential-encoder package was opened directly before use. It is suitable for bounded teaching because its machine-readable engineering contract already separates reusable-block, board-integration and machine-configuration ownership, exposes explicit recalculation/review triggers, and distinguishes retained evidence from open/deferred validation. Its current status still leaves cable/termination, protected field power, abnormal-condition qualification, schematic/PCB integration and final release open, so the lesson does not portray it as production-proven.

## Catalog stress-test result

The encoder package demonstrates useful change triggers, but the broader catalog would benefit from making change-impact semantics first-class machine-readable contract data. Future schema work should distinguish `RERUN`, `RECALCULATE`, `REVIEW`, and `REQUALIFY`, link triggers to claims/evidence IDs, and allow board integration to aggregate invalidation across block boundaries.

No OpenPressBrake patch was made. Current OpenPressBrake main at the curriculum write was `3fd3ba2cdec9058f4d5cab6a2fb35716ea3867bd`, adding active Rev1 return-domain grounding authority. That work overlaps board integration, so this pass consumed the encoder package read-only.

No executable compute was justified; no GitHub-hosted runner was used.

## Durable freezes

- `EVIDENCE EXISTS != EVIDENCE STILL APPLIES`.
- `RERUN != RECALCULATE != REVIEW != REQUALIFY`.
- `SCHEMATIC UNCHANGED != PHYSICAL EVIDENCE UNCHANGED`.
- `PREVIOUS PASS + NEW REVISION != CURRENT PASS`.
- `UNKNOWN EVIDENCE APPLICABILITY -> FAIL CLOSED`.

## Exact next work — BD12

Switch back to BOARD INTEGRATION with a full-board kitchen-sink integration review. Start from current main in both repositories and inspect current whole-board integration, connector-owner index, return-domain authority, FPGA resource/pin authority, power-domain authority, watchdog/output-permission authority, block status files, and renderer/capture validation contracts before naming any student-facing artifact.

BD12 should teach a structured cross-block conflict review:

`all required machine functions -> selected block instances -> canonical connection blocks -> FPGA/pin/bus budget -> power/current/return domains -> enable/watchdog authority -> hidden-glue search -> partial-power matrix -> renderer/capture hierarchy -> unresolved-gate ledger`

The exercise should deliberately combine enough block classes to expose integration defects, but it must not call the current OpenPressBrake board production-proven. Treat every missing join, return, enable, resource quantity, connector fact, default state, or verification dependency as a catalog/integration defect rather than filling it from memory.

Because current OpenPressBrake return-domain work is active, re-read current main immediately before any overlapping change. Prefer read-only consumption or an independent curriculum artifact unless the engineering correction is both justified and clearly non-conflicting.