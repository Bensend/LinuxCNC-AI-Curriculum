# Safety curriculum checkpoint — 25F0 press-brake architecture next

UTC checkpoint: 2026-09-24T00:55Z

## Durable state

- Robot/automated-cell transfer is durable in `research/25F0_ROBOT_AUTOMATED_CELL_DELTA_2026-09-24.md`.
- It now includes whole-body occupancy, perimeter guarding, reset visibility, three-position enabling/manual-mode reasoning, restart/power restoration, independent peripheral energy paths, cell-level authority allocation, a transferred/modified/new SRS matrix, fault prompts, human factors and validation skeleton.
- New robot/cell freezes include `PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY`, `SAFETY RESET COMPLETE != CELL OCCUPANCY CLEARED`, `ROBOT STOPPED != CELL SAFE STATE PROVED`, `ROBOT CONTROLLER SAFE STATE != PERIPHERAL MACHINE SAFE STATE`, and `SOFTWARE JOG LIMIT != SAFE MANUAL OPERATION PROVED`.
- Press-brake capstone is opened in `research/25F0_PRESS_BRAKE_CAPSTONE_BOUNDARY_2026-09-24.md` with hazard/energy boundary, first SRS skeleton, authority boundary, validation questions and UNKNOWN register.
- OSHA evidence anchors point-of-operation exposure, accidental cycling, workpiece motion/whip, safeguarding options and production-vs-maintenance hazardous-energy distinction. Lazer Safe Sentinel is retained only as product-specific evidence that stopping-time/light-curtain parameters can be safety-critical; it is not generalized into a universal press-brake truth table.
- No executable compute was justified; no GitHub-hosted compute was used.

## Exact next work

1. Find and inspect at least two professional hydraulic press-brake safety implementations with enough detail to trace protective device/E-stop through safety logic to physical final elements and feedback.
2. Prefer OEM/manufacturer manuals/schematics and current safety-device documentation; preserve provenance and product/version context.
3. Separate controlled stopping, hydraulic supply isolation, dump/decompression, gravity/load holding and maintenance restraint. Do not collapse these into one `safe` bit.
4. Trace what each feedback signal actually proves; retain `FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED`.
5. Compare architectures before extracting reusable low-cost patterns.
6. Only then build the press-brake fault matrix for stuck valves, false feedback, broken channels, common supplies, power restoration, gravity and stored pressure.
7. Keep hydraulic truth tables, valve fail states, stop times/distances, pressure thresholds, integrity targets and proof-test intervals `UNKNOWN` absent machine/product evidence.
8. Compute remains question-driven and self-hosted-only `[self-hosted, openpressbrake]`.
