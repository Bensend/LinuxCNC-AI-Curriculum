# Safety Lane B — installed-device documentation identity — 2026-09-17

- Lane: secondary / independent safety curriculum lane
- Compute: NONE. No GitHub-hosted Actions minutes consumed; executable verification was not justified.
- Status: CHECKPOINTED — safety course remains active.

## Parallel-work check

Before selection, Lane B read the required curriculum entry/order/policy/progress files, active primary checkpoint, safety-course inventory and recent commits.

The newest primary durable work was `safety-course/SAFETY_MAINTENANCE_LIFECYCLE_AND_BYPASS_PRESSURE_WORKSHEET.md` (commit `405f88f`), joining maintenance lifecycle, latent-failure challenge, anomaly/trend review, replacement equivalence, scoped revalidation and bypass-pressure root cause. That overlapped Lane B's prior proposed nuisance-trip/bypass-pressure worksheet, so Lane B abandoned that branch rather than duplicate it.

Immediately before the durable Lane-B write, current `main` still ended with the primary lane's maintenance-lifecycle/log commits. After the artifact commit, `main` was re-read and no intervening primary commit or overlapping file appeared.

## Durable work completed

Added `safety-course/INSTALLED_SAFETY_DEVICE_DOCUMENTATION_IDENTITY_AUDIT.md` in commit `03045fe`.

The artifact freezes this evidence chain:

`installed physical identity -> installed configuration identity -> applicable manufacturer document/revision -> claimed function/constraint -> machine drawing/configuration mapping -> physical verification`

A break in that chain leaves the affected safety claim `UNKNOWN — NOT CLEARED`.

## Key findings

- A correct manufacturer but wrong model suffix/revision/option/firmware is not sufficient documentation proof.
- A manual saying a device can perform a safety function does not prove the installed configuration enables or wires that function.
- Controlled drawings and field installation must be reconciled; neither is automatically correct when they disagree.
- Software CRC/configuration identity proves only its bounded configuration scope, not unchanged wiring, plumbing, mechanics, guard geometry or physical hazardous-energy response.
- LinuxCNC/HAL/FPGA diagnostic names and command state remain ordinary-control/context evidence unless the actual independent safety architecture assigns and validates a safety role.
- Newer manuals are not automatically valid evidence for older installed hardware.
- Exact OpenPressBrake safety device identities, hydraulic safety-valve arrangement, protective-field geometry, STO/safe-motion implementation, EDM mapping, stopping/pressure/force/timing behavior and gravity/stored-energy controls remain `UNKNOWN` until machine-specific evidence establishes them.

## Exact next independent work

If the primary lane has not entered documentation-control work, create `safety-course/SAFETY_DOCUMENT_PROVENANCE_AND_SUPERSESSION_REGISTER.md` covering manufacturer source/document number, revision/date, applicable hardware/firmware range, retrieval date, supersession status, archived-copy identity, claim links, and unresolved applicability conflicts.

If the primary lane enters that branch first, switch to another independent open evidence task rather than touching its files.

No machine-specific PL/SIL/DC, stopping distance, pressure/force threshold, timing value or hydraulic truth table was invented.