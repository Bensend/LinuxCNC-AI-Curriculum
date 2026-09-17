# Safety curriculum Lane B checkpoint — HAWE hydraulic final-element trace

Date: 2026-09-17

## Parallel-work check

Before selection, current main and recent commits were re-read. Primary lane newest durable checkpoint was `f0634793`, covering Husky ISVGC protective demands through K1/K2 and delayed STO plus the compact commissioning card. Its precise next branch requested a professional hydraulic vertical-axis/press implementation exposing hydraulic blocking/dump/holding final elements.

Lane B selected a different file/evidence package: current HAWE SAKB press-brake hydraulic documentation. It does not modify the Husky or commissioning-card artifacts.

Immediately before durable write, current main still ended at `f0634793`; no intervening overlapping file appeared. After the artifact write, `2ead75ae` was directly above `f0634793`.

## Durable work

- `2ead75ae` — `safety-course/PROFESSIONAL_PRESS_BRAKE_HYDRAULIC_FINAL_ELEMENT_TRACE_HAWE_SAKB_2026-09-17.md`

## Evidence gain

HAWE D 6335 (08-2025 / 1.1) exposes the physical hydraulic layer of a certified CNC press-brake control package:

- two proportional cylinder-control valves;
- two pilot-controlled seated valves explicitly described as holding the cylinders up;
- two counterbalance valves;
- a 4/2 spool valve;
- two separately mounted cylinder-base anti-cavitation valves;
- monitored S-version feedback on the two proportional valves, two holding valves and 4/2 valve;
- a phase-dependent sequence diagram including rapid down, operation, holding, decompression and rapid return.

Frozen distinction: `PUMP OFF != RAM RESTRAINED`; `VALVE COMMANDED CLOSED != VALVE POSITION CONFIRMED != LOAD HELD`; and `PRESSURE REMOVED != FLOW BLOCKED != LOAD HELD != MECHANICALLY RESTRAINED`.

The source does **not** expose the complete protective-device/E-stop -> safety logic -> hydraulic-final-element chain. That missing layer remains UNKNOWN rather than being inferred. HAWE certification/test-certificate references are bounded to the documented SAKB application and are not transferred to OpenPressBrake.

## Compute

None. Manufacturer documentation answered the question. No GitHub-hosted Actions minutes and no self-hosted runner compute were consumed.

## Precise next work

Find a professional hydraulic press/vertical-axis implementation exposing the missing upstream chain: protective device or E-stop -> safety logic -> monitored hydraulic blocking/dump/holding final elements -> physical load result -> reset/restart. Prefer a complete OEM wiring + hydraulic drawing or certified application manual. If the primary lane reaches that evidence package first, switch to an independent hydraulic safety-validation task such as feedback common-cause challenge, residual-energy/reaccumulation verification, or physical-restraint boundary rather than duplicating it. Keep all OpenPressBrake valve truth tables, pressure thresholds, stopping values and physical performance UNKNOWN until installed evidence exists.