# Safety maintenance lifecycle / bypass-pressure checkpoint — 2026-09-17

Status: CHECKPOINTED — safety course remains primary active 4000 work.

Session start UTC: `2026-09-17T08:36:42Z`

## Durable work completed

Added `safety-course/SAFETY_MAINTENANCE_LIFECYCLE_AND_BYPASS_PRESSURE_WORKSHEET.md`.

The artifact joins previously separate safety-course branches into the lifecycle:

`validated baseline -> periodic challenge/inspection -> anomaly/change trigger -> preserve evidence/restrict state -> root-cause investigation -> controlled repair/replacement -> scoped revalidation -> new validated baseline`

New durable emphasis:

1. repeated nuisance-trip/bypass pressure is an engineering and human-factors signal, not permission to suppress protection;
2. distinguish a real protective demand from a device/logic/final-element/feedback/workflow fault before changing settings;
3. preserve a failed challenge even if a reset or power cycle later produces PASS;
4. root-cause traces must preserve demand, safety logic, final element/EDM, physical-energy witness, recurrence context and common-cause families separately;
5. improve legitimate safe workflows when safeguard inconvenience predictably encourages defeat;
6. changing muting/discrepancy/EDM windows, guard geometry, safety parameters or mode behavior is a safety-function change requiring appropriate evidence/revalidation, not a default troubleshooting step;
7. part replacement and configuration restore feed into scoped revalidation before a new baseline exists;
8. ordinary LinuxCNC/HAL/FPGA diagnostics may help diagnosis but do not become independent personnel-safety authority.

## Evidence used

- OSHA machine-guarding guidance: safeguards that interfere with quick/comfortable work may be overridden/disregarded; design should avoid interference and, where possible, allow routine tasks such as lubrication without guard removal.
- OSHA 29 CFR 1910.147: servicing/maintenance hazardous-energy control; bypass/removal of safeguards during servicing is within the standard's stated application conditions where applicable.
- Pilz manipulation-protection guidance: convenience, speed, time/performance pressure, poor ergonomics and simplified modes are manipulation incentives; identify the incentive, optimize the protection concept and review effectiveness.

Claims remain labeled/bounded in the worksheet. No machine-specific OpenPressBrake PL/SIL/DC, stopping values, hydraulic truth tables, pressure/force thresholds, EDM timing, safe speed or universal periodic-test interval was invented.

## Compute

NONE. This was source/documentation/architecture work. No GitHub-hosted runner or self-hosted runner was used.

## Precise next work

Apply the maintenance lifecycle to a **documentation-to-installed-state audit**: create a reusable worksheet tracing each safety-relevant drawing/configuration identifier to the installed field device/final element and its physical witness. Include mismatch classes for wrong revision, undocumented replacement, moved protective device, altered feedback wiring, plumbing/mechanical change, stale safety CRC with changed field hardware, and LinuxCNC/FPGA mapping drift. Mark safety-critical mismatches `UNKNOWN — NOT CLEARED` until reconciled.

Then use that audit to define the minimum maintenance evidence package that a future technician must be able to recover without relying on tribal knowledge.

## Session-end logging note

Immediately before ending, append the UTC end/elapsed/overlap row to `LESSON_LOG.md` only through the repository's safe append mechanism. Do not replace a truncated fetch of that large file. If the connector cannot expose the safe append path, preserve the exact row in a separate append fragment rather than risking log loss.
