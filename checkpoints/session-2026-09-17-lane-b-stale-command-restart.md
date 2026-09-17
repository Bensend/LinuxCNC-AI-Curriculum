# Session checkpoint — Lane B stale-command reset/rearm/restart boundary

Date: 2026-09-17
Compute: none. No GitHub-hosted runner and no self-hosted runner used.

## Parallel-work check

At selection time, newest primary durable work was `3e477bd8` / hydraulic load-holding safety trace, backed by HAWE/Rexroth hydraulic objective and physical-proof artifacts. Lane B deliberately selected a different file/evidence package: ordinary-command persistence across protective stop/reset/rearm/restart.

Immediately before durable checkpointing, `main` was re-read. Lane-B artifact commit `34854045` sat directly above primary checkpoint `3e477bd8`; no intervening overlapping primary work appeared.

## Durable work

Added `safety-course/STALE_COMMAND_RESET_REARM_RESTART_FAILURE_PATH_STUDY_2026-09-17.md`.

Manufacturer evidence from SICK and Pilz freezes the separation between protective-demand clearance, reset, restart interlock, and a separate intentional machine-start command. The study extends that boundary into OpenPressBrake architecture as an explicitly labeled INFERENCE: a safety demand should invalidate hazardous ordinary-command freshness so removal of STO/restoration of safety authority cannot simply replay an old LinuxCNC/HAL/FPGA/drive/valve request.

All installed-machine timing, stopping, pressure, hydraulic truth-table, drive restart and retained-state behavior remains UNKNOWN until applicable documentation or machine testing establishes it.

## Exact next independent work

Trace one complete professional drive/machine implementation that exposes all of: safety demand, STO/safety-output restoration, ordinary run/velocity command state, reset, and subsequent start. Prefer a manufacturer timing diagram or application schematic that proves whether a pre-existing ordinary command must transition/reissue after STO or protective-stop recovery.

If the primary lane enters that package first, rotate to an independent restart/common-cause task: asymmetric controller power restoration and retained-state validation across safety controller, LinuxCNC host, FPGA/field I/O and drive layers. Do not invent machine-specific behavior.
