# Lane-B safety checkpoint — maintenance energy isolation / stored-energy authority

Date: 2026-09-18

## Completed

Created `safety-course/MAINTENANCE_ENERGY_ISOLATION_STORED_ENERGY_RETURN_TO_SERVICE_STUDY_2026-09-18.md`; substantive commit `83e3216b591661c49df30e28ce19374a117b642c`.

## Independence / overlap check

Before selection, current primary durable checkpoint was `af17699cffb460a664b418d3145712763cd57d23`, advancing press-brake redundant hydraulic restraint and final-element/physical-witness evidence. Lane B selected the separate servicing/maintenance hazardous-energy-control boundary and used new files only. Immediately after the substantive write, main showed `83e3216b...` directly above the prior primary state; no overlapping-file change occurred. Shared `PROGRESS.md` was intentionally not rewritten.

## Frozen result

`LINUXCNC STOPPED != SAFETY OUTPUT SAFE != ENERGY-ISOLATING DEVICE OPEN/SAFE != LOCKOUT APPLIED != STORED/RESIDUAL ENERGY CONTROLLED != REACCUMULATION PREVENTED != ISOLATION VERIFIED != PERSON MAY SERVICE`.

`SERVICE COMPLETE != MACHINE INTACT/CLEAR != PERSONNEL CLEAR != LOCKOUT REMOVED != ENERGY RESTORED != SAFETY SYSTEM REARMED != FRESH ORDINARY START AUTHORITY`.

OSHA 29 CFR 1910.147 and Appendix A provide SOURCE-CONFIRMED separation of orderly shutdown, physical isolation, lockout/tagout, stored/residual-energy control, verification, and deliberate restoration. An OSHA interpretation further confirms that a locked control/starter switch is generally not equivalent to isolating load/transmission energy.

## OpenPressBrake UNKNOWN

Exact isolation points, accumulator state, hydraulic bleed/isolation architecture, ram restraint/blocking method, pressure thresholds, valve truth tables, reaccumulation behavior, service position and return-to-service functional-test sequence remain UNKNOWN.

## Compute

No executable verification was justified. No runner compute was consumed.

## Precise next work

Find a professional hydraulic press/press-brake OEM service or commissioning procedure exposing `normal shutdown -> electrical/hydraulic/mechanical isolation -> stored-energy bleed/restraint -> isolation verification -> service -> personnel/physical clear -> removal of isolation -> energy restoration -> safety functional check/rearm -> separate fresh production START`, preferably including gravity load plus trapped/reaccumulating hydraulic energy.