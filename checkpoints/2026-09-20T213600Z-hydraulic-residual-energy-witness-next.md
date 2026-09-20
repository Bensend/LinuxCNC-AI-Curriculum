# 4000 safety checkpoint — hydraulic residual-energy witness boundary

## Durable result

Added `safety-course/HYDRAULIC_SAFE_DECOMPRESSION_POSITION_MONITORING_AND_RESIDUAL_ENERGY_WITNESS_BOUNDARY_2026-09-20.md`.

Reconciled the newest Lane-B CytroForce-M acceptance boundary before continuing. New Bosch Rexroth evidence distinguishes two-channel position-monitored hydraulic blocking (STO) from a separate Safe Decompression function using dual bypass valves to drain downstream pressure. HAWE independently identifies switching-position monitoring as observation of the valve switching element and reliable beam holding as a press-brake safety concern.

Freeze:
- VALVE SAFE POSITION CONFIRMED != DOWNSTREAM PRESSURE/ENERGY REMOVED.
- DECOMPRESSION COMMANDED != DECOMPRESSION PATH OPEN != DOWNSTREAM PRESSURE ACCEPTABLY REDUCED.
- LOAD HELD != HAZARDOUS PRESSURE REMOVED.
- PRESSURE REMOVED != LOAD PHYSICALLY RETAINED.
- MANUFACTURER TYPICAL/PERFORMANCE STATEMENT != MACHINE-SPECIFIC ACCEPTANCE LIMIT.

No OpenPressBrake pressure threshold, decompression time, measurement point, load condition, allowable motion, PL/SIL, diagnostic coverage, or proof interval was inferred.

## Source-availability disposition

Generic hydraulic component/manifold documentation is now near an information-gain stop. A complete authoritative chain combining protective demand, monitored hydraulic final-element state, pressure/motion/holding witness, quantitative machine criterion, mismatch/fault disposition, repair/replacement retest and production release was not found in this pass.

## Exact next work

First seek a machine/OEM acceptance or maintenance procedure—not another generic valve catalog—that exposes the missing physical chain. High-value candidates are hydraulic presses/press brakes and servo-hydraulic gravity axes. If that remains unavailable, mark this hydraulic sub-branch source-limited and rotate to another open 4000 safety module, preserving the witness ladder rather than inventing a hydraulic truth table.

Beckwood public material found during this pass provides a useful secondary lead: it says press safety devices/E-stop circuits should be checked before operation and that commissioning baseline operating pressures should be recorded for later comparison, but it does not by itself close the required safety acceptance chain.

No executable verification was justified. No GitHub-hosted runner was used. `PROGRESS.md` was not overwritten in this parallel-active repository state; this checkpoint is the durable reconciliation record for the next safe progress update.
