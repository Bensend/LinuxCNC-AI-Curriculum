# Safety curriculum Lane B checkpoint — emergency substitution control

Date: 2026-09-16
Status: CHECKPOINTED / independent safety lane remains active
Compute: NONE. Documentation/source analysis only; no GitHub-hosted Actions minutes consumed.

## Parallel-work check

Before selecting work, Lane B re-read the active repository governance/progress files and recent commits. Primary safety work most recently added `safety-course/POWER_LOSS_RESTORATION_AND_UNEXPECTED_RESTART_2026-09-16.md` and checkpointed that study. It is focused on mains/safety-control/ordinary-controller/network restoration, cold-start behavior, reset/restart separation, and unexpected restart paths.

Lane B deliberately selected a different evidence package and file set: maintenance response when a safety-relevant component fails and the approved spare is unavailable. No primary-lane files were edited.

Immediately after the Lane-B artifact commit, current `main` was re-read. HEAD was the Lane-B artifact commit `61e9748ee95aa66dc420812e1e0806a65f482262`, parented directly to the primary lane's checkpoint `e0d922b31f670472d576a446b05a7d9443e4ad8a`; no overlapping primary file changed during the Lane-B write.

## Durable work completed

Added:

- `safety-course/MAINTENANCE_EMERGENCY_SAFETY_SUBSTITUTION_DECISION_TREE.md`

Artifact commit:

- `61e9748ee95aa66dc420812e1e0806a65f482262` — `Add maintenance emergency safety substitution decision tree`

## Frozen learning

1. `approved spare unavailable` defaults to controlled OUT OF SERVICE for operation requiring the affected personnel-safety function; urgency does not lower the function's required behavior.
2. A bypass, force, jumper, suppressed EDM/discrepancy, downgraded reset behavior, or ordinary LinuxCNC/FPGA inhibit is not an emergency safety substitution.
3. Exact replacement, manufacturer-named direct/approved successor, and engineered equivalent are separate evidence classes. Manufacturer terminology must be preserved rather than flattening a functional successor into `drop-in`.
4. A safety-relevant `UNKNOWN` capable of defeating the function blocks equivalence/return-to-production claims.
5. Component replacement is maintenance work requiring physical hazardous-energy control appropriate to the task; control circuitry is not energy isolation.
6. Temporary energized testing/positioning is a bounded maintenance transition, followed by deenergization and reapplication of energy controls when the energized step is complete. It is not permission for production with an incomplete safety function.
7. Installed replacement state is `INSTALLED-PENDING-VALIDATION` until the affected physical safety function and relevant fault/reset/restart/final-element paths are re-challenged within a documented scope.
8. Ordinary LinuxCNC/HAL/FPGA/HMI can diagnose, inhibit normal operation, and guide the technician but does not inherit personnel-safety authority because independent safety hardware is unavailable.

## Evidence provenance

- OSHA 29 CFR 1910.147: `SOURCE-CONFIRMED` for servicing/maintenance hazardous-energy control, stored/residual energy control, verification of isolation, and testing/positioning sequence.
- OSHA LOTO enforcement guidance STD 01-05-019: `SOURCE-CONFIRMED` for component replacement not being treated as routine production-mode maintenance and for safeguard restoration before release.
- OSHA 2024-10-21 LOTO interpretation: `SOURCE-CONFIRMED` for the bounded nature of temporary re-energization used for testing/positioning.
- No machine-specific hydraulic truth table, pressure threshold, stopping distance, safe-motion performance, PL/SIL/category, or substitute-part equivalence was inferred from those sources.

## Exact next independent work

Build `safety-course/SAFETY_MAINTENANCE_HANDOFF_SHIFT_CHANGE_CONTINUITY_WORKSHEET.md`.

It should cover incomplete repair/emergency-substitution handoff across technicians and shifts, including:

- exact machine and affected safety function;
- current hazardous-energy isolation/blocking/restraint state and who controls it;
- guards/safety devices removed or unavailable;
- temporary jumpers, forces, test plugs, fixtures, grounds, shorts, or diagnostic overrides;
- replacement part identity and state (`QUARANTINE`, `APPROVED-SPARE`, `INSTALLED-PENDING-VALIDATION`, etc.);
- unresolved `UNKNOWN`s and failed validation observations;
- what remains energized/stored/reaccumulable;
- exact next physical validation step and prerequisites;
- responsibility transfer and positive acknowledgement;
- machine OUT-OF-SERVICE state that remains unmistakable through the handoff.

Use OSHA 1910.147(f)(4) shift/personnel-change continuity as an authoritative starting point, but do not turn a handoff form, CMMS status, or verbal acknowledgement into a substitute for physical energy isolation, locks, blocking, restraint, or required safeguard restoration.

Before starting, re-read current `main` and the primary safety task's newest durable artifact. If the primary lane has entered maintenance handoff/shift-change work, switch Lane B to another independent open safety evidence package instead of duplicating it.