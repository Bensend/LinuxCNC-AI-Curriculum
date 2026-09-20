# Next safety-course checkpoint — controlled-energy diagnostics vs isolation

Date: 2026-09-20

## Current state

1000/2000/3000 remain GRADUATED/CLOSED. 4000 safety course remains primary.

The press-brake post-replacement holding/counterbalance-valve static-retention evidence path is branch-locally source-limited after another bounded search. Reopen it only for genuinely new OEM/manifold evidence that states post-replacement acceptance behavior.

New durable study: `safety-course/MAINTENANCE_ENERGY_ISOLATION_VS_CONTROL_SAFETY_AUTHORITY_TRACE_2026-09-20.md`.

Key freeze:

`NORMAL STOP COMMAND != SAFETY-RELATED STOP != HAZARDOUS-ENERGY ISOLATION`.

`LOCK/TAG APPLIED != STORED ENERGY RENDERED SAFE != ISOLATION VERIFIED`.

`ISOLATION VERIFIED != SAFEGUARDS RESTORED/REVALIDATED != PERSONNEL CLEAR != SAFETY REARM != FRESH PRODUCTION START`.

## Exact next evidence target

Trace professional/OEM examples of diagnostic, commissioning, setup, or verification tasks where hazardous energy must intentionally remain available for a measurement or functional test. For each example, capture:

1. why full isolation would defeat the required test;
2. which energy/hazard remains present;
3. which personnel exposure is possible;
4. documented compensating measures (restricted mode, enabling/hold-to-run device, reduced speed/force, safeguarded space/exclusion, physical restraint, purpose-designed test point, remote observation, etc.);
5. how unexpected motion/energy release is prevented or bounded;
6. how the machine transitions back to fully isolated maintenance or normal production;
7. what evidence is required before ordinary production authority returns.

Prefer authoritative manufacturer safety manuals, complete machine manuals, OSHA/NIOSH guidance, and inspectable industrial implementations. Preserve machine-specific differences; do not generalize a robot teach-mode pattern into a press brake without evidence.

## OpenPressBrake boundary

Do not invent a generic `maintenance mode` that bypasses independent safety. If a future energized diagnostic mode is justified, it must arise from a concrete task/hazard analysis and professional evidence. LinuxCNC/normal FPGA may request/display/log diagnostics but must not become personnel-safety authority merely for convenience.

## Compute

No compute is justified yet. Do not use GitHub-hosted runners. If a later concrete test question genuinely requires runtime, use only `[self-hosted, openpressbrake]` and record authoritative runtime in `LAB_COMPUTE_LOG.md`.
