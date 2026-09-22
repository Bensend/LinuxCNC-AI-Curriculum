# 4000 Safety Curriculum Checkpoint — 2520 Gate / 2530 Source Preparation

UTC checkpoint: 2026-09-22T21:50Z

## Durable work completed

- Recorded session start before substantive work.
- Re-read repository governance/current state and preserved 1000/2000/3000 closure.
- Added `evaluation/2520_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` without a hidden solution. It defines a fresh-machine challenge contract, learner deliverables, scoring observations and critical-fail conditions while preserving evaluator/learner separation.
- Added `safety-course/SAFETY_COURSE_INDEX.md` as concise navigation rather than duplicating the broad research plan.
- During a navigation edit, detected that `SAFETY_COURSE_RESEARCH.md` had been accidentally truncated; immediately restored the exact prior full blob before continuing. No research-plan content was intentionally discarded.
- Treated the unavailable information-separated evaluator as branch-local rather than self-grading 2520.
- Began 2530 source preparation in `safety-course/2530_ESTOP_FIRST_PRINCIPLES_SOURCE_PREP_2026-09-22.md` using current manufacturer material around ISO 13850 / IEC 60204 concepts, reset/restart separation, stop categories and E-stop versus emergency switching-off.
- Updated `PROGRESS.md`.

No executable compute was justified. No GitHub-hosted runner was used.

## Exact next work

1. Keep the 2520 fresh competency gate open until a genuinely information-separated evaluator/oracle executes it.
2. Compare at least three current manufacturer E-stop/safety-relay application architectures. Reverse-map input diagnostics, reset behavior, EDM/final-element monitoring, output structure and final elements to explicit fault hypotheses and physical propositions.
3. Only after that comparison, create the incremental 2530 learner exercise from simple single-channel architecture through fault-driven improvements; do not infer PL/SIL from topology.
4. Trace LinuxCNC `estop_latch` and normal machine-control integration as a boundary/diagnostics lesson, not personnel-safety authority.
5. Preserve machine-specific stop category selection, stopping time/distance, physical load/energy behavior and integrity targets as `UNKNOWN` until supported.
