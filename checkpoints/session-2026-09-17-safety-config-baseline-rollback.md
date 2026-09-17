# Safety configuration baseline / rollback integrity checkpoint — 2026-09-17

- Start UTC: `2026-09-17T06:34:36Z`
- End UTC: `2026-09-17T06:36:05Z`
- Actual elapsed: **1.5 minutes**
- Compute: **NONE**. No GitHub-hosted Actions minutes consumed; self-hosted compute was not justified.
- Overlap: **YES / parallel lane expected.** Recent main history showed Lane-B safety work immediately preceding this run and a primary safety lane active in adjacent commits. This session deliberately selected the Lane-B configuration/rollback branch and did not edit the primary lane's commissioning/human-factors/stale-command artifacts.

## Durable work

Created `safety-course/SAFETY_CONFIGURATION_BASELINE_AND_ROLLBACK_INTEGRITY_WORKSHEET.md`.

Frozen principle:

> A backup is evidence of what was saved, not proof that it is safe for the hardware that exists now.

The worksheet now separates ordinary LinuxCNC/HAL configuration, FPGA/normal hardware configuration, safety-related configuration, and the physical energy-control implementation. It requires a validated baseline manifest tying configuration identity to physical drawings/hardware; controlled backup classification; a pre-rollback hardware/configuration compatibility gate; explicit restore authority; post-restore transfer-integrity + physical-correspondence + safety-function validation; and adversarial rollback tests.

Manufacturer evidence integrated:

- Rockwell GuardLogix: restored/downloaded safety application identity is checked using safety signatures; mismatched signatures/firmware can require unlocking/deleting the signature and revalidation; safety I/O also has configuration signatures and identity/ownership constraints.
- SICK Flexi Soft: verification reads configuration back, compares project/device data, and records verified/current checksums.
- Pilz PNOZ s30: after configuration download, the device Configuration CRC is checked against the configurator CRC.

Important boundary retained: matching signature/CRC/checksum proves configuration identity only within its defined scope. It does not prove field wiring, final elements, hydraulic plumbing, guarding, stored-energy control, stopping performance, EDM truthfulness, or ordinary-controller stale-command behavior.

## Short-session continuation check

This run was short because the selected branch was a bounded worksheet synthesis that closed the exact Lane-B checkpoint item. Useful safety work remains, so the curriculum automation must remain enabled. The next coherent independent task is below rather than manufacturing simulation.

## Exact next independent work

If the primary lane remains focused on complete-machine/stale-command application, create a **safety replacement-parts and equivalence validation worksheet**. Trace what must be re-established when a contactor, safety valve, drive, safety I/O module, protective device, encoder/sensor, power supply, or controller is replaced by a nominally equivalent part. Explicitly distinguish electrical compatibility, diagnostic/feedback compatibility, safety certification/configuration identity, physical energy-control behavior, firmware/configuration effects, and machine-specific revalidation.

If the primary lane has moved into that branch, rotate instead to proof-test/periodic-inspection evidence and latent-failure discovery.

## LESSON_LOG safe-append record

The repository contains `.github/workflows/append-lesson-log.yml`, routed to `[self-hosted, openpressbrake]`, but the current GitHub connector exposes workflow inspection/re-run actions and not a workflow-dispatch action. `LESSON_LOG.md` is large and was only safely partially fetched, so it was **not overwritten** through Contents API.

Exact row preserved for the repository's append-only mechanism:

`| 2026-09-17 | 4000 safety configuration baseline + rollback integrity | 2026-09-17T06:34:36Z | 2026-09-17T06:36:05Z | 1.5 | CONFIGURATION/ROLLBACK WORKSHEET ADDED | Replacement-parts/equivalence validation if non-overlapping; otherwise periodic proof-test/latent-failure branch. | Parallel-lane overlap expected; selected non-overlapping Lane-B branch. No lab compute consumed. |`
