# Safety checkpoint — replacement/revalidation and physical-proof boundary

Date: 2026-09-19

## Durable work this session

- `safety-course/PRESS_BRAKE_SAFETY_RELATED_REPLACEMENT_MACHINE_LEVEL_REVALIDATION_TRACE_2026-09-19.md`
- `safety-course/FIELD_DEVICE_REPLACEMENT_REVALIDATION_AND_EDM_PROOF_BOUNDARY_2026-09-19.md`
- `PROGRESS.md` updated with the new freezes and next work.

## New strongest evidence

Current CINCINNATI XF OEM maintenance documentation states that replacement of safety-related equipment may affect safe performance and requires qualified verification of safe machine operation and **all safety functions**. Hydraulic service/replacement requires the ram physically blocked and main disconnect OFF/locked. Counterbalance adjustment checks both sides, cycles the ram, and rechecks both pressures.

Rockwell project validation independently requires actual field sensors/actuators and shutdown functions to be exercised in the physical application. EDM validation deliberately injects contactor-feedback faults and expects reset/restart inhibition.

## Frozen boundaries

`SAFETY-RELATED COMPONENT REPLACED != MACHINE SAFE TO RETURN TO SERVICE`

`REPLACEMENT DEVICE INSTALLED != FIELD WIRING VERIFIED != SAFETY FUNCTION REVALIDATED != PHYSICAL HAZARD SAFE != PRODUCTION AUTHORITY`

`EDM PASS != HAZARDOUS ENERGY ABSENT != PHYSICAL STOP PERFORMANCE PROVED`

`MACHINE-LEVEL REVALIDATION REQUIREMENT != UNMASKED INDIVIDUAL HYDRAULIC RETENTION PROOF`

## Primary UNKNOWN retained

Public authoritative evidence still has not exposed the exact chain:

`specific monitored hydraulic holding/safety valve replacement -> companion path removed from proof -> individual physical ram/load-retention witness -> pass/fail disposition -> required dynamic stopping re-proof -> safety rearm -> fresh press-brake production initiation`.

Do not manufacture this test or infer a degraded-production mode.

## Exact next work

1. Recheck authoritative press-brake OEM/manifold service sources for the component-specific individual-retention/replacement chain above.
2. If source-limited, continue Lane B into an implementation with external switching-element replacement followed by actual field-device functional proof and a physical energy/motion witness.
3. Keep safety-network and accessible-cell recovery branches available as independent high-value rotations.
4. No compute unless a concrete unresolved question requires it; any compute must use `[self-hosted, openpressbrake]`, never a GitHub-hosted runner.
