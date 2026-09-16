# Safety Curriculum Lane B — recovery change-impact checkpoint — 2026-09-16

Status: CHECKPOINTED — independent lane complete for this pass.
Compute: NONE; documentation/source work only. No GitHub-hosted Actions minutes consumed.

## Parallel-lane check

Lane B read the required curriculum/progress state and inspected recent commits before selecting work. The primary lane's newest durable checkpoint was `checkpoints/session-2026-09-16-safety-wiring-03.md`, commit `61ae4cc...`, focused on professional machine safety wiring, two-map electrical/fluid/gravity energy-boundary reasoning, and searching for complete OEM electrical + hydraulic final-element traces.

Lane B therefore stayed on the separate disaster-recovery/change-impact evidence branch and did not modify the primary professional wiring/reference files, `PROGRESS.md`, or primary safety-wiring checkpoints.

Immediately before committing the module, current main was re-read through recent commits. HEAD remained `61ae4cc...`; no overlapping disaster-recovery/change-impact file had appeared. After the module commit, main was re-read again and `d4adf0be...` was HEAD with the primary lane intact below it.

## Durable work completed

Added `safety-course/DISASTER_RECOVERY_CHANGE_IMPACT_REVALIDATION_MATRIX.md`.

Frozen rule:

`unchanged file` does not mean `unchanged safety function`, and `changed component` does not automatically invalidate every unrelated proof. Revalidation scope follows the changed dependency to the claims it can affect.

The matrix covers controller replacement, firmware/compiler change, safety-I/O replacement, protective-device replacement, field-wiring repair, backup restore, calibration/teach loss, drive/safe-motion replacement, contactor/final electrical element replacement, hydraulic/pneumatic final-element replacement, guard/interlock mounting changes, safety-network identity/topology changes, and ordinary LinuxCNC/HAL/FPGA/HMI updates where the independent safety authority is intended to remain unchanged.

## Evidence gained

- `DOC-CONFIRMED`: GuardLogix restore/download guidance distinguishes application testing from safety-signature identity and requires signature comparison to retained safety documentation.
- `DOC-CONFIRMED`: GuardLogix safety-I/O replacement is device/configuration sensitive; manufacturer guidance requires proper configuration and validation of operation after replacement before affected safety use.
- `DOC-CONFIRMED`: safety-I/O configuration signatures identify device configuration, not arbitrary field wiring or physical final-element behavior.
- `DOC-CONFIRMED`: OSHA 29 CFR 1910.147 requires hazardous stored/residual energy control and verification of isolation/deenergization before servicing; release from LOTO includes inspection for operational integrity.
- `INFERENCE`: recovery work therefore has two separate proof questions: whether the machine is safe for the servicing task, and whether affected operational safety functions are restored for production.

## Exact next independent work

If the primary lane remains on OEM/professional E-stop/interlock/electrical-fluid energy-boundary tracing, build `safety-course/SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md`.

Distinguish:

1. exact replacement;
2. manufacturer-approved successor/substitute;
3. independently engineered equivalent with documented safety-relevant correspondence;
4. merely functionally similar or undocumented substitute.

Trace safety-related ratings, device-local configuration, diagnostics, feedback contacts, response dependencies, mechanical mounting/actuation, environmental assumptions, electrical isolation/energy interruption, and fluid-power function where applicable. State what prior evidence can survive and what must be revalidated.

Do not make a purchasing whitelist, infer safety equivalence from matching voltage/current alone, or invent machine-specific performance/pressure/stopping values.

If the primary lane moves onto replacement-part equivalence before the next Lane-B pass, rotate to another independent open safety artifact rather than duplicating it.