# 4000 Safety Lane B Checkpoint — 2026-09-16d

## Completed

Added `safety-course/LIGHT_CURTAIN_BLANKING_CONFIGURATION_VALIDATION.md`.

Selected inspectable family: Allen-Bradley GuardShield 450L-E. Manufacturer documentation now anchors the course distinction among fixed blanking, monitored floating blanking, and floating blanking without monitoring. The curriculum explicitly treats blanking as a change to the protective-field claim rather than a nuisance-filter preference.

Frozen safety boundary: LinuxCNC/ordinary FPGA may request/report process state and diagnostics but may not silently own personnel-safety blanking authority. Product Type/SIL/PL capability does not prove the complete machine safety function. Protective distance, access geometry, stopping behavior and application suitability remain machine-specific and UNKNOWN until evidenced.

Added adversarial cases for removed fixed objects, enlarged physical openings, monitored-object absence, no-monitor convenience proposals, recipe-driven configuration changes, replacement devices, device-rating shortcuts and requests for invented protective distances.

No compute consumed; documentation/source reasoning answered the current question.

## Next independent work

Rotate to guard-locking / escape-release / restoration semantics. Trace one authoritative manufacturer family deeply enough to separate guard monitoring from guard locking, power-to-lock versus power-to-unlock behavior, escape/emergency release, loss-of-power consequences, and restart/rearm after release/restoration. Preserve the rule that a locked guard is not itself proof that hazardous motion has stopped unless the safety function provides that evidence.

If another lane has already occupied that branch at next start, rotate to maintenance-mode enabling-device architecture and three-position enabling-device behavior rather than duplicating work.
