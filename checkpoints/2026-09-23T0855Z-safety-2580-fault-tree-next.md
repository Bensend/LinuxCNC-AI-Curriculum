# Safety curriculum checkpoint — 2580 fluid-power fault tree next

## Durable state

- 1000/2000/3000 remain GRADUATED/CLOSED; 4000 safety remains primary.
- 2520–2570 external information-separated competency gates remain OPEN and uncontaminated.
- 2570 passed its syllabus coverage audit and is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.
- 2580 is active with manufacturer-grounded source preparation for hydraulic area shutoff, press-control integration, load holding and hose-failure protection.

## Exact next work

1. Build a generic hydraulic press/vertical-axis fault tree from `hazardous closing/descent prevented` backward to physical final elements.
2. Separate four functions that are often conflated: directional neutral/blocking, supply isolation, dump/decompression, and load holding.
3. Add failure branches for stuck spool, internal leakage/drift, accumulator/trapped volume, hose/fitting failure, cylinder/seal failure, sensor/monitor disagreement and common hydraulic paths.
4. For every diagnostic witness, state the exact proposition it proves and the residual physical proposition it does not prove.
5. Add a pneumatic safe-exhaust/repressurization analogue and maintenance mechanical-restraint boundary.
6. Use press-brake examples only generically; do not invent OpenPressBrake-specific valve truth tables, pressures, timing, synchronization or achieved PL/SIL.

## Compute

No executable compute is justified by the current questions. Do not consume GitHub-hosted Actions minutes. Any later justified compute must target only `[self-hosted, openpressbrake]`.