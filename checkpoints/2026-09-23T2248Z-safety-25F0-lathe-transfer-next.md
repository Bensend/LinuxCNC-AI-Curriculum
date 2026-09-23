# Safety curriculum checkpoint — 25F0 lathe transfer next

UTC checkpoint: 2026-09-23T22:48Z

## Durable state

- 25F0 mill/VMC baseline is now durable in `research/25F0_MILL_VMC_CAPSTONE_BASELINE_2026-09-23.md`.
- It contains the lifecycle boundary, energy inventory, SRS skeleton, authority allocation, human-factors/defeat pass, validation skeleton and UNKNOWN register.
- Authoritative anchors include OSHA guarding/LOTO guidance, current Haas mill safety material, and Siemens machine-drive safety-function documentation.
- Key new freezes: `SPINDLE COMMAND OFF != PHYSICAL STANDSTILL PROVED` and `PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION`.
- No executable compute was justified; no GitHub-hosted compute was used.

## Exact next work

1. Build a lathe/turning-center delta from the mill baseline rather than duplicating generic material.
2. Trace chuck/workholding release and retention, spindle/workpiece ejection, turret motion, tailstock/subspindle where applicable, and bar-stock/bar-feeder hazards from authoritative sources.
3. State explicitly which mill SRS clauses transfer, which change, and which new clauses are required.
4. Preserve enclosure containment as a physical proposition distinct from door-interlock state.
5. Preserve setup/jog/clearing human-factor incentives and make the correct recovery path easier than defeating safeguards.
6. Keep chuck pressure/force thresholds, spindle stopping time, bar-stock limits, PL/SIL targets and proof-test intervals UNKNOWN unless the chosen evidence supports them.
7. Then transfer the same contract to robot/cell before press-brake depth.
8. Compute remains question-driven and self-hosted-only `[self-hosted, openpressbrake]`.
