# Safety curriculum checkpoint — 25D0 syllabus audit next

## Durable state

- 25D0 remains active.
- `research/25D0_VFD_STO_AND_FLUID_POWER_COMPARISON_2026-09-23.md` now completes the requested ordinary-VFD/external-switching versus integrated-STO comparison.
- Authoritative ABB and Rockwell documentation re-establishes that STO prevents drive-generated torque under its assumptions but does not establish electrical isolation, standstill, discharged stored energy, or control of gravity/back-driven motion.
- A distinct Tier-E fluid-power comparison is retained because omitting it would create a material transfer gap. It separates supply isolation, dump/decompression, and load holding/restraint without inventing valve truth tables, pressures, response times, PL/SIL, or diagnostic coverage.
- Parker manufacturer material supports the distinction between load holding/hose-failure control and other press-control functions.
- Like-for-like current transaction pricing remains insufficiently established; cost remains expressed as named proposition/failure path bought rather than fabricated dollars.
- No executable compute is justified. No GitHub-hosted runner is to be used.

## Exact next work

1. Audit 25D0 line-by-line against the current safety-course syllabus and competency requirements.
2. Fill only a genuine learner-facing gap. Do not add redundant architecture variants merely to make the module longer.
3. If coverage is coherent, create the canonical 25D0 learner route/release gate and a separate no-solution information-separated evaluator handoff; mark 25D0 READY FOR EXTERNAL/FRESH EVALUATION rather than self-graduating it.
4. Preserve the freezes: STO != standstill; STO != electrical isolation; contactor-open != DC-bus discharged; supply isolation != decompression; dump command != safe pressure proof; directional neutral != load holding; LinuxCNC/ordinary FPGA != personnel-safety authority.
5. Preserve 2520-25C0 external evaluation gates without contamination.
6. Freeze executable compute only for a concrete unresolved implementation question that authoritative evidence cannot answer; target `[self-hosted, openpressbrake]` only.
