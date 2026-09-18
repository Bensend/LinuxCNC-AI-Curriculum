# Safety curriculum Lane B checkpoint — 2026-09-18 08:52 CT

## Completed

Created `safety-course/PSDI_CYCLE_INITIATION_FRESH_INTENT_AUTHORITY_STUDY_2026-09-18.md` from SICK PSDI/press-control documentation and Rockwell's documented double-break PSDI wiring example.

Frozen distinction:

**PROTECTIVE FIELD CLEAR != VALID PSDI MODE != REQUIRED BREAK/MAKE SEQUENCE COMPLETE != PSDI SAFETY RELEASE != FINAL ELEMENT ENABLED != PHYSICAL HAZARDOUS MOTION.**

Also preserve **RESET COMPLETE != PSDI SEQUENCE COMPLETE != ORDINARY START.** PSDI is a deliberate, validated safety-function exception to the generic fresh-START rule: a protective-device sequence can itself become cycle-initiation authority only where the machine/application/jurisdiction permits it and the safety architecture owns the sequence.

## Parallel-work check

Primary newest durable work is `safety-course/ACCESSIBLE_CELL_SAFE_ENTRY_RESTART_AUTHORITY_TRACE_2026-09-18.md` and its checkpoint. Lane B did not modify that artifact, the guard-locking study, gravity-axis brake artifacts, or their evidence packages. PSDI cycle initiation is an independent press safeguarding branch.

Immediately before the substantive write, `main` ended at primary checkpoint `3147d72f`. Immediately after the write, `698f9198` was directly above it; no intervening or overlapping write appeared.

## Evidence status

- SOURCE-CONFIRMED / DOC-CONFIRMED: SICK defines single/double-break PSDI and documents it inside press safety control; Rockwell documents a double-break light-curtain PSDI sequence with safety contactors.
- INFERENCE: reusable authority ladder, LinuxCNC/OpenPressBrake allocation, and adversarial commissioning questions.
- TEST-CONFIRMED: none.
- COMMUNITY-REPORTED: none used.
- UNKNOWN: OpenPressBrake PSDI applicability/permissibility, machine-specific protective geometry, safe distance, stopping/overrun, waiting state, sequence timing, safety-controller implementation, final elements, PL/SIL/category/DC and hydraulic physical facts.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted runner compute was used.

## Exact next independent work

Find a modern professional hydraulic/servo-press PSDI commissioning implementation exposing `mode selection -> safe waiting position/state -> first/second protective-field intervention -> sequence validation -> safety output/final element -> automatic cycle initiation -> interruption during hazardous motion -> reset/restart recovery`, including at least one invalid-sequence or power-cycle case. Preserve the documented U.S. mechanical-power-press restriction and do not infer PSDI applicability to OpenPressBrake without machine-specific standards review.

`PROGRESS.md` was intentionally not rewritten in this lane because its large shared state was already updated by concurrent safety work and a whole-file replacement would create unnecessary overlap risk; this checkpoint is the durable progress record for the independent lane.