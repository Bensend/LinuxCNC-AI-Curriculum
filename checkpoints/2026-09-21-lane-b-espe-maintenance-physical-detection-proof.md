# Lane B checkpoint — ESPE maintenance physical-detection proof

Date: 2026-09-21
Study commit: `d0fb98dafb977ebc95d4462476c0402462eefed0`

## Parallel-work reconciliation

Before selection, Lane B read the required curriculum entry/order/policy/progress state and recent commits. The newest primary durable work is the temporary commissioning/test-state branch: FANUC temporary test-state production blocking, Rockwell force-removal/safety-signature boundaries, 25C0 exceptional-state handoff, and an adversarial physical-change review. Primary next work seeks persistence/clearing and return-to-service evidence for forces/simulations/overrides.

Lane B therefore selected a different source/evidence family and a new file: ESPE physical detection after maintenance, contamination, optical replacement, alignment, and geometry-affecting work. No primary files were modified.

After the study commit, current main was re-read via recent commits. `d0fb98d` remained the newest commit; no overlapping-file reconciliation was required.

## Durable result

Added `safety-course/ESPE_MAINTENANCE_CONTAMINATION_ALIGNMENT_AND_PHYSICAL_DETECTION_PROOF_STUDY_2026-09-21.md`.

Key freezes:

- **DEVICE REPORTS HEALTHY != PHYSICAL PROTECTIVE FIELD PROVED**
- **OPTICS CLEANED != ALIGNMENT/GEOMETRY UNCHANGED PROVED**
- **OPTICS COVER REPLACED != CONTAMINATION REFERENCE CALIBRATED != SCANNER ALIGNED != PROTECTIVE FUNCTION PHYSICALLY REVALIDATED**
- **CONFIGURATION CHECKSUM UNCHANGED != MOUNTING/ALIGNMENT/PROTECTED GEOMETRY UNCHANGED**
- **EXPECTED OSSD/SAFETY INPUT TRANSITION != DANGEROUS MACHINE RESPONSE PHYSICALLY PROVED**
- **MAINTENANCE COMPLETE != RETURN TO PRODUCTION AUTHORIZED**

Manufacturer evidence: SICK C4000/C4000 Palletizer physical test-rod checks across the protected area and post-change/repaired-device reinspection; SICK S200 optics-cover replacement requires machine isolation and a new-cover calibration reference; current SICK scanner replacement guidance also calls for calibration and alignment after optics-cover replacement.

## Provenance status

Manufacturer procedures are `SOURCE-CONFIRMED`. OpenPressBrake transfer statements are `INFERENCE`. Actual OpenPressBrake ESPE type, geometry, resolution, response time, safety distance, reset architecture, PL/SIL/category, test interval, and acceptance thresholds remain `UNKNOWN` unless separately frozen by machine-specific evidence. No claims were promoted to `TEST-CONFIRMED` without physical testing.

## Compute

No executable verification was justified. No GitHub-hosted runner was used. Future repository compute, if a concrete question genuinely requires it, must target `[self-hosted, openpressbrake]` only.

## Precise next work

Find an authoritative OEM/manufacturer procedure that closes the post-ESPE-maintenance chain: **physical field challenge across required geometry -> protective-device output -> safety logic -> actual machine/final-element stop -> failed-test production lockout -> correction -> complete retest -> reset/rearm -> separate fresh ordinary start**. Prefer press/press-brake or another high-energy machine. If authoritative evidence ends at the protective-device output, preserve that boundary and rotate rather than inventing downstream behavior.

`PROGRESS.md` was intentionally not overwritten in this lane because concurrent primary work is active; this checkpoint preserves Lane-B durable state without racing the primary lane.