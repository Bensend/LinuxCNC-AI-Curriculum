# 4000 safety checkpoint — Haas HPB physical installation / revalidation boundary

UTC checkpoint: 2026-09-21T00:42:00Z

## Durable advance

Added:

- `safety-course/HAAS_HPB_INSTALLATION_PHYSICAL_SAFEGUARD_ALIGNMENT_AND_REVALIDATION_BOUNDARY_2026-09-21.md`
- `safety-course/HAAS_HPB_DISPLAYED_STATE_VS_PHYSICAL_POSITION_DIAGNOSTIC_AUTHORITY_2026-09-21.md`

The current Haas HPB OEM manual places Y1/Y2 proportional-valve installation and physical light-curtain installation/alignment in the same press-brake commissioning chapter. This provides a useful machine-level change-impact example but the public procedure does not expose the complete sought chain from protective demand through hydraulic final element and quantitative ram response to production release.

The Haas troubleshooting chapter separately provides a strong physical-witness pattern: compare displayed deflection position to actual physical sensor position; stop continued commanding when displayed feedback and physical motion disagree; after phasing changes, verify actual physical direction rather than trusting command state.

## Frozen distinctions

- LIGHT CURTAIN PHYSICALLY ALIGNED != PROTECTIVE FUNCTION MACHINE-RESPONSE VALIDATED.
- RECEIVER/STATUS INDICATION HEALTHY != RAM STOPPING RESPONSE PHYSICALLY PROVED.
- PROPORTIONAL VALVE INSTALLED/CONNECTED != SAFETY-RELATED HYDRAULIC FINAL-ELEMENT RESPONSE VALIDATED.
- CONTROL + HYDRAULIC INITIALIZATION COMPLETE != SAFETY ACCEPTANCE COMPLETE.
- FACTORY CONFIGURATION BACKUP CREATED != PHYSICAL SAFETY FUNCTION VALIDATED.
- COMMAND DIRECTION != PHYSICAL DIRECTION.
- DISPLAYED POSITION != PHYSICAL POSITION.
- PHYSICAL MOTION OBSERVED != POSITION FEEDBACK VALID.

## Source-limit disposition

The repeated generic search for a single public press-brake OEM partial-acceptance matrix combining affected-function scoping, hydraulic/mechanical final-element witness, quantitative criterion, safeguard requalification, repair/retest and explicit production release is now branch-locally source-limited. Do not continue generic searching merely to fill time. Reopen only when a genuinely new OEM/service/commissioning source exposes that missing chain.

This is an evidence-availability statement, not a claim that Haas or another OEM lacks non-public/factory validation procedures.

## Parallel-lane reconciliation

Newest Lane-B checkpoint `137bcd7a...` was read before durable work. Lane B is pursuing reset-station visibility/blind-area personnel-clear authority. This primary session deliberately stayed on physical change/revalidation and feedback-witness evidence and did not modify Lane-B artifacts.

## Short-session continuation check

After the primary OEM-matrix search reached a source-availability stop, the session did not quit. It rotated into the current Haas troubleshooting evidence and preserved the displayed-state versus physical-position witness lesson. No synthetic simulation or redundant generic catalog search was launched.

## Exact next primary work

Rotate from the source-limited all-in-one OEM matrix search to the highest-value open 25E0/4000 validation-course synthesis: build an AI-readable commissioning/return-to-service decision procedure that starts from a changed physical item, traces affected safety-function dependencies, names which validation evidence classes are invalidated, requires physical witnesses where applicable, and keeps production release/fresh START separate. Base it only on already preserved manufacturer evidence; do not invent OpenPressBrake numerical criteria.

A later source can reopen the OEM-matrix branch if it provides genuinely new hydraulic/mechanical or safeguard-geometry acceptance evidence.

## OpenPressBrake boundary

No OpenPressBrake hydraulic truth table, pressure/stopping threshold, safeguard distance, PL/SIL/category/DC/CCF, proof-test interval or production-release criterion was inferred. Ordinary LinuxCNC/HAL/FPGA diagnostics may expose disagreement and retain evidence but are not personnel-safety authority.

## Compute

No executable verification was justified. No GitHub-hosted runner was used and no hosted Actions minutes were consumed. The self-hosted runner was not invoked because there was no question-driven compute need.
