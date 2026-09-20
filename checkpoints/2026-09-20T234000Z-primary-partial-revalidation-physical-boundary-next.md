# 4000 safety checkpoint — change-impact partial revalidation and physical application boundary

UTC checkpoint: 2026-09-20T23:40:00Z

## Durable advance

Added `safety-course/ROCKWELL_CHANGE_IMPACT_PARTIAL_REVALIDATION_AND_PHYSICAL_APPLICATION_BOUNDARY_2026-09-20.md`.

Rockwell GuardLogix documentation explicitly supports impact-analysis-scoped revalidation while requiring full validation to exercise each sensor and actuator involved in every safety function and treating validation as specific to the actual installation's sensors, actuators, wiring, networks and physical equipment. Safety-signature hierarchy can identify changed controller elements and reduce legitimate revalidation effort, but it is not physical machine proof.

## Frozen distinctions

- CHANGE IDENTIFIED != IMPACT ANALYSIS COMPLETE.
- IMPACT ANALYSIS COMPLETE != AFFECTED SAFETY FUNCTIONS REVALIDATED.
- SAFETY SIGNATURE VERIFIED != PHYSICAL MACHINE SAFETY FUNCTION VALIDATED.
- CONTROLLER LOGIC UNCHANGED != SENSOR/ACTUATOR/WIRING/FINAL-ELEMENT EVIDENCE STILL VALID.
- PARTIAL REVALIDATION ALLOWED != MINIMAL EDIT-ONLY TESTING ALLOWED.

## Parallel-lane reconciliation

Newest Lane-B checkpoint is power-restoration/startup-test authority. This primary-lane work deliberately stayed on change-impact/revalidation scope and did not duplicate the stale-command/power-restoration branch.

## Exact next work

The generic partial-revalidation principle is now adequately manufacturer-supported. Seek a genuinely machine-level/OEM example applying change-impact scope to physical hydraulic/mechanical final elements or safeguard geometry, preferably with quantitative acceptance and explicit return-to-production disposition. If public OEM evidence remains unavailable, mark that narrow branch source-limited and rotate to another open 4000 safety module rather than invent criteria.

Preserve OpenPressBrake-specific PL/SIL, hydraulic topology/truth tables, stopping limits, proof-test intervals, pressure thresholds, safe-speed values, diagnostic coverage and safeguard distances as UNKNOWN until design-specific authority exists.

No executable compute was justified. No GitHub-hosted runner was used.
