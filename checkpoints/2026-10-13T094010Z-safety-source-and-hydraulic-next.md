# 2500/4400 safety continuation checkpoint — 2026-10-13 09:40 UTC

Active priority: LinuxCNC/OpenPressBrake safety course and 4000-series safety/design. 1000/2000/3000 remain graduated/closed; F02 graduated. External/fresh safety evaluations remain sealed.

SOURCE-CONFIRMED: LinuxCNC master 2655e62f and v2.9.10 pass the M51 spindle selector through canonical/NML, but task dispatch passes only mode to a shared motion spindle-override-enable mask; all spindle status override-enabled flags use that mask. Trajectory segments retain queued mask snapshots. The previously traced inhibit bitwise expression depends on SS_ENABLED. Upstream commit e6cc88d3 (August 2026) acknowledges the global enable bit and restores modal override after aborted threading; G33 disables/restores, G76 locks/restores, G33.1 differs. No physical behavior is proven.

DOC-CONFIRMED: historical Fiessler AKFR 2010 Rexroth-interface PDF mentions valve-position and pressure-sensor inputs; AKFH 2021 Hörbiger document mentions valve position, not the same pressure path. Product-specific input and combined-system claims do not prove machine stopping, load holding or isolation. All selected-machine hydraulic truth tables, stopping times and safety integrity remain UNKNOWN.

Prepared local source audit, upstream review note, learner exercise, AKFR source note and physical-witness worksheet for authorized integration. GitHub connector rejected a research file creation and hosted-runner workflow update through safety checks; no bypass. Previous cumulative publication backlog remains pending. No lab compute or GitHub-hosted minutes consumed. Do not dispatch workflows still targeting hosted runners. TIMING_APPEND_REQUEST.txt retains older pending row; do not overwrite.

Next: authorized integration of prepared patch/backlog; reconcile upstream M51 per-spindle documentation with global implementation and the G33/G76 abort restore; correct all hosted-runner workflows to [self-hosted, openpressbrake] before any bounded runtime; selected-machine independent stop/hold/isolation witness and service/rearm qualification. Generic safety schematics NOT FROZEN.
