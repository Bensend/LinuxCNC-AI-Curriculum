# 4000 safety Lane B checkpoint — servo-hydraulic acceptance boundary

## Durable result

Added `safety-course/REXROTH_SERVO_HYDRAULIC_SAFE_MOTION_AXIS_AND_MACHINE_ACCEPTANCE_BOUNDARY_2026-09-20.md`.

Bosch Rexroth CytroForce-M documentation adds genuinely hydraulic acceptance evidence independent of the primary stopping-performance branch: the safety-capable actuator combines electrical Safe Motion with two series hydraulic valves having separate spool-position monitoring; axis validation must prove safety-related sensing corresponds to real mechanical movement; and Rexroth explicitly says generic drive Safe Motion acceptance is not sufficient for the servo-hydraulic application.

Freeze:
- ENCODER DATA PLAUSIBLE != SAFE-MOTION SENSING MAPPED TO THE REAL MECHANICAL AXIS.
- DRIVE SAFETY ACCEPTANCE PASSED != SERVO-HYDRAULIC MACHINE SAFETY ACCEPTANCE PASSED.
- SAFE-MOTION PARAMETERS VERIFIED != HYDRAULIC FINAL-ELEMENT PATH PHYSICALLY VALIDATED.

## Parallel-work disposition

Primary durable work immediately before this lane was `PRESS_STOPPING_PERFORMANCE_WORST_CASE_MEASUREMENT_AND_SAFEGUARD_CONFIGURATION_AUTHORITY_2026-09-20.md`, focused on stop-test machine configuration and safeguard geometry. Lane B used a new file and a distinct hydraulic axis/machine acceptance boundary. Current main was re-read before checkpointing; no overlapping Lane-B file had changed.

`PROGRESS.md` was deliberately not overwritten during this parallel run because it is a shared hot file and the newest primary lane had just updated it. This checkpoint plus the new safety-course artifact are the durable Lane-B progress record; the next safe primary/progress reconciliation can add the artifact without discarding newer primary work.

## Exact next Lane-B work

Seek authoritative servo-hydraulic/press documentation exposing one complete physical acceptance chain:

`protective demand -> electrical safe-motion response -> monitored hydraulic valve/final-element response -> pressure/motion/holding witness -> quantitative criterion -> mismatch/fault disposition -> repair/replacement -> affected-function retest -> production release`.

The strongest missing evidence remains the combination of monitored hydraulic final-element position with pressure/motion witness, quantitative acceptance, mismatch behavior and post-repair return-to-service. If authoritative sources do not expose that chain, mark this hydraulic sub-branch source-limited and rotate rather than inventing a truth table.

No OpenPressBrake hydraulic topology, pressure threshold, stop/hold performance, PL/SIL/Category/DC/CCF or test interval was inferred from CytroForce-M. No executable verification was justified; no GitHub-hosted runner was used.
