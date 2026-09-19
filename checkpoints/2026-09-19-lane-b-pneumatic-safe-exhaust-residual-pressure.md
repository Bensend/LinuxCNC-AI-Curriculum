# Lane B checkpoint — pneumatic safe exhaust / residual pressure

Date: 2026-09-19

## Completed

Created `safety-course/PNEUMATIC_SAFE_EXHAUST_RESIDUAL_PRESSURE_RESTART_BOUNDARY_STUDY_2026-09-19.md`.

Primary lane remained on hydraulic holding-valve component proof, installed drift witnessing, and press-brake post-service retention/revalidation. Lane B used a separate pneumatic evidence family and did not modify the primary lane's hydraulic artifacts or `PROGRESS.md`.

## Durable result

Preserve these boundaries:

- `SAFETY OUTPUT OFF != VALVE PHYSICALLY SHIFTED != DOWNSTREAM PRESSURE REMOVED != ACTUATOR/LOAD PHYSICALLY SAFE`.
- `DUAL VALVE COMMAND AGREEMENT != EXHAUST PATH CLEAR != DOWNSTREAM PRESSURE SAFE`.
- `SAFE EXHAUST COMPLETE != REPRESSURIZATION AUTHORIZED != SAFETY REARM != FRESH ORDINARY START`.

SMC evidence separates dual valve commands, valve-error diagnostics, downstream pressure sensing, and actual downstream pressure. Festo evidence separates safe de-energization from unexpected-restart prevention and identifies exhaust restriction/back pressure as a physical concern.

No OpenPressBrake pneumatic requirement or physical acceptance value was inferred.

## Compute

None justified or used. No GitHub-hosted runner used.

## Exact next independent work

Find a complete professional pneumatic safety commissioning/validation implementation that exposes:

`protective demand -> independent safety evaluator -> dual safe-exhaust final elements -> individual valve diagnostic -> downstream pressure witness -> deliberate one-valve failure or exhaust restriction -> fault/inhibit disposition -> physical actuator/load safe-state witness -> correction -> repressurization/soft-start -> safety rearm -> fresh ordinary start`.

Prefer an OEM procedure with an actual fault challenge or exhaust/pressure validation. Keep pressure, time, flow, and mechanical acceptance values source-specific. If the primary lane moves into this pneumatic package before the next Lane-B session, switch to another independent safety topic rather than extending the same files.