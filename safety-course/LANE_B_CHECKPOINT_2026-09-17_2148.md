# Safety Curriculum Lane B Checkpoint — 2026-09-17 21:48 CDT

## Completed durable work

- Added `STO_CONTACTOR_DC_BUS_STORED_ENERGY_BOUNDARY_STUDY_2026-09-17.md` in commit `ecdbf4d3`.
- Primary lane at selection was `18ea6919`, following `6068c577` HAWE monitored hydraulic commissioning work.
- Lane B intentionally used different files and a different evidence package: drive STO, upstream contactors, DC-bus stored energy, service isolation, and regeneration/backfeed boundaries.
- No executable verification was justified; no runner compute was consumed.

## Freeze to carry forward

`STO ACTIVE != DRIVE MAINS REMOVED != DC BUS DE-ENERGIZED != SERVICE ISOLATION PROVED`.

`CONTACTOR OPEN/EDM HEALTHY != DOWNSTREAM STORED ENERGY ABSENT`.

Ordinary LinuxCNC/HAL/FPGA state must not be promoted into `SAFE TO SERVICE` authority.

## Evidence status

- SOURCE-CONFIRMED / DOC-CONFIRMED: cited Rockwell and Schneider manufacturer material in the study.
- INFERENCE: OpenPressBrake should expose separate motion-safety, operational-power, and maintenance/service-isolation concepts.
- TEST-CONFIRMED: none.
- COMMUNITY-REPORTED: none relied upon.
- UNKNOWN: actual OpenPressBrake drive/disconnect/common-bus topology, discharge path/time/threshold, measurement points, external supplies, regeneration behavior, and machine-specific service procedure.

## Precise next independent work

If the primary lane remains on hydraulic/fall-protection work, trace one professional drive/common-DC-bus implementation end-to-end:

`upstream disconnect/contactors -> DC link/discharge path -> STO -> external control power -> possible motor regeneration/backfeed -> manufacturer measurement points -> maintenance isolation -> return to service`.

Produce a source-to-physical-energy map that explicitly distinguishes motion inhibition from electrical service isolation.

If primary work reaches that same evidence package first, do not duplicate it. Rotate to either:

1. safety-output/contactor coil backfeed plus separate-supply common-cause fault injection; or
2. gravity-axis brake-release sequencing, keeping STO/torque removal separate from brake/load retention.

Before the next write, re-read current `main` and switch branches if overlapping files/evidence have advanced.
