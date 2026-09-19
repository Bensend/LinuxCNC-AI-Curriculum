# Lane B checkpoint — pneumatic safe exhaust / stored pressure — 2026-09-18

## Completed

Created `safety-course/PNEUMATIC_SAFE_EXHAUST_STORED_PRESSURE_RESTART_AUTHORITY_STUDY_2026-09-18.md` at commit `fb6c0e182f56a69ecd8a00f109a27ea69744b6f2`.

This lane intentionally stayed independent of the primary lane's hydraulic press-brake monitored-valve disagreement, physical ram/load-safe disposition, and post-repair re-proof target. It also uses different module/evidence files from Lane B's preceding bounded safeguard-bypass work.

## Durable freeze

`PNEUMATIC SAFETY OUTPUT OFF != SUPPLY ISOLATED != SAFE-EXHAUST ELEMENTS IN EXPECTED STATE != DOWNSTREAM PRESSURE EXHAUSTED != TRAPPED/GRAVITY ENERGY CONTROLLED != PERSONNEL ACCESS SAFE`.

Restart remains separately gated:

`AIR SUPPLY AVAILABLE != SAFE-EXHAUST VALVE READY != DOWNSTREAM PRESSURE RESTORED != SAFETY REARMED != FRESH ORDINARY START/JOG/CYCLE AUTHORITY`.

## Evidence added

- ROSS DM2C: redundant valve elements, internal dynamic monitoring, asynchronous-fault latching, deliberate reset, and pressure/status feedback.
- ROSS M35/RSe: external monitoring architectures that keep individual valve-element position/pressure witnesses visible to the safety system.
- SMC VP/VG: main-valve position detection, input-versus-valve-operation inconsistency detection, redundant residual-pressure release, and explicit warning that the component alone does not establish whole-machine safety.
- Architecture decomposition keeps command, valve-element state, downstream pressure, trapped branches, gravity/mechanical energy, physical actuator state, fault latch, safety rearm, and ordinary LinuxCNC intent separate.

No OpenPressBrake pneumatic hazard, residual-pressure threshold, exhaust timing, valve topology, gravity behavior, PL/SIL/category/DC/CCF, proof interval, or reset sequence was invented.

No executable verification was justified; no GitHub-hosted or self-hosted compute was consumed.

## Parallel-work reconciliation

Immediately before the substantive commit, current main HEAD was `935b0fb193a3fad9765a9210ea5321a165eff1fd`, whose newest primary work remained the hydraulic press-brake valve-disagreement package. Immediately after the substantive write, current main HEAD was `fb6c0e182f56a69ecd8a00f109a27ea69744b6f2`; no intervening overlapping write appeared. Shared `PROGRESS.md` was deliberately not edited to avoid collision with the primary task.

## Precise next work

Find a complete OEM or professional machine implementation exposing:

`protective-device demand -> independent safety evaluator -> redundant pneumatic safe-exhaust elements -> individual element/pressure witness -> downstream physical pressure decay -> trapped-energy/gravity disposition -> disagreement/failure latch -> repair/replacement -> required functional re-proof -> deliberate safety reset/rearm -> separate fresh ordinary START`.

Prefer an implementation with both a pneumatic actuator hazard and a gravity/mechanical consequence, plus a documented stuck valve, failed pressure witness, blocked exhaust, trapped branch, or power-restoration case. Do not duplicate the primary hydraulic valve-disagreement/re-proof evidence package.