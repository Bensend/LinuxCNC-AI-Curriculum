# Next checkpoint — MOTION-189 — 2026-11-03 14:36 UTC

Start START_HERE.md and governance, evaluation, compute and current repository state. Read [MOTION-189](../research/4400_LINUXCNC_MOTION_189_G1_CANONICAL_QUEUE_TO_CUBIC_SOURCE_TRACE_2026-11-03.md) and MOTION-188.

**Highest-value next work:** inspect pinned v2.9.10 `emccanon.cc` `see_segment`, `flush_segments` and all flush triggers. Determine exact conditions when consecutive G1 lines are coalesced and where G61/G64 changes force a flush. Inspect `tests/interp/g6164` actual fixtures/expected output and the complete `configs/sim/axis/axis.ini` referenced HAL files. Freeze a minimal command-level oracle that distinguishes canonical emitted messages, planner segments and cubic joint output; do not infer physical position from stepgen feedback. Compare to CYCLE-174 and predecessor MOTION-144 before any proposed executable lab. If source exhausted rotate to Mesa mill/plasma config or DXF→G-code implementation.

**Constraints:** no compute without independently verified isolated `[self-hosted, openpressbrake]` runner; never hosted Actions. Keep 1000–3000 graduated, blind evaluation sealed and personnel-safety independent. Update PROGRESS/LESSON_LOG and commit. Hourly stays enabled.
