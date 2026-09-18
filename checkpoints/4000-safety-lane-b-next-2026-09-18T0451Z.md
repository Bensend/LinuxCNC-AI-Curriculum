# 4000 safety Lane-B checkpoint — 2026-09-18T04:51Z

## Parallel-state check
At selection time current main ended at primary checkpoint `e4fb66d2` (`checkpoint: safety press restart handshake`). Primary work is press reset/restart/EDM and seeks a same-machine join to hydraulic final elements. Lane B selected separate 24 V control/safety supply backfeed/isolation instead, using a new study file and no overlapping primary files.

Immediately after substantive commit `76c30ae5`, main was re-read. No intervening commit appeared; the Lane-B commit was directly above `e4fb66d2`. No reconciliation was required.

## Durable result
Added `safety-course/SEPARATE_24V_CONTROL_SUPPLY_BACKFEED_ISOLATION_BOUNDARY_STUDY_2026-09-18.md`.

Freeze:

**24 V SUPPLY A OFF != SAFETY DOMAIN DE-ENERGIZED != SAFETY OUTPUT NODE UNPOWERED != FINAL-ELEMENT COIL/STO UNENERGIZED.**

Every crossing between ordinary control and safety-relevant wiring must be reviewed for electrical power direction under normal, power-down, reset, fault and service conditions, not merely logical signal direction.

OpenPressBrake-specific supply topology, isolation, shared returns, service-port behavior, final-element feeds, STO references and safety performance remain UNKNOWN.

## Next independent work
Find an authoritative complete professional example exposing separate safety/control/field 24 V supplies, isolation/coupling, safety output, final-element coil/STO, feedback, and power-down/restart behavior. Trace alternate-source/backfeed paths explicitly.

If the primary lane reaches that package first, rotate Lane B to gravity-axis brake/load-retention sequencing or service/bypass key-transfer authority.

## Compute
No executable verification was justified. No GitHub-hosted or self-hosted runner compute consumed.