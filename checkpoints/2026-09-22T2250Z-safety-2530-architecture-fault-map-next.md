# 4000 Safety Curriculum Checkpoint — 2530 E-stop architecture/fault map

UTC checkpoint: 2026-09-22T22:50Z

## Durable work completed

- Recorded session start in UTC before substantive source work.
- Re-read repository governance/current state and preserved 1000/2000/3000 closure and the open 2520 information-separated competency gate.
- Compared three current professional E-stop/safety-relay architecture families: Rockwell Guardmaster, Siemens SIRIUS 3SK1, and Pilz PNOZ.
- Added `safety-course/2530_ESTOP_ARCHITECTURE_COMPARISON_AND_FAULT_MAP_2026-09-22.md` with reverse mapping from input diagnostics, monitored reset/start, feedback/EDM, output/final-element structure and periodic/cyclic checks to explicit fault hypotheses and physical propositions.
- Added the fault-driven learner exercise only after the comparison: proposition -> single-channel attack -> justified improvements -> common-cause attack -> reset/restart attack -> physical-proof attack. No generic PL/SIL is inferred from topology.
- Source-traced LinuxCNC `src/hal/components/estop_latch.comp` at upstream commit `514be4f657b2f1c432ebaaebd117ef112e3e7565` in `safety-course/2530_LINUXCNC_ESTOP_LATCH_BOUNDARY_TRACE_2026-09-22.md`.
- Froze the boundary that LinuxCNC's software latch/reset/watchdog can coordinate ordinary control and diagnostics but does not itself prove personnel-safety integrity or a physical safe state.
- Updated `PROGRESS.md`.

No executable compute was justified. No GitHub-hosted runner was used.

## Exact next work

1. Keep the 2520 information-separated competency gate open and uncontaminated.
2. Research emergency-stop span/segmentation across linked machines/cells and reset-location/zone-visibility human factors from authoritative sources.
3. Build a 2530 adversarial assessment around stop-strategy selection, fault diagnostics, final-element proof, reset/restart and common cause without inventing stopping time/distance or machine physics.
4. Add E-stop-specific commissioning/validation checks only where they add new coverage beyond the existing 2520 validation matrix.
5. Preserve stop category, PL/SIL, DC, stopping distance/time, gravity/fluid-power response and final-element adequacy as `UNKNOWN` unless the scenario supplies defensible evidence.
