# Rockwell + Pilz — exception cleanup, reset, and fresh-start separation

## Question
After maintenance/service/test exceptions are cleared, what evidence supports requiring a distinct new start action rather than letting cleanup itself resume hazardous operation?

## Rockwell ordinary-control evidence

### DOC-CONFIRMED — release and start are distinct commands/readiness states
PlantPAx process objects expose Maintenance release separately from ordinary start. For example, the Process Lead Lag Standby Motor Group (`PLLS`) documents `MRdy_Rel` as readiness for `MCmd_Rel`, while separately exposing `ORdy_Start` for `OCmd_Start`. Process Motor (`PMTR`) likewise exposes Maintenance acquire/bypass/check/in-service/out-of-service/physical/release readiness separately from operator start readiness (`ORdy_Start1`, `ORdy_Start2`).

This does not by itself prove every project prevents automatic restart after maintenance release, but it does prove that the vendor object model does **not** need to collapse release and start into the same command.

### DOC-CONFIRMED — maintenance release changes authority, not necessarily motion demand
`PCMDSRC` describes `MCmd_Rel` as releasing Maintenance ownership to another command-source class. The command-source model is an authority arbitration mechanism. Treating that authority transition as an implicit new production demand would be an additional project behavior, not something established merely by the release command semantics.

## Pilz safety/restart evidence

Pilz's machine-safety guidance states that after a safeguard has triggered, clearing the protected field must not automatically restart the machine; restart requires a reset/control action outside the danger zone with appropriate visibility. Its emergency-stop guidance similarly states that resetting the operated E-stop must not automatically restart the machine, but only prepare it for restart; starting must occur through deliberate actuation of a control device intended for that purpose. Pilz also describes guard interlocking such that hazardous functions remain prevented until the guard is closed and a separate start command is required.

These are safety-related restart principles, not evidence that an ordinary PlantPAx maintenance release is a safety reset.

## Cross-boundary teaching

The two evidence sets reinforce a reusable architecture while preserving authority boundaries:

1. **exception cleanup** — remove bypass, simulation/virtual selection, forces, temporary aids, maintenance ownership, etc.;
2. **safety reset/rearm** — independent safety architecture establishes whatever reset/rearm conditions its risk assessment requires;
3. **ordinary fresh start** — a deliberate new production start request is accepted only after the relevant cleanup and safety prerequisites are satisfied.

Do not collapse these into one button merely because software makes it convenient.

Freeze:

- **MAINTENANCE RELEASE != START COMMAND.**
- **BYPASS CLEAR != START COMMAND.**
- **SAFETY RESET != START COMMAND.**
- **GUARD/PROTECTED FIELD CLEAR != AUTOMATIC RESTART AUTHORITY.**
- **START REQUEST != SAFETY RESET.**
- **AUTHORITY RESTORED != OLD MOTION DEMAND FRESH.**

## Human-factors failure path

A dangerous implementation can preserve an old automatic demand while maintenance owns the device, then immediately honor that stale demand when Maintenance releases. Even if every individual state transition is logically valid, the combined handoff can surprise the technician/operator. The safer architecture invalidates stale production demand across maintenance/service entry and requires a fresh post-cleanup production request.

That stale-demand invalidation is an **engineering recommendation/inference** here. Its exact implementation must be machine-specific; the sources do not justify claiming every Rockwell object automatically provides it.

## LinuxCNC/OpenPressBrake transfer

For a LinuxCNC machine, HAL/GUI/FPGA ordinary-control logic may implement a `production_config_clean` or `fresh_start_required` gate, but that gate is not personnel-safety authority. Entering service/maintenance should invalidate pending automatic cycle demand; leaving it should restore eligibility, not command motion. Independent safety logic retains authority over personnel-protective functions and physical safety final elements.

## Sources
- Rockwell Automation Studio 5000 online help, `Process Lead Lag Standby Motor Group (PLLS)`, retrieved 2026-09-21.
- Rockwell Automation Studio 5000 online help, `Process Motor (PMTR)`, retrieved 2026-09-21.
- Rockwell Automation Studio 5000 online help, `Process Command Source (PCMDSRC)`, retrieved 2026-09-21.
- Pilz, `Movable guards - EN ISO 14120`, retrieved 2026-09-21.
- Pilz, `Emergency stop is operated on a machine`, retrieved 2026-09-21.
- Pilz, `Interlocking device, safety switch`, retrieved 2026-09-21.

## Next branch
The fresh-start principle is now adequately supported at the architecture level. Next useful 25C0 work should adversarially inspect **stale demand / queued command / automatic-cycle resumption across mode or authority transitions** in a real controller/machine implementation. If authoritative sources do not expose that behavior, mark it source-limited and rotate to another safety human-factors branch rather than inventing semantics.
