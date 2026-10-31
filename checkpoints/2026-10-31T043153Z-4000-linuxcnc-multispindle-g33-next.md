# 2026-10-31T04:31:53Z — LinuxCNC-first multi-spindle G33 checkpoint

**Artifacts:** [SPINDLE-22 source investigation](../research/4400_LINUXCNC_SPINDLE_22_MULTISPINDLE_ATSPEED_INDEX_HANDSHAKE_SOURCE_AUDIT_2026-10-31.md) and [practical diagnostic guide](../guides/4000-linuxcnc-multispindle-g33-index-atspeed-review-2026-10-31.md).

**New source-confirmed results:** both v2.9.10 and pinned development tp.c check all configured spindles' at-speed flags while G33 $N and the index request select one spindle. The pinned upstream two-spindle HAL connects both spindle index-enable pins to encoder_0.index-enable, omitting encoder_1.index-enable, although spindle 1 revs come from encoder 1. Conditional wait and index-origin concerns are INFERENCE; actual HAL load/motion UNKNOWN. No test performed.

**Precise next:** inspect upstream history/issues for whether the all-spindles readiness gate is intentional and whether the example was corrected. If no source gain, trace G33.1 rigid-tap reversal or homing/index state machine. Avoid another generic HAL-order recap.

**Governance:** START_HERE, mission, level/work selection, curriculum, source/template, blind protocol/score, compute ledger and previous DPLL checkpoint reviewed. 1000/2000/F02/3000 CLOSED, active 4000 NON-GRADUATED. Independent evaluator OPEN, OpenPressBrake G0/G1 HOLD; safety-course evidence unchanged. No workflow, build, simulation, physical operation, new authoritative runtime or evaluator; GitHub-hosted/self-hosted Actions 0/0 minutes, ledgers unchanged. Only justified, independently isolated [self-hosted, openpressbrake] compute; never hosted Actions. Hourly task stays enabled. Actual session end and overlap in LESSON_LOG.md.
