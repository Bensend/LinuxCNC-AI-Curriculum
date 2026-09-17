# Session checkpoint — asymmetric power restoration / retained state

Date: 2026-09-17
Session start UTC: 2026-09-17T20:35:47Z
Active level: 4000
Priority: safety course / professional machine implementation

## Governance/current-state reconciliation

Read `START_HERE.md` first and rechecked authoritative level/work-selection state. Current main also contained newer Lane-B checkpoint `8891afc2`, whose precise next independent task was the asymmetric power-restoration matrix. This branch is distinct from the primary hydraulic monitored-valve/fall-protection trace and therefore has useful information gain without duplicating it.

1000/2000/3000 closure remains preserved. No 3300 regression occurred.

## Durable work

Created `safety-course/SAFETY_ASYMMETRIC_POWER_RESTORATION_RETAINED_STATE_MATRIX_2026-09-17.md` in commit `0397a58a`.

The matrix challenges independent and paired restart boundaries across:
- independent safety controller / safety I/O,
- LinuxCNC host,
- FPGA/field I/O,
- drive control and main power,
- field 24-V power,
- communications,
- persistent hydraulic/gravity energy.

It separates safety authority, ordinary command state, FPGA physical output state, drive restart state, physical energy state and diagnostic freshness. It also freezes the rule that a value surviving a restart boundary is not automatically fresh evidence or a newly intended command.

Manufacturer evidence used includes Rockwell PowerFlex 750/755 integrated safety, GuardLogix DCST cold-start behavior, Safe Brake Control cold-start/reset behavior and PowerFlex 755T separate main/control-power sequencing. Product-specific automatic/manual restart behavior was not generalized to OpenPressBrake.

Actual OpenPressBrake retained-state/startup behavior remains `UNKNOWN` pending selected hardware/configuration and installed-machine testing.

## Compute

No simulation, synthesis, benchmark or test suite was justified. No GitHub-hosted Actions minutes and no self-hosted compute were used.

## Precise next work

Primary lane remains the professional monitored hydraulic safety-valve/fall-protection trace. Independent restart lane should next build a **restart-boundary commissioning challenge card** mapping the asymmetric matrix into a bounded physical commissioning procedure, but only after re-reading current main to avoid collision with parallel work. High-value cases: maintained command across one-layer reset, reset held during restoration, communications loss during restoration, and electronics reboot with stored hydraulic/gravity energy still present.

Do not invent OpenPressBrake drive/hydraulic behavior; classify unproven behavior UNKNOWN and perform initial uncertain restart tests isolated/remote with personnel outside the danger zone.

## Lesson log append payload

Use repository safe append mechanism immediately before session close; do not replace a truncated log. Row to append with actual end time/elapsed once known:

`2026-09-17 | 4000 Safety | Asymmetric power-restoration / retained-state matrix | start 2026-09-17T20:35:47Z | end <UTC_END> | elapsed <MINUTES> | overlap: no known file overlap; Lane-B restart branch selected while primary hydraulic branch remained distinct | commit 0397a58a | no compute`
