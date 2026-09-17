# Session checkpoint — Lane B drive STO restart-edge trace

Date: 2026-09-17
Lane: independent safety curriculum Lane B

## Parallel-work check

Before selection, current main was read through the latest primary checkpoint `58059ec8` (`press hydraulic schematic trace`). Primary work is advancing press hydraulic schematic/final-element proof and next targets monitored hydraulic safety valves/fall protection. Lane B therefore avoided those files and evidence packages and continued the independent stale-command/restart branch.

Immediately before durable work, current main still ended at `58059ec8`. After the Lane-B artifact commit, current main ended at `d93c6130` with no intervening overlapping primary commit.

## Durable work

Added `safety-course/DRIVE_STO_RESTART_COMMAND_EDGE_EVIDENCE_TRACE_2026-09-17.md` in commit `d93c6130`.

The trace joins three manufacturer evidence sets without transferring their product-specific behavior into OpenPressBrake:

- Siemens SINAMICS S120: after STO deselection, documented restart requires drive enables plus `ON/OFF1` transitions that cancel `switching on inhibited` and then switch the drive on.
- Schneider Electric safe motion: removing STO/SS1 demand leaves a restart inhibit until a safety-related Reset rising edge; separate documentation requires prevention of unintended restart and keeps STO distinct from coast/external-force behavior.
- Rockwell Automation: drive start-inhibit status separately represents STO and `Safety Reset Required`.

## Frozen learning

`STO DEMAND REMOVED` != `RESTART PERMISSION` != `DRIVE ENABLED` != `NEW ORDINARY START COMMAND` != `MOTION`.

Manufacturer implementations can require reset, enable sequencing and/or a fresh command edge after STO. Therefore OpenPressBrake must not assume either extreme: neither that every drive automatically replays a maintained command nor that every drive automatically rejects it. Exact behavior is configuration-specific and remains `UNKNOWN` until the selected drive/application is documented or tested.

Candidate defense-in-depth architecture remains: independent safety authority performs the personnel-safety function, while ordinary LinuxCNC/FPGA control separately invalidates hazardous command freshness across a safety-authority boundary and requires deliberate post-boundary rearm/new command. This is `INFERENCE`, not a claim about current hardware.

## Compute

No simulation, synthesis, benchmark or executable test was needed. No GitHub-hosted runner was used and no self-hosted compute was consumed.

## Precise next independent work

Build `SAFETY_ASYMMETRIC_POWER_RESTORATION_RETAINED_STATE_MATRIX.md` across safety controller, LinuxCNC host, FPGA/field I/O and drive layers. Challenge one-layer and two-layer reset/power-loss combinations; identify surviving command state, stale evidence, unavailable authority, startup defaults, required reset/rearm/new-command actions and proof needed before hazardous output can return. Keep actual OpenPressBrake retained-state behavior `UNKNOWN` until documentation or installed-machine testing proves it. Before starting, re-read current main and rotate if the primary lane has entered this branch.