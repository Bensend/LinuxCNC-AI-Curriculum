# Session checkpoint — asymmetric power restoration / retained state

Date: 2026-09-17
Session start UTC: 2026-09-17T20:35:47Z
Session end UTC: 2026-09-17T20:37:16Z
Actual elapsed: 1.5 minutes
Active level: 4000
Priority: safety course / professional machine implementation

## Governance/current-state reconciliation

Read `START_HERE.md` first and rechecked authoritative level/work-selection state. Current main also contained newer Lane-B checkpoint `8891afc2`, whose precise next independent task was the asymmetric power-restoration matrix. This branch is distinct from the primary hydraulic monitored-valve/fall-protection trace and therefore has useful information gain without duplicating it.

1000/2000/3000 closure remains preserved. No 3300 regression occurred.

## Durable work

Created `safety-course/SAFETY_ASYMMETRIC_POWER_RESTORATION_RETAINED_STATE_MATRIX_2026-09-17.md` in commit `0397a58a`.

The matrix challenges independent and paired restart boundaries across independent safety controller/safety I/O, LinuxCNC host, FPGA/field I/O, drive control and main power, field 24-V power, communications, and persistent hydraulic/gravity energy.

It separates safety authority, ordinary command state, FPGA physical output state, drive restart state, physical energy state and diagnostic freshness. It freezes the rule that a value surviving a restart boundary is not automatically fresh evidence or a newly intended command.

Manufacturer evidence used includes Rockwell PowerFlex 750/755 integrated safety, GuardLogix DCST cold-start behavior, Safe Brake Control cold-start/reset behavior and PowerFlex 755T separate main/control-power sequencing. Product-specific automatic/manual restart behavior was not generalized to OpenPressBrake.

Actual OpenPressBrake retained-state/startup behavior remains `UNKNOWN` pending selected hardware/configuration and installed-machine testing.

## Compute

No simulation, synthesis, benchmark or test suite was justified. No GitHub-hosted Actions minutes and no self-hosted compute were used.

## Overlap

No known file overlap. Lane-B restart work was selected while the primary hydraulic monitored-valve/fall-protection branch remained distinct.

## Precise next work

Primary lane remains the professional monitored hydraulic safety-valve/fall-protection trace. Independent restart lane should next build a restart-boundary commissioning challenge card mapping the asymmetric matrix into a bounded physical commissioning procedure, after re-reading current main to avoid collision with parallel work. High-value cases: maintained command across one-layer reset, reset held during restoration, communications loss during restoration, and electronics reboot with stored hydraulic/gravity energy still present.

Do not invent OpenPressBrake drive/hydraulic behavior; classify unproven behavior UNKNOWN and perform initial uncertain restart tests isolated/remote with personnel outside the danger zone.

## Lesson log safe-append status

`LESSON_LOG.md` was intentionally not replaced because only a bounded/truncated fetch was available and no repository append primitive was exposed by the connector. The exact row is preserved here for the repository safe-append mechanism:

`2026-09-17 | 4000 Safety | Asymmetric power-restoration / retained-state matrix | 2026-09-17T20:35:47Z | 2026-09-17T20:37:16Z | 1.5 | durable matrix committed | restart-boundary commissioning challenge card after current-main collision check | No known overlap; Lane-B restart branch distinct from primary hydraulic branch; commit 0397a58a; no compute`
