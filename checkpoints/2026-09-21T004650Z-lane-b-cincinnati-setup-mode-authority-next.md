# 4000 safety checkpoint — Lane B Cincinnati setup-mode authority

UTC checkpoint: 2026-09-21T00:46:50Z

## Parallel-work check

Before selection, Lane B read the standing entry/order/work-selection/progress/curriculum state and inspected the newest primary durable work. The primary lane is advancing 25E0 physical-change revalidation and adversarial return-to-service exercises. Lane B therefore avoided those module files and evidence artifacts.

Immediately before checkpointing, current main was re-read through the recent commit list. No newer primary commit appeared after Lane B's study commit, and no overlapping file changed. No reconciliation was required.

## Durable advance

Added `safety-course/CINCINNATI_PRESS_BRAKE_SETUP_MODE_TOOLING_CHANGE_AND_MOTION_AUTHORITY_STUDY_2026-09-21.md`.

Manufacturer evidence from Cincinnati's hydraulic press-brake manuals shows that SETUP is a bounded motion-authority mode, not a no-motion safe state: palmbutton/RAM-UP motion remains available while tooling procedures separately require keep-out behavior and, for specific substeps, safety blocks and OFF conditions.

Durable freezes:

- **SETUP MODE SELECTED != HAZARDOUS MOTION IMPOSSIBLE**.
- **SETUP MODE SELECTED != DIE AREA SAFE TO ENTER**.
- **AUTOMATIC CYCLE DISABLED != ALL HAZARDOUS MOTION SOURCES DISABLED**.
- **BOUNDED ENERGIZED SETUP AUTHORITY != ENERGY ISOLATION/BLOCKING**.
- **MODE RETURNED TO PRODUCTION != SAFEGUARDS REQUALIFIED != FRESH PRODUCTION START**.

The study preserves provenance labels: Cincinnati statements are DOC-CONFIRMED; OSHA general press-brake statements are SOURCE-CONFIRMED; OpenPressBrake transfer is INFERENCE; machine-specific speeds, stopping performance, hydraulic states, safety performance levels and final implementation remain UNKNOWN. No TEST-CONFIRMED or COMMUNITY-REPORTED claims were promoted.

## Exact next Lane-B work

Find an authoritative OEM/manufacturer commissioning or maintenance procedure that physically challenges multiple command sources across a setup/service-mode boundary, preferably demonstrating a negative test where production AUTO/CYCLE is inhibited while a bounded setup control remains functional, then showing restoration/requalification and a separate fresh production start.

Prefer a different evidence family from the primary lane. If primary work moves into setup-mode command-authority testing before the next Lane-B run, rotate to another open safety branch instead of duplicating it.

## Compute

No executable verification was justified. No GitHub-hosted runner was used and no self-hosted compute was consumed.
