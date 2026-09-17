# Hydraulic press physical-proof matrix

Companion to `PROFESSIONAL_HYDRAULIC_PRESS_LOAD_HOLDING_ENERGY_OBJECTIVES_TRACE_2026-09-17.md`.

## Rule

A safety claim is only as strong as the physical state actually observed. Do not promote command or diagnostic evidence beyond its documented boundary.

| Observation | Can support | Cannot prove by itself |
|---|---|---|
| LinuxCNC/HAL valve command = 0 | ordinary controller requested zero | coil de-energized; spool safe; pressure absent; load held |
| FPGA watchdog tripped | ordinary FPGA output authority removed | external driver de-energized; valve moved; hydraulic hazard safe |
| Driver current = 0 | coil current absent at observed channel | spool position; alternate hydraulic path; load restraint |
| Safety relay/PLC output OFF | safety logic commanded its final output OFF | contactor/valve physical state unless feedback is separately validated |
| Valve position feedback | monitored valve reached documented position | pressure in every volume; gravity load retained; mechanical restraint installed |
| Pressure gauge/transducer = 0 | pressure is low at that valid sensing point | pressure elsewhere; sensing path connected; load mechanically restrained |
| Pressure remains | pressure exists at witness point | automatically unsafe; retained pressure may be intentional load holding |
| Cylinder position stationary | no detected motion during observation interval | future motion impossible; hydraulic energy absent; load-holding path healthy |
| Mechanical block visibly engaged | restraint appears installed | rating/applicability; correct load transfer; all other hazards isolated |
| EDM/aux contact correct | monitored final element feedback agrees with expected state | all hazardous energy absent; hydraulic load physically retained |

## Required vertical-axis proof chain

For each credited safety function, map:

**protective demand → independent safety logic → electrical final element → hydraulic final element → relevant pressure/flow state → load state → restart/rearm behavior**

Where maintenance requires personnel beneath/in the gravity hazard, add:

**load transfer → mechanical restraint engagement → physical verification → controlled removal/restoration sequence**

## Fault challenges to include when applicable

- commanded-OFF valve with simulated/stuck feedback disagreement;
- one failed electrical output channel;
- one failed hydraulic shutoff/holding path;
- pressure witness disconnected or isolated from the trapped volume;
- loss of pump power while load remains elevated;
- hose/path failure on the source side and actuator side of the credited holding element;
- safety reset while ordinary motion command remains stale/asserted;
- restoration of pressure/power without a fresh deliberate START;
- removal of maintenance restraint before verified transfer to the intended holding mechanism.

Exact challenge methods must follow the installed machine/manufacturer design. Do not improvise destructive or personnel-exposing fault injection.

## Human-factors acceptance

The correct proof path should be the easiest normal path. Test points, pressure witnesses, restraint access and reset controls should not require entering the danger zone merely to learn whether the machine is safe to enter. If a required block, gauge point, bleed point or test point is sufficiently awkward that maintainers predictably bypass it, redesign the access/verification method rather than normalizing the bypass.

## OpenPressBrake status

This matrix is a curriculum/design-review tool, not proof that the current OpenPressBrake machine satisfies any row. Installed hydraulic schematic, component identity, plumbing, safety logic, final-element feedback, pressure-witness locations and physical challenge evidence are still required before changing `UNKNOWN` to a stronger evidence class.
