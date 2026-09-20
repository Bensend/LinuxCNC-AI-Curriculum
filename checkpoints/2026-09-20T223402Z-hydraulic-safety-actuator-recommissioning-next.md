# 4000 safety checkpoint — hydraulic safety actuator recommissioning

UTC checkpoint: 2026-09-20T22:34:02Z

## Durable advance

Added `safety-course/HYDRAULIC_SAFETY_ACTUATOR_REPAIR_RECOMMISSIONING_AND_SAFETY_TIME_REVALIDATION_2026-09-20.md`.

Bosch Rexroth actuator evidence materially strengthens the maintenance lifecycle: after repair/replacement, safety functionality is included in final examination; recommissioning requires validation of the safety function including its safety period and traceable documentation. This establishes that restored configuration and apparent operation are not substitutes for the quantitative physical timing evidence on which a time-dependent hydraulic safety function relies.

## Frozen distinctions

- HYDRAULIC SAFETY COMPONENT REPAIRED != SAFETY FUNCTION REVALIDATED.
- SAFETY FUNCTION OPERATES != REQUIRED SAFETY TIME PHYSICALLY REVALIDATED.
- VALVE/ACTUATOR CONFIGURATION RESTORED != PHYSICAL HYDRAULIC PERFORMANCE RESTORED.
- RECOMMISSIONING FUNCTION TEST COMPLETE != MACHINE-SPECIFIC PRODUCTION RELEASE unless the machine/OEM acceptance authority says so.

## Boundary

Do not copy the actuator paper's proof-test interval or any product-specific timing into OpenPressBrake. OpenPressBrake hydraulic topology, thresholds, timing, holding criteria, measurement points, PL/SIL and release procedure remain UNKNOWN.

## Next work

The generic hydraulic-component branch is approaching an information-gain stop. Continue only for a genuinely new machine/OEM procedure that maps a safety-related maintenance/replacement change to affected hydraulic/mechanical final-element tests, quantitative physical criteria, safeguard requalification and explicit production release. If public documentation still does not expose that chain, mark the branch source-limited and rotate to the highest-value open 4000 safety module rather than inventing a truth table.

No executable compute was justified. No GitHub-hosted runner was used.
