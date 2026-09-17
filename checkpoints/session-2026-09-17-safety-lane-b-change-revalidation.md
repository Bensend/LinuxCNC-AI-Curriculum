# Safety Lane B — post-incident change revalidation checkpoint — 2026-09-17

- Lane: second independent safety-curriculum lane.
- Compute: NONE. Source/documentation study and engineering synthesis only. No GitHub-hosted Actions minutes consumed; self-hosted compute was not justified by an executable question.
- Status: CHECKPOINTED — Lane B remains active.

## Parallel-work check

Before selecting work, Lane B read the required curriculum entry/order/selection/progress material and inspected current recent commits. The primary lane's newest durable checkpoint was `checkpoints/session-2026-09-17-safety-human-factors-restart-access.md` at `a407b609`, with work centered on human factors, restart/access/guarding, stale-command restart testing, and complete-machine application.

Lane B therefore did not modify the primary lane's human-factors, field-commissioning, stale-command, mode/EDM, or complete-machine application artifacts. It selected the independent post-incident/change revalidation branch already left by Lane B's prior checkpoint.

Immediately after creating the Lane-B artifact, current `main` was re-read through recent commits. `0ba051c` was current HEAD and no intervening primary-lane commit or overlapping file appeared.

## Durable work completed

Added `safety-course/SAFETY_POST_INCIDENT_CHANGE_REVALIDATION_MATRIX.md`.

Frozen architecture:

> A successful repair does not automatically restore the validity of every safety claim that existed before the repair. Revalidate the claims touched by the change, including interfaces and failure paths that the change can influence.

The matrix maps changes in safety wiring/configuration, protective devices, contactors/STO, hydraulic final elements, ordinary proportional/directional control, drive parameters, LinuxCNC/HAL, FPGA/transport, guards/access hardware, mechanical restraint, accumulator/plumbing, sensors/EDM, power/common distribution and HMI diagnostics to the safety claims potentially invalidated and the evidence needed to rebuild them.

It explicitly preserves the separation between ordinary LinuxCNC/FPGA command state, independent safety authority, final-element evidence, energy-path evidence and actual physical hazardous-effect response.

## Evidence gained

- `SOURCE-CONFIRMED`: OSHA 29 CFR 1910.147 includes modifying machinery within servicing/maintenance and addresses lockout-capable energy-isolating devices when replacement, major repair, renovation or modification is performed.
- `SOURCE-CONFIRMED`: OSHA machine-guarding guidance requires guards/safety devices to be in place and functional when maintenance is completed and identifies training needs when new or altered safeguards are put into service.
- `SOURCE-CONFIRMED`: OSHA human-factors guidance warns that interfering safeguards may be overridden/disregarded.
- `DOC-CONFIRMED`: Pilz validation guidance distinguishes minor changes/reinspection from complex/significant changes and treats validation as confirmation that protective measures are implemented correctly and safety functions are functional.
- `INFERENCE`: exact change-radius classification and the `NOT TOUCHED / REVIEW / INVALIDATED` workflow are curriculum engineering structure rather than quoted regulatory language.

Machine-specific PL/SIL/DC, stopping distance/time, hydraulic truth table, pressure thresholds, proof-test intervals and legal substantial-modification classification remain `UNKNOWN` pending actual machine/jurisdiction evidence.

## Exact next independent work

Create `safety-course/SAFETY_CONFIGURATION_BASELINE_AND_ROLLBACK_INTEGRITY_WORKSHEET.md` if the primary lane remains elsewhere.

Focus: prevent a post-fault or maintenance rollback from restoring an old LinuxCNC/HAL/FPGA/safety-controller configuration that no longer matches the installed wiring/components. Record configuration identity, hardware compatibility, controlled backups, who/what may restore safety configuration, rollback prerequisites, post-rollback physical validation, and explicit separation between restoring ordinary controller software and restoring safety authority.

Before starting, re-read current `main` and primary checkpoint. If the primary lane enters configuration/change-management work, switch instead to another independent open maintenance/validation artifact rather than overlap.